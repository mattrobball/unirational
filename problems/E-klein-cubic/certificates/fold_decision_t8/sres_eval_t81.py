#!/usr/bin/env python3
"""Independent first-subresultant evaluation oracle for Track T8.

Does not import certificates/fold_decision_t6 producers.
Implements Euclidean PRS over Q and F_p. Classical Sres_1 via sympy.subresultants
is available for absolute-value / Bézout cross-checks.

Zero-locus of the Euclidean s1 agrees with classical PSC_1 (common scalar
on D(ell)).
"""
from __future__ import annotations

from fractions import Fraction
from hashlib import sha256
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"
FACTORS = ROOT / "certificates/fold_normalization_t2r/saturation_factors"


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def load_P():
    assert file_hash(P_PATH) == EXPECTED_P, "P sha256 mismatch"
    terms = []
    with P_PATH.open() as f:
        hdr = next(f).strip()
        assert hdr == "A\tB\tY\tZ\tu\tcoefficient", hdr
        for line in f:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    assert len(terms) == 1593
    return terms


def load_H():
    assert file_hash(H_PATH) == EXPECTED_H, "H sha256 mismatch"
    terms = []
    with H_PATH.open() as f:
        hdr = next(f).strip()
        assert hdr == "A\tB\tY\tZ\tcoefficient", hdr
        for line in f:
            a, b, y, z, c = map(int, line.split())
            terms.append(((a, b, y, z), c))
    assert len(terms) == 37992
    return terms


def load_tsv_ABYZ(path: Path, with_u: bool = False):
    terms = []
    with path.open() as f:
        hdr = next(f).strip()
        if with_u:
            assert hdr == "A\tB\tY\tZ\tu\tcoefficient", hdr
            for line in f:
                a, b, y, z, u, c = map(int, line.split())
                terms.append(((a, b, y, z, u), c))
        else:
            assert hdr == "A\tB\tY\tZ\tcoefficient", hdr
            for line in f:
                a, b, y, z, c = map(int, line.split())
                terms.append(((a, b, y, z), c))
    return terms


def eval_ABYZ(terms, A, B, Y, Z, mod=None):
    s = 0
    for (a, b, y, z), c in terms:
        v = c * (A**a) * (B**b) * (Y**y) * (Z**z)
        s += v
        if mod is not None:
            s %= mod
    return s


def eval_ABYZu(terms, A, B, Y, Z, u, mod=None):
    s = 0
    for (a, b, y, z, uu), c in terms:
        v = c * (A**a) * (B**b) * (Y**y) * (Z**z) * (u**uu)
        s += v
        if mod is not None:
            s %= mod
    return s


def specialize_P(terms, A, B, Y, Z, mod=None):
    coeffs = [0] * 7
    for (a, b, y, z, u), c in terms:
        v = c * (A**a) * (B**b) * (Y**y) * (Z**z)
        coeffs[u] += v
        if mod is not None:
            coeffs[u] %= mod
    return coeffs


def poly_deg(c: list) -> int:
    d = len(c) - 1
    while d > 0 and c[d] == 0:
        d -= 1
    return d if c and c[d] != 0 else -1


def poly_lc(c: list):
    d = poly_deg(c)
    return c[d] if d >= 0 else 0


def poly_deriv(c: list, mod=None) -> list:
    out = [0] * max(0, len(c) - 1)
    for i in range(1, len(c)):
        out[i - 1] = i * c[i]
        if mod is not None:
            out[i - 1] %= mod
    return out


def poly_trim(c: list) -> list:
    c = list(c)
    while len(c) > 1 and c[-1] == 0:
        c.pop()
    if not c:
        return [0]
    return c


def inv_mod(a: int, p: int) -> int:
    return pow(a % p, -1, p)


def sres1_euclid_Q(coeffs: list) -> tuple[Fraction, Fraction, str]:
    """Rational Euclidean PRS; returns associate of classical Sres_1 = s1*u + s0."""
    F = [Fraction(x) for x in coeffs]
    G = [Fraction(x) for x in poly_deriv(coeffs)]

    def fdeg(c):
        d = len(c) - 1
        while d > 0 and c[d] == 0:
            d -= 1
        return d if c and c[d] != 0 else -1

    def flc(c):
        d = fdeg(c)
        return c[d] if d >= 0 else Fraction(0)

    def fprem(F, G):
        F = list(F)
        G = list(G)
        dg = fdeg(G)
        if dg < 0:
            return F
        while fdeg(F) >= dg:
            df = fdeg(F)
            mult = flc(F) / flc(G)
            shift = df - dg
            if len(F) < len(G) + shift:
                F += [Fraction(0)] * (len(G) + shift - len(F))
            for i, v in enumerate(G):
                F[i + shift] -= mult * v
            while len(F) > 1 and F[-1] == 0:
                F.pop()
        return F

    for _ in range(20):
        if fdeg(G) < 0:
            return Fraction(0), Fraction(0), "vanished"
        if fdeg(G) <= 1:
            s0 = G[0] if G else Fraction(0)
            s1 = G[1] if len(G) > 1 else Fraction(0)
            return s1, s0, "ok"
        R = fprem(F, G)
        F, G = G, R
    return Fraction(0), Fraction(0), "loop"


def sres1_euclid_Fp(coeffs: list, p: int) -> tuple[int, int, str]:
    """Euclidean PRS over F_p with field division."""
    F = [x % p for x in coeffs]
    G = [x % p for x in poly_deriv(coeffs, p)]

    def fprem(F, G):
        F = list(F)
        G = list(G)
        dg = poly_deg(G)
        if dg < 0:
            return F
        inv_lc = inv_mod(poly_lc(G), p)
        while poly_deg(F) >= dg:
            df = poly_deg(F)
            mult = (poly_lc(F) * inv_lc) % p
            shift = df - dg
            if len(F) < len(G) + shift:
                F += [0] * (len(G) + shift - len(F))
            for i, v in enumerate(G):
                F[i + shift] = (F[i + shift] - mult * v) % p
            F = poly_trim(F)
        return F

    for _ in range(20):
        if poly_deg(G) < 0:
            return 0, 0, "vanished"
        if poly_deg(G) <= 1:
            s0 = G[0] % p if G else 0
            s1 = G[1] % p if len(G) > 1 else 0
            return s1, s0, "ok"
        R = fprem(F, G)
        F, G = G, R
    return 0, 0, "loop"


def sres1_classical_Q(coeffs: list) -> tuple[Fraction, Fraction, str]:
    """Classical Sres_1 via sympy.subresultants."""
    import sympy as sp

    x = sp.symbols("x")
    f = sum(int(c) * x**i for i, c in enumerate(coeffs))
    g = sp.diff(f, x)
    sr = sp.subresultants(f, g, x)
    s1poly = None
    for poly in sr:
        if sp.degree(poly, x) == 1:
            s1poly = poly
            break
    if s1poly is None:
        for poly in sr:
            if sp.degree(poly, x) == 0:
                return Fraction(0), Fraction(int(sp.Poly(poly, x).TC())), "deg0"
        return Fraction(0), Fraction(0), "missing"
    poly = sp.Poly(s1poly, x)
    s1 = Fraction(int(poly.coeff_monomial(x)))
    s0 = Fraction(int(poly.coeff_monomial(1)))
    return s1, s0, "ok"


def resultant_f_fprime(coeffs: list, mod=None) -> int:
    """Res_u(f, f') via sympy."""
    import sympy as sp

    x = sp.symbols("x")
    if mod is None:
        f = sum(int(c) * x**i for i, c in enumerate(coeffs))
        return int(sp.resultant(f, sp.diff(f, x), x))
    f = sum((int(c) % mod) * x**i for i, c in enumerate(coeffs))
    r = sp.resultant(f, sp.diff(f, x), x)
    return int(r) % mod


def eval_s1_at_point(P_terms, A, B, Y, Z, mod=None, classical=False):
    coeffs = specialize_P(P_terms, A, B, Y, Z, mod)
    if mod is None:
        if classical:
            return sres1_classical_Q(coeffs)
        return sres1_euclid_Q(coeffs)
    return sres1_euclid_Fp(coeffs, mod)


def gate_factors_at_base(P_terms, H_terms, ell_terms, C_terms, Q4_terms, A, B, Y, Z, mod=None):
    """Evaluate u-free gates at (A,B,Y,Z). G via Res/H when H != 0."""
    ell = eval_ABYZ(ell_terms, A, B, Y, Z, mod)
    C = eval_ABYZ(C_terms, A, B, Y, Z, mod)
    L = (A - 15) if mod is None else (A - 15) % mod
    M = B if mod is None else B % mod
    Q4 = eval_ABYZ(Q4_terms, A, B, Y, Z, mod)
    H = eval_ABYZ(H_terms, A, B, Y, Z, mod)
    coeffs = specialize_P(P_terms, A, B, Y, Z, mod)
    Res = resultant_f_fprime(coeffs, mod)
    if mod is None:
        if H == 0:
            G = None
        elif Res % H == 0:
            G = Res // H
        else:
            G = "Res_not_div_by_H"
    else:
        if H % mod == 0:
            G = None
        else:
            G = (Res * inv_mod(H, mod)) % mod
    return {
        "ell": ell,
        "C": C,
        "L": L,
        "M": M,
        "Q4": Q4,
        "H": H,
        "Res": Res,
        "G": G,
    }


def gcd_deg_P_Pu(coeffs, mod=None) -> int:
    """Degree of gcd(P, P_u) via Euclidean algorithm."""
    if mod is None:
        F = [Fraction(x) for x in coeffs]
        G = [Fraction(x) for x in poly_deriv(coeffs)]

        def fdeg(c):
            d = len(c) - 1
            while d > 0 and c[d] == 0:
                d -= 1
            return d if c and c[d] != 0 else -1

        def flc(c):
            d = fdeg(c)
            return c[d] if d >= 0 else Fraction(0)

        def fprem(F, G):
            F = list(F)
            G = list(G)
            dg = fdeg(G)
            if dg < 0:
                return F
            while fdeg(F) >= dg:
                df = fdeg(F)
                mult = flc(F) / flc(G)
                shift = df - dg
                if len(F) < len(G) + shift:
                    F += [Fraction(0)] * (len(G) + shift - len(F))
                for i, v in enumerate(G):
                    F[i + shift] -= mult * v
                while len(F) > 1 and F[-1] == 0:
                    F.pop()
            return F

        while fdeg(G) >= 0:
            R = fprem(F, G)
            F, G = G, R
        return fdeg(F)

    F = [c % mod for c in coeffs]
    G = [c % mod for c in poly_deriv(coeffs, mod)]
    while poly_deg(G) >= 0:
        inv = inv_mod(poly_lc(G), mod)
        dg = poly_deg(G)
        while poly_deg(F) >= dg:
            mult = (poly_lc(F) * inv) % mod
            shift = poly_deg(F) - dg
            if len(F) < len(G) + shift:
                F += [0] * (len(G) + shift - len(F))
            for i, v in enumerate(G):
                F[i + shift] = (F[i + shift] - mult * v) % mod
            F = poly_trim(F)
        F, G = G, F
    return poly_deg(F)


def bezout_sres1_via_extended_euclid(coeffs):
    """Return (s1, s0, a_coeffs, b_coeffs) with (s1*u+s0) = a*P + b*P_u over Q.

    Uses the extended Euclidean algorithm on the specialized univariate.
    Coefficients a,b are lists (low degree first).
    """
    F = [Fraction(x) for x in coeffs]
    G = [Fraction(x) for x in poly_deriv(coeffs)]
    # extended: track A_f, B_f for F = A_f * P + B_f * Pu initially F=P
    # F = 1*P + 0*Pu, G = 0*P + 1*Pu
    Af, Bf = [Fraction(1)], [Fraction(0)]
    Ag, Bg = [Fraction(0)], [Fraction(1)]

    def fdeg(c):
        d = len(c) - 1
        while d > 0 and c[d] == 0:
            d -= 1
        return d if c and c[d] != 0 else -1

    def flc(c):
        d = fdeg(c)
        return c[d] if d >= 0 else Fraction(0)

    def poly_sub_scaled(U, mult, V, shift):
        U = list(U)
        if len(U) < len(V) + shift:
            U += [Fraction(0)] * (len(V) + shift - len(U))
        for i, v in enumerate(V):
            U[i + shift] -= mult * v
        while len(U) > 1 and U[-1] == 0:
            U.pop()
        return U

    def poly_add_scaled(U, mult, V, shift):
        U = list(U)
        if len(U) < len(V) + shift:
            U += [Fraction(0)] * (len(V) + shift - len(U))
        for i, v in enumerate(V):
            U[i + shift] += mult * v
        while len(U) > 1 and U[-1] == 0:
            U.pop()
        return U

    for _ in range(20):
        if fdeg(G) < 0:
            return Fraction(0), Fraction(0), Af, Bf, "vanished"
        if fdeg(G) <= 1:
            s0 = G[0] if G else Fraction(0)
            s1 = G[1] if len(G) > 1 else Fraction(0)
            return s1, s0, Ag, Bg, "ok"
        # F = q*G + R  over Q (field division)
        # compute R = F - q G with polynomial quotient
        Fwork = list(F)
        # collect quotient terms while reducing
        # Also update cofactors: R = F - q G => Ar = Af - q Ag, Br = Bf - q Bg
        Ar, Br = list(Af), list(Bf)
        dg = fdeg(G)
        while fdeg(Fwork) >= dg:
            df = fdeg(Fwork)
            mult = flc(Fwork) / flc(G)
            shift = df - dg
            Fwork = poly_sub_scaled(Fwork, mult, G, shift)
            Ar = poly_sub_scaled(Ar, mult, Ag, shift)
            Br = poly_sub_scaled(Br, mult, Bg, shift)
        F, G = G, Fwork
        Af, Bf, Ag, Bg = Ag, Bg, Ar, Br
    return Fraction(0), Fraction(0), Af, Bf, "loop"


if __name__ == "__main__":
    P = load_P()
    H = load_H()
    print("P,H loaded", len(P), len(H))
    for pt in [(1, 2, 3, 4), (5, 7, 11, 13)]:
        s1e, s0e, st = eval_s1_at_point(P, *pt, classical=False)
        s1c, s0c, stc = eval_s1_at_point(P, *pt, classical=True)
        print(pt, "euclid", st, "classical", stc)
        if s1c != 0 and s1e != 0:
            print("  ratio", Fraction(s1e) / Fraction(s1c))
        s1b, s0b, a, b, stb = bezout_sres1_via_extended_euclid(specialize_P(P, *pt))
        print("  bezout", stb, "s1 match ratio", (s1b / s1e) if s1e != 0 else None)
