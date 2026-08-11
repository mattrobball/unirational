# Notebook supplement — 2026-08-11: the spin Hodge-support route is CLOSED — METHOD-INSUFFICIENT. One witness kills every point cell of the census

## What was asked

Push the spin Hodge-support route until it is closed one way or the other:
either every census cell dies (which would give the repository headline,
`ed_C(PSL_2(F_11)) = 4`, via the sealed Cor IX.5), or an unremovable witness
appears at every remaining choke point (proving the method cannot decide the
question), or an honest handoff. The remaining cells were `(O1)` free
supports, `(O2)` the 352 mandatory points, `(O3)` the `C_11` / `F_55` points
— named the sharpest — and `(O5)` the higher-multiplicity strata. `(O4)` was
already closed to attack by the Hesse-cubic witness.

Packet: `TOTAL_DEGENERATION.md`, `O3_ODD_ORDER_POINTS.md`,
`O2_MANDATORY_POINTS.md`, `O1_O5_FREE_AND_MULTIPLICITY.md`,
`verify_total_degeneration.py`, `verify_o3_odd_order.py`,
`verify_min_degree.py`, with updates to `SUPPORT_CENSUS.md`,
`ADVERSARIAL_TESTS.md`, `REPLAY.md`, `STATUS.md`.

## The answer, in one move

The census constrains a point-supported block at `x` by exactly eight
conditions (`TOTAL_DEGENERATION.md` §1, C1-C8): the stabiliser is in
`Sigma_spin`, the perverse jump is `4-n`, the carrier is a weight-three
sub-Hodge structure of `H^3(Y_x)`, `2 <= dim Y_x <= 3`, the fibre maps
finitely onto an `H`-invariant `Z_x subset V14` of dimension `>= 2`, the Hom
of (AHS-spin) is nonzero, the abelian factor carries `k(H)` copies of
`E_{-11}`, and capacity holds. **Nothing bounds `dim Y_x` from above except
`3`.**

Take `dim Y_x = 3`. Then `Z_x = V14`, and the tautological datum

    Y_x = V14,   q|_{Y_x} = id,   W_x = H^3(V14,Q) = T(-1)

satisfies all eight, in **every one of the nine point cells at once**, with
the Hom an *isomorphism* (`Res_H T -> W_x(1)` is the identity) and the
`E_{-11}` floor met **exactly** at `C_11` and `F_55`, where `A_x = J(V14) ~
E_{-11}^5`. That is Theorem W1. Theorem W2 is the immediate consequence: no
point cell `P0`-`P8` is closable by this machinery — hence neither is `(O1)`
(which contains `P0`), `(O2)` (= `P5`, `P6`), `(O3)` (= `P7`, `P8`), or
`(O5)` (whose revived strata all have point layers). With `(O4)` already
witnessed, **every boxed family carries a witness** and
`SPIN-SUPPORT-CENSUS-CLOSED` is unreachable.

Geometrically the witness is not exotic (Lemma W0): `Z_x = V14` says exactly
that every fibre closure of `phi` passes through `x`, which is the ordinary
behaviour of a projection from `x`. Lemma W0' pushes the same way rather than
against: purity of the exceptional locus forces `dim Bs(phi) >= n-5`, so the
base locus is never finite.

## What else the campaign produced

**1. `V14^{F_55} = empty`, unconditionally, and 12 new mandatory base
points.** A finite group fixing a smooth point of a variety acts faithfully
on the tangent space, so `mu(H) > 3` forces `V14^H = empty`. The minimal
faithful degree of `F_55 = C_11 : C_5` is `5` (its irreducible degrees are
`1,1,1,1,1,5,5` and every linear character kills `C_11`), and of
`PSL(2,11)` also `5`. This replaces the worker-grade mod-397 input of
`FIX_IX_v14.md` §8 with a proof, and it makes the 12 `F_55`-fixed points of
`P(U)` **mandatory base points** for every `G`-equivariant rational map, at
every degree — the `F_55` analogue of Theorem K4. Mandatory base locus:
`352 + 12 = 364` points. The law fires at exactly `F_55` and `G` and is
silent elsewhere, so `V14^{D_10} = V14^{D_12} = V14^{A_5} = empty` stay
genuine measurements.

**2. The `(O3)` arithmetic is a tautology, not a contradiction.** A support
at a `C_11`-point must carry an abelian fivefold with `Q(zeta_11)`-
multiplication *and* be isogenous to `E_{-11}^5`. These are the **same**
demand: `Q(sqrt(-11))` is the quadratic subfield of `Q(zeta_11)` (`11 = 3
mod 4`), `[Q(zeta_11):Q(sqrt(-11))] = 5`, and the forced CM type is the
quadratic-residue coset, which is a union of cosets of `Gal(Q(zeta_11)/K)`,
i.e. **induced** from `K` — and an induced CM type of index 5 gives
`A ~ E^5`. So no field-mismatch kill exists, and the demand is realised
canonically by `J(V14)` itself. The cell that looked sharpest arithmetically
is the one where the arithmetic cannot bite.

**3. The pointwise-kernel selection rule, and two new unconditional kills.**
If a positive-dimensional support `S` has pointwise kernel `H_0`, then `H_0`
acts trivially on `S`, the equivariant fundamental group is
`pi_1(S) x H_0`, and every simple constituent has carrier
`IH^i(Sbar,L) (x) rho` with `H_0` acting through a single `rho in Irr(H_0)`.
So `rho` must occur in `Res_{H_0}T` (Theorem W3). This reproduces kill `K-d`
and adds: **`K-m`**, the constant-coefficient channel is dead on every
`C_11`-stratum, and **`K-n`**, *every rank-one* equivariant channel is dead
on every `F_55`-stratum — only the two 5-dimensional `theta_i` survive.
Uniform in the source, in `m`, in the degree and in the dimension. Neither
empties its cell, because the point layer survives.

**4. The minimal live coordinate degree — named task §7.4, CLOSED.**
`M = 10'`, `Lambda^2 U = 5 (+) 10'`, `S^2 U = 10 (+) 11`, and
`dim Hom(M^*, S^d U^*) = 0,0,0,3,0,6,0,22,0,42,0,99` for `d = 1..12`. The
minimal live degree is `d = 4` for `V = U` (a `P^2` of candidate landing
tuples) and `d = 2` for `V = U^{(+)m}`, `m >= 2` (multiplicity `C(m,2)`, by
Cauchy). Consequences: kill `K-g` is **vacuous** on the minimal source, and
at `d = 4` free positive-dimensional *component* orbits die (`4^4 = 256 <
660`) but revive at `d = 6`. Odd-`d` vanishing reproduces Theorem C6 by an
independent route, termwise.

**5. `(O2)` narrowed but not closed.** Since `rho(V14) = 1`, an irreducible
surface in `V14` is an ample divisor; if it is smooth, Lefschetz plus
`b_1(V14) = 0` gives irregularity zero. So in the `dim Y_x = 2` branch the
required `E_{-11}` cannot come from the image surface — only from branching
of the finite cover or from singularities. Real narrowing, not a kill, and
silent on `dim Y_x = 3`.

## Consistency

The mandatory `D_12` test against Cor IX.6 PASSES on every verdict
(`ADVERSARIAL_TESTS.md` §W1): the two new kills live at strata whose
pointwise kernel has order divisible by 11 and `11` does not divide 12, so
neither is visible to the realised dominant `D_12`-equivariant spin map;
`dim T^{D_12} = 2 > 0`, so the channel that map needs is left open; and a
witness, being a non-exclusion, cannot contradict an existence theorem. The
one cell `D_12` sees in full — `P5`, the `S_3` points — is left open, which is
the correct sign.

Recorded honestly rather than hidden (§W2): W1's proof uses only `n >= 4`,
`dim(target) = 3` and purity of `H^3`, so at `n = 5` it gives the same verdict
for the **ambient** packet's point cells. Nothing there is damaged —
`THEOREM_POINT_SUPPORT.md` already recorded that `FREE-SUPPORT-EXCLUDED` is
unavailable; W1 upgrades "unavailable" to "unavailable in principle". Also
recorded: the falsifiable predictions of §S4 (`chi_top(V14^g) = 6, 4, 2` at
orders 3, 5, 6) are **not** measured by this campaign and remain the sharpest
independent test of Theorem S0.

## What a stronger method must see

The package is a function of `(Y, p, T)` alone; it uses `q` only through its
existence, properness and one projection-formula step. So it cannot bound

    delta(x) = dim q(p^{-1}(x)),   x in Bs(phi),

beyond `2 <= delta(x) <= 3`. **Residual 1**: prove `delta(x) <= 1` at some
point of each orbit — equivalently, that not every fibre closure of `phi` can
pass through a mandatory point. **Residual 2**: granting `delta(x) = 2`,
exclude `H`-equivariant finite covers of ample divisors of `V14` with
`E_{-11}` in the Albanese. **Residual 3**: nonconstant local systems on the
eigen-strata (cell `O4g`), untouched. All three are statements about the
**map**, not about the support decomposition. Not a residual: the arithmetic.

## Exits

```text
SPIN-ROUTE-CLOSED-METHOD-INSUFFICIENT      (the campaign exit)
SPIN-HODGE-SUPPORT-METHOD-INSUFFICIENT
SPIN-SUPPORT-CENSUS-CLOSED-TO-ATTACK
TOTAL-DEGENERATION-WITNESS-PROVED
POINT-CELLS-UNCLOSABLE
POINTWISE-KERNEL-SELECTION-RULE-PROVED
BASE-LOCUS-DIMENSION-BOUND
O3-OPEN-WITH-WITNESS
V14-F55-EMPTY-UNCONDITIONAL
F55-STRATUM-MANDATORY
O3-CM-TYPE-INDUCED
O2-OPEN-WITH-WITNESS
O2-IMAGE-SURFACE-REGULAR
O1-OPEN-WITH-WITNESS
O5-OPEN-WITH-WITNESS
MIN-LIVE-DEGREE-COMPUTED
TOTAL_DEGENERATION_OK
O3_ODD_ORDER_OK
MIN_DEGREE_OK
```

`SPIN-CHAIN-OBSTRUCTION-UNDECIDED` is unchanged, and nothing here decides
Problem E: the headline `ed_C(PSL_2(F_11)) in {3,4}` remains **OPEN**. What
is now settled is that the Hodge-support route cannot decide it.

## Verification

`verify_total_degeneration.py` (`TOTAL_DEGENERATION_OK`), 87 exact
assertions, about two seconds, Python standard library only: the nine point
cells and their orbit sizes; `dim T^H` and the floor `k(H)` for all nine
stabilisers, computed by orthogonality inside `Z[zeta_m]` with exact
polynomial reduction modulo `Phi_m`; the W1 checklist cell by cell together
with the twelve-kill audit; the selection rule and its dead channels; the
`(O1)` capacity tables across degree and source dimension; the `(O2)`
ample-divisor narrowing; the census tally; and the `D_12` test.
`verify_o3_odd_order.py` (`O3_ODD_ORDER_OK`), 86 exact assertions, under a
second, standard library plus `spin_network_lib`: `PSL(2,F_11)` built from
`2x2` matrices over `F_11` and enumerated in full (order profile, 12 Sylow
11-subgroups, `|N_G(C_11)| = 55`, the quadratic-residue multiplier);
`W|_{C_11}` from the integral monomial model; the Gauss-sum identities
`eta + eta' = -1`, `eta.eta' = 3` in `Z[zeta_11]`; the `12 + 60` tally;
`Res_{C_11}T` and `Res_{F_55}T`; the minimal-faithful-degree table and its
consistency with every measured fixed locus; and the CM-type combinatorics.
`verify_min_degree.py` (`MIN_DEGREE_OK`), 114 exact assertions, about two
seconds: `chi_U` isolated by a central class-sum projector satisfying
`A^2 - 10A + 300 = 0` over `Z`, two independent code paths for
`chi_{S^d U}` (Newton recursion and the Molien generating function) agreeing
on all 1320 elements up to `d = 16`, and the Cauchy check at multiplicity.

All three verifiers, plus `verify_spin_hodge_census.py`, `verify_o4_census.py`,
`verify_v14_betti.py` and `scripts/check_manifest_parity.py`, pass. The packet
is on `agent/spin-route-campaign-20260810`. This notebook revision was
authored against parent head
`4cb21fc02968861735b05abc193bd56fe5e9e91a`.
