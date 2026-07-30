# Intended commit split (WP-4 / Gate 3)

Headline remains **OPEN**.  No state-mutating git commands were run.

## Suggested commits (do not auto-apply)

### Commit 1 — WP-4A involution-plane module
```
certificates/transitions/common.py
certificates/transitions/involution_plane/produce.py
certificates/transitions/involution_plane/verify.py
certificates/transitions/involution_plane/module.json
```
Message: `E strata machine WP-4A: involution-plane bigraded module + odd-order theorem`

### Commit 2 — WP-4B D12 binary line module
```
certificates/transitions/d12_binary_line/produce.py
certificates/transitions/d12_binary_line/verify.py
certificates/transitions/d12_binary_line/module.json
```
Message: `E strata machine WP-4B: free D12 binary covariant module + endpoint classification`

### Commit 3 — WP-4C V4 fixed line + charges
```
certificates/transitions/v4_fixed_line/produce.py
certificates/transitions/v4_fixed_line/verify.py
certificates/transitions/v4_fixed_line/module.json
```
Message: `E strata machine WP-4C: V4 line forced base, jet module, E[2] charge tracking`

### Commit 4 — WP-4D C3 lines + 220 remainder closed
```
certificates/transitions/c3_lines/produce.py
certificates/transitions/c3_lines/verify.py
certificates/transitions/c3_lines/module.json
certificates/transitions/c3_lines/disc_identity.m2
```
Message: `E strata machine WP-4D: C3 eigenlines, char-0 reduced X-section, close 220 remainder`

### Commit 5 — WP-4E point links
```
certificates/transitions/point_links/produce.py
certificates/transitions/point_links/verify.py
certificates/transitions/point_links/module.json
```
Message: `E strata machine WP-4E: D10/D12/A4 point-link modules with incident flags`

### Commit 6 — documentation + seal
```
certificates/LOCAL_TRANSITION_MODULES.md
certificates/transitions/SEAL.json
```
Message: `E strata machine WP-4: LOCAL_TRANSITION_MODULES.md + Gate 3 seal`

## Not committed (scratch / concurrent worker)
```
tmp/strata_machine_wp4/
```

## Explicitly not edited (concurrency)
```
HANDOFF.md
RESOLUTION.md
CURRENT_PATHS.md
SPEC.md
```

## Stop
Gate 3 complete.  Do **not** start WP-5 (global diagram) or WP-6.
