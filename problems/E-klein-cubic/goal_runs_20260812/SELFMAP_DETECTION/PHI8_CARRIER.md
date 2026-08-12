# The CARRIER question for `phi_8`: the base scheme, and why the exclusion cannot be done

Exits: `PHI8-BASE-SCHEME-CURVE-DEGREE-1224`,
`PHI8-BASE-NO-DIVISORIAL-COMPONENT-REPROVED`,
`PHI8-BASE-DECOMPOSED`,
`PHI8-CARRIER-FORCED-UNCONDITIONALLY`,
`CARRIER-EXCLUSION-IMPOSSIBLE-FOR-PHI8`,
`S2-DETECTION-LEVER-VOID`,
`CARRIER-LINES-CONSTANT-CLASS-DEAD-AND-EMPTY`,
`CARRIER-D8-UNDECIDED`,
`CARRIER-POINT-ORBIT-60-UNDECIDED`,
`PHI8-CARRIER-CANDIDATE-BOXED`,
`RETRACTION-BRANCH-UNDECIDED`.

Verified exactly: `verify_phi8_carrier.py` (`RESULT: PASS`, 60 checks, ~65 s).

**Problem E headline: OPEN. The retraction branch does not close, and it cannot
be closed this way.**

---

## 0. One-paragraph summary

The work order was: compute `Bs(J_{phi_8})`, and decide, orbit by orbit,
whether any component can carry the `(AHS-Gamma)` block — with
`RETRACTION-BRANCH-DEAD` as the prize if none can. The base scheme was
computed. The verdict is not the prize, and it is not an undecided either. It
is a **route closure with the opposite sign**:

> `phi_8` is **CARRIER, unconditionally**. Not "CARRIER if the retraction
> branch is nonempty" — CARRIER, full stop. Therefore `(AHS-Gamma)` **holds**
> for `phi_8`, some component of `Bs(J_{phi_8})` **does** carry the block, and
> the exclusion that `PHI8_DEGREE.md` §7 boxed as "the only remaining step
> between here and `RETRACTION-BRANCH-DEAD`" is a statement whose negation is a
> theorem. It cannot be proved because it is false.

The reason is a one-line reading of the sealed dichotomy. `THEOREM_RESTRICTED_
DICHOTOMY.md` Theorem 3.1 is stated for a self-map "obtained by restricting a
hypothetical ambient landing map", but **its proof never uses the provenance**
(§2 below lists the five inputs it does use, all of which `phi_8` satisfies
from sealed facts). So the dichotomy applies to `phi_8` directly, the CLEAN
branch is killed by `delta(phi_8) = 208` not being a norm — which is exactly
what `PHI8_DEGREE.md` Theorem 6.1 proves — and the CARRIER branch is forced.
The same argument voids the detection lever (S2) of
`THEOREM_DETECTION_PRINCIPLE.md` §3.3 **in general**: its two halves ("find
`psi` whose `delta` is not a norm" and "exclude CARRIER for that `psi`") are
mutually exclusive, because the first implies the negation of the second.

What is gained instead is positive and checkable. The base scheme is computed
exactly, the geometry of the carrier is identified, and the theory's forced
prediction — that a component of `Bs(J_{phi_8})` carries a weight-one block
receiving `E_{-11}` — is confirmed against sealed Fano-surface facts rather
than contradicted. That confirmation is a genuine adversarial test of the whole
`delta = 208` chain, and the chain passes it.

---

## 1. The base scheme of `phi_8`, exactly

`phi_8 = [R]`, `R(x) = F(V_8)·x - Q(x,V_8)·V_8`, `deg R = 25`, primitive on `X`
(`SELFMAP_AUDIT.md` Theorem 4.1). Set-theoretically, on `X`,

```
Bs(J_{phi_8}) = { x in X : R(x) = 0 } = { x in X : F(V_8)(x) = Q(x,V_8)(x) = 0 },
```

because a point of the degeneracy curve `D_8 = {V_8 ^ x = 0}` already satisfies
`F(V_8) = Q = 0` (`PHI8_DEGREE.md` §7), and off `D_8` the vanishing of `R` is
equivalent to the vanishing of both scalars. So `D_8 ⊂ Bs(J_{phi_8})` and the
base scheme is cut on `X` by one form of degree `24` and one of degree `17`.

> **Theorem 1.1.** `Bs(J_{phi_8})` is a **curve**: the ideal
> `(F, F(V_8), Q(x,V_8))` has codimension `3` in `P^4`, and
> ```
> deg  = 1224 = 3 · 24 · 17,     Hilbert polynomial  1224 i - 23868,
> ```
> so the three forms meet **properly** and `Bs(J_{phi_8})` is a
> one-dimensional complete intersection of type `(3,24,17)` with arithmetic
> genus `p_a = 23869`. The tuple `R` has `gcd(R_0,...,R_4) = 1` in `Q[x]`, and
> `(F) + (R_0,...,R_4)` also has codimension `3`.

*Proof.* Direct Gröbner computation over `F_p`, `p = 1000033 = 1 mod 11` (so
`G` is `F_p`-rational), block (B) of the verifier. The adjunction cross-check
is exact: a proper complete intersection of type `(3,24,17)` in `P^4` has
`omega = O(3+24+17-5) = O(39)`, hence `2p_a - 2 = 39 · 1224 = 47736` and
`p_a = 23869`, matching the computed Hilbert polynomial on the nose. Two
independent quantities (degree and constant term) agree with the two
independent predictions, so the intersection is proper and no excess component
is hiding. ∎

Two consequences.

* **No divisorial component.** `codim = 3` re-proves, from the intrinsic side,
  `SELFMAP_AUDIT.md` Theorem 4.1's "the divisorial base locus is empty" — and
  it proves the stronger statement the dichotomy actually needs, namely that
  every strict support inside `Bs(J)` has `dim <= 1`. The sealed Theorem 4.1
  certifies emptiness of the divisorial base locus on an explicit 2-plane;
  this is a global computation and is independent of it.
* **`D_8` is a small part of the base scheme.** `deg D_8 = 72` against
  `deg Bs(J) = 1224`. The base scheme is *not* the degeneracy curve; the bulk
  of it is the **lines locus**
  ```
  Lambda := closure{ x in X \ D_8 : the line l_x = <x, V_8(x)> is contained in X },
  ```
  which is where the residual point of `l_x . X` is undefined because the whole
  line lies in `X`. This is the component class that matters below.

---

## 2. The dichotomy is unconditional, and therefore `phi_8` is CARRIER

`THEOREM_RESTRICTED_DICHOTOMY.md` §1 opens with

> "Let `phi : X --> X` be the dominant `G`-equivariant selfmap obtained by
> restricting a hypothetical ambient landing map. Let `J` be its primitive
> restricted base ideal and let `Gamma = Proj_X R(J)^bar` be the normalized
> graph..."

The word "restricted" in "primitive restricted base ideal" names the *object* —
an ideal on `X` rather than on `P^4` — not the *provenance* of `phi`. Reading
the proof line by line, the inputs actually consumed are exactly these five:

| # | input | where it is used | does `phi_8` satisfy it? |
|---|---|---|---|
| (i) | `phi : X --> X` dominant, `G`-equivariant | throughout | **yes**: dominant is `SELFMAP_AUDIT.md` Theorem 4.3 (`TANGENT-RESIDUAL-DOMINANT-NONIDENTITY-CERTIFIED`); `G`-equivariance of the tangent-residual construction `rho(x,[v]) = [F(v)x - Q(x,v)v]` is sealed (`FULL_G_SELFMAP_CLASSIFICATION/THEOREM.md` §1, `SOURCES.md` A15) and `V_8` is `G`-covariant over `Q(zeta_11)` (`PHI8_DEGREE.md` §1, block (B')) |
| (ii) | `Gamma` normal, `pi : Gamma -> X` proper birational, `X` smooth | Lemma 2.1 (`i_pi`, `t_pi`, `t_pi i_pi = id`) | **yes**, by construction of `Gamma` |
| (iii) | `q : Gamma -> X` generically finite of degree `delta` | Lemma 2.2 (`t_q i_q = delta·id`) | **yes**, `delta(phi_8) = 208` (`PHI8_DEGREE.md` Theorem 4.1) |
| (iv) | `V = H^3(X,Q)(1)` irreducible as a rational `G`-module | §3, to make `r_phi` zero-or-injective | **yes**, sealed, independent of `phi` |
| (v) | `End_{G-HS}(V_Z) = O_K`, `K = Q(sqrt(-11))`, `h(K) = 1`, and the graph correspondence integral | §4, to get `delta = N_{K/Q}(u_phi)` | **yes**, sealed (§4.1–4.4); integrality of `u_phi = t_pi i_q` holds for any correspondence |

No step consumes the existence of an ambient tuple `T` with `F(T) = 0`, an
ambient degree `d`, a common factor `H`, or anything else from the landing
side. The provenance clause of §1 is **inert**. (This is an adjudication of the
sealed text, and it is flagged as such: §7 (a) records the check that no other
sealed statement depends on the clause being live.)

> **Theorem 2.1 (`PHI8-CARRIER-FORCED-UNCONDITIONALLY`).**
> `r_{phi_8} != 0`. Equivalently, the normalized graph of `phi_8` is in the
> CARRIER branch, and `(AHS-Gamma)` **holds**: there are a perverse degree
> `j_0`, a proper irreducible strict support `T ⊆ Bs(J_{phi_8})` with
> `dim T <= 1`, and `H = Stab_G(T)`, such that
> ```
> Hom_{HS,H}( Res^G_H V , IH^{s-j_0}(T̄, L)(1) ) != 0,   s = dim T.
> ```
> No hypothesis. In particular the retraction branch is not assumed.

*Proof.* Theorem 3.1 of `THEOREM_RESTRICTED_DICHOTOMY.md` applies to `phi_8` by
the table above. Exactly one branch holds. If CLEAN, then (4.4) gives
`delta(phi_8) = N_{K/Q}(u) = x^2 + xy + 3y^2` for integers `x,y`. But
`delta(phi_8) = 208 = 2^4 · 13`, `13 mod 11 = 2` is a non-residue so `13` is
inert in `K`, and `v_13(208) = 1` is odd; by the sealed representation
criterion `208` is not represented (`PHI8_DEGREE.md` Theorem 6.1, re-checked by
brute force in block (A) of the verifier). So CLEAN fails and CARRIER holds. ∎

> **Corollary 2.2.** The same holds for `phi_9` (`delta = 288 = 2^5 · 3^2`,
> `2` inert, `v_2 = 5` odd) and for every odd iterate `phi_8^r`
> (`delta = 208^r`, `v_13 = r` odd). Infinitely many explicit `G`-selfmaps of
> the Klein cubic threefold have a normalized graph with a proper strict
> support carrying `V`.

> **Corollary 2.3 (`CARRIER-EXCLUSION-IMPOSSIBLE-FOR-PHI8`).** The Box of
> `PHI8_DEGREE.md` §7 — *"Exclude `(AHS-Gamma)` for every irreducible `T` of
> dimension `<= 1` inside `Bs(J_{phi_8})` ... That single exclusion kills the
> retraction branch"* — asks for a proof of a false statement. The exit
> `CARRIER-EXCLUSION-NOT-ACHIEVED` should be read as
> `CARRIER-EXCLUSION-IMPOSSIBLE`, and the residual it boxes should be struck.

Note precisely what Corollary 2.3 does **not** say. `PHI8_DEGREE.md`
Corollary 6.2 (`retraction nonempty => CARRIER(phi_8)`) is a **true**
implication; it is simply vacuous as a lever, because its consequent is
unconditionally true. Nothing in `PHI8_DEGREE.md` is retracted. What is
retracted is the *plan* built on top of it.

---

## 3. The detection lever (S2) is void in general

> **Theorem 3.1 (`S2-DETECTION-LEVER-VOID`).** Let `psi` be any dominant
> `G`-equivariant rational selfmap of `X`. If `delta(psi)` is not represented
> by `x^2 + xy + 3y^2`, then the normalized graph of `psi` is CARRIER
> unconditionally, so the CARRIER branch cannot be excluded for `psi`.
> Consequently the two halves of the lever
> ```
> (S2)  find psi in Self with delta(psi) not a norm,
>       and exclude the CARRIER branch for psi
> ```
> (`THEOREM_DETECTION_PRINCIPLE.md` §3.3) are **mutually exclusive**: the first
> half implies the negation of the second. (S2) can never close the retraction
> branch, for any `psi`, at any degree.

*Proof.* Identical to Theorem 2.1: the dichotomy applies to `psi` by the five
inputs of §2, and the norm equation of the CLEAN branch fails. ∎

This is the honest statement of what the `delta(phi_8) = 208` computation buys.
It buys a **geometric theorem about `phi_8`** — its graph has exceptional
`H^3` carrying the Klein Hodge structure — and it buys nothing about the
retraction branch, because the quantity it constrains, `r_psi`, is intrinsic to
`psi` and does not remember whether `psi` extends to `P^4`.

Why the lever looked live: `THEOREM_DETECTION_PRINCIPLE.md` §4.2 (R4) is
titled *"the clean/carrier dichotomy of the **ambient** graph"*, and (R4) does
say the dichotomy "is the **only** condition in the list that constrains a
quantity intrinsic to `psi`". Both halves of that sentence are right; what was
missed is that a condition intrinsic to `psi` is, for exactly that reason,
useless as a test of whether `psi` is a restriction. Restriction-detection needs
a condition that a restriction satisfies and an abstract self-map may fail —
and (R4), being intrinsic, is never such a condition.

**What survives.** The genuinely ambient obstructions are untouched by this
note and remain the live route:

* the **ambient** `(AHS)` on `p : Y -> P^4` for a landing tuple of degree
  `d >= 35`, with supports in `Bs(J_ambient) ⊂ P^4` — governed by
  `RT_SPLIT_AND_DICHOTOMY/DEGREE_ACCOUNTING.md` and
  `THEOREM_POINT_SUPPORT.md`, whose exit is `SUPPORT-ESCAPE-UNDECIDED`;
* the ambient-to-restricted transfer, whose exit is
  `CLEAN-CASE-TRANSFER-UNDECIDED` with the explicit CT1 countermodel;
* (R1), (R3), (R6) of `THEOREM_DETECTION_PRINCIPLE.md` §4.2, which are the
  conditions with genuine restriction-only content.

---

## 4. Where the carrier actually is

Theorem 2.1 says a carrier exists. It is worth knowing which component carries
it, both because that is the boxed deliverable and because a *failure* to find
one would have been evidence against the `delta = 208` chain.

### 4.1 The `E_{-11}` requirement, stated exactly

`V = H^3(X,Q)(1)` is a polarizable weight-one `Q`-Hodge structure of dimension
`10` on which `O_K` acts (`THEOREM_RESTRICTED_DICHOTOMY.md` (4.2)), with the
two `K`-eigenspaces of `V_C` equal to the two Hodge summands (each of dimension
`5`). Hence `V` is of CM type for `K`, and since `h(K) = 1`,

```
V  ~  H^1(E_{-11}, Q)^{⊕5},        E_{-11} = the CM(-11) elliptic curve, j = -32768.
```

This is the sealed `J(X) ≅ E^5` (Roulleau; Adler independently; recorded in
`goal_runs_20260811/RETRACT_LANDSCAPE_NOTE/THEOREM.md`, adjudicated CONFIRMED
in `ADJUDICATION_PR38.md`). So for **any** candidate support `T`,

```
(AHS-Gamma) for T   =>   Hom_HS( H^1(E_{-11},Q), IH^{s-j_0}(T̄,L)(1) ) != 0,
```

i.e. the block on `T` must have an isogeny factor `E_{-11}` in its weight-one
part. This is the single arithmetic test, and it is what "the `E_{-11}`-isotypic
requirement" means concretely.

### 4.2 The lines locus is the carrier, and every one of its curve components qualifies

Let `T` be a one-dimensional component of `Lambda` (the lines locus of §1) and
let `lambda_T : T --> S`, `x |-> l_x`, be the induced map to the Fano surface of
lines of `X`.

> **Lemma 4.1 (fiber containment).** For every `x in X \ D_8`, the fiber of the
> closure of the graph of `phi_8` in `X x X` over `x` is contained in
> `{x} x l_x`.
>
> *Proof.* On `U = X \ D_8` the line `l_y = <y, V_8(y)>` is defined and varies
> algebraically, and the graph of `phi_8` over `U` is contained in the closed
> incidence set `I_U = {(y,z) : y in U, z in l_y} ⊂ U x X`, because
> `phi_8(y)` is by construction the residual point of `l_y . X`. Closures of a
> subset of a closed set stay inside it, and fibers of `I_U` are the `l_y`. ∎

> **Proposition 4.2.** For `x` in a component `T ⊆ Lambda` on which
> `pi : Gamma -> X` has one-dimensional fibers, the fiber over a general `x`
> maps **onto** `l_x`, so the exceptional divisor `E_T ⊆ Gamma` over `T` is a
> surface ruled by the lines `l_x`, `x in T`, i.e. it dominates the ruled
> surface `P_T = {(x,z) : x in T, z in l_x}` over `T`.
>
> *Proof.* `pi` is birational with `X` smooth and `Gamma` normal, so its
> exceptional set is a divisor (purity); over a curve component `T` the generic
> fiber is therefore one-dimensional. By Lemma 4.1 it lies in `l_x ≅ P^1` and
> is one-dimensional, hence surjects onto `l_x`. ∎

> **Theorem 4.3 (`PHI8-CARRIER-CANDIDATE-BOXED`).** `Lambda` is irreducible,
> `G`-invariant, of degree `792` (§5), and `lambda := lambda_Lambda` is
> nonconstant. Let `C_0 = lambda(Lambda) ⊆ S`. Then
> ```
> V(-1)  ↪  H^1(C̃_0, Q)     as G-Hodge structures,
> ```
> so `Hom_{HS,G}( V , H^1(C̃_0)(1) ) != 0`. That is exactly the datum
> `(AHS-Gamma)` demands on `Lambda`, with `H = Stab_G(Lambda) = G`,
> `j_0 = 0` and constant coefficients `L = Q`.
>
> *Proof.* `deg Lambda = 792 > 1`, so `Lambda` is not a line; a constant
> `lambda` would force `Lambda ⊆ l_x`, hence `Lambda = l_x`, a line. So
> `lambda` is nonconstant and `C_0` is a curve, `G`-invariant because
> `Lambda` is and `lambda` is `G`-equivariant. Three sealed facts about the
> Fano surface `S` of the Klein cubic: `Alb(S) ≅ J(X)`
> (`goals_2026-08-01/J_FIXED_CENTRE_PRYM/HODGE_ISOGENY.md`); the Abel–Jacobi
> map `S -> Alb(S)` is an **embedding** (Roulleau, quoted verbatim in
> `goal_runs_20260811/RETRACT_LANDSCAPE_NOTE/THEOREM.md`); and
> `J(X) ≅ E_{-11}^5` (same source, adjudicated CONFIRMED in
> `ADJUDICATION_PR38.md`). So `C̃_0 -> J(X)` is nonconstant, and the abelian
> subvariety `A ⊆ J(X)` it generates is nonzero and `G`-stable. Now
> `H^1(J(X),Q) = V(-1)` is an **irreducible** rational `G`-module (sealed,
> `THEOREM_RESTRICTED_DICHOTOMY.md` §4), and `H^1(A,Q)` is a nonzero
> `G`-quotient of it, hence all of it: `A = J(X)` up to isogeny. Surjectivity
> of `Jac(C̃_0) ↠ A` dualizes to the stated injection of `G`-Hodge structures.
> ∎

The kill in the opposite direction is available too, and it is the one class of
component that would have failed:

> **Lemma 4.4 (the only CARRIER-dead component class among the lines).** If a
> component `T ⊆ Lambda` had `lambda_T` constant, then `T` would be contained
> in a single line `l ⊂ X`, hence `T = l`; the exceptional divisor over it is
> `l x l ≅ P^1 x P^1`, `H^1 = 0`, no weight-one block occurs, and `T` would be
> **CARRIER-DEAD**. Block (F) of the verifier shows directly that this class is
> empty: at `p = 23, 61, 79, 109` every single `F_p`-point `x` of `Lambda` has
> `l_x ⊄ Bs(J)`. Since the base scheme is a proper complete intersection with
> constant Hilbert polynomial, it is **flat over `Z`**, so every component of
> the special fibre is the specialisation of a characteristic-zero component
> and a characteristic-zero line specialises to a line with the same constant
> line map. One witness therefore settles it in characteristic zero.

Sealed input that reinforces Theorem 4.3: `S` carries **no rational and no
elliptic curves** (`PLUECKER_REES_GRAPH.md`: the Albanese embedding excludes
rational curves; Roulleau's involution/elliptic-curve correspondence with "all
involutions of `G` have trace `1`" excludes elliptic ones), so `g(C_0) >= 2`
independently.

**Boxed carrier candidate.**

```
  T      = Lambda  ⊂  Bs(J_{phi_8}),  irreducible, G-invariant, deg 792
  H      = Stab_G(Lambda) = G                  (|H| = 660)
  j_0    = 0,   s = dim T = 1,   L = Q  (constant: the fibres of Gamma -> X
                                         over Lambda are the lines l_x = P^1)
  block  = IC_{Lambda-bar}(Q),  weight-one part  H^1(C̃_0),  C_0 = lambda(Lambda) ⊆ S
  datum  = V(-1) ↪ H^1(C̃_0),  forced by G-irreducibility of V and Alb(S) = J(X)
```

---

## 5. The decomposition, exactly

### 5.1 Reduced degree

Generic hyperplane slices, solved by msolve at three `(prime, seed)` pairs
`(1000003, 20260812)`, `(2000003, 777)`, `(1000033, 31337)`:

```
Bs(J) slice :  864 DISTINCT points     (elim. polynomial of degree 1080)
D_8   slice :   72 DISTINCT points     (matches the sealed deg D_8 = 72)
```

so `deg Bs(J)_red = 864` and `deg Lambda = 864 - 72 = 792`.

> **Proposition 5.1.** `D_8` occurs in the complete intersection with
> multiplicity exactly `6`, `Lambda` with multiplicity `1`, and
> `1224 = 6 · 72 + 792`.
>
> *Proof.* Lower bound `>= 6` structurally: at a general point of a component
> of `D_8` write `V_8 = lambda x + eps` with `lambda != 0` (the locus
> `V_8 = 0` is `60` points, §5.4) and `eps` the transverse part, vanishing
> exactly on `D_8`. Polarizing `F` and using `F(x) = 0` and
> `grad F(x) · V_8 = 0`,
> ```
> Q(x,V_8) = 3 B(x,eps,eps),        F(V_8) = lambda · Q(x,V_8) + F(eps),
> ```
> so locally `(F(V_8), Q) = (Q, F(eps))` with `Q` of order `2` and `F(eps)` of
> order `3` in `eps`. In a transverse two-dimensional slice two curve germs of
> multiplicities `2` and `3` meet with multiplicity `>= 6`. Hence
> `1224 >= 6·72 + deg Lambda_red = 432 + 792 = 1224`, forcing equality
> everywhere. ∎

### 5.2 `D_8` is irreducible and `G`-invariant, of degree 72

Factoring the eliminating polynomial of the `D_8` slice over `F_1000033` at
three seeds gives Frobenius orbits on the `72` slice points of sizes

```
{4, 18, 50},   {2, 70},   {2, 2, 68}
```

(the first reproduces the sealed `PHI8_DEGREE.md` §7 slice exactly). Take the
orbit of size `70`. Its points lie on a single Frobenius orbit `O` of
components, of size `s` and common degree `e`; every point orbit on `O` has
size divisible by `s`, so `s | 70`, and `s·e >= 70`. `O` lies inside one
`G`-orbit, of size `m` a subgroup index of `PSL(2,11)`. Those indices are
computed from scratch in verifier block (D) — all subgroups up to conjugacy,
via two-generator closures off one representative of each conjugacy class:

```
subgroup orders   1, 2, 3, 4, 5, 6, 10, 11, 12, 55, 60, 660
orbit sizes       1, 11, 12, 55, 60, 66, 110, 132, 165, 220, 330, 660
```

(the order-`4` Klein subgroup, hence the orbit size `165`, is easy to omit by
hand and is included here; the first draft of this packet omitted it and the
verifier caught it). With `m >= s` and `m·e <= 72`, enumerating leaves only
`s = m = 1`.

```
D_8 :  IRREDUCIBLE, G-INVARIANT, degree 72,  H = Stab_G(D_8) = G.
```

### 5.3 `Lambda` is irreducible and `G`-invariant, of degree 792

The same argument on the `Bs(J)` slice. Over `40` seeds at `p = 1000033` the
largest Frobenius orbit found is `787` (seed `1010`; seed `404` gives `753`,
seed `22` gives `721`). `787` is prime, `787 > 72` so the orbit lies inside
`Lambda`, and the enumeration `s | 787`, `s·e >= 787`, `m >= s`, `m·e <= 792`
leaves only `s = m = 1`, `e >= 787`. So `Lambda` has a `G`-invariant,
Frobenius-fixed irreducible component of degree `>= 787`, and the residual has
degree `<= 5`.

> **Lemma 5.2.** There is no `G`-invariant irreducible curve of degree `<= 5`
> in `P^4`. Hence the residual is empty and `Lambda` is irreducible of degree
> `792`.
>
> *Proof.* The smallest nontrivial `G`-orbit size is `11 > 5`, so every
> residual component is itself `G`-invariant. A `G`-invariant curve spans `P^4`
> (its span is a nonzero `G`-submodule of `W`, and `W` is irreducible), so it
> is nondegenerate; a nondegenerate curve of degree `d <= 5` in `P^4` has
> `h^0(O(1)) >= 5`, hence `d >= g + 4` by Riemann–Roch, so `g <= 1`. `G` acts
> faithfully on it (a pointwise-fixed curve would lie in the common fixed locus
> of an irreducible representation, which is empty; and `G` is simple, so the
> kernel is `1` or `G`), hence faithfully on its normalization. For `g = 0`
> that gives `PSL(2,11) ⊂ PGL_2(C)`, impossible — the finite subgroups of
> `PGL_2(C)` are cyclic, dihedral, `A_4`, `S_4`, `A_5`. For `g = 1` the
> automorphism group is `E ⋊ Z/n` with `n | 6`, and a simple nonabelian group
> of order `660` embeds in neither the abelian translation part nor `Z/6`. ∎

```
Lambda :  IRREDUCIBLE, G-INVARIANT, degree 792,  H = Stab_G(Lambda) = G.
```

### 5.4 The point stratum

The base scheme is a **proper complete intersection**, hence Cohen–Macaulay,
hence **unmixed**: `Bs(J_{phi_8})` has no isolated and no embedded points, and

```
Bs(J_{phi_8})_red  =  D_8  ∪  Lambda ,     72 + 792 = 864 .
```

Point supports of the decomposition theorem are nevertheless allowed at
individual points of that curve. The distinguished ones are the `60` points at
which `V_8` vanishes identically (`PHI8_DEGREE.md` §2). Recomputed here: over
`F_23` there are exactly `60`, they include the five coordinate points
`e_0, ..., e_4` (which lie on `X` because `F = sum x_i^2 x_{i+1}`), and
`60 = |G|/11`, so each stabiliser is a Sylow-`11` subgroup `C_11` — these are
exactly the fixed points of the twelve Sylow-`11` subgroups, five each. They
lie on `D_8`.

### 5.5 What is **not** computed

* the geometric genus and the isogeny decomposition of `Jac(D̃_8)` and of
  `Jac(Lambda~)`;
* the primary decomposition of the *degeneracy* scheme `(F) + I_2[x;V_8]`
  (whose extra zero-dimensional part of length `>= 75` is a feature of that
  ideal, not of `Bs(J)`);
* the fibres of `Gamma -> X` over `D_8` and over the `60` points;
* whether a strict-support block actually occurs on `D_8` or on the `60`
  points, in addition to the one on `Lambda`.

Two Macaulay2 `minimalPrimes` runs (on `D_8` and on `saturate(IL, mm)`) were
launched and did not terminate in `61` minutes at `3.2 GB` resident; the
decomposition above was obtained instead by the slice/Frobenius-orbit route,
which is exact and cheap. That is the exact blowup point for §5.5.

---

## 6. Per-orbit verdicts

| orbit | size | `H` | data | verdict |
|---|---:|---|---|---|
| `Lambda` (lines locus) | `1` | `G` | irreducible, `deg 792`, `lambda` nonconstant, `C_0 = lambda(Lambda) ⊆ S` `G`-invariant, `V(-1) ↪ H^1(C̃_0)` | **`CARRIER-CANDIDATE-BOXED`** — the `(AHS-Gamma)` datum is exhibited (Thm 4.3) |
| lines `l ⊂ X` with `lambda` constant | — | — | `H^1(l x l) = 0` | **`CARRIER-DEAD`** — and the class is **empty** (Lemma 4.4) |
| `D_8` (degeneracy curve) | `1` | `G` | irreducible, `deg 72`, multiplicity `6` in the CI | **`CARRIER-UNDECIDED`** — blowup point: `g(D̃_8)` and `Hom(Jac(D̃_8), E_{-11})` not computed; fibres of `Gamma -> X` over `D_8` not computed |
| the `60` points `{V_8 = 0}` | `60` | `C_11` | `Res_{C_11} V` = every nontrivial character of `C_11` once (`W_5` carries the residues `{1,3,4,5,9}`, `W̄_5` the nonresidues) | **`CARRIER-UNDECIDED`** — no character obstruction exists; consistent with the sealed `SUPPORT-ESCAPE-UNDECIDED` of `THEOREM_POINT_SUPPORT.md` |
| other point supports on `D_8 ∪ Lambda` | — | — | — | **`CARRIER-UNDECIDED`** |

Note that the two `UNDECIDED` rows are **not** blockers for any verdict in this
packet: Theorem 2.1 already establishes that a carrier exists, and Theorem 4.3
already exhibits the datum on one orbit. Excluding the remaining orbits would
sharpen the description of *which* support carries the block; it could never
produce `RETRACTION-BRANCH-DEAD`, because that would need **all** orbits to be
dead, which Theorem 2.1 forbids.

---

## 7. Consistency battery

**(a) No sealed statement asserts the retraction branch is nonempty, and none
depends on the provenance clause of Theorem 3.1.** The sealed retraction facts
(`THEOREM_DETECTION_PRINCIPLE.md` §3.3 table) are all conditional
(`phi_{A_0} = id_X => ...`, `D_X in |k H_X|`, `T = Hx + FQ`, `d >= 24`,
`d >= 35`, `delta = 1` is a norm). None is contradicted. `Corollary 4.3` of
`THEOREM_RESTRICTED_DICHOTOMY.md` — "`delta = 1` is a norm, so the norm sieve
never touches the retraction branch" — is *reinforced* here: `delta = 1`
means `phi = id_X`, `Gamma = X`, `e_exc = 0`, `r_phi = 0`, CLEAN, `1 = N(1)`.
Theorem 2.1 does not fire there, exactly as the sealed corollary says.

**(b) The claim chain is checked end to end, including the point stratum and
the nonreduced structure.** The chain of `PHI8_DEGREE.md` Corollary 6.2 was
`retraction nonempty => phi_8 CARRIER => some orbit carries the block`. This
packet shows the second and third links hold **without** the first, so the
chain carries no information about the first. Where a `kill` would have had to
cover every orbit "including the point supports and any embedded/non-reduced
structure", the situation is:

* *nonreduced structure*: `Bs(J_{phi_8})` is a proper complete intersection of
  type `(3,24,17)`, hence Cohen–Macaulay and unmixed. Its non-reducedness is
  entirely the multiplicity `6` along `D_8` (Prop 5.1). Strict supports of the
  decomposition theorem are reduced irreducible subvarieties of `Bs(J)`, so the
  multiplicity is irrelevant to the support list; the support list is
  `{D_8, Lambda}` together with points of `D_8 ∪ Lambda`;
* *point supports*: enumerated in §6, all `UNDECIDED`, and not killable by
  character arithmetic at the distinguished `60`-orbit.

**(c) The `E_{-11}` structure is re-derived from scratch and matches.** For
`25` primes `13 <= p <= 113`, exhaustive enumeration of `P^4(F_p)` gives
`Tr(Frob | H^3(X)) = 1 + p + p^2 + p^3 - |X(F_p)|` and

```
p ≢ 1 (mod 11)  =>  Tr = 0                      (all 21 such primes)
p ≡ 1 (mod 11)  =>  Tr = 5 p a_p,  4p = a_p^2 + 11 b^2
                    p = 23 :  a = -9   (4·23 = 81 + 11)
                    p = 67 :  a = +13  (4·67 = 169 + 99)
                    p = 89 :  a = -9   (4·89 = 81 + 275)
                    p = 199:  a = -20  (4·199 = 400 + 396)
```

This is the signature of a Hodge structure induced from `Q(zeta_11)` with
`E_{-11}` factors — an independent confirmation, computed from `F` alone, of
the `J(X) ~ E_{-11}^5` input on which the whole `(AHS-Gamma)` arithmetic test
rests. It is also a live falsification test of the sealed chain: had the counts
disagreed, `THEOREM_RESTRICTED_DICHOTOMY.md` §4 would have been in trouble.

**(d) The geometry confirms the theory's forced prediction.** Theorem 2.1 says
a carrier must exist. If the computation had returned `Bs(J_{phi_8}) = ∅`, or a
base scheme all of whose components demonstrably carry no `E_{-11}`, the sealed
chain (`delta = 208`, the dichotomy, `End = O_K`) would have been refuted.
Instead the base scheme is a curve of degree `1224` whose big component
`Lambda` carries the block by a forced argument (Thm 4.3). The chain passes.

**(e) Cross-checks against the sealed numbers.** `deg D_8 = 72` reproduced at
five primes; the sealed slice factorization `{4,18,50}` at `p = 1000033`
reproduced exactly; the `60` total-vanishing points over `F_23` reproduced
exactly, with `V_8 = 0` at the coordinate points; `deg F(V_8) = 24`,
`deg Q = 17`, `deg R = 25` reproduced over `Q`; `delta(phi_8) = 208` and
`delta(phi_9) = 288` not norms, re-checked by brute force.

**(f) The D12/realized-map tests do not apply here** — there is no realized
ambient tuple in this packet — and no attempt is made to invoke them.

---

## 8. Non-claims

* **`RETRACTION-BRANCH-DEAD` is not claimed, and is not obtainable by this
  route.** The exact scope of what *is* proved: the restricted CARRIER branch
  of `phi_8` (and of `phi_9`, and of every odd iterate) holds unconditionally,
  so the lever (S2) is void for those maps and for every `psi in Self` whose
  `delta` is not a norm. Nothing is claimed about whether `Land` contains a
  retraction. The landing table's `d' = 1` cell is **not** killed; it remains
  open at every ambient degree `d >= 35`, exactly as before this packet.
* No claim is made that `Lambda` is *the* support that `r_{phi_8}` actually
  hits, only that the `(AHS-Gamma)` datum is present on it and that Theorem 2.1
  forces some support to carry the block. `D_8` and the `60`-point orbit are
  `UNDECIDED`, not excluded.
* The strict-support block on `Lambda` is described through the ruled geometry
  of the exceptional divisor (Prop 4.2 and Lemma 4.1); the identification of
  `L` with the constant sheaf uses that the fibres of `Gamma -> X` over
  `Lambda` map onto the lines `l_x ≅ P^1`. The full decomposition-theorem
  bookkeeping for `Rpi_* IC_Gamma` — perverse degrees, multiplicities, and the
  precise simple constituents — is **not** carried out.
* `deg Lambda = 792` rests on the msolve slice at three `(prime, seed)` pairs
  together with the characteristic-zero multiplicity bound of Prop 5.1; the
  characteristic-zero slice itself (msolve over `Q`, degree `864`) was not run.
* Nothing here touches the **ambient** obstructions, which are where the
  retraction branch must now be attacked: the ambient `(AHS)` with supports in
  `Bs(J_ambient) ⊂ P^4` (`SUPPORT-ESCAPE-UNDECIDED`), the ambient-to-restricted
  transfer (`CLEAN-CASE-TRANSFER-UNDECIDED`), and (R1)/(R3)/(R6) of
  `THEOREM_DETECTION_PRINCIPLE.md` §4.2.
* `V_{10}` and beyond are untouched; so is the audit's (B3).

**Problem E headline: OPEN.**

