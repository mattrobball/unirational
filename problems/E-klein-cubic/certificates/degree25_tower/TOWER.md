# Degree-25 finite Path G tower (P25.1)

**Headline: OPEN.**  

**Exit: `P25-TOWER-SURVIVES`.**  

**Bidegree: (m,d)=(1,25).**  

**N_star = d+2m+1 = 28.**  

**Terminal F-order 3d = 75.**  

**Gate G1: PASS** (finite truncation proved).  

**Not a covariant. Not a headline claim.**

## 1. Finite terminal system

By G1, landing F(p)=0 for a degree-25 polynomial map is equivalent to vanishing of all normal components of F(p) through order 3d=75. Odd orders are automatic under involution covariance. Nonautomatic even orders: [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74].

## 2. Isolation cutoff

Last isolable E+ F-order: **26**.  
First stage without E+ poly isolator: **28** (= d+2m+1).  
Formal newest E+ needed at N_star: **26** (exceeds d=25).

## 3. Free-fibre samples (particular higher sols)

Leading sample `residual_S3_trivial_a_triv`.

- `based_zero`: first nonzero terminal residual at F-order **None**.
- `ker_L1`: first nonzero residual at F-order **28** (norm^2 = 2565625104).

Residual C3 weights at first obstruction: **[0]** (support size 1).

## 4. Zero locus at N_star (exact free state)

### Family `based_minus_lines_odd_m`

- Coefficient coupling: a_odd = 0 (including a_d = 0).
- Particular residual at N_star: **nonzero** on every ker L_1 basis vector.
- High-order E+ ker (r ≥ 13) gives an affine-linear map of **rank 27** into the 29-dimensional residual codomain.
- Zero locus: **NONEMPTY** (cancellable for all 4 ker L_1 basis vectors).
- Killed: **False**.
- Survivor equations: `R_0 + A_high · s = 0` with rank(A_high)=27.

### Family `residual_e_ge7_generic_swap_both`

- Free residual a_d of dimension 52.
- Affine-linear map A_ad of **rank 27** into residual codomain dim 29.
- Zero locus: **NONEMPTY** (cancellable for all 4 ker L_1 basis vectors).
- Killed: **False**.
- Survivor equations: `R_0 + A_ad · a_d = 0` with rank(A_ad)=27.
- Explicit ker-L1[0] particular solution: [{'a_d_index': 1, 'basis_key': ([25, 0], 1), 'coeff': '-25326'}].

## 5. G4 architecture

Every nonautomatic stage is presented as

```text
plane normalization -> triple-line equalizer -> residual point kernel
```

Local free-module surjectivity is **not** promoted to global solvability. Irrelevant torsion, source-line coupling, and the repaired three-copy distinction among source / normal / target P(E_-) are retained.

## 6. Exit classification

**`P25-TOWER-SURVIVES`** — both families have nonempty free-fibre zero loci for the residual at N_star=28. Exact survivor equations are sealed for P25.2. This is **not** P25-POSITIVE, **not** a G-covariant, and **not** an all-degree statement. Headline remains OPEN.

| Proved | Not proved |
|--------|------------|
| Complete free-fibre tower at (1,25) through order 75 | G-global landing covariant |
| N_star=28 isolation cutoff | Full multi-Rees equalizer elimination |
| Exact residual zero loci on free fibre for both families | Projective border support (P25.2+) |
| G4 architecture at every stage | Headline ed_C(G) |

**Headline remains OPEN.**
