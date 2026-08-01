#!/usr/bin/env python3
"""Produce the exact generic Klein cubic in the Hironaka field basis.

The 35 polar coefficients of F([x C D E K]a) are reduced over QQ against
Adler's A-basis of the invariant ring.  The normalized output is a cubic
over the projective invariant field in a certified 12-element basis.
"""

from __future__ import annotations

from collections import defaultdict
from fractions import Fraction
import json
from pathlib import Path
import re
import subprocess
import sys


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "tmp/generic_twist"))
sys.path.insert(0, str(PROBLEM / "tmp/kproj_arithmetic"))

from phi_coefficients import all_coefficients  # noqa: E402
from core import (  # noqa: E402
    PRIMARY_DEGREES,
    PRIMARY_NAMES,
    SECONDARY_DEGREES,
    forms,
    module_columns,
)


FRAME_DEGREES = (1, 4, 5, 6, 7)
FRAME_NAMES = ("x", "C", "D", "E", "K")


def m2_polynomial(polynomial: dict[tuple[int, ...], int]) -> str:
    terms = []
    for exponents in sorted(polynomial, reverse=True):
        coefficient = polynomial[exponents]
        factors = []
        for variable, exponent in enumerate(exponents):
            if exponent == 1:
                factors.append(f"x{variable}")
            elif exponent:
                factors.append(f"x{variable}^{exponent}")
        monomial = "*".join(factors) or "1_R"
        if not terms:
            terms.append(f"{coefficient}*{monomial}")
        elif coefficient > 0:
            terms.append(f"+{coefficient}*{monomial}")
        else:
            terms.append(f"{coefficient}*{monomial}")
    return "".join(terms) or "0_R"


def parse_rows(text: str) -> list[list[Fraction]]:
    text = text.strip()
    assert text.startswith("{{") and text.endswith("}}"), text[:120]
    body = text[2:-2]
    rows = body.split("}, {") if body else []
    return [[Fraction(token.strip()) for token in row.split(",")] for row in rows]


def primary_label(exponents: tuple[int, ...]) -> str:
    factors = []
    for name, exponent in zip(PRIMARY_NAMES, exponents):
        if exponent == 1:
            factors.append(name)
        elif exponent:
            factors.append(f"{name}^{exponent}")
    return "*".join(factors) or "1"


def main() -> None:
    names, _, coefficients = all_coefficients()
    assert tuple(names) == FRAME_NAMES
    grouped: dict[int, list[tuple[tuple[int, int, int], dict]]] = defaultdict(list)
    for triple, polynomial in coefficients.items():
        degree = sum(FRAME_DEGREES[index] for index in triple)
        assert {sum(exponents) for exponents in polynomial} == {degree}
        grouped[degree].append((triple, polynomial))

    lines = ["R=QQ[x0,x1,x2,x3,x4,MonomialOrder=>GRevLex];"]
    for degree, polynomial in sorted(forms().items()):
        lines.append(f"f{degree}={m2_polynomial(polynomial)};")
    lines.extend(
        [
            "b0=1_R;",
            "b1=f7;",
            "b2=f9;",
            "b3=f10;",
            "b4=f12;",
            "b5=f14;",
            "b6=f7^2;",
            "b7=f7*f9;",
            "b8=f9^2;",
            "b9=f9*f10;",
            "b10=f7^3;",
            "b11=f9^2*f10;",
        ]
    )

    manifest = []
    for block, degree in enumerate(sorted(grouped)):
        basis = module_columns(degree)
        targets = grouped[degree]
        expressions = [m2_polynomial(item[2]) for item in basis]
        expressions.extend(m2_polynomial(polynomial) for _, polynomial in targets)
        n_basis = len(basis)
        n_targets = len(targets)
        lines.extend(
            [
                f'print("BEGIN degree={degree} basis={n_basis} targets={n_targets}");',
                f"P{block}=matrix{{{{{','.join(expressions)}}}}};",
                f"(MON{block},COE{block})=coefficients P{block};",
                f"CB{block}=COE{block}_{{0..{n_basis - 1}}};",
                f"CT{block}=COE{block}_{{{n_basis}..{n_basis + n_targets - 1}}};",
                f"Q{block}=CT{block}//CB{block};",
                f"assert(CB{block}*Q{block}==CT{block});",
                f'print("DATA degree={degree} " | toString entries Q{block});',
                f'print("END degree={degree}");',
            ]
        )
        manifest.append(
            {
                "degree": degree,
                "basis": [
                    {
                        "secondary": secondary,
                        "primary_exponents": list(exponents),
                        "label": f"{primary_label(exponents)}*b{secondary}",
                    }
                    for secondary, exponents, _ in basis
                ],
                "targets": [list(triple) for triple, _ in targets],
            }
        )
    lines.append('print("DONE");')

    script = HERE / "generic_cubic_reduction.m2"
    script.write_text("\n".join(lines) + "\n")
    completed = subprocess.run(
        ["/opt/homebrew/bin/M2", "--script", str(script)],
        cwd=PROBLEM,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    log = completed.stdout
    (HERE / "generic_cubic_reduction.log").write_text(log)
    assert "DONE" in log

    solved = {}
    for match in re.finditer(r"^DATA degree=(\d+) (\{\{.*\}\})$", log, re.MULTILINE):
        degree = int(match.group(1))
        assert degree not in solved
        solved[degree] = parse_rows(match.group(2))
    assert set(solved) == set(grouped)

    output = []
    for block in manifest:
        degree = block["degree"]
        rows = solved[degree]
        require_rows = len(block["basis"])
        require_columns = len(block["targets"])
        assert len(rows) == require_rows
        assert all(len(row) == require_columns for row in rows)
        for target_index, triple_list in enumerate(block["targets"]):
            entries = []
            normalized_entries = []
            for basis_item, row in zip(block["basis"], rows):
                coefficient = row[target_index]
                if not coefficient:
                    continue
                primary = tuple(basis_item["primary_exponents"])
                secondary = int(basis_item["secondary"])
                entries.append(
                    {
                        "secondary": secondary,
                        "primary_exponents": list(primary),
                        "numerator": coefficient.numerator,
                        "denominator": coefficient.denominator,
                    }
                )
                # f3^a3 f5^a5 f6^a6 f8^a8 f11^a11 / tau^weight
                # = t3^(a3+2a5) t6^a6 t8^a8 t11^a11.
                a3, a5, a6, a8, a11 = primary
                normalized_entries.append(
                    {
                        "secondary": secondary,
                        "projective_exponents": [a3 + 2 * a5, a6, a8, a11],
                        "numerator": coefficient.numerator,
                        "denominator": coefficient.denominator,
                    }
                )
            triple = tuple(triple_list)
            output.append(
                {
                    "triple": triple_list,
                    "label": "*".join(FRAME_NAMES[index] for index in triple),
                    "degree": degree,
                    "entries": entries,
                    "normalized_entries": normalized_entries,
                }
            )

    payload = {
        "schema": "G_GENERIC_KLEIN_CUBIC_V1",
        "base_field": "QQ",
        "primary_names": list(PRIMARY_NAMES),
        "primary_degrees": list(PRIMARY_DEGREES),
        "secondary_degrees": list(SECONDARY_DEGREES),
        "projective_base": ["t3", "t6", "t8", "t11"],
        "projective_basis": [f"b{i}/tau^{degree}" for i, degree in enumerate(SECONDARY_DEGREES)],
        "frame_names": list(FRAME_NAMES),
        "frame_degrees": list(FRAME_DEGREES),
        "coefficient_count": len(output),
        "coefficients": sorted(output, key=lambda item: item["triple"]),
        "manifest": manifest,
        "scope": "Exact finite generic cubic; no rational point or pointlessness verdict.",
    }
    (HERE / "generic_cubic.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"G_GENERIC_CUBIC_PRODUCED coefficients={len(output)} degrees={sorted(grouped)}")


if __name__ == "__main__":
    main()

