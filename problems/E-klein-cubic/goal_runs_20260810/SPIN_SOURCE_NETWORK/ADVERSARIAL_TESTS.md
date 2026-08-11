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

---

# Adversarial tests — the ported Hodge-support obstruction (2026-08-10)

Tests against `THEOREM_SPIN_HODGE_SUPPORT.md` and `SUPPORT_CENSUS.md`.  The
standing risks here are the mirror image of the ones above: this packet proves
a *positive* necessary condition and then a census with DEAD cells, so the
danger is (i) contradicting the realised `D_12` map of Cor IX.6, (ii) porting
a proof step whose hypothesis silently fails on a spin source, and (iii)
asserting an identification of the target Hodge structure that the repository
has not earned.  All three are tested.

## S1. The MANDATORY `D_12` test — PASSED

**Requirement.**  Cor IX.6 (`FIX_IX_v14.md` §7) proves the `V14` **is**
`D_12`-spin-unirational: a dominant `D_12`-equivariant map from a spin source
exists.  The ported theorem applied with `G := D_12` must be *satisfiable* by
that map, and the census must leave the cells it occupies OPEN.

**Which cells it can occupy.**  `Res_{D_12} T = 2.(1(x)triv) (+) 2.(1(x)std)
(+) 2.(eps(x)std)` (verifier §D, §I).  All three channels have multiplicity
`2`; the census marks **none** of them DEAD.  The map may therefore run
through a free `D_12`-orbit of supports (`H = 1`, cell O1), through an
`S_3`-point support (`D_12` does contain two `S_3`s, so it does see the
`S_3` layer of the 352 — the correction already recorded in §A1 above), or
through an eigenplane-curve support with `H <= C_6`.  Every one of these is
OPEN.

**Three ways this test could have failed, and did not.**

1. *Irreducibility.*  The unique-jump step of Theorem S3(2) needs `T`
   irreducible over `Q` as a `G`-module.  At `G := D_12` that hypothesis is
   **false** (`Res_{D_12}T` has three distinct isotypic pieces), so the
   theorem correctly weakens to "some isotypic piece jumps somewhere and
   projects to a proper support".  Had the packet asserted a unique jump at
   every level, it would have been wrong.  Recorded explicitly in §I.
2. *The sign kill.*  Theorem C4 kills the `S_3`-sign channel.  That kill is a
   restriction of `T` to `S_3` and is therefore *also* in force at `D_12`
   level.  It is consistent because the realised map simply does not use that
   channel; `Res_{S_3}T` still has `2.triv (+) 4.std` available.  A kill that
   had emptied `Res_{S_3}T` would have refuted Cor IX.6 and would have been
   wrong.
3. *The degree-parity theorem.*  Theorem C6 ("`d` is even") is proved from
   `Gtilde` perfect.  At `D_12` level the relevant group is the dicyclic
   preimage `D_12tilde` of order 24, which is **not** perfect — so the proof
   does not restrict.  But `-I in [D_12tilde, D_12tilde]` (verified, order 6),
   so every linear character of `D_12tilde` is trivial on `-I` and the parity
   conclusion survives verbatim at `D_12` level too.  No contradiction either
   way.  For contrast, at a spin-**admissible** level such as `S_3` the
   preimage `Q_12` does have spin linear characters and the parity argument
   genuinely fails there — checked, so that the theorem's scope is exactly
   recorded.

**What the full-`G` question adds that `D_12` cannot see.**  `D_12` contains
no `D_10`, `C_5`, `C_11` or `F_55` (verified: its subgroups are
`1, C_2, C_3, C_6, V_4, S_3, D_12`).  So the cells `P3, P6, P7, P8` — in
particular the two sharpest ones, `C_11` and `F_55`, where `Res_H T` is
`Q`-irreducible and a single support must carry all five `E_{-11}` copies —
are invisible at `D_12` level.  So are the orbit-size and capacity rows,
whose whole content is that a `G`-orbit has 660 or 110 or 66 members.
**PASS**, and informative in the same sense as §A1: the realised map is
positive evidence that the obstruction, if it exists, must live in exactly
those `D_12`-invisible cells.

## S2. Does the census prove too much? — NO, by construction

No cell is DEAD for all spin sources and all degrees (verifier §H asserts
this).  Five positive-dimensional cells (`S4`-`S8`) are DEAD for the
multiplicity-free source `U` only, because the corresponding fixed loci of
`P(U)` are finite; they revive at `m >= 2` (Lemma M0), and this is stated in
the table rather than swept into a uniform claim.  The eight cross-cutting
kills are all conditional on a channel, a fibre dimension, an orbit size or a
degree, never on "there is no support".  `SPIN-SUPPORT-CENSUS-CLOSED` is
**not** claimed and the headline consequence chain is **not** triggered.

## S3. Is the identification of `T` circular, or smuggled through
Tschinkel--Zhang? — NO

**Risk.**  The obvious way to get `H^3(V14)` is to transport `H^3(X)` across
the twin equivalence.  That would be wrong twice: the T-Z equivalence is
*twisted-stable*, not birational ([BCDP23] Thm 4.3 proves both threefolds
birationally rigid), and even a stable birational equivalence changes `H^3`
by `H^1` of blowup centres under weak factorization.

**What is actually used.**  Theorem S0 uses (a) the literature Hodge numbers
of a prime Fano threefold of genus 8, flagged; (b) the *sealed* Klein
character value `chi_W(sigma) = 1`; (c) the *sealed* `V14^sigma` = genus-one
sextic `| |` two points, i.e. `chi_top = 2`; and (d) topological Lefschetz.
No T-Z, no birational transport.  The Klein side enters only through the
character table of `PSL(2,11)`, which is group theory.

**Independent corroboration.**  `chi_T(11) = -1` predicts
`chi_top(V14^{C_11}) = 5`, and `FIX_IX_v14.md` §8 records `V14^{C_11}` = 5
points.  This is a second, independent agreement beyond the `sigma` datum
that fixed the identification — and it also re-derives, with no slack, the
`V14^{C_11} != empty` that `MULTIPLICITY_ROUTE.md` §5 could only get from a
Lefschetz *congruence* using the flagged literature `b_3`.

## S4. Falsifiable predictions — REGISTERED, not yet tested

`chi_top(V14^g) = 4 - chi_T(o)` for `g` of order `o` gives

```text
o =  2 :  2     SEALED, agrees
o =  3 :  6     NOT measured
o =  5 :  4     NOT measured
o =  6 :  2     NOT measured
o = 11 :  5     recorded in FIX_IX_v14.md sec.8, agrees
```

The rejected alternative (`H^3(V14,Q) = 10'`, the discrete series that shares
`chi(sigma) = 2` and `chi(11) = -1` with `T` and is therefore the only near
miss) predicts `3` at `o = 3` and `5` at `o = 6`.  So the `o = 3` and `o = 6`
rows are a **sharp two-sided test** of Theorem S0, decidable by one run of
`verify_v14_s3_d10.py`'s machinery (`M|_{C_6}` has character multiplicities
`(2,1,2,2,2,1)`; `M|_{C_3}` is equally explicit).  A disagreement would
refute Theorem S0 — but note Step 1 of its proof already excludes `10'` on
purely Hodge-theoretic grounds (`H^{2,1}` is a `G`-stable 5-dimensional
subspace, so `H^3 (x) C` cannot be irreducible), so a disagreement would more
likely indict the literature Hodge numbers.

## S5. Does the fixed-point destructibility of Thm N3 destroy the Hodge
support too? — NO, and this is the whole point

**Risk.**  `MULTIPLICITY_ROUTE.md` Thm N3 exhibits an explicit `G`-invariant
centre making `X_0^{D_10} = empty`; if the same move could destroy a Hodge
support block, the port would be vacuous.

**Outcome.**  It cannot.  `Y`, `alpha_phi`, the perverse filtration for `p`
and the strict-support package are attached to the **normalized graph of
`phi`**, not to any chosen resolution; blowing up further changes none of
them (`AMBIENT_SUPPORT.md` §10, Test 2 of the ambient packet, both of which
port unchanged because they use only properness and normality).  Thm N3
changes the birational model of the source; it does not change `I_phi`, hence
not `Y`.  **This is precisely why the invariant survives the exhaustion
recorded in Cor N4** — it is not of fixed-point type.

## S6. The `n = 5` regression — PASSED

Every formula is checked against the ambient packet at `n = 5`
(verifier §F, §G): the point-support degree `j_0 = -1`
(`THEOREM_POINT_SUPPORT.md` (2.1)), the classical channels `(s,j_0) =
(1,-1)` and `(2,0)` (`AMBIENT_SUPPORT.md` §8), the refinement exponent
`s-1-j_0` in (2.7) of `THEOREM.md`, and the whole orbit-size/degree cell
table of `DEGREE_ACCOUNTING.md` §3.  All reproduce exactly.  Where the `n = 6`
answer differs (point supports at `j_0 = -2`, a threefold support channel that
does not exist at `n = 5`), that is a genuine consequence of `dim P(V) = 5`,
not a transcription error.

## S7. Does the two-dimensional generic fibre break `q^*` injectivity? — NO

**Risk flagged in the brief.**  On `P^4 --> X` the landing morphism has
one-dimensional generic fibres; on `P(V) --> V14` it has `e = n-4 >= 2`.

**Outcome.**  The relatively-ample splitting is
`s(beta) = N^{-1} g_*(eta^e cup beta)` with
`N = deg(eta^e|_F) > 0`, and the projection formula
`g_*(eta^e cup g^*alpha) = g_*(eta^e) cup alpha` holds for every `e >= 0`.
Nothing in it wants `g` generically finite, flat or equidimensional.  What
does **not** port is the *restricted*-graph statement (`THEOREM.md` Thm D),
whose proof uses generic finiteness and a trace identity; that theorem is not
used anywhere in this packet, and no restricted transfer is claimed.

## S8. Does the sign-channel kill contradict Theorem V1? — NO

Thm V1 says the `D_10` sign point `s_x` of `Bl_x P(U)` is forced base locus.
Theorem C4 says a *sign-isotypic* point-supported Hodge block at `x` carries
no `T`-projection.  These are statements about different objects (a fixed
point of a blowup versus a strict-support summand of `Rp_*IC_Y^H`) and there
is no tension: the census conclusion is that the direction the fixed-point
analysis pinned is exactly the direction the Hodge obstruction cannot exploit.
That is a limitation of the Hodge route at those points, recorded as such, not
a contradiction.

## S9. Correction recorded: the spin block of `SL(2,11)`

`MULTIPLICITY_ROUTE.md` §7 lists the faithful spin irreducibles as
"`6, 6, 10, 10, 12`".  The correct list is `6, 6, 10, 10, 10, 12, 12`
(two Weil reps; three discrete series of degree `q-1 = 10`, from the
characters of `C_12` of order 4 or 12; two principal series of degree
`q+1 = 12`, from the characters of `C_10` of order 10), and
`36+36+100+100+100+144+144 = 660 = 1320 - 660`.  Nothing in that file depends
on the list — its statements quantify over `U^{(+)m}` — but the "all faithful
spin sources" quantifier is one irreducible wider than recorded, and cell
`(O5)` of the census reflects that.

## S10. Is anything here a fixed-point statement in disguise? — NO

Audited step by step.  Theorem S1 is a projection-formula identity; S2 is
weight strictness plus Hanamura--Saito; S3 is `H^3(P^{n-1}) = 0` plus the
decomposition theorem; S4-S6 are Hodge-structure and stalk-degree arithmetic.
The only inputs that mention fixed loci are the *measured* ones used to
populate the census (the 110 eigenplanes, the 352 points, `V14^{D_10} =
empty`), and they are used to enumerate cells, never to derive the
obstruction.  No Chow projector, no canonical splitting, no "every stratum
stays RCC" claim, no chain argument.
