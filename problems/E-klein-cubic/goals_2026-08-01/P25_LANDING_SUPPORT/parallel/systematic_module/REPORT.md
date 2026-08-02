# Exact systematic-module route and affine preflight

## Outcome

This packet establishes exact pivot-adapted term orders for the sealed 690-row
direct module, computes exact streamed degree-three pivot profiles, and stores
a complete compact degree-four Macaulay schedule.  It also prepares immutable
Singular jobs for both requested target sets.  It does **not** complete the
degree-four coefficient reduction or either standard-basis computation, and
does **not** prove Stage B, Stage C, or P25 emptiness.

The separately requested all-690 affine msolve preflight on
`q0=1, b1_0=1` is a strict timeout/nonverdict.  Consequently no affine flag
batch was started.

All work is confined to this directory.

## Binding source

The sole equation source is

```text
/Users/worker/unirational/problems/E-klein-cubic/certificates/degree25_finite_module/relation_matrix.npz
SHA256 6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb
```

It contains the sealed 690 residual rows over `F_89`, with blocks of sizes

```text
9139, 6*703, 21*37
```

for `M0`, `M1`, and `M2` respectively.

## 1. Exact affine msolve preflight

`produce_affine_msolve.py` substitutes

```text
q0 = 1,  b1_0 = 1
```

directly into all 690 equations

```text
M1(q)b1 + M2(q)b2 = 0.
```

No syzygy contraction or row sampling is used.  The resulting system has 62
variables

```text
b2_0..b2_20, b1_1..b1_5, q1..q36
```

and 2,937,661 nonzero printed terms.  The immutable input is

```text
affine_q0_b1_0_all690.ms
bytes  41,903,831
SHA256 14467ceed6e1e8ba991e25a0aebf8fe8cf1f6646dc8cb07ebf9481b06c63b5e3
```

The exact msolve 0.10.1 run used four threads, seed `2026080189`, and hard
fences of 600 seconds and 8 GiB.  It completed the degree-3 F4 round

```text
690 x 4779, 688 new rows, 0 zero reductions
```

and was still reducing the degree-4 matrix

```text
28808 x 83099, density 4.87%
```

when the wall fence killed it.  Exact resource record:

```text
elapsed_seconds       600.161296
peak_rss_bytes_polled 3172761600
returncode            -9
stop_reason           timeout
leading_output_bytes  0
unit_ideal            false
```

This is not a nonunit certificate: msolve emitted no completed leading ideal.
It is a nonverdict even for this one chart.  A unit here would in any event
have covered only `D(q0) intersect D(b1_0)`; it would not alone have covered
the other q/b1 flags.

## 2. Systematic M2 decomposition

Write

```text
M2[a,j,u] = coefficient of q_u in row a, b2 component j.
```

Flattening `(j,u)` gives a `690 x 777` matrix.  Exact reconstruction finds 690
singleton columns and 87 dense columns.  After only a row permutation and the
corresponding column grouping, the matrix is

```text
[ I_690 | T_690x87 ].
```

The 87 free coordinates are precisely

```text
q0,q1,q2,q3,q4 in b2_0,b2_1,b2_2;
q0,q1,q2,q3    in b2_3,...,b2_20.
```

The tail has 59,375 nonzero entries.  The compressed exact packet
`systematic_m2_decomposition.npz` has SHA256
`b3d9469f35b64436404053012d34c032fc16c0f3c9c1363446d8604f1f3c119d`.

## 3. Why the ordinary module order misses the pivots

In the Stage-B direct module the six `M1` entries are quadratic and the 21
`M2` entries are linear.  Therefore ordinary `(dp,C)` makes an `M1` term lead
before an `M2` term; the systematic coefficient minor by itself is not a
valid leading-term claim.

A component-first order does not repair this.  The tail `T` couples all 21
`b2` components, so a position-over-term order makes some dense free-coordinate
term lead in most rows.

## 4. Exact homogenized embedding

For component weights `w_j`, introduce one variable `h` and define

```text
iota_w(p(q)e_j) = h^w_j p(q)e_j.
```

For Stage B the weights are `[0^6,1^21]`; for the full 28-component module
they are `[0,1^6,2^21]`.  Thus every transformed input row has ordinary degree
2 or 3 respectively.

This embedding preserves every tested membership in both directions:

- an `S`-linear witness applies under `iota_w` unchanged; and
- any `S[h]`-linear witness specializes at `h=1` to a witness in the original
  direct module.

So this is an exact reformulation, not a relaxation or a one-way implication.

Use degree lexicographic order `(Dp,C)` with variables

```text
h, q5,q6,...,q36, q4, q0,q1,q2,q3.
```

All row terms have the same ordinary degree.  The order first maximizes the
power of `h`, so an `M2` term precedes every `M1`/`M0` term.  Within `M2`, every
pivot with `q5..q36` precedes every free coordinate.  For a `q4` pivot, the
only free `q4` coordinates lie in `b2_0..b2_2`, whereas all `q4` pivots lie in
`b2_3..b2_20`; trailing `C` puts the latter components first.  Hence the 690
input leading terms are exactly the 690 singleton M2 pivots.

This proof is checked at runtime against every input row.  The independent
replay `verify_systematic.py` rebuilt the flattening and ran the validation-only
Singular input, obtaining

```text
PASS_INDEPENDENT_SYSTEMATIC_LEADING_TERMS
SYSTEMATIC_LT_CHECK=1
LEADING_CHECK_ONLY_COMPLETE
```

with no `LT_FAIL` line.

## 5. Buchberger-pair reduction

Module leading terms in different components create no module S-pair.  The
first pair layer therefore has exactly

```text
3*C(32,2) + 18*C(33,2) = 10,992
```

same-component pairs, rather than all `C(690,2)=237,705` row pairs.

I did not materialize these 10,992 generally dense S-polynomials as extra
input rows: the verified order lets Singular construct them lazily, while
eager appending would greatly enlarge the input without a bounded benchmark
showing a benefit.  The successful leading-term construction therefore makes
manual pre-syzygy append unnecessary at this stage.

## 6. Exact first Schreyer/F4 layer

The systematic leading terms are 32 pivot variables in each of `b2_0..b2_2`
and 33 in each of `b2_3..b2_20`.  Hence the exact number of same-component
input pairs is

```text
3*C(32,2) + 18*C(33,2) = 10,992.
```

This first layer admits a sharper exact rank split.  In M2 degree two there
are

```text
21*C(38,2) = 14,763
```

module monomials.  The one-variable shadow of the 690 systematic pivots has
14,538 distinct terms.  Its standard complement consists exactly of the
free-free quadratics

```text
3*C(6,2) + 18*C(5,2) = 225.
```

The upstream sealed degree-two coefficient map has shape `14763 x 25530` and
exact rank 14,763.  Its systematic-shadow block contains a triangular
14,538-pivot minor.  Passing to the 225-dimensional standard quotient therefore
forces the residual `10992 x 225` Schreyer block to have exact rank 225.  After
those pivots are eliminated, exactly

```text
10,992 - 225 = 10,767
```

pure-M1 cubic kernel rows remain.  Their complete contraction tensor is
`full_p3_contractions.npy`, shape `10767 x 6 x 9139`, SHA256
`93eb010020c7b808039243cd64aede54677c95f74c17efe8e3abb03c5dbf2019`.
Thus this is an exact F4 row-space argument, not a pair sample.

## 7. Streamed exact cubic pivot profiles

`profile_degree3_closure.py` streams columns of the cubic tensor in blocks,
keeps only the first independent columns seen, and calls exact FFLAS rank
profiles over `F_89`.  It never materializes the full `10767 x 54834`
modular-double matrix.

The one-block bounded preflight reached rank 4,096 in 10.001228 seconds with
peak polled RSS 1,243,348,992 bytes.  It was intentionally only a preflight.

The full exact degree-lexicographic `(Dp,C)` profile then completed:

```text
rank                                      10,767
ordered columns needed                    10,767
wall seconds                              110.698515
peak polled RSS bytes                   3,208,937,472
degree-4 distinct shadow                  143,415
degree-4 duplicate-fiber rows             254,964
degree-4 standard columns                 404,925
degree-5 distinct initial shadow        1,437,126
degree-5 standard columns               3,059,262
initially covered pure-power targets       18 / 222
```

The pivot packet `degree3_pivot_profile.npz` has SHA256
`2aee7c0e2fd8a2b03a7a5133ed02f36ef7d881a8a1a29e39b617f2619da47b69`.

The exact degree-reverse-lexicographic-tie `(dp,C)` profile also completed:

```text
rank                                      10,767
ordered columns needed                    21,999
wall seconds                              167.378920
peak polled RSS bytes                   4,482,547,712
degree-4 distinct shadow                  232,326
degree-4 duplicate-fiber rows             166,053
degree-4 standard columns                 316,014
degree-5 distinct initial shadow        2,746,869
degree-5 standard columns               1,749,519
initially covered pure-power targets      120 / 222
```

The pivot packet `degree3_dp_pivot_profile.npz` has SHA256
`1e2720652bd938683250dea5c3ef8da685f6e9bd1b8126e83bf27b48a9dc8502`.
The `dp` tie is therefore the materially smaller exact continuation: it leaves
166,053 rather than 254,964 degree-four difference rows, 316,014 rather than
404,925 standard columns, and 102 rather than 204 initially uncovered targets.
None of these shadow counts is a higher-pair rank or membership result.

The corresponding all-690 homogeneous block order is

```text
a(total degree), lp(h), dp(q5..q36,q4,q0..q3), C.
```

Its runtime leading-term audit passes for every row.  The prepared all-222 job
`systematic_stageB_hblock_dp_all222.sing` has SHA256
`659592ed319cff6ddceb6287ef7c6811f2bebf8baa499e4245f19b956d1401f1`;
it was not run.

## 8. Compact complete degree-four schedule

`build_degree4_dp_schedule.py` enumerates the 398,379 one-variable
prolongations of the 10,767 normalized cubic pivots without expanding a single
polynomial coefficient row.  It finds exactly 232,326 product fibers and
stores one canonical prolongation plus 166,053 star-tree differences.  The
maximum fiber size is four, with exact histogram

```text
size 1: 152,220 fibers
size 2:  25,611 fibers
size 3:  23,043 fibers
size 4:  31,452 fibers.
```

This schedule is complete.  In a fiber with prolongations
`R_0,...,R_(k-1)`, replacing them by

```text
R_0, R_1-R_0, ..., R_(k-1)-R_0
```

is a determinant-one row transform over `F_89`.  Every omitted pair difference
is `(R_i-R_0)-(R_j-R_0)`, so the stored star spans every same-fiber pair row.
Terms in different module components cannot coincide and have zero module
S-polynomial.  Pairs with LCM degree above four are deferred to their
homogeneous layer, not discarded.

The 3,975,355-byte schedule `degree4_dp_schedule.npz`, SHA256
`7e1aa3d950521e4cb765101b6ec7dd54ff19d32c94419e07cb2da25cd47b3652`,
therefore preserves the complete degree-four Macaulay row space at the
combinatorial level.  It does not contain the uncomputed coefficient
elimination.

## 9. Exact bounded density sample and resource barrier

`sample_degree4_dp_pairs.py` selected the first eight duplicate fibers in the
documented pivot-row/variable scan.  It exactly solved the `10767 x 10767`
pivot minor, verified the 14 normalized rows involved, and expanded only those
eight S-polynomials.  The bounded run completed in 30.697372 seconds with peak
polled RSS 2,440,871,936 bytes; the exact pivot solve took 18.401998 seconds.

```text
raw S-polynomial nnz                         84,565 .. 84,644
median raw nnz                                      84,596.5
standard-complement nnz before reduction    37,322 .. 37,377
median standard-complement nnz                      37,344.5
```

The sample packet `degree4_dp_pair_sample.npz` has SHA256
`167a3219dfbfbcf472c5a5c31c0a09804841fb1ddfa5fe18ffcc50beb15d1d25`.
The sample is deterministic exact data, but eight rows are not asserted to be
statistically representative and were not fully triangularly reduced.

The complete degree-four difference layer has exact dimensions

```text
166,053 rows x 316,014 standard columns.
```

Materializing that rectangle densely would require exactly

```text
52,475,072,742 bytes  as uint8           (52.48 decimal GB)
419,800,581,936 bytes as modular doubles (419.8 decimal GB).
```

Accordingly no larger coefficient closure was launched under the shared-memory
pressure.  A future continuation must consume the compact schedule in
coefficient tiles, spill sparse rows/pivots by homogeneous degree, and certify
each completed row rank before advancing.  Truncated tiles cannot yield a
membership or nonmembership verdict.

## 10. Prepared immutable jobs

### Stage B: all 222 powers

```text
systematic_stageB_homogenized_all222.sing
bytes  30,077,319
SHA256 139789585e7efd3e234965f2404595c7efe67c2efe70fd816b7db4e03bfc35a7
```

It computes one degree-5 standard basis and reduces all

```text
q_i^5 e_j,  0 <= i < 37, 0 <= j < 6.
```

A terminal marker with `passed=222,all_member=1`, following
`SYSTEMATIC_LT_CHECK=1`, would be an exact Stage-B irrelevant-power
certificate in the sealed lower presentation.  The job is prepared but was
not run.

### Full 28 components: all 1,036 powers

```text
systematic_full28_homogenized_degree8.sing
bytes  122,206,482
SHA256 4ebc0c03c9ec88abf77512eae22e0db3df4d006bf29195325f78578dbab2030f
```

It computes one degree-8 standard basis and reduces, for every q axis,

```text
q_i^8 e_0,
h q_i^7 e_1,...,h q_i^7 e_6,
h^2 q_i^6 e_7,...,h^2 q_i^6 e_27.
```

A terminal marker with `passed=1036,all_member=1`, following the leading-term
check, would prove empty projective q-support for the direct lower module.  By
specializing `h=1`, these are exactly the original weighted targets.  The job
is prepared but was not run.

No Macaulay2 duplicate was generated: Singular provides the needed shifted
embedding, exact module order, per-row leading-term assertions, and bounded
runner directly.  Duplicating 122 MB of input in a second syntax would not add
an independent algebraic certificate before either standard basis exists.

## 11. Replay

From `goals_2026-08-01`:

```bash
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/systematic_module/produce_affine_msolve.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/systematic_module/produce_homogenized_module_jobs.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/systematic_module/produce_leading_check.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/systematic_module/verify_systematic.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/systematic_module/profile_degree3_closure.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/systematic_module/profile_degree3_dprevlex.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/systematic_module/build_degree4_dp_schedule.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/systematic_module/verify_seal.py
```

The first three producers refuse to overwrite mismatching immutable files.
The exact bounded-run records are retained; rerunning them requires deliberate
archival rather than silent overwrite.

## Final theorem boundary

Established exactly:

- the all-690 affine input and its timeout/resource trace;
- the `[I_690|T]` decomposition with exactly 87 free coordinates;
- the membership-preserving homogenized embedding;
- all 690 claimed systematic input leading terms in Singular; and
- the exact first-layer rank split `10992 = 225 + 10767`;
- exact degree-three `Dp` and `dp` pivot profiles and monomial shadows;
- the complete compact degree-four product-fiber schedule; and
- immutable Stage-B/all-28 direct-module jobs and bounded resource traces.

Not established:

- emptiness or nonemptiness of the affine chart;
- the degree-four difference-row rank or any new higher-degree pivot;
- any one of the 102 still-uncovered Stage-B targets, or any completed set of
  222 or 1,036 target memberships;
- global Stage-B or Stage-C emptiness; or
- either P25 terminal headline.
