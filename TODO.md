# To do

Open work on the QB64 port (branch `qb64rust`). Remove an item when it is done.

## The tests

- **The real `SHELL "copy ..."`.** Under a script, `scriptshell` (`SCRIPT.BM`) copies in BASIC, because a
  `SHELL` opens a console window on the user's desktop (`docs/devnotes.md`, item 13). So no test runs the
  editor's or the PBM update's `SHELL`. A test of them must run where a window does no harm: in QB64Rust's
  suites VM, or by hand.

- **Run `tests/play.py` on Linux.** The script already has Linux branches (no console helper, a plain
  kill), but they have never run. Two things stand in the way:
  - File names differ in case. The game opens `ww2.cfg`, `euro1939.dat`, `wwii1.sav` and so on, and the
    files are `WW2.CFG`, `EURO1939.DAT`, `WWII1.SAV`. The includes name `'ww2.bi'` and `'ww2a.bm'`, and the
    files are `WW2.BI` and `WW2A.BM`. `DIR$("euro*.dat")` needs a match that ignores case. First find out
    whether QB64Rust and QB64pe fold case on Linux. If they do not, rename the files to lower case, with
    `git mv`.
  - `write_cfg` in `play.py` writes `WW2.CFG` and relies on Windows opening it as `ww2.cfg`.
  - The PBM drive is a DOS drive letter. The PBM Drive menu offers `LEFT$(CURDIR$, 2)`, `A:` and `B:`,
    and the shipped `WW2.CFG` holds `"C:"`. The PBM file is then `C:pbm`. On Linux, `CURDIR$` starts
    with `/`, so its first entry is `/h` or similar, and `C:pbm` is a file of that name. No script plays PBM.

  Then run `play.py check` on Linux under Xvfb, as QB64Rust's own Linux steps do, and compare the screens
  with the recordings made on Windows.
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
- **Six mouse exits of `menu` have no script.** `selex` (`WW2C.BM`) leaves by the mouse in seven places,
  which were rewritten to end by `RETURN` (`docs/devnotes.md`, item 12). `mouse-1939-allied` runs one: line
  1372, a click on a menu entry. These six do not run: 1188 (a key while an army is shown), 1209 (a click on
  the air force), 1218 (a click on the player's navy), 1262 and 1266 (a city clicked for a paratroop drop or a
  bombing), and 1362, which changes the side. Line 1362 runs for a click outside the menu's rows with `xc`
  591 to 609 (`Mickey` counts from 1), and only when `row1`, the row highlighted before the click, is -3. What sets `row1`
  to -3 is not yet known; find it first. Add their clicks to `mouse-1939-allied` or to a second mouse script.
- **A rare crash in `play.py check`.** Once, in a `check` of all the scripts with `--jobs 6`,
  `endturn-1943-allied` ended with exit code 3221225477 (0xC0000005, an access violation) in the QB64Rust
  build. Run alone three times, it passed each time. Find out whether it comes from the QB64Rust runtime.
- **The title and burning-city screens.** `ww2title.exe` and `ww2city.exe` were DOS programs with no
  source, so their `SHELL` lines are comments and the screens are missing. Pictures of both, taken in
  DOSBox, are `docs/WW2TITLE.png` and `docs/WW2CITY.png`. They could be drawn again in BASIC.
- **The jump of the mouse cursor into a menu.** In DOS, `menu` called `MouseBorder` with the limits of
  its own part of the screen (the main menu's x 524 to 634, for example), and the driver pulled the cursor
  inside them. `Mickey` then set wider limits, so only that jump mattered. The port dropped the calls
  (`docs/devnotes.md`, item 5). `_MOUSEMOVE` could move the cursor the same way, when `Mighty > 0`. Decide
  whether it is worth it: a jump of the real cursor can surprise a player in a window.
