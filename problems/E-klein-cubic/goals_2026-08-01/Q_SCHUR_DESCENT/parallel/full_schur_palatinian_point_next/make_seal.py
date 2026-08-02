#!/usr/bin/env python3
"""Create the strict retained-file seal for the completed theorem packet."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "SEAL.json"

# This is intentionally an explicit theorem-packet closure.  Later discovery
# files in this directory are not silently pulled into the completed result.
GROUPS = {
    "report_and_replay": (
        "REPORT.md",
        "REPLAY.md",
    ),
    "certificates_and_manifests": (
        "certificate.json",
        "degree9_projective_emptiness_certificate.json",
        "source_manifest.json",
    ),
    "verifiers": (
        "verify.py",
        "verify_degree9_projective_emptiness.py",
        "verify_seal.py",
    ),
    "replay_sources": (
        "pencil_mod23.py",
        "factor_natural_pencil_mod23.py",
        "produce_certificate.py",
        "degree9_full_landing.py",
        "eigenline_rank_one_probe.py",
        "degree9_binary_factor_sat.py",
        "degree9_binary_factor_sat_exhaustive.py",
        "degree9_fast_linear_sat.py",
        "make_degree9_certificate.py",
        "make_seal.py",
    ),
    "frozen_replay_data": (
        "degree9_rank_one_eigenlines_f529.json",
        "degree9_binary_clauses_f529.json",
        "degree9_fast_linear_sat_f529.json",
    ),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    names = [name for group in GROUPS.values() for name in group]
    assert len(names) == len(set(names))
    assert all((HERE / name).is_file() for name in names)
    payload = {
        "schema": "full-schur-palatinian-point-next-strict-seal-v1",
        "bounded_theorems": [
            "ten natural Palatini pencils are irreducible in the good fibre",
            "the q1--q3 pencil has no algebraic-constant rational root",
            "no nonzero constant-coefficient degree-nine polynomial Schur self-covariant lands identically on the Palatini quartic",
        ],
        "governing_status": "Q-UNDECIDED",
        "strict_scope": (
            "No arbitrary K_Schur-rational frame coefficient verdict, "
            "no V14(K_Schur) or X_Schur(K_Schur) point, and no binary Q verdict."
        ),
        "groups": {key: list(value) for key, value in GROUPS.items()},
        "files": {
            name: {
                "bytes": (HERE / name).stat().st_size,
                "sha256": sha256(HERE / name),
            }
            for name in names
        },
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"WROTE SEAL.json files={len(names)} sha256={sha256(OUTPUT)}")


if __name__ == "__main__":
    main()
