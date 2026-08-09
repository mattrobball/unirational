# Degree-one branch and rational retractions

## 1. Degree one is completely classified as a selfmap

Let \(\varphi:X\dashrightarrow X\) be a dominant \(G\)-equivariant rational
selfmap with \(\deg\varphi=1\). Then \(\varphi\) is birational. Full-\(G\)
birational superrigidity makes it a regular equivariant automorphism.
Since

\[
\operatorname{Aut}(X)=G,
\qquad
\operatorname{Aut}^G(X)=C_G(G)=Z(G)=1,
\]

one has

\[
\boxed{\varphi=\operatorname{id}_X.}
\]

This branch is closed at the selfmap level.

## 2. Consequence for an ambient map

Suppose a dominant ambient landing map

\[
f:\mathbf P(W_5)\dashrightarrow X
\]

has degree-one restriction. After the preceding normalization,

\[
f|_X=\operatorname{id}_X.
\]

Thus \(f\) is a rational \(G\)-retraction of the ambient projective space
onto \(X\).

For a primitive homogeneous representative \(T\) of degree \(d\), the
accepted exact normal form is

\[
T=Hx+FQ,
\qquad \gcd(H,F)=1,
\tag{2.1}
\]

with

\[
\deg H=d-1,
\qquad
\deg Q=d-3.
\]

Writing

\[
A=\Phi(x,x,Q),
\quad B=\Phi(x,Q,Q),
\quad C=F(Q),
\]

gives invariants \(R,S\) satisfying

\[
H+3A=FR,
\qquad
F(Q)=HS,
\qquad
HR+3B+FS=0,
\tag{2.2}
\]

and the line factorization

\[
\boxed{
F(x+tQ)=(Ht-F)(St^2-Rt-1).
}
\tag{2.3}
\]

## 3. Residual discriminant

The residual quadratic has discriminant

\[
\Delta=R^2+4S.
\]

If \(\Delta\) is a square, (2.3) produces two landing covariants of degree
\(d-3\). This is a genuine degree descent for landing maps, although the
smaller maps need not themselves be retractions.

If \(\Delta\) is nonsquare, the residual quadratic defines a connected
double cover over the function field. Degree, invariance, and UFD arguments
do not force it to split. The repository's primitive irreducible degree-nine
countermodel on a singular nonequivariant cubic proves that the full polar
system alone does not exclude this branch.

## 4. Base divisor and lines

On

\[
B=V(F,H)\subset X,
\]

the polar identities force every line

\[
\langle x,Q(x)\rangle
\]

to lie on \(X\), wherever it is noncollapsed. Thus the first exceptional
divisor gives a rational section of the six-sheeted line-incidence cover over
\(B\).

Such split divisors occur in unbounded classes on the incidence threefold.
A contradiction must use that the line is selected by one global covariant
\(Q\) satisfying all of (2.2), not merely that an incidence section exists.

## 5. Effect of the arbitrary-selfmap theorem

The tangent-residual construction refutes the strategy of first proving that
**all** equivariant selfmaps have degree one. It does not alter the exact
retraction identities above. For Problem E, one must now attack the ambient
subclass directly:

- exclude all ambient-extendable degree-greater-than-one restrictions; and
- exclude the nonsquare retraction branch when the restriction has degree
  one.

Neither step follows from arbitrary selfmap rigidity.

## 6. Honest boundary

No Klein-specific theorem is presently proved that forces \(\Delta\) to be a
square or otherwise contradicts the nonsquare double cover. The headline
negative result is therefore not obtained.

```text
FULL-G-DEGREE-ONE-SELFMAP-IS-IDENTITY
DELTA1-RETRACTION-NORMAL-FORM-RETAINED
DELTA1-NONSQUARE-RESIDUAL-BRANCH-OPEN
KLEIN-PSL2(11)-NONUNIRATIONAL-NOT-PROVED
```
