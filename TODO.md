# To do

Open work on the QB64 port (branch `qb64rust`). Remove an item when it is done.

## The tests

- **The real `SHELL "copy ..."`.** Under a script, `scriptshell` (`SCRIPT.BM`) copies in BASIC, because a
  `SHELL` opens a console window on the user's desktop (`docs/devnotes.md`, item 13). So no test runs the
  editor's or the PBM update's `SHELL`. A test of them must run where a window does no harm: in QB64Rust's
  suites VM, or by hand.
- **Run the Linux check again after changes.** `play.py check` passed all 49 scripts on Linux under Xvfb
  on 2026-11-07 (WSL, QB64Rust's Linux build), against the screens recorded on Windows
  (`docs/devnotes.md`, item 17). Nothing runs it on its own yet. It could be a job of
  `.github/workflows/build.yml`, or a step run by hand before a merge.

## The game

- **The editor's backups and the PBM `.old` copy on Linux.** Outside a script these run
  `SHELL "copy ..."`, a Windows command, so on Linux no `.bak` and no `.old` file is made. `scriptshell`
  could copy in BASIC on every system, not only under a script. That would also remove the console window
  on Windows, but no test would then run the real `SHELL` at all.
- **Separate the rules from the drawing** in the large SUBs (`battle`, `navy`, `airforce`, `tupdate`,
  `smarts`), one at a time. Run `play.py check` after each.
- **The title and burning-city screens.** `ww2title.exe` and `ww2city.exe` were DOS programs with no
  source, so their `SHELL` lines are comments and the screens are missing. Pictures of both, taken in
  DOSBox, are `docs/WW2TITLE.png` and `docs/WW2CITY.png`. They could be drawn again in BASIC.
- **The jump of the mouse cursor into a menu.** In DOS, `menu` called `MouseBorder` with the limits of
  its own part of the screen (the main menu's x 524 to 634, for example), and the driver pulled the cursor
  inside them. `Mickey` then set wider limits, so only that jump mattered. The port dropped the calls
  (`docs/devnotes.md`, item 5). `_MOUSEMOVE` could move the cursor the same way, when `Mighty > 0`. Decide
  whether it is worth it: a jump of the real cursor can surprise a player in a window.
