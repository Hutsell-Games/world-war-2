DEFINT A-Z
DECLARE SUB center (y%, a$)
DECLARE SUB citygraf (index%, flag%)
DECLARE SUB deadplane (who%)
DECLARE SUB gcirc (xc%, flag%)
DECLARE SUB ikhan (index%)
DECLARE SUB maptext ()
DECLARE SUB Mickey (a$, lButton%, rButton%, xc%, yc%)
DECLARE SUB pbmview ()
DECLARE SUB showmove (who%)
DECLARE SUB title2 ()
' $INCLUDE: 'ww2.bi'
DIM SHARED yourname$(10), skorz&(2, 5)

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
	IF LEN(DIR$(t$)) = 0 THEN EXIT SUB
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
		IF LEN(DIR$(t$)) < 1 THEN CALL clrbot: COLOR 14: LOCATE 29, 1: PRINT "FILE NOT FOUND :"; t$; : begin$ = "": TICK 5: CALL clrbot: EXIT SUB

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
		t$ = "euro1940.dat": IF begin$ = "1939" OR LEN(DIR$(t$)) = 0 THEN t$ = "euro1939.dat"
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
		IF LEN(DIR$(t$)) > 0 THEN
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
			IF LEN(DIR$("hi" + begin$ + ".ww2")) = 0 THEN
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
	IF LEN(DIR$(file$)) = 0 THEN EXIT SUB
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