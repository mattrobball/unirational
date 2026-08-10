# The Klein-deciding spin complex: `P(U) = P^5` against the `V14`

`Gtilde = SL(2,F_11)` (order 1320), `G = PSL(2,F_11)` (order 660),
`U` = a 6-dimensional faithful (spin) irreducible — the Tschinkel-Zhang
stable factor of arXiv:2409.08392 Thm 1.1. Target: the `V14` twin, whose
`sigma`-fixed geometry is SEALED (`goal_runs_after_c53d89a/FIX_IX_SEAL`,
exit `FIX-IX-SEAL-PASS`) and is **cited, not recomputed**.

All source-side numbers below are produced by
`verify_spin_klein_network.py` (exit marker `SPIN_SOURCE_NETWORK_OK`),
exactly, in characteristic 0, with no sampling and no search, and are
independently reproduced by `verify_spin_dp2_psl27.py`'s `crosscheck_q11`
through a second code path (`spin_network_lib.py`).

## 0. The exact model

Rather than the 6-dimensional even-Weil matrices of the sealed packet
(entries in `Q(zeta_11)`, forcing the degree-40 field `Q(zeta_11, i)` the
moment one diagonalises an order-4 element), we use the **integral monomial
model**

    W  =  Ind_B^{SL(2,F_11)}(chi),   chi = the Legendre symbol,

on `{ f : F_11^2 \ 0 -> C : f(lam v) = chi(lam) f(v) }`, `(g.f)(v) =
f(g^{-1}v)`. Every `rho(g)` is a signed permutation matrix of size 12.
Since `11 = 3 mod 4`, `chi(-1) = -1`, so `rho(-I) = -id_12`: `W` is purely
spin, and `<chi_W, chi_W> = 2` gives

    W  =  U (+) U',

the two Galois-conjugate 6-dimensional spin irreducibles (conjugate over
`Q(sqrt(-11))`; `U` is the sealed packet's even-Weil representation).

**Halving principle.** `rho` has entries in `Z`, so any subspace of `W` cut
out by eigenvalue conditions with eigenvalues in `Q(i)` is defined over
`Q(i)`, hence stable under `Gal(Q(i,sqrt(-11))/Q(i))`, which swaps `U` and
`U'`. So `dim(S n U) = dim(S)/2` for every such `S`. Every 6-dimensional
spin question becomes an exact **integer** question in dimension 12.

## 1. (i) The Q8 restriction — `P(U)^{V4} = empty`

* `-I` is the **unique** involution of `SL(2,11)` (order profile verified:
  `{1:1, 2:1, 3:110, 4:110, 5:264, 6:110, 10:264, 11:120, 12:220, 22:120}`).
  Hence the preimage of every Klein four-group has order 8 with a unique
  involution: it is `Q_8`.
* `G` has **55 involutions** and **55 Klein four-groups** (the Sylow
  2-subgroups), each involution in exactly 3 of them and each four-group
  containing 3 involutions: a `55_3` configuration.
* For every one of the 55: **`U|_{Q_8} = 3 . H`**, `H` the 2-dimensional
  quaternionic irreducible. **No 1-dimensional summand.**

By Cor 2.3 of `THEORY_SPIN_ENGINE.md` this is automatic — every linear
character of `Q_8` kills `[Q_8,Q_8] = <-I>` while a spin source needs
`lambda(-I) = -1` — and it therefore holds for **every** faithful spin
source, not just `U`. Verified independently by character arithmetic.

    P(V)^{V_4} = EMPTY  for every faithful spin source V and all 55 four-groups.

This is the predicted "quaternionic" verdict of [IX §6], now proved, and it
is the exact point where the spin chain combinatorics parts company with
Problem F's (whose whole argument lives at a `V_4`-fixed point).

## 2. (ii) The 110 eigenplanes and the complete incidence table

`chi_W` vanishes on all 110 elements of order 4, so each lifted involution
splits `U` as `3 + 3`:

    P(U)^sigma  =  Pi_sigma^+  disjoint-union  Pi_sigma^-,   each  ~ P^2 in P^5.

**55 swapped pairs, 110 planes.** `C_G(sigma) = D_12` (12 elements, sealed
group fact FIX-A0, re-verified here); the stabiliser of a single plane is the
index-2 subgroup `C_6`, and the **6 reflections invert `sigmatilde` and swap
the two planes** — exactly Lemma 1.3, and exactly the escape shape of
[IX §6].

Pair types over the 1485 unordered pairs of involutions
(`n = ` projective order of `sigma tau`):
`n=2` : 165, `n=3` : 330, `n=5` : 660, `n=6` : 330.

### Incidence table (all 5995 unordered pairs of planes, exact)

| pair type | subgroup `<sigma,tau>` | plane pairs | disjoint | meeting (in a point) |
|---|---|---|---|---|
| same involution | — | 55 | 55 | 0 |
| `n = 2` | `V_4` | 660 | 660 | **0** |
| `n = 3` | `S_3` | 1320 | 660 | **660** |
| `n = 5` | `D_10` | 2640 | 1320 | **1320** |
| `n = 6` | `D_12` | 1320 | 1320 | **0** |

Every nonempty intersection is a single reduced point (intersection of the
two 3-dimensional subspaces of `U` has dimension exactly 1).

**Reading of the table.**

* `n = 2` (commuting): disjoint, and in fact **transverse**:
  `U = U_{+i}(sigma) (+) U_{eps i}(tau)`. This is the `Q_8` mechanism of §1
  seen plane-wise — in each copy of `H`, `tau` interchanges the two
  `sigma`-eigenlines. Prediction of the brief: **confirmed**.
* `n = 6` (`D_12`): disjoint. The preimage of `D_12` is the dicyclic group of
  order 24, whose abelianisation is `V_4` with `-I` in the commutator
  subgroup; so it has **no** spin linear character and
  `P(U)^{D_12} = empty`. This is the source-side mirror of the sealed
  `V14^{D_12} = empty`.
* `n = 3, 5`: exactly half of the four sign-combinations meet, because the
  preimages `Q_12` and `Q_20` have abelianisation `C_4` and hence exactly
  **two** spin linear characters, each occurring in `U` with multiplicity 1.

### The 352 incidence points

The 1980 meeting pairs come from **352 distinct points of `P(U)`**:

* **220 points with `Stab_G(x) = S_3` exactly**, each lying on **3** planes
  (one for each involution of its `S_3`) — 2 `G`-orbits of length 110;
* **132 points with `Stab_G(x) = D_10` exactly**, each on **5** planes —
  2 `G`-orbits of length 66.

`S_3` and `D_10` are maximal among the subgroups of `G` that can fix a point
of a spin source at all: `Q_8`-type preimages kill `V_4`, the dicyclic
preimage kills `D_12`, `SL(2,3)` (binary tetrahedral) kills `A_4`, and
`SL(2,5)` — perfect — kills `A_5`. So the possible point stabilisers are
exactly `1, C_2, C_3, C_5, C_6, C_11, S_3, D_10, F_55`.

**Each plane carries exactly 12 incidence points: 6 of `S_3` type and 6 of
`D_10` type.**

## 3. (iii) Connectivity of the incidence graph

    vertices 110,  edges 1980,  36-regular,  CONNECTED (one component),
    eccentricity 3 at every vertex (vertex-transitive).

Degree decomposition per plane: 12 neighbours through `S_3` points, 24
through `D_10` points. The `S_3`-only sub-network (660 edges) is already
connected on all 110 vertices; so is the `D_10`-only sub-network (1320
edges). Planes of a `D_12`-generating pair are **never adjacent** and sit at
graph distance exactly **2**.

### The odd-order strata

| subgroup | lift | `U`-spectrum | `P(U)^H` |
|---|---|---|---|
| `C_3` | `C_6` | `zeta_6, -1, zeta_6^5`, each mult. 2 | three disjoint lines `P^1` |
| `C_5` | `C_10` | four primitive `zeta_10^odd` mult. 1, `-1` mult. 2 | 4 points + one line `P^1` |
| `C_6` | `C_12` | all six spin characters, mult. 1 (multiplicity-free) | 6 isolated points, 3 in each plane of `sigma` |
| `C_11` | `C_11` | `1` mult. 1, five `zeta_11^{QR}` mult. 1 | 6 isolated points |
| `F_55` | `F_55 x <-I>` | the `C_11`-invariant line is `C_5`-stable | **1 point** |

Note `dim U^{C_11} = 1`: unlike the `F_55` first cut of [IX §8]
(which discards linear sources with `V^{C_11} != 0`), the spin source `P(U)`
**does** have an `F_55`-fixed point, so the `F_55` route does not obstruct it
directly; blowing that point up leaves an exceptional `P^4` whose
`C_11`-fixed locus is 5 points cyclically permuted by `C_5`, i.e. no
`F_55`-fixed point survives.

## 4. The target network (cited, not recomputed)

From `goal_runs_after_c53d89a/FIX_IX_SEAL` (`FIX-IX-SEAL-PASS`; char-0
smoothness DISCHARGED, `results/m2_sigma_K.out`):

* `V14^sigma` = one **smooth irreducible genus-1 sextic** `E_sigma`
  `disjoint-union` two reduced points. **No rational curve.** (Hypothesis (a)
  of Thm 4.1 holds for every involution — one class.)
* `V14^{D_12} = empty` (all four character pieces empty, two primes plus the
  char-0 pencil argument).
* `C_G(sigma) = D_12`; the two isolated points have stabiliser exactly `C_6`
  and are swapped by `D_12`.

## 5. What is PROVED here

Let `phi : P(U) --> V14` be any `G`-equivariant rational map — **dominant or
not**, any degree.

**Theorem K1 (carriers).** For each of the 110 planes `Pi` there is a point
`y(Pi)` of `V14^{sigma_Pi}` such that the carrier stratum over `Pi` (Thm 4.1)
is contracted to `y(Pi)`; `y(Pi)` is fixed by the plane's stabiliser `C_6`,
and the 6 reflections of `D_12` interchange `y(Pi_sigma^+)` and
`y(Pi_sigma^-)`.

**Theorem K2 (stabilisers are exactly `C_6`).** For every `y` in
`V14^{C_6(sigma)}`, `Stab_G(y) = C_6(sigma)` exactly, and `sigma` is its
unique involution.

*Proof.* `Stab_G(y)` contains `C_6`. The subgroup lattice of `PSL(2,11)` is
`1, C_2, C_3, C_5, C_6, C_11, V_4, S_3, D_10, D_12, A_4, A_5, F_55, G`; of
these only `C_6`, `D_12` and `G` contain an element of order 6 (`A_4` and
`A_5` have none), and `G <= D_12`-fixed loci are contained in the `D_12` one.
Since `V14^{D_12} = empty` (sealed), `Stab_G(y) = C_6`; and
`C_6 = <sigma> x C_3` has the single involution `sigma`. `QED`

Note this does **not** use the sealed "the two isolated points have
stabiliser exactly `C_6`" — it *re-derives* it, and it also covers any
`C_6`-fixed point lying on the sextic `E_sigma`, which the seal did not
measure. So Theorem K2 is unconditional given `V14^{D_12} = empty`.

**Theorem K3 (rigidity).** `y(Pi) = y(Pi')` implies `sigma_Pi = sigma_{Pi'}`,
and `y(Pi_sigma^+) != y(Pi_sigma^-)`.
*Proof.* Thm 5.1 with (b') supplied by K2; the second claim because
`Stab(y(Pi_sigma^+)) = C_6` cannot contain a `D_12`-reflection. `QED`

**Theorem K4 (mandatory base locus).** All **352** incidence points of §2 —
2 `G`-orbits of 110 `S_3`-points and 2 `G`-orbits of 66 `D_10`-points — lie
in the indeterminacy locus `Ind(phi)`.
*Proof.* Thm 5.2 with K3. Concretely: `phi` restricted to a plane has image
an irreducible RCC subvariety of `V14^sigma`, hence a point (no rational
curves), hence is the constant `y(Pi)`; two planes of different involutions
through a common point of definition would force `y(Pi) = y(Pi')`. `QED`

This is a genuine strengthening of the state recorded in [IX §6]: the
`sigma`-level is non-obstructing (Cor 4.2), but the **pairwise** level already
pins the base locus of every equivariant rational map, at every degree, with
no search.

## 6. The `D_12`-endpoint chain system, and where it stops

The intended contradiction. Take `sigma, tau` generating `D_12`. Their planes
are disjoint but at graph distance 2, so there is a plane `Pi''` adjacent to
both. If the carriers along a path were forced to share images, K3 would give
`sigma = tau` at once. So the chain system reads:

> For each edge `(Pi, Pi')` of the 1980, either the two carriers have equal
> images — contradiction by K3 — or they are separated by the equivariant
> resolution. The system closes iff at least one edge cannot be separated.

**Theorem K5 (first-order separation — the system does NOT close at first
order).** Let `x` be one of the 352 incidence points, `K = Stab_G(x)` in
`{S_3, D_10}`. Then `T_x P(U)` is a 5-dimensional **honest** `K`-representation
with (verified exactly, both types)

    m_triv = 0,   m_sign = 1,   dim T_x^{sigma,+1} = 2,   dim T_x^{sigma,-1} = 3.

For `K = S_3` this forces `T_x = sign (+) 2.std`; for `K = D_10`,
`T_x = sign (+) (two 2-dimensionals)`. Consequently

    T_x^{sigma,+1} n T_x^{tau,+1} = T_x^K = 0,

so on the exceptional `P^4` of the blowup at `x` the traces
`P(T_x^{sigma,+1}) = P^1` and `P(T_x^{tau,+1}) = P^1` of the two strict
transforms are **disjoint**: one blowup separates the two carriers. The only
pieces that do meet are the `"-1"` pieces `P(T_x^{rho,-1}) = P^2`, which all
pass through the single sign-point `P(T_x^{sign})` — and those are disjoint
from the `"+1"` pieces, hence from the carriers.

**Theorem K6 (no scalar birth).** No point of `P(U)^sigma` is a scalar point
of `sigma`: `sigma` acts on `T_x` with both eigenvalues, multiplicities
`(2,3)`. So Problem F's scalar-birth linking — where `dz|_q = -1` is scalar
precisely because `dim E_+(z) = 1` for the 3-dimensional **linear** source —
has no analogue here. This is Thm 6.1 of the engine, instantiated.

## 7. BOXED MISSING LEMMA

> **SPIN-LINKING LEMMA (open).** Let `phi : P(U) --> V14` be
> `G`-equivariant and let `x` be one of the 352 incidence points, with
> `K = Stab_G(x)` and planes `Pi_sigma^eps`, `Pi_tau^delta` through `x`.
> Show that in **every** `G`-equivariant resolution of `phi` the carriers of
> `Pi_sigma^eps` and `Pi_tau^delta` are joined by a connected chain of
> irreducible RCC subvarieties, each pointwise fixed by an involution of `G`,
> consecutive members meeting.
>
> Given this for a single edge with `sigma != tau`, Theorem K3 yields a
> contradiction, hence **no `G`-equivariant rational map `P(U) --> V14` at
> all**, and (with the folding reduction over all spin sources, Thm 7.4)
> the headline `ed_C(PSL_2(F_11)) = 4`.
>
> **Theorem K5 shows the lemma is FALSE at first order** for the
> multiplicity-free source `U`: a single blowup at `x` separates the
> carriers, because `T_x` has no `K`-invariant vector.

### The two identified routes past the box

1. **Multiplicity (Thm 7.4).** A dominant `P(U) --> V14` gives a dominant
   `P(U^{(+)m}) --> V14` for every `m`, so it suffices to obstruct
   `P(U^{(+)m})` for one `m >= 2`. There the incidence loci are `P^{m-1}`'s,
   and `<chi_{T_x}, 1_K> = m - 1 >= 1`, so the first-order separation of K5
   **disappears**. Theorems K1-K4 are multiplicity-free and survive verbatim.
   This is also the only route that discharges the "all faithful spin
   sources" quantifier that the headline actually requires: killing `P(U)`
   alone is **not** the headline.
2. **Second-generation strata.** Over an `S_3`-point the three new strata
   `P(T_x^{rho,-1}) ~ P^2` are pointwise `rho`-fixed, rational, and all pass
   through the sign-point. Their common image would be a point of
   `V14^{S_3}`. **Missing input:** `V14^{S_3}` and `V14^{D_10}` are *not*
   measured by any sealed packet. Both are decidable by the FIX-IX-SEAL
   machinery at the cost of one run. `V14^{S_3} = empty` would convert route
   2 into a contradiction wherever the resolution is defined at the
   sign-points. (`V14^{A_4} = V14^{A_5} = empty` is *not* free here — `V14`
   is a threefold and both groups have faithful 3-dimensional
   representations.)

## 8. Exit

    SPIN-SOURCE-NETWORK-COMPUTED
    SPIN-CHAIN-OBSTRUCTION-UNDECIDED

Not `SPIN-CHAIN-OBSTRUCTION-PROVED`. The network is computed exactly and in
full, the rigidity and mandatory-base-locus theorems are new and
unconditional, and the missing step is boxed above with a proof that the
naive form of it is false and two concrete routes past it.
