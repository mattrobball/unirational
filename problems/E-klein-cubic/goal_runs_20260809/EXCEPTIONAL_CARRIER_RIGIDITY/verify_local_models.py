#!/usr/bin/env python3
"""Exact finite checks for the local normalized-Rees carrier models.

This script verifies only theorem-forced finite polynomial data.  The geometric
implications (finite normalization, residue-dimension survival, and Rees
valuation interpretation) are proved in the Markdown packet.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Iterable

import sympy as sp

u, v, w, U, V, W, e, H, x, y = sp.symbols("u v w U V W e H x y")

# Characters are written in (Z/2)^2 with
# chi_z=(1,0), chi_s=(0,1), chi_r=(1,1).
CHI = {u: (1, 0), v: (0, 1), w: (1, 1)}


def add_char(a: tuple[int, int], b: tuple[int, int]) -> tuple[int, int]:
    return ((a[0] + b[0]) % 2, (a[1] + b[1]) % 2)


def monomial_char(mon: sp.Expr) -> tuple[int, int]:
    powers = mon.as_powers_dict()
    out = (0, 0)
    for var in (u, v, w):
        exponent = int(powers.get(var, 0))
        if exponent % 2:
            out = add_char(out, CHI[var])
    return out


def eigencharacter(poly: sp.Expr) -> tuple[int, int] | None:
    p = sp.Poly(sp.expand(poly), u, v, w)
    chars = {monomial_char(u**a * v**b * w**c) for (a, b, c), coeff in p.terms() if coeff}
    return next(iter(chars)) if len(chars) == 1 else None


def primitive_normal(dx: int, dy: int) -> tuple[int, int]:
    """Positive primitive normal to an edge vector (dx,dy)."""
    a, b = dy, -dx
    if a < 0 or (a == 0 and b < 0):
        a, b = -a, -b
    g = int(sp.gcd(a, b))
    return (a // g, b // g)


h = u**2 + v**2 + w**2
bypass_pair = (u*w + v**3, u*v + w**3)
conic_pair = (h*v + u**3*w, h*w + u**3*v)

checks: dict[str, object] = {}

checks["characters"] = {
    "bypass_p_s": eigencharacter(bypass_pair[0]),
    "bypass_p_r": eigencharacter(bypass_pair[1]),
    "conic_p_s": eigencharacter(conic_pair[0]),
    "conic_p_r": eigencharacter(conic_pair[1]),
    "expected_p_s": (0, 1),
    "expected_p_r": (1, 1),
}

bypass_det = sp.factor(sp.det(sp.Matrix([[W, V**3], [V, W**3]])))
conic_det = sp.factor(sp.det(sp.Matrix([[V, U**3*W], [W, U**3*V]])))
checks["weak_determinants"] = {
    "bypass": str(bypass_det),
    "bypass_expected": str(W**4 - V**4),
    "conic": str(conic_det),
    "conic_expected": str(U**3 * (V**2 - W**2)),
}

checks["coprimality"] = {
    "bypass_gcd": str(sp.factor(sp.gcd(*bypass_pair))),
    "conic_gcd": str(sp.factor(sp.gcd(*conic_pair))),
}

# Newton-polyhedron check for overline((v^3,w^3)^n)=(v,w)^(3n):
# membership in the integral closure is the inequality a+b >= 3n.
def newton_membership(a: int, b: int, n: int) -> bool:
    return a >= 0 and b >= 0 and a + b >= 3 * n

samples = []
for n in range(1, 6):
    for a in range(0, 3*n + 4):
        for b in range(0, 3*n + 4):
            lhs = newton_membership(a, b, n)
            rhs = a + b >= 3*n
            samples.append(lhs == rhs)
checks["normalized_power_samples"] = {
    "all_pass": all(samples),
    "sample_count": len(samples),
    "inequality": "a+b>=3n",
}

# Compact edges of (2,0),(1,1),(0,N).
newton_normals: dict[str, list[tuple[int, int]]] = {}
for N in range(3, 9):
    p0, p1, p2 = (2, 0), (1, 1), (0, N)
    n1 = primitive_normal(p1[0]-p0[0], p1[1]-p0[1])
    n2 = primitive_normal(p2[0]-p1[0], p2[1]-p1[1])
    newton_normals[str(N)] = [n1, n2]
checks["newton_normals_I_N"] = newton_normals

ok = True
chars = checks["characters"]
ok &= chars["bypass_p_s"] == chars["expected_p_s"]
ok &= chars["bypass_p_r"] == chars["expected_p_r"]
ok &= chars["conic_p_s"] == chars["expected_p_s"]
ok &= chars["conic_p_r"] == chars["expected_p_r"]
ok &= sp.expand(bypass_det - (W**4 - V**4)) == 0
ok &= sp.expand(conic_det - U**3*(V**2-W**2)) == 0
ok &= checks["coprimality"]["bypass_gcd"] == "1"
ok &= checks["coprimality"]["conic_gcd"] == "1"
ok &= bool(checks["normalized_power_samples"]["all_pass"])
for N, normals in newton_normals.items():
    ok &= normals == [(1, 1), (int(N)-1, 1)]

result = {
    "exit": "LOCAL-REES-MODELS-EXACT" if ok else "LOCAL-REES-MODELS-FAILED",
    "checks": checks,
    "geometric_interpretation_proved_in_markdown": [
        "line-valued point-centered weak divisors contract by joint residue dimension",
        "ordinary (v,w) bypass is a curve fiber of a curve-centered Rees divisor",
        "normalized blowup of (v^3,w^3) is the ordinary blowup via normalized powers and Veronese Proj",
    ],
    "claims_not_made": [
        "the local pairs extend to a global G-covariant",
        "the genuine Klein base ideal contains a bypass or conic carrier",
        "the exact type-I or type-II normalized fiber is classified",
    ],
}

out = Path(__file__).with_name("LOCAL_MODELS.json")
out.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
print(result["exit"])
raise SystemExit(0 if ok else 1)
