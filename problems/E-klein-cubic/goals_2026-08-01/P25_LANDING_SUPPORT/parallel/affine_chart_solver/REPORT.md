# Exact affine-chart combined-module strategy

## Outcome

An exact low-memory formulation was built and tested for the support-balanced
`r64` combined matrix

```text
A(q) = [P4(q) | P3_0(q) | ... | P3_5(q)]  (64 x 7 over F_89).
```

The formulation removes all projective `b` variables.  On the representative
chart `q0=1`, it uses the row module `N` of the dehomogenized matrix inside
the free module `R^7`, where

```text
R = F_89[q1,...,q36].
```

The exact decisive criterion is

```text
N = R^7,
```

checked in Singular as both `dim(std(N))=-1` and zero remainder of
`freemodule(7)` modulo the standard basis.  This is Schur/module elimination:
it is equivalent to unit maximal-minor ideal on the chart, but does not
introduce the six normalized `b` variables or expand 7-by-7 determinants.

Two hard-fenced runs were attempted.  Neither completed:

| algorithm | stop | elapsed (s) | peak RSS observed | terminal scope |
|---|---:|---:|---:|---|
| `std` | 600 s timeout | 600.123451 | 3,506,012,160 B | nonverdict |
| `slimgb` | 8 GiB RSS guard | 576.919593 | 8,593,850,368 B | nonverdict |

The `std` trace reached degree 5 and approximately 245 basis generators.  The
`slimgb` trace entered its degree-5 matrix step but crossed the nominal RSS
threshold before returning a basis.  Its first polled over-threshold value was
3,915,776 bytes (0.046%) above 8 GiB because the guard samples every 50 ms; it
then killed the whole process group immediately.

No result file was written by either run.  Therefore neither run proves that
the chart is empty, and neither run produces a rank-defect point.  The honest
status remains

```text
P25-UNDECIDED.
```

## Why the criterion is exact

At a geometric point of `q0=1`, the seven columns of `A(q)` have rank below
seven exactly when the specialized rows fail to span the seven-dimensional
fiber.  Hence the rank-defect locus is the support of `R^7/N`.  It is empty
exactly when `R^7/N=0`, equivalently `N=R^7`.  Standard-module reduction tests
this equality directly and implicitly handles all projective `[b0:b1]`
directions at once.

The previously isolated closed linear space is

```text
L8 = P<span(q4,...,q11)>.
```

Writing

```text
H8 = (q0,q1,q2,q3,q12,...,q36),
```

its complement is covered by 29 affine charts:

```text
q_i=1,  i in {0,1,2,3,12,...,36}.
```

Thus a completed `N_i=R_i^7` certificate on every one of these charts, together
with the existing exact closed-`L8` Stage-B and Stage-C certificates, would
close the combined open-complement problem.  The single tested `q0` chart is
not a cover by itself.

## Certificate format after a successful discovery run

A CAS declaration should not be the final proof packet.  If a chart reaches
`R_i^7`, the preferred replay certificate is a polynomial `7 x 64` lift matrix
`U_i` satisfying

```text
U_i A_i = I_7.
```

A streaming independent verifier can rebuild the selected r64 contractions,
substitute `q_i=1`, multiply the displayed lift, and check the 49 polynomial
entries against the identity.  Twenty-nine such identities give a transparent
affine-cover proof without trusting a complete Gröbner-basis claim.

## Operational conclusion

Under the active 8 GiB / 10 minute restriction, `std` is the safer engine:
its memory curve stayed below 3.51 GB, whereas `slimgb` consumed the full RSS
allowance in its degree-5 block.  Running the remaining 28 charts under the
same fence is not justified by this preflight.  Once the shared large process
has released resources, the next honest test is a longer `std` run on the
immutable `q0=1` input.  Only after that chart returns `R^7` should the cover be
continued and lift identities extracted.

## Replay

From `goals_2026-08-01`:

```bash
/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/affine_chart_solver/produce_affine_module.py \
  --chart 0 --algorithm std

/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/affine_chart_solver/run_bounded.py \
  P25_LANDING_SUPPORT/parallel/affine_chart_solver/r64_combined_q0_eq_1_std.sing \
  --timeout 600 --rss-gib 8

/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/affine_chart_solver/audit_affine_runs.py
```

The sealed upstream packet is

```text
support_balanced_r64_stageBC.npz
sha256 c50de97aa4fc9465793f3fe84b544731b36cec1a2807113e94817c955897be2b
```
