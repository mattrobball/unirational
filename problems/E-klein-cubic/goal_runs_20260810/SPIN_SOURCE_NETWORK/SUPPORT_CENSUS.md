# The admissible-support census for spin sources on the `V14`

Part 2 of the port.  `THEOREM_SPIN_HODGE_SUPPORT.md` proves that a
hypothetical dominant `G`-equivariant `phi : P(V) --> V14` forces a `G`-orbit
of proper strict-support blocks in `{}^pH^{j_0}(Rp_*IC_Y^H)` carrying the
whole of `T = H^3(V14,Q)(1)`.  This file asks **which** supports can do that,
and answers cell by cell.

Every number is machine-checked by `verify_spin_hodge_census.py`
(`SPIN_HODGE_CENSUS_OK`, 206 assertions, exact integers, about 30 s).  Section
references `§A`-`§I` point at that script's sections.

The 2026-08-11 layer — the `(O4)` split of §5.2/§6 and the kills K-i…K-l — is
checked by `verify_o4_census.py` (`O4_CENSUS_OK`, 92 assertions), and the
Betti/Hodge inputs by `verify_v14_betti.py` (`V14_BETTI_OK`, 41 assertions).

**The 2026-08-11 campaign layer** — the total-degeneration witness, the
pointwise-kernel selection rule, the `(O1)`, `(O2)`, `(O3)`, `(O5)` verdicts,
the new kills `K-m`, `K-n`, and the minimal live coordinate degree — is
checked by `verify_total_degeneration.py` (`TOTAL_DEGENERATION_OK`, 87
assertions), `verify_o3_odd_order.py` (`O3_ODD_ORDER_OK`, 86 assertions) and
`verify_min_degree.py` (`MIN_DEGREE_OK`, 114 assertions).  Its analysis files
are `TOTAL_DEGENERATION.md`, `O3_ODD_ORDER_POINTS.md`,
`O2_MANDATORY_POINTS.md`, `O1_O5_FREE_AND_MULTIPLICITY.md`.  **Every cell is
now adjudicated, and the census is CLOSED TO ATTACK: see §6 and §8.**

Notation: `S` an irreducible strict support, `H = Stab_G(S)` its setwise
stabilizer, `H_0` the **pointwise** stabilizer (the kernel of `H` acting on
`S`), `s = dim S`, `j_0` the perverse jump, `n = dim V >= 6`.

---

## 1. (i) Which stabilizers are possible — exactly

The measured source geometry constrains `H_0`, **not** `H`.  A support can be
permuted by a large group with no point of it fixed by anything.

> **Proposition C1 (pointwise kernels; every faithful spin source).**
> `H_0` fixes points of `P(V)`, so its preimage in `Gtilde` has a linear
> character `lambda` with `lambda(-I) = -1`, i.e.
> `-I not in [H_0tilde, H_0tilde]`.  Computing the derived subgroup of the
> preimage of a representative of every one of the 16 conjugacy classes of
> subgroups of `G` (§B) gives
> \[
> H_0\in\Sigma_{\mathrm{spin}}
> =\{1,\;C_2,\;C_3,\;C_5,\;C_6,\;C_{11},\;S_3,\;D_{10},\;F_{55}\},
> \]
> and `V_4, A_4, A_5, D_12, G` are **excluded**, with `|[H_0tilde,H_0tilde]|`
> equal to `2, 8, 120, 6, 1320` respectively — each containing `-I`.
> This is uniform over all faithful spin sources: it is a statement about
> `Gtilde` alone.

> **Proposition C2 (setwise stabilizers).**  `H_0 |> H <= N_G(H_0)`.  The
> normalizers and the resulting `(H_0, H)` pairs are (§B'):
>
> | `H_0` | `N_G(H_0)` | possible `H` |
> |---|---|---|
> | `1` | `G` | **any** of the 14 isomorphism types |
> | `C_2` | `D_12` | `C_2, V_4, C_6, D_12` |
> | `C_3` | `D_12` | `C_3, C_6, S_3, D_12` |
> | `C_5` | `D_10` | `C_5, D_10` |
> | `C_6` | `D_12` | `C_6, D_12` |
> | `C_11` | `F_55` | `C_11, F_55` |
> | `S_3` | `D_12` | `S_3, D_12` |
> | `D_10` | `D_10` | `D_10` only (self-normalizing) |
> | `F_55` | `F_55` | `F_55` only (self-normalizing) |
>
> Dually, a spin-blocked `H` can occur only setwise, with
> \[
> H=A_4,\;A_5,\;G\;\Longrightarrow\;H_0=1;
> \qquad
> H=V_4\Longrightarrow H_0\in\{1,C_2\};
> \qquad
> H=D_{12}\Longrightarrow H_0\in\{1,C_2,C_3,C_6,S_3\}.
> \]
>
> **If `s = 0` then `H = H_0`**, so the stabilizer of a point support lies in
> `Sigma_spin`.

> **Corollary C3 (the two smallest `G`-orbits do not occur at points).**
> A `G`-orbit of point supports has size `660/|H|` with `H in Sigma_spin`, so
> \[
> |G\cdot S|\in\{12,\;60,\;66,\;110,\;132,\;220,\;330,\;660\}.
> \]
> **Orbit sizes 11 and 55 are impossible.**  They need `H = A_5` (index 11)
> or `H = D_12`/`A_4` (index 55), none of which fixes a point of a spin
> source.  Orbit size 1 (`H = G`) is likewise impossible at points.
>
> This is exactly where the spin hypothesis bites the ambient accounting:
> `DEGREE_ACCOUNTING.md` §2 lists `11, 11, 12, 55, 66, 660` as the small
> orbits available to a **linear** source; on a spin source the 11-rows and
> the 55-row are gone from the point layer, and the smallest point orbit is
> the 12 `F_55`-points.

The measured strata (`KLEIN_SPIN_COMPLEX.md` §§2-3), for `V = U`:

| `H_0` | `P(U)^{H_0}` | max `s` | note |
|---|---|---|---|
| `C_2` | 110 planes `P^2` (2 per involution) | 2 | `Stab_G(Pi) = C_6` exactly |
| `C_3` | three disjoint `P^1` | 1 | |
| `C_5` | 4 points `| |` one `P^1` | 1 | |
| `C_6` | 6 isolated points | **0** | |
| `C_11` | 6 isolated points | **0** | |
| `S_3` | 2 points | **0** | 220 of them, mandatory (K4) |
| `D_10` | 2 points | **0** | 132 of them, mandatory (K4) |
| `F_55` | 1 point | **0** | 12 of them |
| `V_4, A_4, A_5, D_12, G` | empty | — | Cor 2.3 |

For `V = U^{(+)m}` every entry is multiplied by `C^m` (Lemma M0), so the
"max `s`" column becomes `3m-1, 2m-1, 2m-1, m-1, ...`: cells that are
zero-dimensional at `m = 1` become positive-dimensional at `m >= 2`.  This
is recorded per cell below.

---

## 2. (ii) The 352 mandatory base points — the sharpest cell

Theorem K4 puts all 352 incidence points inside `Ind(phi)` for **every**
`G`-equivariant rational map, at every degree, dominant or not.  They are
`2` orbits of `110` points with `Stab = S_3` and `2` orbits of `66` points
with `Stab = D_10`.  This is the only part of `Bs(phi)` that is known
unconditionally, so it is the natural place to look for a kill.

### 2.1 The exact restrictions

`chi_T = (10, 2, -2, 0, 2, -1)` on element orders `(1,2,3,5,6,11)` — a
function of the order alone (Theorem S0(3)).  Restricting (§D, by
order-summed character tables that self-validate against three exact
identities before any multiplicity is read):

\[
\boxed{
\operatorname{Res}_{S_3}T=2\cdot\mathbf 1\;\oplus\;4\cdot\mathrm{std},
\qquad
\operatorname{Res}_{D_{10}}T=2\cdot\mathbf 1\;\oplus\;2\cdot W_1\;\oplus\;2\cdot W_2 .
}
\]

Both are **sign-free**: `<Res_H chi_T, sign> = 0` for `H = S_3` and for
`H = D_10`.  The same happens one level down: `Res_{C_6} T` omits the
character `psi_3` (`sigma -> -1`, `C_3 -> 1`) and contains the other five
with multiplicity `2` each.

### 2.2 What this kills, and what it does not

> **Theorem C4 (the sign channel is DEAD at all 352 points).**  Let `x` be
> one of the 352 mandatory points, `H = Stab_G(x) in {S_3, D_10}`, and let
> `M_{x,j_0}` be a point-supported block whose `H`-action is
> **sign-isotypic** (equivalently: whose weight-three Hodge structure `W_x`
> contains no trivial and no 2-dimensional `H`-constituent).  Then
> \[
> \operatorname{Hom}_{\mathrm{HS},H}\!\left(\operatorname{Res}_HT,\;W_x(1)\right)=0,
> \]
> so `x` carries no part of the `T`-isotypic projection.

This is the channel the source geometry singles out, which is why it is
worth stating.  At `x` the tangent representation is
`T_x = sign (+) 2.std` (`H = S_3`) or `sign (+) W_1 (+) W_2` (`H = D_10`)
with `m_triv = 0`, `m_sign = 1` (Thm K5 / M1); the **sign point**
`s_x = P(T_x^{sign})` is the unique `H`-fixed point of the exceptional
`P(T_x)` and is precisely the locus that Theorem V1 proved to be forced base
locus at the 132 `D_10`-points.  So the one direction the fixed-point
analysis pinned is the one direction the Hodge obstruction cannot use.

> **Non-kill.**  Both `Res_{S_3}T` and `Res_{D_10}T` contain the trivial
> character with multiplicity 2 and a 2-dimensional constituent with
> multiplicity 4 resp. 2+2.  So the general point-supported block at a 352
> point is **not** excluded by character arithmetic.  Cells `P5` and `P6`
> below are OPEN.

### 2.3 The geometric floor at those points

Proposition S5 and Corollary S6 apply verbatim:

* the perverse degree is forced, `j_0 = 4-n` (so `j_0 = -2` on `P(U) = P^5`,
  not `-1` as in the ambient packet);
* the carrier is a weight-three sub-Hodge structure of `H^3(Y_x,Q)`, so
  **`dim Y_x >= 2`**;
* `Y_x -> Z_x = q(Y_x) subset V14` is finite, so `Z_x` is a closed
  `H`-invariant subvariety of the threefold `V14` with `dim Z_x >= 2`.

> **Corollary C5 (concrete form of the mandatory-point cell).**  If
> `dim Y_x = 2` then, on a resolution `Y_x~`, `H^3(Y_x~) = H^1(Y_x~)(-1)`, so
> the carrier is an **honest `H^1` of a smooth projective surface**:
> \[
> \operatorname{Hom}_{\mathrm{HS},H}\!\left(\operatorname{Res}_HT,\;H^1(\widetilde{Y_x},\mathbf Q)\right)\neq0,
> \]
> i.e. the exceptional fibre over a mandatory point must be an **irregular
> surface whose Albanese contains `E_{-11}`**, `H`-equivariantly, in the
> trivial or 2-dimensional channel.  At `H = D_10` its image `Z_x` in `V14`
> is a `D_10`-invariant surface (or all of `V14`) — and `V14^{D_10} = empty`
> (measured), so that surface carries a fixed-point-free `D_10`-action.

That last sentence is the sharpest form of what the `D_10` cell asks for,
and it is exactly the shape of question that would close it.  It is **not**
closed here: a finite group can act without fixed points on a projective
surface, and nothing in the repository bounds `dim Y_x`.

---

## 3. (iii) Free-orbit capacity — redone for `P^{n-1}`

### 3.1 The parity theorem (new, and uniform in the spin source)

> **Theorem C6 (the coordinate degree is even).**  Let `phi : P(V) --> V14`
> be `G`-equivariant with `V` a faithful spin source, given by a primitive
> tuple of forms of degree `d` in the sealed embedding `V14 subset P(M)`.
> Then `d` is **even**.

*Proof.*  `G`-equivariance of the projective map means the span of the tuple
is a `Gtilde`-submodule of `S^d(V^*)` isomorphic to `M^*` twisted by a linear
character of `Gtilde`; `Gtilde = SL(2,F_11)` is perfect, so the only linear
character is trivial and the span is `M^*` itself.  Now `-I` acts on `M^*`
trivially (`M` is a `G`-module: `Lambda^2` kills `-I`) and on `S^d(V^*)` by
`(-1)^d`, since `rho(-I) = -id_V`.  Hence
`Hom_{Gtilde}(M^*, S^d V^*) = 0` for odd `d`.  Primitivity does not change
the parity: a common factor is a `Gtilde`-semi-invariant, hence invariant
(perfect group), and every invariant in `S^\bullet(V^*)` has even degree by
the same central-character argument.  `QED`

So the live degrees are `d in {2, 4, 6, 8, ...}`, halving every cell count
below.  (What the minimal live degree actually is — the smallest even `d`
with `<S^d U^*, 10'> != 0` — is **not** computed here; it is a named next
task, §7.)

### 3.2 The capacity table

Refined Bézout, exactly as `DEGREE_ACCOUNTING.md` §1 sets it up but on
`P^{n-1}` instead of `P^4`: choosing general members successively and
removing the fixed components already produced in lower codimension, the
codimension-`c` effective Vogel cycle has degree at most `d^c`, so a
`G`-orbit of `N` base components of codimension `c` needs `N <= d^c`.  On
`P^5` (`V = U`), `c = 5-s`:

| orbit `N` | `s=3` (`c=2`) | `s=2` (`c=3`) | `s=1` (`c=4`) | `s=0` (`c=5`) |
|---:|---:|---:|---:|---:|
| 11 | 4 | 4 | 2 | 2 |
| 12 | 4 | 4 | 2 | 2 |
| 55 | 8 | 4 | 4 | 4 |
| 60 | 8 | 4 | 4 | 4 |
| 66 | 10 | 6 | 4 | 4 |
| 110 | 12 | 6 | 4 | 4 |
| 132 | 12 | 6 | 4 | 4 |
| 165 | 14 | 6 | 4 | 4 |
| 220 | 16 | 8 | 4 | 4 |
| 330 | 20 | 8 | 6 | 4 |
| **660** | **26** | **10** | **6** | **4** |

(entries = the smallest **even** `d` allowed; §G.  The `n = 5` version of the
same routine reproduces `DEGREE_ACCOUNTING.md`'s table exactly, as a
regression.)

Reading:

* **`d = 2`: every free (`N = 660`) support dies, in every dimension** —
  `660 > 2^5 = 32`.  In fact at `d = 2` the whole base scheme has
  codimension-`c` capacity `2^c <= 32`, while the 352 mandatory points alone
  need `352` units of codimension-5 capacity, so at `d = 2` the 352 points
  **cannot** be isolated base components: they must lie on positive-dimensional
  base components of total degree `<= 16` (curves), `<= 8` (surfaces) or
  `<= 4` (threefolds).
* `d = 4`: free point-orbits become admissible; free curve orbits do not
  (they need `d >= 6`), free surface orbits need `d >= 10`, free threefold
  orbits need `d >= 26`.
* Beyond `d = 26` **no cell in the table dies**.  Since there is no
  unconditional no-map degree range for the spin lane (the `d <= 30` window
  quoted in `DEGREE_ACCOUNTING.md` is for the **linear** ambient ladder), the
  live window here is all even `d`, and capacity is a genuine but purely
  low-degree screen.

The caveat of `THEOREM_POINT_SUPPORT.md` §1 carries over unchanged and is
restated so nothing is over-read: **a strict support need not be an
irreducible component of the base scheme.**  It may be a smaller stratum
inside a larger base component, which the Vogel bounds do not count.  So the
capacity rows are necessary conditions on *component* orbits only.

---

## 4. (iv) The CM constraint, per cell

`T ~ H^1(E_{-11})^{(+)5}` (Theorem S0(2)), so **every** sub- and quotient
Hodge structure of `T` is `E_{-11}`-isotypic.  Corollary S4 turns this into
an exact per-stabilizer floor `k(H)` = minimal number of `E_{-11}` copies in
`A_{S,j_0}`:

| `H` | `1` | `C_2` | `C_3` | `C_5` | `C_6` | `S_3` | `D_10` | `C_11` | `F_55` |
|---|---|---|---|---|---|---|---|---|---|
| `dim T^H` | 10 | 6 | 2 | 2 | 2 | 2 | 2 | **0** | **0** |
| `k(H)` | 1 | 1 | 1 | 1 | 1 | 1 | 1 | **5** | **5** |

The two boldface columns are the sharp ones:

> **Theorem C7 (`C_11` and `F_55` supports must carry the whole Weil
> fivefold).**  `Res_{C_11}T = (+)_{k=1}^{10} psi_k` is the unique
> 10-dimensional `Q`-irreducible of `C_11`, with **no invariants**;
> `Res_{F_55}T = theta_1 (+) theta_2` with `theta_i` the two 5-dimensional
> irreducibles of `F_55`, Galois-conjugate over `Q(sqrt(-11))`, and **no**
> trivial and **no** linear character of `F_55` occurs.  Both restrictions
> are irreducible over `Q`.  Hence any nonzero equivariant Hodge map out of
> them is injective, and the support abelian factor contains
> `E_{-11}^5` — all five copies, on a **single** representative support.

This is strictly stronger than the ambient packet's careful
"a single representative support need not contain all five copies"
(`THEOREM.md` §3): on the two odd-order cells, it must.

### 4.1 Where the non-CM `j = 8192/11` exclusion applies

`j(E_sigma) = 8192/11` is not an algebraic integer, so `End(E_sigma) = Z`
and `Hom(E_sigma, E_{-11}) = 0` (sealed).  Consequently:

* **DEAD:** any cell whose weight-one abelian factor is forced to be
  isogenous to a product of copies of `E_sigma` (equivalently: whose carrier
  is `H^1` of a curve dominated by, or dominating, the fixed genus-one
  sextic).  In particular the naive "the carrier is the `sigma`-fixed
  elliptic curve" scenario.
* This cell dies **twice**: also by Proposition S5, since `dim V14^sigma = 1`
  while a point support needs `dim Y_x >= 2` and `Z_x subset V14` of
  dimension `>= 2`, so `Z_x` can never be contained in `V14^sigma`.
* **Not dead:** covers and Prym geometries over `E_sigma` — the ambient
  packet's Test 6 verdict transfers verbatim.  The exclusion condition is
  always `Hom_{HS,H}(Res_H T, H^1(C)) = 0` for the *actual* carrier `C`, and
  no argument replaces `C` by `E_sigma`.

### 4.2 Plane curves inside eigenplanes — explicit

> **Proposition C8 (linear strata are dead in the constant-coefficient
> channel).**  Let `S` be a whole linear eigen-stratum `P(V_lambda) = P^k` of
> `P(V)` — an eigenplane of an involution, an eigen-line of `C_3` or `C_5`,
> or an incidence locus.  In the classical channel
> (`i = s+4-n-j_0 = 1`, `L = Q(-1)`) the carrier is
> `IH^1(P^k, Q(-1)) = H^1(P^k) = 0`.  So the whole stratum can be a strict
> support only with a **nonconstant** local system on a dense open subset.

> **Proposition C9 (what a plane-curve support needs).**  Let `S subset Pi`
> be a curve inside an involution eigenplane `Pi ~ P^2` of `P(U)`, of degree
> `delta`, in the classical channel.  Then the carrier is `H^1(S~)` for a
> smooth projective model, `sigma` acts trivially on it (`sigma` acts
> trivially on `Pi`), `H = Stab_G(S) subset Stab_G(Pi) = C_6`, and the
> admissible channels are the three `sigma`-trivial characters
> `psi_0, psi_2, psi_4` of `C_6`, each with multiplicity 2 in `Res_{C_6}T`
> (total dimension `6 = dim T^{C_2}`; §D').  The CM floor forces
> `E_{-11} subset Jac(S~)`, hence `g(S~) >= 1`, hence
> \[
> \delta\ge3 .
> \]
> Capacity: the orbit has `<= 110` members (one per plane), needing even
> `d >= 4` (`c = 4`).

**Superseded in detail by `O4_EIGENPLANE_CURVES.md` (2026-08-11, exit
`O4-SPLIT`).**  Three corrections and one refutation:

* `H_0 = C_2` **exactly** and `H in {C_2, C_6}`, with orbit `110` or `330`;
  the residual action on `Pi` is the diagonal `C_3 = diag(1,w,w^2)` with
  exactly three fixed points (Thm O4-1, proved from the `C_12`-decomposition
  of `U`).
* the `sigma`-**sign** structures are not excluded — for each of them exactly
  one `C_3`-channel dies, and the `psi_3` case is the already-recorded kill
  K-d (Prop O4-3).
* capacity by **total degree** (refined Bézout bounds `sum deg`, not the
  component count): an orbit of 110 plane cubics needs even `d >= 6`, not
  `d >= 4` (Prop O4-6).
* the proposed closing move is **refuted**: every eigenplane carries a
  `C_3`-stable plane cubic isomorphic to `E_{-11}` satisfying (AHS-spin)
  exactly (Thm O4-5).  What *does* die at `delta = 3` is the nonzero-weight
  case, where the `C_3`-action has a fixed point on the cubic, forcing
  `j(S) = 0`, CM by `Q(sqrt(-3))`, and `Hom(S, E_{-11}) = 0` (Thm O4-4).

(That `H <= C_6` for a positive-dimensional `S subset Pi` is because two
distinct eigenplanes meet in at most a point, so any `h` with `h(S) = S`
must fix `Pi`; and `Stab_G(Pi) = C_6` exactly, the six `D_12`-reflections
swapping the two planes of `sigma` — sealed, `KLEIN_SPIN_COMPLEX.md` §2.)

---

## 5. The census table

`Sigma_spin`-indexed.  "for `V = U`" columns use the multiplicity-free
measured geometry; "general spin `V`" is the uniform verdict.

### 5.1 Zero-dimensional supports (`H = H_0`, nine cells)

| cell | `H` | orbit `N` | `j_0` | min live `d` | verdict | note |
|---|---|---:|---|---:|---|---|
| **P0** | `1` | 660 | `4-n` | 4 | **OPEN, WITNESSED** (W1) | no character obstruction (`Res_1 T = 10.triv`); capacity satisfied at the minimal live degree |
| **P1** | `C_2` | 330 | `4-n` | 4 | **OPEN, WITNESSED** (W1) | `Res T = 6.triv (+) 4.sign`; both channels live |
| **P2** | `C_3` | 220 | `4-n` | 4 | **OPEN, WITNESSED** (W1) | `2.triv (+) 4.omega (+) 4.omega^2` |
| **P3** | `C_5` | 132 | `4-n` | 4 | **OPEN, WITNESSED** (W1) | `2.triv (+) 2.psi_k` each `k` |
| **P4** | `C_6` | 110 | `4-n` | 4 | **OPEN, WITNESSED** (W1); `psi_3` channel **DEAD** | a `psi_3`-isotypic fibre carries nothing |
| **P5** | `S_3` | 110 (x2) | `4-n` | 4 | **OPEN, WITNESSED** (W1); sign channel **DEAD** | MANDATORY (K4).  Residual: bound `dim q(p^{-1}(x)) <= 1` |
| **P6** | `D_10` | 66 (x2) | `4-n` | 4 | **OPEN, WITNESSED** (W1); sign channel **DEAD** | MANDATORY (K4).  `V14^{D_10} = empty` is *satisfied* by the witness `Z_x = V14` |
| **P7** | `C_11` | 60 | `4-n` | 4 | **OPEN, WITNESSED** (W1) | must carry `E_{-11}^5`; the demand is met **exactly** by `J(V14)` |
| **P8** | `F_55` | 12 | `4-n` | 4 | **OPEN, WITNESSED** (W1) | **MANDATORY** (Thm O3-3, new): `V14^{F_55} = empty` unconditionally |

`W1` = the total-degeneration witness, `TOTAL_DEGENERATION.md` Theorem W1:
the single datum `(Y_x, q|_{Y_x}, W_x) = (V14, id, H^3(V14,Q))` satisfies
every necessary condition the package imposes, in **all nine cells at once**,
with the Hom of (AHS-spin) an isomorphism and the Cor S4 floor met exactly at
`P7`, `P8`.  Hence **no point cell is closable by this machinery**
(Theorem W2).

The "min live `d`" column is now the true minimum: `d = 4` is the smallest
degree at which a `G`-equivariant map `P(U) --> V14` exists at all
(`O1_O5_FREE_AND_MULTIPLICITY.md` Theorem O1-0), which dominates every
capacity row.  At multiplicity `m >= 2` it drops to `d = 2`.

### 5.2 Positive-dimensional supports (nine cells, indexed by `H_0`)

| cell | `H_0` | possible `H` | max `s` for `V=U` | verdict for `V = U` | verdict for general spin `V` |
|---|---|---|---:|---|---|
| **S0** | `1` | any of the 14 types | `n-3` | **OPEN** | **OPEN** — the large escape |
| **S1** | `C_2` | `C_2, C_6` exactly (`H_0 = C_2` exactly, Thm O4-2) | 2 | **OPEN**, and **not closable**: whole-plane DEAD in the constant channel (C8); genus-0 curves DEAD; nonzero-weight plane cubics DEAD (`j = 0`, Thm O4-4); the Hesse channel is **WITNESSED** (Thm O4-5) | OPEN |
| **S2** | `C_3` | `C_3, C_6, S_3, D_12`; realised: `C_6` (orbit 110) and `D_12` (orbit 55) | 1 | **DEAD in the constant-coefficient channel** — the only curve inside a `C_3`-eigen-line is the line, `IH^1(P^1) = 0` (Prop O4-7); residual: nonconstant local systems only | OPEN |
| **S3** | `C_5` | `C_5, D_10`; realised: `D_10` (orbit 66) | 1 | **DEAD in the constant-coefficient channel** (Prop O4-7); residual: nonconstant local systems only | OPEN |
| **S4** | `C_6` | `C_6, D_12` | — | **DEAD** (`P(U)^{C_6}` is 6 points) | OPEN for `m >= 2` (`P(V)^{C_6}` is `6` copies of `P^{m-1}`) |
| **S5** | `C_11` | `C_11, F_55` | — | **DEAD** (`P(U)^{C_11}` is 6 points) | OPEN for `m >= 2`, but the **constant-coefficient channel is DEAD** (kill `K-m`, new); must carry `E_{-11}^5` |
| **S6** | `S_3` | `S_3, D_12` | — | **DEAD** (`P(U)^{S_3}` is 2 points) | OPEN for `m >= 2`; sign channel DEAD |
| **S7** | `D_10` | `D_10` only | — | **DEAD** (`P(U)^{D_10}` is 2 points) | OPEN for `m >= 2`; sign channel DEAD |
| **S8** | `F_55` | `F_55` only | — | **DEAD** (`P(U)^{F_55}` is 1 point) | OPEN for `m >= 2`, but **every rank-one equivariant channel is DEAD** (kill `K-n`, new): only `theta_1`, `theta_2` survive; must carry `E_{-11}^5` |

### 5.3 Cross-cutting kills

| kill | statement | verified |
|---|---|---|
| **K-a** | odd coordinate degree `d`: **no equivariant map at all** | Thm C6 (§G) |
| **K-b** | point supports with `dim Y_x <= 1`: **DEAD** (`H^3` of a curve is zero) | Prop S5 (§F) |
| **K-c** | point-support orbits of size 11, 55 or 1: **DEAD** (no such spin point stabilizer) | Cor C3 (§B) |
| **K-d** | sign-isotypic blocks at any `S_3`- or `D_10`-support, `psi_3`-isotypic blocks at any `C_6`-support: **DEAD** | Thm C4 (§D') |
| **K-e** | carriers isogenous to powers of `E_sigma`: **DEAD** (`j = 8192/11` non-CM), and dead again by K-b | §4.1 |
| **K-f** | whole linear eigen-strata in the constant-coefficient channel: **DEAD** (`H^1(P^k) = 0`) | Prop C8 |
| **K-g** | at `d = 2`: all free (`N = 660`) component orbits, every dimension.  **VACUOUS for `V = U`** — there is no equivariant map of degree 2 at all (Thm O1-0); in force from `m = 2` | §G, `verify_min_degree.py` §G |
| **K-h** | `H = A_4, A_5, G` supports with any pointwise kernel other than `1`: **DEAD** | Prop C2 (§B') |
| **K-i** | curve supports of **geometric genus 0** (any degree, any eigenplane, constant channel): **DEAD** (`IH^1 = H^1(P^1) = 0`) | Thm O4-4(1) |
| **K-j** | `C_3`-stable plane **cubics of nonzero weight** in an eigenplane: **DEAD** (`j(S) = 0`, CM by `Q(sqrt(-3))`, so `Hom(S,E_{-11}) = 0`) | Thm O4-4(2) (§D) |
| **K-k** | whole `C_3`- and `C_5`-**eigen-lines** in the constant-coefficient channel: **DEAD** (`IH^1(P^1) = 0`), and for `V = U` these are the *only* positive-dimensional supports in those strata | Prop O4-7 (§B) |
| **K-l** | for each `sigma`-**sign** equivariant structure `psi_j` (`j` odd) at a `C_6`-support, **one** `C_3`-channel is DEAD (`a = 1, 0, 2` for `j = 1, 3, 5`); `j = 3, a = 0` is K-d | Prop O4-3 (§C) |
| **K-m** | *(new)* a positive-dimensional support inside `P(V)^{C_11}`: the **constant-coefficient** channel is DEAD, for every spin source, every `m`, every degree, every dimension and every local system (`Res_{C_11}T` has no invariants) | Thm W3 (`verify_total_degeneration.py` §C8) |
| **K-n** | *(new)* a positive-dimensional support inside `P(V)^{F_55}`: **every rank-one** equivariant channel is DEAD; only the two 5-dimensional structures `theta_1, theta_2` survive (`Res_{F_55}T` contains no linear character) | Thm W3 (§C9) |
| **K-o** | *(new, degree level)* on the minimal source `P(U)` there is **no** `G`-equivariant rational map of coordinate degree `d < 4`; the minimal live degree is `4` (and `2` for `V = U^{(+)m}`, `m >= 2`) | Thm O1-0 (`verify_min_degree.py`) |

Total: **18 primary cells**, of which **5 are DEAD for the multiplicity-free
source `U`** (S4-S8), **2 more (S2, S3) are DEAD for `U` in the
constant-coefficient channel** (2026-08-11), and **0 are DEAD for all spin
sources and all degrees**; plus **15 cross-cutting kills**, none of which
empties the census.  All nine point cells and cell `S1` now carry explicit
**witnesses**, so no cell can be emptied by this machinery either.

---

## 6. The OPEN cells — every one of them witnessed (2026-08-11, campaign)

```text
+---------------------------------------------------------------------------+
| BOXED: the surviving admissible-support cells for a dominant               |
| G-equivariant phi : P(V) --> V14 with V any faithful spin source --        |
| and, for each, the WITNESS that makes it unclosable by this machinery.     |
|                                                                           |
| (O1)  FREE SUPPORTS.  H_0 = 1, any dim s in [0, n-3], H arbitrary.        |
|       No character obstruction at all (Res_1 T = 10.triv).  Capacity      |
|       screens exactly one live degree, d = 4, and only in the positive-   |
|       dimensional rows; the point row 660 <= 4^5 = 1024 passes.           |
|       WITNESS: cell P0 under Theorem W1.                                  |
|                                                                           |
| (O2)  THE 352 MANDATORY POINTS.  H = S_3 (2 x 110), H = D_10 (2 x 66),    |
|       j_0 = 4-n, sign channel DEAD, triv and std / W_1,W_2 channels OPEN. |
|       The dim Y_x = 2 branch is NARROWED (Prop O2-3: a smooth ample       |
|       divisor of V14 has irregularity 0, so E_{-11} must come from        |
|       branching), but the dim Y_x = 3 branch is untouched.                |
|       WITNESS: cells P5, P6 under Theorem W1 -- and V14^{D_10} = empty,   |
|       the measurement meant to close the cell, is what SATISFIES the      |
|       fixed-point-free requirement for Z_x = V14.                         |
|                                                                           |
| (O3)  THE ODD-ORDER POINTS.  H = C_11 (orbit 60), H = F_55 (orbit 12).    |
|       Res_H T is Q-IRREDUCIBLE with no invariants, so a single support    |
|       must carry all of T, i.e. E_{-11}^5.  There is NO field-mismatch    |
|       kill: the forced CM type is the quadratic-residue type of           |
|       Q(zeta_11), it is INDUCED from Q(sqrt(-11)), and the two demands    |
|       -- Q(zeta_11)-multiplication and E_{-11}^5-isogeny -- are the SAME  |
|       demand (Thm O3-4).  NEW: the 12 F_55-points are MANDATORY base      |
|       points, because V14^{F_55} = empty unconditionally (Thm O3-2).      |
|       WITNESS: cells P7, P8 under Theorem W1, with the k = 5 floor met    |
|       EXACTLY by A_x = J(V14) ~ E_{-11}^5.                                |
|                                                                           |
| (O4)  EIGENPLANE / EIGEN-LINE SUPPORTS.  Split 2026-08-11.  DEAD in the   |
|       constant-coefficient channel: whole eigenplanes (C8), whole C_3-    |
|       and C_5-eigen-LINES (K-k), genus-0 eigenplane curves (K-i), and     |
|       C_3-stable plane cubics of nonzero weight (K-j).                    |
|       WITNESS: the Hesse-family member isomorphic to E_{-11} in every     |
|       one of the 110 eigenplanes (Thm O4-5), plus O4e and O4g.            |
|                                                                           |
| (O5)  HIGHER-MULTIPLICITY STRATA.  S4-S8, empty for V = U, revive for     |
|       V = U^{(+)m}, m >= 2.  NEW KILLS at the stratum layer: K-m (C_11,   |
|       constant channel) and K-n (F_55, every rank-one channel).           |
|       WITNESS: the POINT layer of every revived stratum is cell P4, P5,   |
|       P6, P7 or P8, all witnessed by Theorem W1 -- a stratum-level kill   |
|       can never empty a cell whose point layer survives.                  |
+---------------------------------------------------------------------------+
```

> **Theorem (the census is closed to attack).**  Every boxed family carries
> a witness, so `SPIN-SUPPORT-CENSUS-CLOSED` is **unreachable** by this
> machinery and the `FIX_IX_v14.md` Cor IX.5 consequence chain cannot be
> triggered by it.  See `TOTAL_DEGENERATION.md` Theorem W2 and Cor W2.1, and
> §6 of that file for the boxed statement of what a stronger method must see.

**Corrections recorded.**  The 2026-08-11 correction that `(O4)` is the
*least* promising cell rather than the most is confirmed and generalised: the
cells `(O2)` and `(O3)`, named there as the sharp ones, are also unclosable,
and for a reason that has nothing to do with their arithmetic.  `(O3)`'s
arithmetic, the sharpest in the census, turns out to be a **tautology** — the
`E_{-11}^5` demand is met exactly by the target's own intermediate Jacobian.

## 7. Honest limits, and named next tasks

1. **No cell dies for all degrees and all spin sources, and none can.**  The
   headline consequence chain of `FIX_IX_v14.md` Cor IX.5 is therefore **not**
   triggered; Problem E's spin flank stays OPEN.  This packet supplies a
   necessary condition and a census, not an obstruction — and, since
   2026-08-11, a proof that no obstruction of this shape exists
   (`TOTAL_DEGENERATION.md`).
2. ~~`b_3(V14) = 10`, `h^{2,1}(V14) = 5`, `rho(V14) = 1` are **literature**
   values~~ — **CLOSED 2026-08-11**, `SEAL_V14_BETTI.md`, exit
   `V14-BETTI-SEALED`, verifier `V14_BETTI_OK`.  All three are now derived
   in-repo from the sealed model (`V14` = codimension-5 linear section of
   `Gr(2,6)`): `rho = b_2 = 1` by Sommese's Lefschetz theorem for the ample
   rank-5 bundle `O(1)^{(+)5}`, and `chi_top(V14) = -6` by exact Schubert
   calculus, whence `b_3 = 10` and `h^{2,1} = 5`.  Theorem S0 leans on no
   unsealed input, and the same seal discharges the flag in
   `MULTIPLICITY_ROUTE.md` §5 and in `ADVERSARIAL_TESTS.md` §B9.
3. `chi_top(V14^g)` at `g` of order `3, 5, 6` is predicted (`6, 4, 2`) and
   **not measured**; one run of `verify_v14_s3_d10.py`'s machinery decides all
   three and would give an independent confirmation of Theorem S0 (the `10'`
   alternative predicts `3, 4, 5`).
4. ~~The **minimal live coordinate degree** is not computed.~~ — **CLOSED
   2026-08-11**, `O1_O5_FREE_AND_MULTIPLICITY.md` Theorem O1-0, verifier
   `MIN_DEGREE_OK`: `M = 10'`, `Lambda^2 U = 5 (+) 10'`, `S^2 U = 10 (+) 11`,
   and `dim Hom(M^*, S^d U^*) = 0,0,0,3,0,6,0,22,0,42,0,99` for `d = 1..12`.
   The minimal live degree is **`d = 4`** for `V = U` (a `P^2` of candidate
   landing tuples) and **`d = 2`** for `V = U^{(+)m}`, `m >= 2` (multiplicity
   `C(m,2)`, by Cauchy).  Kill `K-g` is vacuous on the minimal source.
5. The fixed-point networks of the **other** spin irreducibles (dimensions
   `10, 10, 10, 12, 12`) are not computed anywhere in-repo; cell `(O5)` is
   correspondingly coarse.  Theorem S3 itself is uniform in the source, so
   only the census needs the extra data.
6. No transfer to a restricted graph on `V14` is claimed; the target-side
   full-support term `IC_{V14}` already contributes `H^3(V14)`, so the
   `RESTRICTED-TRANSFER-UNDECIDED` boundary of the ambient packet is
   inherited unchanged.

## 8. Exit

```text
SPIN-SUPPORT-CENSUS-TABLED
SPIN-SUPPORT-CENSUS-CLOSED-TO-ATTACK       (2026-08-11 campaign)
SPIN-HODGE-SUPPORT-METHOD-INSUFFICIENT     (TOTAL_DEGENERATION.md)
SPIN-CHAIN-OBSTRUCTION-UNDECIDED           (unchanged)
O4-SPLIT                                   (O4_EIGENPLANE_CURVES.md)
O3-OPEN-WITH-WITNESS                       (O3_ODD_ORDER_POINTS.md)
O2-OPEN-WITH-WITNESS                       (O2_MANDATORY_POINTS.md)
O1-OPEN-WITH-WITNESS, O5-OPEN-WITH-WITNESS (O1_O5_FREE_AND_MULTIPLICITY.md)
V14-F55-EMPTY-UNCONDITIONAL                (Thm O3-2)
F55-STRATUM-MANDATORY                      (Thm O3-3)
MIN-LIVE-DEGREE-COMPUTED                   (Thm O1-0)
V14-BETTI-SEALED                           (SEAL_V14_BETTI.md)
TOTAL_DEGENERATION_OK, O3_ODD_ORDER_OK, MIN_DEGREE_OK   (verifier markers)
```

`SPIN-SUPPORT-CENSUS-CLOSED` — meaning *every cell dead* — is **NOT** claimed
and is now **provably unreachable** by this machinery: 18 cells, 5 dead for
the multiplicity-free source (7 counting S2 and S3, dead for `U` in the
constant-coefficient channel only), none dead uniformly, and all five boxed
OPEN families carrying explicit witnesses.  What *is* claimed is
`SPIN-SUPPORT-CENSUS-CLOSED-TO-ATTACK`: every cell has been adjudicated and
the adjudication is negative for the method.
