#!/usr/bin/env python3
"""Good-reduction search for landing covariants in each frame 3-plane.

For a triple U,V,W among the primitive covariants x,C,D,E,K, a homogeneous
point of total source degree N has the form

    A*U + B*V + C*W,

where A,B,C are invariant forms of degrees N-deg(U), etc.  This script builds
complete invariant bases by Reynolds averaging at the good cyclotomic prime
(23,zeta_11-2), evaluates exact landing equations, and asks Macaulay2 for the
dimension of their homogeneous ideal.  Dimension zero means that the
projective locus is empty over the algebraic closure of F_23.  Properness then
excludes the corresponding characteristic-zero ansatz.

This is necessarily a bounded test.  It says nothing about invariant rational
coefficients of unbounded numerator/denominator degree.
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations, permutations
import importlib.util
import math
from pathlib import Path
import subprocess
import sys
import tempfile

import numpy as np

from generic_frame_planes_specialization import cov_c, cov_d, cov_e, cov_k


ROOT = Path(__file__).resolve().parents[1]
SCAN_PATH = ROOT / "certificates" / "modular_covariant_scan.py"
SPEC = importlib.util.spec_from_file_location("klein_modular_scan", SCAN_PATH)
assert SPEC is not None and SPEC.loader is not None
SCAN = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = SCAN
SPEC.loader.exec_module(SCAN)

P = SCAN.P
GROUP = SCAN.GROUP
FRAME_DEGREES = {"x": 1, "C": 4, "D": 5, "E": 6, "K": 7}

# Adler's Hironaka decomposition: parameter degrees 3,5,6,8,11 and the
# twelve secondary degrees below.
PARAMETER_DEGREES = (3, 5, 6, 8, 11)
SECONDARY_DEGREES = (0, 7, 9, 10, 12, 14, 14, 16, 18, 19, 21, 28)


def compositions(degree: int, variables: int = 5):
    def visit(prefix, remaining, slots):
        if slots == 1:
            yield prefix + (remaining,)
            return
        for exponent in range(remaining + 1):
            yield from visit(prefix + (exponent,), remaining-exponent, slots-1)
    yield from visit((), degree, variables)


def invariant_dimension(degree: int) -> int:
    if degree < 0:
        return 0
    answer = 0
    for secondary in SECONDARY_DEGREES:
        remainder = degree - secondary
        if remainder < 0:
            continue
        counts = [0] * (remainder + 1)
        counts[0] = 1
        for parameter in PARAMETER_DEGREES:
            for value in range(parameter, remainder + 1):
                counts[value] += counts[value-parameter]
        answer += counts[remainder]
    return answer


RNG = np.random.default_rng(2026072503)
SELECTION_POINTS = [RNG.integers(0, P, size=5, dtype=np.int64)
                    for _ in range(24)]


def transformed_point(point):
    return np.einsum("gij,j->gi", GROUP, point) % P


TRANSFORMED_SELECTION = [transformed_point(p) for p in SELECTION_POINTS]


def invariant_value(exponents, transformed):
    values = np.ones(len(GROUP), dtype=np.int64)
    for coordinate, exponent in enumerate(exponents):
        if exponent:
            values = values * np.array(
                [pow(int(value), exponent, P)
                 for value in transformed[:, coordinate]], dtype=np.int64
            ) % P
    return int(np.sum(values, dtype=np.int64) % P)


def add_echelon_row(basis, row):
    remainder = np.array(row, dtype=np.int64) % P
    for pivot, old in basis:
        if remainder[pivot]:
            remainder = (remainder - remainder[pivot] * old) % P
    nonzero = np.flatnonzero(remainder)
    if not len(nonzero):
        return False
    pivot = int(nonzero[0])
    remainder = remainder * pow(int(remainder[pivot]), -1, P) % P
    basis.append((pivot, remainder))
    return True


@dataclass(frozen=True)
class InvariantSeed:
    degree: int
    exponents: tuple[int, ...]


INVARIANT_BASES = {}


def invariant_basis(degree):
    if degree in INVARIANT_BASES:
        return INVARIANT_BASES[degree]
    dimension = invariant_dimension(degree)
    if dimension == 0:
        INVARIANT_BASES[degree] = []
        return []
    echelon = []
    result = []
    for exponents in compositions(degree):
        row = [invariant_value(exponents, transformed)
               for transformed in TRANSFORMED_SELECTION]
        if add_echelon_row(echelon, row):
            result.append(InvariantSeed(degree, exponents))
            if len(result) == dimension:
                INVARIANT_BASES[degree] = result
                return result
    raise AssertionError((degree, len(result), dimension))


def frame_at(point):
    integer_point = tuple(int(v) for v in point)
    return {
        "x": np.array(integer_point, dtype=np.int64) % P,
        "C": np.array(cov_c(integer_point), dtype=np.int64) % P,
        "D": np.array(cov_d(integer_point), dtype=np.int64) % P,
        "E": np.array(cov_e(integer_point), dtype=np.int64) % P,
        "K": np.array(cov_k(integer_point), dtype=np.int64) % P,
    }


def coefficient_term(coefficient, exponents):
    coefficient %= P
    factors = []
    if coefficient != 1 or not any(exponents):
        factors.append(str(coefficient))
    for index, exponent in enumerate(exponents):
        if exponent == 1:
            factors.append(f"a{index}")
        elif exponent:
            factors.append(f"a{index}^{exponent}")
    return "*".join(factors)


def m2_dimension(rows, variables_count):
    coefficient_monomials = list(compositions(3, variables_count))
    equations = []
    for _, row in rows:
        equation = "+".join(
            coefficient_term(int(coefficient), exponents)
            for coefficient, exponents in zip(row, coefficient_monomials)
            if coefficient % P
        )
        assert equation
        equations.append(equation)
    variables = ",".join(f"a{i}" for i in range(variables_count))
    program = f"""R=ZZ/{P}[{variables},MonomialOrder=>GRevLex];
I=ideal(
  {',\n  '.join(equations)}
  );
print ("dimension=" | toString dim I);
print ("generators=" | toString numgens I);
"""
    with tempfile.TemporaryDirectory(prefix="klein-plane-") as directory:
        path = Path(directory) / "check.m2"
        path.write_text(program)
        completed = subprocess.run(
            ["M2", "--script", str(path)], cwd=ROOT, text=True,
            capture_output=True, check=False,
        )
    if completed.returncode:
        raise RuntimeError(completed.stdout + completed.stderr)
    dimension_line = next(line for line in completed.stdout.splitlines()
                          if line.startswith("dimension="))
    return int(dimension_line.split("=", 1)[1])


def test_case(triple, total_degree, maximum_points=180):
    candidates = []
    for name in triple:
        coefficient_degree = total_degree - FRAME_DEGREES[name]
        for seed in invariant_basis(coefficient_degree):
            candidates.append((name, seed))
    dimension = len(candidates)
    if dimension == 0:
        return 0, 0, 0
    rows = []
    stagnant = 0
    points = [RNG.integers(0, P, size=5, dtype=np.int64)
              for _ in range(maximum_points)]
    for point in points:
        transformed = transformed_point(point)
        frame = frame_at(point)
        values = []
        for name, seed in candidates:
            scalar = invariant_value(seed.exponents, transformed)
            values.append(scalar * frame[name] % P)
        row = SCAN.cubic_coefficient_row(np.stack(values))
        if add_echelon_row(rows, row):
            stagnant = 0
        else:
            stagnant += 1
        # A subset is enough if it already cuts out the origin.  Waiting for
        # 30 stagnant points avoids invoking M2 after every new equation.
        if stagnant >= 30:
            break
    m2dim = m2_dimension(rows, dimension)
    return dimension, len(rows), m2dim


def determinant_mod_p(matrix):
    result = 0
    for permutation in permutations(range(5)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(5) for j in range(i + 1, 5)
        )
        term = math.prod(
            int(matrix[permutation[column], column]) for column in range(5)
        )
        result += -term if inversions % 2 else term
    return result % P


def main(argv):
    lower = int(argv[1]) if len(argv) > 1 else 11
    upper = int(argv[2]) if len(argv) > 2 else 14
    # The reduced primitive frame remains a frame.  This makes products of
    # independent invariant forms with distinct primitive columns a direct
    # sum, over the invariant fraction field as well as polynomially.
    witness = (10, 11, 17, 21, 0)
    reduced_frame = frame_at(witness)
    matrix = np.stack([reduced_frame[name] for name in FRAME_DEGREES], axis=1)
    echelon = []
    for row in matrix:
        add_echelon_row(echelon, row)
    assert len(echelon) == 5
    determinant = determinant_mod_p(matrix)
    assert determinant == 3
    print(
        f"reduced_frame_witness={witness} rank=5 determinant={determinant}",
        flush=True,
    )
    triples = list(combinations(FRAME_DEGREES, 3))
    for total_degree in range(lower, upper + 1):
        print(f"total_degree={total_degree}", flush=True)
        for triple in triples:
            dimension, equations, m2dim = test_case(triple, total_degree)
            if 11 <= total_degree <= 14:
                assert m2dim == 0
            print(
                f"  {''.join(triple)} candidates={dimension} "
                f"equations={equations} affine_cone_dimension={m2dim}",
                flush=True,
            )
    if lower == 11 and upper == 14:
        print(
            "PASS all ten three-column invariant-polynomial ansatz loci "
            "are projectively empty in total degrees 11 through 14",
            flush=True,
        )


if __name__ == "__main__":
    main(sys.argv)
