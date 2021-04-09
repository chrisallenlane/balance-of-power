## SFX ##
| name             | effect | offset | length |
|------------------|--------|--------|--------|
| banner defeat    |        |        |        |
| banner victory   |        |        |        |
| cursor move      | 2      |        |        |
| menu cancel      |        |        |        |
| menu confirm     |        |        |        |
| menu power down  | 0      | 5      | 4      |
| menu power up    | 0      | 0      | 4      |
| menu select down |        |        |        |
| menu select up   |        |        |        |
| talk             | 1      | 0      |        |
| turn end         |        |        |        |
| unit explode     | 4      |        |        |
| unit move        |        |        |        |
| unit repair      |        |        |        |
| unit select      |        |        |        |
| unit shoot       | 3      |        |        |
| unit unselect    |        |        |        |

Play sound-effects on channel `-1`:
```
sfx(x, -1, x, x)
```
