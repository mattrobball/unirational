#!/usr/bin/env python3
"""FIX-C5 PRODUCER -- the branch quartic Delta_v of the chi_1-vertex projection.

Named by theory/FIX_IV_closure.md sec. 5.18 (named remaining work (ii), "(C5)")
and sec. 5.19 (the hand-derived closed form, the gamma-criterion).

sigma-frame REUSED, not rebuilt: goal_runs_after_9094303/FIX_L1_FRAME_CONSTANTS
(itself reusing goal_runs_after_541e12f/FIX_H1_EQUALIZER).  The V4-packet normal
form (1.1) in the certified A_4-adapted frame (E_a,E_b,E_x,E_y,E_z) is EXACTLY

    F = kp a^3 + km b^3 + a(x^2 + om y^2 + om^2 z^2) + b(x^2 + om^2 y^2 + om z^2)
        + x y z

    i.e.   F = C(a,b) + Q1(a,b) x^2 + Q2(a,b) y^2 + Q3(a,b) z^2 + c x y z   with

    C  = kp a^3 + km b^3 ,  Q1 = a+b ,  Q2 = om a + om^2 b ,  Q3 = om^2 a + om b ,
    c  = 1 (the xyz-coefficient; FIX-L1's `beta = 1`)
    kp = (13+3 sqrt33)/16 ,  km = (13-3 sqrt33)/16 ,  sqrt33 = -nu*delta ,
    delta = om - om^2 = 2om+1 ,  delta^2 = -3 ,  nu^2 = -11 .

    !! NAME CLASH WARNING.  FIX-L1's STATUS.md uses `c` for the CHEBYSHEV
    uniformiser (3+sqrt33)/4.  Note IV sec.5.19 uses `c` for the xyz-COEFFICIENT
    of the normal form.  This packet follows sec.5.19: c = 1 here.  The Chebyshev
    constant is written c_cheb throughout.

Everything is exact characteristic zero.  Field K = Q(om, nu), degree 4 over Q,
realised as sympy expressions reduced modulo the Groebner basis
{om^2+om+1, nu^2+11} (coprime leading monomials -> Buchberger's 1st criterion).

Outputs (payloads/):
    PAYLOAD_C5.txt          the full producer log
    PAYLOAD_GEOMETRY.txt    the compact closed forms + tables
    c5_data.json            machine-readable
and the two CAS inputs m2/c5_sing.m2 , oscar/c5_oscar.jl are checked in
separately (they are not generated here; they are independent transcriptions).

Exit line: FIX_C5_PRODUCE_OK
"""
import json
import os
import sys
import time

import sympy as sp

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = '/Users/worker/unirational/problems/E-klein-cubic'

T0 = time.time()
LOG = []
NCHK = [0]


def log(s=''):
    print(s, flush=True)
    LOG.append(s)


def check(cond, msg):
    NCHK[0] += 1
    if not cond:
        raise AssertionError('CHECK FAILED: ' + msg)
    return cond


# ====================================================== the field K = Q(om,nu)
om, nu = sp.symbols('om nu')
r0 = sp.Symbol('r0')                # r0^2 = 3nu/8   (adjoined for the line census)
iz = sp.Symbol('iz')                # iz^2 = -1      (adjoined for the line census)
a, b, x, y, z, xp, t, s = sp.symbols('a b x y z xp t s')
cc = sp.Symbol('c')                 # generic xyz-coefficient (kept symbolic in A)
kps, kms = sp.symbols('kps kms')    # generic C-coefficients (kept symbolic in A)

GENS = (iz, r0, om, nu, a, b, x, y, z, xp, t, s, cc, kps, kms)
REL = [iz**2 + 1, 8 * r0**2 - 3 * nu, om**2 + om + 1, nu**2 + 11]
#  leading monomials iz^2, r0^2, om^2, nu^2 are pairwise coprime,
#  so REL is a Groebner basis by Buchberger's first criterion.


def red(e):
    """reduce modulo {iz^2+1, 8r0^2-3nu, om^2+om+1, nu^2+11}; exact."""
    e = sp.expand(e)
    if e == 0:
        return sp.Integer(0)
    return sp.expand(sp.reduced(e, REL, *GENS, order='lex')[1])


def kconj(e, i, j):
    """Galois conjugate of a K-element: om -> om^2 if i, nu -> -nu if j."""
    w = sp.Symbol('WTMP')
    out = e
    if i:
        out = sp.expand(out.subs(om, w)).subs(w, -1 - om)
    if j:
        out = sp.expand(out.subs(nu, w)).subs(w, -nu)
    return red(out)


def kinv(e):
    """exact inverse of a NONZERO element of K = Q(om,nu) (degree 4 over Q)."""
    e = red(e)
    if e == 0:
        raise ZeroDivisionError('kinv(0)')
    co = red(kconj(e, 0, 1) * kconj(e, 1, 0) * kconj(e, 1, 1))
    nrm = red(e * co)
    if sp.sympify(nrm).free_symbols:
        raise ArithmeticError('norm is not rational: %s' % nrm)
    return red(sp.expand(co / nrm))


def kdiv(u, w):
    return red(u * kinv(w))


OM2 = -1 - om                       # om^2
DELTA = 2 * om + 1                  # om - om^2 ,  delta^2 = -3
S33 = red(-nu * DELTA)              # sqrt33 (FIX-L1 sign convention)
KP = red((13 + 3 * S33) / 16)
KM = red((13 - 3 * S33) / 16)
C_CHEB = red((3 + S33) / 4)         # FIX-L1's Chebyshev c ; NOT the xyz-coeff


def Cf(A, B, kp=KP, km=KM):
    return red(kp * A**3 + km * B**3)


def Q1f(A, B):
    return red(A + B)


def Q2f(A, B):
    return red(om * A + OM2 * B)


def Q3f(A, B):
    return red(OM2 * A + om * B)


def Fklein(A, B, X, Y, Z, c=1, kp=KP, km=KM):
    return red(Cf(A, B, kp, km) + Q1f(A, B) * X**2 + Q2f(A, B) * Y**2
               + Q3f(A, B) * Z**2 + c * X * Y * Z)


# ================================================================== formatting
def fmt(e):
    return sp.sstr(sp.expand(e))


def sec(title):
    log('')
    log('=' * 78)
    log(title)
    log('=' * 78)


# =============================================================================
def part_A(D):
    """A. verification of the hand-derived branch quartic (Note IV sec.5.19)."""
    sec('A.  VERIFICATION OF THE HAND-DERIVED BRANCH QUARTIC (sec. 5.19)')

    # -- A0: the field and the frame constants -------------------------------
    check(red(om**2 + om + 1) == 0, 'om relation')
    check(red(DELTA**2 + 3) == 0, 'delta^2 = -3')
    check(red(S33**2 - 33) == 0, 'sqrt33^2 = 33')
    check(red(KP + KM - sp.Rational(13, 8)) == 0, 'kp+km = 13/8')
    check(red(KP * KM + sp.Rational(1, 2)) == 0, 'kp*km = -1/2')
    check(red(8 * KP**2 - 13 * KP - 4) == 0, 'kp is a root of 8T^2-13T-4')
    check(red(KP - KM - 3 * S33 / 8) == 0, 'kp-km = 3 sqrt33/8')
    check(red(12 * C_CHEB - (9 + 3 * S33)) == 0, 'alpha = 12 c_cheb (FIX-L1 regression)')
    log('A0  K = Q(om,nu), om^2+om+1 = 0, nu^2 = -11 ; delta = 2om+1, delta^2 = -3')
    log('A0  sqrt33 = -nu*delta = %s' % fmt(S33))
    log('A0  kp = %s' % fmt(KP))
    log('A0  km = %s' % fmt(KM))
    log('A0  FIX-L1 regressions: kp+km = 13/8, kp*km = -1/2, 8kp^2-13kp-4 = 0 : PASS')

    # -- A1: v is on X, and is the chi_1-vertex ------------------------------
    v = (0, 0, 1, 0, 0)
    check(Fklein(*v, c=cc, kp=kps, km=kms) == 0, 'F(v) = 0')
    log('A1  v = [0:0:1:0:0] (the chi_1-vertex, E_x) : F(v) = 0 IDENTICALLY in')
    log('A1  (kp,km,c,om) -- no x^3 monomial is V4-invariant.  v lies ON X.')

    # -- A2: ROUTE (i) = sec.5.19 VERBATIM -----------------------------------
    #   the line through v and a general point p = (a,b,x',y,z), parametrised
    #   as  s*v + t*p , gives the binary cubic  s^2 t * ell + s t^2 * q + t^3 * k .
    Fg = Cf(a, b, kps, kms) + Q1f(a, b) * x**2 + Q2f(a, b) * y**2 \
        + Q3f(a, b) * z**2 + cc * x * y * z
    Fl = sp.expand(Fg.subs({a: t * a, b: t * b, x: s + t * xp,
                            y: t * y, z: t * z}, simultaneous=True))
    Pl = sp.Poly(Fl, s)
    c3 = sp.expand(Pl.coeff_monomial(s**3))
    c2 = sp.expand(Pl.coeff_monomial(s**2))
    c1 = sp.expand(Pl.coeff_monomial(s))
    c0 = sp.expand(Pl.coeff_monomial(1))
    ellp = Q1f(a, b)
    qp = sp.expand(2 * Q1f(a, b) * xp + cc * y * z)
    kpp = sp.expand(Cf(a, b, kps, kms) + Q1f(a, b) * xp**2 + Q2f(a, b) * y**2
                    + Q3f(a, b) * z**2 + cc * xp * y * z)
    check(c3 == 0, 'binary cubic has no s^3 term  <=>  v lies on X')
    check(sp.expand(c2 - t * ellp) == 0, "sec.5.19: ell = Q1")
    check(sp.expand(c1 - t**2 * qp) == 0, "sec.5.19: q = 2 Q1 x' + c yz")
    check(sp.expand(c0 - t**3 * kpp) == 0,
          "sec.5.19: k = C + Q1 x'^2 + Q2 y^2 + Q3 z^2 + c x' yz")
    log('A2  ROUTE (i), sec.5.19 VERBATIM.  Writing the general line through v as')
    log('A2  {s*v + t*p} with p = (a,b,x\',y,z), F restricts to the binary cubic')
    log('A2     0 * s^3  +  ell * s^2 t  +  q * s t^2  +  k * t^3        with')
    log('A2     ell = Q1(a,b)                                   [CONFIRMED]')
    log('A2     q   = 2 Q1 x\' + c y z                           [CONFIRMED]')
    log('A2     k   = C + Q1 x\'^2 + Q2 y^2 + Q3 z^2 + c x\' yz   [CONFIRMED]')
    D_i = sp.expand(qp**2 - 4 * ellp * kpp)
    check(not D_i.has(xp), "x' cancels from q^2 - 4 ell k")
    log("A2  and  Delta_v = q^2 - 4 ell k  contains NO x' :  the x'-CANCELLATION")
    log('A2  asserted in sec.5.19 is CONFIRMED (as it must be -- the discriminant')
    log('A2  lives on the projection base P^3).')

    # -- A3: INDEPENDENT ROUTE -- F as a quadratic in the eliminated slot ----
    Px = sp.Poly(Fg, x)
    e2 = sp.expand(Px.coeff_monomial(x**2))
    e1 = sp.expand(Px.coeff_monomial(x))
    e0 = sp.expand(Px.coeff_monomial(1))
    check(Px.degree() == 2, 'F is quadratic in the eliminated coordinate x')
    check(sp.expand(e2 - Q1f(a, b)) == 0, 'quadratic-in-x: leading coeff Q1')
    check(sp.expand(e1 - cc * y * z) == 0, 'quadratic-in-x: middle coeff c yz')
    check(sp.expand(e0 - (Cf(a, b, kps, kms) + Q2f(a, b) * y**2
                          + Q3f(a, b) * z**2)) == 0, 'quadratic-in-x: constant')
    D_ii = sp.expand(e1**2 - 4 * e2 * e0)
    check(sp.expand(D_i - D_ii) == 0, 'route (i) == route (ii)')
    log('A3  ROUTE (ii), INDEPENDENT BOOKKEEPING.  pi_v : [a:b:x:y:z] -> [a:b:y:z]')
    log('A3  simply ELIMINATES x, and F is a QUADRATIC in x:')
    log('A3     F = Q1(a,b) x^2 + (c y z) x + [C + Q2 y^2 + Q3 z^2] .')
    log('A3  Hence the fibre of pi_v over a general point of P^3 is the 2-element')
    log('A3  root set of this quadratic (pi_v is 2:1), and the branch locus is its')
    log('A3  discriminant.  Route (ii) discriminant == route (i) discriminant.  MATCH.')

    # -- A4: the closed form -------------------------------------------------
    Dclosed = sp.expand(cc**2 * y**2 * z**2
                        - 4 * Q1f(a, b) * (Q2f(a, b) * y**2 + Q3f(a, b) * z**2
                                           + Cf(a, b, kps, kms)))
    check(sp.expand(D_i - Dclosed) == 0, "sec.5.19 closed form for Delta_v")
    log('A4  ***  Delta_v = c^2 y^2 z^2 - 4 Q1(a,b) [ Q2 y^2 + Q3 z^2 + C ]  ***')
    log('A4      -- the sec.5.19 hand derivation is VERIFIED, generically in')
    log('A4         (kp, km, c, om), by two independent routes.')

    # -- A5: Delta_v = (c y z)^2 mod Q1 -------------------------------------
    modQ1 = sp.expand(Dclosed.subs(a, -b))
    check(sp.expand(modQ1 - cc**2 * y**2 * z**2) == 0, 'Delta = (cyz)^2 mod Q1')
    log('A5  Delta_v mod Q1  ==  (c y z)^2   : CONFIRMED  (the gamma-criterion source).')
    log('A5  Hence Delta_v|_{Q1=0} = 2*{y=0} + 2*{z=0} as a divisor on the plane')
    log('A5  {Q1=0} ~ P^2 : the plane Q1=0 is tangent to Delta_v along BOTH lines.')

    # -- A6: V4-equivariance -------------------------------------------------
    #   V4 on P^4: (a,b,x,y,z) -> (a,b,e1 x, e2 y, e3 z), e1 e2 e3 = 1.
    V4 = [(1, 1, 1), (1, -1, -1), (-1, 1, -1), (-1, -1, 1)]
    for (e1, e2, e3) in V4:
        check(sp.expand(Fg.subs({x: e1 * x, y: e2 * y, z: e3 * z}, simultaneous=True)
                        - Fg) == 0, 'F is V4-invariant')
        check(sp.expand(Dclosed.subs({y: e2 * y, z: e3 * z}, simultaneous=True)
                        - Dclosed) == 0, 'Delta_v is V4-invariant')
    log('A6  V4 = {(e1,e2,e3) : ei = +-1, e1e2e3 = 1} acts on P^4 diagonally;')
    log('A6  F is V4-invariant, v is V4-FIXED, and the induced action on')
    log('A6  P^3 = P(a,b,y,z) is (a,b,y,z) -> (a,b,e2 y,e3 z) -- FAITHFUL (V4 -> PGL_4).')
    log('A6  Delta_v is V4-INVARIANT (character chi_0) : CONFIRMED on all four elements.')

    # -- A7: specialisation to the certified frame ---------------------------
    check(sp.expand(D - red(Dclosed.subs({cc: 1, kps: KP, kms: KM}))) == 0,
          'frame specialisation of Delta_v')
    Dstruct = red(y**2 * z**2 - 4 * (KP * a**4 + KP * a**3 * b + KM * a * b**3
                                     + KM * b**4
                                     + (om * a**2 - a * b + OM2 * b**2) * y**2
                                     + (OM2 * a**2 - a * b + om * b**2) * z**2))
    check(red(D - Dstruct) == 0, 'structured expansion of Delta_v')
    log('A7  In the certified frame (c = 1, kp = (13+3sqrt33)/16, km = (13-3sqrt33)/16):')
    log('A7')
    log('A7     Delta_v  =  y^2 z^2')
    log('A7                - 4 [ kp a^4 + kp a^3 b + km a b^3 + km b^4')
    log('A7                      + (om a^2 - ab + om^2 b^2) y^2')
    log('A7                      + (om^2 a^2 - ab + om b^2) z^2 ]      [VERIFIED]')
    log('A7')
    log('A7  (raw expansion in the basis 1, om, nu, om nu:)')
    log('A7     Delta_v = %s' % fmt(D))
    return dict(ell=fmt(ellp), q=fmt(qp), k=fmt(kpp),
                Delta_generic=fmt(Dclosed), Delta_frame=fmt(D),
                Delta_structured=('y^2 z^2 - 4[ kp a^4 + kp a^3 b + km a b^3 + km b^4'
                                  ' + (om a^2 - ab + om^2 b^2) y^2'
                                  ' + (om^2 a^2 - ab + om b^2) z^2 ]'))


# =============================================================================
def part_B(D):
    """B. the line census: all lines of X through the chi_1-vertex."""
    sec('B.  LINE CENSUS -- ALL LINES OF X THROUGH THE chi_1-VERTEX')

    log('B0  A line through v = E_x is span(v, w) with w = (a,b,0,y,z) (x-slot')
    log('B0  removed mod v).  From A3 the restriction of F is the binary cubic')
    log('B0     Q1(a,b) t s^2 + c yz t^2 s + [C + Q2 y^2 + Q3 z^2] t^3 ,')
    log('B0  so span(v,w) subset X  <=>  the INCIDENCE SYSTEM')
    log('B0     (L1) Q1(a,b) = a + b      = 0')
    log('B0     (L2) c * y z              = 0')
    log('B0     (L3) C + Q2 y^2 + Q3 z^2  = 0     holds at [a:b:y:z] in P^3.')
    log('B0  (This is exactly {ell = q = k = 0}: the residual quadratic vanishes.)')

    # solve exactly.  (L1) => b = -a ; then Q2 = delta a, Q3 = -delta a,
    # C = (kp-km) a^3 = (3 sqrt33/8) a^3.
    bb = -a
    q2 = red(Q2f(a, bb))
    q3 = red(Q3f(a, bb))
    cabs = red(Cf(a, bb))
    check(sp.expand(q2 - DELTA * a) == 0, 'Q2 on Q1=0')
    check(sp.expand(q3 + DELTA * a) == 0, 'Q3 on Q1=0')
    check(red(cabs - (KP - KM) * a**3) == 0, 'C on Q1=0')
    log('B1  On (L1) (b = -a):  Q2 = delta a, Q3 = -delta a, C = (kp-km) a^3.')
    log('B1  (L2) splits into {y = 0} and {z = 0}; on each, (L3) becomes')
    log('B1     y = 0 :  a * [ (kp-km) a^2 - delta z^2 ] = 0')
    log('B1     z = 0 :  a * [ (kp-km) a^2 + delta y^2 ] = 0')
    e_y0 = red(sp.expand(cabs + q3 * z**2))
    e_z0 = red(sp.expand(cabs + q2 * y**2))
    check(red(e_y0 - a * ((KP - KM) * a**2 - DELTA * z**2)) == 0, 'y=0 branch')
    check(red(e_z0 - a * ((KP - KM) * a**2 + DELTA * y**2)) == 0, 'z=0 branch')

    #   a = 0  ->  the two coordinate solutions;
    #   a != 0 ->  z^2 = (kp-km)/delta * a^2 = -3nu/8 a^2 ,
    #              y^2 = -(kp-km)/delta * a^2 = +3nu/8 a^2 .
    yy = kdiv(KM - KP, DELTA)
    zz = kdiv(KP - KM, DELTA)
    check(red(yy - 3 * nu / 8) == 0, 'y0^2 = 3nu/8')
    check(red(zz + 3 * nu / 8) == 0, 'z0^2 = -3nu/8')
    log('B2  a != 0 (normalise a = 1, b = -1):   y^2 = 3nu/8   or   z^2 = -3nu/8 .')
    log('B2  These lie in a QUADRATIC extension of K: adjoin r0 with 8 r0^2 = 3 nu.')
    log('B2  Then y0 = +- r0 and z0 = +- i r0 (i = sqrt(-1) not in K).')
    log('B2  Over Q: r0^4 = -99/64, min poly 64 T^4 + 99 (deg 8 over Q; K has deg 4).')
    check(red(64 * (r0**4) + 99) == 0, 'r0 minimal polynomial over Q')

    # the six lines, as (name, w, image, orbit info)
    lines = []
    lines.append(('L2 = <v,E_y>', (0, 0, 0, 1, 0), '[0:0:1:0]'))
    lines.append(('L3 = <v,E_z>', (0, 0, 0, 0, 1), '[0:0:0:1]'))
    lines.append(('M_y+', (1, -1, 0, r0, 0), '[1:-1:r0:0]'))
    lines.append(('M_y-', (1, -1, 0, -r0, 0), '[1:-1:-r0:0]'))
    # z0 = i*r0: encode via z0^2 = -3nu/8 (iz is in GENS/REL with iz^2 = -1).
    z0 = iz * r0
    check(red(z0**2 + 3 * nu / 8) == 0, 'z0^2 = -3nu/8')
    lines.append(('M_z+', (1, -1, 0, 0, z0), '[1:-1:0:i r0]'))
    lines.append(('M_z-', (1, -1, 0, 0, -z0), '[1:-1:0:-i r0]'))

    log('')
    log('B3  THE SIX LINES (exactly six; the incidence system has degree 1*2*3 = 6')
    log('B3      by Bezout and all six roots are simple):')
    vvec = (0, 0, 1, 0, 0)
    rows = []
    for (nm, w, img) in lines:
        # verify F vanishes identically on span(v,w)
        pt = [red(s * vvec[i] + t * w[i]) for i in range(5)]
        val = red(Fklein(*pt, c=1))
        check(val == 0, 'F vanishes identically on line %s' % nm)
        rows.append((nm, w, img))
        log('B3     %-14s  w = (%s)   ->  image %s   [F|_line == 0 : PASS]'
            % (nm, ', '.join(fmt(u) for u in w), img))

    # V4-orbits.  On P^3 the action is (a,b,y,z) -> (a,b,e2 y, e3 z).
    log('')
    log('B4  V4-ORBIT STRUCTURE (sigma_1 = (+,-,-), sigma_2 = (-,+,-), sigma_3 = (-,-,+)):')
    log('B4     L2 = <E_x,E_y>   V4-STABLE (setwise)  stabiliser = V4        orbit size 1')
    log('B4     L3 = <E_x,E_z>   V4-STABLE (setwise)  stabiliser = V4        orbit size 1')
    log('B4     {M_y+, M_y-}     one orbit           stabiliser = <sigma_2>  orbit size 2')
    log('B4     {M_z+, M_z-}     one orbit           stabiliser = <sigma_3>  orbit size 2')
    # verify the orbit claims exactly (on the direction vectors, projectively)
    def act(w, e):
        e1, e2, e3 = e
        return (w[0], w[1], red(e1 * w[2]), red(e2 * w[3]), red(e3 * w[4]))

    def same_line(w1, w2):
        """span(v,w1) == span(v,w2)?  w_i have zero x-slot up to v; compare mod v."""
        u1 = (w1[0], w1[1], w1[3], w1[4])
        u2 = (w2[0], w2[1], w2[3], w2[4])
        # projective equality of two 4-vectors
        for i in range(4):
            for j in range(4):
                if red(u1[i] * u2[j] - u1[j] * u2[i]) != 0:
                    return False
        return True

    V4 = [((1, 1, 1), 'id'), ((1, -1, -1), 'sigma_1'),
          ((-1, 1, -1), 'sigma_2'), ((-1, -1, 1), 'sigma_3')]
    orbit_table = []
    for (nm, w, img) in lines:
        stab = []
        orb = set()
        for e, en in V4:
            w2 = act(w, e)
            hit = next(n2 for (n2, w3, _) in lines if same_line(w2, w3))
            orb.add(hit)
            if hit == nm:
                stab.append(en)
        orbit_table.append((nm, sorted(orb), stab))
    for nm, orb, stab in orbit_table:
        log('B4     %-14s orbit = %-28s stabiliser = %s'
            % (nm, '{' + ', '.join(orb) + '}', '{' + ', '.join(stab) + '}'))
    check(sorted(len(o) for _, o, _ in orbit_table) == [1, 1, 2, 2, 2, 2],
          'orbit sizes 1,1,2,2')

    log('')
    log('B5  CLASSICAL CROSS-CHECK.  Through a general point of a SMOOTH cubic')
    log('B5  threefold there pass exactly SIX lines.  The chi_1-vertex -- a V4-fixed')
    log('B5  point of X -- carries exactly six, all DISTINCT and all REDUCED.  So v')
    log('B5  is not on the "second-type" locus and pi_v is an honest 2:1 cover with')
    log('B5  a 6-fold contracted locus.')
    return rows, lines, orbit_table


# =============================================================================
def part_C(D):
    """C. the singular locus of Delta_v, by exact case analysis."""
    sec('C.  SINGULAR LOCUS OF Delta_v -- EXACT CASE ANALYSIS')

    Da, Db, Dy, Dz = (red(sp.diff(D, u)) for u in (a, b, y, z))
    check(red(4 * D - (a * Da + b * Db + y * Dy + z * Dz)) == 0, 'Euler relation')
    log('C0  Euler:  4 Delta_v = a d_a + b d_b + y d_y + z d_z , so in char 0')
    log('C0  Sing(Delta_v) = V(d_a, d_b, d_y, d_z) -- Delta_v itself is redundant.')
    Q1 = Q1f(a, b)
    Q2 = Q2f(a, b)
    Q3 = Q3f(a, b)
    C = Cf(a, b)
    check(red(Dy - 2 * y * (z**2 - 4 * Q1 * Q2)) == 0, 'd_y factorisation')
    check(red(Dz - 2 * z * (y**2 - 4 * Q1 * Q3)) == 0, 'd_z factorisation')
    kk = red(Q2 * y**2 + Q3 * z**2 + C)
    check(red(Da + 4 * (kk + Q1 * (om * y**2 + OM2 * z**2 + 3 * KP * a**2))) == 0,
          'd_a shape')
    check(red(Db + 4 * (kk + Q1 * (OM2 * y**2 + om * z**2 + 3 * KM * b**2))) == 0,
          'd_b shape')
    log('C1  d_y = 2y (c^2 z^2 - 4 Q1 Q2) ,   d_z = 2z (c^2 y^2 - 4 Q1 Q3)')
    log('C1  d_a = -4[ k + Q1(om y^2 + om^2 z^2 + 3 kp a^2) ]')
    log('C1  d_b = -4[ k + Q1(om^2 y^2 + om z^2 + 3 km b^2) ]      (k = Q2y^2+Q3z^2+C)')

    log('')
    log('C2  CASE I:  Q1 = 0  (b = -a).')
    log('C2     d_a = d_b = -4k, and d_y = 2 c^2 y z^2, d_z = 2 c^2 z y^2, so yz = 0')
    log('C2     and k = 0 -- which is EXACTLY the incidence system (L1)(L2)(L3) of B0.')
    da_I = red(Da.subs(b, -a))
    db_I = red(Db.subs(b, -a))
    check(red(da_I + 4 * kk.subs(b, -a)) == 0, 'Case I d_a = -4k')
    check(red(db_I + 4 * kk.subs(b, -a)) == 0, 'Case I d_b = -4k')
    dy_I = red(Dy.subs(b, -a))
    dz_I = red(Dz.subs(b, -a))
    check(red(dy_I - 2 * y * z**2) == 0, 'Case I d_y')
    check(red(dz_I - 2 * z * y**2) == 0, 'Case I d_z')
    log('C2     ==> Case I contributes EXACTLY the six contracted points of part B.')

    log('')
    log('C3  CASE II:  Q1 != 0.  Four subcases.')
    # II.a  y = z = 0
    log('C3   (a) y = z = 0.  Then Delta_v = -4 Q1 C, and Euler forces Delta_v = 0,')
    log('C3       so C = 0; then d_a = -12 kp Q1 a^2 and d_b = -12 km Q1 b^2 force')
    log('C3       a = b = 0 (kp,km != 0), contradicting Q1 != 0.   EMPTY.')
    check(red(D.subs({y: 0, z: 0}) + 4 * Q1 * C) == 0, 'II.a Delta')
    check(red(Da.subs({y: 0, z: 0, kps: KP}) - red((-4) * (C + Q1 * 3 * KP * a**2))) == 0,
          'II.a d_a')
    check(red(KP) != 0 and red(KM) != 0, 'kp, km nonzero')
    # II.b  y = 0, z != 0
    log('C3   (b) y = 0, z != 0.  d_z forces Q1 Q3 = 0, so Q3 = 0, i.e. b = -om a.')
    log('C3       Then C = (kp - km) a^3 and Delta_v = -4 Q1 C; Euler forces a = 0,')
    log('C3       hence b = 0, contradicting Q1 != 0.   EMPTY.  (kp != km.)')
    bB = red(-om * a)
    check(red(Q3f(a, bB)) == 0, 'II.b Q3 = 0')
    check(red(Cf(a, bB) - (KP - KM) * a**3) == 0, 'II.b C = (kp-km)a^3')
    check(red(KP - KM) != 0, 'kp != km')
    check(red(Q1f(a, bB)) != 0, 'II.b Q1 != 0 for a != 0')
    # II.c  z = 0, y != 0
    log('C3   (c) z = 0, y != 0.  Symmetrically Q2 = 0, b = -om^2 a, C = (kp-km)a^3,')
    log('C3       and the same contradiction.   EMPTY.')
    bC = red(OM2 * (-1) * a)          # b = -om^2 a
    check(red(Q2f(a, bC)) == 0, 'II.c Q2 = 0')
    check(red(Cf(a, bC) - (KP - KM) * a**3) == 0, 'II.c C = (kp-km)a^3')
    # II.d  y != 0, z != 0   -- the real content
    log('C3   (d) y != 0, z != 0.  d_y, d_z give  c^2 z^2 = 4 Q1 Q2 ,  c^2 y^2 = 4 Q1 Q3 .')
    log('C3       Substituting into d_a and d_b and dividing by Q1 != 0 gives the')
    log('C3       remarkable COLLAPSE')
    log('C3            d_a  ->  (12 + 3 kp) a^2 = 0 ,      d_b  ->  (12 + 3 km) b^2 = 0 ,')
    log('C3       and 4+kp, 4+km != 0 (indeed N_{Q(sqrt33)/Q}(4+kp) = 22), so a = b = 0,')
    log('C3       contradicting Q1 != 0.   EMPTY.')
    # exact verification of the collapse, on the subvariety y^2 = 4Q1Q3, z^2 = 4Q1Q2
    Y2 = red(4 * Q1 * Q3)
    Z2 = red(4 * Q1 * Q2)
    kk_sub = red(Q2 * Y2 + Q3 * Z2 + C)
    Da_sub = red(-4 * (kk_sub + Q1 * (om * Y2 + OM2 * Z2 + 3 * KP * a**2)))
    Db_sub = red(-4 * (kk_sub + Q1 * (OM2 * Y2 + om * Z2 + 3 * KM * b**2)))
    D_sub = red(Y2 * Z2 - 4 * Q1 * kk_sub)
    # on the subvariety Delta = 0 reads 4 Q1 Q2 Q3 + C = 0 (c = 1)
    check(red(D_sub + 4 * Q1 * (4 * Q1 * Q2 * Q3 + C)) == 0,
          'II.d Delta = -4Q1(4Q1Q2Q3 + C)')
    # now impose Delta = 0 (i.e. C = -4 Q1 Q2 Q3) and reduce d_a, d_b:
    Csub = red(-4 * Q1 * Q2 * Q3)
    kk2 = red(Q2 * Y2 + Q3 * Z2 + Csub)
    Da2 = red(-4 * (kk2 + Q1 * (om * Y2 + OM2 * Z2 + 3 * KP * a**2)))
    Db2 = red(-4 * (kk2 + Q1 * (OM2 * Y2 + om * Z2 + 3 * KM * b**2)))
    check(red(Da2 + 4 * Q1 * (12 + 3 * KP) * a**2) == 0,
          'II.d collapse of d_a to -4 Q1 (12+3kp) a^2')
    check(red(Db2 + 4 * Q1 * (12 + 3 * KM) * b**2) == 0,
          'II.d collapse of d_b to -4 Q1 (12+3km) b^2')
    check(red((4 + KP) * (4 + KM) - 22) == 0, 'N(4+kp) = (4+kp)(4+km) = 22')
    log('C3       [machine: d_a|_{subvariety, Delta=0} = -4 Q1 (12+3kp) a^2  EXACTLY,')
    log('C3        d_b|... = -4 Q1 (12+3km) b^2  EXACTLY, and (4+kp)(4+km) = 22 != 0.]')

    log('')
    log('C4  ==> THEOREM C5-S.  Sing(Delta_v) is EXACTLY the six contracted points,')
    log('C4      each REDUCED; dim = 0, degree = 6.  All six lie on the plane {Q1 = 0}.')

    # the six points, exact
    pts = [('P_y  (=image of L2)', (0, 0, 1, 0), 'V4-fixed'),
           ('P_z  (=image of L3)', (0, 0, 0, 1), 'V4-fixed'),
           ('N_y+', (1, -1, r0, 0), 'stab <sigma_2>'),
           ('N_y-', (1, -1, -r0, 0), 'stab <sigma_2>'),
           ('N_z+', (1, -1, 0, iz * r0), 'stab <sigma_3>'),
           ('N_z-', (1, -1, 0, -iz * r0), 'stab <sigma_3>')]
    log('')
    log('C5  THE SIX NODES, and the Hessian test (ordinary double point <=> rank 3):')
    hess_rows = []
    for nm, p, stab in pts:
        sub = {a: p[0], b: p[1], y: p[2], z: p[3]}
        check(red(D.subs(sub, simultaneous=True)) == 0, 'Delta vanishes at %s' % nm)
        for g, gn in ((Da, 'd_a'), (Db, 'd_b'), (Dy, 'd_y'), (Dz, 'd_z')):
            check(red(g.subs(sub, simultaneous=True)) == 0,
                  '%s vanishes at %s' % (gn, nm))
        # Hessian rank in the 3 local coordinates of the chart where p != 0
        idx = next(i for i in range(4) if red(p[i]) != 0)
        var = [a, b, y, z]
        loc = [u for i, u in enumerate(var) if i != idx]
        # affine chart: set var[idx] = 1, translate p (p[idx] is 1 in all six cases)
        check(red(p[idx] - 1) == 0, 'node %s is already normalised' % nm)
        shift = {}
        eps = sp.symbols('e0 e1 e2')
        for j, u in enumerate(loc):
            k2 = var.index(u)
            shift[u] = red(p[k2]) + eps[j]
        shift[var[idx]] = 1
        g = red(sp.expand(D.subs(shift, simultaneous=True)))
        g = sp.expand(g)
        H = sp.zeros(3, 3)
        for i2 in range(3):
            for j2 in range(3):
                H[i2, j2] = red(sp.diff(g, eps[i2], eps[j2]).subs(
                    {eps[0]: 0, eps[1]: 0, eps[2]: 0}, simultaneous=True))
        detH = red(H.det())
        rk = 3 if detH != 0 else None
        check(detH != 0, 'Hessian nondegenerate (ordinary node) at %s' % nm)
        hess_rows.append((nm, fmt(detH)))
        log('C5     %-20s  Delta = d_a = d_b = d_y = d_z = 0 ;  det Hess = %s  != 0'
            % (nm, fmt(detH)))
        log('C5     %-20s  -> ORDINARY NODE (A_1) ;  %s' % ('', stab))

    log('')
    log('C6  POSITION.  All six nodes lie on {Q1 = 0}; three on the line {Q1=y=0}')
    log('C6  (namely P_z, N_z+, N_z-) and three on {Q1=z=0} (P_y, N_y+, N_y-).')
    log('C6  Delta_v|_{Q1=0} = (c y z)^2 (A5), so the plane {Q1=0} is tangent to')
    log('C6  Delta_v along both lines, and the nodes are where the tangency degenerates.')
    for nm, p, _ in pts:
        check(red(p[0] + p[1]) == 0, 'node %s lies on Q1 = 0' % nm)

    log('')
    log('C7  THE HEADLINE INCIDENCE.  Sing(Delta_v) = pi_v(contracted locus), as SETS,')
    log('C7  and the correspondence line <-> node is a BIJECTION (6 <-> 6), V4-equivariant.')
    log('C7  There is NO node off the contracted locus and NO contracted line whose')
    log('C7  image is a smooth point.  Delta_v is a 6-NODAL QUARTIC (a nodal K3), and')
    log('C7  Bl_v X -> P^3 is the small resolution of the double solid w^2 = Delta_v.')
    return pts, hess_rows


# =============================================================================
def part_D(D):
    """D. irreducibility."""
    sec('D.  IRREDUCIBILITY OF Delta_v')
    log('D0  LEMMA C5-I (proof).  Let G be a nonzero form of degree d >= 2 in')
    log('D0  P^n, n >= 3, with dim Sing(V(G)) = 0.  Then G is REDUCED and')
    log('D0  ABSOLUTELY IRREDUCIBLE.')
    log('D0     Proof.  Over the algebraic closure write G = prod G_i^{e_i}.')
    log('D0     (i) If some e_i >= 2 then V(G_i) subset Sing(V(G)) has dim n-1 >= 2.')
    log('D0     (ii) If there are two distinct factors G_1, G_2 then')
    log('D0          V(G_1) cap V(G_2) subset Sing(V(G)) and, in P^n with n >= 2,')
    log('D0          two hypersurfaces always meet in dimension >= n-2 >= 1.')
    log('D0     Either way dim Sing >= 1, a contradiction.  QED')
    log('D0  Part C proves dim Sing(Delta_v) = 0 (exact case analysis, no Groebner).')
    log('D0  ==> Delta_v is ABSOLUTELY IRREDUCIBLE and REDUCED.  [PRIMARY ROUTE]')
    log('')
    log('D1  SECOND ROUTE (machine factorisation over K).  See')
    log('D1     oscar/c5_oscar.jl      OSCAR/Hecke factor over Q(u), u^4+28u^2+64')
    log('D1     payloads/PAYLOAD_OSCAR.txt')
    log('D1  and this producer\'s own sympy factorisation over Q(sqrt33, sqrt(-3)) below.')
    # sympy factorisation over the number field (slow but exact)
    Dnum = sp.expand(D.subs({om: sp.Rational(-1, 2) + sp.sqrt(3) * sp.I / 2,
                             nu: sp.sqrt(-11)}))
    Dnum = sp.expand(sp.nsimplify(Dnum))
    t1 = time.time()
    unit, fl = sp.factor_list(Dnum, extension=[sp.sqrt(33), sp.sqrt(-3)])
    dt = time.time() - t1
    check(len(fl) == 1 and fl[0][1] == 1, 'sympy: Delta_v irreducible over K')
    check(sp.Poly(fl[0][0], a, b, y, z).total_degree() == 4, 'the factor has degree 4')
    check(sp.simplify(sp.expand(unit * fl[0][0] - Dnum)) == 0, 'factorisation recomposes')
    log('D2  sympy factor_list over Q(sqrt33, sqrt(-3)) = K :  1 factor, degree 4,')
    log('D2  multiplicity 1  ==>  IRREDUCIBLE over K.   (%.1f s)' % dt)
    log('')
    log('D3  VERDICT.  Delta_v is irreducible over the frame field K = Q(om,nu)')
    log('D3  (= Q(sqrt-3, sqrt-11), which is its OWN Galois closure: K/Q is')
    log('D3  biquadratic, Gal(K/Q) = (Z/2)^2), and it stays irreducible over the')
    log('D3  algebraic closure.  THE BRANCH QUARTIC DOES NOT FACTOR.')
    log('D4  GALOIS STRUCTURE.  Gal(K/Q) = (Z/2)^2 = <sigma_om, sigma_nu> with')
    log('D4     sigma_om : om -> om^2, nu -> nu     (sqrt33 -> -sqrt33, kp <-> km,')
    log('D4                                          Q2 <-> Q3)')
    log('D4     sigma_nu : nu -> -nu, om -> om      (sqrt33 -> -sqrt33, kp <-> km)')
    log('D4  Each acts on Delta_v as a COORDINATE INVOLUTION of P^3:')
    gal = [('sigma_om', (1, 0), {a: b, b: a}, 'a <-> b'),
           ('sigma_nu', (0, 1), {a: b, b: a, y: z, z: y}, 'a <-> b , y <-> z'),
           ('sigma_om sigma_nu', (1, 1), {y: z, z: y}, 'y <-> z')]
    for nm, (i, j), sub, desc in gal:
        Dg = kconj(D, i, j)
        Dsw = red(sp.expand(D.subs(sub, simultaneous=True)))
        check(red(Dg - Dsw) == 0, 'Galois: %s acts as %s' % (nm, desc))
        log('D4     %-18s (Delta_v)  =  Delta_v under  %-16s  EXACT MATCH'
            % (nm, desc))
    log('D4  So Gal(K/Q) acts through the Klein four-group of coordinate swaps')
    log('D4  <(a b), (y z)> subset PGL_4, which COMMUTES with the V4-sign action but')
    log('D4  is NOT contained in it.  In particular the K-form of Delta_v descends to')
    log('D4  no smaller field, and all four Galois conjugates of Delta_v are')
    log('D4  projectively equivalent to Delta_v -- consistent with the three chi-vertices')
    log('D4  being permuted by the residual C3 = A4/V4.')
    return dict(sympy_factors=1, sympy_seconds=round(dt, 1))


# =============================================================================
def part_E(D):
    """E. the V4-action on P^3 and on Delta_v."""
    sec('E.  THE V4-ACTION ON P^3 AND ON Delta_v')
    log('E0  W/<v> = <a,b> (x) chi_0  +  <y> (x) chi_2  +  <z> (x) chi_3 .')
    log('E0  So the coordinate characters on P^3 = P(a,b,y,z) are')
    log('E0     a, b : chi_0        y : chi_2        z : chi_3 ,')
    log('E0  and V4 -> PGL_4 is FAITHFUL (sigma_1 = diag(1,1,-1,-1),')
    log('E0  sigma_2 = diag(1,1,1,-1), sigma_3 = diag(1,1,-1,1)).')
    log('E1  Every monomial of Delta_v is even in y AND even in z, so Delta_v lies in')
    log('E1  Sym^4(chi_0-isotypic part) = the chi_0 piece: Delta_v has character chi_0.')

    log('')
    log('E2  FIXED LOCUS of V4 in P^3 = { [a:b:0:0] }  u  {[0:0:1:0]}  u  {[0:0:0:1]} ,')
    log('E2  i.e. a LINE l_0 = P(<a,b>) plus TWO isolated points.')
    log('E2  The two isolated fixed points ARE two of the six nodes (P_y and P_z).')
    log('E2  Delta_v cap l_0 = {Q1 C = 0} : the four points')
    log('E2     [1:-1:0:0]  and the three points of {kp a^3 + km b^3 = 0} .')
    Dl0 = red(D.subs({y: 0, z: 0}))
    check(red(Dl0 + 4 * Q1f(a, b) * Cf(a, b)) == 0, 'Delta on the fixed line')
    #  the four points are DISTINCT: C has 3 distinct roots (kp, km != 0) and
    #  none of them is the root [1:-1] of Q1 (since C(1,-1) = kp - km != 0).
    check(red(KP) != 0 and red(KM) != 0, 'kp, km != 0 -> C has 3 distinct roots')
    check(red(Cf(1, -1)) != 0, 'C(1,-1) = kp - km != 0 -> Q1 and C are coprime')
    log('E2  [machine]  Delta_v|_{y=z=0} = -4 Q1 C  EXACTLY, and the FOUR points are')
    log('E2  DISTINCT: kp, km != 0 (so C has three distinct roots) and')
    log('E2  C(1,-1) = kp - km != 0 (so Q1 and C share no root).')
    log('E3  GEOMETRIC MEANING.  l_0 = pi_v(P(W^+)) with W^+ = <E_a,E_b,E_x> the')
    log('E3  sigma_1-plus-plane.  X cap P(W^+) = {F_0 = 0} = {kp a^3+km b^3+(a+b)x^2 = 0}')
    log('E3  is the fixed ELLIPTIC curve E_{sigma_1}, and pi_v restricted to it is the')
    log('E3  degree-2 map E_{sigma_1} -> l_0 = P^1 branched at exactly those FOUR points')
    log('E3  (Riemann-Hurwitz: 2g-2 = 2(-2)+4 = 0, g = 1).  This is the sec.5.9(b)')
    log('E3  "chi-vertex lies on E_{sigma_1}" picture, seen from the projection side.')
    log('E3  NOTE: none of those four points is singular on Delta_v (part C).')

    log('')
    log('E4  THE QUOTIENT Delta_v / V4.  Invariants of V4 acting on P^3 are')
    log('E4  a, b, Y = y^2, Z = z^2, so P^3/V4 = P(1,1,2,2) and Delta_v descends to')
    log('E4     Delta_bar :  Y Z = 4 Q1 (Q2 Y + Q3 Z + C)     (weighted degree 4),')
    log('E4  equivalently   (Y - 4Q1Q3)(Z - 4Q1Q2) = 4 Q1 (4 Q1 Q2 Q3 + C) .')
    Y, Z = sp.symbols('Y Z')
    Dbar = red(Y * Z - 4 * Q1f(a, b) * (Q2f(a, b) * Y + Q3f(a, b) * Z + Cf(a, b)))
    check(red(Dbar.subs({Y: y**2, Z: z**2}) - D) == 0, 'Delta_bar pulls back to Delta_v')
    rhs = red(4 * Q1f(a, b) * (4 * Q1f(a, b) * Q2f(a, b) * Q3f(a, b) + Cf(a, b)))
    check(red((Y - 4 * Q1f(a, b) * Q3f(a, b)) * (Z - 4 * Q1f(a, b) * Q2f(a, b))
              - rhs - Dbar) == 0, 'the hyperbola form')
    log('E4  [machine] both identities EXACT.')
    q123 = red(4 * Q1f(a, b) * Q2f(a, b) * Q3f(a, b) + Cf(a, b))
    check(red(q123 - ((4 + KP) * a**3 + (4 + KM) * b**3)) == 0, '4Q1Q2Q3 + C')
    log('E4  and  4 Q1 Q2 Q3 + C = (4+kp) a^3 + (4+km) b^3   [Q1Q2Q3 = a^3+b^3].')
    log('E5  Solving for Z shows Delta_bar is the graph of a rational function of')
    log('E5  (a,b,Y): Delta_v/V4 is a RATIONAL surface, fibred over P^1_{[a:b]} in')
    log('E5  rational curves.  The fibration degenerates exactly over the FOUR points')
    log('E5     Q1 = 0     and     (4+kp) a^3 + (4+km) b^3 = 0 ,')
    log('E5  and (4+kp)(4+km) = 22 != 0 so the second factor really is a cubic.')
    log('E5  Delta_v itself is thus the (Z/2)^2-cover of a rational surface branched')
    log('E5  over the two coordinate divisors {y=0}, {z=0}; the six nodes sit over')
    log('E5  Q1 = 0.  The V4-quotient of the branch datum is therefore as simple as')
    log('E5  it can be -- which is what the parity/lifting analysis of sec.5.18-B needs.')

    log('')
    log('E6  THE TWO COORDINATE PLANE SECTIONS (both V4-stable):')
    Dy0 = red(D.subs(y, 0))
    Dz0 = red(D.subs(z, 0))
    check(red(Dy0 + 4 * Q1f(a, b) * (Q3f(a, b) * z**2 + Cf(a, b))) == 0, 'Delta|y=0')
    check(red(Dz0 + 4 * Q1f(a, b) * (Q2f(a, b) * y**2 + Cf(a, b))) == 0, 'Delta|z=0')
    log('E6     Delta_v|_{y=0} = -4 Q1 * (Q3 z^2 + C)   -- a LINE plus a plane CUBIC')
    log('E6     Delta_v|_{z=0} = -4 Q1 * (Q2 y^2 + C)   -- a LINE plus a plane CUBIC')
    log('E6  Each cubic passes through two of the nodes of its plane; the residual')
    log('E6  intersection with the line {Q1=0} accounts for the third.')
    return dict(Delta_bar=fmt(Dbar))


# =============================================================================
def part_F():
    """F. the 55-line membership of the contracted lines (needs the group)."""
    sec('F.  WHICH CONTRACTED LINES ARE ARRANGEMENT (55-)LINES?')
    log('F0  The 55 arrangement lines are the (-1)-eigenlines l_t = P(ker(t+1)) of')
    log('F0  the 55 involutions t in PSL(2,11) (each involution has eigenvalue')
    log('F0  pattern (+1)^3 (-1)^2 on W).  Certificate A2: l_t subset X.')
    log('F0  A line through v = E_x is an arrangement line  <=>  it is l_t for an')
    log('F0  involution t with  t.E_x = -E_x  (in particular t fixes v projectively).')
    sys.path.insert(0, os.path.join(ROOT, 'goal_runs_after_6519c0b',
                                    'FIX_H0_GLOBAL_SECTIONS'))
    sys.path.insert(0, os.path.join(ROOT, 'goal_runs_after_9094303',
                                    'FIX_L1_FRAME_CONSTANTS'))
    from klein_exact import (Cyc3, C3ZERO, Grp, klein_eval,   # noqa: E402
                             ZERO)
    import produce_l1 as L1                                   # noqa: E402

    G = Grp()
    fr = L1.build_frame(0, 0, G=G)
    frame = fr['frame']
    Ex = frame[2]
    check(klein_eval(Ex, F=Cyc3) == C3ZERO,
          'the chi_1-vertex lies on the RAW Klein cubic sum x_i^2 x_{i+1}')
    log('F0b [machine] klein_eval(E_x) = 0 in the RAW frame: v in X, independently')
    log('F0b of the normal-form bookkeeping.')
    invs = [i for i in range(G.n) if G.ord[i] == 2]
    check(len(invs) == 55, 'exactly 55 involutions')
    log('F1  |PSL(2,11)| = %d ; involutions: %d  (= the 55 arrangement lines).'
        % (G.n, len(invs)))

    def c3(u):
        return Cyc3.lift(u)

    def apply_raw(Mi, vec):
        out = []
        for i in range(5):
            acc = Cyc3.lift(ZERO)
            for j in range(5):
                acc = acc + c3(Mi[i][j]) * vec[j]
            out.append(acc)
        return out

    def prop(u, w):
        """projective equality of two nonzero 5-vectors over Cyc3."""
        for i in range(5):
            for j in range(5):
                if not (u[i] * w[j] - u[j] * w[i]).is_zero():
                    return False
        return True

    thru = []
    for tix in invs:
        w = apply_raw(G.mats[tix], Ex)
        if all((w[i] + Ex[i]).is_zero() for i in range(5)):
            thru.append(tix)
    log('F2  Involutions t with t.E_x = -E_x (i.e. v in l_t): %d  -> indices %s'
        % (len(thru), thru))
    check(len(thru) == 2, 'exactly two arrangement lines pass through v')
    # identify them inside the V4
    K1g = fr['K1']
    inV4 = [ti for ti in thru if ti in K1g]
    check(len(inV4) == 2, 'both are members of the frame V4')
    log('F3  BOTH lie in the frame V4 = %s (sigma = %d).  They are the (-1)-eigenlines'
        % (str(K1g), fr['sigma']))
    # SECOND ROUTE, independent of the counting: identify each eigenline explicitly
    Ey, Ez = frame[3], frame[4]
    ident = {}
    for tix in thru:
        wy = apply_raw(G.mats[tix], Ey)
        wz = apply_raw(G.mats[tix], Ez)
        negy = all((wy[i] + Ey[i]).is_zero() for i in range(5))
        negz = all((wz[i] + Ez[i]).is_zero() for i in range(5))
        check(negy != negz, 'exactly one of E_y, E_z is also negated by t=%d' % tix)
        ident[tix] = 'l_t = <E_x, E_y> = L2' if negy else 'l_t = <E_x, E_z> = L3'
        log('F3     t = %-4d :  t.E_x = -E_x and t.%s = -%s   ==>  %s'
            % (tix, 'E_y' if negy else 'E_z', 'E_y' if negy else 'E_z', ident[tix]))
    check(sorted(ident.values()) == ['l_t = <E_x, E_y> = L2', 'l_t = <E_x, E_z> = L3'],
          'the two arrangement lines through v are exactly L2 and L3')
    log('F3  (the (-1)-eigenspace of an involution is 2-dimensional, and E_x together')
    log('F3   with the second negated basis vector already spans it -- so the')
    log('F3   identification is complete, not merely a count.)')
    log('F3  ==> L2, L3 ARE arrangement lines: sec.5.18-B\'s "L2, L3" VERIFIED.')
    # THIRD cross-check: the projective stabiliser of v is exactly the frame V4
    stab = sorted(g for g in range(G.n) if prop(apply_raw(G.mats[g], Ex), Ex))
    V4set = sorted(set(K1g) | {0})          # the three involutions plus the identity
    check(stab == V4set, 'Stab_{PSL(2,11)}(v) = the frame V4 (order 4)')
    log('F3b [cross-check] the FULL projective stabiliser of v in PSL(2,11) is')
    log('F3b exactly the frame V4 (order %d): %s.  Since an arrangement line through'
        % (len(stab), stab))
    log('F3b v forces its involution into Stab(v), the count 2 is forced by this')
    log('F3b alone -- an independent confirmation of F2.')
    log('F4  ==> The other FOUR lines through v (M_y+-, M_z+-) are NOT among the 55.')
    log('F4  They are genuinely NEW lines of X: their field of definition K(r0)')
    log('F4  (resp. K(i r0)) is a quadratic extension of the frame field, degree 8')
    log('F4  over Q, whereas the two arrangement lines are K-rational.')
    log('F5  Consequence for the lifting criterion of sec.5.18-B: the contracted locus')
    log('F5  of pi_v is NOT contained in the 55-line arrangement.  Two of the six')
    log('F5  contracted lines are arrangement lines (hence base components of every')
    log('F5  equivariant map, by (P2)), and four are not.')
    return dict(n_involutions=len(invs), n_through_v=len(thru), thru=thru,
                V4_involutions=list(K1g), stabiliser_of_v=stab,
                sigma=fr['sigma'],
                identification={str(k2): v2 for k2, v2 in ident.items()})


# =============================================================================
def main():
    log('# FIX-C5 producer -- the branch quartic Delta_v of the chi_1-vertex projection')
    log('# packet goal_runs_after_9094303/FIX_C5_BRANCH_QUARTIC')
    log('# theory/FIX_IV_closure.md sec. 5.18-5.19 ; frame = FIX_L1_FRAME_CONSTANTS')
    log('# exact characteristic zero throughout; no floating point in any decision')

    D = red(sp.expand(y**2 * z**2 - 4 * Q1f(a, b)
                      * (Q2f(a, b) * y**2 + Q3f(a, b) * z**2 + Cf(a, b))))

    A = part_A(D)
    rows, lines, orbits = part_B(D)
    pts, hess = part_C(D)
    Bv = part_D(D)
    Ev = part_E(D)
    Fv = part_F()

    sec('SUMMARY')
    log('S1  Delta_v (hand derivation of sec.5.19)              VERIFIED, 2 routes here')
    log('S1                                                       + 1 more in verify_c5.py')
    log('S2  Delta_v = (c y z)^2 mod Q1                          VERIFIED')
    log('S3  Delta_v irreducible over K and over K-bar           YES (no factorisation)')
    log('S4  Sing(Delta_v)                                       6 reduced points, dim 0,')
    log('S4                                                      degree 6, all A_1 nodes')
    log('S5  lines of X through the chi_1-vertex                 EXACTLY 6, all distinct')
    log('S6  contracted points = Sing(Delta_v)                   BIJECTION (6 <-> 6)')
    log('S7  arrangement (55-)lines among them                   EXACTLY 2 (= L2, L3)')
    log('S8  V4-orbits of the 6 lines                            1 + 1 + 2 + 2')
    log('S9  Delta_v is a 6-nodal quartic (nodal K3);  Delta_v/V4 is RATIONAL.')

    data = dict(
        packet='FIX_C5_BRANCH_QUARTIC',
        frame='FIX_L1_FRAME_CONSTANTS (V4-packet normal form (1.1))',
        field='K = Q(om,nu), om^2+om+1 = 0, nu^2 = -11 ; sqrt33 = -nu(2om+1)',
        normal_form=('F = C(a,b) + Q1 x^2 + Q2 y^2 + Q3 z^2 + c xyz ; '
                     'C = kp a^3 + km b^3, Q1 = a+b, Q2 = om a + om^2 b, '
                     'Q3 = om^2 a + om b, c = 1'),
        kp=fmt(KP), km=fmt(KM), c_xyz=1, c_chebyshev=fmt(C_CHEB),
        vertex='v = [0:0:1:0:0] = E_x  (the chi_1-vertex, V4-fixed, on X)',
        branch_quartic=A,
        singular_locus=dict(
            dim=0, degree=6, reduced=True, type='six A_1 (ordinary) nodes',
            all_on_plane='Q1 = a + b = 0',
            points=[dict(name=nm, coords=[fmt(u) for u in p], stab=st)
                    for nm, p, st in pts],
            hessian_determinants=dict(hess)),
        line_census=dict(
            count=6,
            incidence_system=['Q1(a,b) = 0', 'c*y*z = 0',
                              'C(a,b) + Q2 y^2 + Q3 z^2 = 0'],
            lines=[dict(name=nm, direction=[fmt(u) for u in w], image=img)
                   for nm, w, img in rows],
            orbits=[dict(name=nm, orbit=orb, stabiliser=st)
                    for nm, orb, st in orbits],
            arrangement=Fv,
            new_line_field='K(r0), 8 r0^2 = 3 nu  (and K(i r0)); 64 r0^4 + 99 = 0'),
        irreducibility=dict(over_K='IRREDUCIBLE', over_Kbar='IRREDUCIBLE',
                            galois_closure='K is its own Galois closure over Q',
                            routes=['Lemma C5-I + exact dim Sing = 0',
                                    'OSCAR/Hecke factor over K',
                                    'sympy factor_list over K',
                                    'M2 + OSCAR dim/degree of Sing'],
                            sympy=Bv),
        v4=Ev,
        checks=NCHK[0],
    )
    with open(os.path.join(HERE, 'payloads', 'c5_data.json'), 'w') as fh:
        json.dump(data, fh, indent=1, sort_keys=True)

    # ------------------------------------------------ the compact geometry sheet
    G = []
    G.append('FIX-C5 -- the branch quartic Delta_v of the chi_1-vertex projection')
    G.append('packet goal_runs_after_9094303/FIX_C5_BRANCH_QUARTIC')
    G.append('theory/FIX_IV_closure.md sec. 5.18-5.19 ; frame = FIX_L1_FRAME_CONSTANTS')
    G.append('')
    G.append('FRAME (V4-packet normal form (1.1), certified by FIX-L1):')
    G.append('  F = C + Q1 x^2 + Q2 y^2 + Q3 z^2 + c xyz  on P^4 = P(a,b,x,y,z)')
    G.append('  C  = kp a^3 + km b^3      kp = (13+3 sqrt33)/16, km = (13-3 sqrt33)/16')
    G.append('  Q1 = a + b   Q2 = om a + om^2 b   Q3 = om^2 a + om b   c = 1')
    G.append('  K  = Q(om,nu) = Q(sqrt-3, sqrt-11) ; sqrt33 = -nu*delta, delta = 2om+1')
    G.append('  v  = [0:0:1:0:0] = E_x : the chi_1-vertex, V4-fixed, ON X')
    G.append('')
    G.append('THE PROJECTION.  pi_v : X --> P^3 = P(a,b,y,z) eliminates x; F is a')
    G.append('QUADRATIC in x, so pi_v is 2:1, V4-equivariantly, with V4 acting on')
    G.append('P^3 by (a,b,y,z) -> (a,b, e2 y, e3 z)   (faithful).')
    G.append('')
    G.append('THE BRANCH QUARTIC  (sec.5.19 hand derivation VERIFIED, 3 routes):')
    G.append('  Delta_v = c^2 y^2 z^2 - 4 Q1(a,b) [ Q2 y^2 + Q3 z^2 + C ]')
    G.append('          = y^2 z^2 - 4[ kp a^4 + kp a^3 b + km a b^3 + km b^4')
    G.append('                         + (om a^2 - ab + om^2 b^2) y^2')
    G.append('                         + (om^2 a^2 - ab + om b^2) z^2 ]')
    G.append('  Delta_v == (c y z)^2   mod Q1 .')
    G.append('  Character: chi_0 (V4-invariant).  Degree 4.  IRREDUCIBLE over K and')
    G.append('  over K-bar.  Gal(K/Q) acts by the coordinate swaps (a b), (y z).')
    G.append('')
    G.append('SINGULAR LOCUS:  dim 0, degree 6, reduced; SIX ORDINARY NODES (A_1).')
    G.append('  name    point [a:b:y:z]        field        V4-stabiliser  det Hess')
    G.append('  P_y     [0:0:1:0]              K            V4             96')
    G.append('  P_z     [0:0:0:1]              K            V4             96')
    G.append('  N_y+-   [1:-1:+-r0:0]          K(r0)        <sigma_2>      -594')
    G.append('  N_z+-   [1:-1:0:+-i r0]        K(i r0)      <sigma_3>      -594')
    G.append('  with  8 r0^2 = 3 nu  (64 r0^4 + 99 = 0; 3nu/8 is a NONSQUARE in K).')
    G.append('  ALL SIX lie on the plane {Q1 = a+b = 0}; three on {Q1=z=0} (P_y,N_y+-)')
    G.append('  and three on {Q1=y=0} (P_z,N_z+-).  Delta_v|_{Q1=0} = (c y z)^2.')
    G.append('')
    G.append('LINE CENSUS -- lines of X through v.  Incidence system in P^3:')
    G.append('  Q1(a,b) = 0 ,  c y z = 0 ,  C + Q2 y^2 + Q3 z^2 = 0   (= {ell=q=k=0})')
    G.append('  EXACTLY SIX lines, all distinct and reduced (Bezout 1*2*3 = 6):')
    G.append('  name    line                    image       V4-orbit  arrangement?')
    G.append('  L2      <E_x, E_y>              [0:0:1:0]   {L2}      YES  (= l_{sigma_3})')
    G.append('  L3      <E_x, E_z>              [0:0:0:1]   {L3}      YES  (= l_{sigma_2})')
    G.append('  M_y+-   <E_x,(1,-1,0,+-r0,0)>   [1:-1:+-r0:0]  size 2  NO')
    G.append('  M_z+-   <E_x,(1,-1,0,0,+-i r0)> [1:-1:0:+-i r0] size 2 NO')
    G.append('  (six = the classical count of lines through a general point of a')
    G.append('   smooth cubic threefold.  Stab_{PSL(2,11)}(v) = V4, so exactly TWO')
    G.append('   of the 55 arrangement lines pass through v.)')
    G.append('')
    G.append('*** HEADLINE INCIDENCE ***')
    G.append('  pi_v(contracted lines)  =  Sing(Delta_v) ,  as SCHEMES, bijectively,')
    G.append('  V4-equivariantly.  Delta_v is a 6-NODAL QUARTIC (nodal K3) and')
    G.append('  Bl_v X -> P^3 is the small resolution of the double solid')
    G.append('  w^2 = Delta_v.  No node off the contracted locus; no contracted line')
    G.append('  whose image is a smooth point of Delta_v.')
    G.append('')
    G.append('V4-STRUCTURE.  Characters on P^3: a,b : chi_0 ; y : chi_2 ; z : chi_3 .')
    G.append('  Fix(V4) = line {y=z=0} + points [0:0:1:0], [0:0:0:1].')
    G.append('  The two isolated fixed points ARE two of the six nodes.')
    G.append('  Delta_v|_{y=z=0} = -4 Q1 C : four points -- exactly the branch points')
    G.append('  of the double cover E_{sigma_1} = X cap P(W^+) -> P^1, g = 1.')
    G.append('  QUOTIENT: Delta_v/V4 = { YZ = 4Q1(Q2 Y + Q3 Z + C) } in P(1,1,2,2),')
    G.append('  i.e. (Y-4Q1Q3)(Z-4Q1Q2) = 4Q1[(4+kp)a^3 + (4+km)b^3] -- a RATIONAL')
    G.append('  surface (graph of a rational function of (a,b,Y)); (4+kp)(4+km) = 22.')
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_GEOMETRY.txt'), 'w') as fh:
        fh.write('\n'.join(G) + '\n')

    log('')
    log('exact checks performed: %d' % NCHK[0])
    log('elapsed %.1f s' % (time.time() - T0))
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_C5.txt'), 'w') as fh:
        fh.write('\n'.join(LOG) + '\n')
    print('FIX_C5_PRODUCE_OK')


if __name__ == '__main__':
    main()
