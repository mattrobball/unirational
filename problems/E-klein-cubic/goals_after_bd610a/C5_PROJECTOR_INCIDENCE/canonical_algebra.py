#!/usr/bin/env python3
"""Canonical lazy coordinate API for the installed degree-six algebra.

The exact scalar field entries are represented by sealed Cramer circuits.
This is the same non-interpolated interface used by the authoritative C0
packet: a 36-coordinate vector is embedded in the rectangular splitting
matrix and recovered by ``R^{-1} vec(-)``.

This module deliberately does not assert that a sigma-self-adjoint projector
is a point of the distinguished Fano section.  In fact ``S(0)`` is the unit,
which is the convention obstruction certified by this packet.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Iterable


DIMENSION = 36
SYMMETRIC_DIMENSION = 15
SECTION_NAMES = ("x", "C", "D", "E", "K")
RECTANGLE_BASIS = tuple(
    f"b^{j}*a^{i}" for j in range(6) for i in range(6)
)


@dataclass(frozen=True)
class Circuit:
    """A serializable exact arithmetic-circuit node."""

    op: str
    args: tuple[Any, ...]

    def as_json(self) -> dict[str, Any]:
        def encode(value: Any) -> Any:
            if isinstance(value, Circuit):
                return value.as_json()
            if isinstance(value, tuple):
                return [encode(item) for item in value]
            return value

        return {"op": self.op, "args": [encode(arg) for arg in self.args]}


def _vector(values: Iterable[Any]) -> tuple[Any, ...]:
    answer = tuple(values)
    if len(answer) != DIMENSION:
        raise ValueError(f"expected {DIMENSION} rectangle coordinates")
    return answer


def unit() -> tuple[int, ...]:
    return (1,) + (0,) * (DIMENSION - 1)


def coordinate_symbols(prefix: str = "u") -> tuple[Circuit, ...]:
    return tuple(Circuit("symbol", (f"{prefix}{index}",)) for index in range(DIMENSION))


def embed(coordinates: Iterable[Any]) -> Circuit:
    """Return the exact splitting-matrix circuit sum x_k b^j a^i."""

    return Circuit("rectangle_linear_combination", _vector(coordinates))


def recover(matrix: Circuit) -> tuple[Circuit, ...]:
    """Recover all rectangle coordinates by the sealed Cramer oracle."""

    return tuple(
        Circuit("cramer_coordinate", ("R", index, matrix))
        for index in range(DIMENSION)
    )


def multiply(left: Iterable[Any], right: Iterable[Any]) -> tuple[Circuit, ...]:
    return recover(Circuit("matrix_multiply", (embed(left), embed(right))))


def sigma(value: Iterable[Any]) -> tuple[Circuit, ...]:
    matrix = embed(value)
    return recover(Circuit("symplectic_adjoint", ("Q(x)", matrix)))


def reduced_trace(value: Iterable[Any]) -> Circuit:
    return Circuit("matrix_trace", (embed(value),))


def S(index: int) -> tuple[Any, ...]:
    """Return coordinates of S_i=Q(x)^(-1)Q(V_i(x))."""

    if not 0 <= index < len(SECTION_NAMES):
        raise IndexError(index)
    if index == 0:
        # V_0=x, hence S_x=Q(x)^(-1)Q(x)=1 exactly.
        return unit()
    target = Circuit(
        "matrix_multiply",
        (Circuit("matrix_inverse", ("Q(x)",)), f"Q({SECTION_NAMES[index]}(x))"),
    )
    return recover(target)


def api_descriptor() -> dict[str, Any]:
    return {
        "format": "c5-canonical-lazy-algebra-api-v1",
        "dimension": DIMENSION,
        "symmetric_dimension": SYMMETRIC_DIMENSION,
        "basis": list(RECTANGLE_BASIS),
        "operations": {
            "multiply": "R^-1 vec(embed(x) embed(y))",
            "sigma": "R^-1 vec(Q(x)^-1 embed(x)^t Q(x))",
            "reduced_trace": "trace(embed(x))",
            "S_i": "R^-1 vec(Q(x)^-1 Q(V_i(x)))",
        },
        "section_names": list(SECTION_NAMES),
        "unit_coordinates": list(unit()),
        "S_x_coordinates": list(S(0)),
        "marker": "C5_CANONICAL_ALGEBRA_OK",
    }

