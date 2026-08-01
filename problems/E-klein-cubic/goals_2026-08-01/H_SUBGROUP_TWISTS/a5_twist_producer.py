#!/usr/bin/env python3
"""Produce exact finite-group data and Hilbert--90 witnesses for Goal H.

The characteristic-zero frame is the formula documented in ``BRIDGE.md``.
This producer records the two nonconjugate maximal A5 subgroups and proves
that the formula is generically invertible by a good-reduction witness at 89.
No finite-field pointlessness claim is made.
"""

from __future__ import annotations

from collections import deque
import itertools
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402


P = 89
ZETA = 2
SQRT5 = 19


def gmul(a, b):
    return ew.fcanon(ew.fmul(a, b))


def ginv(a):
    aa, b, c, d = a
    return ew.fcanon((d, -b, -c, aa))


def gpow(a, n):
    out = ew.fone
    for _ in range(n):
        out = gmul(out, a)
    return out


def order(a):
    out = ew.fone
    for n in range(1, 100):
        out = gmul(out, a)
        if out == ew.fone:
            return n
    raise AssertionError("order bound")


GROUP = tuple(sorted(ew.rho))
ORDERS = {g: order(g) for g in GROUP}


def closure(generators):
    found = {ew.fone}
    queue = deque([ew.fone])
    generators = tuple(generators)
    while queue:
        x = queue.popleft()
        for g in generators:
            y = gmul(x, g)
            if y not in found:
                found.add(y)
                queue.append(y)
    return frozenset(found)


def conjugate(g, h):
    return gmul(gmul(g, h), ginv(g))


def conjugacy_orbit(H):
    return {frozenset(conjugate(g, h) for h in H) for g in GROUP}


def find_a5_classes():
    involutions = [g for g in GROUP if ORDERS[g] == 2]
    order_three = [g for g in GROUP if ORDERS[g] == 3]
    candidates = []
    for a in involutions:
        for b in order_three:
            if ORDERS[gmul(a, b)] != 5:
                continue
            H = closure((a, b))
            if len(H) == 60:
                candidates.append((a, b, H))
    first = candidates[0]
    first_orbit = conjugacy_orbit(first[2])
    second = next(candidate for candidate in candidates if candidate[2] not in first_orbit)
    second_orbit = conjugacy_orbit(second[2])
    assert len(first_orbit) == len(second_orbit) == 11
    assert first_orbit.isdisjoint(second_orbit)
    return first, second


def pcompose(left, right):
    return tuple(left[right[i]] for i in range(5))


PID = tuple(range(5))


def pinv(g):
    out = [0] * 5
    for i, image in enumerate(g):
        out[image] = i
    return tuple(out)


def porder(g):
    out = PID
    for n in range(1, 61):
        out = pcompose(out, g)
        if out == PID:
            return n
    raise AssertionError("permutation order bound")


def even(g):
    return sum(g[i] > g[j] for i in range(5) for j in range(i + 1, 5)) % 2 == 0


A5PERMS = tuple(g for g in itertools.permutations(range(5)) if even(g))


def mmul(A, B):
    return [[sum(A[i][k] * B[k][j] for k in range(len(B))) % P
             for j in range(len(B[0]))] for i in range(len(A))]


def mv(A, v):
    return [sum(a * b for a, b in zip(row, v)) % P for row in A]


def identity(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def determinant(A):
    work = [[x % P for x in row] for row in A]
    out = 1
    for col in range(len(work)):
        pivot = next((row for row in range(col, len(work)) if work[row][col]), None)
        if pivot is None:
            return 0
        if pivot != col:
            work[col], work[pivot] = work[pivot], work[col]
            out = -out
        unit = work[col][col] % P
        out = out * unit % P
        inverse = pow(unit, -1, P)
        for row in range(col + 1, len(work)):
            scale = work[row][col] * inverse % P
            work[row] = [(a - scale * b) % P for a, b in zip(work[row], work[col])]
    return out % P


def madd(A, B):
    return [[(a + b) % P for a, b in zip(arow, brow)] for arow, brow in zip(A, B)]


def mscale(c, A):
    return [[c * x % P for x in row] for row in A]


def reduce_cyclotomic(x):
    return sum(
        (int(q.numerator) % P) * pow(int(q.denominator), -1, P) * pow(ZETA, i, P)
        for i, q in enumerate(x.a)
    ) % P


def reduce_rho(g):
    return [[reduce_cyclotomic(x) for x in row] for row in ew.rho[g]]


def standard_representation():
    """The GAP 3-dimensional A5 representation reduced at sqrt(5)=19."""

    inv2 = pow(2, -1, P)
    alpha = -(1 + SQRT5) * inv2 % P
    g5 = (1, 2, 3, 4, 0)
    g3 = (0, 1, 3, 4, 2)
    M5 = [[alpha, -alpha % P, -1 % P], [alpha, 1, 0], [alpha, -alpha % P, 0]]
    M3 = [[0, -1 % P, -alpha % P], [0, 0, 1], [-1 % P, -alpha % P, 0]]
    reps = {PID: identity(3)}
    queue = deque([PID])
    for perm, matrix in ((g5, M5), (g3, M3)):
        assert porder(perm) in (3, 5)
    while queue:
        x = queue.popleft()
        for g, M in ((g5, M5), (g3, M3)):
            y = pcompose(x, g)
            YM = mmul(reps[x], M)
            if y in reps:
                assert reps[y] == YM
            else:
                reps[y] = YM
                queue.append(y)
    assert set(reps) == set(A5PERMS)
    return reps


STDREP = standard_representation()


def standard_triangle_pair():
    twos = [g for g in A5PERMS if porder(g) == 2]
    threes = [g for g in A5PERMS if porder(g) == 3]
    for a in twos:
        for b in threes:
            if porder(pcompose(a, b)) == 5:
                return a, b
    raise AssertionError("no (2,3,5) pair")


PA, PB = standard_triangle_pair()


def subgroup_isomorphism(a, b, H):
    """Map a->PA, b->PB, checking all relations by simultaneous BFS."""

    mapping = {ew.fone: PID}
    queue = deque([ew.fone])
    while queue:
        x = queue.popleft()
        for g, p in ((a, PA), (b, PB)):
            y = gmul(x, g)
            q = pcompose(mapping[x], p)
            if y in mapping:
                assert mapping[y] == q
            else:
                mapping[y] = q
                queue.append(y)
    assert set(mapping) == set(H) and set(mapping.values()) == set(A5PERMS)
    return mapping


def frame_at(H, mapping, y):
    """A(y)=sum_h c(sigma(h^-1)y)rho(h), c=y0/(y0+2y1+3y2)."""

    frame = [[0] * 5 for _ in range(5)]
    denominators = []
    for h in H:
        source = STDREP[mapping[ginv(h)]]
        hy = mv(source, y)
        denominator = (hy[0] + 2 * hy[1] + 3 * hy[2]) % P
        if denominator == 0:
            return None, None
        denominators.append(denominator)
        scalar = hy[0] * pow(denominator, -1, P) % P
        frame = madd(frame, mscale(scalar, reduce_rho(h)))
    return frame, denominators


def klein(v):
    return sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5)) % P


def class_payload(index, data):
    a, b, H = data
    mapping = subgroup_isomorphism(a, b, H)
    witness = None
    for y in itertools.product(range(1, 24), repeat=3):
        frame, denominators = frame_at(H, mapping, y)
        if frame is not None and determinant(frame):
            witness = (y, frame, denominators)
            break
    assert witness is not None
    y, frame, denominators = witness

    # Check the equivariance law at the witness for both chosen generators.
    for g in (a, b):
        gy = mv(STDREP[mapping[g]], y)
        transformed, _ = frame_at(H, mapping, gy)
        assert transformed == mmul(reduce_rho(g), frame)

    # Check invariance of the pulled-back cubic at several target vectors.
    base_values = []
    for z in ((1, 2, 3, 4, 5), (2, 0, 1, 7, 3), (4, 1, 0, 2, 8)):
        base = klein(mv(frame, z))
        for g in (a, b):
            gy = mv(STDREP[mapping[g]], y)
            transformed, _ = frame_at(H, mapping, gy)
            assert klein(mv(transformed, z)) == base
        base_values.append(base)

    return {
        "class": index,
        "order": len(H),
        "generators": [list(a), list(b)],
        "generator_orders": [ORDERS[a], ORDERS[b], ORDERS[gmul(a, b)]],
        "subgroup_elements": [list(h) for h in sorted(H)],
        "isomorphism_to_A5": [
            {"h": list(h), "permutation": list(mapping[h])} for h in sorted(H)
        ],
        "good_reduction": {
            "prime": P,
            "zeta11": ZETA,
            "sqrt5": SQRT5,
            "source_point": list(y),
            "denominator_product": __import__("math").prod(denominators) % P,
            "frame": frame,
            "frame_determinant": determinant(frame),
            "twisted_cubic_values": base_values,
        },
    }


def main():
    first, second = find_a5_classes()
    payload = {
        "format": "H-A5-HILBERT90-v1",
        "scope": "exact subgroup separation and generic-frame nonvanishing; no pointlessness claim",
        "ambient_group_order": len(GROUP),
        "a5_conjugacy_class_sizes": [len(conjugacy_orbit(first[2])), len(conjugacy_orbit(second[2]))],
        "frame_formula": "A(y)=sum_{h in H} c(sigma(h^-1)y)rho(h), c=y0/(y0+2*y1+3*y2)",
        "classes": [class_payload(1, first), class_payload(2, second)],
    }
    (HERE / "a5_twist_payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS two nonconjugate A5 classes of size 11")
    for record in payload["classes"]:
        good = record["good_reduction"]
        print(
            f"PASS A5 class {record['class']} Hilbert-90 frame det={good['frame_determinant']} "
            f"at y={tuple(good['source_point'])} mod {P}"
        )
    print("H_A5_TWIST_PRODUCER_OK")


if __name__ == "__main__":
    main()
