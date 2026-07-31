# P25Z.3 — Exact direct landing-row rank

**Headline: OPEN.**

**Exit:** `P25Z-ROW-RANK-746`

---

## Theorem boundary

Over \(\mathbf F_{89}\), let \(V_{25}\) be the fixed monic rank-43 DVR special
fibre and let

\[
\Lambda\colon \mathrm{Sym}^3(V_{25})\longrightarrow
(\mathrm{Sym}^{75} W^\vee)^{G}
\]

be the polarized landing map \(c\mapsto F(p_c)\). This packet proves

\[
\mathrm{rank}(\Lambda) = 746.
\]

This is an **exact** rank (upper and lower bound), not a sampling plateau.
In particular, the certified 746-row direct subsystem is the complete direct
landing row space over \(\mathbf F_{89}\).

## Construction

1. **Invariant basis.** 2343 independent Reynolds orbit sums of degree-75
   monomials, certified by evaluation rank 2343 on a 2500-point probe set
   (Molien dimension \(m_{75}=2343\)).
2. **Unisolvence.** 2343 source points whose invariant-evaluation matrix is
   invertible over \(\mathbf F_{89}\) (RREF rank 2343, nonzero pivot product
   \(68\not\equiv 0\pmod{89}\)).
3. **Landing rows.** Cubic coefficient rows of \(F(p_c(x_j))\) at the unisolvent
   points, using the sealed monic basis of \(V_{25}\) from `P25Y-DVR-PASS`
   (`basis43_sha256 = 4709fdbeea6db5f5…`).
4. **Rank.** Incremental \(\mathbf F_{89}\) echelon of the stacked rows yields
   rank **746**. Last rank increase at unisolvent index 752; the remaining
   unisolvent rows lie in the same span.

Because evaluation on \(\mathrm{Inv}_{75}\) is an isomorphism at the unisolvent
set, the span of these rows equals the full image of \(\Lambda^*\), with no
sampling gap left.

## Comparison with the historical sampling lower bound

The deterministic 1600-point sampling packet
(`certificates/degree25_direct_support/`) reported rank 746 as a **lower bound
only**. The unisolvent model shows:

- exact rank \(= 746\);
- the old 746-row echelon has the same rowspace as the unisolvent echelon
  (stacked rank 746; old rows contained in the new span);
- no missing genuine direct rows.

## Resource

- Peak RSS (producer): **1528.4 MiB**
- Peak RSS (verifier): **1658.8 MiB**
- Exploratory ceiling: 8192 MiB; no heavy-slot contention with Worker T.

## Artifacts

| File | Role |
|------|------|
| `invariant_basis.npz` | 2343 monom exponents (Reynolds seeds) |
| `unisolvent_points.npz` | points + evaluation matrix |
| `landing_rows_unisolvent.npz` | echelon of landing rows |
| `rank_certificate.json` | machine-readable exit |
| `verify_report.json` | independent verifier report |
| `produce_rowrank.py` / `verify_rowrank.py` | producer / independent verifier |

## Independent verification

`verify_rowrank.py` does **not** import the producer. It recomputes:

1. independence of the 2343 Reynolds images on a fresh probe set (rank 2343);
2. invertibility of the sealed evaluation matrix (rank 2343, pivot product 68);
3. landing-row rank at the sealed unisolvent points from the DVR basis43
   (rank 746).

## What this does **not** prove

- Characteristic-zero freeness or global geometry of the landing ideal.
- Completeness of any quarantined historical 842-row packet (the exact direct
  rank is 746, not 842; that packet remains quarantined).
- Emptiness or nonemptiness of the degree-25 covariant scheme (that is P25Z.2).
- Freeness of the finite \(S\)-module on 28 generators — mixed \(QK^2\) still
  cannot close a free rank-28 presentation from a 746-row subsystem
  (\(56+777=833>746\)).

Headline remains **OPEN**.
