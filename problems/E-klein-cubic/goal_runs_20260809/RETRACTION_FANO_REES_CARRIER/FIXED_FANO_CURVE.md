# The involution-fixed genus-four curve on the Klein Fano surface

Let `S=F(X)` be the Fano surface of lines on the Klein cubic and fix an
involution `t`.  Write

\[
W_5=W_+\oplus W_-,\qquad
E_t=X\cap\mathbf P(W_+),\qquad L_t=\mathbf P(W_-).
\]

## 1. Intrinsic equation

Invariance and cubic parity give

\[
F(x+y)=F(x)+3\Phi(x,y,y)
\qquad(x\in W_+,\ y\in W_-).
\]

Thus the mixed line `P(<x,y>)` is contained in `X` exactly when

\[
x\in E_t,\qquad \Phi(x,y,y)=0.
\]

Define

\[
R_t=V(\Phi(x,y,y))\subset E_t\times L_t.
\]

The map `(x,y) -> P(<x,y>)` identifies `R_t` with the curve component of
`S^t`; the only other fixed point is the line `L_t` itself.  The fixed locus of
a finite-order automorphism on the smooth surface `S` is smooth.  The defining
line bundle

\[
\mathcal O_{E_t}(1)\boxtimes\mathcal O_{\mathbf P^1}(2)
\]

is ample, so `R_t` is connected and hence irreducible.

The two projections have degrees

\[
R_t\to E_t:2,\qquad R_t\to L_t:3.
\]

Adjunction on `E_t x P1` gives

\[
g(R_t)=4.
\]

## 2. Distinction from the genus-two curve

Roulleau studies the incidence divisor `C_{L_t}` of lines meeting `L_t`.
For a harmonic inversion it decomposes as

\[
C_{L_t}=D_t+R_t,
\]

where `D_t` is the smooth genus-two component and the residual component has
genus four.  The two components have different geometry.

- A line parametrized by `R_t` meets the plus-plane at a point of `E_t` and is
  fixed setwise by `t`.
- The two lines parametrized over a general point of the conic defining `D_t`
  are exchanged by `t` and do not contain a point of `E_t`.

A boundary line selected by a retraction branch which is fixed by `t` must
therefore land on `R_t`, not on `D_t`.

Numerically, with `C` an incidence class,

\[
C^2=5,\qquad C\cdot D_t=2,\qquad D_t^2=-4,\qquad K_S=3C,
\]

and hence

\[
R_t=C-D_t,\qquad R_t^2=-3,\qquad K_S\cdot R_t=9.
\]

## 3. Residual `S3` action

The residual group is

\[
N_G(\langle t\rangle)/\langle t\rangle\simeq S_3.
\]

An order-three element acts on `E_t` by translation by a nonzero 3-torsion
point, hence freely on `R_t`.  Its quotient has genus two.

For a residual reflection represented by a commuting involution `s`, the
fixed points on `R_t` are:

1. the isolated fixed line `L_s`, which is a mixed `t`-line and lies on `R_t`;
2. the unique point of `R_t cap R_s`.

The second point is unique because Roulleau's intersection numbers give

\[
R_t\cdot R_s=(C-D_t)(C-D_s)=5-2-2+0=1
\]

when `ts` has order two.  Thus the reflection has two fixed points and its
quotient also has genus two.

Therefore the character on holomorphic differentials is

\[
\chi(1)=4,\qquad \chi(\text{reflection})=0,\qquad
\chi(\text{3-cycle})=1,
\]

so

\[
H^0(R_t,\Omega^1)
\simeq
\mathbf1\oplus\operatorname{sgn}\oplus\operatorname{std}.
\]
