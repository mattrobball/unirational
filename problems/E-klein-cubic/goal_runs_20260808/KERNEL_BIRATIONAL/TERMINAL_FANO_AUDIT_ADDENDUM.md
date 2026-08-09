# Terminal-Fano audit addendum: two exact eliminations

**Date:** 2026-08-08  
**Status:** theorem-level correction and local basket exclusion  
**Scope:** the point-base threefold boundary in `THEOREM.md`

Keep the notation

```text
K = C(t),  L = C(s),  s^5=t,
gamma(s)=zeta_5 s,
gamma acts on X^*(A_L)=F_11 by multiplication by 9.
```

This addendum proves the following statements that were not used in
`RANK_ONE_TERMINAL_ADDENDUM.md`:

1. under the geometric `C11`-`G`-Fano hypothesis, the Gorenstein branch
   with geometric Picard rank greater than one is empty;
2. in the non-Gorenstein rank-one basket list, every basket containing an
   index `11` or `22` point is empty;
3. the factorial genus-six and genus-seven branches are empty;
4. the singular factorial genus-eight branch is empty.

These statements do not exclude the smooth Klein/Pfaffian-Klein branch or
the seven remaining non-Gorenstein baskets.  In particular, this is not a proof that
`ed_K(A)=4`.

The finite arithmetic checks in this note replay with

```text
/opt/homebrew/bin/python3 \
  goal_runs_20260808/KERNEL_BIRATIONAL/verify_terminal_fano_audit.py
```

## 1. The geometric Gorenstein `rho>1` branch is empty

Let `Z` be a terminal Gorenstein threefold over an algebraically closed
field of characteristic zero, with a faithful `C11` action, and suppose

```text
rank Cl(Z)^C11 = 1.                                      (GF)
```

Assume `rho(Z)>1`.  Prokhorov, *G-Fano threefolds, II*, Theorems 1.2 and
6.5, and the smoothing used there, put `rho(Z)` in the set

```text
{2,3,4}.
```

The action on `Pic(Z)` is an integral representation of `C11`.  A
nontrivial rational representation of `C11` has dimension at least

```text
deg Phi_11 = 10.
```

Consequently `C11` acts trivially on `Pic(Z)`.  The natural injection

```text
Pic(Z)_Q -> Cl(Z)_Q
```

then gives

```text
rank Cl(Z)^C11 >= rank Pic(Z)^C11 = rho(Z) > 1,
```

contrary to (GF).  Thus:

```text
GORENSTEIN-GEOMETRIC-C11-GFANO-RHO-GT1-EMPTY.             (1)
```

This corrects the survivor language in `TERMINAL_FANO_BOUNDARY.md`: the
eight deformation types are the finite classification supplied by the
cited theorem for a general acting group, but none can occur for the group
`C11` under (GF).  The argument does **not** remove an arithmetic MMP output
for which only the invariants under the combined geometric action and
absolute Galois action have rank one.  That weaker arithmetic boundary must
still be kept separate.

## 2. A local index divisible by eleven is impossible

### 2.1 Local lifting lemma

Let `F/K` be a finite extension disjoint from `L/K`, and let `P` be an
`A_F`-fixed `F`-rational terminal point of local index `r`, where

```text
11 | r.
```

Kawamata's basket inequality gives `r<24` in the application below, so it
is enough to consider `r=11` and `r=22`.

Take the canonical index-one cover of the germ at `P`.  It is functorial
for automorphisms.  The lifts of the `A_F` action form a central extension
by the deck group `mu_r`.  Its `11`-primary part is a central extension

```text
1 -> D=mu_11 -> Q -> A_F -> 1,                            (2)
```

of group schemes of order `11^2`.  The deck subgroup `D` is defined over
`F` and the Galois action on `X^*(D)` is trivial, since `C` contains all
eleventh roots of unity.  On `X^*(A_F)` the generator of
`Gal(LF/F)=C5` acts by `9`.

After base change to `LF`, the geometric group in (2) cannot be cyclic of
order `121`.  Indeed, every automorphism of `C121` is multiplication by a
unit, and it induces the same scalar modulo `11` on its unique subgroup and
on its quotient of order `11`.  It therefore cannot act as `1` on `D` and
as `9` on `A_F`.  Hence

```text
Q_LF = C11 x C11.                                        (3)
```

On the two-dimensional character space `X^*(Q_LF)`, Galois acts
semisimply with eigenvalues `1` and `9`.  Its fixed space has dimension
one, and every character outside that line has an orbit of length five.

The index-one cover is a terminal Gorenstein threefold germ, hence a cDV
hypersurface germ of embedding dimension at most four.  Its tangent
representation is a direct sum of at most four characters of `Q_LF`.
Because the germ and the lifted action descend to `F`, this multiset of
characters is Galois-stable.  It cannot contain a five-element orbit, so all
its characters lie in the one-dimensional fixed space.  They therefore do
not span `X^*(Q_LF)`.

On the other hand, the lifted action on the index-one-cover germ is
faithful.  In characteristic zero a finite-order automorphism of a germ
which is trivial on the Zariski tangent space is trivial (equivalently,
finite actions are formally linearizable).  Thus a faithful diagonalizable
group action has tangent weights spanning its character group.  This
contradicts (3).

We have proved:

> **Local lemma.**  A nonsplit `A_F` cannot fix an `F`-rational terminal
> point of local index `11` or `22`, whenever `LF/F` still has degree five.

This is precisely the case not covered by the prime-to-index complement
argument in Section 1.2 of `RANK_ONE_TERMINAL_ADDENDUM.md`.

### 2.2 Application to the finite basket list

The old necessary list was

```text
{2^5}, {2^10}, {2^15},
{3^5}, {2^5,3^5}, {4^5},
{2^11},
{11}, {11,2^5}, {11^2}, {22}.                            (4)
```

In each basket in the last line, every index-`11` or index-`22` point is
fixed by geometric `C11`: there are fewer than eleven such points.  A
single such geometric point is rational over the ground field.  In the
`{11^2}` case, either both points are rational or they become rational over
a quadratic extension.  That extension is disjoint from the degree-five
field `L`, so the local lemma still applies.  Thus all four baskets in the
last line of (4) are impossible.

The exact remaining non-Gorenstein necessary list is

```text
{2^5}, {2^10}, {2^15},
{3^5}, {2^5,3^5}, {4^5},
{2^11}.                                                   (5)
```

The first six entries consist of fixed points whose residue fields contain
`L`; after passing to such a residue field the twisted group becomes split,
so the local lemma gives no contradiction.  The last entry is one free
`C11`-orbit and has no `A`-fixed singular point.  These seven entries remain
necessary possibilities, not constructed examples.

## 3. The factorial genus-six and genus-seven branches are empty

The 2026 theorem of Bayer--Kuznetsov--Macri used below makes the Mukai
models canonical and unique for factorial terminal prime Fano threefolds,
not only for smooth ones.  Consequently their Gushel/Mukai maps are
equivariant for automorphisms, and the defining linear spaces are preserved
by the descended projective `A`-action.

### 3.1 Genus six

The canonical genus-six model uses a five-dimensional vector space `V5`
and the Pluecker representation `exterior^2 V5`.  Faithfulness and Galois
descent force the five projective weights of `V5` to be one orbit, which we
may write as `R`.  As in Section 4 below, the ten pair sums give

```text
exterior^2 V5 = U_+ + U_-.                               (6)
```

Thus a descended invariant vector subspace of `exterior^2 V5` can have
dimension only `0`, `5`, or `10`.

In the ordinary Gushel case, the anticanonical `P7` is induced by an
eight-dimensional invariant vector subspace of `exterior^2 V5`, impossible
by (6).  In the special Gushel case, the canonical map from the
eight-dimensional anticanonical vector space to `exterior^2 V5` has a
one-dimensional kernel and hence a seven-dimensional invariant image,
again impossible by (6).  Therefore

```text
TERMINAL-FACTORIAL-GENUS6-TWISTED-C11-ACTION-EMPTY.       (7)
```

This removes both singular and smooth genus-six cases at once; it also
recovers, without using the automorphism group of the unique smooth
order-eleven example, the smooth exclusion in `SMOOTH_FANO_ADDENDUM.md`.

### 3.2 Genus seven

The canonical genus-seven model is

```text
X_bar = OGr+(5,V10) intersect P(W),
dim(V10)=10,  dim(W)=9,                                   (8)
```

in a half-spin projective space of dimension fifteen.  The quadratic form
on `V10` pairs opposite weights.  After translating their common
projective center, faithfulness and descent force

```text
weights(V10) = R union -R.                                (9)
```

Choose the five positive torus weights to be the elements of `R`.  The
sixteen half-spin weights are

```text
(1/2)(+/- r_0 +/- r_1 +/- r_2 +/- r_3 +/- r_4),
```

with one parity of signs.  A direct five-line weight calculation gives

```text
Delta+ = 1 + 2 U_+ + U_-                                 (10)
```

(and the other chirality exchanges `+` and `-`).  Therefore its descended
submodules have dimensions

```text
0,1,5,6,10,11,15,16,
```

and never dimension nine.  The invariant `P(W)=P8` required in (8) cannot
exist.  Hence

```text
TERMINAL-FACTORIAL-GENUS7-TWISTED-C11-ACTION-EMPTY.       (11)
```

No classification of equations and no deformation or smoothing argument
enters either exclusion.

## 4. The singular genus-eight branch is empty

Assume now that `X` is a geometric-rank-one, terminal Gorenstein,
`Q`-factorial Fano threefold of genus eight carrying the descended faithful
`A`-action.  For a terminal Gorenstein threefold, `Q`-factoriality is
factoriality: the local cDV hypersurface class groups are torsion-free.

Bayer--Kuznetsov--Macri, *Mukai models of Fano varieties*, Theorem 1.1 and
Corollary 6.10, apply also to factorial terminal singularities and give the
canonical, unique Mukai realization

```text
X_bar = Gr(2,V) intersect P(W) subset P(exterior^2 V),
dim(V)=6,  dim(W)=10.                                    (12)
```

Uniqueness makes (12) equivariant for every automorphism of `X_bar`.  Thus
the `A`-action induces a faithful projective action on `V` and preserves
`W`.

### 3.1 The only possible weight modules

After splitting `A`, the six projective weights are stable under an affine
map `j -> 9j+c`.  Faithfulness and cardinality six force, after a common
translation,

```text
weights(V) = {0} union R,
R={1,3,4,5,9}.                                           (13)
```

Write `U_+` and `U_-` for the five-dimensional descended modules with
weights `R` and `-R`.  The ten unordered pair sums in `R` consist of one
copy of `R` and one copy of `-R`.  Hence

```text
exterior^2 V = 2 U_+ + U_-.                              (14)
```

By semisimplicity, the annihilator

```text
B := W^perp subset exterior^2 V^*,   dim(B)=5,
```

is one irreducible five-cycle module; its projective weights are `R` or
`-R`.  This remains true when the two isomorphic summands in (14) are glued
by a nonconstant descent parameter: the annihilator is still a single
five-dimensional simple module.

### 3.2 The Pfaffian dichotomy

Let `pf` be the cubic Pfaffian on `exterior^2 V^*`.  Since the sum of the
weights in (13) is zero, its restriction to `B` is an invariant cubic.  On
one five-cycle of weights, the only invariant cubic monomial lines are

```text
x_i^2 x_(i+1),       i mod 5,                             (15)
```

where multiplication by `9=-2` advances the index.  Galois descent acts
transitively on the five lines in (15).  Therefore either

```text
pf|B = 0,
```

or all five coefficients are nonzero.  In the second case a diagonal
change of variables makes the equation

```text
sum_i x_i^2 x_(i+1)=0;
```

the exponent matrix has determinant `33`.  This is the smooth Klein cubic.

The standard conormal description of the projective duality

```text
Gr(2,6)^dual = {pf=0}
```

shows that smoothness of `P(B) intersect {pf=0}` implies smoothness of the
linear section (12).  Explicitly, a singular point `[U]` of `X_bar` would
give a form `omega in B` with `U subset ker(omega)`.  If `rank(omega)=4`,
then `P(B)` is tangent to the Pfaffian cubic at `[omega]`; if its rank is at
most two, `[omega]` is already in the singular locus of that cubic.  Either
case makes the restricted cubic singular.  Thus the nonzero alternative
forces `X_bar` to be smooth.

It remains to exclude `pf|B=0`.  If a general form in `B` has rank four,
then for every such form `omega`, the identity `pf|B=0` puts
`[ker(omega)]` in `Sing(X_bar)`.  Terminality makes this singular locus
finite, so the kernel map from the irreducible `P(B)` is constant.  Its
common two-plane is intrinsic, hence descends and is `A`-stable.  But (13)
has no Galois-stable two-dimensional weight subspace: its only proper
descended summands have dimensions one and five.  This is a contradiction.

If every form in `B` has rank at most two, then `P(B)` is a linear `P4`
inside the Pluecker Grassmannian `Gr(2,V^*)`.  Such a maximal linear space
consists of the forms `ell wedge v` for one fixed `ell`.  Its annihilator
contains `exterior^2 ker(ell)`, already of dimension ten, so equality holds
and (12) contains `Gr(2,ker(ell))`, of dimension six.  This contradicts the
dimensionally transverse threefold realization.

Both zero cases are impossible.  Consequently:

```text
TERMINAL-FACTORIAL-GENUS8-TWISTED-C11-ACTION-IMPLIES-SMOOTH. (16)
```

Combining this with `SMOOTH_FANO_ADDENDUM.md`, the only genus-eight entry
is a smooth Fano whose associated Pfaffian cubic is the Klein cubic.

Primary source for the singular Mukai realization:
<https://arxiv.org/abs/2501.16157>.

## 5. Revised terminal boundary

Under the actual geometric condition (GF), the terminal list is now

```text
Gorenstein, geometric rho>1       empty;
Gorenstein, geometric rho=1       smooth Klein / Pfaffian-Klein only;
non-Gorenstein                    the seven baskets in (5).
```

Outside (GF), an arithmetic point-base output for which the combined
Galois/action invariant class group has rank one is not reduced to this
list by the cited geometric classification.  Moreover, even inside (GF),
the smooth Klein entry is the original candidate rather than an extraneous
classification case.  Therefore the strict conclusion remains

```text
ed_K(A)=4                                      OPEN;
Klein F55-unirationality NO                    OPEN;
Klein PSL2(F11)-unirationality NO              OPEN.
```
