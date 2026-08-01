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

The initial full homogeneous run was stopped after a measured degree-5 block
of size `71471 x 1025063` took 2323 seconds, produced 512 new leading terms,
and produced no zero reductions; the next queue still had 180898 pairs.  This
is retained only as a resource measurement, never as theorem evidence.

The final exact route contracts away the 21 `b2` variables using verified
linear syzygies.  It has 37 `q` variables, six `b1` variables, and 48 dense
contracted equations in its smallest main packet, with 96- and 256-equation
variants used to test whether stronger overdetermination lowers the Groebner
degree.  Its terminal computations are the correct irrelevant saturations for
the boundary and normalized `b0=1` strata.

No Hilbert-series estimate, incomplete Groebner run, or empty solver output is
used as a decision criterion.  Only a completed saturated unit ideal, rebuilt
by the independent verifier, is accepted.

The strongest bounded boundary run retained all 256 verified contractions.
It used `2572.24 s` wall / `1812.78 s` user CPU, reached sampled RSS
`10710720 KiB`, and did not return the first `b1`-saturated basis.  This is the
measured resource floor in `saturation_attempts.json`; it is not theorem
evidence.  Since Stage B remains unresolved, Stage C is not interpreted.

Only one high-memory P25 solver should run at a time.  The shared machine has
128 GiB RAM; the binding route budget is 64 GiB, with live RSS monitoring and
no inference from timeout, crash, or empty output.
