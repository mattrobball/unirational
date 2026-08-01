# Candidate invariant definition and no-go scope

## 1. The broad additive candidate

Fix a finite group `G` and a smooth proper `G`-variety `Y`.  An **additive
Mackey-valued point obstruction** consists of classes

\[
o_H(Y)\in M(H),\qquad H\leq G,
\]

where `M` is a cohomological Mackey functor, subject to:

1. **restriction naturality:**
   `res_H^K(o_K(Y))=o_H(Y)` for `H <= K`;
2. **cohomological transfer:**

   \[
   \operatorname{cor}_H^K\operatorname{res}_H^K
   =[K:H]\,\mathrm{id};                         \tag{1.1}
   \]

3. **fixed-point normalization:** `o_H(Y)=0` whenever `Y^H` is nonempty;
4. **torsion target:** the reduced obstruction group is killed by `|G|`.

The same definition can be made torsorwise.  Restriction of an invariant
along `H -> G` means precomposition with extension of structure group from an
`H`-torsor to a `G`-torsor, equivalently pullback along `BH -> BG`.  A fixed
point gives a point on every `H`-twist, forcing the restricted normalized
obstruction to vanish.  We do not incorrectly treat a `G`-torsor as a
`P`-torsor over the same base.

This class covers the obstruction-valued parts of the following theories
whenever they are additive and carry their standard transfers:

- positive-degree integral Borel cohomology of quotient stacks;
- positive-codimension equivariant Chow groups and Chow groups of `BG`;
- ordinary finite-coefficient cohomological invariants;
- stable additive power-operation outputs;
- any finite torsion extension assembled in the abelian category of such
  coefficient groups.

It deliberately does not include arbitrary classes on `[Y/G]`: the
fixed-point normalization is load-bearing.  A class that remains nonzero on a
variety with an `H`-fixed point is not, by itself, an obstruction to a point on
the `H`-twist.

## 2. What genuinely mixed-prime would have to mean

Here

\[
|G|=660=4\cdot3\cdot5\cdot11.
\]

For every abelian group `A` killed by `660`, the Chinese remainder theorem
gives a canonical product of its primary subgroups.  Explicit idempotents in
`Z/660` are

\[
e_2=165,\qquad e_3=220,\qquad e_5=396,\qquad e_{11}=540.       \tag{2.1}
\]

They satisfy

\[
e_p^2=e_p,\qquad e_pe_q=0\ (p\ne q),\qquad
e_2+e_3+e_5+e_{11}=1\pmod {660}.                \tag{2.2}
\]

Thus

\[
A=A_{(2)}\oplus A_{(3)}\oplus A_{(5)}\oplus A_{(11)},
\qquad x=\sum_p e_px.                            \tag{2.3}
\]

There is no cross-prime extension hidden inside the category of finite
abelian groups: `Hom` and `Ext` between a `p`-primary group and a
`q`-primary group vanish for `p != q`.  Likewise, a cup product of classes
killed by coprime powers is zero, since the product is killed by two coprime
integers.

Consequently a **genuinely** mixed-prime obstruction must leave this additive
abelian setting.  It would need nonadditive descent, compatibility, or
selection data that is not an element of a `660`-torsion Mackey group.

## 3. The exact selected candidate and its result

The selected candidate is the broad additive class above, because it is the
largest common formal envelope of the quotient-stack cohomology, equivariant
Chow, and stable-operation directions in the goal file.

`SYLOW_DETECTION.md` proves:

> For the Klein cubic action, every additive Mackey-valued point obstruction
> satisfying (1)--(4) is zero.

Hence this candidate fails the D2.0 requirement "sensitive after all twists
have index one."  It is refuted before target or source computations.

## 4. What is not claimed

The theorem does not show that every invariant of `[X/G]` is zero.  It does
not cover:

- the rational-point functor itself;
- nonabelian cohomology sets;
- a hypothetical integral spectral invariant with nonadditive gluing;
- unstable operations without additive transfer;
- canonical dimension, except to note that its unknown value is the original
  problem;
- an invariant defined only after a complete classification of actual
  base-locus centres.

Those exclusions are why the exit is `D2-NO-VALID-BRIDGE`, not a universal
impossibility theorem.
