# Independent audit: exact degree-11 landing and installed-twist bridge

Status: **PASS for both installed maximal `A5` twists**, using the exact
characteristic-zero six-evaluation/lexicographic certificates.  The earlier
`class_*_hensel.json` argument is invalid and is not used here.

## 1. Class parameters and outer relation

Let `C0,C1` denote the rational nullspace basis (elsewhere called
`B0,B1`) in
`canonical_a5_pencil.py`, and let `O0,O1` be the two orbit sums in
`exact_reynolds.py`.  The independent Reynolds verifier constructs the two
ten-element orbits of triples directly and checks

```text
O0 = -C0,   O1 = -C1.
```

Thus the common minus sign does not change the pencil parameter.  With
`r=sqrt(-11)`, the exact transported Klein cubics have parameters

| installed record | nullspace/orbit parameter |
|---|---|
| `A5_class_1` | `(13-r)/18` |
| `A5_class_2` | `(13+r)/18` |

They are the two roots of `9*T^2-13*T+5`.  Conjugation by
`diag(1,-1)` in `PGL_2(F_11)` maps the exact chosen generators and every
entry of the recorded source map for class 1 to those of class 2.  On the
Weil representation this is `zeta_11 -> zeta_11^-1`, hence `r -> -r`.

## 2. Why six evaluations prove the full identity

For the faithful icosahedral source,

```text
k[y0,y1,y2]^A5 = k[f2,f6,f10] + f15*k[f2,f6,f10]
```

with degrees `2,6,10,15`.  Therefore the degree-33 invariant space is the
six-dimensional space

```text
f15 * <f2^9, f2^6*f6, f2^3*f6^2, f6^3, f2^4*f10, f2*f6*f10>.
```

The exact Reynolds covariants are degree 11 and equivariant, and each target
cubic is invariant.  Hence its composition with a linear combination of the
five covariants is an invariant source form of degree 33.  The evaluation
matrix at

```text
(1,2,3), (1,2,4), (1,2,5), (1,2,6), (1,2,7), (1,3,2)
```

has rank six after reduction at `sqrt(5)=19 mod 89`.  The displayed rank
minor is the reduction of an exact minor, so it is nonzero in characteristic
zero.  Since the source invariant space has dimension six, evaluation is
injective.  Consequently the six cubic parameter equations are equivalent
to the full polynomial landing identity; they are not a point sample.
The independent exact `Q(sqrt(5))` determinant replay gives residue `79`
modulo 89.

For each class, the exact lexicographic basis is triangular:

```text
J1 = a4^3 + ...
J2 = a3 + q2(a4)
J3 = a2 + q3(a4)
J4 = a1 + q4(a4),
```

all six original equations reduce to zero, and `VDIM=3`.  Thus, for any root
`theta` of `J1`, the transcript gives the exact point

```text
[1 : -q4(theta) : -q3(theta) : -q2(theta) : theta].
```

The coefficient field is `E=Q(w)`, where

```text
w=sqrt(5)+sqrt(-11),
w^4+12*w^2+256=0,
sqrt(5)=(4*w-w^3)/32,
sqrt(-11)=(w^3+28*w)/32.
```

Choosing `theta` in an algebraic closure of `E` is legitimate over the
installed invariant field `K=C(U,V)`: the constant field `C` already contains
an algebraic closure of `E`.  No algebraic extension of `K` is introduced.

## 3. Verification in the original installed twist

For class `i`, let `A_i(y)` be the installed Hilbert--90 frame, let `J_i` be
the exact constant intertwiner, and put `B_i(y)=J_i^-1*A_i(y)`.  Let
`Phi_i(y)` be the degree-11 covariant obtained from the triangular parameter
point above.  The checked identities are

```text
A_i(h*y)   = rho_i(h)*A_i(y),
J_i*U(h)   = rho_i(h)*J_i,
Phi_i(h*y) = U(h)*Phi_i(y),
(C0 + lambda_i*C1)(Phi_i(y)) = 0.
```

On the nonempty frame open, define

```text
z_i(y) = A_i(y)^-1 * J_i * Phi_i(y).
```

The first three identities give `z_i(h*y)=z_i(y)`.  The frame has degree
zero while `Phi_i` is homogeneous, so the projective vector descends to
`P^4(K)`.  Also `a0=1` and the five covariants are linearly independent, so
`Phi_i` is not the zero covariant.  Finally,

```text
A_i*z_i = J_i*Phi_i
F_Klein(A_i*z_i)
  = c_i*(C0 + lambda_i*C1)(Phi_i)
  = 0.
```

This is an exact substitution in the original installed twist equation.
The only denominators are the recorded Hilbert--90 seed denominators and
`det(A_i)`; their common open is nonempty by the authoritative good-reduction
witness.  The proof is compositional: the canonical-model verifier checks
`J_i` and the exact pulled-back Klein cubic, while the degree-11 verifier
checks covariance and the full landing identity.

## 4. Replays and observed outputs

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -B -u \
  source_audit_canonical/verify_reynolds.py
# CANONICAL_A5_PENCIL_REYNOLDS_VERIFY_OK

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -B -u \
  source_audit_canonical/verify_degree33_evaluation.py
# H3_DEGREE33_EXACT_EVALUATION_VERIFY_OK

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -B -u \
  point_attack_degree11_20260801/verify_exact_six_rref.py
# H3_EXACT_DEGREE11_INDEPENDENT_VERIFY_OK
```

`verify_canonical_model.py` was also replayed with writes suppressed and
ended `H3_A5_CANONICAL_MODEL_OK`.

Binding hashes at audit time:

```text
ec06045f082270aa049d7678bf1713e207fd99374db028e582a3b64b2c3487bc  source_audit_canonical/verify_reynolds.py
6191e3beb01dea7ef94d6d3363c628a7a8d9e4b3d6afa7d6afb1b72a4737f5bc  source_audit_canonical/verify_degree33_evaluation.py
b4bac69021d119809c963c3674a69d64d63a078ca4d2913be571ad5aae297812  point_attack_degree11_20260801/exact_six_rref.py
6956aab3c8d916ffec3428800082e4f5abc337f8c3556d6735e40a81d8e8a948  point_attack_degree11_20260801/verify_exact_six_rref.py
cf28d71fb9c1a832d7313e3432d93fb6a78adaa89a973878eee3aea8d2838db9  point_attack_degree11_20260801/class_1_exact_rref_lex.txt
db2b86c23625e4ccb9c38307ffe6ae37143a18875167b1ee5175b55d30dcfd5c  point_attack_degree11_20260801/class_2_exact_rref_lex.txt
71c2ed7149c5f01097067ccb9034fbe2607735539bbc0aba71af3a6f11548f2f  H3_A5_CANONICAL_MODEL_INVARIANT_20260801/verify_canonical_model.py
```

## 5. Retired modular argument

`source_audit_canonical/audit_hensel_p2.py` reconstructs all exact landing
coefficients modulo `89^2`.  There are 577 nonzero equations modulo `89^2`,
although only 468 remain modulo 89.  All four recorded projective
`F_89` points have linearized ranks `rank(A)=4`, `rank([A|b])=5`, so none
lifts even modulo `89^2`.  These points and `class_*_hensel.json` must not be
cited in the positive proof.

Packaging note: the exact proof is currently split between the canonical
model verifier and the degree-11 verifier.  A root verifier should invoke
both (and preferably the independent Reynolds verifier); no mathematical
gap remains in the compositional bridge.
