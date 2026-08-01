#!/usr/bin/env python3
"""Independent verifier for P25W.1 component analysis / UNDECIDED exit.

Does NOT import produce_p25w1.py. Recomputes:
  - rank of each seed component block
  - dim S_1·V = 9139 for every deg-1 component
  - V = S_1 for every deg-2 component
  - self-hash of exit_p25w1.json
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
FM = ROOT / "certificates" / "degree25_finite_module"

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89


def fail(msg: str) -> None:
    print(f"FAIL: {msg}", flush=True)
    sys.exit(1)


def mul_maps(qmonoms, qindex, k: int):
    maps = []
    src = qmonoms[k]
    dst_index = qindex[k + 1]
    for j in range(37):
        mp = np.empty(len(src), dtype=np.int32)
        for i, m in enumerate(src):
            mm = list(m)
            mm[j] += 1
            mp[i] = dst_index[tuple(mm)]
        maps.append(mp)
    return maps


def rref_rows(M: np.ndarray):
    A = M.copy() % P
    pivots: list[int] = []
    r = 0
    rows, cols = A.shape
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if A[i, c] % P:
                piv = i
                break
        if piv is None:
            continue
        if piv != r:
            A[[r, piv]] = A[[piv, r]]
        inv = pow(int(A[r, c]) % P, -1, P)
        A[r] = (A[r] * inv) % P
        col = A[:, c].copy()
        for i in range(rows):
            if i != r and col[i] % P:
                A[i] = (A[i] - col[i] * A[r]) % P
        pivots.append(c)
        r += 1
        if r == rows:
            break
    return A[:r], pivots


def dim_S1V(Vb: np.ndarray, maps) -> int:
    r = Vb.shape[0]
    echelon: list[tuple[int, np.ndarray]] = []
    rank_img = 0
    for j in range(37):
        mp = maps[j]
        G = np.zeros((r, 9139), dtype=np.int64)
        for ii in range(Vb.shape[1]):
            G[:, mp[ii]] = (G[:, mp[ii]] + Vb[:, ii]) % P
        for vi in range(r):
            row = G[vi].copy()
            for piv, erow in echelon:
                c = int(row[piv]) % P
                if c:
                    row = (row - c * erow) % P
            nz = np.flatnonzero(row % P)
            if len(nz) == 0:
                continue
            piv = int(nz[0])
            inv = pow(int(row[piv]) % P, -1, P)
            row = (row * inv) % P
            echelon.append((piv, row))
            echelon.sort(key=lambda x: x[0])
            rank_img += 1
            if rank_img == 9139:
                return 9139
    return rank_img


def main() -> None:
    print("=== P25W.1 verify ===", flush=True)
    exit_path = HERE / "exit_p25w1.json"
    if not exit_path.exists():
        fail("missing exit_p25w1.json")
    body = json.loads(exit_path.read_text())
    claimed = body.get("self_sha256")
    body_no = {k: v for k, v in body.items() if k != "self_sha256"}
    text = json.dumps(body_no, indent=2, sort_keys=True) + "\n"
    if C.sha256_bytes(text.encode()) != claimed:
        fail("self_sha256 mismatch")
    if body.get("exit") != "P25W-PRESENTATION-UNDECIDED":
        fail(f"unexpected exit {body.get('exit')}")

    rel = np.load(FM / "relation_matrix.npz")
    seed = rel["seed_F3"].astype(np.int64) % P
    off3 = rel["off3"]
    if C.sha256_arr(rel["seed_F3"]) != body["inputs"]["seed_F3_sha256"]:
        fail("seed sha mismatch")

    qmonoms = {
        d: ([(0,) * 37] if d == 0 else C.weak_compositions(d, 37))
        for d in range(0, 4)
    }
    qindex = {d: {m: i for i, m in enumerate(qmonoms[d])} for d in range(0, 4)}
    maps2 = mul_maps(qmonoms, qindex, 2)

    # deg0 rank
    Vb0, _ = rref_rows(seed[:, off3[0] : off3[1]])
    if Vb0.shape[0] != 690:
        fail(f"deg0 rank {Vb0.shape[0]} != 690")

    # deg1 full S_1·V
    for bi in range(1, 7):
        Vb, _ = rref_rows(seed[:, off3[bi] : off3[bi + 1]])
        if Vb.shape[0] != 690:
            fail(f"bi={bi} rank_V {Vb.shape[0]}")
        dim_img = dim_S1V(Vb, maps2)
        print(f"bi={bi} dim_S1V={dim_img}/9139", flush=True)
        if dim_img != 9139:
            fail(f"bi={bi} S_1·V not full")

    # deg2 full S_1
    for bi in range(7, 28):
        rk = C.rank_mod(seed[:, off3[bi] : off3[bi + 1]], P)
        if rk != 37:
            fail(f"bi={bi} rank {rk} != 37")

    # matrix dimensions claimed
    gshape = body["deg0_membership_matrix"]["G_shape"]
    if gshape != [91390, 690 * 37]:
        fail(f"G_shape {gshape}")

    print(
        "PASS: component analysis recomputed; exit UNDECIDED at deg0 membership floor",
        flush=True,
    )
    out = {
        "status": "PASS",
        "exit": "P25W-PRESENTATION-UNDECIDED",
        "deg1_full": True,
        "deg2_full": True,
        "deg0_rank_V": 690,
        "rss_mib": C.rss_mib(),
    }
    (HERE / "verify_p25w1_result.json").write_text(
        json.dumps(out, indent=2, sort_keys=True) + "\n"
    )


if __name__ == "__main__":
    main()
