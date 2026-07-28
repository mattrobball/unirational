#!/usr/bin/env python3
"""Generate the exact 15-term universal even-covariant quartic cache.

The output is mechanical data used by the higher-degree landing checkers.
It can always be regenerated from the defining Klein forms and the exact
invariant reconstruction in ``klein_covariant_landing_search.py``.
"""

from __future__ import annotations

import json
from pathlib import Path

import sympy as sp

import klein_covariant_landing_search as search


OUTPUT = Path(__file__).with_name("even_quartic_tensor.json")


def main() -> None:
    tensor = search.quartic_tensor("even")
    polynomial = sp.Poly(tensor, search.u0, search.u1, search.u2)
    assert len(polynomial.terms()) == 15
    payload = {
        "description": "F(u*psi+v*phi+w*f18) in Q[F,D,C][u,v,w]",
        "variables": ["u", "v", "w"],
        "invariants": {"F": 4, "D": 6, "C": 14},
        "terms": {
            ",".join(map(str, powers)): sp.sstr(sp.expand(coefficient))
            for powers, coefficient in polynomial.terms()
        },
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {OUTPUT}")
    print("EVEN_QUARTIC_TENSOR_CACHE_OK terms=15")


if __name__ == "__main__":
    main()
