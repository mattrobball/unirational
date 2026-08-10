# Cyclotomic self-isogeny model for the generic twisted `C11`

**Date:** 2026-08-08  
**Status:** `EXACT ALL-DEGREE REDUCTION / ED=4 OPEN`

Let `L/K` be a cyclic extension of degree five, with group

```text
Gamma=<gamma>,
```

and let `A/K` be the form of `mu_11` whose character module is

```text
M=Z/11,             gamma*m=9m.
```

This includes both generic situations used in the Klein-cubic dossier:

```text
K=C(t), L=K(s), s^5=t                         (characteristic zero),
K=k(a), L=K(u), u^5-u=a, char(k)=5            (characteristic five).
```

The claims below are independent of the characteristic, except that
`char(K) != 11` is assumed.

## 1. The rank-four kernel is a principal cyclotomic ideal

Put

```text
P=Z[Gamma],              I=(gamma-1)P.
```

The relation

```text
(1+gamma+gamma^2+gamma^3+gamma^4)(gamma-1)=0
```

identifies `I`, as a `Gamma`-lattice, with

```text
R=Z[zeta_5].
```

Under this identification, the surjection used in the rank-four permutation
presentation is

```text
h:R -> F_11,
h(f(zeta_5))=8 f(9) mod 11.                         (1.1)
```

Indeed, `zeta_5^i` corresponds to `gamma^i(gamma-1)`, and (1.1) sends it to
`9^i(9-1)`, as required.

Define

```text
alpha=zeta_5^3-zeta_5^2-zeta_5-1.                  (1.2)
```

Then

```text
alpha(9)=3-4-9-1=-11=0 mod 11.                    (1.3)
```

In the basis `(1,zeta_5,zeta_5^2,zeta_5^3)`, multiplication by `alpha` has
matrix

```text
[-1 -1  2  0]
[-1 -2  1  2]
[-1 -2  0  1]
[ 1 -2  0  0],                                    (1.4)
```

whose determinant is `11` and whose Smith form is

```text
diag(1,1,1,11).                                    (1.5)
```

Thus `(alpha)` has index eleven in `R`.  It is contained in `ker(h)` by
(1.3), and `ker(h)` also has index eleven because `h` is onto.  Consequently

```text
J:=ker(h)=alpha I.                                 (1.6)
```

This proves principality directly; no class-number assertion is needed.

## 2. The generic torsor is one explicit self-isogeny

Write `D(-)` for the group of multiplicative type with the indicated
character module, and put

```text
H=D(I).
```

Dualizing

```text
0 -> J -> I -> M -> 0
```

and using the isomorphism `I -> J`, `x |-> alpha*x`, gives

```text
1 -> A -> H --phi_alpha--> H -> 1,                 (2.1)
```

where `phi_alpha` is the self-isogeny whose pullback on characters is
multiplication by `alpha`.  Its degree is exactly eleven.

Moreover,

```text
H = (R_{L/K} G_m)/G_m.                             (2.2)
```

It is the dense open subset of `P(L)` consisting of invertible elements
modulo scalar multiplication.  In particular, `H` is a `K`-rational
fourfold.

The embedding `A -> H` factors through the quasi-split torus
`R_{L/K}G_m`: on character modules, (1.1) factors through `P`.  Hence for
every field extension `F/K`, the map

```text
H^1(F,A) -> H^1(F,H)
```

is zero.  The boundary map associated to (2.1),

```text
H(F) -> H^1(F,A),
```

is therefore onto.  It follows that the generic fiber of (2.1), over the
function field of the target copy of `H`, is a versal `A`-torsor.

Thus the missing lower bound is exactly:

> The generic fiber of the explicit degree-eleven self-isogeny
> `phi_alpha:H -> H` does not descend to a field of transcendence degree at
> most three over `K`.

This is equivalent to `ed_K(A)=4`.  It is not proved here.

## 3. Consequence for birational and ordinary torus invariants

Both the source and target of the versal cover are the same rational torus.
Therefore their underlying birational types, smooth rational
compactifications, ordinary Chow groups, ordinary `K`-groups, and unramified
invariants agree.  An incompressibility proof must retain the self-isogeny,
the `A`-action, or the `Gamma`-linearization.  An invariant of the source and
target varieties alone cannot distinguish this cover.

This also explains why the canonical dimension of an auxiliary norm torus
does not transfer automatically: the `A`-torsor becomes the trivial
`H`-torsor after extension of structure group, even though its boundary
class for (2.1) is nontrivial.

## 4. Exact low-codimension Chow boundary

The standard Chern-class route has a further sharp gap.  For every `i>0`,

```text
11 CH^i(BA)=0.                                      (4.1)
```

Indeed, pullback along the degree-eleven atlas `Spec(K) -> BA` lands in
`CH^i(Spec(K))=0`, and pull-push is multiplication by eleven.

Restriction to `L` is injective on these groups: corestriction followed by
restriction is multiplication by `[L:K]=5`, which is invertible on an
eleven-torsion group.  Its image is contained in the `Gamma`-invariants of

```text
CH^*(B mu_11)=Z[c]/(11c),       deg(c)=1.            (4.2)
```

The descent generator acts by

```text
gamma(c)=9c.
```

Since `9` has exact order five modulo eleven,

```text
(Z/11 c^i)^Gamma=0                 for 1<=i<=4.      (4.3)
```

The injectivity just proved yields

```text
CH^i(BA)=0                          for 1<=i<=4.      (4.4)
```

The first positive class occurs in codimension five.  Let `W` be the
five-dimensional descended representation with geometric weights

```text
R_5={1,9,4,3,5} subset F_11^*.
```

This is the order-five subgroup of `F_11^*`, so

```text
product_(r in R_5) (T-r)=T^5-1.
```

Consequently the first four elementary symmetric functions vanish modulo
eleven and the product is one.  Over `L`,

```text
c_5(W)=c^5 != 0.
```

It follows that

```text
CH^5(BA)=Z/11, generated by c_5(W).                 (4.5)
```

The same argument determines the whole positive-degree ring.  Restriction
identifies `CH^i(BA)` with zero unless `5` divides `i`, and `c_5(W)^j`
restricts to `c^(5j)`.  Therefore

```text
CH^*(BA)=Z[u]/(11u),              deg(u)=5,          (4.5a)
u=c_5(W).
```

Here the notation means that the degree-zero copy of `Z` is unchanged and
every positive power of `u` has order eleven.

### 4.1 The codimension-five class vanishes on the versal self-isogeny

The nonzero class in (4.5) still does not survive on the classifying
fourfold in Section 2.  In fact, a stronger representation-theoretic
statement holds:

```text
R_K(H) -> R_K(A) is surjective.                     (4.6)
```

To see this, decompose a representation of `A_L` into its weights in `M`.
The Galois-stable weight multiset is a union of the three `Gamma`-orbits

```text
{0},  {1,9,4,3,5},  {2,7,8,6,10}.
```

For either nonzero orbit, choose a lift in `I` of one weight and take its
five `Gamma`-conjugates.  Their direct sum is an `H`-representation whose
restriction gives that orbit.  The zero orbit lifts trivially.  This proves
(4.6), including arbitrary multiplicities.

Let `P=H -> H` denote the `A`-torsor (2.1).  Its extension of structure
group from `A` to `H` is the trivial `H`-torsor.  Explicitly,

```text
P times^A H  ->  H times H,
[x,h]        |-> (phi_alpha(x),xh)
```

is an isomorphism.  Therefore, if an `A`-representation `W` is extended to
an `H`-representation using (4.6), the associated vector bundle

```text
P times^A W
```

on the target `H` is trivial.  If `q:H -> BA` is the classifying map of
the versal torsor, then

```text
q^*([W]-rank(W))=0 in K_0(H)                        (4.7)
```

for every `A`-representation `W`.  All lambda-, gamma-, and Chern classes
constructed from representation classes consequently pull back to zero.
In particular,

```text
q^* c_5(W)=0,                                       (4.8)
```

even though `c_5(W)` is nonzero on `BA`.

In fact (4.5a), together with `dim(H)=4`, shows that

```text
q^*:CH^{>0}(BA) -> CH^*(H) is identically zero.      (4.9)
```

There is also an exact equivariant `K`-theory formulation.  Since the
`A`-action on the source `P=H` is free with quotient the target `H`, fpqc
descent gives

```text
K_0^A(P)=K_0(H).                                    (4.10)
```

Under this identification, the action of

```text
K_0^A(Spec(K))=R_K(A)
```

is by tensor product with the associated bundles.  Equations (4.6)--(4.7)
therefore say that this action factors through the rank map

```text
R_K(A) -> Z.                                        (4.11)
```

Equivalently, the augmentation ideal of `R_K(A)` annihilates `K_0^A(P)`.
The same statement holds for its action on every higher equivariant
`K_i^A(P)=K_i(H)`: tensoring with an `A`-representation gives a trivial
bundle of its rank.  In particular the trace bundle is also invisible:

```text
(phi_alpha)_* O_H = O_H^{oplus 11}                  (4.12)
```

as a vector bundle.  Its algebra structure is not trivial, but ordinary or
equivariant `K`-classes forget that structure.

Equations (4.4)--(4.5) do **not** prove a lower bound for essential
dimension: `B mu_11` itself has nonzero Chow classes in arbitrarily high
codimension while `ed(mu_11)=1`.  They prove the narrower and useful no-go
statement that no ordinary low-codimension Chern-class, representation
`K_0`, or associated gamma-filtration argument can supply the missing
codimension-four obstruction.  A successful integral `K`-theoretic argument
would have to use information beyond the representation action in
(4.10)--(4.12), for example the algebra structure or boundary data, and must
retain the cover `phi_alpha`.  No assertion about all higher or relative
`K`-theoretic operations is made here.

## 5. Why the known canonical-dimension theorems stop

### 5.1 Split-torus covering theorems give dimension one

After base change to `L`, (2.1) is an unramified cyclic cover of the split
torus `(G_m)^4`.  Its topological monodromy group is `C11`, which has rank
one.  Burda's exact theorem for unramified covers of complex algebraic tori
therefore says that this split cover is rationally induced from a cover of a
one-dimensional torus, and cannot be induced from dimension zero.  Thus it
recovers exactly

```text
ed_L(mu_11)=1,
```

not a four-dimensional lower bound.  The five-dimensional Galois weight
orbit is descent data; it is invisible to the monodromy rank of the split
cover.

This conclusion is also elementary from (1.5).  Over `L`, the two
unimodular changes of basis in the Smith reduction are automorphisms of the
split source and target tori.  They identify `phi_alpha` with

```text
(x_1,x_2,x_3,x_4) |-> (x_1,x_2,x_3,x_4^11),        (5.1a)
```

up to swapping the unimodular coordinates.  Thus the split cover is
literally pulled back from `G_m -> G_m`, `x |-> x^11`.

Kollar--Zhuang's theorem on essential dimension of isogenies does not
apply: its source is a proper complex abelian variety, whereas `H` is a
rational affine torus over `K`.  More decisively, their general upper bound
says that a cyclic finite abelian cover has essential dimension at most one.
The geometric kernel here is cyclic, and (5.1a) realizes that bound after
splitting.  Hence even a hypothetical extension of an isogeny theorem that
only retained the geometric kernel could give no more than one.  The datum
which would have to enter a new theorem is precisely the semilinear
order-five descent, not principality or the word "isogeny" alone.

The same defect affects every prime-local canonical-dimension theorem.
The extension `L/K` has degree five, prime to eleven, so an
eleven-primary argument is allowed to pass to `L` and sees only the
one-dimensional split compression.  At the other prime the smooth group
`A` has order prime to five.  This is exactly the already-known boundary

```text
ed_K(A;11)=1,             ed_K(A;5)=0.              (5.1)
```

Karpenko's incompressibility theorem for generic torsors of norm tori does
not change this conclusion.  It requires a nontrivial torus torsor with the
stated index divisibility.  Here extension of the generic `A`-torsor to
`H` is the globally trivial torsor in (4.7).

Modern characteristic-class and prismatic methods for finite covers also
produce `p`-essential lower bounds.  In the present case their input after
the permitted degree-five base change is the rank-one cyclic cover just
described.  They therefore cannot supply the missing ordinary mixed-prime
bound without a new relative theorem.

### 5.2 Absolute compression of the combined cover is not the target

In characteristic zero, combine an `A`-torsor over an extension of
`K=C(t)` with the fixed generic `C5`-torsor `s^5=t`.  Nonabelian twisting
identifies this pair with an `F55=C11:C5`-torsor whose `C5` quotient is the
fixed torsor.  If the original field is `K(H)`, its transcendence degree over
`C` is five.

As an **absolute** `F55`-torsor, however, it always has a field of definition
of transcendence degree at most four over `C`: the faithful five-dimensional
representation of the centerless group `F55` projectivizes to a faithful
linearizable action on `P4`.  Hence no absolute invariant of this combined
cover can prove that five parameters are necessary.

This does not give a three-dimensional compression over `K`.  An absolute
four-parameter field of definition need not contain `C(t)` and need not
preserve the specified `C5` quotient torsor.  The missing lower bound is
therefore genuinely **relative**:

> exclude a compression of `phi_alpha` to dimension three while preserving
> the fixed degree-five descent class.

This is the exact nonlinear gate left after the lattice, Chern-class,
representation-`K`-theory, split-cover, and prime-local methods are removed.

### 5.3 Exact function-field form of the nonlinear gate

Let

```text
F_L=L(H),
```

let `a` generate the geometric kernel `A_L=C11`, and let `delta` be the
semilinear descent automorphism.  With the character convention of this
note,

```text
delta^5=1,             delta*a*delta^-1=a^9.         (5.2)
```

A three-dimensional `A`-compression of `H` over `K` is equivalent to a
subfield

```text
E_L subset F_L
```

with all of the following properties:

1. `trdeg_L(E_L)=3`;
2. `E_L` is stable under both `a` and `delta`;
3. the action of `a` on `E_L` is faithful;
4. the `delta`-descent is effective (equivalently, `E_L` is the scalar
   extension of its fixed field over `K`).

One direction takes `E_L=L(Y)` from a compression `H -> Y`.  Conversely,
the normal model of the fixed field gives the compression.  This formulation
contains no degree or support bound.

Two low-complexity kinds of subfield can be excluded exactly.

First, suppose `E_L` is generated by torus characters from a lattice
`N subset I`.  Delta-stability makes `N` a `Gamma`-sublattice.  Since

```text
I tensor Q = Q(zeta_5)
```

is an irreducible four-dimensional rational `C5`-module, every nonzero
`Gamma`-sublattice of `I` has rank four.  Hence no faithful character-generated
subfield has transcendence degree at most three.

Second, there is no faithful projective-linear `A`-action on a `K`-form of
`P3`.  Over the splitting field, represent such an action by a multiset `S`
of four weights in `F_11`, taken modulo simultaneous translation.  Descent
would imply

```text
9S=S+b
```

for some `b in F_11`.  Thus the affine map `x |-> 9x-b` permutes `S`.  It has
order five, one fixed point, and two orbits of length five on `F_11`.  An
invariant multiset of cardinality at most four is therefore supported at the
fixed point.  All weights are equal, so the resulting projective action is
trivial, a contradiction.

This second argument excludes only a projective-space model; it does **not**
exclude a threefold invariant inside `P4` under the five-weight
representation.  The Klein cubic is exactly such a possibility.  The
remaining gate is therefore a genuinely non-monomial, non-projective-space
subfield, equivalently an arbitrary faithful `delta`-stable threefold
function field inside `F_L`.  The Klein cubic function field, with its
semilinear `C5` compatibility, is the concrete smooth-Fano candidate of this
type.

## 6. Strict verdict

```text
TWISTED-C11-GENERIC-TORSOR-IS-EXPLICIT-SELF-ISOGENY
SOURCE-AND-TARGET-SAME-K-RATIONAL-FOUR-TORUS
CHOW-CODIMENSIONS-1-THROUGH-4-EMPTY
FIRST-DESCENDED-CHERN-CLASS-IN-CODIMENSION-5
ALL-REPRESENTATION-K-CLASSES-TRIVIAL-ON-VERSAL-SELF-ISOGENY
SPLIT-TORUS-COVER-MONODROMY-RANK-ONE
PRIME-LOCAL-CANONICAL-DIMENSION-CANNOT-MIX-5-AND-11
ABSOLUTE-F55-COVER-BOUND-DOES-NOT-PRESERVE-FIXED-C5-QUOTIENT
MISSING-GATE-IS-FAITHFUL-DELTA-STABLE-NONLINEAR-TRDEG3-SUBFIELD
SELF-ISOGENY-INCOMPRESSIBILITY-OPEN
ed_K(A)=4-NOT-PROVED
KLEIN-NEGATIVE-HEADLINE-NOT-PROVED
```
