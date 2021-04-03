DEFINT A-Z
DECLARE SUB battleship ()
DECLARE SUB boxes (y%)
DECLARE SUB canimove (index%, flag%)
DECLARE SUB center (y%, a$)
DECLARE SUB choices (wide%)
DECLARE SUB citygraf (index%, flag%)
DECLARE SUB deadplane (who%)
DECLARE SUB gcirc (xc%, flag%)
DECLARE SUB ikhan (index%)
DECLARE SUB maptext ()
DECLARE SUB Mickey (a$, lButton%, rButton%, xc%, yc%)
DECLARE SUB MouseBorder (row1%, col1%, row2%, col2%)
DECLARE SUB mxw (wide%)
DECLARE SUB showmove (who%)
DECLARE SUB showtek (who%, k%)
DECLARE SUB submarine (flag%)
' $INCLUDE: 'ww2.bi'
'============================================================================
'                GENmenu 3.05 : Generic Menu Main Module Level  12/91
'                Updated to Use Graphic Screens 8, 9, 12
'============================================================================
'       tlx  = top left x  (if zero, automatically centered)
'       tly = top left y   (if zero, automatically centered)
'       size = # rows (current maximum=20)
'       mtx$() = text for menu
'                mtx$(0) = heading (blank defaults to M E N U)
'                mtx$(1-size) are options
'       choose = option selected (row #)
'            -1 returned if ESC key pressed
'            entering with choose+21 causes choose to be default entry
'       wtype = window type (0 = no line; 1=single line;
'                            2=double line

SUB airforce (who, chx)
DIM number(2)
IF airloc(who) > 0 THEN CALL hangar
cost = 70 - 5 * teklev(who, 8)
IF chx = 1 AND cash(who) < cost THEN
	IF airsize(who) > 0 THEN
		IF cntrl(who) < 40 THEN chx = 2 ELSE chx = 3
	ELSE
		EXIT SUB
	END IF
END IF
IF chx = 3 AND navysize(3 - who) < 1 THEN chx = 4
flaps:
'.................. does enemy need to move his planes ? ...................
IF chx > 0 THEN
	IF weather = 4 THEN
	chx = 1
	IF cost > cash(who) THEN EXIT SUB
	GOTO runway
	END IF
	IF occupied(airloc(who)) = 0 THEN CALL void(airloc(who), defend)
	IF defend > 0 THEN flag = 2: chx = 4
END IF
'............................................................................
runway:
IF chx = 1 AND cash(who) < cost THEN chx = chx + 1: IF chx > 4 THEN EXIT SUB
mtx$(0) = "Planes"
mtx$(1) = "Build": IF cash(who) < cost OR airsize(who) > 9 THEN mtx$(1) = "-": choose = 23
mtx$(2) = "City Bomb": IF airsize(who) < 1 THEN mtx$(2) = "-"
mtx$(3) = "Navy Atk": IF airsize(who) < 1 OR navysize(3 - who) < 1 THEN mtx$(3) = "-"
mtx$(4) = "AirBase": IF airsize(who) < 1 THEN mtx$(4) = "-"
tlx = 67: tly = 15: size = 4

DEF SEG = VARSEG(graphic(1))
BLOAD "airk.vga", VARPTR(graphic(1))
DEF SEG
PUT (560, 100), graphic, PSET
x = cityx(airloc(who)): y = cityy(airloc(who))
LINE (x, y - 6)-(x + 8, y - 14), 14, BF
CALL hangar
c = 9 + (who = 2)
COLOR 14
LOCATE 12, 68: PRINT airsize(who); " Planes"
LOCATE 6, 68: PRINT "Air Force"
COLOR 15
LOCATE 13, 68: PRINT "Location:"
LOCATE 14, 68: PRINT city$(airloc(who))
IF teklev(who, 7) > 2 THEN LOCATE 3, 68: PRINT "ALL WEATHER"
LINE (528, 62)-(635, 228), c, B
COLOR c: LOCATE 5, 68: PRINT force$(who)
IF chx > 0 THEN choose = chx: GOTO action

colour = 3: hilite = 15
IF who = side AND airloc(side) > 0 THEN CALL gcirc(airloc(side), 15)
CALL menu(10): CALL clrrite

action:
a = 0
IF aflag > 1 AND choose <> 1 THEN EXIT SUB
SELECT CASE choose
'...........................................................................
	CASE IS < 0
	IF who = side THEN CALL gcirc(airloc(side), 2): EXIT SUB
	CASE 1
	IF cash(who) < cost AND airsize(who) < 10 GOTO flaps
	IF airsize(who) > 9 THEN
		IF chx = 1 THEN
			IF weather < 4 THEN chx = 2: GOTO flaps
			EXIT SUB
		END IF
	END IF
	IF airsize(who) < 1 THEN
		airloc(who) = 0
		mtx$(0) = "Air Base"
		size = 0: tlx = 67: tly = 2: max = 32767
	FOR i = 1 TO ncity - 2
		IF cityp(i) = who AND size < 20 THEN size = size + 1: mtx$(size) = city$(i): array(size) = i
	NEXT i
	IF chx = 1 AND size < 1 THEN EXIT SUB
	IF chx = 1 THEN
		FOR j = 1 TO size
			x = ABS(cityy(array(j)) - cityy(capcity(3 - who))) + ABS(cityx(array(j)) - cityx(capcity(3 - who)))
			IF x < max THEN
				CALL void(array(j), defend)
				IF defend < 3 * armysize(occupied(array(j))) THEN max = x: choose = j
			END IF
		NEXT j
		airloc(who) = array(choose): GOTO tower
	END IF
	IF size < 1 THEN CALL clrbot: PRINT "NO AIRBASE LOCATIONS AVAILABLE !"; : EXIT SUB
	IF chx = 0 THEN CALL menu(2): CALL clrrite
	IF choose < 0 THEN EXIT SUB
	airloc(who) = array(choose)
	CALL hangar
tower:
	END IF
	airsize(who) = airsize(who) + 1
	IF pbm > 0 THEN pbm = 11
	c = 9: IF who > 1 THEN c = 8
	CALL image2(STR$(airsize(who)) + " " + force$(who) + " planes in " + city$(airloc(who)), c)
	cash(who) = cash(who) - cost
	GOTO flaps
'...........................................................................
	CASE 2
		IF airsize(who) < 1 THEN EXIT SUB
		IF chx = 0 THEN
			LINE (620, 190)-(635, 210), 8, BF
			LINE (620, 200)-(635, 200), 15
			CIRCLE (580, 200), 40, 3, , , .3
			CIRCLE (580, 200), 40, 3, 4, 6.2, .1
			LINE (553, 192)-(553, 208), 3
			PAINT (580, 200), 3, 3
			PAINT (580, 210), 8, 3
			PAINT (545, 200), 4, 3
		END IF
		mtx$(0) = "City Bomb"
aack:
		c = 1: GOSUB norden
		IF chx = 0 AND (x1 < 1 OR x1 > ncity) GOTO flaps
		IF x1 > 56 THEN CALL clrbot: PRINT "Cannot bomb "; city$(x1); : TICK 2: GOTO flaps
		IF cityp(x1) = who GOTO flaps
		CALL sndfx(5)
		a$ = force$(who) + " planes attack " + city$(x1)
		CALL image2(a$, 4)
		CALL news(a$)
		CALL icon(x1, 0, 3)
'................................dogfight................................
		IF airloc(3 - who) = x1 THEN
dogfight:
			LINE (110, 110)-(435, 210), 0, BF
			LINE (100, 100)-(425, 200), 5, BF
			LINE (100, 150)-(425, 150), 15
			LINE (100, 100)-(425, 200), 15, B
			COLOR 15
			LOCATE 8, 15: PRINT force$(who)
			LOCATE 11, 15: PRINT force$(3 - who)

			FOR k = 1 TO airsize(who)
			PSET (154 + 24 * k, 117), 2
			GOSUB fuselage
			LOCATE 9, 19 + 3 * k: PRINT 1 + teklev(who, 7)
			NEXT k

			number(who) = airsize(who)
			IF y1 > 0 THEN
				hp(3 - who) = 2 + teklev(3 - who, 4) + teklev(3 - who, 5)
				IF teklev(3 - who, 5) > 2 THEN hp(3 - who) = hp(3 - who) + 3
				number(3 - who) = navysize(3 - who)
			ELSE
				hp(3 - who) = 1 + teklev(3 - who, 7)
				number(3 - who) = airsize(3 - who)
			END IF

			FOR k = 1 TO number(3 - who)
			PSET (154 + 24 * k, 167), 2
			IF y1 > 0 THEN
				CALL shipicon(3 - who)
				LOCATE 12, 19 + 3 * k: PRINT 2 + teklev(3 - who, 4) + teklev(3 - who, 5)
			ELSE
				LOCATE 12, 19 + 3 * k: PRINT 1 + teklev(3 - who, 7)
				GOSUB fuselage
			END IF
			NEXT k
			hp(who) = 1 + teklev(who, 7)
			IF chx > 0 THEN
				a$ = force$(who) + " planes attack " + force$(3 - who)
				t$ = "airforce": IF chx = 3 THEN t$ = "navy"
				CALL image2(a$ + " " + t$, 4)
				CALL news(a$ + t$)
			ELSE
				TICK -2
			END IF
gunner:
			y = 9: lose = who: IF RND > .5 THEN lose = 3 - who: y = 12
			IF teklev(lose, 7) > 2 AND RND > .5 GOTO gunner
			hp(lose) = hp(lose) - 1
			LOCATE y, 19 + 3 * number(lose): PRINT hp(lose)
			IF hp(lose) < 1 THEN
				CALL sndfx(8)
				CIRCLE (156 + 24 * number(lose), 167 + 50 * (lose = who)), 8, 4
				PAINT (156 + 24 * number(lose), 167 + 50 * (lose = who)), 4, 4
				TICK .2
				number(lose) = number(lose) - 1
				IF y1 = 0 OR lose = who THEN
					airsize(lose) = airsize(lose) - 1
				ELSE
					navysize(lose) = navysize(lose) - 1
				END IF
				IF number(lose) < 1 THEN
					IF y1 = 0 OR who = lose THEN airsize(lose) = 0: CALL deadplane(lose): GOTO skies
					a$ = force$(lose) + " Navy is destroyed!"
					c = 8: IF lose = 2 THEN c = 1
					CALL image2(a$, 4)
					CALL news(a$)
					navysize(lose) = 0: GOTO skies
				END IF
				IF y1 = 0 OR lose = who THEN
					hp(lose) = 1 + teklev(lose, 7)
				ELSE
					hp(lose) = 2 + teklev(lose, 4) + teklev(lose, 5)
				END IF
				victory&(3 - lose) = victory&(3 - lose) + 2
			END IF
			GOTO gunner
skies:
		CALL europe(0)
		aflag = aflag + 1: IF teklev(who, 7) < 3 THEN aflag = 2
		EXIT SUB
		END IF
'............................................................................
		IF occupied(x1) > 0 AND fort(x1) = 0 THEN target = occupied(x1): GOTO hasmen
		CALL sndfx(8)
		aflag = aflag + 1: IF teklev(who, 7) < 3 THEN aflag = 2

		CALL clrbot
		IF x1 <> capcity(3 - who) THEN
defy:
			t = 0: IF fort(x1) > 2 THEN t = 12
			IF RND < .5 + .1 * (airsize(who) + 2 * teklev(who, 7) - 2 * fort(x1) - t) THEN
				IF fort(x1) > 0 THEN
blastfort:
				CALL clrbot: PRINT city$(x1); " fortifications damaged";
				fort(x1) = fort(x1) - 1: x = cityx(x1): y = cityy(x1)
				LINE (x - 6, y - 6)-(x + 6, y + 6), 2, BF
				CALL showcity(x1)
				TICK turbo!
				EXIT SUB
				END IF

				PRINT city$(x1); " has been Neutralized by bombing";
				cityp(x1) = 0
				CALL flashcity(x1)
				IF x1 = airloc(3 - who) THEN CALL deadplane(3 - who)
				TICK turbo!
				EXIT SUB
			ELSE
				GOTO shotdown
			END IF
		ELSE
			IF RND < .1 + teklev(who, 7) + .05 * airsize(who) THEN
				IF fort(x1) > 0 GOTO blastfort
				PRINT force$(3 - who); " production technology damaged";
				IF teklev(3 - who, 8) > 0 THEN teklev(3 - who, 8) = teklev(3 - who, 8) - 1
				TICK turbo!
				aflag = aflag + 1: IF teklev(who, 7) < 3 THEN aflag = 2
				EXIT SUB
			ELSE
shotdown:
				a = a + 1
				CALL clrbot
				pct! = .5 + .2 + .05 * (teklev(who, 7) - teklev(3 - who, 7)) - .1 * fort(x1) - .05 * ABS(occupied(x1) > 0)
				IF pct! < .1 THEN pct! = .1
				IF pct! > .9 THEN pct! = .9
				IF RND > pct! THEN
					DEF SEG = VARSEG(graphic(1))
					BLOAD "shotd.vga", VARPTR(graphic(1))
					DEF SEG
					PUT (560, 100), graphic, PSET
					CALL sndfx(8)
					airsize(who) = airsize(who) - 1
					COLOR 14: LOCATE 12, 68: PRINT airsize(who); " Planes "
					CALL clrbot
					PRINT force$(who) + " forces have lost " + STR$(a) + " plane(s) in raid on "; city$(x1); : TICK .3
					TICK -2
					IF airsize(who) < 1 THEN
						CALL deadplane(who)
						EXIT SUB
					END IF
					GOTO defy
				END IF
				CALL image2(city$(x1) + " not damaged !", 5)

			END IF
		END IF
		EXIT SUB
'.................................target is occupied, so tactical...........
hasmen:
		z = 0
		CALL icon(armyloc(target), 0, 3)
		x1 = 2 * (teklev(who, 7) - teklev(3 - who, 2)) * SQR(airsize(who)) + 5 * RND
		IF fort(armyloc(target)) = 3 THEN                       'A/A fire
			IF RND > .1 + .1 * teklev(who, 3) GOTO shotdown
			x1 = x1 - 3
		END IF
		IF teklev(who, 3) > 2 THEN x1 = .1 * x1
		IF armyexper(target) < 3 THEN x1 = 2 * x1
		t = unittype(target)
		a$ = ""
		SELECT CASE t
			CASE 2, 4
				x1 = .7 * x1
		END SELECT
		IF armyexper(target) > 6 THEN x1 = .5 * x1

		CALL icon(armyloc(target), armymove(target), 4)
		IF 6 * RND < x1 THEN
			armymove(target) = -1
			a$ = "have PINNED"
		END IF

		IF a$ = "" THEN a$ = "destroyed supplies of": supply(target) = 0

		IF x1 > .05 * armysize(target) THEN x1 = .05 * armysize(target)
		IF unittype(target) = 5 THEN x1 = .3 * armysize(target)
		IF x1 < 5 THEN x1 = 1 + 4 * RND
		IF x1 >= armysize(target) THEN x1 = armysize(target) - 1

		CALL clrbot
		PRINT force$(who); " Planes "; a$; " "; : MONIKER (target): PRINT " (Casualties:"; RTRIM$(STR$(x1)) + "00 )";
		CALL sndfx(8)
		armysize(target) = armysize(target) - x1
		IF armysize(target) < 1 THEN armysize(target) = 1
		aflag = aflag + 1: IF teklev(who, 7) < 3 THEN aflag = 2
		CALL TICK(-turbo!)
		CALL clrrite
		EXIT SUB
'.........................................attack navy.......................
	CASE 3
		IF chx = 3 THEN chx = 4
		IF navysize(3 - who) < 1 GOTO runway
		CALL airdist(who, 99, d)
		IF d < 1 THEN
			IF who = side THEN CALL clrbot: PRINT "Enemy navy out of range"; : TICK 1: CALL clrbot
			GOTO runway
		END IF
		y1 = 1
		GOTO dogfight
'.........................................move airbase......................
	CASE 4
	CALL clrbot
'............................................................................
	IF chx > 0 THEN
		IF who = 1 AND cityx(airloc(who)) < 110 AND cityy(airloc(who)) < 60 THEN flag = 1
		zmax = 32767: x1 = 0
		FOR k = 1 TO ncity - 2
			c = ABS(cityx(k) - cityx(capcity(3 - who))) + ABS(cityy(k) - cityy(capcity(3 - who)))
			IF cityp(k) = who AND c < zmax THEN
				CALL airdist(who, k, d)
				IF occupied(k) = 3 - who THEN d = 0
				CALL void(k, defend): IF defend > 0 THEN d = 0
				IF d > 0 THEN
					IF flag = 0 OR flag = 2 THEN
						zmax = c: x1 = k
					ELSE
						IF cityx(k) > 110 OR cityy(k) > cityy(airloc(who)) THEN zmax = c: x1 = k
					END IF
				END IF
			END IF
		NEXT k
		IF x1 > 0 GOTO newbase
		GOTO aack
		EXIT SUB
	END IF
'............................................................................
	mtx$(0) = "AirBase"
		utility1 = 4
		IF who = side THEN xc = airloc(side)
		c = 0: GOSUB norden
		IF who = side THEN CALL gcirc(xc, 2)
		IF cityp(x1) <> side THEN x1 = 0
		IF chx = 0 AND (x1 < 1 OR x1 > ncity) THEN CALL clrbot: PRINT "ILLEGAL CHOICE for new AirBase"; : GOTO flaps
newbase:
		a$ = force$(who) + " AIRBASE moved to " + city$(x1)
		CALL image2(a$, 5)
		CALL news(a$)
		IF sblast$ <> "" THEN CALL sndblst("engine.voc", 0)
		x = cityx(airloc(who)): y = cityy(airloc(who))
		CALL citygraf(airloc(who), c)
		LINE (x, y - 6)-(x + 8, y - 14), c, BF
		airloc(who) = x1
		CALL hangar
		aflag = aflag + 1: IF teklev(who, 7) < 3 THEN aflag = 2
		IF noise > 0 AND sblast$ = "" THEN SOUND 1200, 1: SOUND 900, 1
		CALL clrrite
	CASE 4
		
	CASE ELSE
		y = 0
		CALL starfin(star, fin, 3 - who)
		DO
		target = star + RND * (fin - star)
		y = y + 1
		LOOP UNTIL y > 99 OR armysize(target) > 0
		IF armysize(target) = 0 GOTO flaps
	END SELECT
EXIT SUB
norden:
	SELECT CASE chx
		CASE 0
			FOR k = 1 TO ncity - 2
			IF (utility1 < 4 AND cityp(k) = 3 - side) OR (utility1 = 4 AND cityp(k) = side) THEN
					CALL airdist((side), k, d)
					IF d > 0 THEN x1 = k: EXIT FOR
			END IF
			NEXT k
			utility1 = 2
			IF x1 > 0 THEN CALL newcity(x1, c) ELSE CALL clrbot: PRINT "NO TARGETS WITHIN RANGE"; : TICK 2: clrrite
		CASE ELSE
			spin = 9
retarg:
			x1 = 0
			FOR j = 1 TO 2
			FOR k = 1 TO ncity - 2
				CALL airdist((3 - side), k, d)
				IF d > 0 THEN
					IF j = 1 THEN
						IF cityp(k) = 3 - who AND occupied(k) > 0 THEN x1 = k: EXIT FOR
					ELSE
						IF cityp(k) = 3 - who THEN x1 = k: IF RND > .7 THEN EXIT FOR
					END IF
				END IF
			NEXT k
			NEXT j
			IF x1 = 0 THEN
				spin = spin - 1: IF spin < 1 THEN CALL clrrite: EXIT SUB
				GOTO retarg
			END IF
	END SELECT
RETURN
fuselage: DRAW "C11R3U3R1C8D3R3D1L3D3R1L1C11L2R1U3L3BR5C0R3U1BL3U3BD5D1BR1D2L4BU4L2": RETURN
END SUB

SUB battleship
SCREEN 12
LINE (1, 2)-(633, 223), 3, BF
LINE (633, 224)-(1, 321), 1, BF
COLOR 7
LINE (568, 128)-(531, 176): LINE -(510, 204): LINE -(498, 227)
LINE -(490, 252): LINE -(485, 272): LINE -(483, 286): LINE -(451, 287)
LINE -(435, 283): LINE -(419, 270): LINE -(401, 260): LINE -(385, 259)
LINE -(363, 262): LINE -(336, 263): LINE -(328, 257): LINE -(315, 250)
LINE -(304, 252): LINE -(290, 252): LINE -(288, 253): LINE -(273, 252)
LINE -(265, 245): LINE -(244, 247): LINE -(226, 248): LINE -(213, 245)
LINE -(202, 240): LINE -(190, 239): LINE -(178, 237): LINE -(162, 235)
LINE -(146, 233): LINE -(127, 231): LINE -(111, 228): LINE -(92, 226)
LINE -(92, 227): LINE -(79, 226): LINE -(72, 221): LINE -(66, 211)
LINE -(66, 203): LINE -(124, 203): LINE -(124, 203): LINE -(252, 193)
LINE -(387, 173)
LINE -(568, 128)
PAINT (364, 211), 8, 7
LINE (220, 196)-(220, 165): LINE -(220, 135): LINE -(198, 135)
LINE -(192, 135): LINE -(192, 123): LINE -(222, 123): LINE -(222, 98)
LINE -(228, 85): LINE -(229, 67): LINE -(244, 67): LINE -(244, 76)
LINE -(256, 83): LINE -(256, 83): LINE -(258, 92): LINE -(244, 94)
LINE -(245, 112): LINE -(260, 120): LINE -(260, 129): LINE -(240, 132)
LINE -(241, 150): LINE -(241, 150): LINE -(262, 153): LINE -(267, 192)
PAINT (236, 174), 8, 7
LINE (236, 68)-(236, 2)
LINE (240, 2)-(240, 67)
LINE (241, 2)-(236, 2)
PAINT (240, 53), 8, 7
PAINT (239, 52), 8, 7
LINE (205, 109)-(264, 116), 8, BF
LINE (211, 82)-(265, 92), 8, BF
LINE (194, 127)-(290, 132), 8, BF
LINE (247, 131)-(255, 173), 8, BF
CIRCLE (239, 30), 12, 8
LINE (287, 188)-(287, 182): LINE -(274, 181): LINE -(269, 175)
LINE -(273, 163): LINE -(338, 154): LINE -(338, 154): LINE -(350, 167)
LINE -(351, 166): LINE -(349, 174): LINE -(331, 179): LINE -(331, 181)
LINE -(331, 181)
PAINT (308, 173), 8, 7
LINE (368, 176)-(362, 168): LINE -(364, 162): LINE -(365, 161)
LINE -(423, 145): LINE -(423, 145): LINE -(441, 154): LINE -(441, 154)
LINE -(440, 159)
PAINT (406, 162), 8, 7
LINE (181, 146)-(212, 197), 8, BF
LINE (176, 198)-(147, 196), 8, BF
LINE (132, 203)-(123, 199), 8, BF
LINE (201, 184)-(234, 194), 0, BF
LINE (96, 204)-(104, 201), 0, BF
LINE (178, 172)-(196, 178), 0, BF
LINE (212, 158)-(238, 164), 0, BF
LINE (258, 184)-(280, 188), 0, BF
LINE (232, 138)-(264, 145), 0, BF
LINE (331, 179)-(363, 176), 0, BF
COLOR 0
LINE (567, 130)-(539, 166): LINE -(539, 166): LINE -(512, 202)
LINE -(512, 202): LINE -(501, 222): LINE -(496, 239)
LINE -(491, 256): LINE -(487, 270): LINE -(500, 246)
LINE -(508, 223): LINE -(521, 204): LINE -(533, 184)
LINE -(567, 130)
PAINT (520, 202), 0, 0
LINE (161, 197)-(174, 155), 8, BF
LINE (168, 165)-(178, 197), 8, BF
LINE (156, 92)-(189, 92), 8
LINE (218, 45)-(255, 45), 8

LINE (363, 170)-(352, 171), 7: LINE -(352, 171), 7

COLOR 9
LINE (424, 283)-(410, 272): LINE -(396, 269): LINE -(380, 268)
LINE -(358, 272): LINE -(331, 274): LINE -(363, 278): LINE -(380, 276)
LINE -(403, 284): LINE -(433, 293): LINE -(433, 293): LINE -(446, 290)
LINE -(424, 283)
PAINT (401, 280), 9, 9
LINE (315, 258)-(308, 254): LINE -(299, 255): LINE -(287, 258)
LINE -(275, 258): LINE -(266, 252): LINE -(256, 251): LINE -(243, 254)
LINE -(242, 254): LINE -(230, 253): LINE -(217, 256): LINE -(227, 258)
LINE -(240, 256): LINE -(240, 256): LINE -(244, 259): LINE -(259, 259)
LINE -(265, 260): LINE -(271, 266): LINE -(285, 266): LINE -(296, 261)
LINE -(307, 263): LINE -(321, 268): LINE -(331, 266)
LINE -(315, 258)
PAINT (303, 260), 3, 9
LINE (197, 248)-(180, 241): LINE -(169, 243): LINE -(150, 240)
LINE -(132, 236): LINE -(93, 232): LINE -(148, 243): LINE -(165, 245)
LINE -(181, 252): LINE -(182, 253): LINE -(197, 250)
LINE -(197, 248)
PAINT (182, 250), 9, 9
LINE (32, 239)-(73, 236): LINE -(82, 245): LINE -(109, 249)
LINE -(122, 254): LINE -(97, 254): LINE -(71, 249): LINE -(61, 243)
LINE -(32, 239)
PAINT (70, 242), 9, 9
LINE (289, 320)-(238, 300): LINE -(217, 302): LINE -(173, 300)
LINE -(141, 292): LINE -(100, 296): LINE -(128, 305): LINE -(155, 313)
LINE -(199, 311): LINE -(208, 319)
LINE -(289, 320)
PAINT (243, 313), 9, 9
LINE (1, 270)-(30, 274): LINE -(38, 284): LINE -(57, 293)
LINE -(85, 300): LINE -(53, 298): LINE -(35, 293): LINE -(33, 292)
LINE -(17, 287): LINE -(2, 290)
LINE -(1, 270)
PAINT (18, 281), 9, 9
LINE (366, 303)-(433, 303): LINE -(460, 313): LINE -(506, 315)
LINE -(537, 312): LINE -(535, 303): LINE -(558, 304): LINE -(580, 315)
LINE -(565, 317): LINE -(545, 318): LINE -(545, 318): LINE -(455, 318)
LINE -(455, 318): LINE -(418, 309)
LINE -(366, 303)
PAINT (439, 311), 9, 9
LINE (305, 300)-(278, 282): LINE -(259, 284): LINE -(242, 282)
LINE -(274, 295)
LINE -(305, 300)
PAINT (282, 295), 9, 9
LINE (525, 235)-(547, 239), 11
LINE (586, 245)-(608, 250): LINE -(598, 251): LINE -(578, 245)
LINE -(586, 245)
PAINT (591, 248), 9, 9
LINE (141, 268)-(202, 285): LINE -(167, 272): LINE -(166, 272)
LINE -(146, 269): LINE -(145, 269)
LINE (12, 260)-(65, 270)
LINE (511, 262)-(567, 266): LINE -(589, 274): LINE -(626, 279)
LINE -(615, 283): LINE -(578, 275): LINE -(554, 274): LINE -(506, 267)
LINE -(494, 261): LINE -(494, 261): LINE -(497, 254)
LINE -(511, 262)
PAINT (547, 272), 9, 9

COLOR 7
LINE (339, 155)-(379, 153): LINE -(379, 153): LINE -(383, 157)
LINE -(383, 157)
LINE (365, 171)-(349, 173): LINE -(350, 172)
PAINT (358, 165), 7, 7
LINE (424, 146)-(481, 147): LINE -(481, 147): LINE -(481, 151)
LINE -(440, 155): LINE -(440, 155)
PAINT (452, 153), 7, 7
LINE (441, 161)-(441, 155), 0: LINE -(441, 155), 0: LINE -(481, 151), 0
LINE -(481, 151), 0
LINE -(441, 161), 0
PAINT (446, 157), 0, 0

LINE (345, 175)-(332, 180): LINE -(332, 180): LINE -(367, 177)
LINE -(367, 177)
PAINT (359, 175), 0, 7

COLOR 8
'                        forward turret
LINE (433, 149)-(483, 117): LINE -(483, 117): LINE -(487, 119)
LINE -(488, 119): LINE -(443, 149): LINE -(443, 149): LINE -(451, 149)
LINE -(451, 149): LINE -(494, 123): LINE -(494, 123): LINE -(498, 125)
LINE -(498, 125): LINE -(462, 149): LINE -(462, 149): LINE -(474, 148)
LINE -(474, 148): LINE -(508, 127): LINE -(513, 129): LINE -(482, 149)
LINE -(482, 149): LINE -(450, 154)
LINE -(433, 149)
PAINT (461, 149), 8, 8
LINE (162, 198)-(134, 194), 8, BF
LINE (135, 196)-(114, 186): LINE -(114, 186): LINE -(118, 187)
LINE -(135, 195): LINE -(135, 195): LINE -(142, 195): LINE -(126, 188)
LINE -(126, 188): LINE -(121, 187): LINE -(141, 194): LINE -(147, 194)
LINE -(132, 188): LINE -(132, 188)
COLOR 15
LINE (202, 182)-(208, 184)
LINE (210, 180)-(219, 184)
LINE (174, 171)-(180, 174)
LINE (181, 170)-(187, 174)
LINE (224, 137)-(236, 144)
LINE (235, 135)-(240, 140)
COLOR 7
LINE (265, 184)-(273, 184): LINE -(273, 178)
LINE (275, 164)-(269, 152): LINE -(261, 154)
PAINT (269, 162), 7, 7
LINE (261, 154)-(261, 148): LINE -(272, 148): LINE -(272, 140)
LINE -(264, 139): LINE -(263, 139): LINE -(264, 146): LINE -(254, 146)
LINE -(256, 153)
PAINT (269, 146), 7, 7
LINE (278, 127)-(291, 134), 7, BF
LINE (262, 110)-(270, 116), 7, BF
LINE (243, 95)-(254, 109), 7, BF
LINE (266, 84)-(271, 93), 7, BF
LINE (244, 68)-(249, 82), 7, BF
LINE (183, 149)-(212, 140), 8
LINE -(212, 149), 8
PAINT (206, 144), 8, 8

COLOR 0
'               smoke
LINE (192, 146)-(176, 141): LINE -(179, 136): LINE -(168, 136)
LINE -(156, 132): LINE -(156, 130): LINE -(148, 125): LINE -(144, 132)
LINE -(136, 132): LINE -(116, 127): LINE -(109, 123): LINE -(92, 121)
LINE -(85, 126): LINE -(79, 122): LINE -(90, 119): LINE -(91, 117)
LINE -(95, 113): LINE -(106, 117): LINE -(110, 112): LINE -(110, 107)
LINE -(120, 114): LINE -(124, 115): LINE -(133, 117): LINE -(159, 117)
LINE -(160, 122): LINE -(168, 115): LINE -(176, 115): LINE -(184, 122)
LINE -(192, 126): LINE -(191, 129): LINE -(196, 136): LINE -(201, 139)
LINE -(200, 144)
LINE -(192, 146)
PAINT (189, 136), 0, 0
LINE (79, 200)-(85, 205): LINE -(85, 205): LINE -(88, 201)
LINE (94, 198)-(98, 203)
LINE (101, 198)-(102, 202)
LINE (157, 194)-(151, 191)
LINE (134, 199)-(160, 201), 0, BF
LINE (171, 191)-(184, 197), 0, BF
LINE (112, 204)-(120, 200), 0, BF

LINE (172, 82)-(174, 161), 8, BF

LINE (229, 15)-(237, 19), 4, BF
LINE (215, 35)-(214, 39), 4, BF
LINE (205, 50)-(208, 52), 5, BF
LINE (219, 29)-(225, 32), 5, BF
LINE (192, 72)-(195, 73), 9, BF
LINE (178, 85)-(181, 84), 10, BF

LINE (206, 155)-(213, 158), 15
LINE (216, 154)-(225, 158), 15
LINE (271, 156)-(277, 152), 15
LINE (262, 127)-(268, 123), 15
COLOR 8
LINE (345, 157)-(386, 126): LINE -(386, 126): LINE -(388, 128)
LINE -(354, 156): LINE -(362, 155): LINE -(363, 155): LINE -(394, 130)
LINE -(394, 130): LINE -(397, 131): LINE -(371, 155): LINE -(371, 155)
LINE -(377, 154): LINE -(406, 131): LINE -(409, 133): LINE -(383, 155)
LINE -(383, 155): LINE -(358, 161): LINE -(358, 161): LINE -(346, 158)
LINE -(346, 158)
LINE -(345, 157)
PAINT (352, 158), 8, 8
LINE (483, 118)-(487, 120), 0, BF
LINE (494, 124)-(498, 126), 0, BF
LINE (509, 128)-(512, 130), 0, BF
LINE (406, 133)-(409, 133), 0, BF
LINE (394, 130)-(397, 132), 0, BF
LINE (385, 127)-(389, 128), 0, BF
LINE (486, 267)-(482, 285), 0: LINE -(460, 287), 0: LINE -(445, 285), 0
LINE -(436, 283), 0: LINE -(423, 273), 0: LINE -(417, 269), 0
LINE -(485, 269), 0
PAINT (462, 277), 0, 0
PSET (500, 170), 8
DRAW "S4C7E10H3G5H2U2E8R2F14D2G7L2H2E4H3G10H4"
PAINT (502, 170), 0, 7
LINE (1, 1)-(633, 321), 11, B
END SUB

SUB choices (wide)
	LINE (8 * tlx + 2, 16 * tly - 5)-(8 * (tlx + wide + 2) + 7, 16 * (tly + size + 2) + 15), 0, BF
	LINE (8 * tlx - 2, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + size + 2) + 8), colour, B
	LINE (8 * tlx + 1, 16 * (tly + 1) + 3)-(8 * (tlx + wide + 1) + 3, 16 * (tly + 1) + 6), colour, B
	LINE (8 * tlx + 1, 16 * tly - 8)-(8 * (tlx + wide + 1) + 3, 16 * (tly + size + 2) + 4), colour, B

	COLOR colour

	LOCATE tly + 1, tlx + INT(.5 * (wide - LEN(mtx$(0))) + .5) + 1: PRINT mtx$(0)

	FOR i = 1 TO size
	LOCATE tly + 2 + i, tlx + 2: PRINT mtx$(i)
	NEXT i
	COLOR 11
	IF f3key > 0 THEN
		LOCATE 27, 68: PRINT "F1=Help"
		LOCATE 28, 68: PRINT "F7=End Turn";
	END IF
END SUB

SUB europe (flag)
carto:
SCREEN 12
CLS
LINE (0, 0)-(525, 438), 10, B
SELECT CASE weather
	CASE 2
	a = 63: x = 40: y = 0
	CASE 3
	a = 10: x = 10: y = 30
	CASE 4
	a = 30: x = 10: y = 10
	CASE ELSE
	a = 0: x = 34: y = 0
END SELECT
PAINT (200, 200), 2, 10

cn& = 65536 * a + 256 * x + y
PALETTE 2, cn&

LINE (2, 66)-(27, 90), 3, BF: LINE (2, 66)-(27, 90), 10, B
LINE (478, 68)-(522, 95), 3, BF: LINE (478, 68)-(522, 95), 10, B
'.................................France.....& North Sea Coast..............
PSET (1, 240), 10
OPEN "I", 1, "europe.grf"
FOR k = 1 TO 7: INPUT #1, a$: DRAW a$: NEXT k
'..................................Spain.......................
PSET (1, 411), 10
FOR k = 1 TO 2: INPUT #1, a$: DRAW a$: NEXT k
'......................Sardinia.............................................
PSET (246, 371), 10
INPUT #1, a$: DRAW a$
'......................Corsica.............................................
PSET (267, 300), 1
FOR k = 1 TO 2: INPUT #1, a$: DRAW a$: NEXT k
'......................Balearic Islands.....................................
PSET (110, 372), 10
INPUT #1, a$: DRAW a$
PSET (100, 369), 10
INPUT #1, a$: DRAW a$
PSET (128, 357), 10
INPUT #1, a$: DRAW a$
'......................Sicily................................................
PSET (319, 413), 10
FOR k = 1 TO 2: INPUT #1, a$: DRAW a$: NEXT k
'......................Italy................................................
PSET (345, 416), 10
FOR k = 1 TO 3: INPUT #1, a$: DRAW a$: NEXT k
PSET (346, 416), 10
INPUT #1, a$: DRAW a$
'......................Yugoslavia...........................................
PSET (353, 235), 10
FOR k = 1 TO 2: INPUT #1, a$: DRAW a$: NEXT k
'...........................Baltic Shoreline.................................................
PSET (247, 17), 10
FOR k = 1 TO 6: INPUT #1, a$: DRAW a$: NEXT k
'................................Britain...........................................
PSET (100, 1), 10
FOR k = 1 TO 4: INPUT #1, a$: DRAW a$: NEXT k
'........................Greece & Yugoslavia..........................
PSET (443, 438), 10
FOR k = 1 TO 2: INPUT #1, a$: DRAW a$: NEXT k
'...................Africa.............................................
PSET (1, 421), 10
FOR k = 1 TO 2: INPUT #1, a$: DRAW a$: NEXT k
CLOSE #1
'.......................................................................
LINE (472, 408)-(474, 412), 10, BF
LINE (468, 396)-(470, 404), 10, BF
LINE (520, 410)-(522, 412), 10, BF

PAINT (100, 100), 1, 10
PAINT (400, 20), 1, 10
PAINT (200, 350), 1, 10
PAINT (505, 415), 1, 10
PAINT (150, 430), 6, 10

LINE (138, 330)-(233, 385), 0, BF
LINE (138, 330)-(233, 385), 4, B
LINE (137, 329)-(234, 386), 15, B
LINE (145, 387)-(239, 392), 0, BF
LINE (235, 335)-(239, 392), 0, BF

IF flag > 0 THEN
	LINE (50, 100)-(475, 200), 0, BF
	LINE (42, 84)-(467, 184), 4, BF
	LINE (42, 84)-(467, 184), 15, B
	COLOR 15: CALL center(7, CHR$(34) + scenario$ + CHR$(34))
	CALL center(9, "Begin: " + mnth$(mnth) + ", " + begin$ + "  End: " + mnth$(vicflag(1)) + "," + STR$(vicflag(2)))
	COLOR 14: CALL center(11, STR$(vicflag(3)) + " cities needed for victory")
	PAINT (160, 368), 4, 15
	LOCATE 23, 20: PRINT "BRIEFING"
	TICK -99
	flag = 0
	GOTO carto
END IF

IF weather = 2 THEN
	LINE (46, 158)-(200, 195), 10: LINE -(300, 195), 10: LINE -(525, 250), 10
	PAINT (100, 300), 3, 10
	PAINT (100, 430), 3, 10
	PAINT (300, 420), 3, 10
	PAINT (260, 310), 3, 10
	PAINT (250, 350), 3, 10
END IF
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
CALL showcity(0)

CALL ships

FOR i = 1 TO ncity
IF occupied(i) > 0 THEN CALL placearmy(occupied(i))
NEXT i
FOR i = 1 TO 2
CALL stax(i)
NEXT i

COLOR 14

IF rr(1) + rr(2) > 0 THEN CALL C47
'............................................................................
IF weather = 0 THEN EXIT SUB
c = 5: IF weather > 1 THEN c = 4
LINE (138, 312)-(233, 328), c, BF
a = 8 * (21 - LEN(forecast$(weather)) \ 2)
COLOR c
FOR k = 1 TO LEN(forecast$(weather)): x = ASC(MID$(forecast$(weather), k, 1)) - 64: PSET (a + 10 * k, 324), c: DRAW "C15S8": DRAW font$(x): NEXT k
LINE (137, 311)-(234, 328), 9, B
LINE (235, 318)-(239, 334), 0, BF
END SUB

SUB evaluate (index, x)
who = 1: IF index > 30 THEN who = 2
from = armyloc(index)
IF from = capcity(who) AND index = occupied(from) THEN x = 0: EXIT SUB
x = 200: IF aggress! > 1 THEN x = 30: IF aggress! > 1.5 THEN x = 15: IF aggress! > 2 THEN x = 5
CALL void(from, defend): IF defend = 0 OR from > 56 THEN x = 0
IF bold > 2 THEN x = .5 * x

best = armysize(index)

FOR j = 1 TO 6: array(j) = -1
a = matrix(from, j)
IF a > 0 THEN IF occupied(a) > 0 AND index = occupied(from) AND aggress! < 3 THEN best = best - armysize(occupied(a)): y = 1
NEXT j: best = .01 * best
IF bold > 0 THEN best = best + 20 * bold

CALL starfin(star, fin, 3 - who)

FOR j = 1 TO 6
	y = -1: a = matrix(from, j): IF a = 0 THEN max = j - 1: GOTO alleval
	  
	c = occupied(a)
	IF a = capcity(who) AND c = 0 THEN
		CALL void(a, z)
		IF z > 0 THEN x = j: EXIT SUB
	END IF

	FOR k = star TO fin
	IF c = 0 AND a <> capcity(3 - who) AND armyloc(k) > 0 AND armymove(k) = a AND armysize(k) * (deffac(unittype(k)) + 1) > 1.5 * armysize(index) * (atkfac(unittype(index)) + 1) GOTO alle
	NEXT k
	
	y = best - x * fort(from) - cityv(from) + 30 * RND: IF fort(from) > 0 THEN IF index = occupied(from) THEN y = y - 25
	IF cityp(a) <> who THEN y = y + 5 * (cityv(a) + fort(a))

	IF cityp(a) = who GOTO ourn
	   IF c = 0 THEN y = y + 10 * cityv(a): GOTO ourn
	   x1 = 1: IF fort(a) = 1 THEN x1 = 2: IF fort(a) = 3 THEN x1 = 3
	   IF armysize(c) > 0 THEN
		odds! = (2 * armysize(index) + 10 * (atkfac(unittype(index)) + 1)) / (x1 * .02 * armysize(c) + 10 * (deffac(unittype(c)) + 1) + 1)
		IF matrix(armyloc(index), 7) > 95 AND matrix(armyloc(c), 7) > 95 THEN odds! = .8 * odds!
		IF supply(index) < 1 THEN odds! = .5 * odds!
		IF aggress! > 3 THEN
			IF odds! < 1 THEN odds! = aggress! ELSE odds! = odds! * aggress!
		END IF
	   ELSE
		odds! = 5
	   END IF
	   IF bold < 4 THEN odds! = odds! * (teklev(who, 1) + 1 + armyexper(index)) / (teklev(3 - who, 2) + 1 + armyexper(c))

	   IF armysize(index) < 15 THEN y = y - 300: odds! = .1
	   IF bold < 3 AND armysize(index) < 40 AND odds! < .8 THEN y = 0
	   IF odds! < .5 THEN y = y - 200

	   IF bold = 0 AND RND > .9 THEN y = y + 10 * (unittype(index) - unittype(c) + armyexper(index) - unittype(index))
	   SELECT CASE odds! + .5 * bold
		CASE IS < .3
		y = -9999
		CASE IS < .5
		y = y - 300
		CASE IS <= .8
		y = y - 20
		CASE .8 TO 1.2
		y = y - 5
		CASE 1.2 TO 1.5
		y = y + 10
		CASE ELSE
		y = y + .02 * armysize(index) + 10 * atkfac(unittype(index)) - .02 * armysize(dest) + 10 * atkfac(unittype(dest)) + 20
	   END SELECT
ourn:
	IF neuter = 1 AND cityo(a) = 0 AND cityp(a) = 0 THEN
		IF victory&(who) - victory&(3 - who) < 30 - 30 * (side = 1) THEN y = -100: IF RND > .1 THEN y = -999
	END IF
	IF matrix(from, 7) > 95 AND matrix(a, 7) > 95 THEN
		IF (teklev(who, 6) < 2 AND cityp(a) <> who) OR navyloc(3 - who) = from OR navyloc(3 - who) = a THEN y = -29999
	END IF

	IF a = 23 AND cityp(a) <> who THEN y = y + 25

	IF capcity(3 - who) > 0 THEN
		dx = cityx(capcity(3 - who)): dy = cityy(capcity(3 - who))
	ELSE
		x1 = 0: dx = 0: dy = 0
		CALL starfin(star, fin, 3 - who)
		FOR i = star TO fin
			IF armysize(i) > 0 THEN
				dx = dx + cityx(armyloc(i))
				dy = dy + cityy(armyloc(i))
				x1 = x1 + 1
			END IF
		NEXT i
		dx = dx / (x1 + .1): dy = dy / (x1 + .1)
	END IF
	x1 = ABS(dx - cityx(from)) + 1.2 * ABS(dy - cityy(from)) - ABS(dx - cityx(a)) - 1.2 * ABS(dy - cityy(a))
	IF capcity(3 - who) > 0 THEN y = y + x1 ELSE y = y + .1 * x1
	IF cityp(a) = 3 - who AND occupied(a) = 0 THEN y = y + 400
	IF a = capcity(3 - who) THEN
		y = y + 100: IF occupied(a) = 0 THEN y = y + 9999
	END IF
	dest = occupied(a)
	IF dest > 0 AND cityp(a) <> who THEN
		x = (.02 * armysize(index) + 10 * (atkfac(unittype(index)) + 1)) / (.02 * armysize(dest) + 10 * atkfac(unittype(dest)) + 1.1)
		SELECT CASE x
			CASE IS < .1
				y = y - 100
			CASE IS < .3
				y = y - 50
			CASE IS > 1
				y = y + 150
			CASE IS > 2
				y = y + 200
			CASE IS > 3
				y = y + 250
			END SELECT
	END IF

	IF cityp(a) = 0 THEN
		IF cityo(a) > 0 THEN
			y = y + 300
		ELSE
			y = y + 150
		END IF
	END IF
'...........................................................................
	FOR k = 1 TO 6: m = matrix(a, k): IF m = 0 GOTO tally3
	IF cityp(m) = 0 THEN y = y + 3 * (cityv(m) + fort(m))
	IF cityp(m) = 3 - who THEN y = y + 3 * (cityv(m) + fort(m))
	IF cityp(m) = who AND c > 0 THEN
		odds! = 5 - 4 * RND
		IF armysize(c) > 0 THEN odds! = armysize(index) / armysize(c) ELSE odds! = 99
		IF odds! < 1 AND aggress! < 2 THEN y = y - 2
	END IF
	IF m = capcity(side) THEN y = y + 150
	IF who = 1 THEN
		IF armyloc(index) = 5 AND a = 10 THEN y = y + 50
		IF armyloc(index) = 14 AND a = 43 THEN y = y + 50
		IF armyloc(index) > 56 THEN y = y + 50
	END IF
tally3:
	NEXT k
'---------------------------------------------------------------------------
	array(j) = y
alle:
NEXT j: max = 6
alleval:
x = 0: best = 0
FOR j = 1 TO max
IF array(j) < 0 GOTO allof
	IF array(j) > x THEN x = array(j): best = j
allof:
NEXT j
	IF defend > armysize(index) AND array(best) < 50 THEN best = 0
	x = best
END SUB

SUB gloat (x, y)
IF noise > 1 THEN
	SELECT CASE x
		CASE 1
			IF sblast$ = "M" THEN
				CALL putflag(x, z)
				IF z <> 4 THEN
					SHELL "playmidi america.mid /FMT:General /Q"
				ELSE
					SHELL "playmidi france.mid /FMT:General /Q"
				END IF
			ELSE
				'It's A Long Way to Tipperary
				PLAY "MSMFt145o3c8d8e-4e-4..e-16f8g8a-4o4c4.P8o4c8o3b-8a-4f2a-4e-2P4"
				IF y > 0 THEN
					PLAY "MBo3c8d8e-4e-4..e-16f8g8a-4o4c4.P8o3a-8b-8o4c4o3a-4o4c4o3b4b-2P4"
					PLAY "MBo3a-8b-8o4c4c4c8.c16o3b-8a-8b-2a-4a-8b-8o4c4o3a-2b-4a-2."
				END IF
			END IF
		CASE 2
		IF sblast$ = "M" THEN
			SHELL "playmidi wagner.mid /FMT:General /Q"
		ELSE
			'Valkyries
			PLAY "mFMSt160o1a8.e16a8o2c4.o1a4."
			PLAY "o2c8.o1a16o2c8e4.c4."
			PLAY "e8.c16e8g4.o1g4.o2c8.o1g16o2c8e2"
			END IF
		END SELECT
	END IF
END SUB

SUB hangar
FOR i = 1 TO 2
x = cityx(airloc(i)): y = cityy(airloc(i))
PSET (x, y - 11), 2
DRAW "C11S4R3U3R1C8D3R3D1L3D3R1L1C11L2R1U3L3BR5C0R3U1BL3U3BD5D1BR1D2L4BU4L2"
NEXT i
END SUB

SUB image2 (a$, s)
sec! = 2: IF Mighty > 0 THEN sec! = -2
s = ABS(s)
mtx$(1) = a$
tlx = 35 - LEN(a$) \ 2
tly = 12: size = 1
CALL mxw(wide)
x = 8 * (tlx + wide)
y = 16 * (tly + 1)
	GET (8 * tlx - 5, 16 * tly - 11)-(8 * (tlx + wide + 1) + 15, 16 * (tly + 3) + 15), graphic
	VIEW (8 * tlx - 5, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + 3) + 8)
	CLS 1
	VIEW
	LINE (8 * tlx, 16 * tly - 3)-(8 * (tlx + wide + 1) + 15, 16 * (tly + 3) + 15), 0, BF
	LINE (8 * tlx - 5, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + 3) + 8), s, BF
	LINE (8 * tlx - 5, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + 3) + 8), 15, B
	COLOR 14
	LOCATE tly + 2, tlx + 2: PRINT a$
	CALL TICK(sec!)
	IF Mighty > 0 THEN TICK .3
	PUT (8 * tlx - 5, 16 * tly - 11), graphic, PSET
END SUB

SUB menu (switch%)
	IF Mighty = 0 AND switch = 3 THEN utility1 = 0
	TICK .1
	IF Mighty > 0 THEN
		CALL MouseBorder(1, 1, 450, 635)
	END IF
		SELECT CASE switch
			CASE 10, 12, 19
				CALL MouseBorder(1, 525, 450, 635)
				switch = switch - 10
			CASE 3, 11
				CALL MouseBorder(1, 1, 450, 525)
			CASE 13
				CALL MouseBorder(1, 640, 450, 645)
				COLOR 14: LOCATE 13, 67: PRINT "Use Arrow Keys"
				switch = 3
			CASE 5, 99
				CALL MouseBorder(1, 525, 450, 635)
		END SELECT
	win = noise
remenu:
	IF colour = 0 THEN colour = 7
	LOCATE 1, 1, 0
	IF mtx$(0) = "" THEN mtx$(0) = "M E N U"

	IF wide = 0 THEN CALL mxw(wide)
	IF tlx = 0 THEN GOSUB noadjust
	IF choose < 21 THEN choose = 1
	IF choose > 21 THEN choose = choose - 21
	IF choose > 21 THEN choose = 1

	row = choose: IF row < 1 THEN row = 1
	IF row > size THEN row = 1
	choose = row
	row1 = row
	   
	IF tly = 0 THEN tly = INT(11.5 - .5 * size)
	IF tly + size > 26 THEN tly = 26 - size
	IF tlx + wide > 78 THEN tlx = 78 - wide
	   
	boxc = colour

	COLOR boxc

	VIEW (8 * tlx - 5, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + size + 2) + 8)
	CLS 1
	VIEW
	CALL choices(wide)

sel1:
	COLOR hilite
	LOCATE tly + 2 + row, tlx + 2: PRINT mtx$(row)
	SELECT CASE switch
		CASE 1: CALL icon(array(row), 0, 7)
		CASE 2, 5
			IF switch = 2 THEN
				target = occupied(array(row))
				CALL icon(array(row), 0, 9)
			ELSE
				CALL icon(armyloc(array(row)), 0, 9)
				target = array(row)
			END IF
			 IF target > 0 THEN
			flag = 1
			COLOR 12
			LOCATE tly + 2 + row, tlx + 2: PRINT SPACE$(wide);
			LOCATE tly + 2 + row, tlx + 2: PRINT mtx$(row);
			FOR k = 4 TO 6
			LOCATE tly + k + size, tlx + 1: PRINT SPACE$(79 - tlx);
			NEXT k
			LOCATE tly + 4 + size, tlx + 1: PRINT "Size"; armysize(target);
			x = POS(0): y = CSRLIN: LOCATE y, x - 1: PRINT "00";
			LOCATE tly + 5 + size, tlx + 1: PRINT LEFT$(unitkind$(unittype(target)), 5); target
			LOCATE tly + 6 + size, tlx + 1: PRINT "Supply "; supply(target)
			 ELSE
			flag = 0
			FOR k = 4 TO 6
			LOCATE tly + k + size, tlx + 1: PRINT SPACE$(79 - tlx);
			NEXT k
			 END IF
		CASE 3
			CALL icon(array(row), 0, 9)
			target = array(row)
		CASE 4: CALL armystat(array(row))
		CASE 6
			k = row
			CALL showtek(side, k)
			IF k = 0 THEN
			COLOR 7: LOCATE tly + 2 + row, tlx + 2: PRINT mtx$(row)
			END IF
		CASE 8
		IF row > 0 THEN
				LINE (548, 148)-(592, 216), 15, B
				a = row: IF side = 1 THEN a = 6 - row
				t$ = "face" + LTRIM$(STR$(a)) + ".vga"
				IF LEN(DIR$(t$)) > 0 THEN
					DEF SEG = VARSEG(graphic(1))
					BLOAD t$, VARPTR(graphic(1))
					DEF SEG
					PUT (550, 150), graphic, PSET
					IF side = 1 THEN
						PAINT (560, 160), 2, 0
					END IF
				END IF
			END IF
	END SELECT
	LINE (8 * (tlx + 1), 16 * (tly + row + 1))-(8 * (tlx + LEN(mtx$(row)) + 1) - 1, 16 * (tly + row + 2) - 1), 7, B
	GOSUB selex
	IF switch <> 3 GOTO reglr
	IF a$ = "H" THEN choose = 1: GOTO called
	IF ASC(a$) = 13 THEN choose = 2: GOTO called
	IF a$ = "P" THEN choose = 3: GOTO called
reglr:
	IF ASC(a$) = 13 GOTO called
	IF switch = 2 THEN LOCATE tly + 2 + row1, tlx + 2: PRINT SPACE$(wide);
	COLOR colour
	LOCATE tly + 2 + row1, tlx + 2: PRINT mtx$(row1)
	GOSUB selswi
	choose = row
	GOTO sel1
'같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같
selex:
IF Mighty > 0 AND (switch < 4 OR switch = 5 OR switch = 6 OR switch = 9 OR switch = 11 OR switch > 80) THEN
		  CALL Mickey(a$, lButton, rButton, xc, yc)
		  IF a$ <> "" THEN
			IF switch > 100 THEN choose = -1: CALL placearmy(switch - 100): GOTO called
			utility1 = 0
			GOTO akey5
		  END IF
		  IF rButton <> 0 THEN
			a$ = CHR$(27)
			IF indicate > 0 THEN
				CALL placearmy(indicate)
				indicate = 0
			END IF
			GOTO akey5
		  END IF

	IF xc < 530 AND switch <> 11 THEN                              '#1
		i = 0: zmax = 32767
		FOR k = 1 TO ncity
		z = ABS(cityx(k) - xc) + ABS(cityy(k) - yc)
		IF z < zmax THEN i = k: zmax = z
'............................. air force select ............................
		IF k = airloc(side) THEN
			z = ABS(cityx(k) + 4 - xc) + ABS(cityy(k) - 9 - yc)
			IF z < 5 THEN choose = -4: GOTO called
		END IF
		NEXT k
'........................... navy select ...................................
		FOR j = 1 TO 2
		z = ABS(shipx(j) - xc) + ABS(shipy(j) - yc)
		IF z < 15 THEN
			CALL clrbot: PRINT force$(j) + " navy:" + STR$(navysize(j)) + " ships at "; city$(navyloc(j)); : TICK .5
			LINE (shipx(j) - 9, shipy(j) - 5)-(shipx(j) + 16, shipy(j) + 9), 14, B
			IF j = side THEN choose = -2: GOTO called
		END IF
		NEXT j
'. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1
		IF i <> 0 AND zmax < 11 THEN
			CALL clrrite: COLOR 11
			LOCATE 5, 69: PRINT city$(i)
			LOCATE 6, 68: PRINT "Value = "; cityv(i);
			a$ = "": COLOR 14
			SELECT CASE fort(i)
				CASE 1
				a$ = "Fort +1"
				CASE 2
				a$ = "FORT +2"
			END SELECT
			LOCATE 7, 69: PRINT a$;
			a$ = ""

			FOR k = 1 TO 2
			IF i = capcity(k) THEN a$ = force$(k) + " CAPITAL"
			NEXT k
			LOCATE 8, 67: PRINT a$;
			LINE (527, 60)-(639, 126), 11, B

			IF occupied(i) > 0 THEN
				COLOR 15
				a = occupied(i)
				LOCATE 9, 67: PRINT country$(nation(a))
				LOCATE 10, 67: PRINT unitkind$(unittype(a)); a
				LOCATE 11, 67
				PRINT "Size "; RTRIM$(STR$(armysize(a))); "00"
				LINE (527, 128)-(639, 180), 4, B
				IF switch = 0 THEN switch = 100 + a
			END IF
'............................................................................
'                               bombing, paratroop, etc
'............................................................................
			IF utility1 > 0 THEN
				CALL clrbot
				SELECT CASE utility1
				CASE 1
				IF cityp(i) = 0 GOTO selex
				PRINT "Trying to paratroop to "; city$(i);
				choose = i
				GOTO called
				CASE 2
				IF cityp(i) = 0 THEN CALL clrbot: PRINT "ILLEGAL CHOICE: "; city$(i); " is NEUTRAL"; : GOTO selex
				choose = i
				GOTO called
				END SELECT
'............................................................................
			END IF
			IF indicate = 0 AND occupied(i) = 0 THEN
				TICK 1
				a$ = CHR$(27)
				GOTO akey5
			END IF
			CALL starfin(star, fin, cityp(i))
			y = 8
			COLOR 9: IF cityp(i) = 2 THEN COLOR 7
'............................................................................
'                              move indicator is ON
'............................................................................
			IF indicate > 0 THEN
				z = armyloc(indicate)
				s = 1: IF indicate > 30 THEN s = 2
				IF matrix(z, 7) > 95 AND matrix(i, 7) > 95 THEN
					IF (cityp(i) <> s AND teklev(side, 6) < 2) THEN CALL image2("Need INVASION Technology", -4): GOTO clrplace
					IF navyloc(3 - side) = z OR navyloc(3 - side) = i THEN
						CALL submarine(1)
						CALL image2(force$(3 - s) + " fleet BLOCKS MOVE", -4)
						LINE (139, 331)-(232, 384), 0, BF
						GOTO clrplace
					END IF
				END IF

				FOR k = 1 TO 6
				IF matrix(z, k) = i THEN
					CALL canimove(indicate, j)
					IF j > 0 THEN CALL clrbot: PRINT unitkind$(unittype(indicate)); " Unit "; indicate; " cannot move in "; forecast$(weather); : TICK .5 * turbo!: GOTO backdown
					armymove(indicate) = i
					CALL clrbot
					PRINT unitkind$(unittype(indicate)); indicate; " is moving from "; armyloc(indicate); " to "; city$(armymove(indicate));
					CALL icon(armyloc(indicate), i, 1)
					CALL sndfx(1)
backdown:
					CALL TICK(.5): CALL clrbot
					win = 0
					GOTO clrplace
				END IF
				NEXT k
clrplace:
				CALL placearmy(indicate)
				indicate = 0
				a$ = CHR$(27)
				GOTO akey5
			END IF
'............................................................................
'                              move indicator is OFF
'............................................................................
			IF cityp(i) <> side THEN a$ = CHR$(27): TICK turbo!: GOTO akey5
			IF occupied(i) > 0 THEN
				 IF armymove(occupied(i)) = 0 THEN
					indicate = occupied(i)
				 ELSE
				CALL clrbot
				PRINT "Top army has used its turn";
				size = 0
				CALL starfin(star, fin, side)
				FOR k = star TO fin
					IF armyloc(k) = i AND armymove(k) = 0 THEN
						size = size + 1
						indicate = k
					END IF
				NEXT k
				IF size > 0 THEN
					CALL clrrite
					COLOR 15
					LOCATE 5, 67: PRINT size + 1; "ARMIES"
					LOCATE 6, 67: PRINT "STACKED..."
					LOCATE 7, 67: PRINT "New Top Unit"
					LOCATE 8, 67: PRINT unitkind$(unittype(indicate)); indicate
					occupied(i) = indicate
				END IF
				 END IF
			END IF
				IF indicate > 0 THEN
				x = cityx(armyloc(indicate)) - 19
				y = cityy(armyloc(indicate)) - 16
				CALL ikhan(indicate)
				IF armymove(indicate) = 0 THEN
					CALL clrbot
					PRINT unitkind$(unittype(indicate)); " Unit"; indicate; "is ready to move  (Str: ";
					CALL strong(indicate): PRINT "  Exp:"; armyexper(indicate); " Supp:"; supply(indicate); ")";
				END IF
				TICK .2
				GOTO selex
				END IF
		END IF
	ELSE
		IF xc > 8 * (tlx - 1) AND xc < 8 * (tlx + wide + 1) THEN
			row1 = row: row = yc \ 16 - tly - 1
			IF row > size OR row < 1 THEN
				IF row1 = -3 THEN
					IF xc > 590 AND xc < 610 THEN side = 3 - side: choose = -1: GOTO called
				END IF
				GOTO selex
			END IF
			IF switch = 2 THEN CALL icon(array(row1), 0, 8)
			IF switch = 5 THEN CALL icon(armyloc(array(row1)), 0, 8)
			a$ = CHR$(13)
			choose = row
			TICK .1
			GOSUB limits
			EXIT SUB
		END IF

	END IF                                          '#1
	IF indicate > 0 GOTO clrplace
	GOTO selex
END IF
'............................................................................
crsr:
	DO: a$ = INKEY$: LOOP WHILE a$ = ""
akey5:
	IF ASC(a$) = 13 THEN RETURN
	IF ASC(a$) = 2 THEN GOTO boss
	IF LEN(a$) = 2 GOTO arrows
	IF switch = 3 THEN choose = -ASC(UCASE$(a$)): GOTO called
	IF ASC(a$) = 27 THEN
		IF indicate > 0 THEN CALL placearmy(indicate)
		choose = -1
		CALL ships
		GOTO called
	END IF
		row1 = row
		FOR k = 1 TO size
		c1$ = UCASE$(LEFT$(LTRIM$(mtx$(k)), 1))
		IF c1$ = UCASE$(a$) THEN choose = k: GOSUB limits: GOTO called
		NEXT k
	GOTO crsr
arrows:
	a$ = RIGHT$(a$, 1)
	row1 = row
	 IF a$ = "H" THEN row = row - 1: GOSUB limits: RETURN
	 IF a$ = "I" THEN row = 1: GOSUB limits: RETURN
	 IF a$ = "P" THEN row = row + 1: GOSUB limits: RETURN
	 IF a$ = "Q" THEN row = size: GOSUB limits: RETURN
	 IF switch = 0 THEN
		SELECT CASE a$
			CASE "="
redoit:
				CALL europe(0)
redux:
				CALL choices(wide)
				IF switch <> 6 THEN CALL statusbar
				CALL showmove(side)
				RETURN
			CASE "A"
				choose = 99: EXIT SUB
			CASE ";"
				a$ = UCASE$(mtx$(0)): file$ = ""
				SELECT CASE a$
					CASE "MAIN"
					file$ = "help.sc1"
				END SELECT
				IF file$ = "" THEN RETURN
				IF LEN(DIR$(file$)) = 0 THEN RETURN
				SCREEN 0
				DEF SEG = &HB800
				BLOAD file$, 0
				DEF SEG
				TICK 0
				SCREEN 12
				GOTO redoit
			CASE ">"
				CALL report(94)
				GOTO redux
			CASE "?"
				CALL report(95)
				GOTO redux
			CASE "@"
				CALL report(96)
				GOTO redux
			CASE "C"
				CALL report(99)
				GOTO redux
			CASE "D"
				CALL report(100)
				GOTO redux
			CASE ELSE
		END SELECT
	END IF
	RETURN

limits:
	IF row > size THEN row = 1
	IF row < 1 THEN row = size
	RETURN

selswi:
	SELECT CASE switch
		CASE 1, 2
			CALL icon(array(row1), 0, 8)
		CASE 3
			CALL icon(target, 0, 8)
		CASE 5
			CALL icon(armyloc(array(row1)), 0, 8)
	END SELECT
RETURN

noadjust:
	IF tlx = 0 THEN tlx = INT(40.5 - .5 * wide)
	RETURN
boss:
	CLS
	LOCATE 1, 1: PRINT "C:>";
	DO: a$ = INKEY$: LOOP WHILE a$ = ""
	IF ASC(a$) <> 2 GOTO boss
boss1:
	CALL europe(0)
	CALL statusbar
	GOTO remenu
called:
	COLOR colour
	tlx = 0: tly = 0
	row1 = row
	GOSUB selswi
END SUB

SUB mxw (wide)
	wide = LEN(mtx$(0)) + 1
	FOR i = 1 TO size
	a = LEN(mtx$(i))
	IF a > wide THEN wide = a
	NEXT i
END SUB

SUB navy (who, chx)
DIM hit(2)
IF weather = 4 AND teklev(who, 4) < 3 THEN EXIT SUB
IF chx > 0 AND navyloc(who) = 0 THEN chx = 1
COLOR 11
ahoy:
cost = 100 - 5 * teklev(who, 8)
cityp(0) = who
IF chx = 0 THEN CALL clrbot: PRINT "Funds available "; cash(who);
IF chx = 1 THEN
	IF cash(who) < cost THEN EXIT SUB
	IF navysize(who) > 9 THEN EXIT SUB
END IF
mtx$(0) = STR$(navysize(who)) + " Ships"
mtx$(1) = "Build": IF cash(who) < cost OR navysize(who) > 9 OR cityp(navyloc(who)) <> who THEN mtx$(1) = "-": choose = 23
mtx$(2) = "Attack": IF cityp(navyloc(who)) <> 3 - who THEN mtx$(2) = "-": choose = 24 + 2 * (mtx$(1) <> "-")
mtx$(3) = "Sail": IF navyloc(who) = 0 THEN mtx$(3) = "-": IF chx = 3 THEN chx = 1
tlx = 67: tly = 12: size = 3
IF teklev(who, 6) > 0 THEN
IF navysize(who) > 1 AND cityp(navyloc(who)) = 0 AND teklev(who, 6) > 0 THEN size = 4: mtx$(4) = "Amphib": IF chx > 0 THEN CALL void(navyloc(1), defend): IF defend < 200 THEN chx = 4
END IF

IF chx = 2 AND RND > .8 THEN chx = 3
IF chx > 0 THEN choose = chx: GOTO anchor
IF nflag > 0 AND choose <> 1 THEN EXIT SUB

COLOR 9
LOCATE 5, 68: PRINT "Attack:"; teklev(who, 4)
LOCATE 6, 68: PRINT "Defend:"; teklev(who, 5)
a$ = "NO": IF teklev(who, 6) > 0 THEN a$ = "YES"
LOCATE 7, 68: PRINT "Amphib: "; a$
COLOR 15: LOCATE 2, 71: PRINT "Navy"
LOCATE 3, 68: PRINT "Technology"
LINE (532, 60)-(639, 114), 11, B
colour = 9: hilite = 14
CALL menu(10): CALL clrrite
anchor:
'---------------------------------------------------------------------------
SELECT CASE choose
'---------------------------------------------------------------------------
'                               Build Ship
'---------------------------------------------------------------------------
	CASE 1
	IF cash(who) < cost GOTO ahoy
	IF chx = 1 AND navysize(who) > 9 THEN EXIT SUB
	IF chx = 0 AND (cash(who) < cost OR navysize(who) > 9) THEN GOTO ahoy

	IF chx = 0 AND navyloc(who) > 0 THEN
		IF cityp(navyloc(who)) <> who GOTO ahoy
		IF matrix(navyloc(who), 7) < 90 GOTO ahoy
	END IF
	IF chx = 1 AND (cityp(who) <> side OR RND < .07 * navysize(who)) THEN EXIT SUB
	IF navysize(who) > 0 GOTO add2ship
ships:
	mtx$(0) = "Port": size = 0: tlx = 67: tly = 2
	size = 0
	FOR i = 1 TO ncity: IF matrix(i, 7) > 90 AND cityp(i) = who AND navyloc(3 - who) <> i THEN size = size + 1: mtx$(size) = city$(i): array(size) = i
	NEXT i
	IF chx = 1 AND size < 1 THEN EXIT SUB
	IF chx = 1 THEN choose = 1 + INT(size * RND): GOTO bottle
	IF size < 1 THEN CALL clrbot: PRINT "NO SHIPYARDS AVAILABLE !"; : EXIT SUB
	IF chx = 0 THEN CALL menu(12): CALL clrrite
bottle:
	IF choose < 1 GOTO ahoy
	navyloc(who) = array(choose)
	cash(who) = cash(who) - cost: navysize(who) = 1
	x = cityx(array(choose)) + 25: y = cityy(array(choose)) + 25: CALL ships
	CALL clrbot: PRINT force$(who); " is building NEW fleet in "; city$(array(choose));
	CALL sndfx(4)
	CALL TICK(turbo!)
	GOTO ahoy
add2ship:

	cash(who) = cash(who) - cost
	navysize(who) = navysize(who) + 1
	IF pbm > 0 THEN pbm = 100 + pbm
	CALL sndfx(4)
	CALL clrbot: PRINT force$(who); " navy increased to "; navysize(who);
	IF who = side THEN CALL TICK(turbo!)
'---------------------------------------------------------------------------
'                               Attack City
'---------------------------------------------------------------------------
	CASE 2
	IF cityp(navyloc(who)) = who THEN
		IF chx = 2 THEN EXIT SUB
		GOTO ahoy
	END IF
	x1 = navyloc(who)
	IF x1 = 45 AND cityp(23) = 3 - who THEN
		IF who = side THEN
		mtx$(0) = "Attack"
		mtx$(1) = city$(23)
		mtx$(2) = city$(45)
		choose = 23
		tlx = 67: size = 2: CALL menu(10)
		CALL clrrite
		IF choose = 1 THEN x1 = 23
		ELSE
		x1 = 23
		END IF
	END IF
	IF chx = 2 AND occupied(x1) > 0 AND RND > .5 THEN chx = 3: GOTO anchor
	IF chx = 2 AND cityp(x1) = 0 THEN chx = 3: GOTO ahoy
	IF x1 < 1 THEN EXIT SUB
	IF who = side THEN nflag = 1
	IF cityp(x1) <> 3 - who GOTO ahoy
	CALL clrbot: PRINT force$(who); " fleet bombards "; city$(x1);
	CALL icon(x1, 0, 3)
		  
	target = x1: index = occupied(target): IF index = 0 GOTO deserted
	pct! = .005 * navysize(who) + .02 * RND + .02 * teklev(who, 4)
	IF fort(target) > 0 THEN pct! = .5 * pct!
	killd = armysize(index) * pct!
	IF killd < 1 THEN killd = 1
	IF killd > 75 THEN killd = 70 + 10 * RND
	CALL clrbot
	MONIKER (index): PRINT "took "; 100 * killd; " casualties";
	x = .5 * navysize(who) + 1: IF x > supply(index) THEN x = supply(index)
	supply(index) = supply(index) - x
	CALL TICK(turbo!)
	armysize(index) = armysize(index) - killd: IF armysize(index) < 1 THEN armysize(index) = 1
	EXIT SUB
deserted:
	IF fort(target) = 0 GOTO blast
	IF RND < .7 + .03 * (navysize(who) + teklev(who, 4) - fort(target)) GOTO hurt1
	IF RND < .1 * teklev(who, 5) GOTO deserted
	navysize(who) = navysize(who) - 1
	CALL image2(force$(cityp(target)) + " artillery sank a ship!", 4)
	CALL image2(STR$(navysize(who)) + " ship(s) are left!", 5)
	CALL sndfx(9)
	CALL sndfx(3)
	CALL TICK(turbo!)
	IF navysize(who) < 1 THEN navyloc(who) = 0: y = 185: GOSUB boxes: LOCATE 12, 30: PRINT force$(who); " fleet eliminated": CALL TICK(9): victory&(3 - who) = victory&(3 - who) + 5: EXIT SUB
	GOTO deserted
hurt1:
	CALL image2(city$(target) + " fortifications damaged", 4)
	fort(target) = fort(target) - 1: x = cityx(target): y = cityy(target): LINE (x - 6, y - 6)-(x + 6, y + 6), 2, BF
	CALL showcity(target)
	CALL TICK(turbo!)
	EXIT SUB
blast:
	IF RND > .75 + .02 * navysize(who) THEN CALL clrbot: PRINT "Citizens of "; city$(target); " stand firm against the attack"; : CALL TICK(turbo!): EXIT SUB
	IF target = capcity(3 - who) THEN CALL clrbot: PRINT "The CAPITAL steadfastly stands loyal"; : CALL TICK(turbo!): EXIT SUB
	cityp(target) = 0
	CALL image2(city$(target) + " is NEUTRALized", 4)
	IF target = airloc(3 - side) THEN CALL deadplane(3 - side)
	CALL showcity(target)
	victory&(who) = victory&(who) + cityv(target)
	EXIT SUB
'---------------------------------------------------------------------------
'                               Sail
'---------------------------------------------------------------------------
	CASE 3
	IF navyloc(who) = 0 AND chx > 0 THEN EXIT SUB
	IF navyloc(who) = 0 GOTO ahoy

	size = 0
	FOR i = 1 TO ncity
	IF matrix(i, 7) > 90 AND navyloc(who) <> i THEN
		d = ABS(cityx(i) - cityx(navyloc(who))) + ABS(cityy(i) - cityy(navyloc(who)))
		IF (navyloc(who) = 32 AND i = 7) OR (navyloc(who) = 7 AND i = 32) THEN d = 0
		IF d < 150 THEN
'...............................Baltic (Kiel is key) ......................
			IF ((navyloc(who) = 45 AND i = 23) OR (navyloc(who) = 23 AND i = 45)) AND cityp(23) = 3 - who THEN GOTO nopass
			size = size + 1
			mtx$(size) = city$(i)
			array(size) = i
		END IF
	END IF
nopass:
	NEXT i
	IF size = 0 THEN
		IF chx = 3 THEN
			EXIT SUB
		ELSE
			GOTO ahoy
		END IF
	END IF
	IF chx = 3 THEN GOSUB nest: IF choose > 0 GOTO admiral ELSE EXIT SUB
	COLOR 11: LOCATE 11, 68: PRINT city$(navyloc(who))
	mtx$(0) = "To"
	colour = 3: tlx = 67: tly = 12
	CALL menu(12): CALL clrrite: IF choose < 1 THEN EXIT SUB
admiral:
	IF array(choose) = navyloc(who) THEN EXIT SUB
	IF who = side THEN nflag = 1
	IF who = 2 AND ((navyloc(who) = 32 AND array(choose) = 7) OR (navyloc(who) = 7 AND array(choose) = 32)) THEN
		IF RND > .5 THEN
			CALL image2("AXIS PASSES GIBRALTAR SAFELY", -8)
		ELSE
			CALL sndfx(9)
			a$ = "GIBRALTAR SINKS AXIS SHIP"
			CALL image2(a$, -4)
			CALL news(a$)
			CALL sndfx(3)
			navysize(who) = navysize(who) - 1
			IF navysize(who) < 1 THEN
				navyloc(who) = 0
				CALL image2(force$(who) + " fleet destroyed", -4)
				victory&(3 - who) = victory&(3 - who) + 5
				CALL europe(0)
				EXIT SUB
			END IF
		END IF
	END IF
	IF array(choose) < 1 OR array(choose) > ncity THEN EXIT SUB
	IF navysize(who) < 1 GOTO ships
	CLS
	y = 250: GOSUB boxes
	COLOR 11
	a$ = force$(who) + " fleet of" + STR$(navysize(who)) + " ship(s) sails "
	LOCATE 10, 25: PRINT a$
	t$ = "From " + city$(navyloc(who)) + " to " + city$(array(choose))
	LOCATE 11, 25: PRINT t$
	CALL news(a$ + t$)
	FOR i = 1 TO navysize(who): PSET (120 + 41 * i, 250), 0: CALL shipicon(who): NEXT i
	IF teklev(who, 4) > 2 THEN COLOR 14: LOCATE 19, 30: PRINT "ALL WEATHER FLEET"

	CALL TICK(-turbo!)
	navyloc(who) = array(choose)
	IF navyloc(1) = navyloc(2) GOTO pirate
sail3:
	CALL europe(0): CALL statusbar
	EXIT SUB
'---------------------------------------------------------------------------
'                               Amphib
'---------------------------------------------------------------------------
	CASE 4
	IF navysize(who) < 1 GOTO anchor
	CALL commander((who), empty)
	IF empty = 0 THEN chx = 3: GOTO anchor
	IF teklev(who, 6) < 1 THEN chx = 3: GOTO anchor
	navysize(who) = navysize(who) - 1
	c = navyloc(who)
	z = 2: IF who = 1 THEN z = 1: IF RND > .5 THEN z = 3
	nation(empty) = z
	choose = 99
	CALL newarmy((who), empty, c)
	cash(who) = cash(who) + 100 - 5 * teklev(who, 8)   'to compensate for cost of recruiting new army
	CALL capture(empty, c, who, 0, 1)
	IF who = side THEN nflag = 1
	a$ = country$(nation(empty)) + " Marines Took " + city$(c)
	CALL image2(a$, 4)
	CALL news(a$)
	EXIT SUB
'---------------------------------------------------------------------------
'                               Exit
'---------------------------------------------------------------------------
	CASE ELSE
	EXIT SUB
END SELECT
GOTO ahoy
'---------------------------------------------------------------------------
'                               Ship vs. Ship
'---------------------------------------------------------------------------
pirate:
	CLS
	CALL battleship
	LOCATE 20, 32: COLOR 11: PRINT "NAVAL COMBAT"
	CALL news("* " + force$(who) + " FLEET ATTACKS AT " + city$(navyloc(3 - who)))
	LINE (240, 300)-(350, 320), 11, B
	PAINT (300, 310), 4, 11
	FOR k = 1 TO 2
		hit(k) = 2 + teklev(k, 4) + teklev(k, 5)
		IF teklev(k, 5) > 2 THEN hit(k) = hit(k) + 3
	NEXT k
	y1 = 100 * navysize(1) + navysize(2)
cannon:
	x = 10: y = 360
	COLOR 11: LOCATE 23, 68: PRINT "ALLIES"; navysize(1);
	GOSUB boxes
	FOR i = 1 TO navysize(1)
	x = x + 50: PSET (x, y)
	CALL shipicon(1)
	NEXT i
	y = 440
	COLOR 11: LOCATE 28, 68: PRINT "AXIS"; navysize(2);
	GOSUB boxes
	x = 10
	FOR i = 1 TO navysize(2)
	x = x + 50: PSET (x, y)
	CALL shipicon(2)
	NEXT i
wave:
	mtx$(0) = "Options"
	mtx$(1) = "Attack"
	mtx$(2) = "Retreat"
	IF chx = 3 THEN choose = 1: GOTO powder
	f3key = 0
	size = 2: colour = 9: tlx = 2: tly = 15: CALL menu(11)
	COLOR 11
powder:
	SELECT CASE choose
	 CASE 1
firemore:
	 GOSUB powgun
	 x = 20 * RND + teklev(who, 4) - teklev(3 - who, 5): x1 = 20 * RND + teklev(3 - who, 4) - teklev(who, 5)
	 IF x > x1 THEN
		a = 3 - who
		x = 20 + 50 * navysize(3 - who)
		y = 350: IF who = 1 THEN y = 430
	 ELSE
		a = who
		x = 20 + 50 * navysize(who)
		y = 430: IF who = 1 THEN y = 350
	 END IF

	 IF teklev(a, 5) < 3 THEN
		hit(a) = hit(a) - 1
	 ELSE
		IF RND < .5 THEN hit(a) = hit(a) - 1
	 END IF
	 IF teklev(3 - a, 4) > 2 THEN hit(a) = hit(a) - 2
	 IF hit(a) < 0 THEN hit(a) = 0
	 GOSUB showhit: IF hit(a) > 0 GOTO firemore
	 GOSUB xout
	 victory&(3 - a) = victory&(3 - a) + 2
	 CALL sndfx(3)

	 navysize(a) = navysize(a) - 1
	 IF navysize(a) < 1 THEN
		LOCATE 14, 30: COLOR 12
		a$ = force$(a) + " fleet DEFEATED"
		CALL image2(a$, 4)
		GOSUB losses
		CALL news("* " + a$ + " at " + city$(navyloc(a)))
		navyloc(a) = 0
		victory&(3 - a) = victory&(3 - a) + 10
		GOTO sail3
	 END IF
	 hit(a) = 2 + teklev(a, 4) + teklev(a, 5)
	 GOTO cannon

	 CASE 2
	 pct! = .3
flee:
	 target = 0
	 FOR i = 1 TO ncity
	 IF cityp(i) = who THEN
		IF i <> navyloc(who) AND matrix(i, 7) > 90 THEN
			d = ABS(cityx(i) - cityx(navyloc(who))) + ABS(cityy(i) - cityy(navyloc(who)))
			IF d < 150 THEN target = i: IF RND > pct! GOTO found1
		END IF
	 END IF
	 NEXT i
	 IF target = 0 THEN
		IF pct! = .3 THEN pct! = 0: GOTO flee
		CALL image2(force$(who) + " FLEET CANNOT ESCAPE!", -5)
		GOTO wave
	 END IF
found1:
	 LOCATE 14, 25: COLOR 15
	 CALL image2(force$(who) + " retreat to " + city$(target), -5): CALL TICK(turbo!)
	 IF pbm > 0 THEN
		GOSUB losses
		CALL news(force$(who) + " fleet withdrew to " + city$(target))
	 END IF
	 navyloc(who) = target
	 GOTO sail3
	 CASE ELSE
	 GOTO wave
	 END SELECT
	 GOTO pirate
'---------------------------------------------------------------------------
'                               Subs
'---------------------------------------------------------------------------
showhit:
	 FOR k = 1 TO 2
	 LOCATE 19 + 5 * k, 6.3 * navysize(k): PRINT hit(k); " ";
	 NEXT k
	 RETURN

nest:
best = 0
IF who = 2 THEN
	IF navyloc(who) = 10 OR navyloc(who) = 28 OR navyloc(who) = 29 THEN choose = 0: RETURN
END IF
IF navysize(3 - who) > 0 AND (navysize(who) + teklev(who, 4) + teklev(who, 5) - navysize(3 - who) - teklev(3 - who, 4) + teklev(3 - who, 5)) > -2 THEN
	FOR i = 1 TO size
	target = array(i)
	IF navyloc(3 - who) = target AND navysize(who) + teklev(who, 3) >= navysize(3 - who) THEN choose = i: RETURN
	IF navysize(3 - who) > 0 THEN
		IF SGN(cityx(navyloc(3 - who)) - cityx(navyloc(who))) = SGN(cityx(target) - cityx(navyloc(who))) THEN
			IF SGN(cityy(navyloc(3 - who)) - cityy(navyloc(who))) = SGN(cityy(target) - cityy(navyloc(who))) AND RND > .5 THEN best = i
		END IF
	END IF
	NEXT i
END IF
	IF best > 0 THEN choose = best: RETURN

	best = 0
	FOR i = 1 TO size
	target = array(i)
	IF navysize(who) < 2 AND cityp(target) = who THEN best = i: GOTO heaveto
	IF cityp(target) = 0 THEN
		IF navysize(who) > 1 AND teklev(who, 6) > 0 THEN
			best = i: IF RND > 1 - .4 * side GOTO heaveto
		ELSE
			GOTO neutral
		END IF
	END IF
	IF navyloc(3 - who) = target AND ABS(navysize(1) - navysize(2)) < 3 AND RND > .3 THEN best = i: GOTO heaveto
	IF cityp(target) <> who THEN best = i: IF RND > .8 GOTO heaveto
neutral:
	NEXT i
	IF best = 0 THEN
		x1 = 0
		FOR k = 1 TO 5
		choose = 1 + INT(RND * size)
		a = cityv(array(choose))
		IF who = 2 THEN IF array(choose) = 10 OR array(choose) = 28 OR array(choose) = 29 THEN a = a + 10
		IF a > x1 THEN x1 = a: best = choose
		NEXT k
	ELSE
heaveto:
		choose = best
	END IF
ahead:
	IF navyloc(3 - who) = array(choose) THEN
		spin = spin + 1
		IF spin < 5 THEN choose = 1 + INT(RND * size): GOTO ahead
		choose = 0
	END IF
	RETURN
xout:
		PSET (x, y)
		DRAW "S5C15G5F5G3H5G5H3E5H5E3F5E5F3"
		PAINT (x - 3, y + 1), 12, 15
		IF noise = 0 THEN TICK .05
	RETURN
powgun:
	y = 100: c = 4: IF RND > .7 THEN c = 0
	x = 500: IF RND > .5 THEN x = 530: IF RND > .6 THEN x = 400
	CALL snapshot(x, y, 0)
	CIRCLE (x, y), 10, c
	PAINT (x, y), c
	LINE (x - 1, y - 2)-(x + 1, y + 1), 4 - c, BF
	CALL sndfx(9)
	CALL TICK(.05)
	CALL snapshot(x, y, 1)
	CALL TICK(.1)
	RETURN
losses:
	IF pbm < 1 THEN RETURN
	x1 = y1 \ 100: y1 = y1 - 100 * x1
	x1 = x1 - navysize(1): y1 = y1 - navysize(2)
	CALL news(force$(1) + " losses:" + STR$(x1) + " ships")
	CALL news(force$(2) + " losses:" + STR$(y1) + " ships")
	RETURN
boxes:
	CIRCLE (320, y), 310, 11, , , .1
	PAINT (320, y), 1, 11
	RETURN
END SUB

SUB report (who)
DIM summ(ncity)
SELECT CASE who
	CASE 94
		GOTO frep
	CASE 95
		who = side: GOTO armrep
	CASE 96
		who = 3 - side: GOTO armrep
	CASE 99
		GOTO batrep
	CASE 100
		who = side: GOTO srep
END SELECT
mtx$(0) = "Inform"
mtx$(1) = force$(side)
mtx$(2) = force$(3 - side)
mtx$(3) = "Cities"
mtx$(4) = "Forces"
mtx$(5) = "Technology"
mtx$(6) = "Battles"
mtx$(7) = "Clr Battles"
tlx = 67: tly = 5
size = 7: CALL menu(0)
chute(who) = 15 * (airsize(who) * (teklev(who, 7) + 1))

SELECT CASE choose
CASE IS < 0
	CALL europe(0)
	EXIT SUB
CASE 1: who = side
CASE 2: who = 3 - side
CASE 3: GOTO cityrep
CASE 4: GOTO frep
CASE 5: GOTO srep
CASE 6: GOTO batrep
CASE 7
	IF noise > 0 THEN SOUND 1200, .5: SOUND 1300, .5
	batwon(1) = 0: batwon(2) = 0
	casualty&(1) = 0: casualty&(2) = 0
	CALL clrbot
	PRINT "Battle summary cleared!"; : TICK 1
	GOTO batrep
CASE ELSE
END SELECT
armrep:
IF choose < 0 GOTO endrep
IF choose = 4 GOTO frep
CALL starfin(star, fin, who)
CLS
COLOR 14: PRINT TAB(48); "Victory Points "; victory&(who);
x = victory&(who) + victory&(3 - who)
IF x > 0 THEN y = (victory&(who) / x) * 100: PRINT "("; y; " %)" ELSE PRINT
CALL armyxy(215, 7, who)
c = 9: IF who = 2 THEN c = 7
COLOR c: PRINT cntrl(who); "/"; ncity; TAB(15); "CITIES CONTROLLED"; TAB(40); : PRINT "("; : x = INT(100 * cntrl(who) / ncity): PRINT x; "%)";
PRINT TAB(50); : COLOR 12: PRINT "Capital: "; city$(capcity(who))

y = vptotal
FOR k = 1 TO 2
IF capcity(k) > 0 THEN y = y + 100
NEXT k
LOCATE 3, 1
PRINT income(who); "/"; y; TAB(15); "INCOME"; TAB(25); "("; : PRINT INT((income(who) / y) * 100); "%)   "; : COLOR 14: PRINT "Cash:"; cash(who)
LOCATE 5, 1
x = 0: FOR i = star TO fin
COLOR c
IF armyloc(i) < 1 GOTO deadeye
x = x + armysize(i)
PRINT i; TAB(5); country$(nation(i)); TAB(15); unitkind$(unittype((i))); TAB(25); : y = CSRLIN
CALL strong(i): PRINT TAB(34); city$(armyloc(i));
IF who <> side THEN PRINT : GOTO deadeye
PRINT TAB(47); armyexper(i); TAB(52); supply(i);
PRINT TAB(60); : IF armymove(i) > -1 THEN PRINT city$(armymove(i)) ELSE PRINT "Resting"
IF fort(armyloc(i)) > 0 THEN LOCATE y, 68: PRINT "FORT +"; fort(armyloc(i))
deadeye:
IF CSRLIN > 24 THEN GOSUB boxy: TICK 99: CLS : LOCATE 1, 70: PRINT "Page 2": LOCATE 5, 1
NEXT i

COLOR 15
PRINT " Total Forces "; TAB(25); LTRIM$(STR$(x)); "00"
PRINT " "; force$(who); " NAVY :"; navysize(who); " ship(s) "; : IF navyloc(who) > 0 THEN PRINT " in "; city$(navyloc(who)) ELSE PRINT
PRINT " "; force$(who); " AIRFORCE :"; airsize(who); " planes(s) in "; city$(airloc(who)); "   Paratroop Capacity :"; STR$(chute(who)); "00";
IF rr(who) > 0 THEN COLOR 14: PRINT " Army #"; rr(who); unittype(rr(who)): PRINT " paratroops to "; city$(armymove(rr(who)))
GOSUB boxy
GOTO endrep

boxy:
LOCATE 1, 1: COLOR 15
PRINT " Report for "; force$(who); " Forces";
COLOR c
PRINT TAB(30); mnth$(mnth); ","; yr;
COLOR 11
LOCATE 4, 1: COLOR 11: PRINT " #  National  Type      Size     Location  Exper  Suply   Move To"
LINE (0, 0)-(639, 440), 15, B
RETURN

cityrep:
FOR k = 1 TO ncity
	COLOR 12: IF cityp(k) > 0 THEN COLOR 9: IF cityp(k) = 2 THEN COLOR 7
	LOCATE INT(cityy(k) / 16 + 1), cityx(k) / 8: PRINT LTRIM$(RTRIM$(STR$(cityv(k))))
NEXT k

LOCATE 1, 1: COLOR 15
PRINT "City Report"; TAB(20); mnth$(mnth); ","; yr
CALL clrbot: COLOR 9: PRINT force$(1); " "; cntrl(1);
COLOR 7: PRINT "	"; force$(2); " "; cntrl(2);
COLOR 12: PRINT "	"; force$(0); " "; ncity - cntrl(1) - cntrl(2);
GOTO endrep

srep:
CLS
j = who: z = 0
scoop:
c = 9: IF j = 2 THEN c = 7
FOR k = 1 TO 8: LOCATE k + 2, 10 + z \ 8
COLOR c
PRINT tname$(k); " "; tek$(teklev(j, k));
IF teklev(j, k) = 3 THEN COLOR 14
PRINT " ("; teklev(j, k); ")"
NEXT k
SELECT CASE teklev(j, 6)
	CASE 0
	COLOR 4: LOCATE 8, 18 + z / 8: PRINT " NO "
	CASE 1
	COLOR 10: LOCATE 8, 10 + z \ 8: PRINT "AMPHIB  CAPABLE   "
	CASE 2
	COLOR 14: LOCATE 8, 10 + z \ 8: PRINT "INVASION CAPABLE  "
END SELECT

LINE (60 + z, 20)-(220 + z, 180), 15, B
COLOR 15: LOCATE 13, 10 + z \ 8: PRINT force$(j); " Technology"

IF teklev(j, 3) > 2 THEN COLOR 14: LOCATE 5, 10 + z \ 8: PRINT "ALL WEATHER LAND  "
IF teklev(j, 7) > 2 THEN
	COLOR 11: LOCATE 15, 10 + z \ 8: PRINT "AIR FORCE: ALL WEATHER"
	LOCATE 16, 10 + z \ 8: PRINT "AIR FORCE: 2X BOMBING"
END IF
IF teklev(j, 4) > 2 THEN COLOR 11: LOCATE 14, 10 + z \ 8: PRINT "ALL WEATHER NAVY"
IF z = 0 THEN z = 240: j = 3 - who: GOTO scoop
GOTO endrep

frep:

FOR k = 1 TO ncity
	IF occupied(k) > 0 THEN
		FOR j = 1 TO maxarmy
		IF armyloc(j) = k THEN summ(k) = summ(k) + .1 * armysize(j)
		NEXT j
	END IF
NEXT k

FOR k = 1 TO ncity
IF summ(k) > 0 THEN
	c = 9: IF cityp(k) = 2 THEN c = 7
	COLOR c
	LOCATE INT(cityy(k) / 16 + 1), cityx(k) / 8: PRINT LTRIM$(RTRIM$(STR$(summ(k))))
END IF
NEXT k
COLOR 14: LOCATE 1, 20: PRINT "Total Forces in Cities (1000's)"
GOTO endrep

batrep:
VIEW (200, 123)-(400, 284)
CLS 1
VIEW
LINE (200, 123)-(400, 284), 15, B
COLOR 14
LOCATE 9, 32: PRINT "BATTLE SUMMARY"
CALL armyxy(320, 160, 1)
CALL armyxy(370, 160, 2)
LINE (200, 176)-(400, 230), 15, B
LINE (200, 230)-(400, 284), 15, B
LINE (290, 176)-(345, 284), 15, B
LOCATE 13, 27: PRINT "BATTLES"
LOCATE 14, 27: PRINT "WON"
LOCATE 16, 27: PRINT "MEN LOST"
LOCATE 17, 27: PRINT "(1000's)"
LOCATE 14, 38: PRINT batwon(1)
LOCATE 14, 45: PRINT batwon(2)
LOCATE 17, 38: PRINT INT(.1 * casualty&(1))
LOCATE 17, 45: PRINT INT(.1 * casualty&(2))

endrep:
TICK -1
CALL europe(0)
END SUB

SUB showmove (who)
CALL starfin(star, fin, who)
FOR i = star TO fin
IF armymove(i) > 0 THEN CALL icon(armyloc(i), armymove(i), 1)
NEXT i
END SUB

SUB submarine (flag)
IF flag = 0 THEN
	LINE (139, 331)-(232, 384), 4, BF
	PSET (150, 370), 4
	OPEN "I", 1, "sub1.grf"
	INPUT #1, a$: DRAW a$
	CLOSE #1
	x = POINT(0): y = POINT(1): PAINT (x, y), 0, 8
ELSE
	LINE (139, 331)-(232, 369), 3, BF
	LINE (139, 370)-(232, 384), 1, BF
	PSET (150, 375), 5
	OPEN "I", 1, "sub2.grf"
	FOR k = 1 TO 2: INPUT #1, a$: DRAW a$: NEXT k
	CLOSE #1
	x = POINT(0): y = POINT(1): PAINT (x, y), 4, 8
END IF
END SUB

