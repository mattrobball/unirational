#!/usr/bin/env python3
"""Arithmetic checks for the repeated-root six-center frontier audit."""


def rank_one_bound(bundle_degree, twist_degree):
    """The genus-free rank-one-cone bound R(f,n)."""
    lower = -(twist_degree // 2)
    values = []
    for line_degree in range(lower, bundle_degree + 1):
        quotient_tangent = max(bundle_degree - 2 * line_degree + 1, 0)
        scalar_section = max(2 * line_degree + twist_degree + 1, 0)
        values.append(quotient_tangent + scalar_section)
    return max(values)


def partitions(total, maximum=None):
    """Integer partitions in nonincreasing order."""
    if total == 0:
        yield ()
        return
    if maximum is None or maximum > total:
        maximum = total
    for first in range(maximum, 0, -1):
        for tail in partitions(total - first, first):
            yield (first,) + tail


def monomials(degree):
    """Affine monomials x^a y^b of total degree at most degree."""
    return [
        (a, b)
        for a in range(degree + 1)
        for b in range(degree + 1 - a)
    ]


def chain_condition_rows(degree, weights):
    """Coefficient rows for a successive free-chain point basis."""
    basis = monomials(degree)
    cumulative = []
    total = 0
    for weight in weights:
        total += weight
        cumulative.append(total)
    rows = []
    for column, (a, b) in enumerate(basis):
        allowed = all(
            a + (depth + 1) * b >= threshold
            for depth, threshold in enumerate(cumulative)
        )
        if not allowed:
            row = [0] * len(basis)
            row[column] = 1
            rows.append(row)
    return basis, rows


def falling_factorial(value, length):
    out = 1
    for offset in range(length):
        out *= value - offset
    return out


def proper_jet_rows(basis, point, multiplicity):
    """Rows evaluating derivatives of order below multiplicity at a point."""
    u, v = point
    rows = []
    for i in range(multiplicity):
        for j in range(multiplicity - i):
            row = []
            for a, b in basis:
                if a < i or b < j:
                    row.append(0)
                else:
                    row.append(
                        falling_factorial(a, i)
                        * falling_factorial(b, j)
                        * u ** (a - i)
                        * v ** (b - j)
                    )
            rows.append(row)
    return rows


def matrix_rank_mod(rows, prime=1000003):
    """Exact row rank over a prime field."""
    matrix = [[entry % prime for entry in row] for row in rows]
    if not matrix:
        return 0
    row_count = len(matrix)
    column_count = len(matrix[0])
    pivot_row = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(pivot_row, row_count) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        inverse = pow(matrix[pivot_row][column], prime - 2, prime)
        matrix[pivot_row] = [
            entry * inverse % prime for entry in matrix[pivot_row]
        ]
        for row in range(row_count):
            if row == pivot_row or matrix[row][column] == 0:
                continue
            scalar = matrix[row][column]
            matrix[row] = [
                (entry - scalar * pivot_entry) % prime
                for entry, pivot_entry in zip(matrix[row], matrix[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == row_count:
            break
    return pivot_row


def repeated_chain_rank(degree, chain_weights, proper_multiplicity):
    """Rank for the repeated chain plus the three explicit proper points."""
    basis, rows = chain_condition_rows(degree, chain_weights)
    for point in ((1, 2), (3, 1), (2, 5)):
        rows.extend(proper_jet_rows(basis, point, proper_multiplicity))
    return matrix_rank_mod(rows)


# Raw M=5H-2*sum(E_i), with six essential weights.
m_square = 5**2 - 6 * 2**2
k_dot_m = -3 * 5 + 6 * 2
chi_m = 1 + (m_square - k_dot_m) // 2
branch_dot_m = 10 * 5 - 6 * 4 * 2
assert (m_square, k_dot_m, chi_m, branch_dot_m) == (1, -3, 3, 2)
print("raw quintic-adjoint arithmetic: PASS")

# A first-near singleton unloads doubled point basis (2 at q) to (1,1).
unloaded_squares = [25 - 4 * (6 - n) - 2 * n for n in range(4)]
assert unloaded_squares == [1, 3, 5, 7]
print("singleton unloading self-intersections: PASS")

# Canonical branch-genus identity.  Odd corrections are r=5 essentials and
# r=3 negligible centers; n_1 counts r=2 and r=3 negligible centers.
for components in range(1, 11):
    for n5 in range(7):
        for n2 in range(13):
            for n3 in range(13):
                odd = n5 + n3
                n1 = n2 + n3
                final_arithmetic_genus = 36 - 6 * 6 - n1
                normalization_genus = components + odd - n1 - 1
                assert final_arithmetic_genus == (
                    normalization_genus - (components + odd) + 1
                )
                assert normalization_genus == components + n5 - n2 - 1
print("canonical branch-genus identity: PASS")

# At proper/free/satellite centers, maximal exceptional contribution and
# movement dimension are (0,2), (1,1), and (2,0).
locations = [(0, 2), (1, 1), (2, 0)]
for corrected_multiplicity in (4, 5):
    charges = [
        corrected_multiplicity - exceptional_count - movement
        for exceptional_count, movement in locations
    ]
    assert charges == [corrected_multiplicity - 2] * 3
for n5 in range(7):
    assert 6 * 2 + n5 == 12 + n5
print("essential-center charge lower bound: PASS")

# Curve-side dimensions before and after the *conditional* charge subtraction.
unconditional = []
conditional = []
for n5 in range(7):
    for n2 in range(13):
        equigeneric_dimension = 29 + n5 - n2
        charged_dimension = equigeneric_dimension - (12 + n5)
        unconditional.append(equigeneric_dimension)
        conditional.append(charged_dimension)
        assert charged_dimension == 17 - n2
assert max(unconditional) == 35
assert max(conditional) == 17
print("global curve-dimension arithmetic: PASS")

# Sharp repeated-chain test: q0<...<q4, with q0,q2,q4 essential and
# q1,q3 negligible separators, together with three proper essential points.
raw_rank_rows = []
raw_chain_ranks = []
for multiplier, degree, expected_rank in ((1, 2, 6), (2, 4, 15), (4, 10, 51)):
    weights = [multiplier, 0, multiplier, 0, multiplier]
    _, chain_rows = chain_condition_rows(degree, weights)
    raw_chain_ranks.append(len(chain_rows))
    rank = repeated_chain_rank(degree, weights, multiplier)
    raw_rank_rows.append(rank)
    assert rank == expected_rank
assert raw_chain_ranks == [3, 6, 21]
assert raw_rank_rows == [6, 15, 51]

degree_ten_dimension = 66
cluster_movement = (2 + 4) + 3 * 2
raw_h0 = degree_ten_dimension - raw_rank_rows[-1]
assert (cluster_movement, raw_h0, cluster_movement + raw_h0) == (12, 15, 27)

# The last raw inequality is a+5b>=12, so no degree-ten monomial with b=0
# survives: the tangent line is a fixed component.
basis, _ = chain_condition_rows(10, [4, 0, 4, 0, 4])
allowed = [
    (a, b)
    for a, b in basis
    if a + b >= 4 and a + 3 * b >= 8 and a + 5 * b >= 12
]
assert allowed and all(b >= 1 for _, b in allowed)

# Restoring 2D1 gives corrected weights (4,2,4,2,4); unloading has the
# same degree-ten rank as the strict point basis (4,3,3,3,3).
full_corrected_rank = repeated_chain_rank(10, [4, 2, 4, 2, 4], 4)
strict_basis_rank = repeated_chain_rank(10, [4, 3, 3, 3, 3], 4)
_, full_chain_rows = chain_condition_rows(10, [4, 2, 4, 2, 4])
_, strict_chain_rows = chain_condition_rows(10, [4, 3, 3, 3, 3])
assert (len(full_chain_rows), len(strict_chain_rows)) == (28, 28)
assert (full_corrected_rank, strict_basis_rank) == (58, 58)
full_h0 = degree_ten_dimension - full_corrected_rank
assert (full_h0, cluster_movement + full_h0) == (8, 20)
print("sharp repeated-chain ranks and D1 comparison: PASS")

assert rank_one_bound(5, 20) == 31
hypothetical_bad_dimension = (17 + 1) + 31
unconditional_bad_bound = (35 + 1) + 31
assert hypothetical_bad_dimension == 49
assert 60 - hypothetical_bad_dimension == 11 > 8
assert unconditional_bad_bound == 67 > 60
print("fixed-determinant shortcut margins: PASS")

root_partitions = sorted(partitions(6), key=lambda part: (-len(part), part))
assert root_partitions[0] == (1, 1, 1, 1, 1, 1)
assert root_partitions[1] == (2, 1, 1, 1, 1)
print("first repeated root partition: PASS")

print("all repeated-root frontier checks: PASS")
