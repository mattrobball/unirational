#!/usr/bin/env python3
"""Build the exact universal 55-point Schur hyperplane family.

The output is an integral cyclotomic presentation together with explicit
nonzero-minor gates proving generic freeness and the Hilbert function on one
dense open.  The good-prime witness is used to prove that named determinant
polynomials are nonzero; it is not promoted by itself to characteristic zero.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
import sys
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
CERTIFICATES = PROBLEM / "certificates"
OUTPUT = HERE / "universal_marked_family.json"
sys.path.insert(0, str(CERTIFICATES))
import exact_weil_check as ew  # noqa: E402


P = 67
ZETA_MOD = 64
H_WITNESS = (1, 1, 1, 2, 7)
F5_TERMS = (
    (1, (3, 0, 2, 0, 0)),
    (-1, (3, 0, 0, 1, 1)),
    (1, (2, 0, 0, 3, 0)),
    (-1, (1, 3, 0, 0, 1)),
    (-1, (1, 1, 3, 0, 0)),
    (3, (1, 1, 1, 1, 1)),
    (1, (0, 3, 0, 2, 0)),
    (1, (0, 2, 0, 0, 3)),
    (-1, (0, 1, 1, 3, 0)),
    (1, (0, 0, 3, 0, 2)),
    (-1, (0, 0, 1, 1, 3)),
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def gmul(a, b):
    return ew.fcanon(ew.fmul(a, b))


def gpow(a, n):
    out = ew.fone
    for _ in range(n):
        out = gmul(out, a)
    return out


def gorder(a):
    out = ew.fone
    for n in range(1, 61):
        out = gmul(out, a)
        if out == ew.fone:
            return n
    raise AssertionError("group order bound")


def zero_matrix():
    return [[ew.C(0) for _ in range(5)] for _ in range(5)]


def matadd(a, b):
    return [[a[i][j] + b[i][j] for j in range(5)] for i in range(5)]


def matscale(c, a):
    return [[ew.C(c) * a[i][j] for j in range(5)] for i in range(5)]


def matvec(a, v):
    return [sum(a[i][j] * v[j] for j in range(5)) for i in range(5)]


def proportional(u, v):
    return all(u[i] * v[j] == u[j] * v[i] for i in range(5) for j in range(i + 1, 5))


def klein_binary_coefficients(u, v):
    out = [ew.C(0) for _ in range(4)]
    for i in range(5):
        j = (i + 1) % 5
        out[0] += u[i] * u[i] * u[j]
        out[1] += u[i] * u[i] * v[j] + 2 * u[i] * v[i] * u[j]
        out[2] += v[i] * v[i] * u[j] + 2 * u[i] * v[i] * v[j]
        out[3] += v[i] * v[i] * v[j]
    return out


def poly_mul(left, right):
    answer = [ew.C(0) for _ in range(len(left) + len(right) - 1)]
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            answer[i + j] += a * b
    return answer


def poly_pow(linear, n):
    answer = [ew.C(1)]
    for _ in range(n):
        answer = poly_mul(answer, linear)
    return answer


def f5_binary_coefficients(u, v):
    answer = [ew.C(0) for _ in range(6)]
    for scalar, exponents in F5_TERMS:
        term = [ew.C(scalar)]
        for i, exponent in enumerate(exponents):
            term = poly_mul(term, poly_pow([u[i], v[i]], exponent))
        for degree, coefficient in enumerate(term):
            answer[degree] += coefficient
    return answer


def construct_line_orbit():
    # Preserve the exact Cayley enumeration from the pinned representation;
    # this fixes the same D12 character projector as the hostile upstream
    # audit.  The serialized cosets themselves are sorted below.
    group = tuple(ew.rho)
    orders = {g: gorder(g) for g in group}
    tau = next(g for g in group if orders[g] == 2)
    stabilizer = {g for g in group if gmul(g, tau) == gmul(tau, g)}
    assert len(stabilizer) == 12
    rotation = next(g for g in stabilizer if orders[g] == 6 and gpow(g, 3) == tau)

    character_values = ((2, 1, -1, -2, -1, 1), (2, -1, -1, 2, -1, -1))
    contained = []
    for values in character_values:
        projector = zero_matrix()
        for j in range(6):
            projector = matadd(projector, matscale(values[j], ew.rho[gpow(rotation, j)]))
        projector = matscale(Fraction(1, 6), projector)
        assert ew.matmul(projector, projector) == projector
        columns = [[projector[i][j] for i in range(5)] for j in range(5)]
        u = next(column for column in columns if any(entry != 0 for entry in column))
        v = next(column for column in columns if any(entry != 0 for entry in column) and not proportional(u, column))
        if all(coefficient == 0 for coefficient in klein_binary_coefficients(u, v)):
            contained.append((u, v))
    assert len(contained) == 1, len(contained)
    base_u, base_v = contained[0]

    unseen = set(group)
    coset_representatives = []
    while unseen:
        representative = min(unseen)
        right_coset = {gmul(representative, h) for h in stabilizer}
        assert len(right_coset) == 12
        coset_representatives.append(representative)
        unseen -= right_coset
    assert len(coset_representatives) == 55
    lines = [(matvec(ew.rho[g], base_u), matvec(ew.rho[g], base_v)) for g in coset_representatives]
    for u, v in lines:
        assert all(coefficient == 0 for coefficient in klein_binary_coefficients(u, v))
        assert all(coefficient == 0 for coefficient in f5_binary_coefficients(u, v))
    return group, stabilizer, coset_representatives, lines


def global_denominator(lines):
    denominator = 1
    for line in lines:
        for vector in line:
            for entry in vector:
                for coefficient in entry.a:
                    denominator = math.lcm(denominator, coefficient.denominator)
    return denominator


def scaled_coefficients(entry, denominator):
    scaled = entry * denominator
    assert all(coefficient.denominator == 1 for coefficient in scaled.a)
    return [coefficient.numerator for coefficient in scaled.a]


def cmod(entry):
    total = 0
    power = 1
    for coefficient in entry.a:
        total = (total + coefficient.numerator * pow(coefficient.denominator, -1, P) * power) % P
        power = power * ZETA_MOD % P
    return total


def rref(matrix):
    a = [[entry % P for entry in row] for row in matrix]
    if not a:
        return [], []
    nrows, ncols = len(a), len(a[0])
    row = 0
    pivots = []
    for column in range(ncols):
        pivot = next((i for i in range(row, nrows) if a[i][column]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        inverse = pow(a[row][column], -1, P)
        a[row] = [inverse * value % P for value in a[row]]
        for i in range(nrows):
            if i != row and a[i][column]:
                scalar = a[i][column]
                a[i] = [(a[i][j] - scalar * a[row][j]) % P for j in range(ncols)]
        pivots.append(column)
        row += 1
        if row == nrows:
            break
    return a, pivots


def rank(matrix):
    return len(rref(matrix)[1])


def determinant(matrix):
    a = [[entry % P for entry in row] for row in matrix]
    n = len(a)
    answer = 1
    for column in range(n):
        pivot = next((i for i in range(column, n) if a[i][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            a[column], a[pivot] = a[pivot], a[column]
            answer = -answer
        value = a[column][column]
        answer = answer * value % P
        inverse = pow(value, -1, P)
        for i in range(column + 1, n):
            scalar = a[i][column] * inverse % P
            for j in range(column, n):
                a[i][j] = (a[i][j] - scalar * a[column][j]) % P
    return answer % P


def projective(vector):
    pivot = next(value % P for value in vector if value % P)
    inverse = pow(pivot, -1, P)
    return tuple(value * inverse % P for value in vector)


def monomials(nvars, degree):
    if nvars == 1:
        return [(degree,)]
    answer = []
    for first in range(degree + 1):
        for tail in monomials(nvars - 1, degree - first):
            answer.append((first,) + tail)
    return answer


def evaluation_matrix(points, degree):
    exponents = monomials(4, degree)
    return [[math.prod(pow(point[i], exponent[i], P) for i in range(4)) % P for exponent in exponents] for point in points]


def mod_poly_add(left, right):
    answer = dict(left)
    for exponent, coefficient in right.items():
        answer[exponent] = (answer.get(exponent, 0) + coefficient) % P
    return {exponent: coefficient for exponent, coefficient in answer.items() if coefficient}


def mod_poly_scale(scalar, polynomial):
    return {exponent: scalar * coefficient % P for exponent, coefficient in polynomial.items() if scalar * coefficient % P}


def mod_poly_mul(left, right):
    answer = {}
    for left_exp, left_coefficient in left.items():
        for right_exp, right_coefficient in right.items():
            exponent = tuple(a + b for a, b in zip(left_exp, right_exp))
            answer[exponent] = (answer.get(exponent, 0) + left_coefficient * right_coefficient) % P
    return {exponent: coefficient for exponent, coefficient in answer.items() if coefficient}


def mod_poly_pow(polynomial, exponent):
    answer = {(0, 0, 0, 0): 1}
    for _ in range(exponent):
        answer = mod_poly_mul(answer, polynomial)
    return answer


def restricted_f3_f5():
    variables = [{tuple(1 if i == j else 0 for i in range(4)): 1} for j in range(4)]
    x4 = {}
    inverse7 = pow(7, -1, P)
    for coefficient, variable in zip((-1, -1, -1, -2), variables):
        x4 = mod_poly_add(x4, mod_poly_scale(coefficient * inverse7, variable))
    forms = variables + [x4]
    f3 = {}
    for i in range(5):
        f3 = mod_poly_add(f3, mod_poly_mul(mod_poly_pow(forms[i], 2), forms[(i + 1) % 5]))
    f5 = {}
    for scalar, exponents in F5_TERMS:
        term = {(0, 0, 0, 0): scalar % P}
        for form, exponent in zip(forms, exponents):
            term = mod_poly_mul(term, mod_poly_pow(form, exponent))
        f5 = mod_poly_add(f5, term)
    return f3, f5


def nonzero_minor(matrix):
    transposed = [list(column) for column in zip(*matrix)]
    _, independent_rows = rref(transposed)
    selected_rows = independent_rows
    row_matrix = [matrix[i] for i in selected_rows]
    _, selected_columns = rref(row_matrix)
    square = [[matrix[i][j] for j in selected_columns] for i in selected_rows]
    value = determinant(square)
    assert value
    return selected_rows, selected_columns, value


def point_coefficients(u, v):
    return [[[v[j] * u[k] - u[j] * v[k] for j in range(5)] for k in range(5)]]


def build():
    group, stabilizer, representatives, exact_lines = construct_line_orbit()
    denominator = global_denominator(exact_lines)
    assert denominator % P

    serialized_lines = []
    universal_points = []
    mod_lines = []
    for representative, (u, v) in zip(representatives, exact_lines):
        u_int = [entry * denominator for entry in u]
        v_int = [entry * denominator for entry in v]
        serialized_lines.append({
            "coset_representative": list(representative),
            "u": [scaled_coefficients(entry, 1) for entry in u_int],
            "v": [scaled_coefficients(entry, 1) for entry in v_int],
        })
        point_tensor = []
        for coordinate in range(5):
            point_tensor.append([
                scaled_coefficients(v_int[j] * u_int[coordinate] - u_int[j] * v_int[coordinate], 1)
                for j in range(5)
            ])
        universal_points.append(point_tensor)
        mod_lines.append(([cmod(entry) for entry in u_int], [cmod(entry) for entry in v_int]))

    witness_points = []
    line_chart_gates = []
    for u, v in mod_lines:
        a = sum(H_WITNESS[i] * u[i] for i in range(5)) % P
        b = sum(H_WITNESS[i] * v[i] for i in range(5)) % P
        assert (a, b) != (0, 0)
        choice = "u" if a else "v"
        line_chart_gates.append({"dot": choice, "value_mod_67": a if a else b})
        witness_points.append([(b * u[i] - a * v[i]) % P for i in range(5)])

    assert len({projective(point) for point in witness_points}) == 55
    pair_gates = []
    for i in range(55):
        for j in range(i + 1, 55):
            found = None
            for left in range(5):
                for right in range(left + 1, 5):
                    value = (witness_points[i][left] * witness_points[j][right] - witness_points[i][right] * witness_points[j][left]) % P
                    if value:
                        found = (left, right, value)
                        break
                if found:
                    break
            assert found is not None
            pair_gates.append({"i": i, "j": j, "coordinates": list(found[:2]), "value_mod_67": found[2]})

    p3_points = [point[:4] for point in witness_points]
    hilbert_function = []
    evaluation_minors = {}
    for degree in range(7):
        matrix = evaluation_matrix(p3_points, degree)
        current_rank = rank(matrix)
        hilbert_function.append(current_rank)
        rows, columns, value = nonzero_minor(matrix)
        exponent_list = monomials(4, degree)
        evaluation_minors[str(degree)] = {
            "rank": current_rank,
            "point_rows": rows,
            "monomial_columns": [list(exponent_list[column]) for column in columns],
            "determinant_mod_67": value,
        }
    assert hilbert_function == [1, 4, 10, 19, 31, 45, 55]

    propagation_form = None
    for coefficients in itertools.product(range(1, 8), repeat=4):
        values = [sum(coefficients[i] * point[i] for i in range(4)) % P for point in p3_points]
        if all(values):
            propagation_form = {"coefficients": list(coefficients), "values_mod_67": values}
            break
    assert propagation_form is not None

    # Name one exact nonzero coefficient minor for the eleven universal
    # quintic kernel forms f3*S2 plus f5.  Its nonzero witness value makes the
    # independence condition a genuine dense-open factor.
    restricted_f3, restricted_f5 = restricted_f3_f5()
    quintic_exponents = monomials(4, 5)
    kernel_rows = []
    for exponent in monomials(4, 2):
        monomial = {exponent: 1}
        product = mod_poly_mul(restricted_f3, monomial)
        kernel_rows.append([product.get(target, 0) for target in quintic_exponents])
    kernel_rows.append([restricted_f5.get(target, 0) for target in quintic_exponents])
    assert rank(kernel_rows) == 11
    _, kernel_columns = rref(kernel_rows)
    kernel_square = [[row[column] for column in kernel_columns] for row in kernel_rows]
    kernel_determinant = determinant(kernel_square)
    assert kernel_determinant
    kernel_independence = {
        "forms": "f3 times the ten degree-two monomials, followed by f5",
        "coefficient_monomials": [list(quintic_exponents[column]) for column in kernel_columns],
        "determinant_mod_67": kernel_determinant,
        "rank": 11,
    }

    # Exact G action on the 55 right cosets, serialized for descent replay.
    rep_index = {}
    for index, representative in enumerate(representatives):
        for h in stabilizer:
            rep_index[gmul(representative, h)] = index
    permutations = {}
    for name, generator in (("S", ew.fs), ("T", ew.ft)):
        permutation = [rep_index[gmul(generator, representative)] for representative in representatives]
        assert sorted(permutation) == list(range(55))
        permutations[name] = permutation

    return {
        "schema": "s19-universal-marked-family-v1",
        "repository_commit_consumed": "37d61c19a108781cf74af837e24810a9f7f7c3be",
        "pinned_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "source_sha256": {
            "certificates/exact_weil_check.py": sha256(CERTIFICATES / "exact_weil_check.py"),
            "goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md": sha256(PROBLEM / "goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md"),
        },
        "base_ring": {
            "presentation": "Z[z,h0,h1,h2,h3,h4,Delta^-1]/(1+z+...+z^10)",
            "cyclotomic_basis": [f"z^{i}" for i in range(10)],
            "global_line_denominator_cleared": denominator,
            "hyperplane_parameters": [f"h{i}" for i in range(5)],
        },
        "group": {
            "name": "PSL(2,11)",
            "order": len(group),
            "D12_order": len(stabilizer),
            "right_coset_count": len(representatives),
            "generator_permutations": permutations,
        },
        "descent_equivariance": {
            "hyperplane_action": "for a column action x->rho(g)x, the dual hyperplane is h->rho(g)^(-T)h",
            "section_action": "rho(g)*p_i(h) equals p_{g.i}(rho(g)^(-T)h) projectively",
            "verification": "the exact S,T line-span checks plus uniqueness of a line-hyperplane intersection prove the displayed identity; the serialized permutations give the full descended orbit",
        },
        "lines": serialized_lines,
        "universal_points": {
            "formula": "p_i(h)=(h.v_i)u_i-(h.u_i)v_i",
            "coefficient_tensor_shape": [55, 5, 5, 10],
            "coefficient_tensor": universal_points,
        },
        "universal_ideal": {
            "ambient": "Proj of the hyperplane h0*X0+...+h4*X4=0",
            "ambient_point_ideal_i": "the hyperplane equation and ten 2x2 minors p_i,a(h)*X_b-p_i,b(h)*X_a for 0<=a<b<=4",
            "P3_chart_point_ideal_i": "after h4 is inverted and X4 is eliminated, the six 2x2 minors with 0<=a<b<=3",
            "marked_union_ideal": "intersection of the 55 point ideals after localization at Delta",
            "flatness": "the pair-separation gates make the union 55 disjoint sections, hence finite etale/free of rank 55",
        },
        "good_open": {
            "definition": "Delta is the product of the named nonzero line-chart, pair-separation, P3-chart, evaluation-minor, kernel-independence, and propagation factors",
            "good_prime": P,
            "zeta_mod_prime": ZETA_MOD,
            "hyperplane_witness": list(H_WITNESS),
            "P3_chart_factor": {"factor": "h4", "value_mod_67": H_WITNESS[4]},
            "line_chart_factors": line_chart_gates,
            "pair_separation_factors": pair_gates,
            "evaluation_minor_factors": evaluation_minors,
            "kernel_independence_factor_degree5": kernel_independence,
            "propagation_linear_form": propagation_form,
        },
        "generic_freeness": {
            "hilbert_function_d0_to_d6": hilbert_function,
            "hilbert_function_d_ge_6": 55,
            "upper_rank_reasons": {
                "0_to_2": "ambient dimensions 1,4,10",
                "3": "the nonzero restricted Klein cubic is in the kernel",
                "4": "its four independent linear multiples are in the kernel",
                "5": "f3*S2 plus f5 gives eleven independent kernel forms on the named open",
                "6": "rank 55 is the length bound",
            },
            "proof": "named nonzero minors give lower ranks; universal kernels give matching upper ranks; constant-rank localization makes the degree pieces locally free; a linear form nonzero on all sections propagates surjectivity from degree 6",
        },
        "terminal_marker": "S19_CANONICAL_MARKED_55_FAMILY_EXACT",
        "strict_nonclaims": [
            "no degree-19 curve or marked Hilbert component is constructed",
            "neither non-ACM Rao branch is excluded",
            "the modular witness is used only to prove determinant polynomials nonzero",
            "the Klein-cubic headline remains open",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = build()
    encoded = json.dumps(payload, indent=2) + "\n"
    if args.write:
        OUTPUT.write_text(encoded)
        print("S19_UNIVERSAL_MARKED_FAMILY_WRITTEN")
    elif args.check:
        if OUTPUT.read_text() != encoded:
            raise SystemExit("universal marked family payload mismatch")
        print("S19_UNIVERSAL_MARKED_FAMILY_PRODUCER_CHECK_OK")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
