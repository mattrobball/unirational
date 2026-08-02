# Incidence correspondence between the two etale algebras

## Objects

- `L_H = T ×^G (G/H)` — coset basis `e_0,…,e_10` (A5 class 1 / design H or K)
- `L_K = T ×^G (G/K)` — coset basis `f_0,…,f_10` (A5 class 2)

Identify cosets with conjugates: `gH ↔ gHg^{-1}`.

## Map

Derived from G7A Paley biplane incidence (A4 intersections of order 12):

```text
N_*(e_i) = Σ_j N_{ij} f_j
N^*(f_j) = Σ_i N_{ij} e_i
```

with `N` the 11×11 zero-one matrix transported to the **same coset bases**
used for the induced cycles (not a bare constant matrix detached from descent).

On augmentation modules (`char ≠ 3`):

```text
N^{-1} = (1/3) N^t
```

Complementary relation: `N_comp = J − N` (nonincident D5 pairs).

## Descent

`N` is G-equivariant for the joint conjugation action; installed `G` is
`Aut` of the design (G7A). Direct rebuild from conjugate intersections matches
the transported design matrix (`direct_intersection_rebuild_matches: true`).

Machine data: `incidence_correspondence.json`.
