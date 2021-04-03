DEFINT A-Z
DECLARE SUB europe (flag)
DECLARE SUB maptext ()
DIM SHARED graphic(1 TO 1564)
DIM SHARED featx(19), featy(19), city$(58), cityx(58), cityy(58), matrix(58, 7), font$(26)
DIM SHARED usai(80), uki(80), fri(80), poli(80), rusi(80), geri(80), para(60)

DECLARE SUB TICK (sec!)
RESTORE
FOR k = 1 TO 19: READ featx(k), featy(k): NEXT k
SCREEN 0
COLOR 11, 1
CLS
LOCATE 3, 9
PRINT STRING$(64, 177)
PRINT "	± VGA Civil War Strategy is offered as SHAREWARE, which lets   ±"
PRINT "	± you try before you buy. If you enjoy this game and are       ±"
PRINT "	± continuing to play, you should register with the Author.     ±"
PRINT "	± See the file REGISTER.DOC for full details.                  ±"
LOCATE 8, 9
PRINT STRING$(64, 177)
PRINT "	± With registration you get all the latest features, technical ±"
PRINT "	± support and upgrade notices. At $10 it is a superior value.  ±"
LOCATE 11, 9
PRINT STRING$(64, 177)
PRINT "	± Other games available are:                                   ±"
PRINT "	± û WW2 in Europe *NEW*    - similar to CWS but expanded to    ±"
PRINT "	±                       capture the scope and flavor of WW2.   ±"
PRINT "	± û EGA CIVILWAR BATTLESET - a prize-winning tactical level    ±"
PRINT "	±                       game and editor for individual battles.±"
PRINT "	± WW2 in Europe is $12     - EGA CIVILWAR BATTLESET is $10     ±"
LOCATE 18, 9
PRINT STRING$(64, 177)
PRINT "	± BONUS: Register CWS and CIVILWAR BATTLESET for only $15 !    ±"
PRINT "	± DOUBLE BONUS: Register ALL 3 for only $25 for hours of fun ! ±"
LOCATE 21, 9
PRINT STRING$(64, 177)
COLOR 14, 4: LOCATE 4, 11: PRINT "VGA Civil War Strategy"
COLOR 0, 4: LOCATE 13, 13: PRINT "WW2 in Europe"
COLOR 0, 7: LOCATE 15, 13: PRINT "EGA CIVILWAR BATTLESET"
COLOR 31, 1: LOCATE 19, 11: PRINT "BONUS!"
COLOR 31, 4: LOCATE 20, 11: PRINT "DOUBLE BONUS!"
COLOR 15, 0
LOCATE 22, 36: PRINT "W.R. Hutsell"
LOCATE 23, 32: PRINT "2021 Hutchinson Drive"
LOCATE 24, 30: PRINT "Kingsport,  TN  37660  USA";
LOCATE 3, 1
TICK 99
'.........................................................................
SCREEN 12
CLS
DEF SEG = VARSEG(graphic(1))
BLOAD "w2icon.vga", VARPTR(graphic(1))
DEF SEG
PUT (100, 100), graphic, PSET
GET (101, 101)-(115, 114), usai
GET (101, 115)-(115, 128), geri
GET (101, 129)-(115, 142), uki
GET (101, 143)-(115, 156), fri
GET (123, 101)-(137, 114), poli
GET (123, 115)-(137, 128), rusi
DEF SEG = VARSEG(graphic(1))
BLOAD "w2xtra.vga", VARPTR(graphic(1))
DEF SEG
PUT (100, 100), graphic, PSET
GET (101, 101)-(115, 112), para
CLS
'.........................................................................
CALL europe(0)
PUT (70, 90), usai, PSET
PUT (90, 95), uki, PSET
PUT (90, 40), uki, PSET
PUT (70, 110), para, PSET
FOR k = 1 TO 8: PUT (470 + 30 * RND, 50 + 20 * k), rusi, PSET: NEXT k
PUT (70, 200), fri, PSET
FOR k = 1 TO 5: PUT (150 - 10 * k, 50 + 25 * k), geri, PSET: NEXT k
FOR k = 1 TO 5: PUT (410 + 40 * RND, 50 + 25 * k), geri, PSET: NEXT k
'.........................................................................
COLOR 11
LOCATE 3, 20: PRINT "NEW GAME! WW2 in Europe !"
COLOR 15
TICK 1
LOCATE 5, 5: PRINT "Based on VGA Civil War Strategy concept... but EXPANDED"
TICK 1
LOCATE 8, 5: PRINT "Infantry, Armor, Artillery, Elite, Static Units"
TICK 1
LOCATE 11, 5: PRINT "Includes Navy and Air elements"
TICK 1
LOCATE 14, 5: PRINT "8 different technology factors, weather, and more"
TICK 1
LOCATE 17, 5: PRINT "1 or 2 players or Play-by-Mail"
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

DATA 270,180,292,175,248,175,215,195,315,180,325,270,350,170
DATA 380,195,400,255,450,275,415,195,445,220,40,230,75,270
DATA 180,200,210,230,440,320,480,340,440,360

SUB europe (flag)
LINE (0, 0)-(525, 438), 2, BF
LINE (0, 0)-(525, 438), 10, B
LINE (2, 66)-(27, 90), 3, BF: LINE (2, 66)-(27, 90), 10, B
'.................................France.....& North Sea Coast..............
PSET (1, 240), 10
DRAW "C10R2F1R4F1R11E1R4F1E6U2E2U3E1U3E1U1E1U2E1U1E1U4E1U6E1U4E1U3E2U2E2U2E1H1"
DRAW "U7E2F3D2F1D4F2D1F1E2U2H1U1H1U2H1U7H6U4H2U6E2H4U3H1U4H1U8H7"
DRAW "H8L2H3L3H1L2H3L4H3U2R1E1U1H1U3"
DRAW "E3R2F1R3F2R19F1R6F4R12F1R6E5H2U3H4U3H1U2R7F7R2F4R5F1R4F2R6E2U2H4U3R3F1R6"
DRAW "E4R4U6R12F1R7E4R1E4R2E7R1E2U1E1U3E5R3F1G2D3R1E2R2E1R1F3R1E1U2H2U1H1E2"
DRAW "R2U1E3R1E3R5F1R3F3U4H2U2E4R2F5E3R7F2R3U7R3U5E3H1U1H1U1E3H3E2U4H2U2H4U1"
DRAW "R37D2G8L5D7"
'..................................Spain.......................
PSET (1, 411), 10
DRAW "C10R5E5R35E5R5E5U5E10U10E5U10E5R5U5H5U5H5U5E5R5E5R5E5U5E5R5E5R10E5R5E10"
DRAW "U10E5R5E5R10F10R5F10R5"
'......................Sardinia.............................................
PSET (246, 371), 10
DRAW "C10D10F5R5U5E5U5E5U15H5U5H5L5G5D5G5D5F5D10"
'......................Corsica.............................................
PSET (267, 300), 1
DRAW "C10D5F1D3G1D3G6D2G5H2L1H1U3H1U7R1E2"
DRAW "U3E2R4E2R1E1U2E1R1"
'......................Balearic Islands.....................................
PSET (110, 372), 10
DRAW "C10F1D1F1R1F3R2E3U1H1U2H1L1U2L4G1L2G2"
PSET (100, 369), 10
DRAW "C10L1G2D1F1R3E2H1U1L2"
PSET (128, 357), 10
DRAW "C10F2R1E3H2L1G1L1D1"
'......................Sicily................................................
PSET (319, 413), 10
DRAW "C10L3H1L3H2L10H2L7G2L1G2D6F4R3F1R2F3R2F5"
DRAW "R4F2R19U2E1U1E5U1E4U1E1U2E1H1L1G1L4G1L4G1L8H2L2"
'......................Italy................................................
PSET (345, 416), 10
DRAW "C10R1E2R2E2R2E2R1E1R1E1R1E2U1E1U4E1U1E2R1E1R1E4U5H4U1H1E1U1E1U1E4U1E4R3"
DRAW "F5D1F3R1F3D1F1D2F1D1F1E7H4U3H2U3H14U2H4U3H5U1H1R4E2H9U1H3L1H3U1H2U2H4L1"
DRAW "H7U2H3U10H1U2H1U4H3U2H4U1H5U7E2U5E6U1E3R1E3R1E3"
PSET (346, 416), 10
DRAW "C10U10R5E5U15E5U15H5U5H10L5H15U5H15U5H15U10H5U5H5U5H5L10G5L5G5L15G15L5G5"
DRAW "L10H5"
'......................Yugoslavia...........................................
PSET (353, 235), 10
DRAW "C10R10F10D3F3E3R3F2D5F5D10F5D10F5D5F10D5F10R5F5D10G5D5F5D10G5D10G5D5"
DRAW "F15R15D5F5G5H10L5G10F10"
DRAW "G3D1G1D8"
'...........................Baltic Shoreline.................................................
PSET (247, 17), 10
DRAW "C10R1G1D1G2F5D1R1D2G2F1E1R2F2R4F2R3F1R2D1"
DRAW "G2L3G2D2R5F1R3F1E4R8E1R11E1R3E2R8F1R1F1R1F1R2F2R4F2R3F4R7E8R3E2R9E1R10E2"
DRAW "R10E2R7E2R4E1R1E3R7E1R9E1R3E2R5E1F2D1F3R1F1R8E8R2H2L2H2U1E1R1F1R3F1R1E1"
DRAW "R4E4U3E2U6BG15BL194BH2BL1G2F2R3E2R2E3H2L4G2L1BR7BL2BE5BR7BL3E1R1F2R2E4R1"
DRAW "F2D2G3D4G2L3H2U2H5E1R1BF5BD10L2H2L2G2F1R5E1BR14BE23D4G1F5R3F1R10E1U2E2R2"
DRAW "E1R4E5BG5BD8BL2F3R4E2H1L2H2L2G2"
'................................Britain...........................................
PSET (100, 1), 10
DRAW "R2F2D5F1D5F1D4F3D6G3L1D2R6E2R10F2R4F2R2F2D2G7D1F2R1F6R3F1G3L1G1L6H1L4H1L4H1L7H1L15"
DRAW "H1L7H2L9G3L2G1L32G4L6G3L7H1E1R2E1R2E4R2E2U1E1U2E5R3E1R5F1R5F1R6F1E5R1E2"
DRAW "L1G1L1G1L3G1L3H2L3H3U1H3L5H3L1H2L6G2H3U5E3R2F1R2F1R4E7U5H2L2G1L7G2H1E3R2"
DRAW "E1R4E2R1F1R4F1R5F3R1E5U1H3"
'........................Greece & Yugoslavia..........................
PSET (443, 438), 10
DRAW "C10U8E3F4R1E1U8H1U5E4"
DRAW "E3R2F5E1"
DRAW "R1E2H4U5H2U3E4R2E5U1E3U2R5F1D4F8E2H2U3R3"
DRAW "F3R2U3H4E2R10F5G1D1F4E4U1E1R3F3"
'...................Africa.............................................
PSET (1, 421), 10
DRAW "C10C10F5R2F3R9E5R5F2R14F4R2R4E6R8E3R2E2R9E1R11E4R26F1R9F2R12F2R15F1R3F1R3"
DRAW "F1R1F2R3F2R6E8R8F3R2E2R4F3G3D2G1D2F2D6"
'.......................................................................
LINE (472, 408)-(474, 412), 10, BF
LINE (468, 396)-(470, 404), 10, BF
LINE (520, 410)-(522, 412), 10, BF

PAINT (100, 100), 1, 10
PAINT (400, 20), 1, 10
PAINT (200, 350), 1, 10
PAINT (505, 415), 1, 10
PAINT (150, 430), 6, 10
'.................................mountains.................................
IF LEN(DIR$("m.vga")) > 0 THEN
DEF SEG = VARSEG(graphic(1))
BLOAD "m.vga", VARPTR(graphic(1))
DEF SEG
FOR k = 1 TO 19
	PUT (featx(k), featy(k)), graphic, PSET
NEXT k
END IF
'.......................................................................
CALL maptext
'CALL showcity

'FOR i = 1 TO maxarmy
'IF armyloc(i) > 0 THEN CALL placearmy(i)
'next i
END SUB

SUB maptext
FOR k = 1 TO ncity
	FOR j = 1 TO LEN(city$(k))
	a = cityx(k) + 6 * (j - 4) - 3
	c = ASC(MID$(UCASE$(city$(k)), j, 1)) - 64
	IF a > 527 GOTO nextc
	SELECT CASE k
		CASE 1
		x = a - 14: y = cityy(k) - 15
		CASE 6
		x = a - 6: y = cityy(k) - 10
		CASE 7
		x = a - 20: y = cityy(k) - 5
		CASE 10
		x = a - 10: y = cityy(k) + 15
		CASE 11, 28
		x = a - 20: y = cityy(k) - 10
		CASE 17, 29
		x = a + 26: y = cityy(k) + 6
		CASE 9, 32
		x = a - 2: y = cityy(k) + 16
		CASE 14, 23, 37, 38, 44, 49
		x = a - 20: y = cityy(k) + 6
		CASE 27
		x = a + 8: y = cityy(k) + 12
		CASE 20, 39, 54
		x = a + 10: y = cityy(k) + 25
		CASE 45, 46, 53
		x = a - 6: y = cityy(k) - 10
		CASE ELSE
		x = a: y = cityy(k) + 12
	END SELECT

	z = POINT(x, y)
	PSET (x, y), z
	IF matrix(k, 7) < 90 THEN DRAW "S4C0" ELSE DRAW "C10"
	IF c > 0 AND c < 27 THEN DRAW font$(c)
	NEXT j
nextc:
NEXT k
END SUB

DEFSNG A-Z
SUB TICK (sec!)
start! = TIMER
DO WHILE TIMER - start! < sec! AND INKEY$ = "": LOOP
END SUB

