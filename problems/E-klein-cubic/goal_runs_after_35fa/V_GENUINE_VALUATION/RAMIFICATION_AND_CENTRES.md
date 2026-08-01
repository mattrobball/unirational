# Exact ramification and centres at infinity

Let `nu` denote the selected valuation of `K=K_proj` over the irreducible
divisor `D` of `F`, normalized by `nu(D)=1`.  The reciprocal root satisfies
`s=1/u` with `nu(s)=1`, hence

```text
nu(u)=-1.
```

## Cramer calculation

The accepted three linear relations have rows

```text
a_i+b_i*vcoord+c_i*t=0.
```

Using rows zero and one gives

```text
Delta = b0*c1-b1*c0,
N_v   = -a0*c1+a1*c0,
N_t   = -b0*a1+b1*a0,
vcoord=N_v/Delta,
t     =N_t/Delta.
```

At the exact normalization point

```text
(r,rho,T)=(0,1,0),
(A,B,Y,Z)=(33/2,-1/200,-1349/600,1331/8),
```

the independent sparse replay obtains

```text
deg_u(Delta)=5,
deg_u(N_v)=5,
deg_u(N_t)=3.
```

All three leading coefficients are nonzero.  The matrix bounds the first two
degrees by five.  Although a naive product could give degree four for `N_t`,
the verifier reconstructs its `u^4` coefficient as the zero polynomial over
`Q[A,B,Y,Z]`.  The displayed witness therefore certifies the generic degrees
on `D`, not only a fortuitous numerical cancellation.  Since `u` has value
`-1`,

```text
nu(vcoord)=5-5=0,
nu(t)=5-3=2.
```

## Ramification in the residual-scalar affine cover

The accepted scaled affine frame field is

```text
K_aff=K(f5),  f5^3=t,  [K_aff:K]=3.
```

Let `w` prolong `nu` to `K_aff`.  Since `nu(t)=2` is prime to three,
`X^3-t` has one Newton edge of slope `2/3`; it is irreducible and totally
ramified, so

```text
e(K_aff/K)=3,  f(K_aff/K)=1.
```

Normalizing `w|K=3*nu` gives

```text
(w(f5),w(f8),w(f10))=(2,-1,-2).
```

This is the geometric trace of the residual scalar needed to impose
`f3=1`.  It is **not** genuine torsor ramification.

## Separation from the genuine splitting field

Let `L=C(P(W))`.  Then `L/K` is Galois with group
`G=PSL_2(F_11)`, while `K_aff/K` is the separate scalar `mu3` extension.
Their intersection is `K`.  Otherwise `L` would contain a degree-three
intermediate field, hence `G` would have an index-three subgroup.  The coset
action would give a nontrivial homomorphism from the nonabelian simple group
`G` to `S3`, impossible.

Consequently the Cramer valuation does not compute inertia in `L/K`.  Let
`I_G` denote that actual inertia.  The exact alternatives are

```text
I_G != 1: the genuine twist has a henselian point;
I_G  = 1: the special fibre is the genuine residue twist,
           has index 1, and its point status is open.
```

The first line is the central-inertia theorem.  In the second line the
torsor extends etale, and the universal effective cycles on every Klein
twist have degrees `60,132,165,220` with gcd one.

## Centre ledger

| Model | Centre selected by the data | Point/index consequence |
|---|---|---|
| coefficient compactification of `K/F` | `D=0, u=infinity` | selected point-field place has `(1,1)` |
| residual-scalar affine cover | weighted ray `(2,-1,-2)` | totally ramified `mu3`, `(e,f)=(3,1)` |
| genuine projective splitting torsor | no inertia computation follows from the scalar cover | `I_G!=1` is locally soluble; `I_G=1` leaves the genuine residue point problem |
| selected proper fixed plane cubic | normalized net `C0+rho*Crho+T*CT` | smooth, index `3`, no residue point |
| proper closure of full auxiliary cubic | specialization of an accepted auxiliary `K`-point | residue point, hence index `1` |
| genuine Klein twist | not the fixed plane centre | residual index `1`; point in the ramified case, open in the unramified case |
| `F14_T` | none selected on its function field | fixed-frame valuation supplies no residual-index conclusion |

The auxiliary index-one row uses a point plus properness.  The genuine
index-one row uses the universal cycle calculation; index one alone does not
imply a point.  An actual genuine point is supplied only in the
`I_G!=1` branch, not by the scalar `mu3` calculation.
