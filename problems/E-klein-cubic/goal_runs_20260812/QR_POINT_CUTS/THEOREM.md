# The 60 C11-point conditions on the QR-degree window cells

**Packet:** `goal_runs_20260812/QR_POINT_CUTS/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

The sealed L12 all-degree C11 theorem says every landing map vanishes at all
60 C11-points, at every degree. The Layer-0 cells at quadratic-residue degrees
were built without those point rows (old B(C11) fired only at non-residues).
This packet rebuilds the cells, imposes `T(p) = 0` at the 60 points, and
re-issues the alive table. **No new dim is zero.** No ODDZERO-standard audit
is triggered. No degree is excluded.

Machine markers: `QR_POINT_CUTS_VERIFY_OK` / `ALLGREEN` (`python3 verifier.py`).

## Exit ledger

```text
QRCUT-C11-CENSUS-60
QRCUT-SEALED-DIMS-REPRODUCED
QRCUT-D35-CONTROL-RANK-0
QRCUT-QR-RANK-1
QRCUT-ALIVE-TABLE
QRCUT-SATURATION
QRCUT-NO-DEGREE-EXCLUSION
```

---

## 0. What is applied

`L12_ORDER11` director adjudication (sealed): at every QR class mod 11 the
`μ = 0` branch dies by integrality, and combined with the sealed NQR branch
**all 60 C11-points lie in `Bs(T)` for every landing map at every degree.**
This packet consumes that statement; it does not re-prove it.

Engine: `D34_GUIDED_SWEEP` (`slicelib`, `d34lib.point_block`, `produce_d34`
recipes, `produce_ladder.structure_blocks`). Per-degree cell recipe as in
`LANDING_SWEEP`. Primes `331` and `661`. python3 only.

Fatal anchors: rebuilt cell dims must be **39 / 63 / 121 / 151 / 397** at
`d = 35, 36, 37, 38, 42`. Control: at `d = 35` (NQR) the 60-point rank on
the cell must be **0**.

---

## 1. The 60 points

The frame has 120 order-11 matrices, forming **12** cyclic subgroups. Each
C11 has a 5-point eigenframe (all on the Klein cubic). Projective dedupe of
the union is **exactly 60**. The 12 frames are pairwise disjoint. The ladder's
one-C11 sample (`produce_ladder.eig_points`) is one of those 12 frames.

Both primes: 120 order-11 elements, 12 frames of 5, 60 points, all on `X`.

---

## 2. Cuts (both primes agree)

| d | class | sealed cell | rank | new dim | sat | C11 already in structure |
|--:|:-----:|------------:|-----:|--------:|:---:|:------------------------:|
| 35 | NQR | **39** | **0** | **39** | yes | yes (control) |
| 36 | QR | **63** | **1** | **62** | yes | no |
| 37 | QR | **121** | **1** | **120** | yes | no |
| 38 | QR | **151** | **1** | **150** | yes | no |
| 42 | QR | **397** | **1** | **396** | yes | no |

Sealed dims reproduced at both primes (fatal, passed). Control rank 0 at
`d = 35` (fatal, passed). Stacking the 60 evaluation rows twice does not
change the rank. Rank of one eigenframe equals rank of all 60 (equivariance
of `M_d`).

At every QR degree in the window the 60-point block has **rank exactly 1**.
That is one new linear condition — the size of the D10/D12 point budget —
not a window-closer.

---

## 3. Re-issued alive table `d = 34..42`

NQR rows are unchanged (C11 was already forced there). QR rows take the new
dim. `d = 34` is QR but already empty; the cut is vacuous.

| d | class | old cell | new cell |
|--:|:-----:|---------:|---------:|
| 34 | QR | 0 | **0** |
| 35 | NQR | 39 | **39** |
| 36 | QR | 63 | **62** |
| 37 | QR | 121 | **120** |
| 38 | QR | 151 | **150** |
| 39 | NQR | 218 | **218** |
| 40 | NQR | 261 | **261** |
| 41 | NQR | 343 | **343** |
| 42 | QR | 397 | **396** |

First open window remains `d = 35`, dim ≤ 39.

---

## 4. Flags

No new dim is 0. **No ODDZERO-standard audit is triggered.** A zero-dimensional
outcome would have been FLAGGED and never claimed; that branch is idle.

---

## 5. Honesty tiering

**Tier 1 — exact frame combinatorics.** The 60-point census (12 frames of 5,
projective uniqueness, all on `X`, ladder-5 is a frame).

**Tier 2 — modular linear algebra, two primes, saturation.** Cell dims, ranks,
new dims. A computed 0 is a characteristic-zero emptiness of that linear
slice (`slicelib` semantics). A positive new dim is an **upper bound** only.

**Tier 3 — flagged / consumed.**

1. The all-degree C11 base-point theorem is **consumed** from `L12_ORDER11`,
   not re-proved here.
2. The landing system `F(T) ≡ 0` is not assembled. These are linear cuts on
   the Layer-0 cell, not a Nullstellensatz.
3. `d = 39, 40, 41` are not recut (NQR; C11 already present). `d = 34` is
   not recut (already 0).

---

## 6. Not claimed

* No degree is excluded. Problem E remains OPEN.
* No construction of a landing map at any surviving dimension.
* No lower bound on any positive new dim (modular rank ≤ char-0 rank).
* No claim that rank 1 continues outside `{36, 37, 38, 42}`.
* Nothing about orders 5, 3, 2, 6, or the landing ideal on a live cell.

---

## 7. Replay

```bash
cd goal_runs_20260812/QR_POINT_CUTS
python3 verifier.py                      # stored artefacts
# python3 scripts/produce_cuts.py --census-only
# python3 scripts/produce_cuts.py 331 35 36 37 38 42
# python3 scripts/produce_cuts.py 661 35 36 37 38 42
# python3 scripts/compile_table.py
# python3 verifier.py --live             # census + d=35 control at p=331
```

## 8. Dependencies

| import | role |
|---|---|
| `goal_runs_20260812/L12_ORDER11` | sealed all-degree C11 base-point theorem (consumed) |
| `goal_runs_20260811/D34_GUIDED_SWEEP` | Layer-0 ladder engine, sealed dims |
| `goal_runs_20260812/LANDING_SWEEP` | per-degree cell recipe and alive table |
| `WORKORDER_QR_POINT_CUTS.md` | this packet's commission |

## Director adjudication (2026-08-12, appended at sealing)

Replayed clean: 72/72 ALLGREEN. Both fatal anchors hold — the sealed
cell dimensions 39/63/121/151/397 reproduce at both primes, and the
`d = 35` control returns rank 0 (the ladder had already forced those
points at non-residue degrees, as the sealed record says).

**Size of the cut, honestly:** rank exactly 1 at each of
`d = 36, 37, 38, 42`, so the alive table moves
`63/121/151/397 → 62/120/150/396`. The director's expectation before
the run was a larger bite; the reason it is 1 is structural, not a
defect: the 60 points form a SINGLE `G`-orbit, so equivariance collapses
the 300 scalar evaluation conditions to the vanishing of one covariant
functional at one representative point (the stabilizer is `C11`, and the
value must already lie in a pinned eigenline). Every additional point of
the orbit is then automatic. This is worth recording as the general
lesson for orbit-supported base conditions: their rank is bounded by the
representation content at a single representative, not by the orbit size.

No new dimension is 0; no window closes; the ODDZERO gate stays idle.
