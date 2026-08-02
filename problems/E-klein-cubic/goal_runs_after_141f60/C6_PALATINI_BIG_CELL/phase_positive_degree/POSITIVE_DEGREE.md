# C6 positive-degree / rational-function Morita residual

**Marker:** `C6-POSITIVE-DEGREE-RESIDUAL`

**Not a headline claim.**  No `K_proj`-point of F_{14,T} and no `C6-POINT-HEADLINE-POSITIVE`.

## Context

After `C6-MORITA-DESCENT-OBSTRUCTION`, constant common lines of the twelve sealed u in D(Q) fail twisted Pluecker G-equivariance ((wedge^2 V)^G=0).  This phase searches **non-constant** sections.

## Interface

- u in P^5 on the fibre-independent determinantal quartic D=V(Q);
- secondary basis of K_proj over P0=Q(t3,t6,t8,t11):

```text
1, f7, f9, f10, f12, f14, f7^2, f7*f9, f9^2, f9*f10, f7^3, f9^2*f10
```

- Morita twelve-word module as in C5 `DESCENT_COMPATIBLE_ANSATZ_AUDIT`.

## Fibre-independence of D

At good primes the normalized quartic Q_x / Q_x(e0) is independent of the tested rational x-fibres; sealed constant points of D lie on every tested fibre.  Thus D subset P^5 is a fixed hypersurface for the relative determinantal model on the tested open.

Exact multi-fibre minors for a sealed point: OK.  Modular multi-fibre for all twelve: OK.

## Ansatz bounds and results

| Family | Bound | Result |
|--------|-------|--------|
| `homogeneous_linear_u_equals_A_x` | deg 1, 12000 random in M_6x5(F_23) | no survivor in random trials |
| `affine_u_equals_A_x_plus_b` | deg 1 affine, 12000 random | no nonconstant survivor in random trials |
| `diagonal_quadratic_plus_affine` | diag deg 2, 8000 random | no survivor in random trials |
| `rational_degree_1_over_1` | rational 1/1, 6000 random | no nonconstant survivor in random trials |
| `lines_on_D_through_sealed_height_le_H` | dir height <=2 exhaustive + h3 sample, multi-prime | no multi-prime line of exhaustive height ≤ 2 (plus height-3 sample) through sealed points |
| `secondary_sparse_constant_vectors` | secondary support <=2, constant vectors | no new nonconstant secondary-sparse section within support ≤2 beyond the line/constant residual already recorded |
| `morita_twelve_word_linear_coefficients` | deg-1 coeffs on 12 words, multi-fibre F_23 | no nonconstant linear-coefficient twelve-word survivor on the 8-fibre screen in 4000 trials |
| `constant_section_equivariance_refresh` | - |  |

### Retained C5 exclusions

- **homogeneous_fano_covariants:** excluded through degree 16 (C5 DEGREE16_FANO_EXCLUSION)
- **short_morita_words:** 341 words length ≤4 and two-word scalars excluded over F_23
- **constant_twelve_word:** Sym^2 rank 78 over F_23 (no nonzero constant c)
- **degree17_sparse_support_le4:** all supports size ≤4 excluded over F_23

## Residual gates

1. Constant-split-line Morita descent remains blocked (Gal orbit 2, (∧²V)^G=0)
2. No linear / affine / diagonal-quadratic / rational(1/1) polynomial section of D found in the stated random-trial bounds over F_23
3. No multi-prime line on D through sealed Q-points at exhaustive direction height <=2 (plus height-3 random sample)
4. Secondary support<=2 reduces to constants/lines already residual
5. Morita twelve-word with degree-1 F_23 coefficients: no survivor on the multi-fibre screen in the stated trials
6. C5 exclusions retained through degree-16 homogeneous Fano covariants and short/constant Morita words
7. Not claimed: emptiness of all of D(K_proj) or of all positive-degree sections

## Resources

- wall ≈ 63.18 s
- peak RSS ≈ 63.6 MB
- GB / msolve: **not invoked**

## Markers

```text
C6-POSITIVE-DEGREE-RESIDUAL
C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS   # primary packet exit unchanged
C6-MORITA-DESCENT-OBSTRUCTION           # retained
C6-EXACT-SPLIT-POINTS-PASS              # retained
```

Headline remains **OPEN**.

