pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

game = {
	map   = {},
	state = {
		map    = 0,
		screen = "title",
	},
}

-- externaize non-media assets
#include src/screen.lua
#include src/screen-battle.lua
#include src/screen-title.lua
#include src/screen-victory.lua
#include src/screen-defeat.lua
#include src/camera.lua
#include src/unit.lua
#include src/units.lua
#include src/cursor.lua
#include src/map.lua
#include src/map/1.lua
#include src/map/2.lua
#include src/map/3.lua
#include src/debug.lua
#include src/main.lua

-- media assets
__gfx__
00000000333333330000000000000000000000008800000000000000aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
00000000333333330000000000000000000000008888000000000000a000000a0000000000000000000000000000000000000000000000000000000000000000
00700700333333330000000000000000000000008888880000000000a000000a0000000000000000000000000000000000000000000000000000000000000000
00077000333333330000000000000000000000008888888800000000a000000a0000000000000000000000000000000000000000000000000000000000000000
00077000333333330000000000000000000000008888882200000000a000000a0000000000000000000000000000000000000000000000000000000000000000
00700700333333330000000000000000000000008888220000000000a000000a0000000000000000000000000000000000000000000000000000000000000000
00000000333333330000000000000000000000008822000000000000a000000a0000000000000000000000000000000000000000000000000000000000000000
00000000333333330000000000000000000000002200000000000000aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc111111110000000000000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc111111110000000000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc111111110000000000000000cccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc111111110000000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc111111110000000000000000cccccc1100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc111111110000000000000000cccc110000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc111111110000000000000000cc11000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc1111111100000000000000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
