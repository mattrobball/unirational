# BOUNDARY_STABLE_MAPS — Goal Q3.3

The positive bridge accepts reducible stable maps.  Boundary types of degree
three were exhausted theoretically and probed modularly on the split Klein
cubic.

## Type ledger

| Type | K_Schur object |
|---|---|
| line + conic | False |
| three lines | False |
| double line + line | False (excluded by no K-line) |
| nonreduced GTC | False |
| embedded-point boundary | False |

## Galois constraints

- Under pure `C3` action on the resolvent triple, no Gal-stable pair of marks
  exists, so a line through exactly two marks cannot be `K`-rational.
- Collinear resolvent triples would give a `K`-line section residual; universal
  collinearity is false, and modular scans on the split Klein cubic find
  collinear residuals only rarely (see `boundary.json` modular_scan).
- A double line over `K_Schur` is excluded by the absence of `K_Schur`-lines on
  the authoritative twist.

## Modular scan scope

modular discovery only — not char-0 reconstruction; does not install the Schur quartic

## Conclusion

`boundary_reduction_pass = False`.  
Residual: Need either a K_Schur-defined reducible stable cubic through the installed resolvent triple, or a new identity forcing one of the boundary types to descend.

Marker `Q3-BOUNDARY-REDUCTION-PASS` **not** achieved.
