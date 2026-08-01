# Goal H2: exact generic `A4` twist

This packet decisively answers the goal with

```text
H-A4-RATIONAL-POINT
```

The installed generic `A4` twist of the Klein cubic has a rational point over
\(K_{A_4}=\mathbf C(\mathbf P^2)^{A_4}\).  The point is obtained from an
exact degree-three projective `A4`-equivariant map, not from the previously
recorded index-one computation.

Read in this order:

1. `STATUS.md` for the verdict and scope.
2. `FIELD_MODEL.md` for \(K_{A_4}=\mathbf C(u,v)\), the exact source
   intertwiner, and Hilbert--90 denominator open.
3. `TWIST_MODEL.md` for the sparse `1' + 1'' + 3` cubic, adapted frame, and
   fully reduced 35-coefficient equation over `C(u,v)`.
4. `FIBRATION_OR_VALUATION.md` for the structural section and exit.
5. `POINT_CERTIFICATE.md` and `POINT_CERTIFICATE.json` for the exact
   degree-zero point formula in the installed frame.
6. `BUG_AUDIT.md` for the transpose defect in the earlier degree search.
7. `REPLAY.md`, `verify_exact_point.py`, and `verify.py` for independent
   verification.

Authoritative exact payloads are `exact_degree3_map.json`,
`canonical_model.json`, `twist_over_Cuv.json`, `source_intertwiner.json`,
`transpose_audit.json`, and `degree3_character1_exact_chart0.sing`.
`SEAL.json` lists every authoritative file and its digest.

`INVALID_TRANSPOSED_DEGREE5/` is quarantined scratch data and is not sealed.
It must not be cited as evidence.
