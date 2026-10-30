# Kila Rive asset contract

The approved character Rive file can be added as `kila.riv` in this directory.
It must contain a `KilaMachine` state machine with a numeric `mood` input:

| Value | State |
| --- | --- |
| 0 | idle |
| 1 | cheer |
| 2 | warn |
| 3 | think |
| 4 | level-up |
| 5 | rest |
| 6 | celebrate-streak |
| 7 | sad-soft |

The Flutter widget detects the asset and drives that input. Until the authored
Rive asset is supplied, it renders its accessible Flutter-drawn Kila fallback.
