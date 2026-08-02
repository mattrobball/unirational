# `C_012`: explicit Fisher cover and a `U1`-adic point

## Verdict

This packet makes two exact advances at the arithmetic torsor gate:

1. it writes the canonical Fisher `3`-covering
   `pi:C_012 -> J_012` explicitly by covariants; and
2. it proves that `C_012` has a point over the `U1`-adic completion
   `C(U2,U3,U4)((U1))`.

Neither result decides whether `C_012(K)` is empty for
`K=C(U1,U2,U3,U4)`.  In particular, local solubility at `U1` rules out that
valuation as an obstruction; it is not a global point.

## The exact plane and coefficient substitution

Put `s=U1`, `t_j=T_j`, and let `epsilon` satisfy

\[
 \epsilon^4+\epsilon^3+\epsilon^2+\epsilon+1=0.
\]

For Fisher's standard generic ternary cubic

\[
\begin{aligned}
 F={}&aX^3+bY^3+cZ^3+a_2X^2Y+a_3X^2Z+b_1XY^2\\
    &+b_3Y^2Z+c_1XZ^2+c_2YZ^2+mXYZ,
\end{aligned}
\]

the independently checked `C_012` substitution is

\[
\begin{array}{lll}
 a=t_0,&b=\epsilon t_3,&c=\epsilon^2s t_1,\\
 a_2=(2+\epsilon)t_1,&a_3=(2+\epsilon^2)t_2,
   &b_1=(1+2\epsilon)t_2,\\
 b_3=(2\epsilon+\epsilon^2)t_4,&c_1=(1+2\epsilon^2)t_4,
   &c_2=(\epsilon+2\epsilon^2)s t_0,\\
 &&m=2(1+\epsilon+\epsilon^2)t_3.
\end{array}
\]

The verifier compares this table with an independent expansion of all 27
ordered summands in

\[
 \operatorname{Tr}\left(
 R_2R_3^2(X+Y\alpha+Z\alpha^2)^2
 \sigma(X+Y\alpha+Z\alpha^2)
 \right).
\]

## Explicit Fisher `3`-covering

The covariant normalization is as follows.  Let

\[
 H=-\frac12\det\left(\frac{\partial^2F}
 {\partial X_i\partial X_j}\right).
\]

If quadrics `Q_i=(1/2)x^t A_i x`, define

\[
 \{Q_1,Q_2\}=[q]\operatorname{adj}(A_1+qA_2).
\]

Then set

\[
 M=\sum_{i,j}\{F_i,H_j\}X_iX_j,
 \qquad
 \Theta=(\nabla F)^tM(\nabla H),
 \qquad
 J=\frac13\det(\nabla F,\nabla H,\nabla\Theta),
\]

where the three gradients in the last determinant are rows.

With the coefficient substitution above, the covering map is

\[
 \boxed{\quad
 \pi:C_{012}\longrightarrow J_{012},\qquad
 (Z_E:X_E:Y_E)=(H^3:\Theta H:J).
 \quad}
\]

Here

\[
 J_{012}:Y_E^2Z_E=X_E^3-27c_4X_EZ_E^2-54c_6Z_E^3,
\]

with the exact `c4,c6` from the hash-bound Jacobian packet.

The identification of this covariant formula with the canonical covering is
imported from T. A. Fisher,
[*Finding Rational Points on Elliptic Curves Using 6-Descent and
12-Descent*](https://www.dpmms.cam.ac.uk/~taf1000/papers/6and12-JALG.pdf),
Proposition 5.2.  In Fisher's normalization the relation on `F=0` is

\[
 J^2=\Theta^3-27c_4\Theta H^4-54c_6H^6.
\]

The replay verifies the exact generic `H` and `Theta` tables: they have 73
and 6,952 coefficient monomials, with SHA-256 digests recorded in
`payload.json`.  It retains `J` by the displayed exact determinant recipe
instead of serializing its 83,744-term generic expansion.  As a normalization
guard, it computes all three covariants on the Hesse family and checks the
syzygy modulo the Hesse cubic exactly.

Thus this packet gives an explicit geometric representative
`xi in H^1(K,J_012[3])`, whose image in `H^1(K,J_012)` is the torsor
`[C_012]`.  It does not determine whether either class vanishes.

## The obstruction algebra is automatically split

The period-index obstruction `Ob_3(xi)` is the Brauer class of the target
Brauer-Severi surface of the degree-three diagram.  The displayed ternary
cubic is already embedded in the actual split plane `P^2_K`.  Consequently

\[
 \operatorname{Ob}_3(\xi)=0,
\]

and the associated nine-dimensional central simple obstruction algebra is
`Mat_3(K)`.  This is structural, not a solubility verdict.  The obstruction
formalism and its relation to Brauer-Severi diagrams are described in
Cremona--Fisher--O'Neil--Simon--Stoll,
[*Explicit n-Descent on Elliptic Curves, I: Algebra*](https://www.dpmms.cam.ac.uk/~taf1000/papers/n-descent-I.pdf).

In particular:

- a `K`-flex would prove `xi=0`;
- a `K`-point on `C_012` only proves `[C_012]=0` and need not be a flex;
- splitting the obstruction algebra proves neither statement, because it is
  already split for every ternary cubic in a split plane.

## Exact `U1`-adic point

Let

\[
 k_0=\mathbf C(U_2,U_3,U_4),\qquad s=U_1.
\]

On the chart `X=0,Z=1`, the plane equation becomes

\[
\begin{aligned}
 B(Y)={}&\epsilon T_3Y^3+(\epsilon^2+2\epsilon)T_4Y^2\\
       &+(2\epsilon^2+\epsilon)sT_0Y+\epsilon^2sT_1.
\end{aligned}
\]

The exact trace tables give

\[
 T_0\equiv5\pmod s,
 \qquad T_1,T_3,T_4\in s k_0[s].
\]

Therefore `G=B/s` is integral over `k0[[s]]`, and at `(s,Y)=(0,0)`,

\[
 G=0,
 \qquad
 G_Y=5(2\epsilon^2+\epsilon)\ne0.
\]

The derivative is a unit, so Hensel's lemma gives a unique

\[
 Y(s)\in s k_0[[s]]
\]

with `B(Y(s))=0`.  Hence

\[
 [0:Y(s):1]\in C_{012}(k_0((s))).
\]

The verifier also checks the first coefficient.  If

\[
\begin{aligned}
 A_1=(T_1/s)|_{s=0}={}&(10\epsilon^2+5\epsilon^3)U_4
 +(-10-10\epsilon^3)U_3\\
 &+(5+10\epsilon)U_2+(10+5\epsilon^2)U_2^2,
\end{aligned}
\]

then

\[
 \frac{Y(s)}s\equiv
 -\frac{\epsilon^2A_1}{5(2\epsilon^2+\epsilon)}\pmod s.
\]

## Exact scope

Proved:

- the exact `C_012` substitution into Fisher's generic ternary cubic;
- the explicit canonical covering map, using Fisher's cited theorem;
- splitness of its period-index obstruction algebra;
- a `C(U2,U3,U4)((U1))`-point, including its first series coefficient.

Not proved:

- `xi=0` or `xi!=0` in `H^1(K,J_012[3])`;
- `[C_012]=0` or `[C_012]!=0` in `H^1(K,J_012)`;
- a `K`-rational flex, a `K`-point, or `K`-pointlessness;
- a point or obstruction for the ambient twisted cubic threefold;
- the full expanded Fisher syzygy after substituting the trace polynomials.

The global arithmetic gate therefore remains open.
