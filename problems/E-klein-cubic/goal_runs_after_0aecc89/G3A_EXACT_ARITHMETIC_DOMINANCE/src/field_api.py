#!/usr/bin/env python3
"""Exact K_proj arithmetic API for G3A (normalized 12-dimensional P0-model).

Elements are length-12 tuples of SymPy rational functions over QQ(t3,t6,t8,t11).
Structure constants are loaded from the certified normalized_kproj_table.json
(bound by hash in INPUT_MANIFEST). Inversion records denominators/opens.
"""

from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Sequence

import sympy as sp

ROOT = Path(__file__).resolve().parents[3]
TABLE_PATH = ROOT / "tmp" / "kproj_arithmetic" / "normalized_kproj_table.json"
PARAMETERS = sp.symbols("t3 t6 t8 t11")
DIM = 12
SECONDARY_DEGREES = (0, 7, 9, 10, 12, 14, 14, 16, 18, 19, 21, 28)
SECONDARY_NAMES = (
    "1",
    "f7",
    "f9",
    "f10",
    "f12",
    "f14",
    "f7^2",
    "f7*f9",
    "f9^2",
    "f9*f10",
    "f7^3",
    "f9^2*f10",
)
PRIMARY_DEGREES = (3, 5, 6, 8, 11)


def _coefficient(rows) -> sp.Expr:
    answer = sp.S.Zero
    for row in rows:
        monomial = sp.Rational(row["numerator"], row["denominator"])
        for parameter, exponent in zip(PARAMETERS, row["exponents"]):
            monomial *= parameter**exponent
        answer += monomial
    return answer


def load_products(path: Path = TABLE_PATH):
    payload = json.loads(path.read_text())
    products = {}
    for row in payload["products"]:
        value = [sp.S.Zero] * DIM
        for entry in row["entries"]:
            value[entry["basis"]] = _coefficient(entry["coefficient"])
        products[(row["left"], row["right"])] = tuple(value)
    if len(products) != 78:
        raise ValueError(f"expected 78 products, got {len(products)}")
    return products, payload


def basis(index: int) -> tuple:
    return tuple(sp.S.One if i == index else sp.S.Zero for i in range(DIM))


def zero() -> tuple:
    return tuple(sp.S.Zero for _ in range(DIM))


def one() -> tuple:
    return basis(0)


def add(left: Sequence, right: Sequence) -> tuple:
    return tuple(a + b for a, b in zip(left, right))


def scale(scalar, value: Sequence) -> tuple:
    return tuple(scalar * item for item in value)


def eq(left: Sequence, right: Sequence) -> bool:
    return all(sp.simplify(a - b) == 0 for a, b in zip(left, right))


def multiply(left: Sequence, right: Sequence, products=None) -> tuple:
    products = products if products is not None else load_products()[0]
    answer = [sp.S.Zero] * DIM
    for i, lc in enumerate(left):
        if lc == 0:
            continue
        for j, rc in enumerate(right):
            if rc == 0:
                continue
            key = tuple(sorted((i, j)))
            scalar = lc * rc
            for k, sc in enumerate(products[key]):
                answer[k] += scalar * sc
    return tuple(map(sp.cancel, answer))


def multiplication_matrix(value: Sequence, products=None):
    products = products if products is not None else load_products()[0]
    cols = [sp.Matrix(multiply(value, basis(c), products)) for c in range(DIM)]
    return sp.Matrix.hstack(*cols)


def trace(value: Sequence, products=None):
    return sp.cancel(multiplication_matrix(value, products).trace())


def norm(value: Sequence, products=None):
    return sp.cancel(multiplication_matrix(value, products).det())


@dataclass(frozen=True)
class InverseRecord:
    value: tuple
    inverse: tuple
    det: sp.Expr
    open_condition: str
    denominators: tuple


def inverse_with_open(value: Sequence, products=None) -> InverseRecord:
    """Invert ``value``; record det (norm of left-multiplication) as open."""

    products = products if products is not None else load_products()[0]
    matrix = multiplication_matrix(value, products)
    det = sp.cancel(matrix.det())
    if det == 0:
        raise ZeroDivisionError("singular multiplication matrix; not a unit")
    inv_col = matrix.inv()[:, 0]
    inv = tuple(map(sp.cancel, (inv_col[i, 0] for i in range(DIM))))
    # Collect rational denominators of inverse coordinates after cancel
    dens = []
    for coord in inv:
        num, den = sp.fraction(sp.together(coord))
        dens.append(sp.cancel(den))
    return InverseRecord(
        value=tuple(value),
        inverse=inv,
        det=det,
        open_condition="det(L_value) != 0 in P0=QQ(t3,t6,t8,t11)",
        denominators=tuple(dens),
    )


def from_secondary_vector(coeffs: Iterable) -> tuple:
    """Build an element from 12 coefficients in the secondary basis over P0."""

    total = zero()
    for i, c in enumerate(coeffs):
        total = add(total, scale(c, basis(i)))
    return total
