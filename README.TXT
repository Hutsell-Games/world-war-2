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

4. The sound files themselves are provided in a "raw" .VOC
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
