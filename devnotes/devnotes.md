1. Basic replacement of `DIR$` with QB64 `_FILEEXISTS`, will require more refactoring to fully work.
    - Goal here is simply to get the code "running", then to go back and ensure all file loading/saving works correctly.
1. Remove `WW2.TXT`, essentially equivalent to `WW2.DOC`
1. Merge `WW2.BI` into `WW2.BAS`
1. Merge `WW2B.BAS` into `WW2.BAS`
1. Remove WW2 Shareware related files `WW2-S.BAS` and `WW2-S.LNK`
1. Merge `WW2C.BAS` into `WW2.BAS`
1. Remove code duplicated between `WW2-S.BAS` and `WW2.BAS`
1. Whitespace reformatting of `WW2B.BAS`, `WW2C.BAS`, `WW2.BAS`, `EDIT.BAS` to allow code folding.
1. Remove extended ASCII characters from some code comments
1. Remove `WW2.OBJ`, `WW2B.OBJ`, `WW2C.OBJ`, `WW2-S.MAK`
1. Remove `WW2TITLE.EXE`, `WW2CITY.EXE`
1. Remove `WW2DEMO.BAS`, while interesting historically, not actually part of game
1. Remove `CWSDEMO.BAS`, the full CWS is available for free from hutsellgames.com
