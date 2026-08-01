#!/usr/bin/env python3
"""Independent verifier for P25W.2 Stage A emptiness.

Does NOT import produce_stageA.py. Recomputes:
  - flattening T from sealed seed_F3
  - rank(T) and a basis of ker(T)
  - the sampled 2×2-minor quadratic forms on ker parameters
  - rank of those quadrics equals dim of all homogeneous quadrics
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


def main() -> None:
    print("=== P25W.2 Stage A verify ===", flush=True)
    result_path = HERE / "stageA_result.json"
    cert_path = HERE / "stageA_certificate.npz"
    if not result_path.exists() or not cert_path.exists():
        fail("missing stageA_result.json or stageA_certificate.npz")

    body = json.loads(result_path.read_text())
    claimed = body.get("self_sha256")
    body_no = {k: v for k, v in body.items() if k != "self_sha256"}
    text = json.dumps(body_no, indent=2, sort_keys=True) + "\n"
    digest = C.sha256_bytes(text.encode())
    if digest != claimed:
        fail(f"self_sha256 mismatch: claimed {claimed} got {digest}")

    if body.get("exit") != "P25W-STAGEA-EMPTY":
        fail(f"unexpected exit {body.get('exit')}")

    rel = np.load(FM / "relation_matrix.npz")
    seed = rel["seed_F3"]
    off3 = rel["off3"]
    seed_sha = C.sha256_arr(seed)
    if seed_sha != body["inputs"]["seed_F3_sha256"]:
        fail("seed_F3 sha mismatch vs sealed relation_matrix")

    m1 = C.weak_compositions(1, 37)
    var_of = np.array(
        [[i for i, e in enumerate(m) if e][0] for m in m1], dtype=np.int32
    )
    T = np.zeros((690, 777), dtype=np.int64)
    for j in range(21):
        block = seed[:, off3[7 + j] : off3[8 + j]].astype(np.int64) % P
        for mi, v in enumerate(var_of):
            T[:, j * 37 + int(v)] = block[:, mi]

    rk = C.rank_mod(T, P)
    if rk != 690:
        fail(f"flattening rank {rk} != 690")
    ns = C.nullspace_rows(T, P)
    ker_dim = int(ns.shape[0])
    if ker_dim != 87:
        fail(f"ker dim {ker_dim} != 87")

    cert = np.load(cert_path)
    if int(cert["prime"]) != P:
        fail("prime mismatch")
    if int(cert["flatten_rank"]) != rk or int(cert["ker_dim"]) != ker_dim:
        fail("certificate flatten metadata mismatch")
    if C.sha256_arr(T.astype(np.uint8)) != body["flattening"]["T_sha256"]:
        # Recomputed T must match sealed hash in the result JSON.
        fail("T sha256 mismatch")
    # ker basis may differ by GL(87); recompute minors from *our* ns.
    sel = cert["sel"].astype(np.int32)
    seed_rng = int(cert["seed_rng"])
    n_sample = int(cert["n_minor_sample"])
    nquad = int(cert["nquad"])
    if nquad != ker_dim * (ker_dim + 1) // 2:
        fail("nquad mismatch")

    minors: list[tuple[int, int, int, int]] = []
    for r1 in range(21):
        for r2 in range(r1 + 1, 21):
            for c1 in range(37):
                for c2 in range(c1 + 1, 37):
                    minors.append((r1, r2, c1, c2))
    rng = np.random.default_rng(seed_rng)
    sel_check = np.sort(
        rng.choice(len(minors), size=n_sample, replace=False)
    ).astype(np.int32)
    if not np.array_equal(sel, sel_check):
        fail("sel not reproduced from seed_rng")

    K = (ns.reshape(ker_dim, 21, 37) % P).astype(np.int64)
    inv2 = pow(2, P - 2, P)
    tri = np.triu_indices(ker_dim)
    M = np.zeros((n_sample, nquad), dtype=np.int64)
    for ii, sidx in enumerate(sel):
        r1, r2, c1, c2 = minors[int(sidx)]
        L11 = K[:, r1, c1]
        L12 = K[:, r1, c2]
        L21 = K[:, r2, c1]
        L22 = K[:, r2, c2]
        O = (
            np.outer(L11, L22)
            + np.outer(L22, L11)
            - np.outer(L12, L21)
            - np.outer(L21, L12)
        ) % P
        O[np.arange(ker_dim), np.arange(ker_dim)] = (O.diagonal() * inv2) % P
        M[ii] = O[tri] % P

    rk_quad = C.rank_mod(M, P)
    print(
        f"recomputed flatten_rank={rk} ker_dim={ker_dim} quadric_rank={rk_quad}/{nquad}",
        flush=True,
    )
    if rk_quad != nquad:
        fail(f"quadric span rank {rk_quad} != {nquad}")

    # Full span of quadrics ⇒ only common zero of all 2×2 minors is a=0,
    # because every square a_i^2 is in the span and a_i^2=0 ⇒ a_i=0 over a field.
    print("PASS: Stage A incidence empty over F_89 (full quadric span on ker)", flush=True)
    out = {
        "status": "PASS",
        "exit": "P25W-STAGEA-EMPTY",
        "flatten_rank": rk,
        "ker_dim": ker_dim,
        "quadric_rank": rk_quad,
        "nquad": nquad,
        "rss_mib": C.rss_mib(),
    }
    (HERE / "verify_stageA_result.json").write_text(
        json.dumps(out, indent=2, sort_keys=True) + "\n"
    )


if __name__ == "__main__":
    main()
