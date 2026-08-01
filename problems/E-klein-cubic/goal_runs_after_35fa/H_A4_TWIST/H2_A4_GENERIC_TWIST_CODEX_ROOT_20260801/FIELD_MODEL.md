# Canonical field model for the generic `A4` torsor

Let the rational tetrahedral representation be generated on `[x:y:z]` by

\[
g=\operatorname{diag}(-1,-1,1),\qquad
h(x,y,z)=(y,z,x).
\]

Fix `omega^2+omega+1=0` and put

\[
 S=x^2+y^2+z^2,\quad
 L=x^2+\omega y^2+\omega^2z^2,\quad
 M=x^2+\omega^2y^2+\omega z^2.
\]

On `S != 0`, set `ell=L/S`, `m=M/S`, `u=ell^3`, and `v=ell*m`.
The Klein four subgroup fixes the squares, while `h` sends

\[
 (\ell,m)\longmapsto(\omega^2\ell,\omega m).
\]

Consequently

\[
 K_{A_4}=\mathbf C(\mathbf P^2)^{A_4}=\mathbf C(u,v),
 \qquad m^3=v^3/u.
\]

This is an equality, not merely an inclusion.  Indeed, the square map has
generic degree four and is the `V4` quotient.  Fourier inversion gives

\[
 \frac{x^2}{S}=\frac{1+\ell+m}{3},\quad
 \frac{y^2}{S}=\frac{1+\omega^2\ell+\omega m}{3},\quad
 \frac{z^2}{S}=\frac{1+\omega\ell+\omega^2m}{3}.
\]

The residual cyclic extension `C(ell,m)/C(u,v)` has generic degree three,
which is exactly the order of `A4/V4`.  Thus `u,v` are a transcendence basis.

## Identification with the installed torsor

For the generator order used in the installed `A4` record, the exact change
from the canonical coordinates to its icosahedral source coordinates is

\[
P=\begin{pmatrix}
0&1&0\\
(\sqrt5-1)/4&(1+\sqrt5)/4&1/2\\
(1+\sqrt5)/4&1/2&(\sqrt5-1)/4
\end{pmatrix},
\qquad \det P=(\sqrt5-1)/4.
\]

The producer and independent verifier check, for both generators,

\[
 \sigma_{\rm inst}(r)P=P\sigma_{\rm can}(r).
\]

Hence `y_inst=P*y_can` identifies the generic torsors.  The 12 exact linear
forms

\[
 d_r(y)=(1,2,3)\,\sigma_{\rm inst}(r^{-1})P y
\]

are written individually in `canonical_model.json`.  They are precisely the
seed denominators of the installed Hilbert--90 frame after this change.

## Opens

Write `q=xyz` and

\[
 \Delta=(x^2-y^2)(x^2-z^2)(y^2-z^2).
\]

The canonical frame is invertible on

\[
 S q L M\Delta\ne0.
\]

In `C(u,v)` the same open is

\[
 u\,v\,(u^2-v^3)\,(u^2-3uv+u+v^3)\ne0,
\]

because

\[
 27u\,q^2/S^3=u^2-3uv+u+v^3,
 \quad
 \Delta/S^3=-\frac{(2\omega+1)(u^2-v^3)}{9u}.
\]

Comparison with the installed equation takes place on the intersection with

\[
 \left(\prod_{r\in A_4}d_r(y)\right)\det A_{\rm inst}(Py)\ne0.
\]

Every displayed factor is a nonzero rational function.  For the last one,
the installed exact frame has a nonzero good-reduction determinant (`7 mod
89`), which proves that its characteristic-zero determinant is not the zero
function.

