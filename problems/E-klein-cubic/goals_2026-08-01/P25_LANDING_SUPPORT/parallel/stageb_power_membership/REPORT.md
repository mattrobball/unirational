# Stage-B pure-power membership: exact low-memory investigation

## Outcome

**PURE-POWER MEMBERSHIP UNDECIDED.**

No identity

```text
C(q) M2(q) = 0,
C(q) M1(q) = q_i^5 e_j
```

was proved, and no exact dual cokernel functional was found that disproves one.
Consequently this directory gives no Stage-B emptiness verdict.  In particular,
the nonzero axis-0 border remainder below is a **nonverdict**, not a
nonmembership certificate.  Exponent six was not tested because exponent-five
failure was not established exactly.

All arithmetic below is exact over `F_89`; no sampling result is used as a
verdict.

## Sealed inputs

- Full cubic contraction tensor: sibling
  `../stageb_global_basis/full_p3_contractions.npy`, shape
  `(10767,6,9139)`, SHA-256
  `93eb010020c7b808039243cd64aede54677c95f74c17efe8e3abb03c5dbf2019`.
- Direct mixed-module source:
  `/Users/worker/unirational/problems/E-klein-cubic/certificates/degree25_finite_module/relation_matrix.npz`,
  SHA-256
  `6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb`.

## Exact affine filtration

On the chart `q_i=1`, the 54,834 columns of the P3 tensor split by degree in
the other 36 variables as follows (all six output components included):

| exact outside degree | columns | cumulative columns |
|---:|---:|---:|
| 0 | 6 | 6 |
| 1 | 216 | 222 |
| 2 | 3,996 | 4,218 |
| 3 | 50,616 | 54,834 |

`analyze_affine_profiles.py` computed exact ranks of the three cumulative low
blocks for axes `0,4,5,12,20,36`.  Every tested axis has ranks

```text
6, 222, 4218.
```

These are exact facts for the six tested axes, but they do not imply the same
profile for the other 31 axes and do not decide any pure-power membership.
The complete hashes and timings are in `affine_rank_profiles.json`.

## Exact axis-0 normalized border

For axis zero, `produce_affine_border.py` selected 4,218 P3 rows whose low
block is invertible and checked the full product

```text
inverse * selected_low_minor = I_4218  over F_89.
```

Multiplying the selected rows by this inverse gives 4,218 normalized rules,
each consisting of one affine module monomial of degree at most two plus a
pure affine-cubic tail.  The tail matrix has shape `(4218,50616)`.

Key artifacts are:

| artifact | SHA-256 |
|---|---|
| `axis0_selected_rows.npy` | `9399ceda054a7c6e49ab856f4bb8e77a2ee3cee2ede152ac78621fa3c5ba60ee` |
| `axis0_low_inverse.npy` | `39f65bd254787b16b887126f579a611a4e4c008df4324f0c1f026a78b531707f` |
| `axis0_border_tails.npy` | `badcbf56207481ba5350f1547d7a88aec3ed846ce0e672f3ba4f1f56e006f25d` |
| `axis0_border_packet.npz` | `147306837c5077d6b917a8d6392ff43297fecc4faf12254153e09a8a05c41aa2` |

The canonical tail-data SHA-256 is
`1d139e8fc969a177e3e64b9525560d35202dd12abfa5d41b2652784e41d55eb6`.

`verify_affine_border.py` is an independent implementation: it imports
neither producer nor reducer, reconstructs the affine monomial partition from
the sealed P3 tensor, verifies the selected inverse, and recomputes all 50,616
tail columns in bounded chunks.  Its successful record is
`verify_affine_border_result.json`, status
`PASS_EXACT_BORDER_NONVERDICT_REPLAY` (46.449687 seconds).

### Deterministic reduction of one target

`reduce_affine_border.py --axis 0 --component 0` dehomogenizes `q0^5 e0` to
the constant target `e0` and eliminates affine degrees zero through four with
the normalized border rules.  It used 529,886 nonzero normalized-rule
coefficients.  The terminal pure degree-five vector has length 3,948,048 and

```text
nonzeros = 3,879,712
SHA-256 = bc38ad975f5da24460257426fa71474104aa14150887ede93ef61dd11470a0d9.
```

The result packet `axis0_border_reduction.npz` has SHA-256
`ef3111f516522558d1f8920dad6e711c62421c7d350be14a47c5ac16ad3270f2`.
The independent verifier byte-binds this packet and confirms the nonzero count
and terminal digest; the deterministic reducer itself is the replay of the
reduction identity.

This nonzero remainder is not a dual witness.  The 10,767 original rows have a
4,218-dimensional low projection, leaving a 6,549-dimensional coefficient
kernel.  Its combinations have zero normalized low part and pure-cubic
remainders (the remainder vectors themselves need not be independent).  Their
degree-two prolongations, together with terminal relations arising from
border overlaps/ambiguities, can still kill the displayed degree-five vector.
Those terminal relations were not fully constructed or quotiented.

## Direct combined M1/M2 test

`produce_direct_module_singular.py` encoded the 690 rows directly as a
homogeneous submodule of a 27-component free module:

```text
component weights: 0^6, 1^21
term order:         global (dp,C)
degree bound:       5
target:             q0^5 * gen(1)
criterion:          reduce(target,std(N)) == 0.
```

Thus a completed run was designed to give an exact membership result for
`(q0^5,e0)` without first materializing the 6.3-million-column mixed Macaulay
map.  The generated 29,830,987-byte script has SHA-256
`2394fd6136f4f8c3c3266513e8db516019fa38f257952115f4a04271ac67b65c`.

The bounded run stopped at the wall-time fence while Singular was still
computing the standard basis:

```text
wall limit:       300 s
elapsed:          300.066322 s
RSS limit:        8,589,934,592 bytes
peak polled RSS:  1,281,376,256 bytes
stop reason:      timeout
return code:      -9
result file:      absent
```

The log has SHA-256
`c0ec66a7a03af58bbbc6ecabe80194f3ae08b14c55b62cbd98e7b71e3502ecd8`.
`direct_axis0_component0_degree5.run.json` is the authoritative run record;
the earlier `direct_axis0_component0_degree5.json` is only the preparation
manifest.  Timeout is an exact resource observation and a mathematical
nonverdict.

## Corrected adjoint boundary

The theory packet's number `109,668` is only the rigorous dimension lower
bound

```text
dim(S_5^6) - dim(ker(mu_3))
= 4,496,388 - 4,386,720
= 109,668
```

for the degree-five contraction cokernel.  It is not a proved exact cokernel
dimension.  Although

```text
109,668 = 13 * 8,436 = 13 * dim Sym^3(F_89^36),
```

this numerology does not prove a `13 tensor Sym^3` decomposition or any fixed
13-dimensional residual factor.

In the affine adjoint filtration the top variables `(U4,U5,V4)` satisfy the
coupled equations

```text
A2^T U4 = 0                                      at domain degree k=2,
A1^T(U4,V4) + A2^T U5 = 0                       at domain degree k=3.
```

The second equation couples the would-be top layer to `(U4,V4)`.  Therefore a
count using only the `k=3` part does **not** produce an automatic
347,985-dimensional kernel.  No such kernel dimension is asserted here.

## What an exact next test must do

The smallest route exposed by this run is an affine Schur-complement test,
not another full Macaulay matrix:

1. Normalize the 6,549 nonselected P3 rows against the 4,218 exact border
   pivots, obtaining the full pure-cubic residual block.
2. Build the degree-five terminal relation operator from its quadratic
   prolongations and every border-overlap relation, while applying it as a
   sparse or black-box map rather than storing the full matrix.
3. Solve against the six terminal remainders for one chart.  A lift gives an
   exact membership witness; an exact left-null vector pairing nontrivially
   with a target gives a nonmembership certificate.
4. Repeat for all required chart/component orbits only after the orbit
   reduction itself has been proved.  The six rank profiles above are not an
   orbit proof.

Until that quotient is computed, exponent five has neither passed nor failed,
so exponent six is not logically triggered.

## Replay

From this directory:

```text
/opt/homebrew/bin/python3 -u analyze_affine_profiles.py
/opt/homebrew/bin/python3 -u produce_affine_border.py --axis 0
/opt/homebrew/bin/python3 -u reduce_affine_border.py --axis 0 --component 0
/opt/homebrew/bin/python3 -u verify_affine_border.py
```

The independent verifier ends with

```text
"status": "PASS_EXACT_BORDER_NONVERDICT_REPLAY"
```

The already-recorded bounded direct invocation was

```text
/opt/homebrew/bin/python3 -u run_bounded_singular.py \
  direct_axis0_component0_degree5.sing --timeout 300 --rss-gib 8
```

Rerunning it will overwrite its log and run record; the sealed hashes in this
report describe the completed 300-second attempt above.
