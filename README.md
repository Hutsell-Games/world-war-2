# W.R. Hutsell's World War 2 In Western Europe Game
A strategic level, one or two player wargame simulating the Second World War.

## This branch: the QB64 port
W.R. Hutsell wrote the game in Microsoft BASIC PDS 7.1 for DOS and gave the source to Dave Mackey. The
original source is kept unchanged on the branch `main`.

This branch, `qb64rust`, changes that source as little as possible so that the game builds with QB64Rust
and QB64pe, and so that its SUBs can be tested. It builds one program, `WW2.BAS`, which includes the other
source files (`WW2.BI`, `WW2A.BM`, `WW2B.BM`, `WW2C.BM`, `MICKEY.BM`, `QB64.BM`, `SCRIPT.BM`):

```
qb64rust -x WW2.BAS -o ww2game.exe
```

Run the program from this folder: it reads its data files from beside itself. `WW2.EXE` is the original
DOS program; do not overwrite it.

The tests are described in [tests/README.md](tests/README.md). Work still to do is in [TODO.md](TODO.md).

`README.TXT` and `WW2.DOC` are the original documentation of the game.
