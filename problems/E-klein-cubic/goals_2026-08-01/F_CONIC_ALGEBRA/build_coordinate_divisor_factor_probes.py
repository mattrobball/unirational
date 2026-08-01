#!/usr/bin/env python3
"""Build modular factor-shape probes for simple base divisors.

These scripts are discovery only.  A useful divisor must later be lifted to
characteristic zero and paired with an exact index-three proof for the
specialized fixed-frame cubic.
"""

from pathlib import Path


HERE = Path(__file__).resolve().parent
PRIMITIVE = HERE / "payload/global_primitive_u_sextic_exact.tsv"
PRIME = 23
VARIABLES = ("A", "B", "Y", "Z", "u")


def terms_after(variable: str, value: int) -> dict[tuple[int, ...], int]:
    index = VARIABLES.index(variable)
    result: dict[tuple[int, ...], int] = {}
    with PRIMITIVE.open() as stream:
        next(stream)
        for line in stream:
            exponents = list(map(int, line.split()[:5]))
            coefficient = int(line.split()[5])
            coefficient *= pow(value, exponents[index], PRIME)
            kept = tuple(exponents[:index] + exponents[index + 1 :])
            result[kept] = (result.get(kept, 0) + coefficient) % PRIME
    return {key: value for key, value in result.items() if value}


def polynomial(terms: dict[tuple[int, ...], int], names: tuple[str, ...]) -> str:
    pieces = []
    for exponents, coefficient in sorted(terms.items(), reverse=True):
        monomial = "*".join(
            name if exponent == 1 else f"{name}^{exponent}"
            for name, exponent in zip(names, exponents)
            if exponent
        ) or "1"
        pieces.append(f"{coefficient}*{monomial}")
    return "+".join(pieces)


def build(label: str, variable: str, value: int) -> Path:
    names = tuple(name for name in VARIABLES if name != variable)
    expression = polynomial(terms_after(variable, value), names)
    rows = [
        f"ring R={PRIME},({','.join(names)}),dp;",
        f"poly P={expression};",
        "list FAC=factorize(P);",
        'print("LABEL=' + label + '");',
        'print("FACTOR_COUNT="+string(size(FAC[1])));',
        "int i;",
        "for (i=1;i<=size(FAC[1]);i++)",
        "{",
        '  print("FACTOR_"+string(i)+"_DEG="+string(deg(FAC[1][i]))+',
        '        "_EXP="+string(FAC[2][i]));',
        "}",
        'print("COORDINATE_DIVISOR_FACTOR_PROBE_DONE");',
        "quit;",
    ]
    path = HERE / f"coordinate_divisor_{label}_p{PRIME}.sing"
    path.write_text("\n".join(rows) + "\n")
    return path


def main() -> None:
    cases = (
        ("A0", "A", 0),
        ("A_gate", "A", 81 * pow(5, -1, PRIME) % PRIME),
        ("B0", "B", 0),
        ("Y0", "Y", 0),
        ("Z0", "Z", 0),
    )
    for label, variable, value in cases:
        path = build(label, variable, value)
        print(f"built={path.name} value={value} bytes={path.stat().st_size}")
    print("COORDINATE_DIVISOR_FACTOR_PROBES_BUILT")


if __name__ == "__main__":
    main()
