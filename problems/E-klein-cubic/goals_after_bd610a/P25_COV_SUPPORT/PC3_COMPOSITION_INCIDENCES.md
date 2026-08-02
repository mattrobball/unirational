# PC.3 primitive-quartic and lower-map composition incidences

Status: `PC3-COMPOSITION-GRAPHS-SCOPED-PASS`. Global status remains
`PC-UNDECIDED`.

The pure composition census is now exact. Degree 31 has no nontrivial pure
lower-map composition. Degree 35 has exactly two ordered components,

```text
D after M7,     M7 after D,
```

and both actual projective graphs have been constructed. Each graph is
disjoint from the literal `K1_35` space. This is not a saturation of the
landing complement.

## Installed lower self-maps

The integral circuits in `certificates/exact_covariants_check.py`, together
with the exact Molien calculation, give:

| degree | dimension | fixed circuit basis | parameter space |
|---:|---:|---|---|
| 1 | 1 | `x` | `P^0` |
| 2 | 0 | — | empty |
| 3 | 0 | — | empty |
| 4 | 2 | `F*x, C` | `P^1` |
| 5 | 1 | `D` | `P^0` |
| 6 | 2 | `H*x, E` | `P^1` |
| 7 | 4 | `K, F*C, F^2*x, J*x` | `P^3` |

Here `C=grad(F_dual)(grad(F))` is the installed primitive quartic. The
ambient quartic space is two-dimensional, but `F*x` vanishes on the Klein
cubic, so the primitive quotient `M4/<F*x>` is the single point represented
by `C`.

At both 419 and 463 the Molien character calculation returns

```text
dim M_d, d=0,...,7:  0,1,0,0,2,1,2,4,
```

and direct evaluations of the displayed bases have ranks `1,2,1,2,4`.

## Exact degree census

The nontrivial installed degrees are `4,5,6,7`.

- Since 31 is prime, no ordered product of two nontrivial lower degrees is
  31. There is no pure degree-31 composition component.
- Since `35=5*7=7*5`, the complete pure degree-35 union consists of
  `D after M7` and `M7 after D`.
- Degree 4 divides neither 31 nor 35. Thus every old degree-31/35 named
  direction containing `C` also carries a positive invariant multiplier.
  Such a direction has a genuine common scalar factor and belongs to the
  factor incidence, not to the pure composition union.

The old structured ansatz contained eight composition words in degree 31,
all positively scaled. In degree 35 it contained twelve words: ten positively
scaled directions and the two pure points `D after K` and `K after D`. Those
two points lie inside the full `P^3` families constructed here. The old
linear spans are not used as definitions of these nonlinear images.

## Kernel-aware projective graphs

The target `M35` is represented by a fixed injective 637-coordinate
evaluation frame, hence projectively by `P^636`. The literal `K1_35` basis
has 361 columns in this frame. An exact quotient matrix

```text
Q : F^637 -> F^276
```

has kernel equal to that 361-space at both good primes.

### `D after M7`

Write a general septic as

```text
q7(a)=a0*K+a1*F*C+a2*F^2*x+a3*J*x,   [a] in P^3.
```

Because `D` has degree five, its coefficients in `a` are indexed by the 56
degree-five monomials. The source is embedded by

```text
nu_5 : P^3 -> P^55.
```

The certificate stores all 1,310 quadratic binomial circuits obtained by
equating products of Veronese coordinates with the same exponent sum. The
composition circuit gives a linear map

```text
T_D7 : F^56 -> F^637.
```

The graph in `P^55 x P^636` is defined by the Veronese quadrics and

```text
y wedge (T_D7 z) = 0.
```

The usual projective base-locus guard is `z notin P(ker T_D7)`. Here
`rank(T_D7)=56` at both primes, so the kernel is zero and the graph has no
base locus.

### `M7 after D`

Substituting the fixed quintic `D` into the four septic basis circuits gives

```text
T_7D : F^4 -> F^637.
```

Its graph in `P^3 x P^636` is `y wedge (T_7D a)=0`. Both reductions have
rank four and zero kernel, so this is a projective linear embedding.

## Intersection with literal `K1_35`

Adding `Qy=0` gives the graph intersection with literal `K1_35`. Independently,
the producer restricts every source-linearized composition to the complete
666-point triangular coefficient grid of one involution plus-plane. There
are `666*5=3330` restriction rows. Equivariance makes vanishing on this one
plane equivalent to the installed all-plane `K1` condition.

| family | source linearization | target rank | `Q*T` rank | plus-plane rank |
|---|---:|---:|---:|---:|
| `D after M7` | 56 | 56 | 56 | 56 |
| `M7 after D` | 4 | 4 | 4 | 4 |

The table is identical at 419 and 463. Full column rank of the exact
plus-plane circuit after one good reduction already proves characteristic-zero
full column rank; the second prime is an independent replay. Thus neither
projective composition graph meets literal `K1_35`.

## Corrected common-factor boundary

The common-factor intersection in the full 637-dimensional `M35` space was
not computed. In particular, this packet does not treat
`I_e*K1_(35-e)` as the exhaustive factor locus. The corrected factor
incidence must allow

```text
h*H in K1_35 even when H is not in K1_(35-e),
```

because the invariant factor `h` may itself vanish on every involution plane.

Consequently:

- each composition graph's intersection with literal `K1_35` is empty;
- its triple intersection with `K1_35` and any common-factor locus is
  therefore empty;
- its intersection with the corrected exhaustive common-factor locus in the
  full `M35` ambient space remains open;
- the mutual intersection of the two full composition graphs remains open.

## Replay and theorem boundary

Run:

```text
python3 P25_COV_SUPPORT/verify_pc3_composition_graphs.py
```

Expected terminal lines:

```text
PASS_PC3_NO_NONTRIVIAL_DEGREE31_PURE_COMPOSITION
PASS_PC3_D35_TWO_KERNEL_AWARE_GRAPHS_TWO_PRIMES
PASS_PC3_D35_COMPOSITION_K1_INTERSECTIONS_EMPTY_SCOPED
BOUNDARY_PC3_CORRECTED_COMMON_FACTOR_INTERSECTIONS_OPEN
```

This packet does not construct the corrected exhaustive common-factor union,
replace either nonlinear graph by its span, saturate any of the remaining 47
degree-31 or 101 degree-35 landing charts, decide a survivor or degree-wide
emptiness, or authorize a headline exit.
