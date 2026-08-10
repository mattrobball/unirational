# PHI_SEXTIC_ISOGENY — REPORT

Exits: **PHI-SEXTIC-ISOGENY-VERDICT-POS**, **PHI-SEXTIC-S3-ISOMORPHIC**,
**PHI-RESTRICTION-CLASSIFIED**, **PHI-ISOLATED-POINTS-TO-LINE**.
Not applicable: `PHI-ODD-DEGREE-RAMIFICATION-FORCED` (it was conditional on
non-isogeny; see §8).

Date 2026-08-10. Two engines (exact `Q(zeta_11)` linear algebra in char 0;
`F_p` arithmetic at 13 split primes), every decisive number computed twice.

---

## 0. Verdict

`C_sigma` and `E_sigma` are **isomorphic**, not merely isogenous — and the
isomorphism can be chosen equivariant for the residual `S3`.

```
j(C_sigma) = 8192/11 = j(E_sigma)            exactly, over K = Q(zeta_11)
```

So the hoped-for negative obstruction does not exist. What the packet does
deliver is a complete classification of the possible restrictions
`Phi|_{C_sigma}` (§5) and one genuinely forced statement about where the two
isolated `sigma`-points of the `V14` must go (§6).

---

## 1. The models

Everything is rebuilt inside the model that `FIX-IX-SEAL` itself uses, so the
two curves are produced by one program from one group.

* `U` = the 6-dim even Weil representation of `SL(2,11)`, generators `T6`
  (diagonal, `zeta^{j^2}`) and `S6` (`c = 1/gauss`, `gauss^2 = -11`); the
  closure has order 1320 with projective order profile
  `(2,110,220,528,220,240)`.
* `Lambda^2 U = 5 + 10'`. `M` := the 10-dim `10'` summand (column space of the
  chi-averaged isotypic projector). `V14 = Gr(2,U) cap P(M)`, cut by the 15
  Plucker quadrics restricted to `M`.
* `Ann(M) subset Lambda^4 U` is 5-dimensional and carries the Klein 5-rep;
  `Pf6`, the Pfaffian of the associated antisymmetric `6x6` matrix, is the
  invariant cubic, and `{Pf6 = 0}` **is** the Klein cubic threefold `X`
  (`FIX-IX-SEAL` §4, via E38's uniqueness of the invariant cubic).
* `sigma`: the element with `sigma^2 = -I`. `M_+` is 6-dimensional,
  `C_sigma = V14 cap P(M_+) subset P^5`; on the Klein side `Lambda^4(sigma)`
  splits `Ann(M)` as `3 + 2`, giving `E_sigma = X cap P(W^+)` (a plane cubic)
  and `L_sigma = P(W^-)`.
* `C_G(sigma)` has order 12 and acts on both `M_+` and `Ann(M)` through
  `S3 = C_G(sigma)/<sigma>` (`sigma` acts as `+1` on `M_+`). **The same two
  group elements `g_tau`, `g_rho` are used on both curves throughout.**

Independent re-derivations of sealed facts, obtained here as by-products:

| sealed fact | source packet | reproduced here |
|---|---|---|
| `Pf6` vanishes identically on `P(W^-)`: `L_sigma` is a line on `X` | FIX-A0 | `CHECK L_sigma_lies_on_X` at `K` and 13 primes |
| `dim W^+ = 3`, `dim W^- = 2` | FIX-A0 | `CHECK klein_sigma_split_3_2` |
| the residual `S3` acts on `L_sigma = P^1` through the faithful 2-dim irrep | FIX-A0 (`residual_character_Wminus`) | `CHECK S3_on_line_faithful` (image of order 6 in `PGL_2`) |
| `j(E_sigma) = 8192/11` | FIX-A0 (two routes, all 55 involutions) | `CHECK j_E_matches_seal` — exact over `K`, from a completely different construction of `E_sigma` |
| `dim(M_+, M_-) = (6,4)`; `V14 cap P(M_-)` = 2 reduced points | FIX-IX-SEAL | `CHECK sigma_split_6_4`, `isolated_sigma_points_deg2` |

Nothing computed here contradicts a sealed input.

## 2. The double-cover form of `C_sigma`

Let `tau` in `S3` have order 2. On `M_+` it splits `4 + 2` (verified at `K` and
at every prime). Write the coordinates `(v_0..v_3 | w_0, w_1)`.

**Lemma 2.1.** The 9-dimensional space of quadrics through `C_sigma` splits as
6 `tau`-even + 3 `tau`-odd. *(verified: `quadrics_rank9`,
`quadric_parity_split_6_3`.)*

**Lemma 2.2.** The 3 odd quadrics assemble into a `3x2` matrix `A(v)` of linear
forms; the Cramer minors of the `3x4` matrix `B(s,t)` of `A(v).(s,t)^T` give
binary cubics `nu(s,t)` with `A(nu(s,t)).(s,t)^T = 0` identically — the
parametrisation of the twisted cubic that is the image of
`C_sigma -> C_sigma/tau = P^1 subset P(V_4)`. *(verified: `nu_is_cubic`,
`nu_in_kernel`.)*

**Lemma 2.3.** Normalising a `tau`-even quadric so that its `ww`-part is
`w_0^2` (resp. `w_0 w_1`, `w_1^2`) and substituting `v = nu(s,t)` gives, after
exact division by `s^2` (resp. `st`, `t^2`), **one and the same** binary
quartic `R(s,t)`, and

```
C_sigma  =  { c^2 = R(s,t) },      4 I^3 - J^2 != 0 ,
```

with `I, J` the classical invariants of `R`. The three normalisations agreeing
is a nontrivial internal consistency check (`branch_quartic_consistent`), and
`4I^3 - J^2 != 0` says the 4 branch points are distinct
(`branch_quartic_separable`).

Consequences, all read off this model: `tau` acts on `C_sigma` as an inversion
with exactly 4 fixed points; the 2-dimensional `tau`-eigenspace meets
`C_sigma` in nothing (`C_meets_2dim_eigenspace_emptily`); and

```
#C_sigma(F_p) = sum over (s:t) in P^1(F_p) of ( 1 + chi(R(s,t)) ).
```

*Pipeline validation.* `scripts/selftest.py` runs **the same three steps** on
the degree-6 model of a known curve `y^2 = x^3 + a x + b` embedded by `|6.O|`
in `P^5` (where `tau = [-1]` splits the coordinates `4+2` in exactly this way)
and recovers `R(s,t) = b s^4 + a s^3 t + s t^3` and the correct `j` for four
different `(a,b)`. The binary-quartic `j`-formula
`j = 6912 I^3/(4I^3 - J^2)` is separately checked against the cross-ratio
formula `j = 256(l^2-l+1)^3/(l^2(l-1)^2)` for six values of `l`, and the
Weierstrass `j`-formula against `1728*4a^3/(4a^3+27b^2)` on eight curves.

## 3. Theorem 1 — the two curves are isomorphic

> **Theorem 1.** `j(C_sigma) = 8192/11 = j(E_sigma)`. Both lie in `Q`, so
> `C_sigma` and `E_sigma` are isomorphic over `C`; in the language of modular
> polynomials the relation is `Phi_1(x,y) = x - y`, i.e. an isogeny of degree 1.

Computed exactly over `K = Q(zeta_11)` (`results/model_K.json`,
`results/checks_K.txt`), two ways on each side:

* `C_sigma`: from the invariants `I, J` of `R(s,t)`, and independently from the
  Weierstrass cubic `Y^2 = h(X)` obtained by moving a branch point to infinity
  (`CHECK j_C_two_routes`, at every prime);
* `E_sigma`: from the `tau`-normal form `Pf6 = z^2 L(u) + C(u)`, which is
  literally a Weierstrass equation `y^2 = -C(1,x)` once `L` is normalised to
  `U_0` (`E_cubic_tau_normal_form`, `E_L_normalised`) — and this reproduces
  FIX-A0's sealed `8192/11` from a construction (`Pf6` on `Lambda^4 U`) that
  shares no code with FIX-A0's Weil-representation model of the 5-rep.

Corroboration at 13 split primes `p = 1 mod 11` (§7): `j(C) = j(E) = 8192/11
mod p` and `a_p(C) = a_p(E)` at every one, with `#E_sigma(F_p)` independently
re-counted by sweeping `P^2(F_p)` against the Pfaffian cubic, and
`#C_sigma(F_23) = 27` independently re-counted by sweeping all 6 731 271 points
of `P^5(F_23)` against the 15 Plucker quadrics in the *un-adapted* basis of
`M_+`.

`8192/11` is not an algebraic integer, so neither curve has complex
multiplication and `End = Z`; `8192/11` is neither 0 nor 1728, so
`Aut(E_sigma, O) = {+-1}`.

## 4. Theorem 2 — the residual `S3` and an equivariant isomorphism

Since `j != 0`, an order-3 automorphism of a genus-one curve cannot fix a
point, so `rho` acts as a **translation** by a 3-torsion point; and since
`tau rho tau = rho^{-1}`, `tau` cannot be a translation, so it is an inversion
with 4 fixed points. Set `T_C := rho(O_C)` and `T_E := rho(O_E)` for any
choices of origin — these points are independent of the choice, up to the
canonical identification of the group structures.

**Lemma 4.1.** Fix origins at `tau`-fixed points, so `tau = [-1]` on both
curves. A map `f: C_sigma -> E_sigma` is `S3`-equivariant and nonconstant iff
`f = phi + c` with `phi` in `Hom(C_sigma, E_sigma)`, `phi(T_C) = T_E`, and
`c` in `E_sigma[2]`.

*(The `tau`-condition gives `2c = 0`; the `rho`-condition gives
`phi(T_C) = T_E`; `S3 = <rho, tau>`.)*

Because `End = Z`, `Hom(C_sigma, E_sigma) = Z.psi` for an isomorphism `psi`,
so the whole question is whether `psi(<T_C>) = <T_E>` — a yes/no question about
two order-3 subgroups.

> **Theorem 2.** `psi(<T_C>) = <T_E>`. Hence an `S3`-equivariant **isomorphism**
> `C_sigma -> E_sigma` exists (four of them, one for each `c` in `E_sigma[2]`),
> and the `S3`-equivariant nonconstant maps `C_sigma -> E_sigma` are exactly
> `n.psi + c` with `n = +-1 mod 3` fixed by the sign of `psi(T_C)` versus `T_E`,
> and `c` in `E_sigma[2]`. Their degrees are exactly the squares `n^2` with
> `3` not dividing `n`:  `1, 4, 16, 25, 49, 64, ...`.

**How it is decided.** Both curves are put in short Weierstrass form
`y^2 = x^3 + A x + B` with the origin at a `tau`-fixed point. Because
`j != 0, 1728`, the geometric isomorphism is `(x,y) -> (u^2 x, u^3 y)` with
`u^2 = B_E A_C / (B_C A_E)` uniquely determined, so the test is the single
scalar identity `x(T_E) = u^2 x(T_C)`.

*Why a mod-`p` verification decides a `C`-statement here.* `C_sigma`,
`E_sigma`, `rho`, `tau` are all defined over `K` and have good reduction at
every `P | p` used. Reduction is injective on 3-torsion (`p != 3`) and is a
bijection `Isom_{Kbar}(C,E) -> Isom_{Fbar_p}(C,E)` (both are torsors under
`{+-1}`, and reduction is injective). So `psi(<T_C>) = <T_E>` holds over `Kbar`
if and only if it holds mod `P`.

**Verified** at `p = 67, 89, 199, 331, 353, 397, 419, 463, 617, 661, 683, 727`
(12 primes) and, at `p = 67`, for all 3 conjugate involutions `tau`, both
order-3 elements `rho`, and every rational branch point used as origin
(`sextic.py 67 0..7`): the verdict `MATCH = True` is stable.

**End-to-end confirmation.** At each of those primes the script then *builds*
the candidate map — `phi(x,y) = (u^2 x, +- u^3 y)` with the sign pinned by
`phi(T_C) = T_E` — pulls it back to the two original geometric models, and
checks

```
F(g.P) = g.F(P)      for g = rho and g = tau, at every point of C_sigma(F_p),
```

with `rho, tau` acting by their *linear* matrices on `P^5` containing
`C_sigma` and on `P^2` containing `E_sigma`. 129 to 1419 point tests per prime,
**0 failures** (`equivariant_isomorphism_pointwise`), plus `F_lands_on_E`
verifying that the image satisfies the Pfaffian cubic. Two degree-1 maps
agreeing at more than 4 points are equal, so this is a proof at each prime, not
a sample.

## 5. Theorem 3 — the other branch, and the classification

The residual `S3` acts faithfully on `L_sigma = P(W^-) = P^1` through the
standard 2-dim irrep (re-verified: the image in `PGL_2` has order 6, and `rho`
and `tau` do not commute on `W^-`). So `rho` fixes 2 points of `L_sigma` and
`tau` swaps them; `S3` has **no** fixed point on `L_sigma`. On `E_sigma`, `rho`
is a nontrivial translation, so `S3` has no fixed point there either.

> **Theorem 3.**
> (a) `X^sigma` contains no `S3`-fixed point. Hence any `G`-equivariant
> rational `Phi: V14 --> X` that is defined at the generic point of `C_sigma`
> restricts to a **nonconstant** map on `C_sigma`.
> (b) A nonconstant `S3`-equivariant map `C_sigma -> L_sigma` **exists**, of
> degree 3; and every such map has degree divisible by 3.
> (c) Therefore `Phi|_{C_sigma}` is either an `S3`-equivariant map onto
> `E_sigma` of degree `n^2` with `3` not dividing `n`, or an `S3`-equivariant
> map onto `L_sigma` of degree divisible by 3. Both branches are possible; no
> numerical obstruction excludes either.

*Proof of (b).* Put the origin at a `tau`-fixed point, so `tau = [-1]` and
`rho =` translation by `T` in `C_sigma[3]`. Pick `S` in `C_sigma[3]` outside
`<T>` and let

```
D = (-S) + (-S+T) + (-S+2T) - (S) - (S+T) - (S+2T).
```

`D` has degree 0 and sum `-6S = O`, so `D = div(f)` for some `f`, unique up to
scalar. `D` is `rho`-invariant, so `f o rho = c f` with `c^3 = 1`; and `c = 1`
would force `f` to descend to `C_sigma/<T>`, making `(pi(-S)) - (pi(S))`
principal there, i.e. `2S` in `<T>`, contradiction. So `c` is a primitive cube
root of 1. `tau^* D = -D`, so `(f o tau) . f` is a constant `gamma`; rescaling
`f` by `lambda` with `lambda^2 = 1/gamma` makes `f o tau = 1/f`. Then `f` is
equivariant for the `S3`-action `rho: z -> c z`, `tau: z -> 1/z` on `P^1`,
which is the standard faithful action; replacing `f` by `1/f` swaps `c` and
`c^2`, so either identification of `S3` with the action on `L_sigma` can be
matched. `deg f = 3`. For the divisibility: if `a` in `L_sigma` is one of the
two `rho`-fixed points, `f^*(a)` is a `rho`-invariant effective divisor of
degree `deg f`, and `rho` acts freely on `C_sigma`, so `3` divides `deg f`.  ∎

### 5.1 Quotient and branch data (the Hurwitz bookkeeping)

The 4 fixed points of each of the 3 involutions of `S3` on `C_sigma` are 12
distinct points (a point fixed by two involutions would be fixed by their
product, a nontrivial power of `rho`, which acts freely). Hence:

| `H <= S3` | `C_sigma/H` | genus | branch data of `C_sigma -> C_sigma/H` |
|---|---|---|---|
| `1` | `C_sigma` | 1 | — |
| `<tau>` | `P^1` | 0 | 4 points of index 2 (the branch quartic `R`) |
| `<rho>` | genus-1 curve, 3-isogenous to `C_sigma` | 1 | étale (`rho` free) |
| `S3` | `P^1` | 0 | 4 points of index 2; `2.1-2 = 6(-2) + 4.3.(2-1) = 0` |

For the target: `L_sigma/S3 = P^1` with branch data one point of index 3 (the
image of the two `rho`-fixed points, one orbit of size 2 with stabiliser `A_3`)
and two points of index 2 (`-2 = 6(-2) + 2.(3-1) + 2.3.(2-1)`). An equivariant
`f: C_sigma -> L_sigma` descends to a degree-`deg f` map of the quotient
`P^1`s; since no point of `C_sigma` has stabiliser containing `rho`, the fibre
over the index-3 branch point consists of free orbits — which is the Hurwitz
form of the divisibility `3 | deg f` proved above.

**Conditional sharpening (hypothesis not sealed).** The task brief's degree
bookkeeping — `Phi^* O_X(1) = O_{V14}(d)`, whence
`3.deg(Phi|_{C_sigma}) = 6d` — is *not* recorded in the sealed dichotomy
packet, which is an existence proof with no degree data. **If** it holds
(i.e. `Phi` is a morphism near `C_sigma` and its defining system has no base
point on `C_sigma`), then `deg(Phi|_{C_sigma}) = 2d` is even, and combining
with Theorem 3:

* `E_sigma` branch: `deg = n^2` with `n` even and `3` not dividing `n`, so
  `deg` in `{4, 16, 64, 100, ...}` and `d >= 2` — in particular
  `Phi|_{C_sigma}` could **not** then be an isomorphism onto `E_sigma`;
* `L_sigma` branch: `6` divides `deg`, so `3` divides `d`.

This is flagged as conditional and is not used anywhere above.

## 6. Theorem 4 — where the two isolated `sigma`-points must go

`V14^sigma = C_sigma` together with `{P_1, P_2} = V14 cap P(M_-)`, a reduced
degree-2 scheme (`FIX-IX-SEAL`). Computed here directly, at the primes where
the pair is `F_p`-rational (`p = 89, 353, 397`): the residual `S3` **fixes each
of `P_1, P_2` under `rho` and swaps them under `tau`** — one orbit of size 2
with stabiliser `A_3 = <rho>`. (At the other primes the pair is
Frobenius-conjugate and the sweep correctly returns 0 rational points; the seal
records stabiliser exactly `C6` in `D12`, which is the same statement.)

> **Theorem 4.** If `Phi` is defined at `P_1` (equivalently, by equivariance,
> at `P_2`), then `Phi({P_1,P_2})` lies in `L_sigma` and `Phi` sends
> `{P_1,P_2}` bijectively onto the two `rho`-fixed points of `L_sigma`.

*Proof.* `Phi` is `G`-equivariant, so it maps `V14^sigma` into `X^sigma` and
respects `S3`. The stabiliser of `P_i` contains `rho`, so the stabiliser of
`Phi(P_i)` contains `rho`. On `E_sigma`, `rho` is a nontrivial translation and
has no fixed point; so `Phi(P_i)` lies in `L_sigma`, where the `rho`-fixed
locus is exactly two points, swapped by `tau`. Finally
`Phi(P_2) = Phi(tau.P_1) = tau.Phi(P_1)` is the *other* one.  ∎

This holds for all 55 conjugate involutions simultaneously, by conjugacy
transport (the 55 involutions of `PSL(2,11)` form one class — FIX-A0).

## 7. Evidence table

`#C(F_p)` from `c^2 = R(s,t)`; `#E(F_p)` from `y^2 = -C(1,x)`; `brute E` from a
direct sweep of `P^2(F_p)` against the Pfaffian cubic; `S3` from the
`x(T_E) = u^2 x(T_C)` test; `pts` = number of pointwise equivariance tests
passed / failed.

| p | #C | a_p(C) | #E | a_p(E) | brute E | j(C)=j(E) mod p | 8192/11 mod p | S3 | pts ok/bad |
|---|---|---|---|---|---|---|---|---|---|
| 23 | 27 | -3 | 27 | -3 | 27 | 15 | 15 | (no `F_p` branch pt) | — |
| 67 | 69 | -1 | 69 | -1 | 69 | 26 | 26 | MATCH | 129/0 |
| 89 | 99 | -9 | 99 | -9 | 99 | 57 | 57 | MATCH | 189/0 |
| 199 | 192 | 8 | 192 | 8 | 192 | 3 | 3 | MATCH | 366/0 |
| 331 | 339 | -7 | 339 | -7 | 339 | 173 | 173 | MATCH | 675/0 |
| 353 | 375 | -21 | 375 | -21 | 375 | 135 | 135 | MATCH | 741/0 |
| 397 | 432 | -34 | 432 | -34 | 432 | 59 | 59 | MATCH | 852/0 |
| 419 | 408 | 12 | 408 | 12 | 408 | 21 | 21 | MATCH | 804/0 |
| 463 | 441 | 23 | 441 | 23 | 441 | 408 | 408 | MATCH | 879/0 |
| 617 | 600 | 18 | 600 | 18 | 600 | 296 | 296 | MATCH | 1188/0 |
| 661 | 645 | 17 | 645 | 17 | 645 | 264 | 264 | MATCH | 1281/0 |
| 683 | 636 | 48 | 636 | 48 | 636 | 248 | 248 | MATCH | 1260/0 |
| 727 | 711 | 17 | 711 | 17 | 711 | 216 | 216 | MATCH | 1419/0 |

Additionally `#C_sigma(F_23) = 27` was recomputed by sweeping all of
`P^5(F_23)` against the 15 Plucker quadrics (independent of every construction
in §2). Char 0: `results/model_K.json` carries the exact `R(s,t)`, `I`, `J`,
the exact Weierstrass cubic of `E_sigma`, and the exact 3-torsion point `T_E`
over `K`; `verifier.py` recomputes `j` from those stored exact coefficients
with a fresh, independent implementation of `Q(zeta_11)` arithmetic and gets
`8192/11` on both sides.

## 8. Not claimed

* **No headline.** Nothing here bears on `G`-unirationality of `X` or on
  `ed_C(PSL_2(F_11))`. The packet constrains `Phi`; that is all.
* **`PHI-ODD-DEGREE-RAMIFICATION-FORCED` does not apply.** The ramification
  corollary sketched in the task brief was explicitly conditional on
  `C_sigma` *not* being isogenous to `E_sigma`. It is, so the argument's
  hypothesis fails and no such conclusion is drawn. In particular nothing here
  says that an odd-degree dominant equivariant `V14 --> X` must ramify over
  `E_sigma`.
* **No explicit `Phi`.** The sealed dichotomy packet is an existence proof;
  this packet does not construct any map `V14 --> X`, nor show that the
  `S3`-equivariant isomorphism `C_sigma -> E_sigma` found here is the
  restriction of one.
* **No `G`-equivariance upgrade.** The isomorphism is equivariant for
  `S3 = C_G(sigma)/<sigma>` only. Whether it is compatible across the 55
  involutions in a way that assembles into anything global is untouched.
* **The degree bookkeeping `deg = 2d` is not sealed** and is used only in the
  clearly flagged conditional remark in §5.
* **`j(C_sigma)` over `K`, not over `Q`.** The computation is exact over
  `K = Q(zeta_11)` and lands in `Q`; no descent statement about a model of
  `C_sigma` over `Q` is claimed.
* The char-0 status of Theorem 2 rests on the reduction argument stated in §4,
  not on an exact `Q(zeta_11)` computation of `T_C` (which would need a branch
  point of `R`, i.e. a further field extension). Theorem 1 *is* exact in
  char 0.

## 9. Replay

```
python3 scripts/selftest.py                 # formula + pipeline self-tests
python3 scripts/sextic.py <p> [variant]     # p = 23,67,89,199,331,353,397,419,463,617,661,683,727
python3 scripts/sextic.py K                 # exact over Q(zeta_11), ~11 min
python3 scripts/bruteforce.py 23 67 ...     # independent sweeps
python3 verifier.py                         # fresh primes 419, 617; ALLGREEN (~9 s)
python3 verifier.py --full                  # also recomputes the exact K model
```

Outputs under `results/`: `model_<mode>.json`, `checks_<mode>.txt`,
`run_<mode>.txt`, `evidence_table.txt`.

Provenance of the inputs used: `goal_runs_after_c53d89a/FIX_IX_SEAL`
(`FIX-IX-SEAL-PASS`) for the `V14` model and `V14^sigma`;
`goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT`
(`FIX-A0-ARRANGEMENT-PASS`) for `j(E_sigma) = 8192/11`, the single conjugacy
class of 55 involutions, and the residual character on `W^-`;
`goal_runs_20260810/V14_MAP_DICHOTOMY` (`V14MAP-V14-TO-KLEIN-EXISTS`, on branch
`agent/v14-map-dichotomy-20260810`, PR #19 — **not merged to `main` at the time
of writing**) for the existence of `Phi`.
