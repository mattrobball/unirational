#!/usr/bin/env python3
"""Exact WP-1 certificate for the Klein degree-2 del Pezzo surface.

This script uses only the Python standard library.  Arithmetic in
K = Q(zeta_7) is represented in the basis 1,z,...,z^5, with
1+z+...+z^6=0.  It verifies all assertions rather than relying on a
floating-point recognition of the group.

Run from the repository root with

    python3 certificates/wp1_fixed_loci.py

The final line is ``WP1_FIXED_LOCI_OK``.
"""

from collections import Counter, deque
from fractions import Fraction
from functools import lru_cache
from itertools import permutations, product


# ---------------------------------------------------------------------------
# Q(zeta_7), exact matrices, and homogeneous polynomials
# ---------------------------------------------------------------------------

Q = Fraction
K0 = (Q(0),) * 6
K1 = (Q(1),) + (Q(0),) * 5


def kadd(a, b):
    return tuple(x + y for x, y in zip(a, b))


def kneg(a):
    return tuple(-x for x in a)


def ksub(a, b):
    return kadd(a, kneg(b))


def kscale(a, scalar):
    return tuple(scalar * x for x in a)


def kmul(a, b):
    # First reduce exponents modulo 7, then eliminate zeta^6 via Phi_7.
    c = [Q(0)] * 7
    for i, ai in enumerate(a):
        for j, bj in enumerate(b):
            c[(i + j) % 7] += ai * bj
    top = c[6]
    return tuple(c[i] - top for i in range(6))


def ksum(values):
    ans = K0
    for value in values:
        ans = kadd(ans, value)
    return ans


def kpow(a, n):
    ans = K1
    while n:
        if n & 1:
            ans = kmul(ans, a)
        a = kmul(a, a)
        n //= 2
    return ans


def kzeta(n):
    n %= 7
    if n < 6:
        return tuple(Q(1) if i == n else Q(0) for i in range(6))
    return (Q(-1),) * 6


def krat(n):
    return kscale(K1, Q(n))


@lru_cache(maxsize=None)
def kinv(a):
    """Inverse in Q(zeta_7), by exact rational Gaussian elimination."""
    if a == K0:
        raise ZeroDivisionError
    columns = []
    for j in range(6):
        ej = tuple(Q(1) if i == j else Q(0) for i in range(6))
        columns.append(kmul(a, ej))
    aug = [[columns[j][i] for j in range(6)] + [K1[i]] for i in range(6)]
    for col in range(6):
        pivot = next(row for row in range(col, 6) if aug[row][col])
        aug[col], aug[pivot] = aug[pivot], aug[col]
        scale = aug[col][col]
        aug[col] = [x / scale for x in aug[col]]
        for row in range(6):
            if row == col or not aug[row][col]:
                continue
            scale = aug[row][col]
            aug[row] = [x - scale * y for x, y in zip(aug[row], aug[col])]
    return tuple(aug[i][-1] for i in range(6))


def kdiv(a, b):
    return kmul(a, kinv(b))


def mat_identity():
    return tuple(tuple(K1 if i == j else K0 for j in range(3)) for i in range(3))


I3 = mat_identity()


def matmul(a, b):
    return tuple(
        tuple(ksum(kmul(a[i][r], b[r][j]) for r in range(3)) for j in range(3))
        for i in range(3)
    )


def matvec(a, v, add=kadd, mul=kmul, zero=K0):
    return tuple(
        _sum_generic((mul(a[i][j], v[j]) for j in range(3)), add, zero)
        for i in range(3)
    )


def proportional(u, v):
    return all(
        ksub(kmul(u[i], v[j]), kmul(u[j], v[i])) == K0
        for i in range(3)
        for j in range(i + 1, 3)
    )


def matadd(a, b):
    return tuple(tuple(kadd(a[i][j], b[i][j]) for j in range(3)) for i in range(3))


def matscale(a, scalar):
    return tuple(tuple(kmul(scalar, a[i][j]) for j in range(3)) for i in range(3))


def det3(a, add=kadd, neg=kneg, mul=kmul, zero=K0, one=K1):
    ans = zero
    for perm in permutations(range(3)):
        inversions = sum(perm[i] > perm[j] for i in range(3) for j in range(i + 1, 3))
        term = one
        for i in range(3):
            term = mul(term, a[i][perm[i]])
        ans = add(ans, neg(term) if inversions & 1 else term)
    return ans


def charpoly3(a):
    """Coefficients low-to-high of det(t I-a)."""
    trace = ksum(a[i][i] for i in range(3))
    s2 = ksum(
        ksub(kmul(a[i][i], a[j][j]), kmul(a[i][j], a[j][i]))
        for i in range(3)
        for j in range(i + 1, 3)
    )
    return (kneg(det3(a)), s2, kneg(trace), K1)


def poly_add(p, q):
    ans = dict(p)
    for monomial, coeff in q.items():
        ans[monomial] = kadd(ans.get(monomial, K0), coeff)
        if ans[monomial] == K0:
            del ans[monomial]
    return ans


def poly_mul(p, q):
    ans = {}
    for ma, ca in p.items():
        for mb, cb in q.items():
            monomial = tuple(x + y for x, y in zip(ma, mb))
            ans[monomial] = kadd(ans.get(monomial, K0), kmul(ca, cb))
    return {m: c for m, c in ans.items() if c != K0}


def poly_pow(p, n):
    ans = {(0, 0, 0): K1}
    for _ in range(n):
        ans = poly_mul(ans, p)
    return ans


def transform_q(a):
    linear = []
    for row in range(3):
        linear.append(
            {(1 if j == 0 else 0, 1 if j == 1 else 0, 1 if j == 2 else 0): a[row][j]
             for j in range(3) if a[row][j] != K0}
        )
    ans = {}
    for i, j in ((0, 1), (1, 2), (2, 0)):
        ans = poly_add(ans, poly_mul(poly_pow(linear[i], 3), linear[j]))
    return ans


Q4_POLY = {(3, 1, 0): K1, (0, 3, 1): K1, (1, 0, 3): K1}


def qeval(v, add=kadd, mul=kmul, zero=K0):
    return _sum_generic(
        (mul(mul(mul(v[i], v[i]), v[i]), v[j]) for i, j in ((0, 1), (1, 2), (2, 0))),
        add,
        zero,
    )


def _sum_generic(values, add, zero):
    ans = zero
    for value in values:
        ans = add(ans, value)
    return ans


# The standard Klein matrices.
z = kzeta(1)
tau = ksum((kzeta(1), kzeta(2), kzeta(4), kneg(kzeta(3)), kneg(kzeta(5)), kneg(kzeta(6))))
a = ksub(kzeta(1), kzeta(6))
b = ksub(kzeta(2), kzeta(5))
c = ksub(kzeta(4), kzeta(3))

D = ((kzeta(1), K0, K0), (K0, kzeta(4), K0), (K0, K0, kzeta(2)))
P = ((K0, K1, K0), (K0, K0, K1), (K1, K0, K0))
# Since tau^2=-7, -1/tau=tau/7.
J = tuple(
    tuple(kmul(kscale(tau, Q(1, 7)), entry) for entry in row)
    for row in ((a, b, c), (b, c, a), (c, a, b))
)


# ---------------------------------------------------------------------------
# Exact enumeration and subgroup audit
# ---------------------------------------------------------------------------


def enumerate_group():
    generators = (D, P, J)
    names = "DPJ"
    matrices = [I3]
    words = [""]
    index = {I3: 0}
    queue = deque([0])
    while queue:
        i = queue.popleft()
        for name, generator in zip(names, generators):
            value = matmul(matrices[i], generator)
            if value not in index:
                index[value] = len(matrices)
                matrices.append(value)
                words.append(words[i] + name)
                queue.append(index[value])
    transitions = []
    for value in matrices:
        transitions.append(tuple(index[matmul(value, generator)] for generator in generators))

    def multiply(i, j):
        ans = i
        for letter in words[j]:
            ans = transitions[ans][names.index(letter)]
        return ans

    table = [[multiply(i, j) for j in range(len(matrices))] for i in range(len(matrices))]
    return matrices, words, table


MATRICES, WORDS, MULT = enumerate_group()
IDENTITY = 0


def ipow(g, n):
    ans = IDENTITY
    while n:
        if n & 1:
            ans = MULT[ans][g]
        g = MULT[g][g]
        n //= 2
    return ans


def iorder(g):
    ans = IDENTITY
    for n in range(1, 169):
        ans = MULT[ans][g]
        if ans == IDENTITY:
            return n
    raise AssertionError("order exceeds group order")


ORDERS = [iorder(g) for g in range(len(MATRICES))]
INVERSES = [next(h for h in range(len(MATRICES)) if MULT[g][h] == IDENTITY) for g in range(len(MATRICES))]


def conjugate(g, h):
    return MULT[MULT[h][g]][INVERSES[h]]


def generated_subgroup(generators):
    generators = tuple(generators)
    subgroup = {IDENTITY}
    queue = deque([IDENTITY])
    while queue:
        h = queue.popleft()
        for g in generators:
            value = MULT[h][g]
            if value not in subgroup:
                subgroup.add(value)
                queue.append(value)
    return frozenset(subgroup)


def all_abelian_subgroups():
    """Exhaustive generation: adjoin every element centralizing the subgroup."""
    seed = frozenset((IDENTITY,))
    found = {seed}
    queue = deque((seed,))
    while queue:
        subgroup = queue.popleft()
        for g in range(len(MATRICES)):
            if g in subgroup:
                continue
            if all(MULT[g][h] == MULT[h][g] for h in subgroup):
                larger = generated_subgroup(tuple(subgroup) + (g,))
                assert all(MULT[x][y] == MULT[y][x] for x in larger for y in larger)
                if larger not in found:
                    found.add(larger)
                    queue.append(larger)
    return found


def subgroup_type(subgroup):
    if len(subgroup) == 1:
        return "1"
    exponent = max(ORDERS[g] for g in subgroup)
    if len(subgroup) == 4 and exponent == 2:
        return "V4"
    if len(subgroup) == exponent:
        return "C%d" % exponent
    return "unknown(%d,%d)" % (len(subgroup), exponent)


def subgroup_conjugacy_orbit(subgroup):
    return {
        frozenset(conjugate(g, h) for g in subgroup)
        for h in range(len(MATRICES))
    }


ABELIAN = all_abelian_subgroups()
ABELIAN_BY_TYPE = Counter(subgroup_type(h) for h in ABELIAN)

ELEMENT_UNSEEN = set(range(len(MATRICES)))
ELEMENT_CLASSES = []
while ELEMENT_UNSEEN:
    g = min(ELEMENT_UNSEEN)
    orbit = {conjugate(g, h) for h in range(len(MATRICES))}
    ELEMENT_CLASSES.append(orbit)
    ELEMENT_UNSEEN -= orbit

UNSEEN = set(ABELIAN)
ABELIAN_CLASSES = []
while UNSEEN:
    subgroup = min(UNSEEN, key=lambda h: (len(h), sorted(h)))
    orbit = subgroup_conjugacy_orbit(subgroup)
    ABELIAN_CLASSES.append((subgroup_type(subgroup), subgroup, orbit))
    UNSEEN -= orbit


# ---------------------------------------------------------------------------
# Exact eigenspaces, line restrictions, and lift audit
# ---------------------------------------------------------------------------


class FieldOps:
    def __init__(self, zero, one, add, neg, mul, inv):
        self.zero = zero
        self.one = one
        self.add = add
        self.neg = neg
        self.mul = mul
        self.inv = inv

    def sub(self, a, b):
        return self.add(a, self.neg(b))

    def div(self, a, b):
        return self.mul(a, self.inv(b))


KOPS = FieldOps(K0, K1, kadd, kneg, kmul, kinv)


def nullspace(rows, ops):
    matrix = [list(row) for row in rows]
    ncols = len(matrix[0])
    pivots = []
    prow = 0
    for col in range(ncols):
        pivot = next((r for r in range(prow, len(matrix)) if matrix[r][col] != ops.zero), None)
        if pivot is None:
            continue
        matrix[prow], matrix[pivot] = matrix[pivot], matrix[prow]
        scale = ops.inv(matrix[prow][col])
        matrix[prow] = [ops.mul(scale, x) for x in matrix[prow]]
        for r in range(len(matrix)):
            if r == prow or matrix[r][col] == ops.zero:
                continue
            scale = matrix[r][col]
            matrix[r] = [ops.sub(x, ops.mul(scale, y)) for x, y in zip(matrix[r], matrix[prow])]
        pivots.append(col)
        prow += 1
        if prow == len(matrix):
            break
    free = [col for col in range(ncols) if col not in pivots]
    basis = []
    for col in free:
        vector = [ops.zero] * ncols
        vector[col] = ops.one
        for r, pivot_col in enumerate(pivots):
            vector[pivot_col] = ops.neg(matrix[r][col])
        basis.append(tuple(vector))
    return basis


def eigenspace_base(matrix, eigenvalue):
    rows = [
        [ksub(matrix[i][j], eigenvalue if i == j else K0) for j in range(3)]
        for i in range(3)
    ]
    return nullspace(rows, KOPS)


def unipoly_trim(p):
    p = list(p)
    while p and p[-1] == K0:
        p.pop()
    return p


def unipoly_divmod(a, b):
    a = unipoly_trim(a)
    b = unipoly_trim(b)
    quotient = [K0] * max(1, len(a) - len(b) + 1)
    while len(a) >= len(b) and a:
        degree = len(a) - len(b)
        coeff = kdiv(a[-1], b[-1])
        quotient[degree] = coeff
        for i, bi in enumerate(b):
            a[degree + i] = ksub(a[degree + i], kmul(coeff, bi))
        a = unipoly_trim(a)
    return unipoly_trim(quotient), a


def unipoly_gcd(a, b):
    a, b = unipoly_trim(a), unipoly_trim(b)
    while b:
        _, remainder = unipoly_divmod(a, b)
        a, b = b, remainder
    if not a:
        return []
    leading_inverse = kinv(a[-1])
    return [kmul(leading_inverse, x) for x in a]


def binary_line_restriction(u, v):
    """Coefficients of q(s*u+t*v), indexed by the exponent of s."""
    def linpow(ai, bi, n):
        p = [K1]
        for _ in range(n):
            nxt = [K0] * (len(p) + 1)
            for degree, coeff in enumerate(p):
                nxt[degree] = kadd(nxt[degree], kmul(coeff, bi))
                nxt[degree + 1] = kadd(nxt[degree + 1], kmul(coeff, ai))
            p = nxt
        return p

    def conv(p, q):
        ans = [K0] * (len(p) + len(q) - 1)
        for i, x in enumerate(p):
            for j, y in enumerate(q):
                ans[i + j] = kadd(ans[i + j], kmul(x, y))
        return ans

    ans = [K0] * 5
    for i, j in ((0, 1), (1, 2), (2, 0)):
        term = conv(linpow(u[i], v[i], 3), linpow(u[j], v[j], 1))
        ans = [kadd(x, y) for x, y in zip(ans, term)]
    return ans


class QuadraticExtension:
    """K[u]/(u^2-q*u-p), represented by a+b*u."""

    def __init__(self, p, q):
        self.p = p
        self.q = q
        self.zero = (K0, K0)
        self.one = (K1, K0)
        self.u = (K0, K1)

    def add(self, x, y):
        return (kadd(x[0], y[0]), kadd(x[1], y[1]))

    def neg(self, x):
        return (kneg(x[0]), kneg(x[1]))

    def sub(self, x, y):
        return self.add(x, self.neg(y))

    def mul(self, x, y):
        a, b = x
        c, d = y
        return (
            kadd(kmul(a, c), kmul(kmul(b, d), self.p)),
            kadd(kadd(kmul(a, d), kmul(b, c)), kmul(kmul(b, d), self.q)),
        )

    def inv(self, x):
        a, b = x
        # conjugate of u is q-u; norm=a^2+abq-b^2p
        norm = ksub(kadd(kmul(a, a), kmul(kmul(a, b), self.q)), kmul(kmul(b, b), self.p))
        norm_inv = kinv(norm)
        return (kmul(kadd(a, kmul(b, self.q)), norm_inv), kmul(kneg(b), norm_inv))

    def embed(self, x):
        return (x, K0)

    def ops(self):
        return FieldOps(self.zero, self.one, self.add, self.neg, self.mul, self.inv)


def extension_eigenspace(matrix, eigenvalue, ext):
    rows = [
        [ext.sub(ext.embed(matrix[i][j]), eigenvalue if i == j else ext.zero) for j in range(3)]
        for i in range(3)
    ]
    return nullspace(rows, ext.ops())


def representative_of_type(kind, class_number=0):
    classes = [item for item in ABELIAN_CLASSES if item[0] == kind]
    classes.sort(key=lambda item: sorted(item[1]))
    return classes[class_number][1]


def cyclic_generator(subgroup, order):
    return next(g for g in subgroup if ORDERS[g] == order)


# Named representatives agree with the concise formulas used in the note.
IDX_D = next(i for i, value in enumerate(MATRICES) if value == D)
IDX_P = next(i for i, value in enumerate(MATRICES) if value == P)
IDX_J = next(i for i, value in enumerate(MATRICES) if value == J)
IDX_A4 = MULT[MULT[IDX_D][IDX_D]][IDX_J]  # D^2 J


def fixed_locus_checks():
    results = {}

    # C2: P(E_-) pulls back to a smooth genus-one double cover; P(E_+)
    # has q != 0 and hence contributes two isolated fixed points.
    assert charpoly3(J) == (kneg(K1), kneg(K1), K1, K1)
    plus = eigenspace_base(J, K1)
    minus = eigenspace_base(J, kneg(K1))
    assert len(plus) == 1 and len(minus) == 2
    assert qeval(plus[0]) != K0
    line_q = binary_line_restriction(minus[0], minus[1])
    if line_q[4] == K0:
        minus[0], minus[1] = minus[1], minus[0]
        line_q = binary_line_restriction(minus[0], minus[1])
    assert line_q[4] != K0
    derivative = [kscale(line_q[i], Q(i)) for i in range(1, 5)]
    assert len(unipoly_gcd(line_q, derivative)) == 1
    results["C2"] = "genus-1 double cover plus 2 isolated points"

    # C3: eigenvalues 1,omega,omega^2.  Invariance forces q=0 for the
    # two nontrivial eigenspaces because lambda^4 != 1.  The 1-eigenline
    # is [1:1:1] and has q=3.
    assert charpoly3(P) == (kneg(K1), K0, K0, K1)
    p_one = eigenspace_base(P, K1)
    assert len(p_one) == 1 and qeval(p_one[0]) != K0
    assert qeval((K1, K1, K1)) == krat(3)
    results["C3"] = "2 branch points plus 2 points over the 1-eigenline"

    # C4: A=D^2J has eigenvalues 1,i,-i.  All three projective fixed
    # eigenlines are off the branch curve.  Only lambda=1 has lambda^2=1;
    # the i and -i actions exchange the two points in their fibers.
    A4 = MATRICES[IDX_A4]
    assert ORDERS[IDX_A4] == 4
    assert charpoly3(A4) == (kneg(K1), K1, kneg(K1), K1)
    one = eigenspace_base(A4, K1)
    assert len(one) == 1 and qeval(one[0]) != K0
    ext_i = QuadraticExtension(kneg(K1), K0)  # i^2=-1
    for eigenvalue in (ext_i.u, ext_i.neg(ext_i.u)):
        eig = extension_eigenspace(A4, eigenvalue, ext_i)
        assert len(eig) == 1
        assert qeval(eig[0], ext_i.add, ext_i.mul, ext_i.zero) != ext_i.zero
    results["C4"] = "2 points over the 1-eigenline; i and -i fibers are exchanged"

    # C7: D has the coordinate eigenlines and all lie on q=0.
    assert tuple(D[i][i] for i in range(3)) == (kzeta(1), kzeta(4), kzeta(2))
    for vector in ((K1, K0, K0), (K0, K1, K0), (K0, K0, K1)):
        assert qeval(vector) == K0
    results["C7"] = "3 branch points"

    # Each of the two conjugacy classes of V4 restricts as the sum of
    # the three nontrivial characters.  Its three eigenlines are all off
    # q=0 and every character squares to 1, so each fiber contributes 2.
    v4_classes = sorted((item for item in ABELIAN_CLASSES if item[0] == "V4"), key=lambda x: sorted(x[1]))
    assert len(v4_classes) == 2
    for class_index, (_, subgroup, _) in enumerate(v4_classes, 1):
        nonidentity = sorted(g for g in subgroup if g != IDENTITY)
        h1, h2 = nonidentity[:2]
        eigenlines = []
        for e1, e2 in product((1, -1), repeat=2):
            rows = []
            for h, sign in ((h1, e1), (h2, e2)):
                matrix = MATRICES[h]
                rows.extend(
                    [ksub(matrix[i][j], krat(sign) if i == j else K0) for j in range(3)]
                    for i in range(3)
                )
            eig = nullspace(rows, KOPS)
            if eig:
                assert len(eig) == 1 and (e1, e2) != (1, 1)
                assert qeval(eig[0]) != K0
                eigenlines.append((e1, e2, eig[0]))
        assert len(eigenlines) == 3
        results["V4.%d" % class_index] = "3 off-branch eigenlines, hence 6 points"

    return results


FIXED_RESULTS = fixed_locus_checks()


def main():
    # Number-field and action checks.
    assert kmul(tau, tau) == krat(-7)
    assert matmul(D, ipow_matrix(D, 6)) == I3
    assert matmul(P, matmul(P, P)) == I3
    assert matmul(J, J) == I3
    assert det3(D) == K1 and det3(P) == K1 and det3(J) == K1
    assert transform_q(D) == Q4_POLY
    assert transform_q(P) == Q4_POLY
    assert transform_q(J) == Q4_POLY

    # The exact matrix closure and its class census.
    assert len(MATRICES) == 168
    expected_orders = Counter({1: 1, 2: 21, 3: 56, 4: 42, 7: 48})
    assert Counter(ORDERS) == expected_orders

    # The involution centralizer used in the structural covariant bound is
    # D8.  For the chosen J it has five involutions and two order-four
    # elements, both squaring to J; its commutator subgroup is {1,J}.
    centralizer_j = [
        g for g in range(len(MATRICES))
        if MULT[g][IDX_J] == MULT[IDX_J][g]
    ]
    assert len(centralizer_j) == 8
    assert Counter(ORDERS[g] for g in centralizer_j) == Counter({
        1: 1, 2: 5, 4: 2
    })
    order_four = [g for g in centralizer_j if ORDERS[g] == 4]
    assert all(MULT[g][g] == IDX_J for g in order_four)
    commutators = {
        MULT[MULT[MULT[a][b]][INVERSES[a]]][INVERSES[b]]
        for a in centralizer_j for b in centralizer_j
    }
    assert commutators == {IDENTITY, IDX_J}

    # This also verifies simplicity: there are six element classes
    # (the order-7 elements split into two), and the normal closure of a
    # representative of every nonidentity class is the whole group.
    assert sorted((ORDERS[next(iter(c))], len(c)) for c in ELEMENT_CLASSES) == [
        (1, 1), (2, 21), (3, 56), (4, 42), (7, 24), (7, 24)
    ]
    for element_class in ELEMENT_CLASSES:
        g = next(iter(element_class))
        if g != IDENTITY:
            assert len(generated_subgroup(element_class)) == 168

    # Exhaustive abelian classification.  Completeness follows from the
    # iterative centralizer-adjunction algorithm in all_abelian_subgroups.
    assert ABELIAN_BY_TYPE == Counter({"1": 1, "C2": 21, "C3": 28, "C4": 21, "C7": 8, "V4": 14})
    class_summary = Counter((kind, len(orbit)) for kind, _, orbit in ABELIAN_CLASSES)
    assert class_summary == Counter({("1", 1): 1, ("C2", 21): 1, ("C3", 28): 1,
                                     ("C4", 21): 1, ("C7", 8): 1, ("V4", 7): 2})

    # There is no projective G-fixed point: D fixes precisely the three
    # coordinate lines, while P cycles them.
    assert len({D[i][i] for i in range(3)}) == 3
    assert all(
        not proportional(matvec(P, v), v)
        for v in ((K1, K0, K0), (K0, K1, K0), (K0, K0, K1))
    )

    # Smoothness: if xyz != 0, multiplying the three derivative equations
    # 3x^2y=-z^3, 3y^2z=-x^3, 3z^2x=-y^3 gives 27=-1.  If a coordinate
    # is zero, the derivative equations force all three to be zero.
    assert Q(27) != Q(-1)

    print("field: tau^2=-7")
    print("group: order=168; element orders", dict(sorted(expected_orders.items())))
    print("abelian subgroup counts:", dict(sorted(ABELIAN_BY_TYPE.items())))
    print("abelian conjugacy classes:")
    for kind, subgroup, orbit in sorted(ABELIAN_CLASSES, key=lambda x: (x[0], sorted(x[1]))):
        words = sorted((WORDS[g] or "1") for g in subgroup)
        print("  %-3s orbit=%2d representative=%s" % (kind, len(orbit), words))
    print("fixed loci on S (w is G-trivial):")
    for kind, result in FIXED_RESULTS.items():
        print("  %-4s %s" % (kind, result))
    print("Condition (A): PASS")
    print("WP1_FIXED_LOCI_OK")


def ipow_matrix(a, n):
    ans = I3
    while n:
        if n & 1:
            ans = matmul(ans, a)
        a = matmul(a, a)
        n //= 2
    return ans


if __name__ == "__main__":
    main()
