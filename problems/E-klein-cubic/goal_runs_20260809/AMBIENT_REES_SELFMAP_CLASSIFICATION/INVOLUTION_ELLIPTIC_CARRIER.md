# Involution plus-plane and canonical ordinary carrier

Fix an involution `t`. Write

\[
W_5=W_+\oplus W_-,\qquad \dim W_+=3,\quad \dim W_-=2.
\]

Every ambient landing tuple satisfies

\[
P|_{W_+}=0.
\]

The later binding packet `EXCEPTIONAL_CARRIER_RIGIDITY/` supplies the correct
normalized-Rees integration theorem for the fixed elliptic
`E_t=X\cap P(W_+)`.

## 1. Parity of an ordinary normal layer

Choose normal parameters `(u,v)` spanning `W_-` and write the first nonzero
ordinary normal term as `P^(r)`. Equivariance gives

\[
P^{(r)}(x,-u,-v)=tP^{(r)}(x,u,v),
\]

hence

\[
r\text{ even}\Rightarrow P^{(r)}\in W_+,
\qquad
r\text{ odd}\Rightarrow P^{(r)}\in W_-.
\]

The lowest part of `F(P)=0` gives `F(P^(r))=0`, so an even layer is
elliptic-valued and an odd layer is line-valued.

## 2. The accepted order is odd

The accepted transition theorem used by `EXCEPTIONAL_CARRIER_RIGIDITY` proves
that the first nonzero ordinary normal order along `E_t` is odd. Therefore its
first target lies in

\[
L_t=P(W_-).
\]

This is not merely formal: the ordinary valuation `v_{E_t}` has a canonical
residual-`S3`-stable center

\[
K_{E,t}\subset
\Gamma=\operatorname{Proj}_X\overline{\mathcal R(J)},
\]

where `J` is the primitive restricted base ideal. The joint-residue carrier
theorem proves that `K_{E,t}` is irreducible, refinement-invariant, and carries
a nonconstant actual morphism to `X^t`. The accepted odd jet integrates to
that morphism.

Hence

\[
\boxed{q(K_{E,t})\subset L_t.}
\]

The canonical ordinary carrier over the fixed elliptic is **line-valued**. It
is not the elliptic `[-5]` carrier.

## 3. Where an elliptic carrier could still occur

Any carrier mapping dominantly to `E_t` must be secondary: a curve component
of a normalized exceptional fibre, or an involution-fixed curve slice inside
a retained surface-valued Rees divisor. Point-centered divisors mapping only
to `E_t` are excluded by the joint-residue survival theorem, because a
point-centered divisor survives on the normalized graph only when its target
initial ratios have transcendence degree two.

Thus the remaining elliptic problem is not to identify the first ordinary
carrier. It is to enumerate secondary fixed curves on the actual normalized
type-I/type-II fibres and compute their source degrees and base corrections.
