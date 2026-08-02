# The degree-eleven rational-normal-quartic incidence

## Verdict

`Q-UNDECIDED`.  A rational normal quartic through the degree-eleven
`A5` point would give a `K`-point on the Schur twist, and the condition has
an explicit finite determinantal presentation.  Its geometric locus is
large (dimension `21`), but neither its rationality nor a `K`-point follows
from the extension `L/K` or from the known `A5` point.

Moreover, the six installed constant degree-eleven `A5` landing maps have
already been excluded by the sealed computation in
`../degree11_secant_descent_agent/`: their eleven-point orbits have quadric
evaluation rank `11`, whereas an orbit on a rational normal quartic has rank
at most `9`.  The equations below are the remaining all-point incidence
problem, not a reopening of those six cases.

## 1. The residual-point theorem

Let `E/K` be the generic Schur `G`-torsor,

```text
G = PSL(2,F_11),  H = A5,  L = E^H,  [L:K] = 11,
```

and let `X/K` be the full twist.  The exact `A5` map gives a point
`P in X(L)`.  If it is already `K`-rational there is nothing to prove, so
assume that its conjugates form a reduced degree-eleven point `Z_11`.

Suppose a `K`-defined geometrically rational normal quartic

```text
C subset P4_K
```

contains `Z_11` and is not contained in `X`.  Bezout gives
`length(C cap X)=4*3=12`.  Every one of the eleven conjugate intersection
multiplicities is equal.  It cannot be at least two, since that would give
intersection length at least `22`.  Hence `Z_11` occurs with multiplicity
one and the residual intersection has length one.  It is Galois invariant,
so it is a `K`-point of `X`.

There is no hidden nonsplit-conic issue.  The degree-eleven point is an
odd-degree zero-cycle on the genus-zero curve `C`.  The index of a genus-zero
curve divides two, hence it divides both `2` and `11`; therefore `C(K)` is
nonempty and `C` is a split rational normal quartic.

## 2. Seven-point chart and exact remaining equations

Work over `E` and label the eleven conjugates by column vectors

```text
z0,...,z10 in P4(E).
```

On the open chart where the first seven are in the required linear general
position, put

```text
A = [z0 z1 z2 z3 z4],
a = A^(-1) z5,
D = diag(a0^(-1),...,a4^(-1)),
v = D A^(-1) z6.
```

The chart conditions are

```text
det(A) != 0,  product(ai) != 0,
product(vi) * product_{i<j}(vi-vj) != 0.
```

After the coordinate change `y=D A^(-1)z`, the first five points are the
coordinate points, the sixth is `(1:1:1:1:1)`, and the seventh is `v`.
The unique rational normal quartic through them is

```text
nu_v([s:t])_i = vi * product_{j != i}(vj*s+t),  i=0,...,4.       (RNC)
```

Indeed it contains `v` at `[0:1]`, `(1:...:1)` at `[1:0]`, and the
`i`-th coordinate point at `[-1/vi:1]`.

For `k=7,8,9,10`, set

```text
w^(k) = D A^(-1) z_k
```

and form the `5 x 3` matrix whose `i`-th row is

```text
(vi*w_i^(k), -vi, w_i^(k)).                                  (M_k)
```

Then the exact remaining equations are

```text
rank(M_k) <= 2,  k=7,8,9,10,                                 (E_k)
```

equivalently all `3 x 3` minors of each `M_k` vanish.  To see sufficiency,
a kernel vector `[s:lambda:t]` gives

```text
w_i^(k) * (vi*s+t) = lambda*vi,
```

which is precisely the rational form of `(RNC)`; the cases `t=0` and a
vanishing factor recover the sixth and coordinate points.  Each `(E_k)` is
a codimension-three membership condition.  Clearing
`det(A)*product(ai)` gives homogeneous polynomial equations in the original
eleven points.  This is a finite, Magma-free system.

If these equations hold, the curve is automatically defined over `K`:
every Galois conjugate of it contains the same eleven-point orbit, and two
rational normal quartics containing the seven general anchor points are
equal.  Thus geometric incidence on this chart already supplies descent;
the unresolved issue is existence of a point on the descended incidence
locus.

## 3. Dimension and rationality boundary

Over an algebraic closure,

```text
Res_{L/K}(X_L) = X^11,  dim = 33.
```

The four conditions `(E_k)` have total expected codimension `4*3=12`, so
the RNC incidence locus has dimension `21`.  This count is exact on the
transverse open.  Projection to the first seven points has a transparent
generic fibre: seven general points of `X` determine their unique quartic,
and its degree-twelve intersection with `X` leaves five distinct residual
points.  Assigning the last four labels to four of those five points gives

```text
5*4*3*2 = 120
```

possibilities.  Hence the incidence locus is generically finite of degree
`120` over an open subset of `X^7`, and every component has dimension `21`.

This proves geometric nonemptiness.  It does **not** prove rationality:
a degree-`120` finite cover of `X^7` is not made rational by that
description.  Nor does it produce a `K`-point on the corresponding twist.
The fact that `K` has transcendence degree five over `C`, and the odd degree
of `L/K`, provide no applicable theorem forcing a point on this
determinantal incidence variety.  Odd degree only splits the genus-zero
curve *after* the curve has been found.

## 4. Computationally actionable form

For an explicit `L`-point formula, enumerate the eleven cosets `G/H`, form
the conjugate columns `z_i`, and evaluate the four rank conditions above.
This is stronger than the necessary quadric-rank screen: it reconstructs the
unique candidate curve and is sufficient on the stated chart.

A finite-field discovery should therefore:

1. vary the free source section in the exact `A5` map;
2. reject charts where the displayed open factors vanish;
3. compute `A^(-1)`, `D`, `v`, and the four matrices `M_k`;
4. retain only simultaneous rank-at-most-two solutions;
5. lift a survivor to characteristic zero and verify the cleared minors as
   rational-function identities on the generic Schur source;
6. substitute the resulting residual point in the original twisted cubic.

A rank drop at one finite-field source specialization is discovery evidence
only.  A valid point construction needs the identities to hold at the
generic source.  Conversely, one good specialization of rank `11` in the
fifteen-column quadric evaluation matrix rigorously excludes a proposed
generic orbit; this is how the existing six constant maps were closed.

```text
Q_SCHUR_A5_DEGREE11_RNC_INCIDENCE_EXACT
```
