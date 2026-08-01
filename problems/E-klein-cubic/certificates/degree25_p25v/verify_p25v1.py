#!/usr/bin/env python3
"""Independent verifier for P25V.1 setup — does not import the producer.

Rebuilds the compression matrix C from seed 2026073189, checks full row rank,
checks C @ seed_F3 matches the stored compressed block, and verifies that any
claimed emptiness certificate is recomputed (not just read from JSON).

For UNDECIDED exits: verifies compression integrity and that no false emptiness
claim is present.
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
TMP = ROOT / "tmp" / "p25v_incidence"

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89
SEED_RNG = 2026073189


def main() -> None:
    print("=== P25V.1 verify ===", flush=True)
    payload = json.loads((HERE / "exit_p25v1.json").read_text())
    assert payload["prime"] == P
    assert payload["compression_seed_rng"] == SEED_RNG

    rel = np.load(FM / "relation_matrix.npz")
    seed = rel["seed_F3"].astype(np.int64) % P
    assert C.sha256_arr(rel["seed_F3"]) == payload["inputs"]["seed_F3_sha256"]

    checked = []
    for r_str, meta in payload["compressions"].items():
        r = int(r_str)
        path = Path(meta["path"])
        assert path.exists(), path
        z = np.load(path)
        # Rebuild C: default_rng(SEED).integers(0,P,size=(r,690))
        Cmat = np.random.default_rng(SEED_RNG).integers(0, P, size=(r, 690), dtype=np.int64) % P
        stored = z["C"].astype(np.int64) % P
        assert np.array_equal(stored, Cmat), f"compression C mismatch r={r}"
        assert C.rank_mod(stored, P) == r
        comp = (stored @ seed) % P
        assert np.array_equal(comp.astype(np.uint8), z["compressed"]), f"compressed block r={r}"
        assert C.sha256_arr(z["compressed"]) == meta["compressed_sha256"]
        checked.append(r)
        print(f"r={r} compression OK", flush=True)

    # No false emptiness: if exit is EMPTY, must have recomputable cert (not just JSON flag)
    if payload["exit"] == "P25-DEGREE25-EMPTY":
        cert = payload.get("empty_certificate")
        assert cert is not None
        # Verifier must recompute — for now require artifact exists and is not a bare flag
        assert Path(cert["file"]).exists()
        raise AssertionError(
            "EMPTY exit requires independent recomputation of the certificate form; "
            "extend this verifier when a unit-ideal / Nullstellensatz artifact is sealed."
        )
    else:
        assert payload["exit"] == "P25V-SUPPORT-UNDECIDED"
        assert payload.get("empty_certificate") is None
        assert payload.get("blocker") is not None

    result = {
        "exit": payload["exit"],
        "checked_compressions": checked,
        "no_false_emptiness_claim": True,
        "ok": True,
    }
    C.write_json_self_hash(HERE / "verify_p25v1_result.json", result)
    print("PASS", result, flush=True)


if __name__ == "__main__":
    main()
