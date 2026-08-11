# The Chern-character defect identity, and the vacuity of the first-order gate

Exits: `GLOBAL-JACOBIAN-COMPLEX-DEFECT-IDENTITY-PROVED`,
`DEFECT-IDENTITY-IMPOSES-NO-EFFECTIVITY-CONSTRAINT`,
`JACOBIAN-SOCLE-DEGREE-FIVE-EXACT`,
`FIRST-ORDER-TANGENT-EXTENSION-GATE-VACUOUS-ABOVE-DEGREE-FIVE-PROVED`.

Provenance: external round 4, sections 4 and 5 (unaudited). Verdict:
**CONFIRMED, and deliberately deflated**: the arithmetic is exact and replays,
and the identity constrains nothing on its own — which the source itself says,
and which is ported here rather than dressed up. The socle corollary is
**CONFIRMED AND SHARPENED**: it is vacuous above degree five, it is exactly one
linear condition in degree five, and — a point the source does not make — the
vacuity survives passage to the equivariant category.

Machine checks: `verify_forced_foliation.py` blocks (D) and (E)
(`RESULT: PASS`), `forced_foliation_witness.m2` section 0b/0c (`RESULT: PASS`).

---

## 1. The complex

Let `T` be a primitive landing tuple of degree `d`, `Q_T = grad F(T)` as in
`THEOREM_FORCED_FOLIATION.md`. Twisting so the entries have the right degree,

```
Q_T^t :  O(d)^{+5} --> O(3d),
```

with cokernel a coherent sheaf written `[Q_T]`, and set
`E_T = ker(Q_T^t) / O·T` (the map `O -> O(d)^{+5}` given by `T` is injective
since `T != 0`). Away from the base locus of `T`, `E_T` is the pullback of
`T_X` along the induced map. In `K^0(P^4)`:

```
[E_T] = 5[O(d)] - [O] - [O(3d)] + [Q_T].                            (15)
```

*Derivation.* `[ker(Q_T^t)] = 5[O(d)] - [im] = 5[O(d)] - ([O(3d)] - [Q_T])`;
subtract `[O]` for the quotient by `O·T`. This is a `K`-theory statement about
classes only; it presupposes nothing about the local structure of the maps.

The global complex is

```
C_T :  O(5-2d) --P_T--> T_{P^4} --dT--> E_T,                        (16)
```

exact on the generic smooth locus. The left map is the foliation (14); the
right one is the derivative of `T`.

*Scope flag, ported honestly.* The exactness of (16) is asserted by the source
only "on the generic smooth locus", and it is **not** re-proved here. It is not
needed for section 2, which is a statement about `K`-classes and is independent
of where the complex is exact.

## 2. The `ch_2` identity — replayed

With `ch_2(O(m)) = m^2 H^2/2` and `ch(T_{P^4}) = 5 ch(O(1)) - 1` from the Euler
sequence:

```
ch_2(E_T)      = 5 d^2/2 - 0 - 9d^2/2 + [Q_T]_2 = -2d^2 H^2 + [Q_T]_2
ch_2(T_{P^4})  = 5/2 H^2
ch_2(O(5-2d))  = (5-2d)^2 H^2 / 2
```

and the alternating sum along (16) is

```
ch_2(C_T) = ch_2(O(5-2d)) - ch_2(T_{P^4}) + ch_2(E_T)
          = (25 - 20d + 4d^2)/2 - 5/2 - 2d^2 + [Q_T]_2
          = [Q_T]_2 - 10(d-1) H^2.                                  (17)
```

`verify_forced_foliation.py` block (D) replays every line symbolically in `d`.
Rank bookkeeping also balances: `rk E_T = 5 - 1 - 1 = 3 = dim X`, and the
alternating rank of (16) is `1 - 5 + 3 = -1`; and `c_1(E_T) = 2d H` when
`[Q_T]` is supported in codimension `>= 2`.

## 3. What (17) does and does not constrain

**Does.** It is an exact compatibility law. The homology of (16) records, in one
number, the failure of `ker Q_T^t` to be saturated, divisorial ramification,
critical surfaces, base-cluster defects and higher infinitely-near
contributions.

**Does not.** These contributions enter (17) **with opposite signs**, because
they sit in different homological positions of the alternating sum. There is
therefore no positivity or effectivity argument to be made from (17): a large
base-cluster defect can be paid for by a large ramification term. The source
says this in its own words — "an exact compatibility law, not an effectivity
contradiction" — and it is right. No exit here claims otherwise.

To use (17) one would need, in addition, either a sign-definite decomposition of
the homology (not available: the terms genuinely have both signs) or an
independent bound on `[Q_T]_2`. Neither is supplied by the source or here.

`DEFECT-IDENTITY-IMPOSES-NO-EFFECTIVITY-CONSTRAINT` is recorded as a **negative**
exit for that reason: the identity is true, replayable, and inert.

## 4. The Jacobian socle, and the first-order tangent-extension gate

### 4.1 The socle computation

`F` smooth in `5` variables `=>` the five partials `F_0,...,F_4`, of degree `2`,
have only the origin as common zero, hence form a regular sequence, hence
`R/J` (`J = (F_0,...,F_4)`) is an Artinian complete intersection with Hilbert
series

```
prod_i (1-t^2)/(1-t) = (1+t)^5 = 1 + 5t + 10t^2 + 10t^3 + 5t^4 + t^5,
```

so **socle degree `5 = 5·(3-2)`**, and

```
(R/J)_m = 0    for every m >= 6,
```

i.e. every form of degree `>= 6` lies in the Jacobian ideal.

Verified for the actual Klein cubic `F = sum_i x_i^2 x_{i+1}`:
`forced_foliation_witness.m2` section 0c computes `dim = 0`, `codim = 5`,
Hilbert function `(1,5,10,10,5,1,0,0,0)` in degrees `0..8`, and confirms the
socle is spanned by the degree-five Hessian (`hess % J != 0`). Independently,
`verify_forced_foliation.py` block (E) bounds `dim(R/J)_m` from above by an
exact rank computation modulo `p = 1000003` (a mod-`p` rank is a lower bound
for the rank over `Q`, hence an upper bound for the codimension), obtaining
`1, 0, 0` in degrees `5, 6, 7`. The two routes agree.

This also cross-checks a sealed repository computation:
`certificates/hodge_centers/HODGE_CENTER_NECESSITY.md` §3 records the same
Hilbert function `1,5,10,10,5,1,0` in its Griffiths-residue description of
`H^{2,1}(X)`.

### 4.2 The gate

The sealed retraction identity
(`goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md`,
`goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/THEOREM.md` Thm C) has
as its first of three components

```
H + 3 Phi(x,x,Q) = F R,        deg H = d-1, deg Q = d-3, deg R = d-4.   (18)
```

Since `3 Phi(x,x,Q) = sum_i F_i(x) Q_i`, (18) says exactly

```
H  in  J + (F)  =  J,
```

the last equality by Euler (`3F = sum_i x_i F_i`, so `F in J`; verified
symbolically in the witness).

> **Corollary 4.1.** For `deg H = d-1 >= 6`, i.e. for `d >= 7`, the identity
> (18) imposes **no condition whatsoever** on `H`: a solution `(Q, R)` exists
> for every `H`, with `R = 0`.
>
> For `deg H = 5` (i.e. `d = 6`) it is exactly **one** linear condition, since
> `dim (R/J)_5 = 1`; the Hessian of `F` is an explicit form violating it.
>
> For `deg H <= 4` it is `dim (R/J)_{d-1}` conditions
> (`1, 5, 10, 10, 5` in degrees `0..4`).

### 4.3 The corollary survives equivariance — and this is the part to keep

`H` must be a `G`-invariant and `Q` a `G`-covariant, so Corollary 4.1 is only
useful if solvability holds in the equivariant category. It does:

> **Proposition 4.2.** The map
> `mu : (Sym^{d-3}W^v ⊗ W) -> Sym^{d-1}W^v`, `Q |-> sum_i F_i(x) Q_i`, is
> `G`-equivariant with image `J_{d-1}`. Hence for `d >= 7` every
> `G`-**invariant** `H` of degree `d-1` is `mu(Q)` for some `G`-**covariant**
> `Q` of degree `d-3`.

*Proof.* `mu` is the contraction of `grad F in W^v ⊗ Sym^2 W^v` against
`Q in Sym^{d-3}W^v ⊗ W` using the canonical pairing `W^v ⊗ W -> C`; each factor
is a `G`-map (using `F` invariant, which holds since `G` is perfect), so `mu`
is a `G`-map, and its image is `J_{d-1}` by definition. For `d-1 >= 6` we have
`J_{d-1} = Sym^{d-1}W^v`, so `mu` is a surjection of `G`-modules; taking
`G`-invariants is exact in characteristic zero for finite `G` (the same
Reynolds step as `INTERPOLATION_THEOREM.md` §2), so
`mu : (Sym^{d-3}W^v ⊗ W)^G -> (Sym^{d-1}W^v)^G` is onto. ∎

> **Corollary 4.3.** In the surviving range of the retraction branch the
> first-order tangent-extension gate is vacuous. The repository's binding
> degree floor there is `d >= 24`
> (`goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/RETRACTION_DEGREE_BOUND.md`,
> `DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24`), so `deg H = d-1 >= 23`,
> far above the socle degree `5`. Identity (18) therefore carries **no**
> information about any surviving retraction, equivariance included.

The content of the retraction branch is consequently entirely in the other two
sealed identities, `F(Q) = H S` and `H R + 3Phi(x,Q,Q) + F S = 0`, and in the
recorded residual: whether the discriminant

```
Delta = R^2 + 4S  in  C[W]^G_{2d-8}
```

is a square. That question is untouched by anything in this file, and the
sealed exit `DELTA1-KLEIN-RETRACTION-BRANCH-OPEN` stands. Recorded here only so
that no future run re-derives (18) as if it were a constraint.

## 5. Non-claims

* (17) is not used to exclude anything, and cannot be without new input.
* The exactness of (16) is not re-proved; nothing above depends on it.
* Corollary 4.3 removes one gate from the retraction branch. It does **not**
  weaken the branch's open status, and it is not progress on `Delta`.
* `[Q_T]_2` is not computed for any tuple, hypothetical or actual.

**Problem E headline: OPEN.**
