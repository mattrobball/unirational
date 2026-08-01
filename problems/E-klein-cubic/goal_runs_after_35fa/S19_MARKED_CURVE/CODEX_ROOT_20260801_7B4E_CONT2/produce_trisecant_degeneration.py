#!/usr/bin/env python3
"""Produce an exact special-hyperplane 19-line degeneration.

The 55 orbit lines contain a universal 55_3 triangle configuration.  Two
additional transversals are chosen over Q(zeta_11); the hyperplane containing
them reduces to the pinned good witness [1:1:1:2:7] modulo (67,zeta-64).
Nineteen trisecants then cover all 55 marked points.  The resulting line union
is deliberately audited as a disconnected non-Hilbert-point, not as the
degree-19 rational curve required by S19.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
import sys
from functools import lru_cache
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE_PACKET = HERE.parent / "CODEX_ROOT_20260801_7B4E"
PROBLEM = HERE.parents[2]
sys.path.insert(0, str(SOURCE_PACKET))
sys.path.insert(0, str(PROBLEM / "certificates"))

import exact_weil_check as ew  # noqa: E402
import produce_universal_marked_family as fam  # noqa: E402


OUTPUT = HERE / "trisecant_degeneration.json"
P = 67
ZETA_MOD = 64
GOOD_H = (1, 1, 1, 2, 7)
TRIPLE_A = (3, 31, 34)
TRIPLE_B = (17, 27, 30)
COMBO_A = (1, -1)
COMBO_B = (1, 14)
COVER = (
    (0, 5, 51),
    (1, 6, 45),
    (2, 7, 50),
    TRIPLE_A,
    (4, 9, 49),
    (7, 18, 21),
    (8, 12, 20),
    (10, 13, 16),
    (11, 35, 42),
    (14, 37, 41),
    (15, 39, 43),
    TRIPLE_B,
    (19, 36, 40),
    (22, 24, 38),
    (23, 32, 33),
    (25, 44, 54),
    (26, 52, 53),
    (28, 48, 49),
    (29, 46, 47),
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def q_rref(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    if not a:
        return a, []
    row = 0
    pivots = []
    for column in range(len(a[0])):
        pivot = next((i for i in range(row, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        value = a[row][column]
        a[row] = [x / value for x in a[row]]
        for i in range(len(a)):
            if i != row and a[i][column]:
                value = a[i][column]
                a[i] = [x - value * y for x, y in zip(a[i], a[row])]
        pivots.append(column)
        row += 1
        if row == len(a):
            break
    return a, pivots


@lru_cache(maxsize=None)
def inverse_coefficients(coefficients):
    value = ew.C(coefficients)
    columns = [(value * ew.zp[j]).a for j in range(10)]
    matrix = [[columns[j][i] for j in range(10)] + [Fraction(i == 0)] for i in range(10)]
    reduced, pivots = q_rref(matrix)
    assert pivots == list(range(10))
    return tuple(reduced[i][-1] for i in range(10))


def cinv(value):
    assert value != 0
    answer = ew.C(inverse_coefficients(value.a))
    assert value * answer == ew.C(1)
    return answer


def c_rref(matrix):
    a = [[ew.C(x) for x in row] for row in matrix]
    if not a:
        return a, []
    row = 0
    pivots = []
    for column in range(len(a[0])):
        pivot = next((i for i in range(row, len(a)) if a[i][column] != 0), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        inv = cinv(a[row][column])
        a[row] = [inv * x for x in a[row]]
        for i in range(len(a)):
            if i != row and a[i][column] != 0:
                value = a[i][column]
                a[i] = [x - value * y for x, y in zip(a[i], a[row])]
        pivots.append(column)
        row += 1
        if row == len(a):
            break
    return a, pivots


def c_rank(matrix):
    return len(c_rref(matrix)[1])


def c_nullspace(matrix):
    reduced, pivots = c_rref(matrix)
    ncols = len(matrix[0])
    free = [j for j in range(ncols) if j not in pivots]
    basis = []
    for column in free:
        vector = [ew.C(0) for _ in range(ncols)]
        vector[column] = ew.C(1)
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][column]
        basis.append(vector)
    return basis


def columns(vectors):
    return [[vector[i] for vector in vectors] for i in range(5)]


def vadd(left, right):
    return [a + b for a, b in zip(left, right)]


def vscale(scalar, vector):
    return [ew.C(scalar) * x for x in vector]


def dot(left, right):
    return sum((a * b for a, b in zip(left, right)), ew.C(0))


def line_meets(line_a, line_b):
    return c_rank(columns((line_a[0], line_a[1], line_b[0], line_b[1]))) < 4


def transversal(lines, triple, combo):
    u, v, w = [lines[i] for i in triple]
    matrix = columns((u[0], u[1], v[0], v[1], vscale(-1, w[0]), vscale(-1, w[1])))
    basis = c_nullspace(matrix)
    assert len(basis) == 2
    relation = [combo[0] * basis[0][i] + combo[1] * basis[1][i] for i in range(6)]
    point_u = vadd(vscale(relation[0], u[0]), vscale(relation[1], u[1]))
    point_v = vadd(vscale(relation[2], v[0]), vscale(relation[3], v[1]))
    point_w = vadd(vscale(relation[4], w[0]), vscale(relation[5], w[1]))
    assert point_w == vadd(point_u, point_v)
    answer = (point_u, point_v)
    assert c_rank(columns(answer)) == 2
    for i in triple:
        assert line_meets(answer, lines[i])
    return answer, basis, relation


def cmod(value):
    answer = 0
    power = 1
    for coefficient in value.a:
        answer = (answer + coefficient.numerator * pow(coefficient.denominator, -1, P) * power) % P
        power = power * ZETA_MOD % P
    return answer


def mod_rref(matrix, p=P):
    a = [[x % p for x in row] for row in matrix]
    if not a:
        return a, []
    row = 0
    pivots = []
    for column in range(len(a[0])):
        pivot = next((i for i in range(row, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        inv = pow(a[row][column], -1, p)
        a[row] = [inv * x % p for x in a[row]]
        for i in range(len(a)):
            if i != row and a[i][column]:
                value = a[i][column]
                a[i] = [(x - value * y) % p for x, y in zip(a[i], a[row])]
        pivots.append(column)
        row += 1
        if row == len(a):
            break
    return a, pivots


def mod_rank(matrix):
    return len(mod_rref(matrix)[1])


def projective_mod(vector):
    pivot = next(x % P for x in vector if x % P)
    inv = pow(pivot, -1, P)
    return tuple(x * inv % P for x in vector)


def marked_points(lines, h):
    answer = []
    for u, v in lines:
        point = vadd(vscale(dot(h, v), u), vscale(-dot(h, u), v))
        assert any(x != 0 for x in point)
        assert dot(h, point) == 0
        answer.append(point)
    return answer


def monomials(nvars, degree):
    if nvars == 1:
        return [(degree,)]
    return [(first,) + tail for first in range(degree + 1) for tail in monomials(nvars - 1, degree - first)]


def hilbert_function(points):
    ranks = []
    for degree in range(7):
        exponents = monomials(4, degree)
        matrix = [[math.prod(pow(point[i], exponent[i], P) for i in range(4)) % P for exponent in exponents] for point in points]
        ranks.append(mod_rank(matrix))
    return ranks


def find_triangle_configuration(lines):
    # Exact intersection can only disappear, not appear, after good reduction.
    # Thus first screen all pairs modulo 67, then certify every survivor over K.
    mod_lines = [tuple([[cmod(x) for x in vector] for vector in line]) for line in lines]
    candidates = []
    for i, j in itertools.combinations(range(55), 2):
        if mod_rank([[mod_lines[i][a][r] for a in range(2)] + [mod_lines[j][a][r] for a in range(2)] for r in range(5)]) < 4:
            candidates.append((i, j))
    edges = [(i, j) for i, j in candidates if line_meets(lines[i], lines[j])]
    edge_set = {tuple(sorted(edge)) for edge in edges}
    triangles = [triple for triple in itertools.combinations(range(55), 3) if all(tuple(sorted(pair)) in edge_set for pair in itertools.combinations(triple, 2))]
    degrees = [sum(i in edge for edge in edges) for i in range(55)]
    incidences = [sum(i in triple for triple in triangles) for i in range(55)]
    assert len(edges) == 165 and set(degrees) == {6}
    assert len(triangles) == 55 and set(incidences) == {3}
    return candidates, edges, triangles


def minimum_triangle_cover(triangles):
    masks = [sum(1 << i for i in triple) for triple in triangles]
    by_point = [[j for j, triple in enumerate(triangles) if i in triple] for i in range(55)]
    full = (1 << 55) - 1
    memo = {}

    def search(covered, remaining, chosen):
        if covered == full:
            return tuple(chosen)
        uncovered_count = 55 - covered.bit_count()
        if uncovered_count > 3 * remaining or remaining == 0:
            return None
        key = (covered, remaining)
        if key in memo:
            return None
        uncovered = [i for i in range(55) if not (covered >> i) & 1]
        point = min(uncovered, key=lambda i: sum((masks[j] & ~covered).bit_count() for j in by_point[i]))
        options = sorted(by_point[point], key=lambda j: (masks[j] & ~covered).bit_count(), reverse=True)
        for j in options:
            new = masks[j] & ~covered
            if not new:
                continue
            result = search(covered | masks[j], remaining - 1, chosen + [j])
            if result is not None:
                return result
        memo[key] = False
        return None

    no_twenty = search(0, 20, []) is None
    assert no_twenty
    witness = search(0, 21, [])
    assert witness is not None
    return [triangles[j] for j in witness], len(memo)


def cser(value):
    return [[coefficient.numerator, coefficient.denominator] for coefficient in value.a]


def vser(vector):
    return [cser(value) for value in vector]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    _, _, _, lines = fam.construct_line_orbit()
    candidates, orbit_edges, orbit_triangles = find_triangle_configuration(lines)
    cover21, states = minimum_triangle_cover(orbit_triangles)

    trans_a, basis_a, relation_a = transversal(lines, TRIPLE_A, COMBO_A)
    trans_b, basis_b, relation_b = transversal(lines, TRIPLE_B, COMBO_B)
    h_basis = c_nullspace([list(vector) for vector in (*trans_a, *trans_b)])
    assert len(h_basis) == 1
    h = h_basis[0]
    h_mod = projective_mod([cmod(x) for x in h])
    assert h_mod == GOOD_H, h_mod

    points = marked_points(lines, h)
    mod_points5 = [projective_mod([cmod(x) for x in point]) for point in points]
    assert len(set(mod_points5)) == 55
    pivot = next(i for i, x in enumerate(GOOD_H) if x)
    # Eliminate the pivot coordinate from h.x=0 to obtain the pinned P^3 chart.
    mod_points4 = []
    for point in mod_points5:
        reduced = tuple(point[i] for i in range(5) if i != pivot)
        mod_points4.append(projective_mod(reduced))
    hf = hilbert_function(mod_points4)
    assert hf == [1, 4, 10, 19, 31, 45, 55]

    assert len(COVER) == 19 and set(itertools.chain.from_iterable(COVER)) == set(range(55))
    cover_lines = []
    for triple in COVER:
        assert c_rank(columns([points[i] for i in triple])) == 2
        cover_lines.append((points[triple[0]], points[triple[1]]))
    assert all(c_rank(columns(line)) == 2 for line in cover_lines)

    cover_edges = [(i, j) for i, j in itertools.combinations(range(19), 2) if line_meets(cover_lines[i], cover_lines[j])]
    components = []
    unseen = set(range(19))
    while unseen:
        stack = [unseen.pop()]
        component = set(stack)
        while stack:
            i = stack.pop()
            for edge in cover_edges:
                if i in edge:
                    j = edge[0] if edge[1] == i else edge[1]
                    if j not in component:
                        component.add(j)
                        unseen.discard(j)
                        stack.append(j)
        components.append(sorted(component))
    assert len(cover_edges) == 2
    assert len(components) == 17
    # Two distinct marked nodes and a forest: P_U(t)=19(t+1)-2.
    shared_nodes = []
    for i, j in cover_edges:
        shared = sorted(set(COVER[i]) & set(COVER[j]))
        assert len(shared) == 1
        shared_nodes.append(shared[0])
    assert len(set(shared_nodes)) == 2
    arithmetic_genus = 1 - (19 - len(cover_edges))
    assert arithmetic_genus == -16

    data = {
        "schema": "s19-exact-trisecant-degeneration-v1",
        "source_sha256": {
            "universal_marked_family.json": sha256(SOURCE_PACKET / "universal_marked_family.json"),
            "produce_universal_marked_family.py": sha256(SOURCE_PACKET / "produce_universal_marked_family.py"),
        },
        "field": "Q(zeta_11), basis 1,zeta,...,zeta^9",
        "good_reduction": {"prime": P, "zeta": ZETA_MOD, "hyperplane_projective": list(h_mod), "distinct_marked_points": 55, "hilbert_function_0_through_6": hf},
        "orbit_triangle_configuration": {
            "modular_pair_candidates": len(candidates),
            "exact_edges": [list(edge) for edge in orbit_edges],
            "degree_sequence": [6] * 55,
            "exact_triangles": [list(triple) for triple in orbit_triangles],
            "point_triangle_incidence_sequence": [3] * 55,
            "minimum_cover_size": 21,
            "cover_21": [list(triple) for triple in cover21],
            "no_cover_at_most_20_dfs_memo_states": states,
        },
        "extra_transversals": [
            {"orbit_line_triple": list(TRIPLE_A), "nullspace_combo": list(COMBO_A), "basis": [[vser(vector) for vector in basis_a]], "relation": [cser(x) for x in relation_a], "line": [vser(vector) for vector in trans_a]},
            {"orbit_line_triple": list(TRIPLE_B), "nullspace_combo": list(COMBO_B), "basis": [[vser(vector) for vector in basis_b]], "relation": [cser(x) for x in relation_b], "line": [vser(vector) for vector in trans_b]},
        ],
        "exact_hyperplane": [cser(x) for x in h],
        "nineteen_line_cover": {
            "marked_triples": [list(triple) for triple in COVER],
            "covers_all_55": True,
            "exact_intersection_edges": [list(edge) for edge in cover_edges],
            "connected_components": components,
            "component_count": len(components),
            "hilbert_polynomial": "19*t+17",
            "arithmetic_genus": arithmetic_genus,
        },
        "terminal_marker": "S19_EXACT_TRISECANT_DEGENERATION_CERTIFIED",
        "strict_nonclaims": [
            "The 19-line union is disconnected and has Hilbert polynomial 19*t+17, not 19*t+1.",
            "This is not a point of Hilb^{19t+1}(P3), not a rational curve, and not an S19 solution.",
            "Good reduction proves the named characteristic-zero nonvanishing gates; it is not itself a characteristic-zero curve construction.",
        ],
    }
    encoded = json.dumps(data, indent=2, sort_keys=True) + "\n"
    if arguments.check:
        if OUTPUT.read_text() != encoded:
            raise SystemExit("trisecant degeneration payload mismatch")
        print("S19_EXACT_TRISECANT_DEGENERATION_REPRODUCES")
    else:
        OUTPUT.write_text(encoded)
    print("PASS exact 55_3 orbit triangle configuration; minimum triangle cover is 21")
    print("PASS exact special hyperplane reduces to [1:1:1:2:7] at (67,zeta-64)")
    print("PASS 19 exact trisecants cover all 55 marked points")
    print("PASS union has 17 components, Hilbert polynomial 19*t+17, p_a=-16")
    print("S19_EXACT_TRISECANT_DEGENERATION_CERTIFIED")


if __name__ == "__main__":
    main()
