DEFINT A-Z
DECLARE SUB airforce (who%, chx%)
DECLARE SUB boxes (y%)
DECLARE SUB canimove (index%, flag%)
DECLARE SUB citygraf (index%, flag%)
DECLARE SUB detach (who%, index%, target%)
DECLARE SUB gcirc (xc%, flag%)
DECLARE SUB homeguard (who%, target%)
DECLARE SUB ikhan (index%)
DECLARE SUB normal (xbar%, vary%, x%)
DECLARE SUB paratroop (who%)
DECLARE SUB pbmview ()
DECLARE SUB retreat (active%, x%)
DECLARE SUB rotate (who%)
DECLARE SUB showmove (who%)
DECLARE SUB submarine (flag%)
DECLARE SUB title2 ()
REM $INCLUDE: 'ww2.bi'
sblast$ = ""
pb$ = CURDIR$

SCREEN 12
s = 1
DEF SEG = VARSEG(graphic(1))
BLOAD GFXDIR + "w2icon.vga", VARPTR(graphic(1))
DEF SEG
PUT (100, 100), graphic, PSET
GET (101, 101)-(115, 114), usai
GET (101, 115)-(115, 128), geri
GET (101, 129)-(115, 142), uki
GET (101, 143)-(115, 156), fri
GET (123, 101)-(137, 114), poli
GET (123, 115)-(137, 128), rusi
GET (117, 129)-(139, 142), alship
GET (117, 143)-(139, 156), axship
DEF SEG = VARSEG(graphic(1))
BLOAD GFXDIR + "w2xtra.vga", VARPTR(graphic(1))
DEF SEG
PUT (100, 100), graphic, PSET
GET (101, 101)-(115, 112), para
GET (103, 114)-(122, 132), drop
GET (121, 100)-(137, 111), ike1
GET (121, 133)-(137, 143), ike2
GET (100, 133)-(116, 143), ike3
GET (100, 144)-(116, 153), ike4
CALL scriptstart
CALL title2
CALL filer(0)


IF COMMAND$ <> "" THEN
	sblast$ = UCASE$(COMMAND$)
	CALL sndfx(8)
END IF
TICK -1
TICK .2

IF player < 1 OR player > 2 THEN player = 1
IF player = 2 OR side = 0 THEN side = 1
IF turbo! < 1 THEN turbo! = 2

city$(0) = "NONE"

newg:
GOSUB init
front:
hilite = 15
mtx$(0) = "WW2-Europe STRATEGY"
mtx$(1) = "Start NEW Game"
mtx$(2) = "Resume Saved Game"
mtx$(3) = "Continue PBM Game"
mtx$(4) = "Quit"
tlx = 2: tly = 14: colour = 4: size = 4
choose = 22: f3key = 0
IF LEN(DIR$("pbm")) = 0 THEN mtx$(3) = "-" ELSE choose = 24
CALL menu(11)
SELECT CASE choose
	CASE IS < 0
		CALL title2
		GOTO front
	CASE 2
		CALL filer(choose)
		IF choose > 0 THEN filel = 1: side = 1: GOTO menu0 ELSE GOTO front
	CASE 3
		IF mtx$(3) = "-" GOTO newg
		pbm = 1: player = 2
			GOSUB clrscrn
			LOCATE 1, 30: PRINT "PBM Data Update"
			CALL filer(5)
			ON ERROR GOTO nodisk
			FILES pb$ + "pbm"
			ON ERROR GOTO 0
			t$ = pb$ + "pbm": a$ = t$ + ".old"
			SHELL "copy " + t$ + " " + a$
			OPEN "I", 1, pb$ + "pbm"
			INPUT #1, k
			IF k > 0 THEN
				FOR j = 1 TO k
					INPUT #1, mtx$(j)
				NEXT j
				SCREEN 12
				CLS
				COLOR 15
				LINE (0, 50)-(500, 449), 4, BF: LINE (0, 0)-(500, 50), 15, BF
				LINE (0, 50)-(500, 449), 15, B
				LOCATE 2, 27: PRINT " N E W S "
				FOR j = 1 TO k
				LOCATE j + 4, 5: PRINT mtx$(j)
				NEXT j
				PAINT (33, 64), 4, 15
			END IF
			INPUT #1, begin$, x, mnth, yr, side, weather
			IF k > 0 THEN
				COLOR 15: LOCATE 2, 11: PRINT force$(side)
				LOCATE 2, 46: PRINT mnth$(mnth); ","; yr
			END IF
			CALL announce(5, ""): DO WHILE INKEY$ = "": LOOP
			IF LEFT$(begin$, 2) = "19" GOTO okpbm
			CALL pbmview: END
okpbm:
			FOR i = 1 TO 4: INPUT #1, vicflag(i): NEXT i
			FOR i = 1 TO ncity
				INPUT #1, a$, occupied(i), cityp(i), fort(i)
			NEXT i
			FOR i = 1 TO maxarmy
				INPUT #1, nation(i), armyloc(i), unittype(i), armysize(i), armyexper(i), supply(i), armymove(i)
			NEXT i
			FOR i = 1 TO 2: INPUT #1, cash(i), cntrl(i), income(i), victory&(i), capcity(i)
			INPUT #1, navysize(i), navyloc(i), navymove(i), airsize(i), airloc(i), rr(i), tracks(i)
			NEXT i
			FOR j = 1 TO 2: FOR k = 1 TO 8: INPUT #1, teklev(j, k): NEXT k: NEXT j
			CLOSE #1
	IF side = 1 THEN
			CLS
			LINE (0, 0)-(639, 449), 1, BF
			LINE (100, 200)-(500, 300), 4, BF
			LINE (100, 200)-(500, 300), 15, B
			COLOR 15: LOCATE 14, 30: PRINT "CONTINUING PBM GAME"
			LOCATE 16, 32: PRINT mnth$(mnth); ", "; yr
			COLOR 14: LOCATE 18, 33: PRINT "UPDATE PHASE"
			LOCATE 21, 33: PRINT force$(side); " Side"
			FOR k = 1 TO ncity: CALL occupy(k): NEXT k
			TICK 0
			CALL europe(0)
			a = RND(-x)
			CALL tupdate
			GOTO newun
	END IF
			s = 31: GOTO newun
	CASE 4
		CLS : END
	CASE ELSE
END SELECT

newgame:
GOSUB init
CALL filer(4): IF begin$ = "" GOTO newg
vptotal = vptotal + 50 * difficult
filel = 1: bold = 1: IF RND > .5 THEN bold = 1 + INT(5 * RND)
IF difficult > 3 AND bold = 1 THEN bold = 2 + INT(4 * RND)

SCREEN 12
CLS : CALL europe(1)
IF cash(side) < 100 THEN chosit = 23
GOTO menu0
'==========================================================================
'                              New Month
'==========================================================================
newmnth:
IF side > 2 THEN side = 1
CALL events
CALL tupdate
IF pbm > 0 THEN GOTO emess ELSE IF autosave > 0 THEN CALL filer(6)

newun:

FOR i = 1 TO 2
cntrl(i) = 0
income(i) = 0
IF cash(i) > 30000 THEN cash(i) = 30000
IF cash(i) < 0 THEN cash(i) = 0
NEXT i
IF player = 1 THEN income(3 - side) = income(3 - side) + 40 * difficult
FOR i = 1 TO ncity
IF cityp(i) > 0 THEN x = cityp(i): cntrl(x) = cntrl(x) + 1: income(x) = income(x) + cityv(i)
NEXT i

FOR i = s TO maxarmy
armymove(i) = 0
IF unittype(i) = 5 THEN armymove(i) = -1
NEXT i
vptotal = income(1) + income(2)

FOR i = 1 TO 2: navymove(i) = 0: IF capcity(i) > 0 THEN income(i) = income(i) + 100
cash(i) = cash(i) + income(i)
NEXT i
'............................ Battle of the Atlantic .....................
x = navyloc(2)
IF x = 10 OR x = 28 OR x = 29 THEN
	CALL submarine(0)
	CALL image2("German U-Boats Sink Supplies", 4)
	CALL sndfx(3)
	LINE (139, 331)-(232, 384), 0, BF
	income(1) = .5 * income(1)
END IF
'...............................maintenance fee - begin new yr............................
a$ = "lost to maintenance"
FOR i = 1 TO 2
	x = 5 * navysize(i)
	IF x > cash(i) THEN
		x = cash(i)
		IF RND > .8 AND navysize(i) > 0 THEN
			navysize(i) = navysize(i) - 1
			IF navysize(i) = 0 THEN navyloc(i) = 0
			IF i = side THEN CALL image2(force$(side) + " ship " + a$, -4)
		END IF
	END IF
	cash(i) = cash(i) - x
	x = 4 * airsize(i)
	IF x > cash(i) THEN
		x = cash(i)
		IF RND > .8 AND airsize(i) > 0 THEN
			airsize(i) = airsize(i) - 1
			IF airsize(i) = 0 THEN airloc(i) = 0
			IF i = side THEN CALL image2(force$(side) + " plane " + a$, -4)
		END IF
	END IF
	cash(i) = cash(i) - x
NEXT i
'...........................................................................

chosit = 22
IF player = 2 THEN GOSUB blanken
IF autosave = 0 OR pbm = 1 OR player = 2 THEN CALL europe(0)
pcode = 0
CALL victor
ON ERROR GOTO 0
IF pcode > 0 GOTO newg
'±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
'                              Main Menu
'±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
menu0:
CALL statusbar
f3key = 1
IF player = 2 AND side = 0 THEN side = 1
IF cash(side) < 100 AND navyloc(side) = 0 THEN nflag = 1
CALL clrbot: COLOR 11: PRINT "Input your decisions now for "; force$(side); " side ";
CALL putflag(side, z)
CALL armyxy(350, 450, z)
LOCATE 10, 68: PRINT force$(side): CALL armyxy(590, 146, z)
LOCATE 26, 68: PRINT player; " Player"
hilite = 11
colour = 4
tlx = 67: tly = 11
mtx$(0) = "Main"
mtx$(1) = "Recruit": IF rflag < 0 OR cash(side) < 100 THEN mtx$(1) = "-": IF chosit = 22 THEN chosit = 23
mtx$(2) = "Navy": IF nflag > 0 THEN mtx$(2) = "-": IF chosit = 23 THEN chosit = 24
mtx$(3) = "Moves": IF mflag > 0 THEN mtx$(3) = "-": IF chosit = 24 THEN chosit = 25
mtx$(4) = "Air Force"
IF aflag > 1 THEN mtx$(4) = "-"
IF cash(side) < 70 - 5 * teklev(side, 8) AND airsize(side) < 1 THEN mtx$(4) = "-"
IF mtx$(4) = "-" AND chosit = 25 THEN chosit = 26
cost = 200 - 5 * teklev(who, 8)
mtx$(5) = "Tech": IF cash(side) < cost THEN mtx$(5) = "-": IF chosit = 26 THEN chosit = 27
mtx$(6) = "END TURN"
mtx$(7) = "Inform"
mtx$(8) = "COMMANDS"
mtx$(9) = "UTILITY"
mtx$(10) = "Editor"
mtx$(11) = "Files"
IF mflag = 1 THEN chosit = 27

size = 11
choose = chosit
CALL menu(0): CALL clrrite
IF choose = -4 THEN choose = 4: TICK .2         'airforce
IF choose = -2 THEN choose = 2: TICK .2
IF choose > 0 AND choose <= size THEN IF LEN(mtx$(choose)) < 2 GOTO menu0
'==========================================================================
'                            Main Menu
'==========================================================================
SELECT CASE choose
	CASE -1
	chosit = 22: GOTO menu0
	CASE 1
	IF cash(side) < 100 OR rflag < 0 THEN rflag = -1: GOTO menu0
	CALL recruit((side))
	chosit = 23
	GOTO menu0
'--------------------------------------------------------------------------
'                       navy
'--------------------------------------------------------------------------
	CASE 2
	IF weather = 4 AND teklev(side, 4) < 3 THEN CALL clrbot: PRINT "Seas are TOO STORMY for naval actions"; : TICK -3: CALL ships: GOTO menu0
	IF nflag = 0 THEN CALL navy((side), 0)
	CALL ships
	chosit = 24
'--------------------------------------------------------------------------
'                       army moves
'--------------------------------------------------------------------------
	CASE 3
	CALL movefrom(index, target)
	IF target > 0 AND index > 0 GOTO tent
	IF index = -1 THEN mflag = 1
	GOTO dudd

tent:
	CALL canimove(index, j)
	IF j > 0 THEN CALL clrbot: PRINT unitkind$(unittype(index)); " Unit "; index; " cannot move in "; forecast$(weather); : TICK .5 * turbo!: GOTO dudd

	tlx = 67: tly = 12
	CALL armystat(index)
	COLOR 11: LOCATE 11, 68: PRINT city$(target)
	CALL ikhan(index)

	size = 0
	mtx$(0) = "To"
	FOR i = 1 TO 6
		IF matrix(target, i) > 0 THEN
			x = matrix(target, i)
			IF matrix(x, 7) > 95 AND matrix(target, 7) > 95 THEN
				IF (teklev(side, 6) < 2 AND cityp(x) <> side) OR navyloc(3 - side) = x OR navyloc(3 - side) = target GOTO dork
			END IF
			size = size + 1
			mtx$(size) = city$(matrix(target, i))
			array(size) = matrix(target, i)
		END IF
dork:
	NEXT i
CALL bubble((size))

IF size < 1 THEN
	CALL clrbot: CALL MONIKER(index): PRINT " in "; city$(target); " cannot move";
	TICK 3
	CALL clrrite
	GOTO dudd
END IF
COLOR 14: LOCATE 3, 68: PRINT "MOVE TO"
hilite = 10: colour = 3: CALL menu(2): CALL clrrite
IF choose < 0 GOTO dudd
CALL clrbot: PRINT "Army "; index; " "; unitkind$(unittype(index)); " is moving from "; city$(target); " to "; city$(array(choose));
CALL icon(target, array(choose), 1)
CALL sndfx(1)
armymove(index) = array(choose): CALL TICK(turbo!): CALL clrbot
CALL clrrite
dudd:
IF index > 0 THEN CALL placearmy(index)
	chosit = 24
	GOTO menu0
'--------------------------------------------------------------------------
'                               airforce
'--------------------------------------------------------------------------
	CASE 4
	IF aflag < 2 THEN
		IF weather = 4 AND teklev(side, 7) < 3 THEN CALL clrbot: PRINT "Planes are FOGGED IN !"; : TICK -3: GOTO menu0
		CALL airforce(side, 0)
		CALL clrrite
		x = cityx(airloc(side)): y = cityy(airloc(side))
		LINE (x, y - 6)-(x + 8, y - 14), 2, BF
		CALL hangar
		CALL clrbot
	END IF
	chosit = 25
	IF mflag = 0 THEN chosit = 24
	IF rflag = 0 THEN chosit = 22
	GOTO menu0
'--------------------------------------------------------------------------
'                               technology

'--------------------------------------------------------------------------
	CASE 5
hitek:
	tlx = 67: tly = 15
	hilite = 14: colour = 5
	mtx$(0) = "Tech"
	FOR k = 1 TO 8: mtx$(k) = tname$(k) + tek$(teklev(side, k)): NEXT k
	a$ = "NO": IF teklev(side, 6) = 1 THEN a$ = "YES"
	mtx$(6) = "Amphib  " + a$
	IF teklev(side, 6) = 2 THEN mtx$(6) = "Invasion û"
	size = 8: chosit = 26
	TICK .2
	CALL menu(6)
	CALL clrrite
	IF choose < 1 GOTO menu0
	IF cash(side) < cost GOTO notek

	IF teklev(side, choose) > 2 GOTO maxlev
	SELECT CASE choose
		CASE 6
		IF teklev(side, choose) > 1 THEN GOTO maxlev
		IF teklev(side, 4) + teklev(side, 5) - 2 * (teklev(side, 6)) < 2 THEN
			CALL image2("Must First Increase Navy Tech", 4)
			GOTO menu0
		END IF
		CASE 8
		IF cash(side) < cost + 200 GOTO notek
		cash(side) = cash(side) - 200
	END SELECT
	cash(side) = cash(side) - cost
	IF RND < .01 * TSF THEN
	c = 9: IF side = 2 THEN c = 8
	CALL image2("SUCCESS! New Technology Achieved!", c)
		CALL news(force$(side) + " Achieve New " + tname$(choose) + " Technology")
		teklev(side, choose) = teklev(side, choose) + 1
		CALL sndfx(2)
	ELSE
		CALL image2("Technology Experiment Failed!", 4)
		IF noise > 0 AND sblast$ = "" THEN FOR k = 600 TO 400 STEP -20: SOUND k, .9: NEXT k
	END IF
	a = choose
	CALL showtek(side, choose)
	choose = 21 + a
	TICK 1
	GOTO hitek
maxlev:
	CALL clrbot
	PRINT "Technology is ALREADY AT MAXIMUM LEVEL"; : TICK -2
	GOTO hitek
notek:
	CALL clrbot: PRINT "Not enough funds to upgrade technology";
	GOTO hitek
'==========================================================================
'                               End Turn
'==========================================================================
	CASE 6
	tlx = 67: tly = 15
	hilite = 15: colour = 3: chosit = 27
	mtx$(0) = "End Turn"
	mtx$(1) = "Yes"
	mtx$(2) = "NOT YET"
	size = 2: CALL menu(0): CALL clrrite: IF choose <> 1 THEN chosit = 24: GOTO menu0
endturn:
	rflag = 0: mflag = 0: nflag = 0: aflag = 0
	IF pbm > 0 THEN GOSUB email
	IF player = 2 THEN
		side = side + 1
		IF side = 2 THEN
			IF pbm > 0 THEN
				GOTO emess
			ELSE
				GOSUB blanken
				CALL europe(0)
			END IF
			GOTO menu0
		END IF
	END IF
	GOTO newmnth
'==========================================================================
'                               Inform
'==========================================================================
	CASE 7
	CALL report((side))
	CALL showmove(side)
	CALL statusbar
	chosit = 28
'==========================================================================
'                            Commands
'==========================================================================
	CASE 8
	chosit = 24
optmen:
	tlx = 67: tly = 14
	COLOR 11: LOCATE tly - 2, tlx + 1: PRINT "esc=Main Menu"
	hilite = 15: colour = 3
	mtx$(0) = "COMMANDS"
	mtx$(1) = "Cancel"
	mtx$(2) = "Paratroop": IF rr(side) > 0 OR airsize(side) = 0 THEN mtx$(2) = "-"
	mtx$(3) = "Fortify": IF cash(side) < cost THEN mtx$(3) = "-"
	mtx$(4) = "Join"
	mtx$(5) = "Detach"
	mtx$(6) = "Supply"
	mtx$(7) = "Rotate"
	mtx$(8) = "Army Drill"
	mtx$(9) = "Static": IF cash(side) < costfac(5) THEN mtx$(9) = "-"
	size = 9
	CALL menu(10): CALL clrrite
	chosit = 29
	 SELECT CASE choose
'---------------------------------------------------------------------------
'                               Cancel
'---------------------------------------------------------------------------
		CASE -1
	CALL statusbar: GOTO menu0
		CASE 1
	CALL cancel(side): mflag = 0
	choose = 22
'---------------------------------------------------------------------------
'                               Paratroop
'---------------------------------------------------------------------------
		CASE 2
	IF rr(side) = 0 THEN
		IF weather = 4 AND teklev(side, 7) < 3 THEN CALL clrbot: PRINT "No air drops - planes are FOGGED IN !"; : TICK 3: GOTO menu0
		PUT (620, 1), drop, PSET
		COLOR 15: LOCATE 1, 68: PRINT "PARATROOP"
		CALL clrbot: PRINT "Capacity ="; RTRIM$(STR$(chute(side))); "00";
		CALL paratroop(side)
	ELSE
		CALL clrbot: PRINT "Already have paratroops in transit Elite unit"; rr(side); : PRINT " to "; city$(armymove(rr(side))); : TICK -2: GOTO menu0
	END IF
	choose = 23
	IF rr(side) > 0 THEN choose = 0
	GOTO optmen
'---------------------------------------------------------------------------
'                               Fortify
'---------------------------------------------------------------------------
		CASE 3
	IF cash(side) < cost THEN CALL clrbot: PRINT "Not enough money for fort"; : GOTO optmen
	CALL fortify(target)
	choose = 24
	GOTO optmen
'---------------------------------------------------------------------------
'                               Combine
'---------------------------------------------------------------------------
		CASE 4
	x = side
	CALL combine(x)
	IF x < 0 THEN CALL clrbot: PRINT "No armies in same city to combine"; : GOTO optmen
	choose = 25
	GOTO optmen
'-------------------------------------------------------------------------
'                               Detach
'-------------------------------------------------------------------------
		CASE 5
	COLOR 14: LOCATE 1, 68: PRINT "DETACH UNIT"
	CALL movefrom(index, target)
	IF target < 1 OR index < 1 GOTO optmen
	IF armysize(index) < 50 THEN CALL clrbot: PRINT "Too small to detach"; : CALL TICK(turbo!): GOTO menu0
	CALL detach(side, index, target)
	choose = 26
	GOTO optmen
'---------------------------------------------------------------------------
'                               Supply
'---------------------------------------------------------------------------
		CASE 6
	CALL starfin(star, fin, (side))
	mtx$(0) = "Supply"
	tlx = 67: tly = 5: colour = 5
	size = 0: FOR i = star TO fin
	IF armyloc(i) = 0 OR supply(i) > 0 GOTO alone
	size = size + 1
	mtx$(size) = city$(armyloc(i))
	array(size) = i
alone:
	NEXT i
	IF size = 0 THEN CALL clrbot: PRINT "All "; force$(side); " armies have supplies"; : TICK (turbo!): GOTO optmen
	CALL menu(5): CALL clrrite
	IF choose < 0 GOTO optmen
	index = array(choose)
	CALL resupply(index, 1)
	CALL placearmy(index)
	choose = 27
	GOTO optmen
'-------------------------------------------------------------------------
'                           Rotate Stack
'-------------------------------------------------------------------------
		CASE 7
	CALL rotate(side)
	choose = 28
	GOTO optmen
'-------------------------------------------------------------------------
'                               Drill
'-------------------------------------------------------------------------
		CASE 8
	COLOR 14: LOCATE 1, 68: PRINT "DRILL ARMY"
	v2 = 1
	CALL movefrom(index, target)
	v2 = 0
	choose = 29
	IF target < 1 OR index < 1 THEN CALL clrbot: PRINT "No armies remain eligible for drills in "; mnth$(mnth); : GOTO optmen
	IF armyexper(index) > 5 OR unittype(index) = 5 THEN CALL clrbot: MONIKER (index): PRINT "has reached maximum level from drilling"; : GOTO optmen
	armyexper(index) = armyexper(index) + 1
	CALL clrbot: MONIKER (index): PRINT "has drilled to reach experience level "; armyexper(index); : CALL sndfx(7)
	CALL TICK(turbo!): clrbot
	armymove(index) = -1
	GOTO optmen
'-------------------------------------------------------------------------
'                               Home Guard
'-------------------------------------------------------------------------
		CASE 9
	IF cash(side) < costfac(5) GOTO optmen
	CALL newcity(0, 0)
	IF choose < 0 OR choose <> 2 GOTO optmen
	target = array(choose)
	CALL homeguard(side, target)
	GOTO optmen
'........................................................................
		CASE ELSE
		chosit = 24
		GOTO menu0
	  END SELECT
	choose = 21 + choose: GOTO optmen
'==========================================================================
'                               Utility Menu
'==========================================================================
	CASE 9
utile:
	chosit = 30
	mtx$(0) = "Utility"
	mtx$(1) = "Side": IF player = 2 THEN mtx$(1) = "-"
	mtx$(2) = "1 Player": IF player = 2 THEN mtx$(2) = "2 Players"
	mtx$(3) = "Noise" + STR$(noise)
	IF noise > 0 AND sblast$ <> "" THEN mtx$(3) = mtx$(3) + " S"
	mtx$(4) = "Display" + STR$(turbo!)
	mtx$(5) = "Balance " + STR$(difficult - 3)
	mtx$(6) = "End Cond"
	mtx$(7) = "Vary Start"
	mtx$(8) = "Neutrals": IF neuter = 1 THEN mtx$(8) = mtx$(8) + " û"
	mtx$(9) = "Keyboard": IF Mighty > 0 THEN mtx$(9) = "Mouse"
	mtx$(10) = "Weather ": IF weather > 0 THEN mtx$(10) = mtx$(10) + " û"
	mtx$(11) = "Hi Scores"
	mtx$(12) = "Begin PBM": IF pbm > 0 THEN mtx$(12) = mtx$(12) + " û"
	mtx$(13) = "PBM Drv " + pb$
	mtx$(14) = "Autosave": IF autosave > 0 THEN mtx$(14) = mtx$(14) + " û"
	mtx$(15) = "Save Config"
	colour = 5: hilite = 15
	size = 15: tlx = 67: tly = 8
	COLOR 11: LOCATE tly - 2, tlx + 1: PRINT "esc=Main Menu"
	CALL menu(10)
	CALL clrrite
		SELECT CASE choose
'-------------------------------------------------------------------------
'                               Swap Sides
'-------------------------------------------------------------------------
		CASE -1
		CALL statusbar: GOTO menu0
		CASE 1
		IF player = 2 GOTO menu0
		side = 3 - side: CALL clrbot
		COLOR 1: IF side = 2 THEN COLOR 7
		PRINT "Now playing "; force$(side); " side"; : CALL sndfx(1)
		CALL statusbar
		GOTO menu0
'-------------------------------------------------------------------------
'                               Solo or 2 Player
'-------------------------------------------------------------------------
		CASE 2
		player = 3 - player: CALL clrbot
		CALL sndfx(1)
		a$ = "Solo": IF player = 2 THEN a$ = "2 Player"
		PRINT a$; " Game";
		choose = 23: GOTO utile
'-------------------------------------------------------------------------
'                               Sounds
'-------------------------------------------------------------------------
		CASE 3
		CALL clrrite: choose = noise + 22
		mtx$(0) = "SOUNDS"
		mtx$(1) = "Quiet"
		mtx$(2) = "Sound"
		mtx$(3) = " & Sound"
		size = 3: tlx = 67: tly = 12
		CALL menu(0): CALL clrrite
		IF choose < 1 GOTO menu0
		CALL clrbot: PRINT "Sound Option : "; mtx$(choose);
		noise = choose - 1
		CALL sndfx(1)
		choose = 24: GOTO utile
'-------------------------------------------------------------------------
'                               Display Speed
'-------------------------------------------------------------------------
		CASE 4
		choose = turbo! + 21
		mtx$(0) = "Speed"
		mtx$(1) = "Fast"
		mtx$(2) = "Normal"
		mtx$(3) = "Slow"
		mtx$(4) = "Very Slow"
		tlx = 67: tly = 15: size = 4
		CALL menu(0): CALL clrrite
		IF choose > 0 THEN
			turbo! = choose
			IF turbo! = 4 THEN turbo! = 8
			CALL clrbot
			PRINT "Display Speed : "; mtx$(choose);
		END IF
		choose = 25: GOTO utile
'-------------------------------------------------------------------------
'                               Play Balance
'-------------------------------------------------------------------------
	   CASE 5
facile:
		choose = difficult + 21
		mtx$(0) = "Balance"
		mtx$(1) = "Axis ++"
		mtx$(2) = "Axis +"
		mtx$(3) = "Balanced"
		mtx$(4) = "Allied +"
		mtx$(5) = "Allied ++"
		mtx$(difficult) = UCASE$(mtx$(difficult))
		tlx = 67: tly = 15: size = 5
		CALL menu(8): CALL clrrite
		IF choose < 1 GOTO menu0
		CALL clrbot: PRINT "Play Balance : "; mtx$(choose);
		difficult = choose
		choose = 26: GOTO facile
'-------------------------------------------------------------------------
'                               Ending Conditions
'-------------------------------------------------------------------------
	   CASE 6
		CALL endit
		choose = 27: GOTO utile
'-------------------------------------------------------------------------
'                              Vary Start Conditions
'-------------------------------------------------------------------------
	   CASE 7
		CALL filer(1)
	   FOR s = 1 TO 2
		star = 1: fin = 10: IF s = 2 THEN star = 31: fin = 40
		FOR k = star TO fin
			armyloc(k) = 0: armysize(k) = 0: unittype(k) = 0
			armyexper(k) = 0: armymove(k) = 0: supply(k) = 0
			nation(k) = 0
		IF RND > .6 THEN
			GOSUB placer
			IF x > 0 THEN
				armyloc(k) = x
				nation(k) = race(armyloc(k))
				armysize(k) = 120 + 50 * RND
				unittype(k) = 1 + INT(3 * RND)
				armyexper(k) = 9 * RND
				armymove(k) = 0
				supply(k) = 1 + 8 * RND
			END IF
		END IF
		NEXT k
	NEXT s
		FOR k = 1 TO ncity: CALL occupy(k): NEXT k
		FOR s = 1 TO 2
			a = 0
			navysize(s) = 0: airsize(s) = 0: navyloc(s) = 0: airloc(s) = 0
			IF RND > .5 THEN GOSUB placer
redux:
			IF x > 0 AND matrix(x, 7) > 90 THEN
				navyloc(s) = x: navysize(s) = 1 + 9 * RND
				GOSUB placer
				a = a + 1
				IF a < 9 GOTO redux
			END IF
			IF RND > .5 THEN GOSUB placer
			cash(s) = 100 + 300 * RND
			IF x > 0 THEN airloc(s) = x: airsize(s) = 1 + 9 * RND
		NEXT s
		CALL europe(0)
		choose = 28: GOTO utile
'-------------------------------------------------------------------------
'                               Neutrality
'-------------------------------------------------------------------------
	   CASE 8
		neuter = 1 - neuter
		choose = 29: GOTO utile
'-------------------------------------------------------------------------
'                               Mouse
'-------------------------------------------------------------------------
	   CASE 9
		Mighty = 1 - Mighty
		a$ = "": IF Mighty > 0 THEN a$ = "and MOUSE"
		a$ = a$ + " cntrl"
		CALL clrbot
		PRINT "Keyboard "; a$;
		choose = 30
		GOTO utile
'-------------------------------------------------------------------------
'                               Weather
'-------------------------------------------------------------------------
	   CASE 10
		weather = 1 - weather
		choose = 31
		GOTO utile
'-------------------------------------------------------------------------
'                               Clear High Scores
'-------------------------------------------------------------------------
	   CASE 11
		CALL maxx(1)
		tlx = 67: tly = 15
		hilite = 15: colour = 3
		mtx$(0) = "Clr Score"
		mtx$(1) = "Yes"
		mtx$(2) = "NO"
		size = 2: CALL menu(0)
		CALL clrbot
		CALL europe(0)
		IF choose <> 1 GOTO utile
		OPEN "O", 1, "hi" + begin$ + ".ww2"
		FOR k = 1 TO 10
		WRITE #1, "", 0
		NEXT k
		CLOSE #1
		CALL clrbot: PRINT "High Scores Cleared for "; begin$;
'-------------------------------------------------------------------------
'                               Begin PBM
'-------------------------------------------------------------------------
		CASE 12
		pbm = 1
		player = 2: side = 1: CALL clrbot: PRINT "Starting PBM Game for "; force$(side); " Side";
		GOTO pbmdrv
'-------------------------------------------------------------------------
'                               PBM Drive
'-------------------------------------------------------------------------
		CASE 13
pbmdrv:
		CALL clrrite
		mtx$(0) = "PBM Drive"
		mtx$(1) = LEFT$(CURDIR$, 2)
		mtx$(2) = "A:"
		mtx$(3) = "B:"
		size = 3: tlx = 67
		CALL menu(0)
		IF choose > 0 THEN pb$ = mtx$(choose)
		CALL clrrite
		GOTO sacf
'-------------------------------------------------------------------------
'                               Autosave
'-------------------------------------------------------------------------
	   CASE 14
		 autosave = 1 - autosave
		 choose = 35: GOTO utile
'-------------------------------------------------------------------------
'                               Save CFG
'-------------------------------------------------------------------------
	   CASE 15
sacf:
		OPEN "O", 1, "ww2.cfg"
		WRITE #1, side, noise, difficult, player, turbo!, batwon(1), batwon(2), casualty&(1), casualty&(2), neuter, Mighty, weather, pb$, autosave
		CLOSE #1
		CALL clrbot: PRINT "Configuration Saved"; : TICK 1
		END SELECT
'==========================================================================
'                               Editor
'==========================================================================
	CASE 10
		GOSUB yesno
		IF choose <> 1 GOTO menu0
		RUN "edit.exe"
'==========================================================================
'                               Files
'==========================================================================
	CASE 11
	ON ERROR GOTO filerr
	size = 0
	FOR k = 1 TO 10
	t$ = "ww" + LTRIM$(STR$(1938 + k)) + ".sav"
	IF LEN(DIR$(t$)) > 0 THEN size = size + 1: EXIT FOR
	NEXT k
filex:
	ON ERROR GOTO 0
	choose = 24: chosit = 32: IF filel = 0 THEN choose = 22
	mtx$(0) = "Options"
	mtx$(1) = "New Game"
	mtx$(2) = "Load": IF LEN(DIR$("*.sav")) = 0 THEN mtx$(2) = "-"
	mtx$(3) = "Save": IF filel = 0 THEN mtx$(3) = "-": choose = 22
	mtx$(4) = "Quit"
	size = 4: tlx = 67: tly = 15
	CALL menu(0): CALL clrrite
	SELECT CASE choose
		CASE IS < 0
			GOTO menu0
		CASE 1
			GOTO newgame
		CASE 4
			GOSUB yesno
			IF choose = 1 THEN END ELSE GOTO menu0
	END SELECT
'..........................................................................
loader:
	IF choose = 2 AND filel = 0 GOTO filex
	CALL filer(choose)
	IF choose < 0 THEN CALL europe(0)
	IF choose = 1 THEN rflag = 0: mflag = 0: nflag = 0: aflag = 0
	GOTO menu0
filerr:
	IF ERR = 53 THEN filel = 0: RESUME filex
	filel = 0: RESUME menu0
'==========================================================================
'                               Quick Turn
'==========================================================================
	CASE 99
	GOTO endturn
CASE ELSE
	chosit = 22
	GOTO menu0
END SELECT
GOTO menu0
'==========================================================================
blanken:        c = 1: IF side = 2 THEN c = 7
		CLS
		LINE (100, 200)-(500, 300), c, BF
		LINE (100, 200)-(500, 300), 8 - c, B
		COLOR 7: LOCATE 14, 31: PRINT " "; mnth$(mnth); yr
		COLOR 11: LOCATE 17, 30: PRINT force$(side); " PLAYER TURN"
		TICK 0
		RETURN
'...........................................................................
placer:
			spin = 0
site:
			x = 1 + INT(56 * RND): spin = spin + 1
			IF cityp(x) = s THEN RETURN
			IF spin < 25 GOTO site
			x = 0: RETURN
init:
pcode = 0: rflag = 0: mflag = 0: nflag = 0: aflag = 0
FOR k = 1 TO maxarmy: armysize(k) = 0: armyloc(k) = 0: armymove(k) = 0: supply(k) = 0: NEXT k
FOR k = 1 TO 2: victory&(k) = 0: tracks(k) = 0: NEXT k
RETURN
email:
	IF pbm > 1 THEN
		IF pbm > 100 THEN
		a$ = " : Ending size ="
		CALL news(force$(side) + " increases NAVY" + a$ + STR$(navysize(side)))
		x = pbm \ 100: pbm = pbm - 100 * x
		END IF
		IF pbm > 1 THEN
		CALL news(force$(side) + " increases AIRFORCE" + a$ + STR$(airsize(side)))
		END IF
	END IF
	x = INT(32767 * RND)
	CALL clrbot: PRINT "Updating PBM file...";
	OPEN "O", 1, pb$ + "pbm"
	k = 0
	IF LEN(DIR$("pbm.&&&")) > 0 THEN
		OPEN "I", 2, "pbm.&&&"
		DO WHILE NOT EOF(2) AND k < 21
			INPUT #2, a$
			k = k + 1
			mtx$(k) = a$
		LOOP
		CLOSE #2
		WRITE #1, k

		IF k > 0 THEN
			FOR j = 1 TO k
				WRITE #1, mtx$(j)
			NEXT j
		END IF
	KILL "pbm.&&&"          'purge temporary file
	ELSE
		WRITE #1, k
	END IF
	WRITE #1, begin$, x, mnth, yr, 3 - side, weather
	FOR i = 1 TO 4: WRITE #1, vicflag(i): NEXT i
	FOR i = 1 TO ncity
	WRITE #1, city$(i), occupied(i), cityp(i), fort(i)
	NEXT i
	FOR i = 1 TO maxarmy
	WRITE #1, nation(i), armyloc(i), unittype(i), armysize(i), armyexper(i), supply(i), armymove(i)
	NEXT i
	FOR i = 1 TO 2: WRITE #1, cash(i), cntrl(i), income(i), victory&(i), capcity(i)
	WRITE #1, navysize(i), navyloc(i), navymove(i), airsize(i), airloc(i), rr(i), tracks(i)
	NEXT i
	FOR j = 1 TO 2: FOR k = 1 TO 8: WRITE #1, teklev(j, k): NEXT k: NEXT j
	CLOSE #1
	a = RND(-x)
	CALL europe(0)
	RETURN
emess:
	CLS
	LINE (100, 100)-(500, 300), 7, BF
	LINE (440, 110)-(480, 160), 5, BF
	COLOR 15: LOCATE 13, 30: PRINT "PBM File has been saved"
	LOCATE 15, 30: PRINT "on Drive "; pb$
	LOCATE 17, 30: PRINT "to send to "; force$(side); " Player"
	COLOR 8: LOCATE 8, 15: PRINT "From: "; force$(3 - side); " Player"
	TICK -1
	END
nodisk:
	   IF ERR = 71 THEN
		GOSUB clrscrn
		COLOR 15: LOCATE 14, 35: PRINT "NO DISK IN "; pb$
		LOCATE 16, 27: PRINT "INSERT DISK OR CHANGE PBM DRIVE"
		TICK 0
	END IF
	   END
clrscrn:
	SCREEN 12
	CLS : LINE (0, 0)-(639, 449), 4, BF
	RETURN
yesno:
	choose = 23
	mtx$(0) = "Quit"
	mtx$(1) = "Yes"
	mtx$(2) = "No"
	size = 2: colour = 5
	tlx = 67: tly = 15
	CALL menu(0): CALL clrrite
	RETURN

'$INCLUDE: 'ww2a.bm'
'$INCLUDE: 'ww2b.bm'
'$INCLUDE: 'ww2c.bm'
'$INCLUDE: 'mickey.bm'
'$INCLUDE: 'qb64.bm'
'$INCLUDE: 'script.bm'
