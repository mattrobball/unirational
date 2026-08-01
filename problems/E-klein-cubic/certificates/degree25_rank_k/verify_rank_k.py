#!/usr/bin/env python3
"""P25W.3 independent verifier — does NOT import produce_rank_k.py.

For each tested prime, recomputes:
  1. Independence of the 2343 Reynolds monom orbit-sums (eval rank = 2343).
  2. Invertibility of the sealed evaluation matrix (rank 2343, nonzero pivot product).
  3. Landing-row rank at the sealed unisolvent points from the monic basis43
     rebuilt at that prime (not read from JSON rank fields).

Also checks that exit_p25w3.json does not silently promote modular ranks to
characteristic zero.
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
sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

M75 = 2343
DEG = 75
PRIMES = [(89, 78), (199, 61), (353, 58)]


def load_group(prime: int, zeta: int):
    recon = C.load_reconstructor()
    mod = recon.load_module(prime, zeta)
    G = (mod.GROUP % prime).astype(np.int64)
    G_inv = np.array(
        [C.invert_mod(G[i], prime) for i in range(len(G))], dtype=np.int64
    )
    inv_order = pow(int(G.shape[0]), -1, prime)
    return mod, G, G_inv, inv_order


def power_dtype(prime: int):
    if prime <= 255:
        return np.uint8
    if prime <= 65535:
        return np.uint16
    return np.uint32


def build_power_table(G_inv: np.ndarray, points: np.ndarray, prime: int) -> np.ndarray:
    z = np.einsum("gij,pj->pgi", G_inv, points) % prime
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


def reynolds_eval(powers, alpha, inv_order, prime):
    n = powers.shape[2]
    n_g = powers.shape[3]
    vals = np.ones((n, n_g), dtype=np.int64)
    for i, e in enumerate(alpha):
        if e:
            vals = vals * powers[i, e].astype(np.int64) % prime
    return (vals.sum(axis=1) % prime) * inv_order % prime


def reynolds_matrix(G_inv, points, monoms, inv_order, prime):
    powers = build_power_table(G_inv, points, prime)
    out = np.zeros((len(monoms), len(points)), dtype=np.int64)
    for mi, alpha in enumerate(monoms):
        out[mi] = reynolds_eval(
            powers, tuple(int(a) for a in alpha), inv_order, prime
        )
    del powers
    return out


def pivot_product_rref(matrix: np.ndarray, prime: int) -> tuple[int, int]:
    a = (np.asarray(matrix, dtype=np.int64) % prime).copy()
    rows, cols = a.shape
    rank = 0
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
        rank += 1
        if rank == rows:
            break
    return rank, prod


def precompute_perm_lists():
    monoms = C.cubic_monomials()
    perm_lists = []
    for exp in monoms:
        idxs: list[int] = []
        for r, e in enumerate(exp):
            idxs.extend([r] * e)
        perm_lists.append(list(set(permutations(idxs))))
    return perm_lists


def cubic_row(V: np.ndarray, prime: int, perm_lists) -> np.ndarray:
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
    _, plus, _ = C.involution_eigenspaces(mod, prime)
    ker = C.arrangement_kernel(mod, seeds, plus, prime)
    _, sr, _ = C.strict_from_arrangement(mod, seeds, ker, prime)
    basis43, piv = C.monic_basis_reynolds(sr, prime)
    return seeds, basis43


def verify_prime(prime: int, zeta: int, perm_lists) -> dict:
    print(f"\n=== verify p={prime} ===", flush=True)
    errors: list[str] = []
    t0 = time.time()

    cert_path = HERE / f"rank_p{prime}.json"
    inv_path = HERE / f"invariant_basis_p{prime}.npz"
    pts_path = HERE / f"unisolvent_points_p{prime}.npz"
    rows_path = HERE / f"landing_echelon_p{prime}.npz"
    for p in (cert_path, inv_path, pts_path, rows_path):
        if not p.exists():
            return {"prime": prime, "ok": False, "errors": [f"missing {p.name}"]}

    cert = json.loads(cert_path.read_text())
    claimed_rank = int(cert["rank"])
    claimed_pivot = int(cert["unisolvence"]["pivot_product_mod_p"])

    monoms = np.load(inv_path)["monoms"].astype(np.int64)
    if monoms.shape != (M75, 5):
        errors.append(f"monoms shape {monoms.shape}")
    if not np.all(monoms.sum(axis=1) == DEG):
        errors.append("monom degree failure")

    pts_data = np.load(pts_path)
    points = pts_data["points"].astype(np.int64)
    eval_matrix = pts_data["eval_matrix"].astype(np.int64)
    if points.shape != (M75, 5):
        errors.append(f"points shape {points.shape}")
    if eval_matrix.shape != (M75, M75):
        errors.append(f"eval_matrix shape {eval_matrix.shape}")

    mod, G, G_inv, inv_order = load_group(prime, zeta)

    # 1. Independence on a fresh probe set
    print(f"  [1] invariant independence...", flush=True)
    rng = np.random.default_rng(424242 + prime)
    probe = []
    while len(probe) < M75 + 50:
        x = rng.integers(0, prime, size=5, dtype=np.int64)
        if np.any(x):
            probe.append(x)
    probe = np.asarray(probe, dtype=np.int64)
    E_probe = reynolds_matrix(G_inv, probe, monoms, inv_order, prime)
    ech_basis: list = []
    for i in range(E_probe.shape[0]):
        C.add_echelon_row(ech_basis, E_probe[i], prime)
    rank_basis = len(ech_basis)
    print(f"    basis eval rank = {rank_basis}", flush=True)
    if rank_basis != M75:
        errors.append(f"invariant basis rank {rank_basis} != {M75}")

    # 2. Unisolvence: recompute eval matrix at sealed points and pivot product
    print(f"  [2] unisolvence invertibility...", flush=True)
    # Use sealed eval_matrix but also recompute a few columns for integrity
    M_re = reynolds_matrix(G_inv, points[:5], monoms, inv_order, prime)
    if not np.array_equal(M_re % prime, eval_matrix[:, :5] % prime):
        errors.append("eval_matrix does not match recomputed Reynolds columns")
    # Full invertibility from sealed matrix (already certified by producer;
    # recompute pivot product on sealed matrix)
    rank_u, pivot_prod = pivot_product_rref(eval_matrix.T, prime)
    print(
        f"    unisolvence rank={rank_u} pivot_prod={pivot_prod} "
        f"(claimed {claimed_pivot})",
        flush=True,
    )
    if rank_u != M75:
        errors.append(f"unisolvence rank {rank_u} != {M75}")
    if pivot_prod % prime == 0:
        errors.append("pivot product is 0")
    if pivot_prod != claimed_pivot:
        errors.append(f"pivot product {pivot_prod} != claimed {claimed_pivot}")

    # Slow Reynolds spot-check
    def slow_R(alpha, x):
        s = 0
        for g in range(G_inv.shape[0]):
            zz = G_inv[g] @ x % prime
            v = 1
            for i, e in enumerate(alpha):
                v = v * pow(int(zz[i]), int(e), prime) % prime
            s = (s + v) % prime
        return s * inv_order % prime

    for mi in (0, 17, 100, 500, 2000):
        if mi >= len(monoms):
            continue
        alpha = tuple(int(a) for a in monoms[mi])
        for j in (0, 1, 2):
            fast = int(eval_matrix[mi, j]) % prime
            slow = slow_R(alpha, points[j])
            if fast != slow:
                errors.append(f"Reynolds mismatch monom {mi} point {j}")

    # 3. Landing rank rebuilt from basis43
    print(f"  [3] landing rank from basis43...", flush=True)
    seeds, basis43 = load_basis43(mod, prime)
    basis_sha = C.sha256_arr(basis43.astype(np.uint64))
    claimed_sha = cert.get("basis43_sha256")
    if claimed_sha and basis_sha != claimed_sha:
        errors.append(f"basis43 sha mismatch {basis_sha[:16]} vs {claimed_sha[:16]}")

    R = C.batch_seed_evaluations(mod, seeds, points, prime).reshape(
        len(points), 5, C.MOLIEN_DIM
    )
    vals = np.einsum("nsw,bw->nbs", R, basis43) % prime
    echelon: list = []
    for i in range(len(points)):
        row = cubic_row(vals[i], prime, perm_lists)
        C.add_echelon_row(echelon, row, prime)
    rank_land = len(echelon)
    print(f"    landing rank = {rank_land} (claimed {claimed_rank})", flush=True)
    if rank_land != claimed_rank:
        errors.append(f"landing rank {rank_land} != claimed {claimed_rank}")

    # Stored echelon rank check
    stored = np.load(rows_path)["echelon"].astype(np.int64) % prime
    if stored.shape[0] != rank_land:
        errors.append(
            f"stored echelon rows {stored.shape[0]} != recomputed rank {rank_land}"
        )
    # Every stored row must lie in recomputed span and vice-versa: stacked rank
    ech_stack: list = []
    for i in range(stored.shape[0]):
        C.add_echelon_row(ech_stack, stored[i], prime)
    for piv, erow in echelon:
        C.add_echelon_row(ech_stack, erow, prime)
    if len(ech_stack) != rank_land:
        errors.append(
            f"stored/recomputed rowspaces differ: stacked rank {len(ech_stack)}"
        )

    ok = not errors
    report = {
        "prime": prime,
        "zeta": zeta,
        "ok": ok,
        "errors": errors,
        "rank_basis": rank_basis,
        "unisolvence_rank": rank_u,
        "pivot_product_mod_p": pivot_prod,
        "landing_rank": rank_land,
        "basis43_sha256": basis_sha,
        "seconds": time.time() - t0,
        "rss_mib": C.rss_mib(),
    }
    print(f"  p={prime}: {'PASS' if ok else 'FAIL'} t={report['seconds']:.1f}s", flush=True)
    return report


def main() -> None:
    t0 = time.time()
    print("P25W.3 verify_rank_k starting (no producer import)", flush=True)
    peak = C.rss_mib()
    perm_lists = precompute_perm_lists()

    reports = []
    for prime, zeta in PRIMES:
        rep = verify_prime(prime, zeta, perm_lists)
        reports.append(rep)
        peak = max(peak, float(rep.get("rss_mib", 0)))

    # Exit file discipline: modular must not be claimed as char-0
    exit_path = HERE / "exit_p25w3.json"
    exit_errors: list[str] = []
    exit_payload = None
    if exit_path.exists():
        exit_payload = json.loads(exit_path.read_text())
        if exit_payload.get("char0_certificate") is True:
            exit_errors.append("exit claims char0_certificate=true without reconstruction")
        if exit_payload.get("exit") == "P25W-RANK-K-746":
            exit_errors.append(
                "exit P25W-RANK-K-746 requires char-0 certificate; modular agreement is insufficient"
            )
        ranks = exit_payload.get("ranks", {})
        for rep in reports:
            p = str(rep["prime"])
            if p in ranks and int(ranks[p]) != int(rep["landing_rank"]):
                exit_errors.append(
                    f"exit ranks[{p}]={ranks[p]} != recomputed {rep['landing_rank']}"
                )
    else:
        exit_errors.append("missing exit_p25w3.json")

    all_ok = all(r.get("ok") for r in reports) and not exit_errors
    summary = {
        "ok": all_ok,
        "exit_errors": exit_errors,
        "primes": reports,
        "peak_rss_mib": peak,
        "total_seconds": time.time() - t0,
        "theorem_boundary": (
            "Verifier recomputed exact F_p ranks and unisolvence pivot products. "
            "It does not certify rank_K. Exit discipline: modular agreement is "
            "not a characteristic-zero certificate."
        ),
        "exit_from_producer": exit_payload.get("exit") if exit_payload else None,
    }
    C.write_json_self_hash(HERE / "verify_report.json", summary)
    print(
        f"\nVERIFY {'PASS' if all_ok else 'FAIL'} "
        f"peak_rss={peak:.1f} MiB t={summary['total_seconds']:.1f}s",
        flush=True,
    )
    if not all_ok:
        for r in reports:
            if not r.get("ok"):
                print(f"  p={r['prime']} errors: {r['errors']}", flush=True)
        if exit_errors:
            print(f"  exit errors: {exit_errors}", flush=True)
        raise SystemExit(1)


if __name__ == "__main__":
    main()
