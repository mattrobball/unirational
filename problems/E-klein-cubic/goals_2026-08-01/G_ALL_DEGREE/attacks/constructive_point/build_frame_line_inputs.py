#!/usr/bin/env python3
"""Build exact Singular inputs for the ten generic frame lines.

This is a discovery/structural side calculation.  It reconstructs the
binary cubics directly from the authoritative covariant formulas; it does
not read a stored factorization verdict.
"""

from __future__ import annotations

from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[3]
sys.path.insert(0, str(PROBLEM / "tmp" / "generic_twist"))

from phi_coefficients import all_coefficients  # noqa: E402


def singular_polynomial(polynomial: dict[tuple[int, ...], int]) -> str:
    terms: list[str] = []
    for exponents in sorted(polynomial, reverse=True):
        coefficient = polynomial[exponents]
        factors: list[str] = []
        for index, exponent in enumerate(exponents):
            if exponent == 1:
                factors.append(f"x{index}")
            elif exponent:
                factors.append(f"x{index}^{exponent}")
        monomial = "*".join(factors) or "1"
        if not terms:
            terms.append(f"{coefficient}*{monomial}")
        elif coefficient > 0:
            terms.append(f"+{coefficient}*{monomial}")
        else:
            terms.append(f"{coefficient}*{monomial}")
    return "".join(terms) or "0"


def main() -> None:
    names, _, coefficients = all_coefficients()
    index_rows = []
    for left in range(5):
        for right in range(left + 1, 5):
            q0 = coefficients[(left, left, left)]
            q1 = coefficients[(left, left, right)]
            q2 = coefficients[(left, right, right)]
            q3 = coefficients[(right, right, right)]
            expression = (
                f"({singular_polynomial(q0)})"
                f"+t*({singular_polynomial(q1)})"
                f"+t^2*({singular_polynomial(q2)})"
                f"+t^3*({singular_polynomial(q3)})"
            )
            label = f"{names[left]}_{names[right]}"
            script = "\n".join(
                [
                    'LIB "absfact.lib";',
                    "ring r=0,(t,x0,x1,x2,x3,x4),dp;",
                    f"poly q={expression};",
                    f'print("BEGIN {label}");',
                    "list ordinary=factorize(q);",
                    'print("ORDINARY_FACTORS="+string(size(ordinary[1])));',
                    "def A=absFactorize(q);",
                    "setring A;",
                    'print("ABSOLUTE_FACTOR_CLASSES="+string(size(absolute_factors[1])-1));',
                    'print("ABSOLUTE_FACTOR_COUNT="+string(absolute_factors[4]));',
                    f'print("END {label}");',
                    "quit;",
                ]
            )
            path = HERE / f"frame_line_{label}.sing"
            path.write_text(script + "\n")
            index_rows.append(f"{label} {path.name}")
    (HERE / "frame_lines.index").write_text("\n".join(index_rows) + "\n")
    print(f"FRAME_LINE_INPUTS_BUILT count={len(index_rows)}")


if __name__ == "__main__":
    main()
