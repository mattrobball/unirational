# Problem A — Expected dimension of rational-curve spaces at the boundary d = n, n+1

> **Resolved (2026-07-22).** Every row in the target table has the expected
> main-component dimension.  The four `d = n` rows were already proved (in
> fact, for every `e`) by Coskun--Starr; the degree-two rows are classical;
> and the remaining `(n,d,e) = (4,5,3)` row follows from a low-degree rank
> stratification.  See [RESOLUTION.md](RESOLUTION.md).  That file also
> explains why the fiberwise-saturation finite-field certificate proposed
> below needs a base-change certificate and is not valid as written.

## Convention

Harris notation throughout this spec: X ⊂ P^{n+1} a hypersurface of degree d,
dim X = n. (Riedl–Yang's P^N, degree ≤ N−2 becomes d ≤ n−1 here.)

## Mathematical statement

For a general X of degree d, Harris's dimension count (notes pp. 25–26)
predicts that the family of degree-e rational curves on X has dimension

    exp(n, d, e) := e(n + 2 − d) + n − 3.

Derivation: rational curves of degree e in P^{n+1} form a family of dimension
(e+1)(n+2) − 4 (coefficient tuples of a parametrization mod scaling and
PGL_2); lying on X imposes ed + 1 conditions.

**Known.** Riedl–Yang (Crelle, arXiv:1409.3802): true — irreducible of
expected dimension — for general X with d ≤ n − 1, all e. The uniform all-e
index-two statement remains open in general ambient dimension, but
Coskun–Starr had already proved the two small exceptional cases used in this
file: `(d,N)=(4,5)` and `(5,6)` in their ambient-space notation, for every e.

**Known failure at d = n+1 (no computer needed).** Degree-e covers of lines
form a closed locus of dimension

    covers(n, d, e) = (2n − 1 − d) + (2e − 2)
                    = dim F_1(X) + (degree-e covers of a fixed P^1 mod source PGL_2).

At d = n+1 this equals n + 2e − 4 > exp = n + e − 3 for all e ≥ 2, so the
literal p. 27 statement is false and the covers locus is a genuine extra
component. The component assertion uses the deformation calculation at a
general line: `N_{L/X} = O^{n-2} + O(-1)`, so after pullback by a degree-e
cover the only global normal deformations come from moving the line. It does
not follow from the dimension inequality alone. (Pleasant check: at d = n
the two numbers agree exactly —
covers = n + 2e − 3 = exp — so index 2 is the borderline.) The live
conjecture therefore concerns the **main components**: components whose
generic member is a map birational onto its image.

**Boundary context.**
- d = n (Fano index 2): the general CHS boundary remains open, but the
  `n=4,5` rows below are the Coskun–Starr exceptional cases and are known for
  every e.
- d = n+1 (index 1): the unrestricted higher-degree main-component problem
  remains open. The degree-two rows below are classical, and the listed
  degree-three row is settled in `RESOLUTION.md`.

## Precise computational objective

For fixed (n, d, e) with d ∈ {n, n+1} and small e, decide with a
characteristic-0 certificate:

> Does every main component of the space of degree-e rational curves on the
> general X_d ⊂ P^{n+1} have dimension exp(n, d, e)?

Each instance is a complete, standalone theorem. There is no need to resolve
"for all e" — accumulate instances outward from the smallest.

## Setup

Parametrized maps: c = (f_0, …, f_{n+1}), each f_i ∈ F_p[s,t] homogeneous of
degree e; M := (e+1)(n+2) coefficients. Equations: F(f_0, …, f_{n+1}) ≡ 0 as
a binary form of degree ed, i.e. **ed + 1 equations, each homogeneous of
degree d in c**. Let M_e(X) ⊂ P^{M−1} be the projectivized vanishing locus.

Dimension bookkeeping (projective maps-space vs curve family):
dim M_e(X) = exp + 3 on main components if the conjecture holds
(+3 = dim PGL_2, −1 scaling already projectivized). Verify this constant on
the calibration instances before trusting any run.

Loci to remove by saturation before reading off dimensions:
1. **Degenerate tuples**: common factor among the f_i (parametrizes
   lower-degree curves, cone over M_{e'} strata). Set-theoretically, its
   ideal is given by the `2e x 2e` maximal minors of the multiplication map
   `S_{e-1}^{n+2} -> S_{2e-1}`, `(g_i) |-> sum g_i f_i`; use this precise
   matrix for saturation, or excise by checking component dimensions.
2. **Covers of lines** (only relevant d = n+1, and exactly the point): the
   condition "image spans a line" is the closed determinantal condition
   rank(coefficient matrix (n+2) × (e+1)) ≤ 2. Saturate M_e(X) by the ideal
   of 3×3 minors of that matrix. What survives is supported on the
   non-line components; its dimension is the quantity conjectured to be
   exp + 3.
   - At d = n: do NOT saturate covers away when testing the
     "equidimensional with two components" refinement — compute both the
     full dimension and the saturated dimension.

## Certificates

**Correction.** The unsaturated proper-incidence certificate below is sound.
The fiberwise-saturated version is not: saturation need not commute with
specialization. See `RESOLUTION.md` for a counterexample and the additional
base-change certificate required for future saturated runs.

- Lower bound: every component of M_e(X) has dim ≥ (M−1) − (ed+1), for every
  X, by Krull. This equals exp + 3 on the nose. Free.
- Upper bound for general complex X: master certificate 2 in the README
  (projectivized incidence over Spec Z, proper projection, closed excess
  locus). Computing dim = exp + 3 for ONE random X over F_p certifies the
  general complex X.
- Caveat: saturating only after specializing `F` is insufficient, even if it
  is done over the same coefficient ring and logged. One must compute the
  universal relative saturation or separately certify saturation/base-change
  compatibility at the chosen fiber.

## Instance table (run in this order)

All dims below are for the projectivized maps space: target = exp(n,d,e) + 3.
Covers column = (2n−1−d) + (2e−2) + 3, the covers-of-lines locus in the same
model; when it exceeds the target, saturation is load-bearing.

Calibration (answers known or classical — pipeline must reproduce them):

| n | d | e | M | eqs (deg) | target dim | covers dim | note |
|---|---|---|---|-----------|------------|------------|------|
| 4 | 3 | 2 | 18 | 7 (3) | 7 + 3 = 10 | 6 + 3 = 9 | conics on cubic fourfolds; d ≤ n−1, Riedl–Yang known |
| 5 | 4 | 2 | 21 | 9 (4) | 8 + 3 = 11 | 8 + 3 = 11* | quartics in P^6, d = n−1, known (*coincidental tie, harmless) |
| 3 | 4 | 2 | 15 | 9 (4) | 2 + 3 = 5 | 3 + 3 = 6 | conics on quartic threefolds, classical; exercises the saturation step |

Originally proposed targets (all now resolved; see `RESOLUTION.md`):

| n | d | e | M | eqs (deg) | target dim | covers dim | regime |
|---|---|---|---|-----------|------------|------------|--------|
| 4 | 4 | 2 | 18 | 9 (4) | 5 + 3 = 8 | 5 + 3 = 8 | d = n: quartic fourfolds in P^5; two components of equal dim expected |
| 4 | 4 | 3 | 24 | 13 (4) | 7 + 3 = 10 | 7 + 3 = 10 | d = n |
| 5 | 5 | 2 | 21 | 11 (5) | 6 + 3 = 9 | 6 + 3 = 9 | d = n: quintics in P^6 |
| 5 | 5 | 3 | 28 | 16 (5) | 8 + 3 = 11 | 8 + 3 = 11 | d = n |
| 4 | 5 | 2 | 18 | 11 (5) | 3 + 3 = 6 | 4 + 3 = 7 | d = n+1: quintic fourfolds; saturation essential |
| 4 | 5 | 3 | 24 | 16 (5) | 4 + 3 = 7 | 6 + 3 = 9 | d = n+1 |
| 5 | 6 | 2 | 21 | 13 (6) | 4 + 3 = 7 | 5 + 3 = 8 | d = n+1: sextic fivefolds |

Note the clean pattern: at d = n the covers locus ties the main component
exactly (the "equidimensional, two components" refinement is the claim being
tested); at d = n+1 covers strictly dominate and the saturated dimension is
the conjecture.

Check the literature per instance before extending this table. The original
target list missed Coskun–Starr's exceptional-case theorem and the standard
low-degree incidence results.

## Method notes

- Reduce PGL_2 symmetry to shrink the Grobner problem: either quotient
  implicitly (accept +3 in all dimensions, simplest, recommended first) or
  slice by 3 random linear conditions on c and expect dim exp + 0…
  document whichever is used; slicing must be by *generic* hyperplanes and
  the slice count folded into the certificate.
- Dimension screening by random linear sections + msolve (README); confirm
  with M2 `dim` on the saturated ideal.
- Randomness: draw X sparse-random first (fast), then dense-random for the
  certified run. If sparse and dense disagree, dense wins (sparse X may be
  special).
- Two primes minimum for any row entering the log as a theorem; then one
  exact run over Q on a small-height lift for rows worth publishing.
- Estimated cost: rows with M ≤ 21 are minutes-to-hours (msolve, F4);
  M = 24–28 rows may need days and careful monomial orders; do them last.

## Outcomes and escalation

- **dim = expected (anticipated for future rows):** after repairing the
  saturation/base-change issue, log as a certified instance of the
  main-component conjecture at the open boundary.
- **dim > expected on a saturated (non-cover) component:** treat as a
  candidate counterexample to CHS at the boundary. Protocol: rerun second
  prime → identify the excess component (primary decomposition or targeted
  saturations) → geometric interpretation (is it another multiple-cover /
  reducible-image stratum not removed by the line-saturation? e ≥ 4 covers
  of conics, etc. — compute covers-of-conics dimensions before crying
  wolf) → exact lift over Q. Only then is it a counterexample for general X.
- Failure mode to watch: a horizontal non-cover component can specialize
  entirely into the covers locus and disappear under fiberwise saturation.
  An independent covers-dimension computation does not repair this; certify
  universal saturation or base change as described above.

## References

- Harris notes pp. 25–28 (the count, the Open Problem, the Outcomes table).
- E. Riedl, D. Yang, *Kontsevich spaces of rational curves on Fano
  hypersurfaces*, https://arxiv.org/abs/1409.3802
- I. Coskun, J. Starr, *Rational curves on smooth cubic hypersurfaces*,
  Theorem 1.6 and its exceptional cases,
  https://homepages.math.uic.edu/~coskun/revcubic.pdf
- K. Furukawa, *Dimension of the space of conics on a Fano hypersurface*,
  Theorem 1.1, https://arxiv.org/abs/1702.08890
- D. Tseng, *A note on rational curves on general Fano hypersurfaces*,
  https://arxiv.org/abs/1709.09740. The displayed radical in Theorem 1.2 has
  a typo; the proof gives `sqrt(2N^2-2N-15)`, consistent with the abstract.
- Harris–Roth–Starr, *Rational curves on hypersurfaces of low degree* (method
  background).
