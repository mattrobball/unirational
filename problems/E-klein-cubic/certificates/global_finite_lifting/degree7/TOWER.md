# Degree-7 finite global lifting tower

**Headline: OPEN.**  
**Exit: `G7-OBSTRUCTION`.**  
**Bidegree: (m,d)=(1,7).**  
**Gate G1: PASS** (finite truncation at normal order 21).

## 1. Finite terminal system

By G1, landing F(p)=0 for a degree-7 polynomial map is equivalent to the vanishing of all normal components of F(p) through order 3d=21. Odd orders are automatic under involution covariance. Nonautomatic even orders: [4, 6, 8, 10, 12, 14, 16, 18, 20].

## 2. Polynomial jet dimensions (C2 parity, multi-Rees)

| order | target | free fibre | multi-Rees dim |
|------:|--------|----------:|---------------:|
| 1 | E_minus | 4 | 112 |
| 2 | E_plus | 9 | 189 |
| 3 | E_minus | 8 | 120 |
| 4 | E_plus | 15 | 150 |
| 5 | E_minus | 12 | 72 |
| 6 | E_plus | 21 | 63 |
| 7 | E_minus | 16 | 16 |

Total multi-Rees dimension (single involution, C2 parity): **722**.

## 3. Isolation stages vs polynomial degree

| F-order | type | formal newest E+ | within d? |
|--------:|------|-----------------:|-----------|
| 4 | isolate_Eplus | 2 | True |
| 6 | isolate_Eplus | 4 | True |
| 8 | isolate_Eplus | 6 | True |
| 10 | mixed_residual | 8 | False |
| 12 | mixed_residual | 10 | False |
| 14 | mixed_residual | 12 | False |
| 16 | mixed_residual | 14 | False |
| 18 | mixed_residual | 16 | False |
| 20 | mixed_residual | 18 | False |

**Last isolable E+ F-order:** 8.  
**First stage without E+ polynomial isolator:** 10.

## 4. G4 global correction architecture

Every nonautomatic stage is presented as

```text
plane normalization -> triple-line equalizer -> residual point kernel
```

Local free-module surjectivity of L_r (ranks certified over Q at a_triv / pure powers for r=1,3,5) is **not** promoted to global solvability. The accepted based residual equalizer at leading order has dimension 10; irrelevant torsion, source-line coupling, marked elliptic data, and the repaired three-copy category are retained as constraints.

## 5. Free-fibre terminal residual (exact)

Sample `based_zero` on residual-trivial free fibre a_triv=(0,1,1,0), based coupling a3=a5=a7=0, particular solutions b2=b4=b6=0:

- Early F-orders 4,6,8 vanish.
- First nonzero terminal residual at F-order **None** (expected: pure E- free fibre has F=0 by triple-E- vanishing; not a G-covariant).

Sample `ker_L1` with nontrivial ker L1:

- Early orders 4,6,8 solved exactly over Q (residual 0).
- First nonzero terminal residual at F-order **10** (norm^2 = 1296).

## 6. Reconciliation with degree-7 exclusion

The space of degree-7 self-covariants is 4-dimensional (K, FC, F^2 x, J x). Accepted landing exclusion (modular scan + exact four-point Groebner) shows the projective base locus is empty. Septic script pass: **True**.

Tower exit `G7-OBSTRUCTION` **agrees** with the exclusion. No candidate appears.

## 7. Why formal smoothness does not produce a degree-7 covariant

1. Formal smoothness on the free open U yields **power series** in the normal variable, of unbounded order.
2. Degree 7 truncates jets at order <=7; the last E+ isolator is b6 at F-order 8.
3. From F-order 10 the free isolator needs order >=8 — unavailable as a polynomial correction.
4. Based coupling kills a7. Residual equations at orders 10..20 remain.
5. Full G-equivariance collapses to a 4-dimensional space already excluded.

## 8. Boundary

| Proved | Not proved |
|--------|------------|
| G1 finite truncation | All-degree periodic obstruction |
| Complete stage ledger at (1,7) | Degrees 13 and 19 towers (G3) |
| Free L1,L3,L5 ranks on samples | Closed Fitting of every multi-Rees residual |
| Exact free-fibre residual at F-order 10 on ker L1 | Full multi-Rees equalizer elimination |
| Consistency with degree-7 exclusion | Existence in higher degree |

**Headline remains OPEN.**
