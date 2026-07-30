# Intended commit split (director verifies and commits; worker cannot write .git)

## Commit 1 — WP-0 input audit
- certificates/STRATA_MACHINE_INPUT_AUDIT.md

## Commit 2 — WP-1 strata machine (Gate 1 packet)
- certificates/strata/group_subgroups.g
- certificates/strata/exact_strata.py
- certificates/strata/verify.py
- certificates/strata/geometry.sage
- certificates/strata/strata_exact.json
- certificates/strata/incidence_exact.json
- certificates/STRATA_EXACT.md

## Do not include
- tmp/strata_machine_wp01/ (scratch logs)
- HANDOFF.md / RESOLUTION.md / CURRENT_PATHS.md / SPEC.md (concurrent worker; director integrates)

## Replay
/opt/homebrew/Caskroom/miniforge/base/bin/gap -q certificates/strata/group_subgroups.g
/opt/homebrew/bin/python3 certificates/strata/exact_strata.py
/opt/homebrew/bin/python3 certificates/strata/verify.py

AUDIT_SHA256=017526b15883cd90b2d618c6b32d467de08e3a76a1d9e44a616e41fc48c7ff74
EXACT_SHA256=0bbb1efae414e8fd87bdad5925645f2694ee5ecb5fc30bdfe02c9434eb07c6dc
