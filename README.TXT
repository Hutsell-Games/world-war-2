***********************************************************
                 Changes to Version 1.15
1. A fix has been made to avoid crashing the PBM game, when
   the program would sometimes run out of memory. The fix
   involves moving some of the graphics in the game into
   separate *.grf files, which may slow some aspects of
   gameplay slightly on slower machines.
2. Hot keys have been added for additional game reports:
        F4  -   troop strength
        F5  -   friendly army report
        F6  -   enemy army report
        F9  -   battle summary
        F10 -   technology report
3. An option has been added to the Inform submenu to allow
   you to clear the battle summary statistics.

***********************************************************
           S O U N D    C A R D    S U P P O R T
***********************************************************
1. Capability has been added to allow use of Sound Blaster
   (trademark of Creative Labs, Inc.) sound cards via the
   Creative Labs software utilities and the CTVDSK disk
   voice driver, which are merged into this application.
   These files are included along with the necessary *.VOC
   sound files.

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!    NOTE: The method used with the sound card reads      !
!    the sound files from disk as the game is playing.    !
!    If you not have both a HARD DISK and a DISK CACHE    !
!    this will appreciably slow the game.                 !
!.........................................................!
!    If you do not have a DISK CACHE you CAN run the      !
!    program with  sounds from a RAM DRIVE. Be sure the   !
!    the sounds are all on the RAM DRIVE, and the         !
!    GO.BAT file, all *.VGA files, all *.DAT files,       !
!    all *.INI files, and the *.CFG files as a minimum.   !
!    Be sure the GO.BAT file has the proper path for      !
!    the WW2.EXE program.                                 !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   This program has been tested on different Sound Blaster
   systems, and is also known to work with the Advanced
   Gravis Ultrasound card. However, since this relies on
   specific Creative Labs software utilities, it may or may
   not work on other systems. There are no guarantees the
   sound will work with any particular user arrangement.
   
+----------------------------------------------------------+
|             TO RUN PROGRAM WITH SOUND BLASTER            |
+----------------------------------------------------------+
|  Type GO S and the sound driver will load, and the       |
| program will run. You should hear gun sounds at the      |
| title screen. When you finish the game, the sound driver |
| will automatically unload to free system memory          |
+----------------------------------------------------------+
| Type GO M to load BOTH the sound driver and the general  |
| MIDI music driver. Both will unload when the game is     |
| over.                                                    |
+----------------------------------------------------------+

    The sound files themselves are provided in a "raw" .VOC
    format, which means they may be customized if you have
    capability to produce/edit .VOC files. (If you have or
    can make .WAV files, there are utilities that will let
    you change them to .VOC format). The files you create
    should be kept about the same size as the ones provide
    to keep game playable; .VOC files can become HUGE if you
    aren't very careful.

    File           Size                    Use
    ------------  -------  --------------------------------------
    battle.voc     5723    artillery fire
    charge.voc     3538    charge refrain
    ding.voc       6275    bell - attention
    drums2.voc     8181    drums - for unit movement
    engine.voc     3212    propeller aircraft
    gun.voc         816    machine gun
    ships.voc     10317    building new ship
    sunk.voc      10949    sinking ship splash

2. The F4 key will show a force summary from the Main Menu
   without having to go through the Inform menu, as a convenience
   in sizing up relative army strengths.

3. Cities that have been neutralized by bombing are now shown in
   purple to distinguish them from cities that were true neutrals
   at the beginning of the scenario.

4. If you have a problem with the sound card routines, there may
   be a way to get some of the sound effects through your PC
   speaker, using a Shareware sound routine that is included for
   free. The quality will suffer and gameplay is slowed somewhat,
   but you may like it better than the standard sound. To invoke
   the .VOC sounds through your PC speaker, start the game by
   typing:

   WW2 Z
