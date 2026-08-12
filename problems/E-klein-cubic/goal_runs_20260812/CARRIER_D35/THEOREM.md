# The canonical-carrier gateway at degree 35

**Packet:** `goal_runs_20260812/CARRIER_D35/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

The W-carrier theorem (`theory/FIX_VII_carrier.md`) says every equivariant
dominant map has a resolution centre whose `H¹` carries the Weil representation.
The canonical minimal carrier is the Hessian curve `C = Sing(V(H))`,
`H = det Hess F`, identified with `X(11)`: degree 20, genus 26.
At `d = 34` the canonical-carrier ansatz was closed NEGATIVE (`FIX_VII_LAND`).
This packet runs the linear analogue on the live `d = 35` 37-cell.

Machine markers: `CARRIER_D35_VERIFY_OK` / `ALLGREEN` (`python3 verifier.py`).

## Exit ledger

```text
CARRIER-D34-RECONSTRUCTED
CARRIER-WINDOW-D35
CARRIER-IC-331-661
CARRIER-SEXTET-FP2
CARRIER-RESTRICTION-RANK-1
CARRIER-KERNEL-INTERVAL-32-36
CARRIER-ANSATZ-LINEARLY-ALIVE
CARRIER-22-MEET-CLOSED
CARRIER-NO-DEGREE-EXCLUSION
```

---

## 0. What is applied

`FIX_VII` Theorem 2 and §6–8; sealed GATE/LAND at `d = 34`; the live 37-cell
(`D35_EXTENDED_SIEVE` / `PAIR_ATTACK_D35`); keep-pass of the 22
(`DEPTH_TABLE_GENERAL`). Primes `331` and `661`. python3 + M2 (named: `I_C`
and the plus-plane/hyperplane sections of `C`). No msolve.

---

## 1. The `d = 34` verdict, reconstructed

GATE: `M_34 = 576` → `(1,6)`-profile `n1 = 16` → restriction to `C` has rank
**3** → carrier space `n2 = 13`, identical at `p = 67` and `199`.
LAND: the landing cone `F(Σ c_i T_i) ≡ 0` on that 13-space is empty at both
primes (Groebner certificate: the sampled ideal is the irrelevant maximal
ideal at `p = 67`). **Canonical-carrier ansatz at `d = 34` is CLOSED-NEGATIVE.**
That death is a landing emptiness, not a linear emptiness.

---

## 2. The Hessian window at `d = 35`

Atiyah–Bott / Chevalley–Weil replay (`scripts/window.py`, same fixed-point
data as `hess_window.py`):

| d | `mult_{W̄}(S^d)` | on-curve `W̄` | ideal ≥ |
|--:|----------------:|-------------:|--------:|
| 34 | 576 | 6 | 570 |
| **35** | **637** | **5** | **632** |
| 36 | 706 | 5 | 701 |

So any subspace of `M_35` (in particular the 37-cell) has restriction rank
to `C` at most **5**. Hence the carrier-compatible kernel has dimension at
least **32** over the character field. `I_C` at both live primes: projective
dimension 1, degree 20, Hilbert polynomial `20i−25`, `HF(35) = 675`.

---

## 3. Restriction of the 37-cell

The 60 C11-points lie on `C` (and on `X`). They already vanish for the
37-cell (L12): value rank **0**. They do not detect Hessian vanishing.

The Hessian sextet `C ∩ Π_σ` is **not** `F_p`-rational. At `p = 331` it
splits as six `F_{p^2}`-points (three conjugate pairs). The 37-cell
**vanishes** at those six points (and therefore on the 330-point G-orbit).
At `p = 661` the sextet is two cubics (needs `F_{p^3}`).

Further `F_{p^2}`-points of `C` come from hyperplane sections (degree-20
0-dimensional schemes, linear factors over `GF(p^2)`). Evaluation of the
37-cell at those points has rank **1** at both primes. Combined with the
character bound:

| | 331 | 661 |
|--:|--:|--:|
| C11 value rank | 0 | 0 |
| extra `F_{p^2}`-points | 14 (incl. 6 sextet) | 7 |
| restriction value rank | **1** | **1** |
| kernel dim over `K` | **32 … 36** | **32 … 36** |

The rank-1 is a characteristic-zero lower bound (`rank_p ≤ rank_K`). The
ansatz is therefore **not free** on the 37-cell, and **not empty**.

Only values (and first jets along a genuine tangent of `C`) are restriction
functionals. Higher jets along the tangent *line* mix normal directions and
were discarded (they produced a fake rank 7).

---

## 4. The 22 cells

Sealed keep-pass: all 22 live at dim 37, closed-functional rank 0, both
primes. They occupy the full 37-cell linearly. The carrier kernel
(dimension ≥ 32) therefore **meets every one of the 22 closed constraints**.
KEEP non-vanishing on the kernel is not a closed cut and is not imposed.

---

## 5. Verdict

**The canonical-carrier ansatz is linearly ALIVE at `d = 35`.**
Carrier-compatible subspace: dimension in `{32,33,34,35,36}`. It meets the
22. The landing cone on that subspace was **not** computed (the d=34 death
lived there; director msolve jobs already own the box).

Remaining carrier families of `FIX_VII` §3, all still open:

- genus-5 `A5`-curves (11-orbit)
- genus-12 `F55`-curves (12-orbit)
- induced `C11` / `D12` configurations
- tower carriers over point orbits (Hodge-local; outside this machinery)

---

## 6. Honesty tiering

**Tier 1 — character formula and `I_C` geometry.** Window multiplicities;
`I_C` dimension/degree/Hilbert; C11-points on `C`; sextet splitting type.

**Tier 2 — modular linear algebra, two primes.** Value rank 1; kernel
interval `[32, 36]` over `K` (lower from the character bound, upper from
`rank_p ≤ rank_K`). A computed 0 would have been a characteristic-zero
emptiness. A positive rank is a lower bound.

**Tier 3 — consumed / not done.**

1. GATE/LAND `d = 34` numbers are consumed from sealed packets.
2. Exact restriction rank in `{1,2,3,4,5}` is not isolated.
3. Landing `F(T) ≡ 0` on the kernel is not assembled.
4. KEEP menus of the 22 on the kernel are not re-tested.

---

## 7. Not claimed

- No degree is excluded. ODDZERO is idle.
- The 22 are not killed.
- The canonical-carrier ansatz is not closed-negative at `d = 35`.
- The landing cone on the Hessian kernel is not empty (and not shown nonempty).
- Induced and tower carriers are not attacked.

---

## 8. Replay

```text
python3 verifier.py           # artefacts + window replay
python3 verifier.py --live    # also I_C at 331 and C11-on-C
```
