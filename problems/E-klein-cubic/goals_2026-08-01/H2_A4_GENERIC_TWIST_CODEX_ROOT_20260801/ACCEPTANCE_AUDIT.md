# Goal H2 acceptance audit

Pinned state: `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
Installed object: the record labeled `A4` in
`H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json`

| Requirement | Evidence | Result |
|---|---|---|
| Decide the genuine generic twist, not a bounded ladder | `POINT_CERTIFICATE.md`; direct map into the installed twist | PASS |
| H2.0: explicit presentation of `K_A4` | `FIELD_MODEL.md`, `canonical_model.json`: `C(u,v)` | PASS |
| H2.0: relation to installed Hilbert--90 frame | exact matrix `P`, 12 seed forms, invariant transition `T` | PASS |
| H2.0: use `1' + 1'' + 3` and norm form | `TWIST_MODEL.md`, exact matrix `D`, five nonzero constants | PASS |
| H2.0: equation over the transcendence basis | `twist_over_Cuv.json`: all 35 coefficients, 22 nonzero | PASS |
| H2.0: opens and equivalence | both canonical and installed opens listed and checked | PASS |
| H2.1: structural route | adapted Fourier/norm frame; no unsupported fibration claim | PASS |
| H2.2: valuation obstruction if no point | not applicable because an exact point exists | N/A |
| H2.3: exact coordinates in `K_A4` | `(M/(Sxyz))*A_inst(P y)^(-1)*Phi_p(y)` | PASS |
| H2.3: exact substitution | `F(A_inst Z_K)=(M/(Sxyz))^3 F(Phi_p)=0` | PASS |
| H2.3: every denominator | explicit open plus 12 serialized linear forms | PASS |
| Explain equivariant-map origin and full-group scope | `POINT_CERTIFICATE.md`, `STATUS.md` | PASS |
| Independent verifier | `verify_exact_point.py` does not import any local producer | PASS |
| Correct stale bounded-search premise | `BUG_AUDIT.md`, eight direct failures | PASS |
| Required named files and exact payloads | present in this sealed directory | PASS |

## Requirement-level conclusion

The mission is fully decided with exit `H-A4-RATIONAL-POINT`.  The generic
installed `A4` twist has a rational point over `K_A4`.  The subgroup route
therefore cannot yield `BR-SUBGROUP-NEG` from `A4`.

No statement here upgrades this to a full `PSL_2(F_11)` result.

