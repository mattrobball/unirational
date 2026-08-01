# Support for `P25-UNDECIDED`

## Exact object and implication direction

Work is over `F_89` with

```text
S = F_89[q0,...,q36],
F = S + S(-1)^6 + S(-2)^21.
```

The sealed 690 residual rows generate a submodule `N0` of the true relation
module.  Hence `F/N0` surjects onto the true landing quotient.  Empty
projective support of `F/N0` would therefore prove empty true landing support;
no false equality between the lower and true presentations is used.

The independent replay recomputed complete landing-row rank `746`, the
`56` monic pure-`K^3` pivots and `690` residual rows, and the rank-43 DVR
model.  The historical 842-row packet is not consumed.

## Safe syzygy contraction

Write the lower-presentation incidence as

```text
M0(q)b0 + M1(q)b1 + M2(q)b2 = 0,
```

where the three kernel blocks have dimensions `1`, `6`, and `21`.  Exact
degree-one left syzygies satisfy

```text
C(q) M2(q) = 0.
```

Contracting gives necessary equations

```text
P4(q)b0 + P3(q)b1 = 0.
```

The producer constructed a `14763 x 25530` coefficient matrix over `F_89`,
with SHA-256
`d813f7b59057c939577faa0f22184b9fa9cce8a7d63af9c321514be9437b3f8f`,
rank `14763`, and nullity `10767`.  It saved 256 deterministic syzygies and
checked every one directly against the sealed `M2` tensor.  The independent
replay also reconstructed the earlier deterministic 96-vector selection and
rebuilt all 48 exploratory `P4/P3` rows byte-for-byte.

Emptiness of any retained syzygy subsystem would be conclusive because these
equations define a safe over-approximation.  A survivor or incomplete solve is
not conclusive.

## Exhaustive stratum boundary

The projective kernel incidence splits into:

1. `b0=b1=0`: independently replayed empty.  The Stage-A verifier recomputed
   flattening rank `690`, kernel dimension `87`, and full quadratic span
   `3828/3828`.
2. `b0=0,b1!=0`: requires saturation of `P3(q)b1` by both irrelevant ideals.
   Sequential saturation by the `b1` ideal and then the `q` ideal equals
   saturation by their product.
3. `b0!=0`: normalize `b0=1` and saturate `P4(q)+P3(q)b1` by the `q`
   irrelevant ideal.

Stage B is the first unresolved stratum.  Therefore Stage C was not promoted
or interpreted.

## Measured exact attempts and nonverdict

`saturation_attempts.json` records the exact scripts and sampled resources.
The strongest run retained all 256 verified necessary equations.  Singular
4.4.1 parsed all 256 generators and spent `2572.24` seconds wall /
`1812.78` seconds user CPU; sampled RSS reached `10710720 KiB`.  It was
interrupted before the first `b-saturated gens=` marker and wrote no result
file.  Runs with 43, 48, and 96 equations, and one affine `b1_0=1` chart, were
also incomplete.

These runs supply a resource floor only.  Timeout, interruption, a missing
result file, and absence of zero reductions are never used as emptiness
evidence.

## Independent replay

The completed equations/upstream replay was:

```text
/opt/homebrew/bin/python3 -u verify_syzygy_empty.py --equations-only
```

It terminated:

```text
PASS: contraction equations only; no emptiness verdict requested
```

For a quick packet audit run:

```text
/opt/homebrew/bin/python3 -u verify_undecided.py
```

For a fresh full equations/upstream replay run:

```text
/opt/homebrew/bin/python3 -u verify_undecided.py --full-replay
```

## Theorem boundary

This packet proves no positive or negative degree-25 verdict.  The sealed DVR
properness theorem would transfer an exact empty prime-89 special fibre to
characteristic zero, but its emptiness hypothesis is not established here.
The only valid exit is `P25-UNDECIDED`, and the headline remains open.
