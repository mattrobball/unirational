#!/usr/bin/env python3
"""Write the hash/size manifest for the discriminant packet."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]


def record(path: Path) -> dict[str, int | str]:
    data = path.read_bytes()
    return {
        "path": str(path.relative_to(PROBLEM)),
        "bytes": len(data),
        "sha256": hashlib.sha256(data).hexdigest(),
    }


packet_names = [
    "REPORT.md",
    "REPLAY.md",
    "produce_discriminant.py",
    "fixed_frame_discriminant_T.tsv",
    "fixed_frame_discriminant_Z.tsv",
    "discriminant_payload.json",
    "produce_boundary_contacts.py",
    "boundary_contact_payload.json",
    "analyze_affine_plane.py",
    "affine_plane_contact_numerator.tsv",
    "affine_plane_F15.tsv",
    "affine_plane_contact_payload.json",
    "check_plane_codim3.py",
    "plane_codim3_payload.json",
    "check_plane_local_types.py",
    "plane_local_types_payload.json",
    "check_conductor_delta.py",
    "conductor_delta_payload.json",
    "projective_slice_audit.py",
    "projective_slice_p1009.sing",
    "projective_slice_p1009.out",
    "projective_slice_payload.json",
    "verify.py",
    "make_seal.py",
]

sources = [
    PROBLEM / "certificates/fixed_frame_arithmetic/five_forms.json",
    PROBLEM / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv",
    PROBLEM / "tmp/xcd_descent_algebra/universal_invariants.json",
    HERE.parent / "generic_singular_rur_QZ.tsv",
    HERE.parent / "generic_singular_rur_NB.tsv",
    HERE.parent / "generic_singular_rur_NY.tsv",
]


def main() -> None:
    artifacts = [record(HERE / name) for name in packet_names]
    payload = {
        "schema": "t3-fixed-frame-discriminant-partial-seal-v1",
        "status": "exact partial packet; global normalized T3.D ledger open",
        "coordinate": "T=Z-11*A^2/18",
        "proved_contact_orders": {
            "S=(A-15L,Y-12L)": {"valuation": 2, "mod_3": 2},
            "E=(L,A), every generic normalization branch": {"valuation": 4, "mod_3": 1},
        },
        "open_obstructions": [
            "authoritative finite birational normalization and conductor",
            "exhaustive normalized height-one support",
            "normalization/local class groups above J1, J2, and F15",
            "identification and exhaustion of the candidate degree-six RUR conductor prime",
        ],
        "artifacts": artifacts,
        "sources": [record(path) for path in sources],
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("T3_DISCRIMINANT_PARTIAL_SEAL_WRITTEN")


if __name__ == "__main__":
    main()
