#!/usr/bin/env python3
"""P25Z.3 independent verifier — does NOT import produce_rowrank.py.

Recomputes the decisive invariants:
  1. Independence of the 2343 Reynolds monom orbit-sums (eval rank = 2343).
  2. Invertibility of the invariant-evaluation matrix at the sealed points
     (rank 2343 and nonzero pivot product).
  3. Rank of the cubic landing rows at those points (rebuilt from basis43,
     not read from JSON).

A verifier that only reads "rank" from JSON verifies nothing.
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
DIRECT = ROOT / "certificates" / "degree25_direct_support"
sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P, Z = 89, 78
M75 = 2343
DEG = 75


def load_group():
    recon = C.load_reconstructor()
    mod = recon.load_module(P, Z)
    G = (mod.GROUP % P).astype(np.int64)
    G_inv = np.array([C.invert_mod(G[i], P) for i in range(len(G))], dtype=np.int64)
    inv_order = pow(int(G.shape[0]), -1, P)
    return mod, G, G_inv, inv_order


def build_power_table(G_inv: np.ndarray, points: np.ndarray) -> np.ndarray:
    z = np.einsum("gij,pj->pgi", G_inv, points) % P
    n = points.shape[0]
    powers = np.empty((5, DEG + 1, n, G_inv.shape[0]), dtype=np.uint8)
    for i in range(5):
        powers[i, 0] = 1
        base = z[:, :, i].astype(np.uint8)
        powers[i, 1] = base
        for e in range(2, DEG + 1):
            powers[i, e] = (
                powers[i, e - 1].astype(np.uint16) * base.astype(np.uint16) % P
            ).astype(np.uint8)
    return powers


def reynolds_eval(powers: np.ndarray, alpha: tuple[int, ...], inv_order: int) -> np.ndarray:
    n = powers.shape[2]
    n_g = powers.shape[3]
    vals = np.ones((n, n_g), dtype=np.int64)
    for i, e in enumerate(alpha):
        if e:
            vals = vals * powers[i, e] % P
    return (vals.sum(axis=1) % P) * inv_order % P


def reynolds_matrix(G_inv, points, monoms, inv_order) -> np.ndarray:
    powers = build_power_table(G_inv, points)
    out = np.zeros((len(monoms), len(points)), dtype=np.int64)
    for mi, alpha in enumerate(monoms):
        out[mi] = reynolds_eval(powers, tuple(int(a) for a in alpha), inv_order)
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


def load_basis43(mod):
    seed_data = C.load_seeds()
    seeds = [
        mod.ReynoldsSeed(int(r["output"]), tuple(r["exponents"])) for r in seed_data
    ]
    _, plus, _ = C.involution_eigenspaces(mod, P)
    ker = C.arrangement_kernel(mod, seeds, plus, P)
    _, sr, _ = C.strict_from_arrangement(mod, seeds, ker, P)
    basis43, piv = C.monic_basis_reynolds(sr, P)
    return seeds, basis43


def main() -> None:
    t0 = time.time()
    print("P25Z.3 verify_rowrank starting (no producer import)", flush=True)
    errors: list[str] = []

    cert_path = HERE / "rank_certificate.json"
    inv_path = HERE / "invariant_basis.npz"
    pts_path = HERE / "unisolvent_points.npz"
    rows_path = HERE / "landing_rows_unisolvent.npz"
    for p in (cert_path, inv_path, pts_path, rows_path):
        if not p.exists():
            raise SystemExit(f"missing artifact {p}")

    cert = json.loads(cert_path.read_text())
    claimed_rank = int(cert["rank"])
    claimed_exit = cert["exit"]

    inv = np.load(inv_path)
    monoms = inv["monoms"].astype(np.int64)
    if monoms.shape != (M75, 5):
        errors.append(f"monoms shape {monoms.shape} != ({M75}, 5)")
    if not np.all(monoms.sum(axis=1) == DEG):
        errors.append("some monoms do not have total degree 75")

    pts_data = np.load(pts_path)
    points = pts_data["points"].astype(np.int64)
    if points.shape != (M75, 5):
        errors.append(f"points shape {points.shape} != ({M75}, 5)")

    mod, G, G_inv, inv_order = load_group()

    # --- 1. Independence of invariant basis on a fresh probe set ---
    print("  [1] invariant independence on fresh probe points...", flush=True)
    rng = np.random.default_rng(424242)
    probe = []
    while len(probe) < M75 + 50:
        x = rng.integers(0, P, size=5, dtype=np.int64)
        if np.any(x):
            probe.append(x)
    probe = np.asarray(probe, dtype=np.int64)
    E_probe = reynolds_matrix(G_inv, probe, monoms, inv_order)  # (M75, n_probe)
    ech_basis: list = []
    for i in range(E_probe.shape[0]):
        C.add_echelon_row(ech_basis, E_probe[i], P)
    rank_basis = len(ech_basis)
    print(f"    basis eval rank = {rank_basis} (need {M75})", flush=True)
    if rank_basis != M75:
        errors.append(f"invariant basis rank {rank_basis} != {M75}")

    # Slow Reynolds spot-check
    def slow_R(alpha, x):
        s = 0
        for g in range(G_inv.shape[0]):
            zz = G_inv[g] @ x % P
            v = 1
            for i, e in enumerate(alpha):
                v = v * pow(int(zz[i]), int(e), P) % P
            s = (s + v) % P
        return s * inv_order % P

    powers_pt = build_power_table(G_inv, points[:3])
    for mi in (0, 1, M75 // 2, M75 - 1):
        alpha = tuple(int(a) for a in monoms[mi])
        fast = reynolds_eval(powers_pt, alpha, inv_order)
        for j in range(3):
            if int(fast[j]) != slow_R(alpha, points[j]):
                errors.append(f"Reynolds mismatch monom {mi} point {j}")
    print("    Reynolds spot-check done", flush=True)

    # --- 2. Unisolvence: recompute eval matrix rank + pivot product ---
    print("  [2] unisolvence of sealed points...", flush=True)
    E = reynolds_matrix(G_inv, points, monoms, inv_order)  # (M75, M75)
    # Compare to stored matrix if present
    if "eval_matrix" in pts_data:
        stored = pts_data["eval_matrix"].astype(np.int64) % P
        if not np.array_equal(E, stored):
            errors.append("stored eval_matrix differs from recomputed Reynolds evals")
    rank_u, pivot_prod = pivot_product_rref(E.T, P)
    print(f"    eval rank={rank_u} pivot_prod={pivot_prod}", flush=True)
    if rank_u != M75:
        errors.append(f"unisolvence rank {rank_u} != {M75}")
    if pivot_prod % P == 0:
        errors.append("pivot product is 0 — matrix not invertible")
    claimed_pp = int(cert.get("unisolvence", {}).get("pivot_product_mod_p", -1))
    if claimed_pp >= 0 and claimed_pp % P != pivot_prod % P:
        errors.append(
            f"pivot product mismatch cert={claimed_pp} recomputed={pivot_prod}"
        )

    # --- 3. Landing rank recomputed from basis43 + cubic rows ---
    print("  [3] recompute landing rank at unisolvent points...", flush=True)
    seeds, basis43 = load_basis43(mod)
    basis_sha = C.sha256_arr(basis43.astype(np.uint64))
    sealed = cert.get("basis43_sha256")
    if sealed and sealed != basis_sha:
        errors.append(f"basis43 sha {basis_sha} != cert {sealed}")
    dvr_path = DIRECT / "dvr_certificate.json"
    if dvr_path.exists():
        dvr = json.loads(dvr_path.read_text())
        dvr_sha = dvr.get("decide_fibre", {}).get("basis43_sha256")
        if dvr_sha and dvr_sha != basis_sha:
            errors.append(f"basis43 sha mismatch vs DVR: {basis_sha} vs {dvr_sha}")

    perm_lists = precompute_perm_lists()
    n = len(points)
    R = C.batch_seed_evaluations(mod, seeds, points, P).reshape(n, 5, C.MOLIEN_DIM)
    vals = np.einsum("nsw,bw->nbs", R, basis43) % P

    # Semantics: match common_p25x.fast_cubic_row on 2 points
    for j in range(2):
        a = cubic_row(vals[j], P, perm_lists)
        b = C.fast_cubic_row(vals[j], P)
        if not np.array_equal(a % P, b % P):
            errors.append(f"cubic row != fast_cubic_row at point {j}")

    ech: list = []
    for i in range(n):
        row = cubic_row(vals[i], P, perm_lists)
        C.add_echelon_row(ech, row, P)
        if (i + 1) % 400 == 0 or i + 1 == n:
            print(f"    n={i+1} rank={len(ech)}", flush=True)
    recomputed_rank = len(ech)
    print(f"    recomputed landing rank = {recomputed_rank}", flush=True)
    if recomputed_rank != claimed_rank:
        errors.append(
            f"landing rank mismatch: recomputed {recomputed_rank} vs cert {claimed_rank}"
        )

    # Cross-check stored echelon rank
    stored_rows = np.load(rows_path)
    stored_ech = stored_rows["echelon"].astype(np.int64) % P
    if stored_ech.shape[0] != claimed_rank:
        errors.append(
            f"stored echelon rows {stored_ech.shape[0]} != claimed rank {claimed_rank}"
        )
    # Same row space as recomputed?
    same = C.same_row_space(
        stored_ech,
        np.asarray([er for _, er in ech], dtype=np.int64),
        P,
    )
    if not same:
        errors.append("stored echelon rowspace != recomputed rowspace")

    # Exit code consistency
    if claimed_rank == 746:
        expect_exit = "P25Z-ROW-RANK-746"
    else:
        expect_exit = f"P25Z-ROW-RANK-{claimed_rank}"
    if claimed_exit != expect_exit and not claimed_exit.startswith("P25Z3-UNDECIDED"):
        # allow exact form
        if claimed_rank > 746 and claimed_exit != f"P25Z-ROW-RANK-{claimed_rank}":
            errors.append(f"exit {claimed_exit} inconsistent with rank {claimed_rank}")

    # Artifact hashes
    for name, path in (
        ("invariant_basis.npz", inv_path),
        ("unisolvent_points.npz", pts_path),
        ("landing_rows_unisolvent.npz", rows_path),
    ):
        got = C.sha256_file(path)
        want = cert.get("artifact_sha256", {}).get(name)
        if want and got != want:
            errors.append(f"sha256 mismatch {name}")

    # Self-hash of certificate
    body = {k: v for k, v in cert.items() if k != "self_sha256"}
    text = json.dumps(body, indent=2, sort_keys=True) + "\n"
    digest = C.sha256_bytes(text.encode())
    if cert.get("self_sha256") != digest:
        errors.append("rank_certificate.json self_sha256 mismatch")

    ok = len(errors) == 0
    report = {
        "ok": ok,
        "errors": errors,
        "recomputed_invariant_rank": rank_basis,
        "recomputed_unisolvence_rank": rank_u,
        "recomputed_pivot_product_mod_p": int(pivot_prod),
        "recomputed_landing_rank": recomputed_rank,
        "claimed_rank": claimed_rank,
        "claimed_exit": claimed_exit,
        "basis43_sha256": basis_sha,
        "seconds": time.time() - t0,
        "rss_mib": C.rss_mib(),
        "headline": "OPEN",
    }
    out = HERE / "verify_report.json"
    # write without circular self-hash requirement for report
    out.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(json.dumps(report, indent=2), flush=True)
    if not ok:
        raise SystemExit("VERIFY FAIL: " + "; ".join(errors))
    print("VERIFY PASS", flush=True)


if __name__ == "__main__":
    main()
