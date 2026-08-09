# Fixed involution planes under a hypothetical rational retraction

This note records the extra all-degree condition supplied by
\(f|_X=\operatorname{id}_X\). It is a genuine strengthening of the general
plus-plane parity theorem, but it is not a contradiction.

Let \(T=(T_0,\ldots,T_4)\) be a primitive homogeneous landing tuple of
degree \(d\), and suppose its restriction to the Klein cubic is the identity.
The five restricted sections represent the same projective morphism as the
coordinate sections, so there is a global section

\[
 h\in H^0(X,\mathcal O_X(d-1)),\qquad T_i|_X=h x_i.
 \tag{1}
\]

After lifting \(h\) to a homogeneous polynomial \(H\), there is a polynomial
covariant \(Q\) with

\[
 T(v)=H(v)v+F(v)Q(v).
 \tag{2}
\]

Fix an involution \(\sigma\), write \(v=w+y\) according to
\(W=W^+_\sigma\oplus W^-_\sigma\), and put

\[
 F_\sigma(w)=F(w,0),\qquad
 E_\sigma=V(F_\sigma)\subset\mathbf P(W^+_\sigma).
\]

By Theorem H0-1, the common order \(m=\operatorname{ord}_{P_\sigma}T\)
is odd and the leading piece is minus-valued:

\[
 T_m=T_m^-\in
 \operatorname{Sym}^{d-m}(W^{+\,*}_\sigma)
 \otimes\operatorname{Sym}^{m}(W^{-*}_\sigma)\otimes W^-_\sigma.
\]

**Proposition.** Coefficientwise in the \(y\)-variables and in
\(W^-_\sigma\),

\[
 \boxed{\quad F_\sigma(w)\mid T_m^-(w;y).\quad}
 \tag{3}
\]

In particular \(d-m\geq3\).

**Proof.** Choose a smooth affine-cone point \(w\) of \(E_\sigma\) and an
arbitrary \(y\in W^-_\sigma\). Invariance gives
\(dF_w(y)=0\). Since the plane cubic is smooth, some plus-direction has
nonzero \(dF_w\), so one can solve recursively for a formal arc

\[
 v(s)=w+s y+s^2w_2+s^3w_3+\cdots\in X.
\]

All transverse pieces of \(T\) below order \(m\) vanish identically. Hence
the coefficient of \(s^m\) in \(T(v(s))\) is
\(T_m^-(w;y)\in W^-_\sigma\). Equation (1) says on the same arc

\[
 T(v(s))=h(v(s))v(s).
\]

Its order-\(m\) coefficient, if nonzero, is a scalar multiple of
\(w\in W^+_\sigma\). The eigenspaces are disjoint, so both coefficients
must be zero. This holds for every \(y\) and a dense set of \(w\in E_\sigma\).
The smooth plane cubic is irreducible, and (3) follows. \(\square\)

Geometrically, the exceptional map over the based plane still has generic
image \(L_\sigma\), as in H0-2, but its leading tuple has the divisor
\(E_\sigma\) as a common base divisor. Resolving that divisor can introduce
an elliptic exceptional stratum carrying the identity boundary data, while
the generic plane exceptional stratum continues to map to the rational line.
The two projective eigenspace pieces in the blowup are disjoint. Therefore
the rational-connectedness argument for the plane does not propagate across
this center, and (3) supplies no all-degree contradiction.

The exact remaining fixed-plane target in the degree-one branch is thus the
landing-ideal problem with the additional divisibility (3), simultaneously
for all 55 conjugate planes. There is no theorem-forced bound on \(d\), so a
bounded covariant sweep would still be nonterminal.

```text
DELTA1-FIXED-PLANE-LEADING-MINUS-DIVISIBLE-BY-ELLIPTIC-CUBIC
DELTA1-FIXED-PLANE-EXCEPTIONAL-SEPARATION-COMPATIBLE
DELTA1-FIXED-PLANE-ALL-DEGREE-CONTRADICTION-NOT-OBTAINED
```

