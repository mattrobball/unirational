# Exact Stage-B coordinate stratification

## Outcome

The closed coordinate stratum

```text
L = P<span(q4,...,q11)> = V(q0,...,q3,q12,...,q36)
```

is **exactly empty for the sealed r256 Stage-B contraction system over
`F_89`**, and therefore the true special-fibre Stage-B locus is empty on
`L`.  This is a conclusive unit/module certificate, not a bounded survivor
test.

The exact first coordinate layer outside `L` was also stratified.  For

```text
U_i = P<span(L,q_i)> \ L
```

the r256 row module is the unit module on `U_i` for the following 21 outside
coordinates:

```text
i = 0,1,2,3,12,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36.
```

Together with the closed-`L` result, this excludes the complete coordinate
`P^8 = P<span(L,q_i)>` for each of these 21 values of `i`.

The one-coordinate charts `i=13,...,20` are not certified.  More
importantly, these `P^8` slices do **not** cover mixed points having two or
more nonzero coordinates outside `L`.  Thus the complement of `L` and global
Stage B remain unresolved.  No P25 or Problem-E verdict follows.

## Closed `L`: exact degree-six module certificate

Let

```text
S_L = F_89[q4,...,q11]
```

and restrict the sealed `256 x 6` cubic contraction matrix to `L`.  Exactly
114 vector-cubic rows remain nonzero (global row ordinals `142,...,255`).
They have 57,864 nonzero coefficients in the `114 x 6 x 120` restricted
tensor.

The producer constructs the exact graded Macaulay map

```text
Phi_6 : F_89^114 tensor (S_L)_3  ->  (S_L)_6^6.
```

Its dimensions and exact rank are

```text
source = 114 * 120 = 13,680
target = 6 * 1,716 = 10,296
rank_F89(Phi_6)    = 10,296.
```

Hence the generated row module `N_L` satisfies

```text
(N_L)_6 = (S_L)_6^6.
```

In particular `q_i^6 e_j` lies in `N_L` for every `i=4,...,11` and every
module component `j=0,...,5`.  The opens `D(q_i)` cover `Proj(S_L)`, so the
localized row module is all of `S_L^6` everywhere on `L`.  Equivalently the
matrix has rank six at every geometric point of `L`, even after base change
to the algebraic closure.  There is no projective pair `(q,b1)` on `L` with
`b1 != 0` and `P3(q)b1=0`.

The producer used exact FFLAS-FFPACK PLUQ to obtain a 10,296-row rank profile.
The independent verifier rebuilt only the selected `10,296 x 10,296` minor
using a separate multiset-based monomial constructor and obtained

```text
determinant = 28 mod 89 != 0.
```

This independently certifies the full-rank claim.  The necessary-contraction
implication then excludes the true Stage-B locus on `L`; no equality between
the contraction locus and the true incidence is asserted.

Evidence:

- `produce_closed_L_degree6.py`
- `closed_L_degree6_certificate.json`
- `verify_closed_L_degree6.py`
- `verify_closed_L_degree6_result.json`

The producer took 16.08 seconds total (15.65 seconds in PLUQ) and recorded
about 1.77 GiB maximum RSS.  The independent determinant replay took 12.12
seconds in the determinant and recorded about 1.36 GiB maximum RSS.

## First layer in the complement

Write

```text
H = {0,1,2,3,12,13,...,36}.
```

Set all outside-`L` coordinates except `q_i` to zero and dehomogenize by
`q_i=1`.  This gives a row module over the eight-variable affine ring
`F_89[q4,...,q11]`.  For multiplier degree bound `d`, the producer forms the
exact coefficient map from all generator multiples of degree at most `d` to
six-vector polynomials of degree at most `d+3`, then appends the six constant
module basis vectors.

If none of the six appended rows occurs in the exact row-rank profile, all six
constants already lie in the source row span.  This is an explicit finite
linear-algebra Nullstellensatz certificate that the row module is the unit
module on the chart.  It avoids `b1` variables and `b1` saturation entirely.

The exact unit certificates are:

| Coordinates `i` | Degree bound | Exact replay |
|---|---:|---|
| `0,1,2,3,31,32,33,34,35,36` | 1 | `rank(source)=rank(augmented)=1902` independently replayed |
| `21,22,23,24,25,26,27,28,29,30` | 2 | `rank(source)=rank(augmented)=7074` independently replayed |
| `12` | 3 | producer PLUQ has full target rank `18018`; exact but not independently rerun |

For `q12`, the degree-three map has 21,120 source rows, 18,018 target columns,
and augmented rank 18,018; the row-rank profile selects none of the six
appended unit rows.  The formal run took 33.37 seconds total, 30.67 seconds in
PLUQ, and recorded about 4.77 GiB maximum RSS.

The degree-at-most-two run did not certify `i=13,...,20`: all six appended
unit rows remained independent at the tested bound.  This means only that no
certificate was found in this bounded Macaulay space.  It is **not** a
nonempty contraction survivor and is not evidence for a true Stage-B point.

Evidence:

- `produce_one_coordinate_charts.py`
- `one_coordinate_chart_certificates.json`
- `verify_one_coordinate_charts.py`
- `verify_one_coordinate_charts_result.json`
- `one_coordinate_q12_degree3_certificate.json`

The 29-chart bounded producer run (20 unit certificates and nine bounded
noncertificates) recorded about 6.24 GiB maximum RSS.  Its 20-chart independent
rank-equality replay recorded about 10.96 GiB maximum RSS, so that heavy replay
should not be launched alongside another memory-intensive process.  No
degree-three chart runs beyond the bounded `q12` run were started after the
resource warning.

## Exact scope of the stratification

The full open complement is

```text
P^36 \ L = union_{i in H} D(q_i).
```

The affine charts certified here are the smaller slices

```text
D(q_i) intersect P<span(L,q_i)>,
```

not the full opens `D(q_i)`.  Therefore the current exact exclusion is:

1. all of `L`;
2. the one-outside-coordinate slices for 21 listed coordinates.

The remaining loci are:

1. the single-outside-coordinate slices for `i=13,...,20`; and
2. every mixed stratum with at least two nonzero coordinates from `H`.

Any claim that these 21 slices cover the complement would be false.  A next
exact step would require module membership on the full affine opens, or a
flag/coordinate stratification that handles the mixed outside support.  A
nonunit contraction computation would remain inconclusive.

## Replay

From this directory:

```text
/opt/homebrew/bin/python3 -u produce_closed_L_degree6.py
/opt/homebrew/bin/python3 -u verify_closed_L_degree6.py

/opt/homebrew/bin/python3 -u produce_one_coordinate_charts.py
/opt/homebrew/bin/python3 -u verify_one_coordinate_charts.py

/opt/homebrew/bin/python3 -u produce_one_coordinate_charts.py \
  --charts 12 \
  --max-multiplier-degree 3 \
  --output one_coordinate_q12_degree3_certificate.json

/opt/homebrew/bin/python3 verify_summary.py
```

The final command is a lightweight ledger/hash audit only.  It terminates

```text
PASS: closed L and scoped one-coordinate certificates are consistent
```

and writes `summary_verification_result.json`.  The preceding producer and
verifier commands are the exact finite-field linear-algebra replays.

All computations consume the sealed source

```text
P25_LANDING_SUPPORT/syzygy_r256_q0_contracted.npz
SHA-256 2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea
```

The lightweight audit records the SHA-256 values of every heavy result it
combines.  It passes on the present packet.  Global Stage B is still
**UNDECIDED**.
