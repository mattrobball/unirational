# Noetherianity: exact scope and corrected conclusion

## 1. What is finitely generated

Let

\[
A=k[f_3,f_5,f_6,f_8,f_{11}].
\]

The repository certificates prove that

\[
R=S^G\text{ is graded free of rank }12\text{ over }A,
\qquad
M=(S\otimes W)^G\text{ is graded free of rank }60\text{ over }A.
\]

After choosing homogeneous bases, the cubic law `q(p)=F(p)` is represented by
twelve weighted cubic polynomials in sixty coordinates over `A`.  The
coordinate ring

\[
A[y_1,\ldots,y_{60}]/(Q_1,\ldots,Q_{12})
\]

is therefore finitely generated and noetherian.  This is the complete global
landing object: its points are global coefficient vectors, so every local
transition equation is automatically imposed after restriction.

Localizing the generic frame and passing to degree zero yields a still smaller
finite object: one cubic in five variables over `K_proj`, with exactly 35
stored coefficients.  The all-degree theorem proves that this generic fibre
is existence-equivalent to the union over every homogeneous degree.

## 2. What is not claimed

No finite-generation theorem is asserted here for

\[
\bigoplus_{m\ge0}
\left(\bigcap_tP_t^m\right)u^m
\]

or for a separately assembled multi-Rees equalizer/Fitting system containing
all line and point layers.  Such a theorem may be true or false; it is not
needed once the global covariant module is used as the source of every
restriction.

Nor does finite generation of the global coefficient ring give an upper
bound for the first degree containing a nonzero cubic zero.  The nonlinear
landing locus is not an `A`-submodule.  Cross terms allow cancellations whose
first polynomial representative can have arbitrarily large height.

## 3. Exact counterexample to the degree-cutoff inference

For any `N>0`, let

\[
R_0=k[u,v],
\qquad
M_N=R_0(-N)e_1\oplus R_0(-N)e_2,
\]

and define the cubic law

\[
q_N(ae_1+be_2)=(u^Nb-v^Na)^3.
\]

The module is generated in degree `N`, but its first nonzero primitive
isotropic vector is

\[
u^Ne_1+v^Ne_2,
\]

of degree `2N`.  As `N` varies, no bound follows from the number or degree of
module generators.  The same example shows why checking the cubic on module
generators is invalid: the zero arises from cancellation between their
polynomial coefficients.

## 4. Correct G2 conclusion

The requested all-degree reduction is finite, but it is not a finite degree
ladder.  The exact finite decision object is

\[
V(\Phi)\subset\mathbf P^4_{K_{\rm proj}}.
\]

Consequently:

- finite global presentation is **proved**;
- exact recovery of all polynomial degrees is **proved**;
- scalar saturation and homogeneous precomposition are **proved** compatible;
- a bounded exceptional list of degrees is neither needed nor claimed;
- rational-point existence or pointlessness on `V(Phi)` remains the sole
  arithmetic decision.

The exit `G2-FINITE-GENERATION-PASS` refers to this finite global coefficient
presentation and exact generic-fibre reduction.  It does not assert the
stronger, unused symbolic multi-Rees finite-generation statement.
