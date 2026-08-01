# Exact global-jet theorem for the three selected residual families

## Theorem

Let `G=PSL(2,11)`, let `W` be the five-dimensional Klein representation over
`K=Q(zeta_11)`, and let `E_+` be the plus eigenspace of one involution.  For
the three pairs

| degree `d` | odd plane order `m` | residual degree `e=d-6m` |
|---:|---:|---:|
| 25 | 3 | 7 |
| 31 | 5 | 1 |
| 35 | 5 | 5 |

there is no nonzero `G`-equivariant homogeneous self-covariant of degree `d`
vanishing to order at least `m` along every one of the 55 involution
plus-planes.

Equivalently, the characteristic-zero global coefficient module for each of
the selected normal-cone residual families is zero.

## Exact coefficient bases

For a seed `(j,alpha)`, the saved basis circuit denotes

```text
R_(j,alpha)(x) = (1/660) sum_(g in G) (g x)^alpha g^(-1)e_j.
```

This is an exact `K`-valued covariant.  The factor `1/660` may be omitted
without changing the span.  The three seed lists contain 189, 410, and 637
circuits.  Independent Molien computations give exactly those dimensions.
The same lists have full evaluation rank over the good holdout fibre
`(89,zeta_11-78)`.  Independence after good reduction implies independence
over `K`; equality with the Molien dimensions proves that the lists are
characteristic-zero bases, not merely modular spanning sets.

## Normal Taylor map

For degree `d` and plane order `m`, form the exact map

```text
J_(d,m): Hom_G(Sym^d W,W)
         -> direct_sum_(r=0)^(m-1)
            Hom(Sym^(d-r) E_+ tensor Sym^r E_-, W)
```

by taking the first `m` normal Taylor coefficients along `E_+`.  A covariant
lies in its kernel exactly when it has order at least `m` on `E_+`.
Equivariance then gives the same order on all 55 conjugate planes.

The producer discovers the following successive kernels over split `F_67`.
The independent verifier rebuilds the group at `p=89`, reconstructs every
Taylor coefficient directly from the multinomial formula, and obtains the
same ranks:

| `(d,m,e)` | full basis | after value | after first normal coefficient | after second normal coefficient |
|---|---:|---:|---:|---:|
| `(25,3,7)` | 189 | 59 | 3 | 0 |
| `(31,5,1)` | 410 | 198 | 43 | 0 |
| `(35,5,5)` | 637 | 361 | 128 | 0 |

Thus the stacked value/first/second-normal map has ranks 189, 410, and 637
modulo 89.  Each full-rank reduction contains a nonzero maximal minor of the
exact integral matrix over `Z[zeta_11,1/660]`.  The characteristic-zero map
is therefore injective.  Notice that only the first three coefficients are
needed even when the selected order is five.

## Consequences for COV0--COV2

The global coefficient module is already zero before triple-line,
point-link, `C3`, marked-elliptic, or landing equations are imposed.
Consequently all of those further constrained modules are zero.  Quotients
by scalar invariant multiples and known compositions are also zero, so the
primitive quotient has dimension zero.  There is no modular candidate to
reconstruct and no nonlinear landing system left in these three selected
families.

This complete global calculation also subsumes Reynolds lifts, orbit sums,
Koszul/syzygy expressions, and deformations of the named formal leading
states **when they have one of the selected leading plane orders**: any such
global ansatz would be an element of the zero module.

## Strict scope

The theorem does not exclude plane order `m=1`.  In particular, it does not
decide the installed 43-dimensional strict degree-25 landing scheme, and it
does not determine the full `m=1` landing schemes in degrees 31 or 35.  It
therefore does not exclude any of those degrees as a whole, does not prove an
all-degree theorem, and does not change the Klein-cubic headline from OPEN.

The exact exit is:

```text
COV-STRUCTURED-DEGREES-EMPTY-SCOPED
```
