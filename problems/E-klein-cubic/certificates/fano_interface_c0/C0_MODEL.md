# C0.1 — Executable representation choice and resource floor

**Packet:** `certificates/fano_interface_c0`  
**Date:** 2026-07-31  
**Track:** C0 (WORKORDER_CAS_AFTER_5E72D8E.md §5)  
**Exit:** `C0-UNDECIDED`  
**Headline:** **OPEN**

---

## 0. Scope fence (binding)

This dispatch installs **no** executable quaternion symbol, **no** explicit
Hermitian matrices, and **no** descended Plücker generators over `K_proj`.
It records the deliberate C0.1 choice, the reason neither option lands inside
the resource fence, and the **smallest exact system** whose installation would
constitute `C0-MODEL-PASS`.

Resource fence (work order §5 / brief): under 4 GiB, under a few minutes per
job; no raw five-equation elimination; no memory-saturating Gröbner. Writes
only under `certificates/fano_interface_c0/` and `tmp/c0_*/`.

Binding corrections: `BRIDGE_AUDIT.md` Gate 1 = `FAIL-SCOPE`; `REPAIR.md`
§§13–14; idempotent ↛ Fano point.

---

## 1. The two C0.1 options (from the work order)

| Option | Deliverable |
|---|---|
| **1** | Exact `D = (a,b)_{K_proj}` with `a,b` in the executable `K_proj` model, five matrices `h_1,…,h_5 ∈ Herm_3(D)`, and the common-isotropic equations |
| **2** | Exact descended restricted Plücker / rank-one equations for `F_{14,T}` over `K_proj` |

Both are accepted by the work order. After a splitting extension of `D` (or of
`A_proj`), the installed model must recompute as the classical smooth degree-14
Fano threefold (dimension 3, degree 14, smooth). A model that fails that check
is wrong.

---

## 2. Deliberate choice: **prefer Option 1**, install neither

### Why Option 1 is preferred for the next install attempt

1. **It is the live arithmetic gate.** The reduced system already named in
   `quaternion_corner.*` and `IDEMPOTENT_TO_KLEIN_POINT.md` §5 is

   ```text
   F_r(x,y) = h_r((1,x,y),(1,x,y)) = 0,   r = 1..5,
   x,y ∈ D = (a,b)_{K_proj},
   ```

   eight scalar unknowns, five scalar equations, expected dimension three.
   Option 1 is exactly that system with certified coefficients.

2. **The split-model check is cheap once matrices exist.** Base-change
   `D ⊗ L ≅ M_2(L)`, rewrite the five Hermitian forms as ordinary
   alternating / Plücker hyperplanes in `Gr(2,6)_L`, and recompute dimension,
   degree, and smoothness of the linear section (independent verifier; no
   import of the producer). Classical geometry supplies the expected
   invariants; the check is finite linear algebra plus a standard Macaulay2 /
   Singular degree computation on a *split* fibre, not a twisted elimination.

3. **It consumes the specific Klein input.** The five-plane `H_T` is the
   descent of `B_5 ⊂ ∧² V_6^*`. Any symbol `(a,b)` unrelated to the Schur
   class of `T_proj`, or any five-plane not equal to that descent, is out of
   scope (brief §3.5 trap).

### Why Option 2 is not preferred (but is equally valid later)

Option 2 writes `F_{14,T}` as

```text
Y_T = SB_2(A_proj) ∩ P(B_{5,T}^⊥)  ⊂  P( (∧² V_6)_T ) ≅ P^{14}_{K_proj},
```

with the ambient projective space **honest** (Plücker obstruction is
`2 α_proj = 0`; accepted in `tmp/fano14_twist/REPORT.md` §1). The five
hyperplanes are `K_proj`-rational linear forms. The remaining equations are
the defining ideal of `SB_2(A_proj)` inside that `P^{14}` — Galois twists of
the classical Plücker quadrics, equivalently the reduced rank-one locus in
`Herm_3(D)` after Morita.

Thus Option 2 still requires either:

- an explicit multiplication table / cocycle for `A_proj` acting on the
  honest 15-space, or
- the same Morita data as Option 1.

It does **not** avoid the descent bottleneck. Its only advantage is that the
split-model check can cite the classical Plücker ideal of `Gr(2,6) ∩ P^9`
without choosing a quaternion chart.

### Cost of the road not taken (Option 2 alone)

| Item | Estimate |
|---|---|
| Install explicit `A_proj` (36-dim CSA over executable `K_proj`) with `σ` | same order as Option 1 steps 1–2 below; dominant cost |
| Five linear forms `B_5^⊥` in the honest 15-space | modest once representation alignment exists |
| Ideal of `SB_2(A)` in `P^{14}` | classical Plücker after splitting; twisted form needs cocycle or Morita |
| Split check dim/deg/smooth | standard, minutes, low memory |
| Net vs Option 1 | **comparable descent cost**; slightly cheaper verification narrative; slightly more awkward for the common-line solve |

---

## 3. Why neither option installs in this dispatch

Accepted state (do not re-derive):

| Fact | Source |
|---|---|
| `period(A_proj)=index(A_proj)=2` ⇒ `A_proj ≅ M_3(D)` abstractly | `BRIDGE_AUDIT.md` §1 |
| Explicit symbol `(a,b)` over executable `K_proj` **not** installed | `quaternion_corner.json` `"explicit_symbol_installed": false` |
| Explicit `H_1,…,H_5` **not** installed | same |
| Local `V_4` model gives `(p²,q²)`-type parameters after odd base change — **not global** | `quaternion_corner.md` §1; `tmp/pfaffian_explicit_descent/REPORT.md` §2 |
| Executable `K_proj` arithmetic exists (`tmp/kproj_arithmetic/`) | descent report §2 |
| Split Schur `V_6` and `B_5 ⊕ B_10` exist at good primes / over `Q(ζ_11)` matrices in upstream Magma source | `tmp/fano14_twist/` |

**Blocking missing inputs for Option 1** (dependency graph from
`tmp/pfaffian_explicit_descent/REPORT.md` §3, still open):

```text
Step 1. Align cyclic Klein module of K_proj with B_5 ⊂ ∧² V_6^*
        (characteristic-zero intertwiner; pin generator words).
Step 2. Descend A_proj = (End(V_6) ⊗ L)^G as a 36-dimensional K_proj-algebra
        with symplectic involution σ.
Step 3. Morita: find σ-self-adjoint reduced-rank-two e; set D = e A e;
        extract (a,b) from anticommuting pure quaternions.
Step 4. Transport B_5 → H_T ⊂ Herm_3(D); verify Moore/Pfaffian recovers
        the certified twisted Klein cubic.
Step 5. (Out of C0.1; is the point problem) common isotropic line.
```

Steps 1–3 are exact linear algebra and Galois descent over a degree-660
cover relative to `K_proj`, or an equivalent cocycle construction. They are
**not** a few-minute structural job. Step 3 still needs coordinates of `e` in
an installed frame (abstract existence of `e` is accepted; coordinates are
not). Local `(p²,q²)` models after the odd `V_4` change are refused as global
symbols (recorded caution).

**Blocking missing inputs for Option 2:** Steps 1–2 above, plus an explicit
description of `SB_2(A_proj) ⊂ P^{14}_{K_proj}`. No lighter path was found
that stays inside the fence.

Installing a **placeholder** symbol or five numeric matrices without certified
`e` / cocycle would violate the house rule against asserting what might be
false (`quaternion_corner.md` §2: refused). This track does not manufacture
placeholders.

---

## 4. Smallest exact system for `C0-MODEL-PASS`

### System S1 (Option 1 — preferred install target)

```text
Ring / field:   executable model of K_proj
                (tmp/kproj_arithmetic: 12-dim over Q(t3,t6,t8,t11), or
                 monogenic packaging over F = C(A,B,Y,Z) with [K_proj:F]=6
                 when that model is the active arithmetic base)

Data:
  a, b ∈ K_proj^×
  D = (a,b)_{K_proj} = K⟨i,j⟩ / (i²-a, j²-b, ji+ij)
  H_r ∈ M_3(D),   H_r^* = H_r,   r=1..5
  span_K {H_1,…,H_5} = H_T   (descended Klein five-plane)

Equations of F14_T in the chart q=(1,x,y):
  F_r(x0,x1,x2,x3, y0,y1,y2,y3) := h_r((1,x,y),(1,x,y)) = 0
  (five polynomials in K_proj[x•,y•], each of weighted degree 2 in the
   quaternion coordinates)

Split-model check (mandatory for C0-MODEL-PASS):
  L / K_proj splitting D
  F14_L  ≅  Gr(2,6)_L ∩ P(B_10)_L
  recompute: dim = 3, deg = 14, Sing = ∅
```

### System S2 (Option 2 — alternative)

```text
Ambient:   P^{14}_{K_proj} = P( honest 15-space of descended ∧² )
Linear:    five K_proj-hyperplanes ℓ_1=…=ℓ_5=0 cutting P(B_5^⊥)
Nonlinear: ideal I_SB of SB_2(A_proj) inside that P^{14}
           (15 twisted Plücker quadrics, or rank-one Hermitian conditions)

F14_T = V(I_SB + (ℓ_1,…,ℓ_5))
Split check: same classical F14 invariants after A_proj splits.
```

### Resource floor to install S1 (or S2)

| Stage | Nature | Floor (order-of-magnitude) |
|---|---|---|
| Representation alignment (Step 1) | exact linear algebra over `Q(ζ_11)`; modular checks at good primes ≠ 67 | minutes–tens of minutes; ≪ 4 GiB if done with sparse matrices / modular CRT |
| Descent of `A_proj` (Step 2) | 36×36 structure constants over `K_proj` or cocycle | main cost; may need multi-hour exact arithmetic; memory depends on presentation of `K_proj` (prefer monogenic over `F` if available) |
| Morita + symbol (Step 3) | idempotent search in 15-dim `Sym(A,σ)` or algebra construction | potentially large if done as raw cubic solve in 15 vars; **prefer abstract Gram–Schmidt coordinates once a concrete Morita frame is written**, not a blind Gröbner |
| Transport + Moore check (Step 4) | matrix algebra over `D` | minutes once Steps 1–3 done |
| Split dim/deg/smooth check | Macaulay2 / Singular on classical linear section | minutes, low memory |

**Fence note.** Step 2 is the genuine resource floor for `C0-MODEL-PASS`. It
is outside this dispatch’s low-memory structural mandate. Steps 1 and 3 admit
modular discovery; characteristic-zero reconstruction must implement final
congruence checks and a holdout prime (house rule; never SymPy’s private
rational reconstruction; never sole fibre `p=67`).

**Not in the floor for C0.1:** solving `F_1=…=F_5=0` for a `K_proj`-point.
That is Track C beyond model install (`C-FANO-POINT`), and work order §5
orders structural fibration search **before** raw elimination.

---

## 5. What would **not** count as `C0-MODEL-PASS`

| Artefact | Why rejected |
|---|---|
| Abstract existence of some `(a,b)` from `index=2` | already known; not executable |
| Local `(p²,q²)` after `V_4` base change | not global over `K_proj` |
| Coordinates of a Morita projector / point of `P²_D` | `FAIL-SCOPE`; auxiliary |
| Auxiliary Pfaffian cubic point in `Sym(A,σ)` | `REPAIR.md` §13 |
| Split classical Plücker equations alone | missing twist / descent data |
| Five isotropic vectors for the five forms separately | individual isotropy already proved; not a common line |

---

## 6. Decision

```text
C0.1 option chosen for future install:  Option 1 (quaternion + H_T)
C0.1 installed this dispatch:           neither
Exit contribution:                      C0-UNDECIDED
```

**Headline:** OPEN.
