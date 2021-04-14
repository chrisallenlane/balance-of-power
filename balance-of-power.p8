pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

-- This is minified source code. Unminified source is available here:
-- https://github.com/chrisallenlane/balance-of-power

-- show/hide on-screen debugging info
DEBUG_SHOW = false

-- enable/disable debugging "cheat" functions
DEBUG_CHEAT = true

-- initialize globals
Menus = {}

-- build the `State` object (order dependent)
#include inc/camera.lua
#include inc/cursor.lua
#include inc/player.lua
#include inc/screens.lua
#include inc/talk.lua
#include inc/state.lua

-- load assets (order independent)
#include inc/anim.lua
#include inc/banner.lua
#include inc/cell.lua
#include inc/cpu.lua
#include inc/info.lua
#include inc/input.lua
#include inc/inputs.lua
#include inc/menu-stat.lua
#include inc/menu-balance.lua
#include inc/menu-target.lua
#include inc/menu-title.lua
#include inc/menu-turn-end.lua
#include inc/radius.lua
#include inc/screen-battle.lua
#include inc/screen-defeat.lua
#include inc/screen-intr.lua
#include inc/screen-title.lua
#include inc/screen-victory.lua
#include inc/seq.lua
#include inc/stage.lua
#include inc/string.lua
#include inc/unit.lua
#include inc/units.lua

-- load stages
#include build/stages.lua

-- load main
#include inc/debug.lua
#include inc/main.lua

-- media assets
__gfx__
000000000aaaaaa000000000000000000000000000000000000000000000000055eeeeeeeeeeeeeeeeeeeeeeeeeeee5555550009999aaaaaaaaaaaaaaa005555
0cc00000aa0000aa00aaaa0000000000000000000000000000000000000000005eeeeeeeeeeeeeeeeeeeeeeeeeeeeee5555044000999aaaaaaaaaaa000aa0555
0cccc000a000000a0a0000a000eeee00000000000000000000000000000000005eeeeeeeeeeeeeeeeeeeee02eeeeeee55504444400009999aaaa0000aaaaa055
0cccccc0a000000a0a0000a000e00e0000088000000000000000000000000000eeeeeeeeeeeee0eee0e0ee022eeeeeee550444444094000000009a0aaaaaa055
0cccc110a000000a0a0000a000e00e0000088000000000000000000000000000eeeeeeeeeeee00ee20e0eee02eeeeeee50444444409949990aa9aa099aaaaa05
0cc11000a000000a0a0000a000eeee0000000000000000000000000000000000eee02eeeeee022ee0e0eee2202eeeeee04444440000094990a9aa00009aaaaa0
01100000aa0000aa00aaaa000000000000000000000000000000000000000000eee02e22eee020e20e0ee02e02eeeeee0444440dddd0094909aa00ddd09aaaa0
000000000aaaaaa0000000000000000000000000000000000000000000000000ee00e22eee020ee0e02e022e000eeeee044040ddffffd0940a90dfffdd090aa0
3444444444444444333333334444444300000000000000000000000000000000e002e02ee2020e20e0eee0eee202eeee04440ddffffdd0990aa0ddfffdd09aa0
3444444444444444443333444444444300000000000000000000000000000000e00002ee2020e20e02ee020e22202eee04440dfffffffd090a0dffffffd09aa0
334444444444444444444444444444330000000000000000000000000000000000002ee02eee20e02ee020e0242202ee04440df4444ffff0a0fff4444fd099a0
33444444444444444444444444444433000000000000000000000000000000000e02ee2220e20e02ee0200e02f42002e04040d499994444f0444499994d090a0
3344444444444444444444444444443300000000000000000000000000000000002ee220ee20e044e4422e224ff4200e04400d444499994ff499994444d009a0
3344444444555544444444444444443300000000000000000000000000000000022e20eee200e4444f4442006fff5d020440dff00555444dd44455500ffd09a0
344444445533335544444444444444430000000000000000000000000000000000e00ee220002ff44ff470007fff5d600440dff50000000dd00000005ffd09a0
344444443333333344444444444444430000000000000000000000000000000004004e4470007fff4ff460007ff5d66704400df0066d505ff505d6610fd00990
4444445555444444333333344333333344444444354444443333333333333333040044446b007fff4ff4600b7ff5d667000000d06661600ff00616660d000000
44445533335544443333344444433333444444443354444433333333433333330440444446674ff44fff46674ff5d6670d00ddd56dd1155ff5511dd65ddd00d0
444533333333544433344444444443334444444433354444333333334433333304404444444444444fff4444fff5d667fdd0dff555555ddffdd555555ffd0ddf
445333333333354433444444444444334445544433335444333333334443333304404444444444404ffffffffff5d667f000dffffdddd55ff55ddddffffd000f
4533333333333354334444444444443344533544333344443333333344433333044044444444440046fffffffff5d667f0d0ddffffffd5ffff5dffffffdd0d0f
4533333333333354344444444444444345333354333444443334433345333333004404444444441016fffffffff45d62f0f00ddffffdd5ffff5ddffffdd00f0f
5333333333333335344444444444444353333335334444443344443353333333200404444444444411fffffffff45d620d0050ddfd444500055444dfdd0500d0
53333333333333354444444444444444333333333444444434444443333333332000004444444444444ffffffff5d6620fd0555dd44999555aaa944dd5550df0
43333333333333345444444444444445333333334444445335444453333333330000004444444444444fffffff5d667250fd5d5d449494aaa4a4aa44d5d5df05
433333333333333435444444444444534333333444444533335445333333333400000004444444000000fffff5d66722550f0ddd4990999999990aa4ddd0f055
44333333333333443544444444444453443333444444533333355333333333440200000444444400005554445d66722555500ddd4000055555500004ddd00555
4433333333333344335444444444453344433444444533333333333333333444552000004444440005555555d667222555550ddd40ffffffffffff04ddd05555
44433333333334443354444444444533444444444444333333333333333334445550220004444440055555666672255555550ddddffffd5555dffffdddd05555
444433333333444433355444444553334444444444444333333333333333335455555222004444440555554400225555555500dddfffd5dddd5dfffddd005555
444444333344444433333555455333334444444444444433333333333333333555555252000444444455544002255555555550dddffffffffffffffddd055555
4444444444444444333333355333333344444444444444433333333333333333555555550000444444444400225555555555550ddd5ffffddffff5ddd0555555
33333333333333f77f333333333333337f33333373333333333333333333333333333333333333333355553333555533bbbbbb5555bbbbbb3333333bb3333333
33333333333ff7cccc7ff33333333333c7f33333f3333333333333333333333333333333333333333355553333555533bbbb55333355bbbb33333bbbbbb33333
3333333333f7cccccccc7f3333333333cc7f3333c7333333333333335555555533355555555553333355555555555533bbb5333333335bbb333bbbbbbbbbb333
333333333f7cccccccccc7f3333ff333ccc7f333cf333333333333335555555533555555555555333355555555555533bb533333333335bb33bbbbbbbbbbbb33
333333333fccccccccccccf333f77f33ccc7f333c7333333333333335555555533555555555555333355555555555533b53333333333335b33bbbbbbbbbbbb33
3333333337cccccccccccc733f7cc7f3cc7f3333c7333333333333335555555533555555555555333355555555555533b53333333333335b3bbbbbbbbbbbbbb3
33333333fccccccccccccccff7cccc7fc7f333337f333333337f77f3333333333355555335555533335555333355553353333333333333353bbbbbbbbbbbbbb3
333333337cccccccccccccc77cccccc77f333333733333337fcccc7733333333335555333355553333555533335555335333333333333335bbbbbbbbbbbbbbbb
bbbbbbbb7cccccccccccccc77cccccc7333333f777ccccf7333333373355553333555533335555333355553333333333b33333333333333b5bbbbbbbbbbbbbb5
bbbbbbbbfccccccccccccccff7cccc7f33333f7c3f77f733333333f73355553333555553355555333355553333333333b33333333333333b35bbbbbbbbbbbb53
bbbbbbbb37cccccccccccc733f7cc7f33333f7cc333333333333337c3355553333555555555555335555555555555555bb333333333333bb35bbbbbbbbbbbb53
bbbbbbbb3fccccccccccccf333f77f33333f7ccc333333333333337c3355553333555555555555335555555555555555bb333333333333bb335bbbbbbbbbb533
bbbbbbbb3f7cccccccccc7f3333ff333333f7ccc33333333333333fc3355553333555555555555335555555555555555bbb3333333333bbb335bbbbbbbbbb533
bbbbbbbb33f7cccccccc7f33333333333333f7cc333333333333337c3355553333355555555553335555555555555555bbbb33333333bbbb33355bbbbbb55333
bbbbbbbb333ff7cccc7ff3333333333333333f7c333333333333333f3355553333333333333333333333333333555533bbbbbb3333bbbbbb33333555b5533333
bbbbbbbb333333f77f33333333333333333333f733333333333333373355553333333333333333333333333333555533bbbbbbbbbbbbbbbb3333333553333333
cccccccccccccc7ff7ccccccccccccccf7cccccc7cccccccccccccccfc66666666666666666666cfbbbbbbbb35bbbbbb33333333333333333bbbbbbbbbbbbbbb
ccccccccccc77f3333f77ccccccccccc3f7ccccc7ccccccccccccccc66dddddddddddddddddddd66bbbbbbbb335bbbbb33333333b33333333bbbbbbbbbbbbbbb
cccccccccc7f33333333f7cccccccccc33f7ccccf7cccccccccccccc555555555555555555555555bbbbbbbb3335bbbb33333333bb33333333bbbbbbbbbbbbbb
ccccccccc7f3333333333f7cccc77ccc333f7ccc77cccccccccccccc555555555555555555555555bbb55bbb33335bbb33333333bbb3333333bbbbbbbbbbbbbb
ccccccccc73333333333337ccc7ff7cc333f7cccf7cccccccccccccc555555555555555555555555bb5335bb3333bbbb33333333bbb3333333bbbbbbbbbbbbbb
cccccccccf333333333333fcc7f33f7c33f7ccccf7cccccccccccccc556666666666666666666655b533335b333bbbbb333bb333b533333333bbbbbbbb5555bb
cccccccc73333333333333377f3333f73f7ccccc7ccccccccc7777cc6666666666666666666666665333333533bbbbbb33bbbb33533333333bbbbbbb55333355
ccccccccf33333333333333ff333333ff7cccccc7ccccccc77ff7f77fccccccccccccccccccccccf333333333bbbbbbb3bbbbbb3333333333bbbbbbb33333333
33333333f33333333333333ff333333fcccccc7f77f7ff77ccccccc7f655556fc655556cc655556c33333333bbbbbb5335bbbb533333333333333333bbbbbbb3
3666663373333333333333377f3333f7ccccc7f3cc7777ccccccccc7c655556cc655556cc655556cb333333bbbbbb533335bb5333333333bbb3333bbbbbbbbb3
36666653cf333333333333fcc7f33f7ccccc7f33cccccccccccccc7fc655556cc655556cc655556cbb3333bbbbbb533333355333333333bbbbbbbbbbbbbbbb33
36666653c73333333333337ccc7ff7ccccc7f333cccccccccccccc7fc655556cc655556cc655556cbbb33bbbbbb533333333333333333bbbbbbbbbbbbbbbbb33
36666653c7f3333333333f7cccc77cccccc7f333cccccccccccccc77c655556cc655556cc655556cbbbbbbbbbbbb33333333333333333bbbbbbbbbbbbbbbbb33
36666653cc7f33333333f7cccccccccccccc7f33cccccccccccccc7fc655556cc655556cc655556cbbbbbbbbbbbbb333333333333333335bbbbbbbbbbbbbbb33
33555553ccc77f3333f77cccccccccccccccc7f3ccccccccccccccc7c655556cc655556cc655556cbbbbbbbbbbbbbb333333333333333335bbbbbbbbbbbbbbb3
33333333cccccc7ff7cccccccccccccccccccc7fccccccccccccccc7c655556cc655556cf655556fbbbbbbbbbbbbbbb33333333333333333bbbbbbbbbbbbbbb3
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4040404040404040404160744040404040404040404040404040404040404040505050505057505050505050505050506060606060606060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4040404040404040566060524040404040404040404040404040404040404040505050505057505050505050505050506060606060606060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4747474747474747476769474749404040404040404040404040404040404040505050505057505050505050505050506060606060404060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
40407d7e7e6d4040726060444057404040404040404040404040404040404040505050505057505050505050505050506060605050404040406060404060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4040407c7c404056606052404057404040404040404040404040404040404040505050505057505050505050505050506060604050404060404040406060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4040404040404046646140406c57404040404040404040404040404040404040504175425057505050505050505050506060604040404040404040404060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
404e7a7e4f4041637440404e7f58474747474749404040404040404040404040546060604557505050505050505050506060606040404040404040404060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
405e50504c4152406471406e507e7a7a6d404057404040404040404040404040506260524057505050505050505050506060606040404050404040405060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
40404d5f406242406274405e5050504c40404057404040404040404040404040505055505057505050504050505050506060606060405060504050506060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4070404142406442405142405e505f4142404057404040404040404040404040505050505057505050505050505050506060606060606060605060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
404056605241605240406473427c726076404057404040404040404040404040505050505057505050505050505050506060606060606060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4142727640647440414251606073606060714057464040404040404040404040505050505057505050505050505050506060606060606060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
6060606073606042517640646060606060607577604240404040404040404040505050505057505050505050505050506060606060606060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
6060606060606060737440646060606060606079606042724240404040404040505050505057505050505050505050506060606060606060606060606060606060606060606040606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
6060606060606060606073606060606060665257516360606042404040404040505050505057505050505040505050506060606060606060606060606060606060606060504060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
6060606060606060606060606060606074404057404062606060714040404040505050505057505050505050505050506060606060606060606060606060606060606050404040606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505050505050506060606060606060606060606060606060606050404040606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505050505050506060606060606060606060606060606060605040404040606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505050505050506060606060606060606060606060606060505040406060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505050505050506060606060606060606060606060606060404040406060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505050505050506060606060606060606060606060606060604060406060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505050505050506060606060506060606060606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505050505050506060404050404040406060606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505050505050506060606040404040606060606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505050505050506060606040604040404060606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111504050505057505050505050505050506060604040606040404060606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
101010101010101010101010101010101111111111111111111111111111111150505050504a474747474747474747476060604040404040404040606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505046505050506060606060606040404060406060606060606060606060606060606060506060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050504160715050506060606060406060606060606060606060606060606060606060605050405060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050546060604250506060606060606060606060606060606060606060606060606050504040404050111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505160605250506060606060606060606060606060606060606060606060605040404040404040111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
1010101010101010101010101010101011111111111111111111111111111111505050505057505050505055535050506060606060606060606060606060606060606060606060504040404040404040111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
__sfx__
010108000c7340c7300c7300c7300e7500e7500e7500e7550c7540c7500c7500c7500b7300b7300b7300b735227002270021700207001f7001e7001f7002170021700207001f7001f70000000000000000000000
