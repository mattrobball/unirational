#!/usr/bin/env python3
"""Fast exact loader for the cached universal even-covariant quartic."""

from __future__ import annotations

import json
from pathlib import Path

import sympy as sp


F, D, C = sp.symbols("F D C")
u, v, w = sp.symbols("u v w")
CACHE = Path(__file__).with_name("even_quartic_tensor.json")


def load_tensor() -> sp.Expr:
    payload = json.loads(CACHE.read_text())
    assert payload["variables"] == ["u", "v", "w"]
    assert payload["invariants"] == {"F": 4, "D": 6, "C": 14}
    local_symbols = {"F": F, "D": D, "C": C}
    answer = sp.S.Zero
    for encoded_powers, encoded_coefficient in payload["terms"].items():
        powers = tuple(map(int, encoded_powers.split(",")))
        coefficient = sp.sympify(encoded_coefficient, locals=local_symbols)
        answer += coefficient * u**powers[0] * v**powers[1] * w**powers[2]
    answer = sp.expand(answer)
    assert len(sp.Poly(answer, u, v, w).terms()) == 15
    return answer


if __name__ == "__main__":
    tensor = load_tensor()
    print("EVEN_QUARTIC_TENSOR_CACHE_LOAD_OK terms=", len(
        sp.Poly(tensor, u, v, w).terms()
    ), sep="")
