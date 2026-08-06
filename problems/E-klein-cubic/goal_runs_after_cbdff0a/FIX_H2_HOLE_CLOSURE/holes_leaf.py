#!/usr/bin/env python3
"""FIX-H1: decide a leaf system in CHARACTERISTIC ZERO, by two independent
engines.

  (i)  sympy Groebner over QQ, with om, kp adjoined as VARIABLES and their
       minimal polynomials om^2+om+1 and 8kp^2-13kp-4 added to the ideal.
       Both minimal polynomials are irreducible over QQ, so Gal(Qbar/QQ) acts
       transitively on their roots; hence the ideal is the unit ideal iff the
       system has no solution for ANY (equivalently, for the packet's) choice
       of (om, kp).  `groebner(...) == [1]`  is then a char-0 emptiness proof.

  (ii) Macaulay2 over the exact degree-4 number field
       K = toField(QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4)):  `1 % I == 0`.

A leaf is EMPTY only when BOTH agree.  If either says non-unit, the leaf is a
candidate for a witness and is reported for explicit solving.
"""
import os
import subprocess
import sys

import sympy as sp

import holes_lib as H
import n2b_lib as L

OM, KP = sp.symbols('om kp')
MINPOLYS = [OM**2 + OM + 1, 8*KP**2 - 13*KP - 4]


def to_sympy(names, polys):
    vs = [sp.Symbol(n) for n in names]
    out = []
    for q in polys:
        e = sp.Integer(0)
        for k, c in q.items():
            coef = (sp.Rational(c[0]) + sp.Rational(c[1])*OM
                    + sp.Rational(c[2])*KP + sp.Rational(c[3])*OM*KP)
            m = sp.Integer(1)
            for i, ex in enumerate(k):
                if ex:
                    m *= vs[i]**ex
            e += coef*m
        out.append(sp.expand(e))
    return vs, out


def sympy_verdict(names, polys, timeout_note=''):
    vs, eqs = to_sympy(names, polys)
    gens = list(vs) + [OM, KP]
    G = sp.groebner(eqs + MINPOLYS, *gens, order='grevlex')
    exprs = list(G.exprs)
    unit = (len(exprs) == 1 and exprs[0] == 1)
    return unit, exprs


def m2_source(names, polys, tag):
    lines = []
    for q in polys:
        terms = []
        for k, v in sorted(q.items()):
            mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                           for i, e in enumerate(k) if e)
            terms.append('(%s)%s' % (L.kstr(v), '*' + mon if mon else ''))
        lines.append('+'.join(terms))
    hdr = ['A = QQ[om,kp];',
           'K = toField(A/ideal(om^2+om+1, 8*kp^2-13*kp-4));',
           'R = K[%s];' % ','.join(names) if names else 'R = K[dummy];',
           'I = ideal(\n  %s\n);' % ',\n  '.join(lines)]
    body = ['stdio << "-- %s" << endl << flush;' % tag,
            'G = gens gb I;',
            'u = (1_R % I);',
            'stdio << "ONE-IN-I " << (u == 0) << endl << flush;',
            'if u == 0 then ( stdio << "VERDICT UNIT-IDEAL (EMPTY)" << endl )'
            ' else ( stdio << "VERDICT NON-UNIT dim=" << dim I'
            ' << " degree=" << degree I << endl; stdio << "GB "'
            ' << toString G << endl );',
            'stdio << "M2-DONE" << endl << flush;',
            'exit 0']
    return '\n'.join(hdr + body) + '\n'


def m2_verdict(names, polys, tag, timeout=900):
    src = m2_source(names, polys, tag)
    d = os.path.join(H.HERE, 'm2')
    os.makedirs(d, exist_ok=True)
    p = os.path.join(d, tag + '.m2')
    open(p, 'w').write(src)
    try:
        r = subprocess.run([H.M2, '--script', p], capture_output=True,
                           text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return None, '<TIMEOUT>'
    out = r.stdout + r.stderr
    log = os.path.join(H.HERE, 'logs', tag + '.log')
    open(log, 'w').write(out)
    if 'UNIT-IDEAL' in out:
        return True, out.strip()
    if 'NON-UNIT' in out:
        return False, out.strip()
    return None, out.strip()
