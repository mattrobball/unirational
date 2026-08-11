# The boxed remaining theorem: global-covariant pointed-rational-curve classification

Exits: `GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED`,
`BOXED-OBJECT-IS-THE-HEADLINE-OBJECT`,
`RT-OBSTRUCTION-LADDER-CLOSED`.

Provenance: external message `[20]` section 6, **sharpened** after external
round 3 (`[21]`), and **re-sited** after external round 4 (section 5 below).
The landing-identity system is verified exactly here
(`verify_landing_identity.py`, `RESULT: PASS`).

**Read section 5 first.** Round 4 does not attack the box; it relocates it. The
object the box constrains — a single global homogeneous `G`-covariant landing
tuple — is, by the repository's own sealed all-degree theorem, exactly the
object whose nonexistence is the Problem E headline and is equivalent to
`ed_C(PSL(2,11)) = 4`. So the box is not a reduction of the headline to
something smaller. It is one proposed route to the headline, and both known
families of route to it are now closed from opposite sides.

**Revision note (this branch).** Round 3 attacked this box from two sides. Both
attacks land, and neither hits the box:

* Its *first half* — "classify the normalized slice ideals, including all higher
  normal jets" — is now **answered as a dictionary and shown to be vacuous as a
  constraint**: every pointed rational curve on `X`, of every degree, occurs as
  a slice satisfying the identities, and the jet depth is unbounded at fixed
  target degree (`SLICE_CLASSIFICATION.md`,
  `LANDING-IDENTITIES-IMPOSE-NO-CURVE-TYPE-CONSTRAINT`). So no classification
  argument alone can deliver the second half.
* Its *second half* is refuted **only in a local-to-global-free form**: an
  invertible, `G`-equivariant, integral cylinder/Gysin operator built from a
  family of pointed lines exists on the Klein cubic
  (`REFUTATION_POINTED_CURVE_EXCLUSION.md`, `T_D = km·B_C∘alpha_F`), but its
  divisor lives in the incidence threefold, not in the `D_X` of any landing
  tuple. Exit `SLICE-LOCAL-POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED`.

The box below is therefore **rewritten to make every global datum simultaneous
and explicit**, and section 2.3 records what is now known to be *unavailable* as
a route. The exit is unchanged.

---

## 1. The landing-identity system — verified

Let `A` be an ambient landing tuple, `F(A) = 0` (the repository convention,
`AMBIENT_REES_SELFMAP_CLASSIFICATION/THEOREM.md`, Theorem B). Let `H` cut the
divisorial common factor `D_X` of `A|_X`, with `gcd(H,F) = 1`, and write

```
A = H B + F C.
```

Let `Phi` be the symmetric trilinear polarization of `F` (`Phi(x,x,x) = F(x)`).

**Theorem 1.1.** The following are equivalent.

**(i)** `F(H B + F C) = 0`.

**(ii)** There exist forms `R_0, R_1, R_3` with

```
F(B)                          = F R_0
H R_0 + 3 Phi(B,B,C)          = F R_1
H R_1 + 3 Phi(B,C,C) + F R_3  = 0
F(C)                          = H R_3.                              (10)
```

**(iii)** `F(B + tC) = (F - H t)(R_0 + R_1 t - R_3 t^2)` in `R[t]`,
`R = Q[x_0,...,x_4]`.                                                **(11)**

*Proof.* `(ii) <=> (iii)` is the coefficient comparison in `t` of the expansion
`F(B+tC) = F(B) + 3Phi(B,B,C) t + 3Phi(B,C,C) t^2 + F(C) t^3`; verified
coefficient by coefficient (`L2`, `L3`).

`(ii) => (i)`: substitute (10) into
`F(HB+FC) = H^3 F(B) + 3H^2 F Phi(B,B,C) + 3H F^2 Phi(B,C,C) + F^3 F(C)`;
everything cancels (`L1`, `L4`).

`(i) => (iii)`: put `G(t) = F(B+tC)`. Then `H^3 G(F/H) = F(HB+FC) = 0` (`L4'`),
so `t = F/H` is a root of `G` in the fraction field, i.e. `(Ht - F)` divides
`G(t)` there. `gcd(H,F) = 1` makes `Ht - F` primitive in `R[t]`, so by Gauss's
lemma the division is already in `R[t]` (`L5` exercises the division step
exactly). Renaming the quotient's coefficients gives (11). ∎

**Verified numerically-exactly as well.** `verify_landing_identity.py` checks the
polarization identity for the Klein `F` symbolically in 10 variables (`L0`), and
checks the cubic and pencil expansions on exact random integer 5-tuples of forms
(`L1`, `L2`, `L6e`).

**Specialization cross-check (`L6`).** In the retraction branch the restricted
map is the identity, so `B = x` (the tautological tuple) and `R_0 = 1`. Then
(11) becomes

```
F(x + tQ) = (F - Ht)(1 + R t - S t^2) = (Ht - F)(S t^2 - R t - 1),
```

which is **exactly** the sealed repository identity of
`goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md` section 2
(restated in `AMBIENT_REES_SELFMAP_CLASSIFICATION/THEOREM.md` Theorem C), signs
included; and (10) reduces to the three sealed scalar identities

```
H + 3Phi(x,x,Q) = F R,     F(Q) = H S,     H R + 3Phi(x,Q,Q) + F S = 0.
```

So the external system is the correct generalization of a result already sealed
in the repository, and the generalization is now proved. **Note:** the general
`A = HB + FC` decomposition and the system (10)/(11) for general `B` are *not*
in the repository — only the `B = x` case is. This packet supplies the general
case.

---

## 2. The boxed remaining theorem

Everything this packet proves reduces the CLEAN branch to a statement about the
single global homogeneous `G`-covariant tuple, not about receivers in the
abstract. Boxed exactly:

> ### Single-tuple global-covariant exclusion (sharpened)
>
> Let all of the following hold **simultaneously, for one and the same object**.
>
> 1. **Global degree and representation.** `A` is a nonzero
>    `G`-covariant ambient landing tuple for the Klein cubic `X`:
>    `A ∈ (Sym^d W^v ⊗ W)^G` for some `d`, with `F(A) = 0`.
> 2. **Attachment.** `H` cuts the divisorial common factor `D_X` of `A|_X`,
>    `gcd(H,F) = 1`, and `A = H B + F C`, so that the landing-identity system
>
>    ```
>    F(B + tC) = (F - H t)(R_0 + R_1 t - R_3 t^2)
>    ```
>
>    holds — equivalently the four identities (10) of Theorem 1.1.
> 3. **Invariant degree.** `D_X ∈ |kH|` with `k ∈ {0} ∪ {5,6,7,...}`
>    (`COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED`); `k = 0` is the `D_X = 0`
>    branch, already settled (`RT-DX0-PROVED`), so `k >= 5`.
> 4. **Slice data.** `S` runs over the irreducible components of `D_X`; the
>    normalized two-dimensional slice ideal of `A` at `eta_S`, with all its
>    higher normal jets, is the decorated complete-ideal weighted cluster of
>    `SLICE_CLASSIFICATION.md` Prop. 2.5, and the pointed rational curves it
>    carries are the ones with degrees the excesses `rho_p`.
> 5. **Incidence.** The correspondence in question is the one **produced by
>    those slices**: the cylinder-in/Gysin-out composite of the curve family that
>    the tuple's own slice data sweeps out over `S`, summed over the `G`-orbit of
>    `S`.
>
> **Prove that under 1–5 the composite**
>
> ```
> V --> IH^1(S,Q) --Gys_S--> V
> ```
>
> **is zero for every orbit of components `S ⊂ D_X`** — i.e. the CLEAN branch
> cannot be realized by the actual tuple's own pointed rational-curve families.

### 2.0 What the sharpening changes

Nothing in content: this is the same statement, with the three quantifiers that
round 3 walked past now written out. The point of writing them out is item 5.
Dropping item 1, 2 or 5 — that is, asking the question about *any* family of
pointed rational curves on `X` whose local slices satisfy the identities —
produces a statement that is now **known to be FALSE**
(`REFUTATION_POINTED_CURVE_EXCLUSION.md` Cor. 4.2). So the box is not merely
unproved; it is *provably not provable* by any argument that forgets the tuple.

### 2.1 Why it cannot be replaced (routes known to be dead)

* **Not by a conductor theorem.** `REFUTATION_CONDUCTOR_GYSIN.md`: the receiver
  exists, `G`-equivariantly, over `Q`, on every smooth cubic threefold. An
  abstract "no such receiver" theorem is false.
* **Not by a target fixed-locus theorem.** The merged receiver ledger
  (`goal_runs_20260810/RECEIVER_LEDGER_X/THEOREM.md`) is scoped, in its own
  words (section 0 "Theorem boundary"), to exclude nothing about "existence of
  equivariant maps into `X`"; and a leakage surface need not be pointwise fixed
  by any nontrivial subgroup.
* **Not by a line normal form.** `COUNTERMODEL_CONIC_SLICE.md`: the slice can be
  `(u,v)^2` with the exceptional `P^1` mapping isomorphically to a smooth conic.
* **Not by a finite classification of the KLS conductor program.** Its binding
  repository exit is `KLS2-NO-FINITE-REDUCTION`
  (`goal_runs_after_35fa/KLS_MINIMALITY/STATUS.md`).
* **Not by the minimal-class/decomposition-of-the-diagonal obstruction.** That
  obstruction *passes* for the Klein cubic
  (`DELTA1-ORDINARY-DECOMPOSITION-DIAGONAL-OBSTRUCTION-PASSES`).
* **Not by a classification of the slice ideals.** `SLICE_CLASSIFICATION.md`:
  the classification exists (decorated complete-ideal weighted clusters) and is
  *empty of constraint* — every pointed rational curve on `X` occurs as a slice
  satisfying (10), with `R_0 = 0` forced and explicit `R_1, R_3`, and the jet
  depth is unbounded at fixed target degree. Exit
  `LANDING-IDENTITIES-IMPOSE-NO-CURVE-TYPE-CONSTRAINT`.
* **Not by excluding the endomorphism abstractly.**
  `REFUTATION_POINTED_CURVE_EXCLUSION.md`: an invertible, `G`-equivariant,
  integral, Rosati-norm-compatible endomorphism of `V` built from an orbit of
  pointed **line** families exists on the Klein cubic —
  `T_D = km · B_C ∘ alpha_F`, with `B_C ∘ alpha_F` the Clemens–Griffiths cylinder
  composed with its Lefschetz-twisted Poincaré adjoint. Exit
  `SLICE-LOCAL-POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED`.

### 2.2 What is known about the classification so far

| cell | slice behaviour | status |
|---|---|---|
| any cell | `I = (a, f J)`, `a = H + fC_0/B_0`, `J` the gauge-invariant Plücker ideal of `(B,C)`; `I mod f = (H)` | settled: `SLICE-PLUCKER-NORMAL-FORM-PROVED` |
| `B(eta_S), C(eta_S)` independent | rank-two cell; `I = (f, t^m)`; exceptional `P^1` maps to a **line**, giving `lambda_S : S ⇢ F(X)` and a cylinder map | line-type; `LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL` applies, with its `r`-cancellation half now proved |
| `C` proportional to `B` or vanishing on `S` | higher normal jets; slice ideal `m`-primary; decorated complete-ideal weighted cluster, excess = target degree | classified: `SLICE-COMPLETE-IDEAL-CLUSTER-CLASSIFICATION-PROVED`, `SLICE-EXCESS-EQUALS-RATIONAL-CURVE-DEGREE-PROVED` |
| any cell, curve type | **every** pointed rational curve on `X`, of every degree, occurs; `R_0 = 0` forced | settled and **negative**: `ALL-POINTED-RATIONAL-CURVE-DEGREES-REALIZED`, `LANDING-IDENTITIES-IMPOSE-NO-CURVE-TYPE-CONSTRAINT` |
| any cell, jet depth | unbounded even at fixed target degree 1 (`A_N = (s^N,0,t,0,0)`, free chain of `N` points, excesses `(0,...,0,1)`) | settled and **negative**: `HIGHER-NORMAL-JET-DEPTH-UNBOUNDED` |
| any cell, coefficient system | the block is `IC_S(U)(-1)` in perverse degree `0`, and only the **constant quotient** of `U` leaks | settled: `CONSTANT-QUOTIENT-COLLAPSE-PROVED` |
| any cell, surface type | `S` is not smooth and not normal-with-rational-singularities | settled: `CLEAN-IMPLIES-NON-RATIONAL-SINGULAR-RECEIVER-PROVED` |
| `5 <= k <= 10` | every component of `D_X` is individually `G`-stable, and the full `V` sits in `H^1(S̃,Q)` | settled: `CLEAN-COMPONENTS-G-STABLE-FOR-k-AT-MOST-10-PROVED` |

### 2.3 What a proof must now consume

Everything local at `eta_S` has been used up. A proof of the box must consume at
least one of the following, all of which are global and none of which the round-3
counterexample respects:

* the **global degree** `d` and the constraint `k >= 5` of item 3;
* the **`G`-representation** `(Sym^d W^v ⊗ W)^G` and componentwise `G`-stability
  in the window `5 <= k <= 10` — note that the `T_D` construction lives at
  `k >> 0` and produces no candidate in that window, and exhibits no
  *individually* `G`-stable smooth receiver
  (`REFUTATION_POINTED_CURVE_EXCLUSION.md` §6.4);
* the **attachment**: that one `H` cuts `D_X` for the *same* tuple whose slices
  sweep the curve family, over *all* points of `S` at once;
* the **incidence**: that the correspondence is the tuple's own, not a freely
  chosen divisor class on the incidence threefold.

Conversely, three things are now known **not** to obstruct: the curve type
(any degree occurs), the jet depth (unbounded), and the Rosati-norm identity
(automatic for any integral element of `O_K`, `K = Q(sqrt(-11))`).

Exit `GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED`.

---

## 3. The box's object is the headline object

Round 4's first claim is that the equivalences

```
exists 0 != T in (Sym^d W^v (x) W)^G primitive with F(T) = 0, some d
   <=>  exists a G-equivariant dominant rational map P(W) --> X
   <=>  X_gen(K_proj) nonempty                                       (1)
```

are already sealed in this repository. **Adjudicated: they are**, with one
named accepted input. The chain, with its artifacts:

| step | artifact | exit |
|---|---|---|
| covariant in *some* degree `<=>` `G`-equivariant rational map `<=>` `X_T(K_proj)` `<=>` a rational point of the explicit normalized cubic `V(Phi)` | `goal_runs_after_35fa/G_UNIVERSAL/ALL_DEGREE_THEOREM.md` ("All-degree landing theorem", five canonically equivalent sets), `SEAL.json` `G2_UNIVERSAL_SEAL_V2` | `G2-FINITE-GENERATION-PASS` |
| such a map is **automatically dominant** — no separate Jacobian-rank-four gate | `goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/DOMINANCE_BRIDGE.md`, seven-step ledger | `G3A-ARITHMETIC-DOMINANCE-PASS`, `G3-DOMINANCE-AUTOMATIC` |
| `C` is `G`-unirational `<=>` `ed_C(G) = 3`; and `3 <= ed_C(G) <= 4`, so not `G`-unirational `<=>` `ed_C(G) = 4` | `RESOLUTION.md`, "Exact reduction to essential dimension"; restated in `SPEC.md` as `ed_C(G)=4 <=> C_gen(K_proj)=∅` | — |

**Audit note, and it matters.** The dominance bridge's step 6 is recorded in its
own ledger as `ACCEPTED_INPUT`, not as a repository proof: it is the lower bound
`ed_C(PSL(2,11)) >= 3` (Beauville, *On finite simple groups of essential
dimension 3*). The `ed_C(G) = 4` consequence likewise rests on the cited
Duncan–Reichstein / Prokhorov / Tschinkel–Zhang inputs assembled in
`RESOLUTION.md`. So (1) is sealed **modulo exactly those citations**, and this
packet does not re-derive them. Also note the earlier
`G_UNIVERSAL/DECISION.md` states the opposite about dominance; `G3A` is the
later packet that removed the rank-four gate, and `NOTEBOOK.md` §17 records that
supersession. `G3A` governs.

> **Consequence.** Proving "there is no single homogeneous `G`-covariant landing
> tuple, in any degree" **is** proving the Problem E headline, and with it
> `ed_C(PSL(2,11)) = 4`. It is not a reduction to a smaller statement, and no
> proof of it can be cheaper than a proof of the headline.

Exit `BOXED-OBJECT-IS-THE-HEADLINE-OBJECT`.

## 4. The obstruction ladder is closed

The box of section 2 is a *route*: constrain the tuple through its own slice
and incidence data. Section 2.1 already listed the routes known to be dead.
Round 4 closes the ladder in both remaining directions.

* **Downward (forget the tuple): closed since round 3.** Dropping items 1, 2 or
  5 of the box gives a statement that is **false**
  (`REFUTATION_POINTED_CURVE_EXCLUSION.md` Cor. 4.2,
  `SLICE-LOCAL-POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED`).
* **Sideways (keep the tuple, use finite local data): closed by round 4.**
  `INTERPOLATION_THEOREM.md` Corollary 4.1: for any *fixed* `G`-stable finite
  package of jet, cluster, incidence or attachment data, every compatible
  invariant section is realised by a global `G`-covariant in all sufficiently
  large degree. So no argument whose input is fixed finite local data can give
  all-degree nonexistence. The decorated-cluster classification of
  `SLICE_CLASSIFICATION.md` is exactly such an input, which is why it came out
  empty of constraint.

What survives is the intersection: data that is **global**, or that **grows with
`d`**, or that uses the **nonlinear** condition `F(T) = 0` — the three things
`INTERPOLATION_THEOREM.md` §3 records as outside the theorem's reach. The list
in section 2.3 of what a proof must consume is unchanged and is now known to be
not merely advisable but necessary.

Exit `RT-OBSTRUCTION-LADDER-CLOSED`. This is a **negative** structural finding:
it removes routes, it proves nothing about the tuple.

## 5. The lane's live content

Two boxed alternatives remain, and they are the whole of it.

> **(A) Arithmetic.** Prove `X_gen(K_proj) = ∅` — equivalently that the explicit
> normalized cubic `V(Phi) ⊂ P^4_{K_proj}` of the all-degree packet has no
> `K_proj`-point. Current state: `G3D-UNDECIDED`
> (`goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC/`), with the `K_proj` line
> algebra, the Hessian cube class and the Clifford/spinor-discriminant gate all
> recorded as `*-PARTIAL`. `SEAL.json` governs over that packet's inconsistent
> internal phase ledger (`NOTEBOOK.md` verification-debt item 17).

> **(B) Geometry.** Classify the `G`-invariant divergence-free rank-one
> foliations satisfying `adj(J_T) = P grad F(T)^t` for some landing tuple, and
> exclude a Klein-cubic first-integral field. New lane, registered in
> `FOLIATION_REFORMULATION.md`, with the forced object proved in
> `THEOREM_FORCED_FOLIATION.md` and an exact non-equivariant witness showing
> the necessary conditions are consistent, so that only the equivariance can
> obstruct.

The box of section 2 remains stated and remains undecided; it is now understood
as a **special route inside (B)**'s ambit rather than as the lane's target.

## 6. The coupled-package form of alternative (B)

Round 5 (`THEOREM_SOURCE_TANGENCY.md`, `BASE_GRADIENT_PACKAGE.md`,
`DEFECT_SMITH_CLASSIFICATION.md`) makes alternative (B) precise enough to state
as one closed condition on one object. Every primitive landing tuple carries a
**coupled package**

```
( T, I_T, Q_T, J_T, P_T, a_T, F_T, Y_T, Delta_T, H, j_phi, H_0, H_1 )   (54)
```

— tuple, base ideal, pulled gradient, Jacobian, kernel covariant, its content,
the saturated foliation, its leaf quotient, the source-tangency invariant, the
common divisorial factor of `T|_X`, the ramification section of the restricted
selfmap, and the two homology sheaves of the Jacobian complex — satisfying
simultaneously

```
   F(T) = 0,
   I_T^6 ⊂ I_Q ⊂ I_T^2,           sqrt(I_Q) = sqrt(I_T),
   I_4(J_T) = I_P I_Q,            adj(J_T) = P_T grad F(T)^t,
   J_T P_T = 0,                   div(P_T) = 0,
   a_T in S^G,  deg a_T in {0} ∪ {5,6,...},  a_T Darboux for the saturation,
   Delta_T|_X = (d/d') H^2 j_phi,      0 != j_phi in H^0(X,O_X(2d'-2))^G,
   [H_1]_2 - [H_0]_2 = [Q_T]_2 - 10(d-1) H^2,
```

together with all orbit, attachment, representation and normalized-Rees
constraints already in the ledger.

> **The correct geometric form of the headline.** Alternative (B) is: *prove
> that no single package (54) exists in any degree*.

Why this is the right statement of (B), and not a decoration:

* it is **strictly stronger** than classifying local decorated clusters —
  those are asymptotically prescribable (`INTERPOLATION_THEOREM.md`,
  Corollary 4.1);
* it is **strictly stronger** than classifying divergence-free covariants —
  `dim ker(div)^G = 5635` at `d = 35`, and the tangency map onto
  `H^0(X,O_X(m+2))^G` is *surjective* for every `m >= 4`
  (`FOLIATION_REFORMULATION.md`, Proposition 5.1), so neither condition alone
  obstructs anything;
* what is restrictive is that **one** `T` must satisfy the adjugate
  factorization and the ramification factorization at once. Both are exactly
  the conditions no single-invariant argument sees.

Round 5's own concrete progress inside (54) is `EXCLUSION_DPRIME_2_3.md`:
`d' in {2,3}` is impossible, removing two cells from every ambient degree,
including `k = 32, 33` at `d = 35`. It does not close (B).

**Problem E headline: OPEN.** Nothing in sections 3–6 changes it. Section 3 is a
relocation of an existing question, section 4 removes routes, section 5 names
what is left, and section 6 states the geometric alternative as a single
condition on a single object.
