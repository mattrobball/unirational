#!/usr/bin/env python3
"""FIX-H1 producer, Part B -- the S3-equalizer at c_sigma, both branches.

Exact, characteristic 0, over the degree-4 field K0 = QQ(om, nu),
om^2+om+1 = 0, nu^2 = -11  (module `k0.py`, self-contained).

DERIVATION (proved in payloads/PAYLOAD_theorem.txt):

  m = common plane order, r = triple-line order, e := r - m >= 1.
  W^- = W^-_sigma is the standard 2-dim representation `std` of the residual
  S3 = C_G(sigma)/<sigma>;  V := Hom(Sym^m W^-, W^-).

  The leading package  Phi = (c_alpha)_{|alpha|=m},  c_alpha in
  H^0(P_sigma, O(d-m)) ox W^-, is S3-equivariant (H0-1 puts the MINUS half in
  the lead) and vanishes to order >= e along each of the three concurrent
  mirror lines ell_{V,i} (because ord_{ell_{V,i}} T = r for all three).
  Hence Phi = D^e Psi with D = the product of the three mirror linear forms,
  which spans the SGN character of S3 on Sym^3(W^+)^*.  So

        g . Psi = sgn(g)^e Psi ,

  and evaluating at the S3-fixed point c_sigma (the fibre of O(k) there is the
  trivial character) gives the ORDER-0 EQUALIZER CONDITION

        lambda_{2e}  in  V[sgn^e] = { L in V : rho.L = L, tau.L = sgn(tau)^e L },

  where lambda_{2e} is the order-2e Taylor coefficient at c_sigma of the
  LEADING LINE DATUM  Lambda = ( the (y,z)-degree-m part of T^- ) / x^e,
  a V-valued binary form of degree d-r on ell_V.  (Lambda necessarily vanishes
  to order >= 2e at c_sigma; lambda_{2e} is its leading coefficient there.)
"""
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from k0 import (K, ZERO, ONE, OM, OM2, NU, DL, KP, KM,     # noqa: E402
                rref, rank, nullspace)

T0 = time.time()
LOG = []


def log(s):
    print(s, flush=True)
    LOG.append(s)


# ------------------------ univariate polynomials over K0 (parameter B) -------
def pz():
    return {}


def pc(k):
    return {} if k.is_zero() else {0: k}


def pv():
    return {1: ONE}


def padd(p, q):
    o = dict(p)
    for e, v in q.items():
        w = o.get(e, ZERO) + v
        if w.is_zero():
            o.pop(e, None)
        else:
            o[e] = w
    return o


def pmul(p, q):
    o = {}
    for e1, v1 in p.items():
        for e2, v2 in q.items():
            e = e1 + e2
            w = o.get(e, ZERO) + v1 * v2
            if w.is_zero():
                o.pop(e, None)
            else:
                o[e] = w
    return o


def pscal(p, k):
    return {e: v * k for e, v in p.items() if not (v * k).is_zero()}


def pstr(p, var='B'):
    if not p:
        return '0'
    return ' + '.join('(%r)*%s^%d' % (v, var, e) for e, v in sorted(p.items()))


# ---------------------------------------------- the residual-S3 matrices on W^-
# produced and closed-form-verified by produce_h1_frame.py (certificate A4)
R = [[K.rat(-1, 2), (ONE - NU) / K.rat(4)],
     [(-ONE - NU) / K.rat(4), K.rat(-1, 2)]]
TAU = [[ONE, ZERO], [ZERO, -ONE]]


def m2inv(M):
    d = M[0][0] * M[1][1] - M[0][1] * M[1][0]
    di = d.inv()
    return [[M[1][1] * di, -M[0][1] * di], [-M[1][0] * di, M[0][0] * di]]


# ------------------------------------------- V = Hom(Sym^m W^-, W^-), monomials
def vbasis(m):
    """(component, i) <-> the basis element  y^i z^{m-i}  in component comp."""
    return [(comp, i) for comp in (0, 1) for i in range(m + 1)]


def act_matrix(M, m):
    """matrix of g (with matrix M on W^-) acting on V, in vbasis(m).

    (g.L)(v^m) = g( L( (g^{-1}v)^m ) ):  substitute (y,z) -> M^{-1}(y,z) in the
    forms, then multiply the component vector by M.
    """
    Mi = m2inv(M)
    n = 2 * (m + 1)
    cols = []
    for comp, i in vbasis(m):
        # the monomial y^i z^{m-i} after y -> Mi00 y + Mi01 z, z -> Mi10 y + Mi11 z
        # expand as a binary form: coefficients coefs[j] of y^j z^{m-j}
        coefs = [ZERO] * (m + 1)
        # (Mi00 y + Mi01 z)^i * (Mi10 y + Mi11 z)^(m-i)
        A = binom_expand(Mi[0][0], Mi[0][1], i)
        Bp = binom_expand(Mi[1][0], Mi[1][1], m - i)
        for j1, c1 in enumerate(A):
            for j2, c2 in enumerate(Bp):
                coefs[j1 + j2] = coefs[j1 + j2] + c1 * c2
        col = [ZERO] * n
        for j in range(m + 1):
            # the substituted form sits in component `comp`; then multiply by M
            col[vbasis(m).index((0, j))] = col[vbasis(m).index((0, j))] + \
                M[0][comp] * coefs[j]
            col[vbasis(m).index((1, j))] = col[vbasis(m).index((1, j))] + \
                M[1][comp] * coefs[j]
        cols.append(col)
    return [[cols[j][i] for j in range(n)] for i in range(n)]


def binom_expand(a, b, k):
    """coefficients of (a y + b z)^k as a list c[j] of y^j z^{k-j}."""
    out = [ZERO] * (k + 1)
    out[0] = ONE                          # start with z^0 ... build up
    cur = [ONE]
    for _ in range(k):
        nxt = [ZERO] * (len(cur) + 1)
        for j, c in enumerate(cur):
            nxt[j + 1] = nxt[j + 1] + c * a
            nxt[j] = nxt[j] + c * b
        cur = nxt
    return cur


def isotypic(m, e):
    n = 2 * (m + 1)
    A = act_matrix(R, m)
    Bm = act_matrix(TAU, m)
    sgn = ONE if e % 2 == 0 else -ONE
    rows = []
    for i in range(n):
        rows.append([A[i][j] - (ONE if i == j else ZERO) for j in range(n)])
    for i in range(n):
        rows.append([Bm[i][j] - (sgn if i == j else ZERO) for j in range(n)])
    return nullspace(rows, n)


def mono_str(m, comp, i):
    yz = ('y^%d' % i if i > 1 else ('y' if i == 1 else '')) + \
         ('z^%d' % (m - i) if m - i > 1 else ('z' if m - i == 1 else ''))
    return '%s E_%s' % (yz if yz else '1', 'y' if comp == 0 else 'z')


def show(vec, m):
    parts = []
    for c, (comp, i) in zip(vec, vbasis(m)):
        if not c.is_zero():
            parts.append('(%r) %s' % (c, mono_str(m, comp, i)))
    return ' + '.join(parts) if parts else '0'


# ================================================================ BRANCH (i)
def branch_m3():
    log('')
    log('===== BRANCH (i): the (3,.) D_B branch,  (m,r) = (3,6),  e = 3 =====')
    m, e = 3, 3
    n = 2 * (m + 1)
    L = isotypic(m, e)
    log('B1  dim V = Hom(Sym^3 W^-, W^-) = %d ;  dim V[sgn^e] = %d '
        '(e = 3 odd -> twist = sgn)' % (n, len(L)))
    assert len(L) == 1, 'expected dim 1, got %d' % len(L)
    gen = L[0]
    piv = next(i for i in range(n) if not gen[i].is_zero())
    inv = gen[piv].inv()
    gen = [v * inv for v in gen]
    log('B1  the equalizer line V[sgn] is spanned by')
    log('B1      %s' % show(gen, m))

    # ---------- the D_B leading datum, line degree 0 ----------------------
    # D_B(yz) = (-x^2y^2z^2, 0, yz(y^2z^2+Bz^2x^2+B^-1x^2y^2),
    #             om zx(z^2x^2+Bx^2y^2+B^-1y^2z^2),
    #             om^2 xy(x^2y^2+By^2z^2+B^-1z^2x^2))
    # (y,z)-degree-3 part of (u_1', u_2') is x^3 * Lambda_0 with
    #   Lambda_0 = om (z^3 + B y^2 z) E_y + om^2 (y^3 + B^-1 y z^2) E_z .
    log('B2  leading line datum of D_B(yz):'
        '  Lambda_0 = om(z^3+B y^2z) E_y + om^2(y^3+B^-1 y z^2) E_z')
    idx = {t: vbasis(m).index(t) for t in vbasis(m)}
    # in the (c1,d1,c2,d2) coordinates:
    S_idx = [idx[(0, 0)], idx[(0, 2)], idx[(1, 3)], idx[(1, 1)]]
    other = [i for i in range(n) if i not in S_idx]
    out_coords = [gen[i] for i in other]
    log('B3  the D_B leading-datum locus (Zariski closure over ALL line '
        'degrees, Thm N2B-2):')
    log('B3      S_DB = { (c1 z^3 + d1 y^2z) E_y + (c2 y^3 + d2 yz^2) E_z'
        '  :  d1 d2 = c1 c2 }')
    log('B3      (D_B(f.yz) has Lambda = om g1^3 (z^3 + Beff y^2 z) E_y'
        ' + om^2 g2^3 (y^3 + Beff^-1 y z^2) E_z,')
    log('B3       g1 = Theta f, g2 = Theta^2 f, Beff = B (g2/g1)^2 ; then'
        ' c1 = om g1^3, d1 = c1 Beff,')
    log('B3       c2 = om^2 g2^3, d2 = c2 Beff^-1, so d1 d2 = c1 c2'
        ' IDENTICALLY)')
    log('B3  coordinates of the equalizer generator OUTSIDE span(S_DB): %s'
        % [repr(v) for v in out_coords])
    inside = all(v.is_zero() for v in out_coords)
    if not inside:
        log('B3  ==> the equalizer line is NOT contained in span(S_DB).')
        log('B3      span(S_DB) is a coordinate subspace, so'
            ' L cap span(S_DB) = {0}:')
        log('B3      NO nonzero D_B leading datum satisfies the order-0'
            ' equalizer, for ANY line degree,')
        log('B3      ANY B on the trace curve, and any degeneration.')
        verdict = 'EMPTY'
        q = None
    else:
        c1, d1, c2, d2 = [gen[i] for i in S_idx]
        q = d1 * d2 - c1 * c2
        log('B3  the equalizer line DOES lie in span(S_DB); quadric value'
            ' d1d2 - c1c2 = %r' % q)
        assert q.is_zero()
        log('B3  ==> the equalizer line lies ON the D_B quadric.  The order-0'
            ' condition therefore')
        log('B3      pins the SHAPE parameters uniquely:')
        Beff = d1 / c1
        rat = c2 / c1
        log('B3        Beff = d1/c1              = %r' % Beff)
        log('B3        c2/c1                     = %r' % rat)
        assert (d2 - rat * Beff.inv()).is_zero() if not Beff.is_zero() else True
        log('B3        (consistency: d2 = (c2/c1) Beff^{-1} c1 : %s)'
            % ('OK' if (d2 - rat * Beff.inv()).is_zero() else 'FAIL'))
        # ---- now impose the branch's own constraint -------------------
        # For D_B(f.yz):  c1 = om g1^3 , c2 = om^2 g2^3 , Beff = B (g2/g1)^2 .
        # Eliminating t = g2/g1  (t^2 = Beff/B , c2/c1 = om t^3) gives the
        # EXACT constraint      (c2/c1)^2 B^3 = om^2 Beff^3 .
        log('B3  branch constraint (eliminate t = g2/g1 from c2/c1 = om t^3,'
            ' t^2 = Beff/B):')
        log('B3        (c2/c1)^2 * B^3 = om^2 * Beff^3     ==>  B^3 forced')
        B3 = OM2 * Beff * Beff * Beff / (rat * rat)
        log('B3        B^3 = %r      (numerically %s)' % (B3, B3.cplx()))
        tr = B3 + B3.inv()
        log('B3        B^3 + B^-3 = %r   (numerically %s)' % (tr, tr.cplx()))
        log('B3        the trace curve demands B^3 + B^-3 = kp + 2 = %r'
            '  (numerically %s)' % (KP + K.rat(2), (KP + K.rat(2)).cplx()))
        onto = (tr - (KP + K.rat(2))).is_zero()
        log('B3        MATCH ? %s' % ('YES' if onto else 'NO'))
        # also test the Galois conjugate kp -> km (the other root of 8k^2-13k-4)
        onto2 = (tr - (KM + K.rat(2))).is_zero()
        log('B3        (also test the conjugate root km: MATCH ? %s)'
            % ('YES' if onto2 else 'NO'))
        # and the om <-> om^2 / nu -> -nu Galois twists of the equalizer line
        twists = []
        for nm, f in (('om->om^2', lambda v: v.conj_om()),
                      ('nu->-nu', lambda v: v.conj_nu()),
                      ('both', lambda v: v.conj_om().conj_nu())):
            t2 = f(tr)
            twists.append((nm, (t2 - (KP + K.rat(2))).is_zero(),
                           (t2 - (KM + K.rat(2))).is_zero()))
            log('B3        Galois twist %-9s : B^3+B^-3 = %r -> kp? %s  km? %s'
                % (nm, t2, twists[-1][1], twists[-1][2]))
        verdict = 'EMPTY' if not (onto or onto2 or
                                  any(a or b for _, a, b in twists)) \
            else 'NONEMPTY'
        log('B3  degenerate limits (ord g1 != ord g2) give lambda_6 ='
            ' om g1^3 z^3 E_y  or  om^2 g2^3 y^3 E_z ;')
        log('B3      the equalizer generator has BOTH c1 != 0 and c2 != 0,'
            ' so these are excluded too.')
    log('B3  VERDICT (order 0): FIX-H1-EQ-M3-%s' % verdict)

    # ---------- the same, done as an explicit elimination in B ------------
    log('B4  explicit elimination in the branch parameter B (line degree 0):')
    Bpoly = {}
    # Lambda_0 * B  (clear B^-1):  coefficients are polynomials in B
    lam = {i: pz() for i in range(n)}
    lam[idx[(0, 0)]] = pscal(pv(), OM)                      # om B * z^3
    lam[idx[(0, 2)]] = pscal(pmul(pv(), pv()), OM)          # om B^2 * y^2 z
    lam[idx[(1, 3)]] = pscal(pv(), OM2)                     # om^2 B * y^3
    lam[idx[(1, 1)]] = pscal(pc(ONE), OM2)                  # om^2 * y z^2
    A = act_matrix(R, m)
    diff = []
    for i in range(n):
        acc = pz()
        for j in range(n):
            if not A[i][j].is_zero():
                acc = padd(acc, pscal(lam[j], A[i][j]))
        acc = padd(acc, pscal(lam[i], -ONE))
        diff.append(acc)
    nz = [i for i in range(n) if diff[i]]
    log('B4      rho.Lambda_0 - Lambda_0 has %d nonzero coordinates of %d'
        % (len(nz), n))
    for i in nz:
        log('B4        coord %s : %s' % (mono_str(m, *vbasis(m)[i]),
                                         pstr(diff[i])))
    # trace curve: B^6 - (kp+2) B^3 + 1 = 0
    trace = {6: ONE, 3: -(KP + K.rat(2)), 0: ONE}
    common = poly_gcd_list([diff[i] for i in nz] + [trace])
    log('B4      gcd(the equalizer equations, B^6-(kp+2)B^3+1) = %s'
        % pstr(common))
    solvable = (len(common) > 1) or (len(common) == 1 and
                                     list(common.keys())[0] > 0)
    log('B4      common root with the trace curve : %s'
        % ('YES' if solvable else 'NO'))

    # tau-check (should be automatic)
    Bt = act_matrix(TAU, m)
    tdiff = []
    for i in range(n):
        acc = pz()
        for j in range(n):
            if not Bt[i][j].is_zero():
                acc = padd(acc, pscal(lam[j], Bt[i][j]))
        acc = padd(acc, pscal(lam[i], ONE))          # tau.L + L  (want 0)
        tdiff.append(acc)
    tok = all(not t for t in tdiff)
    log('B5  tau.Lambda_0 = -Lambda_0 (the required sgn^e twist) : %s'
        '   <-- AUTOMATIC (tau is the image of K_1, and the germ is'
        ' K_1-equivariant)' % ('YES' if tok else 'NO'))
    assert tok

    return dict(dimV=n, dim_line=len(L),
                generator=[repr(v) for v in gen],
                inside_span_SDB=bool(inside),
                quadric=(repr(q) if q is not None else None),
                elimination_gcd=pstr(common), solvable=bool(solvable),
                verdict='FIX-H1-EQ-M3-%s' % verdict,
                tau_automatic=bool(tok))


def poly_gcd(p, q):
    p, q = dict(p), dict(q)
    while q:
        dq = max(q)
        lq = q[dq].inv()
        dp = max(p) if p else -1
        if dp < dq:
            p, q = q, p
            continue
        f = pscal({dp - dq: p[dp] * lq}, ONE)
        p = padd(p, pscal(pmul(f, q), -ONE))
        p = {e: v for e, v in p.items() if not v.is_zero()}
        if not p:
            p, q = q, p
            break
        if max(p) >= dq:
            continue
        p, q = q, p
    return p


def poly_gcd_list(ps):
    g = None
    for p in ps:
        g = dict(p) if g is None else poly_gcd(g, p)
        if g and max(g) == 0:
            return {0: ONE}
    return g if g else {0: ONE}


# =============================================================== BRANCH (ii)
def branch_m1():
    log('')
    log('===== BRANCH (ii): the primitive Chebyshev branch,'
        '  (m,r) = (1,7),  e = 6 =====')
    m, e = 1, 6
    n = 2 * (m + 1)
    L = isotypic(m, e)
    log('C1  dim V = End(W^-) = %d ;  dim V[sgn^e] = %d  (e = 6 even -> twist'
        ' trivial)' % (n, len(L)))
    assert len(L) == 1
    gen = L[0]
    piv = next(i for i in range(n) if not gen[i].is_zero())
    gen = [v * gen[piv].inv() for v in gen]
    log('C1  V[triv] = %s' % show(gen, m))
    idx = {t: vbasis(m).index(t) for t in vbasis(m)}
    isid = (gen[idx[(0, 1)]] == ONE and gen[idx[(1, 0)]] == ONE and
            gen[idx[(0, 0)]].is_zero() and gen[idx[(1, 1)]].is_zero())
    log('C1  i.e. the equalizer line is spanned by the IDENTITY of W^-'
        ' (Schur): %s' % ('YES' if isid else 'NO'))
    assert isid

    log('C2  tau|_{W^-} = diag(1,-1) and e even force Lambda DIAGONAL'
        ' -- automatic (tau in K_1).')
    log('C2  rho|_{W^-} has NONZERO off-diagonal entries, so a diagonal'
        ' Lambda commutes with rho')
    log('C2      iff its two diagonal entries are EQUAL.')
    log('C2  ORDER-0 EQUALIZER (branch ii):  Lambda_yy = Lambda_zz .')
    return dict(dimV=n, dim_line=len(L), generator=[repr(v) for v in gen],
                identity=bool(isid))


# =================================================== higher-order jet pattern
def higher_orders(m, e, kmax=4):
    """dim of Im( ev_{v0} : (Sym^k(std^*) ox V ox sgn^e)^{S3} -> V )."""
    n = 2 * (m + 1)
    AV, BV = act_matrix(R, m), act_matrix(TAU, m)
    sgn = ONE if e % 2 == 0 else -ONE
    # dim V^{tau, sgn^e}
    rows = [[BV[i][j] - (sgn if i == j else ZERO) for j in range(n)]
            for i in range(n)]
    dtau = len(nullspace(rows, n))
    out = []
    for k in range(kmax + 1):
        SR, ST = act_matrix_sym(R, k), act_matrix_sym(TAU, k)
        N = (k + 1) * n
        rr = []
        for (MS, MV, sg) in ((SR, AV, ONE), (ST, BV, sgn)):
            for i in range(k + 1):
                for a in range(n):
                    row = [ZERO] * N
                    for j in range(k + 1):
                        for b in range(n):
                            row[j * n + b] = MS[i][j] * MV[a][b]
                    row[i * n + a] = row[i * n + a] - sg
                    rr.append(row)
        ns = nullspace(rr, N)
        # ev_{v0}: v0 = the tau-fixed direction of std; in the basis used here
        # tau = diag(1,-1), so v0 = e_0, and a basis monomial xi0^i xi1^{k-i}
        # (index i) evaluates to 1 at v0 iff i = k.
        img = [[b[k * n + a] for a in range(n)] for b in ns]
        img = [row for row in img if any(not v.is_zero() for v in row)]
        d = rank(img) if img else 0
        out.append((k, len(ns), d, dtau))
    return out, dtau


def act_matrix_sym(M, k):
    """action of g on Sym^k(std^*):  q -> q o g^{-1}, basis xi0^j xi1^{k-j}."""
    Mi = m2inv(M)
    cols = []
    for i in range(k + 1):
        A = binom_expand(Mi[0][0], Mi[0][1], i)
        Bp = binom_expand(Mi[1][0], Mi[1][1], k - i)
        coefs = [ZERO] * (k + 1)
        for j1, c1 in enumerate(A):
            for j2, c2 in enumerate(Bp):
                coefs[j1 + j2] = coefs[j1 + j2] + c1 * c2
        cols.append(coefs)
    return [[cols[j][i] for j in range(k + 1)] for i in range(k + 1)]


def main():
    log('# FIX-H1 producer B -- the S3-equalizer at c_sigma (exact, char 0)')
    log('# field K0 = QQ(om, nu), om^2+om+1 = 0, nu^2 = -11 ; kp = %r' % KP)
    r3 = branch_m3()
    r1 = branch_m1()
    log('')
    log('===== the order-by-order structure of the equalizer =====')
    hh = {}
    for (m, e, tag) in ((3, 3, 'branch (i)  m=3 e=3'),
                        (1, 6, 'branch (ii) m=1 e=6')):
        rows, dtau = higher_orders(m, e, 4)
        log('  %s :  dim V = %d ,  dim V^{tau,sgn^e} = %d'
            % (tag, 2 * (m + 1), dtau))
        for k, dsp, dimg, dt in rows:
            log('      order k = %d : dim(Sym^k(std*) ox V ox sgn^e)^{S3} = %d'
                ' , dim Im(ev_v0) = %d  ->  %d equalizer condition(s)'
                % (k, dsp, dimg, dt - dimg))
        hh[tag] = [[k, dsp, dimg, dt] for k, dsp, dimg, dt in rows]
    log('')
    log('===== the ORDER-1 condition, explicitly =====')
    log('  (needed only for the unclassified positive-line-degree cells: the')
    log('   order-0 condition already decides both classified branches)')
    for (m, e, tag) in ((3, 3, 'branch (i)  m=3 e=3'),
                        (1, 6, 'branch (ii) m=1 e=6')):
        n = 2 * (m + 1)
        img, dtau = order_image(m, e, 1)
        log('  %s : Im(ev_v0) at order 1 is spanned by' % tag)
        for b in img:
            log('      %s' % show(b, m))
        # the linear conditions cutting it out inside V^{tau,sgn^e}
        BV = act_matrix(TAU, m)
        sgn = ONE if e % 2 == 0 else -ONE
        rows = [[BV[i][j] - (sgn if i == j else ZERO) for j in range(n)]
                for i in range(n)]
        vt = nullspace(rows, n)
        log('      inside the %d-dimensional V^{tau,sgn^e}: %d condition(s)'
            % (len(vt), len(vt) - len(img)))
    return dict(m3=r3, m1=r1, higher=hh)


def order_image(m, e, k):
    n = 2 * (m + 1)
    AV, BV = act_matrix(R, m), act_matrix(TAU, m)
    sgn = ONE if e % 2 == 0 else -ONE
    SR, ST = act_matrix_sym(R, k), act_matrix_sym(TAU, k)
    N = (k + 1) * n
    rr = []
    for (MS, MV, sg) in ((SR, AV, ONE), (ST, BV, sgn)):
        for i in range(k + 1):
            for a in range(n):
                row = [ZERO] * N
                for j in range(k + 1):
                    for b in range(n):
                        row[j * n + b] = MS[i][j] * MV[a][b]
                row[i * n + a] = row[i * n + a] - sg
                rr.append(row)
    ns = nullspace(rr, N)
    img = [[b[k * n + a] for a in range(n)] for b in ns]
    img = [row for row in img if any(not v.is_zero() for v in row)]
    R2, piv = rref(img)
    rows2 = [[BV[i][j] - (sgn if i == j else ZERO) for j in range(n)]
             for i in range(n)]
    return [list(r) for r in R2], len(nullspace(rows2, n))


if __name__ == '__main__':
    out = main()
    log('elapsed %.1f s' % (time.time() - T0))
    os.makedirs(os.path.join(HERE, 'payloads'), exist_ok=True)
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_equalizer.txt'),
              'w') as fh:
        fh.write('\n'.join(LOG) + '\n')
    with open(os.path.join(HERE, 'payloads', 'h1_equalizer.json'), 'w') as fh:
        json.dump(out, fh, indent=1)
    print('FIX_H1_EQUALIZER_OK')
