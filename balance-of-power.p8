pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

-- balance of power
-- by mudbound_dragon
--
-- https://twitch.tv/mudbound_dragon
-- https://chris-allen-lane.com

-- This is minified source code. Unminified source is available here:
-- https://github.com/chrisallenlane/balance-of-power

-- show/hide on-screen debugging info
DEBUG_SHOW = false

-- enable/disable debugging "cheat" functions
DEBUG_CHEAT = true

-- load which stage from the title screen?
-- (useful while developing new maps)
TITLE_STAGE = 1

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
#include build/debug.lua
#include inc/main.lua

-- media assets
__gfx__
cc0000cc00000000000000000000000000b0000033366663666663636663666310eeeeeeeeeeeeeeeeeeeeeeeeeeee0111110009999aaaaaaaaaaaaaaa001111
1c00001c00aaaa0000000000000000000bbb000033366663d666d3d366d366d30eeeeeeeeeeeeeeeeeeeeeeeeeeeeee0111044000999aaaaaaaaaaa000aa0111
010000010a0000a0000aa00000000000bbbbb000333dd6633ddd3333dd33dd330eeeeeeeeeeeeeeeeeeeee02eeeeeee01104444400009999aaaa0000aaaaa011
000000000a0000a000a00a00000aa000555550006633366333333c3333333333eeeeeeeeeeeee0eee0e0ee022eeeeeee110444444094000000009a0aaaaaa011
000000000a0000a000a00a00000aa0008888800066333dd333c3333366636663eeeeeeeeeeee00ee20e0eee02eeeeeee10444444409949990aa9aa099aaaaa01
cc0000cc0a0000a0000aa0000000000008880000666663336333663366d366d3eee02eeeeee022ee0e0eee2202eeeeee04444440000094990a9aa00009aaaaa0
1c00001c00aaaa000000000000000000008000006666633366366663dd33dd33eee02e22eee020e20e0ee02e02eeeeee0444440dddd0094909aa00ddd09aaaa0
0100000100000000000000000000000000000000ddddd333dd3dddd333333333ee00e22eee020ee0e02e022e000eeeee044040ddffffd0940a90dfffdd090aa0
3444444444444444333333334444444336333363333333333333333363363363e002e022e2020e20e0eee0eee202eeee04440ddffffdd0990aa0ddfffdd09aa0
344444444444444444333344444444436d6336d636666663366666636d36d36de00002ee2020e20e02ee0eeee2202eee04440dfffffffd090a0dffffffd09aa0
33444444444444444444444444444433d3d33d3d366666633dd666636666666d00002ee02eee20e02ee020e0e02202ee04440df4444ffff0a0fff4444fd099a0
334444444444444444444444444444333333c33336666663333dddd36666666d0e022e2220e20e02ee0200e02202002e04040d499994444f0444499994d090a0
33444444444444444444444444444433333cc33336666663333333336666666d002ee220ee20e000e00e2e220220200e04400d444499994ff499994444d009a0
334444444455554444444444444444333633336336666dd3366666636d36d36d022e20eee20000500500e200000205020440dff00555444dd44455500ffd09a0
344444445533335544444444444444436d6336d63ddddd333dd666636d36d36d00e00ee22000055444500000200005600440dff50000000dd00000005ffd09a0
34444444333333334444444444444443d3d33d3d33333333333dddd3dd3dd3dd00022e007000704f4f4060007020567004400df0066d505ff505d6610fd00990
44444455554444443333333443333333444444443d44444433333333333333330000e0206b0070ff4f40600b70205670000000d06661600ff00616660d000000
44445533335544443333344444433333444444443354444433333333433333330040e025066705f44ff50667054056700d00ddd56dd1155ff5511dd65ddd00d0
44453333333354443334444444444333444444443335444433333333443333330440e044500054444fff50005f405670fdd0dff555555ddffdd555555ffd0ddf
445333333333354433444444444444334445544433335444333333334443333304000244455544444ffff555fff05670f000dffffdddd55ff55ddddffffd000f
453333333333335433444444444444334453354433334444333333334443333304402444444444404f4ffffffff05670f0d0ddffffffd5ffff5dffffffdd0d0f
453333333333335434444444444444434533335433344444333443334533333300440444444444404f4ffffffff40500f0f00ddffffdd5ffff5ddffffdd00f0f
5333333333333335344444444444444353333335334444443344443353333333200404444444444455fffffffff405000d0050ddfd444500055444dfdd0500d0
5333333333333335444444444444444433333333344444443444444333333333200000444444444444fffffffff056020fd0555dd44999555aaa944dd5550df0
43333333333333345444444444444445333333334444445335444453333333332020004444444444444ffffff405670210fd5d5d449494aaa4a4aa44d5d5df01
4333333333333334354444444444445343333334444445333354453333333334022020044444444000000fff40567002110f0ddd4990999999990aa4ddd0f011
44333333333333443544444444444453443333444444533333355333333333440222200444444400006660000567002211100ddd4000055555500004ddd00111
44333333333333443354444444444533444334444445333333333333333334440022220044444400065656555670022011110ddd40ffffffffffff04ddd01111
44433333333334443354444444444533444444444444333333333333333334441002020004444440055555000000200011110ddddffffd5555dffffdddd01111
444433333333444433355444444553334444444444444333333333333333335411100220004444440050504400022001111100dddfffd5dddd5dfffddd001111
444444333344444433333555455333334444444444444433333333333333333511111002000444444400044000200111111110dddffffffffffffffddd011111
4444444444444444333333355333333344444444444444433333333333333333111111000000444444444400000111111111110ddd5ffffddffff5ddd0111111
33333333333333f77f333333333333337f33333373333333333333333333333333333333333333333335533333355333bbbbbb5555bbbbbb3333333bb3333333
33333333333ff7cccc7ff33333333333c7f33333f3333333333333333333333333333333333333333335533333355333bbbb55333355bbbb33333bbbbbb33333
3333333333f7cccccccc7f3333333333cc7f3333c7333333333333333333333333333333333333333335533333355333bbb5333333335bbb333bbbbbbbbbb333
333333333f7cccccccccc7f3333ff333ccc7f333cf333333333333335555555533355555555553333335555555555333bb533333333335bb33bbbbbbbbbbbb33
333333333fccccccccccccf333f77f33ccc7f333c7333333333333335555555533355555555553333335555555555333b53333333333335b33bbbbbbbbbbbb33
3333333337cccccccccccc733f7cc7f3cc7f3333c7333333333333333333333333355333333553333335533333355333b53333333333335b3bbbbbbbbbbbbbb3
33333333fccccccccccccccff7cccc7fc7f333337f333333337f77f3333333333335533333355333333553333335533353333333333333353bbbbbbbbbbbbbb3
333333337cccccccccccccc77cccccc77f333333733333337fcccc7733333333333553333335533333355333333553335333333333333335bbbbbbbbbbbbbbbb
bbbbbbbb7cccccccccccccc77cccccc7333333f777ccccf7333333373335533333355333333553333335533333333333b33333333333333b5bbbbbbbbbbbbbb5
bbbbbbbbfccccccccccccccff7cccc7f33333f7c3f77f733333333f73335533333355333333553333335533333333333b33333333333333b35bbbbbbbbbbbb53
bbbbbbbb37cccccccccccc733f7cc7f33333f7cc333333333333337c3335533333355333333553333335533333333333bb333333333333bb35bbbbbbbbbbbb53
bbbbbbbb3fccccccccccccf333f77f33333f7ccc333333333333337c3335533333355555555553335555555555555555bb333333333333bb335bbbbbbbbbb533
bbbbbbbb3f7cccccccccc7f3333ff333333f7ccc33333333333333fc3335533333355555555553335555555555555555bbb3333333333bbb335bbbbbbbbbb533
bbbbbbbb33f7cccccccc7f33333333333333f7cc333333333333337c3335533333333333333333333333333333355333bbbb33333333bbbb33355bbbbbb55333
bbbbbbbb333ff7cccc7ff3333333333333333f7c333333333333333f3335533333333333333333333333333333355333bbbbbb3333bbbbbb3333355bb5533333
bbbbbbbb333333f77f33333333333333333333f733333333333333373335533333333333333333333333333333355333bbbbbbbbbbbbbbbb3333333553333333
cccccccccccccc7ff7ccccccccccccccf7cccccc7cccccccccccccccfc66666666666666666666cfbbbbbbbb35bbbbbb33333333333333333bbbbbbbbbbbbbbb
ccccccccccc77f3333f77ccccccccccc3f7ccccc7ccccccccccccccc66dddddddddddddddddddd66bbbbbbbb335bbbbb33333333b33333333bbbbbbbbbbbbbbb
cccccccccc7f33333333f7cccccccccc33f7ccccf7cccccccccccccc555555555555555555555555bbbbbbbb3335bbbb33333333bb33333333bbbbbbbbbbbbbb
ccccccccc7f3333333333f7cccc77ccc333f7ccc77cccccccccccccc555555555555555555555555bbb55bbb33335bbb33333333bbb3333333bbbbbbbbbbbbbb
ccccccccc73333333333337ccc7ff7cc333f7cccf7cccccccccccccc555555555555555555555555bb5335bb3333bbbb33333333bbb3333333bbbbbbbbbbbbbb
cccccccccf333333333333fcc7f33f7c33f7ccccf7cccccccccccccc556666666666666666666655b533335b333bbbbb333bb333b533333333bbbbbbbb5555bb
cccccccc73333333333333377f3333f73f7ccccc7ccccccccc7777cc6666666666666666666666665333333533bbbbbb33bbbb33533333333bbbbbbb55333355
ccccccccf33333333333333ff333333ff7cccccc7ccccccc77ff7f77fccccccccccccccccccccccf333333333bbbbbbb3bbbbbb3333333333bbbbbbb33333333
33355333f33333333333333ff333333fcccccc7f77f7ff77ccccccc7f655556fc655556cc655556c33333333bbbbbb5335bbbb533333333333333333bbbbbbb3
3335533373333333333333377f3333f7ccccc7f3cc7777ccccccccc7c655556cc655556cc655556cb333333bbbbbb533335bb5333333333bbb3333bbbbbbbbb3
33355333cf333333333333fcc7f33f7ccccc7f33cccccccccccccc7fc655556cc655556cc655556cbb3333bbbbbb533333355333333333bbbbbbbbbbbbbbbb33
55555555c73333333333337ccc7ff7ccccc7f333cccccccccccccc7fc655556cc655556cc655556cbbb33bbbbbb533333333333333333bbbbbbbbbbbbbbbbb33
55555555c7f3333333333f7cccc77cccccc7f333cccccccccccccc77c655556cc655556cc655556cbbbbbbbbbbbb33333333333333333bbbbbbbbbbbbbbbbb33
33355333cc7f33333333f7cccccccccccccc7f33cccccccccccccc7fc655556cc655556cc655556cbbbbbbbbbbbbb333333333333333335bbbbbbbbbbbbbbb33
33355333ccc77f3333f77cccccccccccccccc7f3ccccccccccccccc7c655556cc655556cc655556cbbbbbbbbbbbbbb333333333333333335bbbbbbbbbbbbbbb3
33355333cccccc7ff7cccccccccccccccccccc7fccccccccccccccc7c655556cc655556cf655556fbbbbbbbbbbbbbbb33333333333333333bbbbbbbbbbbbbbb3
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
4040404040404040404160744040404040404040404040404040404040404040404040404057404040404040404040406060606060606060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4040404040404040566060524040404040404040404040404040404040404040404040404057404040404040404040406060606060606060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4747474747474747476769474749404040404040404040404040404040404040404040404057404040404040404040406060606060404060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
40407d7e7e6d4040726060444057404040404040404040404040404040404040404040404057404040404040404040406060605050404040406060404060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4040407c7c404056606052404057404040404040404040404040404040404040404040404057404040404040404040406060604050404060404040406060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4040404040404046646140406c57404040404040404040404040404040404040404175424057404040404040404040406060604040404040404040404060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
404e7a7e4f4041637440404e7f58474747474749404040404040404040404040546060604557404040404040404040406060606040404040404040404060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
405e50504c4152406471406e507e7a7a6d404057404040404040404040404040406260524057404040404040404040406060606040404050404040405060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
40404d5f406242406274405e5050504c40404057404040404040404040404040404055404057404040404040404040406060606060405060504050506060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4014404142406442405142405e505f4142404057404040404040404040404040404040404057404040404040404040406060606060606060605060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
404056605241605240406473427c726076404057404040404040404040404040404040404057404040404040404040406060606060606060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
4142727640647440414251606073606060714057464040404040404040404040404040404057404040404040404040406060606060606060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
6060606073606042517640646060606060607577604240404040404040404040404040404057404040404040404040406060606060606060606060606060606060606060606060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
6060606060606060737440646060606060606079606042724240404040404040404040404057404040404040404040406060606060606060606060606060606060606060606040606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
6060606060606060606073606060606060665257516360606042404040404040404040404057404040404040404040406060606060606060606060606060606060606060504060606060606060606060101010101010101010101010101010101111111111111111111111111111111110101010101010101010101010101010
0000000000000000000000000000000000000000000000000000000000000000404040404057404040404040404040406060606060606060606060606060606060606050404040606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
7c404040574d505050506f505050505011111111111111111111111111111111404040404057404040404040404040406060606060606060606060606060606060606050404040606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
40404040575d5050504c404d5050505011111111111111111111111111111111404040404057404040404040404040406060606060606060606060606060606060605040404040606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
4f401540576e50507f4014406e50505011111111111111111111111111111111404040404057404040404040404040406060606060606060606060606060606060505040406060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
7f404040576b5050505c575d5050505011111111111111111111111111111111404040404057404040404040404040406060606060606060606060606060606060404040406060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
506d4040576e5050507f576e5050505011111111111111111111111111111111404040404057404040404040404040406060606060606060606060606060606060604060406060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
4c464040575e6a6f6f5f575e6f6a4c7c11111111111111111111111111111111404040404057404040404040404040406060606060506060606060606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
4160424058474747474770474747474711111111111111111111111111111111404040404057404040404040404040406060404050404040406060606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
60606071407d6d7d6f6d577d7a507e7a11111111111111111111111111111111404040404057404040404040404040406060606040404040606060606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
6060606071434040404657467c4d505011111111111111111111111111111111404040404057404040404040404040406060606040604040404060606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
51606066636073757560776042405e5011111111111111111111111111111111404040404057404040404040404040406060604040606040404060606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
6d51527d6d555355556279606042407c1111111111111111111111111111111140404040404a474747474747474747476060604040404040404040606060606060606060606060606060606060606060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
475b5b474747475b5b474b555163754211111111111111111111111111111111404040404057404040404046404040406060606060606040404060406060606060606060606060606060606060506060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
400705406c6c40071740574e4f6c516011111111111111111111111111111111404040404057404040404160714040406060606060406060606060606060606060606060606060606060605050405060111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
4015167d6f5f40051640575e6f6f6d5111111111111111111111111111111111404040404057404040546060604240406060606060606060606060606060606060606060606060606050504040404050111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
475a5a474747475a5a475a474747474711111111111111111111111111111111404040404057404040405160605240406060606060606060606060606060606060606060606060605040404040404040111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111010101010101010101010101010101011111111111111111111111111111111
__sfx__
010108000c7340c7300c7300c7300e7500e7500e7500e7550c7540c7500c7500c7500b7300b7300b7300b735227002270021700207001f7001e7001f7002170021700207001f7001f70000000000000000000000
