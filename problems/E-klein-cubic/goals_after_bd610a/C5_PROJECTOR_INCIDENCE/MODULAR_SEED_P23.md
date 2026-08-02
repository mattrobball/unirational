# Corrected C5 modular seeds at p=23

This packet records one smooth point of the corrected self-adjoint
square-zero incidence at the certified split fibre

```text
p = 23,  x = (22,21,8,1,1).
```

It is a discovery and convention certificate.  It is not a
`K_proj`-rational point.

## Exact point

The deterministic seed-`20260801` search first drops rank at trial 49.  It
returns the spanning vectors

```text
u = (16,3,22,17,7,8)
v = (6,9,17,15,1,0).
```

In lexicographic `wedge^2(F_23^6)` coordinates their decomposable bivector is

```text
p15 = (11,2,0,20,21,14,7,9,20,18,18,2,4,18,15).
```

The independently reconstructed ten-plane basis gives

```text
z10 = (14,7,9,20,18,18,2,4,18,15),
target_basis * z10 = p15.
```

For the certified symmetric frame indices

```text
(0,1,2,3,4,5,6,7,8,9,10,11,12,13,15),
```

the map `P -> n=-P*Q(x)` gives

```text
a15 = (20,2,13,18,6,3,0,21,8,2,2,10,3,11,22).
```

The verifier reconstructs these lists rather than trusting them as unrelated
solver output.  It checks

```text
rank(P)=rank(n)=2,
n^2=0,
sigma(n)=n,
Trd(n*S_i)=0 for all five i,
all fifteen Pluecker quadrics vanish.
```

At this fibre the `5 x 15` trace matrix has rank five.  Its ten-dimensional
kernel is exactly the ten-plane independently rebuilt by
`fano_covariant_scan.py` under `P -> -P*Q(x)`.

## Smoothness at the seed

After substituting `p=target_basis*z`, the verifier differentiates all fifteen
Pluecker generators in the ten `z` coordinates.  Their `15 x 10` Jacobian has
rank six at `z10`.  Hence the affine cone has tangent dimension four.  Since
the point is nonzero, its projective tangent dimension is three.

The Grassmannian `Gr(2,6)` has dimension eight, and intersection with the five
independent section hyperplanes has local dimension at least `8-5=3`.
Therefore the local dimension equals the projective tangent dimension three,
so this is a smooth point of the projective Fano threefold fibre.

## Six-fibre constant-ansatz boundary

The verifier rebuilds the five trace rows at all six regular points in
`attack_core.POINTS`.  The stacked `30 x 15` matrix has rank fifteen.
Consequently no nonzero coefficient vector that is constant in this installed
symmetric frame satisfies even the linear trace conditions at all six fibres
modulo 23.  The displayed `a15` succeeds only at the first fibre.

This excludes only the constant-coefficient ansatz.  It does not exclude
coefficients in the invariant function field, polynomial covariants of higher
degree, or a `K_proj`-rational point.

## Independent Morita-coordinate seed

`verify_morita_seed_p23.py` works from `c2_morita.json` alone and reconstructs
the five genuine scalar equations `q^*H_iq=0` at its certified split fibre

```text
p=23, zeta11=2, x=(1,2,3,4,5), RUR root=1.
```

It exhaustively enumerates the normalized `23^4` parameter space, obtains
`13154` solutions counted with their affine linear fibres, and independently
checks the displayed common right-`D` line

```text
q=(1,0,0,0,13,9,8,10,0,20,7,1).
```

All five `D`-valued residuals are zero and a `5x5` Jacobian minor is `20`, so
this is a smooth point of that normalized split fibre.  It is a second
finite-fibre seed in Morita coordinates, not a characteristic-zero section.

## Replay

From this packet directory run

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_modular_seed_p23.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_morita_seed_p23.py
```

The terminal marker is

```text
C5_MODULAR_SEED_P23_OK
C5-MORITA-SEED-P23-INDEPENDENTLY-VERIFIED
```

## Direct inputs

```text
tmp/pfaffian_rank2_idempotent_attack/attack_core.py
  d44132e529618c0a639039d6af5604d6700fc7e8653be2ad7c060c9be282eb05
tmp/fano14_twist/fano_covariant_scan.py
  b3c93a41ed1f8b5106d93717dbad058b6c60af100bcee8138925485dac6f107e
tmp/pfaffian_25plus11_descent/descent_core.py
  59fa59a249f02af563173e6279360af13da1a6ee748338a43086b0697c79d436
tmp/pfaffian_representation_alignment/core.py
  4adce14eae3e7f6c4ace7e398946b4e9efe686dbe68f6808c0289e2c7e73f5b4
tmp/pfaffian_25plus11_descent/certificate.json
  8361006e7fa78cb7269e3efbe9542dba676fedce35303528aee03b79320736bd
tmp/pfaffian_representation_alignment/certificate.json
  90746a65051b863c684c906f7166c70572a2edc319e6f6e6e306042261153848
tmp/generic_twist/phi_coefficients.py
  8c217aeaefe300a76e886f0a94803b5812689574299e1a2c72daeec72efd4525
tmp/kproj_arithmetic/core.py
  913b6184df2272e4834f81b38abdda9f468a2852ec571a04a469610054468b01
```
