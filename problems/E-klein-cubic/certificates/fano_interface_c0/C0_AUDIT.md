# Track C0 — genuine twisted Fano interface (structural audit)

**Packet:** `certificates/fano_interface_c0`  
**Date:** 2026-07-31  
**Work order:** `WORKORDER_CAS_AFTER_5E72D8E.md` §0, §1, §5, §7, §8  
**Corrections:** `REPAIR.md` §13, §14; `BRIDGE_AUDIT.md` Gate 1 `FAIL-SCOPE`  
**Exit marker:** **`C0-UNDECIDED`**  
**Headline:** **OPEN**

---

## 0. Executive summary

Worker C ran Track C0 only: choose an executable representation of the genuine
twisted Fano section `F_{14,T}` (C0.1) and search for fibrations / multisections
/ homogeneous descriptions **before** any elimination (C0.2). Resource fence
respected: no five-equation elimination, no large Gröbner, writes only under
`certificates/fano_interface_c0/` and `tmp/c0_*/`.

**Outcomes.**

1. **C0.1:** Prefer **Option 1** (explicit `D=(a,b)` + five Hermitian matrices +
   common-isotropic equations). Neither Option 1 nor Option 2 can be installed
   inside this dispatch’s fence: the executable symbol and matrices remain
   placeholders (`quaternion_corner.json`). Smallest exact system and resource
   floor are named in `C0_MODEL.md`.
2. **C0.2:** Conic bundle, rational fibration, and del Pezzo fibration are
   **geometrically absent** on the split model (`ρ(F_{14})=1`) and therefore do
   not descend. The degree-55 odd multisection **does** descend as a zero-cycle
   and already gives individual isotropy of `H_T`; it does **not** give a common
   line and does **not** kill `[D]`. Ambient `P²_D` remains rational with points;
   the codimension-five section problem is untouched.
3. **Elimination:** Preflight only (`preflight_elimination.json`). Do not run
   until `C0-MODEL-PASS`.

No `C-FANO-POINT`. No auxiliary point is rebranded as a Fano point.

---

## 1. Target and non-targets

```text
Target:     F14_T(K_proj)  — genuine twisted degree-14 Fano section
Not target: auxiliary Pfaffian cubic {c3=0,c2≠0} ⊂ Sym(A,σ) ≅ A^{15}
Not target: Morita projectors I_σ ⊂ P²_D
Not target: bare points of P²_D ≅ SB_2(A)
```

Dictionary: `IDEMPOTENT_TO_KLEIN_POINT.md`, `quaternion_corner.md`,
`BRIDGE_AUDIT.md`.

**Codimension count (binding).**

```text
dim P²_D = 8,   five scalar conditions,   expected dim F14_T = 3.
```

Any construction that produces a point of `P²_D` and stops has done nothing
toward the headline (Gate 1 `FAIL-SCOPE`).

---

## 2. Binding corrections carried

| # | Correction | Source |
|---|---|---|
| 1 | Idempotent → Fano arrow **broken** | `BRIDGE_AUDIT.md` §0, §3 Arrow A |
| 2 | Never “the cubic has a `K_proj`-point abstractly” without “auxiliary Pfaffian characteristic cubic in `Sym(A,σ)`” | `REPAIR.md` §13 |
| 3 | Never “generic Schur twist has index one but no rational point” — only “no rational point is **currently known**” | `REPAIR.md` §14 |
| 4 | Real content is codimension-five section of rational 8-fold | brief §3.4 |
| 5 | Constructions must use specific structure of `H_T` / `PSL(2,11)` / degree-55 / descent data | brief §3.5 |

---

## 3. C0.1 choice (detail in `C0_MODEL.md`)

| Item | Decision |
|---|---|
| Preferred option | **Option 1** — `D=(a,b)_{K_proj}`, `h_1,…,h_5 ∈ Herm_3(D)`, equations `h_r(q,q)=0` |
| Why | Matches the live Gate-2 system; split check is classical; consumes Klein `H_T` |
| Cost of Option 2 | Comparable descent cost (still needs `A_proj` or Morita); slightly cleaner classical Plücker narrative; less convenient for the common-line solve |
| Installed this dispatch | **Neither** |
| Blocking input | Executable coordinates of Morita frame / cocycle; Steps 1–3 of `tmp/pfaffian_explicit_descent/REPORT.md` §3 |
| Local trap | `V_4` symbols of `(p²,q²)` type are not global |

---

## 4. C0.2 structure table (detail in `C0_STRUCTURE_TABLE.md`)

| Structure | Split model | Descends over `K_proj`? | Payoff if yes |
|---|---|---|---|
| Rational fibration | no (`ρ=1`) | no | — |
| Conic bundle | no (`ρ=1`) | no | would enable Problem-B-style unirationality; **unavailable** |
| Odd multisection (deg 55) | geometric points | **yes** as zero-cycle | individual isotropy only; **not** common line; **not** split `D` |
| Homogeneous space (Fano itself) | no useful | ambient `P²_D` yes / Fano no | ambient already rational |
| Low-degree rational section | dense over `C` | **open** | `C-FANO-POINT` |
| Linear section description | yes | yes (descriptive) | C0.1 Option 2 |
| Incidence to Klein cubic | yes | yes | Arrow B (needs Fano point) |

**Problem B check (read-only):** formalized mechanism is for smooth bidegree
`(2,3)` in `P²×P²`. `F_{14,T}` is not of that type. Hypotheses fail at the
geometric-type gate; no further criterion applies.

---

## 5. Elimination preflight (not run)

See `preflight_elimination.json`. Summary:

- **Prerequisite:** `C0-MODEL-PASS` with certified `H_T`.
- **Ring:** `K_proj[x0..x3,y0..y3]`, generators `F_1,…,F_5`.
- **Expected dimension:** 3; three affine charts; not a general CI.
- **Checkpoints:** modular discovery (two primes ≠ 67) → scoped exact work →
  substitution into original Hermitian equations.
- **Verifier:** independent; recomputes `h_r(q,q)`; split dim/deg/smooth
  recomputed; final congruence + holdout; no private SymPy reconstructor.
- **Director authorization** required before any memory envelope above the
  structural fence; must not collide with T8 / P25Y.

---

## 6. Theorem boundary (one paragraph)

**Proved in this packet.** (i) Neither executable C0.1 representation is
available from installed artifacts without crossing a named descent resource
floor; the preferred future install is Option 1, with Option 2 at comparable
cost. (ii) On the classical smooth degree-14 Fano threefold of genus 8 and
Picard number one, there is no conic-bundle, rational-fibration, or del Pezzo
fibration structure, so none descends to `F_{14,T}`. (iii) The degree-55
`A_4`-orbit multisection descends and, with Springer, accounts for individual
isotropy of every member of `H_T`, but the same lever cannot produce a common
isotropic `K_proj`-line or kill the quaternion class of `D`. (iv) Ambient
rationality of `P²_D` and abstract Morita points remain auxiliary (`FAIL-SCOPE`).
(v) An elimination preflight for the five Hermitian equations is recorded and
was **not** executed.

**Not proved.** Existence or nonexistence of a `K_proj`-point of `F_{14,T}`;
an explicit quaternion symbol or Hermitian matrices; emptiness of any chart of
the common-isotropic scheme; `ed_C(G)=3`; `G`-unirationality or its negation;
any headline exit.

---

## 7. Files

```text
certificates/fano_interface_c0/
  C0_AUDIT.md                 # this file
  C0_MODEL.md                 # C0.1 choice, systems S1/S2, resource floor
  C0_STRUCTURE_TABLE.md       # C0.2 table and lever analysis
  preflight_elimination.json  # elimination preflight only
  exit_c0.json                # machine-readable exit
  verify_c0.py                # independent structural verifier
  SEAL.json
  SHA256SUMS

tmp/c0_audit/
  gap_orbit_degrees.txt       # GAP recompute of 55,60,132
```

---

## 8. Intended commit split (director only; worker runs no git)

| Scope | Message |
|---|---|
| `certificates/fano_interface_c0/` | `E/C0: structural Fano interface audit — C0-UNDECIDED, no model install` |
| `tmp/c0_audit/` (if tracked) | `E/C0: GAP orbit-degree scratch for degree-55 multisection pin` |

Path-scoped only. Do not touch `CURRENT_PATHS.md`, `SPEC.md`, `HANDOFF.md`,
`RESOLUTION.md`, `REPAIR.md`, work orders, or `certificates/pfaffian_point/`.

---

## 9. Exit

```text
C0-UNDECIDED
```

Smallest exact system: **S1** in `C0_MODEL.md` (Option 1).  
Resource floor: representation alignment + descent of `A_proj` + Morita symbol
extraction (Steps 1–3), outside this structural fence.

**Problem E remains OPEN.**
