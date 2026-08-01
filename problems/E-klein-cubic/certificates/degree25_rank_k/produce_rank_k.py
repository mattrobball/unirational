#!/usr/bin/env python3
"""P25W.3 producer: exact unisolvent ranks at additional good primes and
characteristic-zero landing-rank preflight / reconstruction attempt.

Writes only under certificates/degree25_rank_k/ and tmp/p25w3_work/.
Does not import verify_rank_k.py. Does not touch degree25_rowrank/,
degree25_p25w/, target_branch_t10/, or fano_c2/.

Headline remains OPEN. A modular rank is never silently promoted to char-0.
"""

from __future__ import annotations

import json
import sys
import time
from itertools import permutations
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
ROW = ROOT / "certificates" / "degree25_rowrank"
sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

OUT = HERE
TMP = ROOT / "tmp" / "p25w3_work"
TMP.mkdir(parents=True, exist_ok=True)

M75 = 2343
DEG = 75
N_PROBE = 2500
CANDIDATE_BATCH = 200
MAX_CANDIDATE_POINTS = 25000
RSS_LIMIT_MIB = 8 * 1024

# Good split primes p ≡ 1 (mod 11). Seed offsets keep point searches independent.
PRIMES: list[tuple[int, int, int]] = [
    # (p, zeta, unisol_seed)
    (89, 78, 2026073190),  # sealed replay
    (199, 61, 2026073200),
    (353, 58, 2026073201),
]
PROBE_SEED_BASE = 2026073189
BASIS_SEED_BASE = 2026073189


def rss_mib() -> float:
    return C.rss_mib()


def check_rss(tag: str) -> float:
    r = rss_mib()
    if r > RSS_LIMIT_MIB:
        raise SystemExit(f"RSS {r:.1f} MiB exceeds 8 GiB ceiling at {tag}")
    return r


def load_group(prime: int, zeta: int):
    recon = C.load_reconstructor()
    mod = recon.load_module(prime, zeta)
    G = (mod.GROUP % prime).astype(np.int64)
    G_inv = np.array([C.invert_mod(G[i], prime) for i in range(len(G))], dtype=np.int64)
    inv_order = pow(int(G.shape[0]), -1, prime)
    return mod, G, G_inv, inv_order


def power_dtype(prime: int) -> np.dtype:
    """Storage dtype for values in 0..p-1."""
    if prime <= 255:
        return np.dtype(np.uint8)
    if prime <= 65535:
        return np.dtype(np.uint16)
    return np.dtype(np.uint32)


def build_power_table(G_inv: np.ndarray, points: np.ndarray, prime: int) -> np.ndarray:
    """powers[i, e, j, g] = (G_inv[g] @ points[j])_i ^ e."""
    z = np.einsum("gij,pj->pgi", G_inv, points) % prime  # (N, 660, 5)
    n = points.shape[0]
    dt = power_dtype(prime)
    powers = np.empty((5, DEG + 1, n, G_inv.shape[0]), dtype=dt)
    for i in range(5):
        powers[i, 0] = 1
        base = (z[:, :, i] % prime).astype(dt)
        powers[i, 1] = base
        for e in range(2, DEG + 1):
            powers[i, e] = (
                powers[i, e - 1].astype(np.int64) * base.astype(np.int64) % prime
            ).astype(dt)
    return powers


def reynolds_eval(
    powers: np.ndarray, alpha: tuple[int, ...], inv_order: int, prime: int
) -> np.ndarray:
    n = powers.shape[2]
    n_g = powers.shape[3]
    vals = np.ones((n, n_g), dtype=np.int64)
    for i, e in enumerate(alpha):
        if e:
            vals = vals * powers[i, e].astype(np.int64) % prime
    return (vals.sum(axis=1) % prime) * inv_order % prime


def reynolds_eval_batch_points(
    G_inv: np.ndarray,
    points: np.ndarray,
    monoms: np.ndarray,
    inv_order: int,
    prime: int,
) -> np.ndarray:
    powers = build_power_table(G_inv, points, prime)
    out = np.zeros((len(monoms), len(points)), dtype=np.int64)
    for mi, alpha in enumerate(monoms):
        out[mi] = reynolds_eval(
            powers, tuple(int(a) for a in alpha), inv_order, prime
        )
    del powers
    return out


def partitions_degree(d: int = 75, nvars: int = 5) -> list[tuple[int, ...]]:
    parts: list[tuple[int, ...]] = []

    def rec(remain: int, maxp: int, cur: list[int]) -> None:
        if remain == 0:
            parts.append(tuple(cur + [0] * (nvars - len(cur))))
            return
        if len(cur) >= nvars:
            return
        for p in range(min(maxp, remain), 0, -1):
            rec(remain - p, p, cur + [p])

    rec(d, d, [])
    return parts


def uniform_composition(rng: np.random.Generator, d: int = 75, n: int = 5) -> tuple[int, ...]:
    pos = np.sort(rng.choice(d + n - 1, size=n - 1, replace=False))
    comp = np.empty(n, dtype=np.int64)
    prev = -1
    for j, ppos in enumerate(pos):
        comp[j] = ppos - prev - 1
        prev = int(ppos)
    comp[n - 1] = d + n - 2 - prev
    return tuple(int(x) for x in comp)


def random_nonzero_points(rng: np.random.Generator, n: int, prime: int) -> np.ndarray:
    pts = []
    while len(pts) < n:
        x = rng.integers(0, prime, size=5, dtype=np.int64)
        if np.any(x):
            pts.append(x)
    return np.asarray(pts, dtype=np.int64)


def try_sealed_monoms(prime: int) -> np.ndarray | None:
    """Reuse sealed monoms from p=89 packet if present and well-formed."""
    path = ROW / "invariant_basis.npz"
    if not path.exists():
        return None
    data = np.load(path)
    monoms = data["monoms"].astype(np.int16)
    if monoms.shape != (M75, 5):
        return None
    if not np.all(monoms.sum(axis=1) == DEG):
        return None
    return monoms


def verify_monoms_independent(
    G_inv: np.ndarray, monoms: np.ndarray, inv_order: int, prime: int, seed: int
) -> tuple[bool, int, float]:
    """Eval-rank check of monoms on a fresh probe set."""
    rng = np.random.default_rng(seed)
    probe = random_nonzero_points(rng, N_PROBE, prime)
    t0 = time.time()
    powers = build_power_table(G_inv, probe, prime)
    ech: list = []
    for alpha in monoms:
        row = reynolds_eval(powers, tuple(int(a) for a in alpha), inv_order, prime)
        C.add_echelon_row(ech, row, prime)
        if len(ech) == M75:
            # still verify remaining are dependent? for basis check need all independent
            pass
    # Must get full rank M75
    # Re-run carefully: each of the M75 monoms must increase or total = M75
    del powers
    # Recompute properly: build full eval matrix and rank
    powers = build_power_table(G_inv, probe, prime)
    ech2: list = []
    for alpha in monoms:
        row = reynolds_eval(powers, tuple(int(a) for a in alpha), inv_order, prime)
        C.add_echelon_row(ech2, row, prime)
    del powers
    rank = len(ech2)
    return rank == M75, rank, time.time() - t0


def build_invariant_basis(
    G_inv: np.ndarray, inv_order: int, prime: int, seed: int
) -> tuple[np.ndarray, dict]:
    """Return (M75, 5) monom exponents certified independent over F_p."""
    ckpt = TMP / f"invariant_monoms_p{prime}.npy"
    sealed = try_sealed_monoms(prime)
    if sealed is not None:
        print(f"  p={prime}: verifying sealed monoms independence...", flush=True)
        ok, rank, secs = verify_monoms_independent(
            G_inv, sealed, inv_order, prime, seed
        )
        if ok:
            np.save(ckpt, sealed)
            meta = {
                "m_75": M75,
                "n_probe": N_PROBE,
                "probe_seed": seed,
                "basis_rank": M75,
                "n_selected": M75,
                "fill_trials": 0,
                "build_seconds": secs,
                "rss_mib_after_basis": rss_mib(),
                "method": "sealed monoms from degree25_rowrank/invariant_basis.npz; "
                "independence by eval rank on probe set",
                "source": str(ROW / "invariant_basis.npz"),
                "reverified": True,
            }
            print(f"  p={prime}: sealed monoms OK (rank {M75}) in {secs:.1f}s", flush=True)
            return sealed, meta
        print(f"  p={prime}: sealed monoms failed (rank {rank}); rebuilding...", flush=True)

    if ckpt.exists():
        loaded = np.load(ckpt).astype(np.int16)
        if loaded.shape == (M75, 5) and np.all(loaded.sum(axis=1) == DEG):
            ok, rank, secs = verify_monoms_independent(
                G_inv, loaded, inv_order, prime, seed
            )
            if ok:
                meta = {
                    "m_75": M75,
                    "n_probe": N_PROBE,
                    "probe_seed": seed,
                    "basis_rank": M75,
                    "n_selected": M75,
                    "fill_trials": 0,
                    "build_seconds": secs,
                    "rss_mib_after_basis": rss_mib(),
                    "method": f"checkpoint {ckpt.name}; independence re-verified",
                    "source": str(ckpt),
                    "reverified": True,
                }
                return loaded, meta

    print(f"  p={prime}: building invariant basis from scratch...", flush=True)
    rng = np.random.default_rng(seed)
    probe = random_nonzero_points(rng, N_PROBE, prime)
    t0 = time.time()
    powers = build_power_table(G_inv, probe, prime)
    print(
        f"  p={prime}: power table {powers.nbytes / 1e6:.0f} MB rss={rss_mib():.0f}",
        flush=True,
    )
    check_rss(f"power_table_p{prime}")

    ech: list = []
    selected: list[tuple[int, ...]] = []
    seen: set[tuple[int, ...]] = set()
    parts = partitions_degree(75, 5)
    for alpha in parts:
        if alpha in seen:
            continue
        seen.add(alpha)
        row = reynolds_eval(powers, alpha, inv_order, prime)
        if C.add_echelon_row(ech, row, prime):
            selected.append(alpha)
            if len(selected) % 200 == 0:
                print(f"    p={prime} rank={len(ech)} t={time.time()-t0:.1f}s", flush=True)

    for alpha in parts:
        if len(ech) >= M75:
            break
        for perm in set(permutations(alpha)):
            if perm in seen:
                continue
            seen.add(perm)
            row = reynolds_eval(powers, perm, inv_order, prime)
            if C.add_echelon_row(ech, row, prime):
                selected.append(perm)
                if len(ech) >= M75:
                    break

    trials = 0
    rng_fill = np.random.default_rng(seed + 1)
    while len(ech) < M75 and trials < 100000:
        trials += 1
        alpha = uniform_composition(rng_fill)
        if alpha in seen:
            continue
        seen.add(alpha)
        row = reynolds_eval(powers, alpha, inv_order, prime)
        if C.add_echelon_row(ech, row, prime):
            selected.append(alpha)

    del powers
    if len(ech) != M75:
        raise SystemExit(f"p={prime}: failed to reach invariant rank {M75}; got {len(ech)}")

    monoms = np.asarray(selected, dtype=np.int16)
    np.save(ckpt, monoms)
    meta = {
        "m_75": M75,
        "n_probe": N_PROBE,
        "probe_seed": seed,
        "basis_rank": len(ech),
        "n_selected": len(selected),
        "fill_trials": trials,
        "build_seconds": time.time() - t0,
        "rss_mib_after_basis": rss_mib(),
        "method": "Reynolds orbit sums of degree-75 monomials; independence by eval rank",
        "source": "built",
        "reverified": False,
    }
    print(f"  p={prime}: invariant basis complete in {meta['build_seconds']:.1f}s", flush=True)
    return monoms, meta


def pivot_product_rref(matrix: np.ndarray, prime: int) -> tuple[int, int, list[int]]:
    a = (np.asarray(matrix, dtype=np.int64) % prime).copy()
    rows, cols = a.shape
    rank = 0
    pivots: list[int] = []
    prod = 1
    for c in range(cols):
        piv = next((i for i in range(rank, rows) if a[i, c] % prime), None)
        if piv is None:
            continue
        a[[rank, piv]] = a[[piv, rank]]
        pivot_val = int(a[rank, c]) % prime
        prod = (prod * pivot_val) % prime
        inv = pow(pivot_val, -1, prime)
        a[rank] = (a[rank] * inv) % prime
        for i in range(rows):
            if i != rank and a[i, c] % prime:
                a[i] = (a[i] - a[i, c] * a[rank]) % prime
        pivots.append(c)
        rank += 1
        if rank == rows:
            break
    return rank, prod, pivots


def find_unisolvent_points(
    G_inv: np.ndarray,
    monoms: np.ndarray,
    inv_order: int,
    prime: int,
    unisol_seed: int,
) -> tuple[np.ndarray, dict, np.ndarray]:
    print(f"  p={prime}: searching unisolvent points (seed={unisol_seed})...", flush=True)
    rng = np.random.default_rng(unisol_seed)
    selected_pts: list[np.ndarray] = []
    ech: list = []
    t0 = time.time()
    tried = 0
    batches = 0

    while len(ech) < M75 and tried < MAX_CANDIDATE_POINTS:
        batch = random_nonzero_points(rng, CANDIDATE_BATCH, prime)
        E = reynolds_eval_batch_points(G_inv, batch, monoms, inv_order, prime)
        for j in range(batch.shape[0]):
            tried += 1
            col = E[:, j].copy()
            if C.add_echelon_row(ech, col, prime):
                selected_pts.append(batch[j].copy())
                if len(selected_pts) % 200 == 0 or len(selected_pts) == M75:
                    print(
                        f"    p={prime} unisolvent rank={len(ech)} tried={tried} "
                        f"t={time.time()-t0:.1f}s rss={rss_mib():.0f}",
                        flush=True,
                    )
                if len(ech) >= M75:
                    break
        batches += 1
        check_rss(f"unisolvent_p{prime}")

    if len(ech) != M75:
        raise SystemExit(f"p={prime}: unisolvent search failed: rank {len(ech)} < {M75}")

    points = np.asarray(selected_pts, dtype=np.int64)
    print(f"  p={prime}: building square evaluation matrix...", flush=True)
    M = reynolds_eval_batch_points(G_inv, points, monoms, inv_order, prime)
    rank, pivot_prod, pivots = pivot_product_rref(M.T, prime)
    if rank != M75 or pivot_prod % prime == 0:
        raise SystemExit(
            f"p={prime}: unisolvence failed: rank={rank} pivot_prod={pivot_prod}"
        )
    meta = {
        "n_points": int(points.shape[0]),
        "unisolvent_seed": unisol_seed,
        "candidates_tried": tried,
        "batches": batches,
        "eval_matrix_rank": rank,
        "pivot_product_mod_p": int(pivot_prod),
        "n_pivots": len(pivots),
        "search_seconds": time.time() - t0,
        "rss_mib": rss_mib(),
        "invertible": True,
    }
    print(
        f"  p={prime}: unisolvence OK rank={rank} pivot_prod={pivot_prod} "
        f"t={meta['search_seconds']:.1f}s",
        flush=True,
    )
    return points, meta, M


def precompute_perm_lists():
    monoms = C.cubic_monomials()
    perm_lists = []
    for exp in monoms:
        idxs: list[int] = []
        for r, e in enumerate(exp):
            idxs.extend([r] * e)
        perm_lists.append(list(set(permutations(idxs))))
    return perm_lists


def fast_cubic_row_pre(V: np.ndarray, prime: int, perm_lists) -> np.ndarray:
    dim = V.shape[0]
    T = np.zeros((dim, dim, dim), dtype=np.int64)
    for i in range(5):
        vi = V[:, i].astype(np.int64) % prime
        vj = V[:, (i + 1) % 5].astype(np.int64) % prime
        T = (T + np.einsum("r,s,t->rst", vi, vi, vj)) % prime
    row = np.zeros(len(perm_lists), dtype=np.int64)
    for idx, perms in enumerate(perm_lists):
        acc = 0
        for perm in perms:
            acc += int(T[perm])
        row[idx] = acc % prime
    return row


def load_basis43(mod, prime: int):
    seed_data = C.load_seeds()
    seeds = [
        mod.ReynoldsSeed(int(r["output"]), tuple(r["exponents"])) for r in seed_data
    ]
    _, plus, minus = C.involution_eigenspaces(mod, prime)
    ker = C.arrangement_kernel(mod, seeds, plus, prime)
    strict, sr, _ = C.strict_from_arrangement(mod, seeds, ker, prime)
    basis43, piv = C.monic_basis_reynolds(sr, prime)
    return seeds, basis43, piv, plus, minus


def evaluate_landing_rank(
    mod, seeds, basis43, points: np.ndarray, perm_lists, prime: int
) -> tuple[int, np.ndarray, dict]:
    print(
        f"  p={prime}: evaluating landing rows at {len(points)} unisolvent points...",
        flush=True,
    )
    t0 = time.time()
    n = len(points)
    R = C.batch_seed_evaluations(mod, seeds, points, prime).reshape(
        n, 5, C.MOLIEN_DIM
    )
    vals = np.einsum("nsw,bw->nbs", R, basis43) % prime  # (n, 43, 5)

    # Spot-check vs common_p25x.fast_cubic_row
    for j in range(3):
        row = fast_cubic_row_pre(vals[j], prime, perm_lists)
        row_ref = C.fast_cubic_row(vals[j], prime)
        if not np.array_equal(row % prime, row_ref % prime):
            raise SystemExit(f"p={prime}: cubic row mismatch at point {j}")
    print(f"  p={prime}: cubic-row semantics check OK", flush=True)

    echelon: list = []
    last_increase = 0
    growth = []
    for i in range(n):
        row = fast_cubic_row_pre(vals[i], prime, perm_lists)
        if C.add_echelon_row(echelon, row, prime):
            last_increase = i + 1
        if (i + 1) % 400 == 0 or i + 1 == n:
            growth.append(
                {
                    "n_points": i + 1,
                    "rank": len(echelon),
                    "last_rank_increase_at": last_increase,
                }
            )
            print(
                f"    p={prime} n={i+1} rank={len(echelon)} last_inc={last_increase} "
                f"rss={rss_mib():.1f}",
                flush=True,
            )
        check_rss(f"landing_p{prime}")

    rank = len(echelon)
    echel_mat = np.zeros((rank, C.CUBIC_MONOM_DIM), dtype=np.int64)
    for i, (piv, erow) in enumerate(echelon):
        echel_mat[i] = erow

    meta = {
        "n_points": n,
        "rank": rank,
        "last_rank_increase_at": last_increase,
        "growth": growth,
        "seconds": time.time() - t0,
        "rss_mib": rss_mib(),
        "cubic_ambient_dim": C.CUBIC_MONOM_DIM,
    }
    print(f"  p={prime}: landing rank = {rank} in {meta['seconds']:.1f}s", flush=True)
    return rank, echel_mat, meta


def process_prime(
    prime: int, zeta: int, unisol_seed: int, perm_lists
) -> dict:
    t0 = time.time()
    print(f"\n=== prime {prime} (zeta={zeta}) ===", flush=True)
    peak = check_rss(f"start_p{prime}")
    mod, G, G_inv, inv_order = load_group(prime, zeta)
    print(f"  group order {G.shape[0]} rss={rss_mib():.0f}", flush=True)

    monoms, basis_meta = build_invariant_basis(
        G_inv, inv_order, prime, PROBE_SEED_BASE + prime
    )
    peak = max(peak, rss_mib())

    points, unisol_meta, eval_M = find_unisolvent_points(
        G_inv, monoms, inv_order, prime, unisol_seed
    )
    peak = max(peak, rss_mib())

    seeds, basis43, piv, plus, minus = load_basis43(mod, prime)
    basis_sha = C.sha256_arr(basis43.astype(np.uint64))
    print(f"  p={prime}: basis43 sha={basis_sha[:16]}... pivots={len(piv)}", flush=True)

    rank, echel_mat, land_meta = evaluate_landing_rank(
        mod, seeds, basis43, points, perm_lists, prime
    )
    peak = max(peak, rss_mib())

    # Persist per-prime artifacts under our write fence
    inv_path = OUT / f"invariant_basis_p{prime}.npz"
    pts_path = OUT / f"unisolvent_points_p{prime}.npz"
    rows_path = OUT / f"landing_echelon_p{prime}.npz"
    np.savez_compressed(
        inv_path,
        monoms=monoms.astype(np.int16),
        prime=np.int64(prime),
        m_75=np.int64(M75),
    )
    np.savez_compressed(
        pts_path,
        points=points.astype(np.uint64),
        eval_matrix=eval_M.astype(np.uint64),
        prime=np.int64(prime),
        zeta=np.int64(zeta),
    )
    np.savez_compressed(
        rows_path,
        echelon=echel_mat.astype(np.uint64),
        prime=np.int64(prime),
        rank=np.int64(rank),
    )

    result = {
        "prime": prime,
        "zeta": zeta,
        "rank": rank,
        "rank_is_exact": True,
        "m_75": M75,
        "unisolvence": {
            "eval_matrix_shape": [M75, M75],
            "eval_matrix_rank": unisol_meta["eval_matrix_rank"],
            "pivot_product_mod_p": unisol_meta["pivot_product_mod_p"],
            "invertible": True,
            "candidates_tried": unisol_meta["candidates_tried"],
            "seed": unisol_seed,
            "search_seconds": unisol_meta["search_seconds"],
        },
        "invariant_basis": basis_meta,
        "landing": land_meta,
        "basis43_sha256": basis_sha,
        "artifacts": {
            "invariant_basis": inv_path.name,
            "unisolvent_points": pts_path.name,
            "landing_echelon": rows_path.name,
        },
        "artifact_sha256": {
            inv_path.name: C.sha256_file(inv_path),
            pts_path.name: C.sha256_file(pts_path),
            rows_path.name: C.sha256_file(rows_path),
        },
        "peak_rss_mib": peak,
        "total_seconds": time.time() - t0,
        "theorem_boundary": (
            f"Proved over F_{prime}: rank(Λ_{prime}) = {rank} exactly, via "
            f"unisolvent evaluation model (invertible {M75}×{M75} Inv_75 eval matrix "
            f"with pivot product ≡ {unisol_meta['pivot_product_mod_p']} mod {prime}). "
            "This is an F_p statement, not a characteristic-zero rank."
        ),
    }

    cert_path = OUT / f"rank_p{prime}.json"
    C.write_json_self_hash(cert_path, result)
    print(
        f"  p={prime}: DONE rank={rank} pivot_prod={unisol_meta['pivot_product_mod_p']} "
        f"peak_rss={peak:.1f} MiB t={result['total_seconds']:.1f}s",
        flush=True,
    )
    # Free large temporaries
    del points, eval_M, echel_mat
    return result


def char0_preflight(prime_results: list[dict]) -> dict:
    """Measure resource floor for char-0 image/kernel reconstruction.

    Side choice: if all modular ranks equal r, image dim = r and kernel dim =
    14190 - r. Reconstruct the smaller side.
    """
    ranks = [int(r["rank"]) for r in prime_results]
    primes = [int(r["prime"]) for r in prime_results]
    r_min = min(ranks)
    r_max = max(ranks)
    ambient = C.CUBIC_MONOM_DIM  # 14190
    inv_dim = M75  # 2343

    # Prefer image when image is smaller than kernel
    image_dim = r_max  # worst-case image for capacity planning
    kernel_dim = ambient - r_min  # worst-case kernel
    if image_dim <= kernel_dim:
        side = "image"
        side_dim = image_dim
        reason = (
            f"image dim ≈ {image_dim} ≤ kernel dim ≈ {kernel_dim}; "
            "reconstruct image of Λ in cubic ambient (or Inv_75 coordinates)."
        )
    else:
        side = "kernel"
        side_dim = kernel_dim
        reason = (
            f"kernel dim ≈ {kernel_dim} < image dim ≈ {image_dim}; "
            "reconstruct ker(Λ)."
        )

    # Storage estimates (int64 residues per prime; rational recon is larger)
    bytes_per_entry = 8
    n_entries_cubic = side_dim * ambient
    n_entries_inv = side_dim * inv_dim  # if worked in Inv_75 coords
    storage_one_prime_mib = n_entries_cubic * bytes_per_entry / (1024 * 1024)
    storage_all_primes_mib = storage_one_prime_mib * len(primes)
    storage_inv_one_mib = n_entries_inv * bytes_per_entry / (1024 * 1024)

    # CRT modulus product
    mod_prod = 1
    for p in primes:
        mod_prod *= p

    # Full char-0 over K=Q(ζ_11) requires degree-10 coefficients; estimate ×10
    # for Z[ζ]-basis of each entry if reconstructed integrally over the cyclotomic.
    cyclotomic_degree = 10  # φ(11)

    # Memory for simultaneous multiprime residues of image echelon:
    # side_dim × ambient × n_primes × 8
    simultaneous_mib = n_entries_cubic * len(primes) * bytes_per_entry / (1024 * 1024)
    # Working set with RREF over Q of a side_dim × ambient matrix of rationals:
    # each Fraction is heavy; use 64-byte lower bound per entry for preflight
    rational_work_mib = n_entries_cubic * 64 / (1024 * 1024)
    cyclotomic_work_mib = rational_work_mib * cyclotomic_degree

    peak_observed = max(float(r["peak_rss_mib"]) for r in prime_results)

    # Decision: can we finish exact char-0 under 8 GiB?
    # Observed modular work ~1.5–2.5 GiB. Rational image of size
    # 746 × 14190 with multiprime CRT is ~80 MB residues but reconstruction
    # of compatible bases across primes for K=Q(ζ_11) requires either:
    #   (a) common integer lifts of generating rows (not available: modular
    #       monic echelons are prime-dependent), or
    #   (b) multiprime CRT of the full map Λ in a fixed Z-lattice model of
    #       V_25 and Inv_75, which needs an integral model of V_25 over
    #       Z[ζ_11] — the sealed monic basis is fibrewise and not yet
    #       lifted to char-0 in this packet.
    bottleneck = (
        "No char-0 free model of V_25 / Λ is installed in this packet: the "
        "monic basis43 is a fibrewise RREF over F_p and differs by prime "
        f"(shas {[r['basis43_sha256'][:12] for r in prime_results]}). "
        "CRT of modular echelons is ill-posed without a fixed Z[ζ_11]-lattice "
        "presentation of Λ. Building that presentation requires reconstructing "
        "the 43 × 189 covariant basis over K and the 14190 × 2343 (or dual) "
        f"map — estimated working set ≳ {cyclotomic_work_mib:.0f} MiB for the "
        f"image side alone at rank {image_dim}, plus multiprime integral model "
        "construction that exceeds the 8 GiB Worker-R ceiling without the "
        "heavy slot. Modular ranks alone do not prove rank_K."
    )

    ranks_agree = r_min == r_max
    floor = {
        "modular_ranks": {str(r["prime"]): r["rank"] for r in prime_results},
        "ranks_agree_across_tested_primes": ranks_agree,
        "lower_bound_rank_K": r_min,  # rank can only drop under reduction
        "upper_bound_m75": M75,
        "interval": [r_min, M75],
        "chosen_side": side,
        "side_reason": reason,
        "side_dim": side_dim,
        "ambient_cubic": ambient,
        "ambient_inv75": inv_dim,
        "storage_one_prime_image_echelon_mib": round(storage_one_prime_mib, 2),
        "storage_all_tested_primes_mib": round(storage_all_primes_mib, 2),
        "storage_inv75_coords_one_prime_mib": round(storage_inv_one_mib, 2),
        "estimated_rational_workset_mib": round(rational_work_mib, 2),
        "estimated_cyclotomic_workset_mib": round(cyclotomic_work_mib, 2),
        "crt_modulus_product": mod_prod,
        "crt_modulus_bits": int(mod_prod).bit_length(),
        "peak_rss_modular_mib": peak_observed,
        "rss_ceiling_mib": RSS_LIMIT_MIB,
        "heavy_slot": False,
        "bottleneck": bottleneck,
        "what_is_proved": (
            f"Exact rank(Λ_p) at primes {primes}; therefore rank_K Λ_K ≥ {r_min}. "
            "No characteristic-zero upper-bound certificate."
        ),
        "what_is_not_proved": (
            "rank_K Λ_K is not decided. Agreement of modular ranks is evidence "
            "only (§8.6: modular rank is never silently promoted to char-0)."
        ),
    }
    return floor


def main() -> None:
    t_all = time.time()
    print("P25W.3 produce_rank_k starting", flush=True)
    peak = check_rss("start")
    perm_lists = precompute_perm_lists()
    print(f"  cubic monoms {len(perm_lists)} precomputed rss={rss_mib():.0f}", flush=True)

    results: list[dict] = []
    for prime, zeta, seed in PRIMES:
        res = process_prime(prime, zeta, seed, perm_lists)
        results.append(res)
        peak = max(peak, float(res["peak_rss_mib"]))
        # Checkpoint intermediate summary
        (TMP / f"done_p{prime}.json").write_text(
            json.dumps(
                {
                    "prime": prime,
                    "rank": res["rank"],
                    "pivot_product_mod_p": res["unisolvence"]["pivot_product_mod_p"],
                },
                indent=2,
            )
            + "\n"
        )

    ranks = [int(r["rank"]) for r in results]
    primes = [int(r["prime"]) for r in results]
    rank_map = {int(r["prime"]): int(r["rank"]) for r in results}
    pivot_map = {
        int(r["prime"]): int(r["unisolvence"]["pivot_product_mod_p"]) for r in results
    }

    if len(set(ranks)) > 1:
        print(
            f"\n*** DECISIVE: modular ranks DIFFER across primes: {rank_map} ***",
            flush=True,
        )

    floor = char0_preflight(results)
    preflight_path = OUT / "preflight_rank_k.json"
    C.write_json_self_hash(preflight_path, floor)

    # Exit selection
    r_min = min(ranks)
    r_max = max(ranks)
    # We have exact modular ranks but no char-0 certificate
    exit_code = "P25W-RANK-K-UNDECIDED"
    if r_max > 746 and r_min > 746:
        # Even without char-0, if every tested fibre has rank > 746 then
        # rank_K ≥ r_min > 746 — that is a certified lower bound (reduction
        # can only drop rank). Report GT746 with lower bound, still no exact
        # char-0 value unless reconstruction succeeds.
        # Work order: P25W-RANK-K-GT746 means it exceeds 746 — give exact or
        # certified lower bound. Modular lower bound is valid for rank_K.
        exit_code = "P25W-RANK-K-GT746"
    # Note: modular agreement at 746 does NOT yield P25W-RANK-K-746.

    summary = {
        "exit": exit_code,
        "headline": "OPEN",
        "task": "P25W.3",
        "primes_tested": primes,
        "ranks": rank_map,
        "unisolvence_pivot_products": pivot_map,
        "ranks_agree": r_min == r_max,
        "lower_bound_rank_K": r_min,
        "upper_bound_m75": M75,
        "char0_certificate": False,
        "reconstruction_side": floor["chosen_side"],
        "reconstruction_side_reason": floor["side_reason"],
        "preflight": "preflight_rank_k.json",
        "peak_rss_mib": peak,
        "total_seconds": time.time() - t_all,
        "theorem_boundary": (
            f"Proved: rank_{{F_p}} Λ_p is exact at each tested good prime "
            f"{primes} via unisolvence (see rank_p*.json). Therefore "
            f"rank_K Λ_K ≥ {r_min}. Not proved: the characteristic-zero rank "
            f"itself (no multiprime CRT image/kernel basis over K=Q(ζ_11) was "
            "constructed; modular agreement is not a char-0 certificate)."
        ),
        "per_prime_certificates": [f"rank_p{p}.json" for p in primes],
        "corrections_carried": [
            "modular rank not promoted to char-0 (§2.4, §8.6)",
            "746 rows complete special-fibre ideal at p=89 only (§2.5)",
            "historical 842/rank-28 not imported (§2.7, §8.9)",
            "no random plateau upper bound",
            "p=67 not used as decision fibre",
            "rational reconstruction uses common_p25x (not SymPy private helper)",
        ],
    }
    C.write_json_self_hash(OUT / "exit_p25w3.json", summary)

    md = [
        "# P25W.3 — Characteristic-zero landing rank (multiprime preflight)",
        "",
        "**Headline: OPEN.**",
        "",
        f"**Exit:** `{exit_code}`",
        "",
        "---",
        "",
        "## Modular ranks (exact, unisolvent)",
        "",
        "| Prime | Rank | Pivot product of unisolvence matrix |",
        "|------:|-----:|------------------------------------:|",
    ]
    for r in results:
        md.append(
            f"| {r['prime']} | **{r['rank']}** | "
            f"{r['unisolvence']['pivot_product_mod_p']} |"
        )
    md += [
        "",
        f"Lower bound on `rank_K`: **{r_min}** (rank can only drop under reduction).",
        f"Upper bound: `m_75 = {M75}`.",
        "",
        "## Reconstruction side",
        "",
        f"Chose **{floor['chosen_side']}** — {floor['side_reason']}",
        "",
        "## Characteristic zero",
        "",
        "**No characteristic-zero certificate.** The modular ranks above are",
        "exact F_p statements. Agreement across primes is evidence only and is",
        "not promoted to `rank_K` (§8.6).",
        "",
        "Bottleneck (preflight):",
        "",
        f"> {floor['bottleneck']}",
        "",
        "## Resource",
        "",
        f"- Peak RSS (producer): **{peak:.1f} MiB** (ceiling 8192 MiB; no heavy slot).",
        f"- Total wall time: {time.time() - t_all:.1f}s.",
        "",
        "Headline remains **OPEN**.",
        "",
    ]
    (OUT / "RANK_K.md").write_text("\n".join(md))
    print(
        f"\nDONE exit={exit_code} ranks={rank_map} peak_rss={peak:.1f} MiB "
        f"t={time.time()-t_all:.1f}s",
        flush=True,
    )


if __name__ == "__main__":
    main()
