#!/usr/bin/env python3
"""Produce the exact M3.3 Lefschetz and conditional Weyl-lattice certificate.

The finite-field part starts only from ``fibration_model.json``.  At each of
the two installed good reductions it computes the projective critical scheme
of the cubic-surface pencil, checks that its 24 points are reduced transverse
A1 points, and checks the missing projective charts and the fibre at infinity.

The integral part constructs the standard Picard lattice of a cubic surface
and the reflection representation of W(E6).  It proves, *conditionally on the
actual line monodromy being the full W(E6)*, that the invariant lattice is
Z(-K) and H^1(W(E6), Pic)=0.  The producer deliberately does not identify the
actual 27-line monodromy: 24 transverse nodes alone do not supply labelled
line permutations.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import warnings
from collections import deque
from pathlib import Path

import sympy as sp
from sympy.utilities.exceptions import SymPyDeprecationWarning


HERE = Path(__file__).resolve().parent
MODEL_PATH = HERE / "fibration_model.json"
OUTPUT_PATH = HERE / "line_monodromy.json"


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_hash(value: object) -> str:
    data = json.dumps(value, separators=(",", ":"), sort_keys=True).encode()
    return sha256_bytes(data)


def polynomial_text(terms: list[dict], prime: int) -> str:
    variables = ("a0", "a1", "a2", "u", "q")
    pieces: list[str] = []
    for term in terms:
        coefficient = int(term["coefficient"]) % prime
        factors = [] if coefficient == 1 else [str(coefficient)]
        for variable, exponent in zip(variables, term["exponents"]):
            exponent = int(exponent)
            if exponent == 1:
                factors.append(variable)
            elif exponent:
                factors.append(f"{variable}^{exponent}")
        pieces.append("*".join(factors) if factors else "1")
    return "+".join(pieces)


def infinity_polynomial_text(terms: list[dict], prime: int) -> str:
    """Return Phi(a0,a1,a2,u,r*u) from Phi(a0,a1,a2,q*u,u).

    If a monomial of the t=1 model is u^m q^k, the s=1 model is
    u^m r^(m-k).  The nonnegativity of m-k is checked explicitly.
    """

    variables = ("a0", "a1", "a2", "u", "r")
    pieces: list[str] = []
    for term in terms:
        original = [int(value) for value in term["exponents"]]
        if original[4] > original[3]:
            raise AssertionError("q exponent exceeds u exponent")
        exponents = original[:4] + [original[3] - original[4]]
        coefficient = int(term["coefficient"]) % prime
        factors = [] if coefficient == 1 else [str(coefficient)]
        for variable, exponent in zip(variables, exponents):
            if exponent == 1:
                factors.append(variable)
            elif exponent:
                factors.append(f"{variable}^{exponent}")
        pieces.append("*".join(factors) if factors else "1")
    return "+".join(pieces)


def run_singular(script: str, timeout: int = 600) -> str:
    completed = subprocess.run(
        ["Singular", "-q"],
        input=script,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=timeout,
        check=True,
    )
    if "?" in completed.stdout or "error" in completed.stdout.lower():
        raise AssertionError("Singular reported an error:\n" + completed.stdout)
    return completed.stdout


def marker(output: str, name: str) -> str:
    match = re.search(rf"^{re.escape(name)}=(.*)$", output, flags=re.MULTILINE)
    if not match:
        raise AssertionError(f"missing Singular marker {name}:\n{output}")
    return match.group(1).strip()


def parse_singular_univariate(text: str, prime: int) -> list[int]:
    """Parse Singular's compact ``q24-3q+1`` string, ascending coefficients."""

    compact = text.replace(" ", "")
    coefficients: dict[int, int] = {}
    for raw in compact.replace("-", "+-").split("+"):
        if not raw:
            continue
        if "q" not in raw:
            coefficient, exponent = int(raw), 0
        else:
            coefficient_text, exponent_text = raw.split("q", maxsplit=1)
            coefficient_text = coefficient_text.removesuffix("*")
            if coefficient_text in ("", "+"):
                coefficient = 1
            elif coefficient_text == "-":
                coefficient = -1
            else:
                coefficient = int(coefficient_text)
            exponent_text = exponent_text.removeprefix("^")
            exponent = int(exponent_text) if exponent_text else 1
        coefficients[exponent] = (coefficients.get(exponent, 0) + coefficient) % prime
    degree = max(coefficients)
    result = [coefficients.get(exponent, 0) for exponent in range(degree + 1)]
    if result[-1] == 0:
        raise AssertionError("parsed leading coefficient is zero")
    return result


def factor_degrees(coefficients: list[int], prime: int) -> list[dict]:
    q = sp.symbols("q")
    polynomial = sp.Poly(
        sum(coefficient * q**exponent for exponent, coefficient in enumerate(coefficients)),
        q,
        modulus=prime,
    )
    with warnings.catch_warnings():
        warnings.simplefilter("ignore", SymPyDeprecationWarning)
        _, factors = sp.factor_list(polynomial, modulus=prime)
    return [
        {"degree": int(factor.degree()), "multiplicity": int(multiplicity)}
        for factor, multiplicity in factors
    ]


def finite_critical_certificate(reduction: dict) -> dict:
    prime = int(reduction["prime"])
    terms = reduction["generic_fibre_terms_a0_a1_a2_u_q"]
    f = polynomial_text(terms, prime)

    elimination_script = "\n".join(
        [
            f"ring r={prime},(a0,a1,a2,u,q),lp;",
            f"poly F={f};",
            "ideal I=diff(F,a0),diff(F,a1),diff(F,a2),diff(F,u),a0-1;",
            "ideal G=std(I);",
            "ideal E=eliminate(G,a0*a1*a2*u);",
            'print("CRITICAL_LENGTH="+string(vdim(G)));',
            'print("ELIMINATION_SIZE="+string(size(E)));',
            'print("DISCRIMINANT="+string(E[1]));',
            'print("DISCRIMINANT_DEGREE="+string(deg(E[1])));',
            'print("DISCRIMINANT_GCD_DEGREE="+string(deg(gcd(E[1],diff(E[1],q)))));',
        ]
    )
    elimination_output = run_singular(elimination_script)
    critical_length = int(marker(elimination_output, "CRITICAL_LENGTH"))
    elimination_size = int(marker(elimination_output, "ELIMINATION_SIZE"))
    discriminant_compact = marker(elimination_output, "DISCRIMINANT")
    discriminant_degree = int(marker(elimination_output, "DISCRIMINANT_DEGREE"))
    gcd_degree = int(marker(elimination_output, "DISCRIMINANT_GCD_DEGREE"))
    coefficients = parse_singular_univariate(discriminant_compact, prime)

    # In the affine chart a0=1 put x=a1, y=a2, z=u.  The four equations
    # f,fx,fy,fz cut out singular members together with their singular point.
    affine_f = (
        f.replace("a0", "1")
        .replace("a1", "x")
        .replace("a2", "y")
        .replace("u", "z")
    )
    transversality_script = "\n".join(
        [
            f"ring r={prime},(x,y,z,q),dp;",
            f"poly f={affine_f};",
            "poly fx=diff(f,x); poly fy=diff(f,y); poly fz=diff(f,z);",
            "poly fq=diff(f,q);",
            "ideal C=f,fx,fy,fz; ideal G=std(C);",
            "matrix H[3][3]=diff(fx,x),diff(fx,y),diff(fx,z),"
            "diff(fy,x),diff(fy,y),diff(fy,z),"
            "diff(fz,x),diff(fz,y),diff(fz,z);",
            "poly hessian_det=det(H);",
            "matrix J[4][4]=diff(f,x),diff(f,y),diff(f,z),diff(f,q),"
            "diff(fx,x),diff(fx,y),diff(fx,z),diff(fx,q),"
            "diff(fy,x),diff(fy,y),diff(fy,z),diff(fy,q),"
            "diff(fz,x),diff(fz,y),diff(fz,z),diff(fz,q);",
            "poly critical_jacobian_det=det(J);",
            "ideal TH=C,hessian_det; ideal TQ=C,fq;"
            "ideal TJ=C,critical_jacobian_det;",
            "ideal BH=std(TH); ideal BQ=std(TQ); ideal BJ=std(TJ);",
            'print("AFFINE_CRITICAL_LENGTH="+string(vdim(G)));',
            'print("HESSIAN_BAD_LOCUS_EMPTY="+string(reduce(1,BH)==0));',
            'print("BASE_DERIVATIVE_BAD_LOCUS_EMPTY="+string(reduce(1,BQ)==0));',
            'print("CRITICAL_JACOBIAN_BAD_LOCUS_EMPTY="+string(reduce(1,BJ)==0));',
        ]
    )
    transverse_output = run_singular(transversality_script)

    # Check the complement a0=0 in the three remaining projective charts.
    completeness_lines = [
        f"ring r={prime},(a0,a1,a2,u,q),dp;",
        f"poly F={f};",
        "ideal J=diff(F,a0),diff(F,a1),diff(F,a2),diff(F,u);",
    ]
    for variable in ("a1", "a2", "u"):
        completeness_lines.extend(
            [
                f"ideal T_{variable}=J,a0,{variable}-1;",
                f"ideal G_{variable}=std(T_{variable});",
                f'print("FINITE_A0_ZERO_{variable}="+'
                f'string(reduce(1,G_{variable})==0));',
            ]
        )
    completeness_output = run_singular("\n".join(completeness_lines))

    return {
        "prime": prime,
        "source_witness": reduction["source_witness"],
        "good_frame_checks": {
            "I8_mod_p": int(reduction["I8"]) % prime,
            "I8_nonzero": int(reduction["I8"]) % prime != 0,
            "frame_determinant_mod_p": int(reduction["frame_determinant"]) % prime,
            "frame_determinant_nonzero": int(reduction["frame_determinant"]) % prime != 0,
        },
        "finite_base_chart": {
            "critical_projective_chart": "a0=1",
            "critical_length": critical_length,
            "affine_critical_length": int(marker(transverse_output, "AFFINE_CRITICAL_LENGTH")),
            "elimination_ideal_size": elimination_size,
            "discriminant_variable": "q=s/t",
            "discriminant_degree": discriminant_degree,
            "discriminant_coefficients_ascending_mod_p": coefficients,
            "discriminant_sha256": canonical_hash(coefficients),
            "discriminant_gcd_derivative_degree": gcd_degree,
            "factor_degrees_over_Fp": factor_degrees(coefficients, prime),
            "distinct_singular_fibres": discriminant_degree if gcd_degree == 0 else None,
            "one_critical_point_per_singular_fibre": (
                critical_length == discriminant_degree and gcd_degree == 0
            ),
            "transverse_A1_fibre_count": (
                critical_length
                if (
                    marker(transverse_output, "HESSIAN_BAD_LOCUS_EMPTY") == "1"
                    and marker(transverse_output, "BASE_DERIVATIVE_BAD_LOCUS_EMPTY") == "1"
                )
                else None
            ),
            "spatial_hessian_nonzero_at_every_critical_point":
                marker(transverse_output, "HESSIAN_BAD_LOCUS_EMPTY") == "1",
            "base_derivative_nonzero_at_every_critical_point":
                marker(transverse_output, "BASE_DERIVATIVE_BAD_LOCUS_EMPTY") == "1",
            "four_by_four_critical_jacobian_nonzero_at_every_point":
                marker(transverse_output, "CRITICAL_JACOBIAN_BAD_LOCUS_EMPTY") == "1",
            "a0_zero_projective_complement_empty": {
                variable: marker(completeness_output, f"FINITE_A0_ZERO_{variable}") == "1"
                for variable in ("a1", "a2", "u")
            },
        },
    }


def infinity_certificate(reduction: dict) -> dict:
    prime = int(reduction["prime"])
    f_infinity_chart = infinity_polynomial_text(
        reduction["generic_fibre_terms_a0_a1_a2_u_q"], prime
    )
    lines = [
        f"ring R={prime},(a0,a1,a2,u,r),dp;",
        f"poly FI={f_infinity_chart};",
        "poly F0=subst(FI,r,0);",
        "ideal J=diff(F0,a0),diff(F0,a1),diff(F0,a2),diff(F0,u);",
    ]
    for variable in ("a0", "a1", "a2", "u"):
        lines.extend(
            [
                f"ideal T_{variable}=J,{variable}-1;",
                f"ideal G_{variable}=std(T_{variable});",
                f'print("INFINITY_{variable}="+string(reduce(1,G_{variable})==0));',
            ]
        )
    output = run_singular("\n".join(lines))
    charts = {
        variable: marker(output, f"INFINITY_{variable}") == "1"
        for variable in ("a0", "a1", "a2", "u")
    }
    return {
        "base_chart": "s=1, r=t/s",
        "coordinate_substitution": "a3=u, a4=r*u",
        "fibre_at_infinity": "r=0",
        "projective_gradient_unit_by_chart": charts,
        "fibre_at_infinity_smooth": all(charts.values()),
    }


def reflection_matrices() -> tuple[list[list[int]], list[sp.Matrix]]:
    intersection = sp.diag(1, -1, -1, -1, -1, -1, -1)
    roots: list[sp.Matrix] = []
    for index in range(1, 6):
        root = sp.zeros(7, 1)
        root[index] = 1
        root[index + 1] = -1
        roots.append(root)
    root = sp.zeros(7, 1)
    root[0] = 1
    root[1] = root[2] = root[3] = -1
    roots.append(root)
    matrices = [sp.eye(7) + root * (root.T * intersection) for root in roots]
    return [[int(value) for value in root] for root in roots], matrices


def matrix_tuple(matrix: sp.Matrix) -> tuple[int, ...]:
    return tuple(int(value) for value in matrix)


def multiply_by_reflection(
    matrix: tuple[int, ...], root: tuple[int, ...], beta: tuple[int, ...]
) -> tuple[int, ...]:
    # Right multiplication by I + root*beta^T.
    result = list(matrix)
    for row in range(7):
        pairing = sum(matrix[7 * row + column] * root[column] for column in range(7))
        for column in range(7):
            result[7 * row + column] += pairing * beta[column]
    return tuple(result)


def enumerate_weyl_group(roots: list[list[int]]) -> dict:
    identity = tuple(1 if row == column else 0 for row in range(7) for column in range(7))
    root_tuples = [tuple(root) for root in roots]
    betas = [
        tuple(root[index] if index == 0 else -root[index] for index in range(7))
        for root in root_tuples
    ]
    seen = {identity}
    queue: deque[tuple[int, ...]] = deque([identity])
    while queue:
        matrix = queue.popleft()
        for root, beta in zip(root_tuples, betas):
            product = multiply_by_reflection(matrix, root, beta)
            if product not in seen:
                seen.add(product)
                queue.append(product)

    def act(matrix: tuple[int, ...], vector: tuple[int, ...]) -> tuple[int, ...]:
        return tuple(
            sum(matrix[7 * row + column] * vector[column] for column in range(7))
            for row in range(7)
        )

    first_root = root_tuples[0]
    first_line = (0, 1, 0, 0, 0, 0, 0)  # e1
    root_orbit = {act(matrix, first_root) for matrix in seen}
    line_orbit = {act(matrix, first_line) for matrix in seen}
    serialized = "\n".join(
        ",".join(str(entry) for entry in matrix) for matrix in sorted(seen)
    ).encode()
    return {
        "enumerated_group_order": len(seen),
        "root_orbit_size": len(root_orbit),
        "line_class_orbit_size": len(line_orbit),
        "sorted_matrix_set_sha256": sha256_bytes(serialized),
    }


def relation_matrix(generators: list[sp.Matrix]) -> tuple[sp.Matrix, list[dict]]:
    adjacency = {(0, 1), (1, 2), (2, 3), (3, 4), (2, 5)}
    relations: list[tuple[str, list[int]]] = []
    for index in range(6):
        relations.append((f"s{index + 1}^2", [index, index]))
    for left in range(6):
        for right in range(left + 1, 6):
            exponent = 3 if (left, right) in adjacency else 2
            relations.append(
                (
                    f"(s{left + 1}s{right + 1})^{exponent}",
                    [left, right] * exponent,
                )
            )

    blocks: list[sp.Matrix] = []
    ledger: list[dict] = []
    for name, word in relations:
        block = sp.zeros(7, 42)
        prefix = sp.eye(7)
        for generator in word:
            block[:, 7 * generator : 7 * generator + 7] += prefix
            prefix = prefix * generators[generator]
        if prefix != sp.eye(7):
            raise AssertionError(f"Coxeter relation failed: {name}")
        blocks.append(block)
        ledger.append({"name": name, "word_zero_based": word})
    return sp.Matrix.vstack(*blocks), ledger


def lattice_certificate() -> dict:
    roots, generators = reflection_matrices()
    identity = sp.eye(7)
    coboundary = sp.Matrix.vstack(*(generator - identity for generator in generators))
    anticanonical = sp.Matrix([3, -1, -1, -1, -1, -1, -1])
    if coboundary * anticanonical != sp.zeros(42, 1):
        raise AssertionError("-K is not fixed")
    if coboundary.rank() != 6:
        raise AssertionError("unexpected invariant rank")

    relations, relation_ledger = relation_matrix(generators)
    relation_rank = relations.rank()
    if relations * coboundary != sp.zeros(relations.rows, coboundary.cols):
        raise AssertionError("coboundaries do not satisfy cocycle relations")

    # Exhibit a primitive rank-six sublattice of the cocycle lattice.  The
    # selected 6x6 minor is unimodular, so im(delta) is saturated in Z^42.
    omitted_column = 1
    columns = [column for column in range(7) if column != omitted_column]
    selected = coboundary[:, columns]
    _, pivot_rows = selected.T.rref()
    rows = list(pivot_rows)
    minor_determinant = int(selected[rows, :].det())
    if abs(minor_determinant) != 1:
        raise AssertionError("failed to find the expected unimodular minor")
    if relation_rank != 36:
        raise AssertionError("unexpected Coxeter cocycle rank")

    generators_json = [
        [[int(generator[row, column]) for column in range(7)] for row in range(7)]
        for generator in generators
    ]
    return {
        "basis": ["h", "e1", "e2", "e3", "e4", "e5", "e6"],
        "intersection_form_diagonal": [1, -1, -1, -1, -1, -1, -1],
        "anticanonical_vector": [int(value) for value in anticanonical],
        "simple_roots": roots,
        "simple_reflection_matrices": generators_json,
        "coxeter_diagram_edges_zero_based": [[0, 1], [1, 2], [2, 3], [3, 4], [2, 5]],
        "integral_invariants": {
            "stacked_generator_minus_identity_shape": list(coboundary.shape),
            "stacked_generator_minus_identity_rank_Q": int(coboundary.rank()),
            "primitive_kernel_generator": [int(value) for value in anticanonical],
            "conclusion": "Pic^W(E6) = Z*(-K)",
        },
        "group_enumeration": enumerate_weyl_group(roots),
        "H1_full_Weyl_group": {
            "status": "proved for the abstract full W(E6) action only",
            "coxeter_relation_count": len(relation_ledger),
            "coxeter_relation_ledger": relation_ledger,
            "cocycle_unknown_count": 42,
            "integral_relation_matrix_shape": list(relations.shape),
            "integral_relation_matrix_rank_Q": int(relation_rank),
            "integral_relation_matrix_sha256": canonical_hash(
                [[int(value) for value in row] for row in relations.tolist()]
            ),
            "Z1_rank": int(42 - relation_rank),
            "coboundary_rank": int(coboundary.rank()),
            "coboundary_matrix_sha256": canonical_hash(
                [[int(value) for value in row] for row in coboundary.tolist()]
            ),
            "unimodular_minor": {
                "omitted_source_column_zero_based": omitted_column,
                "source_columns_zero_based": columns,
                "target_rows_zero_based": rows,
                "determinant": minor_determinant,
            },
            "saturation_argument": (
                "The rank-six coboundary image has a 6x6 minor of determinant +/-1, "
                "so it is saturated in Z^42. The Coxeter relation matrix has kernel "
                "rank six and contains that image; hence Z1=B1 integrally."
            ),
            "conclusion": "H^1(W(E6), Pic(S_bar)) = 0",
            "generic_fibre_applicability": (
                "NOT ESTABLISHED: requires proof that the actual arithmetic line "
                "monodromy is the full W(E6)."
            ),
        },
    }


def build() -> dict:
    model_bytes = MODEL_PATH.read_bytes()
    model = json.loads(model_bytes)
    reductions = []
    for reduction in model["good_reductions"]:
        certificate = finite_critical_certificate(reduction)
        certificate["infinite_base_chart"] = infinity_certificate(reduction)
        finite = certificate["finite_base_chart"]
        if not (
            certificate["good_frame_checks"]["I8_nonzero"]
            and certificate["good_frame_checks"]["frame_determinant_nonzero"]
            and finite["critical_length"] == 24
            and finite["affine_critical_length"] == 24
            and finite["discriminant_degree"] == 24
            and finite["discriminant_gcd_derivative_degree"] == 0
            and finite["spatial_hessian_nonzero_at_every_critical_point"]
            and finite["base_derivative_nonzero_at_every_critical_point"]
            and finite["four_by_four_critical_jacobian_nonzero_at_every_point"]
            and all(finite["a0_zero_projective_complement_empty"].values())
            and certificate["infinite_base_chart"]["fibre_at_infinity_smooth"]
        ):
            raise AssertionError(f"Lefschetz certificate failed at p={certificate['prime']}")
        reductions.append(certificate)

    return {
        "schema": "m3-line-monodromy-and-brauer-boundary-v1",
        "scope": (
            "Exact Lefschetz good-reduction certificate plus an abstract integral "
            "W(E6)-lattice calculation; not a 27-line monodromy certificate."
        ),
        "input": {
            "path": "fibration_model.json",
            "sha256": sha256_bytes(model_bytes),
            "base_field": model["base_field"],
            "generic_fibre": model["characteristic_zero_model"]["generic_fibre_t_nonzero"],
        },
        "good_reduction_lefschetz_certificates": reductions,
        "characteristic_zero_consequence": {
            "status": "certified open-condition consequence",
            "statement": (
                "The exact generic characteristic-zero pencil has geometric "
                "discriminant degree 24 with 24 distinct transverse A1 fibres."
            ),
            "reason": (
                "At two integral good specializations the frame denominators are "
                "units, the discriminant is squarefree of degree 24, the critical "
                "Jacobian is invertible at all 24 points, and the fibre at infinity "
                "is smooth. These are nonvanishing open conditions."
            ),
        },
        "integral_W_E6_lattice": lattice_certificate(),
        "installed_generic_fibre_picard_input": {
            "kind": "installed geometric input, not inferred from node computation",
            "source": [
                "../goal_runs_after_35fa/M_SARKISOV/THEOREM.md:Theorem M2.1",
                "../goal_runs_after_35fa/M_SARKISOV/DIVISOR_COX.md:Picard and intersections",
            ],
            "calculation": (
                "Pic(Y)=Z*H + Z*D and the fibre class is L=H-D. Thus the "
                "relative quotient is generated by H|S=-K_S."
            ),
            "conclusion": "Pic(S) = Z*(-K_S)",
        },
        "obstruction_ledger": {
            "actual_geometric_27_line_monodromy": "UNRESOLVED",
            "actual_arithmetic_27_line_monodromy": "UNRESOLVED",
            "why_nodes_do_not_close_monodromy": (
                "The 24 local Picard-Lefschetz reflections are not labelled as "
                "permutations of the 27 lines, and their generated subgroup has not "
                "been computed. Transverse A1 fibres alone do not prove W(E6)."
            ),
            "external_theorem_boundary": (
                "Universal cubic-surface monodromy is W(E6), but applying that "
                "universal result to this special one-parameter pencil requires a "
                "surjectivity/generality or labelled-transport argument not present "
                "in the installed packet."
            ),
            "external_theorem_inputs_not_promoted_to_computation": [
                {
                    "reference": (
                        "P. Deligne, La formule de Picard-Lefschetz, SGA 7 II, "
                        "Expose XV, Theoreme 3.4, LNM 340 (1973)"
                    ),
                    "scope": (
                        "A transverse ordinary quadratic singularity has local "
                        "Picard-Lefschetz reflection monodromy."
                    ),
                    "used_here": (
                        "Only to interpret each certified A1 critical point as a "
                        "local reflection; it does not identify the generated group."
                    ),
                },
                {
                    "reference": (
                        "J. Harris, Galois groups of enumerative problems, Duke "
                        "Math. J. 46 (1979), 685-724, section III.2, "
                        "doi:10.1215/S0012-7094-79-04635-0"
                    ),
                    "scope": "The universal 27-line cover of smooth cubic surfaces has group W(E6).",
                    "used_here": (
                        "Boundary reference only; no theorem in the certificate "
                        "shows that this special pencil surjects onto universal monodromy."
                    ),
                },
            ],
            "actual_algebraic_Brauer_quotient": (
                "UNRESOLVED: Pic(S)=Z*(-K) determines invariants but does not "
                "determine H^1 of the unknown Galois subgroup."
            ),
            "conditional_full_Weyl_Brauer_quotient": (
                "If the actual action is full W(E6), the lattice certificate gives "
                "H^1(W(E6),Pic)=0 and hence the corresponding algebraic Brauer "
                "quotient vanishes (subject to the standard Hochschild-Serre edge)."
            ),
            "elementary_obstruction": {
                "installed_zero_cycle_degrees": [3, 55],
                "bezout_identity": "37*3 - 2*55 = 1",
                "conclusion": "zero-cycle of degree one; elementary obstruction vanishes",
                "warning": "This is not a rational-point or section theorem.",
            },
        },
        "component_status": "LEFSCHETZ-AND-CONDITIONAL-WEYL-REDUCTION-CERTIFIED",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true", help="write line_monodromy.json")
    parser.add_argument("--check", action="store_true", help="compare with the installed JSON")
    args = parser.parse_args()
    payload = build()
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT_PATH.write_text(rendered)
    if args.check:
        if not OUTPUT_PATH.exists():
            raise SystemExit("line_monodromy.json is missing")
        if OUTPUT_PATH.read_text() != rendered:
            raise SystemExit("line_monodromy.json does not match a fresh exact replay")
    print("PRIMES=" + ",".join(str(item["prime"]) for item in payload["good_reduction_lefschetz_certificates"]))
    print("SINGULAR_FIBRES_PER_PRIME=24")
    print("ACTUAL_27_LINE_MONODROMY=UNRESOLVED")
    print("ABSTRACT_W_E6_ORDER=" + str(payload["integral_W_E6_lattice"]["group_enumeration"]["enumerated_group_order"]))
    print("ABSTRACT_H1_W_E6_PIC=0")
    print("M3_LINE_MONODROMY_REDUCTION_CERTIFICATE_OK")


if __name__ == "__main__":
    main()
