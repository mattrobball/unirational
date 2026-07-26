#!/usr/bin/env python3
"""Exclude degree-10 landing self-covariants with Macaulay2 over F_23.

The deterministic Reynolds implementation lives in
``modular_covariant_scan.py``.  This checker reconstructs its complete
10-dimensional degree-10 covariant basis and 80 independent sampled necessary
landing equations. Macaulay2 proves that their affine cone has Krull dimension zero,
or equivalently that their projective common zero locus is empty.

Together with the exact characteristic-zero Molien multiplicity and projective
properness over the DVR at ``(23,zeta_11-2)``, this excludes a
characteristic-zero degree-10 landing covariant.  The calculation requires the
``M2`` executable.  The imported Reynolds script uses the direct reduction of
the same cyclotomic matrices checked by ``exact_weil_check.py``.
"""

from __future__ import annotations

import importlib.util
import math
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SOURCE = Path(__file__).with_name("modular_covariant_scan.py")


def load_scan_module():
    spec = importlib.util.spec_from_file_location("modular_covariant_scan", SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
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
        for coefficient, exponents in zip(row, module.monomials(3, 10))
        if coefficient % 23
    )


def main() -> None:
    module = load_scan_module()
    seeds = module.covariant_basis(10, 10)
    echelon, used_points = module.landing_equations(seeds)
    assert len(seeds) == 10
    assert len(echelon) == 80
    assert len(used_points) == 80

    variables = ",".join(f"a{index}" for index in range(10))
    equations = ",\n  ".join(equation(module, row) for _, row in echelon)
    program = f"""R=ZZ/23[{variables},MonomialOrder=>GRevLex];
I=ideal(
  {equations}
  );
print (\"generators=\" | toString numgens I);
print (\"dimension=\" | toString dim I);
scan(3..6, d -> print (\"hilbertFunction[\" | toString d | \"]=\" | toString hilbertFunction(d,R/I)));
"""

    with tempfile.TemporaryDirectory(prefix="klein-degree10-") as directory:
        input_path = Path(directory) / "degree10_landing.m2"
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
    assert "generators=80" in completed.stdout
    assert "dimension=0" in completed.stdout
    assert "hilbertFunction[5]=0" in completed.stdout
    assert math.comb(10 + 2, 3) == 220
    print("PASS no degree-10 homogeneous polynomial self-covariant lands in X")


if __name__ == "__main__":
    main()
