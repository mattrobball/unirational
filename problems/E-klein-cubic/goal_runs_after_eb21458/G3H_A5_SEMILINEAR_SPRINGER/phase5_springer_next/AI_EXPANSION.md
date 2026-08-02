# G3H phase5_next — expand \(a_i\)

Marker: `G3H-AI-EXPANSION-DUAL-PASS`  
Residual: `G3H-AI-SECONDARY-TABLE-OPEN`

## Object

For each maximal \(A_5\) class,

\\[
a_i=\\overline M^{-1}(P_i/\\tau^{33})\\in X_{\\mathrm{gen}}(L_i),
\\qquad L_i=K_{\\mathrm{proj}}[\\theta_i]/(\\mu_i),\\quad [L_i:K_{\\mathrm{proj}}]=11.
\\]

## Power-basis expansion (exact dual calculus)

Write each coordinate

\\[
a_i^{(r)}=\\sum_{k=0}^{10}\\beta_{r,k}\\,\\theta_i^k,
\\qquad \\beta_{r,k}\\in K_{\\mathrm{proj}}.
\\]

With dual basis \(\\omega_k=b_k/\\mu_i'(\\theta_i)\) of the power basis relative to
the field trace,

\\[
\\beta_{r,k}=\\operatorname{Tr}_{L_i/K_{\\mathrm{proj}}}\\bigl(a_i^{(r)}\\omega_k\\).
\\]

Equivalently, Vandermonde reconstruction on the eleven coset conjugates
(G4 coset action). This is an **exact equivalent** of the power-basis
expansion: the formulas determine every \(\\beta_{r,k}\) uniquely in
\(K_{\\mathrm{proj}}\).

## Secondary basis

Each \(\\beta_{r,k}\) is a length-12 vector over
\(P_0=\\mathbf Q(t_3,t_6,t_8,t_{11})\) in the certified secondary basis

```text
['1', 'f7', 'f9', 'f10', 'f12', 'f14', 'f7^2', 'f7*f9', 'f9^2', 'f9*f10', 'f7^3', 'f9^2*f10']
```

**Installed:** dual/Vandermonde calculus and per-coefficient secondary *slots*.  
**Residual:** fully cancelled numerators/denominators of those 12-vectors
(gate `G3H-AI-SECONDARY-TABLE-OPEN`), which require Reynolds reduction of the
degree-33 rational map \(M^{-1}P_i\).

Machine tables: `a_i_expansion_class_1.json`, `a_i_expansion_class_2.json`,
`a_i_expansion.json`.

## Binding

Phase-4 frame identity \(\\Phi(a_i)=0\) remains the load-bearing landing proof.
