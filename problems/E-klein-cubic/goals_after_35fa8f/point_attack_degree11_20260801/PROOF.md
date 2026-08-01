# Exact degree-11 point certificate

## 1. Canonical five-space and the two classes

Let `U` be the augmentation module for the action of `A5` on its six
Sylow-5 subgroups, with coordinates `x0,...,x4` and
`x5=-(x0+...+x4)`.  The two invariant cubics `O0,O1` are the two ten-term
orbits of square-free triples listed in `exact_reynolds.py`.

`canonical_a5_pencil.py` independently constructs an exact intertwiner
`J_i : U -> W|H_i` for each installed maximal `A5` class and pulls the
ambient Klein cubic back to `U`.  The two ratios are distinct and satisfy

```text
9 t^2 - 13 t + 5 = 0.
```

Writing `g^2=-11`, class 1 has `t=(13-g)/18` and class 2 has
`t=(13+g)/18`.  The verifier recomputes both intertwiners and this comparison;
it does not use a symmetry shortcut to identify the subgroups.

## 2. Full degree-11 covariant space

Over `Q(s)`, `s^2=5`, Reynolds averaging of the five seeds

```text
(1,(0,0,11)), (0,(0,1,10)), (1,(0,1,10)),
(0,(0,2,9)), (1,(1,1,9))
```

gives five exact covariants `C0,...,C4`.  Exact generator substitution checks

```text
Cj(sigma(h)y) = U(h) Cj(y).
```

Their reductions are linearly independent modulo 89, hence they are
independent in characteristic zero.  Molien's formula gives the full
degree-11 covariant dimension as five, so this is the complete space.

## 3. Exact closed point of the landing scheme

Set

```text
Phi = C0 + a1 C1 + a2 C2 + a3 C3 + alpha C4.
```

The coefficient of every source monomial in `(O0+t O1)(Phi)` is an invariant
of degree 33.  The invariant-ring Hilbert series

```text
(1+q^15)/((1-q^2)(1-q^6)(1-q^10))
```

has degree-33 coefficient six.  Evaluation at

```text
(1,2,3), (1,2,4), (1,2,5),
(1,2,6), (1,2,7), (1,3,2)
```

is injective on this six-space: a Reynolds-basis evaluation minor has
determinant `24 mod 89`.  Therefore vanishing at those six points is
equivalent to the full polynomial identity.

The exact class-2 solution is defined by

```text
alpha^3 + p2 alpha^2 + p1 alpha + p0 = 0,
ai = ai_0 + ai_1 alpha + ai_2 alpha^2.
```

Every coefficient is given in the basis `1,s,g,s*g` in
`degree11_reconstructed_relations.json`.  These candidates were discovered
by CRT reconstruction from four embeddings at 96 split primes, but the
theorem does not rely on modular lifting: `verify_exact_point.py` substitutes
them with rational arithmetic into all six characteristic-zero equations and
gets zero in the cubic quotient field.

Applying `g -> -g` to the coefficients and to `t` gives the class-1
candidate.  The verifier performs a second exact six-equation substitution
for this conjugate candidate.

All constants lie in the algebraically closed constant field `C`, so the
closed algebraic coefficient vector gives an ordinary point over each
invariant function field, not merely a point after extending that field.

## 4. Return to the installed twists

For class `i`, `Psi_i=J_i Phi_i` lands on the original Klein cubic and obeys
the ambient `H_i` covariance.  With the separately installed Hilbert--90
frame `A_i`, define

```text
z_i=A_i(y)^(-1) Psi_i(y).
```

Then `z_i` is `H_i`-invariant, hence has coordinates in
`C(P2)^{H_i}`, and the original frame-substituted equation vanishes exactly.

