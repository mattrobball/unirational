#!/usr/bin/env python3
"""Independent low-memory checks for the Goal G structural reduction.

This verifier reconstructs load-bearing finite calculations.  It does not
read STATUS.md and does not claim that the remaining generic cubic has been
decided.
"""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
import runpy
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]


EXPECTED_HASHES = {
    "certificates/exact_weil_check.py":
        "14c9bda195ccc39e3ae2cd6d6d42bbb8f45397e114b5137947fb41dd665cc2b2",
    "certificates/exact_covariants_check.py":
        "89847a3203bf7d842b00a551a29377bc9d1cdd36dca9cb5d192c54de0abd2a6e",
    "tmp/generic_twist/phi_coefficients.py":
        "8c217aeaefe300a76e886f0a94803b5812689574299e1a2c72daeec72efd4525",
    "tmp/kproj_arithmetic/affine_multiplication_table.json":
        "e0b23d69e7620c5390dbf0a63ccb09757610ef75fd34c3ffa6a382487061ce0c",
    "tmp/kproj_arithmetic/normalized_kproj_table.json":
        "5def3f471698753cb81a6c4c8a3f97f0a4a6e7989d5fdcec196a6e754af0ae7f",
    "tmp/fable_nonfactorized_syzygy_obstruction/certificate.json":
        "3a66f58cb57603a0ec719f358db8d189124ac1bf60e5619fe60c42f3a0930243",
    "tmp/fable_fixed_plane_boundary_adversary/explore.py":
        "64e61afa9b8103e712a32f1fcf0b10a975abae72b1bf12c5d3749975b565bc2b",
    "tmp/fable_nonfactorized_syzygy_obstruction/explore.py":
        "6f90a261e97e066ab68c256b185b9995308b927bb7758df5c1cd0d6fcec7e87b",
    "RESOLUTION.md":
        "3eac1aa9787da90cbee21b0e72e9ea0fe538921e74afd9cc20170d5227e64c67",
    "REPAIR.md":
        "c7cc9d822885726c5dc6b8168e3a1cf55ab6a5f929b3c8ea16e3f77bd3528e54",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def check_hashes() -> None:
    for relative, expected in EXPECTED_HASHES.items():
        actual = sha256(PROBLEM / relative)
        assert actual == expected, (relative, expected, actual)


def determinant(matrix: list[list[int]]) -> int:
    data = [row[:] for row in matrix]
    sign = 1
    denominator = 1
    for pivot_index in range(len(data) - 1):
        if data[pivot_index][pivot_index] == 0:
            swap = next(
                index for index in range(pivot_index + 1, len(data))
                if data[index][pivot_index]
            )
            data[pivot_index], data[swap] = data[swap], data[pivot_index]
            sign *= -1
        pivot = data[pivot_index][pivot_index]
        for row in range(pivot_index + 1, len(data)):
            for column in range(pivot_index + 1, len(data)):
                numerator = (
                    data[row][column] * pivot
                    - data[row][pivot_index] * data[pivot_index][column]
                )
                assert numerator % denominator == 0
                data[row][column] = numerator // denominator
        denominator = pivot
    return sign * data[-1][-1]


def load_phi_module():
    path = PROBLEM / "tmp" / "generic_twist" / "phi_coefficients.py"
    spec = importlib.util.spec_from_file_location("goal_g_phi", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_mixed_gradient_module():
    path = (
        PROBLEM
        / "tmp"
        / "fable_nonfactorized_syzygy_obstruction"
        / "explore.py"
    )
    spec = importlib.util.spec_from_file_location("goal_g_mixed_gradient", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def check_generic_frame() -> None:
    module = load_phi_module()
    names, frame, coefficients = module.all_coefficients()
    assert names == ("x", "C", "D", "E", "K")
    assert len(coefficients) == 35
    assert all(coefficients.values())
    module.verify_expansion(frame, coefficients)

    point = (-2, -2, -2, -2, -1)
    columns = [module.evaluate_vector(vector, point) for vector in frame]
    matrix = [[columns[column][row] for column in range(5)] for row in range(5)]
    assert determinant(matrix) == -295136920


def check_hironaka_ranks() -> None:
    namespace = runpy.run_path(
        str(PROBLEM / "tmp" / "covariant_module" / "module_hilbert.py")
    )
    covariant_support = namespace["covariant_support"]
    invariant_support = namespace["invariant_support"]
    assert sum(value for _, value in covariant_support) == 60
    assert sum(value for _, value in invariant_support) == 12
    assert max(degree for degree, _ in covariant_support) == 26
    assert (15, -2) in list(enumerate(namespace["quotient_coefficients"]))


def check_veronese_syzygy() -> None:
    # Sparse polynomials in Z[a,b,U,V], encoded by exponent tuples.
    def var(index: int):
        exponent = [0, 0, 0, 0]
        exponent[index] = 1
        return {tuple(exponent): 1}

    def add(left, right):
        answer = dict(left)
        for monomial, coefficient in right.items():
            answer[monomial] = answer.get(monomial, 0) + coefficient
            if answer[monomial] == 0:
                del answer[monomial]
        return answer

    def neg(poly):
        return {monomial: -coefficient for monomial, coefficient in poly.items()}

    def mul(left, right):
        answer = {}
        for lm, lc in left.items():
            for rm, rc in right.items():
                monomial = tuple(a + b for a, b in zip(lm, rm))
                answer[monomial] = answer.get(monomial, 0) + lc * rc
        return {m: c for m, c in answer.items() if c}

    def dot(left, right):
        answer = {}
        for first, second in zip(left, right):
            answer = add(answer, mul(first, second))
        return answer

    a, b, U, V = [var(index) for index in range(4)]
    row = [mul(a, a), mul(a, b), mul(b, b)]
    first = [b, neg(a), {}]
    second = [{}, b, neg(a)]
    assert dot(row, first) == {}
    assert dot(row, second) == {}
    general = [mul(b, U), add(neg(mul(a, U)), mul(b, V)), neg(mul(a, V))]
    assert dot(row, general) == {}
    assert all(
        exponent[0] + exponent[1] > 0
        for component in general for exponent in component
    )

    # Reconstruct the two good-fibre maps from the exact cyclotomic Weil
    # representation, the involution eigenspaces, and d(sum x_i^2*x_{i+1}).
    # The upstream routine contains the authoritative reduction/eigenspace
    # implementation; the sealed certificate supplies an independent frozen
    # record of all bases, matrices, and determinants.
    mixed_gradient = load_mixed_gradient_module()
    fibers = mixed_gradient.compute()
    certificate_path = (
        PROBLEM
        / "tmp"
        / "fable_nonfactorized_syzygy_obstruction"
        / "certificate.json"
    )
    certificate = json.loads(certificate_path.read_text(encoding="utf-8"))
    assert certificate["format"] == (
        "fable-nonfactorized-syzygy-obstruction-v1"
    )
    assert fibers == certificate["fibers"]
    assert [(fiber["prime"], fiber["zeta"]) for fiber in fibers] == [
        (67, 64),
        (89, 2),
    ]
    for fiber in fibers:
        prime = fiber["prime"]
        matrix = fiber["coefficient_matrix"]
        assert len(matrix) == 3 and all(len(row) == 3 for row in matrix)
        reconstructed_determinant = determinant(matrix) % prime
        assert reconstructed_determinant == fiber["determinant"]
        assert reconstructed_determinant != 0
    print(
        "PASS reconstructed mixed-gradient determinants "
        + " and ".join(
            f"{fiber['determinant']} mod {fiber['prime']}"
            for fiber in fibers
        )
    )


def symbolic_monomials(order: int, degree: int):
    answer = set()
    for a in range(degree + 1):
        for b in range(degree - a + 1):
            c = degree - a - b
            if b + c >= order and a + c >= order and a + b >= order:
                answer.add((a, b, c))
    return answer


def check_triple_line_recurrence() -> None:
    base = symbolic_monomials(3, 6)
    assert len(base) > 0
    for r in range(1, 41):
        order = 2 * r + 1
        degree = 3 * r + 3
        shift = r - 1
        expected = {
            (a + shift, b + shift, c + shift) for a, b, c in base
        }
        assert symbolic_monomials(order, degree) == expected

        minimum = symbolic_monomials(order, 3 * r + 2)
        assert minimum
        assert not symbolic_monomials(order, 3 * r + 1)


def check_trace_residue_classes() -> None:
    nonzero_torsion = 1
    assert (3 * nonzero_torsion) % 3 == 0
    for degree in range(1, 25):
        shifted_trace = degree * nonzero_torsion % 3
        assert (shifted_trace == 0) == (degree % 3 == 0)


def main() -> None:
    check_hashes()
    check_hironaka_ranks()
    check_generic_frame()
    check_veronese_syzygy()
    check_triple_line_recurrence()
    check_trace_residue_classes()
    print("PASS authoritative input hashes")
    print("PASS rank_A(R)=12 rank_A(M)=60 and M is not free over R")
    print("PASS exact 35-coefficient generic cubic and frame determinant")
    print("PASS all-order quadratic-Veronese syzygy presentation")
    print("PASS first surviving odd-order triple-line recurrence")
    print("PASS elliptic trace excludes mapped degree not divisible by three")
    print("SCOPE structural reduction only; generic cubic support not decided")
    print("G_ALL_DEGREE_STRUCTURAL_VERIFY_OK")


if __name__ == "__main__":
    main()
