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
