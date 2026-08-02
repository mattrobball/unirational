#!/usr/bin/env python3
"""Build the exact M3 fibration model and two good-fibre smoothness checks.

The characteristic-zero equation is kept in the exact straight-line Reynolds
form installed by the projective Schur-frame packet.  Finite-field equations
are used only to certify open conditions (frame invertibility and smoothness
of the generic cubic-surface fibre), never as section-existence evidence.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import runpy
import subprocess
from collections import defaultdict
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
FRAME_DIR = (
    PROBLEM
    / "goals_2026-08-01"
    / "Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D"
)
FRAME_JSON = FRAME_DIR / "exact_frame.json"
FRAME_CORE = FRAME_DIR / "exact_representation_core.py"
M2_DIR = PROBLEM / "goal_runs_after_35fa" / "M_SARKISOV"
M2_LINK = M2_DIR / "links" / "schur_plane_012_dp3" / "link_payload.json"
OUT = HERE / "fibration_model.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def determinant_mod(matrix: list[list[int]], prime: int) -> int:
    data = [[entry % prime for entry in row] for row in matrix]
    determinant = 1
    for column in range(len(data)):
        pivot = next(
            (row for row in range(column, len(data)) if data[row][column]),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            data[column], data[pivot] = data[pivot], data[column]
            determinant = -determinant
        value = data[column][column]
        determinant = determinant * value % prime
        inverse = pow(value, -1, prime)
        data[column] = [(entry * inverse) % prime for entry in data[column]]
        for row in range(column + 1, len(data)):
            factor = data[row][column]
            if factor:
                data[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(data[row], data[column])
                ]
    return determinant % prime


def pullback_coefficients(
    frame: list[list[int]], prime: int
) -> dict[tuple[int, ...], int]:
    """Coefficients of F(Qa)=sum_i (Qa)_i^2 (Qa)_(i+1)."""
    answer: dict[tuple[int, ...], int] = defaultdict(int)
    for row in range(5):
        for first in range(5):
            for second in range(5):
                for third in range(5):
                    exponent = [0] * 5
                    for column in (first, second, third):
                        exponent[column] += 1
                    coefficient = (
                        frame[row][first]
                        * frame[row][second]
                        * frame[(row + 1) % 5][third]
                    )
                    key = tuple(exponent)
                    answer[key] = (answer[key] + coefficient) % prime
    return {key: value for key, value in answer.items() if value % prime}


def fibre_coefficients(
    cubic: dict[tuple[int, ...], int], prime: int
) -> dict[tuple[int, ...], int]:
    """Substitute (a3,a4)=(q*u,u); variables are (a0,a1,a2,u,q)."""
    answer: dict[tuple[int, ...], int] = defaultdict(int)
    for exponent, coefficient in cubic.items():
        target = (
            exponent[0],
            exponent[1],
            exponent[2],
            exponent[3] + exponent[4],
            exponent[3],
        )
        answer[target] = (answer[target] + coefficient) % prime
    return {key: value for key, value in answer.items() if value % prime}


def polynomial_text(
    terms: dict[tuple[int, ...], int], variables: tuple[str, ...], prime: int
) -> str:
    pieces = []
    for exponent, coefficient in sorted(terms.items(), reverse=True):
        factors = []
        coefficient %= prime
        if coefficient != 1 or not any(exponent):
            factors.append(str(coefficient))
        for variable, power in zip(variables, exponent):
            if power == 1:
                factors.append(variable)
            elif power:
                factors.append(f"{variable}^{power}")
        pieces.append("*".join(factors) if factors else "1")
    return "+".join(pieces) if pieces else "0"


def singular_generic_smoothness(
    fibre: dict[tuple[int, ...], int], prime: int
) -> dict:
    variables = ("a0", "a1", "a2", "u", "q")
    polynomial = polynomial_text(fibre, variables, prime)
    chart_lines = []
    for index, chart in enumerate(variables[:4]):
        chart_lines.extend(
            [
                f"ideal I{index}=diff(f,a0),diff(f,a1),diff(f,a2),diff(f,u),{chart}-1;",
                f"ideal G{index}=std(I{index});",
                f'if (reduce(1,G{index})==0) {{ print("CHART_{index}_EMPTY"); }} else {{ print("CHART_{index}_NONEMPTY"); }}',
            ]
        )
    script = "\n".join(
        [
            f"ring r=({prime},q),(a0,a1,a2,u),dp;",
            f"poly f={polynomial};",
            *chart_lines,
            "quit;",
        ]
    )
    completed = subprocess.run(
        ["Singular", "-q"],
        input=script,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        timeout=120,
    )
    markers = [f"CHART_{index}_EMPTY" for index in range(4)]
    assert all(marker in completed.stdout for marker in markers), completed.stdout
    assert "NONEMPTY" not in completed.stdout
    return {
        "coefficient_field": f"F_{prime}(q)",
        "projective_charts": [True] * 4,
        "singular_jacobian_ideal_is_unit_on_every_chart": True,
        "singular_transcript": completed.stdout.strip().splitlines(),
    }


def serialize_terms(terms: dict[tuple[int, ...], int]) -> list[dict]:
    return [
        {"exponents": list(exponent), "coefficient": int(coefficient)}
        for exponent, coefficient in sorted(terms.items(), reverse=True)
    ]


def build() -> dict:
    certificate = json.loads(FRAME_JSON.read_text())
    link = json.loads(M2_LINK.read_text())
    core = runpy.run_path(str(FRAME_CORE))
    field = core["K11"]
    exact_frame = [
        [core["from_coefficients"](entry, field) for entry in row]
        for row in certificate["frame_at_witness"]
    ]
    exact_invariant = core["from_coefficients"](
        certificate["scalar_invariant_at_witness"], field
    )
    exact_determinant = core["from_coefficients"](
        certificate["determinant_at_witness"], field
    )

    reductions = []
    for prime, zeta in ((23, 2), (67, 9)):
        frame = [
            [core["reduce_k11"](entry, zeta, prime) for entry in row]
            for row in exact_frame
        ]
        invariant = core["reduce_k11"](exact_invariant, zeta, prime)
        determinant = core["reduce_k11"](exact_determinant, zeta, prime)
        assert determinant_mod(frame, prime) == determinant != 0
        assert invariant != 0
        cubic = pullback_coefficients(frame, prime)
        fibre = fibre_coefficients(cubic, prime)
        smoothness = singular_generic_smoothness(fibre, prime)
        reductions.append(
            {
                "prime": prime,
                "zeta11": zeta,
                "source_witness": certificate["witness"],
                "frame": frame,
                "frame_determinant": determinant,
                "I8": invariant,
                "cubic_terms": serialize_terms(cubic),
                "generic_fibre_terms_a0_a1_a2_u_q": serialize_terms(fibre),
                "generic_fibre_smoothness": smoothness,
            }
        )

    assert link["field"] == "K_Schur=C(P(V6))^G"
    assert link["map"]["fibre_substitution"] == ["a3=s*u", "a4=t*u"]
    return {
        "schema": "m3-genuine-projective-schur-fibration-v1",
        "base_field": "K=C(P(V6))^PSL2(F11)",
        "characteristic_zero_model": {
            "frame": "R_j=Q_j/I8, j=0,...,4",
            "Q_entry_formula": certificate["frame_entry_formula"]["Q_rj(v)"],
            "I8_formula": "sum_g ((rho6(g)v)_5)^8",
            "coefficient_table_source": (
                "exact_frame.json:cubic_coefficient_table; 35 coefficients, "
                "625 ordered triple products"
            ),
            "Phi_numerator": "sum_i (sum_j Q_ij*a_j)^2*(sum_j Q_(i+1)j*a_j)",
            "Phi_normalized": "Phi_numerator/I8^3",
            "graph": ["Phi_numerator=0", "a3*t-a4*s=0"],
            "generic_fibre_t_nonzero": "Phi_numerator(a0,a1,a2,q*u,u)=0 over K(q)",
            "q_convention": "q=s/t",
        },
        "denominator_ledger": {
            "frame_denominator": "I8",
            "normalized_cubic_denominator": "I8^3",
            "basis_open": "I8*det(Q) != 0",
            "graph_additional_denominators": [],
            "generic_fibre_chart_denominator": "t (only for q=s/t; the other chart is symmetric)",
            "good_reduction_proves_nonzero_over_characteristic_zero": True,
        },
        "generic_fibre": {
            "ambient": "P3_K(q) with coordinates [a0:a1:a2:u]",
            "hyperplane_class": "h=H|S=-K_S",
            "relative_anticanonical": "-K_(Y/P1)=D=H-L; on S this restricts to H|S",
            "smooth": True,
            "smoothness_reason": (
                "two good-fibre Jacobian-unit witnesses below, and hence an "
                "open characteristic-zero generic-smoothness certificate"
            ),
            "zero_cycles": [
                {
                    "degree": 3,
                    "construction": "u=0 gives the plane cubic C_012; intersect it with a K-line",
                },
                {
                    "degree": 55,
                    "construction": "connected D12 orbit of involution minus-lines, each horizontal of degree one",
                },
            ],
            "index": 1,
        },
        "section_to_twist_evaluation": {
            "section_tuple": "[A0(s,t):A1(s,t):A2(s,t):s*q0(s,t):t*q0(s,t)]",
            "identity": "Phi(A0,A1,A2,s*q0,t*q0)=0",
            "basepoint_condition": "A0,A1,A2,q0 have no common zero on P1",
            "extension": "properness of Y over P1 extends a K(q)-point to a section",
            "evaluation": (
                "evaluate at any [s0:t0] where the displayed tuple is nonzero, map to Y, "
                "then apply the blowdown pi to obtain a K-point of the authoritative twist"
            ),
        },
        "good_reductions": reductions,
        "inputs": {
            str(FRAME_JSON.relative_to(PROBLEM)): sha256(FRAME_JSON),
            str(FRAME_CORE.relative_to(PROBLEM)): sha256(FRAME_CORE),
            str(M2_LINK.relative_to(PROBLEM)): sha256(M2_LINK),
            str((M2_DIR / "payload" / "mori_cox.json").relative_to(PROBLEM)): sha256(
                M2_DIR / "payload" / "mori_cox.json"
            ),
        },
        "scope": {
            "split_prime_section_search_is_discovery_only": True,
            "rational_section_produced": False,
            "headline": "OPEN",
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    payload = build()
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUT.write_text(text)
        print(f"WROTE {OUT}")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
