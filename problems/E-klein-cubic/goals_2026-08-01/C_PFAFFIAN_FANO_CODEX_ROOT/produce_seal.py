#!/usr/bin/env python3
"""Produce a hash seal for the honestly scoped Goal C dossier."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = (
    "STATUS.md",
    "README.md",
    "MODEL.md",
    "POINT.md",
    "MORITA_PROJECTOR_AUDIT.md",
    "compressed_algebra.json",
    "involution.json",
    "distinguished_five_plane.json",
    "ambient_leading_audit.json",
    "ambient_eliminant_adaptive_through_p397.json",
    "ambient_eliminant_holdout_p199.json",
    "ambient_rur_three_prime.json",
    "projector_descent_word_screen_p23.json",
    "verify_all.py",
    "verify_compressed_algebra.py",
    "verify_involution.py",
    "verify_distinguished_five_plane.py",
    "reconstruct_ambient_eliminant_adaptive.py",
    "search_projector_descent_words.py",
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    assert (HERE / "STATUS.md").read_text().startswith("C-UNDECIDED\n")
    for name in FILES:
        assert (HERE / name).is_file(), name
    payload = {
        "format": "goal-c-codex-root-scoped-seal-v1",
        "exit": "C-UNDECIDED",
        "verified_marker": "C-PARTIAL-EXACT-INTERFACE-VERIFIED",
        "scope": (
            "exact lazy compressed algebra and involution, exact distinguished "
            "five-plane before Morita, bounded auxiliary projector audits"
        ),
        "missing_for_positive_exit": [
            "K_proj-rational self-adjoint reduced-rank-two idempotent",
            "quaternion corner and explicit 3x3 Hermitian matrices",
            "simultaneous common isotropic right line",
            "original-equation Fano point and headline bridge",
        ],
        "files_sha256": {name: digest(HERE / name) for name in FILES},
        "theorem_boundary": (
            "this seal intentionally does not contain C-POINT-HEADLINE-POSITIVE"
        ),
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps({"exit": payload["exit"], "file_count": len(FILES)}, indent=2))
    print("C-UNDECIDED-SCOPED-SEAL-WRITTEN")


if __name__ == "__main__":
    main()
