# Polarization and homogeneous degree

Let

\[
\mathcal L_t=\mathcal O_{E_t}(1)
\]

be the actual degree-three line bundle from the plane embedding
\(E_t\subset\mathbf P(E_+(t))\).

## 1. Symmetry of the plane polarization

Choose a type-I point \(O\) as origin. Its residual stabilizer is a reflection.
The reflection is induced by a linear automorphism of the ambient plane, so it
preserves \(\mathcal L_t\).

Since \(j(E_t)=8192/11\), the only origin-preserving automorphisms are
\(\pm1\). The nontrivial reflection fixing \(O\) is therefore inversion, and

\[
[-1]^*\mathcal L_t\simeq\mathcal L_t.
\]

Thus \(\mathcal L_t\) is symmetric for this group law.

The same conclusion holds after any permitted marked-origin change. If the new
origin is \(b\in M_t\), its inversion is \(P\mapsto2b-P\); because
\(2b\in\langle q_t\rangle\), this is one of the residual reflections and again
preserves the plane polarization.

## 2. Pullback by \([-5]\)

For a symmetric line bundle on an elliptic curve, the theorem of the square
gives

\[
[n]^*\mathcal L_t\simeq\mathcal L_t^{\otimes n^2}.
\]

Consequently

\[
[-5]^*\mathcal O_{E_t}(1)
\simeq
\mathcal O_{E_t}(1)^{\otimes25}
=
\mathcal O_{E_t}(25).
\]

This proves the claimed degree statement in the actual embedding, not merely
in a chosen Weierstrass model.

## 3. What degree 25 does and does not imply

If a homogeneous degree-\(d\) tuple is basepoint-free on \(E_t\) and induces
\([-5]\), then

\[
\mathcal O_{E_t}(d)\simeq[-5]^*\mathcal O_{E_t}(1),
\]

so \(d=25\).

If the restricted tuple has a common zero divisor \(B_t\), cancellation gives

\[
\mathcal O_{E_t}(d)(-B_t)\simeq\mathcal O_{E_t}(25),
\qquad
\deg B_t=3(d-25).
\]

Thus degree 25 is the basepoint-free elliptic degree. Higher-degree
representatives can arise by scalar multiplication, but only a global common
invariant scalar is removable by the universal-object primitive-reduction
theorem.

## 4. The line component has incompatible polarization

On a fixed line, the boundary map is the identity, so

\[
\lambda_D^*\mathcal O_X(1)|_{L_t}
\simeq
\mathcal O_{L_t}(1).
\]

By contrast,

\[
\mathcal O_D(25)|_{L_t}\simeq\mathcal O_{L_t}(25).
\]

Hence the discrepancy line bundle

\[
\mathcal A=
\mathcal O_D(25)\otimes
\lambda_D^*\mathcal O_X(1)^{-1}
\]

has multidegree

\[
\deg(\mathcal A|_{E_t})=0,\qquad
\deg(\mathcal A|_{L_t})=24.
\]

It is not trivial. Therefore a degree-25 coordinate tuple cannot induce
\(\lambda_D\) as a morphism on all of \(D\).

More generally, one homogeneous basepoint-free degree \(d\) tuple would force
simultaneously

\[
d=25\quad\text{from }E_t,\qquad d=1\quad\text{from }L_t.
\]

No such \(d\) exists.

## 5. Rational line cancellation

A degree-25 tuple inducing the identity rationally on
\(L_t\simeq\mathbf P^1\) must have the form

\[
h_t(y_0,y_1)\,(y_0,y_1)
\]

in the target \(E_-(t)\), with \(\deg h_t=24\). Such a form has zeros, so the
tuple is not a morphism on the line. Componentwise cancellation can recover
the identity as a rational map, but it does not repair the landing obstruction:
every landing covariant vanishes on the entire plus-plane and hence on the
elliptic component.
