#!/usr/bin/env python3
"""Seal the retained canonical three-frame discovery packet."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "THREE_FRAME_SLICE_SEAL.json"
FILES = (
    "THREE_FRAME_SLICE_REPORT.md",
    "THREE_FRAME_SLICE_REPLAY.md",
    "three_frame_slice_probe.py",
    "three_frame_slice_specializations_f23.json",
    "three_frame_slice_geometry.py",
    "three_frame_slice_certificate.json",
    "verify_three_frame_slice.py",
    "degree8_invariant_linear_slice.py",
    "degree8_invariant_linear_slice_certificate.json",
    "verify_degree8_invariant_linear_slice.py",
    "make_three_frame_slice_seal.py",
    "verify_three_frame_slice_seal.py",
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    assert all((HERE / name).is_file() for name in FILES)
    payload = {
        "schema": "full-schur-canonical-three-frame-slice-seal-v1",
        "governing_status": "Q-UNDECIDED",
        "proved_scope": (
            "generic C_015 is a smooth geometrically integral genus-three "
            "plane quartic and the recorded invariant-ratio ansatz has no survivor"
        ),
        "strict_nonclaim": "no K_Schur-rational point is found or excluded",
        "files": {
            name: {
                "bytes": (HERE / name).stat().st_size,
                "sha256": sha256(HERE / name),
            }
            for name in FILES
        },
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"WROTE THREE_FRAME_SLICE_SEAL.json files={len(FILES)} sha256={sha256(OUTPUT)}")


if __name__ == "__main__":
    main()
