# Goal C compressed algebra model

## Exact installed portion

Let `C_a(x)` and `C_b(x)` be the characteristic-zero Reynolds matrices for
the seeds

```text
C_a: x5^3 E_00
C_b: x5^3 E_01
```

in the aligned six-dimensional Schur representation.  The projective
generators are

```text
a = (f11/f14) C_a,
b = (f11/f14) C_b.
```

The packet `c0_minpoly_exact.json` reconstructs both monic degree-six
characteristic/minimal polynomials exactly.  If

```text
m_b(T) = T^6 + d1 T^5 + d2 T^4 + d3 T^3 + d4 T^2 + d5 T + d6,
```

then Cayley--Hamilton gives the six required coefficients in

```text
b^6 = e0 + b e1 + b^2 e2 + b^3 e3 + b^4 e4 + b^5 e5
```

as

```text
(e0,e1,e2,e3,e4,e5)=(-d6,-d5,-d4,-d3,-d2,-d1).
```

Every `e_j` is a scalar in `E=K_proj[a]`.  Thus 30 of the 36 coordinates in
the `1,a,...,a^5` basis vanish structurally; `d1=0` gives the observed 31st
zero.  This replaces the old modular observation by an exact
characteristic-zero identity.

Each coefficient `c_k` or `d_k` is stored as

```text
t11^k * raw_k / beta_f14^k,
```

where `raw_k` is a twelve-vector in the certified Hironaka basis of
`K_proj/P0`.  The producer reconstructs the invariant polynomial before
homogenization in the exact spaces of dimensions

```text
1, 2, 3, 6, 10, 17
```

in degrees `3,6,9,12,15,18`.  The independent verifier checks injectivity of
all six evaluation maps, recomputes both Reynolds characteristic polynomials
at an unused exact `Q(zeta_11)` point, and checks fresh split primes 331 and
463.

Replay:

```sh
/opt/homebrew/bin/python3 -u C_PFAFFIAN_FANO/produce_c0_minpoly.py
/opt/homebrew/bin/python3 -u C_PFAFFIAN_FANO/verify_c0_minpolys.py
```

Required verifier marker:

```text
C0-AB-MINPOLYS-EXACT-VERIFIED
```

## Exact determinant interface for the remaining block

On the generic open, form the 36 columns

```text
R_(j,i) = vec(b^j a^i),       0 <= i,j < 6,
Delta   = det R.
```

The modular witnesses in the sealed C3 packet prove `Delta` is not the zero
rational function.  The remaining `E`-matrix of left multiplication by `a`
has the exact Cramer description

```text
L_a[:,j,:] = reshape(R^(-1) vec(a b^j)),
```

with the last index the `1,a,...,a^5` coordinate.  This is an exact rational
oracle inside `M_6(Q(zeta_11)(x1,...,x5))`, and ordinary matrix
multiplication proves associativity and the unit identities.  Reynolds
covariance makes every coordinate `G`-invariant, hence an element of
`K_proj`.  It is not yet a materialized twelve-basis formula over the named
parameters, so C0 is not declared complete.

## Measured reconstruction floor

`produce_la_samples.py` deterministically extends the C3 modular sample set
to 5,000 good points at `p=353`.  For the representative varying coordinate
`L_a[0,1,0]`, the homogeneous rational ansatz

```text
x q(t) = sum_s p_s(t) beta_s,
deg p_s <= D, deg q <= D
```

has zero nullity for every `D <= 7`.  In particular, the apparent degree-four
fits from the historical 918-point sample were underdetermination: at 1,600
points the degree-four augmented matrix has full rank 910.  The current exact
finite-field floor is therefore

```text
rational total degree at least 8 at p=353
```

for that coordinate.  This is a modular resource floor, not a
characteristic-zero nonexistence theorem and not a reason to revert to the
forbidden `36^3` reconstruction.

Replay the final floor:

```sh
/opt/homebrew/bin/python3 -u C_PFAFFIAN_FANO/produce_la_samples.py
/opt/homebrew/bin/python3 C_PFAFFIAN_FANO/probe_la_rational_degree.py \
  --degree 7 --k 0 --j 1 --i 0
```

## Current boundary

Exact now:

- both degree-six generator polynomials;
- all six coefficients of `b^6` in `E`;
- the generic rectangular open and exact determinant/Cramer interface;
- direct exact and independent modular verification.

Still open:

- materialized `L_a` entries in the named `K_proj` basis, or a comparably
  efficient complete interface usable by C1--C3;
- transport of the involution into that interface;
- the Morita quaternion and the distinguished Hermitian five-plane;
- a simultaneous common line.

