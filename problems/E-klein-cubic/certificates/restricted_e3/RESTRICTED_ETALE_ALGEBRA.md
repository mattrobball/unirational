# Path F / F1 — Restricted étale algebra `R_K = R ⊗_F K_proj`

**Date:** 2026-07-31  
**Base pin:** `c5e71be`  
**Headline:** OPEN  
**Binary status:** `UNDECIDED` — this packet does **not** decide
`res_{K_proj/F}(ξ)=0`.

---

## 0. Scope

Dispatch F of `WORKORDER_POST_ELO_CONSTRUCTION.md`:

1. construct `R_K = R ⊗_F K_proj`;
2. emit exact F2 / F3 plans (companion files);
3. **do not** start a large conic elimination.

Paths G and T are parallel and untouched.

---

## 1. Base data (accepted)

| Object | Value | Source |
|---|---|---|
| `F` | `C(A,B,Y,Z)` with `Q(ζ₁₁) ⊂ C` | fixed-frame five-form system |
| `C/F` | depressed plane cubic from `⟨F0,FA,FB,FY,FZ⟩` | `certificates/fixed_frame_arithmetic/*` |
| `E = Jac(C)` | `y² = x³ − 27 c₄ x − 54 c₆` | Fisher; minimal ternary interface |
| `K_proj/F` | degree **6**, monodromy **S₆**, **no proper intermediate fields** | degree + branch-line packets |
| `ξ ∈ H¹(F, E[3])` | first-descent class of the covering | Path F arithmetic |
| `α_R = w₁(ξ)` | explicit in `Rˣ/Rˣ³` | `tmp/pfaffian_depressed_alpha_r` |
| `D₃`, `D₅` | **retired** as local Kummer obstructions | local Kummer + residual constant point |

### CFOSS pin (mandatory specific citation)

- **Injectivity:** Cremona–Fisher–O’Neil–Simon–Stoll, *Explicit n-descent I*,
  **Lemma 3.1**: if `n` is prime then `w₁` is injective. Used at `n = 3`.
- **Class identification:** **Corollary 3.12** (`n` odd): `w₁(ξ) = det(M)·(Rˣ)ⁿ`.
- **Hash-pinned PDF:** `86f5b9a156c9afffdb3434670012b48bbfdb058ca22f4b2fefac493d5d7d1e01`
- **Repository pin:** `certificates/pfaffian_point/CFOSS_W1_INPUT.md`

Never cite “CFOSS injectivity” generically.

---

## 2. `R` over `F`

The CFOSS étale algebra of `E[3]` is

```text
R = Map_F(E[3], F̄)^{Gal(F̄/F)},     rank_F(R) = 9.
```

Presentation used throughout the Pfaffian / fixed-frame packets:

```text
R  ≅  F · e_O   ×   L,
L  =  F[x,y] / ( ψ₃(x),  y² − x³ − A_E x − B_E ),

ψ₃(X) = 3 X⁴ + 6 A_E X² + 12 B_E X − A_E²,
A_E = −27 c₄,   B_E = −54 c₆.
```

Basis of the rank-eight summand:

```text
1, x, x², x³, y, yx, yx², yx³.
```

### Field factorization of `L` (characteristic zero)

On the smooth open `Δ ≠ 0`, `L/F` is finite étale of rank 8. At the six exact
smooth specializations

```text
(A,B,Y,Z) ∈ { (1,2,3,4), (1,1,1,1), (2,3,5,7),
              (0,1,2,3), (3,1,4,2), (1,0,0,1) }
```

over `Q(ζ₁₁)`:

1. `ψ₃` is **irreducible of degree 4**;
2. the primitive element `x + y` has **irreducible degree-8** minimal polynomial
   over `Q(ζ₁₁)`.

A nontrivial product of positive-rank field factors cannot specialize to a
single degree-8 field. Therefore, generically,

```text
L/F is a field extension of degree 8,
R ≅ F × L.
```

(Replay: `tmp/postelo_F/analyze_R8.jl`, sealed in
`restricted_algebra.json#specialization_witnesses`. Modular factor-type scans
are discovery only and are **not** char-0 claims.)

### Galois-module structure

- `E[3] ≅ (Z/3Z)²` with representation `ρ: Gal(F̄/F) → GL₂(F₃)`.
- `{O}` is Gal-fixed → identity factor `F`.
- The eight nonzero points form a **single** Gal-orbit (transitivity = field
  property of `L`) → nonzero factor `L`.
- The four `x`-coordinates (lines `{±T}`) form a single orbit generically
  (`ψ₃` irreducible).
- The exact image of `ρ` inside `GL₂(F₃)` is **not** sealed as full `GL₂` in
  this packet; modular Frobenius types are consistent with a large image.

### Automorphisms (rigidity, stated not assumed)

```text
Aut(L/F)  is NOT computed in characteristic zero in this dispatch.
```

Path A established `Aut(L/F) = 1` for a different degree-55 algebra. That
statement is **not** transferred here. If needed for F3, compute
`Aut(L/F) ≅ N_G(H)/H` from the Galois closure / image of `ρ` (see F3 plan).

---

## 3. Restricted algebra `R_K = R ⊗_F K_proj`

```text
R_K := R ⊗_F K_proj
     ≅ K_proj · e_O  ×  (L ⊗_F K_proj).
```

### Linear disjointness (main structural lever)

Accepted rigidity: `K_proj/F` has **no proper intermediate fields**, degree 6,
monodromy `S₆`.

Any intersection `L ∩ K_proj` inside a common closure is a subfield of
`K_proj`, hence equals `F` or `K_proj`. It cannot equal `K_proj` because
`[K_proj:F] = 6` does not divide `[L:F] = 8`. Therefore

```text
L ∩ K_proj = F,
```

so `L` and `K_proj` are linearly disjoint over `F`, and

```text
L_K := L ⊗_F K_proj
```

is a **field** of degree 8 over `K_proj` (absolute degree 48 over `F`).

**Note on `gcd(8,6) = 2`.** In the abstract degree lattice a shared quadratic
is possible; `S₆`-rigidity of `K_proj/F` forbids every proper subfield,
including quadratics. The loophole is closed by monodromy rigidity, not by
coprimeness.

### Factorization summary

| Factor | Degree over `K_proj` | Type |
|---|---:|---|
| identity `K_proj · e_O` | 1 | split |
| `L_K` | 8 | field |
| **total** | **9** | étale |

As a Gal(`K_proj̄/K_proj`)-module algebra, `R_K` is exactly the CFOSS algebra
of the base-changed group scheme `E_{K_proj}[3]`.

---

## 4. Image of `α_R` in `R_Kˣ / R_Kˣ³`

Compatibility with the pinned convention:

```text
α_R = w₁(ξ)     (CFOSS I, Cor. 3.12, n=3 odd),
w₁ injective     (CFOSS I, Lemma 3.1, n=3 prime).
```

Explicit representative: scalar-normalized translation determinant

```text
M₀ = L(P₂)⁻¹ L(P₁),   M = M₀ / ℓ(M₀),   α_R = det(M) = det(M₀)/ℓ(M₀)³,
```

installed as a 755,647-node DAG in `tmp/pfaffian_depressed_alpha_r/`. The
identity component is an `R`-cube; after cube gauge one may take
`α_R(O) = 1`. The nontrivial cube-class lives in the `L_K`-component.

### Binary criterion (not evaluated this dispatch)

```text
res_{K_proj/F}(ξ) = 0
    ⟺   α_R ∈ (R_Kˣ)³
    ⟺   α_L ∈ (L_Kˣ)³     (identity component already a cube),
```

by CFOSS I Lemma 3.1 over the perfect char-0 field `K_proj`.

---

## 5. What is proved / not proved

**Proved (this packet):**

- structural presentation of `R` and `R_K`;
- `L/F` field of degree 8 (specialization + étale rank);
- `L_K/K_proj` field of degree 8 (linear disjointness from `S₆`-rigidity);
- CFOSS convention match for `α_R = w₁(ξ)` and injectivity pin;
- identity component of `α_R` is a cube (installed).

**Not proved:**

- whether `res(ξ) = 0`;
- whether `α_L` is a global cube in `L_K`;
- `Aut(L/F)`;
- full image of `ρ`;
- existence/emptiness of `C(K_proj)` or of the conic scheme;
- `ed_C(G)`.

---

## 6. Replay

```sh
/opt/homebrew/bin/python3 -u \
  certificates/restricted_e3/produce_restricted_algebra.py

/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u \
  certificates/restricted_e3/verify_restricted_algebra.py
```

Success marker:

```text
PATH_F_RESTRICTED_ETALE_ALGEBRA_ACCEPT
```

Companion plans (not executed here):

- `CUBE_TEST.md` / `divisor_vector_mod3.json` — F2
- `group_cohomology.json` — F3
- `DECISION.md` — F4 consequences ledger (binary still open)
