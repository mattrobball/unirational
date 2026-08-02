#!/usr/bin/env python3
"""Shared exact arithmetic for Goal C6 (five-form matrix / Palatini model).

Producer and verifiers may import this module for common finite-field and
sparse-polynomial helpers.  Independent verifiers still rebuild every claimed
identity from sealed C5 / Codex sources rather than trusting producer output.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import resource
import time
from fractions import Fraction
from itertools import combinations, combinations_with_replacement
from pathlib import Path
from typing import Any, Iterable, Sequence


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent

PAIRS = tuple(combinations(range(6), 2))
PAIR_INDEX = {pair: index for index, pair in enumerate(PAIRS)}
SECTION_NAMES = ("x", "C", "D", "E", "K")
MONOMS4 = tuple(combinations_with_replacement(range(6), 4))


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def peak_rss_mb() -> float:
    usage = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    # macOS reports bytes; Linux reports kilobytes.
    if usage > 10**9:  # heuristic: already bytes
        return usage / (1024 * 1024)
    # On Darwin ru_maxrss is bytes; on Linux KiB. Detect via platform.
    import sys

    if sys.platform == "darwin":
        return usage / (1024 * 1024)
    return usage / 1024.0


def monom4_exponents() -> list[tuple[int, ...]]:
    exps: list[tuple[int, ...]] = []
    for mon in MONOMS4:
        e = [0] * 6
        for index in mon:
            e[index] += 1
        exps.append(tuple(e))
    return exps


EXP4 = monom4_exponents()


def primitive_root_11(prime: int) -> int:
    assert (prime - 1) % 11 == 0
    return next(value for value in range(2, prime) if pow(value, 11, prime) == 1)


def q11_mod(coefficient, prime: int, zeta: int) -> int:
    total = 0
    for power, (numerator, denominator) in enumerate(coefficient):
        total = (
            total
            + (int(numerator) % prime)
            * pow(int(denominator) % prime, -1, prime)
            * pow(zeta, power, prime)
        ) % prime
    return total


def eval_poly_vector_mod(vector, point: Sequence[int], prime: int) -> list[int]:
    out = [0] * 5
    for coordinate, polynomial in enumerate(vector):
        value = 0
        for term in polynomial:
            mon = int(term["coefficient"]) % prime
            for exponent, coordinate_value in zip(term["exponents"], point):
                mon = mon * pow(int(coordinate_value) % prime, int(exponent), prime) % prime
            value = (value + mon) % prime
        out[coordinate] = value
    return out


def build_forms_mod(
    q_linear,
    frame_vectors: dict[str, Any],
    point: Sequence[int],
    prime: int,
    zeta: int,
) -> list[list[list[int]]]:
    forms: list[list[list[int]]] = []
    for name in SECTION_NAMES:
        vector = eval_poly_vector_mod(frame_vectors[name], point, prime)
        matrix = [[0] * 6 for _ in range(6)]
        for row in range(6):
            for column in range(6):
                entry = 0
                for index in range(5):
                    entry = (
                        entry
                        + q11_mod(q_linear[row][column][index], prime, zeta)
                        * vector[index]
                    ) % prime
                matrix[row][column] = entry
        forms.append(matrix)
    return forms


def matrix_times_vector(matrix: Sequence[Sequence[int]], vector: Sequence[int], prime: int):
    return [
        sum(int(matrix[row][column]) * int(vector[column]) for column in range(len(vector)))
        % prime
        for row in range(len(matrix))
    ]


def M_of(forms: Sequence[Sequence[Sequence[int]]], u: Sequence[int], prime: int):
    """Return the 5 x 6 matrix with rows u^t A_i."""

    return [matrix_times_vector(form, u, prime) for form in forms]


def rank_mod(matrix: Sequence[Sequence[int]], prime: int) -> int:
    work = [[int(entry) % prime for entry in row] for row in matrix]
    if not work:
        return 0
    rows = len(work)
    cols = len(work[0])
    rank = 0
    for column in range(cols):
        pivot = next((row for row in range(rank, rows) if work[row][column] % prime), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], -1, prime)
        work[rank] = [entry * inverse % prime for entry in work[rank]]
        for row in range(rows):
            if row != rank and work[row][column] % prime:
                factor = work[row][column]
                work[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(work[row], work[rank])
                ]
        rank += 1
        if rank == rows:
            break
    return rank


def det_mod(matrix: Sequence[Sequence[int]], prime: int) -> int:
    work = [[int(entry) % prime for entry in row] for row in matrix]
    n = len(work)
    determinant = 1
    for column in range(n):
        pivot = next((row for row in range(column, n) if work[row][column] % prime), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            determinant = (-determinant) % prime
        diagonal = work[column][column] % prime
        determinant = determinant * diagonal % prime
        inverse = pow(diagonal, -1, prime)
        for row in range(n):
            if row != column and work[row][column] % prime:
                factor = work[row][column] * inverse % prime
                for col in range(n):
                    work[row][col] = (work[row][col] - factor * work[column][col]) % prime
    return determinant % prime


def signed_max_minors(matrix: Sequence[Sequence[int]], prime: int) -> list[int]:
    """Signed 5 x 5 maximal minors of a 5 x 6 matrix (kernel orientation)."""

    minors = []
    for deleted in range(6):
        columns = [column for column in range(6) if column != deleted]
        sub = [[matrix[row][column] for column in columns] for row in range(5)]
        minors.append(((-1) ** deleted) * det_mod(sub, prime) % prime)
    return minors


def nullspace_mod(matrix: Sequence[Sequence[int]], prime: int) -> list[list[int]]:
    work = [[int(entry) % prime for entry in row] for row in matrix]
    rows = len(work)
    cols = len(work[0])
    rank = 0
    col_pivot = [-1] * cols
    for column in range(cols):
        pivot = next((row for row in range(rank, rows) if work[row][column] % prime), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], -1, prime)
        work[rank] = [entry * inverse % prime for entry in work[rank]]
        for row in range(rows):
            if row != rank and work[row][column] % prime:
                factor = work[row][column]
                work[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(work[row], work[rank])
                ]
        col_pivot[column] = rank
        rank += 1
        if rank == rows:
            break
    free = [column for column in range(cols) if col_pivot[column] < 0]
    basis = []
    for free_column in free:
        vector = [0] * cols
        vector[free_column] = 1
        for column, pivot_row in enumerate(col_pivot):
            if pivot_row >= 0:
                vector[column] = (-work[pivot_row][free_column]) % prime
        basis.append(vector)
    return basis


def mon_val(exponents: Sequence[int], u: Sequence[int], prime: int) -> int:
    value = 1
    for index, power in enumerate(exponents):
        if power:
            value = value * pow(int(u[index]) % prime, int(power), prime) % prime
    return value


def lambda_from_minors(u: Sequence[int], minors: Sequence[int], prime: int):
    """Return Q(u) such that minors = Q(u) * u, or None if inconsistent."""

    if all(value % prime == 0 for value in minors):
        return 0
    scale = None
    for index, coordinate in enumerate(u):
        if coordinate % prime == 0:
            continue
        candidate = minors[index] * pow(int(coordinate) % prime, -1, prime) % prime
        if scale is None:
            scale = candidate
        elif scale != candidate:
            return None
    if scale is None:
        return None
    if any((minors[index] - scale * int(u[index])) % prime for index in range(6)):
        return None
    return scale


def interpolate_quartic(
    forms: Sequence[Sequence[Sequence[int]]],
    prime: int,
    *,
    seed: int = 0,
    max_tries: int = 8000,
) -> tuple[list[int], int]:
    """Interpolate the unique homogeneous quartic Q with minors = Q(u) u."""

    rng_state = seed
    rows: list[list[int]] = []
    rhs: list[int] = []
    tries = 0
    target = len(EXP4) + 8

    def rand_u() -> list[int]:
        nonlocal rng_state
        # simple LCG for reproducibility without numpy
        out = []
        for _ in range(6):
            rng_state = (1103515245 * rng_state + 12345) % (2**31)
            out.append(rng_state % prime)
        return out

    while len(rows) < target and tries < max_tries:
        tries += 1
        u = rand_u()
        if all(value == 0 for value in u):
            continue
        minors = signed_max_minors(M_of(forms, u, prime), prime)
        scale = lambda_from_minors(u, minors, prime)
        if scale is None:
            continue
        rows.append([mon_val(exponents, u, prime) for exponents in EXP4])
        rhs.append(scale)

    # Gaussian elimination on the first N independent samples (square system).
    n = len(EXP4)
    if len(rows) < n:
        raise RuntimeError(f"insufficient samples for Q interpolation mod {prime}")
    matrix = [row[:] for row in rows[:n]]
    vector = rhs[:n]
    rank = 0
    pivots = [-1] * n
    for column in range(n):
        pivot = next(
            (row for row in range(rank, n) if matrix[row][column] % prime),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        vector[rank], vector[pivot] = vector[pivot], vector[rank]
        inverse = pow(matrix[rank][column], -1, prime)
        matrix[rank] = [entry * inverse % prime for entry in matrix[rank]]
        vector[rank] = vector[rank] * inverse % prime
        for row in range(n):
            if row != rank and matrix[row][column] % prime:
                factor = matrix[row][column]
                matrix[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(matrix[row], matrix[rank])
                ]
                vector[row] = (vector[row] - factor * vector[rank]) % prime
        pivots[column] = rank
        rank += 1
    coeffs = [0] * n
    for column, pivot_row in enumerate(pivots):
        if pivot_row >= 0:
            coeffs[column] = vector[pivot_row]
    return coeffs, rank


def evaluate_quartic(coeffs: Sequence[int], u: Sequence[int], prime: int) -> int:
    return sum(
        int(coeff) * mon_val(exponents, u, prime)
        for coeff, exponents in zip(coeffs, EXP4)
        if coeff
    ) % prime


def omega(form: Sequence[Sequence[int]], u: Sequence[int], v: Sequence[int], prime: int) -> int:
    total = 0
    for row in range(6):
        for column in range(6):
            total = (total + int(u[row]) * int(form[row][column]) * int(v[column])) % prime
    return total


def pluecker_vector(u: Sequence[int], v: Sequence[int], prime: int) -> list[int]:
    return [
        (int(u[left]) * int(v[right]) - int(u[right]) * int(v[left])) % prime
        for left, right in PAIRS
    ]


def form_to_pluecker(form: Sequence[Sequence[int]], prime: int) -> list[int]:
    return [int(form[left][right]) % prime for left, right in PAIRS]


def load_sealed_sources() -> dict[str, Any]:
    """Load and hash-check the C5 binding inputs and Codex five-form sources."""

    c5 = ROOT / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE"
    involution_path = ROOT / "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/involution.json"
    five_path = ROOT / "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/distinguished_five_plane.json"
    pluecker_path = c5 / "generic_pluecker_incidence.json"
    morita_path = c5 / "morita_generic_dag.json"
    morita_split_path = c5 / "morita_generic_split_dag.json"
    status_path = c5 / "STATUS.md"
    manifest_path = c5 / "INPUT_MANIFEST.json"

    paths = {
        "status": status_path,
        "generic_pluecker_incidence": pluecker_path,
        "morita_generic_dag": morita_path,
        "morita_generic_split_dag": morita_split_path,
        "involution": involution_path,
        "distinguished_five_plane": five_path,
        "c5_input_manifest": manifest_path,
    }
    hashes = {name: sha256_file(path) for name, path in paths.items()}

    # Binding hashes recorded from the live C5 packet at packet creation time
    # are re-checked by produce; verifiers recompute independently.
    involution = json.loads(involution_path.read_text())
    five_plane = json.loads(five_path.read_text())
    pluecker = json.loads(pluecker_path.read_text())
    return {
        "paths": paths,
        "hashes": hashes,
        "involution": involution,
        "five_plane": five_plane,
        "pluecker": pluecker,
        "q_linear": involution["Q_linear_coefficients"],
        "frame_vectors": five_plane["hilbert90_frame"]["vectors"],
        "frame_names": five_plane["hilbert90_frame"]["names"],
        "frame_degrees": five_plane["hilbert90_frame"]["degrees"],
    }


def expand_form_sparse(q_linear, frame_vector) -> list[list[list[dict]]]:
    """Expand A = Q(V(x)) as a 6x6 matrix of sparse Q(zeta11)[x] polynomials."""

    # A[r][c] = sum_j Q_linear[r][c][j] * V_j(x)
    matrix: list[list[list[dict]]] = [[[] for _ in range(6)] for _ in range(6)]
    for row in range(6):
        for column in range(6):
            terms: dict[tuple[int, ...], list[Fraction]] = {}
            for index in range(5):
                q_coeff = q_linear[row][column][index]
                for mon in frame_vector[index]:
                    exponents = tuple(int(value) for value in mon["exponents"])
                    scale = int(mon["coefficient"])
                    bucket = terms.setdefault(
                        exponents, [Fraction(0) for _ in range(10)]
                    )
                    for power, (numerator, denominator) in enumerate(q_coeff):
                        bucket[power] += scale * Fraction(int(numerator), int(denominator))
            sparse = []
            for exponents, coeff in sorted(terms.items()):
                if any(coeff):
                    sparse.append(
                        {
                            "x_exponents": list(exponents),
                            "coefficient_Qzeta11": [
                                [value.numerator, value.denominator] for value in coeff
                            ],
                        }
                    )
            matrix[row][column] = sparse
    return matrix


def serialize_forms_exact(q_linear, frame_vectors) -> list[dict]:
    payload = []
    for name in SECTION_NAMES:
        matrix = expand_form_sparse(q_linear, frame_vectors[name])
        # store upper triangle + diagonal for compactness audit; full matrix kept
        nonzero = sum(
            1
            for row in range(6)
            for column in range(6)
            if matrix[row][column]
        )
        payload.append(
            {
                "name": name,
                "skew": True,
                "nonzero_entries": nonzero,
                "matrix": matrix,
            }
        )
    return payload


def chart_inverse_formula() -> dict[str, Any]:
    """Exact inverse formulas on principal opens (Cramer / kernel charts)."""

    return {
        "rank4_open": {
            "condition": "rank M(u)=4 and Q(u)=0 and u != 0",
            "kernel": "ker M(u) is two-dimensional and contains u",
            "reconstruction": (
                "Choose any 4 linearly independent columns of M(u), or equivalently "
                "any nonzero 4 x 4 minor chart. Solve the four independent linear "
                "equations for four coordinates of v; free parameters span ker M(u). "
                "Normalize by imposing a complementary linear form ell(v)=1 with "
                "ell(u)=0, or take v as the second basis vector of a reduced-row-echelon "
                "kernel basis with the first vector scaled to u."
            ),
            "unique_line": "L = <u, v> = P(ker M(u)) is the unique common isotropic line through [u]",
        },
        "minor_charts": [
            {
                "name": f"delete_row_set_or_column_chart_{index}",
                "description": (
                    "On the open where a fixed 4 x 4 minor of M(u) is nonzero, "
                    "four of the five alternating equations solve linearly for four "
                    "coordinates of v; the fifth equation is then a single residual "
                    "condition (equivalent to Q(u)=0 on the rank-4 locus)."
                ),
                "linear_first": True,
            }
            for index in range(15)
        ],
        "pointed_incidence_inverse": {
            "from_line": (
                "Given a common line L=<a,b> with all omega_i(a,b)=0, every nonzero "
                "u in L satisfies Q(u)=0 and ker M(u)=L (on the rank-4 open)."
            ),
            "to_line": (
                "Given u with Q(u)=0 and rank M(u)=4, set L=P(ker M(u))."
            ),
        },
    }
