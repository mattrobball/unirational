# Retraction Fano--Rees carrier: status

**Date:** 2026-08-09  
**Problem:** Klein cubic / `PSL2(F11)`  
**Exit:** `DELTA1-FANO-REES-CARRIER-THEOREM`  
**Headline:** Problem E remains **OPEN**.

## Executive theorem

Assume that a primitive ambient landing tuple is a rational `G`-retraction:

\[
T=Hx+FQ,\qquad F(T)=0,\qquad [T]|_X=\operatorname{id}_X,
\]

and put `B=V_X(H)`.  The tuple determines the gauge-independent Pluecker ideal

\[
J_{\rm line}
=\left(\frac{x_iT_j-x_jT_i}{F}\right)\mathcal O_B
=(x_iQ_j-x_jQ_i)\mathcal O_B.
\]

Its normalized Rees algebra is the canonical graph of the line-selection map
`B -->> F(X)`.

The following are proved.

1. For every involution `t`, the mixed fixed lines form a smooth connected
   genus-four curve
   \[
   R_t=\{(x,y)\in E_t\times L_t:\Phi(x,y,y)=0\}.
   \]
   It maps with degrees two and three to `E_t` and `L_t`.  It is the residual
   genus-four component in Roulleau's decomposition
   `C_{L_t}=D_t+R_t`, not the genus-two component `D_t`.
2. The retraction base `B` is singular along all 55 elliptics `E_t`.
3. In the normalized Pluecker graph, a carrier component above `E_t` is either
   fixed by `t` or paired with a distinct conjugate component.  A fixed
   component is a finite cover of `R_t`; if its degree over `E_t` is `2k`, its
   genus is at least `3k+1`.
4. No carrier component above `E_t` has degree one.  Such a component would
   give a nonconstant elliptic curve on the Klein Fano surface, which contains
   neither rational nor elliptic curves.
5. If `B` is irreducible, the line map cannot collapse identically.  Degree
   and the landing equation would otherwise force `F|H`, contradicting
   primitivity.
6. For irreducible `B`, there is an exact global dichotomy.

   **Dominant Fano branch:**
   \[
   Y\to F(X)\text{ is generically finite},
   \qquad q(Y)\ge5,\quad p_g(Y)\ge10,\quad\rho(Y)\ge25.
   \]

   **Ruled curve branch:**
   \[
   Y\sim_{\rm bir}\mathbf P(T_{F(X)})|_{\Sigma^\nu},
   \quad [\Sigma]=nC,
   \quad d=5n+1,
   \quad n\ge2,
   \quad g(\Sigma^\nu)\ge26.
   \]
   In this branch every involution carrier is nonfixed and paired.
7. The residual `S3` representation on the fixed genus-four curve is
   \[
   H^0(R_t,\Omega^1)
   \simeq\mathbf1\oplus\operatorname{sgn}\oplus\operatorname{std}.
   \]
   Its 55-curve orbit carries two copies of the five-dimensional Weil module.
   The orbit of the original fixed elliptics carries none.

## Why this is new

The degree-one branch previously stopped at an unspecified section of the
six-line incidence cover and an uncomputed exceptional base surface.  It now
has:

- a canonical normalized-Rees ideal derived from the actual landing tuple;
- an exact fixed target curve and source-degree theorem;
- a correction separating the genus-two and genus-four Fano components;
- a complete classification of the one-dimensional line-image escape;
- and an explicit Hodge representation carried by the resulting boundary.

## Exact remaining branch

The retraction is not yet excluded.  The remaining object is much narrower:

> a `G`-invariant Cartier divisor `B sim (d-1)H` which is singular in
> codimension one along all 55 elliptics and whose normalized Pluecker graph is
> either generically finite over the Klein Fano surface or the universal ruled
> surface over a faithful curve `Sigma in |nC|` with `d=5n+1`.

The next theorem is the conductor/Hurwitz compatibility of this singular base
with its normalized line graph.  In the ruled branch, the next target is to
exclude the paired, nonfixed involution carriers.  In the dominant branch, the
next target is the exact normalization conductor formula against the 55
classes `R_t=C-D_t`.

## Nonclaims

This packet does not prove

```text
DELTA1-RETRACTION-EXCLUDED
NO-DOMINANT-G-AMBIENT-LANDING-MAP
KLEIN-PSL2(11)-NONUNIRATIONAL
```

## Replay

```text
python3 verify_fano_retraction_carrier.py
```

Terminal marker:

```text
RETRACTION_FANO_CARRIER_VERIFY_OK
```
