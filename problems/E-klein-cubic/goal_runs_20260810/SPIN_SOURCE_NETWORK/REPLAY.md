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
