# G3H theorem boundary

## Proved in this packet

1. **G7B e0 quarantine.** The map gH |-> [rho(g)e_0] is not well-defined on
   cosets and is not G-equivariant. Historical G7B files are not rewritten.
2. **Cubic compression.** For both maximal A5 classes,
   dim Hom_A5(Sym^3 W, U_i)=1. Explicit normalized Y_i with formal
   equivariance on all 60 elements and a nonzero Jacobian minor.
3. **Semilinear landing.** P_i = Psi_i o Y_i satisfies F_Klein(P_i)=0 by the
   sealed H-A5 identity F(Psi_i(y))=0, and is A5-equivariant of degree 33.
4. **G3-frame L_i-points.** On the covariant-frame open,
   a_i = Mbar^{-1}(P_i/tau^{33}) is H_i-invariant, hence L_i-valued with
   [L_i:K_proj]=11, and Phi(a_i)=0 by F(M a_i)=F(P_i)=0.
5. **Power-basis dual calculus for a_i.** Each coordinate expands uniquely as
   sum_k beta_{r,k} theta^k with beta_{r,k}=Tr(a_i^{(r)} omega_k) in K_proj
   (dual basis of the power basis). Vandermonde reconstruction on coset
   conjugates is equivalent. Marker `G3H-AI-EXPANSION-DUAL-PASS`.
6. **Polar structure constants.** A=Phi(q), second-polar form L, and
   first-polar matrix M are fully expanded in the secondary basis of
   K_proj. C=L·a_i and D=a_i^T M a_i are installed as L_i-elements with
   those structure constants.
7. **Springer interface honesty.** Q_q is over K_proj and the degree is odd,
   but no certified L_i-point of Q_q and no map-back theorem are installed.
   Scoped no-go; illegal cubic odd-degree descent rejected.

## Residuals

- Cancelled secondary-basis numerators/denominators of each beta_{r,k}
  (`G3H-AI-SECONDARY-TABLE-OPEN`).
- Certified L_i-point on a K_proj quadratic
  (`G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN`).
- Explicit map-back Q_q --> X_gen (`G3H-SPRINGER-MAPBACK-OPEN`).
- No K_proj-point of X_gen.
- No Springer reduction pass.

## Forbidden claims (not made)

- rho(g_i)e_0 as induced cycles
- Q_q(L_i) nonempty => X_gen(K_proj) nonempty without map-back
- pure cubic odd-degree descent
- Problem E headline

## Phase5 BLS addendum (Route-1 kill)

7. **Springer quadratic-form theorem on \(Q_q\).** With \([L_i:K_{\mathrm{proj}}]=11\)
   odd, \(Q_q(L_i)\ne\varnothing\Leftrightarrow Q_q(K_{\mathrm{proj}})\ne\varnothing\).
8. **Non-containment** \(X_{\mathrm{gen}}\not\subset Q_q\) (specialization certificate).
9. **Secondary β obstruction.** Cancelled secondary tables blocked by
   degree-33 Reynolds expansion; dual-trace remains the abstract determination.
10. **Route-1 kill.** Springer via \(Q_q\) closed as an interface for producing
    \(L_i\)-isotropy from \(a_i\); map-back unsealed; no headline.

See `phase5_beta_li_springer/THEOREM_BOUNDARY_BLS.md`.
