# Path F / F2 — Divisor cube test (exact plan only)

**Status:** `PLAN_ONLY` — not executed in this dispatch.  
**Headline:** OPEN  
**Depends on:** F1 restricted algebra (`R_K ≅ K_proj × L_K`, `L_K/K_proj` field of degree 8).

This file is the sealed computation plan required by the work order. It does
**not** claim `F-NONCUBE` or `F-DIVISOR-CUBE`.

---

## 0. Decision target

Decide whether the image of the explicit representative

```text
α_R ∈ R_Kˣ / R_Kˣ³
```

is a cube, by the valuation vector

```text
(v_E(α_R))_E  (mod 3)
```

on a normal integral model, followed (only if all valuations vanish mod 3) by
a residual unit-cube test.

By CFOSS I Lemma 3.1 (`n=3`, pinned in
`certificates/pfaffian_point/CFOSS_W1_INPUT.md`):

```text
res(ξ)=0  ⟺  α_R is a cube in R_Kˣ.
```

Identity component already a cube ⇒ equivalent to `α_L ∈ (L_Kˣ)³`.

---

## 1. Objects

| Symbol | Object |
|---|---|
| `F` | `C(A,B,Y,Z)` |
| `K_proj` | degree-6 extension, monodromy `S₆`, no intermediate fields |
| `O_F` | a normal model of `F` (e.g. localized coordinate ring of the affine chart on the base of the five-form system) |
| `O_K` | integral closure of `O_F` in `K_proj` (normal; Dedekind after localizing away from a controlled codim-≥2 set) |
| `O_L` | integral closure of `O_K` in `L_K` |
| `α_L` | nonzero-component of the installed `α_R` after identity cube-normalization |
| `E` | height-one primes of `O_L` (and of `O_K` for the split identity factor) |

**Gauge control.** The saved `α_R` DAG has a mixed-weight node
(`λ + e_Δ`). Componentwise raw weights of the nine coordinates are **not**
valuation-invariant under `R`-cube gauge. The plan works with the
**class** `[α_L]` after a cube regauge that is integral and unit-normalized at
the identity, never with raw DAG weights.

**Retired places.** Do not re-open `D₃=(f₃=0)` or `D₅=(f₅=0)` as local
obstructions (already retired). They may appear in the divisor support only
as places whose valuations are already known to be `0 mod 3` after correct
gauge.

---

## 2. Exact equations / cocycle data

1. **Jacobian model over `O_F`.**
   ```text
   A_E = −27 c₄(q,r),   B_E = −54 c₆(q,r),
   ψ₃ = 3x⁴ + 6 A_E x² + 12 B_E x − A_E²,
   y² = x³ + A_E x + B_E.
   ```
   with `(q,r)` the five-form binary slots (elements of `F`).

2. **Field `L_K`.** Monogenic presentation after F1:
   ```text
   L_K ≅ K_proj[T] / (χ₈(T)),
   ```
   where `χ₈` is the degree-8 minpoly of a primitive element
   `τ = x + u y` (e.g. `u=1` works at all tested specializations). Produce
   `χ₈ ∈ O_K[T]` by clearing denominators of the resultant
   ```text
   Res_X( ψ₃(X), (T − X)² − u² (X³ + A_E X + B_E) ).
   ```

3. **Integral representative of `α_L`.**
   From the installed translation matrix in the R₈-basis
   `(1,x,x²,x³,y,yx,yx²,yx³)`, project to the `L_K`-component and write
   ```text
   α_L = ∑_{i=0}^{7} a_i τ^i ,    a_i ∈ K_proj,
   ```
   then clear a common denominator `d ∈ O_K` so that
   ```text
   β := d³ α_L ∈ O_Lˣ · (fractional ideal data),
   ```
   recording the exact ideal factorization of `(d)` so that
   ```text
   v_E(α_L) ≡ v_E(β) − 3 v_E(d)  (mod 3)
   ```
   is well-defined on the class.

4. **Divisor vector.**
   For every height-one prime `E` of `O_L` with `v_E(β) ≠ 0` or
   `v_E(d) ≠ 0` (finite support),
   ```text
   δ_E := v_E(α_L) mod 3 ∈ {0,1,2}.
   ```
   Output the sparse vector `(δ_E)_E`.

---

## 3. Computation shape

### Phase F2.A — monogenic integral model of `L_K`

1. Build `χ₈` symbolically over `F` (resultant in one variable; coefficients in
   `Q(ζ₁₁)(A,B,Y,Z)`).
2. Base-change coefficients along the accepted monogenic presentation of
   `K_proj = F(u)`, `χ_u(u)=0` (sparse BKK / monogenic_system).
3. Clear denominators → primitive integral polynomial over a model of
   `O_K`.
4. Sanity: at the six F1 specializations, recover irreducible degree-8
   polynomials matching `analyze_R8.jl`.

### Phase F2.B — place census (codimension one only)

1. Factor the discriminant ideal of `χ₈` over `O_K` into height-one primes
   (only places that can ramify in `L_K/K_proj` or support `α_L`).
2. Include poles/zeros of the coefficient denominators of `α_L` and of the
   five-form / `c₄,c₆` denominators on the fixed-frame chart.
3. **Do not** enumerate all primes of a global function field by brute force;
   work with the explicit principal ideal generators coming from the
   coefficient denominators and `disc(χ₈)`.

### Phase F2.C — valuation vector mod 3

For each prime in the finite support:

1. compute `v_E(β)` and `v_E(d)` by local uniformizer / Newton polygon / DVR
   factorization in the completion (exact PARI `nf`, or Hecke local methods
   after specializing only for discovery);
2. reduce mod 3;
3. if any `δ_E ≠ 0`, exit **`F-NONCUBE`**.

### Phase F2.D — residual unit cube (only if F2.C all-zero)

If every `δ_E = 0`, write

```text
α_L = μ · γ³
```

with `γ` in the fraction field and `μ` a unit of the chosen normal model of
`L_K` (constant-field units × S-unit generators after removing the divisor
cube). Decide whether `μ` is a cube in the unit group:

```text
μ ∈ U / U³.
```

Use:

- algebraically closed constant field `C` ⇒ constant units are cubes
  automatically in `Cˣ/(Cˣ)³ = 1`;
- the exact finite-rank unit lattice of the model after the inverted
  discriminant open (Dirichlet / S-unit exact sequence in the function-field
  setting).

**Do not** assume divisor-cube ⇒ global cube without this unit step.

Exits:

- **`F-NONCUBE`:** some `δ_E ≠ 0` ⇒ `res(ξ) ≠ 0`.
- **`F-DIVISOR-CUBE`:** all `δ_E = 0`; then unit test decides cube / noncube.
- **`F-UNIT-NONCUBE`:** residual unit not a cube ⇒ `res(ξ) ≠ 0`.
- **`F-CUBE`:** divisor and unit tests pass ⇒ `res(ξ) = 0` by CFOSS injectivity.

---

## 4. Dimensions and memory floors

| Object | Size estimate | Sparse floor | Dense floor |
|---|---|---|---|
| `χ₈` coeffs in `F = Q(ζ₁₁)(A,B,Y,Z)` | 8 polys; each bi-degree expected O(≤ 48) in frame weights after clearing | stream terms; target **≪ 1 GiB** | avoid dense multivariate in 4 params |
| `χ₈` over monogenic `K_proj=F(u)` | replace params via `χ_u`; fibrewise degree ≤ 6 in `u` | same | same |
| Resultant for `χ₈` | bivariate resultant deg_X ψ₃=4, deg_X RY=2 → deg_T 8 | PARI/Nemo resultant; **< 512 MiB** observed on specializations | N/A |
| Place census | #primes ≤ #factors of disc + denom; expected dozens, not millions | ideal factorization of explicit principals | — |
| Local valuations | one DVR per place; degree ≤ 48 abs over Q(ζ₁₁) on number-field fibres | **< 2 GiB** per fibre | absolute deg-48 nfinit may need **≤ 4 GiB** |
| Unit lattice rank | ≤ #S + r₁+r₂−1 on models; function-field S-unit rank = #S−1 + genus terms | exact S-unit engines; stop if RSS → 8 GiB | — |

**8 GiB gate.** Before any job expected to exceed 8 GiB RSS, emit this table
with measured term counts and stop for director approval. Exploratory ceiling
is 8 GiB; no concurrent memory-saturating jobs with Paths G/T.

**Finite fields:** discovery / support design only (e.g. which places appear).
Never advertise modular non-cube as characteristic-zero `F-NONCUBE` without
exact lift of the valuation.

---

## 5. Certificate format

```text
certificates/restricted_e3/divisor_vector_mod3.json
```

Required fields (when F2 is executed):

```json
{
  "format": "pathF-divisor-vector-mod3-v1",
  "headline": "OPEN",
  "exit": "F-NONCUBE | F-DIVISOR-CUBE | F-UNIT-NONCUBE | F-CUBE | PLAN_ONLY",
  "model": { "O_K": "...", "chi8": "...", "alpha_gauge": "..." },
  "places": [
    { "id": "E1", "generator": "...", "v_alpha_mod3": 0 }
  ],
  "unit_test": { "status": "skipped|pass|fail", "rank": null, "mu_is_cube": null },
  "cfoss": "CFOSS I Lemma 3.1 n=3; PDF sha256 86f5b9a1…1e01",
  "sources_sha256": {},
  "seal_sha256_of_payload_without_this_field": "…"
}
```

Self-hash last. No timing fields. Terminal marker string separate from
payload.

---

## 6. Independent verifier design

`certificates/restricted_e3/verify_cube_test.py` (to be written when F2 runs):

1. **Does not import** the producer that built `α_L` coordinates or the
   valuation engine.
2. Rebuilds `χ₈` from `ψ₃` + resultant formula.
3. Recomputes `v_E(α_L) mod 3` at every place listed in the certificate from
   the integral equation of `β` and the ideal `(d)`.
4. Checks consistency `∑ deg(E)·δ_E ≡ 0 (mod 3)` against the norm of `α_L` in
   `K_projˣ/(K_projˣ)³` (global product formula / norm of cube class).
5. If unit test claimed, recomputes whether `μ` is a cube in the sealed unit
   lattice presentation (matrix of valuations / free generators).
6. Confirms CFOSS pin string matches `CFOSS_W1_INPUT.md`.
7. Success markers: `PATH_F_F2_NONCUBE_ACCEPT` or `PATH_F_F2_CUBE_ACCEPT` etc.

---

## 7. Checkpoint plan

1. Seal monogenic `χ₈` over `F` and over `K_proj`.
2. Seal integral `β,d` for `α_L`.
3. Seal place list + raw valuations (before mod 3).
4. Seal mod-3 vector + exit code.
5. If needed, seal unit lattice and residual cube test.

Each checkpoint is independently hash-pinned; later stages may restart from
any checkpoint without recomputing F1.

---

## 8. Strict boundary

- Plan only in this dispatch.
- No claim that `res(ξ)` vanishes or not.
- No conic elimination.
- `D₃`/`D₅` not reopened as obstructions.
