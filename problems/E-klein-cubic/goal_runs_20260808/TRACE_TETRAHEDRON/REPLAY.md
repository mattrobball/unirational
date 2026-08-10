# Replay

From `/Users/worker/unirational/problems/E-klein-cubic` run:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_TETRAHEDRON/verify_escape.py
```

Expected final data include:

```text
FOUR_TERM_BASE_CONTRIBUTIONS 40
FOUR_TERM_TRACE_CONTRIBUTIONS 200
PARALLELOGRAM_COLLISION_ROW_RANK 1
DELETION_BRIDGES 4
BRIDGE_COEFFICIENTS [(-24, 24), (-36, 36)]
BRIDGE_CLASS 1 -36 [(0, 3, 1, -24), (1, 2, 1, 24), (2, 3, 0, -36)]
BRIDGE_CLASS 2 -24 [(0, 1, 3, -24), (0, 3, 2, -36), (1, 2, 2, 36)]
NONZERO_TRACE_CLASSES 106
SURVIVING_CLASS_COEFFICIENT 18
SURVIVING_CLASS_CONTRIBUTORS [(2, 2, 1, 3, 18)]
FOUR-TERM-DELETION-POLARIZATION-ESCAPE-NOT-SOLUTION-OK
```

The replay performs one exact Laurent expansion only.  It does not enumerate
supports, exponent boxes, collision rowspaces, or coefficient systems.

For the fixed-point/tangent reduction, run:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_TETRAHEDRON/verify_fixed_point_tangent.py
```

Its final marker is:

```text
F55-TRACE-FOUR-TERM-FIXED-POINT-TANGENT-REDUCTION-OK
```

For the higher-jet norm-fibre reduction, run:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_TETRAHEDRON/verify_higher_jet_reduction.py
```

Expected marker:

```text
F55-TRACE-FOUR-TERM-TETRAHEDRAL-NORM-FIBRE-REDUCTION-OK
```

For the affine-rank-three exclusion, run:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_TETRAHEDRON/verify_tetrahedral_exclusion.py
```

Expected final marker:

```text
F55-TRACE-FOUR-TERM-AFFINE-RANK-THREE-EXCLUSION-OK
```

For the planar circuit reduction, run:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_TETRAHEDRON/verify_planar_circuit_reduction.py
```

Expected final marker:

```text
F55-TRACE-FOUR-TERM-PLANAR-CIRCUIT-REDUCTION-OK
```

For the universal rational rank-two landing exclusion, including the four
cyclic-factor evaluations, the Galois support permutations, and all four
spectral coefficients, run:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_TETRAHEDRON/verify_rank2_quadratic_exclusion.py
```

Expected final data include:

```text
RANK2_CYCLIC_COEFFICIENT_EQUATIONS 80
RANK2_CYCLIC_EXACT_EVALUATIONS 4
GALOIS_TAU_WEIGHT_ORBIT [1, 2, 3, 4]
GALOIS_TAU2_SUPPORT_PAIRS [(1, 4), (2, 3)]
SPECTRAL_RANK2_ROW (3, 2, 1, 0) 5*a**3*c**2*d*(z**3 - z**2 - z - 1)
SPECTRAL_RANK2_ROW (2, 0, 3, 1) -5*a**2*b*d**3*(2*z**3 + z**2 + 2*z + 2)
SPECTRAL_RANK2_ROW (1, 3, 0, 2) 5*a*b**2*c**3*z*(z**2 + 2)
SPECTRAL_RANK2_ROW (0, 1, 2, 3) 5*b**3*c*d**2*z*(2*z + 1)
SPECTRAL_RANK2_NONZERO_ROWS 4
F55-TRACE-RATIONAL-RANK2-QUADRATIC-LANDING-EXCLUSION-OK
```

To replay every verifier in this packet and check every expected marker, run:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_TETRAHEDRON/verify_all.py
```

Its final marker is:

```text
F55-TRACE-FOUR-TERM-ALL-EXPONENT-EXCLUSION-REPLAY-OK
```

All calculations are exact.  The packet performs no exponent-box or
collision-hyperplane enumeration.  The 80 equations above are the
coefficients of one analytically forced four-parameter cyclic-factor normal
form; the proof itself uses only four specializations of that form.
