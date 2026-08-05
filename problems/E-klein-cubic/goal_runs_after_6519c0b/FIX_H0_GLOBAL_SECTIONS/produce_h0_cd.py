#!/usr/bin/env python3
"""FIX-H0 producer, Parts C and D.

Part C  the branch table.  For every populated stalk witness of the Note-II
        cell table (theory/FIX_II_jets.md sec.4) compute, in the V4 normal
        form, the two sigma_1-graded plane orders

            aa = ord_{P_1}(T^+) = ord_{(y,z)} (a', b', u_0')     [always EVEN]
            bb = ord_{P_1}(T^-) = ord_{(y,z)} (u_1', u_2')       [always ODD ]

        and record which of the two leads.  Theorem H0-1 says a global
        equivariant dominant map must have bb < aa; PLUS-leading branches
        are globally excluded.

Part D  uniformisation: the m=1 Chebyshev locus  c^3 - 3c = kap  vs the
        odd-m genus-2 reciprocal cover  tau + 1/tau = 2 + (kp p^3 + km q^3)
        / (p^3 + q^3), at the Klein kappa values.

Writes payloads/PAYLOAD_branch_table.txt, payloads/PAYLOAD_uniformisation.txt
and payloads/h0_branches.json.
"""
import json
import os
import time
import sympy as sp

HERE = os.path.dirname(os.path.abspath(__file__))
T0 = time.time()
LINES = []


def log(s):
    print(s, flush=True)
    LINES.append(s)


x, y, z = sp.symbols('x y z')
om, B, c, P1, kp = sp.symbols('om B c P1 kp')

# ------------------------------------------------------------------ Part C

def ordP1(expr):
    """ord_{(y,z)} of a polynomial in x,y,z (min of  deg_y + deg_z )."""
    p = sp.Poly(sp.expand(expr), x, y, z)
    if p.is_zero:
        return None
    return min(m[1] + m[2] for m in p.monoms())


def orders(tup, reduce_fn=None):
    """(ord_{P_1}(T+), ord_{P_1}(T-)) for T = (a',b',u0',u1',u2')."""
    def o(exprs):
        vals = [ordP1(e) for e in exprs if sp.expand(e) != 0]
        return None if not vals else min(vals)
    return o(tup[:3]), o(tup[3:])


def ordR(tup):
    vals = []
    for e in tup:
        e = sp.expand(e)
        if e == 0:
            continue
        p = sp.Poly(e, x, y, z)
        vals.append(min(sum(m) for m in p.monoms()))
    return min(vals)


def m_of(tup):
    """m = min_i ord_{P_i}; by C3-equivariance all three agree."""
    psi = {x: y, y: z, z: x}
    t1 = tup
    t2 = [sp.expand(e.subs(psi, simultaneous=True)) for e in tup]
    t3 = [sp.expand(e.subs(psi, simultaneous=True)) for e in t2]
    outs = []
    for t in (t1, t2, t3):
        a, b = orders(t)
        outs.append(min([v for v in (a, b) if v is not None]))
    return outs


def DB(X):
    """The Theorem-D family D_B(X): X of V4-character chi_1, Y = psi X,
    Z = psi^2 X, psi:(x,y,z)->(y,z,x)."""
    psi = {x: y, y: z, z: x}
    Y = sp.expand(X.subs(psi, simultaneous=True))
    Z = sp.expand(Y.subs(psi, simultaneous=True))
    a = sp.expand(-X * Y * Z)
    b = sp.Integer(0)
    u0 = sp.expand(X * (X**2 + B * Y**2 + Z**2 / B))
    u1 = sp.expand(om * Y * (Y**2 + B * Z**2 + X**2 / B))
    u2 = sp.expand(om**2 * Z * (Z**2 + B * X**2 + Y**2 / B))
    return [a, b, u0, u1, u2]


def scale(tup, f):
    return [sp.expand(f * e) for e in tup]


def cheb_witness():
    """The FIX-N2C (m,r) = (1,7) primitive Chebyshev witness, verbatim from
    goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/payloads/PAYLOAD_witness.txt."""
    a = x*y*z*(P1*om*x**2*z**2 - P1*om*y**2*z**2 + P1*x**2*y**2 - P1*y**2*z**2
               - om*y**4 + om*z**4 + x**4 - y**4)
    b = -P1*x*y*z*(c*om*x**4 - c*om*z**4 + c*x**4 - c*y**4 + 2*om*x**2*y**2
                   - 2*om*y**2*z**2 + 2*x**2*z**2 - 2*y**2*z**2)/2
    u0 = -x*(P1*c*om*x**4*z**2 - 2*P1*c*om*x**2*y**2*z**2 - P1*c*om*y**6
             + P1*c*om*y**4*z**2 + P1*c*om*y**2*z**4 + P1*c*x**4*y**2
             - 2*P1*c*x**2*y**2*z**2 + P1*c*y**4*z**2 + P1*c*y**2*z**4
             - P1*c*z**6 - 2*P1*om*y**4*z**2 + 2*P1*om*y**2*z**4
             + 2*P1*y**4*z**2 - 2*P1*y**2*z**4 - 4*c*om*x**2*y**4
             + 4*c*om*x**2*z**4 - 2*c*x**2*y**4 + 2*c*x**2*z**4
             - 2*om*x**4*y**2 + 2*om*x**4*z**2 - 2*om*y**6 + 2*om*z**6
             - 2*x**4*y**2 + 4*x**2*y**2*z**2 - 2*y**4*z**2 - 2*y**2*z**4
             + 2*z**6)/2
    u1 = y*(-P1*c*om*x**4*z**2 - P1*c*om*x**2*y**4 + 2*P1*c*om*x**2*y**2*z**2
            - P1*c*om*x**2*z**4 + P1*c*om*z**6 + P1*c*x**6 - P1*c*x**4*z**2
            + 2*P1*c*x**2*y**2*z**2 - P1*c*x**2*z**4 - P1*c*y**4*z**2
            - 2*P1*om*x**4*z**2 + 2*P1*om*x**2*z**4 + 2*P1*x**4*z**2
            - 2*P1*x**2*z**4 - 4*c*om*x**4*y**2 + 4*c*om*y**2*z**4
            - 2*c*x**4*y**2 + 2*c*y**2*z**4 - 2*om*x**6 - 2*om*x**2*y**4
            + 2*om*y**4*z**2 + 2*om*z**6 - 2*x**6 + 2*x**4*z**2
            - 4*x**2*y**2*z**2 + 2*x**2*z**4 + 2*y**4*z**2)/2
    u2 = z*(P1*c*om*x**6 - P1*c*om*x**4*y**2 - P1*c*om*x**2*y**4
            + 2*P1*c*om*x**2*y**2*z**2 - P1*c*om*y**2*z**4 - P1*c*x**4*y**2
            - P1*c*x**2*y**4 + 2*P1*c*x**2*y**2*z**2 - P1*c*x**2*z**4
            + P1*c*y**6 + 2*P1*om*x**4*y**2 - 2*P1*om*x**2*y**4
            - 2*P1*x**4*y**2 + 2*P1*x**2*y**4 + 4*c*om*x**4*z**2
            - 4*c*om*y**4*z**2 + 2*c*x**4*z**2 - 2*c*y**4*z**2 + 2*om*x**6
            + 2*om*x**2*z**4 - 2*om*y**6 - 2*om*y**2*z**4 + 2*x**4*y**2
            + 2*x**2*y**4 - 4*x**2*y**2*z**2 + 2*x**2*z**4 - 2*y**6)/2
    return [sp.expand(e) for e in (a, b, u0, u1, u2)]


# the exact number field of the Chebyshev witness
KAP = kp + 2
GB_GENS = [om**2 + om + 1,
           8*kp**2 - 13*kp - 4,
           c**3 - 3*c - KAP,
           27*P1**3 - 24*om*KAP*P1**2 + 32*KAP]
GB = sp.groebner(GB_GENS, om, kp, c, P1, order='lex', domain='QQ')


def nonzero_mod_K(e):
    """True iff e is a nonzero element of the degree-36 field K."""
    r = GB.reduce(sp.expand(e))[1]
    return sp.simplify(r) != 0, sp.expand(r)


def part_C():
    log('--- Part C: the branch table (leading plane orders at sigma_1)')
    tests = []
    q = x**2 + y**2 + z**2                       # A4-invariant, ord_{P_i} = 0
    e2 = x**2*y**2 + y**2*z**2 + z**2*x**2       # ord_{P_i} = 2
    tests.append(('D_B seed  X = x',            '(0,3)',  DB(x)))
    tests.append(('xyz * D_B(x)   [Cor E\']',   '(2,6)',  scale(DB(x), x*y*z)))
    tests.append(('e2 * D_B(x)    [Thm N2B-3]', '(2,7)',  scale(DB(x), e2)))
    tests.append(('D_B(yz)   first layer / T5', '(3,6)',  DB(y*z)))
    tests.append(('q * D_B(yz)',                '(3,8)',  scale(DB(y*z), q)))
    tests.append(('D_B(x y^2) primitive',       '(3,9)',  DB(x*y**2)))
    tests.append(('D_B(x^2 y z)',               '(6,12)', DB(x**2*y*z)))
    tests.append(('(xyz)^2 * D_B(yz)',          '(7,12)', scale(DB(y*z), (x*y*z)**2)))

    rows = []
    for name, cell, tup in tests:
        aa, bb = orders(tup)
        r = ordR(tup)
        ms = m_of(tup)
        assert len(set(ms)) == 1, (name, ms)
        m = ms[0]
        lead = 'PLUS ' if aa < bb else 'MINUS'
        verdict = 'EXCLUDED' if aa < bb else 'survives'
        rows.append(dict(name=name, cell=cell, m=m, r=r, ordTplus=aa,
                         ordTminus=bb, leading=lead.strip(), verdict=verdict))
        log('    %-30s cell %-7s  m=%d r=%2d   ord(T+)=%s ord(T-)=%s  '
            'leading %s  -> %s' % (name, cell, m, r, aa, bb, lead, verdict))

    # the FIX-N2C primitive m=1 witness (needs the number field)
    T = cheb_witness()
    aa, bb = orders(T)
    r = ordR(T)
    # certify that the leading coefficients really are nonzero in K
    checks = {}
    pa = sp.Poly(T[0], x, y, z)
    pu1 = sp.Poly(T[3], x, y, z)
    pu2 = sp.Poly(T[4], x, y, z)
    pu0 = sp.Poly(T[2], x, y, z)
    pb = sp.Poly(T[1], x, y, z)
    def coeff(p, mono):
        d = dict(zip(p.monoms(), p.coeffs()))
        return d.get(mono, sp.Integer(0))
    cand = {
        "a'  [x^5 y z]": coeff(pa, (5, 1, 1)),
        "b'  [x^5 y z]": coeff(pb, (5, 1, 1)),
        "u0' [x^5 y^2]": coeff(pu0, (5, 2, 0)),
        "u0' [x^5 z^2]": coeff(pu0, (5, 0, 2)),
        "u1' [x^6 y]":   coeff(pu1, (6, 1, 0)),
        "u2' [x^6 z]":   coeff(pu2, (6, 0, 1)),
    }
    for k, v in cand.items():
        nz, red = nonzero_mod_K(v)
        checks[k] = {'nonzero_in_K': bool(nz), 'reduced': sp.sstr(red)}
    ms = m_of(T)
    assert len(set(ms)) == 1, ms
    rows.append(dict(name='FIX-N2C primitive Chebyshev witness', cell='(1,7)',
                     m=ms[0], r=r, ordTplus=aa, ordTminus=bb,
                     leading='MINUS' if bb < aa else 'PLUS',
                     verdict='survives' if bb < aa else 'EXCLUDED',
                     leading_coefficient_checks=checks))
    log('    %-30s cell %-7s  m=%d r=%2d   ord(T+)=%s ord(T-)=%s  '
        'leading %s  -> %s'
        % ('FIX-N2C Chebyshev (1,7)', '(1,7)', ms[0], r, aa, bb,
           'MINUS' if bb < aa else 'PLUS ',
           'survives' if bb < aa else 'EXCLUDED'))
    for k, v in checks.items():
        log('        leading coefficient %-16s nonzero in K : %s'
            % (k, v['nonzero_in_K']))
    # q^k translates keep (aa, bb) since ord_{P_i}(q) = 0
    assert ordP1(x**2 + y**2 + z**2) == 0
    log('    ord_{P_1}(q) = 0, so every q^k-translate of the (1,7) witness')
    log('      (the whole populated m=1 row, odd r >= 7) has the same')
    log('      (ord(T+), ord(T-)) = (%s, %s): MINUS-leading, survives.'
        % (aa, bb))
    return rows


# ------------------------------------------------------------------ Part D

def part_D():
    log('--- Part D: uniformisation check')
    out = {}
    s33 = sp.sqrt(33)
    kpv = (13 + 3*s33)/16
    kmv = sp.Rational(13, 8) - kpv
    assert sp.simplify(kpv*kmv + sp.Rational(1, 2)) == 0
    kap = sp.simplify(kpv + 2)
    out['kappa_plus'] = sp.sstr(kpv)
    out['kappa_minus'] = sp.sstr(sp.simplify(kmv))
    out['kap = kappa_plus + 2'] = sp.sstr(kap)

    # 1. the D_B parameter B:  (B^3-1)^2/B^3 = kp   <=>   B^3 + B^-3 = kap
    Bs = sp.symbols('Bs')
    id1 = sp.simplify(sp.expand(((Bs**3 - 1)**2 / Bs**3) - (Bs**3 + Bs**-3 - 2)))
    out['identity_(B^3-1)^2/B^3 == B^3+B^-3-2'] = (id1 == 0)
    log('    (B^3-1)^2/B^3 = B^3 + B^-3 - 2  identically : %s' % (id1 == 0))
    log('    hence  D_B parameter:  B^3 + B^-3 = kap = kp + 2')

    # 2. the Chebyshev cubic c^3 - 3c = kap is  z^3 + z^-3 = kap  for c = z+1/z
    zz = sp.symbols('zz')
    id2 = sp.simplify(sp.expand((zz + 1/zz)**3 - 3*(zz + 1/zz) - (zz**3 + zz**-3)))
    out['identity_(z+1/z)^3-3(z+1/z) == z^3+z^-3'] = (id2 == 0)
    log('    (z+1/z)^3 - 3(z+1/z) = z^3 + z^-3  identically : %s' % (id2 == 0))

    # 3. therefore the roots of c^3-3c-kap are exactly om^k B + om^-k B^-1
    w = sp.Rational(-1, 2) + sp.I*sp.sqrt(3)/2
    sols = []
    for k in range(3):
        cc = w**k * Bs + w**(-k) / Bs
        expr = sp.expand(cc**3 - 3*cc - (Bs**3 + Bs**-3))
        sols.append(sp.simplify(expr) == 0)
    out['roots_of_chebyshev_are_om^k B + om^-k/B'] = all(sols)
    log('    roots of c^3-3c = B^3+B^-3  are  c = om^k B + om^-k B^-1  '
        '(k=0,1,2) : %s' % all(sols))

    # 4. the odd-m genus-2 reciprocal cover at the character point [p:q]=[1:0]
    tau, t = sp.symbols('tau t')
    trace_at_infty = sp.simplify(2 + kpv)          # limit t -> oo of 2+(kp t^3+km)/(t^3+1)
    out['reciprocal_cover_trace_at_[1:0]'] = sp.sstr(trace_at_infty)
    same = sp.simplify(trace_at_infty - kap) == 0
    out['trace_at_[1:0] == kap'] = bool(same)
    log('    genus-2 reciprocal cover  tau + 1/tau = 2 + (kp p^3 + km q^3)'
        '/(p^3+q^3)')
    log('      at the character point [p:q] = [1:0] :  tau + 1/tau = %s'
        ' = kap : %s' % (sp.sstr(sp.simplify(trace_at_infty)), bool(same)))
    log('      so tau = B^{+-3}, while the m=1 Chebyshev parameter is')
    log('      c = tau_1 + 1/tau_1 with tau_1^3 = tau : the SAME reciprocal')
    log('      cover, the m=1 point lying over the odd-m point under the')
    log('      cubic isogeny  tau_1 |-> tau_1^3.')

    # 4b. THE KEY NUMERICAL IDENTITY OF THE KLEIN VALUES
    prod = sp.simplify((kpv + 2)*(kmv + 2))
    out['(kp+2)(km+2)'] = sp.sstr(prod)
    idok = sp.simplify(prod - sp.Rational(27, 4)) == 0
    out['(kp+2)(km+2) == 27/4'] = bool(idok)
    log('    KLEIN IDENTITY  (kp+2)(km+2) = %s = 27/4 : %s'
        % (sp.sstr(prod), bool(idok)))
    mirror = sp.simplify(-27/(4*(kpv + 2)) + (kmv + 2))
    out['-27/(4(kp+2)) == -(km+2)'] = bool(sp.simplify(mirror) == 0)
    log('    hence  -27/(4 kap) = -(km + 2)  exactly : %s'
        % bool(sp.simplify(mirror) == 0))
    log('    so the SECOND Chebyshev cubic  v^3 - 3v = -27/(4 kap)  is')
    log('      (-v)^3 - 3(-v) = km + 2 : the trace-cubic of the OTHER')
    log('      character surface S_{km}.  The m=1 witness therefore carries')
    log('      BOTH character-surface reciprocal parameters, one per surface,')
    log('      while the odd-m>=3 D_B branch carries only the S_{kp} one.')

    # 5. the second Chebyshev cubic  v^3-3v = -27/(4 kap)
    #    -> a second reciprocal-cover point mu with mu + 1/mu = -27/(4 kap).
    #    Is it the cover value at some point t of the genus-2 curve?
    u = sp.symbols('u')                             # u = t^3
    lhs = 2 + (kpv*u + kmv)/(u + 1)
    rhs = -27/(4*kap)
    usol = sp.simplify(sp.solve(sp.Eq(lhs, rhs), u)[0])
    out['second_chebyshev_target'] = sp.sstr(sp.simplify(rhs))
    out['t^3 solving cover(t) = -27/(4 kap)'] = sp.sstr(usol)
    log('    second Chebyshev cubic  v^3 - 3v = -27/(4 kap) = %s'
        % sp.sstr(sp.nsimplify(sp.radsimp(rhs))))
    log('      the cover takes that value at  t^3 = %s' % sp.sstr(usol))
    # is the corresponding point on the genus-2 curve C rational over Q(sqrt33)?
    yy2 = sp.simplify((kpv*usol + kmv)*((kpv + 4)*usol + kmv + 4))
    out['y^2 at that point'] = sp.sstr(yy2)
    issq = sp.simplify(sp.sqrt(yy2)**2 - yy2) == 0
    log('      y^2 there = %s' % sp.sstr(sp.radsimp(yy2)))
    log('      (numerically %s)' % sp.N(yy2, 30))
    out['numeric_y2'] = str(sp.N(yy2, 30))
    # numeric sanity
    Bnum = sp.nsolve(sp.Eq(Bs**3 + 1/Bs**3, sp.N(kap, 40)), Bs, 2.0, prec=40)
    out['B_numeric'] = str(Bnum)
    cnum = Bnum + 1/Bnum
    out['c_numeric_k0'] = str(cnum)
    chk = sp.N(cnum**3 - 3*cnum - kap, 30)
    out['c^3-3c-kap numeric'] = str(chk)
    log('    numeric: B = %s, c = B+1/B = %s, c^3-3c-kap = %s'
        % (sp.N(Bnum, 20), sp.N(cnum, 20), sp.N(chk, 10)))
    return out


def main():
    log('FIX-H0 producer, Parts C and D')
    rows = part_C()
    d = part_D()
    os.makedirs(os.path.join(HERE, 'payloads'), exist_ok=True)
    with open(os.path.join(HERE, 'payloads', 'h0_branches.json'), 'w') as f:
        json.dump({'branch_table': rows, 'uniformisation': d}, f, indent=1,
                  default=str, sort_keys=True)
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_branch_table.txt'),
              'w') as f:
        f.write('\n'.join(LINES) + '\n')
    log('elapsed %.1f s' % (time.time() - T0))
    log('FIX_H0_PRODUCE_CD_OK')


if __name__ == '__main__':
    main()
