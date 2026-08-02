# PC.2 global augmented-module audit

Status: `PC2_GLOBAL_AUDIT_UNDECIDED_NO_JOB_LAUNCHED`.

No existing r43 or r64 output proves `dim(S^7/N)=0`.  The historical
`enlarged_closure` packet labels both scripts prepared and unlaunched, its
independent verifier requires both result files to be absent, and a repository
search found no renamed result.

The criterion itself is sound.  The rows

```text
[P4 | P3_0 | ... | P3_5] in S^7
```

have one degree-four and six degree-three components.  Every maximal minor is
therefore homogeneous of degree `4 + 6*3 = 22`.  Since all entries have
positive degree, the quotient is nonzero at the cone vertex.  Thus Singular's
`dim(std(N))=0` means precisely that the rank-drop support is confined to the
vertex, so the selected contraction matrix has rank seven at every projective
geometric `q`.  Because r43/r64 use rows from the complete contraction module,
that result would exclude the lower-presentation Stage B and Stage C support.

The resource evidence does not justify calling either job feasible.  A closely
matched affine r64 computation (`q0=1`, 36 variables, 101,996,154-byte input)
ran `std` for 600.12 seconds at sampled peak RSS 3.506 GB without completing;
`slimgb` reached 8.594 GB and was killed after 576.9 seconds.  The global r64
input has 37 variables, 6,520,376 nonzero terms, and 104,646,907 bytes.  The
advertised 32-GiB/two-hour values are resource fences, not completion estimates.

`pc2_global_run_bounded.py` is a path-safe runner.  Its default mode only
audits the immutable source hash and semantic guards.  An actual launch requires
`--run`; settings above ten minutes or 8 GiB additionally require
`--acknowledge-large`.  It writes a streamed copy in this writable packet with
the hard-coded historical result path replaced, kills the complete process
group on a fence, and records every noncompletion as a nonverdict.

Safest next action: keep `PC-UNDECIDED`.  If a deliberate resource window is
allocated, test r64 with an explicit bound, promote only a completed parsed
`dim=0` result, and then independently replay it or extract a polynomial lift
certificate.  Positive dimension, timeout, resource stop, crash, or missing
output proves no support point and decides no PC.2 stratum.
