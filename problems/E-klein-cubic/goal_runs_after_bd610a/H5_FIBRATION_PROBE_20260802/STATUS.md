H5-UNDECIDED

# H5 modular residual fibration probe

**Pinned state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`
**H4 input:** `goal_runs_after_35fa/H_11_5_TWIST/` (`H-11_5-NORM-MODEL-PASS`)
**Parallel peer:** `H5_11_5_TRACE_CUBIC/`, `H5_WAVE2_LAURENT_PROJ/` (different files)
**Headline:** OPEN (Problem E unchanged)

## Exit

```text
H5-UNDECIDED
```

Discovery packet only.  Not a pointlessness claim, not a rational point, not a
Problem E headline.

## What was done

1. Bound H4 norm/twist/field payloads and H5 trace-cubic status by path+hash.
2. Specialized the weighted Klein form
   `G(x)=sum_i (1/r_{i+2}) x_i^2 x_{i+1}` on random product-one `r` over primes
   `[31, 41, 61, 71, 89, 101, 131, 151, 181, 199]` (holdout **199**).
3. Used the degree-five eigenpoint orbit `e_0..e_4` (index-one geometry) as
   projection centres.
4. Sampled residual binary quadrics on lines through each eigenpoint; classified
   fibres as contained-line / singular-double / split / nonsplit.
5. Recorded local solubility, heuristic singular-cubic hits, and exact (p≤41)
   or Monte-Carlo point-count estimates.
6. Wrote replay samples for an independent verifier.

## Points found over K

```text
none
```

## Next finite gate (unchanged)

Exact Laurent-support search with coefficients in `K`, or a complete toric
valuation with anisotropic residue, or an exact residual-fibration decision
over `K` (this packet is only modular discovery).

## Replay

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_FIBRATION_PROBE_20260802/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_FIBRATION_PROBE_20260802/verify.py
```

Terminal marker:

```text
H5_FIBRATION_PROBE_VERIFY_OK
```
