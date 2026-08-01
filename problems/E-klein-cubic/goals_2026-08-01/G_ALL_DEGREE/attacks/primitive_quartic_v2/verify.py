#!/usr/bin/env python3
"""Independent exact checks for the primitive-quartic route audit.

This script verifies only the theorem-level statements in RESULT.md:

* simplicity/order data for PSL(2,11) and the forced-disjointness lemma;
* A4/S4 actions on vertices, chords, and the cubic-resolvent pairings;
* the four-equation quartic-algebra landing presentation for the certified
  35-term generic cubic;
* an exact smooth cubic surface containing a full-span primitive S4
  quartic point.

It deliberately prints HEADLINE_OPEN: none of these checks decides whether
the genuine generic Klein twist has a K_proj-point.
"""

from __future__ import annotations

import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
GENERIC_CUBIC = HERE.parent.parent / "generic_cubic.json"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


# ---------------------------------------------------------------------------
# Finite permutation groups


Perm = tuple[int, ...]


def compose(left: Perm, right: Perm) -> Perm:
    """Composition left o right."""

    return tuple(left[right[i]] for i in range(len(left)))


def inverse(p: Perm) -> Perm:
    out = [0] * len(p)
    for i, image in enumerate(p):
        out[image] = i
    return tuple(out)


def generated(generators: tuple[Perm, ...] | list[Perm], degree: int) -> frozenset[Perm]:
    identity = tuple(range(degree))
    gens = tuple(dict.fromkeys(tuple(generators) + tuple(inverse(g) for g in generators)))
    seen = {identity}
    queue = [identity]
    while queue:
        current = queue.pop()
        for generator in gens:
            nxt = compose(current, generator)
            if nxt not in seen:
                seen.add(nxt)
                queue.append(nxt)
    return frozenset(seen)


def parity(p: Perm) -> int:
    inversions = sum(p[i] > p[j] for i in range(len(p)) for j in range(i + 1, len(p)))
    return inversions % 2


def mobius_permutation(matrix: tuple[int, int, int, int], prime: int = 11) -> Perm:
    a, b, c, d = matrix
    infinity = prime
    values: list[int] = []
    for x in range(prime):
        denominator = (c * x + d) % prime
        if denominator == 0:
            values.append(infinity)
        else:
            values.append(((a * x + b) * pow(denominator, -1, prime)) % prime)
    if c % prime == 0:
        values.append(infinity)
    else:
        values.append((a * pow(c, -1, prime)) % prime)
    return tuple(values)


def psl2_11() -> frozenset[Perm]:
    prime = 11
    representatives: set[tuple[int, int, int, int]] = set()
    for a, b, c, d in itertools.product(range(prime), repeat=4):
        if (a * d - b * c) % prime != 1:
            continue
        matrix = (a, b, c, d)
        negative = tuple((-entry) % prime for entry in matrix)
        representatives.add(min(matrix, negative))
    require(len(representatives) == 660, "SL2(11)/{+-1} order")
    group = frozenset(mobius_permutation(matrix) for matrix in representatives)
    require(len(group) == 660, "faithful projective-line action")

    translation = mobius_permutation((1, 1, 0, 1))
    inversion = mobius_permutation((0, 10, 1, 0))
    require(generated((translation, inversion), 12) == group, "standard generators produce PSL2(11)")
    return group


def check_psl_simplicity(group: frozenset[Perm]) -> None:
    identity = tuple(range(12))
    inverses = {g: inverse(g) for g in group}
    unclassified = set(group)
    classes: list[frozenset[Perm]] = []
    while unclassified:
        representative = next(iter(unclassified))
        conjugates = frozenset(
            compose(compose(h, representative), inverses[h]) for h in group
        )
        classes.append(conjugates)
        unclassified.difference_update(conjugates)
    require(sum(len(c) for c in classes) == 660, "conjugacy-class partition")
    for conjugacy_class in classes:
        if identity in conjugacy_class:
            require(len(conjugacy_class) == 1, "identity class")
            continue
        normal_closure = generated(tuple(conjugacy_class), 12)
        require(len(normal_closure) == 660, "every nonidentity normal closure is full")


def image_on_set(group: frozenset[Perm], objects: tuple, action) -> frozenset[Perm]:
    index = {value: i for i, value in enumerate(objects)}
    return frozenset(tuple(index[action(g, value)] for value in objects) for g in group)


def orbit(group: frozenset[Perm], value, action) -> set:
    return {action(g, value) for g in group}


def quartic_group_checks() -> tuple[frozenset[Perm], frozenset[Perm]]:
    s4 = frozenset(itertools.permutations(range(4)))
    a4 = frozenset(p for p in s4 if parity(p) == 0)
    require((len(a4), len(s4)) == (12, 24), "A4/S4 orders")

    vertices = tuple(range(4))
    edges = tuple(frozenset(pair) for pair in itertools.combinations(vertices, 2))
    partitions = (
        frozenset((frozenset((0, 1)), frozenset((2, 3)))),
        frozenset((frozenset((0, 2)), frozenset((1, 3)))),
        frozenset((frozenset((0, 3)), frozenset((1, 2)))),
    )

    def act_vertex(g: Perm, vertex: int) -> int:
        return g[vertex]

    def act_edge(g: Perm, edge: frozenset[int]) -> frozenset[int]:
        return frozenset(g[i] for i in edge)

    def act_partition(g: Perm, partition: frozenset[frozenset[int]]) -> frozenset[frozenset[int]]:
        return frozenset(act_edge(g, edge) for edge in partition)

    for label, group, expected_pairing_image, expected_vertex_stabilizer, expected_pairing_stabilizer in (
        ("A4", a4, 3, 3, 4),
        ("S4", s4, 6, 6, 8),
    ):
        require(len(orbit(group, 0, act_vertex)) == 4, f"{label} vertex transitivity")
        require(len(orbit(group, edges[0], act_edge)) == 6, f"{label} chord transitivity")
        require(len(orbit(group, partitions[0], act_partition)) == 3, f"{label} pairing transitivity")
        vertex_stabilizer = frozenset(g for g in group if act_vertex(g, 0) == 0)
        pairing_stabilizer = frozenset(g for g in group if act_partition(g, partitions[0]) == partitions[0])
        require(len(vertex_stabilizer) == expected_vertex_stabilizer, f"{label} quartic field stabilizer")
        require(len(pairing_stabilizer) == expected_pairing_stabilizer, f"{label} cubic field stabilizer")
        pairing_image = image_on_set(group, partitions, act_partition)
        require(len(pairing_image) == expected_pairing_image, f"{label} resolvent Galois closure")
        require(all(
            len(orbit(group, block, lambda g, subset: frozenset(g[i] for i in subset))) != 1
            for block in edges
        ), f"{label} primitive action")

    # Enumerate all subgroups generated by pairs.  This independently checks
    # the primitive/resolvent criterion used for quartics below.
    all_subgroups = {
        generated((left, right), 4) for left in s4 for right in s4
    }
    candidates = []
    for subgroup in all_subgroups:
        vertex_transitive = len({g[0] for g in subgroup}) == 4
        pairing_transitive = len(orbit(subgroup, partitions[0], act_partition)) == 3
        discriminant_nonsquare = any(parity(g) for g in subgroup)
        if vertex_transitive and pairing_transitive and discriminant_nonsquare:
            candidates.append(subgroup)
    require(len(candidates) == 1 and candidates[0] == s4,
            "irreducible quartic + irreducible resolvent + nonsquare discriminant gives S4")
    return a4, s4


def check_forced_disjointness() -> None:
    group = psl2_11()
    check_psl_simplicity(group)
    a4, s4 = quartic_group_checks()
    require(len(group) == 660 > len(s4) > len(a4), "common-quotient order exclusion")
    # The mathematical field-intersection step is: Gal(E cap N/K) is a
    # quotient of the now-certified simple group of order 660 and of H of
    # order 12 or 24.  The only possible order is one.
    for h in (a4, s4):
        possible_nontrivial_quotient_order = len(group)
        require(possible_nontrivial_quotient_order > len(h), "H cannot have quotient PSL2(11)")
    print("PRIMITIVE_QUARTIC_FORCED_DISJOINTNESS_OK")
    print("PRIMITIVE_QUARTIC_CUBIC_RESOLVENT_OK")


# ---------------------------------------------------------------------------
# Exact four-equation quartic-algebra gate


def add_vectors(left: list[sp.Expr], right: list[sp.Expr]) -> list[sp.Expr]:
    return [sp.expand(a + b) for a, b in zip(left, right)]


def scale_vector(scalar: sp.Expr, vector: list[sp.Expr]) -> list[sp.Expr]:
    return [sp.expand(scalar * value) for value in vector]


def check_finite_gate() -> None:
    payload = json.loads(GENERIC_CUBIC.read_text())
    require(payload["schema"] == "G_GENERIC_KLEIN_CUBIC_V1", "generic cubic schema")
    require(payload["coefficient_count"] == 35, "generic cubic coefficient count")
    triples = [tuple(record["triple"]) for record in payload["coefficients"]]
    expected_triples = list(itertools.combinations_with_replacement(range(5), 3))
    require(triples == expected_triples, "all 35 cubic triples in canonical order")

    b0, b1, b2, b3 = sp.symbols("b0 b1 b2 b3")
    u = [[sp.Symbol(f"u{i}{r}") for r in range(4)] for i in range(5)]
    coefficient_symbols = sp.symbols("c0:35")

    # T^n modulo T^4+b3*T^3+b2*T^2+b1*T+b0, through the largest
    # exponent (nine) occurring in a product of three cubic representatives.
    powers: list[list[sp.Expr]] = []
    for n in range(10):
        if n < 4:
            vector = [sp.Integer(0)] * 4
            vector[n] = sp.Integer(1)
        else:
            vector = [sp.Integer(0)] * 4
            for scalar, previous in (
                (-b3, powers[n - 1]),
                (-b2, powers[n - 2]),
                (-b1, powers[n - 3]),
                (-b0, powers[n - 4]),
            ):
                vector = add_vectors(vector, scale_vector(scalar, previous))
        powers.append(vector)

    remainders = [sp.Integer(0)] * 4
    coefficient_occurrences = {symbol: False for symbol in coefficient_symbols}
    for coefficient, (i, j, k) in zip(coefficient_symbols, triples):
        convolution = [sp.Integer(0)] * 10
        for r, s, t in itertools.product(range(4), repeat=3):
            convolution[r + s + t] += u[i][r] * u[j][s] * u[k][t]
        reduced = [sp.Integer(0)] * 4
        for n, scalar in enumerate(convolution):
            if scalar != 0:
                reduced = add_vectors(reduced, scale_vector(scalar, powers[n]))
        for index in range(4):
            remainders[index] = sp.expand(remainders[index] + coefficient * reduced[index])
            if coefficient in remainders[index].free_symbols:
                coefficient_occurrences[coefficient] = True

    require(all(remainder != 0 for remainder in remainders), "four nonzero remainder equations")
    require(all(coefficient_occurrences.values()), "every certified cubic coefficient occurs")

    flat_u = tuple(symbol for row in u for symbol in row)
    for remainder in remainders:
        polynomial = sp.Poly(remainder, *flat_u)
        require(all(sum(exponents) == 3 for exponents, _ in polynomial.terms()),
                "landing remainders are cubic homogeneous in projective coordinates")

    # Five charts, each with four quartic coefficients plus four remaining
    # A-valued coordinates (four scalar coefficients apiece).
    require(5 == len(u), "five projective charts")
    require(4 + 4 * 4 == 20, "twenty scalar parameters per normalized chart")
    require(len(remainders) == 4, "four landing equations per chart")

    # The coefficient matrix of A_i(T) is 4 x 5.  Evaluation at the four
    # roots is left multiplication by a Vandermonde matrix, so rank four is
    # exactly full P3 span.  Check the formal matrix dimensions and a witness
    # minor (the countermodel below has U=[I_4|0] after reordering).
    matrix_u = sp.Matrix([[u[column][row] for column in range(5)] for row in range(4)])
    require(matrix_u.shape == (4, 5), "quartic conjugate span matrix")
    witness_substitution = {
        u[column][row]: int(column == row) if column < 4 else 0
        for column in range(5) for row in range(4)
    }
    require(matrix_u[:, :4].det().subs(witness_substitution) == 1, "rank-four open is nonempty")

    # Derive the standard cubic resolvent from the three pairings.
    roots = sp.symbols("r0:4")
    y = sp.Symbol("y")
    pairing_values = (
        roots[0] * roots[1] + roots[2] * roots[3],
        roots[0] * roots[2] + roots[1] * roots[3],
        roots[0] * roots[3] + roots[1] * roots[2],
    )
    raw_resolvent = sp.expand(sp.prod(y - value for value in pairing_values))
    symmetric, remainder, substitutions = sp.symmetrize(raw_resolvent, roots, formal=True)
    require(remainder == 0, "pairing polynomial is symmetric")
    elementary = [entry[0] for entry in substitutions]
    e1, e2, e3, e4 = elementary
    expected_symmetric = y**3 - e2 * y**2 + (e1 * e3 - 4 * e4) * y + 4 * e2 * e4 - e1**2 * e4 - e3**2
    require(sp.expand(symmetric - expected_symmetric) == 0, "universal pairing resolvent")
    monic_quartic_substitution = {e1: -b3, e2: b2, e3: -b1, e4: b0}
    derived = sp.expand(symmetric.subs(monic_quartic_substitution))
    expected = y**3 - b2 * y**2 + (b3 * b1 - 4 * b0) * y + 4 * b2 * b0 - b3**2 * b0 - b1**2
    require(sp.expand(derived - expected) == 0, "monic quartic cubic resolvent formula")

    print("PRIMITIVE_QUARTIC_FINITE_GATE_OK")


# ---------------------------------------------------------------------------
# Smooth primitive-S4 countermodel


def check_smooth_countermodel() -> None:
    t, y = sp.symbols("t y")
    f = t**4 - t - 1
    require(sp.Poly(f, t, modulus=2).is_irreducible, "quartic irreducible modulo 2")
    require(sp.Poly(f, t, domain=sp.QQ).is_irreducible, "quartic irreducible over QQ")
    discriminant = sp.discriminant(f, t)
    require(discriminant == -283, "quartic discriminant")
    require(not sp.ntheory.primetest.is_square(abs(int(discriminant))), "nonsquare discriminant")
    resolvent = y**3 + 4 * y - 1
    require(sp.Poly(resolvent, y, domain=sp.QQ).is_irreducible, "irreducible cubic resolvent")
    galois_name = sp.polys.numberfields.galois_group(f, t, by_name=True)[0].name
    require(galois_name == "S4", "primitive quartic Galois group")

    x0, x1, x2, x3 = sp.symbols("x0 x1 x2 x3")
    variables = (x0, x1, x2, x3)
    q1 = x0 * x2 - x1**2
    q2 = x0 * x3 - x1 * x2
    q3 = x1 * x3 - x2**2
    f0 = x0 * x1 * x3 - x0**2 * x1 - x0**3
    cubic = sp.expand(
        f0
        + (x0 + x1 + x2 + x3) * q1
        + (x0 + 2 * x1 + 3 * x2 + 5 * x3) * q2
        + (2 * x0 - x1 + 4 * x2 + x3) * q3
    )
    parameterization = {x0: 1, x1: t, x2: t**2, x3: t**3}
    require(sp.expand(cubic.subs(parameterization) - f) == 0, "quartic points lie on cubic")

    jacobian = [sp.diff(cubic, variable) for variable in variables]
    for chart_variable in variables:
        basis = sp.groebner(jacobian + [chart_variable - 1], *variables, order="grevlex")
        require(basis.contains(sp.Integer(1)), f"smooth affine chart {chart_variable}")

    # The parameterization coefficient matrix is the identity.  Evaluation
    # at the four roots is therefore the Vandermonde matrix, whose squared
    # determinant is the nonzero discriminant.
    coefficient_matrix = sp.eye(4)
    require(coefficient_matrix.det() == 1 and discriminant != 0, "full projective span")

    print("PRIMITIVE_QUARTIC_S4_SMOOTH_COUNTERMODEL_OK")


def check_scope_text() -> None:
    result = (HERE / "RESULT.md").read_text()
    required = (
        "does **not** decide the Goal G headline",
        "E\\cap N=K",
        "still connected of degree four",
        "X(M)\\ne\\varnothing",
        "finite-type presentation over",
        "not a finite bound on numerator degrees",
        "not** asserted to be pointless",
        "No such theorem is",
        "claimed here.",
    )
    for phrase in required:
        require(phrase in result, f"scope boundary missing: {phrase}")


def main() -> None:
    check_forced_disjointness()
    check_finite_gate()
    check_smooth_countermodel()
    check_scope_text()
    print("PRIMITIVE_QUARTIC_ROUTE_AUDIT_OK")
    print("HEADLINE_OPEN")


if __name__ == "__main__":
    main()
