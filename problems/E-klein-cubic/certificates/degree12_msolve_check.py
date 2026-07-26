#!/usr/bin/env python3
"""Exclude degree-12 landing self-covariants with exact msolve over F_23.

The checker reconstructs the complete 16-dimensional Reynolds basis and 143
independent sampled necessary landing equations directly from
``modular_covariant_scan``.
It then computes the homogeneous grevlex leading ideal with exact finite-field
linear algebra.  The leading ideal contains every degree-5 monomial, so the
projective landing locus is empty.  The calculation requires ``msolve``.
"""

from __future__ import annotations

import argparse
import importlib.util
import re
import subprocess
import sys
import tempfile
import time
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SOURCE = Path(__file__).with_name("modular_covariant_scan.py")
PRIME = 23
DEGREE = 12
DIMENSION = 16
EXPECTED_LANDING_RANK = 143


def weak_compositions(total: int, slots: int = 5) -> list[tuple[int, ...]]:
    result: list[tuple[int, ...]] = []

    def visit(prefix: tuple[int, ...], remaining: int, left: int) -> None:
        if left == 1:
            result.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, left - 1)

    visit((), total, slots)
    return result


COEFFICIENT_MONOMIALS = weak_compositions(3, DIMENSION)
assert len(COEFFICIENT_MONOMIALS) == 816


def load_scan_module():
    spec = importlib.util.spec_from_file_location("degree12_direct_weil", SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)

    # The authoritative helper uses a filtered product. Check its order before
    # replacing the exponential coefficient-space enumeration by recursion.
    for degree in range(5):
        for variables in range(1, 7):
            assert weak_compositions(degree, variables) == module.monomials(
                degree, variables
            )
    module.monomials = weak_compositions
    assert module.monomials(3, DIMENSION) == COEFFICIENT_MONOMIALS
    return module


def term(coefficient: int, exponents: tuple[int, ...]) -> str:
    coefficient %= PRIME
    factors: list[str] = []
    if coefficient != 1:
        factors.append(str(coefficient))
    for index, exponent in enumerate(exponents):
        if exponent == 1:
            factors.append(f"a{index}")
        elif exponent:
            factors.append(f"a{index}^{exponent}")
    return "*".join(factors)


def polynomial(row) -> str:
    terms = [
        term(int(coefficient), exponents)
        for coefficient, exponents in zip(row, COEFFICIENT_MONOMIALS)
        if int(coefficient) % PRIME
    ]
    assert terms
    return "+".join(terms)


def parse_leading_monomials(output: str) -> list[tuple[int, ...]]:
    assert "#field characteristic: 23" in output
    assert "#length of basis:      3840 elements" in output
    start = output.index("[") + 1
    stop = output.rindex("]")
    expressions = [part.strip() for part in output[start:stop].split(",")]
    expressions = [expression for expression in expressions if expression]
    result: list[tuple[int, ...]] = []
    for expression in expressions:
        exponents = [0] * DIMENSION
        factors = re.findall(r"a(\d+)\^(\d+)", expression)
        assert factors
        canonical = "*".join(f"a{index}^{exponent}" for index, exponent in factors)
        assert canonical == expression, f"could not parse {expression!r}"
        for raw_index, raw_exponent in factors:
            index, exponent = int(raw_index), int(raw_exponent)
            assert 0 <= index < DIMENSION and exponent > 0
            assert exponents[index] == 0
            exponents[index] = exponent
        result.append(tuple(exponents))
    assert len(result) == 3840
    assert len(set(result)) == len(result)
    return result


def hilbert_function_from_leads(
    leads: list[tuple[int, ...]], maximum_degree: int
) -> list[int]:
    values: list[int] = []
    for degree in range(maximum_degree + 1):
        monomials = weak_compositions(degree, DIMENSION)
        monomial_set = set(monomials)
        covered: set[tuple[int, ...]] = set()
        for lead in leads:
            lead_degree = sum(lead)
            if lead_degree > degree:
                continue
            for quotient in weak_compositions(degree - lead_degree, DIMENSION):
                covered.add(tuple(a + b for a, b in zip(lead, quotient)))
        assert covered.issubset(monomial_set)
        values.append(len(monomials) - len(covered))
    return values


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--threads", type=int, default=4)
    parser.add_argument("--timeout", type=int, default=120)
    args = parser.parse_args()
    assert args.threads > 0 and args.timeout > 0

    module = load_scan_module()
    seeds = module.covariant_basis(DEGREE, DIMENSION)
    echelon, used_points = module.landing_equations(seeds, extra_points=1200)
    assert module.P == PRIME
    assert len(module.GROUP) == 660
    assert len(seeds) == DIMENSION
    assert len(echelon) == EXPECTED_LANDING_RANK
    assert len(used_points) == EXPECTED_LANDING_RANK
    polynomials = [polynomial(row) for _, row in echelon]
    variables = ",".join(f"a{index}" for index in range(DIMENSION))
    solver_input = variables + "\n23\n" + ",\n".join(polynomials) + "\n"

    with tempfile.TemporaryDirectory(prefix="klein-degree12-") as directory:
        source = Path(directory) / "homogeneous.in"
        answer = Path(directory) / "leading.out"
        source.write_text(solver_input)
        command = [
            "msolve",
            "-f",
            str(source),
            "-o",
            str(answer),
            "-t",
            str(args.threads),
            "-v",
            "2",
            "-g",
            "1",
            "-l",
            "2",
            "--random-seed",
            "0",
        ]
        started = time.monotonic()
        completed = subprocess.run(
            command,
            cwd=ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=args.timeout,
            check=False,
        )
        elapsed = time.monotonic() - started
        assert completed.returncode == 0, completed.stdout
        assert answer.is_file()
        leading_output = answer.read_text()

    assert "homogeneous input?               1" in completed.stdout
    assert "linear algebra option            2" in completed.stdout
    assert "size of basis                  3840" in completed.stdout
    assert "max. matrix data              55962 x 14376" in completed.stdout
    leads = parse_leading_monomials(leading_output)
    degree_tally = Counter(map(sum, leads))
    assert degree_tally == {3: 143, 4: 813, 5: 2884}
    hilbert = hilbert_function_from_leads(leads, 5)
    assert hilbert == [1, 16, 136, 673, 1589, 0]
    assert sum(hilbert) == 2415

    print(f"basisRank={len(seeds)} landingRank={len(echelon)}")
    print(f"PASS exact msolve Groebner basis seconds={elapsed:.3f}")
    print(f"leading_monomial_degrees={dict(sorted(degree_tally.items()))}")
    print(f"hilbertFunction[0..5]={hilbert}")
    print("PASS no degree-12 homogeneous polynomial self-covariant lands in X")


if __name__ == "__main__":
    main()
