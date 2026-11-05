#!/usr/bin/env python3
"""Writes the generated scripts of tests/scripts (tests/README.md, "Generated scripts").

    python tests/make_scripts.py [--only <name> ...]

Each generated script plays one scenario as one side, from the title menu to the Hall of Fame and
Quit, with one way of answering the main menu:

    endturn-<year>-<side>   END TURN at once, every month: the computer's side plays alone
    enter-<year>-<side>     Enter at every menu: each main menu highlights the next command of the
                            turn (Recruit, Navy, Moves, ... END TURN), so the turn's commands run
                            with the choices each menu offers first. Where Enter changes nothing (a
                            main menu the same as the one before it, such as Moves in floods), that
                            main menu gets END TURN instead
    twoplayer-<year>        as enter, with two players: the Allied side, then the Axis side, each
                            month

A script takes a digest at each main menu. Which key each main menu gets, and how many there are,
depends on the game, so this tool plays each game first with probes and writes what they found.
Run it again only when a change of the game is meant to change how its games go; then record.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import play  # noqa: E402

YEARS = range(1939, 1946)
SIDES = {1: ("allied", "Allied", "Axis"), 2: ("axis", "Axis", "Allied")}
STYLES = {
    "endturn": {
        "main": "text e",
        "rules": ["rule 2:R key enter"],
        "about": "played by ending every turn at once; the computer plays",
    },
    "enter": {
        "main": "key enter",
        "rules": ["rule 2 key enter"],
        "about": "played by Enter at every menu (the command each menu highlights); the computer plays",
    },
    "twoplayer": {
        "main": "key enter",
        "rules": ["rule 2 key enter"],
        "about": "with two players, each played by Enter at every menu (the command each menu highlights)",
        "players": 2,
    },
}
END_TURN = "text e"
# Main menus a probe tries after those already decided; a game that goes on gets another probe.
PROBE_MENUS = 150
# How long a probe's last prompt waits for a wait that does not come.
PROBE_PROMPT_MS = "5000"
MAX_PROBES = 200


def header(style: str, year: int, side: int, menus: int | None) -> list[str]:
    tag, player, computer = SIDES[side]
    players = STYLES[style].get("players", 1)
    about = (f"{STYLES[style]['about']}." if players == 2 else
             f"as the {player} side, {STYLES[style]['about']} the {computer} side.")
    lines = [
        f"# The {year} scenario {about}",
        f"# A digest at each of the {menus} main menus and two at the Hall of Fame, then Quit."
        if menus else "# A probe: main menus until the game ends.",
        "# Written by tests/make_scripts.py.",
        f"#! seed {year}",
        f"#! cfg side={side}" + (f" player={players}" if players > 1 else ""),
        *([] if menus else ["#! timeout 120"]),
        "",
        "# Waits that any key ends; End Turn and End Game: Yes" +
        ("; a Retreat menu: its first city." if style == "endturn" else "; any other menu: Enter."),
        "rule 1 key space",
        *STYLES[style]["rules"],
        "rule 2:E text y",
        "",
        "# The title menu: Start NEW Game. Start Year: the scenario's entry.",
        "play until 2:W",
        "digest",
        "text s",
        "play until 2:S",
    ]
    for _ in range(year - 1939):
        lines += ["key down", "prompt"]
    return lines + ["digest", "key enter", ""]


def body(keys: list[str]) -> list[str]:
    """The main menus: a digest at each, then its key. A run of main menus with the same key is
    one `repeat` block."""
    lines = ["# Each main menu" + (" (END TURN where Enter changes nothing)." if END_TURN in keys and
                                   len(set(keys)) > 1 else ".")]
    i = 0
    while i < len(keys):
        j = i
        while j < len(keys) and keys[j] == keys[i]:
            j += 1
        step = ["play until 2:M", "digest", keys[i]]
        lines += step if j - i == 1 else [f"repeat {j - i}", *step, "end"]
        i = j
    return lines


def ending(players: int) -> list[str]:
    names = ["text Tester", "key enter"] if players == 1 else         ["text Allies", "key enter", "prompt", "text Axis", "key enter"]
    return ENDING_HEAD + names + ENDING_TAIL


ENDING_HEAD = [
    "",
    "# The game is over: the Hall of Fame asks for each player's commander. No digest while INPUT",
    "# waits: its cursor blinks by the clock. A digest at the pause after the names, and at the table",
    "# of new high scores.",
    "play until 4",
]
ENDING_TAIL = [
    "prompt",
    "digest",
    "key space",
    "prompt",
    "digest",
    "key space",
    "",
    "# Back at the title menu: Quit, and a key for END's \"Press any key to continue\".",
    "play until 2:W",
    "digest",
    "text q",
    "repeat space",
]


def probe_once(tools: play.Tools, exe: Path, name: str, lines: list[str]) -> tuple[list[bytes], bool, str]:
    """Runs a probe: the main menus' digests (without the title and Start Year menus), whether the game
    ended at the Hall of Fame, and the last line of the state file."""
    keys = play.OUT / "probe" / f"{name}.keys"
    keys.parent.mkdir(parents=True, exist_ok=True)
    # After the keys: a prompt for the next wait, and one that no wait answers, so that a game that
    # goes on stops 5 s after the keys are used up.
    keys.write_text("\n".join(lines + ["prompt", "prompt"]) + "\n")
    run = play.run_script(tools, exe, play.load_script(keys), "rust",
                          extra_env={"QB64_SCREEN_PROMPT_MS": PROBE_PROMPT_MS})
    found = play.entries(run.state)
    last = found[-1].decode(errors="replace") if found else f"exit code {run.rc}, no state"
    ended = run.rc == 125 and last.endswith("no rule for the wait at place 4")
    digests = [e for e in found if e.startswith(b"digest ")][2:]
    return digests, ended, last


def probe(tools: play.Tools, exe: Path, style: str, year: int, side: int) -> list[str] | str:
    """The keys of the game's main menus, or why the probes did not end it."""
    name = "probe-" + script_name(style, year, side)
    head = header(style, year, side, None)
    decided: list[str] = []
    for _ in range(MAX_PROBES):
        tried = decided + [STYLES[style]["main"]] * PROBE_MENUS
        digests, ended, last = probe_once(tools, exe, name, head + body(tried))
        if ended:
            return tried[: len(digests)]
        # The first main menu after those decided that is the same as the one before it: Enter
        # changed nothing there, so it gets END TURN.
        stuck = next((i for i in range(max(len(decided), 1), len(digests)) if digests[i] == digests[i - 1]), None)
        if stuck is not None and STYLES[style]["main"] == "key enter":
            decided = tried[:stuck] + [END_TURN]
        elif len(digests) > len(decided):
            decided = tried[: len(digests)]  # no progress lost: go on from there
        else:
            return f"stopped after {len(digests)} main menus: {last}"
    return f"no end after {MAX_PROBES} probes"


def script_name(style: str, year: int, side: int) -> str:
    if STYLES[style].get("players", 1) == 2:
        return f"{style}-{year}"
    return f"{style}-{year}-{SIDES[side][0]}"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--qb64rust-repo")
    parser.add_argument("--jobs", type=int, default=6)
    parser.add_argument("--only", nargs="*", help="names of the scripts to write (default: all)")
    args = parser.parse_args(argv)
    tools = play.find_tools(args)
    exe = play.build(tools, "rust")
    games = [(style, year, side) for style in STYLES for side in SIDES for year in YEARS
             if (side == 1 or STYLES[style].get("players", 1) == 1)
             and (not args.only or script_name(style, year, side) in args.only)]
    found = play.parallel(args.jobs, [lambda g=g: probe(tools, exe, *g) for g in games])
    failed = 0
    for (style, year, side), keys in zip(games, found):
        name = script_name(style, year, side)
        if isinstance(keys, str):
            failed += 1
            print(f"FAIL  {name}: {keys}")
            continue
        lines = header(style, year, side, len(keys)) + body(keys) + ending(STYLES[style].get("players", 1))
        (play.SCRIPTS / f"{name}.keys").write_text("\n".join(lines) + "\n")
        print(f"wrote {name}.keys: {len(keys)} main menus, END TURN at {keys.count(END_TURN)}")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
