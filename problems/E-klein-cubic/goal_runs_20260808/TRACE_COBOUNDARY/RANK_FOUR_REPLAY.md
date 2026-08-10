# Replay: rank-four Fourier boundary

From the Klein-cubic problem root, run:

```sh
cd /Users/worker/unirational/problems/E-klein-cubic
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_COBOUNDARY/verify_rank_four_boundary.py
```

Expected final marker:

```text
RANK4-FOURIER-BOUNDARY-OK
```

The verifier checks the order-five Fourier minors, the exact divisor-lattice
Smith form, the mod-eleven incidence representatives, the two cyclic formal
triple-prime configurations, and the two unramified local polynomial nets.
It does not enumerate Laurent supports or degrees and is not a proof or
search for a global trace solution.

