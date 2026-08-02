# PC.2 structural audit: the sharp next gate

Status: `PC2-STRUCTURAL-NEXT-GATE-SCOPED`. Global status remains
`PC-UNDECIDED`.

This audit stops the light structural branch. The existing 43-, 64-, and
412-row contraction packets do not support a low-degree raw Macaulay proof or
the direct pure-term leading-module shortcut. There is an exact Schur
compression, but that particular route becomes safe only after proving the
still-open global Stage-B minor cover.  A direct global module-surjectivity
certificate would be an alternative decisive route.

## 1. Exact grading and the Macaulay obstruction

Let

```text
S = F_89[q_0,...,q_36],
M = [P4 | P3_0 | ... | P3_5],
F = S e_0 direct_sum S(-1)^6.
```

Each augmented row is homogeneous of shifted degree four. For `r` rows, the
degree-`D` source and target dimensions are therefore

```text
r binom(D+32,36),
binom(D+36,36) + 6 binom(D+35,36).
```

The first degree in which source dimension is even large enough for
surjectivity is:

| rows | last impossible `D` | first dimensionally possible `D` |
|---:|---:|---:|
| 43 | 48 | 49 |
| 64 | 37 | 38 |
| 412 | 16 | 17 |
| 10,767 (comparison) | 6 | 7 |

At the boundary, for example, the 43-row source has dimension
`3,112,158,316,800,631,348,377,400` at `D=48`, below the target dimension
`3,178,364,408,308,673,090,709,930`. The 64-row and 412-row failures at their
last impossible degrees are recorded exactly in the JSON ledger.

Consequently no irrelevant-power certificate whose proof is raw homogeneous
module surjectivity can start below these bounds. Equality or surplus after
the threshold is only a necessary dimension condition, not evidence of
surjectivity.

Every maximal `7 x 7` minor has degree

```text
4 + 6*3 = 22.
```

Thus there is also no literal constant unit minor over `S`. This does not
exclude a unit after chart normalization or localization.

## 2. Exact obstruction to the generator-degree pure-term shortcut

The earlier exact LT packet, with its own separate replay, exhibits a
non-pure-coordinate square minor of the full degree-three `P3` contraction
matrix of rank `10,767`.  The present verifier imports that hash-bound fact;
it does not independently rebuild the 563 MB full matrix or rerun the
historical 10,767-rank replay.  The imported result implies that projection
of the entire contraction row space away from the 222 pure cubic module
coordinates is injective.

The verifier here additionally extracts the union of the actual selected
families from the full `P3` memmap and recomputes its non-pure projection
rank:

```text
r43 subset r64,             64 rows
independent r412 selection, 412 rows
union,                      476 rows
non-pure projection rank,   476
```

Therefore no nonzero constant combination of any selected augmented rows can
be supported only on pure shifted monomials. In particular, under any fixed
admissible shifted module order, the absolute least degree-four term cannot
be obtained as the leading term of a pure generator-degree row. This blocks
the direct degree-four LT/unit-monomial cover proposed for these packets.

This statement does not exclude higher-degree polynomial combinations or
S-polynomials.

## 3. The safe Schur complement and why it does not bypass Stage B

Write `M=[u|A]`, where `u=P4` and `A=P3`. Choose six rows `I` and put

```text
Delta_I = det(A_I).
```

On the open chart `D(Delta_I)`, the six equations indexed by `I` solve
uniquely for `b_1` in terms of `b_0`. For every additional row `a`, define

```text
sigma_{I,a}
  = Delta_I u_a - A_a adj(A_I) u_I.
```

The block determinant identity gives, with rows ordered as `I` followed by
`a`,

```text
det(M_{I union {a}}) = sigma_{I,a}.
```

Both sides have degree 22. Hence on `D(Delta_I)`, `M` has rank seven exactly
when at least one `sigma_{I,a}` is nonzero.

This yields a safe finite route:

1. Certify that finitely many `Delta_I` cover `P^36`, equivalently that `P3`
   has rank six at every projective `q`.
2. On each `D(Delta_I)`, certify that the simultaneous Schur numerators have
   no zero; one replayable form is an identity
   `Delta_I^k in <sigma_{I,a}: a notin I>`.

Step 1 is exactly the unresolved global Stage-B problem. If `rank(P3)<6`,
then `rank([P4|P3])<=6`, so no Schur chart can discard that locus. The
412-row coordinate-plane packet proves the cover only for `q` of coordinate
support at most three (all 7,770 coordinate `P^2`s); it supplies no global
minor cover.

## 4. Constant row compression boundary

For a constant row compression `R`,

```text
rank(RM) <= rank(M).
```

Thus emptiness of the rank-drop locus of `RM` is a decisive sufficient
certificate, while a nonempty compressed locus is only an over-approximation
and does not produce a point of the original locus.

The determinantal height theorem gives the exact upper bound

```text
height I_n(an r x n matrix) <= r-n+1
```

when the maximal-minor ideal is proper. An empty homogeneous projective locus
in `P^36` has radical equal to the irrelevant ideal, of height 37. Therefore:

```text
P3, an r x 6 matrix:       r-5 >= 37, hence r >= 42;
M,  an r x 7 matrix:       r-6 >= 37, hence r >= 43.
```

Thus `r42` is the smallest row count for a global Stage-B `P3` minor cover
that is not ruled out by the height bound, and the existing `r43` packet is
the smallest constant compression not ruled out for augmented rank-drop
emptiness.  This is a necessary row bound, not an existence or emptiness
proof for either packet.

## Next gate for the Schur route and stop rule

The sharp next exact gate for the Schur-chart route is a global Stage-B
certificate: a small finite list of `6 x 6` minors of `P3` whose ideal
contains an irrelevant power.  After that, PC.2 can use the degree-22 Schur
numerators chart by chart.  This is not the only possible global route: a
completed direct certificate `dim(S^7/N)=0` for the augmented module would
decide both stages without first materializing a minor cover.

The prepared 72 MB (`r43`) and 105 MB (`r64`) Singular jobs were not launched.
Their raw module route begins far beyond a light degree.  Prior affine
resource nonverdicts and the dimension thresholds make them poor
low-resource experiments, but a completed exact run would be decisive rather
than merely duplicating old work.  The dimension counts alone are not runtime
infeasibility estimates.

Replay:

```text
python3 P25_COV_SUPPORT/verify_pc2_structural_next_gate.py
```

Expected terminal lines:

```text
PASS_PC2_STRUCTURAL_DIMENSION_OBSTRUCTION
PASS_PC2_SELECTED_NONPURE_PROJECTION_RANK_476
PASS_PC2_SCHUR_GATE_SCOPED
```

No global Stage-B/Stage-C emptiness, projective support decision, modular
survivor, characteristic-zero statement, transition stabilization, or Problem
E headline follows from this audit.
