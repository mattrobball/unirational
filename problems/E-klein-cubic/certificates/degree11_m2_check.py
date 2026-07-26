#!/usr/bin/env python3
"""Exclude degree-11 landing self-covariants with Macaulay2 over F_23.

The deterministic Reynolds implementation lives in
``modular_covariant_scan.py`` and directly reduces the cyclotomic Weil
matrices checked by ``exact_weil_check.py``.  This checker reconstructs the
complete 12-dimensional degree-11 covariant basis and 108 independent sampled
necessary landing equations. Macaulay2 proves that the resulting homogeneous ideal
has Artinian quotient, hence empty projective zero locus.

Together with the exact characteristic-zero Molien multiplicity and
projective properness over the DVR at ``(23,zeta_11-2)``, this excludes a
characteristic-zero degree-11 landing covariant.  The calculation requires
the ``M2`` executable.
"""

from __future__ import annotations

import importlib.util
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SOURCE = Path(__file__).with_name("modular_covariant_scan.py")
DEGREE = 11
DIMENSION = 12


def efficient_monomials(degree: int, variables: int = 5) -> list[tuple[int, ...]]:
    """Weak compositions in the certificate's lexicographic product order."""

    result: list[tuple[int, ...]] = []

    def visit(prefix: tuple[int, ...], remaining: int, slots: int) -> None:
        if slots == 1:
            result.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, slots - 1)

    visit((), degree, variables)
    return result


def load_scan_module():
    spec = importlib.util.spec_from_file_location("degree11_modular_scan", SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)

    # Check the ordering against the authoritative product implementation on
    # small cases, then avoid its exponential scan in 12 coefficient variables.
    for degree in range(5):
        for variables in range(1, 7):
            assert efficient_monomials(degree, variables) == module.monomials(
                degree, variables
            )
    module.monomials = efficient_monomials
    return module


def term(coefficient: int, exponents: tuple[int, ...]) -> str:
    factors = []
    coefficient %= 23
    if coefficient != 1 or not any(exponents):
        factors.append(str(coefficient))
    for index, exponent in enumerate(exponents):
        if exponent == 1:
            factors.append(f"a{index}")
        elif exponent:
            factors.append(f"a{index}^{exponent}")
    return "*".join(factors)


def equation(module, row) -> str:
    return "+".join(
        term(int(coefficient), exponents)
        for coefficient, exponents in zip(
            row, efficient_monomials(3, DIMENSION)
        )
        if coefficient % 23
    )


def main() -> None:
    module = load_scan_module()
    seeds = module.covariant_basis(DEGREE, DIMENSION)
    echelon, used_points = module.landing_equations(seeds)
    assert len(module.GROUP) == 660
    assert len(seeds) == DIMENSION
    assert len(echelon) == 108
    assert len(used_points) == 108

    variables = ",".join(f"a{index}" for index in range(DIMENSION))
    equations = ",\n  ".join(equation(module, row) for _, row in echelon)
    program = f"""R=ZZ/23[{variables},MonomialOrder=>GRevLex];
I=ideal(
  {equations}
  );
print (\"basisRank={len(seeds)}\");
print (\"generators=\" | toString numgens I);
print (\"dimension=\" | toString dim I);
scan(3..6, d -> print (\"hilbertFunction[\" | toString d | \"]=\" | toString hilbertFunction(d,R/I)));
"""

    with tempfile.TemporaryDirectory(prefix="klein-degree11-") as directory:
        input_path = Path(directory) / "degree11_landing.m2"
        input_path.write_text(program)
        completed = subprocess.run(
            ["M2", "--script", str(input_path)],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )

    if completed.stdout:
        print(completed.stdout, end="")
    if completed.stderr:
        print(completed.stderr, file=sys.stderr, end="")
    assert completed.returncode == 0
    assert "basisRank=12" in completed.stdout
    assert "generators=108" in completed.stdout
    assert "dimension=0" in completed.stdout
    assert "hilbertFunction[5]=0" in completed.stdout
    print("PASS no degree-11 homogeneous polynomial self-covariant lands in X")


if __name__ == "__main__":
    main()
