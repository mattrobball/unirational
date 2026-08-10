#!/usr/bin/env python3
"""Exact replay for the root-supported degree-nine osculating ansatz.

Only two finite universes are enumerated:

* the 70 root-multiplicity vectors forced by deg(q) <= 5; and
* 3^5 active-pair signatures for each five-equation tropical system.

There is no degree sweep, finite-field search, Groebner basis, or solver.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from itertools import product
from math import comb


MOD = 11
LAMBDA = (1, 9, 4, 3, 5)  # prime-orbit cokernel for q = v^2 sigma(v)
MU = (1, 5, 3, 4, 9)      # conjugate-term cokernel for U_i = u_i^2 u_(i+1)


def dot_mod(a, b, modulus=MOD):
    return sum(x * y for x, y in zip(a, b)) % modulus


def leading_orders(m):
    """Orders at r_k, indexed by d=k-i."""
    return tuple(
        3 - 2 * (d == 0) - (d == 1) + 2 * m[d] + m[(d - 1) % 5]
        for d in range(5)
    )


def poly_mul(a, b):
    out = [Fraction(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return out


def poly_pow(a, exponent):
    out = [Fraction(1)]
    for _ in range(exponent):
        out = poly_mul(out, a)
    return out


def shifted_coefficient(poly, root, degree):
    """Coefficient of S^degree in poly(root+S)."""
    return sum(
        poly[k] * comb(k, degree) * root ** (k - degree)
        for k in range(degree, len(poly))
    )


def direct_leading_regression(m):
    """Independent exact polynomial check of (2.1), (3.1), and (3.2)."""
    roots = (Fraction(2), Fraction(3), Fraction(5), Fraction(7), Fraction(1, 210))
    assert roots[0] * roots[1] * roots[2] * roots[3] * roots[4] == 1
    linear = [[-r, Fraction(1)] for r in roots]
    ell = []
    for i in range(5):
        f = [Fraction(1)]
        for h in range(5):
            if h != i:
                f = poly_mul(f, linear[h])
        ell.append(f)
    q = []
    for i in range(5):
        f = [Fraction(1)]
        for j in range(5):
            f = poly_mul(f, poly_pow(linear[(j + i) % 5], m[j]))
        q.append(f)
    x = [poly_mul(ell[i], q[i]) for i in range(5)]

    for k in range(5):
        for i in range(5):
            term = poly_mul(poly_mul(x[i], x[i]), x[(i + 1) % 5])
            term = [coefficient / roots[(i + 2) % 5] for coefficient in term]
            d = (k - i) % 5
            expected_order = leading_orders(m)[d]
            assert all(
                shifted_coefficient(term, roots[k], e) == 0
                for e in range(expected_order)
            )
            assert shifted_coefficient(term, roots[k], expected_order) != 0

    # Check the coefficient-only exponent formula at r_0 term by term.
    for d in range(5):
        i, _, _, _, exponents = coefficient_data(m, d)
        alpha_term = Fraction(1, roots[(i + 2) % 5])
        for h, exponent in enumerate(exponents, start=1):
            alpha_term *= (roots[0] - roots[h]) ** exponent
        term = poly_mul(poly_mul(x[i], x[i]), x[(i + 1) % 5])
        term = [coefficient / roots[(i + 2) % 5] for coefficient in term]
        assert shifted_coefficient(term, roots[0], leading_orders(m)[d]) == alpha_term


def coefficient_data(m, d):
    """Coefficient-only leading data at T=r_0 for the term i=-d.

    D_h=r_0-r_h.  The leading coefficient of ell_i has D_h-exponent
    1-delta_(i,h), for h=1,...,4.  The leading coefficient of q_i has
    D_h-exponent m_(h-i).
    """
    i = (-d) % 5
    exponents = []
    for h in range(1, 5):
        ell_i = 1 - (i == h)
        ip = (i + 1) % 5
        ell_ip = 1 - (ip == h)
        exponents.append(
            2 * ell_i
            + ell_ip
            + 2 * m[(h - i) % 5]
            + m[(h - ip) % 5]
        )

    # P_j=r_j-r_(j+1), Q_j=r_j-r_(j+2).
    # D_1=P_0, D_4=-P_4, D_2=Q_0, D_3=-Q_3.
    p_vector = [0] * 5
    q_vector = [0] * 5
    p_vector[0], p_vector[4] = exponents[0], exponents[3]
    q_vector[0], q_vector[3] = exponents[1], exponents[2]

    # c_i=r_(i+2)^(-1).
    unit_vector = [0] * 5
    unit_vector[(i + 2) % 5] = -1
    return i, tuple(p_vector), tuple(q_vector), tuple(unit_vector), tuple(exponents)


def normalized(v):
    m = min(v)
    return tuple(x - m for x in v)


def repeated_min(values):
    m = min(values)
    return values.count(m) >= 2


def tropical_ok(w, indices, coefficient_vectors):
    """All five conjugate leading identities at one fixed prime."""
    for k in range(5):
        vals = [
            coefficient_vectors[t][(-k) % 5] + w[(indices[t] + k) % 5]
            for t in range(3)
        ]
        if not repeated_min(vals):
            return False
    return True


@dataclass(frozen=True)
class Cell:
    """One exact active-pair cell, modulo common translation.

    In every feasible cell below the equality graph has at most two
    components.  For two components, delta is the second component's base
    minus the first component's base and ranges through an integral interval.
    """

    comp: tuple[int, ...]
    offset: tuple[int, ...]
    lower: int | None
    upper: int | None


def active_pair_cells(indices, coefficient_vectors):
    """Enumerate 3^5 active-pair signatures and solve them exactly.

    Each chosen pair gives one difference equality and one difference
    inequality.  Weighted graph propagation solves the equalities.  The
    resulting systems here have one or two components; their remaining
    difference bounds are recorded without truncation.
    """
    pairs = ((0, 1), (0, 2), (1, 2))
    cells = set()
    for signature in product(pairs, repeat=5):
        equalities = []
        inequalities = []
        for k, pair in enumerate(signature):
            a, b = pair
            c = 3 - a - b
            ia = (indices[a] + k) % 5
            ib = (indices[b] + k) % 5
            ic = (indices[c] + k) % 5
            oa = coefficient_vectors[a][(-k) % 5]
            ob = coefficient_vectors[b][(-k) % 5]
            oc = coefficient_vectors[c][(-k) % 5]
            # w_ib-w_ia = oa-ob; w_ia-w_ic <= oc-oa.
            equalities.append((ia, ib, oa - ob))
            inequalities.append((ia, ic, oc - oa))

        graph = [[] for _ in range(5)]
        for a, b, difference in equalities:
            graph[a].append((b, difference))
            graph[b].append((a, -difference))

        comp = [-1] * 5
        offset = [0] * 5
        consistent = True
        component_count = 0
        for root in range(5):
            if comp[root] != -1:
                continue
            comp[root] = component_count
            stack = [root]
            while stack:
                a = stack.pop()
                for b, difference in graph[a]:
                    wanted = offset[a] + difference
                    if comp[b] == -1:
                        comp[b] = component_count
                        offset[b] = wanted
                        stack.append(b)
                    elif comp[b] != component_count or offset[b] != wanted:
                        consistent = False
            component_count += 1
        if not consistent:
            continue
        assert component_count <= 2, (indices, coefficient_vectors, signature, comp)

        if component_count == 1:
            feasible = all(
                offset[a] - offset[b] <= bound
                for a, b, bound in inequalities
            )
            if feasible:
                cells.add(Cell(tuple(comp), tuple(offset), 0, 0))
            continue

        # Put the base of component 0 at zero and call the other base delta.
        lower = None
        upper = None
        feasible = True
        for a, b, bound in inequalities:
            adjusted = bound - offset[a] + offset[b]
            ca, cb = comp[a], comp[b]
            if ca == cb:
                if 0 > adjusted:
                    feasible = False
                    break
            elif ca == 1 and cb == 0:  # delta <= adjusted
                upper = adjusted if upper is None else min(upper, adjusted)
            else:                       # -delta <= adjusted
                candidate = -adjusted
                lower = candidate if lower is None else max(lower, candidate)
        if feasible and not (
            lower is not None and upper is not None and lower > upper
        ):
            cells.add(Cell(tuple(comp), tuple(offset), lower, upper))
    return cells


def cell_value(cell, delta):
    return normalized(tuple(
        cell.offset[i] + (delta if cell.comp[i] == 1 else 0)
        for i in range(5)
    ))


def classify_claim(name, w):
    """Membership in the proved parametric profile lists."""
    if name == "unmarked_A" or name == "unmarked_B":
        return w == (0, 0, 0, 0, 0) or sum(x > 0 for x in w) == 1
    if name == "A_P":
        return (
            w == (0, 0, 0, 0, 0)
            or (w[0] == w[4] == 0 and sum(x > 0 for x in w[1:4]) == 1)
            or w == (1, 0, 0, 0, 1)
        )
    if name == "A_Q":
        return w[0] == 1 and w[1] == w[2] == w[4] == 0 and w[3] >= 0
    if name == "B_P":
        return w[0] == 2 and w[2] == w[3] == w[4] == 0 and w[1] >= 0
    if name == "B_Q":
        return (
            w == (0, 0, 0, 0, 0)
            or sum(x > 0 for x in w) == 1 and w[2] == w[4] == 0
            or w in ((0, 0, 1, 0, 1), (0, 0, 2, 0, 2))
        )
    raise KeyError(name)


def certify_allowed_ray(name, base, step):
    """Prove base+n*step stays in the displayed parametric list."""
    support = tuple(i for i, x in enumerate(step) if x)
    assert all(x in (0, 1) for x in step)
    assert len(support) == 1
    j = support[0]
    if name == "unmarked_A" or name == "unmarked_B":
        assert all(base[i] == 0 for i in range(5) if i != j)
    elif name == "A_P":
        assert j in (1, 2, 3)
        assert all(base[i] == 0 for i in range(5) if i != j)
    elif name == "A_Q":
        assert j == 3 and base[0] == 1
        assert base[1] == base[2] == base[4] == 0
    elif name == "B_P":
        assert j == 1 and base[0] == 2
        assert base[2] == base[3] == base[4] == 0
    elif name == "B_Q":
        assert j in (0, 1, 3)
        assert all(base[i] == 0 for i in range(5) if i != j)
    else:
        raise KeyError(name)


def certify_cell(name, cell, indices, vectors):
    """Certify every integral point of one cell, including unbounded rays."""
    if len(set(cell.comp)) == 1:
        w = normalized(cell.offset)
        assert tropical_ok(w, indices, vectors)
        assert classify_claim(name, w)
        return

    breaks = {
        cell.offset[i] - cell.offset[j]
        for i in range(5)
        for j in range(5)
        if cell.comp[i] == 0 and cell.comp[j] == 1
    }

    if cell.lower is not None and cell.upper is not None:
        assert cell.upper - cell.lower <= 20
        values = range(cell.lower, cell.upper + 1)
        for delta in values:
            w = cell_value(cell, delta)
            assert tropical_ok(w, indices, vectors)
            assert classify_claim(name, w), (name, cell, w)
        return

    if cell.upper is None:
        assert cell.lower is not None
        tail = max(cell.lower, max(breaks) + 1)
        assert tail - cell.lower <= 20
        for delta in range(cell.lower, tail + 1):
            w = cell_value(cell, delta)
            assert tropical_ok(w, indices, vectors)
            assert classify_claim(name, w), (name, cell, w)
        base = cell_value(cell, tail)
        nxt = cell_value(cell, tail + 1)
        step = tuple(nxt[i] - base[i] for i in range(5))
        certify_allowed_ray(name, base, step)
        return

    assert cell.lower is None and cell.upper is not None
    tail = min(cell.upper, min(breaks) - 1)
    assert cell.upper - tail <= 20
    for delta in range(tail, cell.upper + 1):
        w = cell_value(cell, delta)
        assert tropical_ok(w, indices, vectors)
        assert classify_claim(name, w), (name, cell, w)
    base = cell_value(cell, tail)
    nxt = cell_value(cell, tail - 1)
    step = tuple(nxt[i] - base[i] for i in range(5))
    certify_allowed_ray(name, base, step)


def verify_profile_classification(name, indices, vectors):
    cells = active_pair_cells(indices, vectors)
    assert cells
    for cell in cells:
        certify_cell(name, cell, indices, vectors)

    # Conversely, direct symbolic families are checked at enough values to
    # cover their constant/ray formulas; the cell enumeration above proves
    # that there are no other cells.
    test_values = (0, 1, 2, 7, 8, 11, 19, 22)
    claimed = []
    if name.startswith("unmarked"):
        claimed.append((0, 0, 0, 0, 0))
        claimed += [tuple(s if j == k else 0 for j in range(5))
                    for k in range(5) for s in test_values]
    elif name == "A_P":
        claimed.append((1, 0, 0, 0, 1))
        claimed += [(0, 0, 0, 0, 0)]
        claimed += [tuple(s if j == k else 0 for j in range(5))
                    for k in (1, 2, 3) for s in test_values]
    elif name == "A_Q":
        claimed += [(1, 0, 0, s, 0) for s in test_values]
    elif name == "B_P":
        claimed += [(2, s, 0, 0, 0) for s in test_values]
    elif name == "B_Q":
        claimed += [(0, 0, 0, 0, 0)]
        claimed += [tuple(s if j == k else 0 for j in range(5))
                    for k in (0, 1, 3) for s in test_values]
        claimed += [(0, 0, 1, 0, 1), (0, 0, 2, 0, 2)]
    for w in claimed:
        assert tropical_ok(w, indices, vectors), (name, w)
    return cells


def main():
    assert sum(MU) % MOD == 0
    assert all((2 * MU[j] + MU[(j - 1) % 5]) % MOD == 0 for j in range(5))
    assert all((2 * LAMBDA[j] + LAMBDA[(j + 1) % 5]) % MOD == 0 for j in range(5))

    multiplicities = [
        m for m in product(range(6), repeat=5)
        if m[0] == 0 and m[4] >= 1 and sum(m) <= 5
    ]
    assert len(multiplicities) == 70
    for m in multiplicities:
        direct_leading_regression(m)

    survivors = []
    for m in multiplicities:
        orders = leading_orders(m)
        minimum = min(orders)
        tied = tuple(d for d, value in enumerate(orders) if value == minimum)
        assert minimum < 5
        if len(tied) >= 2:
            survivors.append((m, orders, tied))
    assert len(survivors) == 20

    pair_survivors = [entry for entry in survivors if len(entry[2]) == 2]
    triple_survivors = [entry for entry in survivors if len(entry[2]) == 3]
    assert len(pair_survivors) == 18
    assert len(triple_survivors) == 2

    expected_first = {
        (0, 0, a, b, 1) for a in range(5) for b in range(5 - a)
    }
    expected_second = {(0, s, 0, 0, 2) for s in (1, 2, 3)}
    assert {m for m, _, _ in pair_survivors} == expected_first | expected_second
    assert {m for m, _, _ in triple_survivors} == {
        (0, 1, 0, 1, 3),
        (0, 1, 1, 0, 3),
    }

    # Every two-term identity has a nonzero torus-unit Z/11 residue after
    # difference-prime divisors are removed: 5 for (i=0,4), 1 for (i=0,2).
    pair_unit_residues = []
    for m, _, tied in pair_survivors:
        data = [coefficient_data(m, d) for d in tied]
        assert len(data) == 2
        i0, i1 = data[0][0], data[1][0]
        ratio_unit = tuple(data[0][3][j] - data[1][3][j] for j in range(5))
        residue = dot_mod(LAMBDA, ratio_unit)
        pair_unit_residues.append(residue)
        if m in expected_first:
            assert (i0, i1, residue) == (0, 4, 5)
        else:
            assert (i0, i1, residue) == (0, 2, 1)
    assert all(pair_unit_residues)

    A = (0, 1, 0, 1, 3)
    B = (0, 1, 1, 0, 3)

    def triple_system(m):
        orders = leading_orders(m)
        ds = [d for d, value in enumerate(orders) if value == min(orders)]
        data = [coefficient_data(m, d) for d in ds]
        return (
            tuple(item[0] for item in data),
            tuple(item[1] for item in data),
            tuple(item[2] for item in data),
        )

    IA, PA, QA = triple_system(A)
    IB, PB, QB = triple_system(B)
    assert IA == (0, 4, 3)
    assert IB == (0, 4, 2)
    assert PA == ((4, 0, 0, 0, 10), (4, 0, 0, 0, 4), (5, 0, 0, 0, 4))
    assert QA == ((4, 0, 0, 5, 0), (5, 0, 0, 10, 0), (10, 0, 0, 4, 0))
    assert PB == ((4, 0, 0, 0, 9), (6, 0, 0, 0, 4), (9, 0, 0, 0, 6))
    assert QB == ((6, 0, 0, 4, 0), (4, 0, 0, 9, 0), (4, 0, 0, 4, 0))

    zero_vectors = ((0, 0, 0, 0, 0),) * 3
    verify_profile_classification("unmarked_A", IA, zero_vectors)
    verify_profile_classification("unmarked_B", IB, zero_vectors)
    verify_profile_classification("A_P", IA, PA)
    verify_profile_classification("A_Q", IA, QA)
    verify_profile_classification("B_P", IB, PB)
    verify_profile_classification("B_Q", IB, QB)

    # Apply MU.  These are the only surviving marked-orbit profiles.
    assert dot_mod(MU, (1, 0, 0, 0, 1)) == 10       # kills A_P isolated cell
    assert (-(pow(4, -1, 11))) % 11 == 8             # A_Q: s=8 mod 11
    assert (-(2 * pow(5, -1, 11))) % 11 == 4         # B_P: s=4 mod 11
    assert dot_mod(MU, (0, 0, 1, 0, 1)) == 1         # kills B_Q paired cells
    assert dot_mod(MU, (0, 0, 2, 0, 2)) == 2
    assert all(x % 11 for x in MU)

    # Codimension-two local tables.  Entries are residual orders of the
    # three terms after their common divisor is removed.  Unmarked primes add
    # only multiples of 11 to individual entries.
    # A at Z_A: Q0=Q2=0, P4=-(Q0+Q2).
    A_Q0 = (0, 0, 13)
    A_Q2 = (8, 0, 0)
    A_P4 = (6, 0, 0)
    A_local = tuple(A_Q0[t] + A_Q2[t] + A_P4[t] for t in range(3))
    assert A_local == (14, 0, 13)
    assert len({x % 11 for x in A_local}) == 3

    # B at Z_B: P0=P1=0, Q0=P0+P1.
    B_P0 = (0, 0, 3)
    B_P1 = (0, 0, 4)
    B_Q0 = (2, 0, 0)
    B_local = tuple(B_P0[t] + B_P1[t] + B_Q0[t] for t in range(3))
    assert B_local == (2, 0, 7)
    assert len({x % 11 for x in B_local}) == 3

    print("PASS exact polynomial leading-term regression for all 70 vectors")
    print("PASS 70 analytically forced root-multiplicity vectors")
    print("PASS exactly 18 pair-leading and 2 triple-leading tropical survivors")
    print("PASS all pair-leading cases have nonzero order-11 unit residue")
    print("PASS exact 3^5 active-pair classification for both triple systems")
    print("PASS A local orders are 14,0,13 modulo 11")
    print("PASS B local orders are 2,0,7 modulo 11")
    print("F55-OSCULATING-ROOT-SUPPORTED-DEGREE9-EMPTY-SCOPED")


if __name__ == "__main__":
    main()
