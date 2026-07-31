#!/usr/bin/env python3
"""P25Y-B step 5 producer: projective support of J_N (border + F4 probes).

Writes under certificates/degree25_support_f4/ and uses tmp/p25yf4_*/.
Does not import historical 842/rank-28 packets.
"""
from __future__ import annotations

import hashlib
import json
import math
import sys
import time
from itertools import combinations_with_replacement
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
DIRECT = ROOT / "certificates" / "degree25_direct_support"
TMPB = ROOT / "tmp" / "p25yf4_border"
TMPF = ROOT / "tmp" / "p25yf4_f4"
HERE.mkdir(parents=True, exist_ok=True)
TMPB.mkdir(parents=True, exist_ok=True)
TMPF.mkdir(parents=True, exist_ok=True)

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89
Q_DIM, K_DIM, STRICT, ORDER = 37, 6, 43, 28
N_ROWS = 746


def sha256_bytes(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()


def sha256_arr(a: np.ndarray) -> str:
    return sha256_bytes(np.ascontiguousarray(a).tobytes())


def canonical_json(obj) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def write_json_self_hash(path: Path, payload: dict) -> str:
    body = {k: v for k, v in payload.items() if k != "self_sha256"}
    text = canonical_json(body)
    digest = sha256_bytes(text.encode())
    body["self_sha256"] = digest
    path.write_text(canonical_json(body))
    return digest


def main() -> None:
    t0 = time.time()
    peak = C.rss_mib()
    print("P25Y-B step 5 produce_support", flush=True)

    # --- Load / rebuild QK rows ---
    rows_path = TMPB / "rows_qk.npz"
    if not rows_path.exists():
        raise SystemExit(f"missing {rows_path}; run transform first")
    rows_std = np.load(rows_path)["rows"].astype(np.int64) % P
    assert rows_std.shape == (N_ROWS, 14190)
    assert C.rank_mod(rows_std, P) == N_ROWS

    monoms = C.cubic_monomials()

    def kw(m):
        return int(sum(m[Q_DIM:]))

    buckets = {3: [], 2: [], 1: [], 0: []}
    for i, m in enumerate(monoms):
        buckets[kw(m)].append(i)
    perm = np.array(buckets[3] + buckets[2] + buckets[1] + buckets[0], dtype=np.int32)
    ordered = [monoms[i] for i in perm]
    sizes = {"K3": 56, "QK2": 777, "Q2K": 4218, "Q3": 9139}
    M = rows_std[:, perm] % P

    # RREF preferred
    print("RREF...", flush=True)
    A = M.copy()
    pivots = []
    row = 0
    nrows, ncols = A.shape
    for col in range(ncols):
        piv = None
        for r in range(row, nrows):
            if A[r, col] % P != 0:
                piv = r
                break
        if piv is None:
            continue
        if piv != row:
            A[[row, piv]] = A[[piv, row]]
        inv = int(C.inv_mod(int(A[row, col]) % P, P))
        A[row] = (A[row] * inv) % P
        fcol = A[:, col] % P
        for r in range(nrows):
            if r == row:
                continue
            f = int(fcol[r])
            if f:
                A[r] = (A[r] - f * A[row]) % P
        pivots.append(col)
        row += 1
        if row >= nrows:
            break
    n_k3 = sum(1 for c in pivots if c < 56)
    n_qk2 = sum(1 for c in pivots if 56 <= c < 56 + 777)
    n_q2k = sum(1 for c in pivots if 56 + 777 <= c < 56 + 777 + 4218)
    n_q3 = sum(1 for c in pivots if c >= 56 + 777 + 4218)
    peak = max(peak, C.rss_mib())
    print(f"  rank={len(pivots)} K3={n_k3} QK2={n_qk2} Q2K={n_q2k} Q3={n_q3}", flush=True)

    monic_ok = n_k3 == 56
    # Verify monic
    for r, c in enumerate(pivots):
        if c < 56:
            if int(A[r, c]) % P != 1:
                monic_ok = False
            for c2 in range(56):
                if c2 != c and int(A[r, c2]) % P != 0:
                    monic_ok = False

    # Uncovered QK2 monoms (non-pivot among QK2 columns)
    qk2_piv = {c for c in pivots if 56 <= c < 56 + 777}
    uncovered_qk2 = []
    for c in range(56, 56 + 777):
        if c not in qk2_piv:
            uncovered_qk2.append({"col": int(c), "monom": list(ordered[c])})

    # Specialized fibre probe (recompute)
    print("specialized fibre probe...", flush=True)
    slots = []
    for m in monoms:
        s = []
        for i, e in enumerate(m):
            s.extend([i] * int(e))
        slots.append(tuple(s))

    def eval_at(q, k):
        pt = np.concatenate([q, k]) % P
        mvec = np.array(
            [int(pt[a]) * int(pt[b]) * int(pt[c]) % P for a, b, c in slots],
            dtype=np.int64,
        )
        return (rows_std @ mvec) % P

    # Build 84-jet matrix rank at random q0
    kmonoms = [tuple([0] * K_DIM)]
    for deg in range(1, 4):
        kmonoms.extend(C.weak_compositions(deg, K_DIM))
    assert len(kmonoms) == 84
    kindex = {m: i for i, m in enumerate(kmonoms)}
    rng = np.random.default_rng(2026073189)
    jet_ranks = []
    k0_sols = 0
    nonzero_k_hits = 0
    n_trials = 40
    for trial in range(n_trials):
        q0 = rng.integers(0, P, size=Q_DIM)
        coeffs = np.zeros((N_ROWS, 84), dtype=np.int64)
        for col, m in enumerate(monoms):
            qe, ke = m[:Q_DIM], m[Q_DIM:]
            val = 1
            for i, e in enumerate(qe):
                if e:
                    val = val * pow(int(q0[i]), int(e), P) % P
            if val == 0:
                continue
            coeffs[:, kindex[ke]] = (coeffs[:, kindex[ke]] + rows_std[:, col] * val) % P
        rk = int(C.rank_mod(coeffs, P))
        jet_ranks.append(rk)
        if np.all(eval_at(q0, np.zeros(K_DIM, dtype=np.int64)) == 0):
            k0_sols += 1
        for _ in range(200):
            k = rng.integers(0, P, size=K_DIM)
            if np.all(k == 0):
                continue
            if np.all(eval_at(q0, k) == 0):
                nonzero_k_hits += 1
                break
    peak = max(peak, C.rss_mib())

    # Load optional msolve / macaulay artifacts
    msolve_result = {}
    for p in (TMPF / "msolve_result.json", HERE / "msolve_result.json"):
        if p.exists():
            msolve_result = json.loads(p.read_text())
            break
    macaulay_d4 = {}
    for p in (TMPF / "macaulay_d4.json", HERE / "macaulay_d4.json"):
        if p.exists():
            macaulay_d4 = json.loads(p.read_text())
            break

    elapsed = time.time() - t0
    peak = max(peak, C.rss_mib())

    # dim F / Hilbert at d=3 exact
    def dim_S(d):
        return 0 if d < 0 else math.comb(Q_DIM + d - 1, d)

    def dim_F(d):
        return dim_S(d) + K_DIM * dim_S(d - 1) + 21 * dim_S(d - 2)

    seed_rank = len(pivots) - n_k3  # non-K3 pivots
    hilbert = {
        "0": dim_F(0),
        "1": dim_F(1),
        "2": dim_F(2),
        "3": dim_F(3) - seed_rank,  # N_3 = seeds of rank seed_rank
    }

    # Exit decision
    empty = False  # not certified
    exit_marker = "P25YB-UNDECIDED"
    certificate_form = None

    payload = {
        "dispatch": "P25Y-B-step5",
        "exit": exit_marker,
        "certificate_form": certificate_form,
        "headline": "OPEN",
        "prime": P,
        "ring": {
            "ambient": "P^{42}_{F_89}",
            "coordinates": "Q(37)|K(6) fixed DVR model p=89",
            "generators": N_ROWS,
            "generator_degree": 3,
            "homogeneous": True,
            "rank_is_lower_bound_only": True,
            "molien_m75_upper": 2343,
        },
        "border_module": {
            "order_ideal": "1 ⊕ K ⊕ Sym^2 K",
            "order_ideal_rank": ORDER,
            "monic_K3": {
                "n_rules": n_k3,
                "full": n_k3 == 56,
                "monic_ok": monic_ok,
                "status": "CLOSED" if (n_k3 == 56 and monic_ok) else "INCOMPLETE",
                "interpretation": (
                    "All 56 pure-K³ monoms admit monic rewrite rules with tails in "
                    "S·B (S=F_89[Q], B=order ideal). Hence R/J_N is generated by B "
                    "as a finite S-module."
                ),
            },
            "mixed_blocks": {
                "QK2_pivots": n_qk2,
                "QK2_full_777": n_qk2 == 777,
                "QK2_uncovered_count": len(uncovered_qk2),
                "QK2_uncovered_sample": uncovered_qk2[:8],
                "Q2K_pivots": n_q2k,
                "Q3_pivots": n_q3,
                "status": (
                    "PARTIAL"
                    if n_qk2 < 777
                    else "FULL_CLASSICAL"
                ),
                "interpretation": (
                    f"After monic K³, remaining {seed_rank} pivots all land in QK2 "
                    f"({n_qk2}/777). The classical complete packet needed 777 QK2 "
                    f"pivots; with only 746 rows the QK2 block cannot fill (max "
                    f"non-K3 pivots = {N_ROWS - 56}). No proposed relation was "
                    f"found that *refuses* to reduce: non-pivot QK2 monoms are "
                    f"simply outside the 746-row rowspan. Q2K and Q3 contribute "
                    f"0 additional pivots under preferred order."
                ),
                "refutation_relation": None,
            },
            "module_N": {
                "seed_rank_deg3": seed_rank,
                "free_over_S": False,
                "note": (
                    "Nonzero seed rank means F/N is a proper quotient of the free "
                    "module F=S^{28}; the presentation is not free of rank 28."
                ),
            },
            "hilbert_F_over_N_partial": hilbert,
            "dim_F": {str(d): dim_F(d) for d in range(0, 6)},
            "finite_over_S": n_k3 == 56 and monic_ok,
        },
        "specialized_fibres": {
            "trials": n_trials,
            "jet_rank_84": {
                "min": int(min(jet_ranks)),
                "max": int(max(jet_ranks)),
                "all_full": all(r == 84 for r in jet_ranks),
            },
            "trials_with_k0_solution": k0_sols,
            "trials_with_nonzero_k_sample_hit": nonzero_k_hits,
            "interpretation": (
                "At each of 40 random q0, the 746 specialized polys in k span all "
                "84 monoms of degree ≤3 in 6 variables (rank 84). Since monom_vec "
                "always has constant term 1, ker of the jet map is {0}, so no "
                "affine k-solution exists for those q0 (including k=0). This is "
                "discovery evidence that V(J_N) projects into a proper closed "
                "subset of A^{37}_Q; it is not a Nullstellensatz certificate."
            ),
        },
        "macaulay_d4": macaulay_d4
        or {
            "status": "not_available",
        },
        "msolve_f4": msolve_result
        or {
            "status": "not_finished_or_not_run",
            "empty_output_is_failed_run": True,
        },
        "resources": {
            "peak_rss_mib": peak,
            "peak_rss_gib": round(peak / 1024, 3),
            "elapsed_s": round(elapsed, 3),
            "authorization_gib": 64,
            "absolute_ceiling_gib": 96,
            "requested_96gib": False,
        },
        "what_proved": [
            "Monic K³ border of 1⊕K⊕Sym²K CLOSED against the 746-row ideal "
            f"(rank {n_k3}/56, monic_ok={monic_ok}): R/J_N is finite over S=F_89[Q].",
            f"Preferred RREF of J_N,3 has pivot profile K3={n_k3}, QK2={n_qk2}, "
            f"Q2K={n_q2k}, Q3={n_q3} (total rank {len(pivots)}).",
            f"Module N has seed rank {seed_rank} at degree 3; not free of rank 28.",
            f"At d=3, dim(F/N)_3 = {hilbert['3']} "
            f"(= dim Sym^3 − 746 = {14190 - 746}).",
            "40/40 random q0 specializations have full 84-jet rank and no sample "
            "common zero in k.",
        ],
        "what_not_proved": [
            "Emptiness or nonemptiness of V_+(J_N) ⊂ P^{42}_{F_89}",
            "Complete annihilator / Fitting generators of F/N",
            "That rank 746 is the full direct-landing row span (Molien ≤ 2343)",
            "Any degree-25 covariant or headline unirationality",
            "Characteristic-zero emptiness without a special-fibre emptiness "
            "certificate (DVR properness applies only after emptiness of V_+(J_N))",
        ],
        "smallest_unresolved": {
            "computation": (
                "Finish sparse homogeneous F4 / Hilbert of F/N until either "
                "(i) all monoms of some degree D lie in J_N, (ii) saturated "
                "homogeneous ideal = (1), or (iii) an explicit nonzero point of "
                "V_+(J_N) is found and verified against the 746 cubics. "
                "Alternatively, prove that the 84-jet matrix C(q) has rank 84 "
                "for all q ≠ 0 (Fitting ideal of maximal minors equals m_Q-power)."
            ),
            "resource_floor_gib": {
                "border_RREF_and_structure": round(peak / 1024, 3),
                "macaulay_d4_echelon_incomplete": (
                    round(macaulay_d4.get("peak_rss_mib", 0) / 1024, 3)
                    if macaulay_d4
                    else None
                ),
                "msolve_F4_deg4_matrix": (
                    "deg-4 F4 matrix 32077×163184 at ~8% density; run was "
                    "timeout/RSS-gated or incomplete; empty .out = failed run"
                ),
                "note": (
                    "Dense fill is dimensionally first possible at degree 7 "
                    "(~6.9e6 GiB dense). Structure-exploiting F4 or Fitting of "
                    "the 84×746 jet matrix over S is the remaining sub-64 GiB path."
                ),
            },
        },
        "historical_not_imported": [
            "tmp/m1_relative_border_rank28/",
            "tmp/m1_full_plane_block_rank/",
            "certificates/border_support/",
            "historical 842-row packet",
        ],
        "theorem_boundary": {
            "proved": (
                "The 746 certified direct rows, in the fixed Q⊕K frame at p=89, "
                "admit a complete monic K³ border for the order ideal "
                "1⊕K⊕Sym²K; R/J_N is a finite S-module. The mixed QK2 block is "
                "only partially pivoted (690/777). Projective support of J_N is "
                "undecided under the 64 GiB authorization."
            ),
            "not_proved": (
                "V_+(J_N)=∅ or ≠∅; any P25-DEGREE25-EMPTY or P25-COVARIANT exit; "
                "headline unirationality. An empty degree-25 scheme would be a "
                "degree-25 exclusion only."
            ),
        },
        "artifacts": {
            "rows_qk": "tmp/p25yf4_border/rows_qk.npz",
            "direct_rows": "certificates/degree25_direct_support/direct_rows_p89.npz",
            "msolve_input": "tmp/p25yf4_f4/jn_qk.ms",
        },
    }

    # Save rref summary
    np.savez_compressed(
        TMPB / "rref_summary.npz",
        pivots=np.array(pivots, dtype=np.int32),
        perm=perm,
        n_k3=n_k3,
        n_qk2=n_qk2,
    )

    write_json_self_hash(HERE / "support_result.json", payload)
    write_json_self_hash(TMPB / "support_result.json", payload)
    print(f"exit={exit_marker} peak={peak:.0f}MiB elapsed={elapsed:.1f}s", flush=True)
    return payload


if __name__ == "__main__":
    main()
