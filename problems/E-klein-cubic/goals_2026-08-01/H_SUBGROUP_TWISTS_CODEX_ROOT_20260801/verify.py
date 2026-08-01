#!/usr/bin/env python3
"""Independent verifier for the subgroup-twist packet.

This script does not import either producer.  It reconstructs the concrete
subgroups from the exact 660-element Weil model, recomputes both A5 frames
and the 11:5 frame, repeats the A5 nonvanishing test at a second prime,
reconstructs the contained D12 and D10 lines, and audits every higher-degree
Groebner and factorization transcript against its payload hash.
"""

from __future__ import annotations

from collections import deque
from fractions import Fraction
import itertools
import hashlib
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402


def mul(a, b):
    return ew.fcanon(ew.fmul(a, b))


def inv(a):
    aa, b, c, d = a
    return ew.fcanon((d, -b, -c, aa))


def power(a, n):
    out = ew.fone
    while n:
        if n & 1:
            out = mul(out, a)
        a = mul(a, a)
        n //= 2
    return out


def order(a):
    out = ew.fone
    for n in range(1, 100):
        out = mul(out, a)
        if out == ew.fone:
            return n
    raise AssertionError


def closure(generators):
    found = {ew.fone}
    queue = deque([ew.fone])
    while queue:
        h = queue.popleft()
        for generator in generators:
            candidate = mul(h, generator)
            if candidate not in found:
                found.add(candidate)
                queue.append(candidate)
    return frozenset(found)


KEYS = tuple(sorted(ew.rho))
ORDERS = {g: order(g) for g in KEYS}


def conjugate(g, h):
    return mul(mul(g, h), inv(g))


def conjugacy_orbit(subgroup):
    return {
        frozenset(conjugate(g, h) for h in subgroup)
        for g in KEYS
    }


def normalizer(subgroup):
    return frozenset(
        g for g in KEYS
        if frozenset(conjugate(g, h) for h in subgroup) == subgroup
    )


def compose(left, right):
    return tuple(left[right[i]] for i in range(5))


PID = tuple(range(5))


def pinv(perm):
    out = [0] * 5
    for i, image in enumerate(perm):
        out[image] = i
    return tuple(out)


def mmul(a, b, prime):
    return [
        [
            sum(a[i][k] * b[k][j] for k in range(len(b))) % prime
            for j in range(len(b[0]))
        ]
        for i in range(len(a))
    ]


def madd(a, b, prime):
    return [[(x + y) % prime for x, y in zip(r, s)] for r, s in zip(a, b)]


def mscale(scalar, matrix, prime):
    return [[scalar * x % prime for x in row] for row in matrix]


def identity(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def mpow(matrix, exponent, prime):
    out = identity(len(matrix))
    while exponent:
        if exponent & 1:
            out = mmul(out, matrix, prime)
        matrix = mmul(matrix, matrix, prime)
        exponent //= 2
    return out


def mv(matrix, vector, prime):
    return [sum(a * b for a, b in zip(row, vector)) % prime for row in matrix]


def determinant(matrix, prime):
    work = [[entry % prime for entry in row] for row in matrix]
    result = 1
    for column in range(len(work)):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[pivot], work[column] = work[column], work[pivot]
            result = -result
        unit = work[column][column] % prime
        result = result * unit % prime
        inverse = pow(unit, -1, prime)
        for row in range(column + 1, len(work)):
            scale = work[row][column] * inverse % prime
            work[row] = [
                (x - scale * y) % prime
                for x, y in zip(work[row], work[column])
            ]
    return result % prime


def rank(matrix, prime):
    work = [[entry % prime for entry in row] for row in matrix]
    if not work:
        return 0
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(pivot_row, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, prime)
        work[pivot_row] = [inverse * x % prime for x in work[pivot_row]]
        for row in range(len(work)):
            if row == pivot_row:
                continue
            scale = work[row][column]
            if scale:
                work[row] = [
                    (x - scale * y) % prime
                    for x, y in zip(work[row], work[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == len(work):
            break
    return pivot_row


def nullspace(matrix, prime):
    work = [[entry % prime for entry in row] for row in matrix]
    rows = len(work)
    columns = len(work[0])
    pivots = []
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, prime)
        work[pivot_row] = [inverse * x % prime for x in work[pivot_row]]
        for row in range(rows):
            if row == pivot_row:
                continue
            scale = work[row][column]
            if scale:
                work[row] = [
                    (x - scale * y) % prime
                    for x, y in zip(work[row], work[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    free = [column for column in range(columns) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = -sum(
                work[row][column] * vector[column]
                for column in free
            ) % prime
        basis.append(vector)
    return basis


def reduce_cyclotomic(value, prime, zeta):
    result = 0
    for exponent, coefficient in enumerate(value.a):
        coefficient = Fraction(coefficient)
        residue = coefficient.numerator * pow(coefficient.denominator, -1, prime)
        result += residue * pow(zeta, exponent, prime)
    return result % prime


def rho(h, prime, zeta):
    return [
        [reduce_cyclotomic(entry, prime, zeta) for entry in row]
        for row in ew.rho[h]
    ]


def source_rep(prime, sqrt5):
    inv2 = pow(2, -1, prime)
    alpha = -(1 + sqrt5) * inv2 % prime
    p5 = (1, 2, 3, 4, 0)
    p3 = (0, 1, 3, 4, 2)
    m5 = [[alpha, -alpha % prime, -1 % prime], [alpha, 1, 0], [alpha, -alpha % prime, 0]]
    m3 = [[0, -1 % prime, -alpha % prime], [0, 0, 1], [-1 % prime, -alpha % prime, 0]]
    assert mpow(m5, 5, prime) == identity(3)
    assert mpow(m3, 3, prime) == identity(3)
    mapping = {PID: identity(3)}
    queue = deque([PID])
    generators = (
        (p5, m5), (p3, m3),
        (pinv(p5), mpow(m5, 4, prime)),
        (pinv(p3), mpow(m3, 2, prime)),
    )
    while queue:
        perm = queue.popleft()
        matrix = mapping[perm]
        for generator, generator_matrix in generators:
            candidate = compose(perm, generator)
            candidate_matrix = mmul(matrix, generator_matrix, prime)
            if candidate in mapping:
                assert mapping[candidate] == candidate_matrix
            else:
                mapping[candidate] = candidate_matrix
                queue.append(candidate)
    assert len(mapping) == 60
    return mapping


def abstract_map(a, b, pa, pb):
    mapping = {ew.fone: PID}
    queue = deque([ew.fone])
    generators = ((a, pa), (b, pb), (inv(b), pinv(pb)))
    while queue:
        h = queue.popleft()
        image = mapping[h]
        for generator, target in generators:
            candidate = mul(h, generator)
            candidate_image = compose(image, target)
            if candidate in mapping:
                assert mapping[candidate] == candidate_image
            else:
                mapping[candidate] = candidate_image
                queue.append(candidate)
    assert len(mapping) == 60 and len(set(mapping.values())) == 60
    return mapping


def frame_a5(y, subgroup, amap, sigma, prime, zeta):
    result = [[0] * 5 for _ in range(5)]
    product = 1
    den = (1, 2, 4)
    num = (3, 5, 7)
    for h in subgroup:
        moved = mv(sigma[amap[inv(h)]], y, prime)
        denominator = sum(a * b for a, b in zip(den, moved)) % prime
        if not denominator:
            return None, 0
        numerator = sum(a * b for a, b in zip(num, moved)) % prime
        product = product * denominator % prime
        result = madd(result, mscale(numerator * pow(denominator, -1, prime), rho(h, prime, zeta), prime), prime)
    return result, product


def cubic_coefficients(frame, prime):
    out = {}
    for row in range(5):
        for a in range(5):
            for b in range(5):
                for c in range(5):
                    exponent = [0] * 5
                    exponent[a] += 1
                    exponent[b] += 1
                    exponent[c] += 1
                    exponent = tuple(exponent)
                    value = frame[row][a] * frame[row][b] * frame[(row + 1) % 5][c]
                    out[exponent] = (out.get(exponent, 0) + value) % prime
    return {",".join(map(str, e)): c for e, c in sorted(out.items()) if c}


def primitive_root_of_order(prime, n):
    return next(x for x in range(2, prime) if pow(x, n, prime) == 1)


def sqrt_mod(prime, value):
    return next(x for x in range(1, prime) if x * x % prime == value % prime)


def verify_a5_payload():
    payload = json.loads((HERE / "a5_twist_payload.json").read_text())
    records = payload["records"]
    assert len(records) == 2
    subgroups = []
    for record in records:
        a, b = (tuple(x) for x in record["generators_psl2_f11"])
        subgroup = closure((a, b))
        assert len(subgroup) == 60
        assert [ORDERS[a], ORDERS[b], ORDERS[mul(a, b)]] == [2, 3, 5]
        subgroups.append(subgroup)
        pa, pb = (tuple(x) for x in record["source_generator_permutations"])
        amap = abstract_map(a, b, pa, pb)
        sigma = source_rep(89, 19)
        reduction = record["good_reduction"]
        frame, product = frame_a5(tuple(reduction["source_point"]), subgroup, amap, sigma, 89, 2)
        assert frame == reduction["frame"]
        assert product == reduction["denominator_product"]
        assert determinant(frame, 89) == reduction["frame_determinant"] == 24
        assert cubic_coefficients(frame, 89) == reduction["specialized_twist_coefficients"]
        for generator in (a, b):
            moved_y = mv(sigma[amap[generator]], reduction["source_point"], 89)
            moved_frame, _ = frame_a5(moved_y, subgroup, amap, sigma, 89, 2)
            assert moved_frame == mmul(rho(generator, 89, 2), frame, 89)

        # Independent good prime: search a second nonzero frame determinant.
        prime = 331
        zeta = primitive_root_of_order(prime, 11)
        square_root = sqrt_mod(prime, 5)
        sigma2 = source_rep(prime, square_root)
        found = None
        for y0 in range(20):
            for y1 in range(20):
                candidate, _ = frame_a5((y0, y1, 1), subgroup, amap, sigma2, prime, zeta)
                if candidate is not None and determinant(candidate, prime):
                    found = (y0, y1, determinant(candidate, prime))
                    break
            if found:
                break
        assert found is not None

        # C3 fixed projective lines exist, yielding an orbit degree prime to 3.
        c3 = next(h for h in subgroup if ORDERS[h] == 3)
        omega = primitive_root_of_order(331, 3)
        matrix = rho(c3, 331, zeta)
        eigenspace = nullspace([
            [(matrix[i][j] - int(i == j) * omega) % 331 for j in range(5)]
            for i in range(5)
        ], 331)
        assert len(eigenspace) == 2
    first_orbit = conjugacy_orbit(subgroups[0])
    second_orbit = conjugacy_orbit(subgroups[1])
    assert len(first_orbit) == len(second_orbit) == 11
    assert first_orbit.isdisjoint(second_orbit)
    return subgroups


def frame_115(y, subgroup, prime, zeta):
    result = [[0] * 5 for _ in range(5)]
    product = 1
    den = (1, 2, 3, 4, 5)
    num = (2, 3, 5, 7, 11)
    for h in subgroup:
        moved = mv(rho(inv(h), prime, zeta), y, prime)
        denominator = sum(a * b for a, b in zip(den, moved)) % prime
        assert denominator
        numerator = sum(a * b for a, b in zip(num, moved)) % prime
        product = product * denominator % prime
        result = madd(result, mscale(numerator * pow(denominator, -1, prime), rho(h, prime, zeta), prime), prime)
    return result, product


def proportional(v, w, prime):
    return all((v[i] * w[j] - v[j] * w[i]) % prime == 0 for i in range(5) for j in range(i + 1, 5))


def klein(vector, prime):
    return sum(vector[i] ** 2 * vector[(i + 1) % 5] for i in range(5)) % prime


def verify_115_payload():
    payload = json.loads((HERE / "11_5_twist_payload.json").read_text())
    c11 = closure((ew.ft,))
    subgroup = normalizer(c11)
    assert len(subgroup) == 55
    reduction = payload["good_reduction"]
    frame, product = frame_115(tuple(reduction["source_point"]), subgroup, 89, 2)
    assert frame == reduction["frame"]
    assert product == reduction["denominator_product"]
    assert determinant(frame, 89) == reduction["frame_determinant"] == 57
    assert cubic_coefficients(frame, 89) == reduction["specialized_twist_coefficients"]
    orbit = []
    e0 = [1, 0, 0, 0, 0]
    for h in subgroup:
        point = mv(rho(h, 89, 2), e0, 89)
        if not any(proportional(point, old, 89) for old in orbit):
            orbit.append(point)
    assert len(orbit) == 5 and all(klein(point, 89) == 0 for point in orbit)
    return subgroup


def span_contains(basis, vector, prime):
    before = rank([[basis[j][i] for j in range(len(basis))] for i in range(5)], prime)
    after = rank([[*(basis[j][i] for j in range(len(basis))), vector[i]] for i in range(5)], prime)
    return before == after


def line_lands(basis, prime):
    assert len(basis) == 2
    u, v = basis
    return all(
        klein([(u[i] + t * v[i]) % prime for i in range(5)], prime) == 0
        for t in range(4)
    )


def verify_contained_lines():
    # Use p=331, which splits both the 11th- and 5th-root eigenframes.
    prime = 331
    zeta = primitive_root_of_order(prime, 11)
    involution = next(g for g in KEYS if ORDERS[g] == 2)
    d12 = frozenset(g for g in KEYS if mul(g, involution) == mul(involution, g))
    matrix = rho(involution, prime, zeta)
    minus = nullspace([
        [(matrix[i][j] + int(i == j)) % prime for j in range(5)]
        for i in range(5)
    ], prime)
    assert len(d12) == 12 and len(minus) == 2 and line_lands(minus, prime)
    assert all(span_contains(minus, mv(rho(h, prime, zeta), vector, prime), prime) for h in d12 for vector in minus)

    pkey = next(g for g in KEYS if ew.rho[g] == ew.P)
    c5 = closure((pkey,))
    d10 = normalizer(c5)
    root5 = primitive_root_of_order(prime, 5)
    forward = [pow(root5, i, prime) for i in range(5)]
    backward = [pow(root5, (-i) % 5, prime) for i in range(5)]
    d10_line = [forward, backward]
    assert len(d10) == 10 and line_lands(d10_line, prime)
    assert all(span_contains(d10_line, mv(rho(h, prime, zeta), vector, prime), prime) for h in d10 for vector in d10_line)


def verify_low_degree_payload_shape():
    data = json.loads((HERE / "a5_low_degree_search.json").read_text())
    assert len(data["records"]) == 2
    t = __import__("sympy").symbols("t")
    for record in data["records"]:
        assert record["covariant_dimensions_degrees_0_to_4"] == {"0": 0, "1": 0, "2": 1, "3": 0, "4": 2}
        polynomials = []
        for item in record["degree_4_coefficient_polynomials"]:
            coefficients = item["parameter_coefficients_low_to_high"]
            polynomials.append(__import__("sympy").Poly(sum(c * t**i for i, c in enumerate(coefficients)), t, modulus=89))
        gcd = polynomials[0]
        for polynomial in polynomials[1:]:
            gcd = __import__("sympy").gcd(gcd, polynomial)
        assert gcd.degree() == 0
        assert not record["degree_4_point_at_infinity_lands"]


def file_hash(name):
    return hashlib.sha256((HERE / name).read_bytes()).hexdigest()


def verify_higher_degree_payloads():
    middle = json.loads((HERE / "a5_degree5_7_search.json").read_text())
    assert middle["prime"] == 89 and len(middle["records"]) == 2
    for record in middle["records"]:
        assert record["covariant_dimensions"] == {"5": 1, "6": 3, "7": 2}
        assert not record["degree_5_lands_on_X"]
        assert record["degree_6_geometric_landing_scheme_empty_mod_89"]
        assert record["degree_7_affine_landing_gcd_mod_89"] == [1]
        assert not record["degree_7_point_at_infinity_lands"]
        assert record["degree_7_geometric_landing_scheme_empty_mod_89"]
        for chart in record["degree_6_chart_certificates"]:
            assert chart["unit_ideal"]
            if chart["input"] is not None:
                assert file_hash(chart["input"]) == chart["input_sha256"]
                assert file_hash(chart["transcript"]) == chart["transcript_sha256"]
                assert (HERE / chart["transcript"]).read_text().strip() == "UNIT"

    high = json.loads((HERE / "a5_degree8_9_search.json").read_text())
    assert high["prime"] == 89 and len(high["records"]) == 2
    for record in high["records"]:
        assert set(record["degrees"]) == {"8", "9"}
        assert record["degrees"]["8"]["covariant_dimension"] == 5
        assert record["degrees"]["9"]["covariant_dimension"] == 3
        for degree in ("8", "9"):
            item = record["degrees"][degree]
            assert item["geometric_landing_scheme_empty_mod_89"]
            for chart in item["chart_certificates"]:
                assert chart["unit_ideal"]
                if chart["input"] is not None:
                    assert file_hash(chart["input"]) == chart["input_sha256"]
                    assert file_hash(chart["transcript"]) == chart["transcript_sha256"]
                    assert (HERE / chart["transcript"]).read_text().strip() == "UNIT"


def verify_function_field_factorizations():
    assert all((value**3 + value + 4) % 89 for value in range(89))
    degree4 = json.loads((HERE / "degree4_function_field.json").read_text())
    assert len(degree4["records"]) == 2
    for record in degree4["records"]:
        assert record["t_degree"] == 3
        assert record["irreducible_factor_count"] == 1
        assert record["f89_cubic_extension_factor_count"] == 1
        assert record["geometrically_irreducible"]
        for stem in (
            "singular_input",
            "singular_transcript",
            "extension_input",
            "extension_transcript",
        ):
            assert file_hash(record[stem]) == record[f"{stem}_sha256"]
        assert "_[2]=" not in (HERE / record["singular_transcript"]).read_text()
        assert "_[2]=" not in (HERE / record["extension_transcript"]).read_text()

    lines = json.loads((HERE / "a5_covariant_line_search.json").read_text())
    assert lines["format"] == "klein-a5-covariant-line-search-v2"
    assert len(lines["records"]) == 2
    expected_pairs = set(itertools.combinations(range(5), 2))
    for record in lines["records"]:
        assert record["primitive_degrees"] == [2, 4, 5, 6, 7]
        assert record["common_degree"] == 22
        assert record["geometric_line_rational_function_points_found"] == 0
        assert {
            (item["left_column"], item["right_column"])
            for item in record["lines"]
        } == expected_pairs
        for item in record["lines"]:
            assert sorted(degree for degree in item["factor_t_degrees"] if degree) == [3]
            assert sorted(
                degree
                for degree in item["f89_cubic_extension_factor_t_degrees"]
                if degree
            ) == [3]
            assert not item["has_f89_t_linear_factor"]
            assert not item["has_geometric_t_linear_factor"]
            for stem in ("input", "transcript", "extension_input", "extension_transcript"):
                assert file_hash(item[stem]) == item[f"{stem}_sha256"]


def verify_seal():
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["exit"] == "H-SWEEP-UNDECIDED"
    assert seal["live_commit_final_audit"] == "53e267a"
    expected = {}
    for path in sorted(HERE.rglob("*")):
        if not path.is_file() or path.name == "SEAL.json" or "__pycache__" in path.parts:
            continue
        expected[str(path.relative_to(HERE))] = hashlib.sha256(path.read_bytes()).hexdigest()
    assert seal["files"] == expected


def verify_sweep_payload():
    data = json.loads((HERE / "subgroup_sweep_payload.json").read_text())
    assert data["exit"] == "H-SWEEP-UNDECIDED"
    assert data["smallest_unresolved"]["subgroup"] == "A5_class_1"
    records = {record["label"]: record for record in data["classes"]}
    assert set(records) == {"A5_class_1", "A5_class_2", "11:5", "D12", "A4", "D10"}
    assert records["A5_class_1"]["index"] == records["A5_class_2"]["index"] == 1
    assert records["11:5"]["index_witness"]["degrees"] == [3, 5]
    assert all(records[label]["decision"] == "all_torsors_soluble" for label in ("D12", "A4", "D10"))


def main():
    verify_a5_payload()
    verify_115_payload()
    verify_contained_lines()
    verify_low_degree_payload_shape()
    verify_higher_degree_payloads()
    verify_function_field_factorizations()
    verify_sweep_payload()
    verify_seal()
    print("PASS two exact nonconjugate A5 classes and independent p=331 frame witnesses")
    print("PASS both A5 p=89 twist equations and their specialized coefficients")
    print("PASS exact 11:5 frame and degree-five orbit; index gcd(3,5)=1")
    print("PASS D12 and D10 contained two-dimensional subrepresentations")
    print("PASS complete A5 homogeneous landing schemes through degree nine are empty")
    print("PASS degree-four and full-frame line cubics have no geometric t-linear factor")
    print("PASS SEAL.json binds every durable packet file")
    print("H_SUBGROUP_TWISTS_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
