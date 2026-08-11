# The source-tangency invariant and its ramification factorization

Exits: `SOURCE-TANGENCY-IS-THE-CONE-JACOBIAN-PROVED`,
`SOURCE-TANGENCY-RAMIFICATION-FACTORIZATION-PROVED`,
`TANGENCY-EXPONENT-IS-CODIMENSION-WEIGHT-NOT-TWO`,
`SOURCE-TANGENCY-WITNESS-EXACT`.

Provenance: external round 5, section 5 (unaudited). Verdict:
**CONFIRMED WITH SUPPLIED PROOF, AND SHARPENED.** The source states the
identity and justifies it with the single phrase "comparison of the cone
Jacobian with the projective differential gives". That is the load-bearing step
of the entire round and it is not formal; the proof is supplied below in full.
Two sharpenings come out of the proof and were not in the source:

* the constant is **not** an unspecified `c != 0` but exactly `c = d/d'`, and
  the proof shows *why* a constant appears at all (it is a scaling weight, and
  it is where characteristic zero enters);
* the exponent `2` on `H` is the **residue weight** `w = n - e` of the ambient
  situation (here `n = 5` variables, `e = 3` the degree of `F`), not a
  universal square. Instances with `w = 1` and `w = 3` are exhibited in which
  the exponent is `1` and `3`. For the Klein cubic threefold `w = 2`, so the
  source's statement is right in the case that matters, for a reason it does
  not give.

Verified exactly: `verify_source_tangency.py` (`RESULT: PASS`, 192 checks,
sympy over `Q`) and `verify_source_tangency.m2` (`RESULT: PASS`, Macaulay2,
symbolic over `Q`, on a genuine smooth cubic threefold in `P^4`).

---

## 0. Setting

`R = C[x_0,...,x_{n-1}]`, `F in R_e` with `X = V(F) ⊂ P^{n-1}` smooth,
`C(X) = V(F) ⊂ A^n` the affine cone (smooth away from the origin). `T` a
primitive tuple of `n` forms of degree `d` with `F(T) = 0` identically, whose
induced map `[T] : P^{n-1} --> X` is dominant. `J_T`, `Q_T = grad F(T)`,
`P_T` with `adj(J_T) = P_T Q_T^t` are as in `THEOREM_FORCED_FOLIATION.md`,
`deg P_T = (n-1)(d-1) - (e-1)d`.

The repository case is `n = 5`, `e = 3`, `G = PSL(2,11)`, `F` the Klein cubic;
there `deg P_T = 2d-4`.

> **Definition.** The **source-tangency invariant** is
> ```
> Delta_T := D_{P_T} F = grad F(x)^t P_T(x),        deg Delta_T = w (d-1),
> ```
> where `w := n - e`. For the Klein cubic `w = 2` and `deg Delta_T = 2d-2`,
> the source's (33). Equivariance of `P_T` (Proposition 2.3 of
> `THEOREM_FORCED_FOLIATION.md`) and invariance of `F` give
> `Delta_T in (Sym^{w(d-1)} W^v)^G`.

`Delta_T(x) = 0` says that the kernel direction `P_T(x)` is tangent to the cone
at `x`; equivalently, `Delta_T` vanishes identically on `X` exactly when `X` is
an invariant (Darboux) hypersurface of the kernel foliation.

## 1. The residue form and its weight

Let `Omega = dx_0 ^ ... ^ dx_{n-1}`. The **Gelfand–Leray (residue) form**
`eta` on `C(X)` is the `(n-1)`-form determined by

```
dF ^ eta = Omega        on C(X).                                    (T1)
```

It is well defined (two choices differ by a multiple of `dF`, which restricts
to `0` on `C(X)`) and nowhere zero on `C(X) \ {0}`; concretely, on the chart
`F_{n-1} != 0`,

```
eta = dx_0 ^ ... ^ dx_{n-2} / F_{n-1}.                              (T2)
```

Under the scaling `m_lambda(x) = lambda x` one has `m_lambda^* Omega =
lambda^n Omega` and `m_lambda^* dF = lambda^e dF`, so

```
m_lambda^* eta = lambda^{n-e} eta = lambda^w eta:  eta has WEIGHT w.  (T3)
```

(This is the cone form of `K_X = O_X(e-n) = O_X(-w)`; for a cubic threefold
`K_X = O_X(-2)`.) `eta` is `G`-invariant: `G` acts on `W` through `SL(W)`
because `G` is perfect, so `Omega` is invariant, and `F` is invariant.

## 2. The pointwise lemma

> **Lemma 2.1 (linear algebra).** Let `A : V -> V`, `dim V = n`, and let `N, Q`
> be nonzero covectors with `Q^t A = 0`. Pick `v` with `N^t v = 1` and `w_0`
> with `Q^t w_0 = 1`, a basis `(e_i)` of `N^perp` and a basis `(f_i)` of
> `Q^perp`, and set `S = [v, e_1, ..., e_{n-1}]`, `R_0 = [w_0, f_1, ...,
> f_{n-1}]`. Let `A'` be the matrix of `A|_{N^perp} : N^perp -> Q^perp` in the
> bases `(e), (f)` (this is defined because `im A ⊆ Q^perp`). Then
>
> ```
> det(A') = (det S / det R_0) * N^t adj(A) w_0.                      (T4)
> ```

*Proof.* Change bases: `M := R_0^{-1} A S` has last row zero, because
`im A ⊆ Q^perp = span(f_1,...,f_{n-1})`, and its upper-left `(n-1)x(n-1)`
block is `A'`. For a matrix with last row zero every cofactor `C_{ij}` with
`i != n` vanishes (the deleted matrix still contains the zero row), so
`adj(M)` is supported in its last column, and `adj(M)_{nn} = C_{nn} =
det(A')`. Now `adj(R_0^{-1} A S) = adj(S) adj(A) adj(R_0^{-1}) =
(det S / det R_0) S^{-1} adj(A) R_0`. Its `(n,n)` entry is
`(det S/det R_0) * (last row of S^{-1}) adj(A) (last column of R_0)`. The last
row of `S^{-1}` is the functional that is `1` on `v` and `0` on `N^perp`, i.e.
`N^t`; the last column of `R_0` is `w_0`. This is (T4). ∎

Block (A) of `verify_source_tangency.py` checks (T4) on exact integer data in
dimensions `3,4,5,6`.

> **Lemma 2.2 (LEMMA A: `Delta_T` is the cone Jacobian).** Let
> `tau := T|_{C(X)} : C(X) -> C(X)` and define `Jac(tau)` by
> `tau^* eta = Jac(tau) * eta`. Then, as functions on `C(X)`,
>
> ```
> Delta_T |_{C(X)} = Jac(tau),                                      (T5)
> ```
> with no constant. Equivalently, in `H^0(X, O_X(w(d-1)))`,
> `Delta_T|_X = Jac(tau)`.

*Proof.* Fix `x in C(X)`, `x != 0`, with `y := T(x) != 0`. Put `A = J_T(x)`,
`N = grad F(x)`, `Q = Q_T(x) = grad F(y)`. Then `T_x C(X) = N^perp`,
`T_y C(X) = Q^perp`, and `Q^t A = 0` is the chain rule (5). The restricted
differential `d tau_x : T_xC(X) -> T_yC(X)` is exactly `A|_{N^perp}`, so its
matrix in bases `(e),(f)` is `A'`.

Evaluating (T1) on `(v, e_1, ..., e_{n-1})` and using `dF(e_i) = 0`,
`dF(v) = N^t v = 1`:

```
det S = Omega(v, e_1,...,e_{n-1}) = (dF ^ eta)(v, e_1,...,e_{n-1})
      = eta_x(e_1, ..., e_{n-1}),
```

and likewise `det R_0 = eta_y(f_1,...,f_{n-1})`. Therefore

```
(tau^* eta)_x(e_1,...,e_{n-1}) = eta_y(A' f-coords) = det(A') * det R_0,
Jac(tau)(x) * eta_x(e_1,...,e_{n-1}) = Jac(tau)(x) * det S,
```

so `Jac(tau)(x) = det(A') det R_0 / det S`, which by (T4) equals
`N^t adj(A) w_0 = N^t P_T(x) (Q^t w_0) = N^t P_T(x) = Delta_T(x)`. ∎

The last step is where `adj(J_T) = P_T Q_T^t` — i.e. the whole content step of
`THEOREM_FORCED_FOLIATION.md` Lemma 2.2 — is consumed. Without the *polynomial*
factorization of the adjugate there is no polynomial `Delta_T` to speak of.

**Consequence (the honest dichotomy).** `Jac(tau) = 0` identically iff `tau` is
not dominant, iff `[T]|_X : X --> X` is not dominant. So

```
Delta_T|_X = 0   <=>   the restricted selfmap is NOT dominant
             <=>   X is an invariant hypersurface of the kernel foliation. (T6)
```

For the Klein cubic the left branch is closed by a repository theorem: see §5.

## 3. The scaling lemma, and where `d/d'` comes from

Suppose `tau = h * beta` on `C(X)`, with `h` homogeneous of degree `k` and
`beta : C(X) -> C(X)` homogeneous of degree `a` (so `tau` has degree `k + a`).

> **Lemma 3.1.** `Jac(h beta) = ((a + k)/a) * h^w * Jac(beta)`.

*Proof.* Let `E` be the Euler field on `C(X)` and `zeta := iota_E eta`, an
`(n-2)`-form. Since `eta` is a top form, `dh ^ eta = 0`, and contracting with
`E` gives the standard identity

```
dh ^ zeta = dh(E) * eta = (E h) * eta = k h * eta                   (T7)
```

by the Euler relation. Let `Phi : C(X) x A^1 -> C(X)`, `(z,lambda) |-> lambda z`.
Using `eta_{lambda z}(u_1,...,u_{n-1}) = lambda^{w-(n-1)} eta_z(u_1,...,u_{n-1})`
(which is (T3) rewritten) and expanding
`d Phi(u,t) = lambda u + t z`, one gets the exact pullback formula

```
Phi^* eta = lambda^w eta + lambda^{w-1} dlambda ^ zeta.             (T8)
```

Pull (T8) back along `x |-> (beta(x), h(x))`:

```
tau^* eta = h^w beta^* eta + h^{w-1} dh ^ beta^* zeta.              (T9)
```

Homogeneity of `beta` gives `d beta (E) = a E o beta`, hence
`iota_E(beta^* eta) = a beta^* zeta`; and `beta^* eta = Jac(beta) eta` gives
`iota_E(beta^*eta) = Jac(beta) zeta`. So `beta^* zeta = (Jac(beta)/a) zeta`.
Substituting into (T9) and using (T7):

```
Jac(tau) eta = h^w Jac(beta) eta + h^{w-1} (Jac(beta)/a) * k h * eta
             = ((a+k)/a) h^w Jac(beta) eta. ∎
```

Two remarks the source does not make.

* The factor `(a+k)/a` requires `a != 0` **in the ground field**: this is the
  only place characteristic zero is used in the identity itself (it is used
  again, differently, for `Jac != 0`).
* Setting `k = 0` recovers `Jac(beta) = Jac(beta)`; setting `beta = id`
  (`a = 1`) gives `Jac(h * id) = (1+k) h^w`, which is the retraction case.

## 4. The theorem

Let `D_X` be the divisorial part of the base locus of `T|_X`. Since `X ⊂ P^4`
is a smooth cubic threefold, `Pic X = Cl X = Z·H_X` (Lefschetz) and `X` is
projectively normal, so `D_X = div(H|_X)` for a form `H` of degree `k`, unique
up to scalar and up to `F`; `D_X` is `G`-stable and `G` is perfect, so `H` is
`G`-invariant. Write

```
T|_X = H * B,   deg B = d' = d - k,   B primitive on X,   phi = [B] : X --> X.
```

`F(B) = 0` on `X` because `0 = F(T)|_X = H^e F(B)` and `H|_X != 0`. Let
`beta = B|_{C(X)}` and `j_phi := Jac(beta)`, of degree `w(d'-1)`.

> **Theorem 4.1 (the source's (34), proved and sharpened).** If the restricted
> selfmap `phi` is dominant, then in `H^0(X, O_X(w(d-1)))`
>
> ```
>   Delta_T |_X  =  (d/d') * H^w * j_phi,       w = n - e,          (34')
> ```
>
> with `j_phi != 0`. For the Klein cubic threefold (`n=5`, `e=3`, `w=2`) this is
>
> ```
>   Delta_T |_X  =  (d/d') * H^2 * j_phi,   j_phi in H^0(X,O_X(2d'-2))^G. (34)
> ```
>
> If `phi` is not dominant, both sides vanish and `X` is an invariant
> hypersurface of the kernel foliation.

*Proof.* Lemma 2.2 gives `Delta_T|_X = Jac(tau)`; Lemma 3.1 with `h = H`,
`a = d'`, `k = d - d'` gives `Jac(tau) = (d/d') H^w Jac(beta)`. `j_phi != 0`
because `beta` is a dominant map of `4`-dimensional varieties in
characteristic zero, hence generically étale. `j_phi` is `G`-invariant: `H` is,
`eta` is, `beta` is `G`-equivariant, and `g^*(beta^* eta) = beta^*(g^* eta)`
gives `j_phi o g = j_phi`. ∎

> **Corollary 4.2 (divisor form, the source's (35)).**
> ```
> div_X(Delta_T) = 2 D_X + R_phi,     R_phi ~ 2(d'-1) H_X,          (35)
> ```
> where `R_phi` is the ramification divisor of `phi`, i.e. the divisor of the
> canonical map `phi^* K_X -> K_X`.

*Proof.* `div_X(j_phi) = R_phi`: on the `C^*`-bundle `C(X)\{0\} -> X`, `beta`
covers `phi` and satisfies `d beta(E) = d' E`, so in a compatible basis
`det(d beta) = d' det(d phi)`; hence the zero divisor of `Jac(beta)` is the cone
over the zero divisor of `det d phi`, which is `R_phi`. Numerically
`R_phi ~ K_X - phi^* K_X = O_X(-2) - O_X(-2d') = O_X(2d'-2)`, matching
`deg j_phi = w(d'-1) = 2(d'-1)`. ∎

> **Corollary 4.3 (the source's (36)).** `a_T = gcd(P_T)` divides `Delta_T`, so
> `div_X(a_T) <= 2 D_X + R_phi`: every ambient divisorial critical component
> either restricts into the common-factor divisor or into the ramification of
> the restricted selfmap. (`a_T | Delta_T` is immediate from
> `Delta_T = grad F · P_T`.)

## 5. The dominance hypothesis — supplied, and re-linked

Theorem 4.1 and every consequence of it need the restricted selfmap to be
dominant. **The source never states this hypothesis.** It is not automatic: a
tuple with `F(T) = 0` can have `T(X)` a proper subvariety, and (T6) shows the
identity degenerates to `0 = 0` exactly then.

For the Klein cubic the repository proves it:
`goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/THEOREM.md`, Theorem 1.1 —
`phi = f|_X : X --> X` is defined at the generic point and dominant, hence
generically finite of degree `delta >= 1`. The proof rules out `dim Y = 0` by
`X^G = empty` and `dim Y in {1,2}` by `ed_C(PSL_2(F_11)) >= 3`
(Duncan–Reichstein), an `ACCEPTED_INPUT` — the same accepted input that the
ambient dominance bridge uses.

*Audit finding.* The 2026-08-10 RT packets
(`RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md` §1,
`COMBINED_DEGREE_SIEVE/THEOREM_COMBINED_SIEVE.md` §0 and `STATUS.md`) restate
restricted dominance as an *"inherited hypothesis, not proved here"* without
citing the 2026-08-08 theorem that proves it under exactly the hypotheses in
force. The citation is hereby restored. It is a bookkeeping repair, not a new
theorem: nothing downstream changes except that "inherited hypothesis" should
now read "proved in `FULL_G_RESTRICTION_DOMINANCE`, conditional on the accepted
input `ed_C(G) >= 3`".

## 6. What is verified, and how

### 6.1 On a genuine smooth cubic threefold (`verify_source_tangency.m2`)

The packet's own exact degree-`7` witness (Segre construction on
`F = Y_2^3 + 3Y_2Y_0^2 + Y_3^3 + 3Y_3Y_1^2 + 4Y_4^3`, smooth, Fermat in
disguise). Symbolic over `Q`. Results:

| claim | result |
|---|---|
| `T` primitive, `F(T)=0`, `adj(J_T) = P_T Q_T^t`, `deg P_T = 10` | ok |
| `Delta_T = grad F(x)^t P_T` has degree `2d-2 = 12`, nonzero | ok |
| `Delta_T = 1008 x_0^2 x_1^2 x_2 x_4 (x_1x_3^2 - x_0x_4^2)(x_0x_1^2+x_0x_3^2+4x_1x_3x_4)` | ok |
| `Delta_T` does not vanish on `X`: the restricted selfmap is dominant | ok |
| the base scheme of `T|_X` has codimension `2` in `X`: **`H = 1`, `k = 0`, `d' = 7`** | ok |
| `deg(det N) = deg(den) + (2d-2)` (degree bookkeeping of the residue formula) | ok |
| **(34)/Lemma A:** `Delta_T * den = det N` modulo `F`, i.e. `Delta_T\|_X = Jac(T\|_cone)` | ok |
| the scalars `2` and `1/2` in place of `d/d' = 1` both fail | ok |

Here `det N / den` is the cone Jacobian computed in the chart `F_4 != 0` from
(T2): `N_{ij} = F_4 d(beta_i)/dx_j - F_j d(beta_i)/dx_4` for `i,j <= 3` and
`den = F_4^{n-2} F_4(beta)`. The identity is tested **without division**, as
`det N - Jac * den in (F)`.

**A trap this instance exposes.** `Delta_T` visibly contains the square factors
`x_0^2` and `x_1^2`, yet **neither `x_0` nor `x_1` divides `T|_X`**: here
`H = 1`. Square factors of `Delta_T` are *not* evidence of a common factor;
they can be doubled ramification components. (34) may not be read backwards.

### 6.2 The `H`-dependence, and the exponent (`verify_source_tangency.py`)

`H != 1` instances need an ambient tuple whose restriction genuinely factors.
Six exact instances, all with `F(T) = 0` identically and `T` primitive:

| `n` | `e` | `w=n-e` | `d` | `k` | `d'` | `phi` | `Delta_T` |
|---|---|---|---|---|---|---|---|
| 3 | 2 | 1 | 2 | 1 | 1 | `id` | `2 x_0` |
| 4 | 2 | 2 | 2 | 1 | 1 | `id` | `2 x_1^2` |
| 4 | 2 | 2 | 2 | 1 | 1 | ruling swap | `-2 x_0^2` |
| 4 | 2 | 2 | 4 | 2 | 2 | squaring on both rulings | `8 x_0x_1x_2x_3(x_0x_1-x_2x_3)` |
| 4 | 2 | 2 | 6 | 3 | 3 | cubing on both rulings | `6 x_0^3x_1x_2^2x_3^2(5x_0x_1-4x_2x_3)` |
| 5 | 2 | 3 | 2 | 1 | 1 | `id` | `-2 x_1^3` |

The quadric-surface family is `F = x_0x_1 + x_2x_3`, `X = P^1 x P^1`, and
`T = (ac, -bd, ad, bc)` — which satisfies `F(T) = 0` **identically for every
`a,b,c,d`** — with `(a:b), (c:d)` chosen to induce the `r`-th power map on each
ruling, `d' = r`. There `H = -x_0x_1` for `r = 2` and `H = -x_0^2x_1` for
`r = 3` (so `k = 2, 3`), and `j_phi` is a nonzero scalar times
`(x_0x_1)^{r-1}`, whose divisor on `X` is the four coordinate lines with
multiplicity `r-1` — exactly `R_phi`, of class `2(r-1)H_X`. Checked for
`r = 2, 3`; the script also confirms `j_phi = -8x_0x_1` and `27(x_0x_1)^2`
respectively, so the constant `d/d'` is not absorbing a hidden factor.

For every instance the script verifies, exactly and modulo `F`:

* `deg P_T = (n-1)(d-1)-(e-1)d`, `J_T P_T = 0`, `div P_T = 0`;
* `deg Delta_T = w(d-1)`;
* **Lemma A** `Delta_T = Jac(T|_cone)`;
* `T_i|_X = H B_i`, `F(B) = 0` on `X`, `d = k + d'`, `deg j_phi = w(d'-1)`;
* **(34')** `Delta_T|_X = (d/d') H^w j_phi`;
* **the exponent is `n-e`**: replacing `w` by either neighbouring value fails;
* **the constant is `d/d'`**: replacing it by `1`, `2`, `1/2`, `d` or `d'`
  fails whenever those differ from `d/d'`;
* the scaling Lemma 3.1 directly, for four choices of `h` on each of the three
  cones;
* the degenerate branch (T6): a tuple whose restriction is not dominant has
  `Jac(tau) = 0` on `X`.

192 checks, `RESULT: PASS`.

## 7. Why this is the strongest immediate consequence of the package

(35) is one **global square-divisibility condition** coupling the ambient tuple,
the source cubic, the common factor, the restricted selfmap, its ramification
and the ambient kernel foliation. Section 9 of the source is right that neither
factor is separately restrictive: for every `m >= 4` the map
`P |-> grad F · P mod F` from divergence-free `G`-covariants of degree `m` onto
`H^0(X,O_X(m+2))^G` is **surjective** — see `FOLIATION_REFORMULATION.md` §6,
where that claim is proved (Jacobian-ideal saturation `J_e = S_e` for `e >= 6`
plus the radial correction `P |-> P - (div P/(m+4)) x`). So `Delta` alone is
unobstructed; what is restrictive is the simultaneous coupling with
`adj(J_T) = P_T grad F(T)^t` for the same `T`.

## 8. Non-claims

* Theorem 4.1 is a **necessary** condition. Nothing here excludes any tuple in
  any degree by itself; the one exclusion it powers is
  `EXCLUSION_DPRIME_2_3.md`.
* The `H != 1` instances are on quadrics, not on a cubic threefold: no landing
  tuple on a cubic threefold with `H != 1` is known to us to write down (the
  packet's only cubic-threefold witness has `H = 1`). The two halves of the
  verification — Lemma A at `(n,e) = (5,3)`, and the `H`-factorization at
  `w = 1,2,3` with `d' = 1,2,3` — are separately exact, and Theorem 4.1 is
  their formal composition.
* `j_phi` depends on the choice of lift `beta` (equivalently on the scaling of
  `H`); only `div_X(j_phi) = R_phi` and the identity as a whole are canonical.
* The dominance hypothesis of §5 rests on `ed_C(G) >= 3` (Beauville /
  Duncan–Reichstein), an accepted external input, exactly as the rest of the
  repository's dominance chain does.

**Problem E headline: OPEN.** Nothing here changes it.
