## 2026-08-12 Self-map detection: restriction is surjective if the retraction branch is nonempty, and the tangent-residual coordinate degree is exactly 25

Packet: `goal_runs_20260812/SELFMAP_DETECTION/` (director-derived theory plus a
bounded audit; `verify_selfmap_audit.py`, 133 checks, `RESULT: PASS`, `EXIT=0`,
~12 s, two primes, no floating point). Problem E remains **OPEN**; no branch
closes and no cell of the `d = 35` table moves.

**The detection principle.** `Land = A_G(X)` is a `(Self, Bir^G(P^4))`-bimodule:
self-maps act by postcomposition, ambient equivariant birational maps by
precomposition, and the two commute. Restriction `res : Land -> Self`
intertwines the *left* actions, so its image is a **left ideal** containing
`Self o phi_A` for every `A`; precomposition does not descend, because
`g(X) != X`. Degree bookkeeping, stated where the inequalities really are:
topological degrees multiply exactly, coordinate degrees satisfy
`deg_coord(psi o A) = deg_coord(psi)·deg_coord(A) - deg g` with `g` the content
of the composite tuple, and the composite tuple `Psi(T)` is independent of which
ambient lift `Psi` is chosen (two lifts differ by `F·U`, killed by `F(T) = 0`).
The forced foliation, its leaf space `Y_T` and the leaf fibration descend to the
quotient `Self \ Land`; the finite map `rho_T : Y_T -> X` does **not** — it
becomes `psi o rho_T`, generically finite of degree multiplied by `deg psi`, and
no longer finite — and neither do `P_T`, its content, `Delta_T`, `d`, `k`, `d'`
or `delta`. The kernel identity behind the invariance holds generically only, so
it is an identity of *saturated* foliations.

**Retraction-branch surjectivity, proved.** If some `A_0 in Land` has
`phi_{A_0}` birational, then `res` is surjective:
`psi = ((psi o phi_{A_0}^{-1}) o A_0)|_X`. The content is at the tuple level and
is supplied in full: an *equivariant* ambient lift exists (projective normality
plus exactness of `G`-invariants in characteristic zero); `F(Psi) in (F)`
upgrades to `F(Psi(T)) = 0` **identically** because the landing identity for `T`
is an identity in five variables; and `F` does not divide the content of
`Psi(T)`, which is what keeps the restricted map alive after clearing
denominators. Contrapositive — the **detection corollary**: a single dominant
`G`-selfmap provably not a restriction forces `delta(phi_A) != 1` for every
landing tuple, i.e. kills the retraction branch. The general statement uses no
superrigidity; only the identification "birational = retraction" consumes the
repository's accepted full-`G` birational superrigidity input, and that split
was made deliberately.

Checked against the sealed retraction facts (`D_X != 0`, `k = d-1 >= 5`,
`T = Hx + FQ`, `d >= 24`, ambient floor `d >= 35`): fully consistent, and two
sharper statements fall out. A retraction of ambient degree `d_0` gives, for
every self-map `psi` of coordinate degree `n`, the cell
`(d,k,d') = (n d_0, n(d_0-1), n)`, so the tangency constant `d/d'` on the whole
`Self`-orbit of a retraction is `d_0`, independent of `psi`; and a nonempty
retraction branch imports the CLEAN/CARRIER dichotomy for *every* self-map, so
one self-map with topological degree not represented by `x^2+xy+3y^2`, plus a
CARRIER exclusion, would close the branch.

**Why degree bookkeeping alone cannot detect.** The sealed `d' in {2,3,4,5}`
exclusions are statements about all `G`-equivariant selfmaps, dominant or not,
so every `psi in Self` already satisfies `deg_coord(psi) in {1} ∪ {6,7,...}`,
and every value there has open `(d,k)` cells. The restriction-only necessary
conditions are enumerated exactly: ambient extension `F(T) = 0` (the real one),
the tangency factorization `Delta_T|_X = (d/d')H^2 j_psi` (which by the
surjectivity of the tangency map constrains `psi` not at all on its own), the
forced ambient foliation, the CLEAN/CARRIER dichotomy of the ambient graph, the
degree cell, and the forced plus-plane base strata.

**The audit, and the number `COMBINED_DEGREE_SIEVE` §6 asked for.** Equivariant
rational sections of `P(T_X) -> X` are exactly `G`-covariant tuples `V` of degree
`m` on `X` with `grad F·V ≡ 0 (mod F)`, modulo `x·(invariants)` (Hilbert 90 plus
the normal basis theorem to make the lift equivariant; `S/(F)` a UFD to clear
denominators). Their count is `N(m) = [C(m)-C(m-3)] - S(m+2) - S(m-1)`, which is
**zero for every `m <= 7` and one at `m = 8`** — so the minimal equivariant
tangent direction field has degree `8` and is **unique**, and the tangent-residual
self-map built from it is canonical. Its tuple
`R = F(V_8)x - Q(x,V_8)V_8` has degree `25` and **empty divisorial base locus**,
certified by one explicit 2-plane (any nonzero divisor on `X` is a surface in
`P^4` and meets every 2-plane, so a single plane with no common zero is
decisive). Hence

```
deg_coord(phi_8) = 25 exactly,      deg_coord(phi_9) = 28 exactly,
```

with `phi_8` dominant and not the identity, both certified at an exact point of
`X`. Every audited self-map — the identity, `phi_8`, `phi_9`, the iterates — is
**RESTRICTION-COMPATIBLE**, with the first cells `(35,34)`, `(35,10)`, `(35,7)`
respectively; nothing is excluded, so the detection corollary does not fire.
Two by-products: the existence theorem of `FULL_G_SELFMAP_CLASSIFICATION`
becomes constructive (no dominant-section lemma, no free quotient, no descent),
and the computed degrees `1, 25, 28` land inside the sealed surviving set
`{1} ∪ {6,7,...}` — a real consistency test that any value in `{2,3,4,5}` would
have broken.

**Open, and the exact blowup point.** The **topological** degree `delta(phi_8)`
is not computed; that is the quantity the detection lever needs. Known
`3 <= delta <= 25^3`. The identified route is the order of the line congruence
`x |-> l_{x,V_8(x)}`, i.e. `int_X c_3((W ⊗ O_X)/E)` corrected for the spurious
`x = y` solution, and it needs the degeneracy locus `{V_8 ∧ x = 0}` settled
first; not attempted, and no number is recorded. Also not done: boxing `V_8`
over `Q` (it is computed modulo two primes, which is rigorous for every
conclusion drawn), the coordinate degrees of the iterates, and any CARRIER
exclusion.

Exits: `LAND-IS-A-SELF-BIR-BIMODULE-PROVED`,
`RESTRICTION-IMAGE-IS-A-LEFT-IDEAL-PROVED`,
`COMPOSITE-LANDING-TUPLE-CONSTRUCTION-PROVED`,
`RETRACTION-BRANCH-SURJECTIVITY-PROVED`,
`SELFMAP-DETECTION-COROLLARY-PROVED`,
`FOLIATION-QUOTIENT-DESCENT-PROVED`,
`DETECTION-BY-DEGREE-ALONE-IMPOSSIBLE-PROVED`,
`RESTRICTION-ONLY-CONDITIONS-ENUMERATED`,
`EQUIVARIANT-TANGENT-SECTION-REPRESENTATION-PROVED`,
`MINIMAL-EQUIVARIANT-TANGENT-FIELD-DEGREE-EIGHT-EXACT`,
`MINIMAL-EQUIVARIANT-TANGENT-FIELD-UNIQUE`,
`TANGENT-RESIDUAL-COORDINATE-DEGREE-25-EXACT`,
`TANGENT-RESIDUAL-SELFMAP-CANONICAL-AND-EXPLICIT`,
`TANGENT-RESIDUAL-DOMINANT-NONIDENTITY-CERTIFIED`,
`SELFMAP-AUDIT-ALL-RESTRICTION-COMPATIBLE`,
`TANGENT-RESIDUAL-TOPOLOGICAL-DEGREE-NOT-COMPUTED`.
