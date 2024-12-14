# Minimical Canonical World War II Strategy Game for QB64

## Introduction
This is an attempt to create a QB64-compatible version of Hutsell's World War II game. It makes minimal changes in the code in an endeavor to maintain stability and reach feature parity. Then we can build on from there.

## File Cleanup
- Removed `CWSDEMO.BAS`, a demo for CWS, which is available for free. `WW2DEMO.BAS`, another demo.
- Removed irrelevant QB files: `*.OBJ`, `*.LNK`, `WW2MAKE.BTM`, `WW2.MAK`
- Created audio, data, saves, and video subfolders and moved files into appropriate folders.
- Removed old DOS executable files: GUN.EXE, WW2TITLE.EXE, WW2CITY.EXE, WW2DEMO.EXE.
- Removed PRINTDOC.BAT, GO.BAT
- Remove `EGACW.SC1` and `EGACW.SC2`, these seem likely some form of binary file for EGA Civil War Battleset shareware.

## Remove Special DOS Characters
For example "�"