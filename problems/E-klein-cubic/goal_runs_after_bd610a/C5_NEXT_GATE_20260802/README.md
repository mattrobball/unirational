# C5 next gate — Morita record interpreter (2026-08-02)

Non-clobbering worktree for the C / C5 Fano–common-line front.

## Read first

- `NEXT_GATE.md` — exact missing object and planned certificate
- `STATUS.md` — `C5-UNDECIDED` plus partial marker
- `NOT_TO_DO.md` — stale RUR quarantine and prohibitions

## Upstream (read-only)

```text
goals_after_bd610a/C5_PROJECTOR_INCIDENCE/
goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/
goals_after_35fa8f/GOAL_C_EXPLICIT_MORITA_AND_COMMON_LINE.md
goals_2026-08-01/GOAL_C_PFAFFIAN_FANO_POINT.md
```

## Produce / verify

```sh
PYTHONDONTWRITEBYTECODE=1 python3 -u produce_record_interpreter.py
PYTHONDONTWRITEBYTECODE=1 python3 -u verify_record_interpreter.py
```

Expected terminal marker:

```text
C5-MORITA-RECORD-INTERPRETER-P23-PASS
```
