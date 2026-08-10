# Adversarial tests — the multiplicity route (2026-08-10)

Tests run against the results of `MULTIPLICITY_ROUTE.md` and
`THEOREM_SPIN_MULTIPLICITY.md`. The results are **negative** (two refutations),
so the standing risk is not "proving too much" in the usual direction; it is
(i) refuting something the sealed data says is realised, and (ii) refuting a
lemma by mis-stating what it quantifies over. Both are tested below.

## A. The four mandatory tests

### A1. The D12 test — PASSED, and informative

**Requirement.** Cor IX.6 (`FIX_IX_v14.md` §7) proves `V14` **is**
`D_12`-spin-unirational: the escape is realised at `m = 1` by an existing
dominant `D_12`-equivariant map. Any argument must fail when restricted to a
single `D_12`, and must genuinely use incidence points that no single `D_12`
sees.

**First, the factual half of the requirement is wrong and is corrected here.**
A single `D_12` **does** see incidence points. `D_12` has 7 involutions: the
central `sigma` and six reflections. A reflection `tau` and the central `sigma`
generate `V_4` (planes disjoint), but two reflections whose product has order 3
generate one of the two `S_3 <= D_12`, and their planes **meet**, at an
`S_3`-incidence point. So the `S_3` layer of the 352 is visible to `D_12`; only
the `D_10` layer is invisible (`D_10` is not a subgroup of `D_12`).

**Consequence, and the actual test.** A proof of the SPIN-LINKING LEMMA at
`S_3` points would restrict to `D_12` and, with the `D_12`-level rigidity,
contradict the realised map of Cor IX.6. Our result has the opposite sign: it
**proves separation**, at every `S_3` point and every `D_10` point. So it
cannot contradict Cor IX.6, and it does better than merely not contradicting
it: the separating centre `W` of Thm M3 is `G`-invariant, hence a fortiori
`D_12`-invariant, so `Bl_W` is a legitimate step in the resolution of the
realised `D_12`-map, and Thm M3 exhibits explicitly how that resolution
separates the carriers it is obliged to separate. **The realised `D_12`-map is
positive evidence for the refutation**, not against it.

### A2. The m = 1 test — INVERTED, and reported as such

**Requirement.** A persistence induction must genuinely fail at `m = 1`;
exhibit where the trivial multiplicity drops to 0.

**Outcome.** There is no such place, because there is no induction: the
proposed induction dies at step 1 for **every** `m`. Theorem M1(4) gives
`m_triv(N_{Z}) = 0` at every multiplicity, `m = 1` included. The brief's
premise was that the trivial multiplicity `m - 1` of `T_x` supplies invariant
**normal** directions at `m >= 2`; it does not — it is exactly `dim Z`, the
tangent directions along the `K`-fixed component itself.

The `m = 1` specialisation is nonetheless checked as a regression: `Z` is a
reduced point, `m_triv(T_x) = 0`, `T_x = sign (+) 2.std` (`K = S_3`) or
`sign (+) W_1 (+) W_2` (`K = D_10`), eigen-dimensions `(2,3)` — exactly Thm K5
(verifier §B, all 352 loci).

### A3. The definedness test — PASSED

**Requirement.** The 352-point theorem (K4) puts the configuration points in
`Ind(phi)`; the argument must work with carriers and strata on RESOLUTIONS.

**Outcome.** No step evaluates `phi` anywhere. Theorems M1-M3 are statements
about the abstract smooth `G`-variety `B = Bl_W P(V)` and its fixed loci; `phi`
enters only in Cor M4, and only through (i) the existence of an equivariant
resolution `X -> B` of `phi` (equivariant Hironaka applied to `B --> V14`) and
(ii) the pushforward of chains along `X -> B`. K4 is used only to say that
blowing up `W` is the natural first move, never to evaluate anything. Theorem
N3 is likewise purely about `G`-varieties.

### A4. No withdrawn machinery — PASSED

No Chow projector. No "every stratum stays RCC" claim: RCC-ness is used in one
direction only — *the image of an RCC variety under a morphism is RCC* — which
is elementary (rational chains map to rational chains or to points). No
`F_55` first cut, no Rees/Hodge machinery, no `10'`-covariant ladder.

## B. Tests of the refutations themselves

### B1. Does the pushforward step in Cor M4 really go the right way?

Yes, and the direction matters. Chains **push forward** along a proper
birational equivariant `pi : X -> B`: images are closed (properness),
irreducible, RCC, pointwise fixed by the same involution, and consecutive
images still meet. Chains do **not** pull back — blowing up is exactly what
separates — and no step of the argument pretends they do. The carrier of `X`
maps *onto* the carrier of `B` because each step of the Thm 4.1 tower is either
a strict transform (birational onto) or a projective bundle `P(N_mu|_F) -> F`
(onto).

### B2. Is the lemma being refuted the lemma that was boxed?

The boxed lemma says "in **every** `G`-equivariant resolution `X -> P(V)` of
`phi`". Cor M4 exhibits a resolution with no chain, so the boxed lemma is false
as written. §3.1 of `MULTIPLICITY_ROUTE.md` states the residual honestly:
Theorem 7.2 only needs a chain in **one** resolution, and Cor M4 does not by
itself exclude a chain in a resolution that fails to dominate `B`. That
residual is boxed, not swept away — and it is inert, because blowing up `W`
first is always a legal move (`W` is smooth, `G`-invariant, and inside
`Ind(phi)` by K4), so nothing forces a resolution to avoid dominating `B`.

### B3. Does Thm M3 contradict Thm K5 or Thm V1?

No; it contains both.

* K5 is the `m = 1` case of M1(4) plus M3: at `m = 1`, `Z` is a point, `E_Z` is
  `P^4`, `A_rho = P(T_x^{rho,+1}) = P^1` and `B_rho = P(T_x^{rho,-1}) = P^2`,
  the `A`'s are pairwise disjoint and disjoint from the `B`'s, and the `B`'s
  meet at the sign point `S_Z = P(T_x^{sign})` (a point when `m = 1`).
* V1 (the `D_10` sign point of `Bl_x P(U)` is base locus) is true and is not
  contradicted: it is a statement about the blowup **at the point** `x`. N3
  says the resolution never has to create that point — a different centre kills
  the `D_10`-fixed locus outright.

### B4. Does Thm N3's destruction criterion prove too much?

The sharpest test: apply Lemma N2 to an **abelian** subgroup, where destruction
must be impossible (Reichstein-Youssin). It is: for abelian `H` every
irreducible is a linear character, so `N_{C,p}` always contains one and the
fixed locus always survives. Concretely, blowing up `L` in Thm N3 leaves the
`C_5`-fixed locus alive (every isotypic piece of `N_L` is a `C_5`-character
piece) while killing the `D_10`-fixed locus, because `N_L = m W_1 (+) m W_2`
consists of 2-dimensional `D_10`-irreducibles. A criterion that destroyed
abelian fixed loci would be wrong; this one does not.

### B5. Is the destruction centre of Thm N3 actually smooth?

This is where the first attempt failed and had to be repaired. The 66
`C_5`-fixed lines are **not** pairwise disjoint: 660 of the 2145 pairs meet,
exactly the pairs of Sylow 5-subgroups lying in a common Borel `F_55`, and the
11 lines of an `F_55` are concurrent at its unique fixed point (verifier §G:
`{0: 1485, 2: 660}`, 12 groups of order 55, 11 lines each). So `| |_{66} L` is
**not** a smooth centre. The repair is the two-step centre of N3(4): blow up
the 12 `F_55`-loci first — they are pairwise disjoint and fixed by no
involution, so no involution's fixed locus is disturbed — and only then the now
pairwise-disjoint strict transforms. Recorded because the naive one-step
version is wrong.

### B6. Could the `D_10`-fixed locus reappear after the centre is blown up?

No. Fixed points of a blowup lie over fixed points of the base, and over the
only base `D_10`-fixed points (`Z`, `Z'`, both inside `L`) the exceptional
fibre `P(N_L)` has no `D_10`-fixed point by N2 + N3(2). The first blowup
(the `F_55`-loci) creates no involution-fixed point at all, since no involution
fixes an `F_55` point.

### B7. Is `Stab_G(Z) = K` really needed, and is it true?

Needed: it is what confines the involutions acting on `E_Z` to those of `K`,
without which the component count of `Fix(B)` could be smaller. True: verified
directly by acting with all 660 elements of `G` on each of the 352 loci
(verifier §A) — orders 6 and 10 exactly, matching 3 and 5 incident planes.

### B8. Was M0 (multiplicity is a tensor factor) checked, not assumed?

M0 is a one-line proof, but its two consequences are checked numerically at
`m = 1` and then propagated: the four-sign incidence pattern `(1,0,0,1)` on all
1980 incident pairs, and the pairwise disjointness of the 352 lines on all
61776 pairs. Everything else about general `m` is arithmetic in the ledger of
verifier §E, asserted for `m = 1..8`.

### B9. Does anything here depend on an unmeasured target locus?

Only the completeness of the audit row in `MULTIPLICITY_ROUTE.md` §5:
`V14^{C_5}` and `V14^{C_11}` are not measured in-repo and are argued nonempty
from `chi(V14^{C_p}) = chi(V14) mod p` with `chi(V14) = -6`, which uses the
literature value `b_3(V_14) = 10`. This is flagged in place. **No theorem in
this packet depends on it**: M1-M4 are source-side, and N3 uses only
`V14^{D_10} = empty` (measured, `V14_S3_D10_MEASUREMENT.md`). If either locus
turned out empty, that would be a *new* obstruction candidate, not a repair of
a broken proof — and it would then have to be tested against N2 like the
others.

### B10. Could a chain use an involution outside `Stab_G(Z)` by leaving `E_Z`?

That is exactly what the component count handles. A chain member is
irreducible, hence connected, hence inside one connected component of
`Fix(B)`; the components were computed globally, over all 110 planes and all
352 exceptional divisors at once, not locally at one `Z`. Leaving `E_Z` means
entering a plane's strict transform or another `E_{Z'}`, and both routes are in
the computed graph.

### B11. "The carrier point `y_sigma` lies OFF the sextic (sealed)" — NOT sealed

The brief's proposed contradiction ran on the carrier point being one of the
two isolated `C_6`-points of `V14^sigma`, "which lies OFF the sextic
(sealed)". That is not sealed. Thm K1 gives only that `y(Pi)` lies in
`V14^{sigma}` and is `C_6`-fixed, and Thm K2 explicitly notes that it "also
covers any `C_6`-fixed point lying on the sextic `E_sigma`, **which the seal
did not measure**". So `y(Pi)` could a priori sit on `E_sigma`. Nothing in this
packet depends on the distinction — the contradiction the brief wanted would
have followed from stabiliser orders alone (`Stab = C_6` versus `S_3`, or
`<C_6, S_3> = G` with `V14^G = empty`) — but the claim as written in the brief
is recorded here as unsupported. `V14^{C_6}` is decidable by one run of
`verify_v14_s3_d10.py`'s machinery: `M|_{C_6}` has character multiplicities
`(2,1,2,2,2,1)`, so the pieces are one `P^1` per multiplicity-2 character and
one point per multiplicity-1 character.
