# Scope correction for G7B

Do not consume `G7-INDUCED-DOUBLE-CYCLE-PASS` as a degree-eleven cycle in the
normalized G3 frame.

The assignment

```text
gH -> [rho(g)e0]
```

requires `[e0]` to be H-fixed. It is not. Changing a coset representative
changes the projective point, and the claimed point permutation is not the
coset action.

What remains valid:

- the abstract degree-eleven étale algebra `L_H/K_proj`;
- the H-A5 semilinear point;
- the Paley `2-(11,5,2)` incidence matrix between the two coset algebras;
- projective multihomogeneous formulas and the warning against silent sums.

The corrected point is the circuit

```text
a_H(w)=B_G3(w)^(-1) Psi_H(Y_H(w))
```

from `THEOREM.md`. It is H-invariant and therefore an `L_H`-point without
choosing constant split representatives.
