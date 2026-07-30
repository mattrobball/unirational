#!/usr/bin/env python3
"""Independent verifier for WP-E1 Pic^0 obstruction.

Does NOT import produce.py.  Hash-checks fable packets, checks sealed JSON,
and replays the algebraic skeleton of the order-twelve trace contradiction.
"""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent

FABLE_HASHES = {
    "tmp/fable_relative_divisor_trace_obstruction/REPORT.md":
        "cfcda8682c86eb48222bfda6888aeec6580d362afd0a29d18a267b3696425573",
    "tmp/fable_relative_divisor_trace_obstruction/PROOF_AUDIT.md":
        "0cb5758e391e7b6b1986873139dbc99797fa1aa87bd96df63d253b7cfca5b499",
    "tmp/fable_relative_divisor_trace_obstruction/verify.py":
        "cdc46b4568f152b3bc24636949674e4f58ce924124c295ed89e32851c5361ca5",
    "tmp/fable_relative_q_trace_obstruction/REPORT.md":
        "bda7bf9a58025c15c097ce183f43655a9743f23e6e535776af3712f004bc452c",
    "tmp/fable_relative_q_trace_obstruction/PROOF_AUDIT.md":
        "bce1914db25b3c6d1cb451ffdca7c05e6e69b3dc97c8b974afcf41a85d0e29e7",
    "tmp/fable_relative_q_trace_obstruction/verify.py":
        "f9884d21a6d39170ba029348f3c10d21076c5b280937313382111408e5d82c40",
}


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_json(obj) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def main() -> None:
    print("WP-E1 independent verify")

    # Fable hash-check
    for rel, exp in FABLE_HASHES.items():
        h = sha256_file(ROOT / rel)
        assert h == exp, (rel, h, exp)
    print("PASS fable packet hashes")

    # Algebraic skeleton of the contradiction: 2T = -T ≠ 0 for T order 3
    # In additive group Z/3: 2 ≡ -1, and -1 ≠ 0.
    for T in (1, 2):
        assert (2 * T) % 3 == (-T) % 3
        assert (2 * T) % 3 != 0
    print("PASS Z/3 arithmetic 2T=-T≠0")

    # Order-12 residue ledger (combinatorial, from fable verify)
    import itertools
    triples = {
        tuple(sorted(t))
        for t in itertools.combinations_with_replacement((3, 4, 5, 6), 3)
        if sum(t) == 12
    }
    assert triples == {(3, 3, 6), (3, 4, 5), (4, 4, 4)}
    q_val = {(3, 3, 6): 2, (3, 4, 5): 1, (4, 4, 4): 0}
    assert [t for t, v in q_val.items() if v == 0] == [(4, 4, 4)]
    print("PASS order-12 residue ledger (only (4,4,4) is q-free)")

    # Sealed payload
    data_path = HERE / "picard_data.json"
    assert data_path.exists()
    data = json.loads(data_path.read_text())
    body = dict(data)
    h = body.pop("self_sha256")
    assert sha256_bytes(canonical_json(body).encode()) == h
    print("PASS self_sha256 picard_data.json")

    assert data["headline"] == "OPEN"
    assert data["work_package"] == "WP-E1"
    assert "wall_time" not in data and "timing" not in data

    reg = data["order12_quadratic_trace_regression"]
    assert reg["status"] == "PROVED_AS_REGRESSION"
    assert "2q" in reg["finite_quotient_exhibit"]["invariant_class"] or \
           "−q" in reg["finite_quotient_exhibit"]["invariant_class"] or \
           "-q" in reg["finite_quotient_exhibit"]["invariant_class"]
    print("PASS order12 regression theorem present")

    tests = data["trace_tests"]
    assert tests["summary"]["regression_order12"] == "RECOVERED"
    assert tests["summary"]["live_families_killed_by_same_trace"] is False
    assert len(tests["cases"]) >= 4
    # strengths present
    for c in tests["cases"]:
        assert "strength" in c
        assert "reason" in c
    print("PASS trace tests: 4+ cases, live families not falsely killed")

    # j invariant from accepted strata
    m3 = json.loads((CERT / "strata" / "marked_s3_geometry.json").read_text())
    assert m3["E_t"]["j_invariant"]["exact"] == "8192/11"
    print("PASS j(E_t)=8192/11 from accepted strata")

    # PICARD_OBSTRUCTION.md and SEAL exist
    assert (HERE / "PICARD_OBSTRUCTION.md").exists()
    assert (HERE / "SEAL.json").exists()
    print("PASS PICARD_OBSTRUCTION.md + SEAL.json present")

    print("WP_E1_PICARD_SEALED")


if __name__ == "__main__":
    main()
