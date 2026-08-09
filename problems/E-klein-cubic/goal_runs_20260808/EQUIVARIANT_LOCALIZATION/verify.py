#!/usr/bin/env python3
"""Small exact checks for THEOREM.md; every search is over F_11 only."""

P = 11
Q = [1, 9, 4, 3, 5]


def inv(a):
    return pow(a, P - 2, P)


assert [pow(-2, i, P) for i in range(5)] == Q
assert sorted(Q) == sorted(x for x in range(1, P) if pow(x, 5, P) == 1)

# Tangent Euler denominator and the regular-vertex contradiction.
for qi in Q:
    den = 1
    for qj in Q:
        if qj != qi:
            den = den * (qj - qi) % P
    assert den == 5 * pow(qi, 4, P) % P

for s, qs in enumerate(Q):
    residue = 0
    for i, qi in enumerate(Q):
        residue += pow(Q[(i + s) % 5], 4, P) * inv(5 * pow(qi, 4, P))
    assert residue % P == pow(qs, 4, P) != 0

# Independent finite cross-check of the analytic affine-image lemma.
survivors = []
for d in range(P):
    for m in range(1, P):
        vals = [(m * q + d - m) % P for q in Q[1:]]
        if all(v in Q for v in vals):
            survivors.append((d, m, vals))

assert [(d, m) for d, m, _ in survivors] == [(q, q) for q in sorted(Q)]
for d, m, _ in survivors:
    assert (pow(d, 4, P) - 5 * pow(m, 4, P)) % P != 0

# Fourier conservation and inversion.
for s, qs in enumerate(Q):
    for r, qr in enumerate(Q):
        total = sum(pow(qs * inv(qr) % P, b, P) for b in range(5)) % P
        assert total == (5 if s == r else 0)

n = [4, 8, 0, 0, 0]
moments = [sum(n[s] * pow(Q[s], b, P) for s in range(5)) % P for b in range(5)]
assert moments == [1, 10, 3, 6, 0]

recovered = []
for s, qs in enumerate(Q):
    value = inv(5) * sum(moments[b] * pow(inv(qs), b, P) for b in range(5))
    recovered.append(value % P)
assert recovered == n

# Positive/log-concave numerical lift used only as a no-obstruction witness.
g = [1, 10, 91, 798, 0]
assert [x % P for x in g] == moments
assert g[3] % 3 == 0
assert g[1] ** 2 >= g[0] * g[2]
assert g[2] ** 2 >= g[1] * g[3]
assert g[2] <= g[1] ** 2
assert g[3] <= g[1] * g[2]

print("F55-C11-EQUIVARIANT-LOCALIZATION-OK")
