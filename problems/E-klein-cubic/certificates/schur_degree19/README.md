# Attempt 3 — Schur degree-19 rescue curve (Gates 1–2)

**Decision exit:** `STOP-3`  
**Headline:** OPEN  
**Base pin:** `b7be961`

## Replay

```bash
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u \
  certificates/schur_degree19/verify.py
```

Expected markers:

```text
SCHUR_DEGREE19_GATES_1_2_VERIFY_OK
SCHUR_DEGREE19_DECISION_STOP_3
HEADLINE_OPEN
```

## Deliverables

| File | Role |
|---|---|
| `IMPLICATION_AUDIT.md` | Gate 1 (3B): implication chain + house rule 10 |
| `betti_tables.json` | rejected and live Betti / generator patterns |
| `rao_resolutions.md` / `.json` | Task 3C.1 |
| `marked_hilbert.md` / `.json` | Task 3C.2 over \(F\) |
| `quintic_carriers.md` / `.json` | Task 3C.3 |
| `verify.py` | independent verifier (does not import a producer) |
| `SEAL.json` | sealed decision + content hashes |

## Boundary

No qualifying curve is constructed.  Neither Rao branch is excluded.
Gate 3 (3D) was not entered.  Problem E remains OPEN.
