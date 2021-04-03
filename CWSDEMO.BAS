DEFINT A-Z
DECLARE SUB TICK (sec!)
DECLARE SUB usa ()
SCREEN 0
COLOR 11, 1
CLS
LOCATE 3, 9
PRINT STRING$(64, 177)
PRINT "	± WW2 in Europe is offered as SHAREWARE, which lets you try    ±"
PRINT "	± before you buy. If you enjoy this game and are continuing    ±"
PRINT "	± to play, you should register with the Author.                ±"
PRINT "	± See the file REGISTER.DOC for full details.                  ±"
LOCATE 8, 9
PRINT STRING$(64, 177)
PRINT "	± With registration you get all the latest features, technical ±"
PRINT "	± support and upgrade notices. At $12 it is a superior value.  ±"
LOCATE 11, 9
PRINT STRING$(64, 177)
PRINT "	± Other games available are:                                   ±"
PRINT "	± û VGA Civil War Strategy - similar to WW2 but with features  ±"
PRINT "	±                       related to the American Civil War.     ±"
PRINT "	± û EGA CIVILWAR BATTLESET - a prize-winning tactical level    ±"
PRINT "	±                       game and editor for individual battles.±"
PRINT "	± Each is $10 to register.                                     ±"
LOCATE 18, 9
PRINT STRING$(64, 177)
PRINT "	± BONUS: Register WW2 and one other game for only $19 !        ±"
PRINT "	± DOUBLE BONUS: Register ALL 3 for only $25 for hours of fun ! ±"
LOCATE 21, 9
PRINT STRING$(64, 177)
COLOR 14, 4: LOCATE 4, 11: PRINT "WW2 in Europe"
COLOR 0, 4: LOCATE 13, 13: PRINT "VGA Civil War Strategy"
COLOR 0, 7: LOCATE 15, 13: PRINT "EGA CIVILWAR BATTLESET"
COLOR 31, 1: LOCATE 19, 11: PRINT "BONUS!"
COLOR 31, 4: LOCATE 20, 11: PRINT "DOUBLE BONUS!"
COLOR 15, 0
LOCATE 22, 36: PRINT "W.R. Hutsell"
LOCATE 23, 32: PRINT "2021 Hutchinson Drive"
LOCATE 24, 30: PRINT "Kingsport,  TN  37660  USA";
LOCATE 3, 1
TICK 99
CALL usa

COLOR 11
LOCATE 3, 14: PRINT "User Comments on VGA Civil War Strategy"
COLOR 15
TICK 1
LOCATE 5, 5: PRINT CHR$(34); "... simple, subtle, and addictive !"; CHR$(34)
TICK 1
LOCATE 8, 5: PRINT CHR$(34); "This game is fantastic. A MUST for Civil War buffs !"; CHR$(34)
TICK 1
LOCATE 11, 5: PRINT CHR$(34); "Excellent game ! The BEST IBM game I've EVER downloaded!"; CHR$(34)
TICK 1
LOCATE 14, 5: PRINT CHR$(34); "I'd just like to say that I LOVE this game!"; CHR$(34)
TICK 1
LOCATE 17, 5: PRINT CHR$(34); "... more enjoyable hours per dollar than any other game"; CHR$(34)
TICK 3
DIM Image(1 TO 16000)
	SCREEN 9
	DEF SEG = VARSEG(Image(1))
	BLOAD "egacw.sc1", VARPTR(Image(1))
	DEF SEG
	PUT (1, 1), Image, PSET
	DEF SEG = VARSEG(Image(1))
	BLOAD "egacw.sc2", VARPTR(Image(1))
	DEF SEG
	PUT (1, 91), Image, PSET
LINE (1, 180)-(639, 350), 1, BF
LINE (1, 180)-(639, 350), 9, B
LINE (5, 182)-(634, 348), 9, B
TICK 1
COLOR 14
LOCATE 15, 27: PRINT "EGA CIVILWAR BATTLESET..."
LOCATE 17, 2: PRINT " a prize-winning tactical game of individual battles";
TICK .5
PRINT "... with scenario editor"
TICK .5
COLOR 13
LOCATE 17, 63: PRINT "SCENARIO EDITOR"
TICK 1
COLOR 15
LOCATE 19, 2: PRINT CHR$(34); "... one of the best buys in Shareware"; CHR$(34)
TICK 1
LOCATE 21, 2: PRINT CHR$(34); "Probably the best wargame I've seen and played"; CHR$(34)
TICK 1
LOCATE 23, 2: PRINT CHR$(34); "... highly ADDICTIVE game. Should be listed with the FDA!"; CHR$(34)
TICK 3
LOCATE 3, 1

DEFSNG A-Z
SUB TICK (sec!)
start! = TIMER
DO WHILE TIMER - start! < sec! AND INKEY$ = "": LOOP
END SUB

SUB usa
SCREEN 12
LINE (1, 16)-(527, 440), 10, B
PAINT (200, 200), 2, 10
COLOR 10
'===========================  Kentucky =================================
LINE (105, 190)-(150, 190)
LINE -(150, 185)
LINE -(290, 185)
LINE (276, 185)-(301, 175)
LINE -(305, 160)
LINE -(310, 155)
LINE -(305, 145)
LINE -(300, 125)
LINE -(290, 110)

LINE -(275, 95), 1
LINE -(270, 95), 1
LINE -(260, 100), 1
LINE -(250, 100), 1
LINE -(240, 90), 1
LINE -(235, 85), 1
LINE -(230, 85), 1
LINE -(220, 90), 1
LINE -(220, 100), 1
LINE -(210, 105), 1
LINE -(205, 115), 1
LINE -(195, 125), 1
LINE -(170, 130), 1
LINE -(165, 135), 1
LINE -(130, 140), 1
LINE -(120, 150), 1
LINE -(120, 160), 1
LINE -(115, 165), 1
LINE -(105, 170), 1
LINE -(105, 190), 1
'===========================  Tennessee =================================
LINE (290, 185)-(320, 185)
LINE -(320, 185)
LINE -(315, 195)
LINE -(302, 210)
LINE -(290, 215)
LINE -(275, 230)
LINE -(260, 241)
LINE -(260, 241)
LINE -(70, 241)

LINE (105, 190)-(95, 200), 1
LINE -(80, 220), 1
LINE -(70, 241), 1
'===========================  Mississippi =================================
LINE (143, 241)-(145, 405)
LINE -(135, 400)
LINE -(125, 400)
LINE -(115, 405)
LINE -(110, 400)
LINE -(110, 390)
LINE -(115, 380)
LINE -(115, 375)
LINE -(50, 375)
LINE (115, 375)-(60, 375)

LINE (70, 241)-(65, 280), 1
LINE -(60, 295), 1
LINE -(65, 325), 1
LINE -(65, 335), 1
LINE -(50, 375), 1
'===========================  Alabama =================================
LINE (215, 241)-(232, 375)
LINE (176, 395)-(181, 410)
LINE -(166, 415)
LINE -(161, 400)
LINE -(156, 405)
LINE -(146, 405)
LINE (176, 395)-(176, 385)
LINE -(231, 385)
'===========================  Georgia & Florida ============================
LINE (261, 241)-(296, 241)
LINE -(291, 265)
LINE -(350, 340)
LINE -(336, 390)
LINE -(366, 440)
LINE (336, 385)-(325, 385)   'Fla /Ga Border
LINE -(320, 388)
LINE -(245, 388)
LINE -(230, 385)
LINE (180, 410)-(195, 410)
LINE -(215, 415)
LINE -(225, 425)
LINE -(255, 420)
LINE -(265, 420)
LINE -(270, 425)
LINE -(275, 440)
LINE (347, 409)-(343, 409)
LINE -(343, 431)
LINE -(346, 431)
LINE -(346, 412)
LINE -(349, 412)
LINE (347, 411)-(350, 411), 1

LINE (353, 333)-(358, 336), 10, B
'===========================  South Carolina ================================
LINE (290, 241)-(305, 240)
LINE -(345, 240)
LINE -(350, 250)
LINE -(380, 250)
LINE -(415, 280)
LINE -(385, 315)
LINE -(380, 320)
LINE -(375, 325)
LINE -(350, 330)
LINE -(350, 340)
'===========================  North Carolina ================================
LINE (320, 185)-(500, 185)
LINE -(505, 190)
LINE -(490, 195)
LINE -(490, 205)
LINE -(505, 205)
LINE -(500, 215)
LINE -(485, 220)
LINE -(490, 225)
LINE -(500, 225)
LINE -(500, 230)
LINE -(490, 235)
LINE -(488, 240)
LINE -(480, 241)
LINE -(460, 250)
LINE -(455, 255)
LINE -(440, 265)
LINE -(439, 270)
LINE -(425, 278)
LINE -(415, 280)
LINE (510, 190)-(513, 200), , B
LINE (510, 206)-(510, 226)
LINE -(500, 236)
LINE -(502, 241)
LINE -(512, 228)
LINE -(512, 208)
LINE -(510, 206)

'=========================== Chesapeake ====================================
COLOR 10
LINE (500, 185)-(505, 180): LINE -(505, 175)
LINE -(500, 170): LINE -(490, 165)
LINE -(495, 160): LINE -(490, 155)
LINE -(485, 150): LINE -(495, 155)
LINE -(495, 145): LINE -(490, 140)
LINE -(485, 130): LINE -(470, 120)
LINE -(470, 110): LINE -(475, 120)
LINE -(485, 120): LINE -(485, 115)
LINE -(480, 100): LINE -(485, 90)
LINE -(495, 80): LINE -(500, 80)
LINE -(500, 85): LINE -(495, 90)
LINE -(495, 100): LINE -(495, 115)
LINE -(500, 120): LINE -(500, 130)
LINE -(515, 135): LINE -(515, 140)
LINE -(510, 160): LINE -(520, 145)
LINE -(525, 120): LINE -(525, 115)
LINE -(515, 85): LINE -(527, 95)
PAINT (500, 400), 1, 10
PAINT (510, 110), 2
'=============== Ohio, Pennslyvania, Maryland, Virginia =====================
LINE (291, 111)-(301, 101), 1
LINE -(316, 96), 1
LINE -(331, 76), 1
LINE -(345, 51), 1
LINE -(351, 30), 1
LINE -(370, 35), 1

LINE (351, 16)-(351, 54)
LINE -(527, 54)
LINE (381, 54)-(381, 81)
LINE -(431, 66)
LINE -(456, 81)
LINE -(471, 111)
LINE (226, 85)-(226, 16)
'=============== Louisiana, Arkansas, Missouri =============================
LINE (50, 375)-(60, 395), 1
LINE -(105, 405), 1
LINE -(110, 420), 1
LINE -(125, 438), 1
LINE (110, 398)-(105, 398)

LINE -(90, 396)
LINE -(90, 400)


LINE -(105, 402)
LINE -(120, 415)
LINE -(115, 420)
LINE -(125, 435)
LINE -(120, 440)
LINE -(110, 425)
LINE -(100, 435)
LINE -(90, 440)
LINE -(50, 430)
LINE -(25, 435)
LINE -(1, 435)
'----------------------------------
PAINT (250, 430), 1, 10
PAINT (110, 439), 1, 10
PAINT (50, 439), 1, 10
'--------------|‚‡€}€‚‰€ƒ„‡€|{‚€†€{€‚‚‚z€‚‚{€€‚‚‚}z€‚„„}zƒˆ~‚|€…ˆ~€€‚‡~|€ƒ€€€€~€„…€|ƒ{‡{€‚€‚Š€|€ƒ€…€€„~€€‚~€‡€|„€~„€~…}€…€z€„‚‚~}…‚ƒ}|ƒ‰{‚…{€„~|‡z€‰€{€y€…†~„…ƒ‚‡€~€|u|…{{‚‡ƒ~…‹€x€…y}ƒ~|„„ƒ‰€|€{}ƒ~y‚†€~†‡yy††{‚ˆx‡zƒ‰~€‚…}†|‚ˆ€~…€{€…‡{ƒˆ€z‚‹|„ˆz„…}‡‚}ƒˆ€„zƒ~z€†€zƒˆ|††z‡z€†~z€ˆ~{€}€…|…~z‚„}€…„z€‡z€‡}y†{~„†}€‡€{€…~|ƒ~|€†{†zƒ…|„…y€‡z‡€€|„€}†{ƒ…~}ƒz„z‡€{ˆzƒ€}€†€}†}†~€‚|€†{‚†€}ƒ†~€ƒ„|…|€†€€ƒ€|€„|€†€~ƒƒ|€ƒ~|„€|†€€€}‚~}€ƒ}ƒ€€€}€„|…€|„~€ƒƒ~€„€~€ƒ€…€~€ƒ~€„€ƒ„~€‚}€„|€……€}ƒ~€‚€‚‚}€‚~€„}€ƒ€‚„€‚~~‚€€„€‚~‚~‚€‚ƒ~€ƒ‚~€€~ƒ€„€ƒ~„||€€‚~}„€}€„ƒ…‚€€}|ƒ€‚~‚‰‰zyƒ|}€„…€„€w{„„„‚‚‚{w|€†‚ƒ„‚~ƒ‚‚ƒ‚€‚€{€…‚}€‚ƒ~€…€}€‚€‚~‚‚€ƒƒ‚€ƒ~ƒ‚~€~}~€€€€‚„}~‚€}€~}„€‚„‚„„€~~}‚„ƒƒ€~ƒ€~€€‚ƒ€~€ƒƒ€€€€‚‚‚ƒ€€ƒ…ƒ~‚‚€~€‚€‚€‚€€€€‚‚ƒ~~€‚€~€‚€ƒ€ƒ‚€€€€‚‚‚‚ƒ€~‚‚€€€‚ƒ€€€€€~‚‚€€€€€~€€€€‚‚‚‚€€€€€‚€€€€€€€€€€€‚€~€€ƒ‚€€€€€€€€€€€€€‚€€‚‚€ƒ‚‚‚ƒ‚‚‚‚‚‚‚‚ƒƒ‚‚‚‚€€‚‚‚‚€€€€€€€€€€€€€€€€€€‚€€€€€€€€€€€€€€€€€€y}‚|…Š…„€}|€}}yt|…‹}‚{{‚„}‡‚ƒ€}y{††‚€€ƒ€~}~€‚~~†‰…„}|}„€…€{†ƒ|~„„……‚yvƒ††‰‡‰†~~„„……€‚ƒƒ‚~„…‚~€‡†€„…‡‰‚~~ƒ†„…„†‡{ƒ}‚ŠŒ‡†ƒ€{x|ƒ€„‚†‚„€{y„‚}zƒ†‚|€€€~~{€€|„€„{€}†„}‡„ƒ‰Šˆ„††…†‡ˆ‚„„†ˆ……†‡ˆˆ………‚„†€ƒ…ƒ€„ƒ„ƒ„€€€„‚€€€~€z€ƒ€€|€}||€€€€€|€|‚€€€ƒ…‚€ƒ„‡…ƒ€€€€‚„„†…„€€…†……†„„€€~€‚„…†„†‚ƒ„ƒ~‚‚~…}~†ƒ…€†‡‚†…‡‚€„…€~€ˆ~{}Žˆƒux‰‚pwƒ€€z|†ˆˆ‡‚†…vnv‚†…‡–‰Š€ƒƒ~odkrn€‹Ž–•”…wxzorry„†~›†ˆƒ…~wrty€ˆˆ‡‹Œw{‹„}ˆƒy…ƒ‚zƒˆƒ~‚‚‚‡ŒŠ†‹ˆ‡‰††ƒˆ‚Œ††Œˆ†ˆ†z{‚{~‡ŽŽŽ†…ˆ{|}z{‚‡„…„€…‰…|}‡~}~ƒzz…}y~€‚‡ˆ…†ƒ|}w{€ƒ‚}‚„€‚…wt{|vvƒ~‚‰†‚ƒ{zyyy}|z~ƒ€ƒƒƒ~}ƒ‚{z€v‰€}{„ƒ€z}y„{‹ˆ€…€zƒ„€}|€€}ƒŠ…~‡Š|…†~~Œ‡„ˆ‹……‡ƒ‚‚|‚ƒ€‚ˆ‰…„‡ƒ~ƒ‚zz„‚~~ˆ„†ˆ~}€{€~€Š…†„{‚}}z|~…€„ˆ„~~|}}~‚‚|†{‡‚‚~€}}„ƒ€‡}ƒ‚~€‚„„‚‡†}†ˆƒ}}€‚~~…€†ƒƒ„‚€€€~~|€…‚ƒƒˆ€‚‚}|€~€€‚~~€€€‚ƒ~€}~}€~€ƒ€€‚~€{€‚€|€€{€…€}ƒ~|€yƒ€ƒ‚€~„Œ†ˆqlt}€}y|…†|€‡ŒƒŒˆˆuuwk}ˆŠxs€‚«£igŽ`uŠŸ€‹xYe‰„•ŠŒ‰qmTh…‰‡•”‚z…ˆ~‘}Ž‰um‰˜w„y|€„‰~}…}€„…s|‡†€|{{€…ˆ…Ž‹€…‡‰‚zƒ„‚ƒ†|€rvx}Š‡|…„Œ‰xv„{w}y|v|‰†‡ŒŒŽ’’ƒ{xqx„ˆŽŠ‚€}{€}…‰‹„w…wxƒƒ†ˆzzzz‚ˆ„ƒ|~}yˆˆ„†‹‰„‰‡~xw‘”‰zˆ‡|}zz~‡‡ˆ|y……}x„…‡tzƒ„~Ž‹Œ‰xw|ˆ‰„}x€…†Š|‚ˆƒƒ€€{}€†Šƒ}‚ˆ‚„………Š‚v†‰€~~€†‡ˆƒ~x~~~zz‰Š~€~|‚€z…€v{€|€|€ƒ†‰ƒ}„„„}ƒ„€‡‚„†„€~Š„‚{€„~~……€{…€ƒ‚„{w~~€„ˆŠ„{}{€z}‚„}|€}‚}{{{~ƒ„€€€€†…„†‡…„„ƒˆ‡ˆˆˆŒˆ‡‡†„ƒ…†‡„†‰‹‰‡„ƒˆ‰ˆƒƒ„„€€„…†€ƒ‚€€€|{€‚{‚‚…€€€€€}~€‚…€†„€|€€€€€€…€€~€€{€€ƒ€€€€€€}€€€€€€€€€€‚€€€€€€€€€€€€€€€€€€€€€‚€€€€€€€€€€€€€€€€€€€‚€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€‚€€€€€€€€€€€€€€€€€€€‚€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€‚€€€€€€€€‚€~€€€€