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
DIM SHARED usai(80), uki(80), fri(80), poli(80), rusi(80), geri(80), alship(100)
DIM SHARED para(60), axship(100), drop(140), ike1(80), ike2(80), ike3(80), ike4(80)
DIM SHARED parasw
sblast$ = ""
pb$ = CURDIR$

SCREEN 12
s = 1
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
GET (117, 129)-(139, 142), alship
GET (117, 143)-(139, 156), axship
DEF SEG = VARSEG(graphic(1))
BLOAD "w2xtra.vga", VARPTR(graphic(1))
DEF SEG
PUT (100, 100), graphic, PSET
GET (101, 101)-(115, 112), para
GET (103, 114)-(122, 132), drop
GET (121, 100)-(137, 111), ike1
GET (121, 133)-(137, 143), ike2
GET (100, 133)-(116, 143), ike3
GET (100, 144)-(116, 153), ike4
RANDOMIZE TIMER
CALL title2
CALL filer(0)


IF COMMAND$ <> "" THEN
	sblast$ = UCASE$(COMMAND$)
	IF sblast$ = "S" THEN
	OPEN "I", 1, "x.cfg"
		INPUT #1, IRQ, DMA, PORT
		IF IRQ = 0 THEN IRQ = 7
		IF DMA = 0 THEN DMA = 544
		IF PORT = 0 THEN PORT = 1
		plany$ = " -i:" + LTRIM$(STR$(IRQ)) + " -d:" + LTRIM$(STR$(DMA)) + " -p:" + LTRIM$(STR$(PORT))
	CLOSE #1
	END IF
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
			DO WHILE INKEY$ = "": LOOP
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

'                              Main Menu

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
	IF teklev(side, 6) = 2 THEN mtx$(6) = "Invasion �"
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
	mtx$(8) = "Neutrals": IF neuter = 1 THEN mtx$(8) = mtx$(8) + " �"
	mtx$(9) = "Keyboard": IF Mighty > 0 THEN mtx$(9) = "Mouse"
	mtx$(10) = "Weather ": IF weather > 0 THEN mtx$(10) = mtx$(10) + " �"
	mtx$(11) = "Hi Scores"
	mtx$(12) = "Begin PBM": IF pbm > 0 THEN mtx$(12) = mtx$(12) + " �"
	mtx$(13) = "PBM Drv " + pb$
	mtx$(14) = "Autosave": IF autosave > 0 THEN mtx$(14) = mtx$(14) + " �"
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

SUB animate (index)
from = armyloc(index): to2 = armymove(index)
CALL placearmy(index)
armyloc(index) = 0
x = cityx(from) - 12
y = cityy(from) - 11
x1 = .5 * (cityx(to2) + cityx(from))
y1 = .5 * (cityy(to2) + cityy(from))

CALL occupy(from)
IF occupied(from) > 0 THEN CALL placearmy(occupied(from))
armyloc(index) = from
	   
	CALL placearmy(index)
	GET (x - 7, y - 5)-(x + 8, y + 6), anima
	CALL citygraf(from, c)
	IF occupied(from) = 0 THEN LINE (x - 7, y - 5)-(x + 10, y + 8), c, BF
	CALL placearmy(occupied(from))
IF noise > 0 THEN CALL sndfx(7)
	FOR i = 2 TO 8
	x1 = .1 * (i * cityx(to2) + (10 - i) * cityx(from))
	y1 = .1 * (i * cityy(to2) + (10 - i) * cityy(from))
	GET (x1 - 7, y1 - 6)-(x1 + 9, y1 + 9), image
	PUT (x1 - 7, y1 - 6), anima, PSET
	CALL TICK(.01)
	IF noise > 0 AND sblast$ = "" THEN SOUND 50, .03
	PUT (x1 - 7, y1 - 6), image, PSET
	NEXT i
END SUB

SUB armystat (index)
COLOR 9: IF index > 30 THEN COLOR 7
LOCATE 4, 68: PRINT SPACE$(12);
LOCATE 4, 68: PRINT country$(nation(index))
LOCATE 5, 68: PRINT SPACE$(12);
LOCATE 5, 68: PRINT unitkind$(unittype((index))); index
LINE (527, 80)-(639, 145), 0, BF
LOCATE 6, 68: PRINT "Size:"; : CALL strong(index)
LOCATE 7, 68: PRINT "Type:"; TAB(75); unittype(index)
LOCATE 8, 68: PRINT "Exper:"; TAB(75); armyexper(index)
IF supply(index) < 1 THEN COLOR 12
LOCATE 9, 68: PRINT "Supply:"; TAB(75); supply(index)
END SUB

SUB armyxy (x, y, z)
IF z > 0 THEN LINE (x + 3, y + 2)-(x + 17, y + 13), 0, BF
z = ABS(z)
SELECT CASE z
	   CASE 1
	PUT (x, y), usai, PSET
	   CASE 2, 7
	PUT (x, y), geri, PSET
	   CASE 3
	PUT (x, y), uki, PSET
	   CASE 4
	PUT (x, y), fri, PSET
	   CASE 5
	PUT (x, y), poli, PSET
	   CASE 6
	PUT (x, y), rusi, PSET
	   CASE 8
	LINE (x, y)-(x + 14, y + 8), 9, BF
	LINE (x, y)-(x + 14, y + 9), 15, B
	PSET (x + 5, y + 6), 9: DRAW "C15" + font$(1)
	   CASE 9 'Dutch
	LINE (x, y)-(x + 14, y + 2), 4, BF
	LINE (x, y + 3)-(x + 14, y + 6), 15, BF
	LINE (x, y + 7)-(x + 14, y + 9), 9, BF
	   CASE 10 'Belgian
	LINE (x, y)-(x + 4, y + 9), 0, BF
	LINE (x + 5, y)-(x + 9, y + 9), 14, BF
	LINE (x + 10, y)-(x + 14, y + 9), 4, BF
	   CASE ELSE
END SELECT
END SUB

SUB battle (attack, defend, win, lose)
'.............................losses from seaborne invasion.................
IF choose <> 99 THEN
IF matrix(armyloc(attack), 7) > 95 AND matrix(armyloc(defend), 7) > 95 THEN
	x = (.01 + .01 * RND) * armysize(attack): IF x < 1 THEN x = 1
	IF weather = 2 OR weather = 4 THEN x = 3 * x
	who = 1: IF attack > 30 THEN who = 2
	IF teklev(who, 3) > 2 THEN x = x \ 5
	armysize(attack) = armysize(attack) - x: IF armysize(attack) < 1 THEN armysize(attack) = 1
	CALL image2(force$(who) + " Invasion Losses :" + STR$(x) + "00", 4)
END IF
END IF
CALL icon(armyloc(defend), 0, 9)
CALL clrrite: y = 68: COLOR 11: LOCATE 1, y: PRINT "Attacker"
star = 1: c = 9: IF attack > 30 THEN c = 7: star = 2
COLOR c: LOCATE 2, y: PRINT unitkind$(unittype(attack))
LOCATE 3, y: CALL strong(attack)
x = .02 * armysize(attack) + 10 * atkfac(unittype(attack))
IF x > TCR THEN x = TCR
LOCATE 4, y: PRINT "Base    "; x
IF armysize(attack) / armysize(defend) > .2 THEN
	x = x + armyexper(attack)
	IF armyexper(attack) > 6 THEN x = x + armyexper(attack)
	IF x > TCR THEN x = TCR
END IF
LOCATE 5, y: PRINT "Ldr/Exp "; x
IF armysize(attack) < 15 THEN x = .5 * x: IF x > TCR THEN x = TCR
LOCATE 6, y: PRINT "Small   "; x
odds! = armysize(attack) / armysize(defend)
SELECT CASE odds!
	CASE IS <= .2
		x = 1
	CASE IS <= .5
		x = x - 2: IF x < 1 THEN x = 1
	CASE IS > 10
		x = TCR
	CASE IS > 3
		x = x + 2: IF x > TCR THEN x = TCR
END SELECT
LOCATE 7, y: PRINT "Outman  "; x
IF supply(attack) < 1 THEN x = .5 * x: COLOR 13
LOCATE 8, y: PRINT "Supply  "; x: COLOR c
IF x < 1 THEN x = 1
'                       Adjust attack advantage
IF attack < 31 AND side = 2 AND difficult > 3 THEN x = x + 2 * difficult - 6
IF attack > 30 AND side = 1 AND difficult < 3 THEN x = x + 6 - 2 * difficult
LOCATE 9, y: PRINT "Difclt  "; x
x = x + 5 * teklev(star, 1)
LOCATE 10, y: PRINT "Tech    "; x
IF x > TCR THEN x = TCR
COLOR 14: LOCATE 11, y + 1: PRINT "Attack "; x
LINE (532, 159)-(635, 175), 11, B
'................................defender...................................
COLOR 11
x1 = .025 * armysize(defend) + 1 + 10 * deffac(unittype(defend))
IF x1 > TCR THEN x1 = TCR
LOCATE 13, y: PRINT "Defender"
COLOR 16 - c: LOCATE 14, y:  PRINT unitkind$(unittype(defend))
LOCATE 15, y: CALL strong(defend)
LOCATE 16, y: PRINT "Base    "; x1
IF armysize(defend) / armysize(attack) > .2 THEN
	x1 = x1 + armyexper(defend)
	IF armyexper(defend) > 6 THEN x1 = x1 + armyexper(defend)
	IF x1 > TCR THEN x1 = TCR
END IF
LOCATE 17, y: PRINT "Ldr/Exp "; x1
IF armysize(defend) < 15 THEN x1 = .5 * x1
LOCATE 18, y: PRINT "Small   "; x1

odds! = armysize(defend) / armysize(attack)
SELECT CASE odds!
	CASE IS <= .2
		SELECT CASE fort(armyloc(defend))
			CASE 0
			x1 = .2 * x1
			CASE 1
			x1 = .4 * x1
			z = 1
			CASE IS > 1
			x1 = .6 * x1
			z = 2
		END SELECT
	CASE IS <= .5
		x1 = x1 - 2: IF x1 < 1 THEN x1 = 1
	CASE IS > 10
		x1 = TCR
	CASE IS > 2
		x1 = x1 + 2: IF x1 > TCR THEN x1 = TCR
END SELECT
IF x1 < 1 THEN x1 = 1

LOCATE 19, y: PRINT "Outman  "; x1
IF supply(defend) < 1 THEN
	IF unittype(defend) < 4 THEN x1 = .5 * x1 ELSE x1 = .8 * x1
	COLOR 13
END IF
LOCATE 20, y: PRINT "Supply  "; x1: COLOR 16 - c
IF x1 < 1 THEN x1 = 1
'                       Adjust defend advantage
IF defend < 31 AND side = 2 AND difficult > 3 THEN x1 = x1 + 2 * difficult - 6
IF defend > 30 AND side = 1 AND difficult < 3 THEN x1 = x1 + 6 - 2 * difficult
LOCATE 21, y: PRINT "Difclt  "; x1

a$ = "Fort"

IF armymove(defend) = 0 THEN x1 = x1 * (1 + z)
IF x1 > TCR THEN x1 = TCR
IF fort(armyloc(defend)) > 0 AND armymove(defend) = 0 THEN
	COLOR 13: a$ = "Fort+"
	IF fort(armyloc(defend)) = 2 THEN a$ = "Fort++"
END IF
LOCATE 22, y: PRINT a$; TAB(76); x1
COLOR 16 - c
x1 = x1 + 5 * teklev(3 - star, 2)
LOCATE 23, y: PRINT "Tech    "; x1
IF x1 > TCR THEN x1 = TCR

COLOR 14: LOCATE 24, y + 1: PRINT "Defend "; x1
LINE (532, 368)-(635, 384), 11, B

odds! = x / x1
SELECT CASE odds!
	CASE IS < .5
		odds! = .05 * odds!
	CASE IS < 1
		odds! = .2 * odds!
	CASE IS < 3
		odds! = .3 * odds! - .1
	CASE ELSE
		odds! = .067 * odds! + .6
END SELECT
IF odds! > .999 THEN odds! = .999
IF odds! < .001 THEN odds! = .001

a = INT(100 * odds!): IF a < 1 THEN a = 1
a$ = LTRIM$(RTRIM$(STR$(a))) + "%"
COLOR 14: LOCATE 26, y + 1: PRINT "Odds: "; a$;
LINE (534, 393)-(635, 420), 14, B
LINE (532, 391)-(637, 422), 14, B
CALL sndfx(8)
c = 9: s = 1: IF attack > 30 THEN s = 2: c = 8
CALL image2(force$(s) + " forces attack " + city$(armyloc(defend)), c)

t$ = "fort" + LTRIM$(STR$(z)) + ".vga"
IF LEN(DIR$(t$)) > 0 THEN
	DEF SEG = VARSEG(graphic(1))
	BLOAD t$, VARPTR(graphic(1))
	DEF SEG
	PUT (550, 270), graphic, PSET
END IF
FOR i = 1 TO 2: IF supply(i) > 0 THEN supply(i) = supply(i) - 1
NEXT i
'---------------------------------------------------------------------------
win = defend: lose = attack
IF RND < odds! THEN win = attack: lose = defend
'---------------------------------------------------------------------------
CALL clrrite
CALL tank(500, 0)
IF RND > .4 THEN
	GET (532, 1)-(639, 60), graphic
	FOR k = 0 TO 4
		PUT (532, 1 + 10 * k), graphic, PSET
		TICK .005
	NEXT k
	LINE (570, 68)-(532, 142), 14, , &HF0F0
	LINE (606, 68)-(639, 142), 14, , &HF0F0
END IF
c = 9: a = 1: IF attack > 30 THEN a = 2: c = 7
'===========================================================================
pct! = .08 - .02 * z
xbar = armysize(attack) * pct!
vary = xbar * (1 - pct!)
CALL normal(xbar, vary, killd)

pct! = .1 + .02 * z: IF win = defend THEN pct! = 1.5 * pct!
xbar = armysize(defend) * pct!
IF unittype(attack) = 3 THEN xbar = .5 * xbar
vary = xbar * (1 - pct!)
CALL normal(xbar, vary, killa)
'===========================================================================

killa = .8 * killa + .2 * killd: IF killa < 1 THEN killa = 1
killd = .8 * killd + .2 * killa: IF killd < 1 THEN killd = 1
IF killa > 9 * killd THEN killa = 9 * killd
IF killd > 5 * killa THEN killd = 5 * killa

IF killa >= armysize(attack) THEN killa = armysize(attack) - 1
IF killd >= armysize(defend) THEN killd = armysize(defend) - 1
'---------------------------------------------------------------------------
x = INT(100 * odds!): IF x < 1 THEN x = 1
a$ = LTRIM$(RTRIM$(STR$(x))) + "%"
COLOR c
LOCATE 21, 68: PRINT "Attack Loss"
LOCATE 22, 68: PRINT LTRIM$(RTRIM$(STR$(killa)) + "00"); " ("; LTRIM$(RTRIM$(STR$(INT(100 * (killa / armysize(attack)))))); "%)";
LOCATE 23, 68: PRINT "Force:": LOCATE 23, 74: strong (attack)
COLOR 16 - c
LOCATE 25, 68: PRINT "Defend Loss"
LOCATE 26, 68: PRINT LTRIM$(RTRIM$(STR$(killd)) + "00"); " ("; LTRIM$(RTRIM$(STR$(INT(100 * (killd / armysize(defend)))))); "%)";
LOCATE 27, 68: PRINT "Force:": LOCATE 27, 74: strong (defend)
LINE (532, 320)-(639, 430), 4, B
LINE (532, 375)-(639, 375), 4
'---------------------------------------------------------------------------
CALL clrbot
c = 9: a = 1: IF win > 30 THEN a = 2: c = 8
MONIKER (win): PRINT "has defeated "; : MONIKER (lose): PRINT "in "; city$(armyloc(defend));
CALL image2(force$(a) + " VICTORY in " + city$(armyloc(defend)), c)

armysize(attack) = armysize(attack) - killa
armysize(defend) = armysize(defend) - killd
IF armysize(defend) < 1 THEN armysize(defend) = 1
'---------------------------------------------------------------------------
casualty&(s) = casualty&(s) + killa
casualty&(3 - s) = casualty&(3 - s) + killd
'---------------------------------------------------------------------------
s = 1: IF win > 30 THEN s = 2
batwon(s) = batwon(s) + 1
victory&(s) = victory&(s) + 3
CALL icon(armyloc(defend), 0, 8)
END SUB

SUB C47
IF rr(1) + rr(2) = 0 THEN EXIT SUB
LINE (425, 140)-(520, 192), 3, BF
LINE (425, 140)-(520, 192), 0, B
LINE (425, 174)-(520, 174), 0, B
FOR i = 1 TO 2
IF rr(i) > 0 THEN
	c = 9: x = 435: y = 148: IF i = 2 THEN x = 480: c = 8
	PUT (x, y), drop, PSET
	PAINT (x + 6, y + 6), c, 15
	LOCATE 12, 6 * (i - 1) + 55: PRINT LEFT$(city$(armymove(rr(i))), 5)
END IF
crash:
NEXT i
END SUB

SUB canimove (index, flag)
flag = 0
IF weather < 2 THEN EXIT SUB
who = 1: IF index > 30 THEN who = 2
t = unittype(index)
c = armyexper(index)
SELECT CASE weather
	CASE 2
		IF cityy(armyloc(index)) < 190 THEN
			IF teklev(who, 3) = 3 THEN EXIT SUB
			IF t = 1 AND c < 8 THEN flag = 1: EXIT SUB
			IF t = 3 AND teklev(who, 3) < 2 THEN flag = 1
		END IF
	CASE 3
		x = 3
		IF teklev(who, 3) < x THEN
			IF t > 1 AND t < 4 THEN flag = 1: EXIT SUB
			IF c < x + 2 THEN flag = 1
		END IF
END SELECT
END SUB

SUB citygraf (index%, flag%)
flag = 2
FOR k = 1 TO 12
	IF gci(k) = index THEN flag = 1: EXIT SUB
NEXT k
END SUB

SUB combine (who)
gather:
	colour = 3: target = 0: hilite = 3
	tlx = 67: tly = 2
	CALL starfin(star, fin, who)
	size = 0
	FOR i = 1 TO ncity
		IF cityp(i) = who AND occupied(i) > 0 THEN
			FOR j = star TO fin
			IF armyloc(j) = i AND occupied(i) <> j AND armymove(j) = 0 THEN size = size + 1: mtx$(size) = city$(i): array(size) = i: EXIT FOR
			NEXT j
		END IF
	NEXT i
	
	IF size = 0 THEN who = -1: EXIT SUB
	CALL bubble((size))
	i = 0
rommel:
	IF who <> side THEN
		i = i + 1
		IF i <= size THEN
			choose = i
			GOTO join
		ELSE
			EXIT SUB
		END IF
	END IF
	mtx$(0) = "Join"
		choose = 31: hilite = 11
		CALL menu(19): CALL clrrite
join:
		IF choose < 1 GOTO nocity2
		target = array(choose)
		index = occupied(target): t$ = unitkind$(unittype(index)): c = unittype(index)

		armysize(0) = 0: unittype(0) = 0: armyexper(0) = 0: armyloc(0) = target
		supply(0) = 0: armymove(0) = 0: nation(0) = 0
'...........................................................................
		spin = 0
		FOR j = star TO fin
		IF armymove(j) <> 0 OR armyloc(j) <> target OR armysize(j) = 0 GOTO dork1
		IF armysize(0) + armysize(j) > 5000 THEN
			IF who = side THEN
				CALL clrbot
				PRINT "Cannot combine "; unitkind$(unittype(j)); j; : PRINT "... TOO LARGE";
				CALL TICK(-turbo!)
			END IF
			GOTO dork1
		END IF
		IF unittype(j) <> c THEN
			IF who = side THEN
				CALL clrbot
				PRINT unitkind$(unittype(j)); j; "is not "; t$; " Unit";
				CALL TICK(turbo!): GOTO dork1
			ELSE
				GOTO dork1
			END IF
		END IF

		armysize(0) = armysize(0) + armysize(j)
		IF armysize(0) < 1 GOTO dork1
		pct! = (armysize(j) / armysize(0))
		spin = spin + 1
		armyexper(0) = (1 - pct!) * armyexper(0) + pct! * armyexper(j)
		IF who = side THEN CALL clrbot: MONIKER (j): PRINT "in "; city$(target); " is combining "; : CALL strong(j): PRINT " forces"; : CALL TICK(-turbo!)
		supply(0) = supply(0) + supply(j)
		IF supply(0) > 10 THEN supply(0) = 10
		IF nation(0) = 0 THEN
			nation(0) = nation(j)
			unittype(0) = unittype(j)
			best = j
		END IF
		armysize(j) = 0: armyloc(j) = 0: armyexper(j) = 0: armymove(j) = 0
		unittype(j) = 0: supply(j) = 0: nation(j) = 0
dork1:
		NEXT j

		CALL clrbot
		IF who <> side AND spin = 0 GOTO rommel
		IF spin = 0 THEN
				PRINT "No valid armies to combine at this time in "; city$(target);
				TICK (-turbo!)
				EXIT SUB
		END IF
		armysize(best) = armysize(0): unittype(best) = unittype(0)
		armyexper(best) = armyexper(0): supply(best) = supply(0)
		armyloc(best) = target
		nation(best) = nation(0)

		IF spin > 1 THEN
		PRINT "New COMBINED "; force$(who); " "; unitkind$(unittype(best)); " Unit"; best; "in "; city$(armyloc(best)); " with "; : CALL strong(best): PRINT " men";
		CALL sndfx(6)
		armymove(best) = -1
		ELSE
		IF who = side THEN PRINT "Only 1 eligible army -- cannot combine at this time";
		END IF

		IF armymove(best) < 0 THEN
			CALL TICK(-turbo!)
			CALL clrbot
			CALL showcity(0)
			CALL placearmy(best)
			CALL icon(target, 0, 6)
		occupied(target) = best
		END IF
		CALL stax(who)
nocity2:
	IF who <> side GOTO rommel
END SUB

SUB flashcity (which)
x = cityx(which): y = cityy(which): z = cityp(which)
FOR c = 1 TO 15 STEP 4
CIRCLE (x, y), 5, 0
CIRCLE (x, y), 4, c
PAINT (x, y), c, c
CALL TICK(.1)
NEXT c
c = 9: IF z = 2 THEN c = 7
IF z = 0 THEN IF cityo(which) = 0 THEN c = 12 ELSE c = 5
CIRCLE (x, y), 5, 0
CIRCLE (x, y), 4, c
PAINT (x, y), c, c
IF fort(which) > 2 THEN CIRCLE (x, y), 2, 4: PAINT (x, y), 4
END SUB

SUB homeguard (who, target)
CALL starfin(star, fin, who)
FOR k = star TO fin
	IF unittype(k) = 5 AND armyloc(k) = target THEN CALL clrbot: PRINT city$(target); " already has a "; unitkind$(5); " unit": EXIT SUB
NEXT k
CALL commander(who, empty)
IF empty = 0 THEN EXIT SUB
armyexper(empty) = 0
supply(empty) = 2
armyloc(empty) = target
armymove(empty) = -1
unittype(empty) = 5
IF occupied(target) = 0 THEN occupied(target) = empty
IF cityo(target) = who THEN
	nation(empty) = race(target)
ELSE
	nation(empty) = 8
END IF
IF who = 2 THEN nation(empty) = 2
armysize(empty) = (20 * cityv(armyloc(empty)) + 70) * (100 / costfac(unittype(empty)))
IF who = side THEN CALL clrbot: PRINT "Placing "; : MONIKER (empty): PRINT "in "; city$(target); " (Str:"; : CALL strong(empty): PRINT ")"; : TICK -2: CALL clrbot
cash(who) = cash(who) - costfac(5): CALL sndfx(1)
CALL placearmy(empty)
END SUB

SUB icon (from, dest, kind)
IF from < 1 OR from > ncity OR dest < 0 THEN EXIT SUB
x = cityx(from) - 12: y = cityy(from) - 11
x1 = cityx(dest): y1 = cityy(dest)
SELECT CASE kind
	CASE 1
	LINE (x, y)-(x1, y1), 15, , &HF0F0
	   
	CASE 2
	LINE (x - 7, y - 5)-(x + 7, y + 5), 14, BF
	CALL TICK(.1)
	   
	CASE 3
	x = cityx(from): y = cityy(from)
	CALL snapshot(x, y, 0)
	FOR j = 1 TO 3
	FOR i = 4 TO 7 + j
	a = 4: c = 14: IF j < 3 THEN c = 4: a = 0
	CIRCLE (x, y), i, a
	PAINT (x, y), c, a
	NEXT i
	CALL TICK(.1)
	CALL sndfx(9)
	CALL snapshot(x, y, 1)
	NEXT j
	 
	CASE 4
	CALL citygraf(from, c)
	IF occupied(from) = 0 THEN LINE (x - 6, y - 5)-(x + 10, y + 8), c, BF
	IF x1 + y1 > 0 THEN LINE (x, y)-(x1, y1), 2, , &HF0F0

	CASE 5
	IF x1 + y1 > 0 THEN LINE (x, y)-(x1, y1), 2, , &HF0F0

	CASE 6
	x = cityx(from): y = cityy(from)
	CALL snapshot(x, y, 0)
	LINE (x - 9, y - 9)-(x + 9, y + 9), 15, B
	LINE (x - 10, y - 10)-(x + 10, y + 10), 15, B
	CALL sndfx(1)
	CALL TICK(turbo! - 1)
	CALL snapshot(x, y, 1)
	CASE 7          ' draw white box
	x = cityx(from) - 12: y = cityy(from) - 11
	GET (x - 8, y - 8)-(x + 8, y + 8), image
	LINE (x - 7, y - 5)-(x + 7, y + 7), 15, B
	LINE (x - 6, y - 5)-(x + 6, y + 6), 15, B
		 CASE 8     ' replace old image
	x = cityx(from) - 12: y = cityy(from) - 11
	IF x > 0 THEN PUT (x - 8, y - 8), image, PSET
	   
	CASE 9          ' draw arrow pointer
	x = cityx(from) - 12: y = cityy(from) - 11
	GET (x - 8, y - 8)-(x + 10, y + 7), image
	x = x + 7: y = y + 5
	LINE (x + 2, y)-(x + 2, y - 8), 12
	LINE -(x, y - 6), 12
	LINE -(x - 5, y - 11), 12
	LINE -(x - 10, y - 6), 12
	LINE -(x - 6, y - 2), 12
	LINE -(x - 10, y), 12
	LINE -(x + 1, y), 12
	PAINT (x - 2, y - 1), 15, 12

	CASE 10
	x = cityx(from) - 12: y = cityy(from) - 12
	CIRCLE (x, y), 3, 5
	PAINT (x, y), 14, 5

	CASE 11
	LINE (x + 12, y + 11)-(x1, y1), 0, , &H1111

	CASE 12, 13
	FOR k = 8 TO 0 STEP -2
	LINE (x - 7, y - 5)-(x + 7, y + 5), k, BF
	TICK .01
	IF noise > 0 THEN
		IF sblast$ = "" THEN SOUND 244, .1: SOUND 388, .1 ELSE IF k = 0 THEN CALL sndblst("ding.voc", 0)
	END IF

	IF kind = 12 THEN
		PSET (x - 4, y + 2), 15: DRAW "C15S4" + font$(14) + "BD4BR2" + font$(15)
	ELSE
		PSET (cityx(from) - 18, cityy(from) - 9), 0
		DRAW "C14S4" + font$(12) + "BR1" + font$(15) + "BR5" + font$(23)
	END IF
	NEXT k
	CALL TICK(.1)

	CASE ELSE
END SELECT
END SUB

SUB ikhan (index)
x = cityx(armyloc(index)) - 19
y = cityy(armyloc(index)) - 16
LINE (x, y)-(x + 14, y + 13), 0, BF
c = unittype(index)
SELECT CASE c
	CASE 1, 5
		PUT (x, y), ike1, PSET
	CASE 2
		PUT (x, y), ike2, PSET
	CASE 3
		PUT (x, y), ike3, PSET
	CASE 4
		PUT (x, y), ike4, PSET
END SELECT
END SUB

SUB movefrom (index, target)
	flag = 0
	who = side: CALL starfin(star, fin, who)
morearm:
	colour = 3: index = 0: size = 0: target = 0
	FOR i = star TO fin
	IF armyloc(i) > 0 AND armymove(i) = 0 THEN
		IF v2 > 0 THEN IF armyexper(i) > 5 OR unittype(i) = 5 GOTO flop
		IF parasw = 1 AND (unittype(i) <> 4 OR armysize(i) > chute(who)) GOTO flop
			FOR j = 1 TO size
			IF array(j) = armyloc(i) GOTO flop
			NEXT j
		size = size + 1
		IF size > 20 AND flag = 0 THEN flag = i: size = 20: GOTO flop2
		mtx$(size) = city$(armyloc(i))
		array(size) = armyloc(i)
	END IF
flop:
	NEXT i
	IF size = 0 THEN index = -1: EXIT SUB
flop2:
	mtx$(0) = "From"
	CALL bubble((size))
	IF flag > 0 THEN COLOR 4: LOCATE 1, 67: PRINT "ESC for MORE"
movopt:
	tlx = 67: tly = 2
		hilite = 14
		IF parasw = 0 THEN CALL menu(2) ELSE CALL menu(12)
		CALL clrrite
		IF choose < 0 THEN
			IF flag < 1 THEN target = 0: EXIT SUB
			star = flag: flag = -1: GOTO morearm
		END IF
		target = array(choose)

		size = 0
		FOR i = star TO fin
		IF armyloc(i) = target AND armymove(i) = 0 THEN
			IF parasw = 1 AND unittype(i) <> 4 GOTO notpara
			index = i: size = size + 1
			mtx$(size) = "Army" + STR$(i)
			array(size) = i
		END IF
notpara:
		NEXT i
		IF size = 1 THEN EXIT SUB

		mtx$(0) = "Which"
		CALL bubble((size))
		tlx = 67: tly = 15: CALL menu(4): CALL clrrite
		IF choose < 0 THEN index = 0: EXIT SUB
		index = array(choose)
END SUB

SUB newcity (index, flag)
		mtx$(1) = "  "
		mtx$(3) = "  "
		size = 3: a$ = city$(index)
		a = flag
		IF Mighty = 0 THEN utility1 = 0
morecap:
		tlx = 68: tly = 15: colour = 3: choose = 23
		mtx$(2) = city$(index)
		spin = 0
		array(2) = index
		SELECT CASE a
			CASE 2, IS > 9: CALL menu(13)
			CASE ELSE: CALL menu(3)
		END SELECT
		CALL clrrite

		IF choose = -27 THEN index = 0: EXIT SUB
		IF utility1 > 0 THEN index = choose

		IF (choose = 2 OR utility1 > 0) AND flag <> 0 THEN
			CALL airdist((side), index, d)
			IF d < 0 THEN CALL clrbot: PRINT "ILLEGAL CHOICE: "; city$(index); " is OUT OF RANGE"; : GOTO morecap
		END IF

		IF utility1 > 0 THEN utility1 = 0: EXIT SUB
		IF Mighty > 0 THEN a = flag + 10

		   SELECT CASE choose
		CASE IS < 1
		a$ = CHR$(ABS(choose))

		x = 0
		FOR k = 1 TO ncity
		IF LEFT$(city$(k), 1) = a$ THEN
			y = index: index = k
spin2:
			IF (flag = 0 AND cityp(index) = side) OR (flag = 1 AND cityp(index) = 3 - side) OR (flag = 2 AND cityp(index) <> 3 - side) GOTO morecap
				index = index + 1
				IF index > ncity THEN index = 1
				x = x + 1: IF x < ncity - 1 GOTO spin2
				index = y: GOTO morecap
		END IF
		NEXT k
		GOTO morecap

		CASE 1
minus1:
		index = index - 1: IF index < 1 THEN index = ncity
		IF LEFT$(city$(index), 1) = "[" GOTO minus1
		IF flag <> 0 THEN CALL airdist((side), index, d)
		spin = spin + 1: IF spin > 99 THEN EXIT SUB
		IF d < 0 GOTO minus1
		IF (flag = 0 AND cityp(index) <> side) OR (flag = 1 AND cityp(index) <> 3 - side) GOTO minus1 ELSE GOTO morecap
		CASE 2
		EXIT SUB
		CASE 3
plus1:
		index = index + 1: IF index > ncity THEN index = 1
		IF LEFT$(city$(index), 1) = "[" GOTO plus1
		IF flag <> 0 THEN CALL airdist((side), index, d)
		spin = spin + 1: IF spin > 99 THEN EXIT SUB
		IF d < 0 GOTO plus1
		IF (flag = 0 AND cityp(index) <> side) OR (flag = 1 AND cityp(index) <> 3 - side) GOTO plus1 ELSE GOTO morecap
		CASE ELSE
		index = 0
		END SELECT
END SUB

SUB news (a$)
IF pbm < 1 THEN EXIT SUB
OPEN "A", 1, "pbm.&&&"
WRITE #1, a$
CLOSE #1
END SUB

SUB paratroop (who)
chute(who) = 15 * (airsize(who) * (teklev(who, 7) + 1)): IF chute(who) < 1 THEN EXIT SUB
IF who = side THEN CALL clrbot: PRINT "Paratroop Capacity ="; RTRIM$(STR$(chute(who))); "00";
SELECT CASE rr(who)
	CASE 0
	IF who = side GOTO human
	CALL starfin(star, fin, who): max = 32767
	index = 0
	FOR i = star TO fin
	IF armyloc(i) = 0 OR armyloc(i) > 56 OR armymove(i) <> 0 OR unittype(i) <> 4 GOTO puter
	IF armysize(i) > chute(who) GOTO puter
	CALL void(armyloc(i), defend)
	IF defend < max THEN
		CALL airdist(who, armyloc(i), d)
		IF d >= 0 THEN
			target = armyloc(i)
			max = defend
			index = i
		END IF
	END IF
puter:  NEXT i

	IF index = 0 OR max > 2 * armysize(index) THEN EXIT SUB
	x = 1: IF index > 30 THEN x = 2
	IF armysize(index) > chute(x) THEN GOTO toot

	from = armyloc(index): x1 = 0
	FOR i = 1 TO ncity - 2
		IF cityp(i) = 3 - who GOTO puted
		CALL void(i, defend)
		IF defend = 0 OR defend > 3 * armysize(index) GOTO puted
		IF occupied(i) > 0 GOTO puted
		CALL airdist(who, i, d)
		IF d > 0 THEN
			x1 = i
			IF cityp(i) = 0 GOTO haul
			IF fort(i) > 0 AND fort(i) < 3 AND occupied(i) = 0 GOTO haul
		END IF
puted:  NEXT i
	IF x1 > 0 THEN GOTO haul ELSE GOTO toot
'...........................................................................
human:
	CALL gcirc(airloc(side), 15)

	parasw = 1
	CALL movefrom(index, a)
	parasw = 0
	IF index = 0 THEN GOTO toot
	IF armyloc(index) > 56 THEN CALL clrbot: PRINT "ILLEGAL PARATROOP MOVE"; : TICK 2: CALL clrbot: CALL clrrite: GOTO tooter
	IF index < 0 THEN CALL clrbot: PRINT "NO ELIGIBLE UNITS TO PARATROOP - CAPACITY="; RTRIM$(STR$(chute(who))); "00"; : TICK 2: CALL clrbot: CALL clrrite: GOTO tooter
	IF unittype(index) <> 4 THEN CALL clrbot: PRINT "ONLY ELITE UNITS CAN PARATROOP"; : TICK 2: CALL clrbot: CALL clrrite: GOTO tooter
	CALL airdist(who, armyloc(index), d)
	IF d < 0 THEN
		IF who = side THEN CALL clrbot: PRINT "TOO FAR FROM AIRBASE at "; city$(airloc(who));
tooter:
		CALL gcirc(airloc(side), 2)
		IF index > 0 THEN CALL placearmy(index)
		EXIT SUB
	END IF

	IF a < 1 OR index < 1 THEN CALL clrbot: PRINT "Paratroop move not allowed"; : GOTO tooter
	x = 1: IF index > 30 THEN x = 2
	IF armysize(index) > chute(x) THEN CALL clrbot: PRINT "Too many troops for paratroop capacity"; : GOTO tooter
	target = armyloc(index)
aboard:
	CALL clrbot: PRINT "Select destination for "; unitkind$(unittype(index)); index; " from "; city$(target);
	mtx$(0) = "To": from = target: x1 = from: IF from = 0 GOTO toot
	utility1 = Mighty
	CALL newcity(x1, 2)
	IF x1 = from OR x1 = 0 GOTO toot
	IF fort(x1) > 2 THEN CALL clrbot: PRINT "A/A in city too strong -- cannot drop in "; city$(x1); : GOTO toot
	IF cityp(x1) = 3 - who THEN CALL clrbot: PRINT "Cannot paradrop into Enemy city: "; city$(x1); : GOTO toot
	target = x1
haul:
	CALL clrbot: MONIKER (index): PRINT "is paradropping from "; city$(from); " to "; city$(x1);
	tracks(who) = armyloc(index)
	from = armyloc(index)
	rr(who) = index: armyloc(index) = 0: armymove(index) = x1
	CALL trooper(who, 1)
	CALL sndfx(1)
	CALL C47

	CALL occupy(from)
	IF occupied(from) > 0 THEN CALL placearmy(occupied(from))
	GOTO toot

	CASE IS > 0
	CALL trooper(who, 0)
	index = rr(who)
	tracks(who) = armymove(index)
	CALL trooper(who, 1)
	rr(who) = 0: armyloc(index) = armymove(index): armymove(index) = -1
	CALL clrbot: MONIKER (index): PRINT "paratroop force has arrived in "; city$(armyloc(index)); : CALL sndfx(2)
	CALL TICK(turbo!)
	x = cityx(armyloc(index)) - 12: y = cityy(armyloc(index)) - 11
	LINE (x - 7, y - 5)-(x + 10, y + 8), 2, BF
	IF cityp(armyloc(index)) <> who THEN CALL capture(index, armyloc(index), who, 0, 1)
	CALL starfin(star, fin, who)
	FOR k = star TO fin: CALL placearmy(k): NEXT k
	IF occupied(armyloc(index)) > 0 THEN CALL icon(armyloc(index), 0, 10): GOTO toot
	CALL occupy(armyloc(index)): CALL placearmy(index)
	GOTO toot
END SELECT

toot:
	IF who = side THEN CALL gcirc(airloc(side), 2)
	CALL TICK(-turbo!)
	clrbot
END SUB

SUB pbmview
	CLS
	LINE (0, 0)-(639, 449), 4, BF
	COLOR 14: LOCATE 8, 31: PRINT begin$ + " PBM Game is Over"
	LINE (189, 160)-(450, 230), 15, B
	COLOR 9: LOCATE 12, 35: PRINT force$(1), victory&(1)
	COLOR 7: LOCATE 14, 35: PRINT force$(2), victory&(2)
	COLOR 5: LOCATE 17, 35: PRINT "Final Scores"
	TICK -1
END SUB

SUB placearmy (which)
IF which < 1 OR armysize(which) < 1 THEN EXIT SUB
who = nation(which)
x = cityx(armyloc(which)) - 12: y = cityy(armyloc(which)) - 11
IF armymove(which) <> 0 THEN who = -who
CALL armyxy(x - 7, y - 5, who)
IF (side = 1 AND which < 31) OR (side = 2 AND which > 30) THEN
	IF armymove(which) <> 0 THEN
		CALL citygraf(armyloc(which), c)
		LINE (x + 8, y - 5)-(x + 11, y + 5), c, BF
	END IF
END IF
IF supply(which) < 1 THEN
	x = x - 3: y = y + 4
	a$ = "0": IF which > 30 THEN a$ = "7"
	IF nation(which) = 3 THEN a$ = "11"
	PSET (x, y), 0
	DRAW "C" + a$ + "S8" + font$(19) + "S4"
END IF
END SUB

SUB putflag (who, z)
IF who = 2 THEN z = who: EXIT SUB
FOR i = 1 TO 30
IF armysize(i) > 0 THEN z = nation(i): EXIT SUB
NEXT i
END SUB

SUB recruit (who)
levy:
	IF cash(who) < 100 GOTO menu1
	size = 0: COLOR 12
	mtx$(0) = "Recruit"
	IF who = side AND rflag > 0 THEN
		FOR i = 1 TO rflag
		x = rcity(i)
		mtx$(i) = city$(x)
		array(i) = x
		NEXT i
		size = rflag
		GOTO fini
	END IF
	max = 5: IF RND > .9 AND who = side THEN max = 2
	IF difficult < 3 OR who <> side THEN max = max + 1

	FOR i = 1 TO 56
	pct! = .6 * max / cntrl(who)

	IF size = 0 THEN
		IF cntrl(who) < 4 THEN
		   pct! = 1
		ELSE
		   IF i > 20 THEN pct! = .4
		END IF
	END IF
	IF size < max THEN pct! = 3 * pct!
	IF (size < 3 AND i > 25) OR (i > 40 AND size < max) THEN pct! = .9

	array(i) = 0
	IF occupied(i) > 0 AND armysize(occupied(i)) < 3000 AND cityp(i) = who THEN pct! = .4
	IF RND < pct! AND cityp(i) = who THEN
		IF cityo(i) <> who GOTO foe
		size = size + 1
		mtx$(size) = city$(i)
		array(size) = i
		IF size > max - 1 THEN EXIT FOR
	END IF
foe:
	NEXT i
'............................................................................
'                 Special provision for USA & Russian Recruits
'............................................................................
alldone:
	IF who = 1 THEN
		FOR k = 57 TO ncity
			IF cityp(k) = who AND RND > .4 THEN
				size = size + 1
				mtx$(size) = city$(k)
				array(size) = k
			END IF
		NEXT k
	END IF
'............................................................................
fini:
	IF size = 0 THEN
		IF who = side THEN
		CALL clrbot
		PRINT "No more recruiting this turn"; : TICK -2
		END IF
		GOTO menu1
	END IF
	IF who = side AND rflag = 0 THEN FOR i = 1 TO size: rcity(i) = array(i): NEXT i: rflag = size
	CALL bubble((size))

	IF cash(who) < 100 GOTO menu1

	IF (who = side) OR (player = 2) THEN
		tlx = 67: tly = 12: colour = 3
		CALL clrbot: PRINT force$(who); " funds available "; cash(who);
		LOCATE 5, 68: PRINT "Attack:"; teklev(who, 1)
		LOCATE 6, 68: PRINT "Defend:"; teklev(who, 2)
		LOCATE 7, 68: PRINT "Mobile:"; teklev(who, 3)
		LOCATE 9, 68: PRINT "PROD TECH:"; teklev(who, 8)
		COLOR 15: LOCATE 2, 71: PRINT "Army"
		LOCATE 3, 68: PRINT "Technology"
		LINE (532, 60)-(639, 114), 12, B
	END IF
	IF who <> side THEN GOSUB randsel: GOTO auto1
	  
	CALL menu(12): CALL clrrite
	IF choose < 1 GOTO menu1
	target = array(choose): index = choose
auto1:
	empty = 0
	IF occupied(target) > 0 THEN
		i = occupied(target)
		GOTO add2
	END IF
	CALL commander((who), empty)
	   
	IF who <> side AND empty = 0 GOTO menu1
	IF empty = 0 GOTO levy

	nation(empty) = 0
	CALL newarmy(who, empty, target)
	IF empty = 0 THEN EXIT SUB
	GOTO levy
add2:
	GOSUB playb
	a = (15 * cityv(target) + 100) * (100 / costfac(unittype(i)))
	IF a > 250 THEN a = 250
	armysize(i) = armysize(i) + a
	GOSUB playb
	cash(who) = cash(who) - 100 + 5 * teklev(who, 8)
	from = armyloc(i): x = cityx(from) - 12: y = cityy(from) - 11
	GET (x - 9, y - 7)-(x + 9, y + 6), anima
	CALL icon(armyloc(i), 0, 2)
	CALL sndfx(7)

	CALL clrbot: PRINT force$(who); " "; unitkind$(unittype(i)); i; "in "; city$(armyloc(i)); " strength increased to "; : CALL strong(i)
	PUT (x - 9, y - 7), anima, PSET
	CALL TICK(turbo! - 1)
	choose = 21 + index
	GOTO levy
randsel:
		x = 0: choose = 0
		FOR i = 1 TO size
		target = array(i)
		IF occupied(target) = 0 THEN
			y = 2 * cityv(target)
			IF target = capcity(3 - side) THEN
				CALL void(target, z)
				IF z > armysize(occupied(target)) THEN y = 10 * y
			END IF
		ELSE
			y = cityv(target)
			SELECT CASE armysize(occupied(target))
				CASE IS < 500
				y = 2 * y
				CASE IS > 2900
				y = 1
			END SELECT
		END IF
		IF who = 1 THEN
			IF cityy(target) > 55 THEN y = y + 20
			IF target > 56 AND occupied(target) = 0 AND RND > .4 THEN choose = i: RETURN
		END IF
		IF y > x AND RND > .2 THEN x = y: choose = i
		NEXT i
	IF choose = 0 THEN choose = 1 + INT(RND * size)
	IF cash(who) < 100 THEN choose = size
	target = array(choose)
	RETURN
playb:
	SELECT CASE side
		CASE 1
		IF difficult < 3 THEN armysize(empty) = armysize(empty) + 15 - 5 * difficult
		CASE 2
		IF difficult > 3 THEN armysize(empty) = armysize(empty) + 5 * difficult - 15
	END SELECT
	RETURN
menu1:
END SUB

SUB shipicon (a)
	x = POINT(0) - 10
	y = POINT(1) - 10
	LINE (x, y)-(x + 26, y + 14), 0, BF
SELECT CASE a
CASE 1
	PUT (x, y), alship, PSET
CASE 2
	PUT (x, y), axship, PSET
END SELECT
shipx(a) = x + 9: shipy(a) = y + 5
END SUB

SUB showcity (index)
IF index < 1 THEN index = 1
FOR i = index TO ncity
c = 9: IF cityp(i) = 2 THEN c = 7
IF cityp(i) = 0 THEN
	IF cityo(i) = 0 THEN c = 12 ELSE c = 5
END IF
x = cityx(i): y = cityy(i)
IF fort(i) = 1 THEN LINE (x - 6, y - 6)-(x + 6, y + 6), 0, B
IF fort(i) > 1 THEN LINE (x - 6, y - 6)-(x + 6, y + 6), 0, BF
IF LEFT$(city$(i), 1) <> "[" THEN
	CIRCLE (cityx(i), cityy(i)), 5, 0
	CIRCLE (cityx(i), cityy(i)), 4, c
	PAINT (cityx(i), cityy(i)), c, c
ELSE
	CIRCLE (cityx(i), cityy(i)), 7, 0, , , 1.5
	CIRCLE (cityx(i), cityy(i)), 5, c, , , 1.5
	PAINT (cityx(i), cityy(i)), c, c
END IF

IF fort(i) > 2 THEN
	CIRCLE (x, y), 2, 4
	PAINT (x, y), 4
END IF

FOR j = 1 TO 6: IF matrix(i, j) > 0 THEN CALL icon(i, matrix(i, j), 11)
NEXT j
IF i = capcity(1) OR i = capcity(2) THEN COLOR 0: LINE (x - 4, y)-(x + 4, y): LINE (x, y - 4)-(x, y + 4)
NEXT i
CALL hangar
END SUB

SUB smarts
slush = 0: who = 3 - side
CALL clrbot
COLOR 11: PRINT force$(who); " Side is making decisions";
CALL starfin(star, fin, who)
'==========================================================================
'                       Check Supply
'==========================================================================
FOR i = star TO fin
	IF armyloc(i) > 0 AND supply(i) < 1 THEN CALL resupply(i, 0)
NEXT i
'==========================================================================
'                       Fortify Capital or Other Key City
'==========================================================================
cost = 200 - 5 * teklev(who, 8)
IF cost > cash(who) GOTO randd
CALL void(capcity(who), defend)
IF defend = 0 GOTO randd

target = 0
IF occupied(capcity(who)) = 0 OR fort(capcity(who)) > 1 GOTO city2
target = capcity(who): IF target < 1 GOTO city2
IF cityp(target) = who GOTO capital

city2:
target = 0: FOR i = star TO fin
x = armyloc(i): IF x = 0 OR x > 56 OR armymove(occupied(x)) < 0 OR armymove(i) < 0 GOTO endlook
IF fort(x) > 1 GOTO endlook
	CALL void(x, defend)
	IF defend > armysize(i) * (2 + atkfac(unittype(i))) THEN target = armyloc(i): GOTO capital
endlook:
NEXT i

capital:
	IF target = 0 GOTO randd
	IF fort(target) > 1 GOTO randd
	fort(target) = fort(target) + 1
	x = occupied(target): armymove(x) = -1
	cash(who) = cash(who) - cost
	CALL icon(target, 0, 6)
	CALL showcity(0)
'==========================================================================
'                       Research -- New Technologies
'==========================================================================
randd:
	zmax = 0
	cost = 400 - 5 * teklev(who, 8)
	IF cash(who) < cost GOTO lotek
		IF teklev(who, 8) < 3 AND RND > .5 THEN
			teklev(who, 8) = teklev(who, 8) + 1
			cash(who) = cash(who) - cost
			zmax = 1
			GOTO signup
		END IF
lotek:
	cost = 200 - 5 * teklev(who, 8)
	dx = 0
	FOR k = 1 TO 7
		dx = dx + teklev(3 - who, k) - teklev(who, k)
	NEXT k
	IF teklev(who, 6) < 2 THEN dx = 3
	IF cash(who) > 999 THEN dx = 3
	IF cash(who) < cost OR dx < 3 GOTO signup
		IF teklev(who, 6) < 2 AND RND > .2 THEN
			IF teklev(who, 4) + teklev(who, 5) - 2 * (teklev(who, 6)) >= 2 THEN index = 6: GOTO invade
			FOR k = 4 TO 5
				IF teklev(who, k) < 3 THEN index = k: GOTO invade
			NEXT k
		END IF
		index = 0
		FOR k = 1 TO 7
		z = 4: IF k = 6 THEN z = 2
		IF teklev(side, k) - (teklev(who, k)) > 1 OR (who = 1 AND teklev(who, k) < 2 AND RND > .3) THEN
			IF teklev(who, k) < z THEN index = k
			SELECT CASE k
				CASE 3
				IF RND > .5 THEN index = 0
				CASE 4, 5
				IF index = 4 OR index = 5 AND RND > .3 THEN EXIT FOR
				CASE 6
				IF teklev(who, 6) < 2 AND teklev(who, 4) + teklev(who, 5) - 2 * (teklev(who, 6)) >= 2 THEN index = k: EXIT FOR
				CASE 7
				IF index = 7 AND RND > .3 THEN EXIT FOR
			END SELECT
			IF index > 0 AND RND > .7 THEN EXIT FOR
		END IF
		NEXT k
invade:
	IF index > 0 THEN
		cash(who) = cash(who) - cost
		IF RND < .01 * TSF THEN
			c = 9: IF who = 2 THEN c = 8
			teklev(who, index) = teklev(who, index) + 1
			CALL image2(force$(who) + " " + tname$(index) + " Technology =>" + STR$(teklev(who, index)), c)
		END IF
		zmax = 1
		GOTO signup
	END IF
'==========================================================================
'                       Recruit New Armies
'==========================================================================
signup:
'. . . . . . . . . . . . . static units  . . . . . . . . . . . . . . . . . . .
FOR k = 1 TO ncity - 2
	IF cityp(k) = who AND occupied(k) = 0 THEN
		CALL void(k, z)
		IF z > 0 AND RND > .9 AND cash(who) > costfac(5) THEN CALL homeguard(who, k)
	END IF
NEXT k
'. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
IF who = 1 AND navysize(1) < 1 AND cash(1) > 100 THEN CALL navy(1, 1): IF cash(who) < 100 GOTO isok
IF RND > .8 AND cash(who) > 100 AND navysize(who) < 3 THEN CALL navy(who, 1): IF cash(who) < 100 GOTO isok
GOSUB enufarmies
IF cash(who) < 999 AND x > 4 + 3 * RND GOTO isok
IF navysize(who) + 2 < navysize(3 - who) AND cash(who) > 100 AND cityp(navyloc(who)) = who THEN slush = slush + 100: cash(who) = cash(who) - 100: IF cash(who) < 100 GOTO isok
CALL recruit(who)
'==========================================================================
'                         Naval Commands
'==========================================================================
isok:
	cash(who) = cash(who) + slush
dock:
	IF navyloc(who) = 0 THEN
		FOR k = 1 TO ncity
		IF cityp(k) = who AND matrix(k, 7) > 90 THEN navyloc(who) = k: EXIT FOR
		NEXT k
	END IF

	IF cash(who) < 100 OR navysize(who) > 9 OR cityp(navyloc(who)) <> who GOTO movenavy
	IF navysize(who) < navysize(3 - who) THEN CALL navy(who, 1)
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
movenavy:
	IF navysize(who) = 0 THEN navyloc(who) = 0
	IF navyloc(who) = 0 GOTO useplanes
	IF cash(who) > 100 - 5 * teklev(who, 8) AND navysize(who) < 2 AND cityp(navyloc(who)) = who THEN CALL navy(who, 1): GOTO useplanes
	IF cityp(navyloc(who)) <> 3 - who THEN CALL navy(who, 3): GOTO useplanes
	IF cityp(navyloc(who)) = 3 - who THEN CALL navy(who, 2) 'attack
'==========================================================================
'                         Airforce Commands
'==========================================================================
useplanes:
	clrrite
	IF cash(who) > 70 AND (victory&(3 - who) - victory&(who) < 100) THEN CALL airforce(who, 1)
	IF airsize(who) > 0 THEN
		c = 0: x = airloc(who)
		FOR k = 1 TO ncity
			CALL airdist(who, k, d)
			IF cityp(k) = 3 - who AND d > 0 THEN c = c + 1
		NEXT k
		IF weather <> 4 THEN
			IF c > 0 THEN CALL airforce(who, 2) ELSE CALL airforce(who, 3)
		END IF
	END IF
	aflag = 0
'==========================================================================
'                       Give Move Orders to Each Army
'==========================================================================
	CALL ships
'---------------------------------------------------------------------------
FOR i = star TO fin
	IF armyloc(i) > 0 THEN
		IF occupied(armyloc(i)) <> i THEN
			FOR j = star TO fin
			IF armyloc(j) > 0 AND unittype(j) = unittype(i) THEN occupied(armyloc(i)) = i: EXIT FOR
			NEXT j
		END IF
	END IF
NEXT i
'---------------------------------------------------------------------------
'                               Check to Combine/Detach
'---------------------------------------------------------------------------
x = who
CALL combine(x)
'..........................................................................
IF capcity(who) > 0 AND occupied(capcity(who)) > 0 THEN
	FOR k = 1 TO 6
	IF occupied(matrix(capcity(who), k)) > 0 GOTO jump
	NEXT k
	CALL void(capcity(who), defend)
	CALL starfin(x1, y1, 3 - who)
	a = 0
	FOR k = x1 TO y1
	IF armysize(k) > a THEN a = armysize(k)
	NEXT k
	IF RND > .5 AND armysize(occupied(capcity(who))) > defend AND armysize(occupied(capcity(who))) > a THEN CALL detach(who, occupied(capcity(who)), capcity(who))
END IF
'..........................................................................
jump:
IF weather < 4 OR teklev(who, 7) = 3 THEN CALL paratroop(who)
'---------------------------------------------------------------------------
'                               Top Priority
'---------------------------------------------------------------------------
FOR i = star TO fin
target = armyloc(i)

IF armyloc(i) < 1 OR armymove(i) < 0 OR unittype(i) = 5 GOTO deadman
x = armysize(i): IF supply(i) < 1 AND RND > .1 GOTO deadman

choose = 0

IF target = capcity(who) AND occupied(target) = i GOTO deadman   'hold capital
CALL void(target, defend)
IF defend > 0 THEN
	IF target = 40 AND occupied(40) = i AND who = 1 GOTO deadman 'hold Paris
	IF target = 44 AND occupied(44) = i AND who = 2 GOTO deadman 'hold Rome
END IF
IF target <> capcity(who) GOTO nocap
IF i <> occupied(target) GOTO nocap
	FOR j = 1 TO 6
	k = matrix(target, j): IF j = 0 GOTO nocap
	CALL void(k, flag)
	IF flag > armysize(occupied(target)) GOTO deadman
	NEXT j
nocap:
CALL evaluate(i, best)
IF best = 0 GOTO deadman
move9:
	IF best = 0 THEN choose = 1 + INT((j - 1) * RND)
	IF choose = 0 THEN choose = best
	armymove(i) = matrix(target, choose)
'...........................................................................
'                               Adjust Army Move Orders
'...........................................................................
	IF cityp(armymove(i)) = who THEN        ' eliminate crossing moves
		y = occupied(armymove(i))
		IF y > 0 THEN IF armymove(y) = x THEN armymove(i) = 0: GOTO deadman
	END IF
'...................... adjust weather moves.................................
	CALL canimove(i, index): IF index > 0 THEN armymove(i) = 0: GOTO deadman
'......................... check for multiple moves from same city .........
	from = armyloc(i)
	CALL starfin(star, fin, who)
	FOR k = star TO fin
		IF armyloc(k) = from THEN
			x = .02 * armysize(k) + 10 * atkfac(unittype(k)) - .02 * armysize(i) + 10 * atkfac(unittype(i))
			IF x > 0 THEN occupied(from) = k
		END IF
	NEXT k
	IF matrix(armyloc(i), 7) > 95 AND matrix(armymove(i), 7) > 95 THEN
		IF (teklev(who, 6) < 2 AND cityp(armymove(i)) <> who) OR (navyloc(3 - who) = armyloc(i) OR navyloc(3 - who) = armymove(i)) THEN armymove(i) = 0: GOTO deadman
		IF occupied(armymove(i)) > 0 AND cityp(armymove(i)) <> who THEN
			IF armysize(occupied(armymove(i))) / (armysize(i) + 1) > 2 THEN armymove(i) = 0: GOTO deadman
		END IF
	END IF
'................................................................................
	CALL icon(armyloc(i), armymove(i), 1)
	CALL icon(armyloc(i), armymove(i), 9)
	PUT (cityx(armyloc(i)) - 20, cityy(armyloc(i)) - 19), image, PSET
deadman:
NEXT i
'                               drill idle armies
	FOR i = star TO fin
	IF armymove(i) = 0 AND armyexper(i) < 6 THEN
		IF unittype(i) <> 5 THEN armyexper(i) = armyexper(i) + 1: armymove(i) = -1
	END IF
	NEXT i
EXIT SUB
'---------------------------------------------------------------------------
enufarmies:
pct! = 0: odds! = 0
FOR i = 1 TO maxarmy
	IF i < 30 THEN pct! = pct! + armysize(i) ELSE odds! = odds! + armysize(i)
NEXT i
odds! = pct! / (odds! + pct!)
IF who = 2 THEN odds! = 1 / odds!
x = 6 * odds!: IF cash(who) > 300 THEN x = .1 * x
CALL starfin(star, fin, who)
FOR k = star TO fin
	IF armysize(k) > 0 AND unittype(k) = 4 THEN RETURN
NEXT k
x = 0
RETURN
'---------------------------------------------------------------------------
END SUB

SUB snapshot (x, y, flag)
IF flag = 0 THEN GET (x - 10, y - 10)-(x + 10, y + 10), image
IF flag = 1 THEN PUT (x - 10, y - 10), image, PSET
END SUB

SUB sndfx (flag%)
IF noise > 0 THEN
	IF sblast$ <> "" THEN
		SELECT CASE flag
		CASE 1, 6
		t$ = "ding.voc"
		CASE 2
		t$ = "charge.voc"
		CASE 3
		t$ = "sunk.voc"
		CASE 4
		t$ = "ships.voc"
		CASE 5
		t$ = "engine.voc"
		CASE 7
		t$ = "drums2.voc"
		CASE 8
		t$ = "gun.voc"
		CASE 9
		t$ = "battle.voc"
		END SELECT
		CALL sndblst(t$, 0)
	ELSE
		SELECT CASE flag
		CASE 1
		SOUND 2200, .5: SOUND 2900, .7
		CASE 2
		PLAY "MBMST220o3e4g8g2.g8g8g8o4c2"
		CASE 6
		SOUND 400, .7: TICK .05: SOUND 500, .5: TICK .05: SOUND 400, .7
		CASE 7
		SOUND 77, .5: SOUND 59, .5
		CASE 8, 9
		SOUND 77, .3: SOUND 59, .3: CALL TICK(.05)
		CASE ELSE
		SOUND 999, .7
		END SELECT
	END IF
END IF
END SUB

SUB strong (index)
a$ = LTRIM$(RTRIM$(STR$(armysize(index)))) + "00"
PRINT a$;
END SUB

SUB trooper (who, flag)
	IF tracks(who) = 0 THEN EXIT SUB
	from = tracks(who)
	x = cityx(from) - 12: y = cityy(from) - 11
	CALL citygraf(from, c)
SELECT CASE flag
	CASE IS > 0
	PUT (x - 7, y - 5), para, PSET
	CASE ELSE
	LINE (x - 7, y - 5)-(x + 10, y + 8), c, BF
END SELECT
END SUB

SUB tupdate
IF player = 1 THEN
	CALL smarts
END IF
	FOR i = 1 TO maxarmy
	IF armyloc(i) > 0 AND armymove(i) > 0 THEN CALL icon(armyloc(i), armymove(i), 1)
	NEXT i
CALL clrbot: PRINT "	press any key for "; mnth$(mnth); ","; yr; " update";
CALL putflag(1, z): CALL armyxy(3, 450, z)
CALL armyxy(422, 450, 2)
LINE (0, 449)-(440, 462), 4, B
TICK -2
GOSUB upbox
'...........................................................................
IF weather > 0 THEN
FOR k = 1 TO maxarmy
   IF armyloc(k) > 0 AND armymove(k) > 0 THEN
	CALL canimove(k, flag)
	FOR j = 1 TO 2
		IF rr(j) = k GOTO flight
	NEXT j
	IF flag > 0 THEN
		CALL icon(armyloc(k), armymove(k), 4)
		armymove(k) = -1
		IF player = 1 OR ((side = 1 AND k < 31) OR (side = 2 AND k > 30)) THEN
			CALL icon(armyloc(k), 0, 12)
			CALL clrbot: MONIKER (k)
			PRINT " CANNOT MOVE BECAUSE OF THE "; forecast$(weather);
			TICK (-turbo!)
			CALL placearmy(k)
		END IF
	END IF
   END IF
flight:
NEXT k
END IF
'......................paratroop.....................................................
flag = 0: IF rr(1) > 0 AND armymove(rr(1)) = armymove(rr(2)) THEN flag = 1: x1 = rr(1): y1 = rr(2)
FOR i = 1 TO 2
IF rr(i) > 0 THEN
	CALL paratroop(i)
	LINE (425, 140)-(520, 192), 2, BF
	CALL C47
END IF
NEXT i
IF flag > 0 THEN
	CALL image2("Paratroop forces clash in " + city$(armyloc(x1)), 4)
	IF RND > .5 THEN a = x1: x1 = y1: y1 = a
	choose = 99
	CALL icon(armyloc(x1), 0, 3)
	CALL battle(x1, y1, win, lose)
	who = 1: IF win > 30 THEN who = 2
	CALL capture(win, armyloc(win), who, 0, 1)
	CALL retreat(lose, flee)
	armyloc(lose) = 0
	CALL occupy(armyloc(win))
	CALL placearmy(win)
	a$ = country$(nation(lose)) + " " + unitkind$(unittype(lose)) + STR$(lose)
	IF flee > 0 THEN
	CALL image2(a$ + " -> " + city$(flee), 4)
	armyloc(lose) = flee
	CALL occupy(flee)
	CALL placearmy(lose)
	ELSE
	CALL image2(a$ + " was crushed", 4)
	armysize(lose) = 0
	s = 1: IF win > 30 THEN s = 2
	victory&(s) = victory&(s) + 25
	END IF
END IF
'==========================================================================
'                       Assign Time of Action
'==========================================================================
s = 1
FOR i = 1 TO maxarmy
IF i = 31 THEN s = 2
brray(i) = 999
IF armymove(i) < 0 THEN armymove(i) = 0
IF armyloc(i) > 0 AND armymove(i) > 0 THEN brray(i) = INT(4 + 3 * RND) * 100 + i
IF brray(i) <> 999 THEN
	brray(i) = brray(i) - 100 * movfac(unittype(i))
	IF teklev(s, 3) > 0 THEN
		brray(i) = brray(i) - 100 * teklev(s, 3)
	END IF
	IF brray(i) < 100 THEN brray(i) = 100 + i
END IF
IF supply(i) < 1 AND armymove(i) > 0 THEN brray(i) = 900 + i
NEXT i

CALL bub2(maxarmy)
'==========================================================================
'                       Begin Main Loop
'==========================================================================
FOR j = 1 TO maxarmy
IF brray(j) = 999 GOTO allthru
flag = 0
active = INT(brray(j) / 100): active = brray(j) - 100 * active
s = 1: IF active > 30 THEN s = 2
'                       cancel invasion move if city was taken !
IF armymove(active) > 0 THEN
	IF matrix(armyloc(active), 7) > 95 AND matrix(armymove(active), 7) > 95 THEN
		IF (teklev(s, 6) < 2 AND cityp(armymove(active)) <> s) OR navyloc(3 - s) = armyloc(active) OR navyloc(3 - s) = armymove(active) THEN armymove(active) = 0: GOTO eot
	END IF
END IF

IF armymove(active) < 1 GOTO digin
CALL clrbot: PRINT force$(s); " "; unitkind$(unittype(active)); active; " is moving to "; city$(armymove(active));

CALL placearmy(active)
CALL icon(armyloc(active), armymove(active), 5)

CALL animate(active)
'==========================================================================
target = armymove(active)
IF occupied(target) = 0 THEN flee = 1: GOTO easy
IF (s = 1 AND occupied(target) < 31) OR (s = 2 AND occupied(target) > 30) GOTO easy
'==========================================================================
'                       Attack
'==========================================================================
enemy:
CALL icon(target, 0, 3)
defend = occupied(target)

CALL clrbot: PRINT force$(s); " "; unitkind$(unittype(active)); active; " attacks "; force$(3 - s); " "; unitkind$(unittype(defend)); defend; "in "; city$(armyloc(defend));
IF armysize(defend) > 0 THEN CALL battle(active, defend, win, lose): flag = 1
IF armyexper(win) < 10 THEN armyexper(win) = armyexper(win) + 1

IF armysize(lose) < 2 THEN
	CALL clrbot
	IF active = lose THEN armyloc(active) = armyloc(win)
	MONIKER (lose): PRINT "is shattered !";
	index = lose: GOTO crushed
END IF
'==========================================================================
'                       Attacker Loses
'==========================================================================
IF win = active GOTO kickbutt
armymove(active) = armyloc(active)
armyloc(active) = target
CALL clrbot: MONIKER (active): PRINT "withdrew to "; city$(armymove(active));

CALL placearmy(active)
CALL animate(active)

armyloc(active) = armymove(active)
CALL placearmy(active)
occupied(armyloc(active)) = active
armymove(active) = -2
		  
IF 11 * RND > unittype(defend) THEN CALL icon(armyloc(defend), armymove(defend), 4): IF armymove(defend) > 0 THEN armymove(defend) = -2

CALL TICK(-turbo!): GOTO digin
'==========================================================================
'                       Defender Retreats
'==========================================================================
kickbutt:
	CALL icon(armyloc(active), target, 4)
	IF armymove(defend) > 0 THEN CALL icon(target, armymove(defend), 4)

	CALL retreat(defend, flee): IF flee > 0 THEN move2 = flee: GOTO outta

	best = 0: flee = 0
	FOR i = 1 TO 6
	x = matrix(target, i)
	IF x > 0 AND (cityp(x) = 3 - s) AND cityv(x) > best THEN
		IF matrix(armyloc(defend), 7) > 95 AND matrix(x, 7) > 95 THEN
			IF best > 0 GOTO away
		END IF

		IF best = 0 THEN
			flee = i: best = cityv(x)
		ELSE
			IF occupied(x) = 0 THEN flee = i: best = cityv(x)
		END IF
away:
	END IF
	NEXT i
	IF flee = 0 GOTO deadmeat
	move2 = matrix(target, flee)
outta:
	CALL placearmy(defend)                  ' in old city

	armymove(defend) = move2
	CALL animate(defend)                 ' animate retreat
	   
	armyloc(defend) = move2
	occupied(move2) = defend
	CALL clrbot: MONIKER (defend): PRINT " is retreating to "; city$(move2);

	CALL placearmy(defend)                  ' in new city
	   
	CALL icon(target, 0, 6)
	armymove(defend) = -2
	GOTO holdon

deadmeat:
	index = defend
	CALL clrbot
	MONIKER (index): PRINT "has surrendered to "; : MONIKER (active): PRINT "in "; city$(armyloc(index));
crushed:
	x1 = 1: IF lose > 30 THEN x1 = 2
	x = cityx(target) - 12: y = cityy(target) - 11
	CALL citygraf(target, c)
	FOR k = 0 TO 7
	LINE (x - 7, y - 5)-(x + 10, y + 8), c, BF
	LINE (x + k - 7, y + k - 5)-(x + 10 - k, y + 8 - k), 5, BF
	TICK .1
	NEXT k
	LINE (x - 7, y - 5)-(x + 10, y + 7), c, BF

	LINE (x + 9, y - 2)-(x + 10, y + 8), 0, BF
	CIRCLE (x + 1, y), 7, 15, , , .4
	LINE (x - 7, y)-(x + 8, y + 8), 15, BF
	PAINT (x, y - 2), 15
	PSET (x - 6, y + 4), 15
	DRAW "c0S4" + font$(18) + "BR2" + font$(9) + "BR2" + font$(16)

	CALL image2(force$(x1) + " army destroyed", 4)
	IF noise = 0 THEN TICK -2
	CALL gloat(3 - x1, 0)
	LINE (x - 7, y - 5)-(x + 10, y + 8), c, BF
	IF armymove(index) > 0 THEN CALL icon(armyloc(index), armymove(index), 4)
	victory&(s) = victory&(s) + 25
	armyloc(index) = 0: armysize(index) = 0: unittype(index) = 0
	armyexper(index) = 0: armymove(index) = 0: supply(index) = 0
	supply(active) = supply(active) + supply(index): supply(index) = 0
	IF supply(active) > 10 THEN supply(active) = 10
	CALL occupy(target)
	IF occupied(target) > 0 THEN CALL placearmy(occupied(target))
	CALL clrrite
	flee = 0
	IF armyloc(active) = 0 GOTO digin
'---------------------------------------------------------------------------
'                       check for more defenders !
'---------------------------------------------------------------------------
holdon:
	IF occupied(target) > 0 THEN
	CALL image2("More defenders are in " + city$(target), -4)
	GOTO enemy
	END IF
'==========================================================================
'                       Move Into New City
'==========================================================================
easy:
CALL icon(armyloc(active), target, 4)
armyloc(active) = target: armymove(active) = -2
CALL occupy(armyloc(active))
CALL placearmy(active)
'---------------------------------------------------------------------------
'                            City Capture
'---------------------------------------------------------------------------
	IF cityp(armyloc(active)) = s GOTO horde
	c = armyloc(active)
	IF player < 2 AND s = side AND fort(c) > 0 AND flag = 0 THEN
		CALL clrrite
		tlx = 67: tly = 6
		hilite = 15: colour = 4
		mtx$(0) = "Raze ?"
		mtx$(1) = "No"
		mtx$(2) = "Yes"
		size = 2
		CALL menu(0)
		CALL clrrite
		IF choose = 2 THEN fort(c) = 0
	END IF
	CALL capture(active, c, s, flag, flee)
horde:
IF supply(active) < 10 THEN supply(active) = supply(active) + 1: IF RND > .8 GOTO horde
digin:
eot:
NEXT j

allthru:
CALL ships
'...............................iterate sub.................................
FOR i = 1 TO maxarmy
IF unittype(i) < 5 THEN armymove(i) = 0 ELSE armymove(i) = -1
IF armyloc(i) > 0 THEN
	CALL placearmy(i)
	IF unittype(i) = 5 AND armyexper(i) = 5 THEN unittype(i) = 1
END IF
NEXT i

mnth = mnth + 1
IF mnth > 12 THEN mnth = 1: yr = yr + 1

s = 1
FOR i = 1 TO maxarmy
IF armyloc(i) > 0 THEN
	CALL resupply(i, 0)
	IF supply(i) < 3 THEN
	supply(i) = 0
	IF player = 2 OR side = s THEN
		CALL clrbot
		CALL icon(armyloc(i), 0, 13)
		MONIKER (i): PRINT "is LOW ON SUPPLY";
		TICK (-turbo!)
		CALL placearmy(i)
		IF RND > .8 AND armysize(i) > 100 THEN armysize(i) = .9 * armysize(i)
	END IF
END IF
CALL placearmy(i)

IF occupied(armyloc(i)) <> i THEN CALL icon(armyloc(i), 0, 10)
END IF
NEXT i

y = 0: FOR i = 1 TO 30: y = y + .1 * armysize(i): NEXT i
x = 0: FOR i = 31 TO maxarmy: x = x + .1 * armysize(i): NEXT i
IF side = 2 AND x > 0 THEN aggress! = y / x ELSE aggress! = 1
IF side = 1 AND y > 0 THEN aggress! = x / y ELSE IF side = 1 THEN aggress! = 1
'...........................................................................

CALL clrbot
victory&(1) = .9 * victory&(1) + .3 * (income(1) + cntrl(1))
victory&(1) = victory&(1)
IF cntrl(1) > 29 THEN victory&(1) = victory&(1) + 50: IF cntrl(1) > 34 THEN victory&(1) = victory&(1) + 100
IF side = 2 AND cntrl(1) < 11 THEN aggress! = aggress! + .7

IF victory&(1) < 1 THEN victory&(1) = 0
victory&(2) = .9 * victory&(2) + .3 * (income(2) + cntrl(2))
IF cntrl(2) > 29 THEN victory&(2) = victory&(2) + 50: IF cntrl(2) > 34 THEN victory&(2) = victory&(2) + 100
IF side = 1 AND cntrl(2) < 11 THEN aggress! = aggress! + .7
IF player = 2 THEN TICK -1
IF weather > 0 THEN
SELECT CASE mnth
	CASE 12, 1, 2
		IF RND > .7 + .3 * (weather = 2) THEN weather = 2 ELSE weather = 1
	CASE 3 TO 5, 10, 11
		IF RND > .9 + .1 * (weather = 3) THEN weather = 3 ELSE weather = 1
		IF weather <> 3 AND RND > .9 THEN weather = 4
	CASE 6 TO 8
		IF RND > .7 + .3 * (weather = 4) THEN weather = 4 ELSE weather = 1
	CASE 9
		weather = 1: IF RND > .9 THEN weather = 4
END SELECT
END IF
EXIT SUB
upbox:
LINE (139, 330)-(232, 353), 4, BF
LINE (150, 330)-(216, 351), 0, BF
COLOR 15: LOCATE 22, 21: PRINT "UPDATE"
RETURN

END SUB

