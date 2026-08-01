# P25W.3 — Characteristic-zero landing rank

**Headline: OPEN.**

**Exit:** `P25W-RANK-K-UNDECIDED`

---

## Theorem boundary

For the polarized landing map

\[
\Lambda\colon \mathrm{Sym}^3(V_{25})\longrightarrow
(\mathrm{Sym}^{75} W^\vee)^{G}
\]

this packet proves **exact modular ranks** by unisolvence at three good
split primes \(p\equiv 1\pmod{11}\):

| Prime \(p\) | \(\zeta_{11}\bmod p\) | \(\operatorname{rank}_{\mathbf F_p}\Lambda_p\) | Unisolvence pivot product |
|------------:|----------------------:|----------------------------------------------:|--------------------------:|
| 89 | 78 | **746** | 68 |
| 199 | 61 | **746** | 21 |
| 353 | 58 | **746** | 136 |

Therefore

\[
\operatorname{rank}_{K}\Lambda_K \ge 746,
\qquad K=\mathbf Q(\zeta_{11}),
\]

because rank can only drop under reduction. The Molien upper bound is
\(m_{75}=2343\), so

\[
\operatorname{rank}_{K}\Lambda_K\in[746,2343].
\]

**This packet does not prove** \(\operatorname{rank}_K\Lambda_K=746\).
Agreement of modular ranks is evidence only. A modular rank is never
silently promoted to characteristic zero (§2.4, §8.6 of the work order).

---

## Construction (per prime)

1. **Invariant basis.** 2343 Reynolds orbit-sums of degree-75 monomials
   (reused sealed monoms from `degree25_rowrank/`, re-verified independent
   over each \(\mathbf F_p\) by evaluation rank \(=2343\) on a 2500-point probe).
2. **Unisolvence.** 2343 source points with invertible \(2343\times2343\)
   invariant-evaluation matrix (RREF rank 2343, nonzero pivot product).
3. **Landing rows.** Cubic coefficient rows of \(F(p_c(x_j))\) at those
   points, using the monic rank-43 DVR special-fibre basis rebuilt at \(p\).
4. **Rank.** Incremental \(\mathbf F_p\) echelon of the stacked rows equals
   \(\operatorname{rank}(\Lambda_p)\) exactly, because evaluation on
   \(\mathrm{Inv}_{75}\) is an isomorphism at the unisolvent set.

## Reconstruction side (for a future char-0 certificate)

Chose the **image** of \(\Lambda\): if the modular ranks stay at 746, then
\(\dim\operatorname{im}=746\le\dim\ker=13444\). The image is the cheaper
object to reconstruct.

## Why characteristic zero is still open

The monic `basis43` is a **fibrewise** RREF over \(\mathbf F_p\); its
sha256 differs by prime:

- \(p=89\): `4709fdbeea6d…` (matches sealed DVR)
- \(p=199\): `6a7da42ec082…`
- \(p=353\): `3ff3cf79aa78…`

CRT of modular echelons is therefore ill-posed without a fixed
\(\mathbf Z[\zeta_{11}]\)-lattice presentation of \(V_{25}\) and \(\Lambda\).
Building that presentation (43×189 covariant basis over \(K\), then the
landing map, then multiprime CRT of a 746-row image basis) has measured
preflight working-set floor \(\gtrsim 6461\) MiB for cyclotomic rational
image reconstruction alone, and requires the heavy slot. Worker R does not
hold the heavy slot (§7). Measured `UNDECIDED` with this named bottleneck
is successful work (§8.11).

## Independent verification

`verify_rank_k.py` does **not** import the producer. It recomputes, for each
prime:

1. independence of the 2343 Reynolds images on a fresh probe set;
2. invertibility of the sealed evaluation matrix (rank and pivot product);
3. landing-row rank from monic `basis43` at the sealed unisolvent points.

Verifier report: `verify_report.json` (PASS at all three primes).

## Resource

| Job | Peak RSS | Wall time |
|-----|----------|-----------|
| Producer (3 primes) | **1856.6 MiB** | 692 s |
| Verifier (3 primes) | **1842.5 MiB** | 378 s |
| Ceiling | 8192 MiB | no heavy slot |

## Artifacts

| File | Role |
|------|------|
| `rank_p{89,199,353}.json` | per-prime exact rank + unisolvence |
| `invariant_basis_p*.npz` | monom exponents |
| `unisolvent_points_p*.npz` | points + eval matrix |
| `landing_echelon_p*.npz` | landing-row echelon |
| `preflight_rank_k.json` | char-0 resource floor |
| `exit_p25w3.json` | machine-readable exit |
| `verify_report.json` | independent verifier |
| `produce_rank_k.py` / `verify_rank_k.py` | producer / verifier |

## What this does **not** prove

- \(\operatorname{rank}_K\Lambda_K=746\) (or any exact char-0 value).
- Completeness of any historical 842-row packet (not imported; §2.7).
- Emptiness or nonemptiness of the degree-25 scheme (that is P25W.2;
  this task is not a gate for it).

Headline remains **OPEN**.
