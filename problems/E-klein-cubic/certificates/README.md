# Exact certificates for Problem E

These scripts support infrastructure and scoped exclusions.  They do **not**
decide the headline equivariant-unirationality problem.

The dated successful output is recorded in `CHECKS.md`.

This directory is the portable subset published in Git. Newer degree-13/14,
mixed-locus, Pfaffian, and descent reports live in the intentionally ignored
2.4 GB sibling `tmp/` tree; citations to those files elsewhere in Problem E
are local provenance pointers, not dependencies of the commands below.

Run from the problem directory with Python 3 and SymPy/NumPy installed:

```sh
python3 certificates/exact_weil_check.py
python3 certificates/exact_molien.py
python3 certificates/exact_covariants_check.py
python3 certificates/septic_landing_check.py
python3 certificates/generic_covariant_basis_check.py
python3 certificates/generic_frame_lines_check.py
python3 certificates/generic_frame_planes_specialization.py
python3 certificates/generic_frame_planes_check.py 11 14
python3 certificates/flex_cover_check.py
python3 certificates/subgroup_secant_check.py
python3 certificates/subgroup_orbit_check.py
python3 certificates/orbit_hilbert_check.py
python3 certificates/modular_covariant_scan.py
python3 certificates/degree10_m2_check.py
python3 certificates/degree11_m2_check.py
python3 certificates/degree12_msolve_check.py --threads 4 --timeout 120
```

- `exact_weil_check.py` constructs exact generators over
  `Q(zeta_11)`, checks all 660 Cayley-graph identifications with
  `PSL_2(F_11)`, and verifies invariance of the Klein cubic.
- `exact_molien.py` computes the invariant and self-covariant dimensions by an
  exact character average. In degrees 0 through 13 the self-covariant
  dimensions are `0,1,0,0,2,1,2,4,5,6,10,12,16,21`. It also checks the complete
  Hironaka numerators over Adler's parameter ring, the ranks
  `rank_A(R)=12`, `rank_A(M)=60`, and the exact obstruction to freeness of
  `M` over `R`.
- `exact_covariants_check.py` verifies explicit primitive covariants through
  degree 7, exact non-landing witnesses through degree 6, and the nonzero
  determinant witness showing that `(x,C,D,E,K)` is a generic covariant frame.
- `septic_landing_check.py` uses exact rational Groebner bases to exclude every
  degree-7 linear combination.
- `generic_covariant_basis_check.py` proves that the primitive covariants of
  degrees 1, 4, 5, 6, and 7 form a generic frame: their determinant is
  `-295136920` at `(-2,-2,-2,-2,-1)`.
- `generic_frame_lines_check.py` proves, by irreducible reduction over both
  `F_2` and `F_8`, that none of the ten coordinate lines has a
  `C(W)`-rational intersection point with the twisted cubic. It requires
  `M2`.
- `generic_frame_planes_specialization.py` checks exactly that all ten
  three-column frame sections have a smooth specialization, hence are smooth
  geometrically integral plane cubics over the generic invariant field.
- `generic_frame_planes_check.py` constructs the complete invariant-polynomial
  three-column ansatz in each total degree 11 through 14. In all 40 cases,
  good reduction and Macaulay2 prove that the projective landing locus is
  empty. It requires `M2`.
- `flex_cover_check.py` forms the Hessian flex scheme of every generic-frame
  plane, specializes to an exact source line modulo 23, and proves that each
  degree-nine eliminant remains irreducible over `F_(23^3)`. The
  degree-preserving good-reduction argument rules out rational flexes in all
  ten planes without ruling out ordinary points. It requires `M2`;
  `flex_line_scan.py` is its lower-level eliminant constructor.
- `subgroup_secant_check.py` verifies the exact chord geometry of the
  \(C_{11}\) coordinate pentagon and inverse-paired \(C_5\) eigenpoints.
- `subgroup_orbit_check.py` uses the exact 660-element action to check the
  relevant maximal-subgroup character lines and every possible index-two
  block step. Together with the standard maximal-subgroup list, this proves
  that all complex orbits on the cubic have length at least 60 and that the
  natural binary folding chains stop.
- `orbit_hilbert_check.py` reduces the same action at the good prime 331,
  constructs a simple 220-point \(C_3\)-orbit on the cubic, and exactly checks
  its evaluation ranks `[1,5,15,34,65,110,165,220]` through degree 7. This
  excludes containing divisors through degree 4 and leaves a unique quintic,
  ruling out the smallest complete-intersection linkage shortcut.
- `modular_covariant_scan.py` independently excludes all homogeneous
  polynomial self-covariants through degree 9.  It works at the good prime 23,
  directly reduces the cyclotomic matrices from `exact_weil_check.py`,
  constructs complete Reynolds bases, and proves that the projective landing
  locus is empty on every affine chart.  The DVR argument in its module
  docstring transfers the exclusion to characteristic zero.
- `degree10_m2_check.py` reconstructs the complete 10-dimensional Reynolds
  basis and 80 independent sampled necessary landing cubics over `F_23`.
  Macaulay2 proves that their
  affine cone has dimension zero and Hilbert function zero from degree 5, so
  the projective landing locus is empty.  This script requires `M2`.
- `degree11_m2_check.py` similarly reconstructs the complete 12-dimensional
  degree-11 Reynolds basis and 108 independent sampled necessary landing
  cubics. Macaulay2 proves that
  the quotient is Artinian, with Hilbert function zero from degree 5.  The
  script is dynamic, has no dependency on `tmp/`, and requires `M2`.
- `degree12_msolve_check.py` reconstructs the complete 16-dimensional
  degree-12 Reynolds basis and 143 independent sampled necessary landing
  cubics. Exact `msolve` computation, followed by an independent enumeration
  of quotient monomials from the solver's 3840 leading monomials, gives Hilbert
  function `[1,16,136,673,1589,0]`, so the projective landing locus is empty.
  The script has no dependency on `tmp/` and requires `msolve`.

`atlas_lift_check.py` is retained as an independent check of an alternate
ATLAS model over `Z[c]/(c^2+c+3)`; the main modular proof no longer depends on
that model or on an unstated conjugacy with it.

A bounded-degree null search through degree 12 is only a scoped exclusion.  A
rational equivariant map, if it exists, can clear denominators to a polynomial
covariant of an arbitrarily high degree.
