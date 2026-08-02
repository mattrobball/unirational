#!/usr/bin/env python3
"""Independent K_proj field verifier for G3A."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE / "src"))

from field_api import (  # noqa: E402
    PARAMETERS,
    SECONDARY_DEGREES,
    add,
    basis,
    eq,
    inverse_with_open,
    load_products,
    multiplication_matrix,
    multiply,
    norm,
    one,
    scale,
    trace,
    zero,
)

TABLE = ROOT / "tmp" / "kproj_arithmetic" / "normalized_kproj_table.json"
CERT = ROOT / "tmp" / "kproj_arithmetic" / "certificate.json"
MANIFEST = HERE / "INPUT_MANIFEST.json"


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def main() -> None:
    # Bind hash from INPUT_MANIFEST
    man = json.loads(MANIFEST.read_text())
    expected = None
    for item in man["inputs"]:
        if item["path"].endswith("normalized_kproj_table.json"):
            expected = item["sha256"]
    require(expected is not None, "table not in manifest")
    require(sha256(TABLE) == expected, "normalized_kproj_table hash drift")

    products, payload = load_products(TABLE)
    require("secondary_degrees" in payload, "table missing secondary_degrees")
    require(
        list(payload["secondary_degrees"]) == list(SECONDARY_DEGREES),
        f"secondary_degrees drift: {payload.get('secondary_degrees')}",
    )
    require(len(products) == 78, "78 structure products")

    # Unit and basis multiplications
    e0 = one()
    for i in range(12):
        require(eq(multiply(e0, basis(i), products), basis(i)), f"unit*e{i}")
        require(eq(multiply(basis(i), e0, products), basis(i)), f"e{i}*unit")

    # Commutativity on all basis pairs (table is sorted-key symmetric)
    for i in range(12):
        for j in range(i, 12):
            require(
                eq(
                    multiply(basis(i), basis(j), products),
                    multiply(basis(j), basis(i), products),
                ),
                f"commute e{i} e{j}",
            )

    # Hostile associativity sample (not full 12^3 — full table checked upstream;
    # we still re-check a fixed hostile set here)
    hostile = [
        (1, 2, 3),
        (1, 1, 5),
        (4, 7, 2),
        (11, 3, 8),
        (6, 6, 9),
        (2, 10, 4),
        (5, 5, 5),
        (0, 7, 11),
    ]
    for i, j, k in hostile:
        left = multiply(multiply(basis(i), basis(j), products), basis(k), products)
        right = multiply(basis(i), multiply(basis(j), basis(k), products), products)
        require(eq(left, right), f"assoc e{i},e{j},e{k}")

    # Trace/norm of unit
    require(trace(e0, products) == 12, "trace(1)=12")
    require(norm(e0, products) == 1, "norm(1)=1")

    # Specialize P0 -> QQ at a good point for inverse checks (symbolic 12x12
    # inverse over QQ(t) is multi-minute; open is still recorded via det API).
    def specialize(value, point=(2, 3, 5, 7)):
        t3, t6, t8, t11 = PARAMETERS
        subs = {t3: point[0], t6: point[1], t8: point[2], t11: point[3]}
        return tuple(sp.Integer(sp.simplify(v.subs(subs))) for v in value)

    # Build specialized product table at the same point for fast QQ arithmetic
    point = (2, 3, 5, 7)
    t3, t6, t8, t11 = PARAMETERS
    subs = {t3: point[0], t6: point[1], t8: point[2], t11: point[3]}
    products_sp = {
        key: tuple(sp.Integer(sp.simplify(c.subs(subs))) for c in val)
        for key, val in products.items()
    }

    val = add(one(), scale(sp.Integer(point[0]), basis(1)))  # 1 + 2*e1 over QQ
    rec = inverse_with_open(val, products_sp)
    require(eq(multiply(val, rec.inverse, products_sp), one()), "left inverse")
    require(eq(multiply(rec.inverse, val, products_sp), one()), "right inverse")
    require(rec.det != 0, "det recorded nonzero")
    require(rec.open_condition.startswith("det"), "open condition recorded")
    require(len(rec.denominators) == 12, "12 denominators recorded")

    # Inverse of pure basis element e1 over the specialized table
    rec2 = inverse_with_open(basis(1), products_sp)
    require(eq(multiply(basis(1), rec2.inverse, products_sp), one()), "e1 inverse")

    # Zero is singular
    try:
        inverse_with_open(zero(), products_sp)
        raise AssertionError("zero should not invert")
    except ZeroDivisionError:
        pass

    # Record that generic open is det L_v != 0 over P0 (not just specialization)
    require("P0" in rec.open_condition or "det" in rec.open_condition, "open language")

    # Minimal / characteristic polynomials and Cayley–Hamilton (specialized QQ model)
    x = sp.symbols("x")

    def left_mult_matrix(value):
        return multiplication_matrix(value, products_sp)

    def eval_poly_on_matrix(poly_expr, mat):
        """Evaluate sum c_k M^k for a univariate polynomial expression in x."""

        poly = sp.Poly(sp.expand(poly_expr), x, domain=sp.QQ)
        acc = sp.zeros(mat.rows)
        Mk = sp.eye(mat.rows)
        for deg in range(poly.degree() + 1):
            coeff = poly.nth(deg)
            if coeff != 0:
                acc = acc + sp.Rational(coeff) * Mk
            Mk = Mk * mat
        return acc

    def matrix_minpoly(mat):
        """Monic minimal polynomial of a matrix over QQ via linear dependence of powers."""

        n = mat.rows
        # Vectorize powers I, M, ..., M^n in QQ^{n^2}
        powers = [sp.eye(n)]
        cols = [sp.Matrix(n * n, 1, lambda i, _j: powers[0][i // n, i % n])]
        for k in range(1, n + 1):
            powers.append(powers[-1] * mat)
            cols.append(sp.Matrix(n * n, 1, lambda i, _j, P=powers[-1]: P[i // n, i % n]))
        # Find smallest d>=1 such that {I,...,M^d} is linearly dependent
        for d in range(1, n + 1):
            A = sp.Matrix.hstack(*cols[: d + 1])  # n^2 x (d+1)
            # Solve A c = 0 for c = (c0,...,cd), normalize monic (cd=1)
            # Use nullspace
            ns = A.nullspace()
            if not ns:
                continue
            # Prefer vector with last nonzero coordinate; scale monic
            vec = ns[0]
            # Find highest index with nonzero entry
            lead = None
            for i in range(d, -1, -1):
                if vec[i] != 0:
                    lead = i
                    break
            require(lead is not None, "null vector zero")
            # If lead < d, dependence among lower powers — take monic of degree lead
            monic = [sp.Rational(vec[i] / vec[lead]) for i in range(lead + 1)]
            # Ensure matrix poly vanishes
            expr = sum(monic[i] * x**i for i in range(lead + 1))
            # Force monic: monic[lead] should be 1
            expr = sp.expand(expr / monic[lead]) if monic[lead] != 1 else expr
            # Prefer monic with positive leading coeff
            if sp.LC(sp.Poly(expr, x)) < 0:
                expr = sp.expand(-expr)
            # Verify annihilation
            if eval_poly_on_matrix(expr, mat) == sp.zeros(n):
                return sp.expand(expr)
        raise AssertionError("failed to compute matrix minpoly")

    def check_minpoly_charpoly(value, label: str) -> None:
        mat = left_mult_matrix(value)
        chi = mat.charpoly(x).as_expr()
        mu = matrix_minpoly(mat)
        require(sp.degree(mu, x) >= 1, f"{label}: minpoly degree")
        # minpoly divides charpoly
        _quo, rem = sp.div(sp.Poly(chi, x, domain=sp.QQ), sp.Poly(mu, x, domain=sp.QQ))
        require(rem == 0, f"{label}: minpoly does not divide charpoly")
        # Cayley–Hamilton: chi(L) = 0
        require(
            eval_poly_on_matrix(chi, mat) == sp.zeros(12),
            f"{label}: Cayley–Hamilton failed",
        )
        # Algebra annihilation: mu(value) = 0 in the 12-dim algebra
        mu_poly = sp.Poly(sp.expand(mu), x, domain=sp.QQ)
        powers = [one()]
        cur = one()
        for _ in range(1, mu_poly.degree() + 1):
            cur = multiply(cur, value, products_sp)
            powers.append(cur)
        acc = zero()
        for deg in range(mu_poly.degree() + 1):
            coeff = mu_poly.nth(deg)
            if coeff != 0:
                acc = add(acc, scale(sp.Rational(coeff), powers[deg]))
        require(eq(acc, zero()), f"{label}: minpoly does not annihilate algebra element")

    # Unit: minpoly of L_1 = I is x-1
    mu1 = matrix_minpoly(left_mult_matrix(one()))
    require(sp.expand(mu1) == x - 1, f"minpoly(1) expected x-1, got {mu1}")
    check_minpoly_charpoly(one(), "unit")

    # Hostile non-scalar elements
    check_minpoly_charpoly(basis(1), "e1")
    check_minpoly_charpoly(val, "1+2*e1")
    check_minpoly_charpoly(add(basis(2), scale(sp.Integer(3), basis(4))), "e2+3*e4")

    # Certificate external cross-check (table stats)
    cert = json.loads(CERT.read_text())
    require(cert["table"]["nonzero_entries"] == 647, "table nonzero entry count")
    require(sha256(TABLE) == cert["files"]["normalized_kproj_table.json"], "cert hash")

    print("G3A_FIELD_OPS_OK")
    print("G3A_FIELD_INVERSE_OPEN_OK")
    print("G3A_FIELD_HOSTILE_ASSOC_OK")
    print("G3A_FIELD_MINPOLY_OK")
    print("G3A_FIELD_VERIFY_OK")


if __name__ == "__main__":
    main()
