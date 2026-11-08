# Why the WW2 map looks worse than the Civil War Strategy map

Written 2026-11-07, after comparing `SUB europe` (`WW2C.BM`, lines 702–831) with
`SUB usa` in Civil War Strategy (`CWSTRAT2.BM`, lines 1426–1746) and the two games'
screenshots (`tests/out/explore/*.png` in each repo).

## It is the content of the map, not the technique

Both games use SCREEN 12: 640×480, 16 colors, the same 8×8 font and the same menu
code. The pixels are the same size. The difference is what Hutsell chose to draw.

| | Civil War Strategy | World War 2 |
|---|---|---|
| How the outline is drawn | 215 `LINE` statements, hand-placed, straight segments | 37 `DRAW` strings from `graphics/EUROPE.GRF`: 922 one-pixel steps (`E1U2E1U1…`) |
| Interior lines | **State borders**: dark lines dividing the land into about 15 regions | None. Europe is one green blob with no borders |
| Rivers | **74 blue segments**: Ohio, Mississippi, Tennessee, Potomac, James | None |
| Coastline | Deep blue Atlantic and Gulf with bays, the Chesapeake, Florida | Coast present but the sea is a flat strip; the Baltic is six straight segments (`R37D2G8L5D7`) |
| Mountains | 8 `PUT` of a 40-pixel tile (`mtn.vga`), clustered as the Appalachians | 19 `PUT` of a smaller tile (`m.vga`), strewn over the Alps and Balkans |
| Cities | 40 on a 527×424 field (`scenarios/CITIES.GRD`); labels mostly clear | 58 on a 525×438 field (`scenarios/EURO1939.DAT`); `CHERBOURG`/`ROUEN`, `AMSTERDAM`/`ESSEN`, `BIRM'GHAM`/`LONDON` overlap |
| Unit icons | 20×20 flag bitmaps in a white box; forts drawn around the city | 16-pixel flag blocks beside the city dot |
| Roads | Dotted black lines on green: high contrast | Dotted white lines: fade against the green |

Three of these do nearly all the work.

1. **Interior structure.** The state borders and rivers give the CWS map texture and a
   sense of place. The eye reads "Kentucky, the Ohio, the Mississippi". WW2's Europe has
   no national borders at all, so France, Germany and Poland are the same green. This is
   the main reason it looks like a blob. The game knows who owns each city (`cityp`) but
   never draws it on the land.
2. **Density.** 58 cities in the same area as 40, with the same 8×8 font, is 45% more
   crowded. Overlapping labels read as "pixelated mess" even though the pixels are the
   same.
3. **Drawing method.** CWS's `LINE` segments are straight and 5 to 40 pixels long, so
   they look deliberate. WW2's `DRAW` strings are one- and two-pixel diagonal steps, which
   is how an outline is traced from a paper map. The result is a wobbly, jagged coast with
   no clean edge anywhere.

The `DRAW` method is also why converting the coast to vectors (`tests/out/mapsvg.py`)
gives 42 polylines of 922 points: it is a pixel trace, not a vector map.

## What this means for a modernized WW2

The change that matters for the map is content, not resolution.

- **Draw national borders** (1939 frontiers), tinted by owner from `cityp`. This is what
  CWS has and WW2 lacks.
- **Add the big rivers**: Rhine, Danube, Seine, Po, Vistula. Cheap, and it changes the
  look of the whole map.
- **Fix the label density**: stagger labels, or abbreviate on the map and show the full
  name in a hover card.
- **Replace the `DRAW` coast with a proper vector outline.** The current trace is a good
  reference for registration (city coordinates must not move), but a redrawn coastline at
  the same coordinates would look better even at 640×480.
- **Draw roads in a dark color**, as CWS does.

Resolution alone (mockup A, "Faithful HD") makes WW2 sharper but not better than CWS: it
would still be a borderless green blob with crowded labels. Mockup B ("Refreshed") is
where borders and rivers belong.
