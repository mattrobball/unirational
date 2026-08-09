# Landing locus versus syzygy modules

## 1. The basic correction

For each degree `d`, put

\[
M_d=(\operatorname{Sym}^d W_5^\vee\otimes W_5)^G.
\]

The ambient landing condition is the cubic equation

\[
\Lambda_d(P):=F(P_0,\ldots,P_4)=0
\]

in the coefficients of `P`. Therefore

\[
L_d=V(\Lambda_d)\subset M_d
\]

is a homogeneous cubic cone. It is not generally a vector subspace and the
direct sum `L = sum_d L_d` is not a module over `C[W]^G` in the additive
sense proposed in the work order.

Scalar multiplication by an invariant is allowed: if `J` is invariant and
`F(P)=0`, then `F(JP)=J^3F(P)=0`. But addition is nonlinear. If `Phi` denotes
the symmetric trilinear polarization of `F`, then

\[
F(P+Q)=F(P)+3\Phi(P,P,Q)+3\Phi(P,Q,Q)+F(Q).
\]

The mixed terms need not vanish.

## 2. What finite generation does give

The full graded covariant module

\[
M=\bigoplus_d M_d
\]

is finitely generated over the invariant ring `C[W]^G` by standard finite
invariant theory for a finite group. Choose homogeneous covariant generators
`C_1,...,C_N`. Any covariant tuple can be written

\[
P=\sum_j A_j C_j,
\qquad A_j\in C[W]^G.
\]

Substitution into `F(P)=0` gives a cubic equation in the invariant coefficient
functions `A_j`, with coefficients obtained from the polarized values
`Phi(C_i,C_j,C_k)`. Thus the all-degree landing problem is a nonlinear
finite-generator problem over the invariant ring, not a module-generation
problem.

This is useful bookkeeping but does not make primitive maps finite: the
invariant coefficients vary in infinite-dimensional graded families and their
linear combinations can have genuinely new base ideals and Rees valuations.

## 3. Relation to derivations and matrix factorizations

The differential sequence

\[
T_{\mathbf A^5}\xrightarrow{dF}O
\]

controls infinitesimal vector fields tangent to the cubic cone. It does not
classify polynomial maps `P:A^5 --> A^5` satisfying the nonlinear equation
`F(P)=0`. Likewise matrix factorizations classify MCM data over the
hypersurface ring `C[W]/(F)`; they naturally see equations modulo `F`, whereas
ambient landing requires an exact polynomial identity before quotienting.

No linearization from these theories is presently known that converts all
landing tuples into a finitely generated additive syzygy module.

## 4. Composition is the structurally correct operation

Although landing tuples are not additively closed, they are closed under
substitution by lifted selfmaps. If `F(S)=FB` and `F(P)=0`, then

\[
F(S(P))=F(P)B(P)=0.
\]

Thus substitution, not addition, is the natural algebraic structure relevant
to the ambient problem.
