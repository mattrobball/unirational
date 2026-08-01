# Goal R2 completion audit

## Binary exit verdict

- `R2-RATIONAL-CURVE-HEADLINE-POSITIVE`: **not achieved**.
- `R2-HILBERT-COMPONENT-PASS`: **not achieved**.
- `R2-SELECTED-CLASSES-EMPTY-SCOPED`: achieved for lines, conics, and the
  marked-chord quartic incidence, but not used as the terminal exit.
- `R2-DESCENT-OBSTRUCTED`: **achieved** for the selected Pfaffian
  elliptic-normal-quintic/residual-quartic route.
- Problem E headline: **OPEN**.

## Requirement map

| Work package | Required evidence | Delivered evidence | Verdict |
|---|---|---|---|
| R2.0 ranking | lines/conics, cubics, rational quartics/quintics, higher free curves, degree-55 incidence | `CLASS_RANKING.md`, including expected \(2e\) rule, evaluation dimensions, special-fibre and field boundaries | complete |
| R2.1 component | descended component, Galois action, universal model, tangent-obstruction, point or controlled zero-cycle | `DESCENDED_HILBERT_COMPONENT.md` and two JSON payloads; fibre is \(\operatorname{SB}(A^{op})\), index two | complete at obstruction exit |
| integrality | theorem or exact genuine component member | independent smooth prime degree-five good reduction, Hilbert polynomial \(5t\) | complete |
| universal equations | equations and original-cubic containment | all entries of \(M,A\), six equations \(A\lambda=0\); Pfaffian equals original Klein cubic | complete |
| tangent/obstruction | \(H^0(N)\), \(H^1(N)\) | Macaulay2 \(h^0=10\); Riemann--Roch \(\chi(N)=10\), hence \(h^1=0\) | complete |
| descent data | action and base-field point/zero-cycle | \(H^0(E_0(1))=V_6^*\); twist is \(\operatorname{SB}(A^{op})\); index two | complete |
| R2.2 extraction | explicit field chain | `POINT_EXTRACTION.md`; genus-zero secant and elliptic \(\operatorname{Pic}^2\) gates | complete for obstruction exit |
| R2.3 certification | producer, independent verifier, substitution | local universal and descent producers/verifiers | complete |
| seal | deterministic manifest, independent check | `SEAL.json`, `make_seal.py`, `verify_seal.py` | complete after replay |

## Why the obstruction proves the selected exit

Every possible \(K_{\rm proj}\)-point of the selected Hilbert component maps
to the unique Abel--Jacobi value \(q_2\), hence to the unique Pfaffian bundle
\(E_0\). Its complete section fibre is the nonsplit Severi--Brauer fivefold
of index two. Therefore the component has no \(K_{\rm proj}\)-point. This
proves a field-theoretic obstruction to descent of a curve, not just failure
of a search.

## Strict boundaries

- The output does not construct a rational curve or a point.
- The elliptic-quintic obstruction is not promoted to rational quartics,
  rational quintics, or all higher curves.
- A smooth split-field sample is not treated as a base-field member.
- General Abel--Jacobi fibre geometry is not applied to the distinguished
  fixed fibre without proof.
- The nonzero class over \(K_{\rm proj}\) is not transferred to the distinct
  Schur-source field.
- Modular geometry is lifted only to the split component; it is not used to
  prove the Brauer obstruction or a headline theorem.

