# Finite generation: proved scope and invalid inference

## Proved finite data

The global invariant and covariant modules have finite Hironaka data over

\[
A=k[f_3,f_5,f_6,f_8,f_{11}].
\]

The invariant module has rank 12 over (A), and the self-covariant module
has rank 60.  Therefore the global landing law is a finite system of twelve
cubic laws in sixty coefficient slots over (A).  Localizing at the
five-vector frame reduces the same problem to the single cubic
(\Phi=0) over (K_{\rm aff}=\operatorname{Frac}(R)).

For each fixed symbolic order (m), the installed plane-normalization,
triple-line, point-link, minus-line, (C_3/A_4), and marked modules are
coherent.  The exact sheaf-level architecture is

```text
plane normalization -> triple-line equalizer -> residual point kernel
```

and the literal graded discrepancy is the finite irrelevant module (T_m).

## What is not proved

No finite generation theorem is currently installed for the complete
symbolic intersection algebra

\[
\bigoplus_{m\ge0}\left(\bigcap_t I(Z_t)^m\right)u^m
\]

together with every global transition layer.  Finite generation of fixed-
(m) modules does not prove this statement.  The false short Cech complex
cannot be used to manufacture such a presentation.

More importantly, even a finite presentation of that algebra would not make
the nonlinear zero set decidable by checking module generators.  The cubic
landing set is not a submodule: sums introduce cross terms.  Primitive
solutions can first occur above every module-generator degree.

An exact model counterexample is

\[
R=k[u,v],\quad M_N=R(-N)e_1\oplus R(-N)e_2,
\quad q_N(ae_1+be_2)=(u^Nb-v^Na)^3.
\]

The first nonzero isotropic vector is
(u^Ne_1+v^Ne_2), of degree (2N), although (M_N) is generated in
degree (N); its two coefficients are coprime.  Hence generator degree,
primitivity, and Noetherianity alone give no landing cutoff.

## Correct conclusion

The finite global presentation is useful because it identifies the exact
finite arithmetic object.  It does not produce the G2 exceptional bound
requested by the negative branch.  A valid G2 exit must instead provide one
of:

1. an exact pointlessness theorem for (V(\Phi)/K_{\rm aff});
2. an effective representation-specific height bound for a first rational
   point, with proof;
3. a structural landing identity forcing symbolic infinite descent; or
4. a positive (K_{\rm aff})-point and its cleared global coefficient
   vector.

None follows from the finite Hironaka presentation alone.

