# Conic / intersection-algebra scheme (Path F, Fork F1-P)

**Headline:** OPEN  
**Fork:** F1-P  
**Companion audit:** `TERMINALITY_AUDIT.md`

---

## 1. Data

Over

```text
F = C(A, B, Y, Z),
```

the accepted fixed-frame cubic is the generic member of the basepoint-free
five-form system

```text
c = F0 + A FA + B FB + Y FY + (Z + κ A²) FZ = 0,
κ = −11/18,
```

with five linearly independent constant ternary cubics
`F0,FA,FB,FY,FZ ∈ H⁰(P², O(3))` defined over `Q(ζ₁₁) ⊂ C`. Serialized
coordinates: `conic_algebra_inputs.json`.

The extension `K_proj/F` has degree 6, arithmetic monodromy `S_6`, geometric
monodromy `S_6`, and **no proper intermediate fields** (accepted degree and
branch-line packets).

Also accepted:

```text
C(F) = ∅,   Pic⁰(C)(F) = 0,   ind(C/F) = 3.
```

---

## 2. Scheme `S ⊂ P⁵ × GL₆` (affine chart)

### Variables

1. Conic coordinates `[a₂₀ : a₁₁ : a₁₀ : a₀₂ : a₀₁ : a₀₀] ∈ P⁵`.
2. Matrix `M = (m_{ij})_{0≤i,j≤5}` with `det M ≠ 0`.

### Conic form

```text
q_a = a20 X² + a11 X v + a10 X w + a02 v² + a01 v w + a00 w².
```

### Condition (1) — finite flat length six

There exists a linear form `ℓ` with

```text
Res(c, q_a, ℓ) ≠ 0.
```

Then `Z_Q = C ∩ V(q_a)` is a 0-dimensional complete intersection of length 6
(plane cubic × conic). Because `C` is geometrically integral of degree 3, no
nonzero conic shares a component with `C`.

### Condition (2) — algebra isomorphism via multiplication tables

On the chart `ℓ = 1`, set

```text
A_Q = F[X, v] / (c|_{ℓ=1}, q_a|_{ℓ=1}).
```

Choose any F-basis `(b_0,…,b_5)` of `A_Q` (e.g. the monomial staircase of a
fixed grevlex elimination order) with structure constants `μ_{ij}^k(a)`:

```text
b_i b_j = ∑_k μ_{ij}^k(a) b_k.
```

Fix an F-basis `(e_0,…,e_5)` of `K_proj` with structure constants `λ_{ij}^k`
from the accepted sparse frame / monogenic presentation `K_proj = F(u)`,
`χ_u(u)=0`.

Require that `M` implements an F-algebra isomorphism:

```text
∑_{r,s} m_{i r} m_{j s} λ_{r s}^t
  = ∑_k μ_{ij}^k(a) m_{k t}
    for all i,j,t,
det M ≠ 0.
```

**Equivalent trace packaging.** Writing `φ(b_i) = ∑_r m_{i r} e_r`,

```text
Tr_{A_Q}(b_i b_j b_k) = Tr_{K_proj}(φ(b_i) φ(b_j) φ(b_k)).
```

**Equivalent monogenic packaging.** If `χ_u ∈ F[T]` is the accepted monic
degree-6 primitive polynomial for a generator `u` of `K_proj/F`, require
existence of `α = ∑ c_i b_i ∈ A_Q` with

```text
χ_u(α) = 0 in A_Q,
det_F(1, α, α², α³, α⁴, α⁵) ≠ 0.
```

No formulation introduces six free geometric points of `C` as unknowns.

### Condition (3) — projector open

```text
V(c, q_a, ∂_X c) = ∅  in P²
```

(equivalently a nonzero eliminant). This is the depressed-chart form of
`c_2 = F_u ≠ 0` at the support of `Z_Q`.

### Condition (4) — field identification is table-only

All of (2) is expressed by structure constants, traces, norms, or a single
characteristic polynomial. The `S_6`-primitivity hypothesis upgrades any
nonzero F-algebra map `A_Q → K_proj` to an isomorphism (no intermediate
image field).

---

## 3. Closed points and Path F objective

A closed point of the scheme over `F` produces:

```text
P ∈ C(K_proj) ∩ {∂_X c ≠ 0}.
```

That is exactly the Path F positive objective for the fixed-frame genus-one
curve. It is **not** a point of the auxiliary Morita plane `P²_D` and does
**not** by itself prove `G`-unirationality of the Klein cubic.

---

## 4. Strata known empty or non-generic

| Stratum | Status |
|---|---|
| Reducible conics (`q_a` product of linear forms over `F`) | `A_Q` is never a field; excluded by (2) |
| Fixed D5 residual direction `[v:w]=[t_1:1]` with constant `X_∗` | residual identity `c = B·R_B(t_1)`, `R_B(t_1)≠0`; excluded for generic `B` by `S_6`-primitivity (exact) |
| Conics with `A_Q ≅ F^6` or product of proper subfields | excluded by iso to the field `K_proj` |

---

## 5. Computational status

| Task | Status |
|---|---|
| Scheme equations written by mult tables / traces / monogenic charpoly | **done** |
| Five-form coefficients exported exactly over `Q(ζ₁₁)` | **done** |
| Fixed-direction residual identity | **done** (exact) |
| Monogenic `χ_u` on line `(1,2,3,s)` / fibre `s=4` | **done** (`S_6` over `QQ`) |
| F-point of the scheme / explicit conic | **not found** |
| Local cohomological obstruction to existence | **not claimed** |
| Generic elimination of the mult-table ideal | **not run** (would require a scoped 8 GiB plan) |
| Existence exit (this cycle) | **`EXISTENCE-UNDECIDED`** — see `EXISTENCE_STATUS.md` |

---

## 6. Verifier

```sh
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u \
  certificates/fixed_frame_arithmetic/conic_algebra_verify.py
```

Success marker:

```text
PATH_F_F1P_CONIC_ALGEBRA_INTERFACE_ACCEPT
```
