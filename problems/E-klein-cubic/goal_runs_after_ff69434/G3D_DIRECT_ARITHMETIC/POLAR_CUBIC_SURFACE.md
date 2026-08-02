# G3D.1A — canonical second-polar cubic surface

## Setup

Ambient point q = [1:0:0:0:0], Phi(q) = t3 != 0. Second-polar hyperplane ell_q(a) = t3 a0 + (t6/3) a1 + (b7/3) a2 + (t8/3) a3 + (b9/3) a4 with b7=f7, b9=f9. Elimination on t3 != 0:

a0 = -(t6 y1 + b7 y2 + t8 y3 + b9 y4)/(3 t3).

## Surface equation

G_q(y) := Phi(a(y)) is a single K-valued cubic form, stored as **11** nonzero secondary components over P0[y1,y2,y3,y4].

- ell_q vanishes after elimination: **True**
- Re-embedding secondary-0 checks: **True**
- Smooth point on specialized secondary-0 slice: **False**

## Singular locus

No K-rational singular point certified. Specialized singular points on the secondary-0 slice (if any) are discovery data only.

## Marker

```text
G3D-POLAR-CUBIC-SURFACE-PASS
```

Wall time: 16.923 s.
