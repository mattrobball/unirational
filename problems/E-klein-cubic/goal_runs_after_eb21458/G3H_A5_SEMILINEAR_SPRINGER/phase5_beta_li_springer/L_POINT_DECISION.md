# G3H phase5_bls — L_i-point on K_proj quadrics

Marker: `G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO`  
Closed gate: `G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN` with **NO** for the attempted family.

## Springer quadratic-form theorem

Let k be a field of characteristic not 2 and q a quadratic form over k. Let L/k be a finite field extension of odd degree. Then q has a nontrivial zero over L if and only if q has a nontrivial zero over k.

**Application:** Q_q(L_i) ≠ ∅  ⇔  Q_q(K_proj) ≠ ∅

## Non-containment

At the sealed secondary-0 specialization, rank(Q_q)=5 and a positive density of F_p-points of the specialized cubic lie off Q_q. Therefore the cubic hypersurface is not contained in Q_q as schemes over the specialization, hence not over K_proj. Membership of a point of X_gen in Q_q is an independent condition from Phi=0.

Sample (secondary-0, p=97):
397 cubic points off Q_q vs
3 on Q_q
(fraction off = 0.9925).

## Attempts

| Name | Status | Decision |
|---|---|---|
| `a_i_on_Q_q` | NO | NOT_A_POINT_OF_Q_q_FORCED |
| `a_i_on_H_q` | NO | NOT_QUADRATIC_OBJECT |
| `line_residual_binary` | NO | REJECTED_NOT_OVER_K_proj |
| `galois_norm_of_residual_direction` | NO | NO_SEALED_ISOTROPIC_VECTOR |
| `any_L_i_point_on_Q_q` | NO | EQUIVALENT_TO_K_proj_SOLUBILITY_G3P_RESIDUAL |
| `trace_polar_Q_Tr_a_i` | CONDITIONAL | L_i_POINT_IF_FORM_NONDEGENERATE_MAPBACK_ABSENT |
| `polar_pencil_fibre` | NO | NOT_SEALED |

## Conclusion

For the attempted family (a_i on Q_q; residual line; Galois norms; any L_i-point on Q_q; trace polar; pencil): no certified L_i-point of Q_q is obtained from a_i; existence of any L_i-point on Q_q is Springer-equivalent to the unsolved G3P K_proj residual; conditional trace-polar point lacks map-back and nondegeneracy certificate.

Machine ledger: `L_point_decision.json`, `noncontainment_Xgen_Qq.json`,
`springer_quadratic_form.json`.
