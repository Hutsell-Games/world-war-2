# To do

Open work on the QB64 port (branch `qb64rust`). Remove an item when it is done.

## The tests

- **Run `tests/play.py` on Linux.** The script already has Linux branches (no console helper, a plain
  kill), but they have never run. Two things stand in the way:
  - File names differ in case. The game opens `ww2.cfg`, `euro1939.dat`, `wwii1.sav` and so on, and the
    files are `WW2.CFG`, `EURO1939.DAT`, `WWII1.SAV`. The includes name `'ww2.bi'` and `'ww2a.bm'`, and the
    files are `WW2.BI` and `WW2A.BM`. `DIR$("euro*.dat")` needs a match that ignores case. First find out
    whether QB64Rust and QB64pe fold case on Linux. If they do not, rename the files to lower case, with
    `git mv`.
  - `write_cfg` in `play.py` writes `WW2.CFG` and relies on Windows opening it as `ww2.cfg`.

  Then run `play.py check` on Linux under Xvfb, as QB64Rust's own Linux steps do, and compare the screens
  with the recordings made on Windows.
- **A script that uses the mouse.** Every script plays with `mighty=0`. As a result `MouseDriver` (the
  rewritten part of `MICKEY.BM`), `Mickey` and the mouse half of `menu` never run. Write one script with
  `#! cfg mighty=1` that clicks through the title menu, a main menu and a "press a key or mouse button"
  pause. The keys file already has `mouse`, `press` and `release` steps.
- **Paratroop.** After its first wait, no further wait is announced. Find the wait that is missing an
  `announce`, then add a script.
- **Play by mail.** Begin PBM and the PBM news have no script.
- **`twoplayer-1944`.** It is not written: in October 1948, Enter at a Recruit menu brings the same menu
  back for ever (`tests/README.md`, "Generated scripts"). Decide whether that is a bug of the game.

## The game

- **`normal` draws high.** It sums 12 RNDs and subtracts 5.5, but the sum averages 6. So every draw
  centers on `xbar + SQR(vary) / 2`, not on `xbar` (`TestNormalStaysInRange` in `tests/rules_test.bas`).
  Decide whether that is a bug of the game. Fixing it changes the games, so the scripts would need
  `record` again.
- **Separate the rules from the drawing** in the large SUBs (`battle`, `navy`, `airforce`, `tupdate`,
  `smarts`), one at a time. Run `play.py check` after each.
- **The game's `menu` and `yesno` may stop with "RETURN without GOSUB".** The editor did, and its
  `menu` and `yessir` are the same code (`devnotes/devnotes.md`, item 11). In the game, answering a
  `yesno` prompt (the main menu's Editor, and Files then Quit) with `y`, `n` or Esc likely stops the program. So may
  any other `GOSUB` routine that calls `menu`. Not run yet. Check it with a script, then make the same
  change to `menu` in `WW2C.BM`.
- **Test the editor.** It has no script and no unit test. Its menus read keys with no `announce`, so a
  script needs the hooks of `SCRIPT.BM` first: include `script.bm` in `EDIT.BAS`, and call `announce`
  in its `menu` and `TICK`. Then write a script that loads, edits and saves a scenario, and checks the
  saved files.
- **The title and burning-city screens.** `ww2title.exe` and `ww2city.exe` are DOS programs with no
  source, so their `SHELL` lines are comments. The screens are missing.
- **The mouse cursor's limits.** `MouseBorder` no longer confines the real cursor. Only the position the
  game reads is held inside the limits.
