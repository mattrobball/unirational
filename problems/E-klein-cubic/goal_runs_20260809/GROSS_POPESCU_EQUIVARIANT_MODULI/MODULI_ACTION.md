# The natural action on the level-moduli stack

Work over `C` (equivalently over a characteristic-zero base on which 11 is
invertible).

## The intrinsic stack

Let `H=(F_11)^2` with its standard alternating form.  An object of the marking
presentation of the stack `M_11^lev` over a scheme `S` is

```text
(A/S, lambda, alpha),
```

where `A/S` is an abelian scheme of relative dimension two, `lambda` is a
polarization of type `(1,11)`, and

```text
alpha : H_S -> K(lambda)
```

is a symplectic isomorphism.  An isomorphism is an origin-preserving
isomorphism of abelian schemes preserving the polarization and commuting with
`alpha`.

Gross--Popescu formulate the same datum using a theta-group isomorphism
`G(L) ~= He(11)` that is the identity on the central `G_m`.  The induced map
on the quotient is `alpha`.  A symmetric line bundle inducing `lambda`, a
characteristic, and a splitting into two isotropic cyclic subgroups are
choices used to write canonical theta coordinates; they are not additional
independent coarse-moduli data.  Different lifts of the same marking differ
by the Heisenberg action and do not change the multiplicity plane used by
`Theta_11`.

## Change of marking

For `g in Sp(H)=SL2(F11)` define the right marking action by

```text
g . (A,lambda,alpha) = (A,lambda,alpha o g^{-1}).
```

This is a genuine strict action on the marking presentation.  The normalizer
sequence in Gross--Popescu supplies compatible lifts to the theta group and
the Schrödinger representation.  A left-action convention replaces every
formula below by the equivalent inverse convention.

## Central element

For `g=-I`, the automorphism `[-1]_A` preserves `lambda` and restricts to
`-I` on `K(lambda)`.  It therefore gives, functorially in every object, an
isomorphism

```text
(A,lambda,alpha) ~= (A,lambda,alpha o (-I)).
```

Thus the central element acts 2-isomorphically to the identity.  Conversely,
on the dense locus where `Aut(A,lambda)={+1,-1}`, a marking change acting
trivially must be induced by one of those two automorphisms, hence must equal
`+I` or `-I` on `H`.

## Theorem

```text
natural group on the marking presentation = SL2(F11),
ineffective stack kernel                 = {+I,-I},
effective rigidified/coarse group        = PSL2(F11).
```

This statement separates the linear Weil group from the effective projective
moduli symmetry.  The six-dimensional module remains an honest representation
only of `SL2(F11)`, while its action on the Grassmannian and on the `V14`
linear section factors through `PSL2(F11)`.
