# Type-II V4 local Rees coupling

Fix `V4=<z,s>` with the accepted joint decomposition

\[
W=A\oplus B\oplus C\oplus D,
\qquad \dim A=2,
\]

where `A` is trivial and `B,C,D` carry the three nontrivial characters. The
three involution plus-planes are

\[
\mathbf P(A\oplus B),\quad
\mathbf P(A\oplus C),\quad
\mathbf P(A\oplus D).
\]

Let `x` be a type-II point on `P(A)`. On a transverse local slice choose
character coordinates `(b,c,d)` in `B,C,D`.

## 1. One ideal couples all three involutions

Every ambient landing tuple vanishes on each involution plus-plane. Therefore
each coordinate of `P` belongs locally to

\[
(c,d)\cap(b,d)\cap(b,c)=(bc,bd,cd).
\tag{1.1}
\]

This is stronger than three independent normal-jet conditions: it is an exact
constraint on the single local base ideal.

In particular there is no linear normal term.

## 2. Quadratic character decomposition

The degree-two part of (1.1) is spanned by `bc,bd,cd`. Their characters are the
three nontrivial characters again. Hence the quadratic initial tuple has no
`A`-component and, after choosing generators of `B,C,D`, has the form

\[
P_B^{(2)}=\alpha\,cd,
\qquad
P_C^{(2)}=\beta\,bd,
\qquad
P_D^{(2)}=\gamma\,bc.
\tag{2.1}
\]

The coefficients are functions along the fixed line `P(A)`; at the chosen
generic/local point they may be viewed in the residue field.

## 3. The landing identity gives a product-zero relation

Inside `P(B\oplus C\oplus D)`, the accepted V4 minus-lines are

\[
P(C\oplus D),\quad P(B\oplus D),\quad P(B\oplus C),
\]

and all lie in `X`. Therefore the restriction of the cubic `F` to this `P^2`
vanishes on the three coordinate lines, hence

\[
F|_{B\oplus C\oplus D}=\kappa\,BCD.
\tag{3.1}
\]

Here `kappa != 0`: otherwise `X` would contain the plane
`P(B\oplus C\oplus D)`. A smooth cubic threefold cannot contain a plane: if
`F=x_3Q_3+x_4Q_4` along a contained plane, the two quadrics `Q_3,Q_4` have a
common point on `P^2`, where all first derivatives vanish.

Taking the first possible degree-six contribution to `F(P)=0` and using (2.1)
gives

\[
0=\kappa\alpha\beta\gamma\,b^2c^2d^2.
\]

Thus

\[
\boxed{\alpha\beta\gamma=0.}
\tag{3.2}
\]

## 4. Geometric consequence

The first point blowup has exceptional `P^2`. If all three quadratic character
coordinates were nonzero, its induced map would have image meeting the open
torus of `P(B+C+D)`, contradicting (3.2). Therefore at least one of the three
character directions is absent at quadratic order; the first exceptional
surface maps into one edge of the V4 minus-triangle (or degenerates further).

So the first point-exceptional `P^2` cannot simultaneously realize three
elliptic carriers. At least one local involution carrier is forced to higher
Rees order.

## 5. Exact remaining local theorem

Equation (3.2) does not bound the next orders. A higher term can restore the
missing character direction, and normalized blowup can introduce weighted or
multiple divisors. The missing local theorem is to classify those higher Rees
valuations for ideals satisfying (1.1), full V4-equivariance, and the entire
identity `F(P)=0`, not just its degree-six initial term.
