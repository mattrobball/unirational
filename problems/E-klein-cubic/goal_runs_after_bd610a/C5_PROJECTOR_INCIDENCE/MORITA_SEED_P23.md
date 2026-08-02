# Genuine Morita common-line seed at p=23

This lane installs a replayable point of the **genuine five-equation
right-`D`-line problem** on the accepted C2 split fibre.  It is a finite-fibre
structural certificate, not a `K_proj`-rational point.

## Exact equation and chart

Use the accepted packet

```text
../../goals_2026-08-01/
  C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/c2_morita.json
```

with `D=e A_proj e`, corner basis `d_0,...,d_3`, and five Hermitian matrices
`H_i`.  For

```text
q_r = sum_alpha z_(r,alpha) d_alpha,   r=0,1,2,
```

the genuine common-line equations are

```text
F_i(q) = [d_0] (sum_(r,s) star(q_r) H_i[r,s] q_s) = 0,
i=1,...,5.
```

The verifier checks from the corner multiplication and involution tables that
the other three `D` coordinates vanish identically: a Hermitian self-pairing
is fixed by the canonical quaternion involution and hence is scalar.  Thus
these are five scalar quadrics, not twenty unrelated coordinate equations.

The chart used here is

```text
q_0 = 1_D = (1,0,0,0).
```

Because the first component is a unit, `qD` is a genuine locally direct
summand right-`D`-line; no split-fibre torsion or rank-defective vector has
been admitted.

## Accepted fibre and explicit line

The fibre is exactly the good fibre bound by `c2_morita.json`:

```text
p = 23,
zeta_11 = 2,
x = (1,2,3,4,5),
RUR root = 1,
projector pairing s = 3.
```

In the accepted old corner coordinates the line is represented by

```text
q = [1,0,0,0 | 13,9,8,10 | 0,20,7,1].
```

The independently rebuilt split identification `D = Mat_2(F_23)` sends the
last eight coordinates to

```text
(z4,z5,z6,z7,z8,z9,z10,z11)
  = (20,0,20,0,15,0,4,13).
```

Direct quaternion multiplication gives

```text
q^* H_1 q = ... = q^* H_5 q = (0,0,0,0) in D.
```

## Affine determinantal reduction

After splitting `D`, the canonical involution is the adjugate involution on
`Mat_2`.  On `q_0=1`, the four first-column variables

```text
z4,z6,z8,z10
```

are jointly linear when the four second-column variables

```text
z5,z7,z9,z11
```

are fixed.  The five equations therefore have the form

```text
A(v) u + c(v) = 0,
```

where `A` is `5 x 4`.  On `rank(A)=4`, consistency is the single quartic

```text
Delta(v) = det([A(v) | c(v)]) = 0.
```

`Delta` has 68 terms and is **not homogeneous** because `q_0=1`.  Accordingly,
the replay enumerates all `23^4=279841` affine parameter tuples.  This corrects
the older exploratory `c3_linear_fibrations_p23.json` count, whose script
enumerated projective representatives despite the determinant having constant
and lower-degree terms.

The exhaustive result is

```text
Delta(v)=0 parameter tuples                         13476
rank(A)=4                                           279450
rank(A)=3                                              391
consistent rank-4 tuples                             13085
consistent rank-3 tuples                                 3
normalized q_0=1 solutions, including free variables 13154
```

The three singular points of the affine determinant are exactly the three
consistent rank-three parameters:

```text
(2,5,10,1), (2,9,19,17), (4,13,15,22).
```

This is an exact exhaustive statement about the selected split fibre only.

## Smoothness and its meaning

At the displayed line the Jacobian of the five normalized quadrics in the
eight variables has rank five.  The verifier exhibits the minor

```text
columns (z4,z5,z6,z7,z8), determinant 20 mod 23.
```

Hence this point is smooth of relative dimension `8-5=3` on the normalized
finite-fibre chart.  The Jacobian unit permits a Henselian/formal local lift
after choosing compatible lifts of the coefficients.  It does **not** produce
a rational function solution over `K_proj`: a local completed-field point is
not a global rational section.

The remaining exact gate is therefore precise.  One must either

1. descend the split-column reduction through the generic quaternion algebra
   and solve its consistency condition over `K_proj`; or
2. produce another exact `q in D^3` and verify the same five equations over
   `K_proj` directly.

The current `c2_morita.json` serializes the exact lazy construction and its
finite-fibre tables, but not an expanded machine-ready eight-variable
`K_proj` coefficient system suitable for characteristic-zero elimination.

## Relation to the Lane-A modular seed

`MODULAR_SEED_P23.md` records a smooth Pluecker point at

```text
x = (22,21,8,1,1).
```

The Morita line here is at

```text
x = (1,2,3,4,5).
```

They are therefore points of **distinct base fibres** and need not have equal
coordinates.  No coordinatewise identification is asserted.  The accepted
Morita equivalence identifies this right-`D`-line with a genuine Pluecker
point in its own fibre, while Lane A independently verifies its displayed
Pluecker point in the other fibre.

## Independent replay

Run from this directory:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_morita_seed_p23.py
```

The terminal marker is

```text
C5-MORITA-SEED-P23-INDEPENDENTLY-VERIFIED
```

The verifier imports no point-producing solver and writes no files.  It
rebuilds the five quadrics from the multiplication, involution, and Hermitian
tables; exhausts all `23^4` affine parameters; and directly evaluates all five
`D`-valued residuals.

## Bound source hashes

```text
c2_morita.json
  0201a89f9087250a4313ef2732398adbddcadd3d2f234183736088760aec645f
ambient_degree12_rur_char0.json
  54c181762c3c5a263f1dc6522e39d8e690196c7acdc31dfa44f5043481ca3216
ambient_degree12_global_exact.json
  1a2f8dd96ee9323d3b6c52f0c9559471579168f5626df9931e21832801d73b75
compressed_algebra.json
  bfc2e6c5afcfac7c9925b916cad29098bc5033f1938dd9f0273febc067a55fbb
distinguished_five_plane.json
  edee4f7e07e95665044ba4fba85239154f4052f27d99b3cbcdd0f48b60d2378a
verify_morita_seed_p23.py
  eea573f510ee7271937f814db0fe52542f80da2fd45f9689d9f85744da13127d
```
