#!/opt/homebrew/bin/python3
"""Produce the exact T0 route-refutation payload and artifact seal."""
from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
GOALS = HERE.parent
ROOT = GOALS.parent
COMMIT_CONSUMED = "80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c"
BASELINE = "715faf441289e2589b9325311b6613ea0331bf88"

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

MARKERS = {
    "goal": [
        "If any arrow is unavailable at the stated generality, repair it first or return `T-BRIDGE-BLOCKED` with a precise counterexample/gap.",
        "another theorem that destroys the proposed negative implication.",
    ],
    "repair": [
        "The auxiliary Pfaffian characteristic cubic in Sym(A,sigma)",
        "This is not a point of \\(F_{14,T}\\) or of the generic Klein twist. The `FAIL-SCOPE` bridge audit is authoritative.",
    ],
    "bridge_audit": [
        "has a **broken first arrow**.",
        "The missing bridge is the simultaneous",
        "isotropy condition for the descended five-plane `H_T ⊂ Herm_3(D)`.",
    ],
    "idempotent_dictionary": [
        "**not** a Fano point and **not** a Klein point.",
        "| `h_i(q,q)=0` (5 eqs on `D²`) | Fano point | common isotropic line | **unknown** (live gate) |",
    ],
    "fixed_frame_terminality": [
        "C(K_proj) ≠ ∅  =/=>  X is G-unirational",
        "Bridge to Klein unirationality is a separate arrow outside this packet.",
    ],
    "fixed_frame_index": [
        "The full fixed-frame Pfaffian plane cubic descends to `F`; over this field it",
        "This is not a no-point theorem over `K_proj`.",
    ],
}

SEALED_ARTIFACTS = [
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
]


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def locate_marker(path: Path, marker: str) -> dict[str, object]:
    lines = path.read_text().splitlines()
    for i, line in enumerate(lines, 1):
        if marker in line:
            return {"line": i, "text": line.strip()}
    raise AssertionError(f"marker not found in {path}: {marker}")


def counterexample_certificate() -> dict[str, object]:
    s, t, x, y, z, w, q = sp.symbols("s t x y z w q")
    c0 = x**3 + s * y**3 + t * z**3
    cubic = c0 + w**2 * x + q**3
    variables = (x, y, z, w, q)
    grad = [sp.diff(cubic, v) for v in variables]
    section = sp.expand(cubic.subs({w: 0, q: 0}))
    point = {x: 0, y: 0, z: 0, w: 1, q: 0}

    assert sp.expand(section - c0) == 0
    assert sp.expand(cubic.subs(point)) == 0
    assert [sp.expand(g.subs(point)) for g in grad] == [1, 0, 0, 0, 0]
    assert sp.expand(3 * x**3 - (x * grad[0] - sp.Rational(1, 2) * w * grad[3])) == 0
    assert sp.expand(w**3 - (w * grad[0] - sp.Rational(3, 2) * x * grad[3])) == 0
    assert sp.diff(c0, x) == 3 * x**2
    assert sp.diff(c0, y) == 3 * s * y**2
    assert sp.diff(c0, z) == 3 * t * z**2

    residues = {"x^3": 0, "s*y^3": 0, "t*z^3": 1}
    possible_equal_residue_pairs = [
        list(pair)
        for pair in itertools.combinations(residues, 2)
        if residues[pair[0]] == residues[pair[1]]
    ]
    assert possible_equal_residue_pairs == [["x^3", "s*y^3"]]
    assert 1 % 3 != 0  # v_s(-s)=1, whereas cube valuations lie in 3Z.

    return {
        "field": "C((s))((t))",
        "plane_cubic": str(c0),
        "threefold": str(cubic),
        "section_substitution": {"w": 0, "q": 0},
        "rational_point": [0, 0, 0, 1, 0],
        "gradient_at_point": [1, 0, 0, 0, 0],
        "smoothness_radical_certificates": [
            "3*x^3 = x*Y_x-(w/2)*Y_w",
            "w^3 = w*Y_x-(3*x/2)*Y_w",
            "Y_y=3*s*y^2, Y_z=3*t*z^2, Y_q=3*q^2",
        ],
        "t_valuation_residues_mod_3": residues,
        "possible_minimal_tie": possible_equal_residue_pairs[0],
        "residue_obstruction": "v_s(-s)=1 is not divisible by 3",
        "index_argument": "line divisor gives index|3; genus-one index 1 gives a K-point; no K-point; hence index=3",
    }


def main() -> None:
    actual_hashes = {name: digest(path) for name, path in SOURCES.items()}
    assert actual_hashes == EXPECTED_SOURCE_HASHES

    source_markers = {
        name: [locate_marker(SOURCES[name], marker) for marker in markers]
        for name, markers in MARKERS.items()
    }
    payload = {
        "schema": "klein-cubic-target-branch-route-refutation-v1",
        "exit": "T-ROUTE-REFUTED",
        "t0_subexit": "T-BRIDGE-BLOCKED",
        "problem_e_headline": "OPEN",
        "baseline": BASELINE,
        "commit_consumed": COMMIT_CONSUMED,
        "source_sha256": actual_hashes,
        "source_markers": source_markers,
        "valid_arrow": "ind(C_fix/k(D))=3 => C_fix(K_proj)=empty by proper specialization at k(R)=k(D)",
        "missing_arrow": "C_fix(K_proj)=empty =/=> X_gen(K_proj)=empty (no accepted theorem)",
        "counterexample": counterexample_certificate(),
        "scope": {
            "proves": [
                "the advertised BR-T-NEG continuation is unavailable for the fixed-frame plane cubic",
                "index three of a smooth coordinate plane section does not formally imply pointlessness of a smooth cubic threefold",
                "the commissioned target-branch route exits T-ROUTE-REFUTED",
            ],
            "does_not_prove": [
                "X_gen(K_proj) is empty",
                "X_gen(K_proj) has a point",
                "the Klein cubic is or is not G-unirational",
                "ed_C(PSL(2,F_11)) equals 3 or 4",
            ],
        },
    }
    payload_path = HERE / "proof_payload.json"
    payload_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")

    artifact_hashes = {name: digest(HERE / name) for name in SEALED_ARTIFACTS}
    seal = {
        "schema": "klein-cubic-target-branch-route-refutation-seal-v1",
        "exit": "T-ROUTE-REFUTED",
        "commit_consumed": COMMIT_CONSUMED,
        "artifacts_sha256": artifact_hashes,
        "sources_sha256": actual_hashes,
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print("T_TARGET_BRANCH_ROUTE_REFUTATION_PRODUCER_SEALED")


if __name__ == "__main__":
    main()
