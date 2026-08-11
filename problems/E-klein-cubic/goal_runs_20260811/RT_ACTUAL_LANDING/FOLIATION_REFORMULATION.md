# The foliation lane

Exit: `FOLIATION-CLASSIFICATION-TARGET-REGISTERED`,
`COVARIANT-AND-DIVERGENCE-FREE-DIMENSIONS-EXACT`,
`LANDING-DEGREE-AT-LEAST-FOUR-PROVED`,
`DEGREE-FOUR-DIVERGENCE-FREE-COVARIANT-EXPLICIT`,
`TANGENCY-SURJECTIVITY-KILLS-THE-ISOLATED-DELTA-LANE`,
`SATURATED-FOLIATION-INVARIANT-UNDER-POSTCOMPOSITION-PROVED`,
`FOLIATION-QUOTIENT-CLASSIFICATION-REGISTERED`.

Sections 5–7 were added by the round-5 port; see `ADJUDICATION.md` items `R5-*`
and `THEOREM_SOURCE_TANGENCY.md`.

This file states the classification target, records the exact dimension
arithmetic that makes the first cases finite and small, scopes the first
computations, and connects to the algebraic-foliation literature without
borrowing anything from it.

**The lane is not new; the theorem is.** The repository already registered this
lane on the same day, from a *different* external source:
`theory/CONSTRAINT_ADDITIONS_20260811.md` item **C5, "Jacobian rank and the
kernel foliation — NEW-LANE"**, which states that dominance forces
`rank d[T] = 3` generically, that "the kernel of `d[T]` is a rank-one algebraic
foliation whose leaves are the fibers; it must be `G`-invariant, integrable,
singular along a `G`-stable determinantal scheme", and calls it "the biggest
genuinely new lane". What that entry does not have — and what
`THEOREM_FORCED_FOLIATION.md` supplies — is the **explicit generator** of that
kernel: a polynomial covariant `P_T` of pinned degree `2d-4`, obtained from the
adjugate by an exact division that needs primitivity, automatically
divergence-free, together with the exact dimensions of the space it lives in.
C5's own caution about the *saturated* line bundle is confirmed and sharpened
here (section (F4)): the saturation is genuinely lossy. Item **C4** of the same
ledger is the first line of the chain, `grad F(T) · J_T = 0`, our (5).

**This lane is not a proof strategy with a known ending.** It is a second
description of the same open problem. Its only advantage over the first
description is that its objects live in explicitly computable finite
dimensional `G`-modules whose smallest cases are one-dimensional.

---

## 1. The target

> **Classification target (FOL).** Determine the set of
>
> ```
> P in (Sym^{k} W^v (x) W)^G,   k = 2d-4,   P != 0,
> ```
>
> for which there exists a primitive `T in (Sym^d W^v ⊗ W)^G` with `F(T) = 0`
> and
>
> ```
> adj(J_T) = P grad F(T)^t,   J_T P = 0,   div P = 0.
> ```
>
> Equivalently: classify the `G`-invariant rank-one algebraically integrable
> foliations on `P^4` whose field of rational first integrals contains a copy of
> the function field of the Klein cubic, pulled back along a `G`-equivariant
> dominant map. Show the set is empty, or produce a member.

The three displayed conditions are necessary (Theorem 2.4 of
`THEOREM_FORCED_FOLIATION.md`); `div P = 0` and `J_T P = 0` are consequences of
the first, so the honest linear shadow of (FOL) — the part that can be searched
by linear algebra without knowing `T` — is

```
FOL_lin(k) := { P in (Sym^k W^v (x) W)^G : div P = 0 }.
```

Every landing tuple of degree `d` puts a nonzero element into `FOL_lin(2d-4)`.
So a proof that `FOL_lin(2d-4)` contains no admissible member for every `d`
proves the headline. Conversely `FOL_lin` being nonempty proves nothing.

**Why the reformulation is not free.** Recovering `T` from `P` is not addressed
anywhere, so (FOL) is not obviously easier than the original problem. What it
buys is that the ambient space is finite dimensional and computable in each
degree, and — see section 3 — very small at the bottom.

## 2. The exact dimension arithmetic

Let `I(k) = dim (Sym^k W^v)^G` (the invariant ring's Hilbert function) and
`C(k) = dim (Sym^k W^v ⊗ W)^G` (covariant five-tuples of degree `k`).

> **Lemma 2.1.** `div : (Sym^k W^v ⊗ W)^G -> (Sym^{k-1} W^v)^G` is a surjective
> `G`-map for every `k >= 1`, so
>
> ```
> dim FOL_lin(k) = C(k) - I(k-1).
> ```

*Proof.* `div` is the composite of `d` and the canonical contraction
`W^v ⊗ W -> C`, both `G`-maps, hence a `G`-map. For surjectivity let `f` be an
invariant of degree `k-1` and let `E = x` be the tautological covariant (the
Euler field, `C(1) = 1`). Then `f·E in (Sym^k W^v ⊗ W)^G` and

```
div(f x) = sum_j d/dx_j (f x_j) = (k-1) f + 5 f = (k+4) f,
```

nonzero in characteristic zero. ∎

`verify_covariant_dimensions.py` computes `I(k)` and `C(k)` exactly by
character theory over `Q(zeta_330)`, from the eigenvalue data of the eight
conjugacy classes of `PSL(2,11)` on `W` (`1A: (1^5)`, `2A: (1^3,(-1)^2)`,
`3A: (1, w_3^2, w_3^{2·2})`, `5A/5B:` all fifth roots once, `6A:` the sixth
roots other than `-1`... derived in the script by discrete Fourier from the
power-map character values, `11A: z^{QR}`, `11B: z^{NQR}`). It prints
`RESULT: PASS`, with an mpmath cross-check to 25 digits. The table has been
reproduced by a **second, independent implementation** written for this packet.

| k | I(k) | C(k) | dim FOL_lin(k) |
|---|---|---|---|
| 0 | 1 | 0 | 0 |
| 1 | 0 | 1 | 0 |
| 2 | 0 | 0 | 0 |
| 3 | 1 | 0 | 0 |
| **4** | 0 | **2** | **1** |
| 5 | 1 | 1 | 1 |
| **6** | 2 | **2** | **1** |
| 7 | 1 | 4 | 2 |
| **8** | 2 | **5** | **4** |
| 9 | 3 | 6 | 4 |
| **10** | 3 | **10** | **7** |
| 11 | 4 | 12 | 9 |
| **12** | 6 | **16** | **12** |
| 13 | 5 | 21 | 15 |
| **14** | 8 | **26** | **21** |
| 15 | 10 | 32 | 24 |
| **16** | 10 | **41** | **31** |
| 17 | 13 | 49 | 39 |
| 18 | 17 | 59 | 46 |
| 19 | 17 | 73 | 56 |
| 20 | 22 | 86 | 69 |
| 21 | 26 | 100 | 78 |
| 22 | 28 | 121 | 95 |
| 23 | 33 | 140 | 112 |
| 24 | 40 | 161 | 128 |

Bold rows are the even degrees `k = 2d-4`, the only ones a forced foliation can
occupy: `2d-4` is always even, so **the forced foliation always has even
degree**, and half the table is inaccessible to it.

*Convention is not load-bearing.* `W` and `W^v` are the two distinct
five-dimensional irreducibles of `PSL(2,11)` and are complex conjugates, so it
is worth saying explicitly that the table does not depend on which is called
which: swapping them replaces every entry by its complex conjugate, and the
entries are integers. Concretely, the model has `tau : x_i |-> z^{(-2)^i} x_i`
acting on the *coordinates*, so the coordinate span carries the quadratic-residue
exponents; the computation uses that assignment, and the transposed one gives
the same table.

Consistency notes. `I(3) = 1` is the Klein cubic. `C(1) = 1` is the tautological
covariant `x`. `I(5) = 1`, `I(6) = 2`, `I(7) = 1` are consistent with the frame
`(x, C, D, E, K_7)` named in the sealed all-degree packet
(`goal_runs_after_35fa/G_UNIVERSAL/ALL_DEGREE_THEOREM.md`), which carries a
degree-seven invariant `K_7`; no identification is claimed here.

> **Corollary 2.2 (`LANDING-DEGREE-AT-LEAST-FOUR-PROVED`).** `C(2) = C(3) = 0`,
> so there is no `G`-covariant five-tuple at all in degrees 2 and 3, and
> `C(1) = 1` is spanned by `x`, for which `F(x) = F != 0`. Hence every landing
> tuple has `d >= 4`, and every forced foliation has `k = 2d-4 >= 4`.

This is weaker than the sealed branch-specific floors (`d >= 6` and `d >= 24`
in the retraction branch,
`RETRACTION_DEGREE_BOUND.md`/`DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24`),
which govern where they apply; Corollary 2.2 is the floor that holds for **all**
landing tuples with no branch hypothesis, and it comes from nothing but the
character table.

## 3. The first computations, scoped

The reason to open this lane at all is the left-hand end of the table.

**(F1) `d = 4`: `dim FOL_lin(4) = 1`.** If a landing tuple of degree `4` exists,
its forced foliation is, up to scalar, the **unique** divergence-free covariant
of degree four. That object is now written down. Normalized to be primitive, and
**defined over `Q`**:

```
D_4 = ( 2x3^4 + 8x1x2x4^2 - x0x3^2x4 - 9x0x2^2x3 + 7x0x1^2x2 + 3x0^2x4^2 - x0^3x1 ,
        2x4^4 - 9x1x3^2x4 + 7x1x2^2x3 - x1^3x2 - x0x1x4^2 + 8x0^2x2x3 + 3x0^2x1^2 ,
        7x2x3^2x4 - x2^3x3 + 8x1^2x3x4 + 3x1^2x2^2 - 9x0x2x4^2 - x0^2x1x2 + 2x0^4 ,
        -x3^3x4 + 3x2^2x3^2 - x1^2x2x3 + 2x1^4 + 7x0x3x4^2 + 8x0x2^2x4 - 9x0^2x1x3 ,
        3x3^2x4^2 - x2^2x3x4 + 2x2^4 - 9x1^2x2x4 - x0x4^3 + 8x0x1x3^2 + 7x0^2x1x4 )
```

Seven terms per component; the components are the cyclic shifts of the first, as
they must be. The other basis vector of `Cov_4` is `F·x`, with
`div(F x) = 8F != 0`, so the splitting of the two-dimensional `Cov_4` into
`ker(div)` and its complement is clean, and `D_4` is not a multiple of the
Euler field.

`verify_low_degree_covariants.py` produces it, over `Q(zeta_11)`, by taking the
joint kernel of `rho_k(g) - Id` over the three generators
`sigma` (cyclic shift), `tau = diag(z^{(-2)^i})` and the involution `iota`
reused from the repository's own
`goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/exact_schur_frame/exact_representation_core.py`.
That script independently reproduces the whole table above for `k <= 8` —
`Cov: 1,0,0,2,1,2,4,5` and `divergence-free: 0,0,0,1,1,1,2,4` — by explicit
representation theory rather than character arithmetic, and enumerates the group
to confirm `|<sigma,tau,iota>| = 660`. It also returns the unique
divergence-free element of `Cov_6` (`D_6`, 70 terms, likewise over `Q`).

`verify_d4_covariant.py` then audits `D_4` by a separate arithmetic path,
including covariance under `iota` — the generator that actually cuts `Cov_4`
from `7` to `2` — with `iota` rebuilt from the repository formula rather than
imported, and `Q(zeta_11)` implemented as `Q[z]/(z^11-1)` with the relation
`1+z+...+z^10 = 0`, sharing no code with the producer.

**What is still open at (F1)**: whether the rank-one foliation defined by `D_4`
has a `G`-equivariant dominant first-integral map to `X`. That is a finite
question about one named vector field, and it is **not** answered here. Nothing
above bears on it.

**(F2) `d = 5`: `dim FOL_lin(6) = 1`.** Same, one degree up.

**(F3) `d = 6, 7`: `dim FOL_lin(8) = 4`, `dim FOL_lin(10) = 7`.** Still small
enough for an exhaustive treatment of the linear shadow.

**(F4) The saturation caveat.** By `THEOREM_FORCED_FOLIATION.md` §3, `P_T` need
not be primitive: in the packet's exact witness `deg P_T = 10` while the
saturated foliation has degree `2`. So (F1)–(F3) must interrogate the covariant
`P`, not the saturated foliation, and a search that normalizes to primitive
fields will miss members.

**(F5) The condition that is not linear.** `FOL_lin` ignores `adj(J_T) = P Q^t`.
Membership of `FOL_lin` is necessary and very far from sufficient — the same
gap as everywhere else in this problem. A negative answer at (F1) would exclude
`d = 4` only; it would not touch any other degree.

## 4. Sources note — the algebraic-foliation literature

Recorded as orientation. **Nothing below is used in any proof in this packet,
and no claim is made that any of it applies to (FOL).** The connections are
stated as questions, not as inputs. See `SOURCES.md` section E for the full
citations.

* **Darboux and Jouanolou.** The classical theory of algebraic first integrals
  of polynomial vector fields; Jouanolou's theorem that a generic foliation of
  degree `>= 2` on `P^2` has no algebraic invariant curve. Relevance: our
  foliations are the extreme opposite — they are *algebraically integrable*,
  with a four-dimensional worth of first integrals. Whether the equivariant
  constraint is compatible with full integrability is not addressed by that
  literature.
* **The Poincaré problem** (Poincaré 1891): bound the degree of an invariant
  algebraic curve, or of an algebraic first integral, in terms of the degree of
  the foliation. Carnicer settled the non-dicritical case on `P^2`; Cerveau–Lins
  Neto gave bounds under hypotheses on the singularities. Relevance: (FOL) has
  the shape of a Poincaré problem run **backwards** — the first integrals are
  prescribed (a cubic threefold's function field) and the foliation degree is
  what is constrained (`2d-4`). We are not aware of a Poincaré-type bound in
  `P^4` in a form that applies, and we assert none.
* **Cerveau–Lins Neto's classification of degree-two foliations on `P^n`,
  `n >= 3`** (irreducible components of the space of codimension-one
  foliations). Relevance: only by analogy — ours are **rank one**, not
  codimension one, and rank-one foliations on `P^4` are codimension three.
  The analogy should not be pushed.
* **Foliations with algebraic first integrals / trivial canonical class**
  (Loray–Pereira–Touzet and successors). Relevance: a possible source of
  structure theory for the *saturated* foliation of section (F4), whose degree
  is unknown.
* **Jacobian derivations** (Nowicki and the polynomial-derivation literature).
  Relevance: direct. `P_T` is a Jacobian derivation divided by `Q_{T,j}`, and
  the divergence-freeness is Piola's identity, both classical. The equivariance
  and the degree drop are what is not classical.

The honest summary of the literature position: the constructed object is a
natural one and there is a developed theory of such objects, but no theorem is
known to us that takes a `G`-invariant divergence-free rank-one foliation on
`P^4` and decides whether its first-integral field can be that of a Klein
cubic. This lane is open work, not a citation away from closing.

## 5. The divergence splitting, and why the tangency invariant alone is empty

`div : (Sym^m W^v ⊗ W)^G -> (Sym^{m-1} W^v)^G` is surjective and **split**, by
`f |-> f·x/(m+4)` (Lemma 2.1 above, read as a splitting). At `d = 35`,
`m = 2d-4 = 66`, and the exact dimensions are

```
C(66) = 6992,   I(65) = 1357,   dim ker(div)^G = 5635,
```

recomputed in `verify_d35_dimensions.py`. Divergence-freeness alone is
therefore far too weak to be an obstruction, which is the source's (50) and is
confirmed.

Stronger, and worth stating because it closes a lane rather than measuring one:

> **Proposition 5.1.** For every `m >= 4` the map
> ```
> ker(div)^G ∩ (Sym^m W^v ⊗ W)^G  -->  H^0(X, O_X(m+2))^G,
> P |-> grad F · P  (mod F),
> ```
> is **surjective**. So the source-tangency invariant `Delta`, considered as an
> object in its own right and detached from any `T`, imposes no condition at
> all.

*Proof.* The Jacobian ideal `J = (F_0,...,F_4)` of the smooth Klein cubic is a
complete intersection of five quadrics with socle degree `5`, so `J_n = S_n`
for every `n >= 6` (`JACOBIAN-SOCLE-DEGREE-FIVE-EXACT`, re-verified in
`forced_foliation_witness.m2`). Hence for `m >= 4` the map
`(Sym^m W^v ⊗ W) -> S_{m+2}`, `P |-> grad F · P`, is surjective; it is a
`G`-map, and taking `G`-invariants is exact in characteristic zero, so it is
surjective on invariants; composing with the surjection
`(S_{m+2})^G -> H^0(X,O_X(m+2))^G` keeps surjectivity. Finally correct `P` to
be divergence-free without changing the image: put
`P' = P - (div P/(m+4))·x`. Then `div P' = 0` by the splitting computation, and
`grad F · P' = grad F·P - (div P/(m+4))·3F ≡ grad F·P (mod F)` by Euler. ∎

What is restrictive is therefore not `Delta` and not `div P = 0`, but the
**simultaneous coupling** `adj(J_T) = P_T grad F(T)^t` together with
`Delta_T|_X = (d/d')H^2 j_phi` for one and the same `T` — the source's (51).
See `BOXED_GLOBAL_COVARIANT.md` §(54) for the assembled statement.

## 6. The foliation quotient, and the postcomposition caveat resolved

Let `K = C(P^4)` and `L = T^*C(X) ⊂ K`. `D_{P_T}` kills `L`
(`LANDING-COORDINATES-ARE-FIRST-INTEGRALS-PROVED`), `trdeg L = 3`, and a
rank-one foliation on a `4`-fold has constant field of transcendence degree
`3`, so the constant field of `D_{P_T}` is algebraic over `L`. Its relative
algebraic closure `L^{alg} ⊂ K` defines a normal `G`-threefold `Y_T` and a
factorization

```
P^4 --> Y_T --rho_T--> X                                            (32)
```

with the first map having geometrically connected generic leaves and `rho_T`
finite. So a landing tuple is classified by: a `G`-invariant algebraically
integrable rank-one foliation on `P^4`; its normal leaf quotient `Y_T`; a
finite `G`-equivariant `Y_T -> X`; and a homogeneous realisation of the
composite by one tuple.

> **Proposition 6.1 (postcomposition invariance).** Let `psi : X --> X` be a
> dominant generically finite `G`-selfmap, represented by ambient forms `Psi`.
> Then, generically on `P^4`,
> ```
> ker d(Psi o T) = ker dT,
> ```
> so the **saturated** kernel foliation is unchanged; only the unsaturated
> generator changes, by `P_{Psi o T} = a · P_T` for a form `a` of degree
> `2d(deg Psi - 1)`.

*Proof.* `J_{Psi o T}(x) = J_Psi(T(x)) J_T(x)`, so
`ker J_{Psi o T} = J_T^{-1}(ker J_Psi ∩ im J_T)`. Now
`im J_T(x) = ker Q_T^t = T_y C(X)` with `y = T(x)`, and
`J_Psi(y)|_{T_yC(X)}` is the derivative of the cone selfmap `psi~` at `y`,
whose determinant is nonzero at the generic point because `psi` is dominant
generically finite and the characteristic is zero. So
`ker J_Psi(y) ∩ T_yC(X) = 0` generically and the two kernels coincide. The
degree statement follows by comparing `deg P_{Psi o T} = 2(d·deg Psi)-4` with
`deg P_T = 2d-4`. ∎

This resolves the repository's postcomposition caveat
(`theory/CONSTRAINT_ADDITIONS_20260811.md`, item **C12**: "All classifications
… must be stated up to postcomposition"). A classification by **saturated**
foliations automatically quotients the infinite postcomposition semigroup, so
C12 is not an obstruction to a finite all-degree profile classification *in this
lane*; it remains one in every lane indexed by the tuple itself.

**A near-miss to keep straight.** Rescaling `T |-> h·T` by an ambient form is
**not** postcomposition, and it genuinely does change the cone-level foliation:
`J(hT) = h J_T + T (grad h)^t`, and block (C1) of `verify_forced_foliation.py`
exhibits `P_{hT} != h P_T`. Proposition 6.1 does not contradict that observation
and does not extend to it.

## 7. Two scope corrections carried over from round 5

1. **Interpolation does not preserve the nonlinear conditions.** Theorem 1.1 of
   `INTERPOLATION_THEOREM.md` applies to a section on one fixed `G`-stable
   closed subscheme. It does **not** preserve `F(T) = 0`, primitivity,
   dominance, `rank J_T = 4`, `I_4(J_T) = I_P I_Q`, an exact normalized Rees
   algebra, an exact integral-closure type, or `Delta_T|_X = H^2 j_phi`. This
   is already §3.4 and §5 of that file; the round-5 source states it
   independently and it is confirmed.
2. **The line `O(5-2d) -> T_{P^4}` need not be saturated.** Already recorded as
   `THEOREM_FORCED_FOLIATION.md` §3 and (F4) above, with the packet's exact
   witness (`deg P_T = 10`, content `8`, saturated degree `2`) showing it is not
   a corner case. `BASE_GRADIENT_PACKAGE.md` §5 adds what the saturation
   carries: `a_T = gcd(P_T)` is a `G`-invariant of degree `0` or `>= 5` whose
   every irreducible factor is a Darboux hypersurface of the saturated
   foliation.

## 8. Non-claims

* `D_4` is **not** a landing foliation. It is the unique candidate the linear
  shadow permits at `d = 4`; whether it is realised is (F1), and (F1) is open.
* No member of (FOL) is exhibited, and none is excluded.
* `dim FOL_lin(k) = C(k) - I(k-1)` is exact and proved; it is a dimension count
  of a **necessary** linear condition and bounds nothing about landing tuples
  by itself.
* Corollary 2.2 (`d >= 4`) is the only new constraint on landing degrees in
  this file, and it is weaker than the branch-specific sealed floors wherever
  those apply.
* The literature pointers in section 4 are orientation only.
* Proposition 5.1 is a **negative** result: it says the tangency invariant on
  its own is unobstructed. It is not evidence that a coupled package exists.
* Proposition 6.1 quotients the postcomposition semigroup **in this lane only**.
  It does not make the classification of saturated foliations finite, and it
  says nothing about precomposition or about rescaling `T |-> hT`.
* `Y_T` in (32) is constructed as a normal model of a function field; nothing
  is claimed about its singularities, its rationality, or `rho_T`'s degree.

**Problem E headline: OPEN.**
