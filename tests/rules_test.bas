' Unit tests of the game's rules that draw nothing.
' Run from the repo's folder:  qb64rust test tests
'
' Each test runs in a program of its own, so every shared array starts at
' zero. A test sets the few values the SUB reads, calls it and checks what
' the code gives today. These tests record behavior; they do not judge it.

'$INCLUDE: '../ww2.bi'

' ---------------------------------------------------------------- airdist
' airdist gives the distance from a side's air base to a city, or -1 when
' the city is out of range. Range is 50 for each level of teklev(who, 7)
' above the first.

SUB PlaceAirBase
airloc(1) = 1: cityx(1) = 100: cityy(1) = 100
cityx(2) = 130: cityy(2) = 140
cityx(3) = 160: cityy(3) = 180
END SUB

SUB TestAirdistNoTarget
PlaceAirBase
CALL airdist(1, 0, d)
AssertEqualInt -1, d, "target 0"
END SUB

SUB TestAirdistInRange
PlaceAirBase
CALL airdist(1, 2, d)
AssertEqualInt 50, d, "30 across and 40 down"
END SUB

SUB TestAirdistOutOfRange
PlaceAirBase
CALL airdist(1, 3, d)
AssertEqualInt -1, d, "100 away at range 50"
END SUB

SUB TestAirdistLongerRange
PlaceAirBase
teklev(1, 7) = 1
CALL airdist(1, 3, d)
AssertEqualInt 100, d, "100 away at range 100"
END SUB

SUB TestAirdistToEnemyFleet
PlaceAirBase
shipx(2) = 100: shipy(2) = 130
CALL airdist(1, 99, d)
AssertEqualInt 30, d, "target 99 is the other side's fleet"
END SUB

' ---------------------------------------------------------------- starfin
' The Allied armies are 1 to 30, the Axis armies 31 to maxarmy.

SUB TestStarfinAllied
CALL starfin(star, fin, 1)
AssertEqualInt 1, star, "first"
AssertEqualInt 30, fin, "last"
END SUB

SUB TestStarfinAxis
CALL starfin(star, fin, 2)
AssertEqualInt 31, star, "first"
AssertEqualInt maxarmy, fin, "last"
END SUB

' ----------------------------------------------------------------- occupy
' occupied(city) is the lowest-numbered army in the city, or 0.

SUB TestOccupyFirstArmy
armyloc(5) = 7: armyloc(9) = 7
occupied(7) = 99
CALL occupy(7)
AssertEqualInt 5, occupied(7), "armies 5 and 9 in city 7"
END SUB

SUB TestOccupyEmpty
occupied(7) = 99
CALL occupy(7)
AssertEqualInt 0, occupied(7), "no army in city 7"
END SUB

' ----------------------------------------------------------------- bubble
' Sorts mtx$(1 TO x) and carries array() with it.

SUB TestBubbleSorts
mtx$(1) = "c": mtx$(2) = "a": mtx$(3) = "b"
array(1) = 1: array(2) = 2: array(3) = 3
CALL bubble(3)
AssertEqualStr "abc", mtx$(1) + mtx$(2) + mtx$(3), "names"
AssertEqualInt 2, array(1), "array(1)"
AssertEqualInt 3, array(2), "array(2)"
AssertEqualInt 1, array(3), "array(3)"
END SUB

' --------------------------------------------------------------- canimove
' flag = 1 when the weather stops army index from moving.

SUB TestCanimoveFairWeather
weather = 1: armyloc(1) = 1: unittype(1) = 1
CALL canimove(1, flag)
AssertEqualInt 0, flag, "weather 1"
END SUB

SUB TestCanimoveNorthernInfantry
weather = 2: armyloc(1) = 1: cityy(1) = 100
unittype(1) = 1: armyexper(1) = 5
CALL canimove(1, flag)
AssertEqualInt 1, flag, "type 1, experience 5, north of y 190"
END SUB

SUB TestCanimoveNorthernWithTechnology
weather = 2: armyloc(1) = 1: cityy(1) = 100
unittype(1) = 1: armyexper(1) = 5
teklev(1, 3) = 3
CALL canimove(1, flag)
AssertEqualInt 0, flag, "teklev(1, 3) = 3"
END SUB

SUB TestCanimoveSouthern
weather = 2: armyloc(1) = 1: cityy(1) = 300
unittype(1) = 1: armyexper(1) = 5
CALL canimove(1, flag)
AssertEqualInt 0, flag, "south of y 190"
END SUB

SUB TestCanimoveWorstWeatherArmor
weather = 3: armyloc(1) = 1: unittype(1) = 2: armyexper(1) = 9
CALL canimove(1, flag)
AssertEqualInt 1, flag, "type 2 in weather 3"
END SUB

SUB TestCanimoveWorstWeatherVeterans
weather = 3: armyloc(1) = 1: unittype(1) = 1: armyexper(1) = 5
CALL canimove(1, flag)
AssertEqualInt 0, flag, "type 1, experience 5"
END SUB

SUB TestCanimoveWorstWeatherRecruits
weather = 3: armyloc(1) = 1: unittype(1) = 1: armyexper(1) = 4
CALL canimove(1, flag)
AssertEqualInt 1, flag, "type 1, experience 4"
END SUB

' ------------------------------------------------------------------- void
' y = the strength of side's armies next to city a, plus a tenth of those
' two steps away.

SUB TestVoidCountsNeighbors
side = 1
matrix(1, 1) = 2: cityp(2) = 1: occupied(2) = 3: armysize(3) = 40
matrix(2, 1) = 1
matrix(2, 2) = 4: cityp(4) = 1: occupied(4) = 5: armysize(5) = 30
CALL void(1, y)
AssertEqualInt 43, y, "40 next door and 30 two steps away"
END SUB

SUB TestVoidIgnoresOtherSide
side = 1
matrix(1, 1) = 2: cityp(2) = 2: occupied(2) = 3: armysize(3) = 40
CALL void(1, y)
AssertEqualInt 0, y, "the neighbor belongs to side 2"
END SUB

SUB TestVoidHighCityNumber
CALL void(57, y)
AssertEqualInt 0, y, "cities above 56"
END SUB

' -------------------------------------------------------------- commander
' empty is the first free army number of side who: no city and a size
' below 1. It is 0 when the side has no free number.

SUB TestCommanderFirstFree
armysize(1) = 10: armyloc(1) = 3
armysize(2) = 10: armyloc(2) = 4
CALL commander(1, empty)
AssertEqualInt 3, empty, "armies 1 and 2 in use"
END SUB

SUB TestCommanderArmyWithoutCity
armysize(1) = 5
CALL commander(1, empty)
AssertEqualInt 2, empty, "army 1 has no city but has men"
END SUB

SUB TestCommanderAxis
CALL commander(2, empty)
AssertEqualInt 31, empty, "the Axis numbers start at 31"
END SUB

SUB TestCommanderNoneFree
FOR i = 1 TO 30: armysize(i) = 1: NEXT i
CALL commander(1, empty)
AssertEqualInt 0, empty, "all 30 Allied numbers in use"
END SUB

' ----------------------------------------------------------------- normal
' x is a draw near xbar: the sum of 12 RNDs, less 5.5, times the square
' root of vary, added to xbar. x is an INTEGER, so the draw is rounded.
' The 12 RNDs add up to 6 on average, not 5.5, so the draws center on
' xbar + SQR(vary) / 2, not on xbar.

SUB TestNormalNoVariance
CALL normal(40, 0, x)
AssertEqualInt 40, x, "vary 0"
END SUB

SUB TestNormalStaysInRange
' vary 4: the draw is 2 * (-5.5 to 6.5), so 29 to 53 around 40.
total& = 0
FOR i = 1 TO 1000
    CALL normal(40, 4, x)
    AssertTrue x >= 29 AND x <= 53, "draw" + STR$(i) + " is" + STR$(x)
    total& = total& + x
NEXT i
AssertNear 41, total& / 1000, .3, "the mean of 1000 draws, 1 above xbar"
END SUB

' ---------------------------------------------------------------- retreat
' x is the city that army defend retreats to: a city of its own side next
' to its own. A player chooses from a menu when there are two or more;
' these tests stay off that path.

SUB PlaceRetreat
' Army 5 (Allied) in city 1. City 2 is Allied, city 3 is Axis.
side = 1
armyloc(5) = 1: armysize(5) = 20
matrix(1, 1) = 2: cityp(2) = 1
matrix(1, 2) = 3: cityp(3) = 2
END SUB

SUB TestRetreatOneWayOut
PlaceRetreat
CALL retreat(5, x)
AssertEqualInt 2, x, "city 2 is the only Allied neighbor"
END SUB

SUB TestRetreatNoWayOut
PlaceRetreat
cityp(2) = 2
CALL retreat(5, x)
AssertEqualInt 0, x, "both neighbors are Axis"
END SUB

SUB TestRetreatPlayByMail
PlaceRetreat
pbm = 1
CALL retreat(5, x)
AssertEqualInt 0, x, "no retreat in a play-by-mail game"
END SUB

SUB TestRetreatAcrossTheSea
PlaceRetreat
matrix(1, 7) = 99: matrix(2, 7) = 99
CALL retreat(5, x)
AssertEqualInt 2, x, "a sea crossing with no enemy navy"
END SUB

SUB TestRetreatHemmedByNavy
PlaceRetreat
matrix(1, 7) = 99: matrix(2, 7) = 99
navyloc(2) = 1
CALL retreat(5, x)
AssertEqualInt 0, x, "the Axis navy is at city 1"
END SUB

SUB TestRetreatComputerChoosesAtRandom
' One player on the Allied side: Axis army 35 is the computer's, so it
' chooses at random between Axis cities 2 and 3 with no menu.
player = 1: side = 1
armyloc(35) = 1: armysize(35) = 20
matrix(1, 1) = 2: cityp(2) = 2
matrix(1, 2) = 3: cityp(3) = 2
saw2 = 0: saw3 = 0
FOR i = 1 TO 50
    CALL retreat(35, x)
    IF x = 2 THEN saw2 = 1 ELSE IF x = 3 THEN saw3 = 1 ELSE Fail "retreat to" + STR$(x)
NEXT i
AssertEqualInt 1, saw2, "city 2 chosen in 50 retreats"
AssertEqualInt 1, saw3, "city 3 chosen in 50 retreats"
END SUB

' --------------------------------------------------------------- evaluate
' x is the neighbor (1 to 6, the column of matrix) that the computer's
' army index should move to, or 0 to stay. The scores use RND; each test
' sets a case where the result does not depend on it.

SUB PlaceEvaluate
' Allied army 1 holds city 1 at (100, 100).
side = 1
armyloc(1) = 1: armysize(1) = 500: occupied(1) = 1: cityp(1) = 1
cityx(1) = 100: cityy(1) = 100
END SUB

SUB TestEvaluateHoldsOwnCapital
PlaceEvaluate
capcity(1) = 1
matrix(1, 1) = 2: cityp(2) = 2
CALL evaluate(1, x)
AssertEqualInt 0, x, "army 1 holds its own capital"
END SUB

SUB TestEvaluateNoNeighbors
PlaceEvaluate
CALL evaluate(1, x)
AssertEqualInt 0, x, "city 1 has no neighbors"
END SUB

SUB TestEvaluateTakesEmptyEnemyCapital
' Neighbor 1 is an empty Allied city to the west; neighbor 2 is the
' empty Axis capital to the east.
PlaceEvaluate
matrix(1, 1) = 3: cityp(3) = 1: cityx(3) = 0: cityy(3) = 100
matrix(1, 2) = 2: cityp(2) = 2: cityx(2) = 200: cityy(2) = 100
capcity(2) = 2
CALL evaluate(1, x)
AssertEqualInt 2, x, "the empty Axis capital"
END SUB

SUB TestEvaluateCoversThreatenedCapital
' Neighbor 1 is the empty Allied capital, which army 1 itself is next
' to; neighbor 2 is an empty Axis city.
PlaceEvaluate
matrix(1, 1) = 2: cityp(2) = 1: capcity(1) = 2
matrix(2, 1) = 1
matrix(1, 2) = 3: cityp(3) = 2
CALL evaluate(1, x)
AssertEqualInt 1, x, "the empty Allied capital"
END SUB

SUB PlaceEvaluateEnemy (strength)
' Axis army 31, of the given strength, holds city 2 next door. Neither
' side has a capital.
PlaceEvaluate
matrix(1, 1) = 2: cityp(2) = 2: cityx(2) = 110: cityy(2) = 100
armyloc(31) = 2: armysize(31) = strength: occupied(2) = 31
END SUB

SUB TestEvaluateAttacksWeakerArmy
PlaceEvaluateEnemy 20
CALL evaluate(1, x)
AssertEqualInt 1, x, "500 against 20"
END SUB

SUB TestEvaluateAvoidsStrongerArmy
PlaceEvaluateEnemy 5000
armysize(1) = 20
CALL evaluate(1, x)
AssertEqualInt 0, x, "20 against 5000"
END SUB

' ---------------------------------------------------------------- CURDIR$
' QB64.BM's CURDIR$ is the current folder as PDS 7.1 gives it: QB64's
' _CWD$ without the separator at its end. Without the FUNCTION, CURDIR$
' would be an empty string variable.

SUB TestCurdirIsTheCurrentFolder
AssertEqualStr _CWD$, CURDIR$ + RIGHT$(_CWD$, 1), "CURDIR$ and _CWD$"
END SUB

'$INCLUDE: '../ww2a.bm'
'$INCLUDE: '../ww2b.bm'
'$INCLUDE: '../ww2c.bm'
'$INCLUDE: '../qb64.bm'
'$INCLUDE: '../script.bm'
