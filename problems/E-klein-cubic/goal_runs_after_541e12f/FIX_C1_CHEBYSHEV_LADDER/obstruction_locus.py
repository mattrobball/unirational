#!/usr/bin/env python3
"""FIX-C1 -- the zero locus of the level-2 Kuranishi obstruction.

    Ob_2 : ker D_{p0}|_{V_{r+1}}  -->  coker D_{p0}|_{V_{r+2}}
    Ob_2(e_1) = [ 3 Phi(p0, e_1, e_1) ]

is a quadratic map; in coordinates t_0..t_{k-1} on the kernel it is a tuple of
quadratic forms q_l(t) over the parameter field.  The ladder continues past
level 2 exactly along the projective variety

    Z = { [t] in P^{k-1} : q_l(t) = 0 for all l } .

Z always contains the reparametrisation direction (V.grad)p0, since
p0 o (id + eps V) is an exact solution of the whole ladder; the question is
whether Z is anything MORE than that line.

    python3 obstruction_locus.py m1_lam0_A
"""
import json
import os
import subprocess
import sys

import sympy as sp

HERE = os.path.dirname(os.path.abspath(__file__))
om, kp = sp.symbols('om kp')
TS = sp.symbols('t0 t1 t2 t3 t4 t5')


def load(tag):
    with open(os.path.join(HERE, 'payloads', 'LADDER_%s.json' % tag)) as fh:
        return json.load(fh)


def quadrics(data, level=2):
    lv = [l for l in data['levels'] if l['level'] == level][0]
    obs = lv.get('obstruction') or []
    coords = []
    for entry in obs:
        for lbl, _ in entry['residual']:
            if lbl not in coords:
                coords.append(lbl)
    forms = {lbl: sp.Integer(0) for lbl in coords}
    for entry in obs:
        i, j = entry['pair'] if 'pair' in entry else (None, None)
        mono = TS[i]*TS[j] if i is not None else None
        for lbl, val in entry['residual']:
            forms[lbl] += sp.sympify(val)*mono
    return lv, [sp.expand(forms[l]) for l in coords], coords


def main():
    tag = sys.argv[1]
    data = load(tag)
    lv, qs, coords = quadrics(data)
    k = lv['ker'] if False else None
    kdim = [l for l in data['levels'] if l['level'] == 1][0]['ker']
    print('%s : Ob_2 is a system of %d quadratic forms in %d variables'
          % (tag, len(qs), kdim))
    for lbl, q in zip(coords, qs):
        print('   q[%s] = %s' % (lbl, sp.factor(q)))
    if not qs:
        print('   Ob_2 == 0 : the ladder is UNOBSTRUCTED at level 2.')
        return
    # Macaulay2: the projective zero locus over K = QQ(om,kp)
    m2 = os.path.join(HERE, 'm2', 'OBS_%s.m2' % tag)
    tv = ','.join(str(TS[i]) for i in range(kdim))
    body = []
    body.append('A = QQ[om,kp,%s, MonomialOrder=>Lex];' % tv)
    body.append('K = ideal(om^2+om+1, 8*kp^2-13*kp-4);')
    body.append('I = K + ideal(%s);'
                % ',\n   '.join(str(sp.expand(q*sp.Integer(1))).replace('**', '^')
                                for q in qs))
    body.append('J = saturate(I, ideal(%s));' % tv)
    body.append('<< "dim (affine cone incl. om,kp) = " << dim J << endl;')
    body.append('<< "degree = " << (if dim J > 0 then degree J else 0) << endl;')
    body.append('<< "J == K + ideal(t) ? " << (J == K + ideal(%s)) << endl;' % tv)
    body.append('<< "gens J = " << toString mingens J << endl;')
    with open(m2, 'w') as fh:
        fh.write('\n'.join(body) + '\n')
    print('--- Macaulay2 ---')
    r = subprocess.run(['M2', '--script', m2], capture_output=True, text=True,
                       timeout=900)
    print(r.stdout.strip())
    if r.stderr.strip():
        print('STDERR:', r.stderr.strip()[:2000])
    with open(os.path.join(HERE, 'logs', 'OBS_%s.log' % tag), 'w') as fh:
        fh.write(r.stdout + '\n' + r.stderr)


if __name__ == '__main__':
    main()


# ---------------------------------------------------------------------------
def exact_factor(tag):
    """the common linear factor of the level-2 obstruction quadrics.

    If Ob_2 = l_0 . L then every symmetric matrix Q_l of q_l has
    Im(Q_l) = span(l_0, L_l), so l_0 lies in the intersection of the images,
    which equals the orthogonal complement of the SUM of the kernels.  All
    exact over K = QQ(om,kp).
    """
    import c1_lib as CL
    import c1_ring as CR
    data = load(tag)
    lv, qs, coords = quadrics(data)
    if not qs:
        return None, None
    kdim = [l for l in data['levels'] if l['level'] == 1][0]['ker']
    rel = [om**2 + om + 1, 8*kp**2 - 13*kp - 4]
    rd = CL.make_red(rel, (om, kp))
    Q = CR.Quo(rel, (om, kp), (2, 2), rd)
    tv = list(TS[:kdim])
    kervecs = []
    mats = []
    for q in qs:
        P = sp.Poly(sp.expand(q), *tv)
        Mq = [[Q.from_expr(sp.Integer(0)) for _ in range(kdim)]
              for _ in range(kdim)]
        for mono, cf in zip(P.monoms(), P.coeffs()):
            idx = [i for i, e in enumerate(mono) for _ in range(e)]
            a, b = idx
            if a == b:
                Mq[a][a] = Q.from_expr(cf)
            else:
                h = sp.expand(cf/2)
                Mq[a][b] = Q.from_expr(h)
                Mq[b][a] = Q.from_expr(h)
        mats.append(Mq)
        res = CR.analyze_R(Q, Mq)
        kervecs.extend(res['kernel'])
    N = kervecs                                  # rows
    resN = CR.analyze_R(Q, N)
    l0 = resN['kernel']
    return Q, [[Q.to_expr(e) for e in v] for v in l0], mats


def report_factor(tag):
    import c1_ring as CR
    Q, l0, mats = exact_factor(tag)
    if l0 is None:
        print('%s : Ob_2 == 0' % tag)
        return
    print('%s : the common linear factor space of Ob_2 has dimension %d'
          % (tag, len(l0)))
    for v in l0:
        print('   l_0 = %s' % ' + '.join('(%s)*t%d' % (sp.factor(e), i)
                                         for i, e in enumerate(v) if e != 0))
    # verify the factorisation exactly
    data = load(tag)
    lv, qs, coords = quadrics(data)
    kdim = [l for l in data['levels'] if l['level'] == 1][0]['ker']
    tv = list(TS[:kdim])
    GB = [om**2 + om + 1, 8*kp**2 - 13*kp - 4]

    def rk(e):
        e = sp.expand(e)
        return 0 if e == 0 else sp.expand(sp.reduced(e, GB, om, kp,
                                                     order='lex')[1])
    v = l0[0]
    piv = [i for i in range(kdim) if v[i] != 0][0]
    # clear denominators: t_piv -> -sum_{i!=piv} v_i t_i , t_i -> v_piv t_i.
    # Ob_2 is homogeneous quadratic, so this rescales it by v_piv^2.
    subs = {tv[i]: sp.expand(v[piv]*tv[i]) for i in range(kdim) if i != piv}
    subs[tv[piv]] = sp.expand(-sum(v[i]*tv[i] for i in range(kdim)
                                   if i != piv))
    ok = True
    for q in qs:
        e = sp.expand(q.subs(subs, simultaneous=True))
        if e == 0:
            continue
        P = sp.Poly(e, *[tv[i] for i in range(kdim) if i != piv])
        if any(rk(cf) != 0 for cf in P.coeffs()):
            ok = False
    print('   EXACT: every obstruction quadric vanishes on {l_0 = 0} : %s' % ok)
    return ok
