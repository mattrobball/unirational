# C1.1 — Descent-interface preflight for the genuine twisted Fano model

**Packet:** `certificates/fano_c1`  
**Date:** 2026-07-31  
**Work order:** `WORKORDER_CAS_T9_P25Z.md` §0, §2.7–§2.8, §5 C1.1, §7, §8, §9  
**Exit:** `C1-UNDECIDED`  
**Headline:** **OPEN**

---

## 0. Scope fence (binding)

This dispatch is **C1.1 preflight only** (work order §7: Worker C). Resource fence:
under 4 GiB, jobs of minutes; no memory-heavy slot (Worker T holds that). Writes only
under `certificates/fano_c1/` and `tmp/c1_*/`.

**In scope.** Get as far as is cheap toward executable `A_proj`, Morita corner and
quaternion symbol, five Hermitian matrices, restricted Plücker equations; name the
remaining exact system and its resource floor.

**Out of scope.** C1.2 (common-isotropic-line search / elimination). Morphism-fibration
and odd-degree-Brauer searches already closed by C0 (forbidden to repeat as if open).

**Sealed, read-only.** `certificates/fano_interface_c0/`, `certificates/pfaffian_point/`.

**Binding corrections carried.** Gate 1 `FAIL-SCOPE` (idempotent ↛ Fano point);
`REPAIR.md` §§13–14 language; codimension-five section is the real content; trap of
arbitrary-five-plane arguments.

---

## 1. Target (and non-targets)

```text
Target:     F_{14,T}(K_proj) ≠ ∅     # genuine twisted degree-14 Fano section
Not target: auxiliary Pfaffian cubic {c_3=0, c_2≠0} ⊂ Sym(A,σ)
Not target: Morita projectors I_σ ⊂ P²_D ≅ SB_2(A)
Not target: bare points of P²_D
```

```text
dim P²_D = 8,   five scalar conditions,   expected dim F14_T = 3.
```

A construction that produces a point of `P²_D` and stops has done nothing
(`BRIDGE_AUDIT.md` Gate 1).

---

## 2. C1.1 five steps — status this dispatch

| # | Step | Status | Evidence / location |
|---:|---|---|---|
| 1 | Executable `A_proj` over `K_proj` | **Partial** | Vector-space frame + modular multiplication path; **no** char-0 structure constants in the rank-12 `K_proj` model |
| 2 | Morita corner + exact `D=(a,b)_{K_proj}` | **Not installed** | `quaternion_corner.json` still `"explicit_symbol_installed": false` |
| 3 | Five Hermitian matrices `h_1,…,h_5 ∈ Herm_3(D)` | **Not installed** | same; refused without certified `e` / cocycle |
| 4 | Restricted Plücker / rank-one equations | **Not installed** | needs `A_proj` cocycle or Morita data (Option 2 of C0) |
| 5 | Split-fibre dim 3 / deg 14 / smooth of classical `F_14` | **Not run** | requires installed matrices / Plücker generators |

**Exit.** Not `C1-MODEL-PASS` (needs all five). Honest exit: **`C1-UNDECIDED`** with
smallest exact system and resource floor named (work order §8.13).

---

## 3. What is already closed upstream (do not re-derive)

Consumed, hash-pinned, not re-proved:

| Fact | Source |
|---|---|
| `period(A_proj)=index(A_proj)=2` ⇒ abstractly `A_proj ≅ M_3(D)` | `certificates/pfaffian_point/BRIDGE_AUDIT.md` |
| `SB_2(A) ≅ P²_D` rational, chart `D²` | same |
| Individual isotropy of every `h ∈ H_T` (Springer + degree-55) | `tmp/pfaffian_explicit_descent/REPORT.md` |
| Common line open | same |
| Abstract σ-self-adjoint reduced-rank-two idempotent exists | `BRIDGE_AUDIT` / hostile audit |
| **Step-0 alignment:** exact `B_5` intertwiner over `Q(ζ_11)`; generator words `A→TSTS`, `B→T^8S`; `End(V_6)=1+11+12a+12b` | `tmp/pfaffian_representation_alignment/` |
| **36 weight-zero Reynolds seeds** give a `K_proj`-vector-space basis of `A_proj` (existence of frame; not a multiplication table) | same, `certificate.json` / `end36_frame.py` |
| Executable `K_proj` arithmetic (12-dim over `Q(t_3,t_6,t_8,t_11)`) | `tmp/kproj_arithmetic/` |
| C0 preferred Option 1; system **S1**; exit `C0-UNDECIDED` | `certificates/fano_interface_c0/` |

C0 placed “descent of `A_proj`” outside its structural fence. Representation
alignment has since closed the **vector-space layer**. The remaining gap for
C1.1 step 1 is the **algebra layer** (structure constants + involution).

---

## 4. Cheap progress installed this dispatch

### 4.1 Replay of representation alignment

```text
tmp/pfaffian_representation_alignment/verify.py
→ PFAFFIAN_REPRESENTATION_ALIGNMENT_EXACT
peak RSS ≈ 91 MiB, ≈ 26 s
```

Confirms: exact intertwiner rank 5; character decomposition; 36 seeds;
projective determinant 6 mod 23.

### 4.2 Modular multiplication path at the certified `F_23` witness

Scratch: `tmp/c1_preflight/modular_mul_probe.*`,
`tmp/c1_preflight/structure_constants_f23.npz`.

At the same witness `(1,2,3,4,5)` and seeds as the alignment certificate, the
36 projective Reynolds evaluations (scaled by `f_(14-d)/f_14` at the point)
span a **36-dimensional associative unital `F_23`-subalgebra of `M_6(F_23)`**:

| Check | Result | Code path |
|---|---|---|
| Basis det mod 23 | 6 (matches projective det) | Gauss elimination over `F_23` |
| All 1296 products close in the span | yes | matrix mult + solve |
| Associativity, 80 random triples | 0 failures | structure constants |
| Identity in span; left mult = id | yes | `I_6` projects with 1 nonzero coeff |
| `tr(I)=6` | yes | matrix trace |
| Elapsed / peak RSS | ≈ 0.21 s / ≈ 82 MiB | process rusage |

**Specific input consumed:** PSL(2,11) generator alignment words, Schur matrices
from `fano_covariant_scan`, Weil matrices mod 23, Reynolds seeds from the
alignment certificate. This is **not** an arbitrary 36-dim matrix algebra test.

**Theorem boundary of the probe.** Specialized CSA structure constants at one
good prime. Validates that the modular install path for the multiplication table
is sound. Does **not** install `A_proj` over `K_proj`, a symbol `(a,b)`,
Hermitian matrices, Plücker generators, or a Fano point.

### 4.3 Orbit lattice (director correction absorbed)

Independent GAP 4.15.1 recompute (`tmp/c1_preflight/gap_orbit_degrees.txt`):

```text
order-12 subgroups: 110 = 55×A_4 + 55×D_12, both index 55
n_11 = 12, n_5 = 66
orbit degrees 55, 60, 132; gcd = 1
```

C0’s “all order-12 are `A_4`” is false; the load-bearing degree-55 `A_4` cycle
and the gcd remain correct (`DIRECTOR_CORRECTION_C0.md`).

---

## 5. Smallest exact system for `C1-MODEL-PASS`

Retain C0’s **System S1** (Option 1) as the preferred install target, refined
with the closed vector-space layer.

### System S1 (quaternion + `H_T` — preferred)

```text
Ring / field:   executable K_proj
                (tmp/kproj_arithmetic: 12-dim over Q(t3,t6,t8,t11))

Prerequisite (closed as vector space):
  36 weight-zero Reynolds seeds for A_proj
  exact B_5 intertwiner J over Q(ζ_11)

Still required:
  (1a) structure constants c_{ij}^k ∈ K_proj for the 36-frame
       (associative unital CSA of degree 6)
  (1b) symplectic involution σ in that basis
  (2)  Morita: σ-self-adjoint reduced-rank-two e; D = e A e = (a,b)_{K_proj}
  (3)  H_r ∈ Herm_3(D), r=1..5, transport of aligned B_5
  (4)  optional independent Plücker form (Option 2) as cross-check
  (5)  split L/K_proj of D: recompute dim=3, deg=14, Sing=∅ of classical F_14

Live equations after install (C1.2, not this dispatch):
  F_r(x,y) = h_r((1,x,y),(1,x,y)) = 0 in K_proj[x•,y•]
```

### System S2 (Option 2 — Plücker / rank-one)

```text
P^{14}_{K_proj} honest; five K-hyperplanes; ideal of SB_2(A_proj).
Still needs (1a)–(1b) or an equivalent cocycle. Not cheaper for step 1.
```

---

## 6. Resource floor for the remaining install

| Stage | Nature | Measured / estimated floor |
|---|---|---|
| VS frame + alignment | already installed | replay ≈ 26 s, ≈ 91 MiB |
| Modular multiplication path | this dispatch | ≈ 0.2 s, ≈ 82 MiB at `p=23` |
| **(1a) char-0 structure constants in `K_proj`** | **dominant remaining cost** | see below |
| (1b) involution σ | linear algebra once (1a) exists | minutes, low memory |
| (2) Morita + `(a,b)` | idempotent in 15-dim `Sym(A,σ)` or algebra construction; **prefer Gram–Schmidt in a concrete frame**, not blind 15-var Gröbner | potentially large if naive; modest if framed |
| (3)–(4) transport / Plücker | matrix algebra over `D` | minutes after (2) |
| (5) split dim/deg/smooth | Macaulay2 / Singular on classical linear section | minutes, low memory |

### Floor for (1a) — structure constants over `K_proj`

- Count: up to `36³ = 46656` constants; modular density ≈ 90% nonzero at the
  `F_23` fibre ⇒ expect a **dense** table, not a sparse miracle.
- Each constant lives in the rank-12 model of `K_proj` over
  `P_0=Q(t_3,t_6,t_8,t_11)`.
- Sample cost of a single “dense-ish” product inside `K_proj` (this dispatch):
  ≈ 8.7 s, ≈ 124 MiB, output ≈ 4.6×10⁵ characters for one product of two
  random-looking 12-vectors with polynomial coefficients. **Not** a full
  structure-constant entry (those need Reynolds reduction / projection), only a
  lower bound on arithmetic cost inside the field model.
- Naive path: form all weight-zero Reynolds products symbolically (orbit size
  660, degrees ≤ 14) and project onto the 36-frame over `K_proj` → multi-hour
  exact arithmetic; memory sensitive to intermediate expression swell.
  **Outside the 4 GiB / minutes fence of this preflight.**
- Preferred install path for a later authorized dispatch:
  1. Modular structure constants at several good primes `p ≠ 67` (path validated
     here at `p=23`);
  2. Specialization of invariant parameters + CRT / rational reconstruction with
     **implemented final congruence check and holdout prime** (house rule);
  3. Associativity + reduced-norm identity checks over `K_proj` as the decisive
     verifier invariants.
- Optimization recorded but not used: character identity
  `End(V_6)=End(W)+11` may rebuild 25 of 36 dimensions from the installed
  Klein module / Hilbert–90 frame (`alignment REPORT` §5).

**Fence decision.** Installing (1a) is the genuine resource floor for
`C1-MODEL-PASS`. It requires a dedicated dispatch with a written memory envelope
(suggested exploratory 8 GiB per work order §8, staggered against T9/P25Z heavy
slots). This preflight correctly stops without starting that job.

**Local trap restated.** `V_4` base change yields `(p²,q²)`-type symbols after
an odd extension — **not** global over `K_proj` (`quaternion_corner.md` §1).
Do not ship them as the C1.1 symbol.

---

## 7. Corrections 1 and 2 — do they reopen a route?

### 7.1 Correction 1 (work order §2.7): Picard rank vs birational links

**C0 closed:** nontrivial fibrations as *morphisms* on the prime model `F_14`
(`ρ=1` ⇒ no conic bundle / rational fibration / del Pezzo fibration as morphisms;
hence none descend).

**C0 did not close:** birational links after modification, Sarkisov links, or
fibrations on a blowup/flip of `F_{14,T}`.

**Structural answer for later dispatch (no elimination here).**

| Candidate | Why it is not ruled out by `ρ=1` | Specific input it would need | Preflight recommendation |
|---|---|---|---|
| Gal-stable Sarkisov link / blowup along a curve on `F_{14,T}` | After blowup, Picard rank rises; a Mori fibre space can appear | A **Gal-stable** centre (curve or subscheme over `K_proj`), not merely a geometric curve | Worth a later **structural** C1.2 sub-dispatch: classify low-degree Gal-stable subvarieties (e.g. orbits of lines/conics fixed by `A_4`/`D_12` stabilizers). No Gröbner until a centre is named |
| Incidence `P¹`-bundle with the Klein twist | Already accepted descriptive geometry; not a new unirationality mechanism without a Fano point | — | Already used as Arrow B; not a shortcut past `F14_T(K)` |
| Re-search morphisms on the prime model | Ruled out by `ρ=1` | — | **Forbidden** (C0 closed; work order §5) |

So correction 1 **does** open a route C0 appeared to close if C0 is misread as
“no fibration exists in any birational model.” Correct reading: morphisms on
the prime model are closed; **birational models remain open and are authorized
for C1.2** (work order §5 C1.2 item 1). No such model is constructed here.

### 7.2 Correction 2 (work order §2.8): degree-55 and Brauer 2-torsion

**Closed lever (stays closed):** `cor∘res = ×55` is a unit on `Br[2]`, so the
odd-degree multisection does not kill `[D]`. Individual isotropy via Springer
still holds; common line still not given.

**Does not reopen** a Brauer-splitting path to a Fano point. The residual
problem remains the codimension-five common-isotropic-line system after the
model is installed.

---

## 8. What would **not** count as `C1-MODEL-PASS`

| Artefact | Why rejected |
|---|---|
| Abstract `(a,b)` from `index=2` only | already known; not executable |
| Local `(p²,q²)` after `V_4` | not global |
| Modular `F_23` structure constants alone | specialized fibre; not `K_proj` |
| Morita projector / point of `P²_D` | `FAIL-SCOPE` |
| Auxiliary Pfaffian cubic point in `Sym(A,σ)` | `REPAIR.md` §13 |
| Split classical Plücker equations alone | missing twist / descent data |
| Five separate isotropic vectors | individual isotropy already proved |

---

## 9. Decision

```text
C1.1 steps installed:     partial step 1 (VS frame upstream + modular mul path)
C1.1 steps preflighted:   (1a) char-0 structure constants, (1b) σ, (2)–(5)
Smallest exact system:    S1 (refined)
Resource floor:           char-0 (1a) structure constants over K_proj;
                          outside 4 GiB/minutes preflight fence;
                          modular path validated at p=23
Exit:                     C1-UNDECIDED
Birational reopen (corr.1): yes, for later C1.2 structural search only
Brauer reopen (corr.2):     no
```

**Headline:** OPEN.
