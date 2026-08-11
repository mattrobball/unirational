# Notebook supplement — 2026-08-10: `V14^{S3}` and `V14^{D10}` measured (the two missing inputs for route 2 of the spin-linking box)

## What was asked

Compute, exactly and as schemes, the fixed loci `V14^{S_3}` and `V14^{D_10}`
for the standard subgroups of `G = PSL(2,F_11)` on the `V14` twin. These are
the only missing inputs for **route 2** of the boxed SPIN-LINKING LEMMA
(`goal_runs_20260810/SPIN_SOURCE_NETWORK/KLEIN_SPIN_COMPLEX.md` §7): over the
352 forced-indeterminacy points the second-generation exceptional strata are
pointwise involution-fixed and all pass through a sign-point, and their
common image would be a point of `V14^{S_3}` (220 points) or `V14^{D_10}`
(132 points). Optional: `V14^{A_4}`, `V14^{A_5}`.

Packet: `goal_runs_20260810/SPIN_SOURCE_NETWORK/V14_S3_D10_MEASUREMENT.md`,
`verify_v14_s3_d10.py`, `v14_fixed/`.

## Exits

```text
V14-S3-NONEMPTY     two reduced points per S_3 subgroup (both G-classes)
V14-D10-EMPTY       empty, all 66 D_10 subgroups
V14-A4-NONEMPTY     one reduced point per A_4 subgroup
V14-A5-EMPTY        empty, both G-classes (hence V14^G = empty)
V14-S3-D10-MEASUREMENT-OK
```

## What was found

`V14 = Gr(2,U) cap P(M)` in the sealed FIX-IX model; `G` acts on the
10-dimensional `M`, and for `H <= G` the fixed locus splits as a disjoint
union of `V14 cap P(M_chi)` over the linear characters of `H` (Lemma 1 of the
packet, a scheme-theoretic statement). Character dimensions, all verified
against `<Res_H chi_{10'}, chi>`: `S_3` gives `3 + 1`, `D_10` gives `2 + 0`,
`A_4` gives `2` plus a rational `omega`-plane, `A_5` gives `1`.

| `H` | subgroups (`G`-classes) | `V14^H` per subgroup | `Stab_G` of each point | orbits |
|---|---|---|---|---|
| `S_3` | 110 (2 x 55) | **2 reduced points** | `S_3` exactly | 2 orbits of 110 |
| `D_10` | 66 (1) | **empty** | — | — |
| `A_4` | 55 (1) | **1 reduced point** | `A_4` exactly | 1 orbit of 55 |
| `A_5` | 22 (2 x 11) | **empty** | — | — |

So `V14` has exactly 220 points with stabiliser `S_3` and 55 with stabiliser
`A_4`, and none whose stabiliser contains `D_10`, `A_5`, `D_12` (sealed) or
`G`. The two `S_3`-points are swapped by `N_G(S_3) = D_12` — the exact
analogue, one level up, of the sealed `D_12`-swap of the two isolated
`C_6`-points of `V14^sigma` — and each lies on the sealed genus-1 sextic
`E_rho` of **all three** involutions of its `S_3`, so the three sextics of an
`S_3` share two points. Over `K = Q(zeta_11)` the two points are not both
`K`-rational (they do not split at 199, though they do at 397 and 353); their
sum is defined over `K`. Note `A_4` was **not** automatically empty, exactly
as the spin packet warned.

## What it does to route 2

* **Theorem V1 (new, unconditional).** For each of the 132 incidence points
  `x` with `Stab_G(x) = D_10` and every `G`-equivariant rational map
  `phi : P(U) --> V14`, the induced map `Bl_x P(U) --> V14` is **undefined at
  the sign-point** `s_x`. (The five `P^2`-strata through `s_x` would each be
  contracted — `V14^rho` has no rational curve, sealed — to the same point,
  whose stabiliser would then contain `D_10 = <rho, rho'>`.) This extends
  Theorem K4's mandatory base locus one blowup deeper: over 132 of the 352
  points the tower does not stop at the first generation.
* **Theorem V2.** Over the 220 `S_3`-points, if the induced map is defined at
  `s_x` its value is one of the two points of `V14^{S_3(x)}`, with stabiliser
  exactly `S_3`, hence different from all three carrier points at `x` (those
  have stabiliser exactly `C_6`, Thm K2).
* **Theorem V3.** No chain of the boxed lemma's type (irreducible RCC, each
  pointwise involution-fixed, consecutive members meeting) can contain a
  first-generation carrier at `x` together with second-generation strata of
  two distinct involutions of `Stab_G(x)`: the chain has a single image point,
  which would have to be both `C_6`-stabilised and `K`-stabilised. Crossing
  from `sigma` to `tau` needs exactly two such strata, so **route 2 cannot
  supply the chain the SPIN-LINKING LEMMA asks for.** (Independent second
  proof of the `S_3` case: the stabiliser would contain
  `<C_6(sigma), S_3> = G`, and `V14^G <= V14^{A_5} = empty` — which is why
  the "optional" `A_5` computation turned out to be load-bearing.)

Per subgroup, source against target: `P(U)^{S_3}` = 2 points and
`V14^{S_3}` = 2 points, but `P(U)^{D_10}` = 2 points against
`V14^{D_10}` = empty. That asymmetry is what Theorem V1 runs on; the `S_3`
agreement is why route 2 cannot close by emptiness there and Thm V3 has to do
the work instead.

Net: the box is **not** closed and `SPIN-CHAIN-OBSTRUCTION-UNDECIDED` stands;
route 2 is now closed off as a route to the lemma but yields Theorem V1 as a
by-product, and route 1 (multiplicity, engine Thm 7.4) is the remaining named
route — as well as the only one that can discharge the "all faithful spin
sources" quantifier the headline needs. Headline unchanged: **OPEN**.

## Verification

FIX-IX-SEAL standard: exact characteristic 0 over `K = Q(z)/Phi_11`, two
independent primes 397 and 199, and 353 as an end-to-end replay. Every locus
is decided twice per mode — an exact rank certificate in python (the
restricted Pluecker quadrics spanning all quadratic forms on `M_chi`, so the
saturation is the unit ideal without any Groebner basis) and Macaulay2
saturation — and once more for the whole `V14^H` from the definition in the
ambient `P^9` via `minors(2, [x ; g.x])`, which uses no character theory.
Reducedness over `K` is certified by the Jacobian criterion, since Macaulay2
has no `radical` over that field (the limitation the seal also recorded);
`radical` and `primaryDecomposition` are run in addition at the primes. The
sealed regression numbers (`dim 2 degree 6`, `dim 1 degree 2`,
`dim 4 degree 14`) are reproduced by the new pipeline in every mode. The
subgroup lattice of `PSL(2,11)` is recomputed, not assumed, and stabilisers
are measured directly by acting with all 660 elements wherever the points are
rational.

`verify_v14_s3_d10.py` (`V14-S3-D10-MEASUREMENT-OK`) and
`scripts/check_manifest_parity.py` pass. The packet is on
`agent/v14-s3-d10-measurement-20260810`. This notebook revision was authored
against parent head `eaaf80e44623a4c26a048032434fcb371fb34f3c`.
