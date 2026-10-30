# Shared domain vectors

Each JSON file is an array of named cases. A case has an `input` (or named input
fields) and an `expected` result. Numeric values are integers in the units
stated by the field name: EXP, meters, milliseconds, millimeters, and permil.
The Go port should load the same vectors and the same `prisma/game-config.v1.json`
rules, then compare every output field exactly.

`exp.json` includes the nine mandatory examples from README section 3.4, followed
by trial-run and Safe Stop cases from sections 3.7–3.8. `anti-cheat.json`
supplies policy thresholds explicitly; its sample-gap and count limits are
test inputs, not additional game defaults.
`rp.json` verifies the README rule that RP equals the run's protected basis.
