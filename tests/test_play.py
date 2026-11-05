"""Tests of play.py's parts that need no build:  python -m unittest discover -s tests -p "test_*.py" """

import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import play  # noqa: E402

STATE = b"screen-state 1\npages 1 display 0 write 0 read 0\np 00*640\nend\n"


class EntriesTest(unittest.TestCase):
    def test_states_digests_and_stopped(self):
        data = b"digest 0123456789ABCDEF\n" + STATE + b"stopped k line 3: no prompt in time\n"
        self.assertEqual(
            play.entries(data),
            [b"digest 0123456789ABCDEF", STATE, b"stopped k line 3: no prompt in time"],
        )

    def test_a_state_cut_short_is_kept(self):
        self.assertEqual(play.entries(b"screen-state 1\np 00\n"), [b"screen-state 1\np 00\n"])

    def test_empty(self):
        self.assertEqual(play.entries(b""), [])


class DigestTest(unittest.TestCase):
    def test_fnv1a64_known_values(self):
        self.assertEqual(play.fnv1a64(b""), 0xCBF29CE484222325)
        self.assertEqual(play.fnv1a64(b"a"), 0xAF63DC4C8601EC8C)

    def test_a_digest_matches_its_state(self):
        digest = play.as_digest(STATE)
        self.assertTrue(play.same(digest, STATE))
        self.assertTrue(play.same(STATE, digest))
        self.assertFalse(play.same(b"digest 0000000000000000", STATE))

    def test_first_difference(self):
        a = [b"digest 1", STATE]
        self.assertIsNone(play.first_difference(a, [b"digest 1", play.as_digest(STATE)]))
        self.assertEqual(play.first_difference(a, [b"digest 2", STATE]), 0)
        self.assertEqual(play.first_difference(a, a[:1]), 1)


class CheckpointsTest(unittest.TestCase):
    def test_repeat_blocks_are_unrolled(self):
        keys = "\n".join([
            "digest",          # 1
            "repeat 2",        # 2
            "play until 2:M",  # 3
            "state  # here",   # 4
            "repeat 2",        # 5
            "digest",          # 6
            "end",             # 7
            "end",             # 8
            "state",           # 9
            "repeat space",    # 10
        ])
        self.assertEqual(play.checkpoints(keys), [1, 4, 6, 6, 4, 6, 6, 9])

    def test_describe(self):
        keys = Path("k.keys")
        self.assertIn("line 9", play.describe(1, [1, 9], keys))
        self.assertIn("the state at exit", play.describe(2, [1, 9], keys))


class ScriptTest(unittest.TestCase):
    def load(self, text):
        with tempfile.TemporaryDirectory() as d:
            path = Path(d) / "s.keys"
            path.write_text(text)
            return play.load_script(path)

    def test_setup_lines(self):
        s = self.load("#! seed 42\n#! cfg player=2 difficult=1\n#! timeout 60\n# a comment\nkey space\n")
        self.assertEqual(s.seed, "42")
        self.assertEqual(s.timeout, 60)
        self.assertEqual(s.cfg["player"], "2")
        self.assertEqual(s.cfg["difficult"], "1")
        self.assertEqual(s.cfg["side"], "1")

    def test_unknown_field(self):
        with self.assertRaises(play.SetupError):
            self.load("#! cfg colour=3\n")

    def test_unknown_setup_line(self):
        with self.assertRaises(play.SetupError):
            self.load("#! speed 3\n")

    def test_cfg_line_in_filer_order(self):
        with tempfile.TemporaryDirectory() as d:
            play.write_cfg(Path(d), dict(play.CFG_FIELDS))
            self.assertEqual((Path(d) / "WW2.CFG").read_text(), '1,0,3,1,2,0,0,0,0,1,0,1,"",0\n')


class MakeScriptsTest(unittest.TestCase):
    def test_body_folds_runs_into_repeat_blocks(self):
        import make_scripts
        lines = make_scripts.body(["key enter", "key enter", "text e", "key enter"])
        self.assertEqual(lines[1:], [
            "repeat 2", "play until 2:M", "digest", "key enter", "end",
            "play until 2:M", "digest", "text e",
            "play until 2:M", "digest", "key enter",
        ])
        self.assertEqual(play.checkpoints("\n".join(lines)), [4, 4, 8, 11])

    def test_two_players_name_two_commanders(self):
        import make_scripts
        self.assertEqual(make_scripts.ending(2).count("key enter"), 2)
        self.assertEqual(make_scripts.ending(1).count("key enter"), 1)


if __name__ == "__main__":
    unittest.main()
