# Fixed-frame discriminant and pre-normalization contact ledger

Status: **exact partial packet; T3.D is not complete**.  The authoritative
fixed-frame discriminant is constructed over `QQ`, and two genuine
height-one contacts on the raw projective target are computed exactly.  The
required global normalization/conductor identification is still open, so this
packet must not be cited as an exhaustive contact ledger.

## Authoritative inputs and coordinates

The cubic coefficients come from
`certificates/fixed_frame_arithmetic/five_forms.json`, SHA-256
`61377d6e464f7c78cf1fa91d13610b76dc4567de7b7214256e04de50066c83a4`.
The raw target equation comes from
`certificates/target_branch_global/H_factor/H_primitive_integer.tsv`, SHA-256
`b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501`.

The fixed-frame cubic is

```text
F0 + A FA + B FB + Y FY + (Z-11 A^2/18) FZ.
```

Write `T=Z-11 A^2/18`.  The universal convention used throughout is

```text
Delta_cub = (c4^3-c6^2)/1728.
```

This is the fixed-frame ternary-cubic discriminant.  It is not the unrelated
degree-120 `xCD` discriminant.

## Exact discriminant

The coefficients over `QQ(zeta_11)` are one nonzero cyclotomic scalar times a
primitive integer polynomial.  Rational descent gives:

| coordinate | terms | total degree | SHA-256 | exact factorization |
|---|---:|---:|---|---|
| `T` | 647 | 11 | `f1a413ce9e0f38ca386118079146afa55da64bf6dac591ce3e95b3f816135614` | not needed |
| `Z` | 719 | 15 | `14f1209efc4a60613d4c28cffd666a0e97861ad891440e7b9a726e211d814d4f` | irreducible, exponent one over `QQ` |

The degree change is solely the nonlinear coordinate change
`T=Z-11 A^2/18`.  `verify.py` independently evaluates the saved universal
invariant strings on the authoritative five forms, reconstructs both TSVs,
and repeats the exact `QQ` factorization.

## Height-one contacts proved exactly

Let `Hbar` and `Dbar` be the degree-39 and degree-11 homogenizations in
coefficient-space coordinates `[L:A:B:Y:T]`.

| raw support | generic normalization statement | `v(Delta_cub)` | mod 3 | scope |
|---|---|---:|---:|---|
| `S=(A-15L,Y-12L)` | `H_A` is a unit generically, hence normalization is an isomorphism | 2 | 2 | exact |
| `E=(L,A)` | Newton branch types have `(e_L,v_A)=(2,1)` or `(3,1)` | 4 on every normalized branch | 1 | exact at the generic boundary divisor |

For `S`, direct Taylor elimination gives

```text
u=A-15,  v=Y-12,
u=-(H_02/H_10)v^2+O(v^3),
Delta|H=((H_10 D_02-D_10 H_02)/H_10)v^2+O(v^3).
```

The numerator is nonzero, so the order is exactly two.  The generic fibre
cubic has one ordinary node.  After the separable tangent-cone splitting
extension its incidence model is the usual `xy=pi^2` node; its three-primary
local class group is zero.  This last conclusion is compatible with quadratic
descent, but it does not replace the missing global normalization.

At infinity the top forms factor as

```text
H_top = unit*A^28*(53A+6Y)^2*(29A+6Y)^6*Q3,
D_top = unit*A^4*(19A+4Y)^3*Q4,
gcd(H_top,D_top)=A^4.
```

Thus `E` is the sole boundary *divisor component* common to `Hbar` and
`Dbar`; other intersections of the top forms are lower-dimensional.  The
Newton polygon of `Hbar` at the generic point of `E` has vertices
`(0,11),(10,6),(28,0)`, with slopes `-1/2,-1/3`.  Exact edge gcds show that
the initial discriminant is nonzero after extracting `A^4`, hence every
normalization branch has valuation four.  The ambient complete-intersection
cycle coefficient is instead

```text
i_E(Hbar,Dbar)=4*i_E(Hbar,A)=4*11=44.
```

The number 44 is not a normalization valuation.

## Exact special-locus audit inside `S`

The order-two coefficient on `S`, in `(B,T)`, factors as

```text
unit*(B-10T-117)^2*(B+8T+108)^2*(2B-2T-9)
    *(4B+2T+9)^4*Q3*F15,
```

where `Q3` is an irreducible rational cubic and `F15` is the saved
irreducible degree-15 factor.  In `(B,Z)` the named loci are

```text
L  = B+8Z-992                 (Hessian/cusp line),
D  = Q3(T=Z-275/2)            (second-node direction cubic),
C  = B-Z+133                  (cancellation line),
J1 = B-10Z+1258,
J2 = 2B+Z-133.
```

Exact completed-local calculations give:

- Generic `L`: the fibre cusp is smoothed transversely; the absolute total
  incidence is `A1` times a regular parameter and its punctured local Picard
  group is killed by two.
- Generic `D`: the marked singular point is again `A1` times regular; the
  second node is smoothed by the `B` direction.
- Generic `C`: after quadratic splitting the model is
  `xy=tau^2 s`.  The involution sends the split class generator to its
  negative, and restriction-corestriction kills any actual-field
  three-primary class.

These are codimension-three/special-locus facts, not new height-one contact
orders.  The raw target is singular along the curves `J1`, `J2`, and `F15` on
`S`; normalization and local class groups above those curves remain **OPEN**.

## Degree-budget and conductor audits

An explicit projective plane

```text
L=z, A=x+15z, B=2x+3y+5z, Y=y+12z, T=7x+11y+13z
```

was reduced at the fixed good prime 1009.  Singular 4.4.1 computes

```text
deg(Hbar,Dbar)=429,
after S: 427,
after E: 385,
residual: 383,
residual Jacobian ideal: <1>.
```

This exactly matches the cycle budget `429=2+44+383` and is a strong
good-reduction check that the residual raw pullback is generically reduced.
The binding work order explicitly says that a reduced modular pullback is not
the required characteristic-zero normalization ledger, so no exhaustiveness
claim is made from this calculation.

For the candidate degree-six RUR prime

```text
(QZ, B*QZ_Z-NB, Y*QZ_Z-NY) over QQ(A,u),
```

two exact specializations have squarefree degree-six `QZ` and nonzero
`Delta` remainder and norm.  This proves generic noncontainment **conditional
on identifying that RUR prime with a conductor component**.  That
identification, and exhaustion of the full conductor, have not been proved.

## Verdict and exact open boundary

The packet proves the discriminant polynomial and the two displayed generic
contact orders.  It does **not** provide the authoritative finite birational
normalization, an exhaustive conductor/component list, or charts covering
all normalized height-one primes.  In particular:

```text
T3.D global contact ledger: OPEN
T3 headline exit: T3-UNDECIDED
```

No result here may be promoted to `T3-LOCAL-MOD3-LEDGER-PASS` or to the
headline bridge without the T3.A--T3.C normalization packets and the missing
conductor exhaustiveness proof.

