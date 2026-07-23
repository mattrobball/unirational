# Uniform folds at the saturated multiplier boundary

## Statement and exact scope

Keep the quartic notation of
[`special_seed_stability_frontier.md`](special_seed_stability_frontier.md),
[`special_seed_residual_saturation.md`](special_seed_residual_saturation.md),
and
[`special_seed_ramification_comparison.md`](special_seed_ramification_comparison.md).
Thus

\[
\rho:\mathcal Z_F\longrightarrow\mathcal T_F
\]

is the residual double cover, \(\mathcal M_F\) is its branch surface,
\(h:\mathcal M_F\to Y\) is the restriction of the tangent-flag map, and
\(\mathcal R\subset\mathcal M_F\) is the smooth actual ramification curve.
The projective multiplier on \(\mathcal R\) is unique.  Its boundary is
\(\lambda _2=0\), with middle stratum
\(\lambda=(a,1,0)\) and bottom stratum \(\lambda=(1,0,0)\).

> **Boundary fold theorem.**  For a general equation
> \(F\in H^0(\mathcal O(2,4))\), every point of the middle and bottom
> multiplier boundary is an ordinary fold of
> \(h:\mathcal M_F\to Y\).  Near each such point the ambient
> tangent-flag map is an ordinary nodal family and the residual cover is an
> ordinary double cover.  More precisely, there are analytic coordinates in
> which
>
> \[
> uv=s,\qquad z^2=u+v+\phi(t).
> \tag{0.1}
> \]
>
> The boundary scheme is cut out by \(\phi(t)\).  Since the boundary is
> finite and reduced by the ramification-comparison theorem,
>
> \[
> \boxed{\phi'(0)\ne0.}
> \tag{0.2}
> \]
>
> Thus the mixed coefficient denoted \(\gamma\) in the earlier local model
> is nonzero at every middle and bottom boundary point.

This closes the boundary part of the one-point local-analytic problem.  It
does **not** prove that every point on the open residual stratum is a fold or
an isolated ordinary cusp, exclude every higher Morin point there, or
classify isolated double/triple values and collisions.  Those are separate
open-residual and multipoint questions.

## 1. The intrinsic fold row

Use the flat remainder coordinates

\[
s=(s_0,s_1,s_2),\qquad W=\partial_Ts_2,
\qquad f=(s_0,s_1,s_2,W),
\tag{1.1}
\]

and relative variables \(z=(A,B,L,T)\).  On \(\mathcal M_F\), the
\(T\)-column of \(D_zs\) is zero and
\(U=\partial_TW\) is a unit.  At a ramification point the full relative
Jacobian \(D_zf\) has rank three.  Its left kernel is
\((\lambda_0,\lambda_1,\lambda_2,0)\), and its right kernel is a unique
line \([k]\in\mathbf P^3_z\).

For a corank-one map between smooth surfaces, the fold quadratic is the
second differential in the kernel direction.  In the present complete
intersection coordinates it is

\[
\boxed{
\mathfrak q(\lambda,k)
=\sum_{i=0}^2\lambda_iD_z^2s_i(k,k).}
\tag{1.2}
\]

Indeed, the fourth component of a left-kernel vector is zero, so no second
derivative of \(W\) occurs.  The point is an ordinary fold exactly when
\(\mathfrak q\ne0\).

To test the zero locus of (1.2), impose the saturated boundary equations,
adjoin the four rows \(D_zf(k)=0\), and then adjoin
\(\mathfrak q=0\).  All of these are linear equations in the ninety
coefficients of \(F\) once the flag, \(\lambda\), and \(k\) are fixed.

## 2. Uniform row-space stratification

Write \(k=(k_A,k_B,k_L,k_T)\).  The exact characteristic-zero ranks are

\[
\begin{array}{c|c|c|c}
\text{boundary}&\text{kernel stratum}&
 \operatorname{rank}\mathcal E&
 \operatorname{rank}(\mathcal E,\mathfrak q)\\ \hline
\lambda=(a,1,0)&(k_A,k_B)\ne(0,0)&10&11\\
\lambda=(a,1,0)&k_A=k_B=0,\ k_L\ne0&9&9\\
\lambda=(a,1,0)&[k]=[0:0:0:1]&8&8\\ \hline
\lambda=(1,0,0)&(k_A,k_B)\ne(0,0)&9&10\\
\lambda=(1,0,0)&k_A=k_B=0,\ k_L\ne0&9&9\\
\lambda=(1,0,0)&[k]=[0:0:0:1]&7&7.
\end{array}
\tag{2.1}
\]

Here \(\mathcal E\) consists of \(f=0\), the saturated left-kernel
equations, and \(D_zf(k)=0\).  The table holds both for \(p\ne r\) and for
\(p=r\), and it is independent of \(a\).

The proof is a direct coefficient-block splitting.  At a normalized flag,
the coefficient blocks of \(1,A,B,A^2,AB,B^2\) in the \(x\)-variables are
independent copies of the binary-quartic coefficient space.  In the
constant block the five rows

\[
s_0,s_1,s_2,W,U
\tag{2.2}
\]

are independent.  In the block obtained by one \(L\)-derivative, the three
rows

\[
\eta_1=D_Ls_1,\qquad
\eta_2=D_Ls_2,\qquad
D_LW
\tag{2.3}
\]

are independent.  These assertions are triangular in the coefficients of a
binary quartic and remain true at \(T=0\).

On the middle stratum the saturated rows have rank seven.  If the kernel has
an \(x\)-component, the four right-kernel rows add three: their only
relation modulo the left-kernel rows is the contraction with
\((a,1,0)\).  The same argument starts from rank six on the bottom stratum
and again adds three.  The quadratic row (1.2) then has a nonzero component
in the \((k_AA+k_BB)^2\) coefficient block, which no earlier row meets.
This proves the first and fourth rows of (2.1).

If \(k_A=k_B=0\), the right-kernel equations stay in the constant
binary-quartic block.  For \(k_L\ne0\), the middle equations add
\(\eta_2\) and \(k_LD_LW+k_TU\), while the bottom equations add
\(\eta_1,\eta_2\), and \(k_LD_LW+k_TU\).  For the pure \(T\)-direction
only \(U\) is new.  Finally (1.2) vanishes identically on this no-\(x\)
stratum: \(a s_0+s_1\) is affine-linear in \((L,T)\), while \(s_0\) is
constant in those variables.  This proves the remaining four rows.

The rank defect in the no-\(x\) plane is therefore real, but harmless.  It
is compensated by the codimension of that kernel stratum.  The relevant
parameter dimensions and coefficient ranks for the *degenerate-fold*
incidence are

\[
\begin{array}{c|c|c}
\text{stratum}&\text{parameter dimension}&\text{coefficient rank}\\ \hline
\text{middle, }(k_A,k_B)\ne0&6+1+3=10&11\\
\text{middle, no-\(x\), }k_L\ne0&6+1+1=8&9\\
\text{middle, pure \(T\)}&6+1=7&8\\
\text{bottom, }(k_A,k_B)\ne0&6+3=9&10\\
\text{bottom, no-\(x\), }k_L\ne0&6+1=7&9\\
\text{bottom, pure \(T\)}&6&7.
\end{array}
\tag{2.4}
\]

In every row the parameter dimension is strictly smaller than the number of
independent coefficient conditions.  Each bad incidence therefore has image
of dimension less than \(89\) in \(\mathbf P(V)\).  After taking the
projective closures in the multiplier and kernel spaces, the added limits
are precisely the lower strata already listed in (2.4), and they still have
dimension less than \(89\).  Thus the closure of the full bad coefficient
image is proper.  A general coefficient point avoids it, so every surviving
middle or bottom boundary point has \(\mathfrak q\ne0\), proving the fold
assertion for \(h\).

The calculation in this section uses relative second jets only.  No third
jet is needed at the multiplier boundary.  The intrinsic cubic from the
open residual cusp/Morin problem is not asserted to have uniform rank here.

## 3. The two ambient nodal mechanisms

It remains to distinguish the fold of \(h\) from the ambient fold which
produces the node equation in (0.1).

### 3.1 Middle boundary

Let

\[
\Sigma=\{F_{y_0}=F_{y_1}=F_{y_2}=0\}\subset X.
\tag{3.1}
\]

The tangent-flag threefold \(\mathcal T_F\) is locally the blowup of
\(X\) along \(\Sigma\): it is the closure of the graph of the two
independent components of the \(y\)-gradient.  For general \(F\), the map
\(\Sigma\to Y\) is immersive everywhere.  To see this without a generic-map
shortcut, fix \((x,p)\) and a nonzero vertical direction
\([\kappa]\in\mathbf P(T_x\mathbf P^2_x)\).  The three equations
\(j^1_pF_x=0\) and their three \(\kappa\)-derivatives are six independent
coefficient rows: they are the tensor product of the two independent conic
functionals \(e_x,D_\kappa e_x\) with the three independent first-jet
functionals at \(p\).  Their parameter space has dimension
\(2+2+1=5\), so a general \(F\) has no vertical tangent on \(\Sigma\).

The middle and bottom strata are disjoint for a general equation.  Thus at a
middle point the conic map \(X\to Y\) is smooth.  Since \(\Sigma\to Y\)
is immersive, choose coordinates \((w,s,t)\) on \(X\) with

\[
X\to Y:(w,s,t)\longmapsto(s,t),
\qquad \Sigma=\{w=s=0\}.
\tag{3.2}
\]

On the blowup chart containing its unique relative critical point, put
\(w=u\), \(s=uv\).  The tangent-flag map is therefore exactly

\[
(u,v,t)\longmapsto(uv,t).
\tag{3.3}
\]

This is the ambient node at a middle-boundary point.

### 3.2 Bottom boundary

Away from \(\Sigma\), the tangent graph is locally isomorphic to \(X\).
The bottom stratum is the singular-conic locus of \(X\to Y\).  A general
quadratic family has no rank-one conic fiber: rank-one conics have codimension
three in \(\mathbf P H^0(\mathcal O_{\mathbf P^2_x}(2))=\mathbf P^5\),
whereas \(p\in Y\) contributes only two parameters.  Hence every singular
fiber is a rank-two nodal conic.  Smoothness of \(X\) makes the smoothing
parameter nonzero.  The parametric Morse lemma again gives (3.3).  This is
the ambient node at a bottom-boundary point.

## 4. Simultaneous node and branch normal form

We use the following elementary analytic lemma.

> **Node-with-branch lemma.**  Let
> \(\pi:(T,0)\to(Y,0)\) be a smooth threefold germ over a smooth surface
> germ, with an ordinary nodal critical point.  Let \(M\subset T\) be a
> smooth divisor through that point.  If
> \(\pi|_M\) is an ordinary fold, then there are coordinates
> \((u,v,t)\) on \(T\) and \((s,t)\) on \(Y\) such that
>
> \[
> s=uv,\qquad M=\{u+v+\phi(t)=0\}.
> \tag{4.1}
> \]

Here is a proof.  Choose the second base coordinate \(t\) so that
\(d(t\circ\pi)\) is nonzero on \(M\), take a local equation \(m=0\) for
\(M\), and take a relative coordinate \(x\) on \(M\).  Write the first base
coordinate as \(S(x,m,t)\).  At the ambient nodal point its relative Hessian
in \((x,m)\) is nondegenerate.  The fold hypothesis for \(\pi|_M\) is
exactly \(S_{xx}(0)\ne0\).  The analytic Morse lemma with parameters
\((m,t)\), performed without changing \(m\), first gives

\[
S=-x^2+B(m,t).
\]

Nondegeneracy of the full relative Hessian now gives \(B_{mm}(0)\ne0\).
A second analytic Morse lemma, this time in \(m\) with parameter \(t\),
gives \(B=N^2+D(t)\).  The old divisor \(m=0\) becomes
\(N=\psi(t)\).  After replacing the first base coordinate by \(s=S-D(t)\),
we therefore have analytic coordinates \((x,N,t)\) such that

\[
s=N^2-x^2,\qquad M=\{N=\psi(t)\}.
\tag{4.2}
\]

At the marked point \(N=x=0\), so \(\psi(0)=0\).  Setting
\(u=N+x\), \(v=N-x\), and \(\phi=-2\psi\) proves (4.1).

For a quartic, the residual equation after division by \(2p\) is quadratic
in \(r\).  On \(\mathcal M_F\), its second \(r\)-derivative is the unit
\(U\) of the ramification-comparison theorem.  Completing the square
therefore writes the residual cover as

\[
z^2=g,
\tag{4.3}
\]

where \(M=\{g=0\}\).  Since \(M\) is smooth, (4.1) changes \(g\) by only a
unit; over \(\mathbf C\) that unit has an analytic square root and can be
absorbed into \(z\).  This proves the simultaneous model (0.1).

In (4.2), the ambient critical curve is \(x=N=0\), so its intersection with
\(M\) has local ring

\[
\mathbf C[[t]]/(\psi(t))
=\mathbf C[[t]]/(\phi(t)).
\tag{4.4}
\]

This is also the multiplier-boundary scheme, not only its support.  Indeed,
in the coordinates (4.1), the residual multiplier equations with multiplier
\([a:b]\) are

\[
av-b=au-b=2bz=0.
\tag{4.5}
\]

After saturation by \(b\), they give
\(z=0\), \(u=v=b/a\), and \(2u+\phi(t)=0\).  Pulling back \(b=0\) therefore
gives exactly (4.4).  The finite-boundary theorem says that this scheme is
reduced.  Therefore \(\phi'(0)\ne0\), proving (0.2).

## 5. Mechanical replay

The dependency-free checker
[`special_seed_boundary_fold_checks.py`](special_seed_boundary_fold_checks.py)
reconstructs the ninety coefficient columns and verifies:

1. every rational rank in (2.1), at both \(T=0\) and \(T=1\);
2. the full projective \((a,k)\)-stratification over
   \(\mathbf F_3\) and \(\mathbf F_5\), with exactly the ranks in (2.1);
3. all strict dimension inequalities in (2.4); and
4. the coordinate identities in the node-with-branch lemma.

Its recorded output is
[`special_seed_boundary_fold_checks.log`](special_seed_boundary_fold_checks.log).
