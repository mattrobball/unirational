# Degree-12 ambient-projector lead

## Exact modular statement

The full primal-wedge Reynolds search concerns polynomial covariants

```text
W_5 -> wedge^2(V_6)
```

whose values are decomposable.  Such a covariant would give an auxiliary
Morita projector after descent.  It does not impose membership in the
distinguished ten-plane `B_10`, so it is not a point of `F_14,T`.

The independent leading-ideal parser in `audit_ambient_leading.py` obtains:

| degree | coefficient variables | mod-23 Hilbert function | conclusion |
|---:|---:|---|---|
| 9 | 20 | `[1,20,53,0,...]` | projectively empty |
| 10 | 28 | `[1,28,154,0,...]` | projectively empty |
| 11 | 36 | `[1,36,331,22,0,...]` | projectively empty |
| 12 | 48 | `[1,48,705,1971,3,3,3,3,3]` | zero-dimensional, length 3 |

This is computed from the saved leading monomials themselves, not from a
stored pass flag or solver summary.

## Independent-prime frame check

`build_ambient_projector_prime.py` reconstructs the group and the complete
degree-12 Reynolds seed frame after changing the live finite-field globals.
At both split primes 67 and 89 it finds:

```text
covariant dimension = 48
quadratic equation rank = 471
seed frame = the same deterministic frame used at p=23
```

The equation digests differ between primes, as required:

```text
p=67: 044b1401e59979250381a1c870e148919af04f44f333f81c2d19b29a99f2e430
p=89: 0adfcb23f762e1b658682888cdf42bcaa5b6b875b5babef8d62dedb3ab786ed9
```

The same live-globals check is essential for cyclotomic conjugates.  A
read-only sibling output labelled `zeta=4` was byte-identical to its `zeta=2`
RUR because that harness mutated only the namespace copy returned by
`runpy.run_path`.  It is not consumed here.  This packet's builder mutates the
globals retained by the imported functions; its valid `p=23,zeta=4` equation
digest is

```text
7ab90ef5244b9f81347ac40a6eb0370f3d8ab528b41ea7a27a813e21703b6258
```

## Degree-12 residue arithmetic

The correctly ordered affine chart `a47=1` is square-free of degree three in
each solved fibre:

```text
p=23, zeta=2: rational roots 1,6,11
p=23, zeta=4: rational roots 7,8,13
p=67, zeta=9: rational root 7 plus an irreducible quadratic factor
```

Every extracted rational root was checked by direct Reynolds evaluation at
three source points where both the structure form and the restricted
two-plane form are nondegenerate.  The resulting wedges satisfy all Pluecker
quadrics and yield self-adjoint ordinary-rank-two projectors.  None lies in
the distinguished Fano ten-plane.

All six possible conjugate branch pairings at `p=23` were converted to
centered coefficients `A+B*c`, with `c^2+c+3=0`.  None has a low-height
pattern, and all 18 one-prime guesses fail direct Pluecker screens at both 67
and 89.  This excludes only those centered guesses.

## Boundary

The length-three scheme has not been lifted to characteristic zero.  Stable
dimension, residue points, and equation rank do not imply flatness or a common
coefficient vector.  Even an exact lift would close only the explicit Morita
projector subproblem; the five simultaneous Klein-isotropy equations remain.

Replay:

```sh
/opt/homebrew/bin/python3 -u audit_ambient_leading.py --max-degree 8
/opt/homebrew/bin/python3 -u build_ambient_projector_prime.py --prime 67 --degree 12
/opt/homebrew/bin/python3 -u build_ambient_projector_prime.py --prime 89 --degree 12
```
