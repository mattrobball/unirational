# G4 — induced degree-11 cycles

For each maximal A5 class the sealed H_A5 rational point on the corresponding
generic A5-twist (`point.json`, exit `H-A5-CLASS*-RATIONAL-POINT`) is induced
along \(G/H\) to a degree-11 closed point of the generic \(G\)-twist, identified
with \(X_{\mathrm{gen}}=V(\Phi)\) via G2/G3.

## Induction (executable content)

1. Coset action of image order 660 (`coset_actions.json`).
2. Finite etale algebra \(L_H/K_{\mathrm{proj}}\) of degree 11 (coset basis).
3. Binding to the sealed H_A5 point formula for that class.
4. Eleven coset-labeled geometric conjugates; Galois-stable as an unordered set.
5. \(\Phi=0\) by H_A5 landing + specialization/equivariance of the generic twist
   (not by ad-hoc numeric substitution in the G3 frame — that lift is G7B).
6. Cycle defined over \(K_{\mathrm{proj}}\), reduced on an explicit open, degree 11.

Marker: **`G4-INDUCED-DEGREE11-POINT-PASS`** (structural; not a ground-field point).

## Theorem boundary

- Does **not** construct a \(K_{\mathrm{proj}}\)-point of \(X_{\mathrm{gen}}\).
- Does **not** improve the index-one statement by itself.
- Explicit 5-tuples in the normalized G3 frame are a residual for G7B.
- H_A5 scope already records that the A5 points do not alone give a G-point;
  induction supplies the degree-11 cycle on the G-twist, not a rational point.
