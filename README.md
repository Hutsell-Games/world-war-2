# W.R. Hutsell's World War 2 In Western Europe Game
A strategic level, one or two player wargame simulating the Second World War.

## This branch: the QB64 port
W.R. Hutsell wrote the game in Microsoft BASIC PDS 7.1 for DOS and gave the source to Dave Mackey. The
original source is kept unchanged on the branch `main`.

This branch, `qb64rust`, changes that source as little as possible so that the game builds with QB64Rust
and QB64pe, and so that its SUBs can be tested. It builds one program, `WW2.BAS`, which includes the other
source files (`WW2.BI`, `WW2A.BM`, `WW2B.BM`, `WW2C.BM`, `MICKEY.BM`, `QB64.BM`, `SCRIPT.BM`):

```
qb64rust -x WW2.BAS -o ww2.exe
```

The scenario editor is a program of its own, `EDIT.BAS`. The game's Editor entry runs it as
`edit.exe`, and its PLAY GAME runs the game as `ww2.exe`, so keep those names:

```
qb64rust -x EDIT.BAS -o edit.exe
```

The builds are not committed (`.gitignore`). The original DOS programs `WW2.EXE` and `EDIT.EXE`
are not on this branch, because the builds take their names; they are on `main`. So are the
files the port does not use: the DOS sound drivers and players, the DOS batch files, the PDS build
files, the demos, `WW2TITLE.EXE`, `WW2CITY.EXE` and `WNEM.ZIP`. Each merge
into `main` also builds both programs on GitHub Actions (it can be started by hand too, under
Actions, Build, Run workflow): the run's artifact `world-war-2` holds
them with the data files, ready to play.

Run the program from this folder: it reads its data files from beside itself. With no option the
game beeps. `ww2 S` plays the sound effects (the `.VOC` files), and `ww2 M` plays the
music (the `.MID` files) as well.

The tests are described in [tests/README.md](tests/README.md). Work still to do is in [TODO.md](TODO.md).

`README.TXT` and `WW2.DOC` are the original documentation of the game.
