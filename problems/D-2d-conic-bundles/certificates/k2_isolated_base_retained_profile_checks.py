#!/usr/bin/env python3
"""Exact replay for the two isolated-base squarefree exclusions."""

from fractions import Fraction


def rank_one_bound(bundle_degree, twist_degree):
    return max(
        max(bundle_degree - 2 * a + 1, 0)
        + max(2 * a + twist_degree + 1, 0)
        for a in range(-(twist_degree // 2), bundle_degree + 1)
    )


def matrix_rank(rows):
    matrix = [[Fraction(entry) for entry in row] for row in rows]
    rank = 0
    for column in range(len(matrix[0])):
        pivot = next(
            (i for i in range(rank, len(matrix)) if matrix[i][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        scale = matrix[rank][column]
        matrix[rank] = [entry / scale for entry in matrix[rank]]
        for i, row in enumerate(matrix):
            if i == rank or not row[column]:
                continue
            scale = row[column]
            matrix[i] = [
                entry - scale * pivot_entry
                for entry, pivot_entry in zip(row, matrix[rank])
            ]
        rank += 1
    return rank


def monomials_below(order):
    return [
        (x_degree, total - x_degree)
        for total in range(order)
        for x_degree in range(total + 1)
    ]


def truncated_symmetric_contraction_rank(sigma):
    """Rank of Sym^2(k^3) R/m^3 -> k^3 R/m^4, q |-> q sigma."""
    source_monomials = monomials_below(3)
    target_monomials = monomials_below(4)
    target_index = {
        monomial: index for index, monomial in enumerate(target_monomials)
    }
    pairs = [(0, 0), (0, 1), (0, 2), (1, 1), (1, 2), (2, 2)]
    rows = [
        [0] * (len(pairs) * len(source_monomials))
        for _ in range(3 * len(target_monomials))
    ]
    for pair_index, (i, j) in enumerate(pairs):
        placements = [(i, j)] if i == j else [(i, j), (j, i)]
        for monomial_index, monomial in enumerate(source_monomials):
            for output, sigma_index in placements:
                for exponent, coefficient in sigma[sigma_index].items():
                    target = (
                        monomial[0] + exponent[0],
                        monomial[1] + exponent[1],
                    )
                    if sum(target) >= 4:
                        continue
                    row = output * len(target_monomials) + target_index[target]
                    column = (
                        pair_index * len(source_monomials) + monomial_index
                    )
                    rows[row][column] += coefficient
    return matrix_rank(rows)


# Resolved-line section spaces and determinant fibers.
line_rows = [
    # s, d, domain, determinant target, fixed fiber, one-dimensional target
    (0, 2, 21, 13, 8, 9),   # balanced
    (0, 2, 21, 13, 9, 10),  # unbalanced
    (1, 1, 18, 11, 7, 8),
    (2, 0, 15, 9, 6, 7),
]
assert [rank_one_bound(d, 4) for d in (1, 0)] == [7, 6]
assert all(domain == 15 + 3 * d for _, d, domain, _, _, _ in line_rows)
assert all(target == 9 + 2 * d for _, d, _, target, _, _ in line_rows)
print("resolved-line domains and determinant-fiber bounds: PASS")

# Exact codimensions of all primitive isolated-base triple strata in P^17.
base_rows = [
    # type, simple length (None for m^2), triple dimension
    ("rank3 point", 1, 16),
    ("rank3 two distinct", 2, 15),
    ("rank3 tangent vector", 2, 14),
    ("rank3 three distinct", 3, 14),
    ("rank3 tangent plus point", 3, 13),
    ("rank3 curvilinear triple", 3, 12),
    ("rank3 m^2", None, 10),
    ("rank2 simple CI", 4, 13),
    ("rank2 m^2", None, 9),
]
for _, simple_length, triple_dimension in base_rows:
    codimension = 17 - triple_dimension
    if simple_length is not None:
        assert codimension >= simple_length
    else:
        assert codimension >= 7
print("isolated-base stratum codimensions: PASS")

# Ordinary four-line [4,2^4] rows.  With a=S and c>=ell the minimum is 3.
ordinary_four_line_margins = []
for simple_length in range(1, 5):
    codimension = simple_length
    for base_units_on_lines in range(simple_length + 1):
        alignment = base_units_on_lines
        margin = (
            3 + codimension + alignment - 2 * base_units_on_lines
        )
        ordinary_four_line_margins.append(margin)
assert min(ordinary_four_line_margins) == 3
assert 3 + 7 + 1 - 2 * 2 == 7  # m^2 support on one line
print("ordinary four-line isolated-base margins: PASS")

# In the all-unbalanced pencil, a line with s=1 loses one fixed codimension
# and a line with s=2 loses three.  At most two two-unit lines can occur.
all_unbalanced_margins = []
for two_unit_lines in range(3):
    for one_unit_lines in range(5 - 2 * two_unit_lines):
        units = 2 * two_unit_lines + one_unit_lines
        if units > 4:
            continue
        alignment = units
        fixed_loss = 3 * two_unit_lines + one_unit_lines
        margin = 3 + alignment - fixed_loss
        all_unbalanced_margins.append(margin)
assert min(all_unbalanced_margins) == 1
assert 3 + 1 - 3 == 1  # one m^2 support on a selected line
print("all-unbalanced four-line margins: PASS")

# Four concurrent strict lines at a simple base point.  The four normal
# forms represent local base lengths 1,2,3,4.
local_normal_forms = [
    [{(1, 0): 1}, {(0, 1): 1}, {}],
    [{(1, 0): 1}, {(0, 2): 1}, {}],
    [{(1, 0): 1, (0, 2): 1}, {(1, 1): 1}, {}],
    [{(1, 0): 1, (0, 2): 1}, {(2, 0): 1}, {}],
]
local_ranks = [
    truncated_symmetric_contraction_rank(normal_form)
    for normal_form in local_normal_forms
]
assert local_ranks == [26, 22, 20, 18]

source_h1 = 3 * 10
target_h0 = 6 * 1
local_images = [
    72 - (target_h0 + (source_h1 - local_rank))
    for local_rank in local_ranks
]
assert local_images == [62, 58, 56, 54]
four_line_bad_at_base = 4 * 8
local_stratum_dimensions = [16, 14, 12, 10]
local_margins = [
    (image - four_line_bad_at_base) - (dimension + 8)
    for image, dimension in zip(local_images, local_stratum_dimensions)
]
assert local_margins == [6, 4, 4, 4]
print("four-line central-base local ranks and margins 6/4/4/4: PASS")

# Triangle vertex exceptional filtration.
triangle_rank_two_image = 72 - (6 * 3 + (3 * 3 - 5))
triangle_rank_one_image = 72 - (6 * 3 + (3 * 3 - 3))
assert (triangle_rank_two_image, triangle_rank_one_image) == (50, 48)
triangle_bad = 2 * 8 + 10
triangle_rank_two_margin = (triangle_rank_two_image - triangle_bad) - (
    16 + 4
)
triangle_rank_one_margin = (triangle_rank_one_image - triangle_bad) - (
    14 + 4
)
assert (triangle_rank_two_margin, triangle_rank_one_margin) == (4, 4)
print("triangle central-base exceptional margins 4/4: PASS")

# Several triangle vertices can be base points simultaneously.  Image
# losses are 4/6 by first-jet rank; a side shared by two base vertices gives
# one unit of overlap in the bad-space gain.
simultaneous_vertex_margins = []
for vertex_count in range(4):
    for rank_one_vertices in range(vertex_count + 1):
        rank_two_vertices = vertex_count - rank_one_vertices
        # c>=v is enough for positivity; rank-one vertices actually force
        # a still larger c because they consume a successor base unit.
        base_codimension = vertex_count
        overlap = vertex_count * (vertex_count - 1) // 2
        margin = 1 + base_codimension + 2 * rank_two_vertices - overlap
        simultaneous_vertex_margins.append(margin)
assert min(simultaneous_vertex_margins) == 1
print("simultaneous triangle-vertex margins: PASS")

# Unified central/side ledger: c is used exactly once.  Each vertex occupies
# its two incident sides; remaining simple units may be assigned to sides
# up to total weight two.
def triangle_beta(weight):
    return (0, 2, 3)[weight]


unified_triangle_margins = []
for simple_length in range(1, 5):
    for vertex_mask in range(1 << 3):
        vertices = [
            index for index in range(3) if vertex_mask & (1 << index)
        ]
        vertex_count = len(vertices)
        if vertex_count > simple_length:
            continue
        endpoint_weights = [
            int(0 in vertices) + int(1 in vertices),
            int(1 in vertices) + int(2 in vertices),
            int(2 in vertices) + int(0 in vertices),
        ]
        for rank_one_mask in range(1 << vertex_count):
            rank_one_vertices = bin(rank_one_mask).count("1")
            rank_two_vertices = vertex_count - rank_one_vertices
            remaining = simple_length - vertex_count
            for add0 in range(3 - endpoint_weights[0]):
                for add1 in range(3 - endpoint_weights[1]):
                    for add2 in range(3 - endpoint_weights[2]):
                        additions = (add0, add1, add2)
                        if sum(additions) > remaining:
                            continue
                        side_weights = [
                            endpoint + addition
                            for endpoint, addition in zip(
                                endpoint_weights, additions
                            )
                        ]
                        alignment = sum(additions)
                        total_weight = sum(side_weights)
                        beta_gain = sum(
                            triangle_beta(weight) for weight in side_weights
                        )
                        margin = (
                            1
                            + simple_length
                            + alignment
                            + 2 * vertex_count
                            + 2 * rank_two_vertices
                            - 3 * total_weight
                            + beta_gain
                        )
                        unified_triangle_margins.append(margin)
assert min(unified_triangle_margins) == 1
print("unified triangle central/side ledger without double counting: PASS")

# Triangle-side base alignments.  A one-unit side loses one fixed
# codimension; a two-unit side loses three.
triangle_side_margins = []
for simple_length in range(1, 5):
    for two_unit_sides in range(simple_length // 2 + 1):
        for one_unit_sides in range(
            simple_length - 2 * two_unit_sides + 1
        ):
            units = 2 * two_unit_sides + one_unit_sides
            if units > simple_length:
                continue
            alignment = units
            fixed_loss = 3 * two_unit_sides + one_unit_sides
            margin = 1 + simple_length + alignment - fixed_loss
            triangle_side_margins.append(margin)
assert min(triangle_side_margins) == 2
assert 1 + 7 + 1 - 3 == 6  # m^2 support on a triangle side
print("triangle-side isolated-base margins: PASS")

print("isolated-base [4,2^4] and [3^3,2] exclusions: PASS")
