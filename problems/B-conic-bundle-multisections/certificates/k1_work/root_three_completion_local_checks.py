#!/usr/bin/env python3
"""Arithmetic checks for root_three_completion_theorem.md."""


def prime_coefficients(weights, parents):
    values = []
    for weight, proximate_parents in zip(weights, parents):
        values.append(weight + sum(values[j] for j in proximate_parents))
    return values


def main() -> None:
    free4 = [(), (0,), (1,), (2,)]
    free5 = [(), (0,), (1,), (2,), (3,)]
    free6 = [(), (0,), (1,), (2,), (3,), (4,)]
    satellite4 = [(), (0,), (1,), (2, 1)]

    assert prime_coefficients([1, 1, 0, 1], free4) == [1, 2, 2, 3]
    assert prime_coefficients([1, 0, 1, 0, 1], free5) == [1, 1, 2, 2, 3]
    assert prime_coefficients([1, 1, 0, 1], satellite4) == [1, 2, 2, 5]
    assert prime_coefficients([0, 1, 0, 1, 0, 1], free6) == [0, 1, 1, 2, 2, 3]
    assert prime_coefficients([0, 2, 0, 2, 0, 2], free6) == [0, 2, 2, 4, 4, 6]

    normalization_bad = (10 + 2) + (6 + 3)
    gluing_zero_value = (9 + 2) + (5 + 3)
    gluing_rank_one_value = (8 + 2) + (5 + 3) + 2
    assert normalization_bad == 21
    assert gluing_zero_value == 19
    assert gluing_rank_one_value == 20
    glued_bad = max(gluing_zero_value, gluing_rank_one_value)
    assert 36 - glued_bad - 7 == 9
    rank2 = [
        36 - 12 - 9 - 7,
        33 - 9 - 9 - 6,
        33 - 12 - 6 - 6,
        32 - 11 - 8 - 5,
    ]
    assert rank2 == [8, 9, 9, 8]

    print("A-F prime coefficients: [1, 2, 2, 3]")
    print("proper F-F prime coefficients: [1, 1, 2, 2, 3]")
    print("A-S prime coefficients: [1, 2, 2, 5]")
    print("nonproper F-F D coefficients: [0, 1, 1, 2, 2, 3]")
    print("nonproper F-F 2D coefficients: [0, 2, 2, 4, 4, 6]")
    print("rank-three normalization-only bad dimension:", normalization_bad)
    print("rank-three M=0 glued bad dimension:", gluing_zero_value)
    print("rank-three rank-one-M glued bad dimension:", gluing_rank_one_value)
    print("rank-three codimension: 9")
    print("rank-two codimensions:", rank2)
    print("all root-three completion arithmetic checks passed")


if __name__ == "__main__":
    main()
