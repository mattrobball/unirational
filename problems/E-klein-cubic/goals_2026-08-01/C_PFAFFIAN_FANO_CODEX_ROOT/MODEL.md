# Exact compressed model and involution

## Scope

This packet installs an exact lazy characteristic-zero interface for the
specific aligned algebra and its symplectic involution.  It does not install a
Morita corner or solve the genuine Fano incidence.

The coefficient field is represented by the installed invariant-rational
functions in the five source coordinates, with cyclotomic coefficients in
`Q(zeta_11)`.  The serialization retains the coefficient arrays rather than
expanding the resulting Cramer quotients in a Hironaka invariant basis.

## C0 interface

Let `a=(f11/f14) C_a` and `b=(f11/f14) C_b`, where `C_a,C_b` are the exact
degree-three Reynolds covariants rebuilt from the aligned generators
`A -> TSTS` and `B -> T^8 S`.  Define

```text
R = ( vec(b^j a^i) )_(0 <= j,i < 6).
```

On the open `det(R) != 0`, `R` is the exact change of basis from the
rectangular maximal-etale basis to the split matrix realization.  The
compressed left action of `a` is the exact rational circuit

```text
L_a[:,j] = R^-1 vec(a b^j).
```

Together with the exact minimal polynomials of `a,b`, this is a complete lazy
multiplication interface.  The nonzero specializations of `det(R)` at good
primes prove that this open is nonempty in characteristic zero.  They do not
materialize the Cramer quotients in the named invariant generators.

Independent replay:

```sh
/opt/homebrew/bin/python3 -u verify_compressed_algebra.py
```

Expected final marker:

```text
C3-APROJ-LAZY-EXECUTABLE-VERIFIED
```

## C1 involution

The exact normalized intertwiner `J` gives the alternating universal form

```text
Q(x) = J x,
sigma_x(M) = Q(x)^-1 M^t Q(x).
```

The compressed-coordinate operator is defined without a hidden interpolation:
apply `sigma` to each matrix column of `R`, vectorize, and solve against `R`.
The exact identities are checked directly at a rational point and the
coordinate transport is independently replayed at unused good fibres.

Independent replay:

```sh
/opt/homebrew/bin/python3 -u verify_involution.py
```

Expected final marker:

```text
C1-LAZY-INVOLUTION-EXACT-VERIFIED
```

## Distinguished five-plane before Morita coordinates

The exact equivariant covariants

```text
V_0=x, V_1=C, V_2=D, V_3=E, V_4=K
```

have degrees `1,4,5,6,7` and form a Hilbert--90 frame on a nonempty generic
open.  Applying the aligned Pfaffian map and the structure form gives

```text
B_j(x) = Q(V_j(x)),
S_j(x) = Q(x)^-1 B_j(x).
```

Each `B_j` is alternating, hence every `S_j` is fixed by `sigma`; equivariance
of the frame makes the `S_j` descended algebra elements.  Their exact rank is
five, so this is the specific distinguished section rather than an arbitrary
five-plane.  The corresponding quaternionic Hermitian matrices are obtained
only after an explicit Morita basis is chosen, which remains open.

Independent replay:

```sh
/opt/homebrew/bin/python3 -u ../../certificates/exact_covariants_check.py
/opt/homebrew/bin/python3 -u verify_distinguished_five_plane.py
```

Expected final marker:

```text
C2-DISTINGUISHED-FIVE-PLANE-LAZY-VERIFIED
```

## Live gate

The smallest live construction is an explicit self-adjoint reduced-rank-two
idempotent in this exact frame.  It would yield a quaternion corner and a
Morita basis in which the five installed `S_j` become explicit Hermitian
matrices.  Even that projector is not a Fano point: completion still requires
a right quaternionic line simultaneously isotropic for all five distinguished
forms and substitution in the original Pluecker equations.
