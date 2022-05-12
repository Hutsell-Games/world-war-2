1. Remove Help option, this was useful in original context of DOS where it wasn't easy to refer to two windows at the same time (e.g. help file and game) but no longer necessary with modern windowing solutions.
1. Reformatting code, mainly expanding multiple statements across multiple lines instr\ead of all on a single line.
    - This was helpful in older days to keep source code files small as there were easily reachable limits on code file size, but this is not a problem for us.
    - Also cleaning up comments, mainly condensing them.
1. Remove code related to sound blaster and MIDIs from main application.
1. Remove `EGACW.SC1` and `EGACW.SC2`, these are not called anywhere.
1. Remove a number of files related to PDS 7.1/QB but no longer useful for QB64: `QBX.INI`, `QBX.BI`, `QBX.QLB`, `WW2.LNK`, `WW2.MAK`, `WW2MAKE.BTM`
1. Remove a number of files related to sound support: `CT-VOICE.DRV`, `CTMIDI.DRV`, `CTVDSK.DRV`, `GO.BAT`, `PLANY.EXE`, `PLAYMIDI.EXE`, `SBMIDI.EXE`, `SBSIM.COM`, `SNDCVT.EXE`, `SOUND.DOC`, `SOUND.EXE`, and `WW2SND.CFG`
    - A number of these provided support for Soundblaster Sound Cards, which is now a fairly ancient technology.
    - Some provided methods of playing various sound effects. I have retained the `.VOC` files that contain the sounds but removed the players as they do not work with Windows. At some juncture I may integrate sound players back into the game with more modern functionality.
    - Sound is still available, probably what many remember and what is used in VGA Civil War Strategy (e.g., `PLAY` statements), but is not quite as varied or smooth.
1. Update `GO.BAT`, removing some unsupported characters and outdated information.
1. Remove some unneeded sound related files.
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
