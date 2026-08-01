# Correct all-degree coefficient object

The expanded statement and exact fibre boundary are in
`UNIVERSAL_OBJECT.md`; the finite-generation limitations and corrected
line-to-point recurrence are in `FINITE_GENERATION.md`.

Let `S=Sym(W*)`, `R=S^G`, and `M=(S tensor W)^G`.  The complete degree-`d`
landing scheme is

\[
Z_d=\{[p]\in\mathbf P(M_d):F(p)=0\text{ coefficientwise}\}.
\]

For the 55 plus-plane ideals `P_t`, the symbolic filtration is

\[
A_m=\bigcap_tP_t^m,\qquad \mathcal F^mM=(A_m\otimes W)^G.
\]

The genuine Goal G support is the exact-order stratum of `Z_d` in
`F^mM_d/F^(m+2)M_d`.  Its plane jets, triple-line equalizers, point kernels,
marked elliptic data, and irrelevant torsion are simultaneous restrictions
of one global coefficient vector.  Independent local inverse-limit choices
are not points of this scheme.

With `A=k[f3,f5,f6,f8,f11]`, the certified ranks are
`rank_A(R)=12` and `rank_A(M)=60`, both graded free.  Expanding the cubic law
in these bases gives twelve cubic equations in sixty coordinates over `A`.
This is a noetherian finite-type coefficient scheme, but its `A`-sections
have polynomial coordinates of unbounded degree; finite type therefore does
not bound the first primitive landing section.

After localizing at the nonzero determinant of the frame `B=[x C D E K]`,

\[
M\otimes_R\operatorname{Frac}(R)=
\operatorname{Frac}(R)^5
\]

and every-degree landing is equivalent, after clearing invariant
denominators and equalizing weights, to a rational point on

\[
\Phi(a)=F(Ba)=0
\]

over the projective invariant field.  Conversely such a point clears to a
nonzero homogeneous landing covariant.  This is an exact finite arithmetic
reduction of the degree ladder, but rational-point existence remains
undecided.
