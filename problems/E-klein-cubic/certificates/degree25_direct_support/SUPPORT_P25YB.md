# P25Y-B — Support structure from the direct 746-row subsystem

**Headline: OPEN.**

**Exit:** `P25YB-F4-SLOT-REQUEST` (see `p25yb_support.json`, refreshed `preflight_p25y3.json`).

---

## 0. Accepted inputs (not re-derived)

| Fact | Marker |
|------|--------|
| Fixed free rank-43 DVR model of \(V_{25}\) at \(p=89\) | `P25Y-DVR-PASS` |
| Deterministic direct rows, Park–Miller seed `2026073189`, 1600 points, \(\mathbf F_{89}\)-rank **746** | `rank_growth.json` |
| Molien bound \(m_{75}=2343\) (not tight for 746) | `certificates/degree25_molien/` |
| Historical 842-row / rank-28 border | **quarantined** (§1.2.6) |

`P25Y-FULL-ROWSPACE-746` is **not** sealed (\(746\neq 2343\)).

---

## 1. Q⊕K coordinates over the p=89 DVR model

Rebuilt from the sealed DVR circuit (same monic basis as `dvr_special_fibre_p89.npz`):

- \(K=\ker\) of the common-order-3 map on \(V_{25}\), dimension 6
- \(Q\) monic complement, dimension 37
- Frame rank 43; \(K\) and \(Q\) row spaces match the sealed multiprime change-of-basis packet

Artifact: `tmp/p25yb/qk_blocks_p89.npz`.

---

## 2. Independent recompute of \(1\oplus K\oplus\mathrm{Sym}^2 K\)

Suggested order ideal (discovery only until reduced against the direct ideal):

\[
\mathcal O
=
\{1\}
\cup
\{k_i\}_{i=0}^{5}
\cup
\{k_i k_j\}_{i\le j}
\qquad
(|\mathcal O|=28).
\]

### Necessary pure-\(K^3\) border test

On the subspace \(q=0\), the free module \(\mathcal O\) has **no** degree-3 generators, so every pure-\(K\) cubic monom must lie in the ideal:

\[
\mathrm{Sym}^3 K^\vee \;\subset\; J_N\big|_{q=0}.
\]

**Result (recomputed, not imported):** the \(746\times 56\) pure-\(K\) cubic block of the direct rows has

\[
\mathrm{rank}_{\mathbf F_{89}} = 56.
\]

Every pure-\(K^3\) monom reduces to zero against the 746-row ideal on \(q=0\).
Status: **`HOLDS`**.

This is a necessary condition for a free \(1\oplus K\oplus\mathrm{Sym}^2 K\) presentation over \(\mathbf F_{89}[Q]\). It is **not** a full border-basis certificate: mixed multiplications, higher syzygies, and the annihilator over \(S=\mathbf F_{89}[q_0,\ldots,q_{36}]\) remain open.

### What was *not* done

- The quarantined rank-28 / 842-row packet was **not** imported as the landing ideal.
- Comparison to that packet is discovery-only after the independent definition above.

---

## 3. Annihilator / Fitting / support

| Probe | Result |
|-------|--------|
| Pure-\(Q\) cubic evaluation rank | \(\ge 746\) of \(\binom{39}{3}=9139\) |
| Specialized evaluation rank in \(k\) at random \(q_0\) (20 trials) | rank \(84\) on \(120\) samples (fills the deg\(\le 3\) jet dimension) |
| Compact Ann / Fitting generators | **not produced under 8 GiB** |
| Projective emptiness of \(V_+(J_N)\subset\mathbf P^{42}\) | **undecided** |

No subsystem point was promoted to a covariant. Complete \(F(p_c)\equiv 0\) sparse verification was not required (no survivor claimed).

---

## 4. Fenced step 5 — slot request

The 64 GiB homogeneous F4 / projective-support job is **out of scope this round**
(Worker N holds T8-N1). Preflight refreshed in `preflight_p25y3.json`.

```text
P25YB-F4-SLOT-REQUEST
```

**What remained:**

1. Sparse homogeneous F4 / Macaulay fill for \(V_+(J_N)\)
2. Complete annihilator or Fitting generators of a compact \(S\)-module
3. Any survivor lift with complete \(F(p_c)\equiv 0\)

---

## 5. Theorem boundary

**Proved:**

- Direct 746-row ideal, in the fixed \(Q\oplus K\) frame at \(p=89\), kills all pure-\(K^3\) monoms on \(q=0\) (necessary \(1\oplus K\oplus\mathrm{Sym}^2 K\) border condition).
- No compact module with certified Ann/Fitting under 8 GiB.

**Not proved:**

- Full border basis / freeness of rank 28 over \(S\)
- Emptiness or nonemptiness of \(V_+(J_N)\)
- That rank 746 is the full row span (Molien upper bound 2343)
- Any degree-25 covariant
- Headline unirationality

**Holdout:** \(p=199\) remains structural only; decision fibre is \(p=89\).

**Headline remains OPEN.**
