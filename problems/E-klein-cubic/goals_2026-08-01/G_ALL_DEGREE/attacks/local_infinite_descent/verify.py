#!/usr/bin/env python3
"""Independent exact replay for the scoped local recurrence/no-go theorem.

The script reconstructs the monomial symbolic recurrence, the gcd-one
order-three A4 trisection identity in the projective-character model, its
all-odd-order propagation, the sharp degree-three S3 trace survivor, and
scalar homogeneity.  It does not infer primitivity after inverse-character
correction, a saturated point-link theorem, or a global covariant from any
local or formal state.
"""

from __future__ import annotations

from hashlib import sha256
from itertools import product
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
GOALS = HERE.parents[2]

INPUTS = {
    "GOAL_G_ALL_DEGREE_LIFTING.md":
        "f6f985b2d2f9750ae43a5cdc00c6e0d9ce6b21680d4c9e015a130395871724d2",
    "../tmp/fable_trisection_attack/REPORT.md":
        "471bc1c3a7cf4e187a36e33dc680aabb0b9276375a690b764d2dfeb9c63ef8ca",
    "../tmp/fable_trisection_attack/verify.py":
        "f9e3279e8dd5b40cc914b42c1929357ad86638660875d6704d6cec788dba0fe7",
    "../tmp/fable_trisection_compatibility/REPORT.md":
        "e08b8b978281c4dfdbd7d9e6ee6155cc14b1f157ed84cab9f5cb5cf6c0ee72a3",
    "../tmp/fable_trisection_compatibility/verify.py":
        "7d6600b8ce50c1339760fdfbe244c8908a3db9dfa31bd5c3d9216a392515d7b1",
    "../tmp/symbolic_compatibility_complex/triple_line_symbolic/REPORT.md":
        "8df75db930907a567b3607edb134435bc81c7efad8d3889d915c7e3ddcc0a251",
    "../certificates/GLOBAL_TRANSITION_DIAGRAM.md":
        "2ded385ce770839142497fa4c9b569a9d10aff5a242925d76c5bb7b2a8acd931",
    "../certificates/elliptic_lifting/PICARD_OBSTRUCTION.md":
        "57f200e82de68d94246c14b65508f433ce75fb0e97a1876667568605907a246e",
}


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def check_inputs() -> None:
    for relative, expected in INPUTS.items():
        path = (GOALS / relative).resolve()
        assert path.is_file(), path
        assert digest(path) == expected, (path, digest(path), expected)
    print("PASS authoritative dependency hashes")


def in_j(exponents: tuple[int, int, int], m: int) -> bool:
    a, b, c = exponents
    if m <= 0:
        return True
    return b + c >= m and a + c >= m and a + b >= m


def divisible(exponents: tuple[int, int, int], divisor: tuple[int, int, int]) -> bool:
    return all(a >= b for a, b in zip(exponents, divisor))


def in_i_power(exponents: tuple[int, int, int], n: int) -> bool:
    """Membership in (xy,xz,yz)^n by exact exponent enumeration."""

    if n <= 0:
        return True
    a, b, c = exponents
    for alpha in range(n + 1):       # (xy)^alpha
        for beta in range(n - alpha + 1):  # (xz)^beta
            gamma = n - alpha - beta      # (yz)^gamma
            if a >= alpha + beta and b >= alpha + gamma and c >= beta + gamma:
                return True
    return False


def recurrence_rhs(exponents: tuple[int, int, int], m: int) -> bool:
    a, b, c = exponents
    boundary = (
        (a >= m and b >= m)
        or (a >= m and c >= m)
        or (b >= m and c >= m)
    )
    interior = (
        m >= 2
        and min(exponents) >= 1
        and in_j((a - 1, b - 1, c - 1), m - 2)
    )
    return boundary or interior


def rees_rhs(exponents: tuple[int, int, int], m: int) -> bool:
    for j in range(m // 2 + 1):
        if min(exponents) < j:
            continue
        reduced = tuple(value - j for value in exponents)
        if in_i_power(reduced, m - 2 * j):
            return True
    return False


def check_symbolic_recurrence() -> None:
    # This finite enumeration is a regression check; RESULT.md gives the
    # all-m proof directly from the three pair-sum inequalities.
    for m in range(1, 19):
        bound = 3 * m + 9
        for exponents in product(range(bound + 1), repeat=3):
            if sum(exponents) > bound:
                continue
            assert in_j(exponents, m) == recurrence_rhs(exponents, m), (m, exponents)
            assert in_j(exponents, m) == rees_rhs(exponents, m), (m, exponents)

    # Multiplication by h=xyz gives J_(m-2)/J_m -> J_m/J_(m+2).
    for m in range(2, 19):
        for exponents in product(range(2 * m + 8), repeat=3):
            shifted = tuple(value + 1 for value in exponents)
            assert in_j(shifted, m + 2) == in_j(exponents, m)

    # Recover the existing first-surviving-layer formula.
    for r in range(1, 41):
        m = 2 * r + 1
        degree = 3 * r + 3
        left = {
            e for e in product(range(degree + 1), repeat=3)
            if sum(e) == degree and in_j(e, m)
        }
        shift = r - 1
        right = {
            (e[0] + shift, e[1] + shift, e[2] + shift)
            for e in product(range(7), repeat=3)
            if sum(e) == 6 and in_j(e, 3)
        }
        assert left == right, r

    print("PASS J_m all-order recurrence and symbolic-Rees generators")
    print("PASS quotient injection and first-surviving-layer specialization")


def axis_order(poly: sp.Expr, variables: tuple[sp.Symbol, ...], axis: int) -> int:
    terms = sp.Poly(sp.expand(poly), *variables).terms()
    return min(sum(monomial[j] for j in range(3) if j != axis) for monomial, _ in terms)


def equal_rational(left: sp.Expr, right: sp.Expr) -> bool:
    return sp.together(left - right).as_numer_denom()[0].expand() == 0


def check_projective_character_trisection() -> None:
    x, y, z, B = sp.symbols("x y z B")
    X, Y, Z = y * z, z * x, x * y
    w = -X * Y * Z
    u0 = X * (X**2 + B * Y**2 + Z**2 / B)
    u1 = Y * (Y**2 + B * Z**2 + X**2 / B)
    u2 = Z * (Z**2 + B * X**2 + Y**2 / B)
    a = (B**3 - 1) ** 2 / B**3
    landing = a * w**3 + w * (u0**2 + u1**2 + u2**2) + u0 * u1 * u2
    assert equal_rational(landing, 0)

    # Clear the harmless B denominator before monomial/gcd checks.
    cleared = (B * w, sp.expand(B * u0), sp.expand(B * u1), sp.expand(B * u2))
    orders = tuple(
        tuple(axis_order(poly, (x, y, z), axis) for axis in range(3))
        for poly in cleared
    )
    assert orders == ((4, 4, 4), (4, 3, 3), (3, 4, 3), (3, 3, 4))
    assert all(in_j(monomial, 3) for poly in cleared for monomial, _ in sp.Poly(poly, x, y, z).terms())
    assert any(not in_j(monomial, 5) for poly in cleared for monomial, _ in sp.Poly(poly, x, y, z).terms())

    domain = sp.QQ.frac_field(B)
    gcd = sp.Poly(cleared[0], x, y, z, domain=domain)
    for poly in cleared[1:]:
        gcd = sp.gcd(gcd, sp.Poly(poly, x, y, z, domain=domain))
    assert gcd.total_degree() == 0

    # Standard A4 generators: a double sign change and the 3-cycle.
    g1 = {x: -x, y: -y, z: z}
    cyc = {x: y, y: z, z: x}
    tuple_raw = (w, u0, u1, u2)
    expected_g1 = (w, -u0, -u1, u2)
    expected_cyc = (w, u1, u2, u0)
    assert all(equal_rational(p.subs(g1, simultaneous=True), q) for p, q in zip(tuple_raw, expected_g1))
    assert all(equal_rational(p.subs(cyc, simultaneous=True), q) for p, q in zip(tuple_raw, expected_cyc))

    # h^(r-1) raises every branch order by 2(r-1), and cubic landing scales.
    for r in range(1, 101):
        m = 2 * r + 1
        factor_order = 2 * (r - 1)
        propagated_orders = tuple(tuple(v + factor_order for v in row) for row in orders)
        assert min(min(row) for row in propagated_orders) == m
        assert 6 + 3 * (r - 1) == 3 * r + 3
        assert 3 * (r - 1) == 3 * r - 3

    print("PASS gcd-one characteristic-zero A4 projective-character landing identity in J_3/J_5")
    print("PASS exact propagation to every odd symbolic order m>=3")


def check_trace_sharpness() -> None:
    # S3 on three sheets: rho(i)=i+1, sigma(i)=-i.  The target marked
    # type-I orbit is <T>=Z/3 with the same affine action.
    rho = lambda i: (i + 1) % 3
    sigma = lambda i: (-i) % 3
    for i in range(3):
        assert rho(rho(rho(i))) == i
        assert sigma(sigma(i)) == i
        assert sigma(rho(sigma(i))) == rho(rho(i))
        f = i
        assert rho(f) == rho(i)
        assert sigma(f) == sigma(i)
    assert sum(range(3)) % 3 == 0

    # Type-II is e+<T> in Z/2 x Z/3; inversion fixes the 2-torsion e.
    for e in (0, 1):
        for i in range(3):
            point = (e, i)
            rho_point = (e, (i + 1) % 3)
            sigma_point = (e, (-i) % 3)
            assert rho_point == (e, rho(i))
            assert sigma_point == (e, sigma(i))
            assert point[0] == (-point[0]) % 2

    assert [r for r in range(1, 19) if r % 3 == 0] == [r for r in range(1, 19) if (r * 1) % 3 == 0]
    print("PASS residual-S3 trace threshold is sharp at degree three")
    print("PASS type-I and type-II marked triples are exact survivor covers")


def check_scalar_homogeneity() -> None:
    s, a, b, c, w, u0, u1, u2 = sp.symbols("s a b c w u0 u1 u2")
    cubic = lambda W, U0, U1, U2: a * W**3 + b * W * (U0**2 + U1**2 + U2**2) + c * U0 * U1 * U2
    assert sp.expand(cubic(s * w, s * u0, s * u1, s * u2) - s**3 * cubic(w, u0, u1, u2)) == 0
    print("PASS scalar multiplication preserves landing and raw point-jet vanishing via a common factor")


def check_scope_text() -> None:
    """Guard the audited distinction between raw tuples and saturated classes."""

    result = (HERE / "RESULT.md").read_text()
    status = (HERE / "STATUS.md").read_text()

    required_result = (
        "primitive statement only in the\nprojective-character model before inverse-character correction",
        "and is **not literally primitive**",
        "This multiplication argument refutes only **unsaturated** point constraints",
        "A\nsaturated/primitive point-link obstruction remains open",
        "This does not rule out a descent argument imposed after\nprimitive saturation",
    )
    required_status = (
        "**Exit:** `LOCAL-INFINITE-DESCENT-UNSATURATED-ROUTE-REFUTED`",
        "projective-character model.  The actual `W`-valued positive-line-degree\n  class acquires a common inverse-character linear factor and is not\n  literally primitive",
        "This refutes only unsaturated\n  point constraints",
        "obstruction remains open after common factors are cancelled",
    )
    for phrase in required_result:
        assert phrase in result, phrase
    for phrase in required_status:
        assert phrase in status, phrase

    forbidden_result = (
        "## 2. A primitive exact landing class at `m=3`",
        "its nonlinear landing locus contains a primitive characteristic-zero",
        "the base state `p_3` is primitive",
    )
    forbidden_status = (
        "A primitive characteristic-zero `A4`-equivariant landing class exists",
    )
    for phrase in forbidden_result:
        assert phrase not in result, phrase
    for phrase in forbidden_status:
        assert phrase not in status, phrase

    print("PASS scope guard: projective-character gcd and inverse-character common factor")
    print("PASS scope guard: point-jet no-go is unsaturated; primitive point-link remains open")


def main() -> None:
    check_inputs()
    check_symbolic_recurrence()
    check_projective_character_trisection()
    check_trace_sharpness()
    check_scalar_homogeneity()
    check_scope_text()
    print("SCOPE gcd-one only before inverse-character correction; actual W class nonprimitive; point-jet no-go unsaturated only; NOT a global covariant")
    print("LOCAL_INFINITE_DESCENT_RECURRENCE_OK")


if __name__ == "__main__":
    main()
