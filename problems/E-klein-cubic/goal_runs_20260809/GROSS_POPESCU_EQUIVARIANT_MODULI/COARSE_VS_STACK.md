# Coarse space versus stack

## Why 1320 becomes 660

The set of symplectic markings of a fixed polarization kernel is a torsor
under `SL2(F11)`, whose order is

```text
11(11^2-1)=1320.
```

For a general polarized abelian surface the origin-preserving polarized
automorphism group is `{+1,-1}`.  The automorphism `[-1]_A` identifies the
marking `alpha` with `-alpha`.  Therefore the generic coarse fiber of the
forgetful map has

```text
1320 / 2 = 660
```

points.  This resolves the apparent discrepancy between the order-1320
normalizer quotient used in theta coordinates and Gross--Popescu's degree-660
coarse forgetful cover.

## Faithfulness and generic freeness

Let `G=PSL2(F11)`.  If a class `gbar in G` fixes a general coarse point, choose
a lift `g in SL2(F11)`.  There is then a polarized automorphism `u` of the
underlying abelian surface carrying `alpha` to `alpha o g^{-1}`.  Generically
`u=+1` or `-1`, so `g=+I` or `-I`, and `gbar=1`.  Hence:

- the effective coarse action is generically free;
- it is faithful;
- the generic forgetful cover is a `G`-torsor.

Special loci with extra automorphisms account for ramification and do not
alter the generic statement.

## Quotient field

Writing `A_11^lev` and `A_11` for the coarse varieties,

```text
C(A_11^lev)^G = C(A_11).
```

Equivalently, the rational quotient of the level-moduli variety by the
effective level-change group is the moduli variety without level structure.
This is a statement about function fields; the global coarse morphism may be
ramified along extra-automorphism loci.
