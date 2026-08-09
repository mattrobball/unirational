# Scheme-theoretic gluing on the fixed-curve network

Let \(D\) be the reduced union of all involution-fixed elliptics and lines.

## 1. Exact local incidence types

For a local \(V_4=\langle z,s\rangle\), with \(r=zs\), the joint decomposition
is

\[
W=A\oplus B\oplus C\oplus D_0,\qquad
\dim(A,B,C,D_0)=(2,1,1,1).
\]

The three fixed lines and elliptics are

\[
\begin{aligned}
L_z&=\mathbf P(C+D_0),&
E_z&=X\cap\mathbf P(A+B),\\
L_s&=\mathbf P(B+D_0),&
E_s&=X\cap\mathbf P(A+C),\\
L_r&=\mathbf P(B+C),&
E_r&=X\cap\mathbf P(A+D_0).
\end{aligned}
\]

There are exactly two local intersection types.

### Type I

At \([B]\), the three branches are

\[
E_z,\quad L_s,\quad L_r.
\]

Cyclically, \([C]\) and \([D_0]\) give the other two vertices. Thus a type-I
point is one elliptic/line intersection and one line/line intersection,
simultaneously.

### Type II

The scheme

\[
R=X\cap\mathbf P(A)
\]

is a degree-three divisor on \(\mathbf P(A)\simeq\mathbf P^1\). Its three
distinct points are the type-II points, and every one lies on

\[
E_z,\quad E_s,\quad E_r.
\]

No fixed line passes through a type-II point.

There are no other intersections among the 110 fixed curves.

## 2. Reduced scheme intersections

The type-I intersections are reduced because the corresponding ambient linear
spaces meet in the single reduced point \(\mathbf P(B)\), \(\mathbf P(C)\), or
\(\mathbf P(D_0)\).

For a pair of the three elliptics,

\[
E_z\cap E_s=X\cap\mathbf P(A)=R
\]

scheme-theoretically, and similarly for the other pairs. The divisor \(R\) has
degree three and has three distinct points, so it is reduced.

The tangent-character certificate gives three distinct nontrivial
\(V_4\)-characters in \(T_pX\) at both type-I and type-II points. Because the
finite \(V_4\)-action is formally linearizable in characteristic zero, the
three local fixed branches become the three coordinate axes. Thus the
completed local ring of the reduced network is

\[
\widehat{\mathcal O}_{D,p}
\simeq
k[[x,y,z]]/(xy,xz,yz).
\]

Its normalization consists of three power-series branches whose constant
terms agree. In particular, the overlap carries no nilpotents and no tangent
or derivative matching condition.

## 3. Agreement of the component maps

Every type-I and type-II point on an elliptic belongs to

\[
M_t=E_t[2]+\langle q_t\rangle\subset E_t[6],
\]

so it is fixed by \([-5]\). Every line map is the identity.

Therefore:

- at an elliptic/line type-I point, both component maps give the same point;
- at a line/line type-I point, both identity maps agree;
- at a type-II point, all three elliptic maps give the same point.

## 4. Gluing criterion

For a reduced union \(C_1\cup C_2\), the coordinate ring is the fiber product
over the scheme-theoretic intersection. Iterating this at the ordinary triple
points shows that morphisms on the normalized branches glue exactly when
their restrictions to the reduced intersection points agree.

The agreement just proved therefore produces a genuine morphism

\[
\lambda_D:D\longrightarrow X.
\]

Since conjugation by \(G\) transports every component map, the glued morphism
is \(G\)-equivariant.

```text
DEGREE25-CANONICAL-BOUNDARY-MORPHISM-PROVED
```
