# Path F — Gate F2 terminality audit (Fork F1-P)

**Date:** 2026-07-30  
**Base pin (work order):** `89c27e2` (working tree may sit later)  
**Headline:** OPEN  
**Fork chosen at F1:** **F1-P** (conic / intersection-algebra construction)  
**Fork not started:** F1-N (no new divisorial valuation computation)

---

## 0. Fork choice (required before computation)

### Choice

**F1-P only.**

### Reason

1. The two primary quotient divisors already retired as local obstructions are
   `D_3=(f_3=0)` (Hensel point in the projector open) and `D_5=(f_5=0)`
   (exact constant residual point over `F_0=C(A,Y,Z)`). Both are accepted
   inputs; neither remains a Kummer obstruction.
2. Fork F1-N requires a **new** divisorial place with an **integral homogeneous
   gauge**. The saved `alpha_R` DAG has a mixed-weight addition at node `3567`
   (`lambda+e_Delta`), so naive DAG reduction is invalid. Without a fresh
   terminal local–global theorem, further place-hunting risks only
   `F-LOCAL-SOLUBLE` cycles or an unauthorized DAG enlargement.
3. The conic criterion is already theorem-shaped under accepted hypotheses
   (`C(F)=∅`, `Pic^0(C)(F)=0`, `[K_proj:F]=6`, no proper intermediate fields,
   geometric monodromy `S_6`). It is a finite-dimensional algebraic interface
   over `P^5(F)` whose solution is **exactly** a `K_proj`-point of `C`, not an
   auxiliary Morita or Fano-partner object.
4. Therefore F1-P is the only fork with a currently terminal positive
   implication that does not reopen mixed-weight gauge traps.

F1-N was not started (no valuation integral-gauge search, no local Kummer
image computation at a new place).

---

## 1. Target objects (scope check against FAIL-SCOPE)

| Object | Definition | Field | Role |
|---|---|---|---|
| `F` | `C(A,B,Y,Z)` with `A=f_6/f_3^2`, `B=f_5 f_7/f_3^4`, `Y=f_9/f_3^3`, `Z=f_12/f_3^4` | rational | base |
| `C/F` | fixed-frame depressed plane cubic, generic member of the basepoint-free five-form system `⟨F_0,F_A,F_B,F_Y,F_Z⟩` | `F` | **the** genus-one torsor under audit |
| `K_proj` | projective fixed-frame function field | `[K_proj:F]=6` | field of definition for the desired point |
| `Q` | F-conic in the plane of `C` | `F` | cutting divisor of the Gal-orbit |
| `A_Q` | `Γ(C∩Q, O)` length-six F-algebra | `F` | intersection algebra |
| `E=Pic^0(C)` | Jacobian of `C` | `F` | used only via `E(F)=0` |

### Explicit exclusion of the auxiliary-idempotent scope error

The Pfaffian Attempt-1 route returned **`FAIL-SCOPE`** because a
`σ`-self-adjoint reduced-rank-two idempotent is a point of an **auxiliary**
open in the rational `D`-plane `P^2_D` (Morita projectors for the structure
form of `σ`), **not** a point of the degree-14 Fano section `F_{14,T}` nor of
the Klein twist. The missing bridge is a codimension-five simultaneous
isotropy problem for `H_T ⊂ Herm_3(D)`. See
`certificates/pfaffian_point/BRIDGE_AUDIT.md` and
`certificates/pfaffian_point/IDEMPOTENT_TO_KLEIN_POINT.md`.

**This fork does not use that idempotent, `P^2_D`, `Herm_3(D)`, or `F_{14,T}`.**

| Claimed object | Is it the object needed? |
|---|---|
| Point of `C` over `K_proj` | **Yes** — exact Path F objective |
| Point of auxiliary `P^2_D` | **No** — not used |
| Point of `F_{14,T}` | **No** — not used |
| Abstract Morita projector | **No** — not used |

Every arrow below targets `C` or an F-scheme of conics cutting `C`.

---

## 2. Accepted inputs (used, not re-derived)

| Input | Source |
|---|---|
| Exact depressed cubic / five-form linear system over `F` | `tmp/pfaffian_minimal_ternary_model`, `tmp/pfaffian_global_fixed_frame_hostile_audit` |
| `ind(C/F)=3`, `C(F)=∅`, `Pic^0(C)(F)=0` | same hostile audit (incidence Picard ledger) |
| `[K_proj:F]=6` | `tmp/full_scaled_frame_degree_attack` (sparse BKK) |
| No proper intermediate fields; geometric monodromy `S_6` | degree packet + `tmp/full_scaled_frame_branch_line_hostile_audit` |
| Conic criterion under those hypotheses | `tmp/sextic_conic_section_gate` |
| `D_3` locally soluble | `tmp/pfaffian_torsor_valuation_attack`, `tmp/pfaffian_alpha_local_kummer` |
| `D_5` residual constant point; place retired | `tmp/pfaffian_d5_constant_point` |
| Jacobian / `E[3]` / `alpha_R=w_1(ξ)` | `tmp/pfaffian_depressed_alpha_r` |
| **CFOSS I, Lemma 3.1** (`n` prime ⇒ `w_1` injective), conventions via Cor. 3.12 | `certificates/pfaffian_point/CFOSS_W1_INPUT.md` (hash-pinned PDF `86f5b9a1…1e01`) |

CFOSS is cited **only** as the pinned prime-`3` injectivity lemma above. It is
**not** needed for the positive conic implication of F1-P; it remains an
accepted Kummer reverse for any future local comparison.

---

## 3. Final implication (Gate F2)

```text
conic-algebra solution  ==>  C(K_proj) ≠ ∅
```

More precisely:

```text
∃ Q/F conic such that
  (i)  C ∩ Q is finite flat of length 6,
  (ii) A_Q ≅ K_proj as F-algebras,
  (iii) C ∩ Q meets the projector open {∂_X c ≠ 0},
  (iv) the iso in (ii) is witnessed by exact mult tables / traces / norms
==>
∃ P ∈ C(K_proj) lying in the projector open.
```

### Converse (for completeness; not required for positive closure)

```text
P ∈ C(K_proj)  ==>  unique F-conic Q (up to F^×) with C ∩ Q = Gal-orbit of P
                  and A_Q ≅ K_proj.
```

Uniqueness uses `E(F)=0` and `H^0(P^2,O(2)) ≅ H^0(C,O_C(2H))`.

---

## 4. Arrow ledger (source → target, every map attributed)

### Arrow 1 — base curve

| Attribute | Record |
|---|---|
| **Source** | installed Pfaffian Reynolds frame `(0,1,2)`, normalized depressed model |
| **Target** | smooth geometrically integral plane cubic `C/F` |
| **Field** | `F=C(A,B,Y,Z)` |
| **Open** | `f_3 f_5 ≠ 0` chart for ratios; smoothness of generic fibre (accepted) |
| **Descent** | coefficients are weight-zero ratios of Hironaka invariants |
| **Brauer/orientation** | none |
| **Theorem** | exact five-form reconstruction; hostile index audit |

### Arrow 2 — field extension

| Attribute | Record |
|---|---|
| **Source** | sparse three-consequence ideal in `F[t,u,v]` |
| **Target** | `K_proj/F` of degree 6, no proper intermediate fields |
| **Field** | `F` |
| **Open** | generic localization units (`t=f_5^3` structural unit, `u≠0`, Cramer denominators) |
| **Descent** | `μ_3`-invariants of the scaled affine frame |
| **Theorem** | BKK upper bound 6 + étale six-sheet lower bound 6; primitivity from monodromy `S_6` |

### Arrow 3 — conic cuts orbit divisor

| Attribute | Record |
|---|---|
| **Source** | `P ∈ C(K_proj)` with residue field `K_proj` (forced by no intermediate fields + `C(F)=∅`) |
| **Target** | effective F-rational divisor `D=∑ σ(P)` of degree 6 |
| **Field** | `F` |
| **Open** | separability automatic in char 0 |
| **Theorem** | Galois orbit of a primitive closed point |

### Arrow 4 — `D ∼ 2H`

| Attribute | Record |
|---|---|
| **Source** | `O_C(D)⊗O_C(−2H) ∈ E(F)` |
| **Target** | `O_C(D) ≅ O_C(2H)` |
| **Field** | `F` |
| **Theorem** | `E(F)=0` (accepted index/Picard ledger) |

### Arrow 5 — lift to a plane conic

| Attribute | Record |
|---|---|
| **Source** | section of `O_C(2H)` cutting `D` |
| **Target** | conic equation `q_a ∈ H^0(P^2,O(2))`, unique up to `F^×` |
| **Field** | `F` |
| **Open** | none beyond nonzero section |
| **Theorem** | restriction `H^0(P^2,O(2)) → H^0(C,O_C(2H))` is an isomorphism (both sides dim 6; kernel is multiples of the cubic, which live in `H^0(O(−1))=0`) |

### Arrow 6 — reverse: algebra iso ⇒ point

| Attribute | Record |
|---|---|
| **Source** | F-algebra iso `φ: A_Q → K_proj` |
| **Target** | `P ∈ C(K_proj)` corresponding to the closed point of `Spec A_Q` mapped to the generic point of `Spec K_proj` |
| **Field** | `K_proj` |
| **Open** | `det M ≠ 0` for the matrix of `φ` on chosen bases; projector open at `P` |
| **Descent/twist** | none |
| **Brauer ambiguity** | none for the plane model (not a Severi–Brauer) |
| **Theorem** | under `C(F)=∅` and no intermediate fields, any unital F-algebra map `A_Q → K_proj` is an isomorphism; evaluation gives a `K_proj`-point of `C∩Q ⊂ C` |

### Arrow 7 — projector open → rank-two idempotent (optional downstream)

| Attribute | Record |
|---|---|
| **Source** | `P ∈ C(K_proj)` with `∂_X c(P) ≠ 0` |
| **Target** | reduced-rank-two projector in the installed Pfaffian calculus over `K_proj` |
| **Field** | `K_proj` |
| **Open** | `c_2 = F_u ≠ 0` (same as `∂_X c ≠ 0` in depressed coordinates) |
| **Scope warning** | this produces a projector for the **fixed-frame** Pfaffian chart, not automatically a common isotropic line of `H_T` or a point of `F_{14,T}`. Path F only claims `C(K_proj)≠∅`. Bridge to Klein unirationality is a separate arrow outside this packet. |

### Arrow 8 — Klein unirationality (explicitly **not** claimed here)

```text
C(K_proj) ≠ ∅  =/=>  X is G-unirational
```

without the full descent/bridge from the fixed-frame point through the
generic versal twist. Headline remains OPEN even after a hypothetical P-F.

---

## 5. Scheme equations (F1-P interface) — no unstructured six-point solve

Write

```text
q_a = a20 X² + a11 X v + a10 X w + a02 v² + a01 v w + a00 w²,
[a] ∈ P⁵(F).
```

On a chart `ell ≠ 0` with `Res(c,q_a,ell) ≠ 0`, set

```text
A_Q = F[X,v]/(c_ell, q_a,ell)     (dim_F = 6).
```

Fix an F-basis `(e_0,…,e_5)` of `K_proj` with structure constants
`e_i e_j = ∑_k λ_{ij}^k e_k` (from the accepted sparse frame / monogenic
`χ_u` presentation). Fix an F-basis `(b_0,…,b_5)` of `A_Q` with structure
constants `μ_{ij}^k(a)` polynomial in the conic coordinates on the open.

**Multiplication-table isomorphism.** Variables: matrix `M=(m_{rs}) ∈ Mat_6(F)`.
Equations:

```text
∑_{r,s} m_{ir} m_{js} λ_{rs}^t  =  ∑_k μ_{ij}^k(a) m_{kt}
for all i,j,t ∈ {0,…,5},
det M ≠ 0.
```

These are polynomial identities in `(a,M)` — exact mult tables, not a solve for
six geometric points as free variables.

**Trace form (equivalent).** With the same `M`, require

```text
Tr_{A_Q}(b_i b_j b_k) = Tr_{K_proj}(φ(b_i) φ(b_j) φ(b_k))
```

for all triple indices (power-sum / Newton packaging of structure constants).

**Monogenic packaging (equivalent when `K_proj=F(u)`, `χ_u` monic degree 6).**
Variables: `c_0,…,c_5` for `α=∑ c_i b_i ∈ A_Q`. Equations:

```text
χ_u(α) = 0 in A_Q,
det(1,α,α²,α³,α⁴,α⁵) ≠ 0  (F-linear independence in A_Q).
```

Again: one characteristic polynomial and a determinant open — no six-point
enumeration.

**Projector open.** The ideal `(c, q_a, ∂_X c)` has empty projective zero set
(equivalently a nonzero eliminant).

**S_6 rigidity.** Because `K_proj/F` has no proper intermediate field, any
nonzero F-algebra map `A_Q → K_proj` is injective, hence an isomorphism by
equal F-dimension. Reducible conics give product algebras and are excluded by
the field condition automatically.

---

## 6. Fixed-direction stratum (exact exclusion inside the scheme)

The D5 residual constant direction `[v:w]=[t_1:1]` with
`X=X_∗ ∈ Q(ζ_{11})` satisfies, as an identity in `Q(ζ_{11})[A,B,Y,Z]`,

```text
c(X_∗, t_1, 1) = B · R_B(t_1),
R_B(t_1) ≠ 0.
```

So the point lies on `C` if and only if `B=0`. For generic `B`, the same
direction forces an irreducible cubic in `X` over `F` (primitive and linear in
the independent parameter `B`), which would embed a cubic intermediate field
into `K_proj/F`, contradicting `S_6`-primitivity. This stratum is **not** a
solution of the conic scheme for generic `F`. (Exact replay:
`tmp/pathF_frame/conic_algebra_inputs.json`, marker
`FIXED_DIRECTION_RESIDUAL_IS_B_TIMES_RB_EXACT`.)

---

## 7. Resource / exploratory gate

A dense generic elimination of the mult-table ideal over
`F=C(A,B,Y,Z)` (4 transcendentals + `P^5` + `GL_6`) is **not** authorized as an
unscoped job. Before any run expected to exceed **8 GiB RSS**, dimensions,
term counts, sparse/dense floors, certificate shape, checkpoint plan, and
verifier design must be emitted and the job stopped if over ceiling.

This packet installs the terminal interface and exact fixed-direction
exclusion; it does **not** claim a generic Gröbner solution of the full
scheme.

---

## 8. Decision status after this audit

| Item | Status |
|---|---|
| F1 fork | **F1-P** chosen; F1-N not started |
| F2 implication | sealed: conic-algebra solution ⇒ `C(K_proj)≠∅` |
| Scope vs FAIL-SCOPE | target is `C/K_proj`, not auxiliary `P^2_D` |
| Solution of the scheme | **not constructed** |
| Local obstruction | **not claimed** (F1-N not run) |
| Headline | **OPEN** |
| Exit code | **F1-P-INTERFACE** (scheme + audit sealed; existence open) — not `P-F`, not `N-F`, not `F-LOCAL-SOLUBLE`, not `F-STOP` (the conic criterion remains terminal) |

`F-STOP` would apply only if no terminal local–global criterion remained. The
conic criterion remains terminal; what remains is existence of an F-point on
the scheme, not a missing theorem shape.

---

## 9. Files

```text
certificates/fixed_frame_arithmetic/TERMINALITY_AUDIT.md
certificates/fixed_frame_arithmetic/conic_algebra_scheme.md
certificates/fixed_frame_arithmetic/conic_algebra_inputs.json
certificates/fixed_frame_arithmetic/conic_algebra_verify.py
certificates/fixed_frame_arithmetic/SEAL.json
tmp/pathF_frame/          (scratch producer + digests)
```
