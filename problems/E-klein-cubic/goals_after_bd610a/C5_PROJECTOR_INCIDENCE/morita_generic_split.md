# Generic Morita split-circuit lane

## Exact outcome

The companion packet `morita_generic_split_dag.json` serializes the generic
`q0=1` Morita equations as an exact invariant trace DAG.  It is deliberately
separate from the existing `morita_generic.*` packet.

Let

- `P` be the exact degree-12 rank-two bivector matrix;
- `Q=Q(x)`, `s=sum_(i<j) Q_ij P_ij`, and `e=-P Q/s`;
- `B_i=Q(V_i(x))` for `V_i=x,C,D,E,K`;
- `d=(e,eae,ebe,eabe)`;
- `q1=sum_(alpha=0)^3 z_alpha d_alpha` and
  `q2=sum_(alpha=0)^3 z_(4+alpha) d_alpha`;
- `w=e+a e q1+b e q2`.

Then, on the packet's recorded open set,

```text
q^* H_i q = Q^-1 w^T B_i w = lambda_i e.
```

Since `e Q^-1=-P/s` and `Tr(e)=2`,

```text
lambda_i = -Tr(P w^T B_i w)/(2s).
```

Hence the five exact numerator equations are

```text
G_i(z)=Tr(P w^T B_i w)=0,   i=x,C,D,E,K.
```

Writing `w=W0+sum_(k=0)^7 z_k W_(k+1)` gives 45 affine monomial
coefficients per form and 225 coefficient roots in total.  These roots avoid
generic corner-coordinate recovery and avoid `Q^-1`.

## Why the roots are in K_proj

For `rho=rho(g)`, the sealed source circuits obey

```text
P(gx)   = rho P(x) rho^T,
B_i(gx) = rho^(-T) B_i(x) rho^(-1),
Q(gx)   = rho^(-T) Q(x) rho^(-1),
W_k(gx) = rho W_k(x) rho^(-1).
```

Therefore

```text
P' (W_l')^T B_i' W_r'
  = rho (P W_l^T B_i W_r) rho^(-1).
```

Taking the trace proves that every one of the 225 coefficients is invariant.
Thus each is an exact element of

```text
K_proj = C(x1,...,x5)^PSL_2(F_11)
```

in the installed ambient embedding.  Failure to lower these elements to one
preferred basis is not a mathematical descent gap.

## Ambient split block

Over `Q(zeta11,t)(x)`, use the deterministic image chart

```text
J=e[:,(0,1)],  pivot rows=(0,1),
rho_D(d)=J[(0,1),:]^-1 (dJ)[(0,1),:].
```

The chart determinants specialize nontrivially at the bound good fibre, so
their exact determinant circuits are not identically zero.  In row-major
matrix-entry coordinates set

```text
u=(y0,y2,y4,y6),   v=(y1,y3,y5,y7).
```

Alternation of `P` and `B_i` kills all `u-u` and `v-v` quadratic terms.
Consequently the five equations have the exact form

```text
A(v) u + c(v)=0,
```

with `A(v)` a `5 x 4` affine-linear matrix and `c(v)` affine-linear.  The DAG
also contains

```text
Delta(v)=det([A(v)|c(v)])
```

and the five `4 x 4` row minors cutting out `rank(A)<=3`; lower rank strata are
defined by the usual smaller minors.

This is a split chart over the ambient splitting field.  It does not assert
that the quaternion algebra `D` splits over `K_proj`.

## Structural ansatz actually tested

Only the ansatz `v=0` in this selected split chart is obstructed.  The bound
specialization gives

```text
rank A(0)=4,
4x4 row minors=[13,10,4,5,10] mod 23,
Delta(0)=det([A(0)|c(0)])=1 mod 23.
```

Thus the exact root `Delta(0)` is not identically zero, and this particular
generic ansatz is inconsistent.  This is not an obstruction to all common
right-D-lines.

## Normal-form boundary

The DAG is executable as a deterministic symbolic trace circuit, and its
modular interpreter checks all roots and changes of coordinates.  It has not
been expanded or lowered into the preferred length-12
`QQ(t3,t6,t8,t11)` presentation.  Such lowering can be done separately by
clearing denominators, solving degreewise against the installed Hironaka
A-basis on an exact unisolvent orbit set, verifying by sparse subtraction, and
reducing secondary products with the installed `12 x 12` table.

This packet claims neither a `K_proj`-rational common line nor a
characteristic-zero obstruction to every line.

## Replay

From this directory:

```text
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 morita_generic_split_build.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 morita_generic_split_verify.py
```

The final verifier marker is

```text
MORITA-GENERIC-SPLIT-DAG-VERIFIED
```

The finite calculation is used only to replay circuit wiring and certify that
the selected generic determinant roots are nonzero; it is not promoted to a
characteristic-zero common line.
