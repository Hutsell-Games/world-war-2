DEFINT A-Z
DECLARE SUB center (y%, a$)
REM $INCLUDE: 'edit.bi'
DIM SHARED usai(80), uki(80), fri(80), poli(80), rusi(80), geri(80), alship(100)
DIM SHARED para(60), axship(100), drop(140), ike1(80), ike2(80), ike3(80), ike4(80)
DIM SHARED parasw, narmy(2), last
hilite = 14: side = 1
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

CLS
LINE (0, 0)-(639, 449), 8, BF
LINE (0, 450)-(639, 479), 4, BF
COLOR 15: LOCATE 5, 27: PRINT "WW2-Europe Strategy GAME EDITOR"
LINE (160, 50)-(520, 100), 15, B
PAINT (170, 55), 4, 15
CALL filer(0)
LOCATE 28, 55: PRINT "(c) 1995 W. R. Hutsell"

IF player < 1 OR player > 2 THEN player = 1
IF player = 2 OR side = 0 THEN side = 1
IF turbo! < 1 THEN turbo! = 2

city$(0) = "NONE"

newgame:
GOSUB init
CALL filer(4): IF begin$ = "" GOTO newgame
filel = 1

SCREEN 12
CLS : CALL europe(0)
chosit = 23
'±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
'                              Main Menu
'±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
menu0:
colour = 4: IF side = 1 THEN colour = 9
CALL boxes
tlx = 67: tly = 12
mtx$(0) = "Main"
mtx$(1) = "Side"
mtx$(2) = "Army"
mtx$(3) = "Navy"
mtx$(4) = "Air Force"
mtx$(5) = "Cities"
mtx$(6) = "Technology"
mtx$(7) = "Cash"
mtx$(8) = "Capital"
mtx$(9) = "Fortify"
mtx$(10) = "Save"
mtx$(11) = "Load"
mtx$(12) = "PLAY GAME"
mtx$(13) = "Quit"
size = 13
choose = chosit
CALL menu(0)
IF choose > 0 AND choose <= size THEN IF LEN(mtx$(choose)) < 2 GOTO menu0
'==========================================================================
'                            Main Menu
'==========================================================================
SELECT CASE choose
	CASE -1
	chosit = 23: GOTO menu0
'--------------------------------------------------------------------------
'                       Side
'--------------------------------------------------------------------------
	CASE 1
	last = 0
	side = 3 - side: chosit = 23
	CALL clrbot: PRINT "Now editing "; force$(side); " side";
	GOTO menu0
'--------------------------------------------------------------------------
'                       Army
'--------------------------------------------------------------------------
	CASE 2
	CALL clrbot: PRINT "Modifying "; force$(side); " forces";
	CALL recruit((side))
	chosit = 23
	GOTO menu0
'--------------------------------------------------------------------------
'                       navy
'--------------------------------------------------------------------------
	CASE 3
	mtx$(0) = "Navy"
	mtx$(1) = "Move"
	mtx$(2) = "Edit"
	size = 2: tlx = 67: tly = 15
	CALL menu(0)
	SELECT CASE choose
		CASE 1
			IF navysize(side) < 1 THEN CALL clrbot: PRINT "Must first BUILD a navy"; : TICK 2: CALL clrbot: GOTO menu0
			target = navyloc(side)
			CALL newcity(target, 0)
			IF target < 1 OR matrix(target, 7) < 90 GOTO menu0
			navyloc(side) = target
			CALL europe(0)
			GOTO menu0
		CASE 2
			IF navysize(side) = 0 THEN
			target = 1
			CALL newcity(target, 0)
			IF target < 1 OR matrix(target, 7) < 90 GOTO menu0
			navyloc(side) = target
			navysize(side) = 1
			CALL ships
			END IF
			navyloc(side) = target
			CALL plusminus(force$(side) + " Navy", navysize(side), 0, 10)
			IF navysize(side) = 0 THEN navyloc(side) = 0: CALL europe(0)
	END SELECT
	chosit = 24
'--------------------------------------------------------------------------
'                               airforce
'--------------------------------------------------------------------------
	CASE 4
	CALL gcirc(airloc(side), 15)
	mtx$(0) = "Airforce"
	mtx$(1) = "Move"
	mtx$(2) = "Edit"
	size = 2: tlx = 67: tly = 15
	CALL menu(0)
	SELECT CASE choose
		CASE 1
			IF airsize(side) < 1 THEN CALL clrbot: PRINT "Must first BUILD AIRFORCE"; : TICK 2: CALL clrbot: GOTO menu0
			target = airloc(side)
			CALL newcity(target, 0)
			IF cityp(target) <> side OR target < 1 GOTO menu0
			airloc(side) = target
			CALL europe(0)
			GOTO menu0
		CASE 2
			IF airsize(side) = 0 THEN
			target = 1
			CALL newcity(target, 0)
			IF cityp(target) <> side OR target < 1 GOTO menu0
			airloc(side) = target
			airsize(side) = 1
			CALL ships
			END IF
			airloc(side) = target
			CALL plusminus(force$(side) + "AIR", airsize(side), 0, 10)
			IF airsize(side) = 0 THEN airloc(side) = 0: CALL europe(0)
	END SELECT
	chosit = 25
'--------------------------------------------------------------------------
'                               cities
'--------------------------------------------------------------------------
	CASE 5
	target = 1
	CALL newcity(target, 0)
	IF target < 1 OR occupied(target) > 0 GOTO menu0
	COLOR 12
	mtx$(0) = "Options"
	mtx$(1) = force$(1)
	mtx$(2) = force$(2)
	mtx$(3) = force$(0)
	size = 3: tlx = 67
	CALL menu(0)
	IF choose < 0 GOTO menu0
		cityp(target) = 0
		IF choose < 3 THEN cityp(target) = choose
		CALL flashcity(target)
	chosit = 26
	GOTO menu0
'==========================================================================
'                               Technology
'==========================================================================
	CASE 6
	mtx$(0) = force$(side) + " Tech"
	FOR k = 1 TO 8
		mtx$(k) = tname$(k) + STR$(teklev(side, k))
	NEXT k
	size = 8: tlx = 67
	CALL menu(0)
	chosit = 27
	IF choose < 1 GOTO menu0
	SELECT CASE choose
		CASE 6
			CALL plusminus(tname$(choose), teklev(side, choose), 0, 2)
		CASE ELSE
			CALL plusminus(tname$(choose), teklev(side, choose), 0, 3)
	END SELECT
'==========================================================================
'                               Cash
'==========================================================================
	CASE 7
	CALL plusminus(force$(side) + " CASH", cash(side), 0, 19999)
	chosit = 28
'==========================================================================
'                               Capital
'==========================================================================
	CASE 8
	chosit = 29
	target = capcity(side)
		CALL newcity(target, 0)
		IF target < 1 GOTO menu0
		cityp(target) = side
		capcity(side) = target
		CALL showcity
'==========================================================================
'                               Fortify
'==========================================================================
	CASE 9
		target = 1
		CALL newcity(target, 0)
		IF target < 1 GOTO menu0
		CALL plusminus("FORT", fort(target), 0, 3)
		LINE (cityx(target) - 6, cityy(target) - 6)-(cityx(target) + 6, cityy(target) + 6), 2, BF
		CALL showcity
		chosit = 30
'==========================================================================
'                            Save
'==========================================================================
	CASE 10
filex:
	ON ERROR GOTO 0
	choose = 24: chosit = 31: IF filel = 0 THEN choose = 22
	mtx$(0) = "Save As"
	FOR k = 1 TO 8
	mtx$(k) = STR$(1938 + k)
	NEXT k
	choose = VAL(begin$) - 1917
	mtx$(9) = "CANCEL"
	size = 9: tlx = 67: tly = 15
	CALL menu(0)
	SELECT CASE choose
		CASE IS < 1
			GOTO menu0
		CASE 1 TO 8
			begin$ = LTRIM$(RTRIM$((mtx$(choose))))
			year = VAL(mtx$(choose))
			CLS : COLOR 11
			mtx$(0) = "Begin Month"
			FOR k = 1 TO 12
			mtx$(k) = month$(k)
			NEXT k
			mtx$(13) = "CANCEL SAVE"
			size = 13: tlx = 67
			IF month <> 0 THEN choose = 21 + month
			CALL menu(0)
			IF choose < 0 OR choose = 13 THEN CALL europe(0): GOTO menu0
			month = choose
			COLOR 14: LOCATE 2, 1: PRINT "Description:"
			LINE (100, 12)-(401, 32), 5, B
			t$ = scenario$
			CALL Enput(t$, 14, 2, 48, "")
			scenario$ = t$

			a$ = "ww" + begin$ + ".ini"
			PRINT : COLOR 11
			PRINT "Saving "; a$; " scenario file beginning:  "; month$(month); ","; year
			IF LEN(DIR$(a$)) > 0 THEN
				COLOR 14
				PRINT "First : Make backup files "
				t$ = "ww" + begin$ + ".bak"
				SHELL "copy " + a$ + " " + t$
					PRINT "Backup file "; t$; " created - OK"
				a$ = "euro" + begin$ + ".dat"
				t$ = "euro" + begin$ + ".bak"
				SHELL "copy " + a$ + " " + t$
					PRINT "Backup file "; t$; " created - OK"
				TICK 5
			END IF
			COLOR 11
			PRINT "Saving edited map..";
			t$ = "euro" + begin$ + ".dat"
			OPEN "O", 1, t$
			FOR k = 1 TO ncity
			WRITE #1, k, city$(k), race(k), cityx(k), cityy(k), cityv(k), cityp(k), matrix(k, 1), matrix(k, 2), matrix(k, 3), matrix(k, 4), matrix(k, 5), matrix(k, 6), matrix(k, 7), fort(k)
			PRINT ".";
			NEXT k
			CLOSE #1

			PRINT "Now saving edited scenario..";
			t$ = "ww" + begin$ + ".ini"
			OPEN "O", 1, t$
			PRINT #1, scenario$
			PRINT "..";
			WRITE #1, month, year
			WRITE #1, vicflag(1), vicflag(2), vicflag(3), vicflag(4)
			FOR j = 1 TO 2
			WRITE #1, teklev(j, 1), teklev(j, 2), teklev(j, 3), teklev(j, 4), teklev(j, 5), teklev(j, 6), teklev(j, 7), teklev(j, 8)
			NEXT j
			WRITE #1, narmy(1)
			FOR i = 1 TO narmy(1)
			IF armyloc(i) > 0 THEN WRITE #1, nation(i), armyloc(i), unittype(i), armysize(i), armyexper(i), supply(i)
			PRINT ".";
			occupied(armyloc(i)) = i: armyname$(i) = country$(nation(i)) + " " + unitkind$(unittype((i)))
			NEXT i
			WRITE #1, narmy(2)
			FOR i = 31 TO 30 + narmy(2)
			WRITE #1, nation(i), armyloc(i), unittype(i), armysize(i), armyexper(i), supply(i)
			PRINT ".";
			NEXT i
WRITE #1, cash(1), cash(2)
FOR i = 1 TO 2: WRITE #1, navysize(i), navyloc(i): NEXT i
FOR i = 1 TO 2
	IF airsize(i) > 10 THEN airsize(i) = 10
	IF airloc(i) = 0 THEN airsize(i) = 0
	WRITE #1, airsize(i), airloc(i)
NEXT i
	WRITE #1, capcity(1), capcity(2)
	PRINT "..";
	CLOSE #1
	COLOR 14: PRINT "DONE": TICK 1
			CALL europe(0)
		CASE size
			GOTO menu0
	END SELECT
'==========================================================================
'                            Different Scenario
'==========================================================================
	CASE 11
	GOTO newgame
'==========================================================================
'                            Play game
'==========================================================================
	CASE 12
	GOSUB yessir
	IF choose <> 1 THEN CALL europe(0): GOTO menu0
	CLS
	PRINT "Loading game..."
	RUN "ww2.exe"
'==========================================================================
'                            Quit
'==========================================================================
	CASE 13
	GOSUB yessir
	IF choose <> 1 THEN CALL europe(0): GOTO menu0
	END
END SELECT
GOTO menu0
'..........................................................................
filerr:
	IF ERR = 53 THEN filel = 0: RESUME filex
	filel = 0: RESUME menu0
init:
pcode = 0: rflag = 0: mflag = 0: nflag = 0: aflag = 0
FOR k = 1 TO maxarmy: armysize(k) = 0: armyloc(k) = 0: armymove(k) = 0: supply(k) = 0: NEXT k
FOR k = 1 TO 2: victory&(k) = 0: tracks(k) = 0: NEXT k
RETURN

yessir:
	mtx$(0) = "Leave Edit"
	mtx$(1) = "Yes"
	mtx$(2) = "No"
	size = 2
	CALL menu(0)
RETURN

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
       CASE 8   'generic allied
	LINE (x, y)-(x + 14, y + 8), 9, BF
	LINE (x, y)-(x + 14, y + 9), 15, B
	PSET (x + 5, y + 6), 9: DRAW "C15U2E2F2D2BU1L3"
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

SUB boxes
LOCATE 23, 19: COLOR 14: PRINT "GAME EDITOR"
CALL putflag(side, z)
CALL armyxy(590, 145, z)
COLOR 15: LOCATE 10, 68: PRINT force$(side)
COLOR 11: LOCATE 2, 70: PRINT "Armies": COLOR 9
FOR k = 1 TO 2
	LOCATE 2 + k, 68: PRINT force$(k);
	LOCATE 2 + k, 75: PRINT narmy(k);
	COLOR 7
NEXT k
LINE (530, 17)-(630, 62), 3, B
COLOR 11: LOCATE 6, 72: PRINT "Nav Air"
COLOR 9: LOCATE 7, 68: PRINT "Ally"; TAB(72); navysize(1); TAB(76); airsize(1)
COLOR 7: LOCATE 8, 68: PRINT force$(2); TAB(72); navysize(2); TAB(76); airsize(2)
LINE (530, 94)-(630, 126), 5, B
END SUB

SUB bubble (size)
limit = size
DO
	swaps% = FALSE
	FOR i = 1 TO limit - 1
	IF mtx$(i) > mtx$(i + 1) THEN
		SWAP mtx$(i), mtx$(i + 1)
		SWAP array(i), array(i + 1)
		swaps% = i
	END IF
	NEXT i
LOOP WHILE swaps%
END SUB

SUB center (y, a$)
x = LEN(a$)
x = 26 - x \ 2
LOCATE y, 7 + x: PRINT a$
END SUB

SUB choices (wide)
	LINE (8 * tlx + 2, 16 * tly - 5)-(8 * (tlx + wide + 2) + 7, 16 * (tly + size + 2) + 15), 0, BF
	LINE (8 * tlx - 2, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + size + 2) + 8), colour, B
	LINE (8 * tlx + 1, 16 * (tly + 1) + 3)-(8 * (tlx + wide + 1) + 3, 16 * (tly + 1) + 6), colour, B
	IF ABS(wtype) = 2 THEN
		LINE (8 * tlx + 1, 16 * tly - 8)-(8 * (tlx + wide + 1) + 3, 16 * (tly + size + 2) + 4), colour, B
	END IF

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

SUB citygraf (index%, flag%)
flag = 2
FOR k = 1 TO 11
	IF gci(k) = index THEN flag = 1: EXIT SUB
NEXT k
END SUB

SUB clrbot
COLOR 15
LOCATE 29, 1: PRINT SPACE$(79);
LOCATE 29, 1
END SUB

SUB clrrite
VIEW (526, 0)-(639, 448)
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

SUB Enput (t$, tlx, tly, brx, mask$)
'===========================================================================
'                               Initialize
'===========================================================================
  x1 = 1
  text$ = t$ + SPACE$(brx - tlx + 1 - LEN(t$))
  LOCATE tly, tlx: PRINT text$;

'===========================================================================
'                               MAIN LOOP
'===========================================================================
DO
'...........................................................................
  DO
     LINE (8 * (tlx + x1 - 2), 14 * (tly - 1))-(8 * (tlx + x1 - 2) + 8, 14 * tly), 15, B
     LOCATE tly, tlx + x1 - 1, 1
'===========================================================================
'                               Get Key
'===========================================================================
	Ky$ = ""
	DO WHILE Ky$ = "": Ky$ = INKEY$: LOOP
     LINE (8 * (tlx + x1 - 2), 14 * (tly - 1))-(8 * (tlx + x1 - 2) + 8, 14 * tly), 0, B

	IF LEN(Ky$) > 1 THEN
		choose = -1 * ASC(RIGHT$(Ky$, 1))
	ELSE
		choose = ASC(Ky$)
	END IF
'===========================================================================
'                               Key Actions
'===========================================================================
SELECT CASE choose
	CASE -83                          'delete key
	 MID$(text$, x1) = MID$(text$, x1 + 1) + " "
	 LOCATE , , 0
	 PRINT MID$(text$, x1);

	CASE -82                         'Insert
	 Insrt = 1 - Insrt
	 IF Insrt = 0 THEN
		LOCATE , , , 6, 7
	 ELSE
		LOCATE , , , 1, 6
	 END IF

	CASE -79                         'end key
	 a$ = RTRIM$(text$): x1 = LEN(a$) + 1
	 IF x1 > LEN(text$) THEN x1 = LEN(text$)


	CASE -77                         'right arrow
	 IF tlx + x1 < brx + 1 THEN x1 = x1 + 1

	CASE -75                         'left arrow
	 IF x1 > 1 THEN x1 = x1 - 1

	CASE -71                         'home key
	 x1 = 1

	CASE 8                           'backspace
	 IF x1 > 1 THEN x1 = x1 - 1
	 LOCATE , tlx + x1 - 1, 0
	 IF x1 > 0 THEN
		IF Insrt THEN
		MID$(text$, x1) = MID$(text$, x1 + 1) + " "
	   ELSE
		MID$(text$, x1) = " "
	   END IF
		PRINT MID$(text$, x1);
	 END IF

	CASE 13                          'enter
	 EXIT DO

	CASE 27                          'escape : blanks the text
	 text$ = "": EXIT DO

	CASE 32 TO 122                   'other keys : check vs. mask
	 IF LEN(mask$) > 0 THEN IF INSTR(mask$, CHR$(choose)) = 0 GOTO illegalk
	 IF x1 > brx - tlx + 1 GOTO illegalk
	 LOCATE , , 0
	 IF Insrt THEN
	   MID$(text$, x1) = Ky$ + MID$(text$, x1)
	   PRINT MID$(text$, x1);
	 ELSE
	   MID$(text$, x1) = Ky$
	   PRINT Ky$;
	 END IF
	 IF x1 <= brx - tlx + 1 THEN x1 = x1 + 1

	CASE ELSE
illegalk:
	 SOUND 200, .3
	 EXIT DO
END SELECT

  LOOP UNTIL x1 < 1 OR x1 > LEN(text$)
  t$ = RTRIM$(text$)
LOOP UNTIL choose = 13 OR choose = 27
END SUB

SUB europe (flag)
carto:
SCREEN 12
CLS
LINE (0, 0)-(525, 438), 10, B
PAINT (200, 200), 2, 10
LINE (2, 66)-(27, 90), 3, BF: LINE (2, 66)-(27, 90), 10, B
LINE (478, 68)-(522, 95), 3, BF: LINE (478, 68)-(522, 95), 10, B
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

LINE (138, 330)-(233, 385), 0, BF
LINE (138, 330)-(233, 385), 4, B
LINE (137, 329)-(234, 386), 15, B
LINE (145, 387)-(239, 392), 0, BF
LINE (235, 335)-(239, 392), 0, BF
'.......................................................................
CALL features
'.......................................................................
CALL maptext
CALL showcity
COLOR 15: CALL center(1, scenario$)

CALL ships

FOR i = 1 TO maxarmy
CALL placearmy(i)
NEXT i
FOR i = 1 TO 2
CALL stax(i)
NEXT i

COLOR 14

CALL boxes
END SUB

SUB features
IF LEN(DIR$("m.vga")) > 0 THEN
DEF SEG = VARSEG(graphic(1))
BLOAD "m.vga", VARPTR(graphic(1))
DEF SEG
FOR k = 1 TO 19
PUT (featx(k), featy(k)), graphic, PSET
NEXT k
END IF
END SUB

SUB filer (switch)
'....................................................configuration..........
IF switch = 5 THEN GOSUB wbase: EXIT SUB
IF switch < 3 THEN
	OPEN "I", 1, "ww2.cfg"
	INPUT #1, side, noise, difficult, player, turbo!, batwon(1), batwon(2), casualty&(1), casualty&(2), neuter, Mighty, a, pb$
	IF a > 0 THEN weather = 1
	CLOSE #1
END IF
IF switch < 1 THEN EXIT SUB
'...........................................................................
SELECT CASE switch
	CASE 1, 4
redo:
	mtx$(0) = "Starting Year"
	t$ = DIR$("euro*.dat")
	colour = 3
	GOSUB getyr

	CALL clrbot
	LOCATE 29, 1: PRINT "Loading "; begin$;
'....................................initialization.........................
	GOSUB wbase
	PRINT "..";
	t$ = "ww" + begin$ + ".ini"
	IF LEN(DIR$(t$)) < 1 THEN CALL clrbot: COLOR 14: LOCATE 29, 1: PRINT "INITILIZATION FILE NOT FOUND :"; t$; : begin$ = "": TICK 5: CALL clrbot: EXIT SUB
	OPEN "I", 1, t$
	INPUT #1, scenario$
	INPUT #1, month, year
'               set end game conditions
	FOR i = 1 TO 4: INPUT #1, vicflag(i): NEXT i
	
	FOR j = 1 TO 2
	FOR k = 1 TO 8: INPUT #1, teklev(j, k): NEXT k
	NEXT j
	INPUT #1, narmy(1)     ' number of allied armies
FOR i = 1 TO narmy(1)
	INPUT #1, nation(i), armyloc(i), unittype(i), armysize(i), armyexper(i), supply(i)
	armyloc(i) = ABS(armyloc(i))
	PRINT ".";
	occupied(armyloc(i)) = i: armyname$(i) = country$(nation(i)) + " " + unitkind$(unittype((i)))
	IF nation(i) = 2 OR nation(i) = 7 THEN nation(i) = 8
NEXT i
	INPUT #1, narmy(2)             ' number of axis armies
FOR i = 31 TO 30 + narmy(2)
	INPUT #1, nation(i), armyloc(i), unittype(i), armysize(i), armyexper(i), supply(i)
	PRINT ".";
	occupied(ABS(armyloc(i))) = i
	armyname$(i) = country$(nation(i)) + " " + unitkind$(unittype((i)))
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
END SELECT
EXIT SUB
':::::::::::::::::::::::::::::::::: BASE Conditions :::::::::::::::::::::::::
wbase:
	OPEN "I", 1, "ww2base.ini"
	FOR i = 0 TO 2: INPUT #1, force$(i): NEXT i
	FOR i = 1 TO 12: INPUT #1, month$(i): NEXT i
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
'...........................................map.............................
' 1=US 2=German 3=UK 4=French 5=Polish 6=Russian 7=Italian 8=Generic Allied
' 7th position : shows location of matching text. If > 95 then IS invasion port
	t$ = "euro" + begin$ + ".dat"
	IF LEN(DIR$(t$)) = 0 THEN t$ = "euro1939.dat"
	OPEN "I", 1, t$
	vptotal = 0
	FOR k = 1 TO 2: income(k) = 0: control(k) = 0: NEXT k
	FOR k = 1 TO ncity
		occupied(k) = 0
		INPUT #1, i, city$(k), race(k), cityx(k), cityy(k), cityv(k), cityo(k)
		vptotal = vptotal + cityv(i)
		IF cityo(k) > 0 THEN x = cityo(k): control(x) = control(x) + 1: income(x) = income(x) + cityv(i)
		cityp(k) = cityo(k)
		FOR j = 1 TO 7: INPUT #1, matrix(k, j): NEXT j
		INPUT #1, fort(k)
	NEXT k
	CLOSE #1
	RETURN
'...................................menu of options.........................
getyr:
	size = 0
	IF LEN(t$) = 0 THEN choose = -1: EXIT SUB
	size = size + 1
	mtx$(size) = t$
	array(size) = size
	DO WHILE t$ <> "" AND size < 21
		t$ = DIR$
		IF t$ = "" THEN EXIT DO
		size = size + 1: mtx$(size) = t$: array(size) = size
	LOOP
	CALL bubble((size))
	size = size + 1: mtx$(size) = "Quit"
	tlx = 18: tly = 14 - .5 * size
	CALL menu(11)
	IF choose < 0 THEN choose = -1: EXIT SUB
	IF choose = size THEN END
	x = INSTR(mtx$(choose), "1")
	begin$ = LTRIM$(MID$(mtx$(choose), x, 4))
	IF LEN(begin$) < 1 THEN choose = -1: EXIT SUB
RETURN
END SUB

SUB flashcity (which)
x = cityx(which): y = cityy(which): z = cityp(which)
c = 9: IF z = 2 THEN c = 7
IF z = 0 THEN c = 12
CIRCLE (x, y), 5, 0
CIRCLE (x, y), 4, c
PAINT (x, y), c, c
END SUB

SUB gcirc (xc, flag)
IF airsize(side) < 1 THEN EXIT SUB
x = cityx(xc): y = cityy(xc)
COLOR flag
VIEW (0, 0)-(525, 438)
CIRCLE (x, y), 50 * (teklev(side, 7) + 1)
VIEW
END SUB

SUB hangar
FOR i = 1 TO 2
x = cityx(airloc(i)): y = cityy(airloc(i))
PSET (x, y - 11), 2
DRAW "C11S4R3U3R1C8D3R3D1L3D3R1L1C11L2R1U3L3BR5C0R3U1BL3U3BD5D1BR1D2L4BU4L2"
NEXT i
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
	FOR i = 4 TO 10 STEP 1
	CIRCLE (x, y), i, 4
	PAINT (x, y), 14, 4
	NEXT i
	CALL TICK(.1)
	CALL snapshot(x, y, 1)
	NEXT j
	 
	CASE 4
	CALL citygraf(from, c)
	IF occupied(from) = 0 THEN LINE (x - 6, y - 6)-(x + 10, y + 8), c, BF
	IF x1 + y1 > 0 THEN LINE (x, y)-(x1, y1), 2, , &HF0F0

	CASE 5
	IF x1 + y1 > 0 THEN LINE (x, y)-(x1, y1), 2, , &HF0F0

	CASE 6
	x = cityx(from): y = cityy(from)
	CALL snapshot(x, y, 0)
	LINE (x - 9, y - 9)-(x + 9, y + 9), 15, B
	LINE (x - 10, y - 10)-(x + 10, y + 10), 15, B
	CALL TICK(turbo! - 1)
	CALL snapshot(x, y, 1)
	CASE 7          ' draw white box
	x = cityx(from) - 12: y = cityy(from) - 11
	GET (x - 8, y - 8)-(x + 8, y + 8), image
	LINE (x - 7, y - 6)-(x + 7, y + 7), 15, B
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

	IF kind = 12 THEN
		PSET (130, 100), 15: DRAW "C15S4" + font$(14) + "BD4BR2" + font$(15)
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
x = cityx(ABS(armyloc(index))) - 19
y = cityy(ABS(armyloc(index))) - 16
LINE (x, y)-(x + 14, y + 13), 0, BF
c = unittype(index)
SELECT CASE c
	CASE 1
		PUT (x, y), ike1, PSET
	CASE 2
		PUT (x, y), ike2, PSET
	CASE 3
		PUT (x, y), ike3, PSET
	CASE 4
		PUT (x, y), ike4, PSET
	CASE 5
		LINE (x, y)-(x + 15, y + 10), 3, BF
		LINE (x, y)-(x + 15, y + 10), 0, B
END SELECT
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

SUB menu (switch%)
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
       
	boxc = colour: IF wtype > 10 THEN boxc = INT(wtype / 10): wtype = wtype - 10 * boxc

	COLOR boxc

	VIEW (8 * tlx - 5, 16 * tly - 11)-(8 * (tlx + wide + 1) + 7, 16 * (tly + size + 2) + 8)
	CLS 1
	VIEW
	CALL choices(wide)

sel1:
	COLOR hilite
	LOCATE tly + 2 + row, tlx + 2: PRINT mtx$(row)
	SELECT CASE switch
		CASE 3
			CALL icon(array(row), 0, 9)
			target = array(row)
		CASE 5
			CALL icon(armyloc(array(row)), 0, 9)
			target = array(row)
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
'°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
selex:
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
				CALL choices(wide)
				RETURN
			CASE "A"
				choose = 99: GOTO called
			CASE ";"
				a$ = UCASE$(mtx$(0)): file$ = ""
				SELECT CASE a$
					CASE "MAIN"
					file$ = "help.sc2"
				END SELECT
				IF file$ = "" THEN RETURN
				IF LEN(DIR$(file$)) = 0 THEN RETURN
				SCREEN 0
				DEF SEG = &HB800
				BLOAD file$, 0
				DEF SEG
				TICK 99
				SCREEN 12
				GOTO redoit
		END SELECT
	END IF
	RETURN

limits:
	IF row > size THEN row = 1
	IF row < 1 THEN row = size
	RETURN

selswi:
	SELECT CASE switch
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
	GOTO remenu
called:
	IF switch <> 11 THEN CALL clrrite
	tlx = 0: tly = 0
	COLOR colour
	row1 = row
	GOSUB selswi
END SUB

SUB MONIKER (index)
PRINT country$(nation(index)); " "; armyname$(index); index;
END SUB

SUB mxw (wide)
	wide = LEN(mtx$(0)) + 1
	ndx = 0
	FOR i = 1 TO size
	l = LEN(mtx$(i))
	IF l > wide THEN wide = l: ndx = i
	NEXT i
END SUB

SUB newarmy (who, empty, target)
	IF choose = 99 THEN flag = 1
	supply(empty) = 3 + 5 * RND: IF who = 1 THEN supply(empty) = supply(empty) + 2
	armyexper(empty) = 1: IF who = 2 THEN armyexper(empty) = 2
	IF who <> side THEN
		unittype(empty) = 1
		IF aggress! > 2 OR RND > .8 THEN unittype(empty) = 1 + INT(3 * RND)
	ELSE
		COLOR 15
		LOCATE 2, 68: PRINT "PLACING"
		LOCATE 3, 68: PRINT force$(side);
		LOCATE 4, 68: PRINT "Army"; empty; "in";
		LOCATE 5, 68: PRINT city$(target)
		mtx$(0) = "Unit Type"
		FOR k = 1 TO 5: mtx$(k) = unitkind$(k): NEXT k
		size = 5: tlx = 67: tly = 15
		colour = 4: hilite = 14
		CALL menu(99)
		IF choose < 0 THEN empty = 0: EXIT SUB
		unittype(empty) = choose
	END IF
	IF unittype(empty) = 4 THEN armyexper(empty) = 4 + RND
	armyname$(empty) = unitkind$(unittype((empty)))

	armyloc(empty) = target
	occupied(target) = empty
	IF nation(empty) = 0 THEN
		nation(empty) = race(target)
		SELECT CASE who
			CASE 1
mustdo:
					mtx$(0) = "Nation"
					size = 0
					FOR k = 1 TO 10
					IF k <> 2 AND k <> 7 AND k <> 8 THEN
						size = size + 1
						mtx$(size) = country$(k)
						array(size) = k
					END IF
					NEXT k
					tlx = 67
					CALL bubble(size)
					CALL menu(0)
					IF choose < 0 GOTO mustdo
					x = array(choose)
					nation(empty) = x
			CASE 2
				nation(empty) = 2
		END SELECT
	END IF
	armysize(empty) = (20 * cityv(armyloc(empty)) + 250) * (100 / costfac(unittype(empty)))
	IF unittype(empty) = 5 THEN
		armyexper(empty) = 0
		armysize(empty) = .7 * armysize(empty)
	END IF
	IF armyloc(empty) > 56 THEN armysize(empty) = armysize(empty) \ 4
	IF armysize(empty) > 450 THEN armysize(empty) = 450
	IF flag = 1 THEN armysize(empty) = 12000 / costfac(unittype(empty))

	CALL placearmy(empty)

	CALL clrbot: PRINT "Placing NEW UNIT :"; : MONIKER (empty): PRINT "in "; city$(target);
	PRINT " Size = "; : CALL strong(empty)
	armymove(empty) = 0
	narmy(who) = narmy(who) + 1
	cityp(target) = side
	CALL occupy(target)
	CALL flashcity(target)
	CALL stax(side)
END SUB

SUB newcity (index, flag)
		mtx$(0) = "City"
		mtx$(1) = "  "
		mtx$(3) = "  "
		size = 3: a$ = city$(index)
morecap:
		tlx = 68: tly = 15: choose = 23
		colour = 3
		COLOR 11: LOCATE 9, 67: PRINT "FIRST Letter"
		LOCATE 10, 67: PRINT "of City Name"
		COLOR 14: LOCATE 11, 72: PRINT "OR"
		COLOR 15
		LOCATE 12, 67: PRINT "UP/DOWN arrows"
		mtx$(2) = city$(index): array(2) = index
		CALL menu(3)

		IF choose = -27 THEN index = 0: EXIT SUB
		IF utility1 > 0 THEN index = choose

	       SELECT CASE choose
		CASE IS < 1
		a$ = CHR$(ABS(choose))

		x = 0
		FOR k = 1 TO ncity
		IF LEFT$(city$(k), 1) = a$ THEN y = index: index = k: GOTO morecap
		NEXT k

		CASE 1
minus1:
		index = index - 1: IF index < 1 THEN index = ncity
		CASE 2
		EXIT SUB
		CASE 3
plus1:
		index = index + 1: IF index > ncity THEN index = 1
		CASE ELSE
		index = 0
		END SELECT
		GOTO morecap
END SUB

SUB occupy (x)
occupied(x) = 0
FOR i = 1 TO maxarmy
IF ABS(armyloc(i)) = x THEN occupied(x) = i: EXIT SUB
NEXT i
END SUB

SUB placearmy (which)
IF which < 1 OR armysize(which) < 1 THEN EXIT SUB
who = nation(which)
IF k = 34 THEN STOP
x = cityx(ABS(armyloc(which))) - 12: y = cityy(ABS(armyloc(which))) - 11
IF armymove(which) <> 0 THEN who = -who
CALL armyxy(x - 7, y - 5, who)
IF (side = 1 AND which < 31) OR (side = 2 AND which > 30) THEN
	IF armymove(which) <> 0 THEN
		CALL citygraf(armyloc(which), c)
		LINE (x + 8, y - 5)-(x + 11, y + 5), c, BF
	END IF
END IF
IF armyloc(which) < 0 THEN
	x = x - 3: y = y + 4
	a$ = "0": IF which > 30 THEN a$ = "7"
	IF nation(which) = 3 THEN a$ = "11"
	PSET (x, y), 0
	DRAW "C" + a$
	DRAW "S8"
	DRAW font$(18)
	DRAW "S4"
END IF
END SUB

SUB plusminus (a$, a, x, y)
CALL clrbot: PRINT "Press ENTER when done";
IF a < 0 THEN a = 0
LINE (530, 220)-(639, 340), 4, BF
COLOR 15
LOCATE 13, 69: PRINT a$
LOCATE 16, 73: PRINT ""
LOCATE 20, 73: PRINT ""
adjust:
IF UCASE$(LEFT$(a$, 2)) = "ST" THEN
	LOCATE 18, 71: PRINT RTRIM$(STR$(a)); "00 ";
ELSE
	LOCATE 18, 71: PRINT a; " ";
END IF
DO WHILE t$ = "": t$ = INKEY$: LOOP

SELECT CASE RIGHT$(t$, 1)
	CASE "G"
	z = y
	CASE "H"
	z = 1.2 * a: IF z = a THEN z = a + 1
	CASE "I"
	IF a < 19999 THEN
	z = 2 * a: IF z = a THEN z = a + 1
	END IF
	CASE "O"
	z = x: LOCATE 18, 71: PRINT SPACE$(8)
	CASE "P"
	z = .8 * a: IF z = a THEN z = a - 1
	CASE "Q"
	z = .5 * a: IF z = a THEN z = a - 1
	CASE CHR$(13), CHR$(27)
	CALL clrbot
	CALL clrrite
	EXIT SUB
END SELECT
a = z
IF a < x THEN a = x
IF a > y THEN a = y
t$ = ""
GOTO adjust
END SUB

SUB putflag (who, z)
IF who = 2 THEN z = who: EXIT SUB
FOR i = 1 TO 30
IF armysize(i) > 0 THEN z = nation(i): EXIT SUB
NEXT i
END SUB

SUB recruit (who)
levy:
	IF last <> 0 THEN target = last ELSE target = 1
	IF last = 0 THEN
	FOR k = 1 TO ncity
		IF cityp(k) = side THEN target = k: EXIT FOR
	NEXT k
	END IF
	CALL newcity(target, 0)
	last = target
	IF target < 1 THEN EXIT SUB
	COLOR 12
	mtx$(0) = "Army"
	mtx$(1) = "Place"
	mtx$(2) = "Edit"
	mtx$(3) = "Rotate"
	mtx$(4) = "Remove"
	size = 4: tlx = 67
rechex:
	IF occupied(target) = 0 GOTO auto1
	s = 1: IF occupied(target) > 30 THEN s = 2
	x = occupied(target)
	CALL clrbot: PRINT country$(nation(x)); " "; unitkind$(unittype(x)); x; " Strength:"; RTRIM$(STR$(armysize(x))); "00   Supply:"; supply(x); "   Exper:"; armyexper(x);
	IF (side = 1 AND occupied(target) > 30) OR (side = 2 AND occupied(target) < 31) THEN
		CALL clrbot: COLOR 10: PRINT "Must first remove ENEMY army from "; city$(target); "!"; : TICK 2
		CALL remove(target)
		IF choose <> 1 THEN CALL clrbot: EXIT SUB
		IF occupied(target) > 0 GOTO rechex
		GOTO auto1
	END IF

	mtx$(0) = city$(target): tlx = 67
	CALL menu(0)
	IF choose < 1 THEN EXIT SUB
SELECT CASE choose
CASE 1
	index = choose
auto1:
	CALL commander((who), empty)
	IF empty = 0 THEN CALL clrbot: COLOR 14: PRINT "All "; force$(side); " army slots are used!"; : SOUND 150, .3: TICK 2: EXIT SUB
	nation(empty) = 0
	CALL newarmy(who, empty, target)
	IF armyloc(empty) > 0 THEN
		mtx$(0) = "Chance"
		mtx$(1) = "Always"
		mtx$(2) = "50%"
		size = 2: tlx = 67
		CALL menu(0)
		CALL clrbot: PRINT "DONE";
		IF choose = 2 THEN armyloc(empty) = -armyloc(empty): PRINT "Army "; empty; " has 50% chance of appearing"; : TICK 1
	END IF
CASE 2
auto2:
	x = occupied(target)
	CALL clrbot: PRINT country$(nation(x)); " "; unitkind$(unittype(x)); x; " Strength:"; RTRIM$(STR$(armysize(x))); "00   Supply:"; supply(x); "   Exper:"; armyexper(x);
	mtx$(0) = "Unit" + STR$(x)
	mtx$(1) = "Strength"
	mtx$(2) = "Supply"
	mtx$(3) = "Exper"
	mtx$(4) = "Type"
	size = 4
	tlx = 67: tly = 15
	CALL menu(0)
	IF choose < 0 THEN EXIT SUB
	IF choose > 0 THEN a$ = mtx$(choose) ELSE EXIT SUB
	t$ = force$(side) + unitkind$(unittype(x)) + STR$(x)
	SELECT CASE choose
		CASE 1
			CALL plusminus(a$, armysize(x), 1, 12500)
			IF armysize(x) < 1 THEN armysize(x) = 1
			CALL clrbot: PRINT t$; "New strength :"; RTRIM$(STR$(armysize(x))); "00";
		CASE 2
			CALL plusminus(a$, supply(x), 0, 10)
			CALL clrbot: PRINT t$; "New supply level:"; supply(x);
		CASE 3
			CALL plusminus(a$, armyexper(x), 0, 10)
			CALL clrbot: PRINT t$; "New experience level:"; armyexper(x);
		CASE 4
			mtx$(0) = "Change To"
			FOR k = 1 TO 5: mtx$(k) = unitkind$(k): NEXT k
			size = 5: tlx = 67
			CALL menu(0)
			IF choose < 1 THEN EXIT SUB
			CALL clrbot: PRINT force$(side); " "; unitkind$(unittype(x)); x; " changed to";
			unittype(x) = choose
			PRINT unitkind$(unittype(x));
	END SELECT
	GOTO auto2
CASE 3
	CALL rotate(target)
CASE 4
	CALL remove(target)
END SELECT
END SUB

SUB remove (target)
mtx$(0) = "Remove ?"
mtx$(1) = "Yes"
mtx$(2) = "NO"
size = 2: tlx = 67
x = occupied(target)
y = 1: IF x > 30 THEN y = 2
CALL clrbot: PRINT force$(y); " "; unitkind$(unittype(x)); x; " Str:"; : CALL strong(x)
CALL menu(0)
IF choose <> 1 THEN CALL clrbot: EXIT SUB
armyloc(x) = 0: armysize(x) = 0: narmy(y) = narmy(y) - 1
CALL occupy(target)
CALL clrbot: PRINT force$(y); " "; unitkind$(unittype(x)); x; : COLOR 14: PRINT "** REMOVED **"; : TICK 1: CALL clrbot
CALL citygraf(target, c)
LINE (cityx(target) - 19, cityy(target) - 17)-(cityx(target) - 2, cityy(target) - 3), c, BF
CALL flashcity(target)
CALL placearmy(occupied(target))
END SUB

SUB rotate (target)
colour = 3: hilite = 3
tlx = 67
CALL starfin(star, fin, side)
size = 0
FOR k = star TO fin
	IF ABS(armyloc(k)) = target THEN size = size + 1: mtx$(size) = unitkind$(unittype(k)): array(size) = k
NEXT k
IF size > 18 THEN size = 18
tly = 22 - size

CALL bubble((size))

COLOR 15
LOCATE 1, 67: PRINT city$(target)
COLOR 11
LOCATE 2, 67: PRINT "TOP OF STACK"

LOCATE 3, 67: PRINT unitkind$(unittype(occupied(target))); occupied(target)
CALL menu(5)
IF choose < 0 THEN EXIT SUB
x = array(choose)
occupied(target) = x
CALL clrbot: PRINT country$(nation(x)); " "; unitkind$(unittype(x)); array(choose); "( Str: "; RTRIM$(STR$(armysize(x))); "00) is now on top of stack in "; city$(target);
CALL ikhan(x)
TICK turbo!
CALL placearmy(x)
CALL clrbot
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

SUB showcity
FOR i = 1 TO ncity
c = 9: IF cityp(i) = 2 THEN c = 7
IF cityp(i) = 0 THEN c = 12
x = cityx(i): y = cityy(i)
SELECT CASE fort(i)
	CASE 1
		LINE (x - 6, y - 6)-(x + 6, y + 6), 0, B
	CASE IS > 1
		LINE (x - 6, y - 6)-(x + 6, y + 6), 0, BF
END SELECT
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

SUB snapshot (x, y, flag)
IF flag = 0 THEN GET (x - 10, y - 10)-(x + 10, y + 10), image
IF flag = 1 THEN PUT (x - 10, y - 10), image, PSET
END SUB

SUB starfin (star, fin, who)
star = 1: fin = 30: IF who = 2 THEN star = 31: fin = maxarmy
END SUB

SUB stax (who)
CALL starfin(star, fin, who)
FOR i = star TO fin
IF armysize(i) > 0 AND occupied(ABS(armyloc(i))) <> i THEN
	target = ABS(armyloc(i))
	CALL icon(target, 0, 10)
END IF
NEXT i
END SUB

SUB strong (index)
a$ = LTRIM$(RTRIM$(STR$(armysize(index)))) + "00"
PRINT a$;
END SUB

SUB TICK (sec!)
start! = TIMER
DO WHILE TIMER - start! < sec! AND INKEY$ = "": LOOP
END SUB

