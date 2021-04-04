## SFX ##
| name            | effect | offset | length |
|-----------------|--------|--------|--------|
| banner defeat   |        |        |        |
| banner victory  |        |        |        |
| cursor cancel   |        |        |        |
| cursor move     |        |        |        |
| cursor select   |        |        |        |
| menu cancel     |        |        |        |
| menu confirm    |        |        |        |
| menu power down | 0      | 8      | 8      |
| menu power up   | 0      | 0      | 8      |
| talk a          |        |        |        |
| talk b          |        |        |        |
| turn end        |        |        |        |
| unit explode    |        |        |        |
| unit move       |        |        |        |
| unit repair     |        |        |        |
| unit shoot      |        |        |        |

Play sound-effects on channel `-1`:
```
sfx(x, -1, x, x)
```
