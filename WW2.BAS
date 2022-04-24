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
DECLARE SUB battleship ()
DECLARE SUB center (y%, a$)
DECLARE SUB choices (wide%)
DECLARE SUB deadplane (who%)
DECLARE SUB maptext ()
DECLARE SUB Mickey (a$, lButton%, rButton%, xc%, yc%)
DECLARE SUB MouseBorder (row1%, col1%, row2%, col2%)
DECLARE SUB mxw (wide%)
DECLARE SUB showtek (who%, k%)
DECLARE SUB airdist (who%, target%, d%)
DECLARE SUB animate (index%)
DECLARE SUB armystat (index%)
DECLARE SUB armyxy (x%, y%, z%)
DECLARE SUB battle (attack%, defend%, win%, lose%)
DECLARE SUB bub2 (x%)
DECLARE SUB bubble (x%)
DECLARE SUB burn ()
DECLARE SUB cancel (side%)
DECLARE SUB capture (active%, c%, s%, flag%, flee%)
DECLARE SUB clrbot ()
DECLARE SUB combine (who%)
DECLARE SUB clrrite ()
DECLARE SUB commander (who%, empty%)
DECLARE SUB C47 ()
DECLARE SUB endit ()
DECLARE SUB europe (flag%)
DECLARE SUB evaluate (index%, x%)
DECLARE SUB events ()
DECLARE SUB filer (switch%)
DECLARE SUB flashcity (which%)
DECLARE SUB fortify (target%)
DECLARE SUB gloat (x%, y%)
DECLARE SUB hangar ()
DECLARE SUB icon (from%, dest%, kind%)
DECLARE SUB image2 (a$, s%)
DECLARE SUB maxx (flag%)
DECLARE SUB menu (switch%)
DECLARE SUB MONIKER (index%)
DECLARE SUB movefrom (index%, target%)
DECLARE SUB navy (who%, x%)
DECLARE SUB newarmy (who%, empty%, target%)
DECLARE SUB newcity (index%, flag%)
DECLARE SUB news (a$)
DECLARE SUB occupy (x%)
DECLARE SUB placearmy (which%)
DECLARE SUB putflag (who%, z%)
DECLARE SUB recruit (who%)
DECLARE SUB report (who%)
DECLARE SUB resupply (index%, flag%)
DECLARE SUB ships ()
DECLARE SUB shipicon (x%)
DECLARE SUB showtek (who%, k%)
DECLARE SUB smarts ()
DECLARE SUB showcity (index%)
DECLARE SUB snapshot (x%, y%, flag%)
DECLARE SUB sndblst (file$, flag%)
DECLARE SUB sndfx (flag%)
DECLARE SUB starfin (star%, fin%, who%)
DECLARE SUB statusbar ()
DECLARE SUB stax (who%)
DECLARE SUB strong (index%)
DECLARE SUB tank (x%, y%)
DECLARE SUB TICK (sec!)
DECLARE SUB trooper (who%, flag%)
DECLARE SUB tupdate ()
DECLARE SUB victor ()
DECLARE SUB void (a%, y%)

' ===========================================================================
'
' GENERAL.BI
'
'  Copyright (C) 1989 Microsoft Corporation, All Rights Reserved
'
' ===========================================================================

' ===========================================================================
' RegType contains the register structure for performing BIOS calls using
' CALL INTERRUPT
' ===========================================================================

TYPE RegType              'for CALL INTERRUPT
     ax    AS INTEGER
     bx    AS INTEGER
     cx    AS INTEGER
     dx    AS INTEGER
     bp    AS INTEGER
     si    AS INTEGER
     di    AS INTEGER
     flags AS INTEGER
END TYPE

' ===========================================================================
' GLOBAL CONSTANTS
' ===========================================================================

CONST FALSE = 0
CONST TRUE = -1
CONST MINROW = 2
CONST MAXROW = 25
CONST MINCOL = 1
CONST MAXCOL = 80
CONST MAXMENU = 10
CONST MAXITEM = 20
CONST MAXWINDOW = 10
CONST MAXBUTTON = 50
CONST MAXEDITFIELD = 20
CONST MAXHOTSPOT = 20

' ===========================================================================
' DECLARATIONS
' ===========================================================================

DECLARE SUB Interrupt (intnum AS INTEGER, inregs AS RegType, outregs AS RegType)
DECLARE SUB GetCopyBox (row1%, col1%, row2%, col2%, buffer$)
DECLARE SUB PutCopyBox (row%, col%, buffer$)
DECLARE SUB AttrBox (row1%, col1%, row2%, col2%, attr%)
DECLARE SUB PutBackground (row%, col%, buffer$)
DECLARE SUB GetBackground (row1%, col1%, row2%, col2%, buffer$)
DECLARE SUB Box (row1%, col1%, row2%, col2%, fore%, back%, border$, fillFlag%)
DECLARE SUB Scroll (row1%, col1%, row2%, col2%, lines%, attr%)
DECLARE FUNCTION GetShiftState% (bit%)
DECLARE FUNCTION AltToASCII$ (kbd$)

' ===========================================================================
'
' MOUSE.BI
'
'  Copyright (C) 1989 Microsoft Corporation, All Rights Reserved
'
' ===========================================================================

' ===========================================================================
' DECLARATIONS
' ===========================================================================

DECLARE SUB MouseHide ()
DECLARE SUB MouseShow ()
DECLARE SUB MousePoll (row%, col%, lButton%, rButton%)
DECLARE SUB MouseBorder (row1%, col1%, row2%, col2%)
DECLARE SUB MouseDriver (m0%, m1%, m2%, m3%)
DECLARE SUB MouseInit ()

' COMMON SHARED /uitools/ MousePresent AS INTEGER
COMMON SHARED MousePresent AS INTEGER


'==========================================================================
COMMON SHARED choose%, tlx%, tly%, size%, mtx$(), colour%, hilite%
COMMON SHARED cityx(), cityy(), cityv(), cityp(), city$(), filel, country$()
COMMON SHARED cash(), cntrl(), matrix(), income(), anima(), rflag
COMMON SHARED nflag, bold, f3key, turbo!, rr(), tname$(), rusky, autosave
COMMON SHARED image(), force$(), armyloc(), player, aggress!, plany$
COMMON SHARED armysize(), unittype(), armyexper(), supply(), mnth$()
COMMON SHARED rcity(), vicflag(), tracks(), batwon(), cityo()
COMMON SHARED armymove(), mnth, yr, array(), mflag, side, sblast$, race()
COMMON SHARED navyloc(), navysize(), navymove(), occupied(), vptotal, fort()
COMMON SHARED victory&(), pbm, noise, capcity(), difficult, utility1
COMMON SHARED chute(), font$(), brray(), casualty&(), airsize(), unitkind$()
COMMON SHARED graphic, begin$, teklev(), Mighty, tek$(), aflag, neuter, nation()
COMMON SHARED TCR, TSF, atkfac(), deffac(), movfac(), costfac()
COMMON SHARED airloc(), weather, forecast$(), pcode, featx(), featy()
COMMON SHARED shipx(), shipy(), scenario$, pb$, gci(), v2
'==========================================================================
CONST ncity = 58, maxarmy = 60
DIM SHARED cityx(ncity), cityy(ncity), cityv(ncity), cityp(ncity), city$(ncity), rcity(7)
DIM SHARED cash(2), cntrl(2), matrix(ncity, 8), income(2), anima(300)
DIM SHARED mtx$(21), image(300), force$(2), armyloc(maxarmy), vicflag(4)
DIM SHARED armysize(maxarmy), unittype(maxarmy), armyexper(maxarmy), supply(maxarmy), mnth$(12)
DIM SHARED armymove(maxarmy), array(maxarmy), tname$(8), cityo(ncity), race(ncity)
DIM SHARED navyloc(2), navysize(2), navymove(2), occupied(ncity), fort(ncity), rr(2)
DIM SHARED victory&(2), capcity(2), hp(2), tracks(2)
DIM SHARED chute(2), font$(26), brray(maxarmy), casualty&(2), batwon(2)
DIM SHARED teklev(2, 8), tek$(3), airsize(2), unitkind$(6), nation(maxarmy)
DIM SHARED graphic(1 TO 6000), country$(10), forecast$(4)
DIM SHARED atkfac(maxarmy), deffac(maxarmy), movfac(maxarmy), costfac(maxarmy), airloc(2)
DIM SHARED featx(19), featy(19), shipx(2), shipy(2), gci(12)
DIM SHARED usai(80), uki(80), fri(80), poli(80), rusi(80), geri(80), alship(100)
DIM SHARED para(60), axship(100), drop(140), ike1(80), ike2(80), ike3(80), ike4(80)
DIM SHARED parasw
DIM SHARED yourname$(10), skorz&(2, 5)
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
IF _FILEEXISTS("pbm") = 0 THEN mtx$(3) = "-" ELSE choose = 24
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
	IF _FILEEXISTS(t$) THEN size = size + 1: EXIT FOR
	NEXT k
filex:
	ON ERROR GOTO 0
	choose = 24: chosit = 32: IF filel = 0 THEN choose = 22
	mtx$(0) = "Options"
	mtx$(1) = "New Game"
	FOR j = 1 TO 10
		t$ = "ww" + LTRIM$(STR$(1938 + j)) + ".sav"
		IF _FILEEXISTS(t$) THEN
			saveExists = 1: EXIT FOR
		ELSE
			saveExists = 0
		END IF
	NEXT j
	mtx$(2) = "Load": IF saveExists = 0 THEN mtx$(2) = "-"
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
	IF _FILEEXISTS("pbm.&&&") THEN
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
	IF _FILEEXISTS(t$) THEN
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
	IF _FILEEXISTS("m.vga") THEN
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
				IF _FILEEXISTS(t$) THEN
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
					IF _FILEEXISTS(file$) = 0 THEN RETURN
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

SUB airdist (who, target, d)
	IF target < 1 THEN d = -1: EXIT SUB
	x1 = cityx(airloc(who))
	y1 = cityy(airloc(who))
	IF target < 99 THEN
		odds! = .1 * (cityx(target) - x1)
		x = odds! * odds!
		odds! = .1 * (cityy(target) - y1)
		y = odds! * odds!
	ELSE
		odds! = .1 * (shipx(3 - who) - x1)
		x = odds! * odds!
		odds! = .1 * (shipy(3 - who) - y1)
		y = odds! * odds!
	END IF
	d = 10 * SQR(x + y)
	IF d > 50 * (teklev(who, 7) + 1) THEN d = -1
END SUB

SUB bub2 (x)
	DO
		y% = FALSE
		FOR i = 1 TO x - 1
		IF brray(i) > brray(i + 1) THEN
			SWAP brray(i), brray(i + 1)
			y% = i
		END IF
		NEXT i
	LOOP WHILE y%
END SUB

SUB bubble (x)
	DO
		y% = FALSE
		FOR i = 1 TO x - 1
		IF mtx$(i) > mtx$(i + 1) THEN
			SWAP mtx$(i), mtx$(i + 1)
			SWAP array(i), array(i + 1)
			y% = i
		END IF
		NEXT i
	LOOP WHILE y%
END SUB

SUB burn
	SCREEN 12
	CLS : CALL europe(0)
END SUB

SUB cancel (side)
	CALL starfin(star, fin, (side))
	counter:
	CALL clrrite
	size = 0
	FOR j = star TO fin
	IF armyloc(j) > 0 AND armymove(j) > 0 THEN size = size + 1: mtx$(size) = city$(armyloc((j))): array(size) = j
	NEXT j
	CALL bubble(size)
	tlx = 67: tly = 2: wtype = 2
	mtx$(0) = "Cancel"
	IF size < 1 THEN CALL clrbot: PRINT "No units have orders to cancel"; : EXIT SUB
	CALL menu(5)
	SELECT CASE choose
	 CASE 1 TO size
		index = array(choose)

		CALL clrbot: COLOR 11: MONIKER (index): PRINT "in "; city$(armyloc(index)); " has cancelled move to "; city$(armymove(index)); : CALL TICK(turbo! + 1)
		CALL icon(armyloc(index), armymove(index), 4)
		armymove(index) = 0: CALL sndfx(1)
	 CASE ELSE
		GOTO finix
	END SELECT
	finix:
	CALL clrrite
END SUB

SUB capture (active, c, s, flag, flee)
	CALL clrbot
	COLOR 11: MONIKER (active): PRINT "has captured "; city$(c);
	x = cityx(c): y = cityy(c)
	index = 2: IF c = 53 THEN index = 6
	LINE (x - 6, y - 6)-(x + 6, y + 6), index, BF
	CALL placearmy(active)
	IF fort(c) > 0 AND flag > 0 THEN fort(c) = fort(c) - 1
	CALL showcity(c)
	victory&(s) = victory&(s) + cityv(c)
	IF c = capcity(3 - s) THEN
		victory&(s) = victory&(s) + 100
		victory&(3 - s) = victory&(3 - s) - 100
		CALL clrbot: PRINT force$(3 - s); " CAPITAL captured !";
		CALL burn
		CALL image2("FLASH! " + city$(capcity(3 - s)) + " has fallen!", 4)
		capcity(3 - s) = 0
		CALL gloat(s, 0)
		CALL TICK(turbo!)
		CALL clrrite
	END IF
	IF c = airloc(3 - s) THEN CALL deadplane(3 - s)
	'----------------------------------neutral-----------------------------------
	IF cityp(c) = 0 AND cityo(c) = 0 THEN
		IF neuter = 1 THEN
		victory&(s) = victory&(s) - 10
		CALL image2("VIOLATING NEUTRALS COSTS 10 VP'S!", 4)
		IF armymove(active) = 35 THEN rusky = 1
		END IF
		flee = 0
	END IF
	'------------------------------------------------------------------------------
	cityp(c) = s
	CALL flashcity(c)
	IF flee > 0 AND noise > 1 AND sblast$ = "" THEN
	' 1=US 2=German 3=UK 4=French 5=Polish 6=Russian 7=Italian 8=Generic Allied
	SELECT CASE nation(active)
	CASE 1, 3, 5, IS > 7
		'America/God Save the Queen/King
		PLAY "MLmFt180o2MNc4c4MLd4o1b4.o2c8d4"
	CASE 2, 7
		'Germany's National Anthem: "Deutschland-Lied"
		PLAY "MNMFT160o2e-4.f8g4f4a-4g4f8d8e-4"
		CASE 4  'Marseilles
		PLAY "MNMFt160o1g8.g16o2c4c4d4d4g4.e16c8."
	CASE 6 'Troika
		PLAY "mFT170o3c4.d-8c4o2b-4a-4g4f2"
	END SELECT
	END IF
END SUB

SUB center (y, a$)
	x = LEN(a$)
	x = 26 - x \ 2
	LOCATE y, 7 + x: PRINT a$
END SUB

SUB clrbot
	COLOR 15
	LOCATE 29, 1: PRINT SPACE$(79);
	LOCATE 29, 1
END SUB

SUB clrrite
	VIEW (526, 0)-(639, 445)
	CLS 1
	VIEW
END SUB

SUB commander (who, empty)
	empty = 0
	CALL starfin(star, fin, who)
	FOR i = star TO fin
	IF armyloc(i) = 0 AND armysize(i) < 1 THEN
		empty = i
		EXIT SUB
	END IF
	NEXT i
END SUB

SUB deadplane (who)
	x = cityx(airloc(who)): y = cityy(airloc(who))
	LINE (x, y - 6)-(x + 8, y - 14), 2, BF
	a$ = force$(who) + " Air Force is DESTROYED!"
	CALL image2(a$, 4)
	CALL news("* " + a$)
	IF rr(who) > 0 THEN
		CALL image2(force$(who) + " Paratroop move cancelled", 4)
		armymove(rr(who)) = 0
		armyloc(rr(who)) = airloc(who)
		rr(who) = 0
		CALL C47
	END IF
	airloc(who) = 0: airsize(who) = 0
END SUB

SUB detach (who, index, target)
	CALL commander(who, empty): IF empty = 0 THEN EXIT SUB
	supply(empty) = .3 * supply(index): supply(index) = supply(index) - supply(empty): IF supply(index) < 0 THEN supply(index) = 0
	armysize(empty) = .3 * armysize(index): armysize(index) = armysize(index) - armysize(empty)
	armyloc(empty) = target: armyexper(empty) = armyexper(index): armymove(empty) = 0
	armyexper(empty) = armyexper(index)
	unittype(empty) = unittype(index)
	nation(empty) = nation(index)
	CALL icon(armyloc(empty), 0, 10)
	CALL clrbot: PRINT force$(who); " "; unitkind$(unittype(empty)); " Unit #"; empty; " detached with "; : CALL strong(empty): PRINT " men"; : CALL TICK(turbo!): CALL sndfx(1)
	CALL clrbot
END SUB

SUB endit
	mtx$(8) = "Time: " + mnth$(vicflag(1)) + STR$(ABS(vicflag(2)))
	CALL clrbot: PRINT "Press ENTER to toggle ending conditions";
	COLOR 14: PRINT "				ESC when done";
	what4:
	FOR i = 2 TO 4: IF vicflag(i) > 0 THEN mtx$(i - 1) = "� " ELSE mtx$(i - 1) = "  "
	NEXT i
	choose = chosit
	mtx$(0) = "Victory Conditions"
	mtx$(1) = mtx$(1) + mtx$(8)
	mtx$(2) = mtx$(2) + RTRIM$(STR$(ABS(vicflag(3)))) + " / 58 Cities"
	mtx$(3) = mtx$(3) + "Capital"
	mtx$(4) = "DONE"
	wtype = 2: colour = 3: size = 4: hilite = 14
	CALL menu(0)
	chosit = 21 + choose
	SELECT CASE choose
		CASE 1 TO 2
			vicflag(choose + 1) = -vicflag(choose + 1)
		CASE 3
			vicflag(choose + 1) = 1 - vicflag(choose + 1)
		CASE ELSE
		GOTO cheer
	END SELECT
	GOTO what4
	cheer:
	CALL europe(0)
END SUB

SUB events
	'==========================================================================
	'                              Special Events
	'==========================================================================
	CALL clrbot
	'............................................................................
	t$ = "special.evt"
	IF rusky = 1 AND RND < .15 * difficult THEN
	bolshevik:
		rusky = 0
		CALL image2("Russia Enters the War", 4)
		cityp(58) = 1
		CALL flashcity(58)
		IF noise > 1 AND sblast$ = "" THEN
			PLAY "T170o3c4.o2b-8a-4g4f4e4f4c4o3c4.d-8c4o2b-4a-4g4f2"
		END IF
		TICK -2
		EXIT SUB
	END IF
	IF _FILEEXISTS(t$) = 0 THEN EXIT SUB
	OPEN "I", 1, t$
	'       x=trigger date  y=side affected (1-2)
	'       z=event code:   1=victory  2=cash  3=ships  4=airforce
	'                       10-18 = technology (1-8)
	'                       20=rusky flag set
	'                       21=usa enters war
	'                       22=russia enters war
	'                       >100= city changes to side y (city code=100-z)
	'       a=amount of effect
	DO WHILE NOT EOF(1)
		INPUT #1, x, a$, y, z, a
		IF 100 * (yr - 1900) + mnth = x THEN
			CLOSE #1
			SELECT CASE z
				CASE 1
					victory&(y) = victory&(y) + a
				CASE 2
	bank:
					cash(y) = cash(y) + a
				CASE 3
					IF navysize(y) > 0 AND navysize(y) < 10 THEN
						navysize(y) = navysize(y) + a
					ELSE
						a = 100 * a: GOTO bank
					END IF
				CASE 4
					IF airsize(y) > 0 AND airsize(y) < 10 THEN
						airsize(y) = airsize(y) + a
					ELSE
						a = 70 * a: GOTO bank
					END IF
				CASE 11 TO 15, 17 TO 18
					IF teklev(y, z - 10) < 3 THEN teklev(y, z - 10) = teklev(y, z - 10) + 1
				CASE 16
					IF teklev(y, z - 10) < 2 THEN teklev(y, z - 10) = teklev(y, z - 10) + 1
				CASE 20
					IF rusky = 0 AND cityp(58) = 0 THEN rusky = 1: IF cityp(35) = 0 THEN cityp(35) = 1
				CASE 21
					cityp(57) = 1: CALL flashcity(57)
				CASE 22
					GOTO bolshevik
				CASE IS > 100
					IF occupied(z - 100) = 0 THEN
						cityp(z - 100) = y: CALL flashcity(z - 100)
						IF z = 135 AND cityp(58) = 0 AND 8 * RND < difficult THEN rusky = 1
					END IF
			END SELECT
			c = 8: IF y = 1 THEN c = 9
			CALL image2(a$, c)
			EXIT SUB
		ELSE
			IF 100 * (yr - 1900) + mnth < x THEN CLOSE #1: EXIT SUB
		END IF
	LOOP
	CLOSE #1
END SUB

SUB filer (switch)
	'....................................................configuration..........
	IF switch = 5 THEN GOSUB wbase: EXIT SUB
	IF switch < 3 THEN
		OPEN "I", 1, "ww2.cfg"
		INPUT #1, side, noise, difficult, player, turbo!, batwon(1), batwon(2), casualty&(1), casualty&(2), neuter, Mighty, a, pb$, autosave
		IF sblast$ = "S" THEN noise = 1
		IF sblast$ = "M" THEN noise = 2
		IF a > 0 THEN weather = 1
		CLOSE #1
	END IF
	IF switch < 1 THEN EXIT SUB
	'...........................................................................
	SELECT CASE switch
		CASE 1, 4
	redo:
		mtx$(0) = "Start Year"
		FOR j = 1939 TO 1960
			t$ = "euro" + STR$(j) + ".dat"
			colour = 3
			GOSUB getyr
		NEXT j

		CALL clrbot
		LOCATE 29, 1: PRINT "Loading "; begin$;
	'....................................initialization.........................
		GOSUB wbase
		PRINT "..";
		t$ = "ww" + begin$ + ".ini"
		IF _FILEEXISTS(t$) = 0 THEN CALL clrbot: COLOR 14: LOCATE 29, 1: PRINT "INITILIZATION FILE NOT FOUND :"; t$; : begin$ = "": TICK 5: CALL clrbot: EXIT SUB
		OPEN "I", 1, t$
		INPUT #1, scenario$
		INPUT #1, mnth, yr
	'               set end game conditions
		FOR i = 1 TO 4: INPUT #1, vicflag(i): NEXT i
		
		FOR j = 1 TO 2
		FOR k = 1 TO 8: INPUT #1, teklev(j, k): NEXT k
		NEXT j
		INPUT #1, a     ' number of allied armies
	FOR i = 1 TO a
		INPUT #1, nation(i), armyloc(i), unittype(i), armysize(i), armyexper(i), supply(i)
		PRINT ".";
		IF armyloc(i) < 0 THEN GOSUB randarm
		occupied(armyloc(i)) = i
		IF nation(i) = 2 OR nation(i) = 7 THEN nation(i) = 8
		NEXT i
		INPUT #1, a             ' number of axis armies
	FOR i = 31 TO 30 + a
		INPUT #1, nation(i), armyloc(i), unittype(i), armysize(i), armyexper(i), supply(i)
		IF armyloc(i) < 0 THEN GOSUB randarm
		PRINT ".";
		occupied(armyloc(i)) = i
		pct! = pct! + .0007 * armysize(i) * costfac(unittype(i))
	NEXT i
	FOR i = 1 TO 2: INPUT #1, cash(i): NEXT i
	FOR i = 1 TO 2: INPUT #1, navysize(i), navyloc(i): NEXT i
	FOR i = 1 TO 2
		INPUT #1, airsize(i), airloc(i)
		chute(who) = 15 * (airsize(who) * (teklev(who, 7) + 1))
	NEXT i
		INPUT #1, capcity(1), capcity(2)
		PRINT "..";
		CLOSE #1
	'::::::::::::::::::::::::::::::::::::::LOAD SAVED GAME:::::::::::::::::::::::
		CASE 2
		tlx = 0: tly = 12: colour = 6
		mtx$(0) = "Load Saved Game"
		colour = 4: GOSUB getsave

		CALL clrbot: PRINT "Loading";

		OPEN "I", 1, file$
		INPUT #1, scenario$, begin$
		CLOSE #1
		IF begin$ <> "1939" THEN begin$ = "1940"

		GOSUB wbase
		IF _FILEEXISTS(t$) = 0 THEN CALL clrbot: COLOR 14: LOCATE 29, 1: PRINT "FILE NOT FOUND :"; t$; : begin$ = "": TICK 5: CALL clrbot: EXIT SUB

		OPEN "I", 1, file$
		INPUT #1, scenario$, begin$, a$
		INPUT #1, mnth, yr, player, side
		INPUT #1, rflag, mflag, nflag, aflag, weather
		FOR i = 1 TO 4: INPUT #1, vicflag(i): NEXT i

		FOR i = 1 TO ncity
		INPUT #1, a$, occupied(i), cityp(i), fort(i): IF i MOD 3 <> 0 THEN PRINT ".";
		NEXT i
		FOR i = 1 TO maxarmy
		INPUT #1, nation(i), armyloc(i), unittype(i), armysize(i), armyexper(i), supply(i), armymove(i)
		NEXT i

		FOR i = 1 TO 2: INPUT #1, cash(i), cntrl(i), income(i), victory&(i), capcity(i)
		INPUT #1, navysize(i), navyloc(i), navymove(i), airsize(i), airloc(i), rr(i), tracks(i)
		NEXT i
		FOR j = 1 TO 2: FOR k = 1 TO 8: INPUT #1, teklev(j, k): NEXT k: NEXT j
		CLOSE #1

		FOR k = 1 TO 2
		chute(who) = 15 * (airsize(who) * (teklev(who, 7) + 1))
		NEXT k
	'............................................................................
		CALL europe(1): CALL clrbot
		CALL statusbar
		FOR k = 1 TO 2
		IF rr(k) > 0 THEN CALL trooper(k, 1)
		CALL showmove(k)
		NEXT k
	':::::::::::::::::::::::::::::::::::::::SAVE:::::::::::::::::::::::::::::::::
		CASE 3, 6
		IF switch = 3 THEN GOSUB getsave ELSE file$ = "wwii5.sav"
		CALL clrbot: PRINT "Saving "; file$;
		OPEN "O", 1, file$
		WRITE #1, scenario$, begin$, DATE$
		WRITE #1, mnth, yr, player, side
		WRITE #1, rflag, mflag, nflag, aflag, weather
		FOR i = 1 TO 4: WRITE #1, vicflag(i): NEXT i

		FOR i = 1 TO ncity
		WRITE #1, city$(i), occupied(i), cityp(i), fort(i): IF i MOD 3 <> 0 THEN PRINT ".";
		NEXT i
		FOR i = 1 TO maxarmy
		WRITE #1, nation(i), armyloc(i), unittype(i), armysize(i), armyexper(i), supply(i), armymove(i)
		NEXT i

		FOR i = 1 TO 2: WRITE #1, cash(i), cntrl(i), income(i), victory&(i), capcity(i)
		WRITE #1, navysize(i), navyloc(i), navymove(i), airsize(i), airloc(i), rr(i), tracks(i)
		NEXT i
		FOR j = 1 TO 2: FOR k = 1 TO 8: WRITE #1, teklev(j, k): NEXT k: NEXT j
		CLOSE #1
		
		IF switch = 3 THEN
		myside = side
		IF myside < 1 OR myside > 2 THEN myside = 1
		OPEN "O", 1, "ww2.cfg"
		a = 0: IF weather > 0 THEN a = 1
		WRITE #1, myside, noise, difficult, player, turbo!, batwon(1), batwon(2), casualty&(1), casualty&(2), neuter, Mighty, a, pb$, autosave
		CLOSE #1
		END IF

		CALL europe(0)
		CALL statusbar
		CALL clrbot
		PRINT file$; " FILE SAVED"; : TICK -2: CALL clrbot
	END SELECT
	EXIT SUB
	':::::::::::::::::::::::::::::::::: BASE Conditions :::::::::::::::::::::::::
	wbase:
		OPEN "I", 1, "ww2base.ini"
		FOR i = 0 TO 2: INPUT #1, force$(i): NEXT i
		FOR i = 1 TO 12: INPUT #1, mnth$(i): NEXT i
		FOR k = 1 TO 8: INPUT #1, tname$(k): NEXT k
		FOR k = 1 TO 5: INPUT #1, unitkind$(k): NEXT k
		FOR k = 1 TO 10: INPUT #1, country$(k): NEXT k
		FOR k = 1 TO 26: INPUT #1, font$(k): NEXT k
		FOR k = 0 TO 3: INPUT #1, tek$(k): NEXT k
		FOR k = 1 TO 4: INPUT #1, forecast$(k): NEXT k
		FOR k = 1 TO 19: INPUT #1, featx(k), featy(k): NEXT k
		INPUT #1, TCR, TSF
		FOR k = 1 TO 5
			INPUT #1, atkfac(k), deffac(k), movfac(k), costfac(k)
		NEXT k
		INPUT #1, j
		FOR k = 1 TO j: INPUT #1, gci(k): NEXT k
		CLOSE #1
		PRINT "...";
	'...........................................map.............................
	' 1=US 2=German 3=UK 4=French 5=Polish 6=Russian 7=Italian 8=Generic Allied
	' 7th position : shows location of matching text. If > 95 then IS invasion port
		t$ = "euro1940.dat": IF begin$ = "1939" OR _FILEEXISTS(t$) = 0 THEN t$ = "euro1939.dat"
		flag = 0
	refile:
		PRINT "...";
		OPEN "I", 1, t$
		vptotal = 0
		FOR k = 1 TO 2: income(k) = 0: cntrl(k) = 0: NEXT k
		FOR k = 1 TO ncity
			occupied(k) = 0
		IF flag = 0 THEN
			INPUT #1, i, city$(k), race(k), cityx(k), cityy(k), cityv(k), cityo(k)
		ELSE
			INPUT #1, i, city$(k), race(k), cityx(k), cityy(k), cityv(k), cityp(k)
		END IF
			vptotal = vptotal + cityv(i)
			IF cityp(k) > 0 THEN x = cityp(k): cntrl(x) = cntrl(x) + 1: income(x) = income(x) + cityv(i)
			FOR j = 1 TO 7: INPUT #1, matrix(k, j): NEXT j
			INPUT #1, fort(k)
		NEXT k
		CLOSE #1
		IF switch = 5 THEN RETURN
		IF flag = 0 THEN flag = 1: t$ = "euro" + begin$ + ".dat": GOTO refile
		RETURN
	'...................................menu of options.........................
	getyr:
		size = 0
		IF LEN(t$) = 0 THEN choose = -1: EXIT SUB
		size = size + 1
		mtx$(size) = LTRIM$(MID$(t$, 5, 4))
		array(size) = size
		DO WHILE t$ <> "" AND size < 21
			t$ = DIR$
			t$ = LTRIM$(MID$(t$, 5, 4))
			IF t$ = "" THEN EXIT DO
			size = size + 1: mtx$(size) = t$: array(size) = size
		LOOP
		CALL bubble((size))
		tlx = 18: tly = 14 - .5 * size
		CALL menu(11)
		IF choose < 0 THEN choose = -1: EXIT SUB
		begin$ = mtx$(choose)
		IF LEN(begin$) < 1 THEN choose = -1: EXIT SUB
	RETURN
	getsave:
		CLS
		LINE (0, 0)-(639, 449), 8, BF
		size = 5 + (switch = 3)
		FOR k = 1 TO 21: mtx$(k) = "": NEXT k
		FOR k = 1 TO size
		mtx$(k) = STR$(k) + " unused"
		t$ = "wwii" + LTRIM$(STR$(k)) + ".sav"
		IF _FILEEXISTS(t$) THEN
			OPEN "I", 1, t$
			t$ = ""
			INPUT #1, a$, mtx$(21), mtx$(0)
			INPUT #1, x1, y1, a, x, y
			mtx$(k) = STR$(k) + "  " + LEFT$(mtx$(0), 6) + RIGHT$(mtx$(0), 2) + " " + mtx$(21) + "=>" + LTRIM$(STR$(y1))
			IF k = 5 THEN mtx$(k) = STR$(k) + "  AUTOSAVE"
			CLOSE #1
			END IF
		NEXT k
		mtx$(0) = "Saved Games"
		tlx = 21: tly = 7
		CALL menu(11)
		IF choose < 0 THEN EXIT SUB
		file$ = "wwii" + LTRIM$(STR$(choose)) + ".sav"
		RETURN
	randarm:
		IF RND > .5 THEN
			armyloc(i) = ABS(armyloc(i))
		ELSE
			occupied(ABS(armyloc(i))) = 0: nation(i) = 0
			armyloc(i) = 0: armysize(i) = 0
		END IF
	RETURN
END SUB

SUB fortify (target)
	tlx = 67: tly = 2
	who = side: CALL starfin(star, fin, who)
	size = 0
	FOR i = 1 TO 56
	x = occupied(i)
	IF x >= star AND x <= fin AND fort(i) < 3 THEN
			IF size < 19 THEN size = size + 1
			mtx$(size) = city$(armyloc(x))
			array(size) = x
	END IF
	NEXT i
	IF size = 0 THEN CALL clrbot: PRINT "No cities eligible to fortify"; : EXIT SUB
	CALL bubble((size))
	mtx$(0) = "Fortify"
		choose = 31
		CALL menu(5): CALL clrrite
		IF choose < 0 GOTO nocity
		target = armyloc(array(choose))
		CALL occupy(target): x = occupied(target): IF x < 0 GOTO nocity
		IF fort(target) > 2 THEN CALL clrbot: PRINT city$(target); " at MAXIMUM fortification level of 3"; : CALL TICK(4): GOTO nocity
		cost = 200 - 5 * teklev(who, 8)
		IF cash(side) < cost THEN CALL clrbot: PRINT "Fortifications for "; city$(target); " cost "; cost; " and you only have "; cash(side); : CALL TICK(4): GOTO nocity
		COLOR 3
		fort(target) = fort(target) + 1
		cash(side) = cash(side) - cost
		CALL clrbot: PRINT city$(target); " fortifications increased to "; fort(target);
		CALL icon(target, 0, 6)
		CALL showcity(target)
		IF armymove(x) > 0 THEN CALL icon(armyloc(x), armymove(x), 5)
		armymove(x) = -1
	nocity:
END SUB

SUB gcirc (xc, flag)
	IF airsize(side) < 1 THEN EXIT SUB
	x = cityx(xc): y = cityy(xc)
	COLOR flag
	VIEW (0, 0)-(525, 438)
	CIRCLE (x, y), 50 * (teklev(side, 7) + 1)
	VIEW
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

SUB maxx (flag)
	CLS : LINE (0, 0)-(639, 449), 8, BF
	COLOR 14: LOCATE 2, 7: PRINT STRING$(61, "�")
	LOCATE 9, 7: PRINT STRING$(61, "�")
	FOR i = 1 TO 6: LOCATE 2 + i, 7: PRINT "�"; SPACE$(59); "�": NEXT i
	COLOR 13: LOCATE 1, 28: PRINT begin$; "  SCENARIO"
			COLOR 9
			IF _FILEEXISTS("hi" + begin$ + ".ww2") = 0 THEN
				OPEN "O", 1, "hi" + begin$ + ".ww2"
				FOR k = 1 TO 10
				WRITE #1, "", 0
				NEXT k
				CLOSE #1
			END IF
			OPEN "I", 1, "hi" + begin$ + ".ww2"
			FOR s = 1 TO 2
			LOCATE 3, 30 * (s - 1) + 10: PRINT force$(s); " HALL of FAME"
			COLOR 7: FOR i = 1 TO 5
			INPUT #1, yourname$(5 * (s - 1) + i), skorz&(s, i)
			LOCATE 3 + i, 30 * (s - 1) + 8: PRINT i, yourname$(5 * (s - 1) + i), skorz&(s, i)
			NEXT i: NEXT s: CLOSE #1
	'..........................................................................
				FOR s = 1 TO 2: FOR i = 1 TO 5
				IF victory&(s) < skorz&(s, i) GOTO oldskor
					FOR j = 5 TO i + 1 STEP -1
					skorz&(s, j) = skorz&(s, j - 1)
					yourname$(5 * (s - 1) + j) = yourname$(5 * (s - 1) + j - 1)
					NEXT j
	IF flag > 0 THEN EXIT SUB
				COLOR 9: IF s = 2 THEN COLOR 7
				a = 3 * s + s - 1
				FOR k = 8 + a TO 10 + a
				LOCATE k, 1: PRINT SPACE$(80); : NEXT k
				a$ = "Congratulations ! ": IF player = 1 AND s <> side THEN a$ = ""
				LOCATE 8 + a, 1: PRINT a$; force$(s); " Score of"; victory&(s); "!"
				PRINT "New Entry into "; force$(s); " HALL of FAME in place "; i
				IF player = 1 AND s <> side THEN a$ = "COMPUTER": PRINT a$; " was "; force$(s); " commander": GOTO automate
	who4:
				PRINT "What is name of "; force$(s); " commander"; : INPUT a$: IF a$ = "" OR LEN(a$) > 12 GOTO who4
	automate:
				yourname$(5 * (s - 1) + i) = a$
				skorz&(s, i) = victory&(s): GOTO foun
	oldskor:
				NEXT i
	foun:
				NEXT s
	IF flag > 0 THEN EXIT SUB
			OPEN "o", 1, "hi" + begin$ + ".ww2"
			FOR s = 1 TO 2
				FOR i = 1 TO 5
				WRITE #1, yourname$(5 * (s - 1) + i), skorz&(s, i)
				NEXT i
			NEXT s: CLOSE #1
			LOCATE 22, 1: CALL TICK(-1)
			CALL maxx(1)
			LOCATE 17, 30: COLOR 14: PRINT "New High Scores": CALL TICK(0)
			SCREEN 9
			CALL title2
			TICK 0
END SUB

SUB MONIKER (index)
	PRINT country$(nation(index)); " "; unitkind$(unittype(index)); index;
END SUB

SUB newarmy (who, empty, target)
	supply(empty) = 3 + 5 * RND: IF who = 1 THEN supply(empty) = supply(empty) + 2
	armyexper(empty) = 1: IF who = 2 THEN armyexper(empty) = 2
	IF choose = 99 THEN flag = 1: unittype(empty) = 4: GOTO okelit

	IF who <> side THEN
		unittype(empty) = 1
		IF aggress! > 2 OR RND > .8 THEN unittype(empty) = 1 + INT(4 * RND)
		IF unittype(empty) > 4 THEN unittype(empty) = 4
		CALL starfin(star, fin, who)
		FOR k = star TO fin
			IF armysize(k) > 0 AND unittype(k) = 4 GOTO okelit
		NEXT k
		unittype(empty) = 4
	ELSE
		COLOR 15
		LOCATE 2, 68: PRINT "RECRUITING"
		LOCATE 3, 68: PRINT "New Army in"
		LOCATE 4, 68: PRINT city$(target)
		mtx$(0) = "Unit Type"
		FOR k = 1 TO 4: mtx$(k) = unitkind$(k): NEXT k
		size = 4: tlx = 67: tly = 5
		colour = 4: hilite = 14
		CALL menu(99)
		CALL clrrite
		IF choose < 0 THEN empty = 0: EXIT SUB
		unittype(empty) = choose
	END IF
	okelit:
	IF unittype(empty) = 4 THEN armyexper(empty) = 4 + RND

	armyloc(empty) = target
	occupied(target) = empty
	IF nation(empty) = 0 THEN nation(empty) = race(target): IF who = 2 THEN nation(empty) = 2
	armysize(empty) = (20 * cityv(armyloc(empty)) + 250) * (100 / costfac(unittype(empty)))
	IF armyloc(empty) > 56 THEN armysize(empty) = armysize(empty) \ 4
	IF armysize(empty) > 450 THEN armysize(empty) = 450
	IF flag = 1 THEN armysize(empty) = 12000 / costfac(unittype(empty))

	cash(who) = cash(who) - 100 + 5 * teklev(who, 8): CALL sndfx(1)
	CALL placearmy(empty)

	CALL clrbot: PRINT "Placing NEW UNIT :"; : MONIKER (empty): PRINT "in "; city$(target);
	CALL news("New " + force$(who) + " " + unitkind$(unittype(empty)) + " recruited in " + city$(target))
	PRINT " Size = "; : CALL strong(empty)
	IF who = side OR player = 2 THEN
		CALL TICK(turbo! - 1)
	ELSE
		TICK .2
	END IF
	armymove(empty) = -1
END SUB

SUB normal (xbar, vary, x)
	' NOTE : vary is VARIANCE
	pct! = 0
	FOR k = 1 TO 12: pct! = pct! + RND: NEXT k
	pct! = pct! - 5.5
	x = xbar + pct! * SQR(vary)
	END SUB

	SUB occupy (x)
	occupied(x) = 0
	FOR i = 1 TO maxarmy
	IF armyloc(i) = x THEN occupied(x) = i: EXIT SUB
	NEXT i
END SUB

SUB resupply (index, flag)
		who = 1: IF index > 30 THEN who = 2
		pct! = cash(who) / armysize(index) * (2000 / costfac(unittype(index)))
		x = INT(pct!)
		y = x + supply(index): IF y > 5 THEN x = 5 - supply(index)
		IF x < 1 THEN
			IF player = 1 AND ((side = 1 AND index > 30) OR (side = 2 AND index < 31)) THEN EXIT SUB
			IF flag < 1 THEN EXIT SUB
			CALL clrbot
			PRINT "Not enough funds in the Treasury to supply "; : MONIKER (index)
			TICK (-turbo!)
			GOTO nocash
		END IF
		supply(index) = supply(index) + x
		cash(who) = cash(who) - .01 * x * armysize(index)
		IF flag > 0 THEN CALL clrbot: MONIKER (index): PRINT "in "; city$(armyloc(index)); " received "; x; " units of supply"; : CALL sndfx(1): TICK -1.1
	nocash:
		IF cash(who) < 0 THEN cash(who) = 0
END SUB

SUB retreat (defend, x)
	x = 0: x1 = 0
	IF player = 1 THEN
		IF (side = 1 AND defend > 30) OR (side = 2 AND defend < 31) THEN x1 = 1
	END IF
	IF pbm > 0 THEN EXIT SUB

	hilite = 13: colour = 3: tlx = 67: tly = 5: size = 0
	y = armyloc(defend)
	who = 1: IF defend > 30 THEN who = 2
		FOR k = 1 TO 6
		IF matrix(y, k) > 0 AND cityp(matrix(y, k)) = who THEN
			z = matrix(y, k)
			IF matrix(y, 7) > 95 AND matrix(z, 7) > 95 THEN
				IF navyloc(3 - side) = y OR navyloc(3 - side) = z GOTO hemmed
			END IF
			size = size + 1
			mtx$(size) = city$(matrix(y, k))
			array(size) = matrix(y, k)
		END IF
	hemmed:
		NEXT k
		IF size = 0 THEN EXIT SUB
		IF size = 1 THEN x = array(1): EXIT SUB
		mtx$(0) = "Retreat"
		IF x1 = 0 THEN
			CALL bubble((size))
			CALL clrrite
			CALL menu(2)
			CALL clrrite
		ELSE
			choose = 1 + INT(RND * size)
		END IF
		IF choose < 0 OR choose > size THEN x = 0: EXIT SUB
		x = array(choose)
END SUB

SUB rotate (who)
	colour = 3: target = 0: hilite = 3
	tlx = 67: tly = 2
	CALL starfin(star, fin, who)
	size = 0
	FOR i = 1 TO ncity
		IF cityp(i) = who AND occupied(i) > 0 THEN
			FOR j = star TO fin
			IF armyloc(j) = i AND occupied(i) <> j THEN size = size + 1: mtx$(size) = city$(i): array(size) = i: EXIT FOR
			NEXT j
		END IF
	NEXT i

	IF size = 0 THEN CALL clrbot: PRINT "No stacked units to rotate"; : TICK turbo!: CALL clrbot: EXIT SUB
	CALL bubble((size))
	mtx$(0) = "Flip Stack"
	colour = 5: hilite = 14
	tlx = 67: tly = 6
	CALL menu(99): CALL clrrite

	IF choose < 0 THEN EXIT SUB
	target = array(choose)
	size = 0
	FOR i = star TO fin
		IF armyloc(i) = target THEN size = size + 1: mtx$(size) = LEFT$(unitkind$(unittype(i)), 5) + STR$(i): array(size) = i
	NEXT i
	IF size > 15 THEN size = 15
	CALL bubble((size))

	COLOR 15
	LOCATE 3, 67: PRINT city$(target)
	COLOR 11
	LOCATE 4, 67: PRINT "TOP OF STACK"

	LOCATE 5, 67: PRINT (unitkind$(unittype(occupied(target)))); occupied(target)
	tlx = 67: tly = 6
	CALL menu(5)
	CALL clrrite
	IF choose < 0 THEN EXIT SUB
	occupied(target) = array(choose)
	CALL clrbot: PRINT unitkind$(unittype((array(choose)))); array(choose); "( Str: "; RTRIM$(STR$(armysize(array(choose)))); "00) is now on top of stack in "; city$(target);
	CALL ikhan(array(choose))
	CALL sndfx(1)
	TICK turbo!
	CALL placearmy(array(choose))
	CALL clrrite
	CALL clrbot
END SUB

SUB ships
	FOR s = 1 TO 2
	IF navysize(s) = 0 THEN navyloc(s) = 0: GOTO sink
	IF navyloc(s) = 0 THEN navysize(s) = 0: GOTO sink
	SELECT CASE navyloc(s)
	CASE 1
		x = cityx(navyloc(s)) - 10: y = cityy(navyloc(s)) - 20
	CASE 7, 38
		x = cityx(navyloc(s)) - 25: y = cityy(navyloc(s)) + 10
	CASE 1, 9, 49, 53
		x = cityx(navyloc(s)) + 10: y = cityy(navyloc(s)) - 10
	CASE 14
		x = cityx(navyloc(s)) - 20: y = cityy(navyloc(s)) + 10
	CASE 11
		x = cityx(navyloc(s)) - 25: y = cityy(navyloc(s)) - 20
	CASE 10, 28
		x = cityx(navyloc(s)) - 25: y = cityy(navyloc(s))
	CASE 23, 44
		x = cityx(navyloc(s)) - 37: y = cityy(navyloc(s)) - 6
	CASE 17, 29
		x = cityx(navyloc(s)) + 35: y = cityy(navyloc(s)) - 6
	CASE 20, 32, 37, 54
		x = cityx(navyloc(s)) - 15: y = cityy(navyloc(s)) + 25
	CASE 45, 46
		x = cityx(navyloc(s)): y = cityy(navyloc(s)) - 20
	CASE ELSE
		x = cityx(navyloc(s)) + 25: y = cityy(navyloc(s)) + 25
	END SELECT
		PSET (x, y), 1
	IF s = 2 GOTO frigate
		CALL shipicon(1)
		GOTO sink
	frigate:
		CALL shipicon(2)
	sink:
	NEXT s
END SUB

SUB showtek (who, k)
	x = 0: IF cash(who) < 200 OR (k = 8 AND cash(who) < 500) THEN x = 1
	CALL putflag(who, z)
	CALL armyxy(580, 35, z)
	LINE (540, 70)-(635, 200), 13, B
	DEF SEG = VARSEG(graphic(1))
	LOCATE 4, 70: PRINT tname$(k)
	SELECT CASE k
	CASE 1, 2, 3
		SELECT CASE teklev(side, k)
			CASE 0: t$ = "std.vga": a$ = "Standard"
			CASE 1: t$ = "imp.vga": a$ = "Improved"
			CASE 2: t$ = "adv.vga": a$ = "Advanced"
			CASE ELSE: t$ = "ult.vga": a$ = " Ultra  "
		END SELECT
	CASE 4, 5
		SELECT CASE teklev(side, k)
			CASE 0: t$ = "nstd.vga": a$ = "Standard"
			CASE 1: t$ = "nimp.vga": a$ = "Improved"
			CASE 2: t$ = "nadv.vga": a$ = "Advanced"
			CASE ELSE: t$ = "nult.vga": a$ = " Ultra  "
		END SELECT
	CASE 6
		a$ = " Amphib "
		IF teklev(side, 6) = 2 THEN a$ = "Invasion"
		IF x = 1 THEN k = 0: COLOR 7
		SELECT CASE teklev(who, 6)
			CASE 0
				LINE (565, 100)-(605, 164), 0, BF
				CIRCLE (585, 140), 20, 4
				CIRCLE (585, 140), 14, 4
				PAINT (585, 158), 4, 4
				LINE (572, 132)-(595, 158), 4
				LINE (578, 127)-(601, 153), 4
				PAINT (585, 140), 4, 4
				LOCATE 12, 70: PRINT a$
				EXIT SUB
			CASE 1
				t$ = "amp.vga"
			CASE 2
				t$ = "inv.vga"
		END SELECT
	CASE 7
		SELECT CASE teklev(side, k)
			CASE 0: t$ = "std.vga": a$ = "Standard"
			CASE 1: t$ = "imp.vga": a$ = "Improved"
			CASE 2: t$ = "adv.vga": a$ = "Advanced"
			CASE ELSE: t$ = "ult.vga": a$ = " Ultra  "
		END SELECT
	CASE 8
		SELECT CASE teklev(side, k)
			CASE 0: t$ = "fast.vga": a$ = "Standard"
			CASE 1: t$ = "faim.vga": a$ = "Improved"
			CASE 2: t$ = "faad.vga": a$ = "Advanced"
			CASE ELSE: t$ = "faul.vga": a$ = " Ultra  "
		END SELECT
	END SELECT
	BLOAD t$, VARPTR(graphic(1))
	DEF SEG
	IF x = 1 THEN k = 0: COLOR 7
	PUT (565, 100), graphic, PSET
	LOCATE 12, 70: PRINT a$
	LOCATE 6, 69: PRINT "Technology"
END SUB

SUB sndblst (file$, flag%)
	ON LOCAL ERROR GOTO nosound
	IF _FILEEXISTS(file$) = 0 THEN EXIT SUB
	IF sblast$ = "" OR noise = 0 THEN EXIT SUB
	IF sblast$ = "Z" THEN SHELL "sound " + file$ + " 5 1 8": EXIT SUB
	SHELL "plany.exe " + file$ + plany$
	nosound:
	RESUME sounder
	sounder:
	CALL clrbot: PRINT "Sound Driver Error "; file$; : TICK 1
	ON ERROR GOTO 0
END SUB

SUB starfin (star, fin, who)
	star = 1: fin = 30: IF who = 2 THEN star = 31: fin = maxarmy
END SUB

SUB statusbar
	COLOR 14
	LOCATE 22, 28: PRINT SPACE$(2)
	LOCATE 22, 19: PRINT force$(side); " Turn"
	x = 23 - LEN(mnth$(mnth)) \ 2
	LOCATE 23, x: PRINT mnth$(mnth)
	LOCATE 24, 21: PRINT yr
	max = 67: IF yr < 1863 THEN max = 77
	FOR i = 1 TO 2: IF victory&(i) < 0 THEN victory&(i) = 0
	NEXT i
	COLOR 14: LOCATE 1, 68: PRINT "VP :"; victory&(side)
	a = 100 * (victory&(side) / (victory&(1) + victory&(2) + .01)): IF a > 100 THEN a = 100
	LOCATE 2, 68: PRINT "Pct:"; a; "%"
	LOCATE 3, 68: PRINT "Cities: "; cntrl(side)
	c = 9: IF side = 2 THEN c = 7
	LINE (532, 0)-(639, 54), c, B
	IF navysize(side) > 0 THEN
		LOCATE 5, 68: PRINT navysize(side); "Ships in"
		LOCATE 6, 70: PRINT city$(navyloc(side))
		LINE (532, 96)-(639, 54), c, B
	END IF
	LOCATE 8, 68: PRINT "Funds "; cash(side)
	LINE (532, 96)-(639, 127), c, B
END SUB

SUB stax (who)
	CALL starfin(star, fin, who)
	FOR i = star TO fin
	IF armysize(i) > 0 AND occupied(armyloc(i)) <> i THEN
		target = armyloc(i)
		CALL icon(target, 0, 10)
	END IF
	NEXT i
END SUB

SUB tank (x, y)
	IF x = 0 THEN COLOR 0: x = 500: y = 50: GOSUB strafe: EXIT SUB
	SCREEN 12
	LINE (x + 32, y + 1)-(x + 139, y + 206), 3, BF
	LINE (x + 139, y + 206)-(x + 32, y + 317), 10, BF
	CIRCLE (x + 46, y + 188), 9, 0
	PAINT (x + 44, y + 187), 0, 0
	CIRCLE (x + 46, y + 188), 12, 0
	PAINT (x + 56, y + 188), 7, 0
	COLOR 0
	LINE (x + 47, y + 178)-(x + 97, y + 197): LINE -(x + 96, y + 201): LINE -(x + 44, y + 197)
	LINE (x + 78, y + 190)-(x + 104, y + 188): LINE -(x + 106, y + 204): LINE -(x + 71, y + 207)
	LINE -(x + 71, y + 200)
	PAINT (x + 101, y + 199), 7, 0
	LINE (x + 105, y + 188)-(x + 121, y + 193): LINE -(x + 120, y + 200): LINE -(x + 106, y + 204)
	PAINT (x + 115, y + 194), 8, 0
	LINE (x + 56, y + 190)-(x + 96, y + 201)
	PAINT (x + 70, y + 197), 0, 0
	LINE (x + 55, y + 184)-(x + 94, y + 198)
	PAINT (x + 63, y + 189), 8, 0
	PAINT (x + 61, y + 185), 15, 0
	LINE (x + 70, y + 204)-(x + 53, y + 205): LINE -(x + 47, y + 216): LINE -(x + 119, y + 219)
	LINE -(x + 123, y + 206): LINE -(x + 102, y + 204)
	LINE (x + 52, y + 207)-(x + 121, y + 210)
	PAINT (x + 94, y + 208), 7, 0
	PAINT (x + 94, y + 215), 8, 0
	LINE (x + 49, y + 217)-(x + 49, y + 229): LINE -(x + 58, y + 233): LINE -(x + 66, y + 233)
	LINE -(x + 60, y + 227): LINE -(x + 61, y + 217)
	LINE (x + 48, y + 228)-(x + 59, y + 228)
	LINE (x + 51, y + 224)-(x + 60, y + 224)
	LINE (x + 50, y + 220)-(x + 59, y + 220)
	PAINT (x + 56, y + 219), 8, 0
	PAINT (x + 59, y + 231), 0, 0
	LINE (x + 105, y + 220)-(x + 104, y + 228): LINE -(x + 116, y + 228): LINE -(x + 116, y + 219)
	LINE (x + 105, y + 228)-(x + 113, y + 236): LINE -(x + 121, y + 236): LINE -(x + 117, y + 228)
	LINE (x + 106, y + 224)-(x + 112, y + 224)
	LINE (x + 121, y + 235)-(x + 136, y + 224): LINE -(x + 139, y + 216): LINE -(x + 133, y + 205)
	LINE -(x + 122, y + 206)
	LINE (x + 131, y + 208)-(x + 127, y + 208): LINE -(x + 120, y + 213)
	LINE (x + 131, y + 208)-(x + 135, y + 214): LINE -(x + 133, y + 221): LINE -(x + 122, y + 231)
	LINE -(x + 118, y + 224): LINE -(x + 119, y + 219)
	PAINT (x + 128, y + 219), 0, 0
	PAINT (x + 113, y + 232), 0, 0
	PAINT (x + 108, y + 221), 8, 0
	PAINT (x + 130, y + 207), 8, 0
	PAINT (x + 65, y + 205), 15, 0
	LINE (x + 115, y + 201)-(x + 132, y + 204)
	PAINT (x + 116, y + 204), 8, 0
	LINE (x + 67, y + 233)-(x + 74, y + 229): LINE -(x + 74, y + 225): LINE -(x + 104, y + 227)
	PAINT (x + 84, y + 223), 0
	LINE (x + 56, y + 233)-(x + 77, y + 235): LINE -(x + 30, y + 268): LINE -(x + 31, y + 287)
	LINE -(x + 84, y + 237): LINE -(x + 113, y + 237)
	PAINT (x + 89, y + 234), 2, 0
	GOSUB strafe
	EXIT SUB
	strafe:
	LINE (x + 56, y + 27)-(x + 79, y + 27): LINE -(x + 84, y + 20): LINE -(x + 92, y + 20)
	LINE -(x + 96, y + 27): LINE -(x + 118, y + 27): LINE -(x + 119, y + 29): LINE -(x + 96, y + 29)
	LINE -(x + 94, y + 32): LINE -(x + 82, y + 32): LINE -(x + 79, y + 29): LINE -(x + 53, y + 29)
	LINE -(x + 53, y + 28): LINE -(x + 56, y + 27)
	LINE (x + 87, y + 20)-(x + 89, y + 11), 8, BF: LINE -(x + 87, y + 11): LINE -(x + 89, y + 20), 0, B
	PSET (x + 86, y + 27), 14
	PAINT (x + 86, y + 27), 8, 0
	LINE (x + 80, y + 30)-(x + 96, y + 31), 0, BF
	LINE (x + 78, y + 17)-(x + 96, y + 18), 0, B
	LINE (x + 83, y + 23)-(x + 92, y + 23), 0
	PAINT (x + 88, y + 16), 11, 0
	CIRCLE (x + 88, y + 29), 2, 4: PAINT (x + 88, y + 29), 4
	CIRCLE (x + 88, y + 29), 6, 15
	RETURN
END SUB

SUB TICK (sec!)
	IF sec! < 0 THEN
		IF sec! = -1 THEN CALL clrbot: COLOR 14: PRINT "press a key ";
		IF Mighty > 0 THEN
			IF sec! = -1 THEN PRINT "or mouse button";
			CALL Mickey(a$, lButton, rButton, xc, yc)
			IF sec! = -1 THEN CALL clrbot
			EXIT SUB
		ELSE
			DO WHILE INKEY$ = "": LOOP
			EXIT SUB
		END IF
	END IF
	IF sec! = 0 THEN DO WHILE INKEY$ = "": LOOP: EXIT SUB
	start! = TIMER
	DO WHILE TIMER - start! < sec! AND INKEY$ = "": LOOP
END SUB

SUB title2
	SCREEN 12
	LINE (1, 1)-(630, 480), 8, BF
END SUB

SUB victor
	x = 0: FOR j = 1 TO 30: IF armyloc(j) > 0 THEN x = x + armysize(j)
	NEXT j
	y = 0: FOR j = 31 TO maxarmy: IF armyloc(j) > 0 THEN y = y + armysize(j)
	NEXT j

	CALL clrbot: COLOR 14
	IF vicflag(2) > 0 AND yr >= vicflag(2) AND vicflag(1) - mnth < 3 THEN
		CALL image2("Time almost expired (" + LEFT$(mnth$(vicflag(1)), 3) + "," + STR$(vicflag(2)) + ")", 4)
	END IF
	FOR i = 1 TO 2
	IF (i = 1 AND y = 0) OR (i = 2 AND x = 0) THEN j = 7: victory&(i) = victory&(i) * 1.1: GOTO finis

	IF yr >= vicflag(2) AND mnth >= vicflag(1) AND vicflag(2) > 0 THEN j = 2: GOTO finis
	IF cntrl(i) >= vicflag(3) AND vicflag(3) > 0 THEN j = 3: GOTO finis

	CALL clrbot: COLOR 14
	IF vicflag(3) > 0 AND cntrl(i) >= .9 * vicflag(3) THEN
		CALL image2(force$(i) + " side almost has" + STR$(vicflag(3)) + " cities", 4)
	END IF
	IF vicflag(4) > 0 AND capcity(3 - i) = 0 AND capcity(i) > 0 THEN j = 4: GOTO finis

	GOTO stale

	finis:
	SELECT CASE j
		CASE IS < 3
		a$ = "TIME EXPIRED"
		IF victory&(3 - i) > victory&(i) THEN i = 3 - i
		CASE 3
		a$ = STR$(vicflag(3)) + " CITIES CONTROLLED"
		CASE 4
		a$ = "CAPITAL CAPTURED"
		CASE 7
		a$ = "ENEMY ANNIHILATED"
	END SELECT
	c = 1: IF i = 2 THEN c = 7
	PALETTE 1, 60
	LINE (70, 140)-(485, 265), 0, BF
	LINE (50, 120)-(465, 250), c, BF
	LINE (50, 120)-(465, 250), 4, B
	COLOR 14
	t$ = force$(i) + " SIDE IS WINNING"
	CALL center(10, t$)

	COLOR 15
	t$ = "END GAME VICTORY CONDITION" + STR$(j - 1) + " REACHED"
	CALL center(12, t$)
	CALL center(14, a$)
	CALL statusbar

	mtx$(0) = "End Game"
	mtx$(1) = "Yes"
	mtx$(2) = "No-Override"
	size = 2: colour = 7
	tlx = 67: tly = 18
	hilite = 14
	CALL menu(0)

	IF choose = 2 THEN
		vicflag(j) = vicflag(j) + 1: IF j = 4 THEN vicflag(j) = 0
		IF player = 1 THEN
			victory&(side) = .7 * victory&(side)
			x = .3 * victory&(side)
			CALL image2("Victory Points Lost:" + STR$(x), 5)
		END IF
		SCREEN 9
		CALL europe(0)
		EXIT SUB
	END IF


	LINE (0, 0)-(639, 479), 4, BF
	s = 2
	IF i = 1 THEN
		FOR k = 1 TO 30
		IF armyloc(k) > 0 THEN s = nation(k): GOTO boast
		NEXT k
	END IF
	boast:
	SCREEN 9
	'             bonus for triggering end conditions (other than time)
	IF j > 2 THEN
		victory&(i) = 1.1 * victory&(i)
		IF vicflag(2) >= yr THEN
			IF vicflag(1) > mnth OR vicflag(2) > yr THEN
				victory&(i) = victory&(i) + 120 * (vicflag(2) - yr) + 10 * (vicflag(1) - mnth)
			END IF
		END IF
	END IF
		IF weather > 0 THEN weather = 1
		SCREEN 12
		FOR k = 1 TO 5
			CALL tank(115 * (k - 1) + 1, 110)
			LINE (115 * (k - 1) + 33, 110)-(115 * (k - 1) + 140, 428), 15, B
			CALL putflag(s, z)
			CALL armyxy(115 * (k - 1) + 120, 280, z)
			LINE (115 * (k - 1) + 120, 280)-(115 * (k - 1) + 120, 303), 0
		NEXT k
		LINE (110, 43)-(549, 88), 0, BF
		LINE (100, 35)-(539, 80), 5, BF
		LINE (100, 35)-(539, 80), 15, B
		COLOR 15: LOCATE 4, 27: PRINT force$(i); "  VICTORY  VP's="; victory&(i): GOTO death
	death:
		LINE (220, 230)-(410, 260), 0, BF
		LINE (220, 230)-(410, 260), 14, B
		COLOR 14: LOCATE 16, 40 - .5 * LEN(a$): PRINT a$
	CALL gloat(i, 1)
		TICK -1
		IF pbm = 0 THEN
			CALL maxx(0): pcode = 1
		ELSE
			OPEN "O", 1, "pbm"
			WRITE #1, begin$
			WRITE #1, victory&(1)
			WRITE #1, victory&(2)
			CLOSE #1
			CALL pbmview
			END
		END IF
		EXIT SUB
	stale:
		NEXT i
END SUB

SUB void (a, y)
  y = 0: IF a > 56 THEN EXIT SUB
	FOR j = 1 TO 6
	x = matrix(a, j): IF x = 0 THEN EXIT SUB
	IF cityp(x) = side AND occupied(x) > 0 THEN y = y + armysize(occupied(x))

		FOR k = 1 TO 6: m = matrix(x, k): IF m = 0 OR m = a GOTO tally4
		IF cityp(m) = side AND occupied(m) > 0 THEN y = y + .1 * armysize(occupied(m))
	tally4:
		NEXT k
	NEXT j
END SUB

' $include: 'MICKEY.BAS'