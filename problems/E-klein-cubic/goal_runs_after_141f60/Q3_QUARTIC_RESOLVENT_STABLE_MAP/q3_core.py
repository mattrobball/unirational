#!/usr/bin/env python3
"""Shared exact arithmetic for Goal Q3 (primitive quartic / resolvent / deg-8).

Independent of produce.py.  Verifiers may import this module.
"""

from __future__ import annotations

import hashlib
import itertools
import os
import resource
from collections import deque
from pathlib import Path
from typing import Iterable

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

# ---------------------------------------------------------------------------
# Klein cubic (split model)
# ---------------------------------------------------------------------------

N = 5
X_SYMS = sp.symbols("x0:5")
KLEIN_F = sum(X_SYMS[i] ** 2 * X_SYMS[(i + 1) % N] for i in range(N))
GRAD_F = [sp.diff(KLEIN_F, x) for x in X_SYMS]

# Pairings of four letters {0,1,2,3}: the cubic resolvent set.
PAIRINGS: tuple[tuple[tuple[int, int], tuple[int, int]], ...] = (
    ((0, 1), (2, 3)),
    ((0, 2), (1, 3)),
    ((0, 3), (1, 2)),
)
PAIRING_LABELS = ("01|23", "02|13", "03|12")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def peak_rss_mb() -> float:
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    if os.uname().sysname == "Darwin":
        return rss / (1024 * 1024)
    return rss / 1024.0


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[i]] for i in range(len(right)))


def inverse_perm(perm: tuple[int, ...]) -> tuple[int, ...]:
    out = [0] * len(perm)
    for src, tgt in enumerate(perm):
        out[tgt] = src
    return tuple(out)


def closure(generators: Iterable[tuple[int, ...]]) -> set[tuple[int, ...]]:
    gens = tuple(generators)
    identity = tuple(range(len(gens[0])))
    seen = {identity}
    queue = deque([identity])
    while queue:
        cur = queue.popleft()
        for g in gens:
            nxt = compose(g, cur)
            if nxt not in seen:
                seen.add(nxt)
                queue.append(nxt)
    return seen


def parity(perm: tuple[int, ...]) -> int:
    inv = 0
    n = len(perm)
    for i in range(n):
        for j in range(i + 1, n):
            if perm[i] > perm[j]:
                inv += 1
    return inv % 2


def orbit(start, generators, action):
    seen = {start}
    queue = deque([start])
    while queue:
        cur = queue.popleft()
        for g in generators:
            nxt = action(g, cur)
            if nxt not in seen:
                seen.add(nxt)
                queue.append(nxt)
    return seen


# ---------------------------------------------------------------------------
# A4 / S4 on four letters
# ---------------------------------------------------------------------------


def s4_group() -> set[tuple[int, ...]]:
    return set(itertools.permutations(range(4)))


def a4_group() -> set[tuple[int, ...]]:
    return {g for g in s4_group() if parity(g) == 0}


def act_on_pairing(perm: tuple[int, ...], pairing_index: int) -> int:
    """Induced action of S4 on the three pairings."""
    (a, b), (c, d) = PAIRINGS[pairing_index]
    image_pairs = (
        frozenset({perm[a], perm[b]}),
        frozenset({perm[c], perm[d]}),
    )
    for j, ((x, y), (u, v)) in enumerate(PAIRINGS):
        target = (frozenset({x, y}), frozenset({u, v}))
        if set(image_pairs) == set(target):
            return j
    raise RuntimeError("pairing image missing")


def pairing_homomorphism(group: set[tuple[int, ...]]) -> dict[tuple[int, ...], tuple[int, ...]]:
    """Map each group element to its permutation of the three pairings."""
    result = {}
    for g in group:
        result[g] = tuple(act_on_pairing(g, i) for i in range(3))
    return result


def resolvent_image_group(group: set[tuple[int, ...]]) -> set[tuple[int, ...]]:
    return set(pairing_homomorphism(group).values())


# ---------------------------------------------------------------------------
# Secant residual geometry on the cubic
# ---------------------------------------------------------------------------


def evaluate_poly(poly, point):
    return sp.expand(poly.subs(dict(zip(X_SYMS, point))))


def third_point(left, right):
    """Third intersection of the chord through two points of the cubic."""
    a = sum(evaluate_poly(g, left) * right[i] for i, g in enumerate(GRAD_F))
    b = sum(evaluate_poly(g, right) * left[i] for i, g in enumerate(GRAD_F))
    out = tuple(sp.expand(b * left[i] - a * right[i]) for i in range(N))
    if not any(out):
        raise ValueError("contained or degenerate chord")
    return out


def hyperplane_of(points) -> tuple:
    matrix = sp.Matrix(points)
    kernel = matrix.nullspace()
    if len(kernel) != 1:
        raise ValueError(f"expected full-span quartet, got kernel size {len(kernel)}")
    return tuple(kernel[0])


def resolvent_triple(points):
    chords = {}
    for i, j in itertools.combinations(range(4), 2):
        chords[(i, j)] = third_point(points[i], points[j])
    return tuple(third_point(chords[a], chords[b]) for a, b in PAIRINGS)


def on_cubic(point) -> bool:
    return evaluate_poly(KLEIN_F, point) == 0


def projective_rank(points) -> int:
    return sp.Matrix([list(p) for p in points]).rank()


def clear_content(point):
    """Scale an exact rational point to primitive integer coordinates."""
    vals = [sp.Integer(sp.nsimplify(v)) for v in point]
    content = sp.gcd([int(v) for v in vals if v != 0] or [1])
    if content == 0:
        content = 1
    return tuple(int(v // content) for v in vals)


# ---------------------------------------------------------------------------
# Modular Klein geometry
# ---------------------------------------------------------------------------


def klein_mod(point, p: int) -> int:
    s = 0
    for i in range(N):
        s = (s + (point[i] * point[i] % p) * point[(i + 1) % N]) % p
    return s


def grad_mod(point, p: int):
    g = [0] * N
    for i in range(N):
        # d/dx_i of sum_j x_j^2 x_{j+1}: 2 x_i x_{i+1} + x_{i-1}^2
        g[i] = (
            2 * point[i] * point[(i + 1) % N] + point[(i - 1) % N] * point[(i - 1) % N]
        ) % p
    return g


def third_point_mod(left, right, p: int):
    gl = grad_mod(left, p)
    gr = grad_mod(right, p)
    a = sum(gl[i] * right[i] for i in range(N)) % p
    b = sum(gr[i] * left[i] for i in range(N)) % p
    out = tuple((b * left[i] - a * right[i]) % p for i in range(N))
    if all(v == 0 for v in out):
        return None
    return out


def mat_rank_mod(rows, p: int) -> int:
    if not rows:
        return 0
    m = [list(r)[:] for r in rows]
    r, c = len(m), len(m[0])
    rank = 0
    col = 0
    while rank < r and col < c:
        pivot = None
        for i in range(rank, r):
            if m[i][col] % p:
                pivot = i
                break
        if pivot is None:
            col += 1
            continue
        m[rank], m[pivot] = m[pivot], m[rank]
        inv = pow(m[rank][col], -1, p)
        m[rank] = [(v * inv) % p for v in m[rank]]
        for i in range(r):
            if i == rank:
                continue
            factor = m[i][col] % p
            if factor:
                m[i] = [(m[i][j] - factor * m[rank][j]) % p for j in range(c)]
        rank += 1
        col += 1
    return rank


def hyperplane_mod(points, p: int):
    # nullspace of 4x5 matrix of points
    rows = [list(pt) for pt in points]
    # Gauss–Jordan for one-dimensional right kernel
    m = [row[:] for row in rows]
    r, c = 4, 5
    rank = 0
    col_used = []
    col = 0
    while rank < r and col < c:
        pivot = None
        for i in range(rank, r):
            if m[i][col] % p:
                pivot = i
                break
        if pivot is None:
            col += 1
            continue
        m[rank], m[pivot] = m[pivot], m[rank]
        inv = pow(m[rank][col], -1, p)
        m[rank] = [(v * inv) % p for v in m[rank]]
        for i in range(r):
            if i == rank:
                continue
            factor = m[i][col] % p
            if factor:
                m[i] = [(m[i][j] - factor * m[rank][j]) % p for j in range(c)]
        col_used.append(col)
        rank += 1
        col += 1
    free = [j for j in range(c) if j not in col_used]
    if len(free) != 1 or rank != 4:
        return None
    f = free[0]
    vec = [0] * c
    vec[f] = 1
    for i, pc in enumerate(col_used):
        vec[pc] = (-m[i][f]) % p
    return tuple(vec)


def resolvent_triple_mod(points, p: int):
    chords = {}
    for i, j in itertools.combinations(range(4), 2):
        t = third_point_mod(points[i], points[j], p)
        if t is None:
            return None
        chords[(i, j)] = t
    out = []
    for a, b in PAIRINGS:
        t = third_point_mod(chords[a], chords[b], p)
        if t is None:
            return None
        out.append(t)
    return tuple(out)


# ---------------------------------------------------------------------------
# Boundary incidence: line + conic / three lines through a triple
# ---------------------------------------------------------------------------


def line_residual_on_cubic(p, q):
    """Third residual of the line through p,q on the cubic (exact)."""
    return third_point(p, q)


def plane_through(p, q, r):
    """Linear forms spanning the dual of span{p,q,r}; return one hyperplane eq
    in P4 that vanishes on the plane (codim-2 linear space needs two forms).
    Returns two independent linear forms cutting out the plane, or None.
    """
    mat = sp.Matrix([list(p), list(q), list(r)])
    if mat.rank() < 3:
        return None
    # nullspace of 3x5 is 2-dimensional: two linear equations
    ns = mat.nullspace()
    if len(ns) != 2:
        return None
    return tuple(tuple(v) for v in ns)


def plane_cubic_residual_line_conic(points_on_plane_cubic, p, q, r):
    """On a plane cubic C = X ∩ Π, the unique plane cubic through three points
    decomposes (when reducible) as line+conic.  Check the three lines of the
    triangle for containment in X.
    """
    results = {}
    pairs = ((0, 1, 2), (0, 2, 1), (1, 2, 0))
    labels = ("line_01", "line_02", "line_12")
    pts = (p, q, r)
    for (i, j, k), lab in zip(pairs, labels):
        try:
            residual = third_point(pts[i], pts[j])
            # Contained line iff residual is ill-defined; already raised.
            # Check whether residual equals pts[k] (triangle residual).
            collinear_with_third = (
                projective_rank([pts[i], pts[j], pts[k]]) == 2
            )
            residual_equals_third = projective_rank([residual, pts[k]]) == 1
            results[lab] = {
                "residual_equals_third": bool(residual_equals_third),
                "three_points_collinear": bool(collinear_with_third),
                "residual": [str(v) for v in residual],
            }
        except ValueError as exc:
            results[lab] = {"error": str(exc), "contained_chord": True}
    return results


# ---------------------------------------------------------------------------
# C3 / S3 actions on 8-sets: orbit arithmetic for monodromy gates
# ---------------------------------------------------------------------------


def c3_orbit_partitions(n: int = 8) -> list[dict]:
    """Integer solutions f + 3t = n with f,t >= 0 (fixed pts + 3-orbits)."""
    out = []
    for t in range(n // 3 + 1):
        f = n - 3 * t
        if f >= 0:
            out.append(
                {
                    "fixed_points": f,
                    "three_orbits": t,
                    "forces_fixed_point": f > 0,
                    "min_fixed": f,
                }
            )
    return out


def s3_orbit_type_exists_fixed_point_free(n: int = 8) -> bool:
    """Whether S3 can act fixed-point-freely on an n-set.

    Orbit sizes under S3 divide 6 and are 1,2,3, or 6 (stabilizer possibilities).
    Fixed-point-free means no orbit of size 1.
    """
    # Solve 2a + 3b + 6c = n, a,b,c >= 0 (no size-1 orbits).
    for c in range(n // 6 + 1):
        for b in range((n - 6 * c) // 3 + 1):
            rem = n - 6 * c - 3 * b
            if rem >= 0 and rem % 2 == 0:
                return True
    return False


def s3_orbit_partitions(n: int = 8) -> list[dict]:
    parts = []
    for c in range(n // 6 + 1):
        for b in range((n - 6 * c) // 3 + 1):
            rem = n - 6 * c - 3 * b
            if rem < 0 or rem % 2:
                continue
            a2 = rem // 2
            for a1 in range(0, 1):  # we list fixed-point-free and with fixed later
                pass
            # also allow fixed points (size-1 orbits)
            for f in range(n - 6 * c - 3 * b + 1):
                rem2 = n - 6 * c - 3 * b - f
                if rem2 >= 0 and rem2 % 2 == 0:
                    parts.append(
                        {
                            "fixed_points": f,
                            "two_orbits": rem2 // 2,
                            "three_orbits": b,
                            "six_orbits": c,
                            "forces_fixed_point": f > 0,
                        }
                    )
    # unique by tuple
    uniq = {}
    for p in parts:
        key = (p["fixed_points"], p["two_orbits"], p["three_orbits"], p["six_orbits"])
        uniq[key] = p
    return list(uniq.values())


# ---------------------------------------------------------------------------
# PSL(2,11) simplicity certificate (for linear disjointness)
# ---------------------------------------------------------------------------


def psl2_11_order() -> int:
    prime = 11
    infinity = prime
    translation = tuple(
        infinity if v == infinity else (v + 1) % prime for v in range(prime + 1)
    )
    inv_vals = []
    for v in range(prime + 1):
        if v == infinity:
            inv_vals.append(0)
        elif v == 0:
            inv_vals.append(infinity)
        else:
            inv_vals.append((-pow(v, -1, prime)) % prime)
    inversion = tuple(inv_vals)
    group = closure((translation, inversion))
    return len(group)


def common_quotient_orders(a_orders: set[int], b_orders: set[int]) -> set[int]:
    return a_orders & b_orders


A4_QUOTIENT_ORDERS = {1, 3, 12}
S4_QUOTIENT_ORDERS = {1, 2, 6, 24}
PSL211_QUOTIENT_ORDERS = {1, 660}  # simple


BINDING_INPUT_PATHS = [
    "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/STATUS.md",
    "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/COMPLETION_AUDIT.md",
    "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/fixed_curve_bridge/THEOREM.md",
    "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/fixed_curve_bridge/STATUS.md",
    "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/SOURCE_MANIFEST.json",
    "goals_2026-08-01/Q_SCHUR_DESCENT/STATUS.md",
    "goals_2026-08-01/Q_SCHUR_DESCENT/COMPLETION_AUDIT.md",
    "goals_2026-08-01/Q_SCHUR_DESCENT/QUARTIC_FRONTIER.md",
    "goals_2026-08-01/Q_SCHUR_DESCENT/quartic_frontier.json",
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/quartic_descent/field_certificate.json",
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/quartic_descent/geometry_certificate.json",
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/curve_incidence/incidence_certificate.json",
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/incidence_generality/REPORT.md",
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/incidence_splitting/REPORT.md",
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/root_secant/REPORT.md",
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/fixed_curve_bridge/THEOREM.md",
    "goals_after_bd610a/M3_SARKISOV_SECTION/STATUS.md",
    "goals_after_bd610a/M3_SARKISOV_SECTION/DEGREE4.md",
    "goals_after_bd610a/M3_SARKISOV_SECTION/SECTION_RESIDUAL.md",
    "goal_runs_after_35fa/S19_MARKED_CURVE/CODEX_ROOT_20260801_7B4E/STATUS.md",
    "goal_runs_after_35fa/S19_MARKED_CURVE/CODEX_ROOT_20260801_7B4E_CONT2/STATUS.md",
    "goals_after_141f60/GOAL_Q3_QUARTIC_RESOLVENT_STABLE_MAP.md",
]
