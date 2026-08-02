# A5Q common-cycle quadratic-rank variant

## Exact certificate

The two installed degree-eleven cycles are evaluated at the same good
specialization

```text
p = 89,
v = (71,10,17,18,13,44),
class-1 landing branch alpha = 80,
class-2 landing branch alpha = 49.
```

`verify_common_variant.py` independently reconstructs the full Schur frame
`Q(v)`, both maximal `A5` subgroup transports, and all eleven conjugates of
each point.  The two cycles therefore lie in one common descended coordinate
frame; they are not results obtained from two unrelated Schur witnesses.

For each cycle separately, the `11 x 15` quadratic-evaluation matrix has rank
`11`.  Stacking the two matrices in class order gives a `22 x 15` matrix of
rank `15`.  With quadratic monomials ordered

```text
x0^2,x0*x1,x0*x2,x0*x3,x0*x4,
x1^2,x1*x2,x1*x3,x1*x4,
x2^2,x2*x3,x2*x4,x3^2,x3*x4,x4^2,
```

the submatrix using combined rows `0,...,14` and all columns has determinant

```text
83 mod 89.
```

The terminal replay marker is

```text
A5Q_COMMON_CYCLE_QUADRATIC_RANK15_OK
```

## Characteristic-zero consequence

Every entry is the reduction of the same exact straight-line transport used
for the two characteristic-zero cycles, and the replay checks every required
frame, landing, and denominator nonvanishing gate at the common
specialization.  The determinant `83` therefore proves that the corresponding
characteristic-zero minor is nonzero.  Hence the union `Z_1 union Z_2` imposes
all fifteen independent conditions on quadrics:

```text
H^0(P^4, I_(Z_1 union Z_2)(2)) = 0.
```

In particular, the two cycles cannot lie together on a cubic rational normal
scroll in `P^4`, since every such scroll has nonzero quadratic equations.

More generally, if a connected genus-zero stable map of total degree `d`
contained both cycles, quadratic evaluation on the twenty-two conjugate
points would factor through

```text
H^0(C, f^* O_P4(2)),
```

whose dimension is `2d+1`.  Rank `15` therefore forces `d >= 7`.  Thus no
connected genus-zero stable map of total degree at most six contains both
cycles.

## Strict boundary

This certificate does not exclude common curves of degree at least seven,
higher-genus curves, or surfaces without quadratic equations.  It does not
solve the single-cycle degree-five interpolation incidence, instantiate a
tangent residual, construct a rational point or rational curve, or promote a
Problem E headline.

Replay from this directory with

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_common_variant.py
```
