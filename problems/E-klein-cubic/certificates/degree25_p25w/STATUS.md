# P25W — degree-four closure and kernel-incidence (Worker P)

**Headline: OPEN.**

**Dispatch:** `WORKORDER_CAS_T10_P25W_C2.md` Track P25W (§1.5–1.6, §4, §7–9).

---

## Exits this round

| Task | Exit | Artifact |
|---|---|---|
| P25W.0 field scope | recorded | `STATUS.md` (this file), `exit_p25w0.json` |
| P25W.1 degree-four closure | `P25W-PRESENTATION-UNDECIDED` | `exit_p25w1.json`, `p25w1_component_spans.json` |
| P25W.2 Stage A (`b0=b1=0`) | **empty** (`P25W-STAGEA-EMPTY`) | `stageA_result.json`, `stageA_certificate.npz` |
| P25W.2 Stage B preflight | `P25W-SLOT-REQUEST` | `preflight_incidence.json` |

---

## P25W.0 — row-rank field scope (no new producer)

```text
rank over F_89          = 746 exactly          (P25Z-ROW-RANK-746)
characteristic-zero rank = not yet decided     (Worker R / P25W.3)
complete p=89 special landing ideal = the 746 rows
```

For emptiness, **no characteristic-zero rank certificate is needed**: empty special
fibre implies empty generic fibre by the sealed DVR properness argument
(`certificates/degree25_direct_support/DVR_MODEL.md`).

The 690-row packet is a **lower presentation** (`P25Z-FINITE-PRESENTATION-LOWER`):
`F/N_0 ↠ R/J`, so emptiness of `Supp(F/N_0)` implies emptiness of the true support.
A nonempty lower-presentation point is not interpretable until P25W.1 closes and the
746 cubics are checked.

---

## P25W.1 — degree-four closure

**(N_0)_4 = S_1 · (N_0)_3** inside the finite-dimensional `F_89`-space `F_4`
(`dim F_4 = 160987`).

### Settled componentwise (exact over `F_89`)

| Basis degree | Ambient of seed coeffs | `V_b = pr_b((N_0)_3)` | `S_1 · V_b` | Membership of any deg-4 test |
|---|---|---|---|---|
| 2 (21 comps) | `S_1` (dim 37) | full `S_1` (rank 37) | full `S_2` | **automatic** |
| 1 (6 comps) | `S_2` (dim 703) | rank 690 | full `S_3` (dim 9139) | **automatic** |
| 0 (1 comp) | `S_3` (dim 9139) | rank 690 | subspace of `S_4` (dim 91390), dim ≤ 25530 | **open** |

So every `T_i(s_a)` and every commutator defect is already in `(N_0)_4` on all
components of basis degree ≥ 1. The only open membership is the pure-`q`
component in `S_4`.

### Remaining matrix (resource floor)

```text
G : F_89^{25530} → F_89^{91390}
columns = q_j · (seed_a)_0 ,  a=1..690, j=0..36
tests   = deg0 components of 6·690 T_i(s_a) and of the nonzero commutator defects
```

Naive dense RREF exceeds the 8 GiB exploratory fence (uint8 storage of `G` alone
≈ 2.2 GiB; peak for full GE higher). Floor recorded as **16 GiB** for a dedicated
slot. Exit: `P25W-PRESENTATION-UNDECIDED`.

**Not used as exit:** specialized fibre T-stability from the P25Z packet.

---

## P25W.2 Stage A — `b0 = b1 = 0` stratum **empty**

Only the 21 quadratic dual variables remain. The equations are bilinear:
`M2(q) β = 0` with `M2` the 690×21 linear block of the sealed seed matrix.

**Certificate (exact over `F_89`):**

1. Flatten to `T ∈ Mat_{690×777}(F_89)`; `rank T = 690`, `ker dim = 87`.
2. Parametrize `K = ker T` by `a ∈ F^{87}` as matrices `M(a) ∈ Mat_{21×37}`.
3. Rank ≤ 1 iff all 2×2 minors of `M(a)` vanish (homogeneous quadrics in `a`).
4. A deterministic sample of 4000 minors spans **all** 3828 homogeneous quadrics
   on `F^{87}`. Hence the only common zero is `a = 0`.
5. Therefore `K` contains no nonzero rank-1 matrix: no `(q,β)` both nonzero.

Independent verifier recomputes flattening rank, ker dimension, and the quadric
span rank without importing the producer.

This is **not** emptiness of the full kernel incidence (the `b0,b1` strata remain).

---

## P25W.2 Stage B — preflight only (`P25W-SLOT-REQUEST`)

Smallest deterministic compression: **64** equations, bidegree `(3,1)`, 65
variables, double irrelevant saturation. Measured floor **16 GiB** > 8 GiB
exploratory fence. Heavy multihomogeneous solve deferred to the director’s slot.

Implication chain (when run):

```text
compressed incidence empty  ⇒  seed incidence empty
                            ⇒  full special landing scheme empty
                            ⇒  (DVR) char-0 degree-25 landing scheme empty
```

That last arrow is a **scoped degree-25 exclusion**, never a headline negative.

---

## Peak RSS (this dispatch)

| Job | Peak RSS |
|---|---|
| Stage A produce | ≈ 433 MiB |
| Stage A verify | ≈ 400 MiB class |
| P25W.1 component spans | ≈ 975 MiB |
| Stage B preflight | < 100 MiB |

---

## Theorem boundary (one paragraph)

**Proved over `F_89`:** the Stage A (`b0=b1=0`) multihomogeneous kernel incidence
is empty; on every basis component of degree 1 or 2 the degree-four piece of the
lower presentation fills the ambient graded summand, so those components of all
degree-four closure tests pass. **Not proved:** exactness `F/N_0 ≅ R/J` (deg-0
membership open); emptiness of the full (or compressed) kernel incidence; any
characteristic-zero row rank (only `rank_{F_89} = 746` is sealed; generic rank
≥ 746). The lower-presentation caveat remains: emptiness of `Supp(F/N_0)` would
prove emptiness of the true support, but a nonempty answer is not interpretable
until P25W.1 closes and the 746 special-fibre cubics are checked. Empty special
fibre would imply empty generic fibre by DVR properness without a char-0 rank
certificate.

**Problem E remains OPEN.**
