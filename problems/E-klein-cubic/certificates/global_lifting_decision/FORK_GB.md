# Path G Fork G-B — Construction side

**Headline: OPEN.**  
**Decision exit: `G-CONSTRUCTION`.**  
**Containment `G ⊆ R_3`: FALSE at tested bidegrees (1,7), (1,13), (3,19).**  
**All-degree open meeting: NOT CLAIMED** (item 3 only partial).  
**No formal lift is a covariant.**

---

## Director context

Gate G1 returned `G-SCOPED` with containment **FALSE** at `(1,7)`. Fork G-A is
off the table at that bidegree. This packet runs Fork G-B.

## 1. Persistence (item 1) — PASS

| bidegree | `dim B` | `dim G_witness` | open meeting | char-0 certificate |
|----------|--------:|----------------:|--------------|---------------------|
| (1,7) | 112 | 10 (G1) | CERTIFIED | max minor −2 on cols (0,1,2,5,8,11,14) at `a_triv` |
| (1,13) | 364 | 44 | CERTIFIED | rank 7, max minor −2 at free fibre (0,1,1,0) |
| (3,19) | 1224 | 160 | CERTIFIED | rank 13, max minor 8 at free fibre (0,1,0,0,0,0,1,0) |

**Correction.** Pure residual-`S_3`-trivial free fibre works at `m=1` but **drops
rank** at `m=3` (`rank L_3 = 9 < 13`). Open meeting at `(3,19)` uses general
points of the based residual G-witness (not the pure residual-triv subfamily).

No persistence failure — did not stop.

## 2. All-odd-`m` rank theorem (item 2) — PROVED

For every integer `m ≥ 0` and `r ∈ {1,3}`:

- generic rank `L_r = 3m+r+1` (full codomain),
- generic nullity `= 2r+2` (hence `null L_1 = 4`, `null L_3 = 8`),
- generic coker `= 0`.

**Proof mechanism:** at pure powers `a = y0^m f_0 + y1^m f_1`,
`L_r(b) = 2 b_0 y0^m y1^m + b_1 y1^{2m} + b_2 y0^{2m}`; the three
multiplication windows cover all binary monomials of degree `3m+r`. Upper
semicontinuity upgrades the specialization to a generic statement. Exact Q
verification on odd `m ≤ 11` is sealed in `rank_theorem.json`.

## 3. Finite generation / periodicity (item 3) — PARTIAL

| layer | all-`m` / all-`d`? | mechanism |
|-------|-------------------|-----------|
| Free `L_r` surjectivity | YES | pure powers + multi-Rees |
| Linear based residual equalizer | all `d` for fixed `m` over `R=Sym(E_+^*)` | finite gen. free/projective over `R` |
| `G ∩ (B \ R_3)` | **only tested bidegrees** | no monotonicity/Rees incidence theorem yet |
| Infinite obstruction tower L-F | NO | ranks → ∞ in `m`; closed-form ranks, not finite gen. |

**Quartic warning.** Finite generation of covariants over the invariant ring
does **not** give unbounded degree (`4^n d` only). Free/all-`m` claims above
use pure powers + multi-Rees, not the quartic endomorphism.

## 4. Higher polar recursion (item 4) — PROVED (combinatorial)

Nonautomatic F-orders: `3m+1, 3m+3, 3m+5, ...` (odd δ). Newest isolation
operator is always `L_{2k+1}(b) = B(b; a_m, a_m)`. Residual `R` is given by
the live triple enumeration (independent of odd `m`). On the common free open
`U ∋` pure powers, every finite stage is formally smooth (`ω_r = 0`).

**Formal lifts on `U` exist as normal series — not covariants.**

## 5–6. Equivariant gluing / algebraization — NOT IN THIS DISPATCH

**Algebraization gate (named only):**

> `ALGEBRAIZATION_OF_FORMAL_NORMAL_LIFTS` — promote a residual-equivariant
> formal normal-order solution of the polar system on `U` to a homogeneous
> polynomial `p ∈ Hom(Sym^d W^*, W)^G` landing in `X` (Artin / equivariant
> algebraization). Still not a headline until landing, dominance, and
> conversion to `ed_C(G)=3` / G-unirationality.

## Decision exit: `G-CONSTRUCTION`

Globally compatible Level-2 states meet the unobstructed open at three
bidegrees; the free-module rank theorem and polar recursion reclassify the
nonlinear machine as **constructive** on a nonempty open of free leading jets.
Still **not** a covariant; still **no headline**; all-degree `G` open meeting
not claimed.

### Terminal markers

```text
PATH_G_FORK_GB_OK
PATH_G_FORK_GB_VERIFY_OK
```

## Files

```text
certificates/global_lifting_decision/produce_forkB.py
certificates/global_lifting_decision/verify_forkB.py
certificates/global_lifting_decision/persistence_certificate.json
certificates/global_lifting_decision/rank_theorem.json
certificates/global_lifting_decision/higher_polar_recursion.json
certificates/global_lifting_decision/finite_generation_boundary.json
certificates/global_lifting_decision/algebraization_gate.json
certificates/global_lifting_decision/forkB_exit.json
certificates/global_lifting_decision/FORK_GB.md
certificates/global_lifting_decision/SEAL_FORK_GB.json
```

**PATH_G_FORK_GB_OK**
