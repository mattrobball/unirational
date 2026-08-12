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
TANGENT-RESIDUAL-TOPOLOGICAL-DEGREE-NOT-COMPUTED
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

1. **`delta(phi_8)`, the topological degree.** Not computed. This is the exact
   quantity `COMBINED_DEGREE_SIEVE` §6 asks for and the one the detection lever
   needs: a self-map whose `delta` is not represented by `x^2+xy+3y^2`, together
   with a CARRIER exclusion, kills the retraction branch. Known:
   `3 <= delta <= 25^3`. The identified route (line-congruence order via
   `int_X c_3((W ⊗ O_X)/E)`) needs the degeneracy locus `{V_8 ∧ x = 0}` and the
   spurious `x = y` multiplicity settled first; neither was attempted.
   See `SELFMAP_AUDIT.md` §7 B1.
2. **Boxing `V_8` over `Q`.** It is computed mod two primes; an integral model
   the way `D_5` is boxed in `D35_K30_K31_CELLS.md` §2 is separate work (B5).
3. **Excluding CARRIER** for a specific self-map — untouched anywhere in the
   repository.

## Non-claims

* No self-map is shown to lie outside `Im(res)`; the retraction branch is not
  killed; no cell of the `d = 35` table changes.
* `res` well defined inherits the accepted input `ed_C(PSL_2(F_11)) >= 3`;
  Corollary 3.4 additionally inherits the accepted full-`G` birational
  superrigidity input, and Theorem 3.3 does not.
* Theorem 4.1 concerns the *divisorial* base locus only.
* Uniqueness in Theorem 3.1 is uniqueness of the minimal *section*, not a claim
  that `phi_8` has minimal coordinate degree among nonidentity self-maps.

`Problem E headline: OPEN.`
