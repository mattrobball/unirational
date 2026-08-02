# C5 multiprime Morita holdout (2026-08-02)

Read-only upstream:

- `goals_after_bd610a/C5_PROJECTOR_INCIDENCE/` (sealed Morita DAGs)
- `goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/` (modular RUR + c2)

## Files

| File | Role |
|---|---|
| `produce_multiprime_morita.py` | multiprime fibre builder + stored-factor walk |
| `verify_multiprime_morita.py` | independent rebuild + checks (no producer import) |
| `multiprime_ledger.json` | machine ledger / open witnesses / checksums |
| `STATUS.md` | `C5-UNDECIDED` + partial marker |
| `REPLAY.md` | exact replay commands |
| `NOT_TO_DO.md` | quarantines |

## Marker

```text
C5-MORITA-MULTIPRIME-HOLDOUT-PASS
```

Exit remains `C5-UNDECIDED` (no `K_proj` point).
