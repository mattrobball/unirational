# Stage-B structural audit

## Outcome

This investigation does **not** decide Stage B and produces no landing
candidate.  It does, however, identify why every earlier 43/48/96-row boundary
saturation was incapable of returning the unit ideal, and it supplies a smaller
43-row replacement without those certified false coordinate components.

The strongest new exact geometric statement is:

> For the replacement necessary-equation subsystem, the `43 x 6` cubic matrix
> has rank six at every point of every coordinate line in `P^36` over the
> algebraic closure of `F_89`.  Consequently the original Stage-B incidence has
> no point whose `q` vector has support at most two.

Coordinate lines do not cover `P^36`; this is not a global emptiness theorem.

All generated work is contained in this directory.

## Bound inputs

The main replay binds the following immutable inputs:

| Input | SHA-256 |
|---|---|
| `certificates/degree25_finite_module/relation_matrix.npz` | `6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb` |
| `linear_syzygies.npz` (current 256 packet) | `f3787f317d851900de76da85ecb67018de5b48b0177d4e6e517634312f1c86a9` |
| `linear_syzygies_r48_reconstructed.npz` | `95fb1405584468b6e327fa36617f8daafd32e7630d29526f9d09ae5f3820d5e8` |
| `syzygy_r48_q0_contracted.npz` | `ba6d0533ab7fdb8bd93fb9309ce5b7d615f0a4799b22aa5e502e2dfec0bc21bb` |
| `syzygy_r96_q0_contracted.npz` | `7bfa9b41cabbb2446041ac0fb561b4fa6b35b5a7c00f7e843598de543878c979` |
| `syzygy_r256_q0_contracted.npz` | `2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea` |

The old 96-row contraction was made from the old 96-vector syzygy packet, not
from the first 96 vectors of the later 256 packet.  The recovery artifact's
`old_syzygies` array is therefore used when auditing r96.

## 1. Exact systematic structure of `M2`

Flattening the 21 linear `b2` columns gives an exact `690 x 777` matrix of rank
690.  After explicit row and tensor-coordinate permutations it is

```text
[ I_690 | A_690x87 ].
```

The 87 nonpivot tensor coordinates are exactly

```text
(q0,q1,q2,q3) * b2_j       for j=0,...,20,
q4 * b2_j                  for j=0,1,2.
```

This is useful for pivot-adapted chart elimination, but it is not a block
decomposition.  The tail `A` has 59,375 nonzero entries; every row has 82--87
nonzeros, every column has 674--689 nonzeros, and its bipartite support graph is
connected.  Thus the obvious RREF decomposition leaves one dense coupled block.

The other graded blocks are equally nondegenerate in linear-algebra terms:

- the pure-q cubic block has rank `690/690`;
- each of the six quadratic `b1` blocks has rank `690/690`;
- each of the 21 linear `b2` blocks has rank `37/37`.

No coordinate block or exact linear row redundancy emerged from this audit.

## 2. Grading guard against a false `690 x 999` flattening

On `b0=0`, the six `b1` columns are quadratic in `q`, while the 21 `b2`
columns are linear.  Their honest coefficient storage has

```text
6*C(38,2) + 21*37 = 6*703 + 21*37 = 4995
```

columns.  It is not a `690 x (37*27) = 690 x 999` linear flattening.  One may
factor a quadratic term formally as `q tensor (q tensor b1)`, but the second
factor is constrained to contain the same `q`; treating it as an arbitrary
27-vector changes the incidence.  Therefore the Stage-A rank-one-kernel test
cannot be copied to a `37 x 27` tensor without an additional exact
factorization theorem, which the data contradict by nonzero `P3` contractions.

## 3. Exact obstruction in the old sparse packets

If every selected syzygy `C(q)` has zero coefficient in a set of q directions,
then all its `P3` and `P4` contractions vanish on the corresponding projective
coordinate space.  Both irrelevant ideals are nonzero there, so projective
saturation cannot remove that component.

The replay checks the stored polynomial coefficients, not just syzygy support:

| Packet | Certified retained false locus / defect | Consequence |
|---|---|---|
| old r43 | all contractions vanish on `P<q4,...,q12> x P^5_b1` | boundary saturation cannot be unit |
| old r48 | all contractions vanish on `P<q4,...,q11> x P^5_b1` | boundary saturation cannot be unit |
| old r96 | at `q=e5`, `P3(e5)` has rank 3, leaving a `P^2_b1` kernel | boundary saturation cannot be unit |
| current 256, 43 sparsest | all contractions vanish on `P<q4,...,q22> x P^5_b1` | pure global sparsity selection cannot be unit |
| current r256 | `P3(e_i)` has rank 6 for every `i` | no forced coordinate-point defect detected |

For r43 and r48, the same support calculation also forces `P4=0` on the listed
q-space, so those packets cannot decide the `b0=1` chart either.

This upgrades the interpretation of the old runs: their missing unit result was
not merely a resource issue.  Their exact input ideals contain explicit
projective components.

## 4. Linear independence of the 256 contractions

Over `F_89`, exact FFLAS ranks are:

```text
rank(256 equation rows in 6*Sym^3(Q)^*) = 256,
rank(all 256*6 individual cubic forms)  = 1536,
rank(each of the six cubic blocks)       = 256.
```

Thus no linear row combination can reduce the number of independent retained
equations.  Sparse combinations may reduce term count, but a selection based
only on term count creates the false coordinate components above.

## 5. Replacement support-cover r43 packet

`support_cover_r43_stageB.npz` (SHA-256
`89a6d9feab7d08cdbd6b9ba68853fc7a7d041d2057c1c51982aa3c7ad42b7779`)
contains 43 rows selected from the current verified 256 packet.  The producer
and independent verifier establish:

- every selected `C(q)M2(q)=0` identity directly;
- every selected `P3` coefficient rebuilt from the sealed 690 relations;
- union of q-coefficient support is all 37 directions;
- the 43 equation rows have rank 43;
- each of the six cubic blocks has rank 43;
- `P3(e_i)` has rank 6 for all 37 coordinate points;
- the original uncontracted `b0=0` 690-by-27 matrix has rank 27 at all 37
  coordinate points.

Within the **current 256-vector packet**, at least 15 rows are necessary merely
to have rank six at every coordinate point:

1. only 16 packet rows see `q4`, so six of them are required at `e4`;
2. only 14 disjoint packet rows see `q5`, so six more are required at `e5`;
3. the entire q4 family has rank zero at `e6`, and the entire q5 family has rank
   only three there, so at least three further rows are required.

The stored 15-row coordinate cover attains this lower bound.  Twenty-eight
additional cheapest rows bring the system to the dimensionally plausible 43
equations.  It has 1,880,133 expanded `P3` terms, only `1.08358` times the
1,735,114 terms of the unusable current “43 sparsest” subsystem.

This 15-row lower bound is relative to the stored 256-vector packet; it is not a
claim about all 10,767 systematic nullspace vectors.

## 6. Exact exclusion on all coordinate lines

For every pair `0 <= i < j <= 36`, restrict the replacement cubic matrix to

```text
q = e_i + t e_j.
```

Every matrix entry has degree at most three in `t`, so a maximal minor has
degree at most 18.  `certify_coordinate_lines.py` reconstructs each chosen
minor from 19 exact evaluations and checks it at a twentieth point.  It finds:

```text
639 lines: two maximal minors have gcd 1,
 27 lines: three maximal minors have gcd 1.
```

Rank six at the point at infinity is checked separately.  A unit gcd in
`F_89[t]` has no root over the algebraic closure, so this proves rank six at
every point of all 666 coordinate lines.  The compact minor artifact is
`coordinate_line_minors.npz`, SHA-256
`bd7cfad5c7e5f3638ae830b9b81c84cab06ae9f0fd81a06d235a61545b087a23`.

This is an exact exclusion of q-support one and two, not sampling.  It says
nothing about support at least three.

## 7. Symmetry audit

No valid PSL(2,11) chart reduction is present in the sealed packet.  The group
equivariance has already been imposed when constructing the covariant
multiplicity space; the scalar coefficient parameters `q_i` are coordinates
on that multiplicity space, not the original five-dimensional group
representation.  The RREF basis also has no sealed permutation action on its
37 coordinates.

Accordingly, a finite collection of q charts cannot be declared exhaustive by
PSL symmetry without first supplying an explicit action on this 37-space and
checking covariance of all 690 relations.  This audit does not rule out some
other automorphism of the presentation; it finds no certified one to use.

## 8. Deferred global-nullspace selection

Reconstructing all 10,767 FFLAS systematic basis columns while the shared exact
Singular job was live was intentionally avoided.  The unavoidable resident
arrays already include approximately:

```text
14763*25530 doubles = 2.81 GiB,
25530*10767 doubles = 2.05 GiB,
the uint8 coefficient matrix = 0.35 GiB,
```

before FFLAS workspace.  More importantly, the exact support audit shows that
“globally sparsest” is the wrong objective by itself.  Any future full-basis
selection should minimize contracted `P3` terms subject to:

1. all 37 q directions represented;
2. rank six at every coordinate point;
3. preferably the coordinate-line unit-gcd tests;
4. 43 independent equation rows.

## 9. Prepared exact CAS job

`produce_support_cover_singular.py` writes
`support_cover_r43_boundary.sing`:

```text
bytes:   31,351,466
SHA-256: 2bb07c31711ece9a73974e29abfbc8565b6367cebfc58af62800d712f6d90f8b
```

It performs exact sequential saturation first by the b1 irrelevant ideal and
then by the q irrelevant ideal.  The job was **generated but not launched**
while the shared controlled r256 Singular process occupied the exact-CAS slot.

A returned unit would prove the selected necessary-equation Stage-B scheme
empty and hence Stage B empty.  Nonunit, timeout, crash, or missing output would
not prove a point of the original incidence.

## Replay

```text
/opt/homebrew/bin/python3 -u analyze_structure.py
/opt/homebrew/bin/python3 -u verify_structure.py
/opt/homebrew/bin/python3 -u certify_coordinate_lines.py
/opt/homebrew/bin/python3 -u verify_coordinate_lines.py
```

The completed replays end respectively with:

```text
PASS: exact Stage-B structural audit
PASS: independent Stage-B structural replay
PASS: all 666 q-coordinate lines have contraction rank six
PASS: replayed 666 coordinate-line unit-gcd certificates
```

## Theorem boundary

Proved exactly here:

- the stated systematic `M2` decomposition and absence of a sparse block split;
- explicit positive-dimensional defects in old r43/r48 and a coordinate-point
  defect in old r96;
- a verified 43-row replacement without coordinate-point defects;
- no Stage-B point with q-support at most two.

Not proved here:

- unit saturation of the replacement r43 or full r256 system;
- Stage-B emptiness for q-support at least three;
- Stage C emptiness;
- a point of the full 690- or 746-equation landing scheme;
- degree-25 emptiness or a characteristic-zero covariant.

The global goal therefore remains undecided.
