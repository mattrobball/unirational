#!/usr/bin/env python3
"""Independent verifier for ``line_monodromy.json``.

This file does not import the producer.  It rebuilds the finite critical
schemes from ``fibration_model.json`` in Singular and reconstructs the
integral E6 reflection/cocycle calculation from its defining roots.
"""

from __future__ import annotations

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
CERT_PATH = HERE / "line_monodromy.json"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def json_digest(value: object) -> str:
    return digest(json.dumps(value, separators=(",", ":"), sort_keys=True).encode())


def singular(script: str) -> str:
    result = subprocess.run(
        ["Singular", "-q"],
        input=script,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        timeout=600,
    )
    require("?" not in result.stdout, "Singular diagnostic:\n" + result.stdout)
    return result.stdout


def read_marker(output: str, name: str) -> str:
    match = re.search(rf"^{re.escape(name)}=(.*)$", output, re.MULTILINE)
    require(match is not None, f"missing marker {name}:\n{output}")
    return match.group(1).strip()


def cubic_text(terms: list[dict], prime: int) -> str:
    names = ("a0", "a1", "a2", "u", "q")
    answer: list[str] = []
    for term in terms:
        coefficient = int(term["coefficient"]) % prime
        factors = [] if coefficient == 1 else [str(coefficient)]
        for name, exponent in zip(names, term["exponents"]):
            exponent = int(exponent)
            if exponent == 1:
                factors.append(name)
            elif exponent:
                factors.append(f"{name}^{exponent}")
        answer.append("*".join(factors) if factors else "1")
    return "+".join(answer)


def opposite_chart_text(terms: list[dict], prime: int) -> str:
    names = ("a0", "a1", "a2", "u", "r")
    answer: list[str] = []
    for term in terms:
        old = [int(value) for value in term["exponents"]]
        require(old[3] >= old[4], "q exponent is not supplied by u")
        exponents = old[:4] + [old[3] - old[4]]
        coefficient = int(term["coefficient"]) % prime
        factors = [] if coefficient == 1 else [str(coefficient)]
        for name, exponent in zip(names, exponents):
            if exponent == 1:
                factors.append(name)
            elif exponent:
                factors.append(f"{name}^{exponent}")
        answer.append("*".join(factors) if factors else "1")
    return "+".join(answer)


def parse_univariate(text: str, prime: int) -> list[int]:
    found: dict[int, int] = {}
    for term in text.replace(" ", "").replace("-", "+-").split("+"):
        if not term:
            continue
        if "q" not in term:
            coefficient, exponent = int(term), 0
        else:
            left, right = term.split("q", 1)
            left = left.removesuffix("*")
            coefficient = -1 if left == "-" else (1 if left in ("", "+") else int(left))
            right = right.removeprefix("^")
            exponent = int(right) if right else 1
        found[exponent] = (found.get(exponent, 0) + coefficient) % prime
    degree = max(found)
    return [found.get(index, 0) for index in range(degree + 1)]


def independent_factor_degrees(coefficients: list[int], prime: int) -> list[dict]:
    q = sp.symbols("q")
    poly = sp.Poly(
        sum(value * q**index for index, value in enumerate(coefficients)),
        q,
        modulus=prime,
    )
    with warnings.catch_warnings():
        warnings.simplefilter("ignore", SymPyDeprecationWarning)
        _, factors = sp.factor_list(poly, modulus=prime)
    return [
        {"degree": int(factor.degree()), "multiplicity": int(multiplicity)}
        for factor, multiplicity in factors
    ]


def verify_reduction(model_reduction: dict, retained: dict) -> None:
    prime = int(model_reduction["prime"])
    require(retained["prime"] == prime, "prime mismatch")
    terms = model_reduction["generic_fibre_terms_a0_a1_a2_u_q"]
    f = cubic_text(terms, prime)
    finite = retained["finite_base_chart"]

    elimination = singular(
        "\n".join(
            [
                f"ring R={prime},(a0,a1,a2,u,q),lp;",
                f"poly F={f};",
                "ideal Crit=diff(F,a0),diff(F,a1),diff(F,a2),diff(F,u),a0-1;",
                "ideal G=std(Crit); ideal D=eliminate(G,a0*a1*a2*u);",
                'print("LEN="+string(vdim(G)));',
                'print("DSIZE="+string(size(D)));',
                'print("DPOLY="+string(D[1]));',
                'print("DDEG="+string(deg(D[1])));',
                'print("GCDDEG="+string(deg(gcd(D[1],diff(D[1],q)))));',
            ]
        )
    )
    coefficients = parse_univariate(read_marker(elimination, "DPOLY"), prime)
    require(int(read_marker(elimination, "LEN")) == 24, f"p={prime}: length")
    require(int(read_marker(elimination, "DSIZE")) == 1, f"p={prime}: elimination")
    require(int(read_marker(elimination, "DDEG")) == 24, f"p={prime}: degree")
    require(int(read_marker(elimination, "GCDDEG")) == 0, f"p={prime}: squarefree")
    require(coefficients == finite["discriminant_coefficients_ascending_mod_p"], f"p={prime}: coefficients")
    require(json_digest(coefficients) == finite["discriminant_sha256"], f"p={prime}: discriminant hash")
    require(independent_factor_degrees(coefficients, prime) == finite["factor_degrees_over_Fp"], f"p={prime}: factors")

    affine = f.replace("a0", "1").replace("a1", "x").replace("a2", "y").replace("u", "z")
    transverse = singular(
        "\n".join(
            [
                f"ring R={prime},(x,y,z,q),dp;",
                f"poly f={affine}; poly fx=diff(f,x); poly fy=diff(f,y); poly fz=diff(f,z); poly fq=diff(f,q);",
                "ideal C=f,fx,fy,fz; ideal CG=std(C);",
                "matrix H[3][3]=diff(fx,x),diff(fx,y),diff(fx,z),"
                "diff(fy,x),diff(fy,y),diff(fy,z),diff(fz,x),diff(fz,y),diff(fz,z);",
                "poly hd=det(H);",
                "matrix J[4][4]=diff(f,x),diff(f,y),diff(f,z),diff(f,q),"
                "diff(fx,x),diff(fx,y),diff(fx,z),diff(fx,q),"
                "diff(fy,x),diff(fy,y),diff(fy,z),diff(fy,q),"
                "diff(fz,x),diff(fz,y),diff(fz,z),diff(fz,q);",
                "poly jd=det(J); ideal IH=C,hd; ideal IQ=C,fq; ideal IJ=C,jd;",
                "ideal GH=std(IH); ideal GQ=std(IQ); ideal GJ=std(IJ);",
                'print("ALEN="+string(vdim(CG)));',
                'print("HOK="+string(reduce(1,GH)==0));',
                'print("QOK="+string(reduce(1,GQ)==0));',
                'print("JOK="+string(reduce(1,GJ)==0));',
            ]
        )
    )
    require(int(read_marker(transverse, "ALEN")) == 24, f"p={prime}: affine length")
    require(read_marker(transverse, "HOK") == "1", f"p={prime}: Hessian")
    require(read_marker(transverse, "QOK") == "1", f"p={prime}: base derivative")
    require(read_marker(transverse, "JOK") == "1", f"p={prime}: critical Jacobian")
    require(finite["distinct_singular_fibres"] == 24, f"p={prime}: retained fibre count")
    require(finite["one_critical_point_per_singular_fibre"] is True, f"p={prime}: one-node flag")
    require(finite["transverse_A1_fibre_count"] == 24, f"p={prime}: A1 count")

    # Verify simultaneously the complement of a0=1 and the projective fibre
    # over q=infinity in the opposite base chart.
    opposite = opposite_chart_text(terms, prime)
    chart_lines = [
        f"ring R={prime},(a0,a1,a2,u,q),dp;",
        f"poly F={f}; ideal P=diff(F,a0),diff(F,a1),diff(F,a2),diff(F,u);",
    ]
    for coordinate in ("a1", "a2", "u"):
        chart_lines.extend(
            [
                f"ideal I_{coordinate}=P,a0,{coordinate}-1; ideal G_{coordinate}=std(I_{coordinate});",
                f'print("AFF_{coordinate}="+string(reduce(1,G_{coordinate})==0));',
            ]
        )
    chart_lines.extend(
        [
            f"ring S={prime},(a0,a1,a2,u,r),dp;",
            f"poly FI={opposite}; poly F0=subst(FI,r,0);",
            "ideal Q=diff(F0,a0),diff(F0,a1),diff(F0,a2),diff(F0,u);",
        ]
    )
    for coordinate in ("a0", "a1", "a2", "u"):
        chart_lines.extend(
            [
                f"ideal J_{coordinate}=Q,{coordinate}-1; ideal H_{coordinate}=std(J_{coordinate});",
                f'print("INF_{coordinate}="+string(reduce(1,H_{coordinate})==0));',
            ]
        )
    charts = singular("\n".join(chart_lines))
    for coordinate in ("a1", "a2", "u"):
        require(read_marker(charts, f"AFF_{coordinate}") == "1", f"p={prime}: finite {coordinate}")
        require(finite["a0_zero_projective_complement_empty"][coordinate] is True, f"p={prime}: retained finite chart")
    for coordinate in ("a0", "a1", "a2", "u"):
        require(read_marker(charts, f"INF_{coordinate}") == "1", f"p={prime}: infinity {coordinate}")
        require(retained["infinite_base_chart"]["projective_gradient_unit_by_chart"][coordinate] is True, f"p={prime}: retained infinity")

    good = retained["good_frame_checks"]
    require(good["I8_mod_p"] == int(model_reduction["I8"]) % prime != 0, f"p={prime}: I8")
    require(good["frame_determinant_mod_p"] == int(model_reduction["frame_determinant"]) % prime != 0, f"p={prime}: determinant")
    print(f"P{prime}_24_TRANSVERSE_A1_FIBRES_OK")


def expected_reflections() -> tuple[list[sp.Matrix], list[sp.Matrix]]:
    form = sp.diag(1, -1, -1, -1, -1, -1, -1)
    roots: list[sp.Matrix] = []
    for index in range(1, 6):
        root = sp.zeros(7, 1)
        root[index], root[index + 1] = 1, -1
        roots.append(root)
    branch = sp.Matrix([1, -1, -1, -1, 0, 0, 0])
    roots.append(branch)
    return roots, [sp.eye(7) + root * (root.T * form) for root in roots]


def tuple_matrix(matrix: sp.Matrix) -> tuple[int, ...]:
    return tuple(int(value) for value in matrix)


def matrix_product(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(
        sum(left[7 * row + middle] * right[7 * middle + column] for middle in range(7))
        for row in range(7)
        for column in range(7)
    )


def matrix_action(matrix: tuple[int, ...], vector: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(
        sum(matrix[7 * row + column] * vector[column] for column in range(7))
        for row in range(7)
    )


def verify_lattice(retained: dict) -> None:
    roots, generators = expected_reflections()
    root_lists = [[int(value) for value in root] for root in roots]
    generator_lists = [
        [[int(generator[row, column]) for column in range(7)] for row in range(7)]
        for generator in generators
    ]
    require(retained["simple_roots"] == root_lists, "simple roots")
    require(retained["simple_reflection_matrices"] == generator_lists, "reflection matrices")

    form = sp.diag(1, -1, -1, -1, -1, -1, -1)
    for root, generator in zip(roots, generators):
        require((root.T * form * root)[0] == -2, "root norm")
        require(generator.T * form * generator == form, "isometry")
        require(generator * generator == sp.eye(7), "reflection involution")

    generator_tuples = [tuple_matrix(generator) for generator in generators]
    identity = tuple_matrix(sp.eye(7))
    seen = {identity}
    queue: deque[tuple[int, ...]] = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generator_tuples:
            product = matrix_product(current, generator)
            if product not in seen:
                seen.add(product)
                queue.append(product)
    enumeration = retained["group_enumeration"]
    require(len(seen) == enumeration["enumerated_group_order"] == 51840, "W(E6) order")
    root_orbit = {matrix_action(matrix, tuple(root_lists[0])) for matrix in seen}
    line_orbit = {matrix_action(matrix, (0, 1, 0, 0, 0, 0, 0)) for matrix in seen}
    require(len(root_orbit) == enumeration["root_orbit_size"] == 72, "root orbit")
    require(len(line_orbit) == enumeration["line_class_orbit_size"] == 27, "line orbit")
    serialized = "\n".join(
        ",".join(str(entry) for entry in matrix) for matrix in sorted(seen)
    ).encode()
    require(digest(serialized) == enumeration["sorted_matrix_set_sha256"], "group hash")

    coboundary = sp.Matrix.vstack(*(generator - sp.eye(7) for generator in generators))
    minus_k = sp.Matrix([3, -1, -1, -1, -1, -1, -1])
    require(coboundary.rank() == 6, "invariant rank")
    require(coboundary * minus_k == sp.zeros(42, 1), "-K invariant")
    require(sp.gcd_list(list(minus_k)) == 1, "-K primitive")

    edges = {(0, 1), (1, 2), (2, 3), (3, 4), (2, 5)}
    words: list[list[int]] = [[index, index] for index in range(6)]
    for left in range(6):
        for right in range(left + 1, 6):
            words.append([left, right] * (3 if (left, right) in edges else 2))
    blocks: list[sp.Matrix] = []
    for word in words:
        block = sp.zeros(7, 42)
        prefix = sp.eye(7)
        for letter in word:
            block[:, 7 * letter : 7 * letter + 7] += prefix
            prefix *= generators[letter]
        require(prefix == sp.eye(7), "Coxeter word")
        blocks.append(block)
    relation = sp.Matrix.vstack(*blocks)
    h1 = retained["H1_full_Weyl_group"]
    require(relation.shape == (147, 42), "relation shape")
    require(relation.rank() == h1["integral_relation_matrix_rank_Q"] == 36, "relation rank")
    require(relation * coboundary == sp.zeros(147, 7), "coboundaries are cocycles")
    relation_list = [[int(value) for value in row] for row in relation.tolist()]
    coboundary_list = [[int(value) for value in row] for row in coboundary.tolist()]
    require(json_digest(relation_list) == h1["integral_relation_matrix_sha256"], "relation hash")
    require(json_digest(coboundary_list) == h1["coboundary_matrix_sha256"], "coboundary hash")
    witness = h1["unimodular_minor"]
    minor = coboundary[witness["target_rows_zero_based"], witness["source_columns_zero_based"]]
    require(int(minor.det()) == witness["determinant"] and abs(int(minor.det())) == 1, "unimodular minor")
    require(h1["Z1_rank"] == h1["coboundary_rank"] == 6, "H1 ranks")
    require("NOT ESTABLISHED" in h1["generic_fibre_applicability"], "conditional scope")
    print("ABSTRACT_W_E6_LATTICE_AND_H1_OK")


def main() -> None:
    model_bytes = MODEL_PATH.read_bytes()
    model = json.loads(model_bytes)
    certificate = json.loads(CERT_PATH.read_text())
    require(certificate["schema"] == "m3-line-monodromy-and-brauer-boundary-v1", "schema")
    require(certificate["input"]["sha256"] == digest(model_bytes), "input hash")
    require("exit_label" not in certificate, "component must not declare an M3 exit")
    require(
        certificate["component_status"]
        == "LEFSCHETZ-AND-CONDITIONAL-WEYL-REDUCTION-CERTIFIED",
        "component status",
    )
    reductions = certificate["good_reduction_lefschetz_certificates"]
    require(len(reductions) == len(model["good_reductions"]) == 2, "reduction count")
    for model_reduction, retained in zip(model["good_reductions"], reductions):
        verify_reduction(model_reduction, retained)
    verify_lattice(certificate["integral_W_E6_lattice"])
    ledger = certificate["obstruction_ledger"]
    require(ledger["actual_geometric_27_line_monodromy"] == "UNRESOLVED", "geometric scope")
    require(ledger["actual_arithmetic_27_line_monodromy"] == "UNRESOLVED", "arithmetic scope")
    require(ledger["actual_algebraic_Brauer_quotient"].startswith("UNRESOLVED"), "Brauer scope")
    require(37 * 3 - 2 * 55 == 1, "Bezout zero cycle")
    print("ACTUAL_27_LINE_MONODROMY_AND_BRAUER_UNRESOLVED_OK")
    print("M3_LINE_MONODROMY_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
