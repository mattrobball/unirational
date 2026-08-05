#!/usr/bin/env python3
"""FIX-C1 -- run the jet ladder from a branch seed and locate the first
obstruction.  Exact, characteristic zero.

    python3 produce_c1.py m1 0      # the (1,7) Chebyshev seed, lam = 1
    python3 produce_c1.py m1 1      #                            lam = om
    python3 produce_c1.py m1 2      #                            lam = om^2
    python3 produce_c1.py control   # the (3,6) D_B seed  (T5 witness)

THE LADDER.  A germ of an A4-equivariant landing covariant along the V4 triple
line expands as T = sum_{n>=r} T_n in the (x,y,z)-adic filtration; the level-l
equation (the degree-(3r+l) part of F(T) = 0) is

    D_{p0}(e_l) := 3 Phi(p0,p0,e_l) = - R_l ,
    R_l = sum_{i+j=l, i,j>=1} 3 Phi(p0,e_i,e_j) + sum_{i+j+k=l} Phi(e_i,e_j,e_k)

with p0 = T_r the seed and e_l = T_{r+l}.  Since F(p0) = 0 exactly, R_1 = 0,
so level 1 is homogeneous: e_1 ranges over ker D_{p0} and the FIRST equation
with a nonzero right-hand side is level 2, whose obstruction is the quadratic
Kuranishi map

    Ob_2 : ker D_{p0}|_{V_{r+1}} --> coker D_{p0}|_{V_{r+2}} ,
    Ob_2(e_1) = [ 3 Phi(p0, e_1, e_1) ] .

Level 3 is then a cubic-plus-bilinear map of (e_1, e_2).

Output: payloads/LADDER_<tag>.json, .txt  and  logs/LADDER_<tag>.log
"""
import itertools
import json
import os
import sys
import time

import sympy as sp

import c1_lib as L
import c1_ladder as LD
import c1_points as PT
import c1_ring as CR
from c1_lib import x, y, z

HERE = os.path.dirname(os.path.abspath(__file__))
T0 = time.time()
LINES = []


def log(msg):
    s = '[%7.1fs] %s' % (time.time() - T0, msg)
    LINES.append(s)
    print(s, flush=True)


# ---------------------------------------------------------------------------
# the geometrically trivial deformation directions
# ---------------------------------------------------------------------------
def invariants(deg):
    """basis of the A4-invariant forms of degree `deg` in x,y,z."""
    par = (deg % 2,)*3
    out, seen = [], set()
    for A in range(deg + 1):
        for B in range(deg + 1 - A):
            C = deg - A - B
            if (A % 2, B % 2, C % 2) != par:
                continue
            mn = (A, B, C)
            if mn in seen:
                continue
            orb = {mn, (mn[2], mn[0], mn[1]), (mn[1], mn[2], mn[0])}
            seen |= orb
            out.append(sp.expand(sum(L.mono(o) for o in orb)))
    return out


def equivariant_fields(deg):
    """A4-equivariant vector fields (V_x, psi V_x, psi^2 V_x) of degree deg:
    V_x runs over the degree-deg monomials of V4-character chi_1."""
    out = []
    for A in range(deg + 1):
        for B in range(deg + 1 - A):
            C = deg - A - B
            if (A + C) % 2 == 1 and (B + C) % 2 == 0:
                vx = L.mono((A, B, C))
                vy = L.psi(vx)
                out.append((vx, vy, L.psi(vy)))
    return out


def trivial_directions(p0, level, rd):
    """G.p0 (G an invariant of degree `level`) and (V.grad)p0 (V equivariant
    of degree level+1).  Both reparametrise the source or rescale by an
    invariant function: the IMAGE of the germ is unchanged, so they are not
    deformations of the map."""
    out = []
    for G in invariants(level):
        out.append(('G=%s' % G, [L.red_poly(sp.expand(G*u), rd) for u in p0]))
    for V in equivariant_fields(level + 1):
        d = [L.red_poly(sp.expand(V[0]*sp.diff(u, x) + V[1]*sp.diff(u, y)
                                  + V[2]*sp.diff(u, z)), rd) for u in p0]
        out.append(('V=%s' % V[0], d))
    return out


# ---------------------------------------------------------------------------
def assemble_level(op, rhs_polys, Q, sign=1):
    """union the operator row set with the RHS monomial support (both
    psi-orbit reduced), pad the operator with zero rows, build RHS vectors.

    Rows outside the operator support are AUTOMATIC obstruction coordinates.
    """
    reps = list(op['rows'])
    assert reps == [LD.orbit_key(mn) for mn in reps]
    repset = set(reps)
    polydata = []
    for w in rhs_polys:
        vec = {}
        if w != 0:
            P = sp.Poly(w, x, y, z)
            for mono, cf in zip(P.monoms(), P.coeffs()):
                k = LD.orbit_key(tuple(mono))
                if k in vec:
                    assert sp.expand(vec[k] - cf) == 0, \
                        'RHS not psi-invariant at %s' % (k,)
                else:
                    vec[k] = cf
        polydata.append(vec)
        for k in vec:
            if k not in repset:
                repset.add(k)
                reps.append(k)
    idx = {mn: i for i, mn in enumerate(op['rows'])}
    ncols = len(op['names'])
    Mpad = [op['M'][idx[mn]] if mn in idx
            else [list(Q.zero) for _ in range(ncols)] for mn in reps]
    rhss = []
    for vec in polydata:
        v = [Q.from_expr(vec.get(mn, sp.Integer(0))) for mn in reps]
        rhss.append([Q.neg(e) for e in v] if sign < 0 else v)
    return reps, Mpad, rhss


def residual_report(Q, resid):
    nz = [(lbl, Q.to_expr(val)) for lbl, val in resid if not Q.is_zero(val)]
    return nz


# ---------------------------------------------------------------------------
def run(tag, seed, lam, m, r, rel, gens, degs, rd, pts_fn, primes, levels=3):
    Q = CR.Quo(rel, gens, degs, rd)
    out = {'tag': tag, 'lam': str(lam), 'm': m, 'r': r, 'ring_dim': Q.n,
           'levels': []}
    log('%s: ring dim_QQ R = %d' % (tag, Q.n))
    FT = L.red_poly(L.F_klein(seed), rd)
    rr, ordP, _ = L.orders(seed, rd)
    pm = L.sigma_split_orders(seed, rd)
    log('%s: SEED  F(T) = %s   r = %s   ord_P = %s   (ord T+, ord T-) = %s'
        % (tag, FT, rr, ordP, pm))
    assert FT == 0 and rr == r and min(ordP) == m
    assert L.check_equivariance(seed, lam, rd)
    assert pm[1] < pm[0] and pm[1] % 2 == 1, 'FIX-H0 H0-1 split violated'
    out['seed'] = {'F': 0, 'r': rr, 'ordP': list(ordP),
                   'ordTplus': pm[0], 'ordTminus': pm[1]}

    dfp = L.dF_at(seed)
    ddfp = L.ddF_at(seed)

    ops = {}
    for ell in range(1, levels + 1):
        n = r + ell
        names, E, syms, rows, M = LD.level_operator(dfp, n, m, lam, Q, rd,
                                                    'e%d' % ell)
        rows2, M2, _ = LD.psi_orbit_reduce(rows, M, Q, check=True)
        p = primes[0]
        hint, mrk, _ = CR.modular_pivot_rows(Q, M2, pts_fn(p)[0], p)
        ops[ell] = dict(names=names, E=E, syms=syms, rows=rows2, M=M2,
                        hint=hint, n=n)
        log('%s: level %d  dim V_%d = %d  target orbit-rows = %d  '
            '(modular rank guess %d)'
            % (tag, ell, n, len(names), len(rows2), mrk))

    # ---------------- LEVEL 1 --------------------------------------------
    o1 = ops[1]
    res1 = CR.analyze_R(Q, o1['M'], hint=o1['hint'], verbose=True)
    k1vecs = res1['kernel']
    for v in k1vecs:
        assert all(Q.is_zero(e) for e in CR.matvec_R(Q, o1['M'], v))
    k1 = [LD.tuple_from_vector(o1['E'], o1['syms'], v, Q, rd) for v in k1vecs]
    for kt in k1:
        assert L.red_poly(L.D_apply(dfp, kt), rd) == 0
    log('%s: LEVEL 1 exact:  rank %d / %d cols,  dim ker = %d,  '
        'dim coker = %d (of %d orbit-rows)'
        % (tag, res1['rank'], len(o1['names']), len(k1vecs),
           len(o1['rows']) - res1['rank'], len(o1['rows'])))

    triv = []
    for nm, d in trivial_directions(seed, 1, rd):
        if all(sp.expand(u) == 0 for u in d):
            continue
        try:
            v = LD.piece_coords(d, o1['names'], o1['E'], o1['syms'], Q, rd)
        except AssertionError as exc:
            log('%s:   trivial direction %s is NOT in V_%d (%s)'
                % (tag, nm, o1['n'], exc))
            continue
        assert all(Q.is_zero(e) for e in CR.matvec_R(Q, o1['M'], v)), \
            'trivial direction not in the kernel'
        triv.append((nm, v))
    dtriv = 0
    if triv:
        Mt = [[triv[k][1][i] for k in range(len(triv))]
              for i in range(len(o1['names']))]
        rt = CR.analyze_R(Q, Mt)
        dtriv = rt['rank']
    log('%s: LEVEL 1 kernel: %d-dimensional; trivial (reparametrisation / '
        'invariant-multiple) part %d-dimensional [%s]; ESSENTIAL directions %d'
        % (tag, len(k1vecs), dtriv, ', '.join(nm for nm, _ in triv),
           len(k1vecs) - dtriv))
    out['levels'].append(
        {'level': 1, 'n': o1['n'], 'dimV': len(o1['names']),
         'target_rows': len(o1['rows']), 'rank': res1['rank'],
         'ker': len(k1vecs), 'coker': len(o1['rows']) - res1['rank'],
         'trivial_ker': dtriv, 'essential_ker': len(k1vecs) - dtriv,
         'rhs': 'R_1 = 0 (the seed solves F = 0 exactly)', 'solvable': True})

    # ---------------- LEVEL 2 --------------------------------------------
    o2 = ops[2]
    pairs, W = [], []
    for i in range(len(k1)):
        for j in range(i, len(k1)):
            f = sp.Rational(1, 2) if i == j else sp.Integer(1)
            pairs.append((i, j))
            W.append(L.red_poly(f*L.H_apply(ddfp, k1[i], k1[j]), rd))
    rows2, M2pad, rhs2 = assemble_level(o2, W, Q, sign=-1)
    hint2 = [rows2.index(o2['rows'][i]) for i in o2['hint']]
    res2 = CR.analyze_R(Q, M2pad, rhss=rhs2, hint=hint2, verbose=True)
    log('%s: LEVEL 2 exact:  rank %d / %d cols,  dim ker = %d,  '
        'dim coker = %d (of %d orbit-rows, %d outside the operator support)'
        % (tag, res2['rank'], len(o2['names']), len(res2['kernel']),
           len(rows2) - res2['rank'], len(rows2),
           len(rows2) - len(o2['rows'])))
    ob2 = []
    for k, (i, j) in enumerate(pairs):
        nz = residual_report(Q, res2['residuals'][k])
        log('%s:   Ob_2 coefficient of t%d t%d : %s'
            % (tag, i, j, 'ZERO' if not nz
               else '%d NONZERO residual coordinate(s)' % len(nz)))
        if nz:
            ob2.append({'pair': [i, j],
                        'residual': [[str(lbl), str(val)] for lbl, val in nz]})
    out['levels'].append(
        {'level': 2, 'n': o2['n'], 'dimV': len(o2['names']),
         'target_rows': len(rows2), 'rank': res2['rank'],
         'ker': len(res2['kernel']),
         'coker': len(rows2) - res2['rank'],
         'rhs': 'R_2 = 3 Phi(p0,e_1,e_1),  e_1 in ker D (dim %d)' % len(k1),
         'obstruction': ob2, 'solvable': not ob2})
    if ob2:
        log('%s: FIRST OBSTRUCTION AT LEVEL 2 -- Ob_2 is not identically zero'
            % tag)
        out['verdict'] = 'OBSTRUCTED-AT-2'
        return Q, out
    log('%s: level 2 is UNOBSTRUCTED for every e_1 in ker D' % tag)

    # solutions e_2^{(ij)} and the level-2 kernel
    E2 = [LD.tuple_from_vector(o2['E'], o2['syms'], v, Q, rd)
          for v in res2['solutions']]
    for k, (i, j) in enumerate(pairs):
        chk = L.red_poly(L.D_apply(dfp, E2[k])
                         + (sp.Rational(1, 2) if i == j else 1)
                         * L.H_apply(ddfp, k1[i], k1[j]), rd)
        assert chk == 0, 'level-2 solution does not verify'
    K2 = [LD.tuple_from_vector(o2['E'], o2['syms'], v, Q, rd)
          for v in res2['kernel']]

    # ---------------- LEVEL 3 --------------------------------------------
    o3 = ops[3]
    terms = {}

    def addterm(key, poly):
        key = tuple(sorted(key))
        terms[key] = sp.expand(terms.get(key, sp.Integer(0)) + poly)

    for a in range(len(k1)):
        for k, (i, j) in enumerate(pairs):
            addterm((('t', a), ('t', i), ('t', j)),
                    L.H_apply(ddfp, k1[a], E2[k]))
    for a in range(len(k1)):
        for l in range(len(K2)):
            addterm((('t', a), ('s', l)), L.H_apply(ddfp, k1[a], K2[l]))
    for a in range(len(k1)):
        for b in range(a, len(k1)):
            for cc in range(b, len(k1)):
                mult = 6 if len({a, b, cc}) == 3 else (
                    1 if a == b == cc else 3)
                addterm((('t', a), ('t', b), ('t', cc)),
                        mult*L.Phi_fast(k1[a], k1[b], k1[cc]))
    keys = sorted(terms)
    W3 = [L.red_poly(terms[k], rd) for k in keys]
    rows3, M3pad, rhs3 = assemble_level(o3, W3, Q, sign=-1)
    hint3 = [rows3.index(o3['rows'][i]) for i in o3['hint']]
    res3 = CR.analyze_R(Q, M3pad, rhss=rhs3, hint=hint3, verbose=True)
    log('%s: LEVEL 3 exact:  rank %d / %d cols,  dim ker = %d,  '
        'dim coker = %d (of %d orbit-rows, %d outside the operator support)'
        % (tag, res3['rank'], len(o3['names']), len(res3['kernel']),
           len(rows3) - res3['rank'], len(rows3),
           len(rows3) - len(o3['rows'])))
    ob3 = []
    for k, key in enumerate(keys):
        nz = residual_report(Q, res3['residuals'][k])
        lbl = '*'.join('%s%d' % (a, b) for a, b in key)
        log('%s:   Ob_3 coefficient of %-12s : %s'
            % (tag, lbl, 'ZERO' if not nz
               else '%d NONZERO residual coordinate(s)' % len(nz)))
        if nz:
            ob3.append({'monomial': lbl,
                        'residual': [[str(a), str(b)] for a, b in nz]})
    out['levels'].append(
        {'level': 3, 'n': o3['n'], 'dimV': len(o3['names']),
         'target_rows': len(rows3), 'rank': res3['rank'],
         'ker': len(res3['kernel']),
         'coker': len(rows3) - res3['rank'],
         'rhs': 'R_3 = 6 Phi(p0,e_1,e_2) + Phi(e_1,e_1,e_1)',
         'obstruction': ob3, 'solvable': not ob3})
    if ob3:
        log('%s: FIRST OBSTRUCTION AT LEVEL 3' % tag)
        out['verdict'] = 'OBSTRUCTED-AT-3'
    else:
        log('%s: level 3 is UNOBSTRUCTED for every (e_1, e_2)' % tag)
        out['verdict'] = 'EXTENDS-THROUGH-3'
    return Q, out


def main():
    which = sys.argv[1]
    if which == 'm1':
        j = int(sys.argv[2])
        part = sys.argv[3] if len(sys.argv) > 3 else None
        if part:
            names, T, lam, rel, degs, rd = L.seed_m1_split(j, part)
            tag = 'm1_lam%d_%s' % (j, part)
            Q, out = run(tag, T, lam, 1, 7, rel, L.GENS, degs, rd,
                         lambda p: PT.points_m1_split(j, part, p),
                         [1021, 1039, 1123])
            out['part'] = part
        else:
            names, T, lam, rel, rd = L.seed_m1(j)
            tag = 'm1_lam%d' % j
            Q, out = run(tag, T, lam, 1, 7, rel, L.GENS, (3, 3, 2, 2), rd,
                         lambda p: PT.points_m1(j, p), [1021, 1039, 1123])
    else:
        T, lam, rel, rd = L.seed_control()
        tag = 'control_m3r6'
        Q, out = run(tag, T, lam, 3, 6, rel, L.GENS_B, (6, 2, 2), rd,
                     PT.points_control, [1021, 1039, 1123])
    with open(os.path.join(HERE, 'payloads', 'LADDER_%s.json' % tag),
              'w') as fh:
        json.dump(out, fh, indent=1)
    with open(os.path.join(HERE, 'payloads', 'LADDER_%s.txt' % tag),
              'w') as fh:
        fh.write('\n'.join(LINES) + '\n')
    log('verdict: FIX-C1-LADDER-%s' % out.get('verdict', 'INCOMPLETE'))


if __name__ == '__main__':
    main()
