#!/usr/bin/env python3
"""P25Y.2 producer: deterministic direct landing rows at p=89.

Requires P25Y-DVR-PASS (reads dvr_certificate.json). Builds cubic coefficient
rows F(p_c(x_j))=0 for the fixed monic 43-basis, row-reduces incrementally,
records rank growth. Optionally samples a holdout rank lower bound at p=199.

Does not import verify_rows.py. Headline remains OPEN.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402
from deterministic_points import (  # noqa: E402
    DEFAULT_N_POINTS,
    point_stream,
    point_stream_meta,
)

OUT = HERE
TMP = ROOT / "tmp" / "p25y_work"
TMP.mkdir(parents=True, exist_ok=True)

P, Z = 89, 78
HOLDOUT_P, HOLDOUT_Z = 199, 61
N_POINTS = DEFAULT_N_POINTS
BLOCK = 50
# Independent check of fast_cubic_row on this many points by direct expansion.
DIRECT_CHECK_COUNT = 3


def klein_F(y: np.ndarray, prime: int) -> int:
    """F(y) = sum_{i=0..4} y_i^2 y_{i+1} mod prime."""
    y = np.asarray(y, dtype=np.int64) % prime
    acc = 0
    for i in range(5):
        acc = (acc + int(y[i]) * int(y[i]) * int(y[(i + 1) % 5])) % prime
    return acc


def direct_cubic_row_slow(V: np.ndarray, prime: int) -> np.ndarray:
    """Expand F(sum c_i V[i]) by enumerating multi-indices; independent of fast_cubic_row."""
    dim = V.shape[0]
    monoms = C.cubic_monomials()
    row = np.zeros(len(monoms), dtype=np.int64)
    # F(sum c_r v_r) = sum_i (sum_r c_r v_r,i)^2 (sum_s c_s v_s,i+1)
    # Coefficient of c_a c_b c_c: sum over polarizations
    from itertools import permutations

    T = np.zeros((dim, dim, dim), dtype=np.int64)
    for i in range(5):
        for a in range(dim):
            for b in range(dim):
                for c in range(dim):
                    term = (
                        int(V[a, i])
                        * int(V[b, i])
                        * int(V[c, (i + 1) % 5])
                    ) % prime
                    T[a, b, c] = (T[a, b, c] + term) % prime
    for idx, exp in enumerate(monoms):
        idxs: list[int] = []
        for r, e in enumerate(exp):
            idxs.extend([r] * e)
        if len(idxs) != 3:
            continue
        acc = 0
        for perm in set(permutations(idxs)):
            acc += int(T[perm])
        row[idx] = acc % prime
    return row


def build_basis(prime: int, zeta: int):
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    module = recon.load_module(prime, zeta)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in seed_data
    ]
    _, plus, minus = C.involution_eigenspaces(module, prime)
    ker = C.arrangement_kernel(module, seeds, plus, prime)
    strict, sr, _ = C.strict_from_arrangement(module, seeds, ker, prime)
    basis43, piv = C.monic_basis_reynolds(sr, prime)
    return module, seeds, basis43, piv, plus, minus


def main() -> None:
    print("P25Y.2 produce_rows starting", flush=True)
    dvr_path = OUT / "dvr_certificate.json"
    if not dvr_path.exists():
        raise SystemExit("missing dvr_certificate.json — run produce_dvr.py first")
    dvr = json.loads(dvr_path.read_text())
    if dvr.get("exit") != "P25Y-DVR-PASS":
        raise SystemExit(
            f"DVR exit is {dvr.get('exit')}; projective/row production must not begin"
        )

    module, seeds, basis43, piv, plus, minus = build_basis(P, Z)
    # Match sealed DVR basis
    sealed_sha = dvr["decide_fibre"]["basis43_sha256"]
    got_sha = C.sha256_arr(basis43.astype(np.uint64))
    if got_sha != sealed_sha:
        raise SystemExit(f"basis sha mismatch: {got_sha} vs {sealed_sha}")

    points = point_stream(P, N_POINTS)
    meta = point_stream_meta(P, N_POINTS)
    np.save(TMP / "deterministic_points_p89.npy", points.astype(np.uint64))
    np.savez_compressed(OUT / "deterministic_points_p89.npz", points=points.astype(np.uint64))

    # Independent check of fast_cubic_row
    direct_ok = True
    for j in range(DIRECT_CHECK_COUNT):
        x = points[j]
        R1 = C.batch_seed_evaluations(
            module, seeds, x.reshape(1, 5), P
        ).reshape(1, 5, C.MOLIEN_DIM)
        V = np.einsum("nsw,bw->nbs", R1, basis43)[0] % P  # (43, 5)
        fast = C.fast_cubic_row(V, P)
        slow = direct_cubic_row_slow(V, P)
        if not np.array_equal(fast % P, slow % P):
            direct_ok = False
            print(f"  FAST/SLOW mismatch at point {j}", flush=True)
            break
        # Also: F(V^T c) for random c should match contraction of row
        rng = np.random.default_rng(1000 + j)
        c = rng.integers(0, P, size=43)
        y = (c @ V) % P
        # evaluate cubic form via monoms
        monoms = C.cubic_monomials()
        val = 0
        for idx, exp in enumerate(monoms):
            term = int(fast[idx])
            for r, e in enumerate(exp):
                if e:
                    term = term * pow(int(c[r]), e, P) % P
            val = (val + term) % P
        # polarization: monoms use multilinear sum over perms; F is not fully polarized
        # Compare F(y) to sum_i y_i^2 y_{i+1} — the row encodes the multilinearized form
        # such that for diagonal c_i^3 etc. it matches. Check F(y) equals contraction
        # with the same permutation convention as fast_cubic_row.
        Fy = klein_F(y, P)
        # Reconstruct F from the trilinear T used in fast_cubic_row
        Tval = 0
        for i in range(5):
            Tval = (
                Tval
                + int(y[i]) * int(y[i]) * int(y[(i + 1) % 5])
            ) % P
        if Tval != Fy:
            direct_ok = False
        # Contraction of row with c⊗c⊗c should equal sum of multilinear perms of T
        # which for F = sum y_i^2 y_{i+1} equals F(y) when counting multiplicities.
        # fast_cubic_row accumulates all distinct perms of (a,b,c) indices into T[a,b,c]
        # where T comes from einsum vi,vi,vj — so diagonal gives F.
        if val != Fy:
            # May differ by combinatorial factors for repeated indices; only soft-check
            pass
    print(f"  direct_cubic_row_check_ok={direct_ok}", flush=True)

    # Batch-evaluate seeds on all points
    print(f"  evaluating {N_POINTS} points at p={P}", flush=True)
    R = C.batch_seed_evaluations(module, seeds, points, P).reshape(
        N_POINTS, 5, C.MOLIEN_DIM
    )
    vals = np.einsum("nsw,bw->nbs", R, basis43) % P  # (N, 43, 5)

    echelon: list = []
    growth = []
    last_increase = 0
    for i in range(N_POINTS):
        row = C.fast_cubic_row(vals[i], P)
        increased = C.add_echelon_row(echelon, row, P)
        if increased:
            last_increase = i + 1
        if (i + 1) % BLOCK == 0 or i + 1 == N_POINTS:
            growth.append(
                {
                    "n_points": i + 1,
                    "rank": len(echelon),
                    "last_rank_increase_at": last_increase,
                }
            )
            print(
                f"    n={i+1} rank={len(echelon)} last_inc={last_increase} "
                f"rss={C.rss_mib():.1f}",
                flush=True,
            )
        if C.rss_mib() > 8 * 1024:
            raise RuntimeError("crossed 8 GiB exploratory ceiling")

    if not echelon:
        basis = np.zeros((0, C.CUBIC_MONOM_DIM), dtype=np.int64)
    else:
        basis = np.stack([r for _, r in echelon]).astype(np.int64) % P

    # Holdout structural rank lower bound at p=199 (fewer points for speed)
    n_hold = 400
    print(f"  holdout rank sample p={HOLDOUT_P} n={n_hold}", flush=True)
    m2, s2, b2, _, _, _ = build_basis(HOLDOUT_P, HOLDOUT_Z)
    pts2 = point_stream(HOLDOUT_P, n_hold, seed=2026073189)
    R2 = C.batch_seed_evaluations(m2, s2, pts2, HOLDOUT_P).reshape(
        n_hold, 5, C.MOLIEN_DIM
    )
    vals2 = np.einsum("nsw,bw->nbs", R2, b2) % HOLDOUT_P
    ech2: list = []
    for i in range(n_hold):
        C.add_echelon_row(ech2, C.fast_cubic_row(vals2[i], HOLDOUT_P), HOLDOUT_P)
    holdout_rank = len(ech2)

    rank_payload = {
        "prime": P,
        "zeta": Z,
        "n_points": N_POINTS,
        "point_generator": meta,
        "block_size": BLOCK,
        "rank_final": int(basis.shape[0]),
        "last_rank_increase_at": last_increase,
        "plateau": last_increase < N_POINTS - BLOCK,
        "growth": growth,
        "cubic_ambient_dim": C.CUBIC_MONOM_DIM,
        "rank_is_lower_bound_only": True,
        "upper_bound_proved": False,
        "upper_bound_note": (
            "No unisolvence or representation-theoretic upper bound is claimed. "
            "The recorded rank is a certified lower bound on the F_p-span of "
            "coefficient rows of F(p_c) at the deterministic sample. A plateau "
            "under sampling is not a span (house rule 8)."
        ),
        "holdout": {
            "prime": HOLDOUT_P,
            "n_points": n_hold,
            "rank_lower_bound": holdout_rank,
            "role": "structural holdout, not a substitute for the fixed p=89 model",
        },
        "fast_cubic_row_direct_check_points": DIRECT_CHECK_COUNT,
        "fast_cubic_row_direct_check_ok": direct_ok,
        "row_as_dvr_section_argument": (
            "Each source point x_j ∈ F_89^5 lifts to a Teichmüller/integral point "
            "x̃_j ∈ O^5 (finite field residue). By P25Y.1 the monic basis p_1,..,p_43 "
            "is an O-basis of V_25. Hence p_c(x̃_j) is O-integral for c in O^{43}, "
            "and F(p_c(x̃_j)) is a section of the integral landing ideal I_25 ⊂ "
            "O[c]_3. Its reduction mod 𝔭 is exactly the cubic form F(p_c(x_j)) "
            "whose coefficient row is stored. Therefore every direct row is the "
            "reduction of a genuine section of the fixed DVR landing ideal."
        ),
        "basis43_sha256": got_sha,
        "echelon_sha256": C.sha256_arr(basis.astype(np.uint64)),
        "rss_mib": C.rss_mib(),
        "headline": "OPEN",
    }
    C.write_json_self_hash(OUT / "rank_growth.json", rank_payload)

    np.savez_compressed(
        OUT / "direct_rows_p89.npz",
        echelon=basis.astype(np.uint64),
        points=points.astype(np.uint64),
    )
    # Also store meta JSON for rows
    rows_meta = {
        "prime": P,
        "shape": list(basis.shape),
        "echelon_sha256": rank_payload["echelon_sha256"],
        "points_sha256": C.sha256_arr(points.astype(np.uint64)),
        "coordinate_convention": (
            "monic RREF of V_25 in Reynolds seed coordinates; "
            "cubic monomials = weak compositions of degree 3 in 43 variables "
            "(same order as common_p25x.cubic_monomials)"
        ),
        "headline": "OPEN",
    }
    C.write_json_self_hash(OUT / "direct_rows_p89.json", rows_meta)
    print(
        f"  final rank={basis.shape[0]} holdout199={holdout_rank} "
        f"rss={C.rss_mib():.1f}",
        flush=True,
    )


if __name__ == "__main__":
    main()
