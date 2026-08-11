# Replay

From this directory (`problems/E-klein-cubic/goal_runs_20260810/SPIN_SOURCE_NETWORK/`):

```text
python3 verify_spin_klein_network.py
python3 verify_spin_dp2_psl27.py
```

Final markers:

```text
SPIN_SOURCE_NETWORK_OK
SPIN_DP2_PSL27_OK
```

Runtime: about 20 s each on one core. Python 3 standard library only
(`fractions`, `itertools`, `collections`, `json`). No Macaulay2, no msolve,
no network access, no data files.

## What each script actually asserts

`verify_spin_klein_network.py` (`q = 11`, self-contained):

* `|SL(2,11)| = 1320`, its full element-order profile, and that `-I` is its
  only involution;
* `rho = Ind_B(chi)` is a homomorphism (checked against **all** 1320 group
  elements and both generators), faithful, and `rho(-I) = -id_12`;
* `<chi_W, chi_W> = 2` and `chi_W = 0` on all 110 order-4 elements;
* 55 involutions, 55 four-groups forming a `55_3` configuration, every
  preimage `= Q_8`, and `U|_{Q_8} = 3H` with no 1-dimensional summand;
* the 110 eigenplanes are `P^2`s, stabiliser `C_6`, swapped by the 6
  reflections of `C_G(sigma) = D_12`;
* the complete `5995`-pair incidence table, with the `V_4`- and
  `D_12`-disjointness singled out;
* the 352 distinct incidence points, their stabilisers (`S_3`, `D_10`
  exactly), the orbit count, and the `K`-representation `T_x`
  (`m_triv = 0`, `m_sign = 1`, eigen-dimensions `2` and `3`);
* connectivity, 36-regularity, eccentricity 3, and that `D_12`-paired planes
  sit at distance exactly 2;
* the `C_3`, `C_5`, `C_6`, `C_11` eigen-strata multiplicities.

`verify_spin_dp2_psl27.py` (`q = 7`, uses `spin_network_lib.py`):

* the same structural chain for `SL(2,7)`: order 336, unique involution,
  `W_7` purely spin of dimension 8, `U` of dimension 4;
* 21 involutions, 14 four-groups, `U|_{Q_8} = 2H`, `P(U)^{V_4}` empty;
* 42 eigenlines in `P^3`; pair types `2,3,4` only; `V_4`- and `D_8`-pairs
  disjoint; `S_3` the only incidence type;
* 56 incidence points, each on 3 lines with `Stab = S_3` exactly;
* `T_x = sign (+) std` with `m_triv = 0` — the no-scalar-birth diagnosis;
* connectivity and 8-regularity;
* **`crosscheck_q11`**: an independent recomputation of the entire `q = 11`
  network through this library, reproducing 110 planes, 1980 edges,
  `220 + 132` incidence points, connectedness and `U|_{Q_8} = 3H`.

Every assertion is a real equality or emptiness test on exactly computed
objects. A failing assertion prints its name and the script exits `1` with
`*_FAILED` instead of the marker.

## Exactness

All arithmetic is over `Z`, `Q`, or `Q(i)` with `fractions.Fraction`. The
6-dimensional (resp. 4-dimensional) spin representation is never written out
over `Q(zeta_11)` (resp. `Q(zeta_7)`); instead the integral monomial model
`W = Ind_B(chi)` of dimension `q+1 <= 12` is used, and every spin quantity is
recovered by the halving principle (`dim(S n U) = dim S / 2`, proved by
Galois descent in the file headers). This keeps the whole computation inside
the permitted envelope: exact character theory plus exact linear algebra in
dimension `<= 12`.

---

# Replay — `V14^{S3}` / `V14^{D10}` measurement (added 2026-08-10)

From this directory:

```text
python3 verify_v14_s3_d10.py              # all four modes, python + Macaulay2
python3 verify_v14_s3_d10.py 397          # one mode
python3 verify_v14_s3_d10.py 397 --no-m2  # exact rank certificates only
```

Final markers:

```text
V14-S3-NONEMPTY
V14-D10-EMPTY
V14-A4-NONEMPTY
V14-A5-EMPTY
V14-S3-D10-MEASUREMENT-OK
```

Modes: `397`, `199`, `353` (finite fields, `p = 1 mod 11`) and `K` (exact
characteristic 0 over `K = Q(z)/Phi_11`). Runtime: a few seconds per prime;
`K` takes several minutes, most of it building the 1320-element even-Weil
closure over `Q(zeta_11)` and then running Macaulay2 over the number field.
Python 3 standard library only (`fractions`, `itertools`, `subprocess`) plus
Macaulay2, which is invoked on drivers this script generates. No msolve, no
network access, no data files.

## What it asserts

Model layer (every mode), regression against `FIX-IX-SEAL`:

* `gauss^2 = -11`, `S6^2 = -I`, `|<T6,S6>| = 1320`;
* the projective order profile of `PSL(2,11)` — `(1,55,110,264,110,120)`;
* the `10'`-isotypic projector has rank 10 and fixes its column space;
* the subgroup lattice, recomputed not assumed: 55 `C_3`, 66 `C_5`, **110
  `S_3` in two `G`-classes of 55**, 66 `D_10`, 55 `A_4`, 22 `A_5` in two
  classes of 11;
* `dim M^{sigma,+} = 6`, `dim M^{sigma,-} = 4`, and through Macaulay2
  `REG SIGPLUS dim 2 degree 6`, `REG SIGMINUS dim 1 degree 2`,
  `REG V14 dim 4 degree 14` — the sealed genus-1 sextic, the two isolated
  `sigma`-points, and `V14` itself, reproduced by the new pipeline in all
  four modes (the `K` value of the ambient degree is new: the seal ran the
  direct ambient Groebner basis at the primes only).

Measurement layer (every mode), for `S_3` (both classes), `D_10`, `A_4`,
`A_5` (both classes):

* `dim M_chi` for every linear character, against the character-theoretic
  prediction `<Res_H chi_{10'}, chi>`;
* an exact **rank certificate**: whenever the 15 restricted Pluecker quadrics
  span the whole space of quadratic forms on `M_chi`, the locus is empty as a
  scheme with no Groebner basis at all (this settles `D_10`, `A_5`, the `S_3`
  sign point and the `A_4` `omega`-pair);
* Macaulay2 on the rest: `saturate == ideal 1` for the empty pieces, and
  `dim 1 degree d` with the Jacobian smoothness criterion (= reducedness for
  a 0-dimensional scheme) for the nonempty ones; `radical` and
  `primaryDecomposition` in addition at the primes, where Macaulay2 supports
  them;
* the **same verdicts again from the definition** in the ambient `P^9`:
  `I_V14 + minors(2, [x ; g.x]) + minors(2, [x ; h.x])` for `H = <g,h>`, which
  uses no character theory;
* at the primes, an exhaustive search of `P(M_chi)(F_p)` for the actual
  points, and their `G`-stabilisers computed by acting with all 660 elements:
  `Stab = S_3` exactly with set-stabiliser of order 12 (so `D_12` swaps the
  two points), `Stab = A_4` exactly for the `A_4` point.

A failing assertion is printed with its name and the script exits `1` with
`V14-S3-D10-MEASUREMENT-FAILED` instead of the markers.

The generated Macaulay2 drivers `v14_fixed/m2_v14fixed_<mode>.m2` are
committed and carry the exact ideals in all four modes; their `.out` outputs
and the console `.log`s are regenerated by the replay and are gitignored, as
with `FIX_IX_SEAL/results/`.

---

# Replay — the multiplicity route (added 2026-08-10)

From this directory:

```text
python3 verify_spin_multiplicity.py
```

Final marker:

```text
SPIN_MULTIPLICITY_OK
```

Runtime about 40 s on one core. Python 3 standard library only
(`fractions`, `collections`), importing `spin_network_lib` from this
directory. No Macaulay2, no msolve, no network access, no data files.

## What it asserts

Sections A-D, source-side, exact over `Q(i)` in the 12-dimensional integral
monomial model:

* the network regression — 55 involutions, 110 eigenplanes, 1980 incident
  pairs, 352 incidence loci (220 on 3 planes, 132 on 5), stabilisers exactly
  `S_3` and `D_10` measured by acting with all 660 elements of `G` (with the
  fast monomial-action routine cross-checked against
  `spin_network_lib.stab_of_point`);
* the Thm K5 regression at `m = 1`: `T_x` is 5-dimensional with
  `m_triv = 0`, `m_sign = 1`, eigen-dimensions `(2,3)`, on all 352 loci;
* the **four-sign incidence pattern** `(1,0,0,1)` on every one of the 1980
  incident pairs, and the partner map (the second spin linear character of
  `Ktilde`) as a fixed-point-free involution on the 352 loci preserving the
  stabiliser;
* the 352 loci are **pairwise disjoint** (all 61776 pairs), each plane carries
  exactly 12 of them, and every meeting pair of planes meets exactly in one of
  them.

Section E, the multiplicity ledger for `m = 1..8`:
`dim Z = m-1 = m_triv(T_x) = dim T_x Z`, hence `m_triv(N_Z) = 0`; and
`dim A = 3m-2`, `dim B = 4m-2`, `dim S_Z = 2m-2`.

Section F, the decisive one: the connected components of
`Fix(Bl_W P(V)) = U_rho (Bl_W P(V))^rho`, built by union-find from the
computed intersection dimensions — `462 = 110 + 352` components, of sizes
`{13: 110, 3: 220, 5: 132}`, with the 110 carriers in 110 distinct
components.

Section G, the `D_10` destruction centre: 66 Sylow 5-subgroups, each with a
2-dimensional `(-1)`-eigenspace of its `C_10`-lift; the 2145 pairs split
`{0: 1485, 2: 660}` with the 660 meeting pairs exactly those inside a common
Borel; 12 Borels `F_55`, 11 concurrent lines each, one fixed point each, no
involution fixing it; all 132 `D_10`-fixed points on their own `C_5`-line and
none an `F_55` point; `m_triv(T_z | C_5) = 2m-1 = dim L` for every `m`.

Section H, the abelian audit: every preimage of a Klein four-group is `Q_8`
with `U|_{Q_8} = 3H` (no 1-dimensional summand), and `C_2, C_3, C_5, C_6,
C_11` all have nonempty fixed loci on `P(U)`.

A failing assertion is printed with its name and the script exits `1` with
`SPIN_MULTIPLICITY_FAILED` instead of the marker.

---

# Replay — the ported Hodge-support obstruction and its census (added 2026-08-10)

From this directory:

```text
python3 verify_spin_hodge_census.py
```

Final marker:

```text
SPIN_HODGE_CENSUS_OK
```

Runtime about 30 s on one core, 206 assertions.  Python 3 standard library
only (`fractions`, `itertools`).  Self-contained: it does **not** import
`spin_network_lib`, and it builds `SL(2,F_11)` from `2x2` matrices mod 11.
No Macaulay2, no msolve, no network access, no data files.

## What it asserts

Section A, the group layer, from scratch:

* `|SL(2,11)| = 1320`, `-I` its unique involution, `|PSL(2,11)| = 660` and
  the projective order profile `(1,55,110,264,110,120)`;
* the **whole subgroup lattice** recomputed by cyclic extension from one
  representative of each cyclic class: 620 subgroups in 16 conjugacy classes
  and 14 isomorphism types, matching Dickson — in particular `S_3` and `A_5`
  each falling in two `G`-classes, as `V14_S3_D10_MEASUREMENT.md` §1 records.

Section B, the spin layer: for a representative of every one of the 16
classes, the derived subgroup of its `SL(2,11)`-preimage, and the verdict
`-I in [Htilde,Htilde]?`.  Result:
`Sigma_spin = {1, C_2, C_3, C_5, C_6, C_11, S_3, D_10, F_55}` can fix a point
of a faithful spin source and `{V_4, A_4, A_5, D_12, G}` cannot, with
`|[Htilde,Htilde]| = 2, 8, 120, 6, 1320`.  Hence the point-support orbit
sizes are exactly `{12, 60, 66, 110, 132, 220, 330, 660}` and **11 and 55 are
impossible**.

Section B', the support-stabiliser classification: `N_G(H_0)` for every
`H_0 in Sigma_spin`, and the full list of `H` with `H_0` normal in `H` and
`H <= N_G(H_0)`; dually, the possible pointwise kernels of a spin-blocked
setwise stabiliser (`A_4`, `A_5`, `G` force `H_0 = 1`).

Section C, the character layer: `<chi_W, chi_W> = 1` from the sealed
5-dimensional Klein character, `chi_T = (10,2,-2,0,2,-1)` on element orders,
`<chi_T,chi_T> = 2`, `<chi_T,1> = 0`, and `<chi_T, chi_{10}> =
<chi_T, chi_{10'}> = 0` — so `T` is the third rational 10-dimensional
irreducible and is **not** the `10'` that carries the sealed `V14`-model.

Section D, the restriction layer: `Res_H T` for all fourteen isomorphism
types, computed from **order-summed** character tables `s(psi,o) =
sum_{ord h = o} psi(h)` (integers, because Galois permutes the elements of a
given order).  Each table self-validates against three exact identities —
`sum psi(1)^2 = |H|`, `sum_psi psi(1) s(psi,o) = |H| delta_{o,1}`, and
`sum_psi s(psi,o) s(psi,o') = delta_{oo'} |H| n_o` — **before** any
multiplicity is read, and every multiplicity is asserted to be a nonnegative
integer summing to `dim T = 10`.  The corollaries: sign multiplicity `0` in
`Res_{S_3}T` and `Res_{D_10}T`, `psi_3` multiplicity `0` in `Res_{C_6}T`, no
invariants and `Q`-irreducibility for `C_11` and `F_55`, and
`Res_{D_12}T = 2.(1(x)triv) (+) 2.(1(x)std) (+) 2.(eps(x)std)`.

Section E, the target layer: the Lefschetz identification of `T` on the
`V14` — `chi_top(V14) = -6`, the three candidates for `H^{2,1}` in dimension
5, the sealed `chi_top(V14^sigma) = 2` selecting `W`/`Wbar`, and the five
fixed-locus Euler-characteristic predictions `(2,6,4,2,5)` at orders
`(2,3,5,6,11)`, two of which reproduce known values.

Section F, the perverse ledger: `i = s+4-n-j_0`, the `n = 5` regression
against `THEOREM_POINT_SUPPORT.md` and `AMBIENT_SUPPORT.md` §8, the new
`n = 6` values, and the point-support stalk-degree identity
`j_0 + dim Y = 3` forcing `dim Y_x >= 2`.

Section G, the degree layer: the parity statement and the refined-Bezout
capacity table on `P^{n-1}` for all admissible orbit sizes, plus a regression
that reproduces `DEGREE_ACCOUNTING.md` §3's table exactly at `n = 5`.

Section H, the census: 18 primary cells, each cross-checked against sections
A-G (orbit sizes are `660/|H|`; the five cells DEAD for `V = U` are exactly
those whose `P(U)^{H_0}` is zero-dimensional; **no** cell is DEAD uniformly),
plus the eight cross-cutting kills, each asserted against its backing fact.

Section I, the mandatory `D_12` consistency test against Cor IX.6, including
the check that the degree-parity theorem holds at `D_12` level (because
`-I in [D_12tilde, D_12tilde]`) but would **not** be forced at a
spin-admissible level such as `S_3`.

A failing assertion is printed with its name and the script exits `1` with
`SPIN_HODGE_CENSUS_FAILED` instead of the marker.

---

# Replay — the `b_3` seal and the `(O4)` split (added 2026-08-11)

From this directory:

```text
python3 verify_v14_betti.py
python3 verify_o4_census.py
```

Final markers:

```text
V14_BETTI_OK
O4_CENSUS_OK
```

`verify_v14_betti.py`: 41 assertions, under a second, Python 3 standard
library only (`fractions`), self-contained.  No Macaulay2, no msolve, no
network, no data files.

* Section A builds the Chow ring of `Gr(2,6)` as symmetric polynomials in the
  two Chern roots of `S^dual`, with the Schubert basis on the `2x4` box,
  classes outside the box set to zero (the quotient by `(h_5,h_6)`), and the
  degree map "coefficient of `s_{(4,4)}`".  Regressions: 15 Schubert classes,
  a Pieri product, `h_5` out of the box, `int sigma_1^8 = 14`.
* Section B computes `c(T_{Gr}) = c(S^dual (x) Q)` from the Chern roots and
  checks `c_1 = 6 sigma_1` and `int c_8 = 15 = chi_top(Gr(2,6))`.
* Section C restricts to the codimension-5 linear section: `c_1(T_{V14}) =
  sigma_1` (index 1), `deg = 14`, `(-K)^3 = 14` (genus 8), `c_1c_2 = 24`
  (`chi(O) = 1`), `h^0(-K) = 10` by HRR — so the sealed `P(M) = P^9` is the
  anticanonical space — and the target value
  `chi_top(V14) = int c_3(T_{V14}) = -6`.
* Section D assembles `b = (1,0,1,10,1,0,1)`, `h^{3,0} = 0`, `h^{2,1} = 5`,
  `rho = b_2 = 1`, with the Hodge-diamond consistency check.
* Section E regresses against the packet: `chi_top = 4 - b_3` as Theorem S0
  uses it, the five Lefschetz predictions `(2,6,4,2,5)`, and the two known
  agreements at orders 2 and 11.

`verify_o4_census.py`: 92 assertions, a few seconds, Python 3 standard library
plus `spin_network_lib` from this directory.

* Section A rebuilds the residual action on an eigenplane from the integral
  monomial model: `chi_W` on the `C_12`-lift, the multiplicities extracted by
  orthogonality inside `Z[zeta_12]` (exact, no floating point), the halving
  principle, and the conclusion that the three `C_3`-eigenvalues on the plane
  are `1, w, w^2` — pairwise distinct, so the residual action is the diagonal
  `C_3` with exactly three fixed points.
* Section B computes setwise stabilisers directly: `Stab_G(Pi) = C_6`
  (order 6) with 6 of the 12 elements of `C_G(sigma) = D_12` swapping the
  planes; the three `C_3`-eigen-lines with stabilisers `D_12` (orbit 55) and
  `C_6` (orbit 110); the `C_5`-eigen-line with stabiliser `D_10` (orbit 66).
* Section C recomputes `Res_{C_6}T = (2,2,2,0,2,2)` and tabulates the channel
  condition `2a+j != 3 mod 6`, plus `dim T^H` for all six stabilisers.
* Section D is the plane-curve layer: the weight-0 cubics are exactly the
  Hesse family, weight-nonzero cubics contain all three coordinate points, the
  `C_3`-isotypic multiplicities of `H^1` for `delta = 3..8` and all weights,
  the general principle that every channel is nonzero for `delta >= 4`, and
  the exact `Z[w]` factorisation of `x^3+y^3+z^3-3xyz` into a triangle.
* Section E is refined-Bézout capacity by **total degree**, reproducing the
  census's component-count table at `delta = 1` and sharpening it to
  `d >= 6` for an orbit of 110 plane cubics.
* Section F is the `(O4)` verdict table and the mandatory `D_12` consistency
  test against Cor IX.6.

A failing assertion is printed with its name and the script exits `1` with
`V14_BETTI_FAILED` / `O4_CENSUS_FAILED` instead of the marker.

---

# Replay — total degeneration, the `(O3)` odd-order cell, and the minimal
live coordinate degree (added 2026-08-11)

From this directory:

```text
python3 verify_total_degeneration.py
python3 verify_o3_odd_order.py
python3 verify_min_degree.py
```

Final markers:

```text
TOTAL_DEGENERATION_OK
O3_ODD_ORDER_OK
MIN_DEGREE_OK
```

`verify_total_degeneration.py`: 87 assertions, about 1.7 s, Python 3 standard
library only, self-contained (builds `PSL(2,F_11)` from scratch, as
`verify_spin_hodge_census.py` does).  No Macaulay2, no msolve, no network, no
data files.

* Section A builds `Sigma_spin` (the nine subgroups that can support a spin
  block) and the nine point cells `P0`-`P8`: their orbit sizes `660/|H|`, the
  Cor S4 multiplicity floor `k(H)`, and the regression that orbit sizes `11`,
  `55`, `1` never occur at a point (Cor C3).
* Section B is Theorem W1, the total-degeneration witness
  `(Y_x, q|_{Y_x}, W_x) = (V14, id, H^3(V14,Q))`, checked against all eight
  package constraints C1-C8 in every one of the nine cells: the stalk-degree
  window forcing `dim Y_x in {2,3}`, the Hom-dimension table
  `dim End_H(Res_H T) = (100,52,36,20,20,20,12,10,2)`, the abelian factor
  `A_x = J(V14) ~ E_{-11}^5` meeting the Cor S4 floor in every cell and
  exactly at `C_11`/`F_55`, and the full kill audit: all twelve cross-cutting
  kills `K-a`...`K-l` of `SUPPORT_CENSUS.md` §5.3 checked and none touches the
  witness.
* Section C is Theorem W3, the pointwise-kernel selection rule: the dead
  channels at each `H_0 in Sigma_spin`, reproducing kill `K-d` at
  `C_6`/`S_3`/`D_10` and adding two new kills — the constant channel dies at
  every `C_11`-stratum, all five linear channels die at every `F_55`-stratum.
* Section D applies W3 to the positive-dimensional cells `S0`-`S8`: they are
  finite (hence not positive-dimensional) for `V = U` at `H_0 = C_6, C_11,
  S_3, D_10, F_55`, and revive as `P^{m-1}`-bundles for `V = U^{(+)m}`,
  `m >= 2`; the two new kills apply to the revived `S5`, `S8` strata but do
  not close them, because their point layer (`P4`, `P5`, `P6`, `P7`, `P8`) is
  witnessed by W1.
* Section E is `(O1)`, free supports: no character obstruction at all
  (`Res_1 T = 10.triv`), the capacity table across codimension and across
  spin-source dimension `n = 6..12`, and the verdict that capacity is a
  low-degree screen only, never an all-degree kill.
* Section F is `(O2)`, the 352 mandatory incidence points: `Res_{S_3}T` and
  `Res_{D_10}T` both sign-free (kill `K-d`), the sealed Betti numbers
  `b(V14) = (1,0,1,10,1,0,1)`, `rho(V14) = b_2(V14) = 1`, and the
  ample-divisor narrowing — a smooth ample divisor of `V14` has irregularity
  0 by Lefschetz, so the required `E_{-11}` can only be created by branching
  or by singularities of the image surface, not by the surface itself.
* Section G is the census tally — 18 primary cells, 5 dead for `V = U`
  (`S4`-`S8`), 0 dead for all spin sources and all degrees — and the
  campaign exit.
* Section H is the mandatory `D_12` test: the two new kills live at strata
  whose pointwise kernel has order divisible by 11, `11` does not divide
  `|D_12| = 12`, so neither kill is visible to the realised dominant
  `D_12`-equivariant spin map of Cor IX.6, and `dim T^{D_12} = 2 > 0` is left
  open by every verdict here. PASS.

`verify_o3_odd_order.py`: 86 assertions, about 0.2 s, Python 3 standard
library only, self-contained.  No Macaulay2, no msolve, no network, no data
files.

* Section A is the group layer: `|SL(2,F_11)| = 1320`, `|PSL(2,F_11)| = 660`,
  its order profile, `N_G(C_11) = F_55` of order 55, the 12 Sylow
  11-subgroups, and the quadratic residues mod 11, `{1,3,4,5,9}`.
* Section B is the spin source: `U|_{C_11} = triv (+)` five nontrivial
  characters, so `P(U)^{C_11}` is 6 isolated points, with the
  trivial-character eigenline fixed by `C_5` and the other five permuted
  cyclically and freely; the resulting `12 + 60` tally (12 points with
  `Stab = F_55`, 60 with `Stab = C_11`); and the tangent representation at an
  `F_55`-point, `T_x = theta_1`.
* Section C is `Res_{C_11}T` and `Res_{F_55}T`: both `Q`-irreducible of
  dimension 10 with no invariants, so the Cor S4 floor is `k = 5` at both.
* Section D is the minimal faithful degree: `mu(F_55) = mu(G) = 5 > 3`, so by
  Theorem O3-2 (Cartan linearisation) `V14^{F_55} = V14^G = empty`
  unconditionally, replacing the worker-grade mod-397 input of
  `theory/FIX_IX_v14.md` §8; and the regression that no measured
  **non**empty fixed locus has `mu(H) > 3`.
* Section E is the new mandatory base locus: the 12 `F_55`-points join the
  352 incidence points of Theorem K4 for 364 mandatory points total,
  pairwise disjoint by stabiliser, with the `d = 2` capacity count showing
  they cannot all be isolated base components at that degree.
* Section F is the CM-type computation: `Q(sqrt(-11))` is the quadratic
  subfield of `Q(zeta_11)` of index 5, the forced CM type is the
  quadratic-residue coset, and it is a union of cosets of
  `Gal(Q(zeta_11)/Q(sqrt(-11)))`, i.e. induced, so the Shimura-Taniyama
  splitting gives `A ~ E_{-11}^5` — the same conclusion Theorem S0 reaches
  independently — and there is no field-mismatch kill.
* Section G is the witness at a `C_11`/`F_55` point (Theorem W1
  instantiated), the twelve-kill audit, the verdict OPEN-WITH-WITNESS for
  cells `P7`/`P8`, and the mandatory `D_12` test: `gcd(55,12) = 1` and `D_12`
  has no element of order 11, so cells `P7`/`P8` are invisible at `D_12`
  level and this file claims zero kills. PASS.

`verify_min_degree.py`: 114 assertions, about 2 s, Python 3 standard library
only, self-contained.

* Section A builds `Gtilde = SL(2,F_11)` (15 classes) and the integral
  monomial model `W = Ind_B(Legendre)`.
* Section B computes `chi_U` exactly in `K = Q(sqrt(-11))` by the central
  class-sum projector.
* Section C identifies `Lambda^2 U = 5 (+) 10'` and `M = 10'`, the
  10-dimensional coordinate module of the sealed `V14 = Gr(2,U) cap P(M)`.
* Section D computes `chi_{S^d U}` by two independent routes — Newton's
  identities and the Molien series — agreeing on all 1320 elements up to
  degree 16.
* Section E tabulates `dim Hom_{Gtilde}(M^*, S^d U^*)` for `d = 1..12`:
  `0, 0, 0, 3, 0, 6, 0, 22, 0, 42, 0, 99` — so the minimal live coordinate
  degree for `V = U` is `d = 4`; odd `d` vanish identically, reproducing
  Theorem C6 independently and termwise.
* Section F checks convention independence: `U` vs `U'`, `S^d U` vs its
  dual, `M` vs `M^*` all agree.
* Section G shows the multiplicity source `U^{(+)m}` revives `d = 2` at
  `m >= 2`, with multiplicity `C(m,2)` by the Cauchy formula for
  `S^2(U (x) C^m)`.

A failing assertion is printed with its name and the script exits `1` with
`TOTAL_DEGENERATION_FAILED` / `O3_ODD_ORDER_FAILED` / `MIN_DEGREE_FAILED`
instead of the marker.

---

## Residuals campaign layer (2026-08-11)

```text
python3 verify_r0_dependency.py     -> R0_DEPENDENCY_OK      (323 assertions)
python3 verify_r1_degeneration.py   -> R1_DEGENERATION_OK    (117 assertions)
python3 verify_r2_covers.py         -> R2_COVERS_OK          (179 assertions)
python3 verify_r3_cm.py             -> R3_CM_OK              ( 90 assertions)
```

All four run in well under a second, Python 3 standard library only, exact
integer / `Fraction` / cyclotomic arithmetic, no sampling and no modular
reduction.  `verify_r0_dependency.py` is self-contained and the other three
import its cyclotomic engine and metacyclic character-table builder, so the
arithmetic layer is self-tested once and shared.

`verify_r0_dependency.py` (`DEPENDENCY_MAP.md`):

* Section A builds `Z[zeta_N]` from `Phi_N` by exact integer polynomial
  division and self-tests it (degree `= phi(N)`, `Phi_N | x^N-1`, the root
  sum, conjugation).
* Section B validates the `PSL(2,11)` class data from scratch (class sizes
  summing to 660, the order profile reconstructed from the 55 nonsplit tori,
  66 split tori and 12 Sylow 11-subgroups) and `chi_T` against
  `<chi_T,chi_T> = 2`, `<chi_T,1> = 0`, and Lefschetz at orders 2 and 11.
* Section C builds `Irr(H)` for every `H in Sigma_spin` and for `D_12` by
  Clifford theory from `H = C_m x| C_k`, validating each table by
  orthonormality, `sum d^2 = |H|` and the regular character.
* Section D recomputes every `Res_H T`, `dim T^H`, floor `k(H)` and dead
  channel — an independent code path reproducing
  `verify_spin_hodge_census.py` and `verify_total_degeneration.py`.
* Section E checks the perverse ledger and Proposition D2 for `n = 5..12`.
* Section F computes the closure of the dependency table under `{R1,R2,R3}`
  rather than asserting it.

`verify_r1_degeneration.py` (`R1_TOTAL_DEGENERATION.md`):

* Section A computes the arc-limit set of `[u^2 : v]` at the origin over an
  exact rational grid and the initial map, exhibiting total degeneration with
  a constant initial map.
* Section B expands `(dL - Xi)^k L^{5-k}` symbolically under the vanishing
  table `L^{5-j}Xi^j = 0` for `j + b < 5`, giving `14 delta_F = d^3` at
  `b = 1`, the divisibility `14 | d`, the low-degree window and three
  regressions (linear projection, four quadrics, the ambient `n = 5` case).
* Section C is the `F_55` representation theory: quadratic residues, the
  duality `theta_1^* = theta_2`, `Res_{F_55}M^* = theta_1 (+) theta_2`, and
  the `C_11`-weight multiplicities of `S^k(theta_1^*)`.
* Section D is the `C_11` eigen-point bookkeeping in `P(M)` and on `V14`.
* Section E audits going-down: every abelian subgroup of every occurring
  stabiliser has nonempty fixed locus on the `V14`.

`verify_r2_covers.py` (`R2_AMPLE_COVERS.md`):

* Section A: index one, degree 14, the anticanonical Hilbert function
  (`h^0(-K) = 10`, `h^0(-2K) = 40`, so exactly 15 quadrics through `V14` —
  the Pluecker quadrics), genus 8, and adjunction for `Z in |kH|`.
* Section B: the cyclic-cover ledger `q(Y) = sum_i h^1(-iL)` term by term,
  with the positivity of `K_Z + iL` checked numerically for `k = 1,2,3` and
  `e = 1,2,3`.
* Section C: linear characters in `Res_H M^*` for every `H in Sigma_spin` —
  `F_55` has none, so no `F_55`-stable hyperplane section exists.
* Section D: `(S^2M)^{C_11}` is 5-dimensional and is the regular
  `C_5`-representation, so `k = 2` is not excluded at `F_55`.
* Sections E, F: the `Cor S4` floors, and the linear-system count that rules
  out a 16-nodal member of `|H|`.

`verify_r3_cm.py` (`R3_CM_RIGIDITY.md`):

* Section A: the CM-type period domain is finite (`2^g` types).
* Section B: exact search for algebraic integers of norm one in
  `Q(sqrt(-11))` (only `+-1`), plus Hilbert-90 witnesses showing the
  integral-structure hypothesis is load-bearing.
* Section C: Hurwitz for `E -> E/[-1]`, the Euler characteristic of `j_*L`,
  and `h^1 = 2 = dim H^1(E_{-11})`.
* Section D: the cross-ratio identity `lambda = ((a-b)/(a+b))^2` for
  `C_2`-stable configurations, verified on exact rational samples, and the
  degree-six equation `j(lambda) = -32768`.
* Section E: the nonzero `Hom`, and that the proposed reduction lands on
  `FRONTIER-1`.

A failing assertion prints its name and the script exits `1` without its
marker.
