@echo off
if "%1" == "s" goto card
if "%1" == "S" goto card
if "%1" == "m" goto card
if "%1" == "M" goto card
goto nocard
:card
if not exist sbsim.com goto nosound
echo ÿ   W O R L D    W A R     2     in  E U R O P E
echo                   Strategy Game
echo            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo            ³     (with SOUND CARD CAPABILITY)     ³
echo            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
sbsim.com ww2snd.cfg
if "%1" == "m" goto sbmu
if "%1" == "M" goto sbmu
:game
ww2.exe %1
if "%1" == "m" goto sbmx
if "%1" == "M" goto sbmx
:thru
sbsim.com /U
goto done
rem . . . . . . . . . . . . . . . . music option (midi) . . . . . . . . .
:sbmu
sbmidi /G
goto game
:sbmx
sbmidi /U
goto thru
rem . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
:nosound
echo ÿ
echo Must uncompress SOUNDS.Z~P before using sound options !
pause
echo ÿ
:nocard
cls
echo ÿ   W O R L D    W A R     2     in  E U R O P E
echo WW2 to play the game
echo README.TXT for latest information including SOUND CARD setup
echo INSTALL to load on hard drive
echo Documentation is in the files WW2.DOC
echo Use PRINTDOC to print documentation
echo Online help available within the game
echo ÿ
echo ========================================================================
echo Please note that only the 1939 scenario is uncompressed on this
echo disk. The remaining scenarios are compressed in the file
echo SCENARIO.ZIP to save disk space.
echo ÿ
echo ALL the scenarios will be uncompressed when you INSTALL the program.
echo ========================================================================
echo ÿ
echo Hit Ctrl-C if you do NOT wish to begin the game
pause Press ENTER to begin World War 2 in Europe
cls
echo Loading World War 2 in Europe ...
ww2.exe
goto done
:soundoff
:done
