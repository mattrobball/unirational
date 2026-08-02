# The universal object for all homogeneous landing covariants

## 1. Global coefficient lattice

Work over a characteristic-zero field `k` containing the character values of

\[
G=\operatorname{PSL}_2(\mathbf F_{11}).
\]

Let `W` be the five-dimensional Klein representation, let

\[
F(x_0,\ldots,x_4)=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1},
\qquad X=V(F)\subset\mathbf P(W),
\]

and put

\[
S=\operatorname{Sym}(W^*),\qquad R=S^G,\qquad
M=(S\otimes W)^G.
\]

The graded piece `M_d` is exactly the space of degree-`d` polynomial
`G`-equivariant maps `W -> W`.  Polarization of `F` gives a cubic polynomial
law

\[
q:M\longrightarrow R,\qquad q(p)=F(p),\qquad q(M_d)\subset R_{3d}.
\]

Thus the literal degree-`d` landing scheme is

\[
Z_d=V(q_d)\subset\mathbf P(M_d).
\]

This is the primary object.  Every local plane, line, point, or marked datum
is obtained by restricting one element of `M_d`; independent local choices
are never substituted for a global coefficient vector.

## 2. Intrinsic generic twist

The action of the finite faithful group `G` on `P(W)` is generically free:
for every `1 != g in G`, the fixed locus of `g` is a proper closed subset,
and their finite union is proper.  Choose a `G`-stable free open
`U subset P(W)` and let

\[
B=U/G,\qquad K_{\rm proj}=k(B)=k(\mathbf P(W))^G.
\]

The generic fibre

\[
T=U\times_B\operatorname{Spec}K_{\rm proj}
\]

is a `G`-torsor.  Define the twist

\[
X_T=T\times^G X.
\]

This projective threefold over `K_proj` is the universal all-degree landing
object.

### Proposition 2.1 — rational sections

There is a canonical bijection

\[
X_T(K_{\rm proj})
\simeq
\{G\text{-equivariant rational maps }\mathbf P(W)\dashrightarrow X\}.
\]

Indeed, the associated bundle

\[
U\times^G X\longrightarrow B
\]

has generic fibre `X_T`.  A `K_proj`-point of the generic fibre is a rational
section over `B`; pulling it back to `U` gives a `G`-equivariant rational map
to `X`.  Conversely, descent of such a map gives the rational section.  The
two constructions are inverse on generic points.

## 3. Polynomialization and the character issue

A rational map `P(W) --> P(W)` can be represented by a primitive tuple

\[
p=(p_0,\ldots,p_4)
\]

of homogeneous polynomials of one degree.  Here primitive means
`gcd(p_0,...,p_4)=1` in the UFD `S`.

If the projective map is `G`-equivariant, then for every `g in G` the two
primitive tuples `p(gx)` and `g p(x)` represent the same projective map.
Two primitive polynomial tuples representing the same rational projective
map differ by a scalar in `k^*`: writing the ratio as coprime `a/b` forces
`b` to divide every coordinate of the first tuple and `a` to divide every
coordinate of the second.  Consequently

\[
p(gx)=\chi(g)g p(x)
\]

for a character `chi:G -> k^*`.

The verifier constructs the action of the standard matrices

\[
S:z\mapsto-1/z,\qquad T:z\mapsto z+1
\]

on `P^1(F_11)`, enumerates the generated permutation group, and obtains order
660.  It then enumerates the normal closure of `[S,T]` and again obtains 660.
Thus `G=[G,G]`, so `chi=1`.  Every `G`-equivariant rational projective map
therefore has a genuine homogeneous polynomial covariant representative.
If its image lies in `X`, then `F(p)=0` as a polynomial identity.

This proves the intrinsic bijection

\[
X_T(K_{\rm proj})
\simeq
\frac{\{0\ne p\in M_d\text{ for some }d:F(p)=0\}}
     {\text{projective scalar equivalence}}.
\]

## 4. Primitive and scalar-multiple covariants

Let `p in M_d` be nonzero and let `delta` be the gcd of its five coordinates.
For `g in G`, equivariance and invertibility of the target matrix imply that
`g(delta)` and `delta` are associates.  Hence

\[
g(\delta)=\chi_\delta(g)\delta
\]

for a character `chi_delta`.  Perfectness of `G` gives `chi_delta=1`, so
`delta in R`.  Therefore

\[
p_{\rm prim}=p/\delta
\]

is again a homogeneous `G`-covariant, and

\[
F(p)=\delta^3F(p_{\rm prim}).
\]

Thus landing is preserved by primitive reduction.  Conversely, for every
nonzero homogeneous `h in R`,

\[
F(hp)=h^3F(p),
\]

so invariant scalar multiplication preserves landing and the induced
projective map.  Two primitive representatives of the same map differ by a
constant in `k^*`.  This is the exact treatment of primitive versus
scalar-multiple covariants requested in G2.

## 5. Explicit Klein trivialization

The certified homogeneous frame is

\[
B=(x,C,D,E,K_7),\qquad e=(1,4,5,6,7).
\]

Let

\[
\tau=f_3^2/f_5,
\]

which has source degree one.  Over the projective invariant field the five
vectors

\[
\bar B_j=B_j/\tau^{e_j}
\]

form a basis of the twisted rank-five vector space.  Hence `X_T` is the cubic

\[
\Phi(a_0,\ldots,a_4)
=F\!\left(\sum_{j=0}^4a_j\bar B_j\right)=0
\]

in `P^4_{K_proj}`.  Its 35 symmetric coefficients are stored exactly in

```text
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
```

in the normalized twelve-element secondary basis over
`k(t3,t6,t8,t11)`.

## 6. Denominator clearing is the all-degree theorem

Let `[a_0:...:a_4]` be a `K_proj`-point of `V(Phi)`.  The element
`a_j tau^{-e_j}` has degree `-e_j` in the graded fraction field of `R`, so
choose homogeneous `n_j,d_j in R` with

\[
a_j\tau^{-e_j}=n_j/d_j,
\qquad \deg n_j=\deg d_j-e_j.
\]

Put `h=product_j d_j`, `H=deg h`, and

\[
p=h\sum_j a_jB_j/\tau^{e_j}
 =\sum_j\left(n_j\prod_{k\ne j}d_k\right)B_j.
\]

The coefficient of `B_j` has degree `H-e_j`; every summand has degree `H`.
Moreover

\[
F(p)=h^3\Phi(a)=0.
\]

The normalized frame is independent and `a` is nonzero, so `p` is nonzero.
This produces a literal polynomial element of `M_H`, not only a sheaf
section or formal state.

Conversely, if `0 != p in M_d` and `F(p)=0`, expand uniquely

\[
p=\sum_j c_jB_j,
\qquad \deg c_j=d-e_j.
\]

Then

\[
a_j=c_j\tau^{e_j-d}\in K_{\rm proj},
\qquad
p/\tau^d=\sum_ja_jB_j/\tau^{e_j},
\]

and

\[
\Phi(a)=F(p)/\tau^{3d}=0.
\]

The two constructions are inverse after projective scalar equivalence.
Therefore

\[
V(\Phi)(K_{\rm proj})\ne\varnothing
\Longleftrightarrow
\exists d\; Z_d\ne\varnothing.
\]

This equivalence has no hidden bounded-degree hypothesis.

## 7. Exact symbolic-order fibres and transition data

For the 55 involution plus-plane ideals `P_t`, put

\[
A_m=\bigcap_tP_t^m,
\qquad \mathcal F^mM=(A_m\otimes W)^G.
\]

For an actual polynomial covariant `p`, its true order is the maximal odd `m`
with `p in F^mM`.  The exact support is

\[
\mathcal L_{m,d}
=\{[p]\in Z_d:p\in\mathcal F^mM_d,
                  p\notin\mathcal F^{m+2}M_d\}.
\]

Restriction of the one global class of `p` gives, simultaneously,

- all 55 plane-normal jets;
- every `V4` triple-line equalizer;
- residual multiple-point kernels;
- source fixed lines, exceptional normal-direction lines, and target fixed
  lines as distinct objects;
- `C3`, `C6`, `A4`, `D10`, and `D12` links;
- type-I/type-II marked elliptic data;
- the finite irrelevant-torsion correction between literal graded pieces and
  sheaf sections.

The authoritative necessity theorem is

```text
certificates/global_transition/necessity_theorem.json
```

and its direction remains forward only.  The generic-twist point clears to a
literal global polynomial before these restrictions are taken, so no local
compatibility or low-degree torsion term is lost.  Conversely, this theorem
does not turn an independently chosen local inverse-limit state into a global
covariant.

## 8. Finite type and scope

With

\[
A=k[f_3,f_5,f_6,f_8,f_{11}],
\]

`R` and `M` are graded free `A`-modules of ranks 12 and 60.  Expansion of the
cubic law gives twelve cubic equations in sixty coefficient slots over `A`.
This is a noetherian finite-type coefficient scheme.

Its graded polynomial sections have unbounded degree, so finite type does not
imply a finite first-landing-degree bound.  The generic twist is the correct
finite object because it quotients exactly by invariant denominators and
projective scalar multiplication.  It reduces the union of all bidegree
supports to one explicit rational-point problem without claiming a false
finite degree ladder.
