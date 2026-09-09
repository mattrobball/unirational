# Problem E — PSL(2,11)-unirationality of the Klein cubic

**Status: RESOLVED AFFIRMATIVELY (2026-09-09).**

Let \(G=\operatorname{PSL}_2(\mathbf F_{11})\) act through its faithful
five-dimensional Klein representation \(A\) on

\[
X=\{x_0^2x_1+x_1^2x_2+x_2^2x_3+x_3^2x_4+x_4^2x_0=0\}\subset\mathbf P(A).
\]

There is an explicit dominant \(G\)-equivariant rational map

\[
\boxed{\Phi:\mathbf P(A^{\oplus4})=\mathbf P^{19}\dashrightarrow X.}
\]

The construction uses the equivariant six-dimensional Pfaffian model of the
Klein cubic.  For four inputs \(a_0,a_1,a_2,a_3\in A\), the first three
alternating forms determine a quadratic pair of common isotropic three-planes.
The fourth form supplies a radical vector on each plane; a fixed cofactor
relation gives two conjugate points on \(X\); their residual secant intersection
is the descended output.  Choosing bases removes every ambiguity and gives five
explicit homogeneous determinant formulas.  Before cancelling a common factor,
the displayed coordinates have common degree 568.

At the integral input

\[
\begin{aligned}
b_0&=(1,1,0,0,1),& b_1&=(0,1,-1,1,0),\\
b_2&=(-1,-1,1,-1,-1),& b_3&=(-1,1,-1,0,0),
\end{aligned}
\]

the map is defined and

\[
\Phi(b_0,b_1,b_2,b_3)=[3:-2:2:-1:2].
\]

In the target chart \(y_0\neq0\), exact differentiation with respect to
\((a_0)_0,(a_0)_2,(a_1)_0\) gives the Jacobian minor

\[
\det\begin{pmatrix}
13/3&26/9&52/9\\
0&-17/9&-16/9\\
1/3&19/9&29/9
\end{pmatrix}
=-\frac{221}{27}\neq0.
\]

Hence \(\Phi\) is dominant.  Since its source is the projectivization of an
honest linear \(G\)-representation, the Klein cubic is \(G\)-unirational.  In
particular

\[
\boxed{\operatorname{ed}_{\mathbf C}(\operatorname{PSL}_2(\mathbf F_{11}))=3.}
\]

## Start here

- [`EXPLICIT_MAP_RESOLUTION_20260909.md`](EXPLICIT_MAP_RESOLUTION_20260909.md) —
  theorem, construction, proof of equivariance and dominance, and scope.
- [`explicit_map/klein_rational_coordinates.pdf`](explicit_map/klein_rational_coordinates.pdf)
  and [`explicit_map/klein_rational_coordinates.tex`](explicit_map/klein_rational_coordinates.tex)
  — one-page coordinate formula with every basis and determinant fixed.
- [`explicit_map/README.md`](explicit_map/README.md) — exact evaluators and
  reproduction instructions.

## Relationship with the earlier repository

The older `SPEC.md`, `RESOLUTION.md`, `CURRENT_PATHS.md`, `HANDOFF.md`, and the
large research ledger document the pre-solution campaign.  They are retained as
historical provenance and may still contain the word **OPEN**.  For the headline
status they are superseded by the September 2026 explicit-map resolution above.

Several older negative results remain correct at their stated scope.  In
particular, the direct standard-source homogeneous landing search is excluded
through coordinate degree 34, and the formally verified theorem excluding
honest linear sources into the degree-fourteen Fano partner remains valid.
Neither conflicts with the present map: the source here is \(A^{\oplus4}\), and
the target is the cubic itself.

## Verification status

The explicit-map proof is not yet Lean formalized.  The accompanying scripts
check the Pfaffian identity and group covariance exactly, evaluate the stated
rational point, and recompute the nonzero Jacobian certificate using exact
arithmetic.  Finite-field checks are used only as nonvanishing certificates
after denominators are verified to be units; the landing and equivariance
identities are mathematical identities of the construction, not sampling
claims.
