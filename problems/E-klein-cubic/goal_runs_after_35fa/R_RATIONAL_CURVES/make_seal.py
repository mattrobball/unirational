#!/opt/homebrew/bin/python3
"""Create the deterministic Goal R2 packet seal."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM_ROOT = HERE.parents[1]

SEALED_FILES = (
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
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def external_dependencies():
    descended = load(HERE / "descended_hilbert_payload.json")
    sources = load(HERE / "source_manifest.json")
    dependencies = {
        path: sha
        for path, sha in descended["dependencies_sha256"].items()
        if "/" in path
    }
    for entry in sources["dependencies"]:
        dependencies[entry["path"]] = entry["sha256"]
    for path, expected in dependencies.items():
        assert digest(PROBLEM_ROOT / path) == expected, path
    return dict(sorted(dependencies.items()))


def main() -> None:
    files = {}
    for name in SEALED_FILES:
        path = HERE / name
        assert path.is_file(), path
        files[name] = {"bytes": path.stat().st_size, "sha256": digest(path)}
    packet_hash = hashlib.sha256(
        json.dumps(files, sort_keys=True, separators=(",", ":")).encode("utf-8")
    ).hexdigest()
    seal = {
        "schema": "klein-r2-rational-curves-seal-v1",
        "packet": "R_RATIONAL_CURVES",
        "exit": "R2-DESCENT-OBSTRUCTED",
        "headline": "OPEN",
        "pinned_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "live_state_audited": "37d61c19a108781cf74af837e24810a9f7f7c3be",
        "sealed_files": files,
        "sealed_files_canonical_sha256": packet_hash,
        "external_dependencies_sha256": external_dependencies(),
        "terminal_marker": "R2_SEAL_CREATED",
    }
    output = HERE / "SEAL.json"
    output.write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print("wrote", output.name)
    print("R2_SEAL_CREATED")


if __name__ == "__main__":
    main()
