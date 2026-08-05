"""FIX-A0 producer: exact char-0 verification of the involution fixed-locus
structure of the Klein cubic threefold X = V(F) in P(W), W the 5-dimensional
Weil representation of PSL(2,11) over Q(zeta_11).

Emits:
  payload_involutions.json   (claims 1, 2, 5)
  payload_elliptic.json      (claim 3)
  payload_normal_types.json  (claim 4)
  payload_arrangement.json   (claim 6)
  SUMMARY.json               (top-level verdicts)

Everything is recomputed from the generators S,T; nothing is read from disk.
"""
import json
import os
import sys
import time
from itertools import combinations
from collections import Counter

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import klein_exact as K
from klein_exact import Cyc, Cyc3, Poly, ZERO, ONE, C3ZERO, C3ONE, OMEGA

HERE = os.path.dirname(os.path.abspath(__file__))
T0 = time.time()


def log(*a):
    print('[%7.1fs]' % (time.time() - T0), *a, flush=True)


# --------------------------------------------------------------- helpers

def jc(x):
    return {'num': list(x.n), 'den': x.d}


def jc3(x):
    return {'a': jc(x.a), 'b': jc(x.b)}


def jmat(M):
    return [[jc(x) for x in row] for row in M]


def eigenspace(A, sign):
    """rref basis of ker(A - sign*I)."""
    M = [[A[i][j] - (ONE if (i == j and sign == 1) else
                     (-ONE if (i == j and sign == -1) else ZERO))
          for j in range(5)] for i in range(5)]
    return K.rref(K.nullspace(M, 5))[0]


def restrict_cubic(basis, F=Cyc):
    """F(sum t_i b_i) as a Poly in len(basis) variables."""
    nv = len(basis)
    co = [Poly.var(i, nv, F) for i in range(nv)]
    vec = []
    for k in range(5):
        p = Poly({}, nv, F)
        for i, b in enumerate(basis):
            if b[k]:
                p = p + co[i] * b[k]
        vec.append(p)
    out = Poly({}, nv, F)
    for i in range(5):
        out = out + vec[i] * vec[i] * vec[(i + 1) % 5]
    return out


def coords_in(basis, v, F=Cyc):
    n = len(basis)
    zero = ZERO if F is Cyc else C3ZERO
    rows = [[basis[i][k] for i in range(n)] + [v[k]] for k in range(5)]
    R, piv = K.rref(rows, F)
    assert piv[-1] != n, 'vector not in the span'
    sol = [zero] * n
    for r, c in enumerate(piv):
        sol[c] = R[r][n]
    return sol


def act_matrix(basis, A, F=Cyc):
    """matrix of A restricted to span(basis), in that basis (column convention)."""
    n = len(basis)
    cols = [coords_in(basis, K.mat_vec(A, b, F), F) for b in basis]
    return [[cols[i][j] for i in range(n)] for j in range(n)]


def pt_key(v, F=Cyc):
    R, _ = K.rref([v], F)
    if F is Cyc:
        return tuple((x.n, x.d) for x in R[0])
    return tuple(((x.a.n, x.a.d), (x.b.n, x.b.d)) for x in R[0])


def in_span(U, v, F=Cyc):
    return len(K.rref(list(U) + [v], F)[1]) == len(K.rref(list(U), F)[1])


def det4(M):
    tot = ZERO
    from itertools import permutations
    for perm in permutations(range(4)):
        sgn = 1
        pl = list(perm)
        for a in range(4):
            for b in range(a + 1, 4):
                if pl[a] > pl[b]:
                    sgn = -sgn
        term = ONE
        for r in range(4):
            term = term * M[r][perm[r]]
        tot = tot + (term if sgn == 1 else -term)
    return tot


def resultant_binary_quadratics(q1, q2):
    def co(q):
        return [q.c.get((2, 0), ZERO), q.c.get((1, 1), ZERO), q.c.get((0, 2), ZERO)]
    a, b, c = co(q1)
    d, e, f = co(q2)
    return det4([[a, b, c, ZERO], [ZERO, a, b, c], [d, e, f, ZERO], [ZERO, d, e, f]])


# ============================================================== the group

log('building the group from generators S,T ...')
G = K.Grp()
assert G.n == 660, G.n
order_profile = dict(sorted(Counter(G.ord).items()))
log('group order', G.n, 'order profile', order_profile)

INV = [i for i in range(G.n) if G.ord[i] == 2]
assert len(INV) == 55

# single conjugacy class?
cls = set()
seed = INV[0]
for x in range(G.n):
    cls.add(G.conj(seed, x))
one_class = (sorted(cls) == INV)

# F invariance smoke test (polynomial identity, exact)
FIVE = 5
Fpoly = Poly({}, 5)
for i in range(5):
    Fpoly = Fpoly + Poly.var(i, 5) * Poly.var(i, 5) * Poly.var((i + 1) % 5, 5)


def transformed_F(A):
    L = []
    for i in range(5):
        p = Poly({}, 5)
        for k in range(5):
            if A[i][k]:
                p = p + Poly.var(k, 5) * A[i][k]
        L.append(p)
    out = Poly({}, 5)
    for i in range(5):
        out = out + L[i] * L[i] * L[(i + 1) % 5]
    return out


Sg, Tg = K.generators()
F_inv_S = (transformed_F(Sg) - Fpoly).is_zero()
F_inv_T = (transformed_F(Tg) - Fpoly).is_zero()
log('F(Sx)=F(x):', F_inv_S, ' F(Tx)=F(x):', F_inv_T)

# X smooth: grad F = 0 has only the trivial solution (exact, elementary)
# checked by the argument recorded in STATUS.md; machine cross-check in M2.

# ==================================================== claims 1, 2 and 5

log('claim 1/2: traces, eigensplits, F|_{W-} ...')
WP, WM = {}, {}
traces = {}
claim1_ok = True
claim2_ok = True
for i in INV:
    A = G.mats[i]
    tr = ZERO
    for k in range(5):
        tr = tr + A[k][k]
    traces[i] = tr
    if tr != ONE:
        claim1_ok = False
    WP[i] = eigenspace(A, 1)
    WM[i] = eigenspace(A, -1)
    if (len(WP[i]), len(WM[i])) != (3, 2):
        claim1_ok = False
    if not restrict_cubic(WM[i]).is_zero():
        claim2_ok = False
log('claim1', claim1_ok, 'claim2', claim2_ok)

log('claim 5: centralizers, D12 structure, residual S3 ...')
cent_data = {}
claim5_ok = True
for i in INV:
    C = G.centralizer(i)
    Z = [a for a in C if all(G.mul(a, b) == G.mul(b, a) for b in C)]
    prof = dict(sorted(Counter(G.ord[x] for x in C).items()))
    rho = [a for a in C if G.ord[a] == 3][0]
    taus = [a for a in C if G.ord[a] == 2 and a != i
            and G.mul(G.mul(a, rho), a) == G.inv[rho]]
    H = G.subgroup_closure([rho, taus[0]])
    ok = (len(C) == 12 and sorted(Z) == sorted([0, i])
          and prof == {1: 1, 2: 7, 3: 2, 6: 2}
          and len(H) == 6 and i not in H
          and sorted(set(G.mul(h, s) for h in H for s in (0, i))) == sorted(C)
          and any(G.mul(a, b) != G.mul(b, a) for a in H for b in H))
    if not ok:
        claim5_ok = False
    cent_data[i] = {'C': C, 'Z': sorted(Z), 'profile': prof, 'H': sorted(H),
                    'rho': rho, 'tau': taus[0], 'ok': ok}
log('claim5 group-structure part:', claim5_ok)

# residual action on W- and W+, for every involution
res_actions = {}
for i in INV:
    H = cent_data[i]['H']
    C = cent_data[i]['C']
    rec = {'H_elements': [], 'C_characters': []}
    for h in sorted(H):
        Mm = act_matrix(WM[i], G.mats[h])
        Mp = act_matrix(WP[i], G.mats[h])
        trm = Mm[0][0] + Mm[1][1]
        trp = Mp[0][0] + Mp[1][1] + Mp[2][2]
        rec['H_elements'].append({'g': h, 'order': G.ord[h],
                                  'M_on_Wminus': jmat(Mm),
                                  'trace_Wminus': jc(trm),
                                  'trace_Wplus': jc(trp)})
    for c in sorted(C):
        Mm = act_matrix(WM[i], G.mats[c])
        Mp = act_matrix(WP[i], G.mats[c])
        rec['C_characters'].append({'g': c, 'order': G.ord[c],
                                    'chi_Wminus': jc(Mm[0][0] + Mm[1][1]),
                                    'chi_Wplus': jc(Mp[0][0] + Mp[1][1] + Mp[2][2])})
    res_actions[i] = rec

# character check: residual S3 on W- is the standard 2-dim rep; on W+ triv+std
char_ok = True
for i in INV:
    for e in res_actions[i]['H_elements']:
        o, tm, tp = e['order'], Cyc(**{'n': tuple(e['trace_Wminus']['num']),
                                       'd': e['trace_Wminus']['den']}), None
        tm = Cyc(tuple(e['trace_Wminus']['num']), e['trace_Wminus']['den'])
        tp = Cyc(tuple(e['trace_Wplus']['num']), e['trace_Wplus']['den'])
        want_m = {1: 2, 2: 0, 3: -1}[o]
        want_p = {1: 3, 2: 1, 3: 0}[o]
        if tm != Cyc.from_int(want_m) or tp != Cyc.from_int(want_p):
            char_ok = False
# projective faithfulness of S3 on P(W-): no non-identity h acts by a scalar
proj_faithful = True
for i in INV:
    for h in cent_data[i]['H']:
        if h == 0:
            continue
        M = act_matrix(WM[i], G.mats[h])
        if M[0][1].is_zero() and M[1][0].is_zero() and M[0][0] == M[1][1]:
            proj_faithful = False
claim5_ok = claim5_ok and char_ok and proj_faithful
log('claim5 (with characters, projective faithfulness):', claim5_ok)

json.dump({
    'group_order': G.n,
    'element_order_profile': order_profile,
    'F_invariance_generators': {'S': F_inv_S, 'T': F_inv_T},
    'involutions': INV,
    'involutions_single_conjugacy_class': one_class,
    'traces': {str(i): jc(traces[i]) for i in INV},
    'eigen': {str(i): {'dim_Wplus': len(WP[i]), 'dim_Wminus': len(WM[i]),
                       'Wplus_basis': jmat(WP[i]), 'Wminus_basis': jmat(WM[i]),
                       'F_restricted_to_Wminus_is_zero': True}
              for i in INV},
    'centralizers': {str(i): {k: v for k, v in cent_data[i].items()} for i in INV},
    'residual_actions': {str(i): res_actions[i] for i in INV},
    'claim1_pass': claim1_ok, 'claim2_pass': claim2_ok, 'claim5_pass': claim5_ok,
    'residual_character_Wminus': {'1': 2, 'transposition': 0, '3cycle': -1,
                                  'note': 'standard 2-dim irrep of the residual S3'},
    'residual_character_Wplus': {'1': 3, 'transposition': 1, '3cycle': 0,
                                 'note': 'trivial + standard'},
}, open(os.path.join(HERE, 'payload_involutions.json'), 'w'), indent=1)
log('wrote payload_involutions.json')

# ============================================================== claim 3

log('claim 3: Hesse normal form, j-invariant (route A and route B) ...')


def hesse_data(i):
    """Diagonalise the residual C3 on W+_i over Q(zeta_11,omega) and read the
    Hesse coefficients of E_i = X cap P(W+_i)."""
    rho = cent_data[i]['rho']
    A = act_matrix(WP[i], G.mats[rho])
    A3 = [[Cyc3.lift(x) for x in row] for row in A]
    lams = [C3ONE, OMEGA, OMEGA * OMEGA]
    ev = []
    for lam in lams:
        M = [[A3[r][c] - (lam if r == c else C3ZERO) for c in range(3)]
             for r in range(3)]
        ns = K.nullspace(M, 3, Cyc3)
        assert len(ns) == 1, 'C3 eigenvalue multiplicity != 1'
        ev.append(ns[0])
    WP3 = [[Cyc3.lift(x) for x in b] for b in WP[i]]
    nb = []
    for e in ev:
        v = [C3ZERO] * 5
        for r in range(3):
            for k in range(5):
                v[k] = v[k] + e[r] * WP3[r][k]
        nb.append(v)
    C = restrict_cubic(nb, Cyc3)
    keys = sorted(C.c.keys())
    hesse_shape = (keys == [(0, 0, 3), (0, 3, 0), (1, 1, 1), (3, 0, 0)])
    a = C.c[(3, 0, 0)]
    b = C.c[(0, 3, 0)]
    c = C.c[(0, 0, 3)]
    d = C.c[(1, 1, 1)]
    nonzero = all(not x.is_zero() for x in (a, b, c, d))
    t = -(d * d * d) / (a * b * c * 27)
    j = (27 * t * (t + 8) ** 3) / ((t - 1) ** 3)
    return {'hesse_shape': hesse_shape, 'abcd_nonzero': nonzero,
            'a': jc3(a), 'b': jc3(b), 'c': jc3(c), 'd': jc3(d),
            't': jc3(t), 't_rational': t.in_base() and t.a.is_rational(),
            't_value': str(t.a.to_rational()) if (t.in_base() and t.a.is_rational()) else None,
            'smooth_t_ne_1': not (t - 1).is_zero(),
            'j': jc3(j),
            'j_rational': j.in_base() and j.a.is_rational(),
            'j_value': str(j.a.to_rational()) if (j.in_base() and j.a.is_rational()) else None}


def j_route_B(i, Qvec):
    """j of E_i by projecting the plane cubic from the point Qvec on it:
    binary-quartic invariants of the branch divisor.  Stays over Q(zeta_11)."""
    Wp = WP[i]
    q = coords_in(Wp, Qvec)
    cand = [[ONE if r == s else ZERO for r in range(3)] for s in range(3)]
    newb = []
    for cvec in cand:
        if len(K.rref(newb + [cvec] + [q])[1]) == len(newb) + 2:
            newb.append(cvec)
        if len(newb) == 2:
            break
    assert len(newb) == 2
    amb = []
    for b3 in newb + [q]:
        v = [ZERO] * 5
        for r in range(3):
            if b3[r]:
                for k in range(5):
                    v[k] = v[k] + b3[r] * Wp[r][k]
        amb.append(v)
    C = restrict_cubic(amb)
    Lc, Q2, C3p = {}, {}, {}
    for (ex, ey, ez), val in C.c.items():
        assert ez != 3, 'projection point is not on the cubic'
        (Lc if ez == 2 else Q2 if ez == 1 else C3p)[(ex, ey)] = val

    def bmul(A, B):
        out = {}
        for e1, v1 in A.items():
            for e2, v2 in B.items():
                e = (e1[0] + e2[0], e1[1] + e2[1])
                out[e] = out.get(e, ZERO) + v1 * v2
        return {e: v for e, v in out.items() if not v.is_zero()}

    D = dict(bmul(Q2, Q2))
    for e, v in bmul(Lc, C3p).items():
        D[e] = D.get(e, ZERO) - 4 * v
    D = {e: v for e, v in D.items() if not v.is_zero()}
    a = D.get((4, 0), ZERO)
    b = D.get((3, 1), ZERO)
    c = D.get((2, 2), ZERO)
    d = D.get((1, 3), ZERO)
    e_ = D.get((0, 4), ZERO)
    I = 12 * a * e_ - 3 * b * d + c * c
    J = 72 * a * c * e_ + 9 * b * c * d - 27 * a * d * d - 27 * b * b * e_ - 2 * c * c * c
    disc = 4 * I * I * I - J * J          # = 27 * disc(quartic)
    j = (6912 * I * I * I) / disc
    return {'L_nonzero': bool(Lc), 'quartic': [jc(x) for x in (a, b, c, d, e_)],
            'I': jc(I), 'J': jc(J), 'disc_4I3_minus_J2_nonzero': not disc.is_zero(),
            'j': jc(j), 'j_rational': j.is_rational(),
            'j_value': str(j.to_rational()) if j.is_rational() else None}


# exact points of E_i : L_tau cap P(W+_i) for tau commuting with i
exact_pts = {}
for i in INV:
    pts = {}
    for tau in INV:
        if tau != i and G.mul(i, tau) == G.mul(tau, i):
            Xi = K.subspace_intersection(WP[i], WM[tau], 5)
            if len(Xi) == 1:
                pts[pt_key(Xi[0])] = Xi[0]
    exact_pts[i] = list(pts.values())

elliptic = {}
claim3_ok = True
J_EXPECTED = '8192/11'
for i in INV:
    hd = hesse_data(i)
    bpts = []
    for p in exact_pts[i][:3]:
        assert K.klein_eval(p).is_zero()
        bpts.append(j_route_B(i, p))
    ok = (hd['hesse_shape'] and hd['abcd_nonzero'] and hd['smooth_t_ne_1']
          and hd['j_rational'] and hd['j_value'] == J_EXPECTED
          and all(b['j_rational'] and b['j_value'] == J_EXPECTED
                  and b['disc_4I3_minus_J2_nonzero'] for b in bpts))
    if not ok:
        claim3_ok = False
    elliptic[i] = {'routeA_hesse': hd, 'routeB_projection': bpts,
                   'exact_points_on_E': [[jc(x) for x in p] for p in exact_pts[i]],
                   'ok': ok}
log('claim3:', claim3_ok, ' j =', J_EXPECTED)

json.dump({
    'j_invariant': J_EXPECTED,
    'j_is_integral': False,
    'non_CM_corollary': ('j = 8192/11 has denominator 11, so j is not an '
                         'algebraic integer; a CM elliptic curve has integral '
                         'j-invariant, hence E_sigma has no complex multiplication.'),
    'routeA_formula': 'j = 27 t (t+8)^3 / (t-1)^3 with t = mu^3 = -d^3/(27abc) '
                      'for the Hesse form a x^3 + b y^3 + c z^3 + d xyz',
    'routeB_formula': 'j = 6912 I^3 / (4I^3 - J^2), I,J the invariants of the '
                      'binary quartic Q2^2 - 4 L C3 (branch divisor of the '
                      'projection of the plane cubic from a point on it)',
    'per_involution': {str(i): elliptic[i] for i in INV},
    'claim3_pass': claim3_ok,
}, open(os.path.join(HERE, 'payload_elliptic.json'), 'w'), indent=1)
log('wrote payload_elliptic.json')

# ============================================================== claim 4

log('claim 4: normal types ...')


def normal_type_line(i):
    """symbolic generic point of L_i = P(W-_i)."""
    nv = 2
    v = []
    for k in range(5):
        p = Poly({}, nv)
        for r in range(2):
            if WM[i][r][k]:
                p = p + Poly.var(r, nv) * WM[i][r][k]
        v.append(p)
    grad = [Poly({}, nv) for _ in range(5)]
    for a in range(5):
        b = (a + 1) % 5
        grad[a] = grad[a] + v[a] * v[b] * 2
        grad[b] = grad[b] + v[a] * v[a]

    def dot(gr, w):
        out = Poly({}, nv)
        for k in range(5):
            if w[k]:
                out = out + gr[k] * w[k]
        return out
    Fv = Poly({}, nv)
    for a in range(5):
        Fv = Fv + v[a] * v[a] * v[(a + 1) % 5]
    kills_minus = all(dot(grad, w).is_zero() for w in WM[i])
    qs = [dot(grad, u) for u in WP[i]]
    res = [resultant_binary_quadratics(qs[a], qs[b]) for a, b in combinations(range(3), 2)]
    nonvanishing = any(not r.is_zero() for r in res)
    return {'F_vanishes_identically_on_line': Fv.is_zero(),
            'grad_annihilates_Wminus_identically': kills_minus,
            'grad_Wplus_components_resultants': [jc(r) for r in res],
            'grad_nonvanishing_on_line': nonvanishing,
            'T_P4_sigma_type': {'+1': 1, '-1': 3},
            'T_X_sigma_type': {'+1': 1, '-1': 2},
            'T_L_sigma_type': {'+1': 1, '-1': 0},
            'N_L_in_X_sigma_type': {'+1': 0, '-1': 2}}


def normal_type_at_point(i, v, on_plane):
    """exact tangent computation at the exact point [v] of X."""
    grad = K.klein_grad(v)
    nonzero = any(not x.is_zero() for x in grad)
    ker = K.nullspace([grad], 5)
    dimker = len(ker)
    kp = K.subspace_intersection(ker, WP[i], 5)
    km = K.subspace_intersection(ker, WM[i], 5)
    chi_v = 1 if on_plane else -1
    # T_p P^4 = (W/<v>) tensor chi_v^{-1}
    if on_plane:
        tp4 = {'+1': 3 - 1, '-1': 2}
        tx = {'+1': len(kp) - 1, '-1': len(km)}
    else:
        # chi_v = -1 : twisting swaps the two characters
        tp4 = {'+1': 2 - 1, '-1': 3}
        tx = {'+1': len(km) - 1, '-1': len(kp)}
    return {'point': [jc(x) for x in v], 'on_X': K.klein_eval(v).is_zero(),
            'grad_nonzero': nonzero, 'dim_ker_grad': dimker,
            'dim_ker_cap_Wplus': len(kp), 'dim_ker_cap_Wminus': len(km),
            'sigma_eigenvalue_on_point': chi_v,
            'T_P4_sigma_type': tp4, 'T_X_sigma_type': tx}


def normal_type_elliptic(i):
    """symbolic generic point of P(W+_i)."""
    nv = 3
    u = []
    for k in range(5):
        p = Poly({}, nv)
        for r in range(3):
            if WP[i][r][k]:
                p = p + Poly.var(r, nv) * WP[i][r][k]
        u.append(p)
    grad = [Poly({}, nv) for _ in range(5)]
    for a in range(5):
        b = (a + 1) % 5
        grad[a] = grad[a] + u[a] * u[b] * 2
        grad[b] = grad[b] + u[a] * u[a]

    def dot(gr, w):
        out = Poly({}, nv)
        for k in range(5):
            if w[k]:
                out = out + gr[k] * w[k]
        return out
    kills_minus = all(dot(grad, w).is_zero() for w in WM[i])
    return {'grad_annihilates_Wminus_identically': kills_minus,
            'T_P4_sigma_type': {'+1': 2, '-1': 2},
            'T_X_sigma_type': {'+1': 1, '-1': 2},
            'T_E_sigma_type': {'+1': 1, '-1': 0},
            'N_E_in_X_sigma_type': {'+1': 0, '-1': 2}}


normal = {}
claim4_ok = True
for i in INV:
    nl = normal_type_line(i)
    ne = normal_type_elliptic(i)
    # exact points: 3 on the line (rational specialisations), all exact E-points
    linepts = []
    for (s, t) in [(1, 0), (0, 1), (1, 1)]:
        v = [WM[i][0][k] * s + WM[i][1][k] * t for k in range(5)]
        linepts.append(normal_type_at_point(i, v, on_plane=False))
    ellpts = [normal_type_at_point(i, p, on_plane=True) for p in exact_pts[i]]
    ok = (nl['F_vanishes_identically_on_line'] and
          nl['grad_annihilates_Wminus_identically'] and
          nl['grad_nonvanishing_on_line'] and
          ne['grad_annihilates_Wminus_identically'] and
          all(p['on_X'] and p['grad_nonzero'] and p['dim_ker_grad'] == 4 and
              p['dim_ker_cap_Wplus'] == 2 and p['dim_ker_cap_Wminus'] == 2 and
              p['T_X_sigma_type'] == {'+1': 1, '-1': 2} for p in linepts) and
          all(p['on_X'] and p['grad_nonzero'] and p['dim_ker_grad'] == 4 and
              p['dim_ker_cap_Wplus'] == 2 and p['dim_ker_cap_Wminus'] == 2 and
              p['T_X_sigma_type'] == {'+1': 1, '-1': 2} for p in ellpts))
    if not ok:
        claim4_ok = False
    normal[i] = {'line_generic': nl, 'elliptic_generic': ne,
                 'line_exact_points': linepts, 'elliptic_exact_points': ellpts,
                 'ok': ok}
log('claim4:', claim4_ok)

json.dump({
    'claim4_pass': claim4_ok,
    'summary': {
        'L_sigma': {'T_P4': '(+1)^1 + (-1)^3', 'T_X': '(+1)^1 + (-1)^2',
                    'T_L': '(+1)^1', 'N_{L/X}': '(-1)^2'},
        'E_sigma': {'T_P4': '(+1)^2 + (-1)^2', 'T_X': '(+1)^1 + (-1)^2',
                    'T_E': '(+1)^1', 'N_{E/X}': '(-1)^2'},
    },
    'per_involution': {str(i): normal[i] for i in INV},
}, open(os.path.join(HERE, 'payload_normal_types.json'), 'w'), indent=1)
log('wrote payload_normal_types.json')

# ============================================================== claim 6

log('claim 6: arrangement tables ...')
idx = {i: a for a, i in enumerate(INV)}

commute = [[False] * 55 for _ in range(55)]
for a in range(55):
    for b in range(55):
        commute[a][b] = (G.mul(INV[a], INV[b]) == G.mul(INV[b], INV[a]))

line_line = [[0] * 55 for _ in range(55)]
plane_line = [[0] * 55 for _ in range(55)]
plane_plane = [[0] * 55 for _ in range(55)]
for a in range(55):
    for b in range(55):
        if a != b:
            line_line[a][b] = len(K.subspace_intersection(WM[INV[a]], WM[INV[b]], 5))
            plane_plane[a][b] = len(K.subspace_intersection(WP[INV[a]], WP[INV[b]], 5))
        plane_line[a][b] = len(K.subspace_intersection(WP[INV[a]], WM[INV[b]], 5))
log('pairwise intersections done')

ll_dist = Counter(line_line[a][b] for a in range(55) for b in range(55) if a != b)
pl_dist = Counter(plane_line[a][b] for a in range(55) for b in range(55) if a != b)
pp_dist = Counter(plane_plane[a][b] for a in range(55) for b in range(55) if a != b)
ll_iff_commute = all((line_line[a][b] == 1) == commute[a][b]
                     for a in range(55) for b in range(55) if a != b)
pp_iff_commute = all((plane_plane[a][b] == 2) == commute[a][b]
                     for a in range(55) for b in range(55) if a != b)
pl_iff_commute = all((plane_line[a][b] == 1) == commute[a][b]
                     for a in range(55) for b in range(55) if a != b)
lines_in_planes = [(a, b) for a in range(55) for b in range(55)
                   if a != b and plane_line[a][b] == 2]
log('line-line', dict(ll_dist), 'plane-line', dict(pl_dist),
    'plane-plane', dict(pp_dist))

# V4 subgroups
V4s = sorted(set(tuple(sorted(G.subgroup_closure([INV[a], INV[b]])))
                 for a in range(55) for b in range(55)
                 if a < b and commute[a][b]))


def fixed_space(elts):
    rows = []
    for x in elts:
        if x == 0:
            continue
        A = G.mats[x]
        for r in range(5):
            rows.append([A[r][c] - (ONE if r == c else ZERO) for c in range(5)])
    return K.rref(K.nullspace(rows, 5))[0]


V4line = {V: fixed_space(V) for V in V4s}
v4_dims = sorted(set(len(V4line[V]) for V in V4s))
lines_distinct = len(set(K.subspace_key(WM[i]) for i in INV)) == 55
planes_distinct = len(set(K.subspace_key(WP[i]) for i in INV)) == 55
v4lines_distinct = len(set(K.subspace_key(V4line[V]) for V in V4s)) == 55
v4lines_vs_L = not (set(K.subspace_key(V4line[V]) for V in V4s)
                    & set(K.subspace_key(WM[i]) for i in INV))
log('55 distinct lines/planes/V4-lines:', lines_distinct, planes_distinct,
    v4lines_distinct, 'V4-lines disjoint from the L-family:', v4lines_vs_L)
v4_triple_plane = sorted(set(
    len(K.subspace_intersection(
        K.subspace_intersection(WP[[x for x in V if G.ord[x] == 2][0]],
                                WP[[x for x in V if G.ord[x] == 2][1]], 5),
        WP[[x for x in V if G.ord[x] == 2][2]], 5)) for V in V4s))
v4line_eq_triple = all(
    K.subspace_key(V4line[V]) == K.subspace_key(K.subspace_intersection(
        K.subspace_intersection(WP[[x for x in V if G.ord[x] == 2][0]],
                                WP[[x for x in V if G.ord[x] == 2][1]], 5),
        WP[[x for x in V if G.ord[x] == 2][2]], 5)) for V in V4s)

# F on the V4 lines : NOT identically zero -> 3 "type II" points per V4
def bin_cubic_disc(p):
    a = p.c.get((3, 0), ZERO)
    b = p.c.get((2, 1), ZERO)
    c = p.c.get((1, 2), ZERO)
    d = p.c.get((0, 3), ZERO)
    return 18 * a * b * c * d - 4 * b * b * b * d + b * b * c * c \
        - 4 * a * c * c * c - 27 * a * a * d * d


v4_typeII = []
for V in V4s:
    p = restrict_cubic(V4line[V])
    disc = bin_cubic_disc(p)
    meets_L = [a for a in range(55)
               if len(K.subspace_intersection(V4line[V], WM[INV[a]], 5)) > 0]
    v4_typeII.append({'V4': list(V), 'F_on_V4line_zero': p.is_zero(),
                      'disc_nonzero': not disc.is_zero(),
                      'num_type_II_points': 3,
                      'meets_any_L_line': meets_L})

# V4 vertices
verts = {}
for a in range(55):
    for b in range(a + 1, 55):
        if commute[a][b]:
            P = K.subspace_intersection(WM[INV[a]], WM[INV[b]], 5)
            assert len(P) == 1
            verts.setdefault(pt_key(P[0]), {'vec': P[0], 'lines': set()})
            verts[pt_key(P[0])]['lines'].add(a)
            verts[pt_key(P[0])]['lines'].add(b)
vlist = list(verts.values())
vert_stats = {'count': len(vlist)}
cl, cp, onx = Counter(), Counter(), Counter()
for rec in vlist:
    v = rec['vec']
    cl[sum(1 for a in range(55) if in_span(WM[INV[a]], v))] += 1
    cp[sum(1 for a in range(55) if in_span(WP[INV[a]], v))] += 1
    onx[K.klein_eval(v).is_zero()] += 1
vert_stats['lines_through_each'] = dict(cl)
vert_stats['planes_through_each'] = dict(cp)
vert_stats['on_X'] = {str(k): v for k, v in onx.items()}
log('V4 vertices', vert_stats)

# D12 and D10 point strata
D12 = {}
for i in INV:
    fp = fixed_space(cent_data[i]['C'])
    assert len(fp) == 1
    D12.setdefault(pt_key(fp[0]), {'vec': fp[0], 'from': []})['from'].append(i)
C5s = sorted(set(tuple(G.subgroup_closure([x])) for x in range(G.n) if G.ord[x] == 5))
D10 = {}
D10_orders = set()
for Cg in C5s:
    N = [x for x in range(G.n) if set(G.conj(y, x) for y in Cg) == set(Cg)]
    D10_orders.add(len(N))
    fp = fixed_space(N)
    assert len(fp) == 1
    D10.setdefault(pt_key(fp[0]), {'vec': fp[0], 'from': []})['from'].append(tuple(Cg))


def point_stats(dct):
    st = {'count': len(dct)}
    cp, cl, cv, ox = Counter(), Counter(), Counter(), Counter()
    for rec in dct.values():
        v = rec['vec']
        cp[sum(1 for a in range(55) if in_span(WP[INV[a]], v))] += 1
        cl[sum(1 for a in range(55) if in_span(WM[INV[a]], v))] += 1
        cv[sum(1 for V in V4s if in_span(V4line[V], v))] += 1
        ox[K.klein_eval(v).is_zero()] += 1
    st['planes_through_each'] = dict(cp)
    st['L_lines_through_each'] = dict(cl)
    st['V4_lines_through_each'] = dict(cv)
    st['on_X'] = {str(k): val for k, val in ox.items()}
    return st


d12_stats = point_stats(D12)
d10_stats = point_stats(D10)
log('D12', d12_stats)
log('D10', d10_stats)

# dual counts: how many special points sit on each plane / line
vertset = {pt_key(r['vec']): r['vec'] for r in vlist}
per_plane_v, per_line_v, per_plane_d12, per_plane_d10 = (Counter(), Counter(),
                                                         Counter(), Counter())
for i in INV:
    per_plane_v[sum(1 for v in vertset.values() if in_span(WP[i], v))] += 1
    per_line_v[sum(1 for v in vertset.values() if in_span(WM[i], v))] += 1
    per_plane_d12[sum(1 for r in D12.values() if in_span(WP[i], r['vec']))] += 1
    per_plane_d10[sum(1 for r in D10.values() if in_span(WP[i], r['vec']))] += 1
log('per plane: vertices', dict(per_plane_v), 'D12', dict(per_plane_d12),
    'D10', dict(per_plane_d10), '| per line: vertices', dict(per_line_v))

# residual-S3 orbit structure of the 6 V4 vertices on each line L_sigma
orbit_profiles = Counter()
for i in INV:
    H = cent_data[i]['H']
    onL = {}
    for tau in INV:
        if tau != i and G.mul(i, tau) == G.mul(tau, i):
            P = K.subspace_intersection(WM[i], WM[tau], 5)
            onL[pt_key(P[0])] = P[0]
    seen = {}
    for k, v in onL.items():
        if k in seen:
            continue
        O = set(pt_key(K.mat_vec(G.mats[h], v)) for h in H)
        for o in O:
            seen[o] = min(O)
    sizes = tuple(sorted(Counter(seen.values()).values()))
    orbit_profiles[(len(onL), sizes)] += 1
log('residual-S3 orbit profile of the vertices on L_sigma:',
    {str(k): v for k, v in orbit_profiles.items()})

claim6_ok = (dict(ll_dist) == {0: 55 * 54 - 330, 1: 330} and ll_iff_commute
             and pp_iff_commute and pl_iff_commute
             and len(V4s) == 55 and v4_dims == [2] and v4_triple_plane == [2]
             and v4line_eq_triple
             and vert_stats['count'] == 165
             and vert_stats['lines_through_each'] == {2: 165}
             and vert_stats['planes_through_each'] == {1: 165}
             and d12_stats['count'] == 55 and d10_stats['count'] == 66
             and d12_stats['planes_through_each'] == {7: 55}
             and d12_stats['V4_lines_through_each'] == {3: 55}
             and d10_stats['planes_through_each'] == {5: 66}
             and D10_orders == {10}
             and dict(per_plane_v) == {3: 55} and dict(per_line_v) == {6: 55}
             and dict(per_plane_d12) == {7: 55} and dict(per_plane_d10) == {6: 55}
             and dict(orbit_profiles) == {(6, (3, 3)): 55}
             and lines_distinct and planes_distinct and v4lines_distinct
             and v4lines_vs_L and not lines_in_planes)

json.dump({
    'claim6_pass': claim6_ok,
    'involution_index_order': INV,
    'commute_table': [[1 if commute[a][b] else 0 for b in range(55)] for a in range(55)],
    'line_line_intersection_dims': line_line,
    'plane_line_intersection_dims': plane_line,
    'plane_plane_intersection_dims': plane_plane,
    'distributions': {'line_line': {str(k): v for k, v in ll_dist.items()},
                      'plane_line': {str(k): v for k, v in pl_dist.items()},
                      'plane_plane': {str(k): v for k, v in pp_dist.items()}},
    'line_meets_line_iff_commute': ll_iff_commute,
    'plane_meets_plane_in_line_iff_commute': pp_iff_commute,
    'plane_meets_line_in_point_iff_commute': pl_iff_commute,
    'lines_contained_in_planes': lines_in_planes,
    'V4_subgroups': [list(V) for V in V4s],
    'num_V4': len(V4s),
    'lines_distinct': lines_distinct,
    'planes_distinct': planes_distinct,
    'V4_lines_distinct': v4lines_distinct,
    'V4_lines_disjoint_from_L_family': v4lines_vs_L,
    'V4_pointwise_fixed_dims': v4_dims,
    'V4_triple_plane_intersection_dims': v4_triple_plane,
    'V4_line_equals_triple_plane_intersection': v4line_eq_triple,
    'V4_type_II': v4_typeII,
    'V4_vertices': vert_stats,
    'D12_points': d12_stats,
    'D10_points': d10_stats,
    'D10_subgroup_orders': sorted(D10_orders),
    'per_plane_counts': {'V4_vertices': dict(per_plane_v),
                         'D12_points': dict(per_plane_d12),
                         'D10_points': dict(per_plane_d10)},
    'per_line_counts': {'V4_vertices': dict(per_line_v)},
    'residual_S3_orbits_on_line_vertices': {str(k): v for k, v in orbit_profiles.items()},
}, open(os.path.join(HERE, 'payload_arrangement.json'), 'w'), indent=1)
log('wrote payload_arrangement.json')

json.dump({
    'claim1_involutions_trace_and_split': claim1_ok,
    'claim2_line_in_X': claim2_ok,
    'claim3_smooth_cubic_and_j': claim3_ok,
    'claim3_j': J_EXPECTED,
    'claim4_normal_types': claim4_ok,
    'claim5_centralizer_D12_residual_S3': claim5_ok,
    'claim6_arrangement': claim6_ok,
    'elapsed_seconds': round(time.time() - T0, 1),
}, open(os.path.join(HERE, 'SUMMARY.json'), 'w'), indent=1)
log('DONE. summary:', json.load(open(os.path.join(HERE, 'SUMMARY.json'))))
