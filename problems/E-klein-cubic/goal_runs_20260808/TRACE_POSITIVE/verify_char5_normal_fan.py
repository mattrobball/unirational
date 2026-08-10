#!/usr/bin/env python3
"""Dependency-free arithmetic checks for CHAR5_NORMAL_FAN_ADDENDUM.md."""

W = (1, 9, 4, 3, 5)
P = (0, 0, 0, 4, 0)
Q = (2, 0, 0, 0, 2)
R = (3, 1, 0, 0, 0)


def rho(v, i=1):
    i %= 5
    return tuple(v[(j - i) % 5] for j in range(5))


def dot(a, b):
    return sum(x * y for x, y in zip(a, b))


def row_for(letter, i):
    return rho({"P": P, "Q": Q, "R": R}[letter], i)


def mat_vec(rows, v):
    return tuple(dot(row, v) for row in rows)


assert all(sum(v) == 4 and dot(W, v) % 11 == 1 for v in (P, Q, R))

# Coefficient-vector form of sum(y_i)=0 and r_i-q_i=y_(i+1)/2.
y = []
for i in range(5):
    y.append(tuple(a - b for a, b in zip(rho(Q, i), rho(P, i))))
assert tuple(sum(y[i][j] for i in range(5)) for j in range(5)) == (0,) * 5
for i in range(5):
    lhs = tuple(2 * (a - b) for a, b in zip(rho(R, i), rho(Q, i)))
    assert lhs == y[(i + 1) % 5]

words = (
    "PPPPQ", "PPPRQ", "PPQPQ", "PPQRQ", "PPRRQ",
    "PQPRQ", "PQRRQ", "PRQRQ", "PRRRQ",
)
kernels = (
    (0, 0, 1, 0, 0),
    (0, 1, 0, 0, 0),
    (1, 0, 0, 0, 0),
    (1, 0, 0, 0, 0),
    (1, 0, 0, 0, 0),
    (0, 0, 1, 0, 0),
    (-1, 1, 0, 0, 0),
    (1, 0, 0, 0, 0),
    (1, 0, 0, 0, 0),
)
for word, kernel in zip(words, kernels):
    rows = tuple(row_for(letter, i) for i, letter in enumerate(word))
    assert mat_vec(rows, kernel) == (0,) * 5

# The explicit Tate-line term is unique among the six products in f^2 rho(f).
u = (2, 2, 3, 1, 2)
v = (2, 2, 1, 2, 3)
assert all(sum(a) == 10 and dot(W, a) % 11 == 1 for a in (u, v))
target = (6,) * 5
terms = []
for left, multiplicity in ((tuple(2 * z for z in u), "a2"),
                           (tuple(u[j] + v[j] for j in range(5)), "2ab"),
                           (tuple(2 * z for z in v), "b2")):
    for right, label in ((rho(u), "a"), (rho(v), "b")):
        terms.append((tuple(left[j] + right[j] for j in range(5)),
                      multiplicity + label))
assert [label for exponent, label in terms if exponent == target] == ["2aba"]

print("F55-CHAR5-NORMAL-FAN-COUNTEREXAMPLE-AND-TATE-CHECKS-OK")
