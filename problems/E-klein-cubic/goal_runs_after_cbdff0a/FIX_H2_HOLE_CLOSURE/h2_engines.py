#!/usr/bin/env python3
"""FIX-H2: the engine battery, with the FIX-H1 discipline.

Three independent CHARACTERISTIC-ZERO engines, each of which decides
"is the ideal the unit ideal, i.e. is the variety empty":

  qq  -- msolve over QQ with om, kp adjoined as VARIABLES and their minimal
         polynomials om^2+om+1, 8kp^2-13kp-4 added to the ideal.  Both are
         irreducible over QQ, so Gal(Qbar/QQ) is transitive on their roots and
         the ideal is (1) iff the system has no solution for the packet's
         (om, kp+).  Inputs are emitted fully expanded with BARE INTEGER
         coefficients and asserted parenthesis-free (msolve 0.10.1 silently
         mis-parses parentheses -- FIX-N2C/MSOLVE_PARSER.md), and the `-g`
         '#'-header is stripped before the unit test (same doc, addendum).
  m2  -- Macaulay2 over K = toField(QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4)),
         `1 % I == 0`.
  sp  -- sympy Groebner over QQ[vars,om,kp] + the two minimal polynomials.

plus `ff` -- msolve mod p with split (om_p, kp_p): a FINDING, never a verdict.

A timeout, a zero-byte output or a missing output file is NOT-DECIDED /
ERROR, never a verdict.  Every msolve unit/non-unit reading in this packet is
produced by `H.is_unit_ideal` and that parser is self-tested here against a
positive (unit) and a negative (non-unit) control -- run `h2_engines.py
--selftest`.
"""
import os
import subprocess
import sys
import time

import holes_leaf as LF
import holes_lib as H
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE

NTH = os.environ.get('NTH', '8')
PRIMES = [100057, 100153, 1048609]


# --------------------------------------------------------------------- msolve
def ff(tag, names, polys, p=100057, timeout=1800, nthreads=None):
    omp, kpp = S.find_roots(p)
    assert omp is not None and kpp is not None, 'prime %d not split' % p
    src = H.emit_ff(names, polys, p, omp, kpp)
    rc, dt, txt = H.run_msolve('%s_p%d' % (tag, p), src, flags=['-g', '1'],
                               nthreads=nthreads or NTH, timeout=timeout)
    if txt.startswith('<'):
        return None, dt, txt
    return H.is_unit_ideal(txt), dt, txt[:200]


def qq(tag, names, polys, timeout=3600, nthreads=None):
    src = H.emit_vars(names, polys, 0)
    rc, dt, txt = H.run_msolve(tag + '_qq', src, flags=['-g', '2'],
                               nthreads=nthreads or NTH, timeout=timeout)
    if txt.startswith('<'):
        return None, dt, txt
    return H.is_unit_ideal(txt), dt, txt[:200]


# ------------------------------------------------------------------ Macaulay2
def m2_source(names, polys, tag, order=None):
    lines = []
    for q in polys:
        terms = []
        for k, v in sorted(q.items()):
            mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                           for i, e in enumerate(k) if e)
            terms.append('(%s)%s' % (L.kstr(v), '*' + mon if mon else ''))
        lines.append('+'.join(terms))
    ring = ('R = K[%s];' % ','.join(names)) if names else 'R = K[dummy];'
    if order == 'lex':
        ring = 'R = K[%s, MonomialOrder => Lex];' % ','.join(names)
    if order == 'elim':
        ring = ('R = K[%s, MonomialOrder => {%d,%d}];'
                % (','.join(names), min(3, len(names)),
                   max(0, len(names) - 3)))
    hdr = ['A = QQ[om,kp];',
           'K = toField(A/ideal(om^2+om+1, 8*kp^2-13*kp-4));',
           ring,
           'I = ideal(\n  %s\n);' % ',\n  '.join(lines)]
    body = ['stdio << "-- %s" << endl << flush;' % tag,
            'u = (1_R % I);',
            'stdio << "ONE-IN-I " << (u == 0) << endl << flush;',
            'if u == 0 then ( stdio << "VERDICT UNIT-IDEAL (EMPTY)" << endl )'
            ' else ( stdio << "VERDICT NON-UNIT dim=" << dim I'
            ' << " degree=" << degree I << endl );',
            'stdio << "M2-DONE" << endl << flush;',
            'exit 0']
    return '\n'.join(hdr + body) + '\n'


def m2(tag, names, polys, timeout=3600, order=None):
    src = m2_source(names, polys, tag, order)
    d = os.path.join(H.HERE, 'm2')
    os.makedirs(d, exist_ok=True)
    p = os.path.join(d, tag + '.m2')
    open(p, 'w').write(src)
    t0 = time.time()
    try:
        r = subprocess.run([H.M2, '--script', p], capture_output=True,
                           text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return None, time.time() - t0, '<TIMEOUT>'
    dt = time.time() - t0
    out = r.stdout + r.stderr
    open(os.path.join(H.HERE, 'logs', tag + '_m2.log'), 'w').write(out)
    if not out.strip():
        return None, dt, '<EMPTY M2 OUTPUT -- ERROR, NOT A VERDICT>'
    if 'UNIT-IDEAL' in out:
        return True, dt, 'M2 unit'
    if 'NON-UNIT' in out:
        return False, dt, out[out.find('VERDICT'):][:200]
    return None, dt, out.strip()[-300:]


def m2v_source(names, polys, tag):
    """Macaulay2 over QQ with om, kp adjoined as VARIABLES plus their minimal
    polynomials -- the same Galois-transitivity argument as msolve-qq, but a
    completely different implementation (and usually far faster than toField
    arithmetic).  Still a characteristic-zero proof."""
    vs = list(names) + ['om', 'kp']
    lines = []
    for q in polys:
        terms = []
        for k, v in sorted(q.items()):
            mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                           for i, e in enumerate(k) if e)
            for ci, extra in ((0, ''), (1, '*om'), (2, '*kp'), (3, '*om*kp')):
                if v[ci] == 0:
                    continue
                c = v[ci]
                terms.append('(%d/%d)%s%s' % (c.numerator, c.denominator,
                                              ('*' + mon) if mon else '',
                                              extra))
        if terms:
            lines.append('+'.join(terms))
    lines.append('om^2+om+1')
    lines.append('8*kp^2-13*kp-4')
    hdr = ['R = QQ[%s];' % ','.join(vs),
           'I = ideal(\n  %s\n);' % ',\n  '.join(lines)]
    body = ['stdio << "-- %s" << endl << flush;' % tag,
            'u = (1_R % I);',
            'stdio << "ONE-IN-I " << (u == 0) << endl << flush;',
            'if u == 0 then ( stdio << "VERDICT UNIT-IDEAL (EMPTY)" << endl )'
            ' else ( stdio << "VERDICT NON-UNIT dim=" << dim I << endl );',
            'stdio << "M2-DONE" << endl << flush;',
            'exit 0']
    return '\n'.join(hdr + body) + '\n'


def m2d_source(names, polys, tag, dlim):
    """DEGREE-BOUNDED Groebner probe (the brief's step 3-iii), over
    QQ[vars,om,kp] + the two minimal polynomials.

    RIGOROUS BUT ONE-SIDED: if a partial Groebner basis truncated at degree
    `dlim` already contains a nonzero CONSTANT, then 1 lies in the ideal and
    the variety is empty -- a complete characteristic-zero proof, because the
    partial basis consists of honest ideal members.  If no constant appears
    the answer is NOT-DECIDED; it is never a NONEMPTY verdict.
    """
    body = m2v_source(names, polys, tag).split('I = ideal(')[1]
    ideal_txt = 'I = ideal(' + body.split('\n);')[0] + '\n);'
    vs = list(names) + ['om', 'kp']
    return '\n'.join([
        'R = QQ[%s];' % ','.join(vs),
        ideal_txt,
        'stdio << "-- %s dlim=%d" << endl << flush;' % (tag, dlim),
        'G = flatten entries gens gb(I, DegreeLimit => %d);' % dlim,
        'c = select(G, g -> g != 0 and first degree g == 0);',
        'stdio << "GBSIZE " << #G << " CONSTS " << #c << endl << flush;',
        'if #c > 0 then ( stdio << "VERDICT UNIT-IDEAL (EMPTY)" << endl )'
        ' else ( stdio << "VERDICT NOT-DECIDED-AT-THIS-DEGREE" << endl );',
        'stdio << "M2-DONE" << endl << flush;',
        'exit 0']) + '\n'


def m2d(tag, names, polys, dlim=8, timeout=1800):
    src = m2d_source(names, polys, tag, dlim)
    d = os.path.join(H.HERE, 'm2')
    os.makedirs(d, exist_ok=True)
    p = os.path.join(d, tag + '_d%d.m2' % dlim)
    open(p, 'w').write(src)
    t0 = time.time()
    try:
        r = subprocess.run([H.M2, '--script', p], capture_output=True,
                           text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return None, time.time() - t0, '<TIMEOUT>'
    dt = time.time() - t0
    out = r.stdout + r.stderr
    open(os.path.join(H.HERE, 'logs', tag + '_m2d%d.log' % dlim), 'w').write(out)
    if 'UNIT-IDEAL' in out:
        return True, dt, 'M2 degree-%d GB contains a constant' % dlim
    if 'NOT-DECIDED-AT-THIS-DEGREE' in out:
        return None, dt, 'no constant in the degree-%d GB' % dlim
    return None, dt, out.strip()[-300:]


def m2v(tag, names, polys, timeout=3600):
    src = m2v_source(names, polys, tag)
    d = os.path.join(H.HERE, 'm2')
    os.makedirs(d, exist_ok=True)
    p = os.path.join(d, tag + '_v.m2')
    open(p, 'w').write(src)
    t0 = time.time()
    try:
        r = subprocess.run([H.M2, '--script', p], capture_output=True,
                           text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return None, time.time() - t0, '<TIMEOUT>'
    dt = time.time() - t0
    out = r.stdout + r.stderr
    open(os.path.join(H.HERE, 'logs', tag + '_m2v.log'), 'w').write(out)
    if not out.strip():
        return None, dt, '<EMPTY M2 OUTPUT -- ERROR, NOT A VERDICT>'
    if 'UNIT-IDEAL' in out:
        return True, dt, 'M2v unit'
    if 'NON-UNIT' in out:
        return False, dt, out[out.find('VERDICT'):][:200]
    return None, dt, out.strip()[-300:]


def m2h_source(names, polys, sat, tag):
    """HOMOGENEOUS formulation over K = toField(QQ[om,kp]/(...)).

    The cone's landing equations are homogeneous cubics in the block
    parameters and the extra conditions X0 = Y1 = ... = 0 are linear, so the
    whole ideal is homogeneous -- but only if `om`, `kp` stay in the FIELD
    rather than becoming variables.  Then

        V(I) n { f != 0 } = empty     <=>     saturate(I, f) = (1) ,

    and a homogeneous Groebner computation is dramatically cheaper than the
    inhomogeneous one obtained by dehomogenising at B6.  `sat` names the
    parameters the licence lets us invert (B6, and Y0 on case N).

    NOTE on the list form `saturate(I, {f,g})`.  It must mean SUCCESSIVE
    saturation, i.e. I : (f*g)^inf -- removing V(f) u V(g) -- and NOT
    I : (f,g)^inf, which would only remove components inside the codimension-2
    locus V(f) n V(g) and would be the wrong statement here.  Checked
    empirically on a discriminating example (`m2/probe_sat2.m2`): for
    I = (a*b*c), `saturate(I,{a,b})` and `saturate(I,a*b)` both return
    ideal(c), whereas I : (a,b)^inf is I itself.
    """
    lines = []
    for q in polys:
        terms = []
        for k, v in sorted(q.items()):
            mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                           for i, e in enumerate(k) if e)
            terms.append('(%s)%s' % (L.kstr(v), '*' + mon if mon else ''))
        lines.append('+'.join(terms))
    return '\n'.join([
        'A = QQ[om,kp];',
        'K = toField(A/ideal(om^2+om+1, 8*kp^2-13*kp-4));',
        'R = K[%s];' % ','.join(names),
        'I = ideal(\n  %s\n);' % ',\n  '.join(lines),
        'stdio << "-- %s (homogeneous, saturate by %s)" << endl << flush;'
        % (tag, sat),
        'stdio << "HOMOGENEOUS " << (isHomogeneous I) << endl << flush;',
        'J = saturate(I, %s);' % sat,
        'u = (1_R % J);',
        'stdio << "ONE-IN-SAT " << (u == 0) << endl << flush;',
        'if u == 0 then ( stdio << "VERDICT UNIT-IDEAL (EMPTY)" << endl )'
        ' else ( stdio << "VERDICT NON-UNIT dim=" << dim J << endl );',
        'stdio << "M2-DONE" << endl << flush;',
        'exit 0']) + '\n'


def m2h(tag, names, polys, sat, timeout=3600):
    src = m2h_source(names, polys, sat, tag)
    d = os.path.join(H.HERE, 'm2')
    os.makedirs(d, exist_ok=True)
    p = os.path.join(d, tag + '_h.m2')
    open(p, 'w').write(src)
    t0 = time.time()
    try:
        r = subprocess.run([H.M2, '--script', p], capture_output=True,
                           text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return None, time.time() - t0, '<TIMEOUT>'
    dt = time.time() - t0
    out = r.stdout + r.stderr
    open(os.path.join(H.HERE, 'logs', tag + '_m2h.log'), 'w').write(out)
    if 'HOMOGENEOUS false' in out:
        return None, dt, '<INPUT NOT HOMOGENEOUS -- formulation error>'
    if 'UNIT-IDEAL' in out:
        return True, dt, 'M2 homogeneous saturation = (1)'
    if 'NON-UNIT' in out:
        return False, dt, out[out.find('VERDICT'):][:200]
    return None, dt, out.strip()[-300:]


# ---------------------------------------------------------------------- sympy
def sp(names, polys, timeout=None):
    t0 = time.time()
    try:
        unit, exprs = LF.sympy_verdict(names, polys)
    except Exception as e:
        return None, time.time() - t0, 'ERR:%s' % e
    return unit, time.time() - t0, 'sympy %d basis elements' % len(exprs)


# ------------------------------------------------------------------- controls
def selftest():
    """the parser and both char-0 engines, in BOTH directions."""
    ok = True
    unit_names = ['a', 'b']
    # V(a, a-1) = empty  -> unit ideal
    Iunit = [{(1, 0): ONE}, {(1, 0): ONE, (0, 0): L.kneg(ONE)}]
    # V(a^2-2, b-a) = 2 points -> NOT the unit ideal
    Inon = [{(2, 0): ONE, (0, 0): L.kscal(-2, ONE)},
            {(0, 1): ONE, (1, 0): L.kneg(ONE)}]
    for label, I, want in (('EMPTY-control', Iunit, True),
                           ('NONEMPTY-control', Inon, False)):
        v1, _, i1 = qq('ctrl_%s' % label, unit_names, I, timeout=300)
        v2, _, i2 = m2('ctrl_%s' % label, unit_names, I, timeout=300)
        v3, _, i3 = sp(unit_names, I)
        v4, _, i4 = ff('ctrl_%s' % label, unit_names, I, timeout=300)
        good = (v1 is want) and (v2 is want) and (v3 is want) and (v4 is want)
        ok = ok and good
        print('  %-18s want=%-5s qq=%-5s M2=%-5s sympy=%-5s ff=%-5s  %s'
              % (label, want, v1, v2, v3, v4, 'OK' if good else '*** FAIL'),
              flush=True)
    print('  parser self-test on the raw strings:', flush=True)
    for body, want in (('[1]', True), ('[-1]', True),
                       ('#header\n#more\n[b^2, a*b, a^2]', False),
                       ('#header\n[1]:', True)):
        got = H.is_unit_ideal(body)
        print('     %-32r -> %-5s (want %s) %s'
              % (body, got, want, 'OK' if got is want else '*** FAIL'),
              flush=True)
        ok = ok and (got is want)
    print('SELFTEST %s' % ('PASS' if ok else 'FAIL'), flush=True)
    return ok


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(0 if selftest() else 1)
    print(__doc__)
