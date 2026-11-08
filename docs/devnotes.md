# Developer notes: branch `qb64rust`

This branch starts from `main`, the original BASIC PDS 7.1 source. It changes as little as possible so that the
game builds with QB64Rust and with QB64pe 4.7.0, and so that its SUBs can be unit tested.

## Build and test

```
qb64rust -x WW2.BAS -o ww2.exe
qb64rust -x EDIT.BAS -o edit.exe
qb64rust test tests
python tests\play.py check
```

The last line plays the whole-game scripts and compares their screens with the recorded ones
([tests/README.md](../tests/README.md)).

Put the executables in this folder before running them. The game looks for its data files in
`graphics\`, `sound\` and `scenarios\` under the folder it runs in (`FOLDERS.BI`).
Keep the names `ww2.exe` and `edit.exe`: the game's Editor entry runs `edit.exe`, and the editor's PLAY GAME
runs `ww2.exe`. The builds are not committed (`*.exe` in `.gitignore`). The original DOS programs `WW2.EXE`
and `EDIT.EXE` are removed from this branch, because the builds take their names; they are on `main`.

## Layout

| File | What |
|---|---|
| `WW2.BAS` | The main module only: start-up, the turn loop, the menus (1,001 lines). It includes the files below |
| `WW2.BI` | Every shared declaration: the original ones, then those that were in `WW2.BAS` and `WW2B.BAS` |
| `WW2A.BM` | The SUBs that were in `WW2.BAS` |
| `WW2B.BM`, `WW2C.BM` | The PDS modules `WW2B.BAS` and `WW2C.BAS` without their headers |
| `QB64.BM` | What the game needs from PDS 7.1 that QB64 does not have: `DIR$`, `CURDIR$`, the playing of the sound files, and `Mickey`, the wait for a key or a mouse button |
| `SCRIPT.BM` | The hooks for the whole-game scripts: the seed, and the announcement of each wait for a key |
| `EDIT.BAS` | The scenario editor, a program of its own (1,661 lines). It includes `EDIT.BI`, `QB64.BM` and `SCRIPT.BM` |
| `EDIT.BI` | The editor's declarations, as they came, and the include of `FOLDERS.BI` |
| `FOLDERS.BI` | The names of the three data folders, as `CONST`s. Included by `WW2.BI` and `EDIT.BI` |
| `ww2.cfg` | The settings the game starts with (`filer`, `WW2B.BM`). Every data file has a lower-case name, the name the code opens (item 17) |
| `graphics\` | Pictures (`.vga`), the F1 help screens (`help.sc1` for the game, `help.sc2` for the editor), the map drawings (`europe.grf`, `sub1.grf`, `sub2.grf`) and `europe.map`, which the code does not read |
| `sound\` | Sound effects (`.voc`) and tunes (`.mid`) |
| `docs\` | These notes and their screenshots (`WW2TITLE.png`, `WW2CITY.png`), and the game's original documents: the manual `WW2.DOC`, its text marked up with `@` headings (`WW2.TXT`) and `RELEASE_NOTES.TXT` |
| `scenarios\` | The scenarios (`euro1939.dat` to `euro1945.dat`, `ww1939.ini` to `ww1945.ini`), `ww2base.ini` and `special.evt`. The editor writes its saves and `.bak` backups here |
| `tests\rules_test.bas` | Unit tests, run by `qb64rust test` |
| `tests\play.py` | Plays the scripts and compares their screens (`check`, `compare`, `record`, `coverage`, `explore`) |
| `tests\make_scripts.py` | Writes the generated scripts, after probing each game |
| `tests\scripts\` | The scripts (`<name>.keys`) and their recorded screens (`<name>.screen`) |
| `tests\data\` | The saved games (`wwii1.sav` to `wwii5.sav`) and high scores (`hi1943.ww2`, `hi1944.ww2`) that came with the game. Every script's run starts with them. `pbm\` holds the play-by-mail files that the PBM scripts start from |
| `tests\test_play.py` | Tests of `play.py` itself |
| `tests\README.md` | How the tests work and how to write a script |
| `.github\workflows\build.yml` | Builds `ww2.exe` and `edit.exe` with QB64Rust on each merge into `main` or when started by hand, and uploads them with the data files as the artifact `world-war-2` |

## What was changed from `main`, and why

1. **One program instead of four linked modules.** QB64 builds one program. `WW2B.BAS` and `WW2C.BAS` were
   renamed to `.BM` and are included at the end of `WW2.BAS`. Their headers (`DEFINT`, `DECLARE`, the include
   of `ww2.bi`) were removed, because the main module already has them. The fourth module, `MICKEY.BAS`, is
   gone (item 5).
2. **The SUBs of `WW2.BAS` moved to `WW2A.BM`, unchanged.** A test file includes the `.BM` files and so gets every
   SUB without the main module's code.
3. **The `DIM SHARED` lines of `WW2.BAS` and `WW2B.BAS` moved to the end of `WW2.BI`**, with the includes of
   `general.bi`. A test file needs them too.
4. **`DIR$` is a FUNCTION in `QB64.BM`**, written with QB64's `_FILES$`. The 16 calls are unchanged, except
   `t$ = DIR$` in `filer` (`WW2B.BM`), which is now `t$ = DIR$("")`: a FUNCTION of QB64 cannot leave its argument
   out.

   `CURDIR$` is a FUNCTION in `QB64.BM` too, written with QB64's `_CWD$`. It gives the current folder without
   the separator `_CWD$` ends with, as PDS does (`C:\GAMES\WW2`). The two calls in `WW2.BAS` are unchanged:
   `pb$ = CURDIR$` at the start, and `LEFT$(CURDIR$, 2)`, the first entry of the PBM Drive menu. The first
   port missed it. QB64 has no `CURDIR$`, and both compilers build a bare `CURDIR$` as a string variable,
   with no message. It was always `""`, so the PBM Drive menu showed a blank first entry
   (`TestCurdirIsTheCurrentFolder` in `tests\rules_test.bas`).
5. **The mouse is `Mickey` in `QB64.BM`, written with QB64's mouse statements.** The original `MICKEY.BAS`
   held `Mickey` and Microsoft's `MOUSE.BAS` routines, which called the DOS mouse driver with `Interrupt 51`.
   `MOUSE.BI` declared them. The game calls only `Mickey` and `MouseBorder`, so the driver routines, `MOUSE.BI`
   and its unused `MousePresent` are gone. `Mickey` looks at every mouse event, so a click whose press and
   release both come between two passes of its loop is not lost. The version that read only the buttons' last
   state lost such clicks: `mouse-1939-allied` failed in 3 of 6 runs with it (2026-11-05). The loop also
   runs at most 100 times a second (`_LIMIT`), where the DOS version kept a core busy.

   The DOS `Mickey` limited the cursor to x 1 to 632 and y 1 to 444 before each wait. QB64 cannot confine
   the cursor, so the position `Mickey` returns is held inside those limits instead. `menu` (`WW2C.BM`) called
   `MouseBorder` with the limits of its own part of the screen. `Mickey` replaced them before reading, so
   their only effect in DOS was to pull the cursor into that part. That jump is not done, and the calls are
   gone (`TODO.md`).
6. *(Removed: it was about `MOUSE.BI`, which item 5 removes.)*
7. **The sound files play through QB64's own sound** (`playsound` in `QB64.BM`). The original played them
   with DOS programs: `plany.exe` or `sound.exe` for the `.VOC` effects (`sndblst`, `WW2B.BM`) and
   `playmidi` for the `.MID` tunes (`gloat`, `WW2C.BM`). Those `SHELL` calls now call `playsound`.
   - Like the `SHELL`, `playsound` returns when the sound ends. A key pressed meanwhile ends the sound and
     stays for the game to read, so a tune of 14 seconds can be cut short.
   - `playsound` gives 0 when it cannot play the file. `gloat` then plays its `PLAY` tune, as it does
     without `M`.
   - QB64 cannot open a `.VOC`, so `vocwav$` turns it into a WAV in memory. The game's VOCs are 8-bit
     mono at 5,882 to 15,625 Hz. `ENGINE.VOC` and `GUN.VOC` hold a repeat count of 3. It is read as 3
     more plays, 4 in all, but that reading is not checked against Creative's description of the format.
     If the count is the total, they play once less: the engine sound for 1.6 s, not 2.2 s.
   - `FRANCE.MID` and `WAGNER.MID` are damaged, as they came: `FRANCE.MID` declares 25 tracks but holds
     21, and the last track of `WAGNER.MID` is a piece of BASIC source. QB64 will not open either one.
     `midifile$` drops the broken tracks in memory. The files themselves are unchanged.
   - `sndblst` lost its error handler, `ON LOCAL ERROR GOTO nosound`, which QB64 does not have.
     `playsound` raises no error: a missing file is silent. The handler's "Sound Driver Error" message is gone.
   - The start-up code no longer reads the Sound Blaster's IRQ, DMA and port from `x.cfg`. Only
     `plany.exe` used them, and `x.cfg` is not in the game's files, so `ww2 S` stopped with "File not
     found". The variable that held them, `plany$`, is gone from `WW2.BI`.

   As in the original, the command line chooses the sound. With no option, the game beeps through
   `SOUND` and `PLAY`. `S` and `Z` play the `.VOC` effects, and `M` also plays the MIDI tunes. Effects
   also need a Sounds level of 1 or more, and tunes a level of 2. The level comes from `WW2.CFG`, which has
   2, and can be changed in the game's Sounds menu.
8. **`SHELL "ww2title.exe"` and `SHELL "ww2city.exe"` are comments** (`title2` and `burn` in `WW2B.BM`). Both are
   DOS programs with no source here, and 64-bit Windows cannot run them. The title screen and the burning-city
   screen are therefore missing. The two programs were removed from this branch (they are on `main`). Run in
   DOSBox on 2026-11-05, they showed [WW2TITLE.png](WW2TITLE.png) and [WW2CITY.png](WW2CITY.png). Each draws
   a GIF held inside the EXE, reads no other file, shows it for a few seconds and returns without a key.
9. **Hooks for the whole-game scripts** (`SCRIPT.BM`). `RANDOMIZE TIMER` is now `CALL scriptstart`. Each wait
   for a key calls `announce` first: `TICK`, the `menu` loop, `Mickey`, the Hall of Fame's `INPUT`, the PBM news
   and the boss screen. A `TICK` with a time above 0 returns at once when the game is scripted, and a saved
   game holds a fixed date (`scriptdate$` in `filer`, in place of `DATE$`). None of this
   does anything unless the environment variable `WW2_SEED` is set, so the game plays as before.
   The editor has the same hooks in its `menu`, its boss screen, `Enput` (the scenario's description),
   `plusminus` (a number to change) and `TICK`.

10. **The PDS build files are removed:** `WW2.MAK`, `WW2.LNK`, `WW2MAKE.BTM` and the `.OBJ` files of the four
    modules. So are the shareware main module `WW2-S.BAS` and its `WW2-S.MAK` and `WW2-S.LNK`, which no longer
    built once the modules became `.BM` files. So are the DOS programs `WW2.EXE` and `EDIT.EXE`, whose names
    the QB64 builds take. All of them are still on `main`.

11. **The scenario editor, `EDIT.BAS`, builds as its own program.** It was already one module, so it
    stays whole. Its PLAY GAME still runs `ww2.exe`, and the game's Editor entry (`WW2.BAS`) still runs
    `edit.exe`: the QB64 builds take the names of the DOS programs. It has these changes:
    - It includes `QB64.BM` at its end for `DIR$`. Its one bare `t$ = DIR$` (in `filer`) is `DIR$("")`.
    - Its `menu` SUB always leaves the routine `selex` by `RETURN`. The original left it by `GOTO called` or
      `GOTO boss` whenever an item was picked by its first letter, or with Esc, F7 or Ctrl+B. Now `selex`
      sets `leave` and returns, and the line after `GOSUB selex` makes the jump.

      Why: QB64pe and QB64Rust keep one `GOSUB` stack for the whole program. When a SUB ends with its own
      `GOSUB` still pending, that entry stays on the stack. The next `RETURN` outside the menu then takes it
      and stops the program with "RETURN without GOSUB". In the editor that `RETURN` ends `yessir`, so
      "Leave Edit" answered with `y` stopped the program. It also ends `getyr` in `filer`, so a letter at the
      Starting Year menu did the same. QB 4.5 and PDS 7.1 drop a SUB's pending `GOSUB` entries when the
      SUB ends, so the original worked.

    - Its `getyr` in `filer` ends by `RETURN` with `choose` below 0 where it ended the SUB, and the line
      after `GOSUB getyr` ends the SUB (item 12).
    - It has the hooks of `SCRIPT.BM` (item 9), so that a script can play it. It calls `scriptcheck`, not
      `scriptstart`: the original editor never called `RANDOMIZE`, and it still does not.

    The editor's `menu` is the same code as the game's (`WW2C.BM`), and the game's `yesno` (`WW2.BAS`) is
    the same as `yessir`. Item 12 makes the same change in the game.

12. **Every `GOSUB` routine of the game ends by `RETURN`.** Four routines left their SUB while their
    `GOSUB` was pending, for the reason given in item 11:
    - `selex` in `menu` (`WW2C.BM`), by `GOTO called` (9 places), `GOTO boss` (Ctrl+B) and `EXIT SUB`
      (2 places). Now it sets `leave` (1, 2 or 3) and returns, and the lines after `GOSUB selex` make the
      jump. This is the change made in the editor, with one more case for the two `EXIT SUB`s.
    - `getyr` and `getsave` in `filer` (`WW2B.BM`), by `EXIT SUB` when no year or saved game was chosen. Now
      they return with `choose` below 0, and the line after each `GOSUB` ends the SUB.
    - `norden` in `airforce` (`WW2C.BM`), by `EXIT SUB` when it finds no target in 9 tries. Now it sets
      `leave` to 3 and returns, and the line after each `GOSUB norden` ends the SUB.

    What stopped the game before: picking an entry by its letter, or leaving a menu with Esc, while a
    `GOSUB` routine waited on the menu. Then that routine's `RETURN` took the menu's entry and stopped the
    program with "RETURN without GOSUB". The script `menus-gosub-1939-allied` plays the cases:
    - a letter at Start Year (`getyr`);
    - Editor, then `n` (`yesno`);
    - Files, Quit, then Esc (`yesno`);
    - a letter at Saved Games (`getsave`).

    It also plays Esc at Start Year and at Saved Games, and F7 at a main menu. Those are the other new
    exits of `getyr`, `getsave` and `selex`.

    Before the change, the QB64Rust build never got past its first step: after `1` at Start Year, the
    main menu did not come, and the run timed out. The message itself was not seen, since the window is
    hidden. The other 37 scripts show the same screens as before. They do run `norden`'s give-up exit
    (`WW2C.BM`, line 435). That exit left a stale entry on the stack, but in those games no later `RETURN`
    took it.
13. **Under a script, `SHELL "copy ..."` is done in BASIC** (2026-11-06). The editor's Save copies the
    scenario files to `.bak` files, and the PBM update copies the PBM file to `.old`, each by `SHELL`. A
    `SHELL` starts a `cmd.exe`, whose console window shows on the user's desktop although the scripts run the
    program on a hidden one. So the three lines now call `scriptshell` (`SCRIPT.BM`), which runs the `SHELL`
    as before unless `WW2_SEED` is set, and then copies the file itself. Found in the Civil War Battleset
    port, whose battles each end in such a copy. `edit-1939` gives the same screens and the same `.bak`
    hashes as before, and a watch of new processes during it saw no `cmd.exe`. No script runs the real
    `SHELL` now (`TODO.md`).
14. **The editor's Navy, Edit no longer moves the navy** (2026-11-07, the user's ruling). `CASE 3` of
    `EDIT.BAS` set `navyloc(side) = target` after the `IF` that builds a new navy. For a navy that already
    existed, `target` was whatever city the last command had picked. So changing the size of a navy also
    moved it there. The line is gone. A new navy still goes to the city picked for it, inside the `IF`.
    `edit-1939` was recorded again: after Fortify at Belgrade, Navy, Edit now leaves the Allied navy at
    London. Its first 15 checkpoints are unchanged. Checkpoints 16 to 18, after the scenario is loaded again,
    and the hash of the saved `WW1939.INI` changed.
15. **Recruit says when all army slots are used** (2026-11-07, the user's ruling). Each side has 30 armies
    (`starfin`). When all 30 are in use and the player recruits at a city with no army, `commander` finds no
    free one. The original went back to the Recruit menu without a word, so the pick seemed to do nothing.
    The computer's side already left Recruit in that case. Now `recruit` (`WW2A.BM`) shows "All Allied army
    slots are used!" in yellow with a low tone and waits for a key, then shows the Recruit menu again as
    before. The message, color and tone are the author's own, from the editor's `recruit` (`EDIT.BAS`), which
    leaves Recruit after a 2-second pause. The game keeps the menu, since a city that has an army can still
    be reinforced. The wait is `keypause` (`WW2B.BM`). It is the pause of `TICK -2`, but it announces place 1 with the
    letter `N`, so that a script can answer it apart from the other pauses. Found by the two-player 1944
    game, whose Allies run out of commanders in August 1948. Enter at every menu chose the same city for
    ever, so `twoplayer-1944` could not be written (`tests/README.md`, "Generated scripts").
16. **Paratroop with no army that can go no longer stops the game** (2026-11-07). When no Elite army
    fits the paratroop capacity, `movefrom` (`WW2A.BM`) returns `index = -1`. `paratroop` then read
    `armyloc(index)` before it tested `index < 0`. PDS checks no array bounds, so the original read the word
    before the array and went on. QB64pe and QB64Rust stop with "Subscript out of range" (error 9). The
    two lines are now in the other order, so the game says "NO ELIGIBLE UNITS TO PARATROOP" as its author
    meant, and shows COMMANDS again. Found by `paratroop-1939-axis`: the Axis side has no Elite army in
    1939. Under a script the error's dialog waited on the hidden desktop until the run was killed, which
    looked like a missing announcement (`TODO.md` said "no further wait is announced"). `play.py` now sets
    `QB64PE_NOPROMPT=y`, so a runtime error ends the run at once.
17. **The game builds and plays on Linux** (2026-11-07). Three changes made it so:
    - **The data files have lower-case names** (`git mv`): `ww2.cfg`, everything in `graphics\`, `sound\`
      and `scenarios\`, and the saved games and high scores in `tests\data\`. The code opens them by
      lower-case names (`ww2.cfg`, `euro1939.dat`, `wwii1.sav`), and on Linux neither QB64Rust nor QB64pe
      folds case. Measured with both Linux builds: `OPEN "abc.txt"` fails with error 53 when the file is
      `ABC.TXT`, and `_FILES$("abc*.txt")` finds nothing. Menus that list files do not change, because
      `DIR$` (`QB64.BM`) returns names in upper case, as DOS did.
    - **The `$INCLUDE` lines name the source files as they are** (`'WW2.BI'`, `'WW2A.BM'`, and in
      `tests\rules_test.bas` `'../WW2A.BM'`). The sources keep their upper-case names.
    - **`scriptshell` turns a backslash into a slash** (`SCRIPT.BM`). The editor names its backups
      `scenarios\ww1939.bak` for cmd's `copy`. On Linux a backslash is part of a file's name, so under a
      script the copy found nothing.

    `play.py` now writes `ww2.cfg` in lower case. With these changes all 49 scripts passed on Linux under
    Xvfb (WSL, QB64Rust's Linux build), against the screens recorded on Windows. They also passed on
    Windows as before. Outside a script the editor's backups and the PBM `.old` copy still need cmd's
    `copy` (`TODO.md`). Items 19 and 20 fix the PBM drive menu and the Editor and PLAY GAME entries,
    which also assumed DOS.
18. **The editor's Save writes every army** (2026-11-07, the user's ruling). Save (`EDIT.BAS`) wrote slots
    1 to `narmy(1)` and 31 to `30 + narmy(2)`, as if each side's armies were packed at the front. Remove
    empties a slot and lowers the count, and the slot need not be the last. Then Save wrote the empty slot
    and left out the last army. The Allied loop also skipped armies with a location of 0 or below, but it
    had written the full count first. An Allied army placed with a 50% chance has a negative location, so
    it was left out, and every line after it was read one army off. Save now counts each side's armies
    with a location other than 0 and a size above 0, writes that count, then writes those armies in slot
    order. Both faults are in the original. A third one was in the editor's loader: it ran
    `armyloc(i) = ABS(armyloc(i))` on each Allied army, so a 50% chance was lost when the scenario was
    loaded and saved again. The loader now keeps the negative location, as it already did for the Axis
    armies. `edit-commands-1939` was recorded again. It now removes Berlin's Axis army (slot 32) and
    Paris's Infantry 5, keeps an Allied army with a 50% chance, saves, loads the scenario back and saves
    again. The saved `ww1939.ini` holds 6 Allied and 3 Axis armies, the army at Hannover among them. The
    second Save backs up the first one, and each `.bak` has the same hash as the file saved after it.
19. **The PBM drive off Windows is the game's folder** (2026-11-07, the user's ruling). The PBM Drive menu
    offered `LEFT$(CURDIR$, 2)`, `A:` and `B:`. On Linux the first entry was `/h` or similar, and the PBM
    file `/hpbm`. The shipped `ww2.cfg` holds `"C:"`, which made a file named `C:pbm` that Continue PBM
    Game, which looks for `pbm`, never found. Off Windows the menu now offers only `./`, the game's own
    folder (`pbmhere$`, `QB64.BM`), and a DOS drive read from `ww2.cfg` becomes `./` (`pbmdrive$`, called
    by `filer`, `WW2B.BM`). On Windows nothing changes. `TestPbmDriveOnThisSystem` in
    `tests\rules_test.bas` checks both functions on the system it runs on. No script shows the menu,
    since its first entry differs from machine to machine.
20. **The Editor and PLAY GAME entries run the builds by their names on each system** (2026-11-07). The
    game's Editor entry ran `RUN "edit.exe"`, and the editor's PLAY GAME ran `RUN "ww2.exe"`. On Linux
    the builds are `edit` and `ww2`, so neither name was found. Both entries now call `exename$`
    (`QB64.BM`): `edit.exe` on Windows, `./edit` elsewhere. Off Windows `RUN` hands the name to the shell
    (`system()` in libqb's `sub_run`), and the shell looks for a bare name on the PATH, not in the
    current folder. Measured in WSL with QB64Rust's Linux build: `RUN "child"` printed
    "sh: 1: child: not found" and ended, and `RUN "./child"` ran it. `onwindows%` there makes the choice for
    `exename$`, `pbmhere$`, `pbmdrive$` and the size of the PBM Drive menu. No script plays either entry:
    under a script `RUN` would end the program that the screen hook follows. `TestExeNameOnThisSystem` in
    `tests\rules_test.bas` checks `exename$`.

## Kept as the original had it

- **Battle losses are drawn high** (2026-11-07, the user's ruling: keep it as DOS players knew it). `normal`
  (`WW2B.BM`) sums 12 RNDs and subtracts 5.5, but the sum averages 6. So each draw centers on
  `xbar + SQR(vary) / 2`, not on `xbar`. `battle` (`WW2A.BM`) uses it for both sides' losses, so every
  battle costs both sides more than its `xbar` says. `TestNormalStaysInRange` in `tests\rules_test.bas`
  checks the range the game gets.

## Not done yet

See [TODO.md](../TODO.md).

## What has been checked

- QB64Rust 0.3.0 and QB64pe 4.7.0 both build `WW2.BAS`.
- Both builds were played with the same keys from the start menu to the first turn of the 1939 scenario. The
  screen was compared at four points and is identical, pixel for pixel, in both builds.
- `qb64rust test tests`: 20 tests pass. They cover `airdist`, `starfin`, `occupy`, `bubble`, `canimove` and
  `void`.
- The 49 scripts (`tests\scripts\`, two of them for the editor) play every scenario as each side to the
  end, with one or two players, and go through the menus, the mouse, Paratroop and a play-by-mail game
  (`tests\README.md`). Both builds show the same screens at every checkpoint, in two runs each
  (`play.py record`). On 2026-11-07 they ran 88% of the game's lines with a statement and 78% of the
  editor's (`play.py coverage`), and all 49 passed on Linux too (item 17).
- QB64Rust 0.3.0 and QB64pe 4.7.0 both build `EDIT.BAS`. Both builds were played with the same timed keys,
  in a copy of this folder. The keys load 1939 by a letter at the Starting Year menu and open Technology.
  They then save the scenario back as 1939 and quit with `y`. Both builds exit with 0, and their screens are
  identical at all 7 checkpoints. The saved `WW1939.INI` and `EURO1939.DAT` hold the same lines as the
  originals (with CRLF line ends), and `SHELL "copy"` made the two `.bak` files.
- The script `edit-1939` plays the editor. It loads 1939, then changes a technology level, the cash, the fort
  of Belgrade, the navy and the side. It saves the scenario as 1939, loads it again and quits. Besides the
  screens, it checks the hashes of the saved `WW1939.INI` and `EURO1939.DAT` and of the two `.bak` files.
  Both builds give the same screens and files, in two runs each.

## What this found in QB64Rust

- `Interrupt 51, regs, regs` is rejected ("not supported yet: `Interrupt` as a statement"). QB64pe accepts it.
- `ON LOCAL ERROR GOTO` was reported as "not supported yet". QB64pe rejects it too ("Name already in use
  (ERROR)"). Since 2026-11-05 QB64Rust gives a plain error instead. It says the form is BASIC PDS 7.1's, and to
  use `ON ERROR GOTO` with the handler in the main module, and `ON ERROR GOTO 0` before the SUB ends. The
  `ON ERROR GOTO 0` matters: a handler set in a SUB stays active after the SUB returns, where `ON LOCAL ERROR`
  ends with its SUB. QB64Rust's `verification\v17_d_err_on_local_error_sub` and `v17_d_on_error_sub_stays`
  measure both.
- A named `COMMON` block is rejected by both compilers, with a clearer message from QB64Rust.
- **A bare `CURDIR$` builds with no message in both compilers**, as a string variable that is always `""`
  (measured 2026-11-05). PDS 7.1's `CURDIR$` returns the current folder. So the port lost it silently, and
  only a review found it (item 4).
- **A SUB that ends with a `GOSUB` pending breaks the caller's next `RETURN`**, in QB64Rust as in QB64pe.
  QB64Rust keeps QB64pe's single `GOSUB` stack on purpose (QB64Rust's `study\00` §6, "Kept"). QB 4.5 and
  PDS 7.1 give the other result. The test program: main does `GOSUB ask`, `ask` calls a SUB that does
  `GOSUB inner` and leaves `inner` by `GOTO` and `END SUB`.
  - QB 4.5 (QB64Rust's `tools\qb45\qb45.py`) returns from `ask` and goes on.
  - PDS 7.1 does the same in all three runs, under DOSBox: in QBX, and built with `BC /O /E /X`, with and
    without `/D` (2026-11-05).
  - QB64pe and QB64Rust stop at that `RETURN` with "RETURN without GOSUB". QB64Rust's
    `verification\v17_d_gosub_left_in_sub` now tests this, so a later change to QB64Rust's stack would show.

  The editor depended on the PDS result (item 11 above).
- **A rare crash at exit came from QB64Rust's test hook, not from the game or the runtime** (2026-11-07).
  `endturn-1943-allied` sometimes ended with exit code 0xC0000005 (an access violation), after all its
  checkpoints and its last state were written. It crashed in 1 or 2 runs in 40 at `--jobs 4`. Under `cdb`, the
  stacks showed two threads at once. The main thread was in `exit()`, destroying libqb's static objects. The
  hook's key thread, still pressing Space for the script's last line `repeat space`, was in
  `keyboard_keydown`, writing into libqb's `keyhit_buffer` after its storage was freed. A real program
  gets its keys on the main thread, so it cannot hit this. QB64Rust's `tools\screen\screen_state.cpp` now
  stops giving keys once the program begins to exit. After the fix, 200 runs of 200 passed.
