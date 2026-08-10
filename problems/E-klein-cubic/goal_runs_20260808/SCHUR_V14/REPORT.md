# SCHUR_V14 audit report

Status: **OPEN / UNFULFILLED**.  No common isotropic two-plane and no
pointlessness theorem was obtained.

The exact new result is the all-degree forced-base/first-jet reduction in
`THEOREM.md`:

1. every spin-source map `P(U) ---> V14` has all 66 `C5`-fixed source
   lines in its indeterminacy;
2. these lines are the `K12` secants on the 12 `C11:C5` vertices;
3. the first nonzero jet at any vertex is a projectively equivariant map
   from the standard monomial `C11:C5` source `P4` to `V14`;
4. hence a global spin map forces a point on the sealed genuine `11:5`
   trace cubic.

Exact two-prime fixed-normalizer audits give:

```text
prime                              881       1321
|G| / |2.G|                       660/1320  660/1320
C5 source eigenspace dimensions  2,1,1,1,1 2,1,1,1,1
C5-line stabilizer / orbit        10/66     10/66
C5 target fixed points            4         4
D10 fixed binary-quadric rank     3/3       3/3
C11 target points, F55 orbits     5, [5]    5, [5]
vertex orbit / line graph         12, K12   12, K12
```

The binary-quadric rank `3/3`, rather than absence of finite-field points,
proves geometric `V14^D10` emptiness in the good fibre; projective
specialization gives the characteristic-zero statement.  Nonzero
restricted equations on every `C5` character `P1` prove geometric
finiteness of `V14^C5`.

The packet also independently checks characteristic-zero multiplicities by
CRT at `23,67,89,199`:

```text
d                         0 1 2 3 4 5 6 7  8 9 10
dim Hom(Sym^d U,M)        0 0 0 0 3 0 6 0 22 0 42
forced-line kernel, d=4,6,8,10       0,3,15,35
Pluecker coefficient rank/dimension  0/0,6/6,120/120,630/630
```

This last table is bounded corroboration only.  The negative theorem is
equivalent to the still-open `11:5` trace intersection

```text
r2^(-1) psi(E*) cap ker(Tr_E/K),   psi(a)=a^2 sigma(a).
```

The corrected sections 8.28--8.30 of `theory/FIX_IX_v14.md` supersede the
earlier proposed fan obstruction: its necessary polytope shadow is
feasible, and the attempted Brauer repair is invalid.  No extrapolation
from the bounded tables or the nontrivial order-11 class is legitimate.

