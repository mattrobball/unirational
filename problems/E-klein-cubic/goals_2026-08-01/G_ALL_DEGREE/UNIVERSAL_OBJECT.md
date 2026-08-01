# Correct universal object for all homogeneous landing covariants

## 1. Global coefficient object

Work over a characteristic-zero field `k` containing the character values.
Let

\[
S=\operatorname{Sym}(W^*),\qquad
R=S^G,\qquad
M=(S\otimes W)^G.
\]

The degree-`d` component `M_d` is the complete space of homogeneous
`G`-equivariant polynomial maps `W -> W` of degree `d`.  Polarization of the
Klein cubic defines a homogeneous cubic polynomial law

\[
q:M\longrightarrow R,\qquad q(p)=F(p),\qquad q(M_d)\subset R_{3d}.
\]

Thus the literal degree-`d` landing scheme is

\[
Z_d=V(q_d)\subset \mathbf P(M_d),
\]

where `q_d` means every coefficient of the invariant polynomial `F(p)`.
There is no sampling or local-choice ambiguity in this definition: a point
of `Z_d` is one global coefficient vector.

## 2. The symbolic filtration and exact local restrictions

For the 55 involution plus-plane ideals `P_t`, put

\[
A_m=\bigcap_t P_t^m,\qquad
\mathcal F^mM=(A_m\otimes W)^G.
\]

The filtration is symbolic; it is not replaced by a power of the ideal of
the reduced union.  For odd `m`, the associated layer is

\[
\operatorname{gr}^{m,m+2}M
=\left[(A_m/A_{m+2})\otimes W\right]^G.
\]

Restriction of one global vector in this layer gives, functorially and
simultaneously,

- its 55 plane-normal jets;
- the three-branch equalizers on every `V4` line;
- the residual `D10` and `D12` point kernels;
- the minus-line, `C3`, `C6`, `A4`, and marked-elliptic restrictions;
- the finite irrelevant-torsion correction when literal graded pieces are
  compared with sheaf sections.

The exact sheaf architecture is

```text
plane normalization -> triple-line equalizer -> residual point kernel.
```

It is a restriction presentation of the filtered global object, not a
replacement for it.  Independent local choices define at most a point of a
necessary inverse limit; they are not a point of `Z_d` until they lift to one
element of `M_d`.

The order-`m`, degree-`d` landing support is consequently the locally closed
stratum

\[
\mathcal L_{m,d}
=\{[p]\in Z_d:p\in\mathcal F^mM_d,
                 \ p\notin\mathcal F^{m+2}M_d\},
\]

equipped with the complete restriction diagram above.  This definition
automatically retains every equalizer and every coefficient of `F(p)=0`.

## 3. A finite-type coefficient model

Adler's five primaries give the polynomial ring

\[
A=k[f_3,f_5,f_6,f_8,f_{11}].
\]

The verified Hironaka data are

\[
\operatorname{rank}_A R=12,\qquad
\operatorname{rank}_A M=60,
\]

and both modules are graded free over `A`.  Choose the certified twelve
secondaries of `R` and any homogeneous rank-60 `A`-basis of `M`.  Expanding
`F(p)` in the secondary basis gives twelve homogeneous cubic equations

\[
Q_1(y_1,\ldots,y_{60})=\cdots=Q_{12}(y_1,\ldots,y_{60})=0
\]

over `A`.  Their common zero scheme is a noetherian finite-type coefficient
object.  It is exact, but its `A`-points have polynomial coordinates of
unbounded degree.  Noetherianity of this scheme therefore does not bound the
first homogeneous landing degree.

Passing to `P=Frac(A)` gives one finite projective rational-point problem.
Equivalently, after passing to `K=Frac(R)` and localizing at the nonzero frame
determinant,

\[
M\otimes_RK=Kx\oplus KC\oplus KD\oplus KE\oplus KK_7,
\]

and the affine invariant-field equation is the single cubic

\[
\Phi_{\rm aff}(u_0,\ldots,u_4)
=F(u_0x+u_1C+u_2D+u_3E+u_4K_7)=0.
\]

The exact 35 polar coefficients are reconstructed from the original Klein
equation.  Normalization by `tau=f_3^2/f_5` descends this to the projective
invariant field

\[
K_{\rm proj}/k(t_3,t_6,t_8,t_{11}),\qquad [K_{\rm proj}:k(t_3,t_6,t_8,t_{11})]=12.
\]

Precisely, for `B=(x,C,D,E,K_7)` and `e=(1,4,5,6,7)`, the descended cubic is

\[
\Phi(a_0,\ldots,a_4)
=F\!\left(\sum_{j=0}^4 a_jB_j/\tau^{e_j}\right)=0
\quad\text{over }K_{\rm proj}.
\]

Concretely, if `beta_0,...,beta_11` are the normalized secondary basis
elements and `c_ijk` is the coefficient of `a_i a_j a_k` in this normalized
cubic (the corresponding affine polar coefficient divided by
`tau^(e_i+e_j+e_k)`), then

\[
\Phi(a)=\sum_{0\le i\le j\le k\le4}c_{ijk}a_i a_j a_k,
\qquad
c_{ijk}=\sum_{s=0}^{11}r_{ijk,s}(t_3,t_6,t_8,t_{11})\beta_s.
\]

`generic_cubic.json` contains all 35 sparse vectors `r_ijk`.  They already
include the repeated-index multinomial factors, so the displayed sum is
literal.  `produce_generic_cubic.py` obtains them by expanded coefficient
division over `QQ`, and `verify_generic_cubic.py` independently rebuilds each
right-hand side from the primary and secondary polynomials and compares it
with the original coefficient of `F([x C D E K]a)`.

## 4. All-degree equivalence

The following three statements are equivalent.

1. Some `Z_d` has a nonzero point.
2. Some `\mathcal L_{m,d}` has a point for its true odd plane order `m`.
3. The generic projective twist `V(\Phi)` has a
   `K_proj`-rational point.

Put `B=(x,C,D,E,K_7)` and `e=(1,4,5,6,7)`.  Since `deg(tau)=1`, the normalized
frame `B_j/tau^e_j`, every `t_d=f_d/tau^d`, and every normalized secondary
`beta_s=b_s/tau^deg(b_s)` have source weight zero.  Thus a `K_proj`-point
`[a_0:...:a_4]` gives homogeneous invariant rational coefficients

\[
b_j=a_j\tau^{-e_j}=n_j/d_j,
\qquad \deg n_j=\deg d_j-e_j.
\]

Choose homogeneous numerators and denominators in `R`, put
`h=\prod_j d_j` and `H=deg h`, and set

\[
p=h\sum_j b_jB_j
 =\sum_j\left(n_j\prod_{k\ne j}d_k\right)B_j.
\]

The coefficient of `B_j` has degree `H-e_j`, so every displayed summand and
therefore `p` has the single degree `H`; no highest-component argument is
needed.  Moreover

\[
F(p)=h^3F\!\left(\sum_j a_jB_j/\tau^{e_j}\right)=h^3\Phi(a)=0.
\]

At least one `a_j` is nonzero, `h` and `tau` are nonzero in the invariant
fraction field, and the five frame vectors are independent there, so `p` is
nonzero.  This proves `3 => 1`.

Conversely, expand a nonzero homogeneous `p\in M_d` uniquely over the frame
as `p=\sum_j c_jB_j`.  Graded independence gives `deg(c_j)=d-e_j`.  Hence

\[
a_j=c_j\tau^{e_j-d}\in K_{\rm proj},\qquad
\frac p{\tau^d}=\sum_j a_j\frac{B_j}{\tau^{e_j}}.
\]

The `a_j` have weight zero and are not all zero, while cubic homogeneity gives
`Phi(a)=F(p)/tau^{3d}=0`.  This proves `1 => 3`.  The verifier checks these
degree identities for all five frame entries and all 35 polar coefficients,
including the literal projective-basis normalization in `generic_cubic.json`.
Statement 2 is the exact symbolic-order stratification of 1.

This equivalence is the valid all-degree replacement for a degree ladder.
It does not decide whether the rational point exists.

## 5. What finite generation does and does not prove

The finite-type model proves that the all-degree question is one exact
arithmetic support problem, not infinitely many unrelated experiments.  It
does **not** turn rational-point existence over `K_proj` into checking the 60
module basis vectors, finitely many bidegrees, or finitely many local states.
The cubic zero set is not a module and cancellations among high-degree
invariant coefficients are essential.

Accordingly, a headline-negative exit still requires a rational-point
obstruction for `V(Phi)` (or an equivalent all-order identity such as
`(ID_m)`), and a headline-positive exit still requires one exact point.

## 6. Exact scope of the local transition system

The local modules occur here as targets of restriction maps from one global
filtered vector.  Their plane, line, point, elliptic, and torsion equations
are therefore retained simultaneously.  The larger inverse limit of
independently chosen local vectors can strictly exceed the image of this
restriction map; its nonzero elements are not additional points of the
universal landing scheme.

The all-order first-plane theorem in `FIRST_GATE.md` supplies a new
structural equation on every actual global point.  It reduces the first even
successor to the two Hilbert--Burch syzygies of `(a^2,ab,b^2)`, forces an
elliptic map on every mapped gcd component, and makes the mapped vertical
degree divisible by three.  Its triple-line identity identifies the first
post-minimum layer for every odd `m` with the order-three layer up to the
forced factor `(xyz)^((m-3)/2)`.  Neither statement kills the primitive
locus or later line layers, so neither is promoted to pointlessness of
`V(Phi)`.

## 7. Smallest remaining support problem

There is no remaining infinite degree list in the formulation.  The exact
unresolved object is the single cubic hypersurface

\[
V(\Phi)\subset\mathbf P^4_{K_{\rm proj}}
\]

whose 35 coefficients and degree-12 field arithmetic are finite and
executable.  The missing theorem is precisely one of

\[
V(\Phi)(K_{\rm proj})=\varnothing
\quad\text{or}\quad
V(\Phi)(K_{\rm proj})\ne\varnothing.
\]

No finite collection of homogeneous degrees, formal jets, or specialized
fibres decides this displayed alternative without an additional transfer or
height theorem.
