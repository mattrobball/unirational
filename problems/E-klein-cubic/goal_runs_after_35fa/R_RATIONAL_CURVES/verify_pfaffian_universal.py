#!/opt/homebrew/bin/python3
"""Independent verifier for pfaffian_quintic_universal.json.

This script does not import the producer or the representation-alignment
core.  It reconstructs the cyclotomic matrix identities from the payload,
then asks Singular and Macaulay2 to recompute the good-reduction Hilbert,
smoothness, primeness, containment, and tangent-space checks.
"""

from __future__ import annotations

import json
from pathlib import Path
import subprocess
import tempfile

from sympy.polys.domains import QQ


HERE = Path(__file__).resolve().parent
K11 = QQ.cyclotomic_field(11)
ZERO = K11.zero
ONE = K11.one
PAIR_INDEX = tuple((i, j) for i in range(6) for j in range(i + 1, 6))


def field_element(data):
    result = ZERO
    power = ONE
    for numerator, denominator in data:
        result += K11(numerator) / K11(denominator) * power
        power *= K11.unit
    return result


def deserialize_poly(data):
    return {
        tuple(term["exponents"]): field_element(term["coefficient_qzeta11"])
        for term in data
    }


def poly_add(left, right):
    result = dict(left)
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, ZERO) + coefficient
        if result[monomial] == ZERO:
            del result[monomial]
    return result


def poly_neg(poly):
    return {monomial: -coefficient for monomial, coefficient in poly.items()}


def poly_mul(left, right):
    result = {}
    for monomial_left, coefficient_left in left.items():
        for monomial_right, coefficient_right in right.items():
            monomial = tuple(a + b for a, b in zip(monomial_left, monomial_right))
            result[monomial] = result.get(monomial, ZERO) + coefficient_left * coefficient_right
            if result[monomial] == ZERO:
                del result[monomial]
    return result


def sum_polys(polys):
    result = {}
    for poly in polys:
        result = poly_add(result, poly)
    return result


def pfaffian(matrix, indices):
    if not indices:
        return {(0, 0, 0, 0, 0): ONE}
    first = indices[0]
    result = {}
    for position in range(1, len(indices)):
        second = indices[position]
        remaining = indices[1:position] + indices[position + 1 :]
        term = poly_mul(matrix[first][second], pfaffian(matrix, remaining))
        result = poly_add(result, term if position % 2 else poly_neg(term))
    return result


def matrix_product(left, right):
    return [
        [sum_polys(poly_mul(left[i][k], right[k][j]) for k in range(6)) for j in range(6)]
        for i in range(6)
    ]


def exact_checks(payload):
    matrix = [[{} for _ in range(6)] for _ in range(6)]
    adjugate = [[{} for _ in range(6)] for _ in range(6)]
    matrix_entries = {tuple(entry["pair"]): entry for entry in payload["pfaffian_matrix_upper"]}
    adjugate_entries = {tuple(entry["pair"]): entry for entry in payload["pfaffian_adjugate_upper"]}
    for left, right in PAIR_INDEX:
        key = (left + 1, right + 1)
        matrix[left][right] = deserialize_poly(matrix_entries[key]["linear_form"])
        matrix[right][left] = poly_neg(matrix[left][right])
        adjugate[left][right] = deserialize_poly(adjugate_entries[key]["quadratic_form"])
        adjugate[right][left] = poly_neg(adjugate[left][right])

    pf = pfaffian(matrix, tuple(range(6)))
    scalar = field_element(payload["pfaffian_scalar_qzeta11"])
    expected_pf = {}
    for index in range(5):
        exponents = [0] * 5
        exponents[index] = 2
        exponents[(index + 1) % 5] = 1
        expected_pf[tuple(exponents)] = scalar
    assert pf == expected_pf

    product = matrix_product(matrix, adjugate)
    for row in range(6):
        for column in range(6):
            assert product[row][column] == (pf if row == column else {})

    equations = [deserialize_poly(eq) for eq in payload["equations_bihomogeneous_x2_lambda1"]]
    for row in range(6):
        expected = {}
        for column in range(6):
            for x_monomial, coefficient in adjugate[row][column].items():
                monomial = list(x_monomial) + [0] * 6
                monomial[5 + column] = 1
                expected[tuple(monomial)] = expected.get(tuple(monomial), ZERO) + coefficient
        expected = {m: c for m, c in expected.items() if c != ZERO}
        assert equations[row] == expected
    print("INDEPENDENT_EXACT_PFAFFIAN_AND_ADJUGATE_IDENTITIES_OK")


def format_mod23_poly(data):
    names = ["x1", "x2", "x3", "x4", "x5"]
    pieces = []
    for term in data:
        factors = []
        for name, exponent in zip(names, term["exponents"]):
            if exponent:
                factors.append(name if exponent == 1 else f"{name}^{exponent}")
        pieces.append(f'{term["coefficient"]}*' + "*".join(factors))
    return "+".join(pieces) or "0"


def run_script(executable, suffix, script):
    with tempfile.NamedTemporaryFile("w", suffix=suffix, delete=False) as handle:
        handle.write(script)
        path = Path(handle.name)
    try:
        completed = subprocess.run(
            [executable, "-q", str(path)] if suffix == ".sing" else [executable, "--script", str(path)],
            text=True,
            capture_output=True,
            check=True,
        )
        return completed.stdout + completed.stderr
    finally:
        path.unlink(missing_ok=True)


def geometric_sample_checks(payload):
    equations = [format_mod23_poly(eq) for eq in payload["sample_mod_23"]["equations"]]
    equations = [equation for equation in equations if equation != "0"]
    assert len(equations) == 5
    klein = "x1^2*x2+x2^2*x3+x3^2*x4+x4^2*x5+x5^2*x1"

    singular = "ring r=23,(x1,x2,x3,x4,x5),dp;\n"
    singular += "ideal I=" + ",\n".join(equations) + ";\n"
    singular += "ideal G=std(I);\n"
    singular += '"R2_DIM"; dim(G); "R2_DEGREE"; degree(G); "R2_HILBERT"; hilb(G,1);\n'
    singular += f'poly F={klein}; "R2_CONTAINMENT"; reduce(F,G);\n'
    singular += 'ideal S=I+minor(jacob(I),3); "R2_SINGULAR_AFFINE_DIM"; dim(std(S));\n'
    singular += 'LIB "primdec.lib"; list L=minAssGTZ(I); "R2_MINASS"; size(L); quit;\n'
    singular_output = run_script("/opt/homebrew/bin/Singular", ".sing", singular)
    assert "R2_DIM\n2" in singular_output
    assert "// degree (proj.)   = 5" in singular_output
    assert "R2_HILBERT\n1,0,-5,5,0,-1,0" in singular_output
    assert "R2_CONTAINMENT\n0" in singular_output
    assert "R2_SINGULAR_AFFINE_DIM\n0" in singular_output
    assert "R2_MINASS\n1" in singular_output

    macaulay = "R=GF(23)[x1,x2,x3,x4,x5];\n"
    macaulay += "I=ideal(" + ",\n".join(equations) + ");\n"
    macaulay += f"F={klein}; S=R/(F); IS=sub(I,S); Qmod=coker gens IS; T=Hom(IS,Qmod);\n"
    macaulay += 'print("R2_TANGENT_ON_CUBIC " | toString hilbertFunction(0,T));\n'
    macaulay += "exit 0\n"
    macaulay_output = run_script("/opt/homebrew/bin/M2", ".m2", macaulay)
    assert "R2_TANGENT_ON_CUBIC 10" in macaulay_output

    expected = payload["sample_mod_23"]["expected"]
    assert expected == {
        "degree": 5,
        "hilbert_numerator": [1, 0, -5, 5, 0, -1, 0],
        "minimal_associated_primes": 1,
        "normal_h1": 0,
        "projective_dimension": 1,
        "singular_affine_cone_dimension": 0,
        "tangent_dimension_on_cubic": 10,
    }
    # For an lci curve on a threefold, chi(N)=(-K_X).C=2*5=10.
    # The verified h0(N)=10 therefore gives h1(N)=0.
    print("INDEPENDENT_GOOD_REDUCTION_HILBERT_SMOOTH_PRIME_OK")
    print("INDEPENDENT_TANGENT_10_OBSTRUCTION_H1_0_OK")


def main():
    payload = json.loads((HERE / "pfaffian_quintic_universal.json").read_text(encoding="utf-8"))
    assert payload["schema"] == "klein-pfaffian-elliptic-quintic-universal-v1"
    assert payload["terminal_marker"] == "R2_PFAFFIAN_UNIVERSAL_EQUATIONS_CERTIFIED"
    exact_checks(payload)
    geometric_sample_checks(payload)
    print("R2_PFAFFIAN_UNIVERSAL_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
