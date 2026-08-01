#!/usr/bin/env python3
"""Producer for the isolated Goal H subgroup-twist packet.

It constructs separate generic twists for both maximal A5 classes, plus A4
and 11:5, using a degree-zero Hilbert--90 seed on projective space.  It also
records the exact index-one and soluble-subgroup conclusions used in STATUS.
"""

from __future__ import annotations

from collections import deque
import itertools
import json
import math
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402


P, ZETA, SQRT5 = 89, 2, 19


def gmul(a, b): return ew.fcanon(ew.fmul(a, b))


def ginv(a):
    aa, b, c, d = a
    return ew.fcanon((d, -b, -c, aa))


def gpow(a, n):
    out = ew.fone
    for _ in range(n): out = gmul(out, a)
    return out


def order(a):
    out = ew.fone
    for n in range(1, 100):
        out = gmul(out, a)
        if out == ew.fone: return n
    raise AssertionError


GROUP = tuple(sorted(ew.rho))
ORDERS = {g: order(g) for g in GROUP}


def closure(gens):
    found, queue = {ew.fone}, deque([ew.fone])
    while queue:
        x = queue.popleft()
        for g in gens:
            y = gmul(x, g)
            if y not in found: found.add(y); queue.append(y)
    return frozenset(found)


def conj(g, h): return gmul(gmul(g, h), ginv(g))


def orbit(H): return {frozenset(conj(g, h) for h in H) for g in GROUP}


def normalizer(H, ambient=GROUP):
    return frozenset(g for g in ambient if frozenset(conj(g, h) for h in H) == H)


def two_a5_classes():
    pairs = []
    for a in (g for g in GROUP if ORDERS[g] == 2):
        for b in (g for g in GROUP if ORDERS[g] == 3):
            if ORDERS[gmul(a, b)] == 5:
                H = closure((a, b))
                if len(H) == 60: pairs.append((a, b, H))
    first = pairs[0]
    first_orbit = orbit(first[2])
    second = next(row for row in pairs if row[2] not in first_orbit)
    assert len(first_orbit) == len(orbit(second[2])) == 11
    assert first_orbit.isdisjoint(orbit(second[2]))
    return first, second


def pc(a, b): return tuple(a[b[i]] for i in range(5))


PID = tuple(range(5))


def peven(g): return sum(g[i] > g[j] for i in range(5) for j in range(i + 1, 5)) % 2 == 0


PERMS = tuple(g for g in itertools.permutations(range(5)) if peven(g))


def po(g):
    x = PID
    for n in range(1, 61):
        x = pc(x, g)
        if x == PID: return n
    raise AssertionError


def mi(n): return [[int(i == j) for j in range(n)] for i in range(n)]


def mm(A, B):
    return [[sum(A[i][k] * B[k][j] for k in range(len(B))) % P
             for j in range(len(B[0]))] for i in range(len(A))]


def mv(A, v): return [sum(x * y for x, y in zip(row, v)) % P for row in A]


def ma(A, B): return [[(x + y) % P for x, y in zip(a, b)] for a, b in zip(A, B)]


def ms(c, A): return [[c * x % P for x in row] for row in A]


def det(A):
    A, out = [[x % P for x in row] for row in A], 1
    for j in range(len(A)):
        pivot = next((i for i in range(j, len(A)) if A[i][j]), None)
        if pivot is None: return 0
        if pivot != j: A[j], A[pivot], out = A[pivot], A[j], -out
        u = A[j][j] % P; out = out * u % P; ui = pow(u, -1, P)
        for i in range(j + 1, len(A)):
            q = A[i][j] * ui % P
            A[i] = [(x - q * y) % P for x, y in zip(A[i], A[j])]
    return out % P


def reduce_c(x):
    return sum(int(q.numerator) * pow(int(q.denominator), -1, P) * pow(ZETA, i, P)
               for i, q in enumerate(x.a)) % P


RHO = {g: [[reduce_c(x) for x in row] for row in ew.rho[g]] for g in GROUP}


def source_a5():
    inv2 = pow(2, -1, P); alpha = -(1 + SQRT5) * inv2 % P
    g5, g3 = (1, 2, 3, 4, 0), (0, 1, 3, 4, 2)
    M5 = [[alpha, -alpha % P, -1 % P], [alpha, 1, 0], [alpha, -alpha % P, 0]]
    M3 = [[0, -1 % P, -alpha % P], [0, 0, 1], [-1 % P, -alpha % P, 0]]
    reps, queue = {PID: mi(3)}, deque([PID])
    while queue:
        x = queue.popleft()
        for g, M in ((g5, M5), (g3, M3)):
            y, YM = pc(x, g), mm(reps[x], M)
            if y in reps: assert reps[y] == YM
            else: reps[y] = YM; queue.append(y)
    assert set(reps) == set(PERMS)
    return reps


SOURCE_A5 = source_a5()
PA, PB = next((a, b) for a in PERMS if po(a) == 2 for b in PERMS if po(b) == 3 and po(pc(a, b)) == 5)


def iso(a, b, H):
    out, queue = {ew.fone: PID}, deque([ew.fone])
    while queue:
        x = queue.popleft()
        for g, p in ((a, PA), (b, PB)):
            y, yp = gmul(x, g), pc(out[x], p)
            if y in out: assert out[y] == yp
            else: out[y] = yp; queue.append(y)
    assert set(out) == set(H) and set(out.values()) == set(PERMS)
    return out


def frame(H, source, y, ell):
    A, denoms = [[0] * 5 for _ in range(5)], []
    for h in H:
        hy = mv(source[ginv(h)], y)
        d = sum(x * z for x, z in zip(ell, hy)) % P
        if not d: return None, None
        # Degree-zero seed c(y)=y0/ell(y), hence c is in C(P(V)).
        A = ma(A, ms(hy[0] * pow(d, -1, P) % P, RHO[h])); denoms.append(d)
    return A, denoms


def poly_mul(a, b):
    out = {}
    for ea, ca in a.items():
        for eb, cb in b.items():
            e = tuple(x + y for x, y in zip(ea, eb)); out[e] = (out.get(e, 0) + ca * cb) % P
    return {e: c for e, c in out.items() if c}


def twist_coefficients(A):
    linear = [{tuple(int(i == j) for i in range(5)): A[row][j] for j in range(5) if A[row][j]}
              for row in range(5)]
    out = {}
    for i in range(5):
        term = poly_mul(poly_mul(linear[i], linear[i]), linear[(i + 1) % 5])
        for e, c in term.items(): out[e] = (out.get(e, 0) + c) % P
    exponents = [
        e for e in itertools.product(range(4), repeat=5) if sum(e) == 3
    ]
    assert len(exponents) == 35
    return {",".join(map(str, e)): out.get(e, 0) for e in exponents}


def gens(H):
    return next((a, b) for a in sorted(H) for b in sorted(H) if closure((a, b)) == H)


def record(label, H, source, source_kind, source_map=None):
    a, b = gens(H); ell = tuple(range(1, len(next(iter(source.values()))) + 1))
    witness = None
    for y in itertools.product(range(1, 25), repeat=len(ell)):
        A, ds = frame(H, source, y, ell)
        if A is not None and det(A): witness = y, A, ds; break
    assert witness
    y, A, ds = witness
    for g in (a, b):
        Ag, _ = frame(H, source, mv(source[g], y), ell)
        assert Ag == mm(RHO[g], A)
    return {
        "label": label, "order": len(H), "generators": [list(a), list(b)],
        "subgroup_elements": [list(h) for h in sorted(H)], "source_kind": source_kind,
        "source_map": source_map or [], "source_dimension": len(ell), "ell": list(ell),
        "frame_formula": "A(y)=sum_h c(sigma(h^-1)y)rho(h), c=y0/(ell_0*y0+...+ell_r*yr)",
        "twist_equation": "sum_i (A(y)z)_i^2 (A(y)z)_(i+1)=0 over C(P(V))^H",
        "good_reduction": {"prime": P, "zeta11": ZETA, "sqrt5": SQRT5,
                           "source_point": list(y), "denominator_product": math.prod(ds) % P,
                           "frame": A, "frame_determinant": det(A),
                           "specialized_twist_coefficients": twist_coefficients(A)},
    }


def main():
    first, second = two_a5_classes(); records = []
    a5_maps = []
    for label, (a, b, H) in zip(("A5_class_1", "A5_class_2"), (first, second)):
        mapping = iso(a, b, H); a5_maps.append((H, mapping))
        source = {h: SOURCE_A5[mapping[h]] for h in H}
        rows = [{"h": list(h), "permutation": list(mapping[h])} for h in sorted(H)]
        records.append(record(label, H, source, "faithful icosahedral 3-space", rows))

    H, mapping = a5_maps[0]
    involutions = [g for g in H if ORDERS[g] == 2]
    V4 = next(frozenset({ew.fone, a, b, gmul(a, b)}) for i, a in enumerate(involutions)
              for b in involutions[i + 1:] if gmul(a, b) == gmul(b, a))
    A4 = normalizer(V4, H); assert len(A4) == 12
    rows = [{"h": list(h), "permutation": list(mapping[h])} for h in sorted(A4)]
    records.append(record("A4", A4, {h: SOURCE_A5[mapping[h]] for h in A4},
                          "faithful tetrahedral 3-space", rows))

    C11 = frozenset(gpow(ew.ft, i) for i in range(11)); F55 = normalizer(C11); assert len(F55) == 55
    records.append(record("11:5", F55, {h: RHO[h] for h in F55},
                          "faithful irreducible W restricted to 11:5"))

    payload = {"format": "H-SUBGROUP-GENERIC-TWISTS-v1", "base_field": "C",
               "constant_field_model": "Q(zeta_11,sqrt(5)) embedded in C",
               "a5_conjugacy_class_sizes": [11, 11], "records": records}
    (HERE / "twists.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")

    index = {
        "format": "H-SUBGROUP-INDEX-v1",
        "records": [
            {"subgroup": "A5_class_1", "index": 1, "evidence": ["linear section degree 3", "C3-fixed point orbit degree 10 or 20"]},
            {"subgroup": "A5_class_2", "index": 1, "evidence": ["linear section degree 3", "C3-fixed point orbit degree 10 or 20"]},
            {"subgroup": "A4", "index": 1, "evidence": ["linear section degree 3", "C3-fixed point orbit degree 4"]},
            {"subgroup": "11:5", "index": 1, "evidence": ["linear section degree 3", "C11 eigenpoint orbit degree 5"]},
            {"subgroup": "D10", "index": 1, "evidence": ["H-stable contained projective line twists to P1"]},
            {"subgroup": "D12", "index": 1, "evidence": ["H-stable contained projective line twists to P1"]},
        ],
        "valuation_status": "No valuation pointlessness theorem: index obstruction is impossible for every selected subgroup.",
        "warning": "Index one is not a rational point for the four unresolved twists.",
    }
    (HERE / "index_valuation.json").write_text(json.dumps(index, indent=2, sort_keys=True) + "\n")
    for row in records: print(f"PASS {row['label']} det={row['good_reduction']['frame_determinant']}")
    print("H_SUBGROUP_TWISTS_PRODUCER_OK")


if __name__ == "__main__": main()
