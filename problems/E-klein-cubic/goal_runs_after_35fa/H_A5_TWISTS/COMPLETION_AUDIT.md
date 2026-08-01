# Completion audit

| requirement | result | evidence |
|---|---|---|
| H3.0: preserve and compare both embeddings | PASS | `COMPARISON.md`, `canonical_model_payload.json`, independent Reynolds verifier |
| H3.1: small exact models over a transcendence basis | PASS | `FIELD_MODEL.md`, `minimal_model_payload.json`, `build_minimal_model.py` |
| Equivalence with original frame equation | PASS | authoritative-frame checks in `build_canonical_model.py`; invariant coordinate change in `FIELD_MODEL.md` |
| H3.2: explicit covariant attack | PASS | five exact degree-11 Reynolds covariants in `common/exact_degree11.py` |
| H3.3 class 1 decision | `H-A5-CLASS1-RATIONAL-POINT` | class 1 exact dp/lex inputs, transcripts, JSON, and `POINT.md` |
| H3.3 class 2 decision | `H-A5-CLASS2-RATIONAL-POINT` | separate class 2 exact dp/lex inputs, transcripts, JSON, and `POINT.md` |
| Exact coordinates | PASS | each JSON contains a monic cubic for `theta` and linear formulas for `a3,a2,a1`; `a0=1` |
| Complete landing identity | PASS | exact degree-33 dimension/evaluation-determinant verifier; all six equations reduce to zero |
| Substitute in genuine twist | PASS | `[z_i]=[A_i^-1 J_i Phi_i]`, hence `F(A_i z_i)=F(J_i Phi_i)=0` |
| Independent verification | PASS | the three scripts in `independent/` recompute the canonical model, degree-33 injectivity, and Singular landing certificate; `common/verify_exact_points_direct.py` additionally substitutes both points directly in the cubic constant-field quotient |
| Separate class directories and one seal | PASS | each class has `field_model.json`, `twist_equation.json`, two point payloads, a class verifier, and the root has one `SEAL.json` |
| No modular promotion | PASS | mod 89 is used only to certify exact determinants/ranks by nonzero reduction; nonemptiness is exact characteristic zero |
| No Magma dependency | PASS | Python/SymPy and Singular only |

The earlier Hensel claim is deliberately excluded: solving four selected
equations modulo powers of 89 does not force the complete landing ideal, and
an independent audit found no lift already modulo \(89^2\).  The final
verdict instead rests on exact characteristic-zero Gröbner and FGLM
certificates.

The maps obtained are `A5`-equivariant rational maps
\(\mathbf P^2\dashrightarrow X\).  Their image has dimension at most two,
so this packet does not claim dominance, `A5`-unirationality, or any
affirmative implication for the full group \(G=\operatorname{PSL}_2(\mathbf
F_{11})\).  Since neither twist is pointless, this route supplies no
`BR-SUBGROUP-NEG` headline.
