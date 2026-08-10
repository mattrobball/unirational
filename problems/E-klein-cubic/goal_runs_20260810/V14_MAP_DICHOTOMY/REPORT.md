# V14-MAP-DICHOTOMY — REPORT

Exit: **V14MAP-DICHOTOMY-SEALED**. Sealed 2026-08-10 from an external ChatGPT session
("Existence Of A Map", https://chatgpt.com/share/6a7a121d-0994-83ea-9e1f-510064072ea6;
extract in `import/`), reviewed and adjudicated by the director. Machine layer:
`verifier.py`, pure python3, primes 397 and 199, ALLGREEN (`results/checks.log`).

Notation: `G = PSL(2,11)`; `U` = the 6-dim even Weil representation of `SL(2,11)` (the
center acts by -1, so only `P(U)` carries a `G`-action); `M` = the `10'` summand of
`Lambda^2 U`; `A = Ann(M)` in `Lambda^4 U` (5-dim); `X = {Pf = 0}` in `P(A)` the Klein
cubic (sealed identification, FIX_IX_SEAL item 5); `V14 = Gr(2,U) cap P(M)`.

## Theorem A — no equivariant map Klein → V14

**For every automorphism `alpha` of `G` there is no `alpha`-twisted `G`-equivariant
rational map `X --> V14`, dominant or not.**

Proof. Fix an involution `sigma`, put `N = C_G(sigma) = D12`. Sealed inputs: (i) the
line `L_sigma = P(W_sigma^-)` lies on `X`, is pointwise `sigma`-fixed, `N`-stable and
rational (FIX_A0_INVOLUTION_ARRANGEMENT, exit `FIX-A0-ARRANGEMENT-PASS`); (ii)
`V14^sigma` = smooth genus-1 sextic + 2 reduced points, so no rational curve lies in a
positive-dimensional component, and `V14^{D12}` is empty (FIX_IX_SEAL, exit
`FIX-IX-SEAL-PASS`). Given equivariant `f: X --> V14`, resolve indeterminacy
equivariantly (char 0, blowups along smooth `G`-stable centers) and track a carrier:
start with `L_sigma`; at each blowup take the strict transform if the carrier is not
contained in the center, else the projectivization of a nonzero `sigma`-eigen-subbundle
of the normal bundle restricted to the carrier. Both branches preserve irreducibility,
pointwise `sigma`-fixedness, rational chain connectedness, and `N`-stability (`N`
centralizes `sigma`, hence preserves the eigen-subbundles). The final carrier maps to an
irreducible `N`-stable RCC closed subset of `V14^sigma`; with no rational curve
available there it is a single point, hence a point of `V14^N` = empty. Contradiction.
The `alpha`-twisted case follows because `alpha` preserves the class of involutions and
carries centralizers to centralizers.

This is the residual-RCC centralizer obstruction of
`research/equivariant-unirationality-new-applications/GENERALIZATIONS.md` §2 with source
`X` in place of a linear `P(V)`; the only source-side requirement is the initial
carrier, supplied by `L_sigma`. Exit: **V14MAP-KLEIN-TO-V14-EMPTY**.

## Theorem B — an equivariant map V14 → Klein exists

**There is a nonconstant `G`-equivariant rational map `Phi: V14 --> X`.**

Proof. (1) `F = C(V14)^G`, `E = C(V14)`, `T = Spec E -> Spec F` the generic torsor (the
action is faithful, `G` finite, `V14` irreducible, hence generically free). The generic
point of `V14` is a `G`-equivariant `E`-point, i.e. a tautological `v_T` in `(^T
V14)(F)`. (2) `^T P(U) = SB(Alg)`, `Alg` a degree-6 central simple `F`-algebra whose
class in `Br(F)` is the boundary of the `mu_2`-extension: 2-torsion, and period and
index share prime factors, so `ind` divides 2. Redundant second derivation: `^T V14`
sits in `SB_2(Alg)` and `v_T` is a right ideal of reduced dimension 2, which is a
multiple of the index. Choose `L/F` of degree at most 2 splitting `Alg`. (3) `M`, `A`,
`W` are honest `G`-representations, so their twists are `F`-vector spaces; over `L`,
after a splitting `U_{T,L} = L^6`, the twisted pair `(^T X, ^T V14)` is an honest
Pfaffian-Grassmannian pair, and for a general `L`-rational hyperplane `Pi` in
`P(U_{T,L}) = P^5_L` the classical hyperplane construction gives a birational `chi_Pi:
^T V14_L --> ^T X_L`. Pinned inputs: Tschinkel-Zhang arXiv:2409.08392
(`external_docs/tschinkel_zhang_stable_equivariant_arxiv2409.08392.pdf`); the
equivariance identity `g chi_Pi = chi_{gPi} g` audited in
`goal_runs_20260809/GROSS_POPESCU_EQUIVARIANT_MODULI` (exit `GP-THETA11-G-EQUIVARIANT`);
and the precedent that this exact mechanism (Brauer-Severi factor split by a degree <= 2
extension, quadratic point descended by third intersection) is already consumed by the
`ed = 3 <=> headline` reduction recorded in `SPEC.md` ("There is a stronger
unconditional reduction, proved in `RESOLUTION.md`..."). (4) Nishimura: `^T V14_L` is
smooth with an `L`-point, so `(^T X)(L)` is nonempty. If `L = F`, done. (5) Otherwise
`L/F` is quadratic with involution `iota`, and `^T X` sits in `P(W_T)` for an `F`-form
`W_T` — no Brauer obstruction on the target, which is where `W` being an honest
representation is used. For `x` in `(^T X)(L)`: if `x = x^iota` it is an `F`-point; if
the line `<x, x^iota>` lies in `^T X` it is a `P^1_F`, which has `F`-points. Otherwise,
with `Fcub` the twisted cubic form and `Bpol` its symmetric trilinear polarization, put
`a = Bpol(x,x,x^iota)` and `b = Bpol(x,x^iota,x^iota) = a^iota`; then `Fcub(sx + t
x^iota) = 3st(as + bt)`, so the residual point `r = [b x - a x^iota]` is
`iota`-anti-invariant, hence `F`-rational, and lies on `^T X`. So `(^T X)(F)` is
nonempty. (6) Twisting adjunction (Duncan-Reichstein Thm 1.1; `SPEC.md` "Exact
equivalent formulations"): `(^T X)(F)` = {`G`-equivariant rational maps `V14 --> X`}.
Nonconstant because `X^G` is empty (`W` irreducible, `G` perfect). Exit:
**V14MAP-V14-TO-KLEIN-EXISTS**.

**Corollary 1 (transfer).** For every twisting pair `(T,K)`: `(^T V14)(K)` nonempty
implies `(^T X)(K)` nonempty (Nishimura along the twist of `Phi`; `V14` smooth, `X`
proper). Exit: **V14MAP-TRANSFER-POINTED-TWISTS**.

**Corollary 2 (both comparison routes closed).** Theorem A makes "find `X --> V14` to
disprove the headline" vacuous; Theorem B unconditionally fulfills the necessary
condition "`V14 --> X` exists if `X` is `G`-unirational". Neither direction can decide
the headline.

## Machine layer (verifier.py, p = 397 and 199, ALLGREEN)

Model rebuilt in FIX_IX_SEAL conventions (1320-closure, projective-order profile
(2,110,220,528,220,240), `rank(10'-projector) = 10`, `dim Ann(M) = 5`); 60 distinct
`V14` points per prime from a kernel-jump generator, each in `M`, decomposable, and
satisfying the 15 wedge-square (Plucker) equations; `Hom_G(M,A) = 0` (projector rank 0,
`<chi_M, chi_A> = 0`) — no degree-1 covariant; `Sym^2(10')` has `dim 55`, `mult(1) =
mult(5) = mult(5bar) = 1`, `mult(10') = 2`, `<chi,chi> = 9`, which force `1 + 5 + 5bar +
10' + 10' + 12 + 12'`; the trivial occurs once in `Sym^3(A)` and once in
`Sym^3(A^dual)`, and the invariant cubic on `A` is a nonzero multiple of `Pf6` (sealed
Klein identification); the quadratic covariant into `A` is nonzero, unique up to scale,
generator-equivariant, and vanishes at 60/60 sampled `V14` points; the secant identity
and the `F`-rationality of `r` hold exactly on 12 conjugate pairs per prime over
`F_{p^2}` for the cyclic Klein form; `A^G = M^G = 0`, so `X^G = P(A)^G` is empty. Exit:
**V14MAP-DEGREE12-REPLAYED**.

**Correction to the session's degree-2 argument (new, this packet).** `Sym^2(10')` has
TWO one-dimensional 5-slots, not one: there is a second quadratic covariant `q_bar:
Sym^2 M -> A^dual` (`A` is not self-dual, `<chi_A, chi_A> = 0`). It does NOT vanish on
`V14` (60/60 sampled points have nonzero image), so the session's "the unique quadratic
5-covariant vanishes on V14" is incomplete. Degree 2 is closed anyway, for a different
reason on the second slot: the unique `G`-invariant cubic of `P(A^dual)` — the conjugate
Klein cubic, i.e. the `alpha`-twisted target — is nonzero at 60/60 image points, so the
degree-2 map `V14 --> P(A^dual) = P^4` misses it. Both 5-dim targets are closed at
degree 2, at both primes.

## Session import, unreplayed part

The session also excluded explicit covariant realizations of `Phi` in degrees 1-5 at `p
= 397` (degree 1: `Hom_G(M,A) = 0`; degree 2: the quadratic `A`-covariant lies in the
restricted Plucker ideal; degrees 3-5: rank computations). Degrees 1-2 are REPLAYED here
at two primes and extended to the conjugate 5-slot; degrees 3-5 remain
**V14MAP-DEGREE-3-4-5-IMPORT-UNREPLAYED** — work order: replay at a second prime with
char-0 transfer, covering both 5-dim targets. Session errors and leads: it stated
`Sym^2(10') = 1 + 5 + 10 + 10'` (dim 26, not 55; the correct decomposition is above —
director character computation, re-checked by the verifier), and its "generically
dominant via Palatini flop plus canonical degree-2 divisors on ruling lines" claim is an
UNVERIFIED sketch: an open lead, not a result.

## Not claimed, and replay

Dominance of `Phi`; any explicit `Phi`; any headline or `ed` value. Char-0 scope: the
proofs above are char 0; the machine layer is mod-p at two primes (evidence-grade for
char 0). Headline stays **OPEN**. Replay: `python3 verifier.py` (defaults 397 199, ~11
s, writes `results/checks.log`, prints ALLGREEN).
