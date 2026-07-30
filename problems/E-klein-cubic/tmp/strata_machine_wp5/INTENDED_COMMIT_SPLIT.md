# Intended commit split (WP-5 / Gate 4)

Headline remains **OPEN**.  Exit **P** (formal necessary state only).
No state-mutating git commands were run.

## Suggested commits (do not auto-apply)

### Commit 1 — WP-5 common + producer/verifier scaffold
```
certificates/global_transition/common_global.py
certificates/global_transition/produce.py
certificates/global_transition/verify.py
```
Message: `E strata machine WP-5: global transition scaffold (incidence, levels, necessity)`

### Commit 2 — WP-5 sealed JSON artifacts
```
certificates/global_transition/diagram.json
certificates/global_transition/dimension_tables.json
certificates/global_transition/level1_marked_states.json
certificates/global_transition/level2_inverse_limit.json
certificates/global_transition/necessity_theorem.json
certificates/global_transition/exit.json
certificates/global_transition/SEAL.json
```
Message: `E strata machine WP-5: sealed Level 1–2 diagram, necessity, Exit P`

### Commit 3 — documentation
```
certificates/GLOBAL_TRANSITION_DIAGRAM.md
```
Message: `E strata machine WP-5: GLOBAL_TRANSITION_DIAGRAM.md (Gate 4)`

## Not committed (scratch)
```
tmp/strata_machine_wp5/
```

## Explicitly not edited (concurrency)
```
HANDOFF.md
RESOLUTION.md
CURRENT_PATHS.md
SPEC.md
```

## Stop
Gate 4 complete (Levels 1–2 executed; Level 3 authorized but not decided;
Exit P).  Do **not** start WP-6 or WP-7.
