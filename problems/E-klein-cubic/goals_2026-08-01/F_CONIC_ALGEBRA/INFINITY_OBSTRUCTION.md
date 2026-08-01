# Exact infinity-divisor obstruction

## Verdict

Let

```text
F = C(A,B,Y,Z),       T = Z - 11*A^2/18,
K_proj = F[u]/(P).
```

The divisor constructed below has a residue-degree-one place of `K_proj`,
but the residual fixed-frame cubic has index three.  Proper specialization
therefore proves

```text
C(K_proj) = empty.
```

By the bidirectional criterion in `CRITERION.md`, the full conic-intersection
criterion is empty.  The terminal scoped exit is

```text
F-CONIC-CRITERION-EMPTY
```

This is a theorem about the auxiliary fixed-frame plane cubic.  The repaired
repository bridge does not identify its pointlessness with pointlessness of
the genuine generic Klein twist, so the Klein headline remains open.

## 1. A degree-one place at `u=infinity`

Write

```text
P = c6*u^6 + c5*u^5 + ... + c0
```

after replacing `Z` by `T+11*A^2/18`.  Direct extraction from the sealed
1,593-term primitive gives

```text
c6 = 38263752 * B^2 * (A-15) * D(A,B,Y,T),
```

where the 18 terms of `D` are recorded in `infinity_obstruction.json`.
The factor `D` is irreducible and occurs once.  To see its geometry, put

```text
p = 100*A + 4*B + 2*T + 12*Y - 1623,
q = 212*B + 106*T + 36*Y + 81,
d = 53*p - q.
```

An invertible linear change of `(A,B,Y,T)` gives the exact identity

```text
6625000*D =
  150*(107219*p^2 + 954*p*q - 9*q^2)
  - 600*Y*(53*p-q)^2
  + (53*p-q)^3.
```

The right side is primitive and linear in `Y`; its `Y`-coefficient and
constant term are coprime because the latter is nonzero at `53*p-q=0`.
Thus `D` is irreducible.  On the dense open `d!=0`, set

```text
r   = p/d,
rho = d.
```

Solving `D=0` gives the birational parameterization

```text
A = 33/2 - 3750*r^2,
Y = 33125*r^2 - 9/4 + rho/600,
B = -5625*r^2 - T/2 + (r/4 - 1/200)*rho.
```

The displayed definitions recover `p=rho*r`, `q=rho*(53*r-1)`, and
`d=rho`, so

```text
C(D) = C(r,rho,T).
```

The exact point `(r,rho,T)=(0,1,0)` gives

```text
(A,B,Y,Z) = (33/2, -1/200, -1349/600, 1331/8),
c5 = 4782969/625000000 != 0.
```

Hence `D` does not divide `c5`.  At the DVR of `F` defined by `D`, the
reciprocal polynomial is

```text
s^6*P(1/s) = c6 + c5*s + ... + c0*s^6.
```

Modulo `D` it has the simple factor `s`.  Hensel factorization therefore
gives a place of `K_proj/F` with

```text
e=1,  f=1,  residue field=C(D)=C(r,rho,T).
```

## 2. The normalized residual net

Over `k=C(r)`, substitution of the parameterization turns the residual
cubic into

```text
C0(r) + rho*Crho(r) + T*CT,
```

where

```text
C0    = F0 + (33/2-3750*r^2)*FA - 5625*r^2*FB
           + (33125*r^2-9/4)*FY,
Crho  = (r/4-1/200)*FB + FY/600,
CT    = -FB/2 + FZ.
```

There is an exact `c in Q(zeta_11)` (stored by its ten power-basis
coordinates in `infinity_obstruction.json`) satisfying

```text
qY(c)=rB(c)=rY(c)=rZ(c)=0.
```

Consequently all three cubics vanish on the degree-three scheme

```text
y = c*w,
G = X^3 + (a0+a2*r^2)*X*w^2 + (b0+b2*r^2)*w^3 = 0,
```

with the four exact cyclotomic coefficients also stored in the payload.
Equivalently,

```text
(C0,Crho,CT) subset (y-c*w,G).
```

At the good split prime `89`, with `zeta_11 -> 2`, an independent exact
Groebner replay gives on `w=1`

```text
(C0,Crho,CT) =
(y-2, X^3+(19*r^2-31)*X+(-26*r^2+14)),
```

and the two charts at `w=0` are empty.  The right side is finite flat of
degree three.  Properness and upper semicontinuity, together with the exact
degree-three subscheme already exhibited, lift equality of the base schemes
to characteristic zero.

This degree-three scheme stays integral after extending the constant field
to `C`.  Indeed write

```text
G = N(X) + r^2*L(X),
N=X^3+a0*X+b0,       L=a2*X+b2.
```

Here `a2!=0` and `N(-b2/a2)!=0`; the latter exact cyclotomic value reduces
to `17 mod 89`.  Thus `-N/L` has a simple pole and is not a square over the
algebraic closure of the constant field.  The equation

```text
r^2 = -N(X)/L(X)
```

is geometrically irreducible, and hence `G` is irreducible in `C(r)[X]`.
The base scheme is one degree-three closed point `B_net` over `k`.

The same good reduction has a smooth member at `(r,rho,T)=(1,0,0)`, so the
generic residual plane cubic is smooth.

## 3. Exact index computation for the net

Let `Lambda=P2_k` parameterize the net and let

```text
X_net = {lambda0*C0 + lambda1*Crho + lambda2*CT = 0}
        subset P2_z x Lambda.
```

This threefold is normal.  Away from `B_net`, projection to `P2_z` is a
`P1`-bundle.  At `B_net`, equality of the base ideal with `(y-c*w,G)` and
separability of `G` show that the three section differentials span the
two-dimensional conormal space.  The singular locus of `X_net` is therefore
finite.  Since a hypersurface is Cohen--Macaulay, Serre's `R1+S2` criterion
gives normality.

Put

```text
U = P2_z - B_net,
V = X_net - (B_net x Lambda).
```

Then `V -> U` is a `P1`-bundle.  Removing a codimension-two closed point
does not change the class group of `P2`, so

```text
Cl(V) = Z*H_z + Z*H_lambda.
```

The class-group localization sequence for the normal `X_net` now shows

```text
Cl(X_net) is generated by H_z, H_lambda,
and E=B_net x Lambda.
```

On the generic cubic over `k(Lambda)=C(r,rho,T)`, these generators have
degrees

```text
deg(H_z)=3,     deg(H_lambda)=0,     deg(E)=3.
```

Every closed point on the generic cubic closes to a horizontal Weil divisor
on `X_net`, so its degree is divisible by three.  A plane line supplies a
degree-three divisor.  Therefore

```text
ind(C over C(D)) = 3,
C(C(D)) = empty.
```

## 4. Specialization and conic emptiness

If `C(K_proj)` contained a point, embed it in the henselian factor belonging
to the simple reciprocal root above.  Properness of the plane cubic model
extends the point across that DVR and reduces it to a `C(D)`-point of the
residual cubic.  Section 3 proves that no such point exists.  Hence

```text
C(K_proj)=empty.
```

The point/conic equivalence in `CRITERION.md` is exhaustive, including the
`w=0` chart.  Thus no nondegenerate `F`-conic has scheme-theoretic
intersection algebra isomorphic to the selected `K_proj`, which proves
`F-CONIC-CRITERION-EMPTY`.

