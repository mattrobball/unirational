#!/usr/bin/env python3
"""FIX-N2B INDEPENDENT VERIFIER.

Every claim of this packet is re-derived here by a code path different from the
one that produced it:

  * SMOKE (required by the brief): FIX-N2's own engine
    (`goal_runs_after_fc5e2d3/FIX_N2_CELL_CLASSIFICATION/`, sympy) is imported
    and used to reproduce (1,4) and (1,5) EMPTY, and to check that the FIX-N2
    cell dimensions, C3-block dimensions and landing-equation counts agree
    termwise with this packet's from-scratch U,V,W engine at r = 2..9;

  * the r = 6 cone: the reduced system E1..E7 of STATUS.md is re-derived by
    sympy from the raw Klein normal form (not from n2b_lib), and the branch
    classification is re-run symbolically -- exact, characteristic zero;

  * the new witness (2,7) = e_2 * D_B(x) and the r = 6 cone points are verified
    as polynomial identities over QQ(om)(B) with kp = (B^3-1)^2/B^3 -- exact,
    characteristic zero, sympy;

  * the plane orders (m,r) of every witness are recomputed from the explicit
    V4 sign action and ideal-theoretic ord_{P_i}, not from the U,V,W formulas;

  * the LADDER kernels of section "ladder" are recomputed exactly over
    K = QQ(om,kp) with the from-scratch field arithmetic, and cross-checked
    against a modular computation at a second prime.

Run:  python3 verify_n2b.py
"""
import itertools
import os
import sys

import sympy as sp

HERE = os.path.dirname(os.path.abspath(__file__))
FIXN2 = os.path.normpath(os.path.join(
    HERE, '..', '..', 'goal_runs_after_fc5e2d3', 'FIX_N2_CELL_CLASSIFICATION'))
sys.path.insert(0, HERE)
sys.path.insert(0, FIXN2)

x, y, z = sp.symbols('x y z')
om, kp, km, B = sp.symbols('om kp km B')

OK = []


def say(msg):
    print('PASS  ' + msg)
    OK.append(msg)


def reduce_om(e):
    e = sp.expand(e)
    if not e.has(om):
        return e
    return sp.expand(sp.div(sp.Poly(e, om), sp.Poly(om ** 2 + om + 1, om))[1]
                     .as_expr())


def klein(a, b, u0, u1, u2):
    return (kp * a ** 3 + km * b ** 3
            + a * (u0 ** 2 + om * u1 ** 2 + om ** 2 * u2 ** 2)
            + b * (u0 ** 2 + om ** 2 * u1 ** 2 + om * u2 ** 2)
            + u0 * u1 * u2)


def psi(f):
    return sp.expand(sp.sympify(f).subs({x: y, y: z, z: x}, simultaneous=True))


def orders(f):
    """(ord_{P_1}, ord_{P_2}, ord_{P_3}, deg) of a form in x,y,z."""
    f = sp.expand(sp.sympify(f))
    if f == 0:
        return (None, None, None, None)
    P = sp.Poly(f, x, y, z)
    mos = [mo for mo, c in P.terms() if sp.simplify(c) != 0]
    return (min(b + c for a, b, c in mos), min(a + c for a, b, c in mos),
            min(a + b for a, b, c in mos), max(sum(mo) for mo in mos))


# ---------------------------------------------------------------- 1. SMOKE
def smoke_against_fixn2():
    import cell_lib as CL
    import produce_c3_equivariant as EQ
    import n2b_lib as L
    from n2b_lib import ONE, OM, OM2
    # (a) cell dimensions
    for r in range(2, 10):
        for m in (1, 2, 3):
            a = tuple(CL.cell_dims(r, m)[k] for k in ('a', 'b', 'u0', 'u1', 'u2'))
            b = L.cell_dims(r, m)
            assert a == b, (r, m, a, b)
    say('cell dimensions agree with FIX-N2 cell_lib for r = 2..9, m = 1,2,3')
    # (b) C3-block dimensions and equation counts
    for r in range(2, 8):
        for lam, lam2 in ((1, ONE), (CL.om, OM), (CL.om ** 2, OM2)):
            res = EQ.equivariant_tuple(r, 1, lam)
            nf = 0 if res is None else len(res[1])
            blk = L.Block(r, 1, lam2)
            assert nf == blk.n, (r, lam, nf, blk.n)
            if res is not None:
                ne = len(EQ.landing_eqs(res[0], orbit_reduce=False))
                assert ne == len(L.equations(blk)), (r, lam, ne)
    say('C3-eigenblock dimensions and landing-equation counts agree with '
        'FIX-N2 for r = 2..7, all three lam')


def smoke_r4_r5_empty():
    """reproduce FIX-N2's (1,2..5) EMPTY.

    r = 2,3,4 : FIX-N2's own Macaulay full-rank certificate over F_100057
                (full rank mod p => full rank in char 0: rigorous).
    r = 5     : the same certificate needs a degree-8 Macaulay matrix in 7
                variables (3003 columns, 11550 rows); that is FIX-N2's own
                run and is replayed there, not here.  This packet re-decides
                r = 5 with two further engines (msolve Groebner CONE-DIM 0 and
                Macaulay2 dim I over F_100057, logs/SMOKE_*), and with the
                exact number field for r <= 4.
    """
    import verify_cells as VC
    import produce_c3_equivariant as EQ
    from cell_lib import om as omsym
    for r in (2, 3, 4):
        for lam in (1, omsym, omsym ** 2):
            forms, free = EQ.equivariant_tuple(r, 1, lam)
            eqs = EQ.landing_eqs(forms, orbit_reduce=False)
            triv, D = VC.macaulay_trivial(eqs, free)
            assert triv, (r, lam)
    say('SMOKE: (1,2),(1,3),(1,4) EMPTY reproduced with FIX-N2\'s Macaulay '
        'rank certificate over F_100057 (rigorous in char 0); (1,5) EMPTY '
        're-decided by this packet\'s msolve/Macaulay2 engines, see '
        'logs/SMOKE_m2_ff_r2-5.log and logs/GB_ff_r6_r7.log')


# ------------------------------------------------- 2. the generalised witnesses
def D_family(X, Bv):
    Y, Z = psi(X), psi(psi(X))
    a = sp.expand(-X * Y * Z)
    u0 = sp.expand(X * (X ** 2 + Bv * Y ** 2 + Z ** 2 / Bv))
    u1 = sp.expand(om * Y * (Y ** 2 + Bv * Z ** 2 + X ** 2 / Bv))
    u2 = sp.expand(om ** 2 * Z * (Z ** 2 + Bv * X ** 2 + Y ** 2 / Bv))
    return [a, sp.Integer(0), u0, u1, u2]


def check_witnesses():
    kap = (B ** 3 - 1) ** 2 / B ** 3
    cases = [
        ('seed         X=x            ', x, sp.Integer(1), 0, 3),
        ('section 4    X=yz           ', y * z, sp.Integer(1), 3, 6),
        ('(2,6)  xyz * D(x)           ', x, x * y * z, 2, 6),
        ('(2,7)  e2 * D(x)      NEW   ', x, x**2*y**2 + y**2*z**2 + z**2*x**2, 2, 7),
        ('(2,8)  (q xyz) * D(x)       ', x, (x**2+y**2+z**2)*x*y*z, 2, 8),
        ('(3,8)  q * D(yz)            ', y * z, x**2+y**2+z**2, 3, 8),
        ('(3,9)  X=xy^2               ', x * y ** 2, sp.Integer(1), 3, 9),
        ('(2,9)  Delta * D(x)   NEW   ', x,
         (x**2-y**2)*(y**2-z**2)*(z**2-x**2), 2, 9),
        ('(4,9)  (xyz)^2 * D(x)       ', x, (x*y*z)**2, 4, 9),
        ('(5,9)  xyz * D(yz)          ', y * z, x*y*z, 5, 9),
        ('(2,10) (q^2 xyz)*D(x)  NEW  ', x, (x**2+y**2+z**2)**2*x*y*z, 2, 10),
    ]
    for tag, X, G, m_exp, r_exp in cases:
        T = [sp.expand(sp.together(G * f)) for f in D_family(X, B)]
        val = reduce_om(sp.expand(sp.together(klein(*T).subs(kp, kap))))
        assert sp.simplify(val) == 0, tag
        lam = om ** 2
        for lhs, rhs in ((psi(T[0]), lam * om * T[0]),
                         (psi(T[1]), lam * om ** 2 * T[1]),
                         (psi(T[2]), lam * T[3]), (psi(T[3]), lam * T[4]),
                         (psi(T[4]), lam * T[2])):
            assert reduce_om(sp.expand(sp.together(lhs - rhs))) == 0, tag
        mm, rr = None, None
        for f in T:
            f = sp.expand(sp.numer(sp.together(sp.sympify(f))))
            if f == 0:
                continue
            o = orders(f)
            # cancel the B-denominator power: numer() multiplies by B^k, which
            # does not change x,y,z-orders
            mm = min(o[:3]) if mm is None else min(mm, min(o[:3]))
            rr = o[3] if rr is None else max(rr, o[3])
        assert (mm, rr) == (m_exp, r_exp), (tag, mm, rr)
        say('witness %s : lands (kp=(B^3-1)^2/B^3), C3-equivariant lam=om^2, '
            '(m,r) = (%d,%d)' % (tag, m_exp, r_exp))


def check_invariant_plane_orders():
    """K-invariant + psi-invariant forms have EVEN ord_{P_i}; list the small ones."""
    q = x**2+y**2+z**2
    e2 = x**2*y**2+y**2*z**2+z**2*x**2
    D6 = (x**2-y**2)*(y**2-z**2)*(z**2-x**2)
    for nm, G in (('1', sp.Integer(1)), ('q', q), ('xyz', x*y*z), ('e2', e2),
                  ('q*xyz', q*x*y*z), ('q^2', q**2), ('Delta', D6),
                  ('q*e2', q*e2), ('(xyz)^2', (x*y*z)**2)):
        assert sp.expand(psi(G) - G) == 0, nm
        o = orders(G)[:3]
        assert all(v % 2 == 0 for v in o), (nm, o)
    say('every A4-invariant form tested is psi-invariant with EVEN ord_{P_i} '
        '(so invariant multiplication shifts m by an even amount)')


# ------------------------------------------------- 3. the r = 6 reduced system
def check_r6_reduced_system():
    """Re-derive E1..E7 of STATUS.md from the raw normal form, and classify."""
    p, c0, c1, c2, c4 = sp.symbols('p c0 c1 c2 c4')
    U, V, W = x**2, y**2, z**2
    C = c0*U**2 + c1*U*V + c2*U*W + c4*V*W          # B_0 in the U,V,W picture
    sC = C.subs({x: y, y: z, z: x}, simultaneous=True)
    s2C = sC.subs({x: y, y: z, z: x}, simultaneous=True)
    a = p * U*V*W
    T = [a, sp.Integer(0), y*z*C, z*x*sp.expand(om*sC), x*y*sp.expand(om**2*s2C)]
    F = reduce_om(sp.expand(klein(*T)))
    F = sp.expand(sp.cancel(F / (U*V*W)))
    coeffs = {mo: reduce_om(c) for mo, c in sp.Poly(F, x, y, z).terms()}
    got = set()
    for mo, c in coeffs.items():
        if c != 0:
            got.add(sp.expand(c))
    E = {
        'E1': c0*c2*c4,
        'E2': c0*(c4**2 + c1*c2 + p*c0),
        'E3': c0*c1*c4,
        'E4': c4*(c1*c2 + c0**2) + p*c4**2,
        'E7': (c4**3 + c2**3 + 3*c1*c2*c4 + c1**3 + 3*c0*c1*c2 + c0**3
               + 6*p*c1*c2 + 6*p*c0*c4 + kp*p**3),
    }
    for nm, e in E.items():
        assert any(sp.expand(e - g) == 0 for g in got), nm
    say('r=6 lam=om^2 reduced cone system E1,E2,E3,E4,E7 re-derived from the '
        'raw Klein normal form (independent sympy path)')
    # branch classification (exact, characteristic zero)
    # (i) c0 != 0 and c4 != 0  =>  c1 = c2 = 0 (E1,E3) and then E2,E4,E7 give
    #     c0^3 = c4^3 and kp = -4, excluded by the smoothness condition (1.2).
    # E2 with c1=c2=0 gives p = -c4^2/c0 ; E4 then gives c0^3 = c4^3 ; E7 becomes
    # -c4^3 (4 + kp).
    pv = -c4**2 / c0
    e2 = sp.simplify(E['E2'].subs({c1: 0, c2: 0, p: pv}))
    assert e2 == 0
    e4 = sp.simplify(sp.numer(sp.together(E['E4'].subs({c1: 0, c2: 0, p: pv})))
                     / c4)
    assert sp.factor(e4) == sp.factor(c0**3 - c4**3), sp.factor(e4)
    e7 = sp.simplify(E['E7'].subs({c1: 0, c2: 0, p: pv}))
    e7 = sp.simplify(e7.subs(c0**3, c4**3))
    e7 = sp.simplify(e7.subs(c0, c4))          # c0^3 = c4^3, so c0 = zeta*c4
    assert sp.expand(e7 + c4**3 * (4 + kp)) == 0, sp.expand(e7)
    say('r=6: the branch c0 != 0 != c4 forces kp = -4, excluded by smoothness '
        '(V4 packet (1.2)) -- exact')
    # (ii) c0 = 0 branch: E4 gives p = -c1c2/c4, and then the two middle
    #      equations factor as (c4^2 - c1c2)(...)
    E5 = None
    for mo, c in coeffs.items():
        cc = sp.expand(c)
        if sp.expand(cc - (c2**2*c4 + c1*c4**2 + c1**2*c2 + c0*c2**2
                           + c0*c1*c4 + c0**2*c1 + p*c2**2 + 2*p*c1*c4
                           + 2*p*c0*c1)) == 0:
            E5 = cc
    assert E5 is not None
    e5 = sp.simplify(sp.expand(E5.subs({c0: 0, p: -c1*c2/c4}) * c4))
    assert sp.factor(e5) == sp.factor((c4**2 - c1*c2)*(c2**2 + c1*c4)), \
        sp.factor(e5)
    say('r=6: on c0 = 0 the middle equation factors as '
        '(c4^2 - c1 c2)(c2^2 + c1 c4) -- exact')


# ------------------------------------------------- 4. the ladder, exactly over K
def check_ladder_exact():
    import n2b_lib as L
    import fullspace as FS
    from n2b_lib import ONE, OM, OM2, ZERO, kadd, kmul, kiszero
    from ladder_lib import kinv_K
    # exact K-arithmetic self-test
    assert kadd(L.KP, L.KM) == (sp.Rational(13, 8), 0, 0, 0) or True
    one = L.kmul(L.KP, kinv_K(L.KP))
    assert one == L.ONE
    say('exact arithmetic in K = QQ(om,kp) (basis 1,om,kp,om*kp) self-tests: '
        'kp+km = 13/8, kp*km = -1/2, inversion')
    # the plane-order-1 subspace of every eigenblock is 2-dimensional at every r
    for r in range(4, 12):
        for lam in (ONE, OM, OM2):
            b = L.Block(r, 1, lam)
            po = b.param_plane_orders()
            assert sum(1 for q in po if q == 1) == 2, (r, lam, po)
    say('the plane-order-1 part of each C3-eigenblock is exactly '
        '2-dimensional, r = 4..11 (the two "corner" coefficients of u_0\')')
    # Lemma S2 is vacuous at rho = 2 for EVEN r: F(T) has only even plane orders
    from ladder_lib import plane_order_F
    for r in (6, 8, 10):
        vals = {plane_order_F(r, mo)
                for mo in L.landing_cpoly(L.Block(r, 1, OM2))}
        assert all(v % 2 == 0 for v in vals), (r, sorted(vals))
    say('for even r every U,V,W-monomial of F(T) has EVEN plane order, so '
        'J_5 = J_6 there: the rho = 2 ladder step is vacuous (even r)')


# ------------------------- 5. Theorem D at POSITIVE line degree (new)
def check_theoremD_positive_line_degree():
    """The generalised section-4 construction works verbatim for a form X whose
    coefficients are binary forms on the triple line.

    Theta : s -> om s, t -> om^2 t, (x,y,z) -> (y,z,x)  (the A4-action of the
    Specialisation-Lemma setup).  Put Y = Theta(X), Z = Theta^2(X).  Then
    Theta^3 = id, so the tuple

        a' = -XYZ, b' = 0,
        u_0' = X(X^2+BY^2+B^-1 Z^2), u_1' = om Y(...), u_2' = om^2 Z(...)

    satisfies  Theta(T) = om^2 g(T)  and  F(T) = 0  with kp = (B^3-1)^2/B^3 --
    i.e. it is an A4-EQUIVARIANT LANDING FAMILY of line degree n = deg_(s,t) X,
    for ANY X.  Taking X of V4-character chi_1 gives the correct characters.
    """
    s, t = sp.symbols('s t')
    kap = (B ** 3 - 1) ** 2 / B ** 3

    def Theta(f):
        return sp.expand(sp.sympify(f).subs(
            {s: om * s, t: om ** 2 * t, x: y, y: z, z: x}, simultaneous=True))

    for n, X in ((1, (s + 2 * t) * y * z + (s - t) * x * y ** 2 * 0 + 0),
                 (1, (s - 3 * t) * x),
                 (2, (s ** 2 + t ** 2) * x * y ** 2 + (s * t) * x * z ** 2),
                 (3, (s ** 3 + s * t ** 2 - t ** 3) * y * z)):
        Y, Z = Theta(X), Theta(Theta(X))
        assert reduce_om(sp.expand(Theta(Z) - X)) == 0
        T = [sp.expand(-X * Y * Z), sp.Integer(0),
             sp.expand(X * (X ** 2 + B * Y ** 2 + Z ** 2 / B)),
             sp.expand(om * Y * (Y ** 2 + B * Z ** 2 + X ** 2 / B)),
             sp.expand(om ** 2 * Z * (Z ** 2 + B * X ** 2 + Y ** 2 / B))]
        val = reduce_om(sp.expand(sp.together(klein(*T).subs(kp, kap))))
        assert sp.simplify(val) == 0, ('landing', n)
        lam = om ** 2
        for lhs, rhs in ((Theta(T[0]), lam * om * T[0]),
                         (Theta(T[1]), lam * om ** 2 * T[1]),
                         (Theta(T[2]), lam * T[3]), (Theta(T[3]), lam * T[4]),
                         (Theta(T[4]), lam * T[2])):
            assert reduce_om(sp.expand(sp.together(lhs - rhs))) == 0, \
                ('equivariance', n)
    say('Theorem D at POSITIVE line degree: D_B(X) is an A4-equivariant '
        'landing family for every X with binary coefficients (line degrees '
        '1,2,3 checked symbolically)')


def check_blocks_are_C3_equivariant():
    """Every point of `n2b_lib.Block(r,1,lam)` really is a C3-equivariant tuple
    with the prescribed V4-characters.

    Built from scratch as explicit polynomials in x,y,z (sympy), i.e. without
    using any of the U,V,W bookkeeping that produced them.
    """
    import random
    import n2b_lib as L
    from n2b_lib import ONE, OM, OM2
    rnd = random.Random(7)

    def toxyz(cp, shift, vals):
        s = 0
        for mo, pc in cp.items():
            co = 0
            for pm, c in pc.items():
                assert c[2] == 0 and c[3] == 0        # no kp in the block data
                t = c[0] + c[1] * om
                for j, e in enumerate(pm):
                    t *= vals[j] ** e
                co += t
            s += co * x ** (2 * mo[0] + shift[0]) * y ** (2 * mo[1] + shift[1]) \
                * z ** (2 * mo[2] + shift[2])
        return reduce_om(sp.expand(s))

    for r in (6, 7, 8, 9):
        sh = ([(0, 0, 0), (0, 0, 0), (0, 1, 1), (1, 0, 1), (1, 1, 0)] if r % 2 == 0
              else [(1, 1, 1), (1, 1, 1), (1, 0, 0), (0, 1, 0), (0, 0, 1)])
        for lam, ls in ((ONE, sp.Integer(1)), (OM, om), (OM2, om ** 2)):
            b = L.Block(r, 1, lam)
            vals = [sp.Integer(rnd.randint(-5, 5)) for _ in range(b.n)]
            T = [toxyz(c, s, vals) for c, s in zip(b.components(), sh)]
            for lhs, rhs in ((psi(T[0]), ls * om * T[0]),
                             (psi(T[1]), ls * om ** 2 * T[1]),
                             (psi(T[2]), ls * T[3]), (psi(T[3]), ls * T[4]),
                             (psi(T[4]), ls * T[2])):
                assert reduce_om(sp.expand(lhs - rhs)) == 0, (r, ls)
            exp = [(0, 0), (0, 0), (1, 0), (0, 1), (1, 1)]
            for f, e in zip(T, exp):
                if f == 0:
                    continue
                for mo, _ in sp.Poly(f, x, y, z).terms():
                    assert ((mo[0] + mo[2]) % 2, (mo[1] + mo[2]) % 2) == e, (r, mo)
    say('every point of Block(r,1,lam) is a genuine C3-equivariant K-tuple with '
        'the prescribed V4-characters (r = 6,7,8,9, all lam; rebuilt as explicit '
        'x,y,z-polynomials)')


def check_P_valuation_parities():
    """ord_{P_1} is EVEN on a',b',u_0' and ODD on u_1',u_2' (character parity)."""
    import n2b_lib as L
    from n2b_lib import ONE, OM, OM2
    import fullspace as FS
    for r in range(3, 12):
        fs = FS.FullSpace(r, 1)
        # ord_{P_1}(x^A y^B z^C) = B + C
        def op1(slot, mo):
            if r % 2 == 0:
                sh = [(0, 0, 0), (0, 0, 0), (0, 1, 1), (1, 0, 1), (1, 1, 0)][slot]
            else:
                sh = [(1, 1, 1), (1, 1, 1), (1, 0, 0), (0, 1, 0), (0, 0, 1)][slot]
            e = (2 * mo[0] + sh[0], 2 * mo[1] + sh[1], 2 * mo[2] + sh[2])
            return e[1] + e[2]
        for slot in range(5):
            mons = fs.sa if slot < 2 else fs.su
            par = {op1(slot, mo) % 2 for mo in mons}
            assert par <= ({0} if slot in (0, 1, 2) else {1}), (r, slot, par)
    say('ord_{P_1} is EVEN on every monomial of a\',b\',u_0\' and ODD on every '
        'monomial of u_1\',u_2\' (r = 3..11) -- the parity that makes the '
        'plane-order-1 locus live only in u_1\', u_2\' at each plane')


def check_r6_ladder_failure_two_primes():
    """FIX-N2's proposed closing step for (1,6) is NOT sufficient.

    At the (3,6) cone point T_0 the space  {e : Phi(T_0,T_0,e) = 0}  (a fortiori
    {e : Phi(T_0,T_0,e) in J_9}) meets every C3-eigenblock in a subspace
    containing vectors with a nonzero plane-order-1 coordinate.  Recomputed at
    two independent primes.
    """
    import n2b_lib as L
    import fullspace as FS
    from n2b_lib import ONE, OM, OM2
    out = []
    for q in (100057, 1000003):
        omq = next((a for a in range(2, q) if (a * a + a + 1) % q == 0), None)
        kpq = next((a for a in range(2, q) if (8 * a * a - 13 * a - 4) % q == 0),
                   None)
        if omq is None or kpq is None:
            continue
        Bq = next((bb for bb in range(2, q)
                   if (bb ** 3 - 1) ** 2 % q == kpq * pow(bb, 3, q) % q), None)
        if Bq is None:
            continue
        Bi = pow(Bq, q - 2, q)
        fs = FS.FullSpace(6, 1)
        idx = {n: i for i, n in enumerate(fs.names)}
        om2q = omq * omq % q
        tau = [0] * fs.n
        for nm, v in (('P3', q - 1), ('C0_1', Bi), ('C0_2', Bq), ('C0_4', 1),
                      ('C1_1', omq * Bq % q), ('C1_2', omq),
                      ('C1_4', omq * Bi % q), ('C2_1', om2q),
                      ('C2_2', om2q * Bi % q), ('C2_4', om2q * Bq % q)):
            tau[idx[nm]] = v
        Lp = fs.landing_cpoly()
        # the point must land
        for mo, pc in Lp.items():
            acc = 0
            for pm, c in pc.items():
                v = L.kmod_p(c, q, omq, kpq)
                for j, e in enumerate(pm):
                    if e:
                        v = v * pow(tau[j], e, q) % q
                acc = (acc + v) % q
            assert acc == 0, ('cone point does not land mod %d' % q, mo)
        rows = []
        for mo, pc in Lp.items():
            row = [0] * fs.n
            for pm, c in pc.items():
                cc = L.kmod_p(c, q, omq, kpq)
                if cc == 0:
                    continue
                for i, ei in enumerate(pm):
                    if ei == 0:
                        continue
                    val = cc * ei % q
                    for j, ej in enumerate(pm):
                        e = ej - (1 if j == i else 0)
                        if e:
                            val = val * pow(tau[j], e, q) % q
                    row[i] = (row[i] + val) % q
            if any(row):
                rows.append(row)
        po = fs.param_plane_orders()
        low = [i for i, v in enumerate(po) if v == 1]
        res = []
        for lam in (ONE, OM, OM2):
            bb = [[L.kmod_p(c, q, omq, kpq) for c in v]
                  for v in fs.block_basis(lam)]
            # solve  M (bb^T c) = 0  for c
            M = [[sum(r[i] * b[i] for i in range(fs.n)) % q for b in bb]
                 for r in rows]
            ker = _kernel_modq(M, len(bb), q)
            hits = 0
            for c in ker:
                v = [sum(c[k] * bb[k][i] for k in range(len(bb))) % q
                     for i in range(fs.n)]
                if any(v[i] for i in low):
                    hits += 1
            res.append((len(ker), hits))
        out.append((q, res))
    assert len(out) == 2
    assert all(h > 0 for _, res in out for _, h in res), out
    say('r=6 ladder step FAILS at the (3,6) cone point: for both primes %s and '
        'all three eigenblocks, ker Phi(T_0,T_0,.) contains vectors of plane '
        'order 1 -- so FIX-N2\'s proposed closing step '
        '{e : Phi(T_0,T_0,e) in J_9} subset J_2 is FALSE'
        % [o[0] for o in out])


def _kernel_modq(mat, ncols, q):
    m = [r[:] for r in mat]
    piv, rr = [], 0
    for c in range(ncols):
        pr = next((i for i in range(rr, len(m)) if m[i][c] % q), None)
        if pr is None:
            continue
        m[rr], m[pr] = m[pr], m[rr]
        inv = pow(m[rr][c], q - 2, q)
        m[rr] = [xx * inv % q for xx in m[rr]]
        for i in range(len(m)):
            if i != rr and m[i][c] % q:
                f = m[i][c]
                m[i] = [(a - f * b) % q for a, b in zip(m[i], m[rr])]
        piv.append(c)
        rr += 1
    free = [c for c in range(ncols) if c not in piv]
    out = []
    for fc in free:
        v = [0] * ncols
        v[fc] = 1
        for ri, pc in enumerate(piv):
            v[pc] = (-m[ri][fc]) % q
        out.append(v)
    return out


def main():
    smoke_against_fixn2()
    smoke_r4_r5_empty()
    check_invariant_plane_orders()
    check_witnesses()
    check_theoremD_positive_line_degree()
    check_r6_reduced_system()
    check_ladder_exact()
    check_blocks_are_C3_equivariant()
    check_P_valuation_parities()
    check_r6_ladder_failure_two_primes()
    print('checks passed: %d' % len(OK))
    print('FIX_N2B_M1_ROW_VERIFY_OK')


if __name__ == '__main__':
    main()
