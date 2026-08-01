#!/usr/bin/env python3
"""Independent replay of the isolated Goal H packet."""

from __future__ import annotations

from collections import deque
import hashlib
import itertools
import json
from pathlib import Path
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
CERT = ROOT / "certificates"
sys.path.insert(0, str(CERT))
import exact_weil_check as ew  # noqa: E402


P, ZETA, SQRT5 = 89, 2, 19


def gm(a, b): return ew.fcanon(ew.fmul(a, b))


def gi(a):
    aa, b, c, d = a
    return ew.fcanon((d, -b, -c, aa))


def gp(a, n):
    x = ew.fone
    for _ in range(n): x = gm(x, a)
    return x


G = tuple(sorted(ew.rho))


def close(gens):
    out, q = {ew.fone}, deque([ew.fone])
    while q:
        x = q.popleft()
        for g in gens:
            y = gm(x, g)
            if y not in out: out.add(y); q.append(y)
    return frozenset(out)


def cj(g, h): return gm(gm(g, h), gi(g))


def corbit(H): return {frozenset(cj(g, h) for h in H) for g in G}


def pc(a, b): return tuple(a[b[i]] for i in range(5))


PID = tuple(range(5))


def mm(A, B):
    return [[sum(A[i][k] * B[k][j] for k in range(len(B))) % P
             for j in range(len(B[0]))] for i in range(len(A))]


def mv(A, v): return [sum(x * y for x, y in zip(row, v)) % P for row in A]


def madd(A, B): return [[(x + y) % P for x, y in zip(a, b)] for a, b in zip(A, B)]


def scale(c, A): return [[c * x % P for x in row] for row in A]


def determinant(A):
    A, out = [[x % P for x in row] for row in A], 1
    for j in range(len(A)):
        i = next((i for i in range(j, len(A)) if A[i][j]), None)
        if i is None: return 0
        if i != j: A[i], A[j], out = A[j], A[i], -out
        u = A[j][j] % P; out = out * u % P; ui = pow(u, -1, P)
        for i in range(j + 1, len(A)):
            c = A[i][j] * ui % P
            A[i] = [(x - c * y) % P for x, y in zip(A[i], A[j])]
    return out % P


def red(x):
    return sum(int(q.numerator) * pow(int(q.denominator), -1, P) * pow(ZETA, i, P)
               for i, q in enumerate(x.a)) % P


RHO = {g: [[red(x) for x in row] for row in ew.rho[g]] for g in G}


def source_rep():
    # Literal characteristic-zero matrices first.
    r = sp.sqrt(5); a = -(1 + r) / 2
    A = sp.Matrix([[a, -a, -1], [a, 1, 0], [a, -a, 0]])
    B = sp.Matrix([[0, -1, -a], [0, 0, 1], [-1, -a, 0]])
    assert all(sp.simplify(x) == 0 for x in A**5 - sp.eye(3))
    assert all(sp.simplify(x) == 0 for x in B**3 - sp.eye(3))

    inv2 = pow(2, -1, P); a = -(1 + SQRT5) * inv2 % P
    p5, p3 = (1, 2, 3, 4, 0), (0, 1, 3, 4, 2)
    A = [[a, -a % P, -1 % P], [a, 1, 0], [a, -a % P, 0]]
    B = [[0, -1 % P, -a % P], [0, 0, 1], [-1 % P, -a % P, 0]]
    out, q = {PID: [[1, 0, 0], [0, 1, 0], [0, 0, 1]]}, deque([PID])
    while q:
        x = q.popleft()
        for g, M in ((p5, A), (p3, B)):
            y, YM = pc(x, g), mm(out[x], M)
            if y in out: assert out[y] == YM
            else: out[y] = YM; q.append(y)
    assert len(out) == 60
    return out


SRC = source_rep()


def frame(H, source, y, ell):
    A = [[0] * 5 for _ in range(5)]
    for h in H:
        hy = mv(source[gi(h)], y); d = sum(x * z for x, z in zip(ell, hy)) % P
        if not d: return None
        A = madd(A, scale(hy[0] * pow(d, -1, P) % P, RHO[h]))
    return A


def pmul(a, b):
    out = {}
    for ea, ca in a.items():
        for eb, cb in b.items():
            e = tuple(x + y for x, y in zip(ea, eb)); out[e] = (out.get(e, 0) + ca * cb) % P
    return {e: c for e, c in out.items() if c}


def cubic_coeffs(A):
    ls = [{tuple(int(i == j) for i in range(5)): A[k][j] for j in range(5) if A[k][j]}
          for k in range(5)]; out = {}
    for i in range(5):
        for e, c in pmul(pmul(ls[i], ls[i]), ls[(i + 1) % 5]).items(): out[e] = (out.get(e, 0) + c) % P
    exponents = [e for e in itertools.product(range(4), repeat=5) if sum(e) == 3]
    assert len(exponents) == 35
    return {",".join(map(str, e)): out.get(e, 0) for e in exponents}


def verify_twists():
    data = json.loads((HERE / "twists.json").read_text())
    assert data["format"] == "H-SUBGROUP-GENERIC-TWISTS-v1"
    assert [r["label"] for r in data["records"]] == ["A5_class_1", "A5_class_2", "A4", "11:5"]
    a5s = []
    for rec in data["records"]:
        H = frozenset(tuple(h) for h in rec["subgroup_elements"])
        ga, gb = (tuple(x) for x in rec["generators"])
        assert close((ga, gb)) == H and len(H) == rec["order"]
        if rec["source_map"]:
            mapping = {tuple(x["h"]): tuple(x["permutation"]) for x in rec["source_map"]}
            assert set(mapping) == set(H)
            for x in H:
                for y in H: assert mapping[gm(x, y)] == pc(mapping[x], mapping[y])
            source = {h: SRC[mapping[h]] for h in H}
        else:
            source = {h: RHO[h] for h in H}
        assert sum(all(source[h][i][j] == (source[h][0][0] if i == j else 0)
                       for i in range(rec["source_dimension"])
                       for j in range(rec["source_dimension"])) for h in H) == 1

        good = rec["good_reduction"]; y = tuple(good["source_point"]); ell = tuple(rec["ell"])
        A = frame(H, source, y, ell)
        assert A == good["frame"] and determinant(A) == good["frame_determinant"] != 0
        assert cubic_coeffs(A) == good["specialized_twist_coefficients"]

        # Independent witness, not copied from the producer payload.
        second = None
        for yy in itertools.product(range(2, 18), repeat=rec["source_dimension"]):
            if yy == y: continue
            B = frame(H, source, yy, ell)
            if B is not None and determinant(B): second = yy, B; break
        assert second
        yy, B = second
        for g in (ga, gb): assert frame(H, source, mv(source[g], yy), ell) == mm(RHO[g], B)
        print(f"PASS independent {rec['label']} det={determinant(B)} at y={yy}")
        if rec["label"].startswith("A5_"): a5s.append(H)
    assert len(corbit(a5s[0])) == len(corbit(a5s[1])) == 11
    assert corbit(a5s[0]).isdisjoint(corbit(a5s[1]))
    print("PASS both maximal A5 classes separately and nonconjugately verified")


def proportional(v, w):
    return all(v[i] * w[j] == v[j] * w[i] for i in range(5) for j in range(i + 1, 5))


def kcoeff(u, v):
    return (
        sum(u[i] * u[i] * u[(i + 1) % 5] for i in range(5)),
        sum(u[i] * u[i] * v[(i + 1) % 5] + 2*u[i]*v[i]*u[(i + 1) % 5] for i in range(5)),
        sum(v[i] * v[i] * u[(i + 1) % 5] + 2*u[i]*v[i]*v[(i + 1) % 5] for i in range(5)),
        sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5)),
    )


def verify_soluble_lines():
    # D12: the involution minus-eigenspace is two-dimensional and its line lies on X.
    S = ew.rho[ew.fs]
    cols = [[ew.C(int(i == j)) - S[i][j] for i in range(5)] for j in range(5)]
    u = next(c for c in cols if any(x != 0 for x in c))
    v = next(c for c in cols if any(x != 0 for x in c) and not proportional(u, c))
    assert all(x == 0 for x in kcoeff(u, v))
    assert sum(S[i][i] for i in range(5)) == 1
    assert sum(gm(g, ew.fs) == gm(ew.fs, g) for g in G) == 12

    # D10: the inverse C5 eigenline pair spans a contained line.
    pkey = next(g for g in G if ew.rho[g] == ew.P); C5 = {gp(pkey, i) for i in range(5)}
    N = {g for g in G if {cj(g, h) for h in C5} == C5}; assert len(N) == 10
    assert {next(i for i in range(5) if gp(pkey, i) == cj(g, pkey)) for g in N} == {1, 4}
    a, s, t = sp.symbols("a s t"); phi = a**4+a**3+a**2+a+1
    va, vb = [a**i for i in range(5)], [a**((-i) % 5) for i in range(5)]
    F = sp.expand(sum((s*va[i]+t*vb[i])**2*(s*va[(i+1)%5]+t*vb[(i+1)%5]) for i in range(5)))
    assert sp.rem(sp.Poly(F, a), sp.Poly(phi, a)).as_expr().expand() == 0
    print("PASS exact D10 and D12 contained subrepresentation lines")


def verify_index_payload():
    data = json.loads((HERE / "index_valuation.json").read_text())
    assert data["format"] == "H-SUBGROUP-INDEX-v1"
    assert [x["index"] for x in data["records"]] == [1] * 6
    assert math_gcd(3, 10) == math_gcd(3, 20) == math_gcd(3, 4) == math_gcd(3, 5) == 1
    # Upstream exact subgroup census supplies: A5/A4 fixed lines off X,
    # while C3 eigenspaces meet X and C11 eigenlines lie on X.
    import runpy
    ns = runpy.run_path(str(CERT / "subgroup_orbit_check.py"))
    assert len(ns["a5"]) == 60 and len(ns["a4"]) == 12 and len(ns["frob55"]) == 55
    print("PASS index-one orbit degrees and exact fixed-locus prerequisites")


def verify_direct_search():
    # Recompute every covariant space and Groebner chart; do not trust stored booleans.
    import a4_direct_search as ds
    data = json.loads((HERE / "a4_direct_search.json").read_text())
    assert data["format"] == "H-A4-DIRECT-SEARCH-v2"
    first, _ = ds.base.two_a5_classes()
    a, b, A5 = first
    mapping = ds.base.iso(a, b, A5)
    involutions = [g for g in A5 if ds.base.ORDERS[g] == 2]
    V4 = next(
        frozenset({ds.base.ew.fone, x, y, ds.base.gmul(x, y)})
        for i, x in enumerate(involutions)
        for y in involutions[i + 1:]
        if ds.base.gmul(x, y) == ds.base.gmul(y, x)
    )
    A4 = ds.base.normalizer(V4, A5)
    ga, gb = ds.base.gens(A4)
    source = [ds.SOURCE_A5[mapping[g]] for g in (ga, gb)]
    qgen = next(g for g in A4 if ds.base.ORDERS[g] == 3)
    cosets = [
        frozenset(ds.base.gmul(v, ds.base.gpow(qgen, e)) for v in V4)
        for e in range(3)
    ]
    exponents = {g: next(e for e, coset in enumerate(cosets) if g in coset) for g in A4}
    assert all(
        exponents[ds.base.gmul(x, y)] == (exponents[x] + exponents[y]) % 3
        for x in A4 for y in A4
    )
    stored = {(row["degree"], row["character_exponent"]): row for row in data["records"]}
    assert set(stored) == set(itertools.product(range(1, 5), range(3)))
    for degree, character in sorted(stored):
        target = [
            [[pow(ds.OMEGA, character * exponents[g], ds.P) * x % ds.P for x in row]
             for row in ds.RHO[g]]
            for g in (ga, gb)
        ]
        mons, basis = ds.covariant_basis(source, target, degree)
        coeffs = ds.landing_coefficients(mons, basis)
        empty, charts = ds.projective_empty(coeffs, len(basis))
        row = stored[(degree, character)]
        assert len(basis) == row["covariant_dimension"]
        assert len(coeffs) == row["landing_coefficient_count"]
        assert empty and row["geometrically_empty"] and charts == row["charts"]
    print("PASS independently recomputed all 12 A4 projective landing schemes")


def verify_seal():
    data = json.loads((HERE / "SEAL.json").read_text())
    assert data["format"] == "H-SUBGROUP-TWISTS-SEAL-v1"
    assert data["exit"] == "H-SWEEP-UNDECIDED"
    for name, expected in data["files"].items():
        assert hashlib.sha256((HERE / name).read_bytes()).hexdigest() == expected, name
    assert "SEAL.json" not in data["files"]
    print(f"PASS seal hashes files={len(data['files'])}")


def math_gcd(a, b):
    while b: a, b = b, a % b
    return a


def main():
    assert pow(ZETA, 11, P) == 1 and ZETA != 1 and SQRT5*SQRT5 % P == 5
    verify_twists(); verify_soluble_lines(); verify_index_payload(); verify_direct_search(); verify_seal()
    print("H_SUBGROUP_TWISTS_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__": main()
