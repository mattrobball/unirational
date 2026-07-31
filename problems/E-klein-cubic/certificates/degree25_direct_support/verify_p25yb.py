#!/usr/bin/env python3
"""Independent verifier for P25Y-B support structure packet.

Does NOT import produce_p25yb.py. Recomputes:
  1. Q⊕K frame from the DVR circuit at p=89
  2. Pure-K³ block rank of the sealed 746-row echelon on that K-space
  3. Self-hash of p25yb_support.json and preflight_p25y3.json
  4. Consistency of the K³-border status with the recomputed rank

Decisive invariant: rank of the 746×56 pure-K cubic block equals 56
iff the proposed 1⊕K⊕Sym²K pure-K³ border reduces on q=0.
"""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P, Z = 89, 78
Q_DIM, K_DIM = 37, 6
STRICT = 43


def canonical_json(obj) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def check_self_hash(path: Path) -> dict:
    payload = json.loads(path.read_text())
    body = {k: v for k, v in payload.items() if k != "self_sha256"}
    digest = hashlib.sha256(canonical_json(body).encode()).hexdigest()
    assert digest == payload["self_sha256"], f"self_sha256 mismatch in {path}"
    return payload


def monom_slots(exp):
    slots = []
    for i, e in enumerate(exp):
        slots.extend([i] * int(e))
    assert len(slots) == 3
    return slots[0], slots[1], slots[2]


def pure_K3_block(echelon, K_rows, prime):
    monoms = C.cubic_monomials()
    monK = C.weak_compositions(3, K_DIM)
    monK_i = {m: i for i, m in enumerate(monK)}
    E = np.zeros((len(monoms), 56), dtype=np.int64)
    K = K_rows.astype(np.int64) % prime
    for e_idx, exp in enumerate(monoms):
        i, j, k = monom_slots(exp)
        for a in range(K_DIM):
            Ka = int(K[a, i])
            if not Ka:
                continue
            for b in range(K_DIM):
                Kab = Ka * int(K[b, j]) % prime
                if not Kab:
                    continue
                for c in range(K_DIM):
                    coeff = Kab * int(K[c, k]) % prime
                    if not coeff:
                        continue
                    cnt = [0] * K_DIM
                    cnt[a] += 1
                    cnt[b] += 1
                    cnt[c] += 1
                    f = monK_i[tuple(cnt)]
                    E[e_idx, f] = (E[e_idx, f] + coeff) % prime
    return (echelon.astype(np.int64) % prime) @ E % prime


def build_frame(prime, zeta):
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
    basis43, _ = C.monic_basis_reynolds(sr, prime)
    Q_rows, K_rows, frame, order3 = C.qk_frame(
        sr, module, seeds, plus, minus, ker, strict, prime
    )
    return basis43 % prime, Q_rows % prime, K_rows % prime, frame % prime, order3


def main() -> None:
    support = check_self_hash(HERE / "p25yb_support.json")
    preflight = check_self_hash(HERE / "preflight_p25y3.json")

    assert support["exit"] == "P25YB-F4-SLOT-REQUEST"
    assert preflight["exit"] == "P25YB-F4-SLOT-REQUEST"
    assert support["headline"] == "OPEN"
    assert support["molien_context"]["P25Y_FULL_ROWSPACE_746"] == "NOT_SEALED"
    assert support["molien_context"]["m_75"] == 2343

    data = np.load(HERE / "direct_rows_p89.npz")
    echelon = data["echelon"].astype(np.int64) % P
    assert echelon.shape == (746, 14190)
    assert C.rank_mod(echelon, P) == 746

    print("rebuilding Q⊕K frame...", flush=True)
    basis43, Q_rows, K_rows, frame, order3 = build_frame(P, Z)
    assert order3 == 37
    assert C.rank_mod(frame, P) == STRICT
    assert K_rows.shape == (6, 43)

    dvr_np = np.load(HERE / "dvr_special_fibre_p89.npz")
    assert np.array_equal(basis43, dvr_np["basis43"].astype(np.int64) % P)

    print("recomputing pure-K³ block rank...", flush=True)
    block = pure_K3_block(echelon, K_rows, P)
    rk = int(C.rank_mod(block, P))
    print(f"  rank_K3={rk}/56")
    assert rk == 56, rk
    assert support["structure_1_K_Sym2K"]["rank_pure_K3_block"] == 56
    assert support["structure_1_K_Sym2K"]["full_K3_coverage"] is True
    assert support["structure_1_K_Sym2K"]["structure_1_K_Sym2K_K3_border"] == "HOLDS"

    # Membership: every unit vector of the 56 is in the rowspan
    for fi in range(56):
        e = np.zeros((1, 56), dtype=np.int64)
        e[0, fi] = 1
        assert C.rank_mod(np.vstack([block, e]), P) == rk

    # Artifact blocks
    art = np.load(ROOT / "tmp" / "p25yb" / "qk_blocks_p89.npz")
    assert int(C.rank_mod(art["block_K3"].astype(np.int64) % P, P)) == 56

    # Preflight remaining work
    assert "64 GiB" in preflight["reason"] or "F4" in preflight["reason"]
    assert "what_remained" in support
    assert support["survivors"]["count"] == 0

    print("PASS verify_p25yb")
    print("  K³ border HOLDS (rank 56/56) — necessary for 1⊕K⊕Sym²K")
    print("  exit=P25YB-F4-SLOT-REQUEST (no compact annihilator under 8 GiB)")
    print("  P25Y-FULL-ROWSPACE-746 NOT sealed; headline OPEN")


if __name__ == "__main__":
    main()
