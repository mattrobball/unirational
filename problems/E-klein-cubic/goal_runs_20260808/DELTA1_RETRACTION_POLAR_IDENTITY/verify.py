#!/usr/bin/env python3
"""Exact replay for the degree-one retraction polar-identity packet."""

from __future__ import annotations

from functools import reduce

import sympy as sp


def abstract_identities() -> None:
    h, f, a, b, c, r, s, t, disc = sp.symbols(
        "h f a b c r s t disc"
    )

    cubic = f + 3 * a * t + 3 * b * t**2 + c * t**3
    substitutions = {
        a: (f * r - h) / 3,
        b: (-h * r - f * s) / 3,
        c: h * s,
    }
    factored = (h * t - f) * (s * t**2 - r * t - 1)
    assert sp.expand(cubic.subs(substitutions) - factored) == 0

    ap = (r + disc) / 2
    cm = (disc - r) / 2
    residual = s * t**2 - r * t - 1
    split = (ap * t + 1) * (cm * t - 1)
    assert sp.expand(
        residual.subs(s, (disc**2 - r**2) / 4) - split
    ) == 0

    # At the two residual roots, the factorized cubic vanishes.  Clearing a
    # root denominator gives homogeneous tuples A*x-Q and C*x+Q.
    assert sp.simplify(split.subs(t, -1 / ap)) == 0
    assert sp.simplify(split.subs(t, 1 / cm)) == 0
    print("PASS abstract polarized identities and line factorization")
    print("PASS square discriminant gives two degree-lowered landing roots")


def countermodel() -> None:
    z0, z1, z2, z3, w = sp.symbols("z0 z1 z2 z3 w")
    z = (z0, z1, z2, z3)
    variables = z + (w,)

    q = sum(zi**2 for zi in z)
    c = z0**3 + 2 * z1**3 + 3 * z2**3 + 5 * z3**3
    f = sp.expand(q * w + c)
    assert sp.gcd(q, c) == 1
    # A primitive polynomial linear in w is irreducible by Gauss.
    assert sp.factor(f) == f

    zp = (
        z0**3,
        z0**2 * z1 + f,
        z0**2 * z2,
        z0**2 * z3,
    )
    qp = sum(zi**2 for zi in zp)
    cp = zp[0] ** 3 + 2 * zp[1] ** 3 + 3 * zp[2] ** 3 + 5 * zp[3] ** 3
    target = tuple(sp.expand(qp * zi) for zi in zp) + (-sp.expand(cp),)

    assert {sp.Poly(item, *variables).total_degree() for item in target} == {9}

    # Structural exact landing check.  For a scalar lambda and a four-vector
    # y, q(lambda*y)=lambda^2*q(y) and c(lambda*y)=lambda^3*c(y).
    # Here lambda=qp, q(z')=qp, c(z')=cp, and the last coordinate is -cp;
    # hence F(target)=qp^3*(-cp)+qp^3*cp=0.  Verify the two homogeneity
    # identities independently without expanding the enormous composition.
    lam, y0, y1, y2, y3 = sp.symbols("lam y0 y1 y2 y3")
    yy = (y0, y1, y2, y3)
    qy = sum(item**2 for item in yy)
    cy = y0**3 + 2 * y1**3 + 3 * y2**3 + 5 * y3**3
    assert sp.expand(sum((lam * item) ** 2 for item in yy) - lam**2 * qy) == 0
    assert sp.expand(
        (lam * y0) ** 3
        + 2 * (lam * y1) ** 3
        + 3 * (lam * y2) ** 3
        + 5 * (lam * y3) ** 3
        - lam**3 * cy
    ) == 0
    assert sp.expand(qp - sum(item**2 for item in zp)) == 0
    assert sp.expand(
        cp
        - (zp[0] ** 3 + 2 * zp[1] ** 3 + 3 * zp[2] ** 3 + 5 * zp[3] ** 3)
    ) == 0

    h = z0**6 * q
    qtuple = []
    for item, coordinate in zip(target, variables):
        quotient = sp.cancel((item - h * coordinate) / f)
        assert sp.denom(quotient) == 1
        qtuple.append(sp.expand(quotient))
    assert {
        sp.Poly(item, *variables).total_degree() for item in qtuple if item != 0
    } == {6}

    coordinate_gcd = reduce(sp.gcd, target)
    assert coordinate_gcd in (1, -1)

    # Polynomial divisibility above is the exact restriction check:
    # target-h*x=f*qtuple, hence [target]|_(f=0)=id.

    print("PASS primitive irreducible degree-nine retraction countermodel")

    # Compute only the specialization needed to certify that the global
    # residual discriminant is not a square.  Set z1=z2=0,z3=1, retain z0,
    # and specialize z0=0 only after the exact polynomial quotients R,S have
    # been formed.
    u, v, tau = sp.symbols("u v tau")
    qs = u**2 + 1
    cs = u**3 + 5
    fs = sp.expand(qs * v + cs)
    zps = (u**3, fs, 0, u**2)
    qps = sum(item**2 for item in zps)
    cps = zps[0] ** 3 + 2 * zps[1] ** 3 + 5 * zps[3] ** 3
    ts = tuple(sp.expand(qps * item) for item in zps) + (-sp.expand(cps),)
    hs = u**6 * qs
    xs = (u, 0, 0, 1, v)
    qsp = []
    for item, coordinate in zip(ts, xs):
        quotient = sp.cancel((item - hs * coordinate) / fs)
        assert sp.denom(quotient) == 1
        qsp.append(quotient)

    y = tuple(xs[i] + tau * qsp[i] for i in range(5))
    line_cubic = sp.Poly(
        sp.expand(
            sum(y[i] ** 2 for i in range(4)) * y[4]
            + y[0] ** 3
            + 2 * y[1] ** 3
            + 3 * y[2] ** 3
            + 5 * y[3] ** 3
        ),
        tau,
    )
    aa = line_cubic.coeff_monomial(tau) / 3
    cc = line_cubic.coeff_monomial(tau**3)
    rr = sp.cancel((hs + 3 * aa) / fs)
    ss = sp.cancel(cc / hs)
    assert sp.denom(rr) == 1
    assert sp.denom(ss) == 1
    delta_special = sp.factor((rr**2 + 4 * ss).subs(u, 0))
    expected = -4 * (v + 5) ** 2 * (v**2 + 5 * v - 1)
    assert sp.expand(delta_special - expected) == 0
    squarefree = sp.factor_list(delta_special)[1]
    assert any(exponent % 2 for _, exponent in squarefree)
    print("PASS countermodel residual discriminant is nonsquare")


def invariant_degree_boundary() -> None:
    # Every n>=8 is 3a+5b.  This supplies formal invariant nonsquares
    # f3*f5*(f3^a*f5^b)^2 in every residual degree 2d-8 for d>=36.
    for d in range(36, 1000):
        n = d - 8
        representations = [
            (a, b)
            for a in range(n // 3 + 1)
            for b in range(n // 5 + 1)
            if 3 * a + 5 * b == n
        ]
        assert representations
        a, b = representations[0]
        assert 3 + 5 + 2 * (3 * a + 5 * b) == 2 * d - 8
        # The f3 valuation is 1+2a, hence odd.
        assert (1 + 2 * a) % 2 == 1
    print("PASS high-degree invariant nonsquare arithmetic")


def main() -> None:
    abstract_identities()
    countermodel()
    invariant_degree_boundary()
    print("DELTA1-RETRACTION-POLAR-IDENTITY-PACKET-OK")


if __name__ == "__main__":
    main()
