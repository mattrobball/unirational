# Stratified Stage B and Stage C report

## Exact closed-stratum result

Let

```text
L8 = P<span(q4,...,q11)>.
```

The pre-existing degree-six certificate and its independent replay prove that
Stage B is empty on `L8`.  This packet now also proves that normalized Stage C
is empty on `L8`.

For the 114 nonzero restricted r256 rows, the degree-six `P3` Macaulay map is

```text
S_3^114 -> S_6^6,   13680 -> 10296.
```

It is onto, so its exact kernel has dimension 3384.  Contracting the complete
kernel with the restricted `P4` rows gives 3384 scalar septics.  Their products
by the eight `L8` coordinates span all of `S_8`:

```text
rank = 6435 / 6435.
```

Thus the compatibility ideal contains every octic and has no projective zero.
Every normalized Stage-C solution would annihilate this ideal, so no such
solution exists on `L8`.

Primary artifacts:

- `closed_L8_stageC_certificate.json`
- `closed_L8_stageC_compatibility.npz`
- `verify_closed_L8_stageC_result.json`

The producer finished in 73.7 seconds with peak RSS 5,162,008,576 bytes.  The
independent verifier rebuilt the complete nullspace and compatibility map and
checked the selected 6435-square minor at rank 6435; it finished in 39.7
seconds with peak RSS 3,764,109,312 bytes.

Important hashes:

```text
source r256 packet:
  2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea
compatibility artifact:
  ad64848d98316eff00793814a5e8be09978f61c13057e4256e9a586375093957
kernel uint8:
  673d49d7543a22aae14cafe6ab84ace82b7d15217198d4553bfbf29cb5f3485c
compatibility uint8:
  770f3d266eb5f1c3d7891ce0c4a63129e0c1f1e67ce92eb730ebb114cc4e70ee
selected 6435-square minor uint8:
  203c2f225aa11959c96ab50f5573e63a0950e171dc3918d41e4cac3f02194817
```

The optional augmented-module Groebner route was tried under a 4 GiB fence and
stopped manually after its basis grew to roughly 5900 generators.  It produced
no result and is a nonverdict; the compatibility certificate supersedes it.

## Prepared open-complement jobs

Set

```text
H8 = (q0,...,q3,q12,...,q36),   V(H8)=L8.
```

`stratified_jobs.json` binds six exact Singular inputs.  All use block orders
preserving the `b/q` multigrading.  Stage-B and normalized Stage-C jobs use
`(dp(6),dp(37))`; combined projective `[b0:b1]` jobs use
`(dp(7),dp(37))`.  For Stage B and combined incidence, the script saturates by
`H8` first and by the appropriate `b`-irrelevant ideal second.

The prepared alternatives are:

- new-r43 Stage B;
- old-r48 Stage B;
- new-r43 normalized Stage C;
- old-r48 normalized Stage C;
- old-r48 combined Stage B plus Stage C;
- support-balanced r64 combined Stage B plus Stage C.

`verify_stratified_inputs_result.json` independently binds the old-r48
syzygies and contractions, the new-r43 and r64 upstream replays, both exact
closed-`L8` certificates, every script hash, every block order, and every
H8-first saturation sequence.  None of these large complement jobs has been
launched.

Provenance guard: the current old-r48 Stage-B complement script is the
regenerated H8-first block-order file with SHA-256
`510bbb7d399b18e0986a0c618ee6d82d50e6c24ec8ebc04857020d1077e15ac1`.
Any earlier preflight, log, or claimed result against an overwritten version of
that pathname (and therefore a different script hash) is provenance-invalid
and must not be used.

## Current theorem boundary

Stage B and normalized Stage C are both exactly empty on `L8`.  The complement
`P36 minus L8` remains undecided until one of the corresponding exact
H8-complement saturation jobs returns the unit ideal.  A nonunit result,
timeout, resource stop, crash, or missing result remains a contraction
nonverdict and is not a point of the true incidence.
