# Involution plus-plane and the first Rees layers

Fix an involution `t`. Write

\[
W_5=W_+\oplus W_-,\qquad \dim W_+=3,\quad \dim W_-=2.
\]

The accepted ambient landing theorem gives

\[
P|_{W_+}=0.
\]

At the generic point of `P(W_+)`, choose normal parameters `(u,v)` spanning
`W_-`. Expand

\[
P=P^{(r)}+P^{(r+1)}+\cdots
\]

by ordinary normal order, with `P^(r)` the first nonzero term.

## Parity theorem

Since `t` is `+1` on `W_+` and `-1` on the two normal variables,
`G`-equivariance implies

\[
P^{(r)}(x,-u,-v)=tP^{(r)}(x,u,v).
\]

Therefore

\[
r\text{ even}\Rightarrow P^{(r)}\in W_+,
\qquad
r\text{ odd}\Rightarrow P^{(r)}\in W_-.
\]

Passing the exact landing identity to the lowest nonzero normal degree gives

\[
F(P^{(r)})=0.
\]

Consequently any defined ordinary first-exceptional map lands in

\[
E_t=X\cap\mathbf P(W_+)\quad\text{if }r\text{ is even},
\]

and in

\[
L_t=\mathbf P(W_-)\subset X\quad\text{if }r\text{ is odd}.
\]

This gives a sharp boundary condition on the first normal map.

## Why this is not yet a canonical elliptic carrier

The ordinary blowup of the plus-plane is not in general the normalized blowup
of `I_P`. At the generic two-dimensional regular local ring transverse to the
plane, an `m`-primary ideal can have multiple Rees valuations. The ordinary
order valuation need not be among them, and the leading forms may have common
zeros on the exceptional `P^1`, so the rational map can remain indeterminate.

Thus the parity theorem does not prove that an elliptic carrier exists on the
first blowup, nor that it is unique, irreducible, birational over `E_t`, or has
zero base correction. An elliptic horizontal fixed curve may first occur on a
higher normalized-Rees divisor.

## Canonical replacement

For every Rees valuation `v` above the generic plus-plane, normalize the five
coordinates by `m=v(I_P)` and take their residue vector. The global identity
forces that residue vector to lie on the affine cone over `X`. This gives the
canonical map from the associated Rees divisor to `X`.

The still-missing theorem is to identify the `t`-fixed horizontal curves on
these canonical divisors and compute their source degree and base
intersection. No such computation follows from parity alone.
