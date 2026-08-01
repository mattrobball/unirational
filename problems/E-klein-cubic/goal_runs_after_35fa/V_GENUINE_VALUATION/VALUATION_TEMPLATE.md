# Proper-specialization valuation template

## Theorem 1: selected degree-one point-field place

Let `R` be a henselian discrete valuation ring with fraction field `F_h` and
residue field `k`.  Let `E/F` be finite separable, and suppose a selected
place above the valuation of `F` is defectless and has

```text
e=1, f=1.
```

Equivalently, its henselian local degree is `ef=1`, so
`E tensor_F F_h` has a factor isomorphic to `F_h`; fix the corresponding
embedding `i:E -> F_h`.  (The characteristic-zero application below is
defectless.)  Let `Y/E` be proper, and assume that
after applying `i` it is the generic fibre of a proper `R`-scheme
`mathcal Y`.  If the special fibre `Y_0/k` has no `k`-point, then

```text
Y(E)=empty.
```

Indeed, an `E`-point gives an `F_h`-point through `i`.  The valuative
criterion for properness extends it uniquely to an `R`-section, whose closed
point is a `k`-point of `Y_0`.  If `Y_0` is smooth proper of index `m>1`, its
degree-one points are absent, so the same conclusion follows.

No regularity, smoothness, or integrality of the total space is needed for
this one-way specialization.  Those properties can be needed to establish
the claimed special fibre or its index.  Properness is indispensable: a
point of an open generic fibre may specialize into the omitted boundary.

## Theorem 2: converse by smooth Hensel lifting

If `mathcal Y -> Spec R` is smooth as well as proper, reduction induces

```text
mathcal Y(R) -> Y_0(k)
```

surjectively.  Therefore

```text
Y(F_h) is nonempty  <=>  Y_0(k) is nonempty.
```

The reverse implication uses henselianity and smoothness; properness supplies
the forward implication.  A singular visible point in the special fibre is
not enough for the reverse implication.

## Theorem 3: genuine finite-group twist dichotomy

Let `G` act on a smooth proper variety `X/C`, let `T/K` be a `G`-torsor, and
let `nu` be a discrete valuation of `K`, trivial on `C`, with henselization
`K_h`.  Choose a prolongation to a finite Galois splitting field and write
`D_dec` and `I` for decomposition and inertia.

In residue characteristic zero, inertia is tame.  Because `C` contains all
roots of unity, `I` is central in `D_dec`.  Hence for every nonidentity
`g in I`,

```text
D_dec subset C_G(g).
```

For the Klein action of `PSL_2(F_11)`, the exact centralizer census proves
that every such centralizer preserves either a projective point on the Klein
cubic or a projective line contained in it.  Twisting that stable linear
subspace gives a `K_h`-point.  Thus

```text
I != 1  =>  X_T(K_h) is nonempty.
```

If `I=1`, the torsor extends finite etale over the henselian valuation ring.
Twisting the constant smooth proper model gives a smooth proper model whose
special fibre is the residue twist, and Theorem 2 gives

```text
X_T(K_h) is nonempty
  <=> the residue twist has a k(nu)-point.
```

This dichotomy is the mandatory compatibility test for transporting an
auxiliary index-three special fibre to the genuine twist.  At a ramified
place the genuine local point already prevents a negative specialization;
at an unramified place the special fibre must be the genuine residue twist,
not an unrelated section.

## Application to the `D`-place

Goal F supplies Theorem 1 for the selected fixed plane cubic: the selected
place of `K_proj/F` has `(e,f)=(1,1)`, its proper residual plane cubic is
smooth of index three, and therefore the fixed plane cubic has no
`K_proj`-point.

The scaled affine frame is a different extension.  The exact identities

```text
nu(t)=2,  t=f5^3
```

show that the degree-three residual-scalar cover `K_aff=K(f5)` is totally
ramified.  This is a `mu3` scaling cover, not the projective
`PSL_2(F_11)`-torsor.  The two extensions are linearly disjoint: otherwise
their intersection would give a degree-three subfield of the genuine
`G`-extension, equivalently an index-three subgroup of the simple group `G`.

Theorem 3 must therefore be applied to the still-undetermined genuine
inertia, not to the scalar `mu3`.  If genuine inertia is nontrivial, the
local twist has a point.  If it is trivial, the special fibre is the genuine
residue twist and has index one, but its point status is open.  In neither
case is the special fibre the selected fixed plane cubic.  There is no
contradiction and no transfer.
