#!/usr/bin/env python3
"""P25W.2 Stage A — multihomogeneous emptiness of the b0=b1=0 stratum.

Stratum: only the 21 quadratic-basis dual variables β ∈ P^{20}.
Equations: M2(q) β = 0, with M2 the 690×21 linear block of the sealed seed matrix.

Equivalent pure-tensor formulation:
  N(β) q = 0  with N(β) = Σ_j β_j B_j ∈ Mat_{690×37}(F_89),
  which is T · vec(β q^T) = 0 for the flattening T ∈ Mat_{690×777}.

Certificate:
  1. rank(T) = 690, so ker(T) has dimension 87.
  2. Parametrize K = ker(T) by a ∈ F^{87}: M(a) ∈ Mat_{21×37}.
  3. Rank(M) ≤ 1 iff all 2×2 minors of M(a) vanish (homogeneous quadrics in a).
  4. A deterministic set of 4000 minors spans the full 3828-dimensional space of
     homogeneous quadrics on F^{87}. Hence the only common zero is a = 0.
  5. Therefore K contains no nonzero rank-1 matrix, so no (q,β) both nonzero
     satisfy the Stage A equations. The multihomogeneous saturation by the
     q-irrelevant and β-irrelevant ideals is (1) on this stratum.

Writes only under certificates/degree25_p25w/ and tmp/p25w_stageA/.
Does not import the verifier. Peak RSS stays well under 8 GiB.
"""
from __future__ import annotations

import json
import sys
import time
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
FM = ROOT / "certificates" / "degree25_finite_module"
TMP = ROOT / "tmp" / "p25w_stageA"
HERE.mkdir(parents=True, exist_ok=True)
TMP.mkdir(parents=True, exist_ok=True)

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89
SEED_RNG = 20260731
N_MINOR_SAMPLE = 4000


def main() -> None:
    t0 = time.time()
    peak = C.rss_mib()
    print("=== P25W.2 Stage A produce ===", flush=True)

    rel = np.load(FM / "relation_matrix.npz")
    seed = rel["seed_F3"]
    off3 = rel["off3"]
    seed_sha = C.sha256_arr(seed)
    print(f"seed_F3 sha256={seed_sha} shape={seed.shape}", flush=True)

    m1 = C.weak_compositions(1, 37)
    var_of = np.array(
        [[i for i, e in enumerate(m) if e][0] for m in m1], dtype=np.int32
    )

    # Flattening T: 690 × (21*37), columns ordered (j, var) with var = 0..36.
    T = np.zeros((690, 21 * 37), dtype=np.int64)
    for j in range(21):
        block = seed[:, off3[7 + j] : off3[8 + j]].astype(np.int64) % P
        for mi, v in enumerate(var_of):
            T[:, j * 37 + int(v)] = block[:, mi]
    peak = max(peak, C.rss_mib())

    rk = C.rank_mod(T, P)
    ns = C.nullspace_rows(T, P)
    ker_dim = int(ns.shape[0])
    print(f"flattening rank={rk}/777 ker_dim={ker_dim} rss={peak:.0f}", flush=True)
    assert rk == 690
    assert ker_dim == 87

    # Basis matrices of K = ker(T) as 21×37 arrays.
    K = (ns.reshape(ker_dim, 21, 37) % P).astype(np.int64)
    nquad = ker_dim * (ker_dim + 1) // 2  # dim of homogeneous quadrics
    assert nquad == 3828

    minors: list[tuple[int, int, int, int]] = []
    for r1 in range(21):
        for r2 in range(r1 + 1, 21):
            for c1 in range(37):
                for c2 in range(c1 + 1, 37):
                    minors.append((r1, r2, c1, c2))
    assert len(minors) == 210 * 666

    rng = np.random.default_rng(SEED_RNG)
    sel = np.sort(rng.choice(len(minors), size=N_MINOR_SAMPLE, replace=False)).astype(
        np.int32
    )

    inv2 = pow(2, P - 2, P)
    tri = np.triu_indices(ker_dim)
    M = np.zeros((N_MINOR_SAMPLE, nquad), dtype=np.int64)
    for ii, sidx in enumerate(sel):
        r1, r2, c1, c2 = minors[int(sidx)]
        L11 = K[:, r1, c1]
        L12 = K[:, r1, c2]
        L21 = K[:, r2, c1]
        L22 = K[:, r2, c2]
        # Quadratic form of the 2×2 minor as packed monom coeffs a_i a_j (i≤j).
        O = (
            np.outer(L11, L22)
            + np.outer(L22, L11)
            - np.outer(L12, L21)
            - np.outer(L21, L12)
        ) % P
        O[np.arange(ker_dim), np.arange(ker_dim)] = (O.diagonal() * inv2) % P
        M[ii] = O[tri] % P
        if (ii + 1) % 1000 == 0:
            print(f"  built minor rows {ii+1}/{N_MINOR_SAMPLE}", flush=True)

    peak = max(peak, C.rss_mib())
    t_rank = time.time()
    rk_quad = C.rank_mod(M, P)
    print(
        f"quadric span rank={rk_quad}/{nquad} t={time.time()-t_rank:.1f}s "
        f"rss={C.rss_mib():.0f}",
        flush=True,
    )
    assert rk_quad == nquad, "Stage A certificate requires full quadric span"

    # Spot-check: random elements of K have full row-rank 21 (sanity, not the proof).
    ranks = []
    for _ in range(200):
        a = rng.integers(0, P, size=ker_dim)
        mat = (a @ ns.reshape(ker_dim, 21 * 37)).reshape(21, 37) % P
        ranks.append(C.rank_mod(mat, P))
    from collections import Counter

    rank_hist = {str(k): int(v) for k, v in Counter(ranks).items()}
    print(f"random K ranks (sanity): {rank_hist}", flush=True)

    peak = max(peak, C.rss_mib())
    elapsed = time.time() - t0

    # Persist certificate inputs for the independent verifier.
    cert_npz = HERE / "stageA_certificate.npz"
    np.savez_compressed(
        cert_npz,
        T=T.astype(np.uint8),
        ns=ns.astype(np.uint8),
        sel=sel,
        prime=np.int32(P),
        seed_rng=np.int64(SEED_RNG),
        n_minor_sample=np.int32(N_MINOR_SAMPLE),
        nquad=np.int32(nquad),
        flatten_rank=np.int32(rk),
        ker_dim=np.int32(ker_dim),
        quadric_rank=np.int32(rk_quad),
    )
    # Also keep a tmp copy of selection metadata.
    np.savez_compressed(
        TMP / "stageA_cert_data.npz",
        sel=sel,
        seed_sha=np.array(seed_sha),
        prime=np.int32(P),
    )

    payload = {
        "dispatch": "P25W.2-StageA",
        "exit": "P25W-STAGEA-EMPTY",
        "prime": P,
        "stratum": "b0=b1=0 (21 quadratic dual variables only)",
        "method": (
            "Flatten bilinear Stage-A equations to T ∈ Mat_690×777(F_89); "
            "ker dim 87; 2×2 minors of the parametric ker matrix span all "
            "homogeneous quadrics on F^{87}, so only the zero matrix in ker "
            "has rank ≤ 1. Hence no nonzero pure tensor β⊗q lies in ker(T)."
        ),
        "inputs": {
            "relation_matrix": str(FM / "relation_matrix.npz"),
            "seed_F3_sha256": seed_sha,
            "seed_F3_shape": list(seed.shape),
        },
        "flattening": {
            "shape": [690, 777],
            "rank": rk,
            "ker_dim": ker_dim,
            "T_sha256": C.sha256_arr(T.astype(np.uint8)),
            "ns_sha256": C.sha256_arr(ns.astype(np.uint8)),
        },
        "quadric_span": {
            "n_parameters": ker_dim,
            "dim_homogeneous_quadrics": nquad,
            "n_minors_total": len(minors),
            "n_minors_sampled": N_MINOR_SAMPLE,
            "sample_seed_rng": SEED_RNG,
            "sample_rank": rk_quad,
            "full_span": True,
            "sel_sha256": C.sha256_arr(sel),
            "M_sample_sha256": C.sha256_arr(M.astype(np.uint8)),
        },
        "sanity_random_K_ranks": rank_hist,
        "theorem": {
            "proves": (
                "The multihomogeneous Stage-A incidence "
                "{(q,β) ∈ P^{36}×P^{20} : M2(q) β = 0} is empty. "
                "Equivalently, after saturating the bihomogeneous ideal of the "
                "690 bilinear equations by the q-irrelevant and β-irrelevant "
                "ideals, one obtains the unit ideal on this stratum."
            ),
            "does_not_prove": (
                "Emptiness of the full kernel incidence (b0,b1 not necessarily "
                "zero); emptiness of the true landing scheme; any characteristic-zero "
                "rank statement; exactness of the 690-row presentation."
            ),
            "scope": "Exact linear algebra over F_89 only.",
        },
        "artifact": str(cert_npz.relative_to(ROOT)),
        "resource": {
            "peak_rss_mib": peak,
            "elapsed_seconds": elapsed,
            "memory_ceiling_gib": 8,
        },
    }
    C.write_json_self_hash(HERE / "stageA_result.json", payload)
    print(f"DONE exit=P25W-STAGEA-EMPTY peak_rss={peak:.0f} MiB t={elapsed:.1f}s", flush=True)


if __name__ == "__main__":
    main()
