# certificates/fold_t11b — T11.1 Route C

Exact localized syzygies for the fold chart `(P_B,P_Y,P_Z)` over `(A,u)`.

| File | Role |
|---|---|
| `ROUTE_C.md` | human narrative + obstruction |
| `exit_t11b.json` | machine exit `T11B-UNDECIDED` |
| `produce_routeC.py` | producer |
| `verify_routeC.py` | independent verifier |
| `verify_routeC_result.json` | verifier result |

Run verifier:

```bash
/opt/homebrew/bin/python3 certificates/fold_t11b/verify_routeC.py
```

Does not write to `certificates/fold_t11/` (sealed). Does not touch P25V paths.

**Headline:** **OPEN**
