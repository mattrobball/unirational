# Notebook supplement — 2026-08-11: the RT slice classification — the landing identities constrain nothing, and the pointed-curve exclusion is refuted only slice-locally

## What was asked

Adjudicate and port a further external round on `RT_ACTUAL_LANDING` (external,
unaudited; the previous round from the same line was mostly right but had one
refuted claim and an under-justified step). The round claimed (a) a complete
structural classification of normalized two-dimensional slice ideals via
Zariski–Lipman weighted clusters, (b) universality of pointed rational curves,
(c) unbounded jet depth, (d) the exact conic cell with explicit `R_i`, and
(e) — the headline — a **refutation** of the packet's boxed pointed-rational-curve
exclusion, by an invertible `G`-equivariant integral endomorphism of
`V = H^3(X,Q)(1)` built from orbit-summed pointed **line** correspondences.

Packet: `SLICE_CLASSIFICATION.md`, `REFUTATION_POINTED_CURVE_EXCLUSION.md`,
revised `BOXED_GLOBAL_COVARIANT.md`, `verify_slice_universality.py` (314 exact
assertions, `RESULT: PASS`), blocks `C7`–`C7d` added to `verify_conic_slice.py`,
with `ADJUDICATION.md` items `R1`–`R23`, `SOURCES.md`, `REPLAY.md`, `STATUS.md`.

## The classification is right, and it is empty of constraint

The slice ideal is always `I = (a, fJ)` with `a = H + fC_0/B_0` and `J` the
**gauge-invariant Plücker ideal** of `(B,C)` — an identity, verified
symbolically, not a hypothesis. Its integral closure is a Zariski–Lipman
weighted cluster, and the excess `rho_p` at each infinitely near point is
exactly the degree of the map the exceptional component `E_p` carries into `X`.
Two repairs the source needed: Zariski's theorem is for `m`-primary ideals and
must be applied after splitting off the gcd (which is the divisorial common
factor itself); and `kappa(eta_S)` is not algebraically closed, so the decoration
is a pointed genus-zero stable map over a residue field with Galois action.

Then the sharp part. Take **any** pointed morphism `gamma : P^1 → X` of degree
`e`, given by a base-point-free tuple `P(s,t)`. Put `f = s`, `H = t^e`,
`B = P(0,1)`, `C = (P - t^e B)/s`. Then `HB + fC = P`, and the four landing
identities follow from `F(P) = 0` by two exact divisions — mod `s` gives `R_1`,
mod `t^e` gives `R_3` — with `R_0 = 0` **forced**, because the marked value lies
on `X`. The base ideal has integral closure `(s,t)^e`, one exceptional component
of excess `e`, and the map it carries is `gamma` on the nose.

So every pointed rational curve on `X` occurs as a slice satisfying the
identities: lines, conics, a genuine irreducible plane rational cubic (built in
the verifier by projecting a tangent-plane section of the Klein cubic from its
singular point, and checked birational onto its image), and multiple covers of
every degree. And the depth is unbounded even at fixed target degree 1:
`A_N = (s^N,0,t,0,0)` has complete ideal `(t,s^N)`, a free chain of `N` points
with excesses `(0,...,0,1)`, and one dicritical component mapping with degree 1
to a line — the five-coordinate Klein version of the repo's own `[u^N : v]`
example (`R1-INDUCTION-REFUTED`).

One unification worth recording: the conic countermodel is not an ad-hoc
witness, it is **literally** the `e = 2` instance of the universality recipe, and
its `R_0 = 0`, `R_1 = 8`, `R_3 = -8v` come out of the general derivation.

## The endomorphism exists, and it collapses

The construction: `C` a `G`-invariant ample class on the Fano surface,
`xi = e^*H_X`, `L = a·xi + m·pi^*C` on the incidence threefold `I`, `D` a general
smooth member of `|kL|`, and the composite `V → H^1(D,Q) → V` (cylinder in,
Gysin out). It is an automorphism. Three steps the source asserted are proved
here, and one is corrected upward:

* `B_C = e_*pi^*(C ∪ -)` is an isomorphism — hard Lefschetz on the Fano surface,
  then the observation that `e_*pi^* : H^3(F) → H^3(X)` is the **Poincaré-dual
  map of the Clemens–Griffiths cylinder isomorphism** `alpha_F = pi_*e^*`. The
  source's "homological cylinder" was Clemens–Griffiths again, dualized.
* `beta_D pi_D^* = k M_{a,m}` — projection formula for `j : D ↪ I` with
  `[D] = kL`.
* `alpha_D = pi_D^* alpha_F` — flat base change on the cartesian square.
* **Correction.** The `xi` term of `M_{a,m}` is identically **zero**: by the
  projection formula it is `H_X ∪ e_*pi^*(-)` and `H^1(X,Q) = 0`. So
  `M_{a,m} = m·B_C` exactly, an isomorphism for *every* `m != 0` — stronger than
  the source's "all but finitely many `m`", and it removes the only
  non-effective step. It also discharges half of the repo's own
  `LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL`: "the coefficient `r` cancelling" **is**
  this vanishing.

The upshot is that the operator collapses to `T_D = k m · B_C ∘ alpha_F`. The
divisor contributes only a scalar; the content is the cylinder isomorphism
composed with its Lefschetz-twisted adjoint. Integrality and the Rosati-norm
identity are then automatic, since `End_{G-HS}(V_Z) = O_K`, `K = Q(sqrt(-11))`
(`RESTRICTED-CLEAN-CM-NORM-PROVED`), and every element of `O_K` satisfies
`z̄z = N(z)`.

Two by-products. The Klein cubic's **absence of Eckardt points** — computed in
this packet for an unrelated purpose — is exactly what makes `e : I → X` finite
of degree 6 and hence `xi` ample; without it the polarization argument has no
ground. And the receiver `e(D) ⊂ X` is *forced* to be non-normal or to carry a
non-rational singularity, since `H^1(S,O_S) = 0` for every surface in a smooth
cubic threefold while `H^1(D,Q) ≅ H^1(F,Q) = Q^{10}`. So the construction is a
**witness for** `CLEAN-IMPLIES-NON-RATIONAL-SINGULAR-RECEIVER-PROVED`, not a
counterexample to it — and it proves the double locus of `e|_D` is nonempty,
which the repo's double-hit dimension count only made expected.

## What is actually refuted — the scope call

The boxed exclusion quantifies over the slices **of an actual `G`-covariant
landing tuple** and over **components `S ⊂ D_X` of that tuple's own divisorial
common factor**. `D` is a general divisor in a linear system on the incidence
threefold; no landing tuple appears anywhere in its construction, and `e(D)` is
not exhibited as a component of any `D_X`. **The box is not refuted.**

What is refuted is the slice-local strengthening: "no family of pointed rational
curves on `X` whose slices satisfy the identities can produce a nonzero
`V → IH^1(S,Q) → V`". That is false, and the witness sits in the *simplest*
slice cell — the generic point of `D` is line-type with all `R_i = 0`. The
source concedes exactly this in its closing paragraph while its headline says the
opposite; we keep the concession and drop the headline. Its proposed exit
`POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED` is **not ported**.

This is the second time this external line has produced a correct object with an
overstated scope (the first: the conductor/Gysin refutation, real but routed
through an input it did not need). The pattern is worth naming — reliable about
existence, unreliable about scope.

So the box is **sharpened**, not deleted: all five global data are now written
out simultaneously (global degree, `G`-representation, invariant degree `k >= 5`,
attachment of `H` to `D_X`, and the incidence of the tuple's *own* curve
families), together with a list of what a proof must consume, since everything
local at `eta_S` has now been used up. Three things are known **not** to
obstruct: curve type (any degree occurs), jet depth (unbounded), and the
Rosati-norm identity (automatic for any integral element of `O_K`).

Limitations recorded rather than papered over: the `T_D` route lives at
`k >> 0`, so it supplies no candidate in the window `5 <= k <= 10` where the
packet's `G`-stability lemma bites, and it exhibits no *individually* `G`-stable
smooth receiver — the orbit sum is reducible with permuted components. It
therefore does not interact with the retraction corollary or the sealed
`d >= 6` floor in either direction.

## Exits

```text
SLICE-PLUCKER-NORMAL-FORM-PROVED
SLICE-COMPLETE-IDEAL-CLUSTER-CLASSIFICATION-PROVED
SLICE-EXCESS-EQUALS-RATIONAL-CURVE-DEGREE-PROVED
ALL-POINTED-RATIONAL-CURVE-DEGREES-REALIZED
HIGHER-NORMAL-JET-DEPTH-UNBOUNDED
EXACT-KLEIN-CONIC-CELL-VERIFIED
LANDING-IDENTITIES-IMPOSE-NO-CURVE-TYPE-CONSTRAINT
KLEIN-INCIDENCE-MAP-FINITE
POINTED-LINE-CYLINDER-AND-GYSIN-ISOGENIES-EXIST
ORBIT-SUMMED-FULL-SUPPORT-ENDOMORPHISM-EXISTS

SLICE-LOCAL-POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED

LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL   (r-cancellation half now proved)
GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED
PROBLEM-E-HEADLINE-OPEN
```

Not ported: `POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED`.

Verifier: `verify_slice_universality.py`, `RESULT: PASS`, 314 exact assertions;
`verify_conic_slice.py` extended with `C7`–`C7d`, still `RESULT: PASS`.

**Problem E headline: OPEN.** Nothing here changes it.