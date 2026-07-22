# Problem D — Unirationality of general (2,d) hypersurfaces in P^2 x P^2, d >= 4

## Provenance and relation to Problem B

Problem B resolved the case d = 3 affirmatively (tangent residuals; see
`../B-conic-bundle-multisections/RESOLUTION.md` and the PDF notes).  This
problem is the continuation to Harris's actual question (notes pp. 23-24:
"bidegree (2,d), d large") armed with what B taught.  Everything below is
stated over C.

## Problem statement

Let X ⊂ P^2_x × P^2_y be a general hypersurface of bidegree (2,d), d >= 4:
a standard conic bundle over P^2_y with smooth discriminant of degree
3d >= 12, and simultaneously a fibration ρ: X → P^2_x in plane curves C_x
of degree d and genus (d-1)(d-2)/2.  Known: X is rationally connected, not
rational (Prym criterion, disc degree >= 6), and for very general X not
stably rational (Böhning–Graf von Bothmer, all d >= 2).  Unirationality is
open for every d >= 4, with the published expectation negative for d large
(Prokhorov §14.3) — an expectation that just failed at d = 3.

> **Problem D.**  Decide unirationality of the general (2,d) hypersurface.
> **Primary target: d = 4** (discriminant degree 12; fibers of ρ are plane
> quartics — canonical genus-3 curves).  Specifically: decide whether the
> tangent-residual double cover Z → S defined below is rational; its
> rationality implies that the general (2,4) hypersurface is unirational.

## What transfers from d = 3 unchanged

1. **The engine, strengthened.**  If W is ANY rational surface with a map
   φ: W → X having two-dimensional image and π∘φ dominant onto P^2_y, then
   X ×_{P^2_y} W → W is a conic bundle over a rational surface with the
   tautological section w ↦ (φ(w), w), hence birational to W × P^1, and X
   is unirational.  (Only the SOURCE need be rational — the image surface
   T = φ(W) need not be normal, smooth, or otherwise nice.)
2. **The free supply of rational surfaces.**  For every rational curve
   B ⊂ P^2_y, the vertical surface π^{-1}(B) is a conic bundle over a
   rational curve, hence rational by Tsen.  Verticality makes them useless
   directly; the entire game is converting them to horizontal ones through
   the second fibration ρ.
3. **Pic, parity, adjunction.**  Pic(X) = Z H_x ⊕ Z H_y,
   K_X = O_X(-1, d-3); horizontal divisors have even base-degree 2a; every
   smooth member of every horizontal system has effective-or-trivial
   canonical class, hence is irrational: any rational multisection is a
   singular member, with adjoint defect growing with d.
4. **The covariant identity (theorem for all d; symbolic confirmation per
   d is certificate work only).**  With L = {W=0}, f = g + Wh + ... (g
   binary of degree d, h of degree d-1) and P = U g_u + V g_v + W h,

       Res_{u,v}(g, P) + Δ(g) f = W^2 q_f,

   with q_f of degree d-2 in (U,V,W) and coefficients of degree 2d-1 in
   the coefficients of f.  Proof sketch (audit 2026-07-22): the W^0 term
   is a product of d linear forms each vanishing (Euler) at a root of g,
   hence a covariant multiple c(g)·g(U,V); c(g) vanishes whenever g has a
   double root (that root's factor is identically zero), so Δ | c, and
   deg c = 2d-2 = deg Δ forces c = const·Δ; the constant is -1 at d = 2
   (verified by hand) and d = 3 (verified symbolically).  The W^1
   comparison is an equality of two binary forms of degree d-1 agreeing at
   the d distinct roots of g — exactly enough points, since a nonzero
   degree-(d-1) form has at most d-1 roots; the case Δ(g) = 0 follows by
   density.  All degree checks match: d = 3 recovers the verified
   (degree-5, linear) case.  Globally
   q has bidegree (4d-2, d-2) and

       div_X(Res) = 2S + T,   T ~ (4d-2) H_x + (d-2) H_y,

   where S = X ∩ (P^2 × L) and T is the residual divisor: over general x
   its fiber is the degree-d(d-2) residual scheme ΣR_i cut on C_x by the
   covariant curve {q = 0}, since Σ(2p_i + R_i) ~ dH and Σp_i ~ H give
   ΣR_i ~ (d-2)H, and O_{P^2}(d-2) → O_{C_x}(d-2) is surjective.

## What breaks at d >= 4, precisely

The tangent line at a marked point p ∈ C_x ∩ L now meets C_x in
2p + R with deg R = d - 2 >= 2: the residual is a CORRESPONDENCE, not a
map.  Concretely there is an incidence

    Z = closure{(x, p, r) : p ∈ C_x ∩ L smooth, r ∈ T_pC_x · C_x − 2p}

with Z → S of degree d-2 and Z → X (by (x,p,r) ↦ (x,r)) landing in T.
For d = 3, Z = S and rationality was free; for d >= 4, Z is a degree-(d-2)
cover of the rational surface S and NOTHING guarantees its rationality —
this is the entire difficulty, and the reason genus-1 fibers were special
(group law = single-valued residual).  By item 1 above:

> **Z rational ⟹ X unirational.**  More generally any rational
> multisection W of Z → S, or any other covariant correspondence with
> rational total space, suffices.

## Task list

**D1 (certificate infrastructure).**  Verify the universal identity for
d = 4 symbolically (extension of
`../B-conic-bundle-multisections/certificates/tangent_residual_local_checks.py`;
the universal ring has 15 f-coefficients), including primitivity of the
SIX coefficients of the quadric q_f, pin the sign constant, and write up
the all-d proof sketched above.  Derive the divisor identity and the class
of T for d = 4: T ~ 14 H_x + 2 H_y, base-degree 28.  Also certify
q|_S ≢ 0 and distinctness of the 8 = d(d-2) residual points at a witness
(needed for T reduced with no junk, as in B).

**D2 (the decisive computation, d = 4).**  Z → S is a DOUBLE cover: on
the tangent line at p, the residual is a binary quadratic; its
discriminant cuts the branch curve B_Z ⊂ S (geometrically: p such that
T_pC_x is bitangent or inflectional elsewhere).  Compute:
  (a) the class of B_Z in Pic(S) and its singularities for general X
      (S is a smooth rational conic-bundle surface; use the (t,m) chord
      coordinates of the B external check, which need a Q-point only for
      writing maps over Q, not over C);
  (b) irreducibility of Z (nonempty branch suffices for a double cover)
      and q, p_g, P_2 of its normalization by the corrected double-cover
      calculus of B (D_4 caveat and unloaded cluster ideals apply
      verbatim);
  (c) verdict: if Castelnuovo passes, produce the unirationality theorem
      for (2,4) with the full witness/properness certificate apparatus of
      B; if it fails, record the invariants — they quantify exactly how
      far this covariant misses.

  **Expected outcome (audit 2026-07-22): negative.**  On the tangent line
  at a marked point the residual quadratic has coefficients of x-degrees
  (6, 8, 10), so the branch curve B_Z meets each conic fiber of S → L in
  ~32 points (raw count, before the small degenerate corrections), giving
  (K_S + B_Z/2)·fiber ≈ -2 + 16 = 14 > 0: the fibers of Z → L have genus
  ~15 and K_Z is strongly positive along them.  Not a proof (rational
  surfaces carry high-genus fibrations, and B_Z could be very singular),
  but the honest prior is that Z_4 is of general type.  D2 is therefore
  framed as certifying the invariants, with a rational Z_4 counting as a
  major upset.  Note the structural lesson: d = 3 did not merely use
  genus-1 fibers, it avoided this branch-positivity tax entirely by
  having no cover at all (single-valued residual).  Formalizing the tax —
  Kodaira dimension of covariant correspondence surfaces as a function of
  d and the covariant's numerics — is the "limits of the method" theorem
  of D3 and is worth having in its own right.

**D3 (the covariant zoo, if D2 is negative).**  The construction space is
much larger than one correspondence:
  - marked divisors from richer vertical seeds: π^{-1}(conic) is also
    rational and marks C_x in 2d points; π^{-1}(rational curve of degree
    e) marks de points;
  - other covariants of plane quartics: bitangent incidences (28 = odd
    theta characteristics; the bitangent-residual correspondence), conics
    through subsets of marked points, adjoint/osculating constructions,
    the Hessian marking (inflection multisection of degree 3d(d-2));
  - compositions: iterate correspondences (tangent-of-residual, etc.), in
    the spirit of Bogomolov–Tschinkel's tangent-correspondence
    propagation on elliptic fibrations;
  - for each candidate: the SAME three-step audit — total-space invariants
    (rationality of the correspondence surface), else rational
    multisections of it, else next candidate.  Log every negative with its
    invariants: a structured no-go pattern across the zoo would be the
    first quantitative evidence FOR the large-d negative expectation, and
    a "limits of the method" theorem (Kodaira dimension of covariant
    surfaces as d grows) is publishable independent of the main question.

**D4 (exclusion frontier — with a large inherited head start).**  Members
of |H_x + kH_y| are double planes with branch of degree 2k + 2d = 2k + 8.
Decisive observation: the k = 0 case (class (1,0), the minimal
multisections ρ^{-1}(line-condition)) is branched along OCTICS — the same
numerics as Problem B's class-(1,1) frontier, whose entire BRANCH-SIDE
classification (the corrected-multiplicity rationality table for double
octic planes, cluster systems, the finite Enriques-diagram frontier and
its exclusion theorems in `../B-conic-bundle-multisections/certificates/
k1_frontier.md` and `k1_work/`) transfers verbatim.  Only the
INCIDENCE side changes: which octics arise as disc(F|_ℓ) for a general
(2,4) form F (a different, in fact simpler, family than B's
σ^T adj(A) σ).  Redo the orbit-vs-codimension arguments over the
89-dimensional parameter space with the new incidence.  Even partial
low-class exclusions sharpen where any positive construction must live.

## Certificates

All of B's certificate technology applies: universal identities verified
symbolically over the universal ring; one-witness properness/openness
transfers; étale-algebra checks for unconditioned instances (the marked
points now live in a degree-d algebra Q[th]/(g_0)); deterministic
grid-evaluation proofs with the degree bounds recomputed for d = 4.  A
hit protocol identical to B's: second prime / exact lift / dominance over
the parameter space (now P^{89} for d = 4... recompute: coefficients
6·C(d+2,2) = 6·15 = 90, so P^{89}).

## Success criteria

- D2 positive (upset): headline theorem "general (2,4) is unirational" —
  would move the smooth-discriminant frontier from 9 to 12 and make d = 5
  the next test of the (already dented) large-d expectation.
- D2 negative (expected) with certified invariants, then D3 zoo sweep:
  each negative logged with invariants; a structured pattern is the first
  quantitative evidence for non-unirationality at higher d, and the
  branch-positivity-tax formalization is a standalone "reach of the
  method" theorem.
- D4: certified exclusion frontier for (2,4) low classes, seeded by the
  transferred double-octic classification.

Precision note (from review): Z_4 rational is SUFFICIENT for
unirationality of the general (2,4), not equivalent to it — a negative D2
leaves the covariant zoo and non-correspondence constructions fully open.
The problem statement box above says "implies" advisedly.

## References

- Problem B RESOLUTION.md and notes (tangent residuals, corrected
  double-cover calculus, certificate patterns).
- Harris, Seattle notes pp. 23-24 (the original (2,d) question).
- Prokhorov, Russian Math. Surveys 73:3 (2018), §14.3 (rationality survey
  and the negative expectation).
- Böhning–Graf von Bothmer, Comment. Math. Helv. 93 (2018) (stable
  irrationality of very general (2,n)).
- Bogomolov–Tschinkel, J. reine angew. Math. 511 (1999) (correspondence
  propagation on elliptic fibrations — the iteration antecedent).
- Casarotti–Gammelgaard–Massarenti, arXiv:2511.17213 (surface conic
  bundles, discriminant degree 8 — parallel frontier one dimension down).
