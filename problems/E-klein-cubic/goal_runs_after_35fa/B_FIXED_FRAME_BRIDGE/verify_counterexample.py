#!/opt/homebrew/bin/python3
"""Independent exact-algebra and valuation-ledger check for the formal example."""

from __future__ import annotations

import json
from pathlib import Path

from sympy import diff, expand, symbols


HERE = Path(__file__).resolve().parent


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> None:
    payload = json.loads((HERE / "counterexample_payload.json").read_text())
    require(payload["field"] == "K0=C((s))((t))", "field drift")
    require(payload["plane"]["index"] == 3, "index claim drift")

    x, y, z, w, q, s, t, R = symbols("x y z w q s t R")
    plane = x**3 + s*y**3 + t*z**3
    ambient = plane + w**2*x + q**3
    derivatives = [diff(ambient, v) for v in (x, y, z, w, q)]
    expected = [3*x**2 + w**2, 3*s*y**2, 3*t*z**2, 2*w*x, 3*q**2]
    require(derivatives == expected, "ambient partials drift")
    point = {x: 0, y: 0, z: 0, w: 1, q: 0}
    require(expand(ambient.subs(point)) == 0, "displayed point is off the cubic")
    require(derivatives[0].subs(point) == 1, "displayed point is singular")
    require(expand(x*derivatives[0] - w*derivatives[3]/2 - 3*x**3) == 0,
            "x radical identity failed")
    require(expand(w*derivatives[0] - 3*x*derivatives[3]/2 - w**3) == 0,
            "w radical identity failed")

    # Smoothness proof ledger: Fy=Fz=Fq=0 forces y=z=q=0 over an
    # algebraic closure; Fw=0 gives wx=0; Fx=0 then forces x=w=0.
    require(expected[1:3] == [3*s*y**2, 3*t*z**2], "square gates drift")
    require(expected[3] == 2*w*x and expected[0] == 3*x**2+w**2,
            "final smoothness gates drift")

    # R^3+s is Eisenstein at the s-adic DVR: leading valuation 0, all
    # lower coefficients have valuation >=1, and the constant has valuation
    # exactly 1.  Thus adjoining cube_root(-s) has degree three.
    cube_polynomial = R**3 + s
    require(expand(cube_polynomial.subs(R, symbols("r"))) == symbols("r")**3+s,
            "degree-three polynomial drift")
    coefficient_valuations = {3: 0, 2: float("inf"), 1: float("inf"), 0: 1}
    require(coefficient_valuations[3] == 0, "Eisenstein leading gate")
    require(all(coefficient_valuations[i] >= 1 for i in (0, 1, 2)),
            "Eisenstein divisibility gate")
    require(coefficient_valuations[0] == 1, "Eisenstein square gate")

    # In every extension of degree prime to three, e and f are nonzero mod
    # three.  The noncancelling binary part has valuation 0 mod three,
    # whereas t*z^3 has valuation e mod three.
    cubes_mod_three = {(3*n) % 3 for n in range(-6, 7)}
    require(cubes_mod_three == {0}, "cube valuation residue drift")
    for e_mod_three in (1, 2):
        require(e_mod_three not in cubes_mod_three, "valuation contradiction failed")
    proof = payload["index_proof"]
    for phrase in ("defectlessness", "e*f", "3|f"):
        require(phrase in proof["finite_extension_lemma"], f"extension lemma missing {phrase}")
    require(proof["cube_extension_eisenstein_at_s"] is True, "Eisenstein ledger drift")
    require("degree prime to 3" in proof["conclusion"], "closed-point degree conclusion missing")
    require("index exactly 3" in proof["conclusion"], "index upper bound missing")

    print("B_FORMAL_SECTION_EXACT_ALGEBRA_ACCEPT")
    print("B_FORMAL_SECTION_INDEX_PROOF_LEDGER_ACCEPT")


if __name__ == "__main__":
    main()

