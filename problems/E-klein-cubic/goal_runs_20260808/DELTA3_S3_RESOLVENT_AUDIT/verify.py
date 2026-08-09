#!/usr/bin/env python3
"""Independent finite arithmetic replay for the delta=3 boundary."""

from itertools import permutations, product


def compose(p, q):
    """p after q."""
    return tuple(p[q[i]] for i in range(3))


S3 = list(permutations(range(3)))
IDENTITY = tuple(range(3))


def check_s3():
    center = [
        z for z in S3 if all(compose(z, g) == compose(g, z) for g in S3)
    ]
    assert center == [IDENTITY]

    automorphisms = []
    rest = [g for g in S3 if g != IDENTITY]
    for images in permutations(rest):
        phi = {IDENTITY: IDENTITY, **dict(zip(rest, images))}
        if all(
            phi[compose(g, h)] == compose(phi[g], phi[h])
            for g in S3
            for h in S3
        ):
            automorphisms.append(phi)
    assert len(automorphisms) == 6

    inners = []
    for s in S3:
        sinv = tuple(s.index(i) for i in range(3))
        inners.append(
            tuple(compose(compose(s, g), sinv) for g in S3)
        )
    assert len(set(inners)) == 6


def mul_quad(x, y):
    """Multiply a+b*nu using nu^2+nu+3=0."""
    a, b = x
    c, d = y
    return (a * c - 3 * b * d, a * d + b * c - b * d)


def check_cm_norm():
    nu = (0, 1)
    nubar = (-1, -1)
    assert mul_quad(nu, nubar) == (3, 0)


def inv(a, p):
    return pow(a % p, -1, p)


def check_c11():
    p = 11
    delta = 3
    q = [1, 9, 4, 3, 5]
    k = [0, 6, 0, 0, 0]
    assert sum(k[s] * inv(q[s] ** 3, p) for s in range(5)) % p == 2
    assert sum(k) % p == 2 * delta % p
    residues = []
    for b in range(4):
        residues.append(
            7 * sum(k[s] * pow(q[s], b - 3, p) for s in range(5)) % p
        )
    assert residues == [3, 5, 1, 9]


def c5_matrix(v):
    points = [1, 2, 3, 4]
    reps = [
        (1, 1), (1, 4), (1, 2), (1, 3),
        (2, 1), (2, 4), (2, 2), (2, 3),
    ]
    matrix = {(x, y): 0 for x in points for y in points}
    for value, (x, y) in zip(v, reps):
        matrix[(x, y)] = value
        matrix[((-x) % 5, (-y) % 5)] = value
    return matrix


def check_c5():
    p = 5
    delta = 3
    v = [0, 0, 1, 0, 0, 1, 0, 0]
    m = c5_matrix(v)
    points = [1, 2, 3, 4]
    e = {a: 2 * inv(a, p) % p for a in points}
    h = {a: -a % p for a in points}
    for x in points:
        assert sum(m[(x, y)] for y in points) % p == 1
    for y in points:
        assert e[y] * sum(m[(x, y)] * inv(e[x], p) for x in points) % p == delta
    residues = []
    for b in range(4):
        residues.append(
            sum(
                pow(h[x], 3 - b, p)
                * pow(h[y], b, p)
                * inv(e[x], p)
                * m[(x, y)]
                for x in points
                for y in points
            )
            % p
        )
    assert residues == [3, 1, 2, 4]


def add_q(point, q):
    kind = point[0]
    a, b = q
    if kind == "A":
        return ("A", (point[1] + a) % 2)
    return ("B", (point[1] + a) % 2, (point[2] + b) % 2)


def c3_matrix(u):
    points = [("A", a) for a in range(2)] + [
        ("B", a, b) for a in range(2) for b in range(2)
    ]
    reps = [
        (("A", 0), ("A", 0)),
        (("A", 0), ("A", 1)),
        (("A", 0), ("B", 0, 0)),
        (("A", 0), ("B", 1, 0)),
        (("B", 0, 0), ("A", 0)),
        (("B", 0, 0), ("A", 1)),
        (("B", 0, 0), ("B", 0, 0)),
        (("B", 0, 0), ("B", 0, 1)),
        (("B", 0, 0), ("B", 1, 0)),
        (("B", 0, 0), ("B", 1, 1)),
    ]
    matrix = {(x, y): 0 for x in points for y in points}
    for value, (x, y) in zip(u, reps):
        for q in product(range(2), repeat=2):
            matrix[(add_q(x, q), add_q(y, q))] = value
    return points, matrix


def check_c3():
    p = 3
    delta = 0
    u = [0, 0, 0, 2, 0, 0, 0, 0, 0, 1]
    points, m = c3_matrix(u)
    e = {x: (-1 if x[1] else 1) % p for x in points}
    h = dict(e)
    for x in points:
        assert sum(m[(x, y)] for y in points) % p == 1
    for y in points:
        assert e[y] * sum(m[(x, y)] * inv(e[x], p) for x in points) % p == delta
    residues = []
    for b in range(4):
        residues.append(
            sum(
                pow(h[x], 3 - b, p)
                * pow(h[y], b, p)
                * inv(e[x], p)
                * m[(x, y)]
                for x in points
                for y in points
            )
            % p
        )
    assert residues == [0, 0, 0, 0]


def check_integral_lift():
    a = [3, 126, 177, 9]
    assert [x % 3 for x in a] == [0, 0, 0, 0]
    assert [x % 5 for x in a] == [3, 1, 2, 4]
    assert [x % 11 for x in a] == [3, 5, 1, 9]
    assert a[1] % 3 == 0
    assert a[3] == 3 * 3
    assert a[1] ** 2 >= a[0] * a[2]
    assert a[2] ** 2 >= a[1] * a[3]


F6_TERMS = [
    (15, (4, 2, 0, 0, 0)),
    (6, (4, 0, 1, 1, 0)),
    (36, (3, 1, 0, 0, 2)),
    (36, (2, 3, 1, 0, 0)),
    (24, (2, 1, 2, 1, 0)),
    (24, (2, 1, 0, 2, 1)),
    (15, (2, 0, 0, 0, 4)),
    (24, (1, 2, 1, 0, 2)),
    (6, (1, 1, 0, 4, 0)),
    (6, (1, 0, 4, 0, 1)),
    (24, (1, 0, 2, 1, 2)),
    (36, (1, 0, 0, 2, 3)),
    (15, (0, 4, 2, 0, 0)),
    (6, (0, 4, 0, 1, 1)),
    (36, (0, 2, 3, 1, 0)),
    (24, (0, 2, 1, 2, 1)),
    (6, (0, 1, 1, 0, 4)),
    (15, (0, 0, 4, 2, 0)),
    (36, (0, 0, 2, 3, 1)),
    (15, (0, 0, 0, 4, 2)),
]


def eval_poly(terms, x):
    return sum(
        coeff * product_power
        for coeff, exponents in terms
        for product_power in [
            __import__("math").prod(x[i] ** exponents[i] for i in range(5))
        ]
    )


def check_sextic_witness():
    x = (-2, -2, 1, 2, 1)
    klein = sum(x[i] ** 2 * x[(i + 1) % 5] for i in range(5))
    assert klein == 0
    assert eval_poly(F6_TERMS, x) == 960


def main():
    check_s3()
    check_cm_norm()
    check_c11()
    check_c5()
    check_c3()
    check_integral_lift()
    check_sextic_witness()
    print("DELTA3-S3-RESOLVENT-AUDIT-OK")


if __name__ == "__main__":
    main()

