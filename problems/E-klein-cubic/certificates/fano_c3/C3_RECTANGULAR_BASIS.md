# C3.0 — Maximal-étale rectangular basis for `A_proj`

**Packet:** `certificates/fano_c3`  
**Date:** 2026-07-31  
**Work order:** `WORKORDER_CAS_T11_P25V_C3.md` §0, §1.8, §2.10, §5 C3.0–C3.1, §7–§9  
**Exit C3.0:** `C3-RECTANGULAR-BASIS-MODULAR`  
**Exit C3.1:** `C3-RECONSTRUCTION-UNDECIDED`  
**Headline:** **OPEN**

---

## 0. Scope fence

**In scope.** C3.0 modular rectangular basis; C3.1 reconstruction **preflight** and
low-degree probes only.

**Out of scope.** C3.2 (involution, Morita, Hermitian); C3.3 (common isotropic line).
Both gated on `C3-APROJ-EXECUTABLE`. Writes only under `certificates/fano_c3/` and
`tmp/c3_*/`.

**Binding correction §2.10.** C2.1's low-degree failure does **not** justify
entrywise reconstruction of the 36-word regular representation. Maximal-étale
compression first.

---

## 1. Idea (§1.8)

Let `a ∈ A` have separable minimal polynomial of degree six and put `E = K[a]`.
Then `E` is a maximal étale subalgebra and `A` is free of rank six as a right
`E`-module. If `1,b,...,b^5` is a right `E`-basis, the rectangle
`{b^j a^i : 0 ≤ i,j < 6}` is a `K`-basis, and left multiplications are `6×6`
matrices over `E`.

**Compressed data:** at most 42 elements of `E` plus six minimal-polynomial
coefficients — against 2592 `K`-entries (C2.1) or 46656 structure constants.

---

## 2. Pair

| Item | Value |
|---|---|
| Source | sealed C2.0 pure frame pair |
| `a` | `e_{1}` |
| `b` | `e_{2}` |
| Search | sealed pair first; no RNG |
| Sealed pair succeeded | `True` |

---

## 3. Primary witness `p = 23`

| Check | Result |
|---|---|
| Frame det | 6 |
| Minpoly degree of `a` | **6** |
| Separable | **True** |
| Minpoly coeffs | `[14, 0, 18, 2, 16, 0, 1]` |
| Rectangle det (M6) | **5** |
| Rectangle det (frame) | **20** |
| `b^6` identity | ok |
| `L_a` identity | ok |

---

## 4. Secondary witness `p = 89` (`≡ 1 mod 11`, not 67)

| Check | Result |
|---|---|
| Frame det | 5 |
| Minpoly degree | **6** |
| Separable | **True** |
| Minpoly coeffs | `[65, 38, 0, 0, 50, 0, 1]` |
| Rectangle det (M6) | **58** |
| Rectangle det (frame) | **65** |

Holdout modular `p = 199`: det_m6 = 187, success = True.  
Holdout probe `p = 463`: det_m6 = 228, success = True.

---

## 5. C3.1 low-degree probes (summary)

Degree-probe prime `p = 353`, samples = 918.
Ansatz: each compressed `K`-coordinate expands as
`x = Σ_{k=0..11} r_k(t)·β_k` in the certified free basis of `K_proj/P_0`,
with each `r_k` a total-degree ≤ `D` polynomial in `(t_3,t_6,t_8,t_11)`.
Max `D` tested: **4** (840 unknowns; same method as C2.1).

| Block | entries | floor 0 | floor 1–4 | floor ≥5 | unmeasured |
|---|---:|---:|---:|---:|---:|
| minpoly (6) | 6 | 1 | 0 | 5 | 0 |
| e_coords (36) | 36 | 31 | 0 | 5 | 0 |
| La_E (216) | 216 | 36 | 0 | 180 | 0 |

Measured entries with free-module floor ≥ 5: **190**; with floor ≤ 4: **68**.

C2.1 proved a degree floor ≥ 5 for ~1249 varying shortlex entries. Compression
does not magically lower every degree, but cuts the object count from 2592 to
~258 `K`-coordinates (42 `E`-elements + 6 minpoly coeffs). **No fallback to the
36³ table** (§2.10).

Full `C3-APROJ-EXECUTABLE` requires actual multi-prime adaptive reconstruction
over the rank-12 model; this round stops at preflight + probes →
`C3-RECONSTRUCTION-UNDECIDED`.

---

## 6. Theorem boundary

**Proved (modular).** The pure Reynolds-frame pair `(e_1, e_2)` has separable
degree-six minimal polynomial for `a` and a unit rectangular-basis determinant
at the sealed `F_23` and `F_89` witnesses (and modular holdouts).

**Not proved.** `m_a`, `e_j`, `L_a` over `K_proj`; involution; Morita corner;
quaternion symbol; five Hermitian matrices; restricted Plücker; any point of
the genuine twisted Fano section `F_{14,T}`. Problem E remains **OPEN**.

**Trap named.** A construction valid for an arbitrary degree-six CSA over an
arbitrary field is too weak for C3.2/C3.3 — that generality yields individual
isotropy and fails to give a common line. This packet only seals the rectangular
model of the specific descended `A_proj` frame.

**Language.** No claim that “the cubic has a `K_proj`-point abstractly”; no claim
that “the generic Schur twist has no rational point.” No auxiliary projector is
a Fano point.

---

## 7. Deliverables

```text
certificates/fano_c3/
  C3_RECTANGULAR_BASIS.md
  rectangular_basis.json
  rectangular_basis.npz
  preflight_c31.json
  exit_c3.json
  produce_c3.py
  verify_c3.py
```

Scratch: `tmp/c3_preflight/`, `tmp/c3_work/`.

**Peak RSS (producer):** ~234.91 MiB.  
**Elapsed:** ~42.119 s.
