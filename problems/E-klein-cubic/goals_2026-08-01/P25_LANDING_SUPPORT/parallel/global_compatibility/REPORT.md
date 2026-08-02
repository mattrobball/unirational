# Full-global compatibility audit

## Outcome

```text
P25-UNDECIDED
```

No global Stage-B/Stage-C constant-rank or irrelevant-power certificate was
completed in this packet.  The smallest unresolved locus remains the part of
the Stage-B incidence with both `q`-support and `b1`-support larger than the
certified coordinate restrictions, together with Stage C away from the
certified `q`-coordinate lines.

This directory does contain three exact advances:

1. the augmented `[P4|P3]` contraction has rank seven over
   `algebraic_closure(F_89)` at every `q` with support at most two;
2. Stage B is empty globally in `q` when `b1` has support exactly one;
3. an immutable, direct `690 x 28` weighted degree-eight job is ready whose
   all-zero terminal result would prove the complete lower-presentation
   projective support empty and hence give the safe degree-25 emptiness route.

The terminal job was **not launched**.  The exact dual `b`-pencil criterion
described below was prepared but no Krylov rank was completed: one launch was
refused by the memory guard, and a later attempt stopped at an independent
inverse check before reaching a pencil matrix.  No finite-field point
sampling is promoted anywhere in this report.

## 1. Binding inputs

All calculations are over `F_89` and use:

| input | shape | SHA-256 |
|---|---:|---|
| full linear syzygy basis | `10767 x 690 x 37` | `3571e9879bf1af6d6a405d9761522d4253e76e40edd129afd4b9363287d60ca3` |
| full six-component P3 tensor | `10767 x 6 x 9139` | `93eb010020c7b808039243cd64aede54677c95f74c17efe8e3abb03c5dbf2019` |
| sealed 690-row relation matrix | `690 x 14134` | `6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb` |

The first two are the complete `10,767`-dimensional linear-syzygy contraction
space, not a selected row packet.

## 2. Exact augmented certificate on all q-coordinate lines

The previous `r43` and `r64` augmented packets both have rank only six on the
four axes `q4,q5,q6,q7`.  Thus they cannot certify even the coordinate points
for combined Stage B and Stage C.

A deterministic greedy extension by full-basis rows `8740` and `9490`
produces an `r66` packet with rank seven at all 37 axes.  On every one of the
666 coordinate lines, maximal-minor determinant polynomials of degree at most
22 were computed exactly.  Two to four stored determinants have gcd one:

```text
655 lines need 2 minors
  8 lines need 3 minors
  3 lines need 4 minors
```

Consequently the `66 x 7` matrix `[P4|P3]` has rank seven at every geometric
point of all 666 lines.  Equivalently, the combined Stage-B/Stage-C kernel is
empty whenever `q` has support at most two.  This is an algebraic-closure
statement from polynomial gcds, not an evaluation claim.

Artifacts:

```text
support_augmented_r66_stageBC.npz
sha256 b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84

augmented_coordinate_line_minors.npz
sha256 ec4230542e561878ed641ba2294abf8012130a9cd13774b92f33bd46c6ce7adc

verify_augmented_coordinate_lines_result.json
status PASS_INDEPENDENT_AUGMENTED_COORDINATE_LINE_REPLAY
```

Coordinate lines do not cover `P^36`; this result is not global emptiness.

## 3. Exact global-q exclusion when b1-support is one

For `j=0,...,5`, let

```text
A_j : Sym^3(F_89^37) -> F_89^10767
```

be the coefficient map of the `j`-th full P3 component.  Each `A_j` has exact
rank `9139`, witnessed by a stored `9139 x 9139` row minor.  Therefore it
remains injective after extending scalars to `algebraic_closure(F_89)`.

For every projective `q`, its cubic Veronese coefficient vector is nonzero.
Thus `A_j v_3(q)` is nonzero, proving

```text
P3(q)b1 != 0
```

whenever `b1` has exactly one nonzero coordinate.  This is global in `q` and
stronger than a point evaluation: each `A_j` is injective on the whole
9,139-dimensional polarized cubic coefficient space.

Artifacts:

```text
single_b_support_minors.npz
sha256 980c190eddb99404fa995fe1ee8a3be023decd2ef17b7291bff5053673d32081

verify_single_b_support_result.json
status PASS_INDEPENDENT_SINGLE_B_SUPPORT_REPLAY
```

This does not treat `b1`-support at least two and does not include P4.

## 4. Exact b-pencil criterion, prepared but not run

The dualization suggested by the six-component structure is substantially
smaller in projective dimension.  Put

```text
A(b) = b0*A_0 + ... + b5*A_5,
```

a `10767 x 9139` matrix linear on `P^5_b`.  A single row profile selected from
`A_0` gives invertible `9139 x 9139` pivot blocks in all six `A_j`; the exact
cross-profile ranks are

```text
[9139, 9139, 9139, 9139, 9139, 9139].
```

This is only an axis/common-profile preflight.

For a coordinate pencil `A_0*s+A_j*t`, constant invertible row and column
operations normalize the pair to

```text
A_0 = [I;0],   A_j = [T;U],   U has 1628 rows.
```

The transpose presents a graded cokernel on `P^1`.  Its homogeneous
degree-six Macaulay map is surjective if and only if the constant matrix

```text
[ U ; U*T ; U*T^2 ; ... ; U*T^5 ]
```

of shape `9768 x 9139` has rank `9139`.  Indeed the coefficient recurrence
eliminates the six pivot blocks and leaves exactly this controllability map.
If it has full rank, the cokernel's degree-six part is zero; since the
cokernel is generated in degree zero, every later part is zero.  Its
projective support is therefore empty, proving `rank A(b)=9139` at **every
geometric point of the pencil over the algebraic closure**.

This is a genuine polynomial-matrix/Macaulay criterion.  It does not inspect
the 89 rational values of `t`, and it is not vulnerable to the determinant
degree `9139` exceeding the field size.

`certify_b_star_lines.py` implements this exact criterion on the five lines
`P<e_0,e_j>`.  The first launch stopped at its pre-allocation resource guard:

```text
resource guard: free+speculative=0.07 GiB < 6
```

A later guarded attempt reached the common pivot inversion, but stopped when
the independent inverse-product check failed, before any block-Krylov matrix
was formed.  The inverse path was then changed to in-place FFLAS with
integer-rounded modular verification.  Shared memory fell below the 6-GiB
guard before the corrected script could be rerun.  Hence
`b_star_line_job.json` is `PREPARED_NO_COMPLETED_CERTIFICATE`; no line theorem
beyond the already certified axes is claimed here.  Even five passing
star-line certificates would cover only five lines, not `P^5`, so they would
remain partial Stage-B progress.

There is also a binding size floor for the most direct global-`P^5` Macaulay
route.  With `R=F_89[b0,...,b5]`, the transpose map is

```text
R(-1)^10767 -> R^9139.
```

Surjectivity in target degree `d` is dimensionally impossible before `d=29`:

```text
d=28: source 2,168,215,392 < target 2,169,013,704
d=29: source 2,555,396,712 > target 2,542,981,584.
```

Thus the naive full-`P^5` Macaulay matrix first becomes possible only at
degree 29 and has more than 2.5 billion rows/columns on each side.  This is a
resource floor, not an obstruction theorem and not a substitute for a
structure-exploiting Fitting or representation certificate.

## 5. Direct terminal lower-presentation job

Let

```text
F = S*e0 + S(-1)^6 + S(-2)^21,
S = F_89[q0,...,q36].
```

The 690 sealed generators all have weighted degree three.  In weighted degree
`d`, the direct presentation has source dimension

```text
690 * dim S_(d-3)
```

and target dimension

```text
dim S_d + 6*dim S_(d-1) + 21*dim S_(d-2).
```

Degree eight is the first dimensionally possible full-surjectivity degree:

| d | source | target |
|---:|---:|---:|
| 3 | 690 | 14,134 |
| 4 | 25,530 | 160,987 |
| 5 | 485,070 | 1,489,657 |
| 6 | 6,305,910 | 11,661,364 |
| 7 | 63,059,100 | 79,436,188 |
| 8 | 517,084,620 | 480,738,817 |

`direct_full690_all28_degree8.sing` computes one bounded standard basis and
then reduces all 1,036 targets

```text
q_i^8 e0,
q_i^7 e_j   (1 <= j <= 6),
q_i^6 e_j   (7 <= j <= 27),
0 <= i < 37.
```

If and only if a completed immutable result ends in

```text
status=ALL_TARGETS_COMPLETE,total=1036,passed=1036,all_member=1
```

all those displayed pure powers have been proved members of the direct
690-row lower module.  On every standard chart `D_+(q_i)`, `q_i` is
invertible, so all 28 module generators vanish after localization.  The
projective support of `F/N_0` is empty.  Because this lower quotient surjects
onto the true 746-row landing quotient, the true special landing support is
empty without needing exact T-closure.

Zero reduction is an exact membership proof even if the degree bound leaves
the computed set short of a complete all-degree standard basis: every reducer
lies in `N_0`.  Conversely, any nonzero remainder, timeout, crash, or missing
terminal marker is a nonverdict.

```text
direct_full690_all28_degree8.sing
bytes  116165074
sha256 857621471324b6b650a3466625668b5333bc1665e8f531c8b4cf19b54284c49f

verify_full28_degree8_job_result.json
status PASS_IMMUTABLE_FULL28_DEGREE8_JOB_REPLAY
```

The 116-MB generated script exceeds GitHub's single-file limit and is locally
ignored; `produce_full28_degree8_job.py` reconstructs it byte-for-byte from
the sealed 7.3-MB relation packet.  The producer and independent preparation
replay bind its exact hash and all 1,036 target statements.

A smaller direct Stage-B precursor was also prepared:

```text
direct_690_all_222_degree5.sing
bytes  29901754
sha256 d013d3dffdd573c93c384beaccbd5f682510bc2cc95c6dabf620d3ffdb1f1f24

verify_all_pure_power_job_result.json
status PASS_IMMUTABLE_ALL_222_JOB_REPLAY
```

It tests the 222 targets `q_i^5 e_j` in the six M1 components.  It was not
launched either.

The tiny `singular_weighted_syntax_smoke.sing` ran in under one second and
validated the weighted `isHomog`, `degBound`, reduction, and append-result
syntax.  It is not a mathematical membership result.

## 6. Replay

From this directory, the completed exact certificates replay with:

```bash
/opt/homebrew/bin/python3 produce_augmented_coordinate_lines.py
/opt/homebrew/bin/python3 verify_augmented_coordinate_lines.py
/opt/homebrew/bin/python3 certify_single_b_support.py
/opt/homebrew/bin/python3 verify_single_b_support.py
/opt/homebrew/bin/python3 explore_b_pencil_profiles.py
/opt/homebrew/bin/python3 produce_all_pure_power_job.py
/opt/homebrew/bin/python3 verify_all_pure_power_job.py
/opt/homebrew/bin/python3 produce_full28_degree8_job.py
/opt/homebrew/bin/python3 verify_full28_degree8_job.py
```

The b-pencil calculation is deliberately deferred until at least 6 GiB of
free plus speculative memory is available:

```bash
/opt/homebrew/bin/python3 -u certify_b_star_lines.py
```

The heavy terminal job is deliberately deferred until the shared heavy slot
is released.  Its immutable manifest records the bounded command.  It must
not be interpreted unless the terminal marker and all 1,036 positive
membership records are present.

## 7. Theorem boundary

Proved here:

- exact augmented rank seven for all `q`-support-at-most-two points;
- exact Stage-B exclusion for `b1`-support exactly one, globally in `q`;
- exact input construction and replay for two unlaunched weighted-module
  jobs;
- an exact algebraic-closure b-pencil criterion, implemented but unrun.

Not proved here:

- constant rank of `A(b)` on all of `P^5`;
- Stage B for `b1`-support at least two;
- Stage C for arbitrary `q`;
- empty lower-module or true landing support;
- `P25-DEGREE25-EMPTY` or a characteristic-zero covariant.
