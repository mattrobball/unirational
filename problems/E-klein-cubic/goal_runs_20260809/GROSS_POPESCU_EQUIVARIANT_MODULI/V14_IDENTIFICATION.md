# Exact identification with the repository `V14`

## The two even bases

Gross--Popescu use the projected even basis

```text
e_0=x_0,       e_i=(x_i+x_{-i})/2  (1<=i<=5).
```

The repository's exact even-Weil model uses the cosine basis

```text
b_0=e_0,       b_i=x_i+x_{-i}=2e_i  (1<=i<=5).
```

Thus `b=eD` with `D=diag(1,2,2,2,2,2)`.  If `p^e_ij` and `p^b_ij` are the
corresponding Pluecker coordinates, then

```text
p^e_ij = d_i d_j p^b_ij.
```

Gross--Popescu's five equations therefore become, in the repository basis,

```text
2 p23 + p15 = 0,
2 p26 - p13 = 0,
p14 + 2 p35 = 0,
p16 - 2 p45 = 0,
2 p46 + p12 = 0.
```

Indices here are Gross--Popescu's one-based indices.

## Weil generators

Set the repository root `zeta=xi^6`, since `6=1/2 mod 11`.  The diagonal
Weil generator then agrees with Gross--Popescu's formula.  Conjugating the
Fourier restriction by `D` gives the repository cosine matrix, up to the
single projective normalization fixed by

```text
Gauss^2=-11,  c=1/Gauss,  S^2=-I.
```

The exact script `scripts/verify_v14_identification.py` works in
`Q(zeta_11)` and verifies both generators.  It also verifies adversarially
that simply copying Gross--Popescu's unscaled equations into the cosine basis
fails the Fourier test.

## The `10'` summand

Gross--Popescu prove that `Lambda^2(V_+)` is the direct sum of irreducible
modules of dimensions five and ten and that the five hyperplanes above cut
the ten-dimensional summand.  The repository's characteristic-zero seal
proves

```text
Lambda^2(U) = 5 + 10'
```

multiplicity-freely and defines its `V14` as

```text
Gr(2,U) intersect P(M_10),
```

where `M_10` is that unique ten-dimensional summand.  Since the exact
basis-corrected Gross--Popescu kernel is invariant and ten-dimensional, it is
necessarily the same `M_10`.

This is an explicit representation-theoretic conjugacy: same projective
six-dimensional Weil action, same central extension, same decomposition,
same five hyperplanes, and same Grassmannian section.  It is stronger than an
abstract isomorphism of genus-eight Fano threefolds.

## Theorem

Combining this identification with functorial equivariance and Gross--Popescu
Theorems 2.2 and 2.6 gives

```text
A_11^lev  ~_G  V14
```

for the natural effective level action.  This is the exit
**GP-MODULI-EQUIVARIANTLY-BIRATIONAL-V14**.
