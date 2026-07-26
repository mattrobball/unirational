# Verification transcript

Checked on 2026-07-25 from the Problem E directory.

## Environment

```text
Python 3.14.6
numpy 2.5.1
sympy 1.14.0
Macaulay2 1.26.06
msolve 0.10.1
```

## Exact action

Command:

```sh
python3 certificates/exact_weil_check.py
```

Output:

```text
PASS g^2=-11
PASS S^2=T^11=(ST)^3=1
PASS ST^3ST^4ST^3=P, P^5=1
PASS F(Sx)=F(Tx)=F(Px)=F(x) exactly in Q(zeta_11)
PASS exact Cayley consistency on all 660 elements of PSL_2(F_11)
```

## Molien dimensions

Command:

```sh
python3 certificates/exact_molien.py
```

Relevant output:

```text
d  self-covariants  invariants
 0                0           1
 1                1           0
 2                0           0
 3                0           1
 4                2           0
 5                1           1
 6                2           2
 7                4           1
 8                5           2
 9                6           3
10               10           3
11               12           4
12               16           6
13               21           5
PASS exact class average
covariant hsop numerator: [(1, 1), (4, 1), ..., (24, 1), (26, 1)]
invariant hsop numerator: [(0, 1), (7, 1), ..., (21, 1), (28, 1)]
rank_A(R)=12 rank_A(M)=60 rank_R(M)=5
PASS exact Hironaka numerators and non-freeness over R
```

The omitted middle entries are printed and asserted in full by the checker.
The negative coefficients beginning in degree 15 of `H_M/H_R` certify that
the self-covariant module is not a free graded module over the full invariant
ring.

## Exact primitive covariants

Commands:

```sh
python3 certificates/exact_covariants_check.py
python3 certificates/septic_landing_check.py
```

Output:

```text
PASS C,D,Hx,E equivariant under exact S,T,P
PASS quartic witness F=0, F(C)=50
PASS quintic witness F(D)=1080
PASS sextic witness H=0, F(E)=-786432
PASS primitive septic K equivariant under exact S,T,P
PASS det[x,C,D,E,K](-2,-2,-2,-2,-1)=-295136920
[(-1, 2, -2, 0, -2), (1, 1, 1, 1, -1),
 (-2, 1, -2, 1, 1), (2, -2, 1, 0, -1)]
PASS every projective chart A=1,B=1,C=1,D=1 has Groebner basis [1]
```

## Generic-twist frame

Command:

```sh
python3 certificates/generic_covariant_basis_check.py
```

Output:

```text
witness = (-2, -2, -2, -2, -1)
det[x,C,D,E,K] = -295136920
columns =
x = (-2, -2, -2, -2, -1)
C = [280, 369, 336, 272, 208]
D = [212, 92, 32, 181, 172]
E = [386, 216, 236, 156, 468]
K = [42, 1612, 1512, -232, 1048]
PASS determinant polynomial is nonzero over Z
```

## Generic-frame coordinate lines

Command:

```sh
python3 certificates/generic_frame_lines_check.py
```

Relevant output:

```text
line=x+t*C ... factor_degrees=[3] rational_roots=[] ... absolute_modular_certificate=(2, 8)
line=x+t*D ... factor_degrees=[3] rational_roots=[] ... absolute_modular_certificate=(2, 8)
line=x+t*E ... factor_degrees=[3] rational_roots=[] ... absolute_modular_certificate=(2, 8)
line=x+t*K ... factor_degrees=[3] rational_roots=[] ... absolute_modular_certificate=(2, 8)
line=C+t*D ... factor_degrees=[3] rational_roots=[] ... absolute_modular_certificate=(2, 8)
line=C+t*E ... factor_degrees=[3] rational_roots=[] ... absolute_modular_certificate=(2, 8)
line=C+t*K ... factor_degrees=[3] rational_roots=[] ... absolute_modular_certificate=(2, 8)
line=D+t*E ... factor_degrees=[3] rational_roots=[] ... absolute_modular_certificate=(2, 8)
line=D+t*K ... factor_degrees=[3] rational_roots=[] ... absolute_modular_certificate=(2, 8)
line=E+t*K ... factor_degrees=[3] rational_roots=[] ... absolute_modular_certificate=(2, 8)
PASS all ten generic-frame coordinate lines have no C(W)-point
```

For each line the reduction preserves total degree and degree three in the
line parameter. Irreducibility over both `F_2` and `F_8` is the absolute
irreducibility certificate used in `RESOLUTION.md`.

## Generic-frame planes

Commands:

```sh
python3 certificates/generic_frame_planes_specialization.py
python3 certificates/generic_frame_planes_check.py 11 14
```

Relevant output:

```text
source (-1, -1, -1, -1, 0) frame_determinant -4400
xCD terms 10 smooth True factor_degrees [(3, 1)]
xCE terms 10 smooth True factor_degrees [(3, 1)]
xCK terms 10 smooth True factor_degrees [(3, 1)]
xDE terms 10 smooth True factor_degrees [(3, 1)]
xDK terms 10 smooth True factor_degrees [(3, 1)]
xEK terms 10 smooth True factor_degrees [(3, 1)]
CDE terms 10 smooth True factor_degrees [(3, 1)]
CDK terms 10 smooth True factor_degrees [(3, 1)]
CEK terms 10 smooth True factor_degrees [(3, 1)]
DEK terms 10 smooth True factor_degrees [(3, 1)]
reduced_frame_witness=(10, 11, 17, 21, 0) rank=5 determinant=3
PASS all ten three-column invariant-polynomial ansatz loci are projectively empty in total degrees 11 through 14
```

The second checker tested all 40 triple-degree cases; every affine cone had
Macaulay2 `dimension=0`. The full coefficient/equation table and the DVR
properness argument are recorded in `tmp/generic_plane/REPORT.md`.

## Generic-frame flex covers

Command:

```sh
python3 -u certificates/flex_cover_check.py
```

Relevant output:

```text
case xCD degree_a 9 degree_s 141 terms 1184 infinity_degree 105 ... GF(23^3)_factors 1 factor_exponent 1
case xCE degree_a 9 degree_s 156 terms 1291 infinity_degree 111 ... GF(23^3)_factors 1 factor_exponent 1
case xCK degree_a 9 degree_s 171 terms 1391 infinity_degree 117 ... GF(23^3)_factors 1 factor_exponent 1
case xDE degree_a 9 degree_s 171 terms 1423 infinity_degree 126 ... GF(23^3)_factors 1 factor_exponent 1
case xDK degree_a 9 degree_s 186 terms 1530 infinity_degree 132 ... GF(23^3)_factors 1 factor_exponent 1
case xEK degree_a 9 degree_s 200 terms 1680 infinity_degree 147 ... GF(23^3)_factors 1 factor_exponent 1
case CDE degree_a 9 degree_s 189 terms 1728 infinity_degree 171 ... GF(23^3)_factors 1 factor_exponent 1
case CDK degree_a 9 degree_s 204 terms 1818 infinity_degree 177 ... GF(23^3)_factors 1 factor_exponent 1
case CEK degree_a 9 degree_s 219 terms 1973 infinity_degree 192 ... GF(23^3)_factors 1 factor_exponent 1
case DEK degree_a 9 degree_s 224 terms 2070 infinity_degree 207 ... GF(23^3)_factors 1 factor_exponent 1
PASS ten degree-9 flex eliminants remain irreducible over GF(23^3)
```

Irreducibility survives the cubic constant extension, which certifies
geometric irreducibility because the eliminant degree is nine. The selected
line preserves degree nine, the infinity resultants are nonzero, and the
primitive good-reduction argument lifts to characteristic zero. Hence none of
the ten plane cubics has a rational flex, even over `C(W)`.

## Subgroup orbit and secant checks

Commands:

```sh
python3 certificates/subgroup_secant_check.py
python3 certificates/subgroup_orbit_check.py
```

Relevant output:

```text
PASS C11 frame: 5 contained diagonals and 5 endpoint-tangent sides
PASS each inverse C5-eigenpoint chord is contained in the Klein cubic
PASS gcd(60,132,165,220)=1, while each listed effective degree is >2
PASS D12 unique character line is off X
PASS D10 unique character line is off X; F=5
PASS both A4 character lines are off X
PASS W restricts irreducibly to A5 and 11:5 (exact character norm 1)
PASS exact index-two block chains: C11 none; C5<D10 stops; V4 none; C3 has C6/two S3 choices, all fold to D12 and stop
```

The orbit-length conclusion additionally uses the standard ATLAS
maximal-subgroup list for \(\operatorname{PSL}_2(11)\). The checker itself
performs every representation, equation, and index-two-overgroup calculation
exactly.

## The 220-point orbit ideal

Command:

```sh
python3 certificates/orbit_hilbert_check.py
```

Relevant output:

```text
PASS reduced Klein action has 660 distinct matrices over F_331
PASS primitive C3 eigenpoint is simple and has projective orbit 220
PASS orbit lies on the Klein cubic
PASS evaluation ranks degrees 0..7: [1, 5, 15, 34, 65, 110, 165, 220]
PASS X section dimensions degrees 0..7: [1, 5, 15, 34, 65, 111, 175, 260]
```

The nonzero reduced minors lift to characteristic zero. Thus the orbit lies
on no divisor of degree at most four, while the degree-five kernel is exactly
one-dimensional (the Hessian). Any regular three-divisor link containing it
starts in degrees at least `(5,6,6)` and has residual degree at least 320.

## Good-reduction exclusion, degrees 1–9

Command:

```sh
python3 certificates/modular_covariant_scan.py
```

Relevant output:

```text
group_order=660 invariant_cubic_terms=5
degree=7 covariants=4 symmetric_cube=20 landing_rank=15 witnesses=15
  projective_base_locus_empty=True patches=[True, True, True, True]
degree=8 covariants=5 symmetric_cube=35 landing_rank=32 witnesses=32
  projective_base_locus_empty=True patches=[True, True, True, True, True]
degree=9 covariants=6 symmetric_cube=56 landing_rank=45 witnesses=45
  projective_base_locus_empty=True patches=[True, True, True, True, True, True]
degree=10 covariants=10 symmetric_cube=220 landing_rank=80 witnesses=80
PASS no homogeneous polynomial self-covariant of degree <= 9 lands in X
```

The degree-10 row is basis/equation preparation only; its projective
emptiness is checked separately below.

## Degree-10 Macaulay2 exclusion

Command:

```sh
python3 certificates/degree10_m2_check.py
```

Output:

```text
generators=80
dimension=0
hilbertFunction[3]=140
hilbertFunction[4]=6
hilbertFunction[5]=0
hilbertFunction[6]=0
PASS no degree-10 homogeneous polynomial self-covariant lands in X
```

`python3 -m py_compile certificates/*.py` also passed. The degree-10 script
dynamically rebuilt its Reynolds basis and equations from the direct
\(\zeta_{11}\mapsto2\) reduction; no static file under `tmp/` was used.

## Degree-11 Macaulay2 exclusion

Command:

```sh
python3 certificates/degree11_m2_check.py
```

Output:

```text
basisRank=12
generators=108
dimension=0
hilbertFunction[3]=256
hilbertFunction[4]=76
hilbertFunction[5]=0
hilbertFunction[6]=0
PASS no degree-11 homogeneous polynomial self-covariant lands in X
```

The script dynamically rebuilt its direct-Weil Reynolds basis and 108
independent sampled necessary landing equations; no cached data or other file
under `tmp/` was used. A separate exact replay also reconstructed every cached equation from
its witness point before this durable checker was promoted.

## Degree-12 exact msolve exclusion

Command:

```sh
python3 certificates/degree12_msolve_check.py --threads 4 --timeout 120
```

Output:

```text
basisRank=16 landingRank=143
PASS exact msolve Groebner basis seconds=8.070
leading_monomial_degrees={3: 143, 4: 813, 5: 2884}
hilbertFunction[0..5]=[1, 16, 136, 673, 1589, 0]
PASS no degree-12 homogeneous polynomial self-covariant lands in X
```

The checker reconstructs the complete basis and 143 selected independent
sampled necessary landing equations directly from the Weil matrices, writes
only a temporary solver input, parses all 3840 leading
monomials, and independently enumerates the quotient monomials. Since the
Hilbert function vanishes in degree five, the homogeneous projective landing
locus is empty. The good-reduction and projective-properness argument transfers
this emptiness to characteristic zero.
