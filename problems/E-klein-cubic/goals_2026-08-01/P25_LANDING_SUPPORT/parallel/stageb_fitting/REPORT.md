# Stage B Fitting and determinantal audit

## Verdict

No global Stage B emptiness certificate and no Stage B candidate was obtained.
The calculations below are exact, but their strongest geometric conclusion is
only that a Stage B point cannot have a `q`-vector supported on one or two of
the chosen 37 coordinates.  This is **not** a saturation or global support
verdict.

The useful outputs are:

* an exact Fitting reformulation with no `b1,b2` variables;
* a correction to a tempting but misgraded rank-one flattening;
* exact maximal-minor Bézout certificates on all 666 coordinate lines;
* an exact diagnosis of which contraction prefixes/packets do and do not
  have missing-coordinate defects; and
* `balanced42.npz`, a boundary-format `42 x 6` cubic compression which is a
  better input for a future structured resultant/Fitting computation.

## Exact projected Fitting problem

From the sealed degree-three relation block, write

```text
A(q) = [ M1(q) | M2(q) ] : F_89^6 + F_89^21 -> F_89^690,
```

where the six `M1` columns are quadratic in `q` and the 21 `M2` columns are
linear in `q`.  Upstream Stage A proves that `rank M2(q)=21` for every
`[q] in P^36`.

Consequently Stage B is **exactly**

```text
D = { [q] : rank A(q) < 27 } = V(I_27(A)) in P^36.
```

Indeed, a nonzero vector in `ker A(q)` cannot have `b1=0`, because then it
would give a nonzero vector in `ker M2(q)`.  Conversely every Stage B point
gives such a kernel vector.  Thus the decisive no-`b` calculation is

```text
(I_27(A) : (q0,...,q36)^infinity) = (1).
```

This formulation is exact, unlike a compressed-incidence survivor.

## Contraction implication directions

For the sealed `256 x 6` cubic contraction matrix `P3(q)`, every true Stage B
point satisfies

```text
P3(q) b1 = 0,
```

and therefore lies in `D_256 = V(I_6(P3))`.  For any constant `42 x 256`
matrix `R`, put `B42=R*P3`; then

```text
D subset D_256 subset V(I_6(B42)).
```

Hence emptiness of the `B42` rank-drop locus would be decisive.  A point of
that locus would prove nothing about `D_256`, still less about the true Stage
B locus, until lifted and checked in all 690 equations.  Algebraically,
`I_6(B42) subset I_6(P3)` by Cauchy--Binet; the variety inclusions go in the
opposite direction.

## Exact bounded certificates

The verifier consumes:

```text
relation_matrix.npz             sha256 6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb
syzygy_r256_q0_contracted.npz   sha256 2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea
linear_syzygies.npz             sha256 f3787f317d851900de76da85ecb67018de5b48b0177d4e6e517634312f1c86a9
linear_syzygies_r48_reconstructed.npz
                                sha256 95fb1405584468b6e327fa36617f8daafd32e7630d29526f9d09ae5f3820d5e8
syzygy_r48_q0_contracted.npz    sha256 ba6d0533ab7fdb8bd93fb9309ce5b7d615f0a4799b22aa5e502e2dfec0bc21bb
syzygy_r96_q0_contracted.npz    sha256 7bfa9b41cabbb2446041ac0fb561b4fa6b35b5a7c00f7e843598de543878c979
```

It obtained the following exact facts over `F_89`.

1. The `M2` coefficient flattening has rank `690`.
2. `A(e_i)` has rank `27` for all 37 coordinate points.
3. `P3(e_i)` has rank `6` for all 37 coordinate points.
4. The following 15 contraction rows already have rank six at every
   coordinate point:

   ```text
   242,243,244,225,226,228,142,143,144,145,146,227,245,246,247.
   ```

5. On every coordinate line `P(span(e_i,e_j))`, both the full matrix `A`
   and this 15-row subsystem have full column rank at every geometric point.

For item 5, set `q=x e_i+e_j`.  A determinant of a constant `27 x 690`
row-compression of `A` has degree at most

```text
6*2 + 21*1 = 33
```

in `x`; a determinant of a constant `6 x 15` compression of the contraction
subsystem has degree at most 18.  The verifier interpolates each determinant
from respectively 34 or 19 distinct prime-field values and computes exact
polynomial gcds.  Two or three deterministic compressed minors have gcd one
on each of all `C(37,2)=666` lines.  Rank at the point at infinity is checked
separately.  Gcd one over `F_89[x]` excludes roots over the algebraic closure,
not merely `F_89`-rational roots.

It follows rigorously that any Stage B point has coordinate support at least
three.  This coordinate-dependent support bound does not imply emptiness.

The verifier also finds an invertible `256 x 256` coefficient minor using no
coordinate of the form `q_i^3 e_j`.  Therefore the constant row span of the
256 contractions contains none of the 222 pure vectors `q_i^3 e_j`.  This
rules out a degree-zero pure-power module certificate only; polynomial
multipliers and Fitting minors remain completely open.

## Why the old prefixes cannot decide Stage B

The underlying linear syzygies have the following common missing variables:

```text
first 43 rows in the r256 order: q4,...,q22
actual reconstructed r48 packet: q4,...,q11
first 96 rows in the r256 order: q4,...,q14
actual old r96 packet:            none
all 256 rows:                     none
```

Thus the 43-row equations vanish identically on
`P(span(q4,...,q22))`, the actual 48-row packet vanishes on
`P(span(q4,...,q11))`, and a hypothetical first-96 prefix of the current
r256 ordering would vanish on `P(span(q4,...,q14))`.  The actual saved r96
packet is the old 96-vector selection, uses every variable, and has no such
automatic coordinate-subspace survivor.  Thus the r43 and r48 saturated
ideals cannot be the unit ideal; their timeouts hid explicit
positive-dimensional false loci.  No analogous conclusion is claimed for
the actual r96 packet.

## The support-balanced 42-row artifact

`balanced42.npz` contains 15 actual contraction rows giving the coordinate
axis/line cover above, followed by 27 deterministic dense linear combinations
of all 256 rows.  The compression has exact rank 42 and its 42 polynomial rows
are independent.  Its hash is

```text
f2e2b22412a53fc81817ecba2e6f58001fd7320ca14c8e5534712374367c6226.
```

A `42 x 6` matrix has expected maximal-minor codimension
`42-6+1=37`, one more than `dim P^36`; so this is the smallest
boundary-format contraction system for which generic projective emptiness is
expected.  Expected codimension is not a proof.  The artifact is intended for
a determinantal resultant, exterior-power complex, or blocked Fitting
calculation, not a raw 43-variable F4 run.

## Misgraded `690 x 999` shortcut

Stage B cannot be encoded as decomposable tensors in the kernel of a
`690 x (37*(6+21)) = 690 x 999` coefficient matrix.  That construction would
make both the `b1` and `b2` blocks linear in `q`, whereas the sealed grading is

```text
b1 block: Sym^2(Q),  6*703 coefficients;
b2 block: Q,        21*37 coefficients.
```

A faithful one-`q` factorization has the form

```text
q tensor y,  y in (B1 tensor Q) + B2,
```

so its ambient tensor space has dimension

```text
37*(6*37+21) = 8991,
```

and one must additionally impose that the `B1 tensor Q` part of `y` is
`b1 tensor q` with the same `q`.  Dropping that compatibility is a safe
over-approximation, but its 690-row flattening has kernel dimension 8301.
There are `34,457,451` quadrics on that kernel, while a `37 x 243` rank-one
matrix supplies only

```text
C(37,2)*C(243,2) = 19,582,398
```

two-by-two minors.  Therefore the literal Stage-A strategy in which the
restricted minors span *all* quadrics is dimensionally impossible for this
faithful linearization.

## A second exact route and its size

Let

```text
M = coker(S(-3)^690 -> S(-1)^6 + S(-2)^21).
```

Its projective support is the exact Fitting locus `D`.  Surjectivity of the
degree-seven Macaulay map would be a sufficient global emptiness certificate.
Degree six cannot be surjective by dimensions:

```text
d=6: source 6,305,910; target 6,415,578.
```

The first dimensionally possible degree is seven:

```text
d=7: source 63,059,100; target 47,212,074.
```

This identifies an exact linear-algebra target, but the uncompressed matrix
is far outside a light-memory job.  A credible continuation is a blocked
Schur-complement or matrix-free rank certificate exploiting the rank-690
`M2` flattening, not construction of the raw matrix.

## Replay

From the goal-run directory:

```text
/opt/homebrew/bin/python3 -u P25_LANDING_SUPPORT/parallel/stageb_fitting/verify_stageb_fitting.py
```

The script rebuilds every stated rank and line gcd, recreates
`balanced42.npz`, and writes `result.json`.  Its exit marker is
`PASS_BOUNDED_NONVERDICT`.
