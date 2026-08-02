# PREPARED_NOT_RUN: exact r66 normalized Stage-C chart on `D(q0)`

No CAS job was launched.  This directory contains an independently generated
and entrywise replayed affine system for the selected 66-row contraction
packet over `F_89`, after `q0=1` and `b0=1`:

```text
P4(q) + P3(q)b1 = 0.
```

It has 66 equations in 42 variables, ordered
`b1_0,...,b1_5,q1,...,q36`, and ordinary total degree at most four.

## Binding and exact term audit

The sealed source packet is

```text
parallel/global_compatibility/support_augmented_r66_stageBC.npz
sha256 b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84
```

Its bound tensor hashes are

```text
P4 32197337d815ed4b2600d3d2965499a276fab5a3589559f10d8fe2488199771b
P3 00b2ea7c59b74741982d4731424ac7d19df8b31770aa1a56a190ca7c456030c9
```

The affine term ledger is exact:

| block | printed terms |
|---|---:|
| `P4` | 4,446,378 |
| all six `P3_j b1_j` blocks | 2,363,052 |
| total | 6,809,430 |

The six `P3` component counts are
`393905,393814,393811,393955,393848,393719`.  The affine-q degree counts
for `P4`, in degrees zero through four, are
`66,2350,43463,550336,3850163`.  Full per-row and per-degree ledgers are in
`r66_stageC_q0_1_b0_1.json`.

The canonical CAS inputs are:

```text
r66_stageC_q0_1_b0_1.ms
  bytes  118337283
  sha256 c4e99a95d9ad3bc24bed2c0bcad1d9fc3376c9a8be06018e628783ac173b0f84

r66_stageC_q0_1_b0_1.sing
  bytes  118338632
  sha256 26a0fa4a62216bf1b30043782884220d66213a8b18ae58505d4f0b6db3119089
```

`verify_stagec_q0.py` does not trust the producer's strings.  It parses every
printed monomial back into coefficient arrays, compares all 66 rows entrywise
to the sealed tensors, checks row hashes and term/degree ledgers, and verifies
that the msolve and Singular streams carry identical equations.  It ends

```text
PASS_INPUT_REPLAY_PREPARED_NOT_RUN
```

## Prepared exact jobs and fail-closed semantics

`run_guarded.py` is dry-run by default.  It launches a CAS only with an
explicit `--execute`, validates the bound input hash first, refuses stale
outputs, monitors RSS through macOS `libproc`, kills the process group if the
RSS poll fails or a wall/RSS fence is reached, and accepts only a completed
exact unit sentinel.

`job_plan.json` binds three mutually alternative, never-concurrent jobs:

1. preferred msolve ordinary F4 with `-m 100`;
2. msolve ordinary F4 with all pairs (`-m 0`);
3. Singular `std` over characteristic 89.

The `-m 100` option is supported by msolve 0.10.1 and caps the number of
pairs selected per F4 matrix.  It may lower peak RSS, but it is not a
resumable decomposition or a collection of separately meaningful proofs.
Only full completion with a unit sentinel is decisive.

## Resource forecast and scheduling gate

The closest observed job is the simpler r66 Stage-B chart: 41 variables and
2,363,052 terms.  Its all-pairs run reached 4.2753 GiB RSS during an
incomplete degree-six round after 548.96 seconds.  This Stage-C system has one
more variable, 2.881 times as many terms, and 4,446,378 additional `P4`
terms.  It must not be assumed to fit below that observed peak.

The current approximately 5.85 GiB free-plus-speculative headroom is
inadequate, especially while the main Singular process is active.  After
contention ends, the prepared forecast is:

- try `-m 100` alone only with at least 20 GiB genuinely available, under its
  16-GiB fail-closed fence;
- reserve all-pairs msolve or Singular for at least 40 GiB available, under a
  32-GiB fence;
- treat any fence stop as a nonverdict.

These are scheduling estimates, not completion guarantees.

## Exact scope

A completed unit ideal proves emptiness of this one selected affine chart
`D(q0)` with `b0=1`.  A complete nonunit basis, timeout, resource stop, crash,
missing result, or parser failure is a nonverdict for the true incidence.
Even a unit here does not cover the other `q` charts and therefore does not
prove global Stage-C emptiness or any terminal P25 claim.

## Safe replay (no CAS)

From `goals_2026-08-01`:

```bash
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/r66_stagec/produce_stagec_q0.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/r66_stagec/verify_stagec_q0.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/r66_stagec/make_job_plan.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/r66_stagec/verify_seal.py
```

