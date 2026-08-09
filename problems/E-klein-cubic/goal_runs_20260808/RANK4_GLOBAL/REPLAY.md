# Replay

From `problems/E-klein-cubic` run:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/RANK4_GLOBAL/verify.py
/opt/homebrew/bin/python3 goal_runs_20260808/RANK4_GLOBAL/verify_kummer_newton.py
/opt/homebrew/bin/python3 goal_runs_20260808/RANK4_GLOBAL/verify_fine_interior_audit.py
/opt/homebrew/bin/python3 goal_runs_20260808/RANK4_GLOBAL/verify_rank3_klein_cover.py
```

The main Kummer replay first reconstructs the four distinct cyclic
eigenlines over `F_11`, hence the three and only three invariant two-planes
through `<mu>`.  It then checks the complete normalized residue-normal box
for those fixed planes.  The respective minimum coordinate sums are
`6,8,8`, so the barycenter satisfies every Fine inequality strictly.  It
also reconstructs the sparse triple-incidence directions and their exact
integral `2+sigma` and norm-cube lifts.

The independent Fine-interior replay separately checks connectedness data,
the two former level-one exceptional planes, and exact rational witnesses.
The last replay verifies the Smith lattice and identifies the sole surviving
rank-three cover with the Klein cubic torus.

No script enumerates Laurent supports, degrees, exponents, or numbers of
prime orbits.

Expected final markers:

```text
RANK4-GLOBAL-CONTRACTED-DIVISOR-THEOREM-OK
RANK4-GLOBAL-KUMMER-FINE-INTERIOR-THEOREM-OK
RANK4-FINE-INTERIOR-UPGRADE-AUDIT-OK
RANK3-KLEIN-COVER-BOUNDARY-OK
```
