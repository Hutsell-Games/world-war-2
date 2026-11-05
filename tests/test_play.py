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

    def test_program_and_files(self):
        s = self.load("#! program edit\n#! files WW1939.INI EURO1939.DAT\n#! files ww1939.bak\n")
        self.assertEqual(s.program, "edit")
        self.assertEqual(s.files, ["WW1939.INI", "EURO1939.DAT", "ww1939.bak"])
        self.assertEqual(self.load("key space\n").program, "ww2")

    def test_unknown_program(self):
        with self.assertRaises(play.SetupError):
            self.load("#! program demo\n")

    def test_file_entries(self):
        with tempfile.TemporaryDirectory() as d:
            (Path(d) / "ww1939.bak").write_bytes(b"a\r\nb\r\n")
            (Path(d) / "lf.txt").write_bytes(b"a\nb\n")
            lines = play.file_entries(Path(d), ["WW1939.BAK", "lf.txt", "none.dat"]).decode().splitlines()
            # CRLF and LF give the same hash; the name matches whatever its case.
            self.assertEqual(lines[0].split()[:2], ["file", "WW1939.BAK"])
            self.assertEqual(lines[0].split()[2], lines[1].split()[2])
            self.assertEqual(lines[2], "file none.dat missing")
            # Each line is an entry of its own, after the states.
            self.assertEqual(play.entries(STATE + "\n".join(lines).encode() + b"\n")[1:],
                             [line.encode() for line in lines])

    def test_files_only_after_a_run_that_ended_well(self):
        with tempfile.TemporaryDirectory() as d:
            (Path(d) / "a.dat").write_bytes(b"a\n")
            script = self.load("#! files a.dat\n")
            ok = play.with_files(play.Run(script, "c", "", 0, STATE, Path(d)), Path(d))
            self.assertTrue(play.entries(ok.state)[-1].startswith(b"file a.dat "))
            # A stopped run keeps "stopped" as its last entry, so the reason for the failure shows.
            stopped = STATE + b"stopped k line 3: no prompt in time\n"
            bad = play.with_files(play.Run(script, "c", "", 125, stopped, Path(d)), Path(d))
            self.assertEqual(bad.state, stopped)
            self.assertIn("no prompt in time", play.run_problem(bad))

    def test_cfg_line_in_filer_order(self):
        with tempfile.TemporaryDirectory() as d:
            play.write_cfg(Path(d), dict(play.CFG_FIELDS))
            self.assertEqual((Path(d) / "WW2.CFG").read_text(), '1,0,3,1,2,0,0,0,0,1,0,1,"",0\n')


class CoverageTest(unittest.TestCase):
    UNIT = (
        "coverage 2\n"
        "file\t0\taaaa\trules_test.bas.test-entry.bas\n"
        "file\t1\tbbbb\trules_test.bas\n"
        "file\t2\tcccc\t../ww2b.bm\n"
        "0\t3\t1\t1\t\n"
        "1\t9\t1\t1\t\n"
        "2\t10\t1\t1\tLEN\n"
        "2\t11\t1\t0\t\n"
        "end\n"
    )

    def test_rebase_keeps_only_the_games_files(self):
        self.assertEqual(
            play.rebase_records(self.UNIT * 2),
            ("coverage 2\nfile\t2\tcccc\tww2b.bm\n2\t10\t1\t1\tLEN\n2\t11\t1\t0\t\nend\n") * 2,
        )

    def test_reached_only_by_the_unit_tests(self):
        with tempfile.TemporaryDirectory() as d:
            unit, script = Path(d) / "unit.txt", Path(d) / "script.txt"
            unit.write_text(play.rebase_records(self.UNIT), encoding="latin-1")
            # The script ran line 11, which the unit tests did not, and not line 10, which they did.
            script.write_text(
                "coverage 2\nfile\t5\tcccc\tww2b.bm\n5\t10\t1\t0\t\n5\t11\t1\t4\t\nend\n", encoding="latin-1"
            )
            self.assertEqual(play.reached_only_by(unit, [script]), 1)
            self.assertEqual(play.statement_counts([unit, script])[("ww2b.bm", 11, 1)], 4)

    def test_sub_table_names_the_main_module_of_the_program(self):
        with tempfile.TemporaryDirectory() as d:
            counts = Path(d) / "edit.txt"
            counts.write_text("coverage 2\nfile\t1\tcccc\tEDIT.BAS\n1\t50\t1\t2\t\nend\n", encoding="latin-1")
            # Line 50 of EDIT.BAS is in its main module, before its first SUB.
            self.assertIn("(main module)", play.sub_table([counts], "edit.bas"))


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
