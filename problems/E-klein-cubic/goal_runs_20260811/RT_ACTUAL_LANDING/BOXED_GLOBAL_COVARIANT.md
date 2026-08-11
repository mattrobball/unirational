# The boxed remaining theorem: global-covariant pointed-rational-curve classification

Exit: `GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED`.

Provenance: external message `[20]` section 6. The landing-identity system is
verified exactly here (`verify_landing_identity.py`, `RESULT: PASS`); the
statement is boxed unchanged in content, with the notation fixed to the
repository's.

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

> ### Global-covariant pointed-rational-curve classification
>
> Let `A = HB + FC` be a `G`-covariant ambient landing tuple for the Klein cubic
> `X`, i.e. a nonzero `A ∈ (Sym^d W^v ⊗ W)^G` with `F(A) = 0`, decomposed along
> a form `H` cutting the divisorial common factor `D_X` of `A|_X`, with
> `gcd(H,F) = 1`, so that the landing-identity system
>
> ```
> F(B + tC) = (F - H t)(R_0 + R_1 t - R_3 t^2)
> ```
>
> holds. **Classify the normalized two-dimensional slice ideals of such tuples
> at the generic points of the irreducible components of `D_X`, including all
> higher normal jets, and prove that the orbit-summed correspondences of the
> resulting pointed rational-curve families cannot realize the full-support
> endomorphism required by CLEAN** — that is, cannot produce a nonzero composite
>
> ```
> V --> IH^1(S,Q) --Gys_S--> V
> ```
>
> for any orbit of components `S ⊂ D_X`.

### 2.1 Why it cannot be replaced

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

### 2.2 What is known about the classification so far

| cell | slice behaviour | status |
|---|---|---|
| `B(eta_S), C(eta_S)` independent | rank-two cell; ideal generated by `(H,F)`; exceptional `P^1` maps to a **line**, giving `lambda_S : S ⇢ F(X)` and a cylinder map | line-type; `LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL` applies |
| `C` proportional to `B` or vanishing on `S` | higher normal jets; slice ideal can be `m`-primary | **open**; the conic countermodel lives here |
| any cell, coefficient system | the block is `IC_S(U)(-1)` in perverse degree `0`, and only the **constant quotient** of `U` leaks | settled: `CONSTANT-QUOTIENT-COLLAPSE-PROVED` |
| any cell, surface type | `S` is not smooth and not normal-with-rational-singularities | settled: `CLEAN-IMPLIES-NON-RATIONAL-SINGULAR-RECEIVER-PROVED` |
| `5 <= k <= 10` | every component of `D_X` is individually `G`-stable, and the full `V` sits in `H^1(S̃,Q)` | settled: `CLEAN-COMPONENTS-G-STABLE-FOR-k-AT-MOST-10-PROVED` |

Exit `GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED`.
**Problem E headline: OPEN.**
