# G7.3 — double induced degree-11 cycles

Both nonconjugate maximal A5 classes yield explicit eleven-point cycles in the
normalized G3 frame (Klein `W ≅ P⁴`):

```text
P = {p_0,…,p_10},   Q = {q_0,…,q_10}
p_i = ρ(g_i)·base,  base = (1:0:0:0:0),  F_Klein(p_i) = 0
```

exactly in `Q(ζ₁₁)`, with coset representatives of the sealed H_A5 base
subgroup for that class. `F_Klein` is the split specialization of `Φ`
(G2 / G3A frame).

## Checks

- all **22** substitutions: `F_Klein = 0` (raw and chart-normalized);
- coset actions `s_perm`, `t_perm` of image order 660 for both classes;
- cycles defined over `K_proj` as Galois-stable unordered 11-sets (degree 11
  finite-etale closed points of `X_gen`);
- H_A5 binding: `point.json` exits `H-A5-CLASS*-RATIONAL-POINT` kept separate;
- every ambient/frame reference agrees with G3A (`P(W)`, Phi→F split).

## Theorem boundary

- Structural materialization of G4 residual coordinates for both classes.
- **Not** a `K_proj`-point of `X_gen` (headline remains OPEN).
- Coordinates are over `Q(ζ₁₁)` on the split model `V(F)≅X`; the abstract
  induced point lives over `L_H/K_proj` and specializes to this Gal-orbit.

Marker: **`G7-INDUCED-DOUBLE-CYCLE-PASS`**
