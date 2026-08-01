#!/usr/bin/env python3
"""Install the ordered COV2.1 equalizer on the fixed global circuit bases.

There is one global coefficient vector.  Consequently every incidence
equalizer after the initial plane-vanishing condition is the restriction of
one and the same polynomial section; its two composites are literally the
same arithmetic circuit.  We record those zero residual matrices as circuit
identities instead of materializing enormous zero arrays.

This packet deliberately distinguishes the literal global module from the
sheafified compact module.  The degree-35 one-dimensional defects at 67 and
89 are special-fibre facts; they are not promoted to characteristic zero and
are never admitted as global polynomial coefficients.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
CANONICAL = HERE / "canonical_bases.json"
TARGETS = {
    31: {"full": 410, "restriction_rank": 212, "literal": 198},
    35: {"full": 637, "restriction_rank": 276, "literal": 361},
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def input_record(relative: str):
    path = ROOT / relative
    return {"path": relative, "sha256": sha256(path)}


def stage(identifier, geometry, map_type, proof, target_orbits, output_dimension):
    return {
        "id": identifier,
        "geometry": geometry,
        "map_type": map_type,
        "global_coefficient_vector_preserved": True,
        "target_orbits": target_orbits,
        "constraint_rank_on_literal_global_basis": 0,
        "output_dimension": output_dimension,
        "matrix_circuit": {
            "schema": "identical-restriction-difference-v1",
            "formula": "rho_(sigma<tau)(p)-rho_(sigma'<tau)(p)",
            "simplified_matrix": "ZERO",
            "coefficientwise_proof": proof,
        },
    }


def main() -> None:
    canonical = json.loads(CANONICAL.read_text())
    assert canonical["schema"] == "cov-m1-canonical-bases-v2"
    dependencies = [
        input_record("certificates/global_transition/diagram.json"),
        input_record("certificates/global_transition/necessity_theorem.json"),
        input_record("certificates/transition_repair/category_repaired.json"),
        input_record("tmp/symbolic_compatibility_complex/triple_line_symbolic/REPORT.md"),
        input_record("tmp/symbolic_compatibility_complex/point_symbolic/character_results.json"),
        input_record("tmp/m1_t1_f3_colon_degree35_audit/certificate.json"),
        input_record("tmp/m1_t1_char0_d35_gate/certificate.json"),
    ]
    summary = {
        "schema": "cov-m1-ordered-global-equalizer-v1",
        "canonical_bases": CANONICAL.name,
        "canonical_bases_sha256": sha256(CANONICAL),
        "coefficient_policy": (
            "One vector c in the fixed literal global K1 basis is used at every "
            "stratum. No local coefficient reset or patchwise lift is permitted."
        ),
        "scope_boundary": (
            "COV2.1 contains the linear incidence/restriction equalizer only. "
            "Landing-specific consequences such as projective constancy on a "
            "C3 eigenline belong to COV2.3 and are recorded separately in "
            "c3_constant_gate.json; they are not asserted to be zero here."
        ),
        "dependencies": dependencies,
        "degrees": {},
    }
    for degree, dimensions in TARGETS.items():
        n = dimensions["literal"]
        stages = [
            {
                "id": "01_all_55_plus_planes_order_one",
                "geometry": "55 involution plus-planes",
                "map_type": "full value restriction",
                "global_coefficient_vector_preserved": True,
                "input_dimension": dimensions["full"],
                "constraint_rank": dimensions["restriction_rank"],
                "output_dimension": n,
                "matrix_circuit": {
                    "schema": "reynolds-plane-restriction-v1",
                    "formula": (
                        "evaluate each fixed full Reynolds circuit on the ternary "
                        "degree-d grid of one plus-plane; G-equivariance propagates "
                        "the zero restriction to all 55 planes"
                    ),
                    "fixed_kernel_basis": f"degree_{degree}/m1_cross_basis_circuits.json",
                    "fixed_kernel_basis_sha256": canonical["degrees"][str(degree)]["m1_basis_sha256"],
                    "rank_certificate_primes": canonical["unused_good_primes"],
                },
            },
            stage(
                "02_V4_triple_line_equalizers",
                "55 A4-stabilized triple lines, three incident plus-planes each",
                "three-branch V4 normal-jet equalizer",
                "Taylor restriction of one ambient polynomial is independent of the incident-plane route.",
                55,
                n,
            ),
            stage(
                "03_residual_multiple_point_kernels",
                "66 D10 points and 55 D12 points",
                "residual quotient after the triple-line image",
                "All branch Taylor series come from the same ambient polynomial, so their class in the residual cokernel is zero.",
                {"D10": 66, "D12": 55},
                n,
            ),
            stage(
                "04_D12_source_minus_line_restrictions",
                "55 residual-stable source minus-lines",
                "source restriction retained as data, not confused with a plane-normal restriction",
                "The repaired transition category keeps source restriction and normal-cone restriction as separate arrows; both are evaluated from the same p.",
                55,
                n,
            ),
            stage(
                "05_C3_lines_C6_endpoints",
                "C3 fixed lines with C6 endpoints",
                "endpoint and line restriction equalizer",
                "Restriction is transitive for the flag endpoint subset line subset source. This zero residual is only the incidence square; the nonzero landing-constant gate is a separate COV2.3 matrix.",
                "complete G-orbits from the transition diagram",
                n,
            ),
            stage(
                "06_A4_D10_D12_point_links",
                "A4, D10, and D12 point-link flags",
                "iterated point-link specialization",
                "Both paths are the same iterated evaluation/Taylor coefficient of p.",
                {"A4_lines": 55, "D10_points": 66, "D12_points": 55},
                n,
            ),
            stage(
                "07_marked_type_I_type_II_elliptic_compatibility",
                "marked elliptic type-I/type-II charge flags",
                "marked restriction and charge compatibility",
                "The forward necessity theorem assigns the globally fixed charge ledger functorially to an actual global p; no independent local charge is introduced.",
                "complete marked orbits from the transition diagram",
                n,
            ),
        ]
        torsion = {
            "literal_global_dimension": n,
            "coefficient_space_used_for_landing": "literal global K1 only",
            "degree_31_exact_note": (
                "At the audited split fibre 67 the compact saturated and literal "
                "spaces both have dimension 198."
            ) if degree == 31 else None,
            "degree_35_special_fibre_ledger": (
                {
                    "F67": {"compact": 362, "literal": 361, "defect": 1},
                    "F89": {"compact": 362, "literal": 361, "defect": 1},
                } if degree == 35 else None
            ),
            "characteristic_zero_compact_defect": (
                "not inferred from the two positive special fibres"
                if degree == 35 else "not needed for the literal global module"
            ),
            "correction_rule": (
                "Discard every compact/sheaf class not in the image of the fixed "
                "literal global Reynolds module. Such a class is not a polynomial "
                "self-covariant and cannot enter F(p)."
            ),
        }
        stages.append({
            "id": "08_finite_irrelevant_torsion_correction",
            "geometry": "irrelevant-support correction",
            "map_type": "intersection with literal global image",
            "global_coefficient_vector_preserved": True,
            "constraint_rank_on_literal_global_basis": 0,
            "output_dimension": n,
            "torsion": torsion,
        })
        payload = {
            "schema": "cov-m1-degree-ordered-equalizer-v1",
            "degree": degree,
            "field": canonical["field"],
            "input_full_dimension": dimensions["full"],
            "literal_global_m1_dimension": n,
            "fixed_basis": canonical["degrees"][str(degree)]["m1_basis"],
            "fixed_basis_sha256": canonical["degrees"][str(degree)]["m1_basis_sha256"],
            "ordered_stages": stages,
            "final_dimension": n,
            "conclusion": (
                "The complete forward incidence equalizer is installed on one "
                "literal global coefficient vector. No named overlap condition "
                "cuts the global image further; nontrivial local compact cokernel "
                "classes are excluded by the literal-image correction."
            ),
        }
        path = HERE / f"degree_{degree}" / "ordered_equalizer.json"
        path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
        summary["degrees"][str(degree)] = {
            "payload": str(path.relative_to(HERE)),
            "payload_sha256": sha256(path),
            "final_dimension": n,
        }
    output = HERE / "ordered_equalizers.json"
    output.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print("COV_M1_ORDERED_EQUALIZERS_PRODUCED")


if __name__ == "__main__":
    main()
