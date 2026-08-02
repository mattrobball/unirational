# G3H phase5_bls — secondary β tables

Marker: `G3H-AI-SECONDARY-TABLE-OBSTRUCTION`  
Closed gate: `G3H-AI-SECONDARY-TABLE-OPEN` (as **named exact obstruction**)

## Demand

For both A5 classes and all coordinates of

\[
a_i^{(r)}=\sum_{k=0}^{10}\beta_{r,k}\,\theta_i^k,
\qquad \beta_{r,k}\in K_{\mathrm{proj}},
\]

produce cancelled secondary 12-vectors (numerators/denominators over
\(P_0=\mathbf Q(t_3,t_6,t_8,t_{11})\) in basis

```text
['1', 'f7', 'f9', 'f10', 'f12', 'f14', 'f7^2', 'f7*f9', 'f9^2', 'f9*f10', 'f7^3', 'f9^2*f10']
```

). Dual-trace formulas alone are insufficient for this gate.

## Decision

**Obstruction:** `DEGREE-33-REYNOLDS-SECONDARY-EXPANSION`.

For each of the 55 power-basis coefficients β_{r,k} ∈ K_proj of a_i (both A5 classes: 2×55), a cancelled secondary 12-vector (numerators/denominators over P0 in the certified secondary basis) is exactly the image of β_{r,k} under the structure isomorphism K_proj ≅ P0^{12} (secondary model). Computing that image from the geometric definition a_i = Mbar^{-1}(P_i/τ^{33}) requires G-invariant reduction (Reynolds projection / SAGBI elimination) of a degree-33 equivariant rational map on P(W) into the secondary generators of degrees [0, 7, 9, 10, 12, 14, 14, 16, 18, 19, 21, 28]. Dual-trace / Vandermonde formulas determine β_{r,k} as abstract elements of K_proj but are not a secondary expansion. This packet records the obstruction and does not install fake cancelled tables.

### Complexity

Ambient composition degree 33; secondary top degree 28; invariant ring of PSL_2(F_11) on P^4; full symbolic Reynolds for all 55 coefficients exceeds the sealed local-CAS budget of this residual close-or-kill run. Modular multipoint witnesses can probe individual specializations but do not replace cancelled generic secondary numerators.

### Installed vs not

- Installed: dual-trace / Vandermonde calculus (phase5_springer_next,
  `G3H-AI-EXPANSION-DUAL-PASS`); per-slot obstruction tags for all 2×55 coefficients.
- Not installed: cancelled secondary numerators/denominators.

Machine ledger: `secondary_beta_decision.json`.
