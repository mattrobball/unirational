# Exact fibration model and section conventions

## Graph model

The installed M2 packet gives

\[
Y=\{\Phi(a_0,\ldots,a_4)=0,\ a_3t-a_4s=0\}
\subset\mathbf P^4_K\times\mathbf P^1_K.
\]

Over \([s:t]\), the cubic-surface fibre is

\[
S_{[s:t]}:\quad \Phi(a_0,a_1,a_2,su,tu)=0\subset\mathbf P^3.
\]

The map to \(X_T\) forgets \([s:t]\); the map to \(\mathbf P^1\) forgets
\([a]\).  Put

\[
H=\pi^*\mathcal O_{X_T}(1),\qquad D=\operatorname{Exc}(\pi),
\qquad L=H-D=f^*\mathcal O_{\mathbf P^1}(1).
\]

The M2 intersection and Cox data give \(-K_Y=H+L=2H-D\), relative Picard
rank one, and the two extremal rays.

## Exceptional sections

The center is the complete intersection of two hyperplanes in \(X_T\), so

\[
N_{C/X_T}\simeq\mathcal O_C(1)\oplus\mathcal O_C(1).
\]

Consequently

\[
D=\mathbf P_C(N_{C/X_T})\simeq C\times\mathbf P^1,
\]

and the restriction of \(f\) is projection to the second factor.  A section
inside \(D\) is therefore a morphism \(\mathbf P^1\to C\).  Since \(C\) is a
smooth genus-one curve, every such morphism is constant.  Thus

\[
\{\text{sections contained in }D\}\simeq C,
\]

and a \(K\)-section of this type exists exactly when \(C(K)\ne\varnothing\).
Its intersection numbers are

\[
H\cdot\Gamma=0,\qquad L\cdot\Gamma=1,
\qquad D\cdot\Gamma=-1.
\]

This component must not be lost by imposing \(u\ne0\) at the start of a Cox
search.

## Nonexceptional sections

Let \(\Gamma\not\subset D\) be a section and put \(d=H\cdot\Gamma\).  Since
\(L\cdot\Gamma=1\),

\[
D\cdot\Gamma=d-1.
\]

Pulling the graph coordinates back to the fixed base \(\mathbf P^1\) gives
binary forms

\[
A_i\in K[s,t]_d\quad(i=0,1,2),\qquad
U\in K[s,t]_{d-1},
\]

with

\[
a_3=sU,\qquad a_4=tU.
\]

The section equations are the \(3d+1\) coefficients of

\[
\Phi(A_0,A_1,A_2,sU,tU)=0.
\]

The parameter count before saturation is

\[
3(d+1)+d=4d+3
\]

affine coefficients, modulo common scalar.  The raw coefficient scheme must
be saturated by the no-common-zero morphism open and separated from the
exceptional locus \(U=0\).

For \(d=1\), the blowdown is a line disjoint from \(C\).  For \(d=2\), it is
a geometrically integral conic meeting \(C\) once.  The binding no-line and
no-conic theorems exclude both over \(K\).  At \(d=3\), the raw scheme is ten
cubics in \(\mathbf P^{14}\).

## Evaluation bridge

A rational section gives a \(K\)-point of \(Y\), hence of \(X_T\), by
evaluation at any \(K\)-point of the base.  Therefore an actual section is a
headline-positive bridge.  A geometric component, a finite orbit of
sections, or a modular section does not supply that bridge without descent.
