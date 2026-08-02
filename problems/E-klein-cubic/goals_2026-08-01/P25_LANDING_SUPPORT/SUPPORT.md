# Support for `P25-UNDECIDED`

## Exact object and implication direction

Work is over `F_89` with

```text
S = F_89[q0,...,q36],
F = S + S(-1)^6 + S(-2)^21.
```

The sealed 690 residual rows generate a submodule `N0` of the true relation
module.  Hence `F/N0` surjects onto the true landing quotient.  Empty
projective support of `F/N0` would prove empty true landing support; no equality
between the lower and true presentations is assumed.

P0 independently reconstructs the rank-43 DVR model, complete landing-row rank
`746`, the `56` monic pure-`K^3` pivots, and the `690` residual rows.  The
retired historical 842-row packet is not consumed.

## Exact strata already closed

Write the lower incidence as

```text
M0(q)b0 + M1(q)b1 + M2(q)b2 = 0.
```

Stage A (`b0=b1=0`) is independently empty: the replay gives flattening rank
`690`, kernel dimension `87`, and full quadratic span `3828/3828`.

Let `L8=P<span(q4,...,q11)>`.  The stratified packet proves:

```text
Stage B on L8:
  S3^114 -> S6^6 has rank 10296/10296;
  the selected square minor has determinant 28 mod 89.

Normalized Stage C on L8:
  dim ker(P3 compatibility) = 3384;
  the degree-eight compatibility map has rank 6435/6435.
```

These are algebraic-closure statements, not sampled finite-field tests.

## Certified complement cover

The outside-coordinate ideal is

```text
H8=(q0,q1,q2,q3,q12,...,q36),
```

with 29 coordinates.  For Stage B, take a length-34 Reed--Solomon evaluation
code of dimension 29 on the outside q-coordinates and one of dimension 6 on
`b1`.  Over the algebraic closure their nonzero codewords have supports at
least 6 and 29.  Since `6+29>34`, the supports intersect.  Thus the 34 paired
opens `D(ell_k(q)) intersect D(m_k(b1))` cover
`D(H8) x P^5_b1`.  Independent producers and verifiers rebuild both generator
matrices, all maximal-minor/MDS checks, and the support argument.

Together with closed `L8`, those 34 affine systems are an exhaustive Stage-B
cover.  Stage C has `b0!=0`, so normalize `b0=1`; closed `L8` plus the 29
outside-q opens is exhaustive.  Constant linear forms mixing `b0` and `b1`
are not used, because those components have different twists.

## Safe contractions and their real scope

The complete degree-one left-syzygy calculation has coefficient matrix
`14763 x 25530`, rank `14763`, and nullity `10767`.  Contracting gives the
necessary equations

```text
P4(q)b0 + P3(q)b1 = 0.
```

The r66 packet is rebuilt from 64 support-balanced contractions plus two bound
full-basis rows.  Exact replay proves augmented rank seven on all 666
coordinate lines, so no contracted survivor has q-support at most two.  Each
of the six full Stage-B coefficient maps has rank `9139/9139`, excluding
`b1`-support exactly one.  Neither family covers mixed points globally.

The old r48 complement route is retired, not merely timed out: at `q=e12` it
has P3 rank `4/6` and augmented rank `4/7`, with explicit Stage-B and Stage-C
kernel witnesses.  Those witnesses belong only to the compressed necessary
system and are not landing candidates.

## Exact computational nonverdicts

For the r66 Stage-B chart `q0=1,b1_0=1`, the exact ordinary msolve input has
66 equations, 41 variables, and SHA-256
`9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b`.
The run completed the degree-five F4 round and entered the 1,708-pair
degree-six round.  It was manually stopped after observed RSS reached
`4,482,960 KiB`; it emitted no leading ideal or unit certificate.  The first
runner's sandbox-blind RSS field and the manual-stop provenance are explicitly
audited in the determinantal-cover packet.

An exact signature-mode retry is not admissible evidence: msolve rejected the
inhomogeneous chart and reported characteristic `1073741827`, not 89.  No
result from that invocation is promoted.

The systematic direct-module audit proves an exact `[I_690|T]` leading block
and reduces the initial pair layer to `10992=225+10767`.  Its degree-reverse-
lex schedule has 166,053 higher difference rows, but even byte-valued dense
materialization would require `52,475,072,742` bytes.  This is a resource
floor, not a nonmembership theorem.

The sealed pair-split retry changes only msolve's documented per-F4-matrix cap
from `-m 0` to `-m 100`; the input and field remain byte-identical.  It is
`PREPARED_NOT_RUN`.  Its fail-closed runner requires a live process-group RSS
census, which is unavailable in the managed sandbox, and unsandboxed execution
is quota-blocked until 2026-08-08.

## Transfer and theorem boundary

The sealed DVR replay proves the conditional implication

```text
empty complete prime-89 projective special fibre
  => empty characteristic-zero degree-25 landing scheme.
```

Its hypothesis is not established.  There is also no candidate to lift or
substitute into the original Klein cubic.  Therefore the only valid current
exit is `P25-UNDECIDED`; the headline remains open.
