#!/usr/bin/env python3
"""Exact low-degree landing audit for the 16 char-5 progression families.

For each (d,r), write

    f = x^a H^5 + x^b K^5,

where a_j=d*j mod 5 and b_j=a_j+r mod 5.  The C11 weights of H and K
are forced.  At a fixed root degree n their weight spaces are finite and
small.  We rename the fifth powers of their coefficients as independent
variables (Frobenius is bijective over the algebraic closure), expand the
full polynomial identity

    sum_i rho^i(f)^2 rho^(i+1)(f) = 0,

and test every projective chart with H and K both nonzero.  This is a
complete algebraic-closure computation at the stated root degree; it is not
an all-degree cutoff.
"""

from __future__ import annotations

import re
import argparse
import subprocess
import tempfile
from collections import defaultdict
from itertools import combinations_with_replacement
from pathlib import Path


P = 5
W = (1, 9, 4, 3, 5)
SINGULAR = "/opt/homebrew/bin/Singular"


def exponent_basis(degree: int, wanted_weight: int):
    out = []
    for indices in combinations_with_replacement(range(5), degree):
        exponent = [0] * 5
        for index in indices:
            exponent[index] += 1
        if sum(e * w for e, w in zip(exponent, W)) % 11 == wanted_weight:
            out.append(tuple(exponent))
    return tuple(out)


def rho(exponent, power=1):
    power %= 5
    return tuple(exponent[(j - power) % 5] for j in range(5))


def add3(a, b, c):
    return tuple(x + y + z for x, y, z in zip(a, b, c))


def landing_system(d: int, r: int, root_degree: int):
    a = tuple((d * j) % 5 for j in range(5))
    b = tuple((entry + r) % 5 for entry in a)
    weight_a = sum(x * w for x, w in zip(a, W)) % 11
    weight_b = sum(x * w for x, w in zip(b, W)) % 11
    weight_h = 9 * (1 - weight_a) % 11
    weight_k = 9 * (1 - weight_b) % 11
    basis_h = exponent_basis(root_degree, weight_h)
    basis_k = exponent_basis(root_degree, weight_k)

    # Frobenius turns x^u into x^(5u).  Coefficients are renamed A_i,B_j.
    support = []
    for index, u in enumerate(basis_h):
        support.append((tuple(a[j] + 5 * u[j] for j in range(5)), index))
    offset = len(basis_h)
    for index, u in enumerate(basis_k):
        support.append((tuple(b[j] + 5 * u[j] for j in range(5)), offset + index))

    # equations[target exponent][coefficient monomial] = coefficient mod 5.
    equations = defaultdict(lambda: defaultdict(int))
    for shift in range(5):
        fi = [(rho(e, shift), c) for e, c in support]
        fn = [(rho(e, shift + 1), c) for e, c in support]
        for e1, c1 in fi:
            for e2, c2 in fi:
                for e3, c3 in fn:
                    target = add3(e1, e2, e3)
                    monomial = tuple(sorted((c1, c2, c3)))
                    equations[target][monomial] = (
                        equations[target][monomial] + 1
                    ) % P
    clean = []
    for polynomial in equations.values():
        terms = {m: c for m, c in polynomial.items() if c}
        if terms:
            clean.append(terms)
    return a, b, weight_h, weight_k, basis_h, basis_k, tuple(clean)


def render_term(indices, coefficient, names):
    factors = []
    if coefficient != 1:
        factors.append(str(coefficient))
    multiplicities = defaultdict(int)
    for index in indices:
        multiplicities[index] += 1
    for index in sorted(multiplicities):
        exponent = multiplicities[index]
        factors.append(names[index] if exponent == 1 else f"{names[index]}^{exponent}")
    return "*".join(factors) if factors else str(coefficient)


def chart_input(basis_h, basis_k, equations, h_chart, k_invert):
    original = [f"A{i}" for i in range(len(basis_h))] + [
        f"B{i}" for i in range(len(basis_k))
    ]
    variables = [name for i, name in enumerate(original) if i != h_chart] + ["z"]
    substitution = {name: ("1" if i == h_chart else name) for i, name in enumerate(original)}

    rendered = []
    for polynomial in equations:
        terms = []
        for indices, coefficient in sorted(polynomial.items()):
            names = [substitution[name] for name in original]
            # Drop factors specialized to one.
            kept = tuple(index for index in indices if names[index] != "1")
            compressed_names = names
            terms.append(render_term(kept, coefficient, compressed_names))
        rendered.append("+".join(terms) or "0")

    b_name = f"B{k_invert}"
    rendered.append(f"z*{b_name}-1")
    return (
        f"ring R={P},({','.join(variables)}),dp;\n"
        f"ideal I={','.join(rendered)};\n"
        "option(redSB); ideal G=std(I);\n"
        'if (reduce(1,G)==0) { print("UNIT=1"); } else { '
        'print("UNIT=0"); print("DIM="+string(dim(G))); }\n'
        "quit;\n"
    )


def run_chart(source: str):
    with tempfile.TemporaryDirectory(prefix="char5_progression_") as temp:
        path = Path(temp) / "chart.sing"
        path.write_text(source)
        completed = subprocess.run(
            [SINGULAR, "-q", str(path)],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=120,
        )
    match = re.search(r"UNIT=([01])", completed.stdout)
    if not match:
        raise RuntimeError(completed.stdout)
    return match.group(1) == "1", completed.stdout.strip()


def audit_degree(root_degree: int):
    survivors = []
    rows = []
    for d in range(1, 5):
        for r in range(1, 5):
            data = landing_system(d, r, root_degree)
            a, b, wh, wk, basis_h, basis_k, equations = data
            if not basis_h or not basis_k:
                rows.append((d, r, wh, wk, len(basis_h), len(basis_k), 0, "NO_BASIS"))
                continue
            nonempty_charts = []
            for h_chart in range(len(basis_h)):
                for k_invert in range(len(basis_k)):
                    source = chart_input(
                        basis_h, basis_k, equations, h_chart, k_invert
                    )
                    unit, output = run_chart(source)
                    if not unit:
                        nonempty_charts.append((h_chart, k_invert, output))
            status = "NONEMPTY" if nonempty_charts else "EMPTY"
            rows.append((d, r, wh, wk, len(basis_h), len(basis_k), len(equations), status))
            if nonempty_charts:
                survivors.append((d, r, nonempty_charts))
    return rows, survivors


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--degrees",
        default="1,2,3,4",
        help="comma-separated root degrees to audit",
    )
    args = parser.parse_args()
    degrees = tuple(int(value) for value in args.degrees.split(",") if value)
    all_survivors = {}
    for root_degree in degrees:
        rows, survivors = audit_degree(root_degree)
        all_survivors[root_degree] = survivors
        for row in rows:
            print("N", root_degree, "D_R", row[0], row[1], "WH_WK", row[2], row[3],
                  "DIMS", row[4], row[5], "EQS", row[6], row[7])
        print("ROOT_DEGREE", root_degree, "SURVIVOR_FAMILIES", [x[:2] for x in survivors])
    print("F55-CHAR5-PROGRESSION-LOW-DEGREE-AUDIT-DONE")


if __name__ == "__main__":
    main()
