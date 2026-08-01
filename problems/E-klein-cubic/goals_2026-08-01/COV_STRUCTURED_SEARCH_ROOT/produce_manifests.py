#!/usr/bin/env python3
"""Materialize exact-basis, empty-candidate, and provenance manifests."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
DEGREES = (25, 31, 35)
PINNED_BASELINE = "715faf441289e2589b9325311b6613ea0331bf88"
SOURCES = (
    PROBLEM / "goals_2026-08-01" / "GOAL_COV_STRUCTURED_POSITIVE_SEARCH.md",
    PROBLEM / "certificates" / "exact_molien.py",
    PROBLEM / "certificates" / "modular_covariant_scan.py",
    PROBLEM / "tmp" / "degree13_opt" / "reconstruct_large_prime.py",
    PROBLEM / "tmp" / "d12_block_attack" / "analyze.py",
    PROBLEM / "tmp" / "symbolic_compatibility_complex" / "jet_scan.py",
    PROBLEM / "tmp" / "generic_twist" / "phi_coefficients.py",
    PROBLEM / "tmp" / "kproj_arithmetic" / "core.py",
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def dump(path: Path, payload: object) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


def relative(path: Path) -> str:
    return str(path.relative_to(PROBLEM))


def main() -> None:
    ranking = json.loads((HERE / "degree_ranking.json").read_text())
    ranked = {item["degree"]: item for item in ranking["ranking"]}
    summary = {
        "schema": "COV_SELECTED_GLOBAL_MODULES_V1",
        "pinned_mathematical_baseline": PINNED_BASELINE,
        "field": "Q(zeta_11)",
        "integral_model": "Z[zeta_11,1/660]",
        "selected_pairs": [],
        "theorem": (
            "for (d,m,e)=(25,3,7),(31,5,1),(35,5,5), the exact "
            "characteristic-zero global coefficient module is zero"
        ),
        "scope": "all selected m>=3 normal-cone residual families; no m=1 exclusion",
    }
    for degree in DEGREES:
        directory = HERE / f"degree_{degree}"
        seeds_path = directory / "covariant_basis_seeds.json"
        seeds = json.loads(seeds_path.read_text())
        p67 = json.loads((directory / "global_jets_p67.json").read_text())
        p89 = json.loads((directory / "global_jets_p89.json").read_text())
        record = ranked[degree]
        assert len(seeds) == record["self_covariant_dimension"]
        assert all(sum(item["exponents"]) == degree for item in seeds)
        assert p67["orders"] == p89["orders"]
        assert sum(item["jet_rank"] for item in p89["orders"]) == len(seeds)
        basis_manifest = {
            "schema": "COV_EXACT_REYNOLDS_BASIS_V1",
            "degree": degree,
            "field": "Q(zeta_11)",
            "basis_dimension": len(seeds),
            "molien_dimension": record["self_covariant_dimension"],
            "seed_payload": seeds_path.name,
            "seed_payload_sha256": sha256(seeds_path),
            "basis_element_formula": (
                "R_(j,alpha)(x)=(1/660) sum_(g in G) (g x)^alpha g^(-1)e_j"
            ),
            "basis_proof": (
                "each circuit is exactly G-equivariant by Reynolds averaging; "
                "the p=89 evaluation rank equals the seed count; reduction independence "
                "implies characteristic-zero independence; the independent Molien count "
                "equals that count"
            ),
            "split_discovery_basis_rank": {"prime": 67, "rank": p67["basis_rank"]},
            "independent_holdout_basis_rank": {
                "prime": 89,
                "zeta11": 78,
                "rank": p89["basis_rank"],
            },
            "normalization_note": "the factor 1/660 may be omitted without changing spans",
        }
        dump(directory / "basis_manifest.json", basis_manifest)

        selected = {
            "degree": degree,
            "plane_order": p67["plane_order"],
            "residual_degree": p67["residual_degree"],
            "characteristic_zero_global_module_dimension": 0,
            "split_67_filtration": [
                item["kernel_dimension"] for item in p67["orders"]
            ],
            "holdout_89_filtration": [
                item["kernel_dimension"] for item in p89["orders"]
            ],
            "stacked_holdout_rank": sum(item["jet_rank"] for item in p89["orders"]),
            "primitive_quotient_dimension": 0,
            "landing_equations_after_linear_elimination": 0,
        }
        candidate = {
            "schema": "COV_SELECTED_PAIR_CANDIDATE_V1",
            **selected,
            "candidate": None,
            "decision": "EMPTY_BEFORE_LANDING",
            "reason": (
                "the complete characteristic-zero global coefficient module with the "
                "selected common symbolic plane order is zero"
            ),
            "downstream_constraints": {
                "triple_line": "vacuous on zero module",
                "point_link": "vacuous on zero module",
                "C3": "vacuous on zero module",
                "marked_elliptic": "vacuous on zero module",
                "scalar_invariant_multiples": "zero",
                "known_compositions": "zero",
                "landing_identity": "no parameters remain",
            },
        }
        dump(directory / "candidate.json", candidate)
        summary["selected_pairs"].append(selected)

    dump(HERE / "global_module_summary.json", summary)
    source_manifest = {
        "schema": "COV_SOURCE_MANIFEST_V1",
        "pinned_mathematical_baseline": PINNED_BASELINE,
        "sources": {relative(path): sha256(path) for path in SOURCES},
    }
    dump(HERE / "SOURCE_MANIFEST.json", source_manifest)
    print("COV_MANIFESTS_PRODUCED")


if __name__ == "__main__":
    main()
