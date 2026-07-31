# Degree-13 finite global lifting tower

**Headline: OPEN.**  
**Exit: `G13-SAMPLE-RESIDUAL`.**  
**Historical package label (computation record): `G13-OBSTRUCTION`** — retained in
JSON/`exit.json` as a sealed sample ledger; **not** a degree-wide obstruction theorem
(`REPAIR.md` §§11–12).  
**Bidegree: (m,d)=(1,13).**  
**d − 6m = 7.**  
**Gate G1: PASS** (finite truncation at normal order 39).

## 1. Finite terminal system

By G1, landing F(p)=0 for a degree-13 polynomial map is equivalent to vanishing of all normal components of F(p) through order 3d=39. Nonautomatic even orders with live triples: [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38].

## 2. Polynomial jet dimensions

| order | target | free fibre | multi-Rees dim |
|------:|--------|----------:|---------------:|
| 1 | E_minus | 4 | 364 |
| 2 | E_plus | 9 | 702 |
| 3 | E_minus | 8 | 528 |
| 4 | E_plus | 15 | 825 |
| 5 | E_minus | 12 | 540 |
| 6 | E_plus | 21 | 756 |
| 7 | E_minus | 16 | 448 |
| 8 | E_plus | 27 | 567 |
| 9 | E_minus | 20 | 300 |
| 10 | E_plus | 33 | 330 |
| 11 | E_minus | 24 | 144 |
| 12 | E_plus | 39 | 117 |
| 13 | E_minus | 28 | 28 |

Total multi-Rees dimension: **5649**.

## 3. Isolation stages vs polynomial degree

| F-order | type | formal newest E+ | within d? |
|--------:|------|-----------------:|-----------|
| 4 | isolate_Eplus | 2 | True |
| 6 | isolate_Eplus | 4 | True |
| 8 | isolate_Eplus | 6 | True |
| 10 | isolate_Eplus | 8 | True |
| 12 | isolate_Eplus | 10 | True |
| 14 | isolate_Eplus | 12 | True |
| 16 | mixed_residual | 14 | False |
| 18 | mixed_residual | 16 | False |
| 20 | mixed_residual | 18 | False |
| 22 | mixed_residual | 20 | False |
| 24 | mixed_residual | 22 | False |
| 26 | mixed_residual | 24 | False |
| 28 | mixed_residual | 26 | False |
| 30 | mixed_residual | 28 | False |
| 32 | mixed_residual | 30 | False |
| 34 | mixed_residual | 32 | False |
| 36 | mixed_residual | 34 | False |
| 38 | mixed_residual | 36 | False |

**Last isolable E+ F-order:** 14.  
**First stage without E+ polynomial isolator:** 16.

## 4. G4 global correction architecture

Every nonautomatic stage is presented as

```text
plane normalization -> triple-line equalizer -> residual point kernel
```

Local free-module surjectivity is **not** promoted to global solvability.

## 5. Free-fibre terminal residual (exact)

Leading sample `residual_S3_trivial_a_triv`.

Sample `based_zero`: first nonzero terminal residual at F-order **None**.

Sample `ker_L1`: early isolable orders solved; first nonzero residual at F-order **16** (norm^2 = 156816).

Residual C3 weights at first nonzero sample residual: **[0]** (support size 1).

## 6. Invariants recorded for G3 pattern

| invariant | value |
|-----------|------:|
| m | 1 |
| d | 13 |
| d mod 6 | 1 |
| d − 6m | 7 |
| first non-isolable F-order | 16 |
| first nonzero free-fibre residual (ker L1) | 16 |
| residual norm^2 | 156816 |
| residual S3-type (leading) | residual_S3_trivial_a_triv |
| source-line ledger (samples) | based a_odd=0 |

## 7. Theorem boundary (`REPAIR.md` §§11–12)

A nonzero free-fibre residual on a selected `ker_L1` sample is **not** an
obstruction theorem for all degree-13 maps.  The same packet records a
`based_zero` sample with vanishing residual, so the free-fibre residual map
already has zeros.  The decisive object remains \(\Theta^{-1}(0)\) with all
global equalizers and coefficient couplings imposed.

**P25.1 confirmation.**  At \((m,d)=(1,25)\), the particular terminal residual
is again nonzero on sample directions, yet later high-order kernel freedom
(rank 27 into a 29-dimensional residual codomain) cancels it and both live
free-fibre families survive (`certificates/degree25_tower/TOWER.md`, exit
`P25-TOWER-SURVIVES`).  Terminal nonzero sample values are therefore not
evidence of an empty global zero locus.

| Proved | Not proved |
|--------|------------|
| Complete free-fibre tower at (1,13) | Degree-wide emptiness of \(\Theta^{-1}(0)\) |
| Exact residual on ker-L1 sample | All-degree periodic obstruction |
| Isolation cutoff \(N_\star=d+2m+1\) | Full multi-Rees equalizer elimination |
| G4 architecture at every stage | G-global Molien landing for d=13 |

**Retained:** finite truncation (G1), isolation cutoff \(N_\star=d+2m+1\), exact
sample residual data.  
**Headline remains OPEN. Exit `G13-SAMPLE-RESIDUAL` only.**
