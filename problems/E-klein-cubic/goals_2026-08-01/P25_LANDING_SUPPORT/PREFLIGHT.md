# Exact solver preflight

## System

- Field: `F_89`.
- Homogeneous coefficient variables: 43 (`q0..q36,k0..k5`).
- Exact landing-row basis: 746 dense cubics.
- Border-adapted pivot profile: 56 monic `K^3` pivots and 690 `Q K^2`
  pivots.
- Full generated msolve input: 134,913,277 bytes, SHA-256
  `e5d182b26f8cffe7a6fcca52f6772c1945236b86de2ecff0fdde25e7d6d4155b`.

The historical 842-row packet is not consumed.

## Portable versus local artifacts

The six generated solver inputs above GitHub's 100 MB per-file limit are
intentionally local and ignored by Git. Their exact hashes and byte counts are
recorded in the adjacent JSON metadata. Rebuild them from the committed source
artifacts with:

```text
/opt/homebrew/bin/python3 produce_msolve_input.py
/opt/homebrew/bin/python3 produce_standard_input.py
/opt/homebrew/bin/python3 produce_syzygy_charts.py --rows 48
/opt/homebrew/bin/python3 produce_syzygy_charts.py --rows 96
/opt/homebrew/bin/python3 produce_syzygy_charts.py --rows 256
```

The smaller companion inputs, contracted arrays, producers, metadata, and
audit documents remain part of the portable report.

## Resource strategy

The exact homogeneous quotient is preferable to the 63-variable kernel
incidence for this run: one Artinian leading ideal decides the whole
projective scheme, whereas the incidence computation must manage two
irrelevant ideals and extra kernel variables.

The generic semi-regular Hilbert-series estimate for 746 cubics in 43
variables first becomes nonpositive in degree 7.  This is only a resource
estimate, not theorem evidence.  It explains why the full border-adapted row
set can be easier than a small subsystem: a 128-cubic generic subsystem does
not reach the corresponding threshold until much later.  Exact completion and
the 43 pure powers—not this estimate—are the decision criterion.

Only one high-memory P25 solver should run at a time.  The shared machine has
128 GiB RAM; the binding route budget is 64 GiB, with live RSS monitoring and
no inference from timeout, crash, or empty output.
