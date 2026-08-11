# Notebook supplement — 2026-08-11: the spin packet's last cited input is sealed, and census cell (O4) splits — with a witness that closes the cell to attack

## What was asked

Two sequential tasks on the spin lane, extending
`goal_runs_20260810/SPIN_SOURCE_NETWORK/`. (1) Seal the three inputs that
`THEOREM_SPIN_HODGE_SUPPORT.md` §0 still flagged as literature —
`b_3(V14) = 10`, `h^{2,1}(V14) = 5`, `rho(V14) = 1` — with an exact citation
**and** an independent in-repo derivation. (2) Attack census cell `(O4)`:
supports that are curves inside the 110 eigenplanes and the eigen-line strata
of the spin source `P(U)`, which `SUPPORT_CENSUS.md` §6 had flagged as "the
only cell that looks finite and explicit enough to be decided by the existing
machinery".

Packet: `SEAL_V14_BETTI.md`, `verify_v14_betti.py`,
`O4_EIGENPLANE_CURVES.md`, `verify_o4_census.py`, with updates to
`SUPPORT_CENSUS.md`, `THEOREM_SPIN_HODGE_SUPPORT.md`, `MULTIPLICITY_ROUTE.md`
§5, `ADVERSARIAL_TESTS.md`, `SOURCES.md`, `STATUS.md`, `REPLAY.md`.

## Exits

```text
V14-BETTI-SEALED                        the three flagged inputs, derived in-repo
V14_BETTI_OK                            (verifier marker, 41 assertions)
O4-SPLIT                                cell (O4) split, dead and open parts exact
O4-EIGENPLANE-CURVES-OPEN-WITH-WITNESS  the open part is witnessed, not merely unclosed
O4_CENSUS_OK                            (verifier marker, 92 assertions)
SPIN-SUPPORT-CENSUS-TABLED              (unchanged; the table is edited, not closed)
```

`O4-DEAD` is **NOT** claimed and is now known to be unreachable by this
machinery. `SPIN-SUPPORT-CENSUS-CLOSED` is still not claimed. Headline
unchanged: **OPEN**.

## What was found

**1. `chi_top(V14) = -6` by exact Schubert calculus, and the three flags
fall.** The sealed FIX-IX model makes `V14 = Gr(2,U) cap P(M)` a
**codimension-5 linear section of the 8-fold `Gr(2,6)`**, i.e. the zero locus
of a section of the ample rank-5 bundle `O(1)^{(+)5}`. Two consequences, both
derived rather than cited:

* *Picard rank.* Sommese's Lefschetz theorem for ample vector bundles
  (Sommese 1978 Prop. 1.16; Lazarsfeld, *Positivity II* §7.1) gives
  `H^i(Gr) -> H^i(V14)` an isomorphism for `i < dim V14 = 3`, so `b_1 = 0`
  and `b_2 = 1`; Kodaira vanishing on the Fano `V14` makes
  `Pic = H^2(.,Z) = Z`, hence `rho(V14) = b_2 = 1`. All four hypotheses
  (smooth ambient, ample bundle, correct rank, expected codimension) are
  checked one at a time; the last two are the sealed `dim V14 = 3`,
  `deg V14 = 14`.
* *Euler characteristic.* `c(T_{V14}) = c(T_{Gr})/(1+sigma_1)^5` and
  `[V14] = sigma_1^5` in the Chow ring of `Gr(2,6)`, realised as symmetric
  polynomials in the two Chern roots with the `2x4`-box Schubert basis and
  the degree map "coefficient of `s_{(4,4)}`". Exact integers throughout:
  `chi_top(V14) = int c_3(T_{V14}) = -6`, hence `b_3 = 4 - chi = 10` and,
  with `h^{3,0} = 0` by Kodaira, `h^{2,1} = 5`.

Five regressions pin the computation: `int sigma_1^8 = 14`,
`int c_8(T_{Gr}) = 15 = chi_top(Gr(2,6))`, `c_1(T_{Gr}) = 6 sigma_1`,
`deg V14 = (-K)^3 = 14` (genus 8, matching the sealed Macaulay2
`REG V14 dim 4 degree 14`), `chi(O) = 1`. A sixth is new and pretty:
`h^0(-K_{V14}) = 10` by Hirzebruch–Riemann–Roch, so the sealed
`P(M) = P^9` **is** the anticanonical space and the model is the classical
`X_14` — which is what licenses the Iskovskikh / Iskovskikh–Prokhorov
citation in the first place, and the citation is then not load-bearing.
**Theorem S0 now leans on no unsealed input**, and the same seal discharges
the `b_3` flags in `MULTIPLICITY_ROUTE.md` §5 and `ADVERSARIAL_TESTS.md` §B9.

**2. Cell `(O4)` splits, and its open part is witnessed.** The residual
geometry of an eigenplane is pinned exactly: `sigma` acts trivially on
`Pi ~ P^2`, `Stab_G(Pi) = C_6`, and the residual `C_3` acts as
`diag(1,w,w^2)` with three isolated fixed points (proved from the
`C_12`-decomposition of `U`, extracted by orthogonality inside `Z[zeta_12]`
and halved). For an irreducible curve `S subset Pi`: `H_0 = C_2` exactly,
`H in {C_2, C_6}`, orbits 110 or 330. Dead in the constant-coefficient
channel: whole eigenplanes; whole `C_3`- and `C_5`-eigen-**lines**, which for
`V = U` are the only positive-dimensional supports in those strata (so cells
`S2`, `S3` of the census die for `U` in that channel); eigenplane curves of
geometric genus 0; and — the one genuinely new kill — `C_3`-stable plane
**cubics of nonzero weight**, where all three coordinate points lie on the
curve, so the order-3 automorphism of the elliptic curve has a fixed point,
forcing `j(S) = 0`, CM by `Q(sqrt(-3))`, and hence no nonzero map from the
`E_{-11}`-isotypic `T`. Per channel, each `sigma`-sign equivariant structure
kills exactly one `C_3`-channel (`psi_3` giving back the census's K-d).

But the cell does **not** die, and cannot: the weight-zero `C_3`-invariant
cubics are exactly the Hesse family, and for **any** elliptic curve `E` and
any nonzero `tau in E[3]` the pair `(E, t_tau)` embeds by `|3.0|` as a plane
cubic on which the translation acts as `diag(1,w,w^2)` — the residual action
of the eigenplane on the nose. Taking `E = E_{-11}` gives, in every one of the
110 planes, a `C_6`-stable smooth cubic isomorphic to `E_{-11}` with `C_6`
acting trivially on `H^1`, satisfying (AHS-spin), the refinement (5.2), and
Cor S4's floor `k(C_6) = 1` exactly. Above degree 3 no character kill exists
at all (all three `C_3`-channels of `H^1` are nonzero for every `delta >= 4`
and every weight). So the census's proposed closing move — *exclude `E_{-11}`
from the Jacobians of the `C_6`-stable plane curves* — is refuted twice: the
family is positive-dimensional in every degree `>= 3`, so the question was
never finite, and `E_{-11}` is attained rather than excludable. `(O4)` is
therefore the **least** promising of the five boxed cells, not the most, and
that retraction is recorded in `SUPPORT_CENSUS.md` §6. The sharp cells are
`(O2)` (the 352 mandatory points) and `(O3)` (`C_11`, `F_55`).

**3. Capacity sharpened.** Refined Bézout bounds the **total degree** of the
distinguished varieties, not their number, so an orbit of `N` components of
degree `delta` needs `N.delta <= d^c`: an orbit of 110 plane cubics needs even
`d >= 6`, not the `d >= 4` of the census's component-count table. The caveat
that a strict support need not be a base **component** is inherited unchanged.

**4. Consistency.** The mandatory `D_12` test against Cor IX.6 PASSES with
the informative sign: `Res_{D_12}T` has all three channels of multiplicity 2,
the eigenplane cell is fully visible at `D_12` level, and the one subcell that
survives our kills is exactly the trivial channel the realised
`D_12`-spin-unirational map is free to occupy. Every kill is either "this
carrier is zero" (`IH^1` of a `P^k` or a rational curve) or a CM-field
mismatch, neither of which can contradict the existence of a map. The
`j = 8192/11` overreach the brief warned about is explicitly **not**
committed: the carrier is `IH^1` of the *support*, the image of the plane is a
single point by Thm K1, and `S` lies in `Bs(phi)` where `phi` is undefined.

## Verification

`verify_v14_betti.py` (`V14_BETTI_OK`), 41 exact assertions, under a second,
Python standard library only, self-contained. `verify_o4_census.py`
(`O4_CENSUS_OK`), 92 exact assertions, a few seconds, standard library plus
`spin_network_lib`: the `C_12` / `C_6` / `C_10` decompositions by
orthogonality in cyclotomic rings with no floating point, the setwise
stabilisers computed by acting with all 1320 group elements on the eigenspaces
(`C_6`, `D_12`, `D_10`, orbits 110/330/55/66), the `Res_{C_6}T` channel table,
the plane-curve weight combinatorics for `delta = 3..8`, an exact `Z[w]`
factorisation of `x^3+y^3+z^3-3xyz` into a triangle of lines, the capacity
table, and the `D_12` consistency test.

Both verifiers and `scripts/check_manifest_parity.py` pass. The packet is on
`agent/seal-b3-and-o4-20260810` (PR #33).
