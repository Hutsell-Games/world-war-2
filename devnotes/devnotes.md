1. QB64 doesn't support the `DIR$` statement from PDS 7.1, using `SHELL` to save list of files to temporary file then reading and displaying in WW2 Editor.
1. Corrected an error thrown when attempting to paratroop with no troops available to paratroop. Used the same checks and error messages as were in the original code but swapped two of them so that a check for a negative number was made first. Seems QB64 implementation is slightly different from PDS implementation.
1. QB64 doesn't support the `DIR$` statement from PDS 7.1, using `SHELL` to save list of files to temporary file then reading and displaying in WW2.
1. Commented out `ON LOCAL ERROR GOTO nosound` as it is throwing an error in QB64.
1. Moved some code relating to using the mouse around due to changes in QB64 not supporting the initial configuration.
    - The files `GENERAL.BI` and `MOUSE.BI` were placed towards the beginning of `WW2.BAS`
    - The `$INCLUDE` statements were removed from `MICKEY.BAS`
    - An `$INCLUDE` for `MICKEY.BAS` was added to the end of `WW2.BAS`
1. Convert all `DIR$` to `_FILEEXISTS` equivalents, except one.
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
