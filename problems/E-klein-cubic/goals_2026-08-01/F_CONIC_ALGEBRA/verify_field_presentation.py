#!/usr/bin/env python3
"""Independent replay for the exact F0 degree-six presentation.

The verifier does not import a producer.  It compares the local matrix with
the sealed sparse consequences term by term, checks exact determinant/content
identities on several symbolic lines, and reconstructs the selected Cramer
embedding in the irreducible `(1,2,3,4)` fibre.
"""

from __future__ import annotations

from collections import defaultdict
from fractions import Fraction
from hashlib import sha256
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PAYLOAD = HERE / "payload"
PRESENTATION = HERE / "field_presentation.json"
UPSTREAM = PROBLEM / "tmp/full_scaled_frame_degree_attack/sparse_bkk_certificate.json"
EXPECTED_COUNTS = [[946, 659, 678], [910, 579, 661], [1098, 680, 417]]


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def read_matrix():
    A, B, Y, Z, u = sp.symbols("A B Y Z u")
    cells = [[0 for _ in range(3)] for _ in range(3)]
    counts = [[0 for _ in range(3)] for _ in range(3)]
    source = PAYLOAD / "determinant_matrix_cells_exact.tsv"
    with source.open() as stream:
        assert next(stream).strip() == "row\tcolumn\tA\tB\tY\tZ\tu\tcoefficient"
        for line in stream:
            row, column, eA, eB, eY, eZ, eu, coefficient = map(int, line.split())
            cells[row][column] += coefficient * A**eA * B**eB * Y**eY * Z**eZ * u**eu
            counts[row][column] += 1
    assert counts == EXPECTED_COUNTS
    return (A, B, Y, Z, u), sp.Matrix(cells)


def read_polynomial(name: str, variables):
    expression = 0
    path = PAYLOAD / name
    with path.open() as stream:
        header = next(stream).split()
        expected = [str(variable) for variable in variables] + ["coefficient"]
        assert header == expected
        count = 0
        for line in stream:
            fields = list(map(int, line.split()))
            exponents, coefficient = fields[:-1], fields[-1]
            monomial = coefficient
            for variable, exponent in zip(variables, exponents):
                monomial *= variable**exponent
            expression += monomial
            count += 1
    return sp.Poly(expression, *variables, domain=sp.ZZ), count


def upstream_matrix_terms():
    payload = json.loads(UPSTREAM.read_text())
    answer = [[defaultdict(Fraction) for _ in range(3)] for _ in range(3)]
    columns = {(0, 0): 0, (0, 1): 1, (1, 0): 2}
    for row, records in enumerate(payload["consequences"]["serialized"]):
        for record in records:
            eA, eB, eY, eZ, et, eu, ev = map(int, record["exponents"])
            column = columns[(et, ev)]
            answer[row][column][eA, eB, eY, eZ, eu] += Fraction(
                int(record["numerator"]), int(record["denominator"])
            )
    return answer


def local_matrix_terms():
    answer = [[defaultdict(Fraction) for _ in range(3)] for _ in range(3)]
    with (PAYLOAD / "determinant_matrix_cells_exact.tsv").open() as stream:
        next(stream)
        for line in stream:
            row, column, eA, eB, eY, eZ, eu, coefficient = map(int, line.split())
            answer[row][column][eA, eB, eY, eZ, eu] += Fraction(coefficient)
    return answer


def main() -> None:
    presentation = json.loads(PRESENTATION.read_text())
    assert presentation["format"] == "goal-F-exact-field-presentation-v1"
    for name, expected in presentation["payload_sha256"].items():
        assert digest(PAYLOAD / name) == expected

    # The local matrix is literally the accepted sparse consequence matrix,
    # not a later interpolation or a reordered set of columns.
    assert local_matrix_terms() == upstream_matrix_terms()

    (A, B, Y, Z, u), matrix = read_matrix()
    content, content_count = read_polynomial(
        "global_parameter_content_exact.tsv", (A, B, Y, Z)
    )
    primitive, primitive_count = read_polynomial(
        "global_primitive_u_sextic_exact.tsv", (A, B, Y, Z, u)
    )
    assert content_count == 2630
    assert primitive_count == 1593
    assert content.total_degree() == 22
    assert primitive.degree(u) == 6

    # Exact bivariate checks retain a free symbol and exercise each parameter
    # in coupled lines.  The source packet separately hash-binds the full
    # characteristic-zero identity; these replays do not merely read it.
    s = sp.symbols("s")
    lines = (
        {A: 1, B: 2, Y: 3, Z: s},
        {A: s, B: 2 + s, Y: 3 - s, Z: 4 + 2 * s},
        {A: 1 + 2 * s, B: 2 - s, Y: 3 + 3 * s, Z: 4 - s},
    )
    for substitution in lines:
        specialized_matrix = matrix.applyfunc(lambda value: sp.expand(value.subs(substitution)))
        determinant = sp.Poly(sp.expand(specialized_matrix.det()), s, u, domain=sp.ZZ)
        right = sp.Poly(
            sp.expand(u * content.as_expr().subs(substitution) * primitive.as_expr().subs(substitution)),
            s,
            u,
            domain=sp.ZZ,
        )
        assert determinant == right

    # Select one residue embedding and reconstruct all field generators.
    point = {A: 1, B: 2, Y: 3, Z: 4}
    M = matrix.applyfunc(lambda value: sp.Poly(value.subs(point), u, domain=sp.QQ))
    P = sp.Poly(primitive.as_expr().subs(point), u, domain=sp.QQ).primitive()[1]
    assert P.degree() == 6
    assert len(sp.factor_list(P.as_expr())[1]) == 1
    a0, b0, c0 = M[0, 0], M[0, 1], M[0, 2]
    a1, b1, c1 = M[1, 0], M[1, 1], M[1, 2]
    delta = b0 * c1 - b1 * c0
    assert sp.gcd(delta, P).degree() == 0
    delta_inverse = sp.invert(delta, P)
    v_value = sp.rem((-a0 * c1 + a1 * c0) * delta_inverse, P)
    t_value = sp.rem((-b0 * a1 + b1 * a0) * delta_inverse, P)
    for row in range(3):
        residual = sp.rem(M[row, 0] + M[row, 1] * v_value + M[row, 2] * t_value, P)
        assert residual.is_zero

    print("LOCAL_MATRIX_EQUALS_ACCEPTED_SPARSE_CONSEQUENCES")
    print("DET_EQUALS_U_CONTENT_PRIMITIVE_ON_EXACT_SYMBOLIC_LINES")
    print("PRIMITIVE_SEXTIC_DEGREE6_AND_SELECTED_EMBEDDING_ACCEPT")
    print("GOAL_F_FIELD_PRESENTATION_ACCEPT")


if __name__ == "__main__":
    main()
