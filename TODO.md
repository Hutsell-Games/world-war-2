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
- **The editor's Navy, Edit moves the navy.** It sets `navyloc(side) = target` after the `IF` that
  builds a new navy (`EDIT.BAS`, `CASE 3`). `target` is then whatever city the last command picked, so
  editing the size of an existing navy also moves it there. `edit-1939` shows it: after Fortify at
  Belgrade, Navy, Edit puts the Allied navy at Belgrade. Decide whether that is a bug of the editor. Fixing it
  changes `edit-1939`, which would need `record` again.
- **The editor's other commands.** `edit-1939` covers Technology, Cash, Fortify, Navy Edit, Side, Save,
  Load and Quit. Army (recruit, remove, rotate), Navy Move, Air Force, Cities and Capital have no script.
- **The mouse exits of `menu` have no script.** `selex` (`WW2C.BM`) leaves by the mouse in seven places:
  lines 1194, 1215, 1224, 1268, 1272, 1368 and 1378. They were rewritten to end by `RETURN`
  (`devnotes/devnotes.md`, item 12), but the scripts play with `mighty=0`, so none runs them. First find out
  whether a keys file can give a mouse click (QB64Rust's `tools\screen\README.md`). If it cannot, try a script
  with `cfg mighty=1` and keys only, which runs the `Mickey` branch of `selex` but not the seven exits.
- **A rare crash in `play.py check`.** Once, in a `check` of all the scripts with `--jobs 6`,
  `endturn-1943-allied` ended with exit code 3221225477 (0xC0000005, an access violation) in the QB64Rust
  build. Run alone three times, it passed each time. Find out whether it comes from the QB64Rust runtime.
- **The title and burning-city screens.** `ww2title.exe` and `ww2city.exe` are DOS programs with no
  source, so their `SHELL` lines are comments. The screens are missing.
- **The mouse cursor's limits.** `MouseBorder` no longer confines the real cursor. Only the position the
  game reads is held inside the limits.
