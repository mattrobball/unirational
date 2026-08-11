# The equivariant interpolation theorem, and exactly what it kills

Exit: `FINITE-EQUIVARIANT-JET-DATA-ASYMPTOTICALLY-INTERPOLABLE-PROVED`,
`FIXED-FINITE-LOCAL-DATA-NOT-AN-ALL-DEGREE-OBSTRUCTION-PROVED`,
`DECORATED-CLUSTER-OBSTRUCTION-PROGRAM-BOTTOMED-OUT`.

Provenance: external round 4, section 1 (unaudited). Verdict: **CONFIRMED**,
with the proof written out and — the part that matters — with the scope
boundary made precise and machine-checked (`verify_interpolation_scope.py`,
`RESULT: PASS`).

---

## 1. Statement

Write `G = PSL(2,11)`, `W` the Klein five-dimensional representation,
`P(W) = P^4`, and

```
M_d := H^0(P(W), O(d) (x) W)^G = (Sym^d W^v (x) W)^G
```

for the space of homogeneous `G`-covariant five-tuples of degree `d`.

> **Theorem 1.1 (equivariant interpolation).** Let `Z ⊂ P(W)` be a `G`-stable
> closed subscheme. Then there is a `d_0 = d_0(Z)` such that for every
> `d >= d_0` the restriction map
>
> ```
> rho_d :  M_d  -->  H^0(Z, (O(d) (x) W)|_Z)^G                      (2)
> ```
>
> is **surjective**.

Equivalently: for `d >= d_0(Z)`, every `G`-invariant section of `O(d) ⊗ W` over
`Z` — every compatible finite package of orbit-wise values, jets, cluster
decorations, prescribed maps on exceptional curves, marked attachments — is the
restriction of one global homogeneous `G`-covariant of degree `d`.

## 2. Proof

Let `E = O_{P(W)}(d) ⊗ W`; since `W` is a vector space this is `O(d)^{⊕5}`
carrying a `G`-linearization twisting the five summands into each other. The
ideal sheaf sequence of `Z`

```
0 --> I_Z (x) E --> E --> E|_Z --> 0
```

is a sequence of `G`-equivariant coherent sheaves and `G`-equivariant maps,
because `Z` is `G`-stable. Its cohomology sequence is a sequence of
`G`-modules:

```
H^0(P(W), E) --> H^0(Z, E|_Z) --> H^1(P(W), I_Z (x) E) --> ...
```

**Step 1 (Serre).** `I_Z` is coherent on the projective scheme `P(W)`, so there
is `d_0(Z)` with `H^1(P(W), I_Z(d) ⊗ W) = H^1(P(W), I_Z(d))^{⊕5} = 0` for all
`d >= d_0(Z)`. Hence `H^0(E) -> H^0(E|_Z)` is surjective for `d >= d_0(Z)`.

**Step 2 (Reynolds).** `G` is finite and the ground field has characteristic
zero, so the Reynolds operator `R = |G|^{-1} sum_{g in G} g` is a
`G`-equivariant projector onto invariants and the functor `V |-> V^G` is exact
on `G`-modules. Applying it to the surjection of Step 1 gives surjectivity of
`H^0(E)^G -> H^0(E|_Z)^G`, which is (2). ∎

Both steps are standard; neither is in dispute. What needs care is the
quantifier order, and that is section 3.

## 3. Scope — stated exactly, and machine-checked

`verify_interpolation_scope.py` verifies the four statements below by **exact**
rank computations (`Fraction` arithmetic, no floating point).

### 3.1 The quantifier order is `Z` first, then `d`

`d_0` depends on `Z`. The theorem reads

> for every `Z`, there exists `d_0(Z)`, such that for every `d >= d_0(Z)` ...

and **not**

> there exists `d_0`, such that for every `Z` and every `d >= d_0` ...

`d_0(Z)` is unbounded over `Z`. The verifier exhibits this exactly: for `Z` the
order-`m` infinitesimal neighbourhood of a point of `P^n`, the restriction map
`H^0(O(d)) -> H^0(O_Z(d))` is surjective **if and only if** `d >= m`, checked
for `n = 2, 4` and `m = 1,2,3,4`, so `d_0(Z) = m` exactly. In the equivariant
setting the same effect appears: for a single free `G`-orbit in `P^2` the
invariant restriction map is already surjective in degree 1, and for three free
orbits it is surjective only from degree 3.

### 3.2 Data that grows with `d` is not covered — this is the live boundary

Take `Z_d :=` the order-`(d+1)` jet at a point. Then for **every** `d` the
restriction map fails to be surjective, and the deficiency `2,3,4,5,6,7,8`
(for `d = 0,...,6` in `P^2`) is strictly increasing. So a family of conditions
whose complexity grows with the degree is untouched by Theorem 1.1.

This is exactly where the surviving obstruction programs must live. A program
that says "for each `d`, the tuple's base cluster must have multiplicity
`>= c·d` at some point of the 55-plane orbit, and such a cluster is
impossible" is **not** refuted by Theorem 1.1. A program that says "the tuple's
slice at `eta_S` must be a decorated cluster of this fixed finite type, and no
covariant restricts to it" **is** refuted by Theorem 1.1.

### 3.3 Only stabiliser-compatible data is interpolable, in any degree

The word "compatible" in the statement is load-bearing. Over a point `p` whose
stabiliser `G_p` is nontrivial, the value `T(p)` of any covariant satisfies
`T(p) = g T(p)` for `g in G_p`, so it lies in `W^{G_p}` — a proper subspace.
No degree, however large, changes this. The verifier exhibits it: for the
cyclic group acting on `P^2` by coordinate shift and `p = (1,1,1)`, the space
of achievable values is one-dimensional (`= dim W^G`) in **every** degree
`0..8`, while at a free point it is all of `W` already in degree 1.

For `G = PSL(2,11)` on `P(W)` this is not idle: the 55 plus-planes, the
minus-lines, the `V_4`-lines and the odd strata all carry nontrivial
stabilisers, and the interpolable jet packages along them are exactly the
stabiliser-equivariant ones. Theorem 1.1 says every *compatible* package is
realised; it does not say every package is compatible.

### 3.4 The theorem is about a LINEAR condition, not about landing

Theorem 1.1 produces a covariant `T in M_d` whose restriction to `Z` is the
prescribed `sigma_d`. It says **nothing** about whether that `T` is nonzero
after imposing anything else, and in particular nothing about

* `F(T) = 0` — a nonlinear closed condition on `M_d`, invisible to (2);
* primitivity of `T`;
* dominance of the induced map.

Any contradiction must therefore consume `F(T) = 0` globally. That is the
source's own conclusion and it is correct.

## 4. What this closes

> **Corollary 4.1.** No obstruction program whose input is a *fixed finite*
> package of local, cluster, incidence or attachment data — one that does not
> grow with `d` — can prove all-degree nonexistence of a landing covariant.

This retires the decorated-cluster program of `SLICE_CLASSIFICATION.md` as a
route to nonexistence, and it does so in the same direction that packet's own
findings already pointed: `LANDING-IDENTITIES-IMPOSE-NO-CURVE-TYPE-CONSTRAINT`
(every pointed rational curve occurs) and `HIGHER-NORMAL-JET-DEPTH-UNBOUNDED`
(the depth is unbounded at fixed target degree). Theorem 1.1 explains **why**
those computations came out empty and shows the emptiness is structural, not an
accident of the cases examined.

**Third lane to bottom out at the headline.** With this, three independent lanes
have now reduced to the all-degree landing question itself and to nothing
smaller:

| lane | where it bottoms out | exit |
|---|---|---|
| F55 coefficient circuits | `F55_COVERAGE_C_ADJUDICATION_20260808.md`: "the global statement of Coverage C is equivalent to the original F55 pointlessness problem" | `F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE` |
| the CLEAN arithmetic sieve | `goal_runs_20260810/COMBINED_DEGREE_SIEVE/`: "Closing CLEAN needs a geometric exclusion of small `delta`, not more congruences" | `COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED` |
| decorated local/cluster data | this file, Corollary 4.1 | `DECORATED-CLUSTER-OBSTRUCTION-PROGRAM-BOTTOMED-OUT` |

The pattern is uniform and worth stating plainly: every finite local invariant
of the hypothetical tuple that has been computed so far is either unconstrained
or asymptotically prescribable. What survives is global.

## 5. Non-claims

* Theorem 1.1 is **not** evidence that a landing covariant exists. It is a
  statement about a linear restriction map, and the landing condition is not
  linear.
* It does **not** bound `d_0(Z)` for any `Z` of interest here. Making
  `d_0(Z)` effective (Castelnuovo–Mumford regularity of the relevant `I_Z`)
  was not attempted and is not needed for Corollary 4.1.
* It does **not** apply to data indexed by `d`, nor to conditions that are
  nonlinear in `T`. Both remain legal ground for an obstruction.

Terminal marker: `verify_interpolation_scope.py` prints `RESULT: PASS`.
