# Status — SELFMAP DETECTION

**Date:** 2026-08-12
**Branch:** `agent/selfmap-detection-20260812`
**Headline:** `Problem E headline: OPEN.` No branch closes.

## Exits

```text
LAND-IS-A-SELF-BIR-BIMODULE-PROVED
RESTRICTION-IMAGE-IS-A-LEFT-IDEAL-PROVED
COMPOSITE-LANDING-TUPLE-CONSTRUCTION-PROVED
RETRACTION-BRANCH-SURJECTIVITY-PROVED
SELFMAP-DETECTION-COROLLARY-PROVED
FOLIATION-QUOTIENT-DESCENT-PROVED
DETECTION-BY-DEGREE-ALONE-IMPOSSIBLE-PROVED
RESTRICTION-ONLY-CONDITIONS-ENUMERATED
EQUIVARIANT-TANGENT-SECTION-REPRESENTATION-PROVED
MINIMAL-EQUIVARIANT-TANGENT-FIELD-DEGREE-EIGHT-EXACT
MINIMAL-EQUIVARIANT-TANGENT-FIELD-UNIQUE
TANGENT-RESIDUAL-COORDINATE-DEGREE-25-EXACT
TANGENT-RESIDUAL-SELFMAP-CANONICAL-AND-EXPLICIT
TANGENT-RESIDUAL-DOMINANT-NONIDENTITY-CERTIFIED
SELFMAP-AUDIT-ALL-RESTRICTION-COMPATIBLE
TANGENT-RESIDUAL-TOPOLOGICAL-DEGREE-NOT-COMPUTED   [superseded 2026-08-12]
MINIMAL-EQUIVARIANT-TANGENT-FIELD-BOXED-OVER-Q
DEGENERACY-LOCUS-ONE-DIMENSIONAL-DEGREE-72
TANGENCY-DOUBLE-POINT-MULTIPLICITY-TWO
PHI8-DELTA-COMPUTED
PHI9-DELTA-COMPUTED
PHI8-NOT-CLEAN
PHI9-NOT-CLEAN
RETRACTION-BRANCH-CARRIER-ONLY
CARRIER-EXCLUSION-NOT-ACHIEVED
```

## Executive summary

**Part 1 — the detection principle.** `Land = A_G(X)` is a
`(Self, Bir^G(P^4))`-bimodule under postcomposition and precomposition;
restriction `res : Land -> Self` intertwines the left `Self`-actions, so
`Im(res)` is a **left ideal** of `Self`. Precomposition does not descend.
Coordinate degrees compose with an **inequality**
(`deg_coord(psi o A) = deg_coord(psi)·deg_coord(A) - deg g`, `g` the content of
the composite tuple), while topological degrees multiply exactly; the composite
tuple `Psi(T)` is independent of the lift `Psi`. The forced foliation, its leaf
space and the leaf fibration descend to `Self \ Land`; the finite map
`rho_T : Y_T -> X` does **not** — it changes by left composition with `psi`, and
stops being finite. The kernel identity behind that is generic, not global.

**Retraction-branch surjectivity (proved).** If some `A_0 in Land` has
`phi_{A_0}` birational then `res` is surjective, via
`psi = ((psi o phi_{A_0}^{-1}) o A_0)|_X`. The hidden content — an *equivariant*
ambient lift of `psi`, the passage from `F(Psi) in (F)` to `F(Psi(T)) = 0`
**identically**, and `F ∤ gcd(Psi(T))` — is supplied in full (Lemma 3.1,
Prop 3.2). **Detection corollary:** one dominant `G`-selfmap provably not a
restriction forces `delta(phi_A) != 1` for every landing tuple, i.e. (granting
the repository's accepted superrigidity input) **kills the retraction branch**.
Checked against the sealed retraction facts: fully consistent, and it yields two
new sharper statements — the tangency constant on the whole `Self`-orbit of a
retraction is the retraction's own ambient degree `d_0`, and a nonempty
retraction branch imports the CLEAN/CARRIER dichotomy for *every* self-map.

**Scope honesty.** Detection by degree alone is impossible: the sealed
`d' in {2,3,4,5}` exclusions bind **all** covariant self-maps, so every
`psi in Self` already has `deg_coord(psi) in {1} ∪ {6,7,...}`, and every such
value has open cells. The six restriction-only necessary conditions are
enumerated (R1)–(R6); only (R4), the CLEAN norm form, tests a quantity intrinsic
to `psi`, and only on one branch.

**Part 2 — the audit.** The flagged never-computed item is done. Equivariant
rational sections of `P(T_X) -> X` are exactly covariant tuples `V` of degree `m`
on `X` with `grad F·V ≡ 0 (mod F)`, modulo `x·(invariants)`; their count is
`N(m) = [C(m)-C(m-3)] - S(m+2) - S(m-1)`, which is **zero for `m <= 7` and one
for `m = 8`**. So the minimal equivariant tangent direction field has degree `8`
and is unique, the tangent-residual selfmap built from it is **canonical**, and

```
        deg_coord(phi_8) = 25,        deg_coord(phi_9) = 28,
```

both exact — the tuple `R = F(V_8)x - Q(x,V_8)V_8` of degree `25` has **empty**
divisorial base locus, certified on one explicit 2-plane. `phi_8` is dominant
and is not the identity, with exact point certificates. Every audited self-map
is **RESTRICTION-COMPATIBLE**; nothing is excluded, so the detection corollary
does not fire.

A by-product: the existence theorem of `FULL_G_SELFMAP_CLASSIFICATION` becomes
**constructive** — `phi_8` is exhibited without the dominant-section lemma, the
free quotient or the descent argument.

**Part 3 — the topological degree (2026-08-12, `PHI8_DEGREE.md`).** The item
listed below as open #1 is done.

```
        delta(phi_8) = 208 = 2^4 * 13,     delta(phi_9) = 288 = 2^5 * 3^2
```

exactly, by two independent routes that agree, at six targets, at two primes and
in characteristic zero. Both preliminary obstacles are settled, and the first
settles **against** the audit's expectation: the degeneracy locus
`{V_8 ^ x = 0}` is **one-dimensional** — a reduced curve of degree `72`, not a
finite set — so the line congruence is not a morphism and the naive Chern-class
count `1753` is void; and the spurious `x = y` solution has multiplicity exactly
`2` (the line is tangent there). `13` is inert in `Q(sqrt(-11))` and
`v_13(208) = 1` is odd, so **`delta(phi_8)` is not represented by
`x^2+xy+3y^2`** and `phi_8` cannot be CLEAN; likewise `phi_9` (`v_2(288) = 5`).
Consequently, **if the retraction branch is nonempty then the normalized graph
of `phi_8` must carry a CARRIER block** on a proper irreducible
`T ⊆ Bs(J_{phi_8})`, `dim T <= 1`, with the `(AHS-Gamma)` Hom condition. The
arithmetic half of the detection lever has fired; the CARRIER half is
**not** excluded, and the retraction branch does **not** die here. By-product:
`V_8` and `V_9` are boxed over `Q` with integer coefficients (blowup point (B5)
closed).

## Verification

```
$ cd problems/E-klein-cubic/goal_runs_20260812/SELFMAP_DETECTION
$ python3 verify_selfmap_audit.py ; echo "EXIT=$?"
```

Terminal output, verbatim:

```text
  checks run : 133
  failures   : 0

RESULT: PASS
EXIT=0
```

Runtime ~12 s. Two primes (`p = 1000033`, `p = 3000229`). Exact integer /
`Fraction` / `F_p` arithmetic; no floating point; no external CAS.

Key intermediate output, verbatim:

```text
  m      :    1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
  N(m)   :    0   0   0   0   0   0   0   1   1   2   3   4   4   7   7

    m= 7  dim Cov_m= 4  dim K_m=3  dim Z_m=3  N(m)=0
    m= 8  dim Cov_m= 5  dim K_m=3  dim Z_m=2  N(m)=1
    dominance certificate at q = (656604, 116083, 373455, 620717, 168772):
        restricted cone Jacobian = 456844 != 0
```

## What is open, and where the next step is

1. ~~**`delta(phi_8)`, the topological degree.**~~ **DONE 2026-08-12**:
   `delta(phi_8) = 208`, `delta(phi_9) = 288`, both non-norms. See
   `PHI8_DEGREE.md`.
2. ~~**Boxing `V_8` over `Q`.**~~ **DONE 2026-08-12**: integer coefficients,
   `40` terms per component, max `|coefficient| = 24`; `V_9` likewise.
3. **Excluding CARRIER for `phi_8`** — the whole remaining distance to
   `RETRACTION-BRANCH-DEAD`, and still untouched. The candidate supports are the
   components of `Bs(J_{phi_8}) = D_8 ∪ {l_x ⊂ X}`; `D_8` is the reduced
   degree-`72` curve computed in `PHI8_DEGREE.md` §2, whose primary
   decomposition, genera and CM data are **not** computed. One exclusion of
   `(AHS-Gamma)` over that curve kills the retraction branch.
4. **The Segre class of `Bs(J_{phi_8})`.** `delta = 25^3 - 25 zeta - a` is
   checked for consistency only; `zeta` and `a` are not computed. This is the
   only route that would give a third, purely intersection-theoretic
   determination of `delta`.

## Non-claims

* No self-map is shown to lie outside `Im(res)`; the retraction branch is not
  killed; no cell of the `d = 35` table changes.
* `delta = 208` is unconditional as a lower bound; the matching upper bound
  needs the target to lie off an at-most-two-dimensional bad locus. Six
  independent targets, two characteristics, two routes — but no named target is
  *proved* generic. This is the one caveat, and it is stated again in
  `PHI8_DEGREE.md` §8.
* `res` well defined inherits the accepted input `ed_C(PSL_2(F_11)) >= 3`;
  Corollary 3.4 additionally inherits the accepted full-`G` birational
  superrigidity input, and Theorem 3.3 does not.
* Theorem 4.1 concerns the *divisorial* base locus only.
* Uniqueness in Theorem 3.1 is uniqueness of the minimal *section*, not a claim
  that `phi_8` has minimal coordinate degree among nonidentity self-maps.

`Problem E headline: OPEN.`
