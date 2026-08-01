# The genuine $f_5$ Hessian-kernel line

## Exact Hessian identity

For

\[
F=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1},
\]

the literal degree-five invariant in the repository satisfies

\[
\det\operatorname{Hess}(F)=32f_5.
\]

Thus $H=(f_5=0)$ is the Hessian divisor. At its generic point the Hessian
has a canonical kernel line. Choose the first column

\[
y=\operatorname{adj}(\operatorname{Hess}(F))e_0.
\]

The choice of column only chooses a rational scale on the open where that
column is nonzero; the projective kernel line itself is canonical and
$G$-equivariant.

## Pure-cubic line section

The adjugate identity gives

\[
\operatorname{Hess}(F)y=32f_5e_0.
\]

Since $F$ is cubic, its exact Taylor expansion on the projective line
spanned by $x$ and $y$ is

\[
F(sx+ty)=s^3F(x)+s^2tB_{21}(x,y)+st^2B_{12}(x,y)+t^3F(y).
\]

Both mixed coefficients are multiples of $f_5$. The producer verifies the
two exact polynomial divisions, and the independent verifier reconstructs
them from scratch. Hence in $\mathbf C(H)[s,t]$,

\[
F(sx+ty)=s^3f_3+t^3F(y).
\]

The point at $s=0$ is not on the cubic because $F(y)$ is generically
nonzero. For $s$ nonzero, a rational intersection point would require

\[
\left(\frac ts\right)^3=-\frac{f_3}{F(y)}.
\]

## Exact noncube valuation

At the characteristic-23 projective point

```text
[x0:x1:x2:x3:x4] = [8:4:4:8:7]
```

the verifier reconstructs

```text
(f3,f5,F(y)) = (0,0,20) mod 23,
grad(f3)      = (21,4,11,13,15),
grad(f5)      = (12,10,22,14,21).
```

The $x_1,x_2$ Jacobian minor is $1$ modulo 23. Since $x_0$ is nonzero, this
is a smooth point of the complete intersection in the $x_0$-chart.
Multivariate Hensel lifts the germ to characteristic zero. On the lifted
geometric prime divisor $Z\subset H$,

\[
\operatorname{ord}_Z(f_3)=1,
\qquad
\operatorname{ord}_Z(F(y))=0.
\]

Therefore

\[
\operatorname{ord}_Z\!\left(-\frac{f_3}{F(y)}\right)=1,
\]

which is not divisible by three. The ratio is not a cube even after
extending the constant field to $\mathbf C$.

## Scoped conclusion

The canonical projective line

\[
\langle x,\ker\operatorname{Hess}(F)_x\rangle
\]

has no $\mathbf C(H)$-rational intersection point with the Klein cubic at
the generic point of $H$. Hence its descended line cannot provide a point
on the genuine $f_5$-residue twist.

This excludes one canonical construction only. It does not imply that the
full residue cubic is pointless; a point away from this line remains
possible.

## Replay

```sh
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/produce_hessian_line.py
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/verify_hessian_line.py
```

Required markers:

```text
V_F5_HESSIAN_LINE_PRODUCED
V_F5_HESSIAN_LINE_INDEPENDENT_ACCEPT
```
