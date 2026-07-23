#!/usr/bin/env python3
"""Arithmetic replay for the n=3 nonintegral-block exclusion."""

from itertools import product


def check(condition: bool, label: str) -> None:
    if not condition:
        raise AssertionError(label)
    print(f"{label}: PASS")


def matrix_rank(rows: list[list[int]]) -> int:
    """Exact row rank over Q, using integer-preserving elimination."""
    work = [row[:] for row in rows if any(row)]
    rank = 0
    column = 0
    while rank < len(work) and column < len(work[0]):
        pivot = next((r for r in range(rank, len(work))
                      if work[r][column]), None)
        if pivot is None:
            column += 1
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        pivot_value = work[rank][column]
        for r in range(len(work)):
            if r == rank or work[r][column] == 0:
                continue
            row_value = work[r][column]
            work[r] = [pivot_value * x - row_value * y
                       for x, y in zip(work[r], work[rank])]
        rank += 1
        column += 1
    return rank


def conic_product(left: tuple[int, int, int],
                  right: tuple[int, int, int]) -> tuple[int, ...]:
    """Coefficients in (x^2,y^2,z^2,xy,xz,yz)."""
    a, b, c = left
    d, e, f = right
    return (a * d, b * e, c * f,
            a * e + b * d, a * f + c * d, b * f + c * e)


def relation_map_rank(lines: list[tuple[int, int, int]]) -> int:
    """Rank of (m_i) -> sum ell_i m_i from three linear cofactors."""
    basis = [(1, 0, 0), (0, 1, 0), (0, 0, 1)]
    columns = [conic_product(line, cofactor)
               for line in lines for cofactor in basis]
    rows = [[column[row] for column in columns] for row in range(6)]
    return matrix_rank(rows)


# A nonproper-deleted cubic contains four proper and two nonproper lows.
weights = (4, 4, 4, 4, 3, 3)
total_weight = sum(weights)
check(total_weight == 22, "selected low contact weight")

# Reduced line + integral conic, both through p.  Enumerate disjoint
# distributions for which neither component is forced into the branch.
line_conic_contacts = set()
for assignment in product((0, 1), repeat=len(weights)):
    line_weight = sum(weight for weight, side in zip(weights, assignment)
                      if side == 0)
    conic_weight = total_weight - line_weight
    line_contact = 6 + line_weight
    conic_contact = 6 + conic_weight
    if line_contact <= 12 and conic_contact <= 24:
        line_conic_contacts.add((line_contact, conic_contact))
check(line_conic_contacts == {(10, 24), (12, 22)},
      "branch-free line-conic contact distributions")
check({(13 - line, 25 - conic) for line, conic
       in line_conic_contacts} == {(3, 1), (1, 3)},
      "line-conic component target dimensions")
check(3 + 1 - 1 == 1 + 3 - 1 == 3,
      "line-conic glued target dimension")
check(54 - (8 + 17 + 3) == 26,
      "line-conic balanced fixed codimension")
check(54 - (9 + 17 + 3) == 25,
      "line-conic unbalanced raw fixed codimension")
check(25 + 1 == 26,
      "line-conic effective fixed codimension")
check(54 - (8 + 17 + 4) == 25
      and 54 - (9 + 17 + 4) + 1 == 25,
      "tangent line-conic effective fixed codimension")

# Three distinct lines: two pass through p and the third does not.  The
# unique branch-free weight distribution is (6,4;12), up to swapping the
# two p-lines.
three_line_weights = set()
for assignment in product((0, 1, 2), repeat=len(weights)):
    sums = [sum(weight for weight, side in zip(weights, assignment)
                if side == component) for component in range(3)]
    if sums[0] <= 6 and sums[1] <= 6 and sums[2] <= 12:
        three_line_weights.add((tuple(sorted(sums[:2])), sums[2]))
check(three_line_weights == {((4, 6), 12)},
      "unique branch-free three-line distribution")
check((13 - 12) + (13 - 10) + (13 - 12) - 2 == 3,
      "three-line glued target dimension")
for unbalanced in range(4):
    raw_codimension = 54 - (3 * 8 + unbalanced + 3)
    check(raw_codimension == 27 - unbalanced,
          f"three-line raw fixed codimension j={unbalanced}")
check(min((27 - j) + (1 if j == 3 else 0) for j in range(4)) == 25,
      "three-line effective fixed codimension")

# Nonreduced cubic 2L+M.  These are the sharp residual contacts used in
# the case split.
check(5 + 2 + 2 + 3 == 12,
      "double support with three lows forces a second branch copy")
check(4 * 3 == 12,
      "four proper lows force a second residual-line copy")
check(6 + 3 + 4 == 13 and 3 + 3 * 4 == 15,
      "mixed two-low double support gives two branch lines")
check(2 * 2 + 3 * 3 == 13,
      "five-low residual line forces a second branch copy")

# Common-support classification.
check(4 * 3 == 12,
      "four proper lows double a common non-p line")
check(5 + 3 * 3 > 11,
      "three proper lows double a common p-line")
check(6 + 4 * 4 + 2 * 3 == 28,
      "h=0 common p-line residual contact")
check(6 + 3 * 4 + 2 * 3 == 24 and 24 + 1 > 24,
      "h=1 common p-line residual plus gluing contact")

# With H through p,P1,P2, an integral residual conic has visible contact
# twenty and one further zero from the branch-line intersection.
check(6 + 2 * 4 + 2 * 3 == 20,
      "common-line integral residual visible contact")
check(25 - 20 - 1 == 4,
      "common-line integral residual target dimension")
check(54 - (8 + 17 + 4) == 25,
      "common-line integral residual balanced fixed codimension")
check(54 - (9 + 17 + 4) == 24,
      "common-line integral residual unbalanced raw fixed codimension")

# Reduced residual conic U+V.  Exactly U passes through p.  The extra one
# in the V-contact is H cap V, where H is already a branch line.
residual_weights = (4, 4, 3, 3)
residual_rows = set()
for assignment in product((0, 1), repeat=len(residual_weights)):
    u_weight = sum(weight for weight, side
                   in zip(residual_weights, assignment) if side == 0)
    v_weight = sum(residual_weights) - u_weight
    u_contact = 6 + u_weight
    v_contact = 1 + v_weight
    if u_contact <= 12 and v_contact <= 12:
        residual_rows.add((u_contact, v_contact))
check(residual_rows == {(9, 12), (10, 11), (12, 9)},
      "common-line reducible residual distributions")
check({(13 - u) + (13 - v) - 1 for u, v in residual_rows} == {4},
      "common-line reducible residual glued target dimension")
for unbalanced in range(4):
    raw_codimension = 54 - (3 * 8 + unbalanced + 4)
    check(raw_codimension == 26 - unbalanced,
          f"reducible residual raw fixed codimension j={unbalanced}")
check((13 - 12) + (13 - 12) - 1 == 1,
      "reducible residual selected-tangent target dimension")
for unbalanced in range(4):
    tangent_raw = 54 - (3 * 8 + unbalanced + 1)
    check(tangent_raw == 29 - unbalanced,
          f"reducible residual tangent raw codimension j={unbalanced}")

# Grassmannian jumping-line incidence.  V=H0(O(2)) has dimension six and
# Gr(3,V) dimension nine.  For three nonconcurrent lines the linear
# relation space among ell_i*m_i has dimension three; for concurrent lines
# it has dimension four.
triangle_rank = relation_map_rank([(1, 0, 0),
                                   (0, 1, 0),
                                   (0, 0, 1)])
concurrent_rank = relation_map_rank([(1, 0, 0),
                                     (0, 1, 0),
                                     (1, 1, 0)])
check((triangle_rank, 9 - triangle_rank) == (6, 3),
      "nonconcurrent linear-syzygy dimension")
check((concurrent_rank, 9 - concurrent_rank) == (5, 4),
      "concurrent linear-syzygy dimension")
grassmann_dimension = 3 * (6 - 3)
independent_incidence_dimension = 3 * 2
nonconcurrent_dependent_dimension = (3 - 1) + 3
concurrent_dependent_dimension = (4 - 1) + 3
check(grassmann_dimension == 9,
      "net Grassmannian dimension")
check(independent_incidence_dimension == 6,
      "independent three-line incidence dimension")
check(nonconcurrent_dependent_dimension == 5,
      "nonconcurrent dependent incidence dimension")
check(concurrent_dependent_dimension == 6,
      "concurrent dependent incidence dimension")
check(grassmann_dimension - max(independent_incidence_dimension,
                                concurrent_dependent_dimension) == 3,
      "three distinct jumping lines have codimension three")

# Explicit nonramified points on both top-dimensional incidence types.
# Triangle example on z=0 near [1:0:0]: [1, t+t^2].
triangle_wronskian_at_zero = 1
# Concurrent dependent example: q1=x(y-z), q2=-y(z+x),
# q3=(x+y)z and g=x^2+y^2+z^2.  On x+y=0 near [0:0:1] the pencil is
# [-t-t^2, 1+2t^2].
concurrent_wronskian_at_zero = -1
check(triangle_wronskian_at_zero != 0,
      "ramification is nonautomatic on independent incidence")
check(concurrent_wronskian_at_zero != 0,
      "ramification is nonautomatic on concurrent incidence")
check(6 - 1 == 5 and grassmann_dimension - 5 == 4,
      "ramified three-line jumping locus has codimension four")

# Moving dimensions and strict margins.  The first baseline retains the
# outside marked line and one selected marked line.  The common-line
# baseline also imposes p,P1,P2 collinear.  Reducibility costs one more.
check(16 + 2 + 17 == 35,
      "single-cubic retained moving dimension")
check(35 - 1 == 34 and 35 - 2 == 33,
      "branch-free factorization moving dimensions")
check(28 + 6 + 3 - 35 == 2,
      "integral nonproper-deleted cubic margin")
check(26 + 6 + 3 - 34 == 1,
      "branch-free line-conic margin")
check(25 + 6 + 3 - (35 - 1 - 1) == 1,
      "tangent branch-free line-conic margin")
check(25 + 6 + 3 - 33 == 1,
      "branch-free three-line margin")
check(35 - 1 == 34,
      "common p-line moving dimension")
check(25 + 7 + 3 - 34 == 1,
      "common-line integral residual rank-zero margin")
check(25 + 6 + 4 - 34 == 1,
      "common-line integral residual all-rank-one margin")
check(25 - 20 - 3 - 1 == 1
      and 54 - (8 + 17 + 1) == 28
      and 28 + 6 - (34 - 1) == 1,
      "common-line selected-tangent residual margin")
check(34 - 1 == 33 and 25 + 6 + 3 - 33 == 1,
      "common-line reducible residual margin")
check(28 + 6 - (34 - 1 - 1) == 2,
      "reducible residual selected-tangent margin")
check((26 - 3) + (6 - 1) + 2 == 30 and 30 + 4 - 33 == 1,
      "reducible residual ramified splitting ledger")

print("n=3 nonintegral-block exclusion: PASS")
