# Exact degree-six field presentation (F0)

Put

```text
F = C(A,B,Y,Z),
t = f5^3,  u = f8/f5,  v = f10*f5
```

on the accepted affine slice `f3=1`.  The generic localization contains

```text
B * (5*A - 81) != 0.
```

The payload `determinant_matrix_cells_exact.tsv` is a `3 x 3` matrix

```text
M(A,B,Y,Z,u) = [a_i(u), b_i(u), c_i(u)]_(i=0,1,2)
```

whose columns correspond, in order, to `(1,v,t)`.  Thus the exact sparse
consequences are

```text
a_i(u) + b_i(u)*v + c_i(u)*t = 0.                 (i=0,1,2)
```

The determinant has a structural factor `u` and an exact parameter content
`C(A,B,Y,Z)`:

```text
det(M) = u * C(A,B,Y,Z) * P(A,B,Y,Z,u).
```

The files in `payload/` contain `M`, `C`, and the primitive sextic `P`.
Their term counts are respectively 6,628, 2,630, and 1,593.  The primitive
has `u`-degree six.  Therefore

```text
K_proj = F[u]/(P).
```

For a selected embedding (the class of `u`), choose rows zero and one and
put

```text
delta = b0*c1 - b1*c0,
v     = (-a0*c1 + a1*c0) / delta,
t     = (-b0*a1 + b1*a0) / delta.
```

The verifier proves `delta` is nonzero generically by exact specialization
at `(A,B,Y,Z)=(1,2,3,4)`, where `P` is irreducible and `gcd(delta,P)=1`.
It then checks all three equations in the quotient.  This records the
residue embedding rather than only an unordered degree-six algebra.

## Scope

This closes the presentation part of F0.  It does not exhibit a point on the
fixed-frame cubic, a conic, or an algebra isomorphism from a conic section.
