# Goal H completion audit

| Requirement | Evidence | Verdict |
|---|---|---|
| Isolated worker directory | `WORK_SCOPE.md`; all worker outputs are below this directory | satisfied |
| `BR-SUBGROUP-NEG` | `BRIDGE.md`, using Duncan--Reichstein Theorem 1.1 | proved |
| Genuine generic torsors | degree-zero constructions over `C(P2)^A5` and `C(P4)^(11:5)` | proved |
| Two maximal `A5` classes separate | disjoint exhaustive conjugacy orbits of eleven subgroups each | proved |
| Exact Hilbert--90 frames and twists | `a5_twist_payload.json`, `11_5_twist_payload.json`; independent determinant and covariance checks | proved |
| H-A divisorial obstruction | no index-three or local obstruction certified | not achieved; no claim made |
| H-B fixed/normalizer screen | no contradiction; exact contained lines solve `D12` and `D10` | decided at stated scope |
| H-C index | degrees `3` and prime-to-three orbit cycles | index exactly one for both `A5` classes and `11:5` |
| H-D direct point search | all homogeneous `A5` covariant landing schemes through degree nine; specified full-frame lines | bounded exclusion only |
| Secondary subgroup sweep | CTZ Theorem 5.1 plus maximal-subgroup classification | only two `A5` classes and `11:5` remain |
| Modular transfer | proper projective specialization for degree bounds; cubic constant-extension factor tests for frame lines | proved at recorded scope |
| Independent replay | `verify.py`, producer commands in `STATUS.md`, content hashes in `SEAL.json` | satisfied |
| Negative headline | no pointless twist proved | not achieved |

## Binary terminal verdict

The required negative theorem is not proved.  The work order expressly
permits the terminal exit `H-SWEEP-UNDECIDED`, and that is the exact verdict.
The smallest remaining theorem is

\[
X_{\tau_{H_1}}\bigl(\mathbf C(\mathbf P^2)^{H_1}\bigr)=\varnothing
\quad\text{or}\quad
X_{\tau_{H_1}}\bigl(\mathbf C(\mathbf P^2)^{H_1}\bigr)\ne\varnothing
\]

for the first recorded maximal `A5` class (equivalently, either `A5` class
may be attacked first).  No bounded computation in this packet is promoted
to that all-degree function-field decision.

## Concurrent packet audit

Repository commits `2301a43`, `9f58d6c`, and `53e267a` installed another
isolated Goal-H packet while this one was running.  Its same headline exit is
compatible, but its ranking leaves `A4` unresolved.  The July 18, 2026 CTZ
Theorem 5.1 proves the `A4` restriction unirational because it satisfies
Condition (A) and is absent from the exception list.  This packet therefore
uses the sharper theorem-backed boundary: maximal irreducible `A5` (two
classes) and maximal `11:5` only.
