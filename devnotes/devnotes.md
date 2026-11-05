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

Put the executables in this folder before running them: a QB64 program looks for its data files beside itself.
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
| `MICKEY.BM` | The mouse routines (`MICKEY.BAS`) |
| `QB64.BM` | What the game needs from PDS 7.1 that QB64 does not have: `DIR$` |
| `SCRIPT.BM` | The hooks for the whole-game scripts: the seed, and the announcement of each wait for a key |
| `EDIT.BAS` | The scenario editor, a program of its own (1,652 lines). It includes `EDIT.BI` and `QB64.BM` |
| `EDIT.BI` | The editor's declarations, as they came |
| `tests\rules_test.bas` | Unit tests, run by `qb64rust test` |
| `tests\play.py` | Plays the scripts and compares their screens (`check`, `compare`, `record`, `coverage`, `explore`) |
| `tests\make_scripts.py` | Writes the generated scripts, after probing each game |
| `tests\scripts\` | The scripts (`<name>.keys`) and their recorded screens (`<name>.screen`) |
| `tests\test_play.py` | Tests of `play.py` itself |
| `tests\README.md` | How the tests work and how to write a script |
| `.github\workflows\build.yml` | Builds `ww2.exe` and `edit.exe` with QB64Rust on each merge into `main` or when started by hand, and uploads them with the data files as the artifact `world-war-2` |

## What was changed from `main`, and why

1. **One program instead of four linked modules.** QB64 builds one program. `WW2B.BAS`, `WW2C.BAS` and
   `MICKEY.BAS` were renamed to `.BM` and are included at the end of `WW2.BAS`. Their headers (`DEFINT`, `DECLARE`,
   the include of `ww2.bi`) were removed, because the main module already has them.
2. **The SUBs of `WW2.BAS` moved to `WW2A.BM`, unchanged.** A test file includes the `.BM` files and so gets every
   SUB without the main module's code.
3. **The `DIM SHARED` lines of `WW2.BAS` and `WW2B.BAS` moved to the end of `WW2.BI`**, with the includes of
   `general.bi` and `mouse.bi`. A test file needs them too.
4. **`DIR$` is a FUNCTION in `QB64.BM`**, written with QB64's `_FILES$`. The 16 calls are unchanged, except
   `t$ = DIR$` in `filer` (`WW2B.BM`), which is now `t$ = DIR$("")`: a FUNCTION of QB64 cannot leave its argument
   out.
5. **`MouseDriver` in `MICKEY.BM` uses QB64's mouse statements.** The original called the DOS mouse driver with
   `Interrupt 51`. The new body does the six driver functions the game uses (0, 1, 2, 3, 7, 8). The limits set by
   `MouseBorder` no longer hold the real cursor; the position the game reads is kept inside them instead.
6. **`COMMON SHARED /uitools/ MousePresent` in `MOUSE.BI` is `DIM SHARED MousePresent`.** QB64 has no named
   `COMMON` blocks.
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
   screen are therefore missing.
9. **Hooks for the whole-game scripts** (`SCRIPT.BM`). `RANDOMIZE TIMER` is now `CALL scriptstart`. Each wait
   for a key calls `announce` first: `TICK`, the `menu` loop, `Mickey`, the Hall of Fame's `INPUT`, the PBM news
   and the boss screen. A `TICK` with a time above 0 returns at once when the game is scripted, and a saved
   game holds a fixed date (`scriptdate$` in `filer`, in place of `DATE$`). None of this
   does anything unless the environment variable `WW2_SEED` is set, so the game plays as before.

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

    The editor's `menu` is the same code as the game's (`WW2C.BM`), and the game's `yesno` (`WW2.BAS`) is
    the same as `yessir`. The game was not changed (`TODO.md`).

## Not done yet

See [TODO.md](../TODO.md).

## What has been checked

- QB64Rust 0.3.0 and QB64pe 4.7.0 both build `WW2.BAS`.
- Both builds were played with the same keys from the start menu to the first turn of the 1939 scenario. The
  screen was compared at four points and is identical, pixel for pixel, in both builds.
- `qb64rust test tests`: 20 tests pass. They cover `airdist`, `starfin`, `occupy`, `bubble`, `canimove` and
  `void`.
- The 37 whole-game scripts (`tests\scripts\`) play every scenario as each side to the end, with one or two
  players, and three of them go through most of the menus. Both builds show the same screens at every
  checkpoint, in two runs each (`play.py record`). The scripts run 82% of the game's lines with a statement
  (`play.py coverage`).
- QB64Rust 0.3.0 and QB64pe 4.7.0 both build `EDIT.BAS`. Both builds were played with the same timed keys,
  in a copy of this folder. The keys load 1939 by a letter at the Starting Year menu and open Technology.
  They then save the scenario back as 1939 and quit with `y`. Both builds exit with 0, and their screens are
  identical at all 7 checkpoints. The saved `WW1939.INI` and `EURO1939.DAT` hold the same lines as the
  originals (with CRLF line ends), and `SHELL "copy"` made the two `.bak` files. There is no script or unit
  test for the editor yet (`TODO.md`).

## What this found in QB64Rust

- `Interrupt 51, regs, regs` is rejected ("not supported yet: `Interrupt` as a statement"). QB64pe accepts it.
- `ON LOCAL ERROR GOTO` is reported as "not supported yet". QB64pe rejects it too ("Name already in use"), so the
  message could say that it is not QB64.
- A named `COMMON` block is rejected by both compilers, with a clearer message from QB64Rust.
- **A SUB that ends with a `GOSUB` pending breaks the caller's next `RETURN`**, in QB64Rust as in QB64pe.
  QB64Rust keeps QB64pe's single `GOSUB` stack on purpose (QB64Rust's `study\00` §6, "Kept"). QB 4.5 and
  PDS 7.1 give the other result. The test program: main does `GOSUB ask`, `ask` calls a SUB that does
  `GOSUB inner` and leaves `inner` by `GOTO` and `END SUB`.
  - QB 4.5 (QB64Rust's `tools\qb45\qb45.py`) returns from `ask` and goes on.
  - PDS 7.1 does the same in all three runs, under DOSBox: in QBX, and built with `BC /O /E /X`, with and
    without `/D` (2026-11-05).
  - QB64pe and QB64Rust stop at that `RETURN` with "RETURN without GOSUB".

  The editor depended on the PDS result (item 11 above).
