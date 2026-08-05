#!/usr/bin/env python3
"""FIX-N2 INDEPENDENT VERIFIER.

Every claim of this packet is re-derived here by a method different from the one
used in the produce_* scripts:

  * characters / plane orders: recomputed from an explicit V4 SIGN ACTION on
    (x,y,z) and from explicit ideal-membership tests, not from the parity
    formula used in cell_lib;
  * the cone bound r >= ceil(3m/2) and the parity delay: recomputed by brute
    monomial enumeration;
  * packet Theorem 2.12's coefficient system (2.5)-(2.6): reconstructed and
    matched termwise (FIX-N2 cross-check 5a);
  * packet Section 4's family: landing identity and residual-C3 equivariance
    verified from scratch (FIX-N2 cross-check 5b);
  * the generalised Section-4 construction: verified as an identity in three
    free variables, then specialised to the explicit (m,r) = (3,9) witness;
  * the Specialisation Lemma: its algebraic content (t-adic graded pieces of an
    equivariant family are C3-equivariant pointwise tuples, and the bottom piece
    satisfies F = 0) verified symbolically on a generic bidegree-(n,r) family;
  * the C3-triviality decisions: re-decided by MACAULAY LINEAR ALGEBRA over a
    finite field (a rank computation in a single degree), not by Groebner bases.
    Full rank of the degree-D Macaulay matrix modulo p implies full rank in
    characteristic zero, hence (v_0,...,v_k)^D subset I, hence the solution cone
    is {0}; so this direction of the test is rigorous for the Klein values.

Run:  python3 verify_cells.py
"""

import itertools
import sys

import sympy as sp

x, y, z = sp.symbols('x y z')

# ---------------------------------------------------------------- exact field
P = 100057                     # prime with a cube root of 1 and a sqrt of 33
OM_P, KP_P, KM_P = 1140, 74361, 63219
assert (OM_P**2 + OM_P + 1) % P == 0
assert (KP_P + KM_P - 13 * pow(8, P - 2, P)) % P == 0
assert (KP_P * KM_P + pow(2, P - 2, P)) % P == 0

om = sp.Symbol('om')
kp, km = sp.symbols('kp km')


def reduce_om(e):
    e = sp.expand(e)
    if not e.has(om):
        return e
    return sp.expand(sp.div(sp.Poly(e, om), sp.Poly(om**2 + om + 1, om))[1].as_expr())


def klein(a, b, u0, u1, u2):
    return (kp * a**3 + km * b**3
            + a * (u0**2 + om * u1**2 + om**2 * u2**2)
            + b * (u0**2 + om**2 * u1**2 + om * u2**2)
            + u0 * u1 * u2)


# ------------------------------------------------- 1. characters, orders, cone
def v4_character_by_group_action(mono):
    """Character of x^A y^B z^C computed from the explicit sign action.

    K = V4 acts on (x,y,z) by the three double sign flips
    g1 = diag(1,-1,-1), g2 = diag(-1,1,-1), g3 = diag(-1,-1,1).
    The character is the pair of signs (g1, g2) recorded as bits.
    """
    A, B, C = mono
    s1 = (-1)**(B + C)          # g1
    s2 = (-1)**(A + C)          # g2
    return (0 if s1 == 1 else 1, 0 if s2 == 1 else 1)


def check_characters():
    """The sign action reproduces cell_lib's parity encoding, up to relabelling."""
    import cell_lib as CL
    # cell_lib records char = ((A+C)%2,(B+C)%2); the sign action gives
    # ((B+C)%2,(A+C)%2).  The two encodings differ by the swap of the two
    # generators, i.e. by relabelling chi_1 <-> chi_2; the trivial character and
    # the partition of monomials into the four classes are identical.
    classes_lib, classes_grp = {}, {}
    for A in range(9):
        for B in range(9 - A):
            C = 8 - A - B
            classes_lib.setdefault(CL.char_of((A, B, C)), set()).add((A, B, C))
            classes_grp.setdefault(v4_character_by_group_action((A, B, C)),
                                   set()).add((A, B, C))
    assert sorted(map(sorted, classes_lib.values())) == \
           sorted(map(sorted, classes_grp.values()))
    # and the trivial classes agree exactly
    assert classes_lib[(0, 0)] == classes_grp[(0, 0)]
    print('PASS  V4 characters: parity encoding = explicit sign action')


def check_orders_and_cone():
    """ord_{P_i} by ideal membership; cone bound; parity delay."""
    import cell_lib as CL
    for mono in itertools.product(range(5), repeat=3):
        A, B, C = mono
        mexp = sp.expand(x**A * y**B * z**C)
        # ord_{(y,z)} of a monomial = largest k with the monomial in (y,z)^k
        k = 0
        while True:
            gens = [y**i * z**(k + 1 - i) for i in range(k + 2)]
            if any(sp.simplify(mexp / g).is_polynomial() and
                   sp.denom(sp.cancel(mexp / g)) == 1 for g in gens):
                k += 1
            else:
                break
        assert k == B + C, (mono, k)
    print('PASS  ord_{P_i} by ideal membership = exponent sums')

    # cone: J_m at degree r is nonzero iff r >= ceil(3m/2); and the character
    # content of the extremal layers.
    for m in range(1, 7):
        rmin = None
        for r in range(1, 40):
            if any(CL.basis(c, r, m) for c in
                   [CL.TRIV, CL.CHI[0], CL.CHI[1], CL.CHI[2]]):
                rmin = r
                break
        assert rmin == -((-3 * m) // 2), (m, rmin)
    print('PASS  Lemma 2.1 cone bound r >= ceil(3m/2), m = 1..6')

    # parity delay: for odd m the first nonzero layer carries no trivial
    # character, i.e. a' = b' = 0 there, and the next layer does.
    for m in (1, 3, 5, 7):
        r0 = -((-3 * m) // 2)
        assert not CL.basis(CL.TRIV, r0, m)
        assert len(CL.basis(CL.CHI[0], r0, m)) == 1
        assert len(CL.basis(CL.TRIV, r0 + 1, m)) == 1
        assert len(CL.basis(CL.CHI[0], r0 + 1, m)) == (2 if m == 1 else 3)
    print('PASS  Lemma 2.2 parity delay: bottom layer (m odd) is (0,0,1,1,1);'
          ' next layer is (1,1,2,2,2) for m=1 and (1,1,3,3,3) for m=3,5,7')


# --------------------------------------------- 2. packet Theorem 2.12 (5a)
def check_packet_m1_r3():
    """Independent reconstruction of the packet's (2.1),(2.4),(2.5),(2.6)."""
    p, q, al, be, ga, de, ep, ph = sp.symbols('p q al be ga de ep ph')
    a = p * x * y * z
    b = q * x * y * z
    u0 = x * (al * y**2 + be * z**2)
    u1 = y * (ga * x**2 + de * z**2)
    u2 = z * (ep * x**2 + ph * y**2)
    F = reduce_om(sp.expand(klein(a, b, u0, u1, u2)))
    F = sp.expand(sp.cancel(F / (x * y * z)))
    U, V, W = sp.symbols('U V W')
    Fuvw = F.subs({x: sp.sqrt(U), y: sp.sqrt(V), z: sp.sqrt(W)})
    Fuvw = reduce_om(sp.expand(sp.simplify(Fuvw)))
    r0, r1, r2 = p + q, om * p + om**2 * q, om**2 * p + om * q
    c = kp * p**3 + km * q**3
    L0, L1, L2 = al * V + be * W, ga * U + de * W, ep * U + ph * V
    model = (L0 * L1 * L2 + r0 * U * L0**2 + r1 * V * L1**2 + r2 * W * L2**2
             + c * U * V * W)
    assert reduce_om(sp.expand(Fuvw - model)) == 0
    print('PASS  packet (2.4): F(tuple)/xyz equals '
          'L0L1L2 + r0 U L0^2 + r1 V L1^2 + r2 W L2^2 + c UVW')

    coeffs = {mo: reduce_om(cf) for mo, cf in
              sp.Poly(sp.expand(model), U, V, W).terms()}
    expected = {
        (2, 1, 0): ga * (al * ep + ga * r1),
        (2, 0, 1): ep * (be * ga + ep * r2),
        (1, 2, 0): al * (al * r0 + ga * ph),
        (1, 0, 2): be * (be * r0 + de * ep),
        (0, 2, 1): ph * (al * de + ph * r2),
        (0, 1, 2): de * (be * ph + de * r1),
        (1, 1, 1): (2 * al * be * r0 + al * de * ep + be * ga * ph + c
                    + 2 * de * ga * r1 + 2 * ep * ph * r2),
    }
    for mo, val in expected.items():
        assert reduce_om(sp.expand(coeffs[mo] - val)) == 0, mo
    print('PASS  packet (2.5) six factored equations and (2.6) central equation')

    sub = {be: r1 * r2 / al, ep: -ga * r1 / al, ph: -al * r0 / ga,
           de: r0 * r2 / ga}
    for mo in [(2, 1, 0), (2, 0, 1), (1, 2, 0), (1, 0, 2), (0, 2, 1), (0, 1, 2)]:
        assert sp.simplify(reduce_om(sp.expand(coeffs[mo].subs(sub)))) == 0
    cen = sp.simplify(reduce_om(sp.expand(coeffs[(1, 1, 1)].subs(sub))))
    assert sp.simplify(reduce_om(sp.expand(cen - (c + 4 * r0 * r1 * r2)))) == 0
    print('PASS  packet (2.7)-(2.8): nondegenerate branch iff c + 4 r0r1r2 = 0')


# ------------------------------------------- 3. Section 4 family + generalised
def psi(f):
    return sp.expand(sp.sympify(f).subs({x: y, y: z, z: x}, simultaneous=True))


def generalised_family(X, B):
    Y, Z = psi(X), psi(psi(X))
    w = -X * Y * Z
    v0 = X * (X**2 + B * Y**2 + Z**2 / B)
    v1 = Y * (Y**2 + B * Z**2 + X**2 / B)
    v2 = Z * (Z**2 + B * X**2 + Y**2 / B)
    return [w, 0, v0, om * v1, om**2 * v2]


def check_section4_and_generalisation():
    B = sp.Symbol('B')
    kap = (B**3 - 1)**2 / B**3
    # (i) the raw trisection identity as an identity in three FREE variables
    XX, YY, ZZ = sp.symbols('XX YY ZZ')
    w = -XX * YY * ZZ
    v0 = XX * (XX**2 + B * YY**2 + ZZ**2 / B)
    v1 = YY * (YY**2 + B * ZZ**2 + XX**2 / B)
    v2 = ZZ * (ZZ**2 + B * XX**2 + YY**2 / B)
    ident = sp.together(kap * w**3 + w * (v0**2 + v1**2 + v2**2) + v0 * v1 * v2)
    assert sp.simplify(sp.factor(ident)) == 0
    print('PASS  trisection identity kappa w^3 + w*sum(v^2) + v0v1v2 = 0 '
          'as an identity in three free variables')

    # (ii) it lands in the Klein normal form after the diagonal rescaling
    #      u0=v0, u1=om v1, u2=om^2 v2, a=w, b=0, kp = kappa
    for tag, X, mult, r_exp, m_exp in (
            ('seed     (X=x)   ', x, 1, 3, 0),
            ('section 4 (X=yz)  ', y * z, 1, 6, 3),
            ('witness  (X=xy^2) ', x * y**2, 1, 9, 3),
            ('witness  (X=x^2yz)', x**2 * y * z, 1, 12, 6),
            ('witness  xyz*(X=x)', x, x * y * z, 6, 2),
            ('witness  (x^2+y^2+z^2)*(X=yz)', y * z, x**2 + y**2 + z**2, 8, 3)):
        T = [sp.expand(mult * f) for f in generalised_family(X, B)]
        val = reduce_om(sp.expand(sp.together(klein(*T).subs(kp, kap))))
        assert sp.simplify(val) == 0, tag
        lam = om**2
        for lhs, rhs in ((psi(T[0]), lam * om * T[0]),
                         (psi(T[1]), lam * om**2 * T[1]),
                         (psi(T[2]), lam * T[3]), (psi(T[3]), lam * T[4]),
                         (psi(T[4]), lam * T[2])):
            assert reduce_om(sp.expand(sp.together(lhs - rhs))) == 0, tag
        monos = set()
        for f in T:
            f = sp.sympify(f)
            if f == 0:
                continue
            f = sp.expand(sp.numer(sp.together(f)))
            for mo, _ in sp.Poly(f, x, y, z).terms():
                monos.add(mo)
        r = max(sum(mo) for mo in monos)
        mx = max(max(mo) for mo in monos if sum(mo) == r)
        assert (r, r - mx) == (r_exp, m_exp), (tag, r, r - mx)
        print('PASS  %s: lands, C3-equivariant with lam=om^2, (m,r) = (%d,%d)'
              % (tag, m_exp, r_exp))


# ------------------------------------------------- 4. Specialisation Lemma
def check_specialisation_lemma():
    """Symbolic check of the lemma's algebraic content on a generic family.

    Take the general bidegree-(n,r) tuple with (n,r) = (2,3), impose the
    A4-equivariance Theta(T) = lam * g(T) with Theta: s->om s, t->om^2 t,
    (x,y,z)->(y,z,x), and check that (a) each t-graded piece is a C3-equivariant
    pointwise tuple, (b) the t^0 part of F(T) is F(T_0).
    """
    s, t = sp.symbols('s t')
    n, r = 2, 3
    import cell_lib as CL
    lam = om**2
    forms, coeffs, bases = CL.make_tuple(r, 1)
    # give every coefficient a generic binary form of degree n
    binco = {}
    fam = []
    for slot, (f, bs) in enumerate(zip(forms, bases)):
        g = 0
        for mo in bs:
            for j in range(n + 1):
                c = sp.Symbol('C%d_%d_%d_%d_%d' % (slot, mo[0], mo[1], mo[2], j))
                binco[(slot, mo, j)] = c
                g += c * s**(n - j) * t**j * x**mo[0] * y**mo[1] * z**mo[2]
        fam.append(g)
    Theta = lambda f: sp.expand(sp.sympify(f).subs(
        {s: om * s, t: om**2 * t, x: y, y: z, z: x}, simultaneous=True))
    conds = []
    for lhs, rhs in ((Theta(fam[0]), lam * om * fam[0]),
                     (Theta(fam[1]), lam * om**2 * fam[1]),
                     (Theta(fam[2]), lam * fam[3]),
                     (Theta(fam[3]), lam * fam[4]),
                     (Theta(fam[4]), lam * fam[2])):
        d = reduce_om(sp.expand(lhs - rhs))
        if d != 0:
            conds.extend(sp.Poly(d, s, t, x, y, z).coeffs())
    conds = [reduce_om(c) for c in conds]
    conds = [c for c in conds if c != 0]
    sol = sp.solve(conds, list(binco.values()), dict=True)
    assert sol, 'equivariance system unsolvable'
    fam = [reduce_om(sp.expand(sp.sympify(f).subs(sol[0]))) for f in fam]
    # (a) each t-graded piece is C3-equivariant pointwise, with lam shifted
    psi_ = lambda f: sp.expand(sp.sympify(f).subs({x: y, y: z, z: x},
                                                  simultaneous=True))
    for j in range(n + 1):
        Tj = [sp.expand(sp.sympify(f).coeff(t, j)).subs(s, 1) for f in fam]
        if all(f == 0 for f in Tj):
            continue
        # Theta multiplies the t^j piece by om^(2j + (n-j)); the pointwise
        # scalar for T_j is therefore lam * om^(-(2j+n-j)) = lam*om^(-(n+j)).
        lamj = reduce_om(sp.expand(lam * om**((3 - (n + j) % 3) % 3)))
        ok = all(reduce_om(sp.expand(L - R)) == 0 for L, R in
                 ((psi_(Tj[0]), lamj * om * Tj[0]),
                  (psi_(Tj[1]), lamj * om**2 * Tj[1]),
                  (psi_(Tj[2]), lamj * Tj[3]), (psi_(Tj[3]), lamj * Tj[4]),
                  (psi_(Tj[4]), lamj * Tj[2])))
        assert ok, ('graded piece not C3-equivariant', j)
    print('PASS  Specialisation Lemma (a): every t-graded piece of an '
          'A4-equivariant family is a C3-equivariant pointwise tuple')
    # (b) the t^0 part of F(T) is F(T_0)
    T0 = [sp.expand(sp.sympify(f).coeff(t, 0)).subs(s, 1) for f in fam]
    FT = reduce_om(sp.expand(klein(*fam)))
    assert reduce_om(sp.expand(sp.expand(FT).coeff(t, 0).subs(s, 1)
                               - klein(*T0))) == 0
    print('PASS  Specialisation Lemma (b): the t^0 level of F(T) is F(T_0)')


# ------------------------------- 5. C3-triviality by Macaulay linear algebra
def macaulay_trivial(eqs, params, maxdeg=9):
    """True if (params)^D is contained in the ideal of eqs, for some D<=maxdeg.

    Rank computation modulo P with om,kp,km specialised to the exact Klein
    values.  Full rank mod P implies full rank in characteristic zero, so a
    True answer certifies that the (homogeneous) solution cone is {0} over the
    algebraic closure of QQ(om,kappa).
    """
    if not eqs:
        return False
    sub = {om: OM_P, kp: KP_P, km: KM_P}
    polys = []
    for e in eqs:
        pe = sp.Poly(sp.expand(sp.sympify(e).subs(sub)), *params)
        polys.append({mo: int(cf) % P for mo, cf in pe.terms()})
    d0 = max(sum(mo) for pdict in polys for mo in pdict)
    npar = len(params)
    for D in range(d0, maxdeg + 1):
        mons = [mo for mo in itertools.product(range(D + 1), repeat=npar)
                if sum(mo) == D]
        index = {mo: i for i, mo in enumerate(mons)}
        rows = []
        for pdict in polys:
            dg = max(sum(mo) for mo in pdict)
            if dg > D:
                continue
            for mult in itertools.product(range(D - dg + 1), repeat=npar):
                if sum(mult) != D - dg:
                    continue
                row = {}
                for mo, cf in pdict.items():
                    key = tuple(a + b for a, b in zip(mo, mult))
                    row[index[key]] = (row.get(index[key], 0) + cf) % P
                rows.append(row)
        if rank_mod_p(rows, len(mons)) == len(mons):
            return True, D
    return False, None


def rank_mod_p(rows, ncols):
    piv = {}
    rank = 0
    for row in rows:
        row = dict(row)
        while row:
            j = min(row)
            if row[j] % P == 0:
                del row[j]
                continue
            if j in piv:
                f = row[j] * pow(piv[j][j], P - 2, P) % P
                for k, v in piv[j].items():
                    row[k] = (row.get(k, 0) - f * v) % P
                row = {k: v for k, v in row.items() if v % P}
            else:
                piv[j] = row
                rank += 1
                break
        if rank == ncols:
            break
    return rank


def check_c3_triviality(rmax=6):
    import produce_c3_equivariant as EQ
    from cell_lib import om as omsym
    results = {}
    for r in range(2, rmax + 1):
        for lam in (1, omsym, omsym**2):
            res = EQ.equivariant_tuple(r, 1, lam)
            if res is None:
                results[(r, str(lam))] = ('empty linear space', None)
                continue
            forms, free = res
            eqs = EQ.landing_eqs(forms, orbit_reduce=False)  # full system
            if not free:
                results[(r, str(lam))] = ('empty linear space', None)
                continue
            triv, D = macaulay_trivial(eqs, free)
            results[(r, str(lam))] = ('cone = {0}' if triv else 'NONTRIVIAL', D)
            print('   r=%d lam=%-5s free=%2d : %s%s'
                  % (r, lam, len(free), results[(r, str(lam))][0],
                     '' if D is None else '  (certified in degree %d)' % D))
            sys.stdout.flush()
    return results


def main():
    check_characters()
    check_orders_and_cone()
    check_packet_m1_r3()
    check_section4_and_generalisation()
    check_specialisation_lemma()
    print('--- C3-equivariant pointwise solution cones in J_1, '
          'by Macaulay rank over F_%d:' % P)
    check_c3_triviality(rmax=int(sys.argv[1]) if len(sys.argv) > 1 else 5)
    print('FIX_N2_CELL_CLASSIFICATION_VERIFY_OK')


if __name__ == '__main__':
    main()
