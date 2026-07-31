# Degree-19 finite global lifting tower

**Headline: OPEN.**  
**Exit: `G19-OBSTRUCTION`.**  
**Bidegree: (m,d)=(3,19).**  
**d − 6m = 1.**  
**Gate G1: PASS** (finite truncation at normal order 57).

## 1. Finite terminal system

By G1, landing F(p)=0 for a degree-19 map is equivalent to vanishing through order 3d=57. Nonautomatic live orders: [10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56].

## 2. Polynomial jet dimensions

| order | target | free fibre | multi-Rees dim |
|------:|--------|----------:|---------------:|
| 3 | E_minus | 8 | 1224 |
| 4 | E_plus | 15 | 2040 |
| 5 | E_minus | 12 | 1440 |
| 6 | E_plus | 21 | 2205 |
| 7 | E_minus | 16 | 1456 |
| 8 | E_plus | 27 | 2106 |
| 9 | E_minus | 20 | 1320 |
| 10 | E_plus | 33 | 1815 |
| 11 | E_minus | 24 | 1080 |
| 12 | E_plus | 39 | 1404 |
| 13 | E_minus | 28 | 784 |
| 14 | E_plus | 45 | 945 |
| 15 | E_minus | 32 | 480 |
| 16 | E_plus | 51 | 510 |
| 17 | E_minus | 36 | 216 |
| 18 | E_plus | 57 | 171 |
| 19 | E_minus | 40 | 40 |

Total multi-Rees dimension: **19236**.

Resource: free-fibre only; multi-Rees dense equalizer **not** built (see `resource_floor.json`). Exceeded 8GB: **False**.

## 3. Isolation stages vs polynomial degree

| F-order | type | formal newest E+ | within d? |
|--------:|------|-----------------:|-----------|
| 10 | isolate_Eplus | 4 | True |
| 12 | isolate_Eplus | 6 | True |
| 14 | isolate_Eplus | 8 | True |
| 16 | isolate_Eplus | 10 | True |
| 18 | isolate_Eplus | 12 | True |
| 20 | isolate_Eplus | 14 | True |
| 22 | isolate_Eplus | 16 | True |
| 24 | isolate_Eplus | 18 | True |
| 26 | mixed_residual | 20 | False |
| 28 | mixed_residual | 22 | False |
| 30 | mixed_residual | 24 | False |
| 32 | mixed_residual | 26 | False |
| 34 | mixed_residual | 28 | False |
| 36 | mixed_residual | 30 | False |
| 38 | mixed_residual | 32 | False |
| 40 | mixed_residual | 34 | False |
| 42 | mixed_residual | 36 | False |
| 44 | mixed_residual | 38 | False |
| 46 | mixed_residual | 40 | False |
| 48 | mixed_residual | 42 | False |
| 50 | mixed_residual | 44 | False |
| 52 | mixed_residual | 46 | False |
| 54 | mixed_residual | 48 | False |
| 56 | mixed_residual | 50 | False |

**Last isolable E+ F-order:** 24.  
**First stage without E+ polynomial isolator:** 26.

## 4. G4 global correction architecture

Every nonautomatic stage is presented as

```text
plane normalization -> triple-line equalizer -> residual point kernel
```

Local free-module surjectivity is **not** promoted to global solvability.

## 5. Free-fibre terminal residual (exact)

Leading sample `pure_powers_y0m_f0_plus_y1m_f1` (dim 8).

Sample `based_zero`: first nonzero at F-order **None**.

Sample `ker_L1`: first nonzero residual at F-order **26** (norm^2 = 15968016).

Residual C3 weights at first obstruction: **[2]** (support size 1).

## 6. Invariants recorded for G3 pattern

| invariant | value |
|-----------|------:|
| m | 3 |
| d | 19 |
| d mod 6 | 1 |
| d − 6m | 1 |
| first non-isolable F-order | 26 |
| first nonzero free-fibre residual (ker L1) | 26 |
| residual norm^2 | 15968016 |
| residual S3-type (leading) | pure_powers_y0m_f0_plus_y1m_f1 |
| source-line ledger (samples) | based a_odd=0 |

## 7. Boundary

| Proved | Not proved |
|--------|------------|
| Complete free-fibre tower at (3,19) | All-degree periodic obstruction |
| Exact residual on ker-L1 sample | Full multi-Rees equalizer elimination |
| Resource floor documented | G-global Molien landing for d=19 |

**Headline remains OPEN.**
