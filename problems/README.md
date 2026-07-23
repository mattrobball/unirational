# Problems: CAS hunts around Harris's Seattle questions

Four computational problems extracted from the open questions in Joe Harris,
*Rationality, Unirationality and Rational Connectivity* (Seattle AG institute
lecture notes), selected and ranked for amenability to computer-algebra
example/counterexample hunting. Ordered by expected theorem-yield per CPU-hour:

| ID | Problem | Source question | Expected outcome |
|----|---------|-----------------|------------------|
| [A](A-expected-dimension-curves/SPEC.md) | Expected dimension of spaces of degree-e rational curves on general hypersurfaces, at the open boundary d = n, n+1 | Notes p. 27 "Open problem" (Coskun–Harris–Starr conjecture) | Steady stream of small rigorous theorems; each instance fully decidable |
| [B](B-conic-bundle-multisections/SPEC.md) | Rational multisections on every smooth bidegree-(2,3) hypersurface in P^2 x P^2 (unirationality of conic bundles) | Notes pp. 23–24, Question on the third variety + refinement 11b | Resolved: tangent residuals give a horizontal rational surface of even degree at most 20 |
| [C](C-lines-debarre-de-jong/SPEC.md) | Counterexample sweep for the Debarre–de Jong conjecture at degree 9 | Notes p. 27, "Question (de Jong)" | Likely null result (conjecture believed); a hit = full refutation, major |
| [D](D-2d-conic-bundles/SPEC.md) | Unirationality of general (2,d) hypersurfaces, d ≥ 4; primary target d = 4 via the tangent-residual double cover | Notes pp. 23–24 ("d large"), continuation of B | Tangent, bitangent, and flex routes are general type; D4 classes (1,0) and (1,1) are excluded, with a two-profile primitive class-(1,2) frontier; headline open |

## Shared conventions

**Ambient notation.** The notes use `X ⊂ P^{n+1}` a hypersurface of degree d
(so dim X = n). Much of the literature (Debarre–de Jong, Riedl–Yang) uses
`X ⊂ P^N` of degree d (so dim X = N−1, i.e. N = n+1). Each spec states which
convention it uses; do not mix them.

**Base fields.** All searches run over F_p for a machine-word prime, default
p = 32003 (msolve/Macaulay2-friendly); use p = 101 for quick smoke tests and
at least two distinct primes (e.g. 32003, 65537 or a ~30-bit prime) before
believing any interesting result. Final certification of any characteristic-0
claim re-runs the computation over Q on an integer lift (see certificates).

**Tooling.** Macaulay2 (primary: ideals, saturation, `dim`, sheaf cohomology,
multigraded support via `NormalToricVarieties`/Cox rings), msolve (fast F4/FGLM
for dimension screening and 0-dimensional solving), Magma if a license is
available (point search, `MinimalBasis`, fast Grobner in mid-size systems).
Keep every run scripted and logged: one `.m2`/input file + one log per
(instance, prime, seed), committed alongside the spec.

## The three master certificates

These are what turn F_p computations into characteristic-0 theorems, and they
are the backbone of all four specs.

1. **Krull lower bound (free).** A subscheme of P^{M} (or A^M) cut by c
   equations has every component of dimension ≥ M − c. So "actual dim ≥
   expected dim" never needs a computer; only the upper bound does.

2. **Semicontinuity upper bound (one F_p point certifies the general
   member).** Set up the *projectivized* incidence
   I = {(object, F)} ⊂ P^{M-1} × P(coefficients of F), defined over Spec Z.
   The projection to P(coeffs) is proper, so
   E_k = {F : dim fiber ≥ k} has *closed* image. If one explicit F_0 over F_p
   has fiber dimension = expected, then E_{expected+1} misses F_0, hence its
   closed image is a proper subset, hence it misses the characteristic-0
   generic point: **the general complex F has fiber dimension ≤ expected**,
   and by (1) exactly expected. One Grobner run = one theorem about the
   general hypersurface. (Properness matters: always work with the
   homogeneous ideal / projective fiber dimension, never a raw affine chart
   alone.)

3. **Asymmetry of the hunt direction.** The same closedness means an *excess*
   dimension found over F_p does NOT automatically lift: excess is a closed
   condition and may hold only mod p. An F_p excess example is a candidate
   *shape*; certification of a characteristic-0 counterexample requires
   re-running the dimension computation over Q on a lift (or over infinitely
   many p with a spreading-out argument). Budget for the exact-arithmetic
   rerun in any hit protocol.

Auxiliary cheap certificate used in B: **rank semicontinuity** — the linear
conditions "F contains the subvariety S" have codimension = rank of an
evaluation matrix; rank at a random F_p point lower-bounds the generic rank.
Use it as a fast screen; promote conclusions to full incidence-dimension runs
before calling them theorems (rank can drop on positive-dimensional strata).

**Practical dimension screening.** Full `dim I` Grobner runs are the
bottleneck. Screen first by random linear slicing: dim ≥ k iff the
intersection with a random codimension-k linear space is nonempty
(0-dimensional solving, msolve is fast at this); confirm claimed dimensions
with an honest Grobner/`dim` run before logging them as results.

## Status board

| Problem | Stage | Last update |
|---------|-------|-------------|
| A | CLOSED — all target rows settled (Coskun–Starr + new deg-2/3 proofs); fiberwise-saturation certificate found invalid, see RESOLUTION.md | 2026-07-22 |
| B | CLOSED affirmatively for every smooth member — tangent residuals give a horizontal rational surface and a parametrization of even degree at most 20 | 2026-07-22 |
| C | Field-free statement REFUTED (char-2 Fermat, dim 12 vs 6); char-0 case open, reduced to N=9 singular line-rich sixfolds + LT remainder cases | 2026-07-22 |
| D | D1/D2 CLOSED; D3 tangent limits, uniform special-seed dualizing positivity, smooth ramification comparison, generic two-point separation, quartic middle/bottom multiplier-boundary folds, bitangent, and flex complete; D4 k=0 and k=1 excluded, k=2 reduced to two primitive squarefree profiles with the entire proper-high seven-distinct-singleton [3,2^7] row, the base-point-free square-factor locus, isolated-base rows e=2,3,4, and the connected e=5 row closed, leaving isolated e=1 and nonproper-high, repeated-tree, isolated-base, and other cluster strata. Open-residual local singularities, other covariants, k>=2, and headline remain open | 2026-07-23 |

## Provenance

Question numbering (#3, #11, #13, #14, #15 …) refers to the synthesized list
extracted from the Harris notes (harris1.pdf, 30 pp.); the ranking rationale
(certificate principle, status verification as of July 2026) is recorded in
the session that produced these specs. Key status facts used:

- Debarre–de Jong proven for d ≤ 8 (Beheshti) and for N ≥ 2d−4
  (Beheshti–Riedl); open exactly at d = 9, N ∈ {9,…,13}.
- Riedl–Yang: spaces of rational curves on general X_d ⊂ P^N irreducible of
  expected dimension for d ≤ N−2; boundary d = N−1, N open (modulo low-e
  partial results), with the covers-of-lines component making the literal
  statement fail at d = N (index 1).
- Unirationality open for: general quintic fourfold, sextic double solid,
  general (2,d) conic bundles in P^2 x P^2 for d ≥ 4.
- Very general quartic fourfolds not stably rational (Totaro; Schreieder);
  existence of any smooth rational hypersurface of degree ≥ 4 open.
