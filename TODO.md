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
- **More unit tests** for SUBs that draw nothing: `normal`, `retreat`, `evaluate`, `stax`, `commander`,
  `gloat`.

## The game

- **Separate the rules from the drawing** in the large SUBs (`battle`, `navy`, `airforce`, `tupdate`,
  `smarts`), one at a time. Run `play.py check` after each.
- **The Editor.** `RUN "edit.exe"` on the main menu still starts the DOS editor. `EDIT.BAS` is not ported.
- **Sound.** The `SHELL` calls to `playmidi`, `plany.exe` and `sound` do nothing on Windows today.
- **The title and burning-city screens.** `ww2title.exe` and `ww2city.exe` are DOS programs with no
  source, so their `SHELL` lines are comments. The screens are missing.
- **The mouse cursor's limits.** `MouseBorder` no longer confines the real cursor. Only the position the
  game reads is held inside the limits.
