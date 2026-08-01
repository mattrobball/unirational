#!/opt/homebrew/bin/python3
"""Independent verifier for the Goal T2 target-branch route refutation."""
from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
GOALS_2026 = ROOT / "goals_2026-08-01"
NEW_GOALS = ROOT / "goals_after_35fa8f"
PINNED = "35fa8f59b6a1423cc89300aeaceefe91552be5ba"
COMMIT = "37d61c19a108781cf74af837e24810a9f7f7c3be"

SOURCES = {
    "goal_t2": NEW_GOALS / "GOAL_T2_TARGET_BRANCH_NORMALIZATION.md",
    "goal_b": NEW_GOALS / "GOAL_B_FIXED_FRAME_TO_GENERIC_BRIDGE.md",
    "implementation_audit": NEW_GOALS / "IMPLEMENTATION_AUDIT.md",
    "repair": ROOT / "REPAIR.md",
    "current_paths": ROOT / "CURRENT_PATHS.md",
    "handoff": ROOT / "HANDOFF.md",
    "bridge_audit": ROOT / "certificates/pfaffian_point/BRIDGE_AUDIT.md",
    "idempotent_dictionary": ROOT / "certificates/pfaffian_point/IDEMPOTENT_TO_KLEIN_POINT.md",
    "fixed_frame_terminality": ROOT / "certificates/fixed_frame_arithmetic/TERMINALITY_AUDIT.md",
    "infinity_theorem": GOALS_2026 / "F_CONIC_ALGEBRA/INFINITY_OBSTRUCTION.md",
    "infinity_status": GOALS_2026 / "F_CONIC_ALGEBRA/STATUS.md",
    "infinity_seal": GOALS_2026 / "F_CONIC_ALGEBRA/SEAL.json",
    "infinity_payload": GOALS_2026 / "F_CONIC_ALGEBRA/infinity_obstruction.json",
    "target_equation": ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv",
}
EXPECTED_SOURCE_HASHES = {
    "goal_t2": "0e6530f43a830a60bb06275b2ffee84aa9eccf11f48a8c9b72c83f936b7e35b7",
    "goal_b": "634855e1ba8e9cb803ae9ab72c2df3530b9c804f1531f725a628c2bd1f8ec2cc",
    "implementation_audit": "9bfe6898b624a659aa72cec25c58f9e5d7c799bad15ef470be5ec68f73eb5444",
    "repair": "c7cc9d822885726c5dc6b8168e3a1cf55ab6a5f929b3c8ea16e3f77bd3528e54",
    "current_paths": "664bd6fcc01908c4cea126a05eab2dec50fba8c6bcb191f68e7f69b330647ed6",
    "handoff": "748e5fda516777708511c4683c73e0cd50a5aa7f1847d845281fa330f3f4f6ca",
    "bridge_audit": "0c9cf64c0a7c367286afd2636bf8f1c8dc432df8616075fb4d6434dcf0d16031",
    "idempotent_dictionary": "d1194af309c13b46ce1c4d5d9c3d24a17ab5308b619559ea82a0bcea79fdefd8",
    "fixed_frame_terminality": "606794be144d89c24fe8f0593ff775812c2cd1b325361e6bbbdf2a8b01e73677",
    "infinity_theorem": "0a0f4d414b9c3b989dcc67f568d14075c0b8cf92579911aee6f4154850d97a2a",
    "infinity_status": "b87093e6a9b557ad5240abd121474fe6f98f50dfe415326c76df051f5aea153f",
    "infinity_seal": "31d8863087fa8f4977b328921a57ed916fe1b334ad3761e3426092a24bf77394",
    "infinity_payload": "00316341a4d5207d8630e3d8d4411113b8fa2df5f6b3db42b48aa3003e094405",
    "target_equation": "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501",
}

EXPECTED_ARTIFACTS = {
    "STATUS.md", "THEOREM.md", "COMMON_OPEN.md", "BRIDGE_LEDGER.md",
    "LOCAL_CLASS_GROUPS.md", "GLOBAL_DEGREE_IMAGE.md", "REQUIREMENTS.md",
    "WORK_SCOPE.md", "component_payload.json", "normalization_payload.json", "proof_payload.json",
    "SOURCE_MANIFEST.json", "produce_t2_route_refutation.py",
    "verify_t2_route_refutation.py",
}

REQUIRED_TEXT = {
    "goal_t2": ["T2-ROUTE-REFUTED", "exact field identifications required by `BR-T-NEG`"],
    "goal_b": ["the fixed-frame condition is merely sufficient and not necessary"],
    "implementation_audit": ["correctly withholds the Klein-cubic headline"],
    "repair": ["not a point of \\(F_{14,T}\\) or of the generic Klein twist"],
    "current_paths": ["`(e,f)=(2,1)`, so `m=1`."],
    "bridge_audit": ["has a **broken first arrow**", "five-plane `H_T ⊂ Herm_3(D)`"],
    "idempotent_dictionary": ["**not** a Fano point and **not** a Klein point"],
    "fixed_frame_terminality": ["C(K_proj) ≠ ∅  =/=>  X is G-unirational"],
    "infinity_theorem": ["e=1,  f=1", "auxiliary fixed-frame plane cubic"],
    "infinity_status": ["genuine generic Klein twist"],
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def fail(message: str) -> None:
    raise SystemExit(f"FAIL: {message}")


def verify_sources(payload: dict[str, object]) -> None:
    hashes = {name: digest(path) for name, path in SOURCES.items()}
    if hashes != EXPECTED_SOURCE_HASHES or payload.get("source_sha256") != hashes:
        fail("source hash table")
    for name, needles in REQUIRED_TEXT.items():
        text = SOURCES[name].read_text()
        for needle in needles:
            if needle not in text:
                fail(f"source theorem marker {name}: {needle}")
    records = payload.get("source_markers")
    if not isinstance(records, dict):
        fail("source marker records")
    for name, entries in records.items():
        lines = SOURCES[name].read_text().splitlines()
        for entry in entries:
            number = entry.get("line")
            if not isinstance(number, int) or not 1 <= number <= len(lines):
                fail("source marker line")
            if lines[number - 1].strip() != entry.get("text"):
                fail("source marker reconstruction")


def verify_counterexample(payload: dict[str, object]) -> None:
    s, t, x, y, z, w, q = sp.symbols("s t x y z w q")
    c0 = x**3 + s * y**3 + t * z**3
    cubic = c0 + w**2 * x + q**3
    grad = [sp.diff(cubic, v) for v in (x, y, z, w, q)]
    point = {x: 0, y: 0, z: 0, w: 1, q: 0}
    checks = [
        sp.expand(cubic.subs({w: 0, q: 0}) - c0) == 0,
        sp.expand(cubic.subs(point)) == 0,
        [sp.expand(g.subs(point)) for g in grad] == [1, 0, 0, 0, 0],
        sp.expand(3 * x**3 - (x * grad[0] - sp.Rational(1, 2) * w * grad[3])) == 0,
        sp.expand(w**3 - (w * grad[0] - sp.Rational(3, 2) * x * grad[3])) == 0,
        [sp.diff(c0, v) for v in (x, y, z)] == [3*x**2, 3*s*y**2, 3*t*z**2],
    ]
    if not all(checks):
        fail("counterexample polynomial identities")
    residues = {"x^3": 0, "s*y^3": 0, "t*z^3": 1}
    ties = [list(p) for p in itertools.combinations(residues, 2) if residues[p[0]] == residues[p[1]]]
    if ties != [["x^3", "s*y^3"]] or 1 % 3 == 0:
        fail("valuation obstruction")
    cert = payload.get("counterexample")
    if cert.get("plane_index") != 3 or cert.get("point") != [0,0,0,1,0]:
        fail("counterexample payload")
    if cert.get("valuation_residues_mod_3") != residues or cert.get("only_possible_minimum_tie") != ties[0]:
        fail("counterexample valuation payload")


def verify_normalization_boundary() -> None:
    data = json.loads((HERE / "normalization_payload.json").read_text())
    false_keys = [
        "target_branch_normalization_constructed",
        "target_branch_conductor_constructed",
        "target_branch_local_class_groups_computed",
        "target_branch_horizontal_degree_image_computed",
    ]
    if data.get("exit") != "T2-ROUTE-REFUTED" or any(data.get(k) is not False for k in false_keys):
        fail("normalization nonclaim boundary")
    if data["infinity_place"] != {"ramification_index": 1, "residue_degree": 1, "residual_index": 3, "scope": "auxiliary fixed-frame plane cubic"}:
        fail("infinity place payload")
    if data["genuine_target_place"]["ramification_index"] != 2 or data["genuine_target_place"]["residue_degree"] != 1:
        fail("target place payload")


def verify_component_payload() -> None:
    data = json.loads((HERE / "component_payload.json").read_text())
    if data.get("exit") != "T2-ROUTE-REFUTED":
        fail("component payload exit")
    infinity = data.get("infinity_component")
    target = data.get("genuine_target_component")
    comparison = data.get("comparison")
    if infinity.get("equation_payload_sha256") != EXPECTED_SOURCE_HASHES["infinity_payload"]:
        fail("infinity component equation")
    if infinity.get("ramification_index") != 1 or infinity.get("residue_degree") != 1 or infinity.get("residual_fixed_frame_index") != 3:
        fail("infinity component invariants")
    if target.get("equation_sha256") != EXPECTED_SOURCE_HASHES["target_equation"]:
        fail("target component equation")
    if target.get("total_degree") != 43 or target.get("term_count") != 37992 or target.get("ramification_index") != 2 or target.get("residue_degree") != 1:
        fail("target component invariants")
    target_lines = SOURCES["target_equation"].read_text().splitlines()
    if len(target_lines) - 1 != 37992:
        fail("target component term count")
    if comparison != {"same_ordered_place": False, "proof": "ramification index mismatch 1 != 2", "abstract_residue_field_birationality_sufficient": False}:
        fail("component comparison")


def verify_seal(seal: dict[str, object]) -> None:
    if seal.get("exit") != "T2-ROUTE-REFUTED" or seal.get("pinned_state") != PINNED or seal.get("commit_consumed") != COMMIT:
        fail("seal boundary")
    artifacts = seal.get("artifacts_sha256")
    if not isinstance(artifacts, dict) or set(artifacts) != EXPECTED_ARTIFACTS:
        fail("seal inventory")
    for name, expected in artifacts.items():
        if digest(HERE / name) != expected:
            fail(f"sealed artifact: {name}")
    if seal.get("sources_sha256") != EXPECTED_SOURCE_HASHES:
        fail("sealed sources")


def main() -> None:
    payload = json.loads((HERE / "proof_payload.json").read_text())
    seal = json.loads((HERE / "SEAL.json").read_text())
    if payload.get("schema") != "klein-cubic-T2-target-branch-route-refutation-v1":
        fail("payload schema")
    if payload.get("exit") != "T2-ROUTE-REFUTED" or payload.get("headline") != "OPEN":
        fail("payload exit/headline")
    if payload.get("pinned_state") != PINNED or payload.get("commit_consumed") != COMMIT:
        fail("payload provenance")
    mismatch = payload.get("ordered_place_mismatch")
    if mismatch != {"infinity": {"e": 1, "f": 1}, "target": {"e": 2, "f": 1}, "conclusion": "not the same ordered valuation"}:
        fail("ordered-place mismatch")
    if payload.get("missing_arrow") != "C_fix(K_proj)=empty =/=> X_gen(K_proj)=empty":
        fail("missing-arrow boundary")
    if (HERE / "STATUS.md").read_text().splitlines()[0] != "T2-ROUTE-REFUTED":
        fail("STATUS first line")
    verify_sources(payload)
    verify_counterexample(payload)
    verify_component_payload()
    verify_normalization_boundary()
    verify_seal(seal)
    print("T2_TARGET_BRANCH_ROUTE_REFUTATION_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
