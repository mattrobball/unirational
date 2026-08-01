#!/opt/homebrew/bin/python3
"""Produce the Goal T2 route-refutation payload and complete seal."""
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

MARKERS = {
    "goal_t2": [
        "Complete `BR-T-NEG` on the genuine multiplicity-one target branch",
        "T2-ROUTE-REFUTED",
        "Verify residue degree one, proper specialization, versality, and the exact field identifications required by `BR-T-NEG`.",
    ],
    "goal_b": [
        "the genuine generic Klein twist over the accepted versal invariant field",
        "the selected fixed ternary frame cubic `C/F`",
        "the fixed-frame condition is merely sufficient and not necessary.",
    ],
    "implementation_audit": [
        "The worker correctly withholds the Klein-cubic headline",
        "the repaired repository does not identify pointlessness of this auxiliary fixed-frame plane cubic with pointlessness of the genuine generic Klein twist.",
    ],
    "repair": [
        "The auxiliary Pfaffian characteristic cubic in Sym(A,sigma)",
        "This is not a point of \\(F_{14,T}\\) or of the generic Klein twist.",
    ],
    "current_paths": ["`(e,f)=(2,1)`, so `m=1`."],
    "handoff": ["(e,f)=(2,1),\\qquad [k(R):k(D)]=1."],
    "bridge_audit": [
        "has a **broken first arrow**.",
        "isotropy condition for the descended five-plane `H_T ⊂ Herm_3(D)`.",
    ],
    "idempotent_dictionary": ["**not** a Fano point and **not** a Klein point."],
    "fixed_frame_terminality": [
        "C(K_proj) ≠ ∅  =/=>  X is G-unirational",
        "Bridge to Klein unirationality is a separate arrow outside this packet.",
    ],
    "infinity_theorem": [
        "e=1,  f=1,  residue field=C(D)=C(r,rho,T).",
        "This is a theorem about the auxiliary fixed-frame plane cubic.",
        "the genuine generic Klein twist, so the Klein headline remains open.",
    ],
    "infinity_status": [
        "This conclusion remains scoped to the auxiliary fixed-frame plane cubic.",
        "the genuine generic Klein twist, so the Klein-cubic headline remains",
    ],
}

SEALED_ARTIFACTS = [
    "STATUS.md",
    "THEOREM.md",
    "COMMON_OPEN.md",
    "BRIDGE_LEDGER.md",
    "LOCAL_CLASS_GROUPS.md",
    "GLOBAL_DEGREE_IMAGE.md",
    "REQUIREMENTS.md",
    "WORK_SCOPE.md",
    "component_payload.json",
    "normalization_payload.json",
    "proof_payload.json",
    "SOURCE_MANIFEST.json",
    "produce_t2_route_refutation.py",
    "verify_t2_route_refutation.py",
]


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def locate(path: Path, marker: str) -> dict[str, object]:
    for number, line in enumerate(path.read_text().splitlines(), 1):
        if marker in line:
            return {"line": number, "text": line.strip()}
    raise AssertionError(f"missing marker in {path}: {marker}")


def counterexample() -> dict[str, object]:
    s, t, x, y, z, w, q = sp.symbols("s t x y z w q")
    c0 = x**3 + s * y**3 + t * z**3
    cubic = c0 + w**2 * x + q**3
    grad = [sp.diff(cubic, v) for v in (x, y, z, w, q)]
    point = {x: 0, y: 0, z: 0, w: 1, q: 0}
    assert sp.expand(cubic.subs({w: 0, q: 0}) - c0) == 0
    assert sp.expand(cubic.subs(point)) == 0
    assert [sp.expand(g.subs(point)) for g in grad] == [1, 0, 0, 0, 0]
    assert sp.expand(3 * x**3 - (x * grad[0] - sp.Rational(1, 2) * w * grad[3])) == 0
    assert sp.expand(w**3 - (w * grad[0] - sp.Rational(3, 2) * x * grad[3])) == 0
    residues = {"x^3": 0, "s*y^3": 0, "t*z^3": 1}
    ties = [list(p) for p in itertools.combinations(residues, 2) if residues[p[0]] == residues[p[1]]]
    assert ties == [["x^3", "s*y^3"]]
    return {
        "field": "C((s))((t))",
        "plane_cubic": str(c0),
        "plane_index": 3,
        "threefold": str(cubic),
        "point": [0, 0, 0, 1, 0],
        "gradient_at_point": [1, 0, 0, 0, 0],
        "valuation_residues_mod_3": residues,
        "only_possible_minimum_tie": ties[0],
        "residue_obstruction": "v_s(-s)=1 not in 3Z",
        "smoothness_identities": [
            "3*x^3=x*Y_x-(w/2)*Y_w",
            "w^3=w*Y_x-(3*x/2)*Y_w",
        ],
    }


def main() -> None:
    hashes = {name: digest(path) for name, path in SOURCES.items()}
    assert hashes == EXPECTED_SOURCE_HASHES
    records = {
        name: [locate(SOURCES[name], marker) for marker in markers]
        for name, markers in MARKERS.items()
    }
    normalization = json.loads((HERE / "normalization_payload.json").read_text())
    components = json.loads((HERE / "component_payload.json").read_text())
    assert normalization["exit"] == "T2-ROUTE-REFUTED"
    assert normalization["target_branch_normalization_constructed"] is False
    assert normalization["infinity_place"]["ramification_index"] == 1
    assert normalization["genuine_target_place"]["ramification_index"] == 2
    assert components["comparison"]["same_ordered_place"] is False
    assert components["infinity_component"]["equation_payload_sha256"] == hashes["infinity_payload"]
    assert components["genuine_target_component"]["equation_sha256"] == hashes["target_equation"]

    payload = {
        "schema": "klein-cubic-T2-target-branch-route-refutation-v1",
        "exit": "T2-ROUTE-REFUTED",
        "pinned_state": PINNED,
        "commit_consumed": COMMIT,
        "headline": "OPEN",
        "ordered_place_mismatch": {
            "infinity": {"e": 1, "f": 1},
            "target": {"e": 2, "f": 1},
            "conclusion": "not the same ordered valuation",
        },
        "valid_hypothetical_arrow": "ind(C_fix/k(D_tar))=3 => C_fix(K_proj)=empty",
        "missing_arrow": "C_fix(K_proj)=empty =/=> X_gen(K_proj)=empty",
        "normalization_payload_status": "explicitly not constructed because non-load-bearing after terminal bridge refutation",
        "counterexample": counterexample(),
        "source_sha256": hashes,
        "source_markers": records,
        "scope": {
            "proves": [
                "the sealed infinity place and target branch are not the same ordered place",
                "the target-normalization route cannot reach the genuine-twist headline",
                "T2 exits T2-ROUTE-REFUTED",
            ],
            "does_not_prove": [
                "normalization or conductor of the genuine target branch",
                "local or global three-primary class-group vanishing on that normalization",
                "pointlessness or solubility of the genuine generic Klein twist",
                "non-G-unirationality or an essential-dimension value",
            ],
        },
    }
    (HERE / "proof_payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    manifest = {
        "schema": "klein-cubic-T2-source-manifest-v1",
        "pinned_state": PINNED,
        "commit_consumed": COMMIT,
        "sources_sha256": hashes,
    }
    (HERE / "SOURCE_MANIFEST.json").write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    seal = {
        "schema": "klein-cubic-T2-target-branch-route-refutation-seal-v1",
        "exit": "T2-ROUTE-REFUTED",
        "pinned_state": PINNED,
        "commit_consumed": COMMIT,
        "artifacts_sha256": {name: digest(HERE / name) for name in SEALED_ARTIFACTS},
        "sources_sha256": hashes,
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print("T2_TARGET_BRANCH_ROUTE_REFUTATION_PRODUCER_SEALED")


if __name__ == "__main__":
    main()
