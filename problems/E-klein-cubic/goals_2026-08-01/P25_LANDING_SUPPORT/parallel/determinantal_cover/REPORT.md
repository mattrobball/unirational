# Determinantal-cover and affine-Nullstellensatz audit

## Outcome

```text
P25-UNDECIDED
```

This phase does **not** close Stage B or Stage C on `D(H8)`.  It proves one
exact finite-cover theorem: Stage B on the unresolved complement can be
covered by 34 paired MDS opens, rather than 174 q/b coordinate flags.  No one
of those 34 charts was proved empty.  No Stage-C chart was proved empty, and
no `H8`-power identity among maximal minors or polynomial left inverse was
obtained.

All work is confined to this directory.

## 1. Binding r66 input

The affine equations come from the independently verified augmented r66
packet

```text
parallel/global_compatibility/support_augmented_r66_stageBC.npz
shape P3 = 66 x 6 x 9139
shape P4 = 66 x 91390
SHA256 b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84
```

Only its `P3` block was used in the launched chart, so that computation is
Stage B only.  The exact chart substitutions were

```text
q0 = 1, b1_0 = 1.
```

The resulting input has 66 equations in 41 variables and 2,363,052 printed
terms:

```text
r66_stageB_qflag00_bflag0.ms
bytes  41,537,116
SHA256 9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b
```

A completed exact unit ideal would prove this one affine chart empty over the
algebraic closure of `F_89`.  Every observed run is incomplete and therefore
a strict nonverdict.

## 2. Ordinary exact msolve run: manually resource-stopped

The first run used exact characteristic 89 arithmetic, ordinary F4, four
threads, seed `2026080189`, and `-m 0`.  It completed:

```text
degree 4:     66 x 54,834, density 65.29%, 65 new, 0 zero
degree 5:  2,752 x 685,405, density 7.90%, 253 new, 0 zero
             degree-5 wall/cpu time 108.09 / 53.00 seconds
```

It then selected all 1,708 degree-six pairs in one round and did not complete
that round.

The original runner's RSS poll invoked `ps` inside the managed sandbox.
macOS denied that call; the original code incorrectly converted the exception
to a zero reading.  Thus its immutable record honestly shows

```text
peak_rss_bytes_polled = 0
stop_reason           = null
returncode            = -15
elapsed_seconds       = 548.9556749580079
```

An escalated read-only `ps` check outside that blind poll observed

```text
RSS = 4,482,960 KiB = 4,590,551,040 bytes = 4.2753 GiB,
```

above the promised 4-GiB fence.  This worker sent `SIGTERM` only to its own
msolve child PID `25955`.  The exact operational attestation is
`manual_stop_provenance.json`.  This was a resource stop, not a nonunit
calculation, a point, or an emptiness proof.

The runner is now fail-closed: an unavailable RSS poll terminates a run with
`rss_poll_unavailable`.  In this environment it must be invoked through an
approved escalated command for live `ps` polling; otherwise it deliberately
does not proceed.

## 3. Signature-mode rejection

One separately authorized rerun used the same immutable input and seed with
msolve option `-q 1`, under a verified live-RSS poll, 600-second wall fence,
6-GiB fence, and four threads.  The live guard was genuinely active:

```text
peak_rss_bytes_polled = 433,258,496
elapsed_seconds       = 39.87083908400382
returncode            = 1
```

It did not start a Gröbner round.  Its exact log reports

```text
field characteristic    1073741827
signature-based computation      1
Input system must be homogeneous.
```

The input itself has characteristic 89 on line two.  Therefore this
signature-mode invocation both changed the reported arithmetic field and
rejected the dehomogenized chart as nonhomogeneous.  It is inapplicable here
and is a strict nonverdict.  It produced no leading ideal.

Before the fail-closed repair, an attempted `RLIMIT_AS` launcher failed in
`preexec_fn` before msolve started; the preserved empty
`r66_stageB_qflag00_bflag0.sig1.log` is only that launch-failure trace.

## 4. Exact 34-open Stage-B MDS cover

Let

```text
H8 = (q0,q1,q2,q3,q12,...,q36)
```

and write `h` for these 29 coordinates.  Over `F_89`, take systematic
Reed--Solomon generator matrices for codes

```text
[34,29,6] on h,
[34, 6,29] on b1.
```

They use the 34 distinct evaluation points `0,...,33`.  Write their columns
as linear forms `l_k(h)` and `m_k(b1)`.  Over every extension field, a nonzero
polynomial of degree below `k` has at most `k-1` roots.  Hence, for nonzero
`h` and `b1`,

```text
|support(l(h))| >= 6,
|support(m(b1))| >= 29.
```

The two supports lie in a 34-element set and `6+29>34`, so they intersect.
Consequently the 34 opens

```text
D(l_k(h) m_k(b1)),  k=0,...,33,
```

cover `D(H8) x P^5_b1` over `algebraic_closure(F_89)`.

The exact systematic forms have the useful census

```text
 6 coordinate-q / coordinate-b1 charts,
23 coordinate-q / dense-b1 charts,
 5 dense-q      / dense-b1 charts.
```

Thus only five q normalizations are dense.  The producer and independent
verifier reconstruct both systematic matrices from the Vandermonde matrices
and check the support-intersection arithmetic:

```text
stageB_mds34_cover.npz
SHA256 b96b734f99c31f457a94dd0eda0e56da6b670c76945a857e57480f9f37da50dd

verify_mds_stageB_cover_result.json
status PASS_INDEPENDENT_STAGEB_MDS34_COVER_REPLAY
```

This is a cover theorem, not a chart-emptiness theorem.  All 34 charts remain
unsolved.

## 5. Grading guard and Stage C

The MDS pairing is valid only for Stage B because all six `b1` coordinates
have the same twist.  A constant linear form mixing `b0` and `b1` is not a
homogeneous section of the graded bundle

```text
S e0 direct_sum S(-1)^6.
```

Accordingly no combined 43-open `P^36_q x P^6_(b0,b1)` claim is made.  Stage
C remains normalized by `b0=1` and requires its 29 outside q opens

```text
D(q_i), i=0,1,2,3,12,...,36,
```

in addition to the already sealed closed-`L8` certificate.  None of those 29
Stage-C charts was run here.

## 6. Exact theorem boundary

Established exactly in this directory:

- the immutable r66 Stage-B affine input on `q0=1,b1_0=1`;
- the complete degree-four and degree-five ordinary-F4 trace;
- the manual resource-stop provenance and its strict nonverdict scope;
- a fail-closed RSS runner and one guarded signature-mode rejection trace;
- the independently replayed 34-open MDS cover of `D(H8) x P^5_b1`.

Not established:

- emptiness of even one of the 34 Stage-B charts;
- Stage-B emptiness on `D(H8)`;
- emptiness of even one Stage-C complement chart;
- Stage-C emptiness on `D(H8)`;
- a saturated maximal-minor ideal, any `H8`-power identity, or a polynomial
  left inverse; or
- `P25-DEGREE25-EMPTY` or a positive covariant.

The phase audit ends

```text
PASS_DETERMINANTAL_COVER_PHASE_AUDIT_NONVERDICT
```

## 7. Deferred scheduling hypothesis

The ordinary run used `-m 0` and therefore selected all 1,708 degree-six
pairs at once.  A future bounded experiment may test `-m 100` (or a similar
finite pair cap) under a distinct immutable run stem; splitting F4 matrices
may lower peak RSS.  This is only a resource-scheduling hypothesis.  It has
not been launched and has no mathematical force.

## Replay

From `goals_2026-08-01`:

```bash
/opt/homebrew/bin/python3 \
  P25_LANDING_SUPPORT/parallel/determinantal_cover/certify_mds_stageB_cover.py

/opt/homebrew/bin/python3 \
  P25_LANDING_SUPPORT/parallel/determinantal_cover/verify_mds_stageB_cover.py

/opt/homebrew/bin/python3 \
  P25_LANDING_SUPPORT/parallel/determinantal_cover/audit_phase.py
```

Observed markers:

```text
PASS_EXACT_STAGEB_MDS34_COVER
PASS_INDEPENDENT_STAGEB_MDS34_COVER_REPLAY
PASS_DETERMINANTAL_COVER_PHASE_AUDIT_NONVERDICT
```
