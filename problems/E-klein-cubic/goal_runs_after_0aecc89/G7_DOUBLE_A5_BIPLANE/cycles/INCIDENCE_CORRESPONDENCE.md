# Incidence correspondence (abstract coset modules)

## Objects

- `L_H = T ×^G (G/H)` — coset basis `e_0,…,e_10` (A5 class 1)
- `L_K = T ×^G (G/K)` — coset basis `f_0,…,f_10` (A5 class 2)

Identify cosets with conjugates: `gH ↔ gHg^{-1}`.

## Map

Derived from G7A Paley biplane incidence (A4 intersections of order 12):

```text
N_*(e_i) = Σ_j N_{ij} f_j
N^*(f_j) = Σ_i N_{ij} e_i
```

with `N` the 11×11 zero-one matrix on the **coset bases** (not a bare matrix
detached from the design). On augmentation modules (`char ≠ 3`):

```text
N^{-1} = (1/3) N^t
```

## Scope

This is an **abstract** correspondence of etale / permutation modules.
Geometric incidence of induced-cycle points requires G7.3 materialization
(currently residual). Direct rebuild from conjugate intersections matches
the transported design matrix.

Machine data: `incidence_correspondence.json`.
