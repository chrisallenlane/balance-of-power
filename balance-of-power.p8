pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

-- show/hide on-screen debugging info
DEBUG_SHOW = false

-- TODO: refactor this
Game = { state = { screen = "title" } }

-- externaize non-media assets
#include src/radius.lua
#include src/screen.lua
#include src/screen-battle.lua
#include src/screen-title.lua
#include src/screen-intr.lua
#include src/screen-victory.lua
#include src/screen-defeat.lua
#include src/menu-screen-title.lua
#include src/menu-balance.lua
#include src/menu-turn-end.lua
#include src/player.lua
#include src/cpu.lua
#include src/input.lua
#include src/inputs.lua
#include src/cell.lua
#include src/queue.lua
#include src/astar.lua
#include src/turn.lua
#include src/camera.lua
#include src/unit.lua
#include src/units.lua
#include src/cursor.lua
#include src/map.lua
#include map/1.lua
#include map/2.lua
#include map/3.lua
#include src/debug.lua
#include src/main.lua

-- media assets
__gfx__
00000000333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
aaaaaaaacccccccc1111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000acccccccc1111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000acccccccc1111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000acccccccc1111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000acccccccc1111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000acccccccc1111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000acccccccc1111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
aaaaaaaacccccccc1111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaaaa0555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0000a0555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0000a055555555000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0000a055555555000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0000a0555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaaaa0555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111110ffffffff0888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000010ffffffff0800008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000010ffffffff0800008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000010ffffffff0800008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000010ffffffff0800008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111110ffffffff0888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88882200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccc11000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccc1100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101111101010101010101010101010101010101010101313131313131313131313131313131311212121212121212121212121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010111111101010101010101010101010101010101010101313131313131313131313131313131311212121212121212121212121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0121212121212121212121212121010101010101010101010101010101010101313131313131313131313131313131311212121212010112121212121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101011111010121010101010101010101010101010101010101313131313131313131313131313131311212123131010101011212010112121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101111101010121010101010101010101010101010101010101313131013131313131313131313131311212120131010111010101011212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101011111110101010121010101010101010101010101010101010101313101311131313131313131313131311212120101010101010101010112121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101011101010101010121212121212121010101010101010101010101313131111111313131313131313131311212121201010101010101010112121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101011101010101010101010101010121010101010101010101010101313131011101313131313131313131311212121201010131010101013112121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101111101010101010101010101010121010101010101010101010101313131310121313131310131313131311212121212013112310131311212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010111111101011101010101011101010121010101010101010101010101313131313121313131313131313131311212121212121212123112121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101011101111101010111110101011101010121010101010101010101010101313131313121313131313131313131311212121212121212121212121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111011101111101011111011111111111111121010101010101010101010101313131313121313131313131313131311212121212121212121212121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111011111111111111111111121010101010101010101010101313131313121313131313131313131311212121212121212121212121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111111111111111111121110101111101010101010101313131313121313131313131313131311212121212121212121212121212121212121212121201121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111111111111101111121111111111111010101010101313131313121313131313101313131311212121212121212121212121212121212121212310112121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111111111111111010121010111111111111101010101313131313121313131313131313131311212121212121212121212121212121212121231010101121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111111111111111010101011111111111111111110101313131313121313131313131313131311212121212121212121212121212121212121231010101121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111111111111111111111111111111111111111110101313131313121313131313131313131311212121212121212121212121212121212123101010101121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131313131313131311212121212121212121212121212121212313101011212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131313131313131311212121212121212121212121212121212010101011212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131313131313131311212121212121212121212121212121212120112011212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131313131313131311212121212311212121212121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131313131313131311212010131010101011212121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131313131313131311212121201010101121212121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131313131313131311212121201110101010112121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000310131313121310131313131313131311212120101111101010112121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131313131313131311212120101010101010101121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131313131313131311212121212121201010112011212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131310111313131311212121212011212121212121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121212121011111013131311212121212121212121212121212121212121212121212121212121231011212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131311111113131311212121212121212121212121212121212121212121212121212123101010112120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000313131313121313131313111313131311212121212121212121212121212121212121212121212121212310101010112120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
