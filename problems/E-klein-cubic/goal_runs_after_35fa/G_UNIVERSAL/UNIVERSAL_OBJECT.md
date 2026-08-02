# The corrected universal landing object

## 1. The global coefficient module

Work over a characteristic-zero field `k` containing the character values of
`G=PSL(2,11)`.  Set

\[
S=\operatorname{Sym}(W^*),\qquad R=S^G,
\qquad M=(S\otimes W)^G.
\]

The degree-`d` piece `M_d` is exactly the vector space of homogeneous
`G`-equivariant polynomial maps `W -> W` of degree `d`.  Polarization of the
Klein cubic `F` gives a homogeneous cubic polynomial law

\[
q:M\longrightarrow R,\qquad q(p)=F(p),
\qquad q(M_d)\subset R_{3d}.
\]

The literal degree-`d` landing scheme is therefore

\[
Z_d=V(q_d)\subset \mathbf P(M_d),
\]

where `q_d=0` means that every coefficient of the polynomial `F(p(w))`
vanishes.  A point of `Z_d` is one global coefficient vector, not a collection
of independently chosen fixed-locus restrictions.

## 2. Symbolic plane order is a filtration, not a second source of points

For the 55 involution plus-plane ideals `P_t`, define

\[
A_m=\bigcap_tP_t^m,
\qquad
\mathcal F^mM=(A_m\otimes W)^G.
\]

The intersection is literal and symbolic.  It is not replaced by an ordinary
power of the ideal of the reduced union.  The exact order-`m`, degree-`d`
landing stratum is

\[
\mathcal L_{m,d}=
\{[p]\in Z_d:
 p\in\mathcal F^mM_d,
 p\notin\mathcal F^{m+2}M_d\}.
\]

Every installed local datum is obtained by restricting the same element of
`M_d`:

- the 55 plane-normal jets;
- the three-branch equalizer on each `V4` line;
- residual `D10` and `D12` point kernels;
- source minus-line, exceptional normal-direction line, and target minus-line
  as distinct objects;
- `C3`, `C6`, `A4`, `D10`, and `D12` links;
- type-I and type-II elliptic markings;
- the finite irrelevant-torsion correction between literal graded pieces and
  sheaf sections.

The sheaf architecture remains

```text
plane normalization -> triple-line equalizer -> residual point kernel.
```

It is a restriction presentation of the filtered global module.  Its inverse
limit of independent local states can be strictly larger than the image of
`M`; such extra states are not points of the universal landing object.

## 3. Finite-type coefficient scheme

Let

\[
A=k[f_3,f_5,f_6,f_8,f_{11}].
\]

The certified Hironaka decompositions are

\[
R\simeq\bigoplus_{j=1}^{12}A(-\nu_j),
\qquad
M\simeq\bigoplus_{i=1}^{60}A(-\mu_i).
\]

Choose the certified secondary basis of `R` and a homogeneous `A`-basis of
`M`.  Expanding `q` in these bases gives twelve weighted-homogeneous cubic
polynomials

\[
Q_1(y_1,\ldots,y_{60}),\ldots,Q_{12}(y_1,\ldots,y_{60})
\]

with coefficients in `A`.  Hence

\[
\mathscr Z=
\operatorname{Proj}_{\mathrm{wt}}
A[y_1,\ldots,y_{60}]/(Q_1,\ldots,Q_{12})
\]

is a finite-type noetherian coefficient object.  Its homogeneous polynomial
sections, in every weight, are precisely the global homogeneous landing
covariants.  Local transition conditions require no extra independent
coordinates: they are functorial restrictions of a section of `M`.

This finite presentation must not be misread as a degree bound.  An
`A`-valued point may have coordinates of arbitrarily high weighted degree,
and the zero set of a cubic law is not closed under addition.

## 4. Generic degree-zero fibre

The certified frame

\[
B=(B_0,\ldots,B_4)=(x,C,D,E,K_7),
\qquad e=(1,4,5,6,7),
\]

is a basis of `M tensor_R Frac(R)`.  Put

\[
\tau=f_3^2/f_5,\qquad \deg\tau=1,
\qquad K_{\rm proj}=\operatorname{Frac}(R)_0.
\]

The normalized frame vectors `B_i/tau^{e_i}` have source weight zero.  The
universal generic degree-zero fibre is the cubic hypersurface

\[
X_{\rm gen}=V(\Phi)\subset\mathbf P^4_{K_{\rm proj}},
\qquad
\Phi(a)=q\!\left(\sum_{i=0}^4a_iB_i/\tau^{e_i}\right).
\]

The projective field is a degree-12 extension of
`k(t3,t6,t8,t11)`.  All 35 symmetric cubic coefficients of `Phi` are stored
in

```text
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
```

in the normalized twelve-element secondary basis.  The pre-existing producer
reconstructs these coefficients from the original Klein equation, and the
pre-existing verifier checks all 35 expanded identities.

## 5. Fibre recovery

The all-degree theorem in `ALL_DEGREE_THEOREM.md` proves that the union of all
`Z_d` is nonempty exactly when `X_gen(K_proj)` is nonempty.  The symbolic
filtration then recovers the true exact-order stratum of any cleared global
representative.  Consequently the generic cubic loses no plane, line, point,
elliptic, torsion, or coefficient condition: those conditions were never
separate choices, but consequences of the single global vector recovered by
denominator clearing.
