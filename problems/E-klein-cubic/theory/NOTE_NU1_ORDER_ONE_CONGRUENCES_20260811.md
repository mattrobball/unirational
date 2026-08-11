# Note — the ν = 1 fiber lane: order-one congruences of lines in P⁴

Opened 2026-08-11 (director; literature sweep executed by a search agent,
citations verified as marked). Status: SURVEY + two derivation-level
exclusions; not a sealed theorem. **Problem E remains OPEN; nothing here
excludes a degree.**

Context. If a dominant landing map has generic fiber degree `ν = 1`, its
fibers form a `G`-invariant first-order congruence of lines in `P⁴` (one
line through a general point) whose base 3-fold is `G`-birational to `X`.
Excluding that configuration kills the whole `ν = 1` class at every degree
`d` — a fiber-side, degree-independent exclusion lane (companion to C14's
trichotomy; the `ν = 2` analogue is the conic-bundle branch of C11/C14).

## The classification (De Poi program)

- P. De Poi, "On first order congruences of lines of P⁴ with a fundamental
  curve", Manuscripta Math. 106 (2001) 101–116.
- P. De Poi, "Congruences of lines with one-dimensional focal locus",
  Port. Math. 61 (2004) 329–338. [read]
- P. De Poi, "First order congruences of lines of P⁴ with irreducible
  fundamental surface", arXiv:math/0407340. [read]
- P. De Poi, "…with generically non-reduced fundamental surface",
  Asian J. Math., arXiv:math/0407341. [read in part]
- De Poi–Mezzetti, "On congruences of linear spaces of order one", Rend.
  Istit. Mat. Univ. Trieste 39 (2007). [NOT independently read]
- C. Peskine, "Order 1 congruences of lines with smooth fundamental
  scheme", arXiv:1601.03951. [read]
- Classical: Kummer 1866; Ascione 1897; Severi 1901; Marletta 1909, 1927;
  Z. Ran, Crelle 368 (1986) for P³. [secondhand only]

Structure for `P⁴`, order one (De Poi 2004 Thm 0.1 with math/0407340-41):
the fundamental locus has dimension 0 (base `≅ P³`) or 2 — a pure
fundamental *curve* is impossible in `P⁴`. In the dimension-2 branch:

1. fundamental surface reduced irreducible — COMPLETE classification:
   projected Veronese, projected del Pezzo, projected scroll, Bordiga;
   base bidegrees `(1,2), (1,5), (1,8), (1,8)`;
2. curve+surface configurations — base birational to a PRODUCT `C × S`
   (stated in math/0407340);
3. fundamental surface non-reduced / reducible — classified ONLY under the
   hypothesis that the components of the reduction are smooth
   (math/0407341, completing Marletta). **The singular-reduction case is a
   literature-acknowledged gap.**

## What this gives the ν = 1 lane

- Veronese case: the base is the quintic del Pezzo threefold `V₅` (Fano,
  index 2, degree 5 — identification OURS from the paper's invariants plus
  the Fano classification, not a verbatim paper statement), which is
  rational; a rational base is never birational to `X` (Clemens–Griffiths).
- Product case: `J(C × S-resolution)` is built from `Jac C` and
  `Alb/Pic⁰ S`-type factors; `J(X)` is indecomposable and not such a sum
  (Clemens–Griffiths). A product base is never birational to `X`.
  (Derivation OURS, elementary.)
- Remaining classified types (del Pezzo / scroll / Bordiga projections):
  built from rational fundamental surfaces; no source pins the base's
  birational type, and no case is a cubic threefold in anything read —
  "no evidence, not rigorously excluded by citation".

**Verdict: (b).** In every case where the classification pins the base, the
base is not birational to a cubic threefold; but the singular-reduction gap
(case 3) means "ν = 1 impossible" is NOT yet a theorem quotable from the
literature alone.

## The route to sealing it, if this lane is ever load-bearing

Our configuration is `G = PSL(2,11)`-invariant — leverage the literature
never uses. The congruence is a `G`-stable 3-fold in `G(1,4) ⊂ P⁹`
(`Λ²W = 10`-dim, irreducible as a `G`-module), its fundamental surface is a
`G`-stable surface in `P⁴` supported on the arrangement strata, and in the
gap case its singular reduction would have to be one of the (finitely many,
mostly classified) invariant surfaces. A short equivariant argument closing
case 3 for `G`-invariant congruences would seal: **no dominant landing map
has ν = 1, at any degree.** Queue-priority: low until some window forces
small `ν` (C2's `g₂² ≥ 3dν` is the natural trigger).

## Not claimed

- No degree and no `ν`-class is excluded here; the gap case is open.
- The `V₅` identification and the product exclusion are derivations on top
  of read sources, flagged as such above.
