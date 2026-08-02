#!/usr/bin/env python3
"""Build the exact generic normalized Morita-quadrics DAG.

This producer does not expand invariant rational functions.  It instantiates
every coefficient as a deterministic straight-line trace circuit in the
accepted 6 by 6 splitting representation.  The resulting scalars are in
K_proj by the installed descent/Morita construction.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
A7 = ROOT / "goals_2026-08-01" / "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
CROOT = ROOT / "goals_2026-08-01" / "C_PFAFFIAN_FANO_CODEX_ROOT"

SOURCES = {
    "c2_morita": A7 / "c2_morita.json",
    "char0_rur": A7 / "ambient_degree12_rur_char0.json",
    "global_pluecker": A7 / "ambient_degree12_global_exact.json",
    "rur_seed_frame": A7 / "ambient_degree12_a47_chart.json",
    "compressed_algebra": CROOT / "compressed_algebra.json",
    "involution": CROOT / "involution.json",
    "distinguished_five_plane": CROOT / "distinguished_five_plane.json",
    "alignment_core": ROOT / "tmp" / "pfaffian_representation_alignment" / "core.py",
    "alignment_certificate": ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json",
    "hilbert90_frame": ROOT / "tmp" / "generic_twist" / "phi_coefficients.py",
    "projective_reynolds_api": ROOT / "certificates" / "fano_c2" / "produce_c2.py",
    "index_two_certificate": ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "certificate.json",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def vector_label(row: int, corner: int) -> dict[str, int]:
    return {"morita_row": row, "corner_basis": corner}


def ordered_word(form: int, left: dict[str, int], right: dict[str, int]) -> dict:
    """The denominator-minimal ordered scalar C_i(left,right)."""

    return {
        "scalar": -1,
        "denominator": "2*s^3",
        "operation": "matrix_trace_of_ordered_product",
        "factors": [
            "P",
            f"transpose(M[{left['corner_basis']}])",
            "Q",
            "P",
            f"transpose(G[{left['morita_row']}])",
            f"B[{form}]",
            f"G[{right['morita_row']}]",
            "P",
            "Q",
            f"M[{right['corner_basis']}]",
        ],
        "left": left,
        "right": right,
    }


def chart_coefficient(
    form: int,
    monomial: list[int],
    labels: dict[int, dict[str, int]],
    base: dict[str, int],
) -> dict:
    if not monomial:
        ordered = [ordered_word(form, base, base)]
    elif len(monomial) == 1:
        value = labels[monomial[0]]
        ordered = [ordered_word(form, base, value), ordered_word(form, value, base)]
    else:
        left, right = (labels[index] for index in monomial)
        ordered = [ordered_word(form, left, right)]
        if monomial[0] != monomial[1]:
            ordered.append(ordered_word(form, right, left))
    return {"monomial": monomial, "ordered_trace_terms": ordered}


def homogeneous_coefficient(
    form: int,
    monomial: list[int],
    labels: dict[int, dict[str, int]],
) -> dict:
    left, right = (labels[index] for index in monomial)
    ordered = [ordered_word(form, left, right)]
    if monomial[0] != monomial[1]:
        ordered.append(ordered_word(form, right, left))
    return {"monomial": monomial, "ordered_trace_terms": ordered}


def main() -> None:
    c2 = json.loads(SOURCES["c2_morita"].read_text())
    assert c2["format"] == "c2-lazy-exact-morita-v1"
    assert c2["corner"]["basis_circuits"] == [
        {"kind": "projector"},
        {"kind": "sandwich_frame", "frame_index": 1},
        {"kind": "sandwich_frame", "frame_index": 2},
        {"kind": "sandwich_frame", "frame_index": 3},
    ]
    assert c2["morita"]["basis_generator_circuits"] == [
        {"kind": "identity"},
        {"kind": "frame", "frame_index": 1},
        {"kind": "frame", "frame_index": 2},
    ]
    names = c2["distinguished_hermitian_forms"]["names"]
    assert names == ["x", "C", "D", "E", "K"]

    all_variables = list(range(12))
    labels = {index: vector_label(index // 4, index % 4) for index in all_variables}
    homogeneous_monomials = [
        [left, right]
        for left in all_variables
        for right in all_variables
        if left <= right
    ]
    assert len(homogeneous_monomials) == 78
    homogeneous_forms = []
    for form, name in enumerate(names):
        rows = [
            homogeneous_coefficient(form, monomial, labels)
            for monomial in homogeneous_monomials
        ]
        assert len(rows) == 78
        homogeneous_forms.append({"index": form, "name": name, "coefficients": rows})

    normalized_charts = []
    for pivot_row in range(3):
        pivot = 4 * pivot_row
        variables = [index for index in all_variables if index // 4 != pivot_row]
        monomials = [[]]
        monomials.extend([[index] for index in variables])
        monomials.extend(
            [[left, right] for left in variables for right in variables if left <= right]
        )
        assert len(monomials) == 45
        forms = []
        for form, name in enumerate(names):
            rows = [
                chart_coefficient(form, monomial, labels, labels[pivot])
                for monomial in monomials
            ]
            forms.append({"index": form, "name": name, "coefficients": rows})
        normalized_charts.append(
            {
                "pivot_row": pivot_row,
                "normalization": f"q_{pivot_row}=1_D=d_0=e",
                "fixed_homogeneous_coordinates": {
                    f"u{pivot + offset}": 1 if offset == 0 else 0
                    for offset in range(4)
                },
                "variables": [f"u{index}" for index in variables],
                "forms": forms,
            }
        )

    payload = {
        "format": "c5-generic-normalized-morita-dag-v1",
        "field": {
            "mathematical": "K_proj=C(P(W))^PSL_2(F_11)",
            "exact_constant_model": "Q(zeta11,t)/(Phi_11(zeta11),w(t))",
            "constant_note": "the selected root t lies in the algebraically closed constant field C",
        },
        "scope": (
            "all five exact homogeneous Morita quadrics and all three normalized charts "
            "as lazy K_proj trace circuits; "
            "no K_proj common line is asserted"
        ),
        "homogeneous_model": {
            "variables": [f"u{index}" for index in all_variables],
            "variable_semantics": {
                f"u{index}": labels[index] for index in all_variables
            },
            "q_r": "q_r=sum_alpha u_(4*r+alpha)*d_alpha",
            "projectivization": "right-D lines; common right multiplication by D^times",
            "forms": homogeneous_forms,
        },
        "chart": {
            "normalization": "q_0=1_D=d_0=e",
            "variables": [f"u{index}" for index in range(4, 12)],
            "variable_semantics": {
                f"u{index}": labels[index] for index in range(4, 12)
            },
            "q_1": "sum_alpha u_(4+alpha) d_alpha",
            "q_2": "sum_alpha u_(8+alpha) d_alpha",
            "corner_basis": "d_alpha=e*M_alpha*e; M=(1,frame[1],frame[2],frame[3])",
            "morita_basis": "g_r*e; G=(1,frame[1],frame[2])",
        },
        "normalized_charts": normalized_charts,
        "base_circuits": {
            "Q": "the exact aligned alternating matrix Q(x)",
            "P": "the skew matrix of the exact degree-12 RUR bivector p(x,t)",
            "s": "sum_(a<b) Q_ab(x)*p_ab(x,t)",
            "e": "-P*Q/s",
            "B_i": "Q(V_i(x)), V_i in (x,C,D,E,K)",
            "S_i": "Q^-1*B_i",
            "M": ["identity", "projective_frame[1]", "projective_frame[2]", "projective_frame[3]"],
            "G": ["identity", "projective_frame[1]", "projective_frame[2]"],
        },
        "coefficient_identity": {
            "original": (
                "C_i((r,alpha),(s,beta))=(1/2)Tr(star(d_alpha)*"
                "e*star(G_r)*S_i*G_s*e*d_beta)"
            ),
            "reduced": (
                "C_i((r,alpha),(s,beta))=-Tr(P*M_alpha^T*Q*P*G_r^T*"
                "B_i*G_s*P*Q*M_beta)/(2*s^3)"
            ),
            "proof_rule": (
                "use e=-P*Q/s, star(X)=Q^-1*X^T*Q, S_i=Q^-1*B_i, "
                "e^2=e, and cyclicity of ordinary matrix trace"
            ),
            "off_diagonal_rule": "add both ordered terms; retain one ordered term on a square",
        },
        "inventory": {
            "form_count": len(homogeneous_forms),
            "homogeneous_coefficients_per_form": len(homogeneous_monomials),
            "homogeneous_total_coefficients": 390,
            "normalized_chart_count": 3,
            "normalized_coefficients_per_form": 45,
            "normalized_coefficients_per_chart": 225,
            "normalized_total_coefficient_records": 675,
            "constant_coefficients": 5,
            "linear_coefficients": 40,
            "quadratic_coefficients": 180,
            "discarded_algebra_coordinates": 0,
        },
        "denominator_ledger": {
            "explicit_trace_denominator": "2*s^3",
            "frame_denominator": "each nonidentity M or G uses the installed f_(14-d)/f14 normalization",
            "uniform_frame_bound": "f14^4 clears every product of the four possible nonidentity frame factors",
            "constant_denominators": "the rational Q(zeta11)-coefficients sealed in the RUR and Reynolds circuits",
            "required_opens": [
                "2!=0",
                "Pf(Q)!=0",
                "s!=0",
                "f14!=0",
                "the selected 4-column corner minor is nonzero",
                "the selected 12-column Morita-module minor is nonzero",
            ],
            "good_fibre_open_witnesses": {
                "prime": 23,
                "zeta11": 2,
                "source_point": [1, 2, 3, 4, 5],
                "rur_root": 1,
                "pfaffian_Q_mod_23": 17,
                "s_mod_23": 3,
                "f14_mod_23": 17,
                "corner_minor": {
                    "flattening": "row-major 6x6 matrices as columns",
                    "rows": [0, 1, 6, 7],
                    "columns": [0, 1, 2, 3],
                    "determinant_mod_23": 16,
                },
                "morita_module_minor": {
                    "flattening": "row-major 6x6 matrices as columns",
                    "basis_order": "G_r*e*d_alpha, lexicographic (r,alpha)",
                    "rows": [0, 1, 6, 7, 12, 13, 18, 19, 24, 25, 31, 30],
                    "columns": list(range(12)),
                    "determinant_mod_23": 19,
                },
            },
        },
        "split_determinant_boundary": {
            "p23_fact": (
                "after the non-descending identification D_p23=Mat_2(F_23), the eight variables split "
                "into two jointly-linear sets of four and give a 5x5 augmented determinant"
            ),
            "generic_fact": (
                "in the installed old q0-chart corner basis every one of u4,...,u11 has a nonzero square "
                "coefficient already at the good p=23 specialization"
            ),
            "conclusion": (
                "no nonempty jointly-linear subset exists over K_proj in these descended coordinates; "
                "the split 4+4 determinant is not a generic K_proj equation"
            ),
        },
        "hensel_lift_gate": {
            "chart": "q_0=1_D",
            "residue_fibre": {
                "prime": 23,
                "zeta11": 2,
                "source_point": [1, 2, 3, 4, 5],
                "rur_root": 1,
            },
            "sealed_residue_line": [1, 0, 0, 0, 13, 9, 8, 10, 0, 20, 7, 1],
            "solved_coordinates": ["u4", "u5", "u6", "u7", "u8"],
            "solved_residues": [13, 9, 8, 10, 0],
            "fixed_free_coordinates": {"u9": 20, "u10": 7, "u11": 1},
            "jacobian_minor_mod_23": 11,
            "formal_consequence": (
                "the five-equation system has a unique lift in the corresponding completed local "
                "coefficient ring after the three free coordinates are fixed"
            ),
            "exact_global_gate": (
                "form the denominator-saturated zero-dimensional K_proj-algebra of these five "
                "equations; test whether the u8 eliminant has a K_proj-linear factor reducing to u8=0, "
                "then back-substitute and verify that the selected etale factor has residue degree one"
            ),
            "warning": (
                "the simple residue root proves only an etale/formal local section; it does not force "
                "the selected eliminant factor to have degree one over K_proj"
            ),
        },
        "source_sha256": {name: sha256(path) for name, path in SOURCES.items()},
        "theorem_boundary": (
            "This specifies the generic coefficients by an exact trace formula, but the serialized "
            "source leaves still require an exact generic interpreter.  The current finite replay "
            "does not by itself establish an executable K_proj coefficient system or a common line."
        ),
    }
    assert sum(len(form["coefficients"]) for form in homogeneous_forms) == 390
    assert all(
        sum(len(form["coefficients"]) for form in chart["forms"]) == 225
        for chart in normalized_charts
    )
    output = HERE / "morita_generic_dag.json"
    output.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"WROTE {output}")
    print("C5-MORITA-GENERIC-390-COEFFICIENT-DAG")


if __name__ == "__main__":
    main()
