#!/opt/homebrew/bin/python3
"""Independent verifier for SEAL.json; does not import the seal producer."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM_ROOT = HERE.parents[1]

EXPECTED_FILES = {
    "CLASS_RANKING.md",
    "COMPLETION_AUDIT.md",
    "DESCENDED_HILBERT_COMPONENT.md",
    "POINT_EXTRACTION.md",
    "REPLAY.md",
    "SOURCES.md",
    "STATUS.md",
    "UNIVERSAL_CURVE_EQUATIONS.md",
    "descended_hilbert_payload.json",
    "make_seal.py",
    "pfaffian_quintic_universal.json",
    "produce_descended_component.py",
    "produce_pfaffian_universal.py",
    "source_manifest.json",
    "verify_all.py",
    "verify_descended_component.py",
    "verify_pfaffian_universal.py",
    "verify_seal.py",
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def expected_external_dependencies():
    descended = load(HERE / "descended_hilbert_payload.json")
    sources = load(HERE / "source_manifest.json")
    result = {
        path: sha
        for path, sha in descended["dependencies_sha256"].items()
        if "/" in path
    }
    for entry in sources["dependencies"]:
        result[entry["path"]] = entry["sha256"]
    return dict(sorted(result.items()))


def main() -> None:
    seal = load(HERE / "SEAL.json")
    assert seal["schema"] == "klein-r2-rational-curves-seal-v1"
    assert seal["packet"] == "R_RATIONAL_CURVES"
    assert seal["exit"] == "R2-DESCENT-OBSTRUCTED"
    assert seal["headline"] == "OPEN"
    assert seal["pinned_state"] == "35fa8f59b6a1423cc89300aeaceefe91552be5ba"
    assert seal["live_state_audited"] == "37d61c19a108781cf74af837e24810a9f7f7c3be"
    assert set(seal["sealed_files"]) == EXPECTED_FILES

    recomputed = {}
    for name in sorted(EXPECTED_FILES):
        path = HERE / name
        assert path.is_file(), path
        observed = {"bytes": path.stat().st_size, "sha256": digest(path)}
        assert observed == seal["sealed_files"][name], name
        recomputed[name] = observed
    canonical_hash = hashlib.sha256(
        json.dumps(recomputed, sort_keys=True, separators=(",", ":")).encode("utf-8")
    ).hexdigest()
    assert canonical_hash == seal["sealed_files_canonical_sha256"]

    dependencies = expected_external_dependencies()
    assert dependencies == seal["external_dependencies_sha256"]
    for relative, expected in dependencies.items():
        path = PROBLEM_ROOT / relative
        assert path.is_file(), path
        assert digest(path) == expected, path
    print("R2_SEAL_VERIFY_OK")


if __name__ == "__main__":
    main()
