# The foliation forced by a landing tuple

Exits: `GLOBAL-JACOBIAN-ADJUGATE-FACTORIZATION-PROVED`,
`FORCED-DIVERGENCE-FREE-COVARIANT-DEGREE-2D-MINUS-4-PROVED`,
`LANDING-COORDINATES-ARE-FIRST-INTEGRALS-PROVED`,
`FORCED-FOLIATION-WITNESS-EXACT`,
`FORCED-FOLIATION-CONDITIONS-CONSISTENT-NON-EQUIVARIANTLY`.

Provenance: external round 4, sections 2–3 (unaudited). Verdict:
**CONFIRMED WITH SUPPLIED PROOFS** — the source compresses the content /
primitivity step, which is the only step that is not formal, and asserts the
saturation of (14), which is false. Both are repaired below. Everything is
verified exactly: `forced_foliation_witness.m2` (`RESULT: PASS`, Macaulay2,
symbolic over `Q`) and `verify_forced_foliation.py` (`RESULT: PASS`, 46 exact
checks, sympy).

---

## 1. Setting

`G = PSL(2,11)` acts on the five-dimensional Klein representation `W`;
`F in Sym^3 W^v` is the Klein cubic, `X = V(F) ⊂ P(W)` smooth.
`R = C[x_0,...,x_4] = Sym(W^v)`.

A **landing tuple** is a nonzero `T in (Sym^d W^v ⊗ W)^G` with `F(T) = 0`;
it is **primitive** if `gcd(T_0,...,T_4) = 1`. Write

```
J_T = ( dT_i / dx_j )_{i,j}      (5 x 5, entries of degree d-1)
Q_T = grad F (T)                 (column, entries F_i(T) of degree 2d)
```

**Dominance is automatic.** By the sealed all-degree theorem
(`goal_runs_after_35fa/G_UNIVERSAL/ALL_DEGREE_THEOREM.md`,
`G2-FINITE-GENERATION-PASS`) a landing covariant is the same datum as a
`G`-equivariant rational map `P(W) --> X`, and by
`goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/DOMINANCE_BRIDGE.md`
(`G3-DOMINANCE-AUTOMATIC`, `G3A-ARITHMETIC-DOMINANCE-PASS`) that map is
automatically dominant, with no separate Jacobian-rank-four gate. *Audit note:*
that bridge's step 6 is an `ACCEPTED_INPUT`, namely `ed_C(G) >= 3` (Beauville);
so "dominant" below is conditional on exactly that one accepted citation and on
nothing else. Consequently `J_T` has generic rank `4`.

## 2. The chain

### 2.1 Chain rule

Differentiating `F(T(x)) = 0`:

```
Q_T^t J_T = 0.                                                      (5)
```

So `Q_T^t` lies in the left kernel of `J_T` at every point, and
`rank J_T <= 4` wherever `Q_T != 0`.

### 2.2 The pulled-back gradient is primitive

> **Lemma 2.1.** If `T` is primitive then `gcd(F_0(T),...,F_4(T)) = 1`; in
> particular `Q_T != 0`.

*Proof.* Suppose an irreducible `h in R` divides every `F_i(T)`. On the
irreducible hypersurface `V(h) ⊂ A^5` all five partials of `F` vanish at
`T(x)`, i.e. `T(V(h))` lies in the common zero locus of `F_0,...,F_4`. `X` is
smooth, so that locus is the origin of `A^5`. Hence `T` vanishes identically on
`V(h)`, so `h | T_i` for every `i`, contradicting primitivity. The same argument
with `h` replaced by `1` gives `Q_T != 0`: if all `F_i(T) = 0` identically then
`T ≡ 0`. ∎

Smoothness of `X` is used exactly here, and nowhere else in this file.

### 2.3 Rank-one adjugate, and the content step

`det J_T = 0` identically (the image lies in the cubic cone), so
`J_T adj(J_T) = adj(J_T) J_T = 0`. Generic rank `4` gives generic rank `1` for
`adj(J_T)`, and `adj(J_T) != 0`.

> **Lemma 2.2 (adjugate factorization).** Let `T` be a primitive landing tuple
> with `J_T` of generic rank `4`. Then there is a **unique** vector
> `P_T in R^5` of polynomials with
>
> ```
> adj(J_T) = P_T Q_T^t ,                                            (6)
> ```
>
> and `P_T != 0`.

*Proof.* Work in `K = Frac(R)`. Over `K` the matrix `J_T` has rank `4`, so its
left kernel is one-dimensional; by (5) it is spanned by `Q_T^t` (which is
nonzero by Lemma 2.1). Every row of `adj(J_T)` lies in that left kernel, since
`adj(J_T) J_T = 0`. Hence there are `p_i in K` with row `i` of `adj(J_T)` equal
to `p_i Q_T^t`, i.e. (6) holds with `P_T = (p_i) in K^5`.

*Polynomiality — the content step.* Fix `i` and write `p_i = A/B` in lowest
terms in the UFD `R` (so `gcd(A,B) = 1`). For every `j`,
`p_i F_j(T) = adj(J_T)_{ij} in R`, i.e. `B | A F_j(T)`, hence `B | F_j(T)`.
Thus `B` divides `gcd_j F_j(T) = 1` by Lemma 2.1, so `B` is a unit and
`p_i in R`.

*Uniqueness.* If `P Q_T^t = P' Q_T^t` then `(p_i - p'_i) F_j(T) = 0` for all
`i,j`; `R` is a domain and some `F_j(T) != 0`, so `P = P'`. Nonvanishing of
`P_T` follows from `adj(J_T) != 0`. ∎

The content step is what the source compresses to "with (5) and `Q_T`
primitive there is a unique polynomial vector". It is not formal: without
primitivity of `Q_T` the conclusion genuinely fails at the level at which it is
applied. `verify_forced_foliation.py` block (C2) exhibits an explicit
**polynomial** rank-one matrix `M = [[x0x1, x1^2],[x0^2, x0x1]] = P Q^t` with
`Q = (x_0^2, x_0x_1)` non-primitive and `P = (x_1/x_0, 1)` not polynomial.

*Honest counter-observation (block C1).* Non-primitivity of `Q_T` is **not** by
itself an obstruction: rescaling a tuple by a form, `T' = h T`, makes `Q_{T'}`
non-primitive (content `h^{deg F - 1}`) and yet `P_{T'}` stays polynomial. So
Lemma 2.2's hypothesis is sufficient, not necessary. Recorded because the
source's phrasing invites the opposite reading. Block C1 also records that
`P_{T'} != h P_T`: rescaling changes the **cone-level** fibration, since
`J(hT) = h J_T + T (grad h)^t`, hence changes the foliation even though the
projective map is unchanged. The object below is attached to the cone map.

### 2.4 Degrees

Entries of `adj(J_T)` are `4x4` minors of forms of degree `d-1`, so of degree
`4(d-1)`; entries of `Q_T` have degree `2d`. Therefore

```
deg P_T = 4(d-1) - 2d = 2d - 4.                                     (7)
```

In general, for a smooth hypersurface of degree `e` in `P^{n-1}` and a
primitive dominant tuple of degree `d`, the same argument gives
`deg P = (n-1)(d-1) - (e-1)d`. The verifier checks the case
`n = 3, e = 2, d = 4` (`deg P = 2`) symbolically and the case
`n = 5, e = 3, d = 7` (`deg P = 10`) in Macaulay2.

### 2.5 Right kernel

From `J_T adj(J_T) = 0` and (6): `(J_T P_T) Q_T^t = 0`, so
`(J_T P_T)_i F_j(T) = 0` for all `i,j`, and since some `F_j(T) != 0` in the
domain `R`,

```
J_T P_T = 0.                                                        (8)
```

### 2.6 Equivariance

> **Proposition 2.3.** Let `chi` be the character by which `G` acts on `F`
> (`F(gy) = chi(g) F(y)`). Then
>
> ```
> P_T(gx) = chi(g)^{-1} g P_T(x)   for all g in G.                  (9)
> ```
>
> Since `G = PSL(2,11)` is perfect, `chi = 1` and `P_T` is an honest
> `G`-covariant: `P_T in (Sym^{2d-4} W^v ⊗ W)^G`.

*Proof.* Differentiating `T(gx) = g T(x)` gives `J_T(gx) g = g J_T(x)`, i.e.
`J_T(gx) = g J_T(x) g^{-1}`. Differentiating `F(gy) = chi(g) F(y)` gives
`grad F(gy) = chi(g) g^{-t} grad F(y)`, hence
`Q_T(gx) = chi(g) g^{-t} Q_T(x)`. For the adjugate, `adj(AB) = adj(B) adj(A)`
and `adj(g) = det(g) g^{-1}` give

```
adj(g J g^{-1}) = adj(g^{-1}) adj(J) adj(g) = g adj(J) g^{-1},
```

the two determinant factors cancelling. Comparing (6) at `gx` and at `x`:

```
P_T(gx) Q_T(gx)^t = adj(J_T)(gx) = g adj(J_T)(x) g^{-1}
                  = g P_T(x) Q_T(x)^t g^{-1},
P_T(gx) chi(g) Q_T(x)^t g^{-1} = g P_T(x) Q_T(x)^t g^{-1}.
```

Cancelling `g^{-1}` and using `Q_T != 0` entrywise in the domain `R` gives
`chi(g) P_T(gx) = g P_T(x)`, which is (9). ∎

The determinant cancellation and the character are both verified exactly:
block (B1) checks `adj(gJg^{-1}) = g adj(J) g^{-1}` symbolically for a
`3x3` `J` with an integer `g` of determinant `13` (so the cancellation is a
real cancellation, not a `det g = 1` accident), and block (B1') on exact
`5x5` integer data. Blocks (9a)–(9e) run the **whole chain on a genuinely
equivariant instance with a nontrivial character**: a `mu_3`-covariant tuple
landing on a conic that is only semi-invariant (`chi = w^2`). There `P_T`
satisfies (9) with `chi != 1` and **fails** `P_T(gx) = g P_T(x)`. So the
appeal to perfectness of `G` is not decoration; it is what makes `P_T` a
covariant rather than a twisted covariant.

### 2.7 First integrals

Let `D_{P_T} = sum_j (P_T)_j d/dx_j`. Then `D_{P_T}(T_i) = (J_T P_T)_i`, so (8)
says

```
D_{P_T}(T_i) = 0,  i = 0,...,4.                                     (10)
```

All five landing coordinates — hence every rational function pulled back from
`X` — are first integrals of the single vector field `P_T`. By the chain rule
the five `F_i(T)` are first integrals too.

### 2.8 Piola, and divergence-freeness

The Piola identity: for any polynomial map, the rows of the cofactor matrix are
divergence-free,

```
sum_j d/dx_j cof(J_T)_{ij} = 0   for every i,                       (11)
```

where `cof(J_T)_{ij} = d det(J_T) / d (dT_i/dx_j)` and `cof(J_T) = adj(J_T)^t`.
By (6), `cof(J_T)_{ij} = F_i(T) (P_T)_j`, so (11) reads

```
F_i(T) div(P_T) + D_{P_T}(F_i(T)) = 0.
```

The second term vanishes by (10) and the chain rule, and some `F_i(T) != 0`, so

```
div(P_T) = 0.                                                       (12)
```

`verify_forced_foliation.py` block (B3) checks (11) symbolically for generic
polynomial maps in `n = 3` and `n = 4`, i.e. with no landing hypothesis at all,
confirming that (11) is a general identity and (12) is what the landing
hypothesis converts it into.

### 2.9 The theorem

> **Theorem 2.4.** Every primitive landing tuple `T` of degree `d` forces a
> nonzero
>
> ```
> P_T in (Sym^{2d-4} W^v (x) W)^G       with
> adj(J_T) = P_T grad F(T)^t,   J_T P_T = 0,   div P_T = 0,         (13)
> ```
>
> and the five coordinates `T_i` are first integrals of `D_{P_T}`. Equivalently
> `P_T` defines a `G`-invariant rank-one algebraically integrable foliation on
> `P^4`, given by a map
>
> ```
> O(5-2d) --> T_{P^4},                                              (14)
> ```
>
> whose field of rational first integrals contains a copy of the function field
> of the Klein cubic.

## 3. A correction to (14): `P_T` need not be primitive

The source presents (14) as if `O(5-2d)` were the foliation's canonical
(saturated) line bundle. It is not. `P_T` can have a nontrivial content
`g = gcd((P_T)_0,...,(P_T)_4)`, and then the honest saturated statement is

```
O(1 - (2d-4-deg g)) --> T_{P^4},
```

with (14) the unsaturated version of it. In the exact witness of section 4 this
is not a corner case: `deg P_T = 10` while `deg g = 8`, so the actual foliation
has degree `2`, not `10`. What the theorem forces is therefore

* a **covariant** of degree exactly `2d-4` satisfying (13) — this is exact; and
* a foliation of degree `2d-4-deg g` for some `0 <= deg g <= 2d-5`.

The classification target in `FOLIATION_REFORMULATION.md` is stated for the
covariant, where the degree is pinned, and not for the saturated foliation,
where it is not.

## 4. The exact worked instance

`forced_foliation_witness.m2`, Macaulay2, symbolic over `Q` throughout. No
random points except one exact rational point used for a rank lower bound, and
no floating point.

**The target.** `F = Y_2^3 + 3Y_2Y_0^2 + Y_3^3 + 3Y_3Y_1^2 + 4Y_4^3` in `P^4`.
The script re-proves smoothness from the partials (`dim = 0`, `codim = 5`), so
nothing depends on knowing that this is the Fermat cubic threefold in the
coordinates `Y_0 = y_0-y_1, Y_1 = y_2-y_3, Y_2 = y_0+y_1, Y_3 = y_2+y_3,
Y_4 = y_4`, in which `F = 4 sum y_i^3`.

**The tuple.** The classical Segre construction. `L = {Y_2=Y_3=Y_4=0}` lies on
`F`; projection from `L` presents `F` as the conic bundle
`3z_0Y_0^2 + 3z_1Y_1^2 + C(z)t^2` over `z in P^2`, with
`C = z_0^3+z_1^3+4z_2^3` and the `P^4`-point `(Y_0,Y_1,tz_0,tz_1,tz_2)`. Over
the rational surface `{z_0u^2 + z_1v^2 = 0}` the conic acquires the rational
point `p = (u:v:0)`, and the second intersection of the line `pq` with the
conic is `Phi(q)p - 2B(p,q)q`. Substituting

```
u = x_0,  v = x_1,  z = (x_1^2, -x_0^2, x_2^2),  q = (x_3^2, x_4^2, 1)
```

gives a homogeneous tuple `T` of degree `d = 7` in `Q[x_0,...,x_4]`.

**Verified, all symbolically:**

| claim | result |
|---|---|
| `T` homogeneous of degree `7`, `F(T) = 0` identically | ok |
| `T` primitive, `gcd(T_i) = 1` | ok |
| `deg J_T = 6`, `deg Q_T = 14`, chain rule `Q_T^t J_T = 0`, `det J_T = 0` | ok |
| dominance: `rank J_T = 4` at the exact point `(2,3,5,7,11)` | ok |
| `Q_T` primitive (Lemma 2.1 on a live example) | ok |
| `adj(J_T) J_T = adj(J_T) != 0`, entries of degree `24 = 4(d-1)` | ok |
| the division `adj(J_T)_{i,j}/Q_{T,j}` is exact, for every `j` | ok |
| `deg P_T = 10 = 2d-4` | ok |
| (6) `adj(J_T) = P_T Q_T^t`, all 25 entries | ok |
| uniqueness: all five columns give the same `P_T` | ok |
| (8) `J_T P_T = 0`; (10) `D_{P_T}(T_i) = 0` and `D_{P_T}(F_i(T)) = 0` | ok |
| (11) Piola for `J_T`; (12) `div P_T = 0` | ok |
| the leaves are not a pencil of lines through a fixed centre | ok |
| fibre dimension `5 - 4 = 1`: the foliation has rank one | ok |

**The explicit foliation.** The witness's `P_T` factors as

```
P_T = 336 * x_0^2 x_1^2 x_2 (x_1x_3^2 - x_0x_4^2) * ( 0, 0, 0, x_0x_4, x_1x_3 ),
```

so the content has degree `8` and the saturated foliation is the degree-two
field `x_0x_4 d/dx_3 + x_1x_3 d/dx_4`, which is again divergence-free and again
kills all five `T_i`. This matches the construction: the fibre direction is the
reparametrization `(x_3^2, x_4^2) -> (x_3^2 + k x_0, x_4^2 + k x_1)` of the
auxiliary point `q`, whose tangent is `(x_0/x_3 : x_1/x_4) ∝ (x_0x_4 : x_1x_3)`.

## 5. What the witness proves, and what it does not

> **Corollary 5.1 (consistency).** The system (5)–(13) — chain rule, rank-four
> Jacobian, rank-one adjugate, a polynomial right-kernel vector of degree
> `2d-4`, all coordinates first integrals, divergence-free — is **satisfiable**
> by an honest primitive dominant tuple landing on a smooth cubic threefold in
> `P^4`.

So no argument can derive a contradiction from (5)–(13) alone. Any exclusion
must use the `G`-equivariance (9), or the specific `G`-module
`(Sym^{2d-4}W^v ⊗ W)^G`, or the Klein `F` itself. This is the same lesson as
`REFUTATION_POINTED_CURVE_EXCLUSION.md` and the `O4` witness, in a new place:
the structure is real, and the structure alone is not an obstruction. It also
confirms the source's own section 5(b) — nonequivariant polynomial unirational
parametrizations of cubic threefolds exhibit exactly this structure — with an
exact example rather than an assertion.

**The first-integral field is not a paradox.** "The first integrals contain the
Klein cubic function field" sounds like a contradiction only if one forgets
that cubic threefolds *are* unirational; the witness is precisely such a
parametrization, and its first-integral field contains the function field of a
smooth cubic threefold. The entire content of Theorem 2.4 beyond the classical
is the word **`G`-invariant**.

## 6. What is classical here

`P_T` is, up to the division by `Q_{T,j}`, a **Jacobian derivation**: the `i`-th
component of the `j`-th column of `adj(J_T)` is, up to sign, the Jacobian of the
four functions `{T_k : k != j}` with respect to `{x_l : l != i}`, and Jacobian
derivations are divergence-free by Piola and kill their defining functions by
construction. That much is classical (see `SOURCES.md` E1–E2). The content of
Lemma 2.2 is that primitivity lets one **divide by `Q_{T,j}`** and stay
polynomial, dropping the degree from `4(d-1)` to `2d-4`; the content of
Proposition 2.3 is that the result is `G`-equivariant on the nose. Those two
facts are what make the object a member of an explicitly computable finite
dimensional `G`-module, and that is what `FOLIATION_REFORMULATION.md` uses.

## 7. Non-claims

* Theorem 2.4 is a **necessary** condition on a landing tuple. Nothing here
  shows it is sufficient, and reconstructing `T` from `P_T` is not addressed.
* Nothing here excludes any tuple, in any degree.
* The `G`-covariance (9) is proved in general but is **not** exercised on a
  `PSL(2,11)`-example, because the existence of such an example is exactly the
  open question. It is exercised on a `mu_3`-example with a nontrivial
  character, which is the case where the argument could fail.
* Dominance is inherited from `G3-DOMINANCE-AUTOMATIC`, whose step 6 is an
  accepted external input (`ed_C(G) >= 3`, Beauville), not a repo proof.

**Problem E headline: OPEN.** Nothing here changes it.
