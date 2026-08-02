#!/usr/bin/env python3
"""Hash-bound replay of the A5-to-full-Schur degree-11 zero-cycle bridge."""

from __future__ import annotations

from hashlib import sha256
import importlib.util
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent


def project_root() -> Path:
    for candidate in (HERE, *HERE.parents):
        if (candidate / "goals_after_35fa8f").is_dir() and (candidate / "certificates").is_dir():
            return candidate
    raise AssertionError("E-klein-cubic project root not found")


def load_module(path: Path):
    spec = importlib.util.spec_from_file_location("q_a5_group_replay", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def is_prime(value: int) -> bool:
    return value >= 2 and all(value % divisor for divisor in range(2, int(value**0.5) + 1))


def main() -> None:
    root = project_root()
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["format"] == "q-schur-a5-degree11-cycle-seal-v1"
    for relative, expected in seal["files"].items():
        assert sha256((HERE / relative).read_bytes()).hexdigest() == expected, relative
    assert seal["marker"] == "Q_SCHUR_EFFECTIVE_DEGREE11_ZERO_CYCLE_VERIFIED"
    print(f"PACKET_SEAL_OK files={len(seal['files'])}")

    payload = json.loads((HERE / "payload.json").read_text())
    assert payload["format"] == "Q-SCHUR-A5-DEGREE11-CYCLE-v1"

    for relative, expected in payload["sources"].items():
        path = root / relative
        actual = sha256(path.read_bytes()).hexdigest()
        assert actual == expected, (relative, actual, expected)
    print(f"SOURCE_HASHES_OK files={len(payload['sources'])}")

    attack = root / "goals_after_35fa8f" / "point_attack_degree11_20260801"
    completed = subprocess.run(
        [sys.executable, "-u", "verify_exact_point.py"],
        cwd=attack,
        check=True,
        capture_output=True,
        text=True,
        timeout=900,
    )
    print(completed.stdout, end="")
    required = (
        "degree_11_covariant_rank=5",
        "degree_33_invariant_dimension=6",
        "class_2_all_six_exact_landing_values=0_in_K(alpha_plus)",
        "class_1_all_six_conjugate_landing_values=0_in_K(alpha_minus)",
        "H3_EXACT_BOTH_A5_POINTS_VERIFIED",
    )
    assert all(marker in completed.stdout for marker in required)
    print("EXACT_A5_EQUIVARIANT_LANDING_REPLAY_OK")

    producer_path = root / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "produce.py"
    group = load_module(producer_path)
    assert len(group.GROUP) == 660
    first, second = group.two_a5_classes()
    for _a, _b, subgroup in (first, second):
        assert len(subgroup) == 60
        assert len(group.orbit(subgroup)) == 11
        assert len(group.normalizer(subgroup)) == 60
    assert group.orbit(first[2]).isdisjoint(group.orbit(second[2]))

    stored = json.loads(
        (root / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json").read_text()
    )
    records = [record for record in stored["records"] if record["label"].startswith("A5_class_")]
    assert len(records) == 2 and all(record["order"] == 60 for record in records)
    assert stored["a5_conjugacy_class_sizes"] == [11, 11]

    data = payload["group"]
    assert data["order"] == len(group.GROUP) == data["subgroup_order"] * data["index"]
    assert data["subgroup_order"] == 60 and data["index"] == 11 and is_prime(data["index"])
    print("FULL_GROUP_A5_INDEX11_MAXIMALITY_REPLAY_OK")

    bridge = payload["bridge"]
    assert bridge["zero_cycle_degree"] == data["index"]
    assert payload["scope"]["binary_goal_status"] == payload["headline"] == "Q-UNDECIDED"
    assert "K-point or a degree-11 closed point" in payload["scope"]["proved"]
    print("A5_WEAK_VERSALITY_BRIDGE_AUDIT_OK")
    print("Q_SCHUR_EFFECTIVE_DEGREE11_ZERO_CYCLE_VERIFIED")


if __name__ == "__main__":
    main()
