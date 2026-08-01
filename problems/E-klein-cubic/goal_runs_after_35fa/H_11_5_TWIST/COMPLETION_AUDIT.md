# Requirement-by-requirement completion audit

| Goal-H4 requirement | Authoritative evidence | Verdict |
|---|---|---|
| Consume pinned genuine `11:5` twist | `SOURCE_BINDING.md`; independent reconstruction of canonical p=89 frame and all 35 coefficients | proved |
| Minimal invariant-field presentation | `FIELD_MODEL.md`, `field_model.json`: `K=C(U1,U2,U3,U4)` with forward and inverse DFT maps | proved |
| Adapt to normal `C11` and quotient `C5` | exact lattice determinant `11`, cyclic `r_i`, degree-five Fourier/Kummer layer | proved |
| Degree-eleven layer | `beta^11=r0^2*r1*r3^4/r2^4`, exact `sigma(beta)`, and inverse reconstruction of all projective `y_i` | proved |
| Rewrite genuine twist in norm/resolvent coordinates | `TWIST_MODEL.md`, `NORM_MODEL.md`: `Tr_E/K(r2^-1*a^2*sigma(a))=0` | proved |
| Forward and inverse equivalence with canonical frame | `C=A^-1B in GL5(K)`, maps `u=Cz`, `z=C^-1u`, common open, independent finite-field replay | proved |
| Analyze norm/torus class | norm one; degree-33 isogeny; exact order-eleven coefficient class | proved |
| Degree-five eigenpoint orbit | explicit `Z0(T)` point over `E`; canonical orbit sources hash-bound | proved |
| Index | effective degrees `3` and `5`, hence index one | proved; not promoted to a point |
| Direct point search | all pure Laurent monomials excluded | scoped only |
| `K`-rational point | `decision.json` records `null` | not achieved; no claim |
| Valuation/unramified obstruction | `decision.json` records `null` | not achieved; no claim |
| Pointlessness and `BR-SUBGROUP-NEG` | bridge is exact, but its premise is absent | does not fire |
| Independent verifier | `verify.py` imports no producer and reconstructs all load-bearing algebra | satisfied |
| Hash seal | `SEAL.json`, checked for exact durable-file equality | satisfied |
| Output location and inventory | this isolated directory; `README.md` | satisfied |

## Exit audit

The goal explicitly permits `H-11_5-NORM-MODEL-PASS`.  This packet meets
that exit's exact boundary: it provides a minimal invariant field, complete
degree-five/degree-eleven tower, a genuine norm-trace equation, and
bidirectional equivalence with the canonical twist.  It does not relabel
the unresolved rational-point question as solved.

The smallest remaining theorem is

\[
 r_2^{-1}\psi(E^*)\cap\ker(\operatorname{Tr}_{E/K})\ne\varnothing\ ?
 \qquad \psi(a)=a^2\sigma(a).
\]

Accordingly the Goal-H4 work order is complete at
`H-11_5-NORM-MODEL-PASS`, while the original Klein-cubic headline remains
**OPEN**.
