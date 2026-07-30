# Intended commit split (WP-6 / Gate 5)

Headline remains **OPEN**. Support **NOT DECIDED** (memory-gate STOP with
formulation). Exit **P** carried forward as a necessary formal state only.
No state-mutating git commands were run.

## Suggested commits (do not auto-apply)

### Commit 1 — producer / verifier scaffold
```
certificates/border_support/common.py
certificates/border_support/produce.py
certificates/border_support/verify.py
```
Message: `E strata machine WP-6: border-support producer/verifier scaffold`

### Commit 2 — sealed sparse translation and formulation
```
certificates/border_support/translation.json
certificates/border_support/c3_a4_c6_blocks.json
certificates/border_support/restricted_module.json
certificates/border_support/support_status.json
certificates/border_support/sparse_blocks.npz
certificates/border_support/SEAL.json
```
Message: `E strata machine WP-6: sealed sparse translation and STOP formulation (Gate 5)`

### Commit 3 — proof note
```
certificates/BORDER_SUPPORT.md
```
Message: `E strata machine WP-6: BORDER_SUPPORT.md (support not decided)`

## Not committed (scratch)
```
tmp/strata_machine_wp6/
```

## Explicitly not edited (concurrency)
```
HANDOFF.md
RESOLUTION.md
CURRENT_PATHS.md
SPEC.md
```

## Explicitly not written
```
WP-7
```

## Stop
Gate 5: sparse nonlinear support formulation complete; decisive Fitting /
saturation beyond 8 GiB exploratory ceiling returned to director gate.
Do **not** start WP-7.
