# T11.1 — Exact local chart / generic fibre (status)

**Exit:** `T11-FOLD-UNDECIDED`  
**Prior exit:** `T11-MODULAR-SIMPLE-POINT` (sealed)  
**Headline:** **OPEN**  
**Object:** fold singular locus `Sing(S_G)` — **not** the target branch `B`  
**Heavy slot:** claimed (`preflight_t111.json`); peak measured RSS on completed exact jobs **≲ 336 MiB** (M2 sequential sat); generic frac-field GB **not completed**

---

## 1. Criterion recalled

A theorem of horizontal height one requires either:

- exact ideal equality `(I_sing)_Δ = (g1,g2,g3)_Δ` over `Q(x_i,x_j)` (Route A / C), or  
- one **exact** nonempty finite algebra over some `Q(x_i,x_j)` after gate localization (Route B).

A nonempty **specialized** fibre — modular or even exact over `Q` at integer `(A,u)` — is **not** by itself `(T-chart)` / `T11-FOLD-HEIGHT1`.

---

## 2. What was completed

### 2.1 Modular simple point (`T11-MODULAR-SIMPLE-POINT`)

At `(A,u)=(63,35)`, `p=101`, after gate-product Rabinowitsch:

| Item | Value |
|---|---|
| Fibre degree | **6** (square-free RUR) |
| Selected point | `(B,Y,Z)=(74,15,15)` over `F_101` |
| Gates | all nonzero (`ell,C,P_uu,delta,L,M,Q4,F27,G`) |
| Selected triple | `(P_B, P_Y, P_Z)` |
| Jacobian minor `Δ` | **5 ≠ 0** |
| Multiplicity | **1** |

Artifacts: `MODULAR_SIMPLE_POINT.md`, `modular_point.json`, `verify_modular_point.py`.

### 2.2 Exact specialized fibres over `Q` (Route B specialized)

Using Macaulay2 over `QQ`, generators specialized at integer `(A,u)`, sequential saturation

```text
I ← (P, P_u, P_A, P_B, P_Y, P_Z)
I ← sat(I, B); sat(I, ell); sat(I, Q4); sat(I, P_uu); sat(I, C); sat(I, delta)
```

(never an expanded full gate product as a single GB input polynomial):

| `(A,u)` | raw dim / deg | sat dim / deg |
|---|---|---|
| `(63,35)` | 1 / 5 | **0 / 6** |
| `(0,1)` | 1 / 5 | **0 / 6** |
| `(2,3)` | 1 / 5 | **0 / 6** |
| `(10,10)` | 1 / 5 | **0 / 6** |
| `(100,50)` | 1 / 5 | **0 / 6** |
| `(5,7)` | 1 / 5 | **0 / 6** |
| `(-1,2)` | 1 / 5 | **0 / 6** |
| `(20,7)` | 1 / 5 | **0 / 6** |

All eight tested integer specializations give a **nonzero finite** algebra of degree **6** over `Q`.  
At the sealed modular chart value `(63,35)`, this is an **exact** (characteristic-zero specialized) degree-6 fibre through the Hensel chart of T11.0.

Artifacts: `specialized_exact_fibres.json`, `verify_specialized_exact.py`.

**Correction applied:** `msolve` characteristic-0 solve mode reported empty on the same specialized systems (false empty under large integer coefficients). M2 over `QQ` is the trusted engine for these specialized fibres.

### 2.3 Route A status

Selected chart gens `(P_B, P_Y, P_Z)` alone are **positive-dimensional** mod 101 (degree 39 after gate sat), so the full `I_sing` component through the simple point is a proper subscheme of `V(P_B,P_Y,P_Z)`. Parametric `std(P_B,P_Y,P_Z)` over `Q(A,u)` was launched (Singular) and did not finish within the exploratory window.

---

## 3. What remains (smallest exact floor)

```text
BOTTLENECK-T111-GENERIC-QAu-ALGEBRA
```

Named next computation:

1. **Preferred:** exact finite `Q(A,u)`-algebra of degree 6 for  
   `I_sing : (ell · C · L · M · Q4 · P_uu · delta · G)^∞`  
   in `(B,Y,Z)`, via either  
   - frac-field GB / sequential sat over `frac(QQ[A,u])`, or  
   - monic degree-6 eliminant with coefficients in `Q(A,u)` obtained by rational interpolation from the specialized fibres above (with independent holdout specializations and direct reduction checks).
2. Prove remaining generators have normal form zero on that algebra; prove gates and a chart minor are units via **norms** (no expanded gate product).
3. Only then seal `T11-FOLD-HEIGHT1`.

The specialized exact degree-6 ledger is Zariski-suggestive (integer points are dense) but is **not** promoted to a function-field theorem in this packet.

---

## 4. Routes A / B / C — how far

| Route | Progress |
|---|---|
| **A** (localized equality for `(P_B,P_Y,P_Z)`) | Modular chart minor sealed; triple alone too big; parametric GB unfinished |
| **B** (full generic fibre, factorwise sat) | **Specialized** exact deg-6 over `Q` at ≥8 integers; **generic** `Q(A,u)` unfinished |
| **C** (localized syzygies) | Not started (gated on A/B algebra) |

Finite algebra dimension over `Q(A,u)`: **not sealed** (expected 6 from modular + specialized).

---

## 5. Resources

| Job | Cap | Peak RSS (measured) |
|---|---|---|
| Modular simple point | 8 GiB | ≪ 1 GiB |
| M2 specialized sat fibres | 8–16 GiB | **~336 MiB** |
| Generic frac-field M2 | 64 GiB authorized | not completed (script init / no finish) |

Heavy slot: **claimed** in `preflight_t111.json`. No 96 GiB request.

---

## 6. Theorem boundary

| Object | Claim | Status |
|---|---|---|
| Target branch `B` | nonnormal; binodal node contributes no 3-primary local Picard class | **sealed previously** (`T-BRANCH-NONNORMAL`, `T10-BINODAL-NO-3-DEFECT`) — unchanged |
| Fold `S_G` | 3-dimensional CI, `S_2`, `dim Sing ≤ 2` | **accepted** |
| Fold `S_G` | modular + exact specialized degree-6 `(A,u)`-fibres | **recorded** (this track) |
| Fold `S_G` | exact horizontal 2-dimensional singular component / nonnormal | **not proved** |

---

## 7. Exit

```text
T11-MODULAR-SIMPLE-POINT
T11-FOLD-UNDECIDED
```

**Headline:** **OPEN**
