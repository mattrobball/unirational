# C1-residue local-solubility theorem

## 1. Exact object and local-field convention

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
X=\{F=0\}\subset \mathbf P(W),\qquad \dim W=5,
\]

where `W` is the honest five-dimensional Weil representation and `F` is
the invariant Klein cubic.  Let `K=K_proj` and let `T/K` be the genuine
generic `G`-torsor.  Thus the variety in this packet is exactly

\[
X_T={}^T X/K,
\]

not the `xCD` plane, a Pfaffian characteristic cubic, or a fixed-frame
specialization.  In the verified Hilbert--90 frame its equation is the
35-term cubic `Phi` in five projective variables recorded in
`G_ALL_DEGREE/generic_cubic.json`.

For a Krull valuation `v` of `K`, trivial on `C`, write `K_v^h` for the
fraction field of the henselization of its valuation ring and `kappa(v)`
for its residue field.  This is the primary local-field model below.  No
unspecified higher-rank completion is silently identified with `K_v^h`.

## 2. The theorem

> **Theorem.** If `kappa(v)` is a `C1` field, then
>
> \[
> X_T(K_v^h)\ne\varnothing.
> \]
>
> The assertion holds for valuations of arbitrary rank.

### Proof

Choose a prolongation of `v` to the generic splitting field and let `D` and
`I` be its decomposition and inertia groups.

If `I` is nontrivial, the exact inertia-centralizer theorem applies.  In
residue characteristic zero, `I` is central in `D`: the arbitrary-rank
ramification pairing injects `I` into the characters of the finite value
group quotient, its kernel being wild inertia; conjugation acts through the
residue action on the character values, and every such root of unity lies
in the fixed base residue field because `C` contains all roots of unity.
This argument is written with exact references in
`VALUATION_FOUNDATIONS.md`.  The independently
reconstructed centralizers of nonidentity elements of `PSL_2(F_11)` have
orders

```text
element order       2   3   5   6  11
centralizer order  12   6   5   6  11.
```

The order-two and order-three/six cases preserve a projective line contained
in `X`; the order-five and order-eleven cases preserve a projective point on
`X`.  Twisting that stable linear space gives a `K_v^h`-point.  This is the
genuine full-twist theorem checked by
`V_VALUATION_TROPICAL/verify_inertia_centralizers.py`.

Suppose now that `I=1`.  The local torsor extends to a finite etale torsor
over the henselian valuation ring `R_v^h`.  Precisely, its cocycle factors
through the residue Galois group; the residue torsor lifts by the equivalence
between finite etale algebras over a henselian local ring and over its
residue field (Stacks Tag `04GK`).  This does not assume that an integral
closure over a non-noetherian valuation ring is finite.  Twist the honest linear
representation `W` as well as its invariant cubic.  The resulting rank-five
vector bundle over the local ring `R_v^h` is free, so the ambient twist is a
split `P4`; the cubic gives a smooth proper model

\[
\mathscr X_T\subset\mathbf P^4_{R_v^h}.
\]

Its special fibre is the genuine residue twist, hence is cut out by one
homogeneous cubic form in five variables over `kappa(v)`.  By the definition
of a `C1` field, a degree-`d` homogeneous form in `n>d` variables has a
nontrivial zero.  Here

\[
n=5>3=d,
\]

so the special fibre has a `kappa(v)`-point.  Smooth lifting over a henselian
local ring lifts that point to an `R_v^h`-point and therefore to a
`K_v^h`-point.  This proves the theorem.  Notice that the degree-55 cycle and
Coray's complete-DVR theorem are not needed for this argument.

For the lifting statement in this general henselian-ring scope, see the
Stacks Project, Lemma 15.13.3, Tag
[`0H74`](https://stacks.math.columbia.edu/tag/0H74).

## 3. Decomposition-group refinement

The same dichotomy gives a second exact restriction which does not assume
that the residue field is `C1`.

> If `I=1` and the decomposition group `D` is not conjugate to
> `G=PSL_2(F_11)`, either maximal `A5` class, or the maximal `11:5`, then
> `X_T(K_v^h)` is nonempty.

Indeed, the unramified residue torsor reduces the local problem to a twist
of the restricted `D`-action.  The exact subgroup sweep proves that every
proper subgroup action other than the two maximal `A5` restrictions and
the maximal `11:5` restriction is unirational.  Duncan--Reichstein,
Theorem 1.1, then gives a rational point on every corresponding `D`-torsor
twist, including this residue torsor; smooth lifting supplies the
`K_v^h`-point.  The `D10` and `D12` cases also have direct contained-line
proofs.

The two external inputs are:

- A. Duncan and Z. Reichstein, *Versality of algebraic group actions and
  rational points on twisted varieties*,
  <https://arxiv.org/abs/1109.6093>, Theorem 1.1;
- I. Cheltsov, Y. Tschinkel, and Z. Zhang, *Equivariant unirationality of
  Fano threefolds*, <https://arxiv.org/abs/2502.19598>, Theorem 5.1.

Their application and the two nonconjugate maximal `A5` classes are audited
in `H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/`.  Therefore any negative
valuation must satisfy the sharper necessary conditions

```text
I = 1,
kappa(v) is not C1,
D is G, one of the two maximal A5 classes, or maximal 11:5.
```

This is a necessary-condition classification, not a point theorem for the
three exceptional decomposition groups.

## 4. Transcendence-degree corollary

Every field of transcendence degree at most one over `C` is `C1`:

- transcendence degree zero gives `C` itself;
- in transcendence degree one, choose `t` transcendental.  Given a
  homogeneous form over the field, its finitely many coefficients lie in a
  finite subextension of the algebraic extension over `C(t)`.  That finite
  extension is the function field of a complex curve, so Tsen gives a
  nontrivial zero already over that subextension.

Consequently

\[
\boxed{\operatorname{trdeg}_{\mathbf C}\kappa(v)\le1
       \ \Longrightarrow\ X_T(K_v^h)\ne\varnothing.}
\]

The external field theorem used here is Tsen--Lang; one primary reference is
S. Lang, *On quasi algebraic closure*, Annals of Mathematics **55** (1952),
373--390, DOI <https://doi.org/10.2307/1969785>.

This corollary strictly enlarges the earlier `residue field C` row.  In
particular it retires:

- every rank-one valuation with residue transcendence degree at most one;
- every rank-two valuation with residue transcendence degree at most one;
- every higher-rank or non-Abhyankar valuation having such residue;
- both ramified and unramified cases.

These are genuine local points on the full five-coordinate twist.

## 5. Precisely covered completion models

### Ordinary rank-one completion

For a discrete rank-one valuation, `K_v^h` embeds in the ordinary complete
discretely valued field `K_v^comp`.  Hence the theorem gives

\[
X_T(K_v^comp)\ne\varnothing
\]

whenever its residue field is `C1`.

### Successive complete-DVR towers

More generally, consider a specified finite tower

```text
K_0 = kappa,
K_1 complete DVR with residue K_0,
...
K_r complete DVR with residue K_(r-1),
```

Assume the fields contain `C` and every displayed discrete valuation is
trivial on `C`, and base-change the genuine generic twist to `K_r`.  If
`K_0` is `C1`, then the twist has a `K_r`-point.  Indeed, descend stage by
stage.  At any stage with nontrivial torsor inertia the exact centralizer
theorem supplies a point.  At an unramified stage the twist has smooth good
reduction to the residue twist, and a residue point lifts.  At the terminal
stage the five-variable cubic has a point by `5>3`.

This covers nongeometric as well as geometric successive towers and, in
particular, rank-one or rank-two successive towers whose terminal residue is
`C1`.  It also reproves the previously covered length-three/four geometric
towers for this special twist without invoking Coray.

For an arbitrary higher-rank topology, the word "completion" can denote
inequivalent constructions.  This packet asserts only the henselization and
the explicitly displayed successive complete-DVR model.

## 6. Exact boundary

The theorem does **not** cover the central unresolved sites:

- a geometric divisorial valuation of the four-dimensional field, whose
  residue has transcendence degree three;
- a saturated geometric rank-two Parshin chain, whose terminal residue has
  transcendence degree two;
- any unramified valuation whose residue field is not known to be `C1`;
- among those, only decomposition groups `G`, maximal `A5`, and maximal
  `11:5` remain after the subgroup-twist theorem;
- the global field `K_proj` itself.

Thus it is an exact local-solubility advance, not a rational point on
`V(Phi)` and not a Goal-G headline decision.
