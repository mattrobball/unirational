# Retraction Fano--Rees carrier: status

**Date:** 2026-08-09  
**Problem:** Klein cubic / `PSL2(F11)`  
**Exit:** `DELTA1-IRREDUCIBLE-BASE-DOMINATES-FANO-SURFACE`  
**Headline:** Problem E remains **OPEN**.

## Executive theorem

Assume that a primitive ambient landing tuple is a rational `G`-retraction:

\[
T=Hx+FQ,
\qquad F(T)=0,
\qquad [T]|_X=\operatorname{id}_X,
\]

and put `B=V_X(H)`.  The tuple determines the gauge-independent Pluecker ideal

\[
J_{\rm line}
=\left(\frac{x_iT_j-x_jT_i}{F}\right)\mathcal O_B
=(x_iQ_j-x_jQ_i)\mathcal O_B.
\]

Its normalized Rees algebra is the canonical graph of the actual line-selection
map `B -->> F(X)`.

The packet proves:

1. For every involution `t`, the mixed fixed lines form a smooth connected
   genus-four curve
   \[
   R_t=\{(x,y)\in E_t\times L_t:\Phi(x,y,y)=0\}.
   \]
   Its degrees over `E_t` and `L_t` are two and three.  It is the residual
   genus-four component in Roulleau's decomposition `C_{L_t}=D_t+R_t`, not the
   genus-two component `D_t`.
2. The retraction base is singular along all 55 elliptics `E_t`.
3. A normalized carrier above `E_t` is either fixed by `t` or paired with a
   distinct conjugate.  A fixed carrier is a finite cover of `R_t`; if its
   source degree is `2k`, its genus is at least `3k+1`.
4. No carrier above `E_t` has source degree one.  Such a component would give
   a rational or elliptic curve on the Klein Fano surface, which has neither.
5. If `B` is irreducible, the Pluecker line map cannot collapse identically.
6. The apparent one-dimensional-image escape is completely excluded.  A ruled
   image curve would have class `[Sigma]=nC`, coordinate degree `d=5n+1`, and
   `n>=2`.  Because every line in that family must meet every `E_t`, it is a
   component of
   \[
   M_t=\{\ell:\ell\cap E_t\ne\varnothing\},
   \qquad [M_t]=K_{F(X)}=3C.
   \]
   Hence `n<=3`, so `(n,d)` is `(2,11)` or `(3,16)`.  The durable exact
   self-covariant certificates exclude all landing tuples through degree 24.
7. Therefore, for every hypothetical retraction with irreducible base, the
   normalized Pluecker graph satisfies
   \[
   \boxed{Y\longrightarrow F(X)\text{ dominant and generically finite}.}
   \]
   Consequently
   \[
   q(Y)\ge5,\qquad p_g(Y)\ge10,\qquad\rho(Y)\ge25.
   \]
8. The residual `S3` representation on the fixed genus-four curve is
   \[
   H^0(R_t,\Omega^1)
   \simeq\mathbf1\oplus\operatorname{sgn}\oplus\operatorname{std}.
   \]
   Its 55-curve orbit carries two copies of the five-dimensional Weil module;
   the orbit of the original fixed elliptics carries none.

## Exact new exits

```text
DELTA1-CANONICAL-PLUECKER-REES-GRAPH
DELTA1-BASE-SINGULAR-ALONG-ALL-55-ELLIPTICS
DELTA1-FIXED-FANO-GENUS4-CURVES
DELTA1-NO-DEGREE-ONE-ELLIPTIC-CARRIER
DELTA1-IRREDUCIBLE-BASE-RULED-BRANCH-EXCLUDED
DELTA1-IRREDUCIBLE-BASE-DOMINATES-FANO-SURFACE
```

## Remaining branch

The retraction itself is not yet excluded.  The remaining alternatives are:

- **irreducible base:** a `G`-invariant Cartier divisor singular along all 55
  elliptics whose normalized Pluecker graph is generically finite over the
  Klein Fano surface;
- **reducible base:** component orbits may distribute the 55 elliptics, and
  individual components may be fixed components of the Pluecker system.

The smallest next theorem is the conductor/Hurwitz formula for the dominant
normalized graph.  In the reducible case one first needs an orbitwise
normalization and component-incidence theorem.

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
