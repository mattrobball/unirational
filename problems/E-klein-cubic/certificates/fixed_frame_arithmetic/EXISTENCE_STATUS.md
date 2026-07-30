# Path F — Existence status on the conic / intersection-algebra scheme

**Date:** 2026-07-30  
**Fork:** F1-P (unchanged)  
**Headline:** OPEN  
**Exit:** `EXISTENCE-UNDECIDED`  
**Not claimed:** `P-F`, `N-F`, `F-STOP`, `F-LOCAL-SOLUBLE`, `ed_C(G)=3`

---

## 0. What was already sealed

Gate F2 sealed the terminal positive implication

```text
conic-algebra solution  ==>  C(K_proj) ≠ ∅
```

with full arrow ledger, FAIL-SCOPE exclusion of auxiliary `P²_D`, and the
exact fixed-direction residual identity

```text
c(X_*, t_1, 1) = B · R_B(t_1),   R_B(t_1) ≠ 0.
```

What remained was **existence** of an `F`-point of the scheme.

---

## 1. Exact remaining system (monogenic packaging)

Over `F = C(A,B,Y,Z)` with `[K_proj:F] = 6`, `S_6` monodromy, and no proper
intermediate fields, the accepted monogenic generator is

```text
u = f_8 / f_5   (affine slice f_3 = 1),
```

annihilated by the sparse-determinant sextic

```text
χ_u(T) = R(A,B,Y,Z; T) ∈ F[T],
R = det(M)/u,
```

where `M` is the `3×3` coefficient matrix of the three sparse BKK consequences
in columns `(1, v, t)`. On the deterministic line `(A,B,Y,Z)=(1,2,3,s)` this
is an explicit primitive bihomogeneous sextic `E(s,u)` (36 terms); at `s=4`
it is irreducible over `QQ` with Galois group `S_6`. Serialized:
`tmp/pathF_existence/monogenic_system.json` and
`tmp/pathF_existence/line_eliminant_E_terms.json`.

### Scheme unknowns

1. Conic `[a₂₀:a₁₁:a₁₀:a₀₂:a₀₁:a₀₀] ∈ P⁵(F)`.
2. Coordinates `c₀,…,c₅` of `α = ∑ c_i b_i ∈ A_Q` on a fixed grevlex
   staircase basis `(b_i)` of

   ```text
   A_Q = F[X,v] / (c|_{w=1}, q_a|_{w=1})
   ```

   on the open `Res(c, q_a, w) ≠ 0`.

### Equations (no six-point solve)

```text
χ_u(α) = 0 in A_Q                         (6 coefficient equations),
det_F(1, α, α², α³, α⁴, α⁵) ≠ 0,          (generator open),
Res(c, q_a, ℓ) ≠ 0 for some linear ℓ,      (length-six open),
V(c, q_a, ∂_X c) = ∅.                      (projector open)
```

Equivalent formulations (same zero set on the det-open): multiplication-table
isomorphism via `M ∈ GL_6`, or triple-trace matching after `M`.

`S_6`-primitivity upgrades any nonzero `F`-algebra map `A_Q → K_proj` to an
isomorphism, so the field-identification condition is rigid.

### Necessary pruning (not yet decisive)

| Invariant | Role |
|---|---|
| `disc(A_Q) ≡ disc(K_proj)` in `F^×/(F^×)²` | disc hypersurface on `P⁵` |
| Cubic / quadratic resolvents of a monogenic element of `A_Q` | match those of `χ_u` up to Tschirnhaus |
| Fixed binary direction `[v:w]=[t₁:1]` | already empty for generic `B` |

---

## 2. Attack log (this cycle)

### 2.1 Specialized fibre `(A,B,Y,Z)=(1,2,3,4)`

Exact rebuild:

- Five-form cubic over `Q(ζ₁₁)` with `T = Z − 11 A²/18 = 61/18`.
- Monogenic `E₄(u)` irreducible over `QQ`, Galois group `S_6`.
- Payload: `tmp/pathF_existence/special_1234.json`.

Small-height search for points of the specialized cubic over `Q(ζ₁₁)` found
none (non-proof). Full search for points over the composite
`Q(ζ₁₁)[u]/(E₄)` (absolute degree 60) and 3-Selmer comparison on the
Jacobian were not completed inside the resource envelope.

### 2.2 Modular discovery / obstruction

By Lang–Steinberg, `H¹(F_q, E) = 0` for abelian varieties over finite fields.
Every genus-one curve over a finite field has a rational point. Therefore
**no modular specialization can prove** `C(K_proj) = ∅` in characteristic
zero. Modular arithmetic remains discovery-only for solution shape; it is not
an obstruction certificate.

(Over `F_q` there is moreover a unique extension of each degree, so
isomorphism type of degree-six fields is not a pruning invariant after
reduction.)

### 2.3 Dense generic elimination

A dense Gröbner / mult-table elimination of the monogenic ideal over
`F = C(A,B,Y,Z)` with unknowns in `P⁵ × A⁶` was **not** launched. Under the
work-order 8 GiB gate it requires a scoped dimension/term-count plan first.
No floor was exceeded because the unscoped job was not started.

### 2.4 Structural non-existence / existence

No new terminal local obstruction (F1-N not reopened). Restriction–corestriction
along `[K_proj:F] = 6` multiplies by `6 ≡ 0 (mod 3)` on the order-three
Weil–Châtelet class, so it neither forces the class to die nor to survive on
`K_proj`. No abstract existence theorem for an `F`-conic with
`A_Q ≅ K_proj` was found.

---

## 3. Decision

| Claim | Status |
|---|---|
| Scheme interface terminal | yes (F2 sealed) |
| Fixed-direction stratum empty | yes (exact) |
| `F`-point of the scheme constructed | **no** |
| Local / cohomological obstruction to existence | **no** |
| Headline `ed_C(G)` | **OPEN** |

**Exit code: `EXISTENCE-UNDECIDED`.**

The conic criterion remains a terminal positive interface. This is **not**
`F-STOP` (a terminal criterion still exists). It is **not** `N-F` (emptiness
of the scheme is not proved). It is **not** `P-F` (no conic / point).

### If the scheme were later proved empty

That would be `N-F`-adjacent **only for this criterion**: it would prove
`C(K_proj) = ∅` via the sealed bridge. It would **not** by itself prove
`ed_C(G) = 4` or non-unirationality of the Klein cubic, and it would not
touch the Pfaffian–Morita / `F_{14,T}` FAIL-SCOPE object.

### If a solution were later constructed

That would be `P-F` for Path F after re-checking the full F2 bridge, still
**not** a headline claim of `ed_C(G) = 3` without the separate versal-twist
bridge.

---

## 4. Files

```text
certificates/fixed_frame_arithmetic/EXISTENCE_STATUS.md
certificates/fixed_frame_arithmetic/existence_verify.py
certificates/fixed_frame_arithmetic/SEAL.json          (updated)
tmp/pathF_existence/monogenic_system.json
tmp/pathF_existence/line_eliminant_E_terms.json
tmp/pathF_existence/special_1234.json
```

## 5. Verifier

```sh
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u \
  certificates/fixed_frame_arithmetic/existence_verify.py
```

Success marker:

```text
PATH_F_EXISTENCE_UNDECIDED_ACCEPT
```
