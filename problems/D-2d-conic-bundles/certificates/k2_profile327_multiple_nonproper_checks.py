#!/usr/bin/env python3
"""Arithmetic replay for the multiple-nonproper [3,2^7] frontier."""


def check(condition: bool, label: str) -> None:
    if not condition:
        raise AssertionError(label)
    print(f"{label}: PASS")


# Integral deleted-cubic contact and fixed codimension.
for s in range(4):
    contact = 2 * 6 + (6 - s) * 4 + s * 3
    target = 37 - contact
    fixed_codim = 54 - (23 + target)
    check((contact, target, fixed_codim) == (36 - s, 1 + s, 30 - s),
          f"integral cubic row s={s}")

# n=2: omit N, forget the other marked tangent.
check(29 + 6 - 34 == 1, "n=2 omitted-N balanced margin")
check(29 + 5 - 33 == 1, "n=2 omitted-N unbalanced margin")

# n=3: the same one-line method is exactly borderline.
check(28 + 6 - 34 == 0, "n=3 omitted-N balanced boundary")
check(28 + 5 - 33 == 0, "n=3 omitted-N unbalanced boundary")

# Proper-deletion simultaneous-jet thresholds and formal separate-line
# sums.  Here e is the actual joint unbalanced-stratum codimension and may
# be smaller than j on coincident/dependent jumping-line boundaries.
for s, required_base, separate_base in [(2, 6, 8), (3, 8, 12)]:
    for j in range(s + 1):
        e = j  # independent-line row replayed here
        required = 2 * s + 2 - e
        separate = 4 * s - j
        check(required == required_base - j
              and separate == separate_base - j
              and separate >= required,
              f"simultaneous tangent threshold s={s}, j={j}")

# P and Q block targets.
check(6 + 3 + 3 == 12 and 13 - 12 == 1,
      "weak NN P-block target")
q_rows = []
for u in range(4):
    contact = 6 + 4 * (5 - u) + 3 * u
    target = max(25 - contact, 0)
    q_rows.append((contact, target))
check(q_rows == [(26, 0), (25, 0), (24, 1), (23, 2)],
      "integral Q-block target table")

# Repeated-support residual contacts.
check([5 + 2 * u + 3 * (3 - u) for u in range(4)]
      == [14, 13, 12, 11],
      "repeated P-support residual contacts")
check(5 + 3 * 6 - 3 == 20 and 5 + 3 * 7 - 3 == 23,
      "repeated integral-Q support boundary")

# n=2 common-support classification.
check(6 + 3 + 4 == 13, "n=2 selected P-line is forced")
check(6 + 3 + 4 * 4 == 25, "n=2 selected Q-conic is forced")
check(5 + 2 + 2 * 3 == 13, "n=2 three-low P-line doubles")
check(3 + 3 * 4 == 15, "n=2 four-low line is forced")
check(5 + 2 * 2 + 4 * 3 == 21,
      "n=2 repeated integral-Q support doubles")

print("multiple-nonproper [3,2^7] frontier: PASS")
