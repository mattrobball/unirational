# Goal H4 — decide the generic `11:5` twist

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 17  
**Possible headline direction:** negative via `BR-SUBGROUP-NEG`

## Mission

Decide the exact generic twist for the Frobenius subgroup `11:5`. Its genuine Hilbert--90 frame and twisted Klein equation are installed over `C(P^4)^{11:5}`. The five `C11` eigenpoints give a degree-five zero-cycle and the twist has index one, but no rational point or pointlessness theorem is known.

This route offers less dimension reduction than `A4/A5` but has strong solvable-group and cyclic-normal-subgroup structure that may make explicit descent or valuation calculations simpler.

## Work packages

1. Compute a minimal invariant-field presentation adapted to `C11 normal 11:5` and rewrite the exact twist in norm/resolvent coordinates.
2. Use the cyclic degree-11 layer and order-five quotient to analyze rational points, torus torsors, norm equations, and unramified cohomology.
3. Search for valuations whose residue action reduces to a cyclic or diagonal cubic with computable index.
4. Alternatively construct an exact rational point using the degree-five eigenpoint orbit and solvable descent.
5. Verify any point/obstruction on the genuine twist and invoke the subgroup bridge only at the exact boundary.

## Exits

```text
H-11_5-POINTLESS-HEADLINE-NEGATIVE
H-11_5-RATIONAL-POINT
H-11_5-NORM-MODEL-PASS
H-11_5-UNDECIDED
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/H_11_5_TWIST/
```

Provide invariant-field and norm-form models, exact point/valuation payloads, independent verifiers, and `SEAL.json`.