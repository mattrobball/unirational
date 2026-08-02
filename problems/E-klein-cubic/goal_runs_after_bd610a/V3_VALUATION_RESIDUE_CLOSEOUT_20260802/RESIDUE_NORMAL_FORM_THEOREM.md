# Valuation obstruction normal form for the genuine Klein twist

## 1. Setup

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}\subset\mathbf P(W),
\]

where `W` is the honest five-dimensional Weil representation.  Put

\[
K=K_{\mathrm{proj}}=\mathbf C(\mathbf P(W))^G,
\]

let `T/K` be the genuine generic projective `G`-torsor, and write

\[
X_T={}^T X.
\]

Thus `trdeg_C K=4`.  For a Krull valuation `v` of `K`, trivial on `C`, let
`K_v^h` be the fraction field of the henselization, `kappa(v)` its residue
field, and `D_v` and `I_v` the decomposition and inertia groups of a chosen
prolongation to the genuine splitting field.

The statements below concern the full smooth five-coordinate twist.  They do
not use the auxiliary `xCD` plane, a Pfaffian characteristic cubic, or the
selected fixed ternary frame.

## 2. The normal-form theorem

> **Theorem (V3 residue normal form).**  Let `v` be any Krull valuation of
> `K`, trivial on `C`.
>
> 1. The local twist has index one:
>    \[
>    \operatorname{ind}(X_T\otimes_KK_v^h)=1.
>    \]
> 2. If `I_v` is nontrivial, then
>    \[
>    X_T(K_v^h)\ne\varnothing.
>    \]
> 3. If `I_v=1`, the genuine torsor and twist extend over the henselian
>    valuation ring to a finite-etale torsor and a smooth proper cubic model,
>    and there is an exact equivalence
>    \[
>    X_T(K_v^h)\ne\varnothing
>    \quad\Longleftrightarrow\quad
>    X_{\overline T_v}(\kappa(v))\ne\varnothing,
>    \]
>    where `X_{\overline T_v}` is the genuine residue `D_v`-twist.
> 4. If `kappa(v)` is `C1`, then the equivalent conditions in (3) hold.
> 5. If `X_T(K_v^h)=empty`, then all of the following necessary conditions
>    hold:
>
>    ```text
>    I_v = 1;
>    kappa(v) is not C1;
>    trdeg_C kappa(v) >= 2;
>    rational_rank(v) <= 2 and Krull_rank(v) <= 2;
>    D_v is conjugate to G or to the maximal 11:5 subgroup;
>    the residue twist is pointless but has index one.
>    ```
>
>    If `Krull_rank(v)=2`, then necessarily
>    \[
>    \operatorname{ratrank}(v)=2,
>    \qquad
>    \operatorname{trdeg}_{\mathbf C}\kappa(v)=2;
>    \]
>    in particular such a site is an Abhyankar rank-two valuation.

### Proof

The universal fixed-subgroup cycles on every Klein twist have degrees

\[
60,\quad132,\quad165,\quad220,
\]

and

\[
-13\cdot60+3\cdot132+165+220=1.
\]

They survive every scalar extension, proving (1).

For (2), finite inertia is tame in residue characteristic zero.  The
arbitrary-rank ramification pairing and the fact that the base contains all
roots of unity make `I_v` central in `D_v`.  For every nonidentity element of
`PSL_2(F_11)`, the exact centralizer census supplies either a stable point on
`X` or a stable projective line contained in `X`.  Twisting that linear
object gives a `K_v^h`-point.

Assume `I_v=1`.  The torsor cocycle factors through the residue Galois group.
Finite-etale descent over a henselian local ring extends it over the valuation
ring.  Twisting the honest rank-five representation gives a free rank-five
module, and twisting the invariant smooth cubic gives a smooth proper model.
A residue point lifts by smooth Hensel lifting.  Conversely, a generic point
extends by properness and reduces to a residue point.  This proves (3).

If the residue field is `C1`, its five-variable cubic has a nontrivial zero
because `5>3`; this proves (4).  Every field of transcendence degree at most
one over `C` is `C1`, so a nonpoint has residue transcendence degree at least
two.

The Abhyankar inequality for the four-dimensional field `K` is

\[
\operatorname{ratrank}(v)+
\operatorname{trdeg}_{\mathbf C}\kappa(v)\le4.
\]

Thus a nonpoint has rational rank at most two.  The Krull rank of an ordered
abelian group of finite rational rank is at most its rational rank, so the
Krull rank is also at most two.  If it is two, rational rank is at least two;
combining both inequalities forces rational rank two and residue
transcendence degree two, with equality in Abhyankar's inequality.

Before the later subgroup work, the exact subgroup sweep left four possible
unramified decomposition groups:

```text
G, A5_class_1, A5_class_2, 11:5.
```

For each embedded maximal `A5`, an exact degree-eleven covariant
`P(V3) --> X` is now installed.  Twisting the honest three-dimensional
representation gives a split plane over every extension field of `C`; the
nonempty domain of the twisted rational map has a rational point because the
field is infinite.  Hence every twist by either maximal `A5` has a point.
The two `A5` cases cannot occur at a negative residue site, leaving exactly
`G` and `11:5`.  The residue twist still carries the universal degree
`60,132,165,220` cycles, so it has index one.  This proves (5).

## 3. Consequences for valuation searches

### 3.1 All higher-rank sites are positive

Every valuation of Krull rank at least three has rational rank at least three,
therefore residue transcendence degree at most one.  Its residue is `C1`, so
it is locally soluble.  This closes all rank-three, rank-four, and more
nonstandard valuation proposals at once.

### 3.2 The only geometric shapes still capable of being negative

For a nontrivial valuation, a negative site must be one of the following:

- rank one, with residue transcendence degree two or three and rational rank
  one or two;
- rank two Abhyankar, with residue transcendence degree exactly two.

It must also be unramified and have decomposition group `G` or `11:5`.
Therefore a value-group, ramification, component-multiplicity, or local-index
argument cannot finish the negative direction.  The local binary is literally
pointlessness of a smooth, index-one residue cubic.

### 3.3 Named remaining residue models

The smallest installed full-`G` divisorial residue models are the invariant
boundaries

```text
f5 = 0,
f6 = 0.
```

At either generic divisor, a valid negative proof must decide the complete
five-coordinate residue twist, not one selected plane or Hessian-kernel line.
The only unresolved proper-decomposition model is the maximal `11:5` cyclic
trace cubic

\[
\operatorname{Tr}_{E/K}
\left(r_2^{-1}a^2\sigma(a)\right)=0.
\]

The installed H5 packet remains undecided on that equation.

## 4. What this closes and what it does not

This theorem closes the *valuation mechanics*: ramification, value groups,
higher rank, low-residue dimension, local index, and both maximal `A5`
decomposition classes cannot produce a nonpoint.  Any genuine valuation
obstruction is now forced into the residue normal form above.

It does **not** prove any of the following:

- a `K_proj`-point of the genuine Klein twist;
- a pointless completion;
- pointlessness or solubility of the full `f5` or `f6` residue twist;
- a point or nonpoint on the `11:5` trace cubic;
- an all-degree landing theorem;
- a higher unramified-cohomology obstruction.

Accordingly the governing Goal-V exit remains

```text
V-UNDECIDED
```

while the theorem-level scoped exit is

```text
V3-RESIDUE-NORMAL-FORM-PASS.
```
