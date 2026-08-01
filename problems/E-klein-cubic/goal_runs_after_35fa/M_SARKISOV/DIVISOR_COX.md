# Divisor, Cox, and Mori-chamber payload

Let \(D\) denote the exceptional divisor and put

\[
H=\pi^*\mathcal O_{X_T}(1),\qquad L=H-D.
\]

## Picard and intersections

\[
\operatorname{Pic}(Y)=\mathbf ZH\oplus\mathbf ZD,
\]

and

\[
H^3=3,\quad H^2D=0,\quad HD^2=-3,\quad D^3=-6.
\]

Consequently

\[
-K_Y=2H-D=H+L,\qquad (-K_Y)^3=12,
\]

and \(L^2H=L^2D=L^3=0\).

## Cox presentation

The blowup sits in the toric blowup of \(\mathbf P^4\) along
\(\Pi_{012}\). Its Cox ring is

\[
\operatorname{Cox}(Y)=
K[a_0,a_1,a_2,y_3,y_4,e]
/\bigl(\Phi(a_0,a_1,a_2,ey_3,ey_4)\bigr),
\]

with degree matrix

| variable | \(H\) | \(D\) |
|---|---:|---:|
| \(a_0,a_1,a_2\) | 1 | 0 |
| \(y_3,y_4\) | 1 | -1 |
| \(e\) | 0 | 1 |

and irrelevant ideal

\[
(a_0,a_1,a_2,e)\cap(y_3,y_4).
\]

The substitutions \(a_3=ey_3\), \(a_4=ey_4\) have class \(H\), so the
single cubic relation is homogeneous of class \(3H\).

## Cones and chambers

\[
\begin{aligned}
\operatorname{Eff}(Y)&=\mathbf R_{\ge0}[D]+\mathbf R_{\ge0}[L],\\
\operatorname{Mov}(Y)&=\operatorname{Nef}(Y)
=\mathbf R_{\ge0}[H]+\mathbf R_{\ge0}[L].
\end{aligned}
\]

The effective cone has two stable-base-locus chambers separated by \(H\):

| chamber | behavior |
|---|---|
| \(\langle D,H\rangle\) | positive \(D\)-part is fixed; moving part factors through \(\pi\) |
| \(\langle H,L\rangle\) | movable/nef chamber of \(Y\) |

Over an algebraic closure let \(q\) be an exceptional fibre and \(\ell\) a
line in a smooth cubic-surface fibre. Then

| curve | \(H\) | \(D\) | \(L\) | \(-K_Y\) |
|---|---:|---:|---:|---:|
| \(q\) | 0 | -1 | 1 | 1 |
| \(\ell\) | 1 | 1 | 0 | 1 |

Thus \(\overline{NE}(Y)=\mathbf R_{\ge0}[q]+\mathbf R_{\ge0}[\ell]\).
The first contraction is \(\pi\), the second is \(f\), and there is no
small wall or flop.

