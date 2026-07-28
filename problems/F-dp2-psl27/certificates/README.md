# Certificates for Problem F

This directory contains exact and proof-level artifacts for the
2026-07-28 audit and final negative resolution. It receives only artifacts
that meet the resolution standard of `../SPEC.md` ("What a resolution
consists of") plus the supporting scripts of WP-1's audits.

Conventions, inherited from Problems B and E:

- every artifact re-runnable from a fresh clone; no dependence on local
  `tmp/` trees;
- exact arithmetic (number fields represented exactly; no floating point
  in anything load-bearing);
- each certificate paired with a `*.md` note stating exactly what it
  certifies, what it assumes, and the command that checks it;
- negative results (a failed necessary condition, an empty fixed locus,
  an exhausted route) are certificates too, at the same standard.

## Available certificates

- [`WP1_FIXED_LOCI.md`](WP1_FIXED_LOCI.md) and
  [`wp1_fixed_loci.py`](wp1_fixed_loci.py): exact
  \(\mathbf Q(\zeta_7)\) action, exhaustive abelian-subgroup conjugacy
  classification, and fixed-locus/lift audit.  Outcome: Condition (A)
  passes; this is a necessary-condition result, not a resolution of
  Problem F.
- [`WP2_TWIST_OBSTRUCTION_AUDIT.md`](WP2_TWIST_OBSTRUCTION_AUDIT.md):
  projective generic-torsor criterion; effective zero-cycles of degrees
  \(2\) and \(21\) on every twist; index one; and vanishing of the
  equivariant universal-torsor class and every higher Amitsur group.  The
  remaining generic-twist alternatives have degrees \(3\) and \(7\), so
  this closes obstruction routes but does not resolve Problem F.
- [`WP3_COVARIANT_EXCLUSIONS.md`](WP3_COVARIANT_EXCLUSIONS.md) and
  [`wp3_covariant_exclusions.py`](wp3_covariant_exclusions.py): exact
  characteristic-zero exclusion of the complete homogeneous Klein-covariant
  landing spaces in degrees \(9,11,15,18,22\), including reconstruction of
  \(g_9,g_{11}\) and the degree-22 syzygy.  A separately labeled
  \(\mathbf F_{11}\) screen covers all complete spaces through degree 22 but
  is heuristic for characteristic zero.  This delimits one construction
  route; it is not a resolution of Problem F.
- [`klein_covariant_landing_search.py`](klein_covariant_landing_search.py):
  reusable exact Gröbner checker for a requested complete homogeneous
  degree.  It is documented in WP3_COVARIANT_EXCLUSIONS.md and reports
  non-unit patches as open rather than as solutions.
- [`WP3_STRUCTURAL_BOUND.md`](WP3_STRUCTURAL_BOUND.md): a uniform
  exhaustiveness, fixed-line, and Jacobian argument for the homogeneous
  \(V\)-covariant model.  Every hypothetical \(G\)-unirationality map can
  be put in this form.  After primitive common-factor reduction, every
  odd degree is impossible and every even landing degree satisfies
  \(d\ge24\).  Thus all degrees through 23 are excluded; the same
  Jacobian quotient immediately excludes degree 26 because there is no
  degree-2 invariant.
- [WP3_DEGREE24_EXCLUSION.md](WP3_DEGREE24_EXCLUSION.md) and
  [wp3_degree24_jacobian.py](wp3_degree24_jacobian.py): exact exclusion of
  the complete degree-24 space using the forced identity \(J_p=cXh\) and
  two invariant-support coefficients.  Combined with the parity theorem
  and the degree-26 invariant-ring gap, this leaves degree 28.
- [WP3_DEGREE28_EXCLUSION.md](WP3_DEGREE28_EXCLUSION.md) and
  [wp3_degree28_exclusion.py](wp3_degree28_exclusion.py): exact exclusion
  of the complete degree-28 space using \(F\mid J_p/X\), the unique
  impossible square-support coefficient, and a four-branch
  leading-monomial descent.
- [WP3_DEGREE30_EXCLUSION.md](WP3_DEGREE30_EXCLUSION.md) and
  [wp3_degree30_exclusion.py](wp3_degree30_exclusion.py): exact exclusion
  of the complete degree-30 space using reduction modulo \(D\), five
  residue ratios, and unit-ideal certificates for the ratio 48 and two
  quadratic conjugate pairs.
- [WP3_DEGREE32_EXCLUSION.md](WP3_DEGREE32_EXCLUSION.md) and
  [wp3_degree32_landing.py](wp3_degree32_landing.py): exact exclusion of
  degree 32 from three \(F\)-free landing coefficients; the surviving
  branch has a common factor \(F\) and reduces to degree 28.
- [even_quartic_tensor.py](even_quartic_tensor.py),
  [even_quartic_tensor.json](even_quartic_tensor.json), and
  [generate_even_quartic_tensor_cache.py](generate_even_quartic_tensor_cache.py):
  fast exact cache and reproducibility generator for the universal quartic
  pullback on the even covariant sector.
- [WP3_DEGREE34_EXCLUSION.md](WP3_DEGREE34_EXCLUSION.md) and
  [wp3_degree34_exclusion.py](wp3_degree34_exclusion.py): exact exclusion
  of the complete degree-34 space using divisor residue reductions,
  full-rank reconstruction of the Jacobian quotient, and three saturated
  unit-ideal calculations.  At that bounded stage the first surviving
  homogeneous degree was \(36\); the all-degree theorem below supersedes
  that frontier.
- [WP3_ALL_DEGREE_PATH_OBSTRUCTION.md](WP3_ALL_DEGREE_PATH_OBSTRUCTION.md)
  and
  [wp3_all_degree_path_obstruction.py](wp3_all_degree_path_obstruction.py):
  final negative resolution.  The exact checker verifies all involution
  fixed loci, the 21 \(D_8\) quadruple points, the 84 incident \(V_4\)
  flags, the distinct forced endpoint eigenlines, and the squarefree
  central-incident target lines.  The paired note proves that every
  component of the \(V_4\)-stable exceptional path maps constantly,
  contradicting the distinct endpoint values.  Combined with the
  structural odd-degree theorem, this excludes all homogeneous degrees
  and proves that Problem F has a negative answer.
