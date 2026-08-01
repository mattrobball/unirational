#!/usr/bin/env python3
"""Build exact finite-group data and good-reduction witnesses for both A5 twists.

The characteristic-zero twist is kept as an exact formula over
L=C(P^2): for a concrete maximal A5 subgroup H and its faithful
three-dimensional representation sigma, put

    A(y) = sum_{h in H} c(sigma(h^-1)y) rho(h),
    c(y)=m(y)/ell(y).

Then A(sigma(g)y)=rho(g)A(y).  A nonzero determinant after reduction at a
good prime proves that A is a Hilbert--90 frame in characteristic zero.
The descended cubic is F(A(y)z)=0 over K=L^H.  We build the two nonconjugate
maximal A5 classes separately.
"""

from __future__ import annotations

from collections import Counter, deque
from fractions import Fraction
import itertools
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
CERT = ROOT / "certificates"
sys.path.insert(0, str(CERT))
import exact_weil_check as ew  # noqa: E402


PRIME = 89
ZETA11 = 2
SQRT5 = 19
DEN = (1, 2, 4)
NUM = (3, 5, 7)


def gmul(a, b):
    return ew.fcanon(ew.fmul(a, b))


def ginv(a):
    aa, b, c, d = a
    return ew.fcanon((d, -b, -c, aa))


def gpow(a, n):
    out = ew.fone
    while n:
        if n & 1:
            out = gmul(out, a)
        a = gmul(a, a)
        n //= 2
    return out


def order(a):
    out = ew.fone
    for n in range(1, 100):
        out = gmul(out, a)
        if out == ew.fone:
            return n
    raise AssertionError("group order search failed")


def closure(generators):
    generators = tuple(generators)
    found = {ew.fone}
    queue = deque([ew.fone])
    while queue:
        h = queue.popleft()
        for g in generators:
            candidate = gmul(h, g)
            if candidate not in found:
                found.add(candidate)
                queue.append(candidate)
    return frozenset(found)


def conjugate(g, h):
    return gmul(gmul(g, h), ginv(g))


KEYS = tuple(sorted(ew.rho))
ORDERS = {g: order(g) for g in KEYS}


def presentation_candidates():
    involutions = [g for g in KEYS if ORDERS[g] == 2]
    order_three = [g for g in KEYS if ORDERS[g] == 3]
    for a in involutions:
        for b in order_three:
            if ORDERS[gmul(a, b)] != 5:
                continue
            subgroup = closure((a, b))
            if len(subgroup) == 60:
                yield a, b, subgroup


def conjugacy_orbit(subgroup):
    return {
        frozenset(conjugate(g, h) for h in subgroup)
        for g in KEYS
    }


def two_a5_classes():
    first_a, first_b, first = next(presentation_candidates())
    first_orbit = conjugacy_orbit(first)
    assert len(first_orbit) == 11
    second_data = next(
        (a, b, subgroup)
        for a, b, subgroup in presentation_candidates()
        if subgroup not in first_orbit
    )
    second_a, second_b, second = second_data
    second_orbit = conjugacy_orbit(second)
    assert len(second_orbit) == 11
    assert first_orbit.isdisjoint(second_orbit)
    return ((first_a, first_b, first), (second_a, second_b, second))


def pcompose(left, right):
    """Permutation left after right, on 0,...,4."""
    return tuple(left[right[i]] for i in range(5))


PID = tuple(range(5))


def pinv(perm):
    out = [0] * 5
    for i, image in enumerate(perm):
        out[image] = i
    return tuple(out)


def porder(perm):
    out = PID
    for n in range(1, 61):
        out = pcompose(out, perm)
        if out == PID:
            return n
    raise AssertionError("permutation order search failed")


def even(perm):
    return sum(
        perm[i] > perm[j]
        for i in range(5)
        for j in range(i + 1, 5)
    ) % 2 == 0


A5_PERMS = tuple(
    perm for perm in itertools.permutations(range(5)) if even(perm)
)


def standard_presentation_pair():
    for a in A5_PERMS:
        if porder(a) != 2:
            continue
        for b in A5_PERMS:
            if porder(b) == 3 and porder(pcompose(a, b)) == 5:
                return a, b
    raise AssertionError("no A5 (2,3,5) pair")


PRESENTATION_PERMS = standard_presentation_pair()


def abstract_isomorphism(a, b):
    """Map <a,b> to permutation A5 via matching (2,3,5) generators."""
    pa, pb = PRESENTATION_PERMS
    generators = ((a, pa), (b, pb), (ginv(b), pinv(pb)))
    mapping = {ew.fone: PID}
    queue = deque([ew.fone])
    while queue:
        h = queue.popleft()
        image = mapping[h]
        for source_generator, target_generator in generators:
            candidate = gmul(h, source_generator)
            candidate_image = pcompose(image, target_generator)
            if candidate in mapping:
                assert mapping[candidate] == candidate_image
            else:
                mapping[candidate] = candidate_image
                queue.append(candidate)
    assert len(mapping) == 60 and len(set(mapping.values())) == 60
    return mapping


def madd(a, b, prime=PRIME):
    return [
        [(x + y) % prime for x, y in zip(row_a, row_b)]
        for row_a, row_b in zip(a, b)
    ]


def mscale(scalar, matrix, prime=PRIME):
    return [[scalar * x % prime for x in row] for row in matrix]


def mmul(a, b, prime=PRIME):
    return [
        [
            sum(a[i][k] * b[k][j] for k in range(len(b))) % prime
            for j in range(len(b[0]))
        ]
        for i in range(len(a))
    ]


def midentity(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def mpow(matrix, exponent, prime=PRIME):
    out = midentity(len(matrix))
    while exponent:
        if exponent & 1:
            out = mmul(out, matrix, prime)
        matrix = mmul(matrix, matrix, prime)
        exponent //= 2
    return out


def minverse(matrix, prime=PRIME):
    n = len(matrix)
    work = [
        [entry % prime for entry in row] + identity_row
        for row, identity_row in zip(matrix, midentity(n))
    ]
    for column in range(n):
        pivot = next(i for i in range(column, n) if work[i][column])
        work[column], work[pivot] = work[pivot], work[column]
        unit = pow(work[column][column], -1, prime)
        work[column] = [unit * x % prime for x in work[column]]
        for row in range(n):
            if row == column:
                continue
            scale = work[row][column]
            if scale:
                work[row] = [
                    (x - scale * y) % prime
                    for x, y in zip(work[row], work[column])
                ]
    return [row[n:] for row in work]


def determinant(matrix, prime=PRIME):
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


def mv(matrix, vector, prime=PRIME):
    return [sum(a * b for a, b in zip(row, vector)) % prime for row in matrix]


def reduce_fraction(value, prime):
    value = Fraction(value)
    return value.numerator * pow(value.denominator, -1, prime) % prime


def reduce_cyclotomic(value, prime=PRIME, zeta=ZETA11):
    return sum(
        reduce_fraction(coefficient, prime) * pow(zeta, exponent, prime)
        for exponent, coefficient in enumerate(value.a)
    ) % prime


def rho_mod(h, prime=PRIME, zeta=ZETA11):
    return [
        [reduce_cyclotomic(entry, prime, zeta) for entry in row]
        for row in ew.rho[h]
    ]


def source_representation(prime=PRIME, sqrt5=SQRT5):
    """GAP's first 3-dimensional A5 representation in a simple basis."""
    inv2 = pow(2, -1, prime)
    alpha = -(1 + sqrt5) * inv2 % prime
    p5 = (1, 2, 3, 4, 0)
    p3 = (0, 1, 3, 4, 2)
    m5 = [
        [alpha, -alpha % prime, -1 % prime],
        [alpha, 1, 0],
        [alpha, -alpha % prime, 0],
    ]
    m3 = [
        [0, -1 % prime, -alpha % prime],
        [0, 0, 1],
        [-1 % prime, -alpha % prime, 0],
    ]
    assert mpow(m5, 5, prime) == midentity(3)
    assert mpow(m3, 3, prime) == midentity(3)
    mapping = {PID: midentity(3)}
    queue = deque([PID])
    generators = (
        (p5, m5),
        (p3, m3),
        (pinv(p5), mpow(m5, 4, prime)),
        (pinv(p3), mpow(m3, 2, prime)),
    )
    while queue:
        perm = queue.popleft()
        matrix = mapping[perm]
        for generator, generator_matrix in generators:
            candidate = pcompose(perm, generator)
            candidate_matrix = mmul(matrix, generator_matrix, prime)
            if candidate in mapping:
                assert mapping[candidate] == candidate_matrix
            else:
                mapping[candidate] = candidate_matrix
                queue.append(candidate)
    assert len(mapping) == 60
    return mapping


def zero_matrix(n):
    return [[0] * n for _ in range(n)]


def frame_at(y, subgroup, abstract_map, source_matrices, prime=PRIME, zeta=ZETA11):
    result = zero_matrix(5)
    denominators = []
    for h in subgroup:
        inverse_source = source_matrices[abstract_map[ginv(h)]]
        moved = mv(inverse_source, y, prime)
        denominator = sum(a * b for a, b in zip(DEN, moved)) % prime
        if denominator == 0:
            return None, None
        numerator = sum(a * b for a, b in zip(NUM, moved)) % prime
        denominators.append(denominator)
        result = madd(
            result,
            mscale(numerator * pow(denominator, -1, prime), rho_mod(h, prime, zeta), prime),
            prime,
        )
    return result, denominators


def find_frame_witness(subgroup, abstract_map, source_matrices, prime=PRIME, zeta=ZETA11):
    for y0 in range(prime):
        for y1 in range(prime):
            y = (y0, y1, 1)
            frame, denominators = frame_at(
                y, subgroup, abstract_map, source_matrices, prime, zeta
            )
            if frame is None:
                continue
            det = determinant(frame, prime)
            if det:
                return y, frame, denominators, det
    raise AssertionError("no finite-field frame witness")


def cubic_coefficients(frame, prime=PRIME):
    coefficients = {}
    for row in range(5):
        following = (row + 1) % 5
        for left in range(5):
            for middle in range(5):
                for right in range(5):
                    exponent = [0] * 5
                    exponent[left] += 1
                    exponent[middle] += 1
                    exponent[right] += 1
                    exponent = tuple(exponent)
                    value = (
                        frame[row][left]
                        * frame[row][middle]
                        * frame[following][right]
                    ) % prime
                    coefficients[exponent] = (
                        coefficients.get(exponent, 0) + value
                    ) % prime
    return {
        ",".join(map(str, exponent)): value
        for exponent, value in sorted(coefficients.items())
        if value
    }


def trace_exact(matrix):
    return sum(matrix[i][i] for i in range(len(matrix)))


def character_norm(subgroup):
    return sum(
        trace_exact(ew.rho[h]) * trace_exact(ew.rho[ginv(h)])
        for h in subgroup
    ) / len(subgroup)


def serialize_group_element(element):
    return list(element)


def serialize_record(label, a, b, subgroup):
    abstract_map = abstract_isomorphism(a, b)
    source_matrices = source_representation()
    y, frame, denominators, det = find_frame_witness(
        subgroup, abstract_map, source_matrices
    )
    # Verify the transformation rule at the witness and both generators.
    for generator in (a, b):
        moved_y = mv(source_matrices[abstract_map[generator]], y)
        moved_frame, _ = frame_at(
            moved_y, subgroup, abstract_map, source_matrices
        )
        assert moved_frame == mmul(rho_mod(generator), frame)
    assert character_norm(subgroup) == ew.C(1)
    return {
        "label": label,
        "order": len(subgroup),
        "generators_psl2_f11": [
            serialize_group_element(a),
            serialize_group_element(b),
        ],
        "generator_orders": [ORDERS[a], ORDERS[b], ORDERS[gmul(a, b)]],
        "source_generator_permutations": [
            list(abstract_map[a]),
            list(abstract_map[b]),
        ],
        "restriction_character_norm": 1,
        "hilbert90_formula": (
            "A(y)=sum_{h in H} c(sigma(h^-1)y)rho(h), "
            "c=(3*y0+5*y1+7*y2)/(y0+2*y1+4*y2)"
        ),
        "twisted_cubic_equation": (
            "F_H(z)=sum_{i mod 5}(A(y)z)_i^2(A(y)z)_{i+1}=0 "
            "over K_H=C(P^2)^H"
        ),
        "good_reduction": {
            "prime": PRIME,
            "zeta11": ZETA11,
            "sqrt5": SQRT5,
            "source_point": list(y),
            "denominator_product": __import__("math").prod(denominators) % PRIME,
            "frame_determinant": det,
            "frame": frame,
            "specialized_twist_coefficients": cubic_coefficients(frame),
        },
    }


def main():
    assert pow(ZETA11, 11, PRIME) == 1 and ZETA11 != 1
    assert SQRT5 * SQRT5 % PRIME == 5
    class_data = two_a5_classes()
    first_orbit = conjugacy_orbit(class_data[0][2])
    second_orbit = conjugacy_orbit(class_data[1][2])
    assert len(first_orbit) == len(second_orbit) == 11
    assert first_orbit.isdisjoint(second_orbit)
    records = [
        serialize_record(f"A5_class_{index}", *data)
        for index, data in enumerate(class_data, 1)
    ]
    payload = {
        "format": "klein-a5-subgroup-generic-twists-v1",
        "base_field": "C",
        "ambient_representation": "exact Q(zeta_11) Weil model from certificates/exact_weil_check.py",
        "generic_torsor": (
            "Spec C(P^2) -> Spec C(P^2)^H for the faithful projective "
            "icosahedral 3-dimensional representation"
        ),
        "class_comparison": {
            "number_of_classes": 2,
            "subgroups_per_class": [len(first_orbit), len(second_orbit)],
            "classes_disjoint": True,
            "method": "exact conjugation enumeration in all 660 elements",
        },
        "records": records,
    }
    output = HERE / "a5_twist_payload.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {output}")
    for record in records:
        reduction = record["good_reduction"]
        print(
            record["label"],
            "det=", reduction["frame_determinant"],
            "point=", reduction["source_point"],
            "nonzero_coefficients=", len(reduction["specialized_twist_coefficients"]),
        )
    print("A5_TWIST_PAYLOAD_OK")


if __name__ == "__main__":
    main()
