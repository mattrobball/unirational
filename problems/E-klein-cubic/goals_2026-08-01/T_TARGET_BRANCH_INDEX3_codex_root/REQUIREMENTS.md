# Requirement/evidence matrix

| Requirement | Result | Evidence |
|---|---|---|
| T0 exact fields and objects | pass | `T0_BRIDGE_LEDGER.md` distinguishes `C_fix`, the Morita projector space, and `X_gen` |
| T0 residue/properness arrow | pass, scoped | branch index three would imply only `C_fix(K_proj)=empty` |
| T0 headline arrow | refuted as available | binding `FAIL-SCOPE` audit and fixed-frame terminality audit explicitly leave simultaneous common isotropy separate |
| Exact route-destroying theorem | pass | smooth `C0/K` of index three occurs as a plane section of a smooth pointed cubic threefold `Y/K` |
| T1 generic normalization | stopped | mandatory T0 rule applies; it cannot repair the object mismatch |
| T2 conductor/local class groups | stopped | non-load-bearing after T0 |
| T3 global `Cl/Pic mod 3` | stopped | even the desired branch theorem would concern only `C_fix` |
| T4 negative headline | unavailable | Problem E remains open; no negative headline is claimed |
| Independent reconstruction | pass when replayed | `verify_route_refutation.py` rechecks source scope, valuation combinatorics, smoothness identities, point, and seal |
| Output contract | pass when replayed | `STATUS.md`, `THEOREM.md`, `proof_payload.json`, producer, verifier, `SEAL.json` |

The terminal work-order exit is `T-ROUTE-REFUTED`, not
`T-NEGATIVE-HEADLINE`.  This is a complete resolution of the commissioned
route and no resolution of the still-open Problem E headline.
