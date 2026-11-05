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

'$INCLUDE: '../ww2a.bm'
'$INCLUDE: '../ww2b.bm'
'$INCLUDE: '../ww2c.bm'
'$INCLUDE: '../mickey.bm'
'$INCLUDE: '../qb64.bm'
'$INCLUDE: '../script.bm'
