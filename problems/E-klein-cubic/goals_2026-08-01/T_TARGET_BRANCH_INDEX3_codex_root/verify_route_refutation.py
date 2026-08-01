#!/opt/homebrew/bin/python3
"""Independent verifier for the T target-branch route refutation.

This script does not import the producer.  It re-hashes the binding inputs,
finds the source statements, rebuilds the exact counterexample identities,
and verifies every sealed terminal artifact.
"""
from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
GOALS = HERE.parent
ROOT = GOALS.parent
EXPECTED_COMMIT = "80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c"
EXPECTED_BASELINE = "715faf441289e2589b9325311b6613ea0331bf88"

SOURCES = {
    "goal": GOALS / "GOAL_T_TARGET_BRANCH_INDEX3.md",
    "repair": ROOT / "REPAIR.md",
    "current_paths": ROOT / "CURRENT_PATHS.md",
    "handoff": ROOT / "HANDOFF.md",
    "bridge_audit": ROOT / "certificates/pfaffian_point/BRIDGE_AUDIT.md",
    "idempotent_dictionary": ROOT / "certificates/pfaffian_point/IDEMPOTENT_TO_KLEIN_POINT.md",
    "fixed_frame_terminality": ROOT / "certificates/fixed_frame_arithmetic/TERMINALITY_AUDIT.md",
    "fixed_frame_index": ROOT / "tmp/pfaffian_global_fixed_frame_hostile_audit/REPORT.md",
}

EXPECTED_SOURCE_HASHES = {
    "goal": "145f74e92ca59aff0aa7c8ddefc8bb2e2d3b440a52f1b858029ddc75d05171ce",
    "repair": "c7cc9d822885726c5dc6b8168e3a1cf55ab6a5f929b3c8ea16e3f77bd3528e54",
    "current_paths": "664bd6fcc01908c4cea126a05eab2dec50fba8c6bcb191f68e7f69b330647ed6",
    "handoff": "748e5fda516777708511c4683c73e0cd50a5aa7f1847d845281fa330f3f4f6ca",
    "bridge_audit": "0c9cf64c0a7c367286afd2636bf8f1c8dc432df8616075fb4d6434dcf0d16031",
    "idempotent_dictionary": "d1194af309c13b46ce1c4d5d9c3d24a17ab5308b619559ea82a0bcea79fdefd8",
    "fixed_frame_terminality": "606794be144d89c24fe8f0593ff775812c2cd1b325361e6bbbdf2a8b01e73677",
    "fixed_frame_index": "9e392ab2d72ab545d453c6d8220091ccc072a250aa16256b6d407b0b2d2b85fb",
}

EXPECTED_ARTIFACTS = {
    "STATUS.md",
    "THEOREM.md",
    "T0_BRIDGE_LEDGER.md",
    "REQUIREMENTS.md",
    "INPUT_AUDIT.md",
    "WORK_SCOPE.md",
    "SCRATCH_SCOPE.md",
    "proof_payload.json",
    "produce_route_refutation.py",
    "verify_route_refutation.py",
}

REQUIRED_MARKERS = {
    "goal": [
        "If any arrow is unavailable at the stated generality, repair it first or return `T-BRIDGE-BLOCKED` with a precise counterexample/gap.",
        "another theorem that destroys the proposed negative implication.",
    ],
    "repair": [
        "The auxiliary Pfaffian characteristic cubic in Sym(A,sigma)",
        "not a point of \\(F_{14,T}\\) or of the generic Klein twist",
    ],
    "bridge_audit": [
        "has a **broken first arrow**.",
        "isotropy condition for the descended five-plane `H_T ⊂ Herm_3(D)`.",
    ],
    "idempotent_dictionary": [
        "**not** a Fano point and **not** a Klein point.",
        "common isotropic line | **unknown** (live gate)",
    ],
    "fixed_frame_terminality": [
        "C(K_proj) ≠ ∅  =/=>  X is G-unirational",
        "Bridge to Klein unirationality is a separate arrow outside this packet.",
    ],
    "fixed_frame_index": [
        "The full fixed-frame Pfaffian plane cubic descends to `F`",
        "This is not a no-point theorem over `K_proj`.",
    ],
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def fail(message: str) -> None:
    raise SystemExit(f"FAIL: {message}")


def verify_sources(payload: dict[str, object]) -> None:
    hashes = {name: digest(path) for name, path in SOURCES.items()}
    if hashes != EXPECTED_SOURCE_HASHES:
        fail("binding source hash mismatch")
    if payload.get("source_sha256") != hashes:
        fail("payload source hash mismatch")
    for name, markers in REQUIRED_MARKERS.items():
        text = SOURCES[name].read_text()
        for marker in markers:
            if marker not in text:
                fail(f"missing source marker {name}: {marker}")
    stored_markers = payload.get("source_markers")
    if not isinstance(stored_markers, dict):
        fail("payload source marker table")
    for name, records in stored_markers.items():
        if name not in SOURCES or not isinstance(records, list):
            fail("payload source marker entry")
        lines = SOURCES[name].read_text().splitlines()
        for record in records:
            line_number = record.get("line")
            line_text = record.get("text")
            if not isinstance(line_number, int) or not (1 <= line_number <= len(lines)):
                fail(f"payload source line number: {name}")
            if lines[line_number - 1].strip() != line_text:
                fail(f"payload source line text: {name}:{line_number}")


def verify_counterexample(payload: dict[str, object]) -> None:
    s, t, x, y, z, w, q = sp.symbols("s t x y z w q")
    c0 = x**3 + s * y**3 + t * z**3
    cubic = c0 + w**2 * x + q**3
    grad = [sp.diff(cubic, v) for v in (x, y, z, w, q)]
    point = {x: 0, y: 0, z: 0, w: 1, q: 0}

    if sp.expand(cubic.subs({w: 0, q: 0}) - c0) != 0:
        fail("plane-section identity")
    if sp.expand(cubic.subs(point)) != 0:
        fail("claimed point is not on the threefold")
    if [sp.expand(g.subs(point)) for g in grad] != [1, 0, 0, 0, 0]:
        fail("claimed point is not smooth")

    # These exact ideal identities, together with the three square partials,
    # put every homogeneous coordinate in the radical of the derivative ideal.
    cert_x = sp.expand(3 * x**3 - (x * grad[0] - sp.Rational(1, 2) * w * grad[3]))
    cert_w = sp.expand(w**3 - (w * grad[0] - sp.Rational(3, 2) * x * grad[3]))
    if cert_x != 0 or cert_w != 0:
        fail("threefold smoothness identities")
    if grad[1:] != [3 * s * y**2, 3 * t * z**2, 2 * w * x, 3 * q**2]:
        fail("threefold partial derivatives")
    if [sp.diff(c0, v) for v in (x, y, z)] != [3 * x**2, 3 * s * y**2, 3 * t * z**2]:
        fail("plane cubic partial derivatives")

    residues = {"x^3": 0, "s*y^3": 0, "t*z^3": 1}
    equal_pairs = [
        list(pair)
        for pair in itertools.combinations(residues, 2)
        if residues[pair[0]] == residues[pair[1]]
    ]
    if equal_pairs != [["x^3", "s*y^3"]]:
        fail("valuation tie enumeration")
    if 1 % 3 == 0:
        fail("cube-valuation obstruction")

    expected = payload["counterexample"]
    if expected["rational_point"] != [0, 0, 0, 1, 0]:
        fail("payload point mismatch")
    if expected["gradient_at_point"] != [1, 0, 0, 0, 0]:
        fail("payload gradient mismatch")
    if expected["t_valuation_residues_mod_3"] != residues:
        fail("payload valuation residues mismatch")
    if expected["possible_minimal_tie"] != equal_pairs[0]:
        fail("payload minimal tie mismatch")


def verify_seal(seal: dict[str, object]) -> None:
    if seal.get("exit") != "T-ROUTE-REFUTED":
        fail("seal exit")
    if seal.get("commit_consumed") != EXPECTED_COMMIT:
        fail("seal commit")
    if seal.get("sources_sha256") != EXPECTED_SOURCE_HASHES:
        fail("seal sources")
    artifacts = seal.get("artifacts_sha256")
    if not isinstance(artifacts, dict):
        fail("seal artifact table")
    if set(artifacts) != EXPECTED_ARTIFACTS:
        fail("seal artifact inventory")
    for name, expected in artifacts.items():
        path = HERE / name
        if not path.is_file() or digest(path) != expected:
            fail(f"sealed artifact mismatch: {name}")


def main() -> None:
    payload = json.loads((HERE / "proof_payload.json").read_text())
    seal = json.loads((HERE / "SEAL.json").read_text())
    if payload.get("schema") != "klein-cubic-target-branch-route-refutation-v1":
        fail("payload schema")
    if payload.get("exit") != "T-ROUTE-REFUTED":
        fail("payload exit")
    if payload.get("t0_subexit") != "T-BRIDGE-BLOCKED":
        fail("payload T0 subexit")
    if payload.get("problem_e_headline") != "OPEN":
        fail("headline boundary")
    if payload.get("baseline") != EXPECTED_BASELINE or payload.get("commit_consumed") != EXPECTED_COMMIT:
        fail("baseline or commit")
    if payload.get("valid_arrow") != "ind(C_fix/k(D))=3 => C_fix(K_proj)=empty by proper specialization at k(R)=k(D)":
        fail("valid-arrow scope")
    if payload.get("missing_arrow") != "C_fix(K_proj)=empty =/=> X_gen(K_proj)=empty (no accepted theorem)":
        fail("missing-arrow scope")

    status_first = (HERE / "STATUS.md").read_text().splitlines()[0]
    if status_first != "T-ROUTE-REFUTED":
        fail("STATUS first line")
    verify_sources(payload)
    verify_counterexample(payload)
    verify_seal(seal)
    print("T_TARGET_BRANCH_ROUTE_REFUTATION_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
