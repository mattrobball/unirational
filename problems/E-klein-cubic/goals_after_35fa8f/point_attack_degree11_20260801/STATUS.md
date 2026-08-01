H-A5-CLASS1-RATIONAL-POINT
H-A5-CLASS2-RATIONAL-POINT

# Exact status

Both separately installed maximal `A5` generic twists have rational points.
The points are induced by homogeneous degree-11 `A5`-equivariant polynomial
maps from the faithful icosahedral source `P2` to the corresponding Klein
cubic.

This is an exact characteristic-zero result.  The independent verifier ends
with

```text
H3_EXACT_BOTH_A5_POINTS_VERIFIED
```

The two embeddings are not identified.  Separate exact intertwiners transport
their ambient Weil actions to the rational five-dimensional augmentation
model.  Their transported cubics have the conjugate parameters

```text
t1=(13-g)/18,  t2=(13+g)/18,  g^2=-11.
```

The class-2 degree-11 point is recorded over `Q(s,g,alpha)`, with `s^2=5`
and `alpha` satisfying the exact cubic in
`degree11_reconstructed_relations.json`.  The class-1 point is its explicitly
verified `g -> -g` conjugate, used with the separately computed class-1
intertwiner.

For each class, if `C0,...,C4` are the raw Reynolds covariants and
`(1,a1,a2,a3,alpha)` is the recorded coefficient vector, put

```text
Phi_i = C0 + a1 C1 + a2 C2 + a3 C3 + alpha C4,
Psi_i = J_i Phi_i,
z_i   = A_i(y)^(-1) Psi_i(y).
```

Here `J_i` is the exact class-specific canonical intertwiner and `A_i` is the
installed Hilbert--90 frame.  Since `A_i` and `Psi_i` have the same covariance,
`z_i` is in `C(P2)^{H_i}`.  Exact substitution gives
`F(A_i z_i)=F(Psi_i)=0`.  The point is nonzero because the five Reynolds
covariants are independent and the `C0` coefficient is one.

This settles Goal H3 positively for both proper subgroups.  It does not
construct a point on the full `PSL_2(F_11)` generic twist.

