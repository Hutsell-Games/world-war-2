@echo off
if "%1" == "s" goto card
if "%1" == "S" goto card
if "%1" == "m" goto card
if "%1" == "M" goto card
goto nocard
:card
if not exist sbsim.com goto nosound
echo   WORLD WAR 2 in EUROPE Strategy Game
echo   (with SOUND CARD CAPABILITY)     
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
pause
echo 
:nocard
cls
echo WORLD  WAR 2 in EUROPE
echo WW2 to play the game
echo README.TXT for latest information including SOUND CARD setup
echo INSTALL to load on hard drive
echo Documentation is in the files WW2.DOC
echo Online help available within the game
echo ========================================================================
echo Hit Ctrl-C if you do NOT wish to begin the game
pause Press ENTER to begin World War 2 in Europe
cls
echo Loading World War 2 in Europe ...
ww2.exe
goto done
:soundoff
:done
