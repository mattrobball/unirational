G3P-UNDECIDED

# Corrected A5 semilinear materialization and polar test

**Pinned main:** `eb21458bea684d2399ad18f003e2be8ebdd161ce`  
**Headline:** OPEN

Scoped markers:

```text
G3P-A5-SEMILINEAR-MATERIALIZATION-PASS
G3P-A5-CANONICAL-POLAR-MISS
G3P-A5-CLASSIFYING-DEGREE-LE4-POLAR-EMPTY
```

The genuine degree-eleven A5 points are now expressed in the normalized G3
frame by the H-invariant circuit

```text
a_H(w)=diag(tau^(1,4,5,6,7))*B_poly(w)^(-1)*J_H*Phi_H(Y_H(w)).
```

For each maximal A5 class, `Y_H` is the unique cubic classifying covariant and
is dominant. The pulled-back point lands on `X_gen`, but exact good-reduction
witnesses show that it lies on neither canonical polar `H_q` nor `Q_q`.
The complete constant-coefficient classifying-map family through degree four
is likewise excluded from both polar identities.

Therefore the missing coordinate gate is closed, but the direct quadratic
Springer gate fails for the canonical low-degree maps. The first remaining
constant-coefficient map family has degree five and dimension five. The local
CAS order for that family and for a genuine quadratic inverse is
`CAS_NEXT_ORDER.md`.

No external CAS was used in this packet. Problem E remains open.
