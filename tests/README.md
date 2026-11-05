# Tests

Two kinds of test live here:

- **Unit tests** (`rules_test.bas`) call the SUBs that draw nothing and check what they return. Run them with
  `qb64rust test tests`.
- **Whole-game scripts** (`scripts\*.keys`) play the game from the title menu to the end, with a fixed random
  seed, and compare its screens with the screens recorded earlier. They are what makes a refactoring safe: a
  change that alters any screen of any script fails.

The scripts use QB64Rust's screen-state check. That is a C++ file linked into the game that gives it keys from
a file and writes the screen out at the points the file asks for. Its manual is QB64Rust's
`tools\screen\README.md`, which this file does not repeat.

## Running them

From the repo's folder, with QB64Rust's repo beside it (`..\QB64Rust`, built in release) and QB64pe beside
that (`..\QB64pe\qb64pe.exe`):

```
python tests\play.py check                  # every script with the QB64Rust build, against the recorded screens
python tests\play.py check enter-1940-axis  # one script
python tests\play.py compare                # the QB64pe and QB64Rust builds against each other
python tests\play.py record [script ...]    # both builds, twice each; writes scripts\<name>.screen
python tests\play.py coverage               # the lines and the SUBs of the game the scripts and unit tests reach
python tests\play.py explore <keys file>    # one run, a PNG of every screen; for writing a script
python tests\make_scripts.py                # writes the generated scripts again (below)
python -m unittest discover -s tests -p "test_*.py"   # the tests of play.py and make_scripts.py
```

`--jobs N` (before the command) sets how many games run at once (default 4). `WW2_SHOW_WINDOWS=1` shows the
game's window; otherwise it runs on a desktop of its own that is never shown, and your keys and mouse cannot
reach it. Everything a run makes goes into `tests\out\`, which git ignores. A build is made again only when a
source file, the compiler or the screen hook changed. What a command prints also goes to
`tests\out\last-<command>.txt`.

A whole `check` of the 39 scripts takes about 35 seconds with `--jobs 6`. `record` of all of them takes a few
minutes, because each script runs five times.

### When a check fails

`check` names the first checkpoint that differs and the line of the keys file that took it:

```
FAIL  endturn-1942-allied [rust]: differs at checkpoint 3, tests/scripts/endturn-1942-allied.keys line 28
    recorded: digest 8E575CF04FCA4E58
    now:      digest 52B151F891A7FB5A
    the screen now:      tests/out/fail/endturn-1942-allied-now-3.png
    the screen recorded: tests/out/fail/endturn-1942-allied-recorded-3.png
```

A checkpoint is usually a digest, a hash of the screen. To show the screen, `check` plays the script again with
full screens and writes a PNG of the one that differs. The recorded screen gets a PNG too when `record` ran on
this machine: it keeps a copy with full screens in `tests\out\recorded\`.

A difference is either a mistake in the change or a change of behavior that was meant. If it was meant, record
the script again (`record <name>`) and say so in the commit message.

## How the game takes part

The game has four hooks for the scripts, all in `SCRIPT.BM`. They do nothing unless the game is started with
the environment variable `WW2_SEED` set, as `play.py` does:

1. **A fixed seed.** `RANDOMIZE` takes `WW2_SEED` instead of `TIMER`, so every run of a script is the same game.
2. **Announced waits.** Before each wait for a key, the game says what kind of wait it is (`announce place,
   letter$`). The keys file then gives each key only when the game waits for it, and can answer waits by rules.
3. **No timed pauses.** `TICK` with a time above 0 (a pause that a key may cut short) returns at once. A game
   then takes seconds, not hours, and nothing depends on how fast the machine is. A message shown during
   such a pause is drawn and gone before the next checkpoint, so no script sees it.
4. **A fixed date.** A saved game holds the date 01-01-2000 instead of today's, so that the Saved Games menu
   looks the same on every day.

The places a script can name (`play until <place>[:<letter>]`, `rule <place>[:<letter>] <keys>`):

| Place | Wait | Where |
|---|---|---|
| 1 | A pause that any key ends ("press a key", `TICK` of 0 or less) | `TICK`, `WW2B.BM` |
| 2 | A menu. The letter is the first letter of the menu's title | `menu`, `WW2C.BM` |
| 3 | A key or a mouse button | `Mickey`, `MICKEY.BM` |
| 4 | A line of text: the commander's name for the Hall of Fame (an `INPUT`); in the editor, the scenario's description | `maxx`, `WW2B.BM`; `Enput`, `EDIT.BAS` |
| 5 | The news of a play-by-mail game | `WW2.BAS` |
| 6 | The boss screen (Ctrl+B), which only Ctrl+B ends | `menu`, `WW2C.BM` and `EDIT.BAS` |
| 7 | In the editor, a number to change: Up, Down, PgUp and PgDn change it, Enter or Esc ends | `plusminus`, `EDIT.BAS` |

The editor (`EDIT.BAS`) has the same hooks as the game, except the seed: it never called `RANDOMIZE`. Its
places are 2, 4, 6 and 7. It has no place 1, since its `TICK` only pauses and never waits for a key.

Menu letters seen so far:

| Letter | Menus |
|---|---|
| `2:W` | the title menu ("WW2-Europe STRATEGY") |
| `2:M` | the main menu |
| `2:S` | Start Year, Supply, Saved Games, SOUNDS, Speed |
| `2:E` | End Turn, End Game |
| `2:R` | Retreat, Recruit |
| `2:C` | COMMANDS, Cancel, Clr Score |
| `2:U` | Utility |
| `2:T` | Tech, To (where a move or the navy goes) |
| `2:P` | Planes (the air force) |
| `2:A` | AirBase |
| `2:B` | Balance |
| `2:F` | From, Fortify, Flip Stack |
| `2:O` | Options (Files) |
| `2:Q` | Quit: the Yes or No of Editor and of Files, Quit |

The editor's menus: `2:S` Starting Year and Save As, `2:M` its main menu, `2:A` Allied Tech (`2:A` also Axis
Tech), `2:C` City, `2:N` Navy, `2:B` Begin Month, `2:L` Leave Edit.

The navy's menu is titled with its number of ships (`2:5` for " 5 Ships"); `play until 2` stops at any menu.
A rule for a letter answers every menu with that letter. A script that must tell them apart uses `prompt` and
plain keys.

A menu takes Up, Down, PgUp, PgDn and Enter, and the first letter of an entry, which chooses it at once. PgDn
goes to the last entry. A letter that matches no entry, or matches only a "-" entry, is ignored, and the menu
announces its wait again. After a command, the COMMANDS menu and the main menu highlight the last entry used,
not the first.

## The scripts

Each script is a keys file with lines that set up its run, which `play.py` reads:

```
#! seed 1940             the random seed (default 1)
#! cfg side=2 player=1   fields of the ww2.cfg the game starts with
#! timeout 300           the longest the run may take, in seconds
#! program edit          the program the script plays: ww2 (the default) or edit (EDIT.BAS)
#! files scenarios/WW1939.INI    files to check after the run, by their hashes
```

Each file a `#! files` line names becomes a last checkpoint, `file <name> <hash>`, or `file <name> missing`.
The hash takes CRLF line ends as LF. A name may start with a folder, written with `/`. Each part of the
name matches whatever its case.

`edit-1939` passes on Windows only. Its two `.bak` files are made by the editor's `SHELL "copy"`, a Windows
command, so on another system they would be recorded as `missing`.

The `ww2.cfg` of a run is written fresh. By default it is one player on the Allied side, difficulty 3, no
sound, keyboard only (`mighty=0`) and no autosave. The fields are `CFG_FIELDS` in `play.py`. Each run starts
in a fresh copy of the game's data files in `tests\out\run\`, so the high scores and saved games of the repo
are never changed.

A script ends the game the way a player does: Quit at the title menu, then `repeat space` for END's "Press any
key to continue". A run that ends any other way (a `prompt` that times out, no rule for a wait, a crash)
fails, and the last line of its state file says why.

### Generated scripts

`make_scripts.py` writes 34 scripts: each of the seven scenarios (1939 to 1945), as each side, in two styles,
and each scenario but 1944 with two players.

| Script | How the player plays |
|---|---|
| `endturn-<year>-<side>` | END TURN at once every month. Only the computer's side acts, so this covers its play (`smarts`, battles, the monthly update) |
| `enter-<year>-<side>` | Enter at every menu. Each main menu highlights the next command of the turn (Recruit, Navy, Moves, Air Force, Tech, END TURN), and each menu after it takes its first choice. Where Enter changes nothing, such as Moves in floods, that main menu gets END TURN instead |
| `twoplayer-<year>` | As `enter`, with two players: the Allied side's turn, then the Axis side's, each month. Both name a commander at the end |

Each takes a digest at every main menu, and two at the Hall of Fame. How many main menus a game has, and where
Enter is stuck, depends on the game. So `make_scripts.py` first plays each game with probes, then writes what
they found. Run it again only when a change is meant to change how the games go, then `record`. It takes about
15 minutes, because a probe that finds a stuck main menu plays the game again from the start.

`twoplayer-1944` is not written: in October 1948 Enter at a Recruit menu brings the same menu back for ever, and
the probes only get unstuck at the main menu. `make_scripts.py` reports it and goes on.

### Scripts written by hand

| Script | What it plays |
|---|---|
| `commands-1939-allied` | Every report of Inform; F1 (help), F3, F4 to F6, F9 and F10 at the main menu; the menus of COMMANDS, UTILITY and Files; a game saved and loaded again |
| `utility-1939-allied` | The settings of UTILITY: players, sound, display speed, weather, autosave, end conditions, high scores, Vary Start, balance, side |
| `orders-1939-axis` | The orders of a turn with choices other than the first: moves and Cancel; COMMANDS Fortify, Join, Detach, Supply, Rotate, Army Drill and Static; the navy sailed; the air force against a navy and to a new base; Tech with and without the money |
| `menus-gosub-1939-allied` | Menus answered by a letter or Esc inside a `GOSUB` routine, which once stopped the game with "RETURN without GOSUB" (`docs/devnotes.md`, item 12): Start Year, Editor then No, Files Quit then Esc, Saved Games. It also plays the other exits that item 12 rewrote: Esc at Start Year, Esc at Saved Games after Load and after Save, and F7. It then quits with Files, Quit, Yes |
| `edit-1939` | The editor: Esc at Starting Year; loads 1939; changes Technology, Cash, a fort, the navy and the side; saves as 1939, loads again, quits. It checks the saved scenario and map and the two `.bak` files |

The first three then end every turn to the end of the game.

### Writing a script by hand

Start from a few lines and let `explore` show where they lead:

```
python tests\play.py explore my.keys
```

It plays the keys, then writes a state at the next wait and stops there. Each screen of the run becomes a PNG in
`tests\out\explore\`. Add a few lines, look, repeat. To see what a step does, step through the waits after it
with `prompt`, `state` and `key space` (a space is harmless at a menu, which only waits again). When the script
ends the game, put it in `scripts\`, run `record <name>`, and check that `record` says the four runs were the
same.

Points that matter:

- **Look at every screen before recording.** A step that lands on another wait than the one meant (a pause
  before a menu, a "-" entry, a menu that highlights another entry) puts the following keys out of step. The
  game often still reaches the end, so exit code 0 proves little. `orders-1939-axis` once ran to the end with
  its Fortify never done.
- **No digest while an `INPUT` waits.** Its cursor blinks by the clock, so the screen differs from run to run.
  Take the digest at the next wait instead.
- **`prompt` before every key** that a plain step gives. A key given without one may arrive while the game is
  not reading keys.
- **Choose menu entries by letter where you can.** Several commands show a pause before their menu, and an
  arrow key given at the pause is lost. `play until <place>:<letter>` waits for the menu itself.
- `play until` answers the waits it passes by rules. A wait with no rule stops the run with "no rule for the
  wait at place N"; `explore` shows the screen there.
- Prefer `digest` to `state`. A full state of the map is about 130 KB; a digest is one line.

## What the scripts do not cover

`play.py coverage` writes the lines that no script and no unit test reaches (`tests\out\coverage\report.txt`)
and a table per SUB, the least covered first (`tests\out\coverage\subs.txt`). With no script named, it also
runs the unit tests with `qb64rust test tests --coverage` and says how many statements they reach that no
script does. With scripts named, it counts only those scripts; `--unit-tests` adds the unit tests. With the
38 scripts of the game and the unit tests, 81% of the game's lines with a statement run (2026-11-05: 3,931 of
4,839 lines run in full or in part). The editor's report is `report-edit.txt`: `edit-1939` runs 58% of its
lines with a statement (786 of 1,360). Of the SUBs that the refactoring is about, `smarts` runs 93% of its
statements, `battle` 91%, `tupdate` 85%, `airforce` 82% and `navy` 79%.

Not covered:

- **The mouse.** Scripts play with the keyboard (`mighty=0`), so the mouse half of `menu` never runs. The keys
  file has mouse steps, but no script uses them yet.
- **Paratroop.** After its first wait no further wait is announced; not looked into yet.
- **Play by mail** (Begin PBM, the PBM news) and PBM Drv, whose menu shows the drive the game runs from.
- **Sound and the DOS programs.** They are not ported (`TODO.md`).
- **Most of the editor** (`EDIT.BAS`). `edit-1939` covers Technology, Cash, Fortify, Navy Edit, Side, Save,
  Load and Quit, but not Army, Navy Move, Air Force, Cities or Capital, and no unit test calls its SUBs
  (`TODO.md`). `coverage` reports the editor apart: `tests\out\coverage\report-edit.txt` and `subs-edit.txt`.
- **The boss screen.** It ends only with Ctrl+B, which a keys file cannot give.
- **Timed pauses as a player sees them.** Under a script they return at once.
