# Hodge representation carried by the fixed Fano curves

This file identifies the exact residual representation contributed by the
involution-fixed genus-four curve and compares it with the original fixed
elliptic.

## 1. Residual representation on `R_t`

For

\[
N_G(\langle t\rangle)/\langle t\rangle\simeq S_3,
\]

the character of `H^0(R_t,Omega^1)` on the three conjugacy classes is

\[
(4,0,1)
\]

in the order `(identity, reflection, 3-cycle)`.

- The 3-cycle acts freely because its action on `E_t` is translation by a
  nonzero 3-torsion point.  The quotient has genus two, so the invariant
  subspace has dimension two.  Conjugacy of a 3-cycle and its inverse forces
  the other two eigenspaces to have dimension one each; the trace is one.
- A reflection has two fixed points.  Riemann--Hurwitz gives quotient genus
  two, so its `+1` and `-1` eigenspaces both have dimension two and its trace
  is zero.

Thus

\[
H^0(R_t,\Omega^1)
\simeq
\mathbf1\oplus\operatorname{sgn}\oplus\operatorname{std}.
\tag{1.1}
\]

The central involution `t` acts trivially because `R_t` is fixed pointwise as
a curve in the Fano surface.

## 2. Restriction of the Klein module

The exact `V4` character decomposition gives, for the centralizer
`D12=N_G(<t>)`,

\[
W_5|_{D_{12}}
=
(\mathbf1\oplus\operatorname{std})_{t=+1}
\oplus
(\operatorname{std})_{t=-1}.
\tag{2.1}
\]

Combining (1.1) and (2.1),

\[
\dim\operatorname{Hom}_{D_{12}}
\left(W_5,H^0(R_t,\Omega^1)\right)=2.
\tag{2.2}
\]

Frobenius reciprocity therefore gives

\[
\operatorname{mult}_{W_5}
\operatorname{Ind}_{D_{12}}^G H^0(R_t,\Omega^1)=2.
\tag{2.3}
\]

The orbit of 55 fixed Fano curves is consequently large enough to carry the
five-dimensional Weil representation required by the Hodge-center theorem.
Every finite carrier cover `C -> R_t` inherits `H^0(R_t,Omega^1)` injectively,
so the same statement applies to the orbit of source carriers selected by the
normalized Pluecker graph.

## 3. Why the 55 source elliptics are insufficient

On the fixed elliptic `E_t`, the residual 3-cycle is a translation and acts
trivially on differentials, while every residual reflection acts as inversion
and hence by `-1`.  Thus

\[
H^0(E_t,\Omega^1)\simeq\operatorname{sgn},
\tag{3.1}
\]

with the central involution acting trivially.  Equation (2.1) then gives

\[
\operatorname{Hom}_{D_{12}}
\left(W_5,H^0(E_t,\Omega^1)\right)=0.
\tag{3.2}
\]

Therefore the orbit of the original 55 elliptics does **not** account for the
required Weil summand in a resolution of a dominant ambient map.  The
normalized line carriers change this: their genus-four target supplies exactly
the missing trivial and standard residual summands.

## 4. Consequence for the retraction branch

The retraction line graph does not merely create unspecified positive-genus
centres.  Whenever a fixed carrier occurs, its finite cover of `R_t` is an
explicit theorem-forced Hodge carrier.  Conversely, the ruled curve-image
branch of `GLOBAL_DICHOTOMY.md` can avoid these fixed carriers only by pairing
every component above `E_t` under `t`; in that branch the required Weil module
must instead occur in `H^1(Sigma^nu)` of the faithful `G`-curve which is the
line-map image.
