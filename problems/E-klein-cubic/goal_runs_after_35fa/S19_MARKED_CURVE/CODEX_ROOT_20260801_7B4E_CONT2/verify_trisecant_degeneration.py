#!/usr/bin/env python3
"""Independent replay of the exact S19 trisecant degeneration."""

from __future__ import annotations

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


P = 67
ZETA = 64


def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def q_rref(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
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
def inv_coefficients(coeffs):
    value = ew.C(coeffs)
    cols = [(value * ew.zp[j]).a for j in range(10)]
    augmented = [[cols[j][i] for j in range(10)] + [Fraction(i == 0)] for i in range(10)]
    reduced, pivots = q_rref(augmented)
    assert pivots == list(range(10))
    return tuple(reduced[i][-1] for i in range(10))


def cinv(value):
    answer = ew.C(inv_coefficients(value.a))
    assert value * answer == ew.C(1)
    return answer


def c_rank(matrix):
    a = [[ew.C(x) for x in row] for row in matrix]
    row = 0
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
        row += 1
        if row == len(a):
            break
    return row


def columns(vectors):
    return [[vector[i] for vector in vectors] for i in range(5)]


def dot(a, b):
    return sum((x * y for x, y in zip(a, b)), ew.C(0))


def vscale(a, v):
    return [ew.C(a) * x for x in v]


def vadd(a, b):
    return [x + y for x, y in zip(a, b)]


def meets(a, b):
    return c_rank(columns((*a, *b))) < 4


def cmod(value):
    total = 0
    power = 1
    for coefficient in value.a:
        total = (total + coefficient.numerator * pow(coefficient.denominator, -1, P) * power) % P
        power = power * ZETA % P
    return total


def mod_rank(matrix):
    a = [[x % P for x in row] for row in matrix]
    row = 0
    for column in range(len(a[0])):
        pivot = next((i for i in range(row, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        inv = pow(a[row][column], -1, P)
        a[row] = [inv * x % P for x in a[row]]
        for i in range(len(a)):
            if i != row and a[i][column]:
                value = a[i][column]
                a[i] = [(x - value * y) % P for x, y in zip(a[i], a[row])]
        row += 1
        if row == len(a):
            break
    return row


def proj(vector):
    pivot = next(x % P for x in vector if x % P)
    inv = pow(pivot, -1, P)
    return tuple(x * inv % P for x in vector)


def deser(value):
    return ew.C([Fraction(n, d) for n, d in value])


def vdeser(vector):
    return [deser(value) for value in vector]


def monomials(nvars, degree):
    if nvars == 1:
        return [(degree,)]
    return [(i,) + tail for i in range(degree + 1) for tail in monomials(nvars - 1, degree - i)]


def hf(points):
    answer = []
    for degree in range(7):
        exponents = monomials(4, degree)
        matrix = [[math.prod(pow(point[i], e[i], P) for i in range(4)) % P for e in exponents] for point in points]
        answer.append(mod_rank(matrix))
    return answer


def cover_search(triangles, budget):
    masks = [sum(1 << i for i in triple) for triple in triangles]
    by_point = [[j for j, triple in enumerate(triangles) if i in triple] for i in range(55)]
    full = (1 << 55) - 1
    failed = set()

    def visit(covered, remaining, chosen):
        if covered == full:
            return tuple(chosen)
        if 55 - covered.bit_count() > 3 * remaining or remaining == 0:
            return None
        key = (covered, remaining)
        if key in failed:
            return None
        point = min((i for i in range(55) if not (covered >> i) & 1), key=lambda i: sum((masks[j] & ~covered).bit_count() for j in by_point[i]))
        for j in sorted(by_point[point], key=lambda j: (masks[j] & ~covered).bit_count(), reverse=True):
            result = visit(covered | masks[j], remaining - 1, chosen + [j])
            if result is not None:
                return result
        failed.add(key)
        return None

    return visit(0, budget, [])


def main():
    data = json.loads((HERE / "trisecant_degeneration.json").read_text())
    assert data["schema"] == "s19-exact-trisecant-degeneration-v1"
    assert data["source_sha256"]["universal_marked_family.json"] == sha256(SOURCE_PACKET / "universal_marked_family.json")
    assert data["source_sha256"]["produce_universal_marked_family.py"] == sha256(SOURCE_PACKET / "produce_universal_marked_family.py")

    _, _, _, lines = fam.construct_line_orbit()
    mod_lines = [tuple([[cmod(x) for x in vector] for vector in line]) for line in lines]
    mod_edges = []
    for i, j in itertools.combinations(range(55), 2):
        matrix = [[mod_lines[i][a][r] for a in range(2)] + [mod_lines[j][a][r] for a in range(2)] for r in range(5)]
        if mod_rank(matrix) < 4:
            mod_edges.append((i, j))
    recorded_edges = [tuple(edge) for edge in data["orbit_triangle_configuration"]["exact_edges"]]
    assert mod_edges == recorded_edges and len(recorded_edges) == 165
    assert all(meets(lines[i], lines[j]) for i, j in recorded_edges)
    edge_set = set(recorded_edges)
    triangles = [triple for triple in itertools.combinations(range(55), 3) if all(tuple(sorted(pair)) in edge_set for pair in itertools.combinations(triple, 2))]
    assert triangles == [tuple(x) for x in data["orbit_triangle_configuration"]["exact_triangles"]]
    assert len(triangles) == 55
    assert {sum(i in edge for edge in recorded_edges) for i in range(55)} == {6}
    assert {sum(i in triple for triple in triangles) for i in range(55)} == {3}
    assert cover_search(triangles, 20) is None
    assert cover_search(triangles, 21) is not None

    h = [deser(value) for value in data["exact_hyperplane"]]
    assert proj([cmod(x) for x in h]) == (1, 1, 1, 2, 7)
    for record in data["extra_transversals"]:
        line = tuple(vdeser(vector) for vector in record["line"])
        assert c_rank(columns(line)) == 2
        assert all(dot(h, vector) == 0 for vector in line)
        assert all(meets(line, lines[i]) for i in record["orbit_line_triple"])

    points = []
    for u, v in lines:
        point = vadd(vscale(dot(h, v), u), vscale(-dot(h, u), v))
        assert any(x != 0 for x in point) and dot(h, point) == 0
        points.append(point)
    points5 = [proj([cmod(x) for x in point]) for point in points]
    assert len(set(points5)) == 55
    points4 = [proj(point[1:]) for point in points5]
    assert hf(points4) == [1, 4, 10, 19, 31, 45, 55]

    cover = [tuple(triple) for triple in data["nineteen_line_cover"]["marked_triples"]]
    assert len(cover) == 19 and set(itertools.chain.from_iterable(cover)) == set(range(55))
    cover_lines = []
    for triple in cover:
        assert c_rank(columns([points[i] for i in triple])) == 2
        cover_lines.append((points[triple[0]], points[triple[1]]))
    cover_edges = [(i, j) for i, j in itertools.combinations(range(19), 2) if meets(cover_lines[i], cover_lines[j])]
    assert cover_edges == [(2, 5), (4, 17)]
    assert data["nineteen_line_cover"]["component_count"] == 17
    assert data["nineteen_line_cover"]["hilbert_polynomial"] == "19*t+17"
    assert data["nineteen_line_cover"]["arithmetic_genus"] == -16
    assert data["terminal_marker"] == "S19_EXACT_TRISECANT_DEGENERATION_CERTIFIED"
    assert any("not a point" in claim for claim in data["strict_nonclaims"])
    print("PASS independent exact 55_3 configuration and minimum cover 21")
    print("PASS independent good-hyperplane and marked-point Hilbert-function replay")
    print("PASS independent 19-line cover audit: 17 components, 19*t+17, p_a=-16")
    print("S19_EXACT_TRISECANT_DEGENERATION_INDEPENDENT_REPLAY_OK")


if __name__ == "__main__":
    main()
