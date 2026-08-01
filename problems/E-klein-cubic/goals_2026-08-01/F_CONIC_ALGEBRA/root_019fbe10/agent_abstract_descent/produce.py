#!/usr/bin/env python3
"""Produce the abstract-descent proof payload from accepted exact inputs."""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
GOALS = HERE.parents[2]
PROBLEM = GOALS.parent
RESTRICTED = PROBLEM / "certificates/restricted_e3/restricted_algebra.json"
RESTRICTED_MD = PROBLEM / "certificates/restricted_e3/RESTRICTED_ETALE_ALGEBRA.md"
DECISION_MD = PROBLEM / "certificates/restricted_e3/DECISION.md"
TERMINALITY_MD = PROBLEM / "certificates/fixed_frame_arithmetic/TERMINALITY_AUDIT.md"
INFINITY = GOALS / "F_CONIC_ALGEBRA/infinity_obstruction.json"
INFINITY_MD = GOALS / "F_CONIC_ALGEBRA/INFINITY_OBSTRUCTION.md"
INFINITY_VERIFY = GOALS / "F_CONIC_ALGEBRA/verify_infinity_obstruction.py"


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def main() -> None:
    restricted = json.loads(RESTRICTED.read_text())
    infinity = json.loads(INFINITY.read_text())

    orbit = restricted["R_over_F"]["galois_module"]["orbits"]["nonzero"]
    assert "size 8" in orbit
    assert restricted["R_over_F"]["presentation"]["nonzero_factor"]["is_field"] is True
    assert restricted["R_over_F"]["presentation"]["nonzero_factor"]["rank_over_F"] == 8
    assert "S6" in restricted["base_fields"]["K_proj"]["monodromy"]
    assert infinity["exit"] == "F-CONIC-CRITERION-EMPTY"
    assert infinity["valuation"]["ramification_index"] == 1
    assert infinity["valuation"]["residue_degree"] == 1
    assert infinity["class_group"]["index"] == 3

    payload = {
        "format": "goal-F-abstract-descent-v1",
        "scope": "fixed-frame plane cubic over F and K_proj",
        "inputs": {
            "E3_nonzero_orbit_size": 8,
            "K_galois_closure": "S6",
            "xi_maps_to": "nonzero [C] in H^1(F,E)[3]",
        },
        "theorem": {
            "E3_of_N": 0,
            "restriction_H1_E3": "injective",
            "restricted_xi": "nonzero",
            "restricted_alpha_R": "noncube",
        },
        "strict_boundary": {
            "noncube_alone_proves_CK_empty": False,
            "remaining_without_valuation": "membership in delta(E(K_proj)/3E(K_proj))",
            "trace_corestriction_formal_obstruction": False,
        },
        "infinity_cross_check": {
            "exit": infinity["exit"],
            "ef": [1, 1],
            "residue_index": 3,
            "cohomological_consequence": "image(res(xi))=res([C]) is nonzero in H^1(K_proj,E)[3]",
            "consistent": True,
        },
        "sources_sha256": {
            str(RESTRICTED.relative_to(PROBLEM)): digest(RESTRICTED),
            str(RESTRICTED_MD.relative_to(PROBLEM)): digest(RESTRICTED_MD),
            str(DECISION_MD.relative_to(PROBLEM)): digest(DECISION_MD),
            str(TERMINALITY_MD.relative_to(PROBLEM)): digest(TERMINALITY_MD),
            str(INFINITY.relative_to(GOALS)): digest(INFINITY),
            str(INFINITY_MD.relative_to(GOALS)): digest(INFINITY_MD),
            str(INFINITY_VERIFY.relative_to(GOALS)): digest(INFINITY_VERIFY),
        },
        "terminal_markers": [
            "GOAL_F_E3_RESTRICTION_INJECTIVE_ACCEPT",
            "GOAL_F_INFINITY_COHOMOLOGY_CONSISTENT_ACCEPT",
        ],
    }
    output = HERE / "proof_payload.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {output}")
    print("GOAL_F_ABSTRACT_DESCENT_PRODUCED")


if __name__ == "__main__":
    main()
