# Exact residual-point theorem and present applicability

Let `L/K` be a separable degree-eleven field, let
`tau=(alpha:beta) in P1(L)` have exact degree eleven, and let

\[
g_\tau(s,t)\in K[s,t]
\]

be its monic homogeneous orbit polynomial.  Let `X={F=0}` be a cubic in a
split `P4_K` and let

\[
\phi=(\phi_0:\cdots:\phi_4):\mathbf P^1_K\longrightarrow\mathbf P^4_K
\]

be given by five basepoint-free binary quartics.  Suppose
`phi(tau)=P in X(L)` projectively.

Then `F(phi)` is a homogeneous binary form of degree twelve and vanishes at
`tau`.  The minimal polynomial therefore divides it in `K[s,t]`:

\[
F(\phi(s,t))=g_\tau(s,t)\,\ell(s,t).
\tag{1}
\]

There are exactly two cases.

1. If `F(phi)=0`, the image of `phi` is a `K`-rational curve on `X`.
2. Otherwise `ell` is a nonzero homogeneous linear form over `K`.  Its root
   `rho in P1(K)` is not a base point, so `phi(rho)` is a nonzero `K`-point
   of `X`.

Because `g_tau` is irreducible of degree eleven, a nonzero linear `ell`
cannot share a factor with it.  Thus (1) is also the scheme-theoretic
intersection decomposition, with the selected degree-eleven divisor and the
residual rational point both having their correct multiplicities.

For the genuine Schur twist, a point obtained from (1) would execute the
accepted generic-twist/Schur-versality bridge and prove the positive
headline.

## Boundary in this packet

The exact rank certificate in `INTERPOLATION_INCIDENCE.md` proves that no
degree-four `phi` interpolates either of the two transported points.  Hence
there is no binary degree-twelve form to divide in this packet, and (1) is a
verified conditional theorem rather than an asserted residual identity for
a nonexistent solution.  In particular neither positive A5Q headline exit
is claimed.
