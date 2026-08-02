# A5Q residual identity: branch is inapplicable after exact emptiness

## Conditional identity

Let `L/K` have degree eleven, let `tau in P^1(L)` have exact degree eleven,
and suppose a `K`-defined degree-four map

```text
phi=(phi_0:...:phi_4):P^1_K -> P^4_K
```

interpolates one of the transported points.  If `g_tau(s,t)` is the monic
homogeneous degree-eleven divisor polynomial of the conjugate orbit of
`tau`, then every conjugate of `tau` is a zero of the degree-twelve binary
form `F(phi(s,t))`.  Separability gives the conditional divisibility

```text
g_tau(s,t) divides F(phi(s,t)).
```

If `F(phi)` is nonzero, the quotient is a degree-one form over `K`; if it is
zero, the image quartic lies on the twist.  This is the conditional A5Q.3
argument, but it starts only after an interpolation map exists.

## Why no division is performed in this packet

For each installed maximal `A_5` class, the five transported point
coordinates span a five-dimensional `K`-space `W_i`.  The exact square-space
dimensions are

```text
dim_K(W_1^2)=11,
dim_K(W_2^2)=11.
```

The criterion in `INTERPOLATION_INCIDENCE.md` proves that any degree-four
interpolation would instead force `dim_K(W_i^2)=9`.  Hence no suitable
`tau`, `lambda`, five binary quartics, or map `phi` exists for either point.
In particular, none of the following objects is defined:

```text
F(phi),
F(phi)/g_tau,
the residual linear form ell,
its K-rational root rho,
phi(rho).
```

The independent verifier therefore reports the residual-division gate as
`NOT_APPLICABLE_EMPTY_INCIDENCE`.  It does not fabricate a zero quotient,
silently skip a failed division, or emit a residual-point marker.

## Exact scope

This disposes of A5Q.3 only for the two exact closed points constructed in
this packet.  It produces neither a residual point nor a rational curve and
does not execute the Schur-versality positive bridge.  The resulting exit is
only

```text
A5Q-DEGREE4-RESCUE-EMPTY-SCOPED.
```
