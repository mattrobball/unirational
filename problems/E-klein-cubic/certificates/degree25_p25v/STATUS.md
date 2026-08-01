# P25V — degree-four closure and compressed kernel incidence

**Headline: OPEN.**

**Dispatch:** `WORKORDER_CAS_T11_P25V_C3.md` Track P25V (§1.5–1.7, §2, §4, §7–10).

---

## Exits this round

| Task | Exit | Artifact |
|---|---|---|
| P25V.0 degree-four closure | **`P25V-PRESENTATION-ENLARGED`** | `exit_p25v0.json`, `deg0_structural_cert.npz` |
| P25V.1 compressed incidence | **`P25V-SUPPORT-UNDECIDED`** | `exit_p25v1.json`, compressions under `tmp/p25v_incidence/` |

---

## P25V.0 — pure-`q` membership **fails**

P25W already settled basis degrees ≥ 1 (membership automatic). Only pure-`q`
membership in `S_4` remained.

### Structural certificate (exact over `F_89`)

The pure-`q` component of `T_i(s_a)` is

```text
deg0(T_i(s_a)) = Σ_{qi} L_{a,qi} · Tq0[i,qi] ∈ S_4,
```

where `Tq0[i,qi]` is the degree-0 (cubic) component of `T_quad_F3[i,qi]` and
`L_{a,qi}` is the linear form of seed `a` on quadratic basis element `qi`.

**Fact:** all **126** cubics `Tq0[i,qi]` (`i=0..5`, `qi=0..20`) lie **outside**
`V_0 = span{seed deg0 rows}` (rank 690 in `S_3`, dim 9139). Independent
verifier: RREF of `V_0`, nonzero remainder for each of the 126 cubics.

### Bulk FLINT witness

Generator matrix `G : F_89^{25530} → F_89^{91390}` (columns `q_j · (seed_a)_0`):

| Quantity | Value |
|---|---|
| `rank(G) = dim S_1·V_0` | **25530** (injective) |
| `T_i(s_a)` deg0 tests | **0 in / 4140 out** |
| commutator deg0 tests | **0 in / 315 out** |
| Peak RSS | **≈ 45.3 GiB** (under 64 GiB budget) |
| Wall time | **≈ 7928 s** (~2.2 h) |

So `N_0` is **not** `T`-stable. Exit **`P25V-PRESENTATION-ENLARGED`**.
Enlargement mandate: add the failed degree-four generators and re-close; full
iterative closure is not completed in this packet. The lower presentation
`N_0` remains valid for emptiness (`Supp(R/J) ⊆ Supp(F/N_0)`).

---

## P25V.1 — compressed incidence **undecided**

- Stage A (`b0=b1=0`) already empty (`P25W-STAGEA-EMPTY`).
- Deterministic compression seed `2026073189`; stored compressions
  `r ∈ {28,32,40,64}` under `tmp/p25v_incidence/compression_r*.npz`.
- Fresh preflight based on compressed incidence (not the forbidden 43-var matrix):
  `preflight_incidence.json`, floor 16 GiB, budget 64 GiB.
- Specialized rank probe (discovery only): 200 random `q ≠ 0` give
  `rank M_64(q) = 28` always; 100 random for full 690×28 also always 28.
- Heavy solve (msolve F4, chart `b0=1,q0=1`):
  - `r=64`: deg-5 matrix `56949×1828991` (1490 s); deg-6 opened with 17700 pairs;
    peak active ≈ 40 GiB.
  - `r=28`: deg-5 matrix `25232×1832458` (159 s); deg-6 incomplete; peak footprint
    ≈ 28.6 GiB.
- **No accepted emptiness certificate** (saturated unit ideal / irrelevant-power
  containment / Nullstellensatz identity). Empty solver kill is not emptiness.
- Exit **`P25V-SUPPORT-UNDECIDED`**. Route remains headline-capable.

---

## Peak RSS

| Job | Peak RSS |
|---|---|
| P25V.0 FLINT rref + membership | ≈ 45.3 GiB |
| P25V.0 produce/verify structural | < 1 GiB |
| P25V.1 msolve r=64 chart | ≈ 40 GiB active |
| P25V.1 msolve r=28 chart | ≈ 28.6 GiB footprint |

---

## Theorem boundary (one paragraph)

**Proved over `F_89`:** the pure-`q` degree-four membership tests for the sealed
690-seed lower presentation all fail — none of the 4140 vectors `T_i(s_a)` nor
the 315 commutator defects on quadratic basis elements lie in `S_1·V_0 ⊂ S_4`,
because all 126 `T_quad` pure-`q` cubics lie outside `V_0`. Hence
`F/N_0 ≇ R/J` and the presentation must be enlarged. Stage A incidence remains
empty. **Not proved:** the `T`-stable closure of `N_0`; emptiness of the full
(or compressed) kernel incidence (unless P25V.1 seals it); any
characteristic-zero row rank (only `rank_{F_89} = 746` is sealed). Emptiness of
`Supp(F/N_0)` would still prove emptiness of the true landing support via the
lower-presentation inclusion and the sealed DVR properness argument; that would
be a **scoped degree-25 exclusion only**, never a headline negative.

**Problem E remains OPEN.**
