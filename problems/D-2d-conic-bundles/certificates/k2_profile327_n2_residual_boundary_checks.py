#!/usr/bin/env python3
"""Arithmetic replay for the n=2 common-support residual boundary.

The exhaustive F_3 calculation below corroborates the displayed normal-form
table over every truncated affine solution.  It does not replace the
characteristic-zero coefficient proof in the certificate.
"""

from collections import Counter
from itertools import product


def check(condition: bool, label: str) -> None:
    if not condition:
        raise AssertionError(label)
    print(f"{label}: PASS")


# Outside rank-zero jets.  Three value equations leave the displayed
# factored spaces; the coefficient audit bounds their determinant-zero loci.
outside_spaces = {
    "balanced": (12, 3, 9, 5),
    "unbalanced": (12, 3, 9, 6),
}
outside_codim = {}
for splitting, (ambient, value_cost, factored, bad_dim) in outside_spaces.items():
    check(ambient - value_cost == factored,
          f"{splitting} rank-zero factored space")
    outside_codim[splitting] = ambient - bad_dim
check(outside_codim == {"balanced": 7, "unbalanced": 6},
      "outside rank-zero codimensions")
check(outside_codim["unbalanced"] + 1 == outside_codim["balanced"],
      "effective outside rank-zero codimension")

# Constant-matrix selected-jet coefficient table.
selected_rank_zero = {
    ("balanced", "noncross"): 3,
    ("balanced", "cross"): 2,
    ("unbalanced_unramified", "noncross"): 3,
    ("unbalanced_unramified", "cross"): 2,
    ("unbalanced_ramified", "noncross"): 2,
    ("unbalanced_ramified", "cross"): 1,
}
check(min(selected_rank_zero.values()) == 1,
      "selected rank-zero raw minimum")
for splitting in ("unbalanced_unramified", "unbalanced_ramified"):
    ramification_cost = 0 if splitting == "unbalanced_unramified" else 1
    check(selected_rank_zero[(splitting, "noncross")] + ramification_cost == 3,
          f"{splitting} effective noncross contribution")
    check(selected_rank_zero[(splitting, "cross")] + ramification_cost + 1 == 3,
          f"{splitting} effective cross contribution")
check(selected_rank_zero[("balanced", "cross")] + 1 == 3,
      "balanced effective cross contribution")


# Exhaust every S with det(S)=0 in Sym^2((F_3[t]/t^4)^2), and every one
# of the 3^6 constant matrices M.  Base-3 integer encodings and an addition
# table keep this full 8,505 x 729 x 6 replay small and stdlib-only.
prime = 3
poly_count = prime ** 4
poly_digits = [
    tuple((number // (prime ** degree)) % prime for degree in range(4))
    for number in range(poly_count)
]
poly_encode = {digits: number for number, digits in enumerate(poly_digits)}


def poly_mul(left: tuple[int, ...], right: tuple[int, ...]) -> int:
    return poly_encode[tuple(
        sum(left[j] * right[degree - j] for j in range(degree + 1)) % prime
        for degree in range(4)
    )]


mul_table = [
    [poly_mul(poly_digits[left], poly_digits[right])
     for right in range(poly_count)]
    for left in range(poly_count)
]
add_table = [
    [poly_encode[tuple((poly_digits[left][degree]
                        + poly_digits[right][degree]) % prime
                       for degree in range(4))]
     for right in range(poly_count)]
    for left in range(poly_count)
]

determinant_zero = []
determinant_zero_lookup = bytearray(poly_count ** 3)
for first in range(poly_count):
    for middle in range(poly_count):
        middle_square = mul_table[middle][middle]
        for last in range(poly_count):
            if mul_table[first][last] == middle_square:
                determinant_zero.append((first, middle, last))
                encoded = (first + poly_count * middle
                           + poly_count ** 2 * last)
                determinant_zero_lookup[encoded] = 1
check(len(determinant_zero) == 8505,
      "F3 determinant-zero translate census")

# Exhaust the fixed positive-degree tails in the outside rank-zero lemma.
# These counts corroborate the direct affine-tail proof.
balanced_tail_maximum = 0
for first_tail, middle_tail, last_tail in product(range(prime), repeat=3):
    count = 0
    for lower_first in product(range(prime), repeat=3):
        first = poly_encode[lower_first + (first_tail,)]
        for lower_middle in product(range(prime), repeat=3):
            middle = poly_encode[lower_middle + (middle_tail,)]
            middle_square = mul_table[middle][middle]
            for lower_last in product(range(prime), repeat=3):
                last = poly_encode[lower_last + (last_tail,)]
                count += mul_table[first][last] == middle_square
    balanced_tail_maximum = max(balanced_tail_maximum, count)
check(balanced_tail_maximum == 459,
      "F3 exhaustive balanced outside-tail corroboration")

unbalanced_tail_maximum = 0
for middle_tail, last_1, last_2, last_3 in product(range(prime), repeat=4):
    count = 0
    for first in range(poly_count):
        for lower_middle in product(range(prime), repeat=3):
            middle = poly_encode[lower_middle + (middle_tail,)]
            middle_square = mul_table[middle][middle]
            for last_0 in range(prime):
                last = poly_encode[(last_0, last_1, last_2, last_3)]
                count += mul_table[first][last] == middle_square
    # The fifth coefficient of the unrestricted first entry is irrelevant.
    unbalanced_tail_maximum = max(unbalanced_tail_maximum, prime * count)
check(unbalanced_tail_maximum == 891,
      "F3 exhaustive unbalanced outside-tail corroboration")


def encode_poly(coefficients: tuple[int, ...]) -> int:
    return poly_encode[tuple(coefficient % prime for coefficient in coefficients)]


def shift_poly(encoded: int) -> int:
    coefficients = poly_digits[encoded]
    return encode_poly((0, coefficients[0], coefficients[1], coefficients[2]))


def balanced_normal_form(values: tuple[int, ...]) -> tuple[tuple[int, ...], ...]:
    a, b, c, d, e, f = values
    return ((d, -2 * b, a, 0),
            (e, -c, -b, a),
            (f, 0, -2 * c, 0))


def unbalanced_normal_form(
        values: tuple[int, ...], ramified: bool) -> tuple[tuple[int, ...], ...]:
    a, b, c, d, e, f = values
    if ramified:
        return ((d, 0, -2 * b, 0),
                (e, 0, -c, 0),
                (f, 0, 0, 0))
    return ((d, -2 * b, a, 0),
            (e, -c, 0, 0),
            (f, 0, 0, 0))


normal_forms = {label: [] for label in (
    "balanced", "balanced_cross",
    "unramified", "unramified_cross",
    "ramified", "ramified_cross",
)}
for values in product(range(prime), repeat=6):
    balanced = tuple(encode_poly(poly) for poly in balanced_normal_form(values))
    unramified = tuple(
        encode_poly(poly) for poly in unbalanced_normal_form(values, False)
    )
    ramified = tuple(
        encode_poly(poly) for poly in unbalanced_normal_form(values, True)
    )
    normal_forms["balanced"].append(balanced)
    normal_forms["balanced_cross"].append(tuple(map(shift_poly, balanced)))
    normal_forms["unramified"].append(unramified)
    normal_forms["unramified_cross"].append(tuple(map(shift_poly, unramified)))
    normal_forms["ramified"].append(ramified)
    normal_forms["ramified_cross"].append(tuple(map(shift_poly, ramified)))

expected_maxima = {
    "balanced": 51,
    "balanced_cross": 135,
    "unramified": 45,
    "unramified_cross": 135,
    "ramified": 135,
    "ramified_cross": 243,
}
for label, raw_variations in normal_forms.items():
    variations = tuple(Counter(raw_variations).items())
    maximum = 0
    for first, middle, last in determinant_zero:
        add_first = add_table[first]
        add_middle = add_table[middle]
        add_last = add_table[last]
        count = 0
        for variation, multiplicity in variations:
            encoded = (
                add_first[variation[0]]
                + poly_count * add_middle[variation[1]]
                + poly_count ** 2 * add_last[variation[2]]
            )
            count += multiplicity * determinant_zero_lookup[encoded]
        maximum = max(maximum, count)
    check(maximum == expected_maxima[label],
          f"F3 exhaustive {label} affine-fiber corroboration")

# Enumerate the contact distribution on a reduced residual U union V.
# U contains p, so it already has weight six.  V receives the extra
# intersection with the common branch line.
low_weights = (4, 4, 4, 3)
survivors = []
for on_u in product((False, True), repeat=4):
    u_contact = 6 + sum(w for w, flag in zip(low_weights, on_u) if flag)
    v_contact = 1 + sum(w for w, flag in zip(low_weights, on_u) if not flag)
    if u_contact <= 12 and v_contact <= 12:
        survivors.append((on_u, u_contact, v_contact))
check(len(survivors) == 3,
      "three choices of exact reducible residual distribution")
check(all(sum(flags) == 1 and flags[3] is False
          for flags, _, _ in survivors),
      "p-line contains exactly one proper low")
check(all((u_contact, v_contact) == (10, 12)
          for _, u_contact, v_contact in survivors),
      "exact residual line contacts")
check(6 + 3 * 4 + 3 > 12,
      "double residual line is forced")

# Three line fibers and the glued determinant targets.
for unbalanced_components in range(4):
    fiber_dimension = 3 * 8 + unbalanced_components
    glued_target_dimension = 3 + 1 - 1
    bad_dimension = fiber_dimension + glued_target_dimension
    fixed_codimension = 54 - bad_dimension
    check(fixed_codimension == 27 - unbalanced_components,
          f"three-line fixed codimension j={unbalanced_components}")
check((27 - 3) + 1 == 25,
      "all-unbalanced effective fixed codimension")

# Rank-zero pair and reducible-residual incidence margins.
check(25 + 7 + 3 - 34 == 1,
      "two-rank-zero common-support margin")
check(25 + 6 + 3 - 33 == 1,
      "reducible-residual rank-zero margin")
check(24 + 6 + 4 - 33 == 1,
      "reducible-residual rank-one margin")

# Raw splitting and cross rows reproduce the same rank-zero margins.
for outside_unbalanced in range(2):
    outside = 7 - outside_unbalanced

    fixed = 25 + outside + selected_rank_zero[("balanced", "noncross")]
    moving = 34 - outside_unbalanced
    check(fixed - moving == 1,
          f"rank-zero pair balanced b1={outside_unbalanced}")

    fixed = 25 + outside + selected_rank_zero[("balanced", "cross")]
    moving = 33 - outside_unbalanced
    check(fixed - moving == 1,
          f"rank-zero pair balanced cross b1={outside_unbalanced}")

    fixed = (25 + outside
             + selected_rank_zero[("unbalanced_unramified", "noncross")])
    moving = 34 - outside_unbalanced
    check(fixed - moving == 1,
          f"rank-zero pair unbalanced b1={outside_unbalanced}")

    fixed = (25 + outside
             + selected_rank_zero[("unbalanced_ramified", "cross")])
    moving = 32 - outside_unbalanced
    check(fixed - moving == 1,
          f"rank-zero pair unbalanced cross b1={outside_unbalanced}")

print("n=2 common-support residual boundary exclusion: PASS")
