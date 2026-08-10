"""Producer for the target-side fixed-locus ledger  X^H,  H <= G = PSL(2,11).

Exact characteristic-zero computation in K = Q(zeta_165).  Writes
results/ledger_exact.json.

Method (one uniform rule, no case analysis in the definition):

    P(W)^H  =  | |_chi  P(W_chi),      W_chi = { v : h.v = chi(h) v for all h in H },

the union over the *one-dimensional* characters chi of H, because [v] is
H-fixed iff  K.v  is an H-stable line.  Then

    X^H = X cap P(W)^H = | |_chi  { F|_{W_chi} = 0 } .

For dim W_chi = 1 this is a single exact evaluation of F; for dim 2 a binary
cubic; for dim 3 a ternary cubic; for dim 5 (H = 1) it is X itself.
"""
import json
import os
import sys
import time
from fractions import Fraction as Q

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import klein_core as kc
from klein_core import (ZERO, ONE, k_add, k_sub, k_mul, k_neg, k_inv, k_scal,
                        k_is_zero, k_eq, k_from_int, root_of_unity)

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(os.path.dirname(HERE), 'results')
CHECKS = []


def check(name, cond, detail=''):
    CHECKS.append((name, bool(cond), detail))
    print(('CHECK PASS  ' if cond else 'CHECK FAIL  ') + name + (('  ' + detail) if detail else ''),
          flush=True)
    return bool(cond)


# ---------------------------------------------------------------- characters
def linear_characters(GT, H):
    """all one-dimensional characters of H, as dicts  element index -> K-value."""
    Hl = sorted(H)
    # derived subgroup
    comms = []
    for a in Hl:
        for b in Hl:
            comms.append(GT.mul[GT.mul[GT.inv[a]][GT.inv[b]]][GT.mul[a][b]])
    D = GT.gen(sorted(set(comms))) if comms else frozenset({GT.one})
    D = frozenset(x for x in D)
    assert D <= H
    # cosets of D in H
    cosets = {}
    rep_of = {}
    for h in Hl:
        key = frozenset(GT.mul[h][d] for d in D)
        if key not in cosets:
            cosets[key] = len(cosets)
        rep_of[h] = cosets[key]
    m = len(cosets)
    keylist = [None] * m
    for key, i in cosets.items():
        keylist[i] = key
    crep = [min(keylist[i]) for i in range(m)]
    cmul = [[rep_of[GT.mul[crep[i]][crep[j]]] for j in range(m)] for i in range(m)]
    cone = rep_of[GT.one]
    corder = []
    for i in range(m):
        n, x = 1, i
        while x != cone:
            x = cmul[x][i]
            n += 1
        corder.append(n)
    # greedy independent generators
    gens = []
    gen_sub = {cone}

    def span(gs):
        S = {cone}
        fr = [cone]
        while fr:
            nf = []
            for x in fr:
                for g in gs:
                    y = cmul[x][g]
                    if y not in S:
                        S.add(y)
                        nf.append(y)
            fr = nf
        return S

    while len(gen_sub) < m:
        best = max((i for i in range(m) if i not in gen_sub), key=lambda i: corder[i])
        gens.append(best)
        gen_sub = span(gens)
    # word for each coset
    word = {cone: tuple([0] * len(gens))}
    fr = [cone]
    while fr:
        nf = []
        for x in fr:
            for gi, g in enumerate(gens):
                y = cmul[x][g]
                if y not in word:
                    w = list(word[x])
                    w[gi] += 1
                    word[y] = tuple(w)
                    nf.append(y)
        fr = nf
    assert len(word) == m
    # candidate characters
    out = []
    seen = set()
    import itertools
    for ks in itertools.product(*[range(corder[g]) for g in gens]):
        vals = []
        for i in range(m):
            v = ONE
            for gi, g in enumerate(gens):
                e = (ks[gi] * word[i][gi]) % corder[g]
                if e:
                    v = k_mul(v, root_of_unity(corder[g], e))
            vals.append(v)
        ok = all(k_eq(vals[cmul[i][j]], k_mul(vals[i], vals[j]))
                 for i in range(m) for j in range(m))
        if not ok:
            continue
        key = tuple(vals)
        if key in seen:
            continue
        seen.add(key)
        out.append({h: vals[rep_of[h]] for h in Hl})
    assert len(out) == m, (len(out), m)
    return out, m, len(D)


def char_space(rho, H_gens, chi):
    """basis of W_chi = intersection of ker(rho(h) - chi(h) I) over generators h."""
    rows = []
    for h in H_gens:
        M = rho[h]
        c = chi[h]
        for i in range(5):
            rows.append([k_sub(M[i][j], c) if i == j else M[i][j] for j in range(5)])
    return kc.kernel(rows, 5)


# ---------------------------------------------------------------- utilities
def bin_cubic_coeffs(basis):
    """F(s*u + t*v) = c3 s^3 + c2 s^2 t + c1 s t^2 + c0 t^3."""
    d = kc.F_restrict(basis)
    return [d.get((3, 0), ZERO), d.get((2, 1), ZERO), d.get((1, 2), ZERO), d.get((0, 3), ZERO)]


def bin_cubic_disc(c):
    a, b, cc, dd = c
    t1 = k_scal(k_mul(k_mul(a, b), k_mul(cc, dd)), 18)
    t2 = k_scal(k_mul(k_mul(k_mul(b, b), b), dd), -4)
    t3 = k_mul(k_mul(b, b), k_mul(cc, cc))
    t4 = k_scal(k_mul(a, k_mul(cc, k_mul(cc, cc))), -4)
    t5 = k_scal(k_mul(k_mul(a, a), k_mul(dd, dd)), -27)
    return k_add(k_add(k_add(k_add(t1, t2), t3), t4), t5)


def rank_ff(rows):
    """rank by division-free (fraction-free) Gaussian elimination."""
    rows = [list(r) for r in rows]
    if not rows:
        return 0
    n = len(rows[0])
    r = 0
    for c in range(n):
        p = None
        for i in range(r, len(rows)):
            if not k_is_zero(rows[i][c]):
                p = i
                break
        if p is None:
            continue
        rows[r], rows[p] = rows[p], rows[r]
        pv = rows[r][c]
        for i in range(r + 1, len(rows)):
            if not k_is_zero(rows[i][c]):
                f = rows[i][c]
                rows[i] = [k_sub(k_mul(pv, x), k_mul(f, y))
                           for x, y in zip(rows[i], rows[r])]
        r += 1
        if r == len(rows):
            break
    return r


def in_span(v, basis):
    """is v in the span of basis?  (basis of a subspace of K^5)"""
    d = rank_ff([list(b) for b in basis])
    return rank_ff([list(b) for b in basis] + [list(v)]) == d


def rank(rows):
    rows = [list(r) for r in rows]
    r = 0
    n = len(rows[0]) if rows else 0
    for c in range(n):
        p = None
        for i in range(r, len(rows)):
            if not k_is_zero(rows[i][c]):
                p = i
                break
        if p is None:
            continue
        rows[r], rows[p] = rows[p], rows[r]
        iv = k_inv(rows[r][c])
        rows[r] = [k_mul(x, iv) for x in rows[r]]
        for i in range(len(rows)):
            if i != r and not k_is_zero(rows[i][c]):
                f = rows[i][c]
                rows[i] = [k_sub(x, k_mul(f, y)) for x, y in zip(rows[i], rows[r])]
        r += 1
    return r


def coords_in_basis(v, basis):
    """coordinates of v w.r.t. `basis` (assumed independent, v in span)."""
    d = len(basis)
    rows = [[basis[j][i] for j in range(d)] + [v[i]] for i in range(5)]
    # gaussian elimination
    piv = []
    r = 0
    for c in range(d):
        p = None
        for i in range(r, 5):
            if not k_is_zero(rows[i][c]):
                p = i
                break
        if p is None:
            continue
        rows[r], rows[p] = rows[p], rows[r]
        iv = k_inv(rows[r][c])
        rows[r] = [k_mul(x, iv) for x in rows[r]]
        for i in range(5):
            if i != r and not k_is_zero(rows[i][c]):
                f = rows[i][c]
                rows[i] = [k_sub(x, k_mul(f, y)) for x, y in zip(rows[i], rows[r])]
        piv.append(c)
        r += 1
    out = [ZERO] * d
    for i, c in enumerate(piv):
        out[c] = rows[i][d]
    return out


def proj_eq(u, v):
    """do u, v span the same line?"""
    for i in range(5):
        for j in range(i + 1, 5):
            if not k_is_zero(k_sub(k_mul(u[i], v[j]), k_mul(u[j], v[i]))):
                return False
    return not (all(k_is_zero(x) for x in u) or all(k_is_zero(x) for x in v))


def apply_mat(M, v):
    out = []
    for i in range(5):
        s = ZERO
        for j in range(5):
            if not k_is_zero(M[i][j]) and not k_is_zero(v[j]):
                s = k_add(s, k_mul(M[i][j], v[j]))
        out.append(s)
    return out


def stab_point(GT, rho, v):
    return frozenset(g for g in range(660) if proj_eq(v, apply_mat(rho[g], v)))


def k_to_str(a):
    """compact printable form: list of the 80 rationals, trailing zeros trimmed."""
    s = [str(x) for x in a]
    while s and s[-1] == '0':
        s.pop()
    return s


def k_is_rational(a):
    return all(x == 0 for x in a[1:])


def k_rat(a):
    assert k_is_rational(a), 'not rational'
    return a[0]


# ---------------------------------------------------------------- main
def main():
    t0 = time.time()
    GT = kc.GroupTable()
    order, idx, rho_by_pos = kc.build_group()
    # reindex rho to GT's indexing
    rho = [None] * 660
    for pos, e in enumerate(order):
        rho[GT.index[e]] = rho_by_pos[pos]
    check('group_660_elements', len(order) == 660)
    check('element_order_profile',
          sorted([GT.ordr.count(k) for k in (1, 2, 3, 5, 6, 11)]) == sorted([1, 55, 110, 264, 110, 120]),
          str({k: GT.ordr.count(k) for k in (1, 2, 3, 5, 6, 11)}))
    # F is G-invariant
    for g in (GT.index[kc.FS], GT.index[kc.FT]):
        M = rho[g]
        d = kc.F_restrict([[M[j][i] for j in range(5)] for i in range(5)])
        base = {tuple(e): ONE for e in kc.FMON}
        same = (set(d) == set(base)) and all(k_eq(d[e], ONE) for e in d)
        check('F_invariant_under_generator_%d' % g, same)

    classes = GT.subgroup_classes()
    check('subgroup_conjugacy_classes_16', len(classes) == 16, 'got %d' % len(classes))
    check('total_subgroups_620', sum(c[1] for c in classes) == 620,
          'got %d' % sum(c[1] for c in classes))

    # distinct labels (two S3 classes, two A5 classes)
    raw = [GT.name(H) for H, _, _, _ in classes]
    labels = []
    from collections import Counter
    cnt = Counter(raw)
    used = Counter()
    for nm in raw:
        if cnt[nm] > 1:
            used[nm] += 1
            labels.append('%s(%s)' % (nm, 'ab'[used[nm] - 1]))
        else:
            labels.append(nm)

    ledger = []
    for li, (H, nconj, orb, gens) in enumerate(classes):
        name = GT.name(H)
        N = GT.normalizer(H)
        C = GT.centralizer(H)
        chis, nchi, dder = linear_characters(GT, H)
        Hg = gens if gens else [GT.one]
        strata = []
        for ci, chi in enumerate(chis):
            B = char_space(rho, Hg, chi)
            if not B:
                continue
            strata.append({'chi': ci, 'dim': len(B), 'basis': B,
                           'values': {h: chi[h] for h in sorted(H)}})
        ledger.append({'H': H, 'name': name, 'label': labels[li],
                       'order': len(H), 'nconj': nconj,
                       'N': N, 'C': C, 'Nname': GT.name(N), 'Cname': GT.name(C),
                       'gens': Hg, 'strata': strata, 'nchi': nchi})
    print('--- ambient strata built  %.1fs' % (time.time() - t0), flush=True)

    # --------------------------------------------------------- per-row X^H
    out_rows = []
    for row in ledger:
        name, H = row['name'], row['H']
        comps = []
        for st in row['strata']:
            d, B = st['dim'], st['basis']
            rec = {'chi': st['chi'], 'dim_W_chi': d}
            if d == 1:
                v = B[0]
                fv = kc.F_eval(v)
                rec['type'] = 'point'
                rec['F_value_zero'] = k_is_zero(fv)
                rec['F_value'] = k_to_str(fv)
                rec['F_rational'] = k_is_rational(fv)
                if k_is_rational(fv):
                    rec['F_value_Q'] = str(k_rat(fv))
                rec['vector'] = [k_to_str(x) for x in v]
                rec['on_X'] = k_is_zero(fv)
                if k_is_zero(fv):
                    rec['X_points'] = 1
                else:
                    rec['X_points'] = 0
            elif d == 2:
                c = bin_cubic_coeffs(B)
                allz = all(k_is_zero(x) for x in c)
                rec['type'] = 'line'
                rec['F_identically_zero'] = allz
                if allz:
                    rec['X_component'] = 'line P^1 contained in X'
                    rec['X_points'] = 'infinite'
                else:
                    dsc = bin_cubic_disc(c)
                    rec['disc_zero'] = k_is_zero(dsc)
                    rec['X_points'] = 3 if not k_is_zero(dsc) else '<3 (non-reduced)'
                    rec['X_reduced'] = not k_is_zero(dsc)
                rec['cubic_coeffs_zero'] = [k_is_zero(x) for x in c]
            elif d == 3:
                dd = kc.F_restrict(B)
                rec['type'] = 'plane'
                rec['F_identically_zero'] = len(dd) == 0
                rec['n_monomials'] = len(dd)
            else:
                rec['type'] = 'P^%d' % (d - 1)
                rec['X_component'] = 'X itself' if d == 5 else '?'
            comps.append(rec)
        row['components'] = comps
        out_rows.append(row)

    # ------------------------------------------------- detailed special rows
    detail = {}

    # ---- C2 : plus-plane cubic (j-invariant via Hesse form) and minus-line
    c2 = [r for r in ledger if r['name'] == 'C2'][0]
    plus = [s for s in c2['strata'] if s['dim'] == 3][0]
    minus = [s for s in c2['strata'] if s['dim'] == 2][0]
    cminus = bin_cubic_coeffs(minus['basis'])
    check('C2_minus_line_inside_X', all(k_is_zero(x) for x in cminus))
    # residual C3 inside N_G(C2) = D12
    D12 = c2['N']
    c3elt = [g for g in D12 if GT.ordr[g] == 3][0]
    M3 = rho[c3elt]
    Pb = plus['basis']
    # matrix of the C3 action on the plus-plane, in the basis Pb
    A3 = [coords_in_basis(apply_mat(M3, b), Pb) for b in Pb]  # rows = images
    # eigenvectors of A3^T for eigenvalues 1, w, w^2
    w = root_of_unity(3)
    hesse_basis = []
    hesse_eigs = []
    for e in range(3):
        lam = root_of_unity(3, e)
        rows = [[k_sub(A3[j][i], lam) if i == j else A3[j][i] for j in range(3)] for i in range(3)]
        ker = kc.kernel(rows, 3)
        assert len(ker) == 1, (e, len(ker))
        coef = ker[0]
        vec = [ZERO] * 5
        for t in range(3):
            for i in range(5):
                vec[i] = k_add(vec[i], k_mul(coef[t], Pb[t][i]))
        hesse_basis.append(vec)
        hesse_eigs.append(e)
    dd = kc.F_restrict(hesse_basis)
    keys = sorted(dd)
    check('C2_plus_plane_Hesse_shape', set(keys) == {(3, 0, 0), (0, 3, 0), (0, 0, 3), (1, 1, 1)},
          str(keys))
    a_, b_, c_, d_ = dd[(3, 0, 0)], dd[(0, 3, 0)], dd[(0, 0, 3)], dd[(1, 1, 1)]
    tt = k_mul(k_neg(k_mul(k_mul(d_, d_), d_)),
               k_inv(k_scal(k_mul(k_mul(a_, b_), c_), 27)))
    check('C2_hesse_parameter_rational', k_is_rational(tt), str(k_to_str(tt)))
    tq = k_rat(tt)
    check('C2_hesse_parameter_is_-16/11', tq == Q(-16, 11), str(tq))
    jj = Q(27) * tq * (tq + 8) ** 3 / (tq - 1) ** 3
    check('C2_j_invariant_8192_over_11', jj == Q(8192, 11), str(jj))
    # Hesse cubic a u^3 + b v^3 + c w^3 + d uvw is singular iff t = -d^3/(27abc) = 1
    check('C2_plus_plane_cubic_smooth_since_t_ne_1', tq != 1, 't = %s' % tq)
    check('C2_j_not_an_algebraic_integer_so_E_sigma_has_no_CM', jj.denominator == 11)
    detail['C2'] = {'hesse_abcd_zero': [k_is_zero(a_), k_is_zero(b_), k_is_zero(c_), k_is_zero(d_)],
                    'hesse_t': str(tq), 'j': str(jj),
                    'minus_line_in_X': all(k_is_zero(x) for x in cminus)}
    # the three C3-eigenpoints of the plus-plane, and whether they are on X
    hp = []
    for e in range(3):
        v = hesse_basis[e]
        fv = kc.F_eval(v)
        stb = stab_point(GT, rho, v)
        hp.append({'c3_eigenvalue': 'w^%d' % e, 'on_X': k_is_zero(fv),
                   'stab_order': len(stb), 'stab_name': GT.name(stb)})
    detail['C2']['plus_plane_C3_eigenpoints'] = hp

    # ---- C3 row in full
    c3 = [r for r in ledger if r['name'] == 'C3'][0]
    pt3 = [s for s in c3['strata'] if s['dim'] == 1]
    ln3 = [s for s in c3['strata'] if s['dim'] == 2]
    check('C3_ambient_shape_pt_plus_two_lines', len(pt3) == 1 and len(ln3) == 2,
          'pts %d lines %d' % (len(pt3), len(ln3)))
    v0 = pt3[0]['basis'][0]
    f0 = kc.F_eval(v0)
    st0 = stab_point(GT, rho, v0)
    check('C3_isolated_point_stabiliser_is_D12', len(st0) == 12 and GT.name(st0) == 'D12',
          '%s order %d' % (GT.name(st0), len(st0)))
    check('C3_isolated_point_OFF_X', not k_is_zero(f0), 'F = ' + ','.join(k_to_str(f0)))
    detail['C3'] = {'isolated_point_F': k_to_str(f0),
                    'isolated_point_F_rational': k_is_rational(f0),
                    'isolated_point_stab': GT.name(st0),
                    'isolated_point_on_X': k_is_zero(f0)}
    if k_is_rational(f0):
        detail['C3']['isolated_point_F_Q'] = str(k_rat(f0))
    # the two eigenlines
    C6 = c3['C']
    lines = []
    for st in ln3:
        B = st['basis']
        c = bin_cubic_coeffs(B)
        dsc = bin_cubic_disc(c)
        # special points on this line: the C6-eigenpoints lying in it
        c6gen = [g for g in C6 if GT.ordr[g] == 6][0]
        A2 = [coords_in_basis(apply_mat(rho[c6gen], b), B) for b in B]
        specials = []
        for lamv, lname in [(root_of_unity(6, e), 'zeta6^%d' % e) for e in range(6)]:
            rows = [[k_sub(A2[j][i], lamv) if i == j else A2[j][i] for j in range(2)]
                    for i in range(2)]
            ker = kc.kernel(rows, 2)
            if len(ker) != 1:
                continue
            coef = ker[0]
            vec = [k_add(k_mul(coef[0], B[0][i]), k_mul(coef[1], B[1][i])) for i in range(5)]
            fv = kc.F_eval(vec)
            stb = stab_point(GT, rho, vec)
            specials.append({'eig': lname, 'on_X': k_is_zero(fv),
                             'stab': GT.name(stb), 'stab_order': len(stb)})
        lines.append({'F_identically_zero': all(k_is_zero(x) for x in c),
                      'disc_nonzero': not k_is_zero(dsc),
                      'X_points': 3,
                      'C6_eigenpoints_on_the_line': specials})
    detail['C3']['eigenlines'] = lines
    check('C3_each_eigenline_meets_X_in_3_reduced_points',
          all(l['disc_nonzero'] and not l['F_identically_zero'] for l in lines))
    check('C3_each_eigenline_carries_exactly_one_C6_point_of_X',
          all(sum(1 for s in l['C6_eigenpoints_on_the_line'] if s['on_X']) == 1
              for l in lines))
    # every element of N_G(C3) outside C_G(C3)=C6 inverts C3, hence swaps the eigenlines
    c3gen = [g for g in c3['H'] if g != GT.one][0]
    c3inv = GT.inv[c3gen]
    outside = [g for g in c3['N'] if g not in c3['C']]
    check('N_C3_outside_C6_inverts_C3_and_swaps_the_two_eigenlines',
          len(outside) == 6 and all(GT.conj(frozenset([c3gen]), g) == frozenset([c3inv])
                                    for g in outside))

    # ---- C5 row : five eigenpoints, F values
    c5 = [r for r in ledger if r['name'] == 'C5'][0]
    pts5 = []
    for st in c5['strata']:
        v = st['basis'][0]
        fv = kc.F_eval(v)
        stb = stab_point(GT, rho, v)
        pts5.append({'on_X': k_is_zero(fv), 'F': k_to_str(fv),
                     'F_rational': k_is_rational(fv),
                     'stab': GT.name(stb), 'stab_order': len(stb)})
    detail['C5'] = {'points': pts5}
    check('C5_five_eigenpoints', len(pts5) == 5)
    check('C5_four_on_X_one_off', sum(1 for p in pts5 if p['on_X']) == 4)

    # ---- C11 row
    c11 = [r for r in ledger if r['name'] == 'C11'][0]
    pts11 = []
    for st in c11['strata']:
        v = st['basis'][0]
        fv = kc.F_eval(v)
        stb = stab_point(GT, rho, v)
        pts11.append({'on_X': k_is_zero(fv), 'stab': GT.name(stb), 'stab_order': len(stb)})
    detail['C11'] = {'points': pts11}
    check('C11_five_eigenpoints_all_on_X',
          len(pts11) == 5 and all(p['on_X'] for p in pts11))

    # ---- V4 row
    v4 = [r for r in ledger if r['name'] == 'V4'][0]
    lv = [s for s in v4['strata'] if s['dim'] == 2]
    pv = [s for s in v4['strata'] if s['dim'] == 1]
    check('V4_ambient_line_plus_three_points', len(lv) == 1 and len(pv) == 3)
    cV = bin_cubic_coeffs(lv[0]['basis'])
    dV = bin_cubic_disc(cV)
    check('V4_line_not_in_X_and_reduced',
          (not all(k_is_zero(x) for x in cV)) and not k_is_zero(dV))
    typeI = []
    for st in pv:
        v = st['basis'][0]
        fv = kc.F_eval(v)
        stb = stab_point(GT, rho, v)
        typeI.append({'on_X': k_is_zero(fv), 'stab': GT.name(stb), 'stab_order': len(stb)})
    check('V4_three_type_I_points_on_X', all(p['on_X'] for p in typeI))
    detail['V4'] = {'type_I': typeI, 'line_disc_nonzero': not k_is_zero(dV),
                    'type_II_count': 3}

    # ---- C6 row
    c6r = [r for r in ledger if r['name'] == 'C6'][0]
    pts6 = []
    for st in c6r['strata']:
        v = st['basis'][0]
        fv = kc.F_eval(v)
        stb = stab_point(GT, rho, v)
        pts6.append({'on_X': k_is_zero(fv), 'stab': GT.name(stb), 'stab_order': len(stb)})
    detail['C6'] = {'points': pts6}
    check('C6_five_eigenpoints', len(pts6) == 5)
    check('C6_two_on_X', sum(1 for p in pts6 if p['on_X']) == 2)

    # ---- S3 (both classes), D10, D12, A4
    for nm in ('S3', 'D10', 'D12', 'A4'):
        rs = [r for r in ledger if r['name'] == nm]
        info = []
        for r in rs:
            pts = []
            for st in r['strata']:
                assert st['dim'] == 1, (nm, st['dim'])
                v = st['basis'][0]
                fv = kc.F_eval(v)
                stb = stab_point(GT, rho, v)
                pts.append({'on_X': k_is_zero(fv), 'stab': GT.name(stb),
                            'stab_order': len(stb)})
            info.append({'n_points': len(r['strata']), 'points': pts})
        detail[nm] = info
        check('%s_no_fixed_point_on_X' % nm, all(not p['on_X'] for i in info for p in i['points']),
              str([[p['on_X'] for p in i['points']] for i in info]))

    for nm in ('C11:C5', 'A5', 'PSL(2,11)'):
        rs = [r for r in ledger if r['name'] == nm]
        check('%s_ambient_fixed_locus_empty' % nm,
              all(len(r['strata']) == 0 for r in rs),
              str([len(r['strata']) for r in rs]))

    # ------------------------------------------------- stabilisers of the strata
    def setwise_stab(basis):
        d = len(basis)
        out = []
        for g in range(660):
            if all(rank_ff([list(b) for b in basis] + [apply_mat(rho[g], b)]) == d
                   for b in basis):
                out.append(g)
        return frozenset(out)

    def pointwise_stab(basis):
        """{g : rho(g) acts as a scalar on span(basis)} = pointwise stabiliser of P(span)."""
        d = len(basis)
        probe = list(basis)
        s = [ZERO] * 5
        for b in basis:
            s = [k_add(x, y) for x, y in zip(s, b)]
        probe.append(s)
        if d == 3:
            s2 = [k_add(basis[0][i], k_scal(basis[1][i], 2)) for i in range(5)]
            s2 = [k_add(s2[i], k_scal(basis[2][i], 3)) for i in range(5)]
            probe.append(s2)
        return frozenset(g for g in range(660)
                         if all(proj_eq(p, apply_mat(rho[g], p)) for p in probe))

    strat_stabs = {}
    for label, basis in (('C2_plus_plane', plus['basis']),
                         ('C2_minus_line', minus['basis']),
                         ('C3_eigenline', ln3[0]['basis']),
                         ('V4_line_ell_V', lv[0]['basis'])):
        sw = setwise_stab(basis)
        pw = pointwise_stab(basis)
        strat_stabs[label] = {'setwise': GT.name(sw), 'setwise_order': len(sw),
                              'G_orbit_of_stratum': 660 // len(sw),
                              'pointwise': GT.name(pw), 'pointwise_order': len(pw)}
    detail['stratum_stabilisers'] = strat_stabs
    check('C2_plane_setwise_D12_pointwise_C2',
          strat_stabs['C2_plus_plane']['setwise'] == 'D12'
          and strat_stabs['C2_plus_plane']['pointwise'] == 'C2')
    check('C2_line_setwise_D12_pointwise_C2',
          strat_stabs['C2_minus_line']['setwise'] == 'D12'
          and strat_stabs['C2_minus_line']['pointwise'] == 'C2')
    check('C3_eigenline_setwise_C6_pointwise_C3_orbit_110',
          strat_stabs['C3_eigenline']['setwise'] == 'C6'
          and strat_stabs['C3_eigenline']['pointwise'] == 'C3'
          and strat_stabs['C3_eigenline']['G_orbit_of_stratum'] == 110)
    check('V4_line_setwise_A4_pointwise_V4_orbit_55',
          strat_stabs['V4_line_ell_V']['setwise'] == 'A4'
          and strat_stabs['V4_line_ell_V']['pointwise'] == 'V4'
          and strat_stabs['V4_line_ell_V']['G_orbit_of_stratum'] == 55)

    # residual C3 = A4/V4 on ell_V : its two fixed points are off X
    a4gen = [g for g in v4['N'] if GT.ordr[g] == 3][0]
    B = lv[0]['basis']
    A2 = [coords_in_basis(apply_mat(rho[a4gen], b), B) for b in B]
    ellv_c3pts = []
    for e in (1, 2):
        lam = root_of_unity(3, e)
        rows = [[k_sub(A2[j][i], lam) if i == j else A2[j][i] for j in range(2)]
                for i in range(2)]
        ker = kc.kernel(rows, 2)
        assert len(ker) == 1
        vec = [k_add(k_mul(ker[0][0], B[0][i]), k_mul(ker[0][1], B[1][i])) for i in range(5)]
        fv = kc.F_eval(vec)
        stb = stab_point(GT, rho, vec)
        ellv_c3pts.append({'on_X': k_is_zero(fv), 'stab': GT.name(stb)})
    check('V4_line_two_A4_points_off_X', all(not p['on_X'] for p in ellv_c3pts),
          str(ellv_c3pts))
    detail['V4']['A4_points_on_ell_V'] = ellv_c3pts
    detail['V4']['type_II_is_free_residual_C3_orbit'] = True

    # the on-X C6 points have involution-eigenvalue -1, i.e. sit on the minus line
    c6r_H = c6r['H']
    c6gen2 = [g for g in c6r_H if GT.ordr[g] == 6][0]
    tinv = GT.mul[GT.mul[c6gen2][c6gen2]][c6gen2]
    check('C6_cube_is_an_involution', GT.ordr[tinv] == 2)
    c6pts_sign = []
    for st in c6r['strata']:
        v = st['basis'][0]
        fv = kc.F_eval(v)
        lam = st['values'][tinv]
        c6pts_sign.append({'on_X': k_is_zero(fv),
                           'involution_eigenvalue': ('+1' if k_eq(lam, ONE) else
                                                     '-1' if k_eq(lam, k_from_int(-1)) else '?')})
    check('C6_on_X_points_are_exactly_the_minus_eigenvalue_ones',
          all((p['on_X']) == (p['involution_eigenvalue'] == '-1') for p in c6pts_sign
              if p['involution_eigenvalue'] in ('+1', '-1'))
          and sum(1 for p in c6pts_sign if p['involution_eigenvalue'] == '-1') == 2,
          str(c6pts_sign))
    detail['C6']['involution_eigenvalues'] = c6pts_sign

    # standard 5-cycle: exact F values at the C5 eigenpoints
    Pmat = [[ONE if i == (j + 1) % 5 else ZERO for j in range(5)] for i in range(5)]
    pg = [g for g in range(660) if kc.mat_eq(rho[g], Pmat)]
    check('five_cycle_P_is_in_the_group', len(pg) == 1)
    f11111 = kc.F_eval([ONE] * 5)
    check('F_at_[1:1:1:1:1]_equals_5', k_is_rational(f11111) and k_rat(f11111) == 5,
          str(k_to_str(f11111)))
    vals5 = []
    for e in range(1, 5):
        w5 = root_of_unity(5, e)
        v = [kc.k_pow(w5, i) for i in range(5)]
        vals5.append(k_is_zero(kc.F_eval(v)))
    check('F_vanishes_at_the_four_primitive_C5_eigenpoints', all(vals5), str(vals5))
    detail['C5']['standard_model'] = {'F_at_all_ones': '5', 'F_at_v(zeta5^k)_k=1..4': 'all zero'}

    # F55 residual C5 permutes the five C11 eigenpoints in a 5-cycle
    c11H = c11['H']
    NF = c11['N']
    p5 = [g for g in NF if GT.ordr[g] == 5][0]
    c11vecs = [st['basis'][0] for st in c11['strata']]
    perm = []
    for i, v in enumerate(c11vecs):
        w = apply_mat(rho[p5], v)
        j = [t for t in range(5) if proj_eq(w, c11vecs[t])]
        assert len(j) == 1
        perm.append(j[0])
    cyc = len(set(perm)) == 5
    seen = [False] * 5
    ncyc = 0
    for i in range(5):
        if seen[i]:
            continue
        ncyc += 1
        j = i
        while not seen[j]:
            seen[j] = True
            j = perm[j]
    check('F55_residual_C5_is_a_single_5_cycle_on_X_C11', cyc and ncyc == 1,
          str(perm))
    detail['C11']['residual_C5_permutation'] = perm

    # D10 residual C2 on the four C5 points of X: two free 2-orbits
    c5H = c5['H']
    ND = c5['N']
    rfl = [g for g in ND if GT.ordr[g] == 2][0]
    c5vecs = [st['basis'][0] for st in c5['strata']]
    onX = [k_is_zero(kc.F_eval(v)) for v in c5vecs]
    perm5 = []
    for v in c5vecs:
        w = apply_mat(rho[rfl], v)
        j = [t for t in range(5) if proj_eq(w, c5vecs[t])]
        assert len(j) == 1
        perm5.append(j[0])
    fixed_on_X = [i for i in range(5) if onX[i] and perm5[i] == i]
    check('D10_reflection_has_no_fixed_point_on_X_C5', len(fixed_on_X) == 0, str(perm5))
    detail['C5']['reflection_permutation'] = perm5

    # ------------------------------------------------- V4 incidence on X
    V4H = v4['H']
    invs = sorted(g for g in V4H if GT.ordr[g] == 2)
    inc = {'type_I': [], 'ell_V_in_plus_planes': [], 'ell_V_meets_minus_lines': []}
    for st in pv:                       # the three type-I vertices
        v = st['basis'][0]
        signs = []
        for t in invs:
            w = apply_mat(rho[t], v)
            if proj_eq(w, v):
                # scalar is +1 or -1 : compare the first nonzero coordinate
                i0 = [i for i in range(5) if not k_is_zero(v[i])][0]
                lam = k_mul(w[i0], k_inv(v[i0]))
                signs.append('+' if k_eq(lam, ONE) else '-')
            else:
                signs.append('?')
        inc['type_I'].append(signs)
    check('V4_each_type_I_vertex_is_plus_for_one_involution_minus_for_two',
          all(s.count('+') == 1 and s.count('-') == 2 for s in inc['type_I']),
          str(inc['type_I']))
    A = lv[0]['basis']
    for t in invs:
        plusdim = 0
        minusdim = 0
        for b in A:
            w = apply_mat(rho[t], b)
            if all(k_eq(x, y) for x, y in zip(w, b)):
                plusdim += 1
            elif all(k_eq(x, k_neg(y)) for x, y in zip(w, b)):
                minusdim += 1
        inc['ell_V_in_plus_planes'].append((plusdim, minusdim))
    check('V4_line_ell_V_lies_in_all_three_plus_planes_and_meets_no_minus_line',
          all(pd == 2 and md == 0 for pd, md in inc['ell_V_in_plus_planes']),
          str(inc['ell_V_in_plus_planes']))
    detail['V4']['incidence'] = inc

    # ------------------------------------------------- subgroup containment poset
    classes_by_name = []
    for li, (H, nconj, orb, gens) in enumerate(classes):
        classes_by_name.append((labels[li], H, orb))
    contain = []
    for i, (na, Ha, orba) in enumerate(classes_by_name):
        for j, (nb, Hb, orbb) in enumerate(classes_by_name):
            if i == j or len(Ha) >= len(Hb):
                continue
            nsub = sum(1 for A in orba if A <= Hb)
            if nsub:
                contain.append({'sub': na, 'sub_order': len(Ha), 'sup': nb,
                                'sup_order': len(Hb),
                                'copies_of_sub_in_one_sup': nsub})
    detail['containment_poset'] = contain

    # ------------------------------------------------- C3 corollary hypotheses
    # dim V^{C3} for every irreducible V, via explicit permutation/matrix models
    c3H = c3['H']
    c3g = [g for g in c3H if g != GT.one][0]
    # orbits of C3 on G/A5 (11 points, both classes), G/F55 (12), G/C3 (220), G/C11 (60)
    def coset_orbits(K, g):
        Kl = frozenset(K)
        cos = {}
        reps = []
        for x in range(660):
            key = frozenset(GT.mul[x][k] for k in Kl)
            if key not in cos:
                cos[key] = len(reps)
                reps.append(key)
        n = len(reps)
        perm = [None] * n
        for key, i in cos.items():
            x = min(key)
            perm[i] = cos[frozenset(GT.mul[GT.mul[g][x]][k] for k in Kl)]
        seen = [False] * n
        norb = 0
        for i in range(n):
            if seen[i]:
                continue
            norb += 1
            j = i
            while not seen[j]:
                seen[j] = True
                j = perm[j]
        return n, norb

    mult = {}
    a5s = [r for r in ledger if r['name'] == 'A5']
    for i, r in enumerate(a5s):
        n, no = coset_orbits(r['H'], c3g)
        mult['10_%d' % i] = no - 1
        check('C3_orbits_on_11_points_class%d' % i, n == 11 and no == 5, '%d,%d' % (n, no))
    f55 = [r for r in ledger if r['name'] == 'C11:C5'][0]
    n, no = coset_orbits(f55['H'], c3g)
    mult['11'] = no - 1
    check('C3_orbits_on_12_points', n == 12 and no == 4, '%d,%d' % (n, no))
    mult['1'] = 1
    # dim W^{C3} directly: the isolated point, dimension 1 (both 5-dim reps: W and W*)
    mult['5'] = len([s for s in c3['strata'] if k_is_zero(k_sub(s['values'][c3g], ONE))
                     ] and [s for s in c3['strata'] if all(k_eq(s['values'][h], ONE) for h in c3H)])
    dimW_C3 = sum(s['dim'] for s in c3['strata'] if all(k_eq(s['values'][h], ONE) for h in c3H))
    mult['5'] = dimW_C3
    mult['5*'] = dimW_C3
    check('dim_W_C3_equals_1', dimW_C3 == 1, str(dimW_C3))
    # 12-dim principal series: F55-orbits on G/C3 are free (gcd(55,3)=1), count them
    ncos, _ = coset_orbits(c3H, GT.one)
    F55l = sorted(f55['H'])
    cos = {}
    reps = []
    for x in range(660):
        key = frozenset(GT.mul[x][k] for k in c3H)
        if key not in cos:
            cos[key] = len(reps)
            reps.append(key)
    seen = set()
    norb55 = 0
    for i in range(len(reps)):
        if i in seen:
            continue
        norb55 += 1
        x = min(reps[i])
        for g in F55l:
            seen.add(cos[frozenset(GT.mul[GT.mul[g][x]][k] for k in c3H)])
    mult['12'] = norb55
    mult['12*'] = norb55
    check('F55_orbits_on_G_mod_C3_is_4', ncos == 220 and norb55 == 4, '%d,%d' % (ncos, norb55))
    degs = {'1': 1, '5': 5, '5*': 5, '10_0': 10, '10_1': 10, '11': 11, '12': 12, '12*': 12}
    tot = sum(mult[k] * degs[k] for k in degs)
    check('sum_mult_times_degree_is_220', tot == 220, str(tot))
    check('every_irreducible_has_nonzero_C3_invariants',
          all(mult[k] > 0 for k in degs), str(mult))
    detail['C3_corollary'] = {'dim_V_C3_by_irreducible': mult, 'degrees': degs,
                              'sum_check': tot}

    # ------------------------------------------------- serialise
    def ser(row):
        return {
            'name': row['name'], 'label': row['label'],
            'order': row['order'], 'nconj': row['nconj'],
            'N': row['Nname'], 'N_order': len(row['N']),
            'C': row['Cname'], 'C_order': len(row['C']),
            'n_linear_characters': row['nchi'],
            'ambient_strata': [{'dim_W_chi': c['dim_W_chi'], 'type': c['type'],
                                **{k: v for k, v in c.items()
                                   if k not in ('dim_W_chi', 'type', 'vector')}}
                               for c in row['components']],
        }

    payload = {
        'problem': 'E-klein-cubic',
        'packet': 'RECEIVER_LEDGER_X',
        'field': 'Q(zeta_165) = Q(zeta_3,zeta_5,zeta_11), degree 80',
        'model': 'S,T generators as in certificates/exact_weil_check.py; F = sum x_i^2 x_{i+1}',
        'rows': [ser(r) for r in ledger],
        'detail': detail,
        'checks': [{'name': n, 'pass': p, 'detail': d} for n, p, d in CHECKS],
        'all_pass': all(p for _, p, _ in CHECKS),
    }
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, 'ledger_exact.json'), 'w') as fh:
        json.dump(payload, fh, indent=1, sort_keys=True)
    print('\n%d checks, %d failures, %.1fs' %
          (len(CHECKS), sum(1 for _, p, _ in CHECKS if not p), time.time() - t0))
    print('PRODUCE_LEDGER_' + ('OK' if payload['all_pass'] else 'FAILED'))


if __name__ == '__main__':
    main()
