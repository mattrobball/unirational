#!/usr/bin/env python3
"""FIX-L1 INDEPENDENT VERIFIER.

Fully self-contained: implements its own exact number field
    K = Q(om, nu),   om^2+om+1 = 0,  nu^2 = -11        (degree 4 over Q)
from scratch (no klein_exact, no sympy, no group theory, no floating point in
any decision), and rebuilds the whole sigma-frame by a DIFFERENT ROUTE from the
producer:

  producer : PSL(2,11) rebuilt from Weil-representation generators in
             Q(zeta_33); the A_4-adapted frame found by group theory; kp, beta,
             rho|_{W^+} read off the group.
  verifier : NO group at all.  Inputs are only the two CERTIFIED H1 closed
             forms  rho|_{W^-} = [[-1/2,(1-nu)/4],[(-1-nu)/4,-1/2]],
             tau|_{W^-} = diag(1,-1)  and the SHAPE of the V4-packet normal
             form (1.1).  From these:
               * Q : W^+ (x) Sym^2 W^- -> C is an ISOMORPHISM
                 W^+ -> (Sym^2 W^-)^* , so the S3-action on W^+ is FORCED;
               * c_sigma is forced as the preimage of the invariant functional;
               * (kp, km) are forced by S3-invariance of F0.
             beta = -(7+sqrt33)/4 and kp = (13+3 sqrt33)/16 are therefore
             DERIVED here, not assumed.

Then every number in payloads/l1_constants.json is checked, and 40-digit
numerics are printed as a sanity layer.

Exit line:  FIX_L1_VERIFY_OK  (or an AssertionError).
"""
import json
import os
import sys
import time
from fractions import Fraction as F

HERE = os.path.dirname(os.path.abspath(__file__))
T0 = time.time()
LOG = []
NCHECK = [0]


def log(s=''):
    print(s, flush=True)
    LOG.append(s)


def check(cond, msg):
    NCHECK[0] += 1
    if not cond:
        raise AssertionError('CHECK FAILED: ' + msg)


# =========================================================== the field Q(om,nu)
# basis e0 = 1, e1 = om, e2 = nu, e3 = nu*om
_MT = {                                   # e_i * e_j  as a dict index->coeff
    (0, 0): {0: 1}, (0, 1): {1: 1}, (0, 2): {2: 1}, (0, 3): {3: 1},
    (1, 1): {0: -1, 1: -1}, (1, 2): {3: 1}, (1, 3): {2: -1, 3: -1},
    (2, 2): {0: -11}, (2, 3): {1: -11},
    (3, 3): {0: 11, 1: 11},
}
for (i, j), v in list(_MT.items()):
    _MT[(j, i)] = v


class K:
    """exact element of Q(om,nu): c0 + c1 om + c2 nu + c3 nu om"""
    __slots__ = ('c',)

    def __init__(self, c=(0, 0, 0, 0)):
        self.c = tuple(F(x) for x in c)

    @staticmethod
    def rat(p, q=1):
        return K((F(p, q), 0, 0, 0))

    def is_zero(self):
        return all(x == 0 for x in self.c)

    def __bool__(self):
        return not self.is_zero()

    def __eq__(self, o):
        if isinstance(o, int):
            o = K.rat(o)
        return self.c == o.c

    def __hash__(self):
        return hash(self.c)

    def __neg__(self):
        return K(tuple(-x for x in self.c))

    def __add__(self, o):
        if isinstance(o, int):
            o = K.rat(o)
        return K(tuple(a + b for a, b in zip(self.c, o.c)))

    __radd__ = __add__

    def __sub__(self, o):
        if isinstance(o, int):
            o = K.rat(o)
        return K(tuple(a - b for a, b in zip(self.c, o.c)))

    def __rsub__(self, o):
        return (-self) + o

    def __mul__(self, o):
        if isinstance(o, int):
            return K(tuple(x * o for x in self.c))
        out = [F(0)] * 4
        for i, a in enumerate(self.c):
            if a == 0:
                continue
            for j, b in enumerate(o.c):
                if b == 0:
                    continue
                for k, m in _MT[(i, j)].items():
                    out[k] += a * b * m
        return K(tuple(out))

    __rmul__ = __mul__

    def __pow__(self, e):
        r, b = ONEK, self
        while e:
            if e & 1:
                r = r * b
            b = b * b
            e >>= 1
        return r

    def _mulmat(self):
        cols = []
        for j in range(4):
            ej = K(tuple(1 if k == j else 0 for k in range(4)))
            cols.append((self * ej).c)
        return [[cols[j][i] for j in range(4)] for i in range(4)]

    def inv(self):
        if self.is_zero():
            raise ZeroDivisionError
        M = self._mulmat()
        aug = [list(M[i]) + [F(1) if i == 0 else F(0)] for i in range(4)]
        sol = _gauss(aug, 4)
        return K(tuple(sol))

    def __truediv__(self, o):
        if isinstance(o, int):
            return K(tuple(x / F(o) for x in self.c))
        return self * o.inv()

    def num(self, prec=40):
        """40-digit complex value (mpmath), om = e^{2 pi i/3}, nu = +i sqrt11."""
        from mpmath import mp, mpf, mpc, sqrt
        mp.dps = prec
        om = mpc(mpf(-1) / 2, sqrt(mpf(3)) / 2)
        nu = mpc(0, sqrt(mpf(11)))
        v = [mpc(1), om, nu, nu * om]
        return sum(mpc(int(x.numerator)) / int(x.denominator) * v[i]
                   for i, x in enumerate(self.c))

    def __repr__(self):
        names = ['', '*om', '*nu', '*nu*om']
        parts = []
        for x, nm in zip(self.c, names):
            if x == 0:
                continue
            parts.append('%s%s' % (x, nm))
        return ' + '.join(parts) if parts else '0'


def _gauss(aug, n):
    M = [row[:] for row in aug]
    piv, r = [], 0
    for c in range(n):
        pr = None
        for rr in range(r, len(M)):
            if M[rr][c] != 0:
                pr = rr
                break
        if pr is None:
            continue
        M[r], M[pr] = M[pr], M[r]
        iv = F(1) / M[r][c]
        M[r] = [x * iv for x in M[r]]
        for rr in range(len(M)):
            if rr != r and M[rr][c] != 0:
                f = M[rr][c]
                M[rr] = [x - f * y for x, y in zip(M[rr], M[r])]
        piv.append(c)
        r += 1
    sol = [F(0)] * n
    for i, c in enumerate(piv):
        sol[c] = M[i][n]
    return sol


ZEROK = K()
ONEK = K.rat(1)
OM = K((0, 1, 0, 0))
OM2 = K((-1, -1, 0, 0))
NU = K((0, 0, 1, 0))
DELTA = OM - OM2                    # = 1 + 2om
R33 = -(NU * DELTA)                 # = -nu - 2 nu om


def kfrom(c1, cw, cnu, c33):
    """c1 + cw om + cnu nu + c33 sqrt33 as an element of K."""
    return (K.rat(c1) + K.rat(cw) * OM + K.rat(cnu) * NU + K.rat(c33) * R33)


# =============================================== generic exact linear algebra
def rref(rows):
    M = [list(r) for r in rows]
    if not M:
        return [], []
    nc = len(M[0])
    piv, r = [], 0
    for c in range(nc):
        pr = None
        for rr in range(r, len(M)):
            if M[rr][c]:
                pr = rr
                break
        if pr is None:
            continue
        M[r], M[pr] = M[pr], M[r]
        iv = M[r][c].inv()
        M[r] = [x * iv for x in M[r]]
        for rr in range(len(M)):
            if rr != r and M[rr][c]:
                f = M[rr][c]
                M[rr] = [x - f * y for x, y in zip(M[rr], M[r])]
        piv.append(c)
        r += 1
        if r == len(M):
            break
    return M[:r], piv


def rank(rows):
    return len(rref(rows)[1])


def nullspace(rows, ncol):
    if not rows:
        return [[ONEK if i == j else ZEROK for i in range(ncol)]
                for j in range(ncol)]
    R, piv = rref(rows)
    free = [c for c in range(ncol) if c not in piv]
    out = []
    for fc in free:
        v = [ZEROK] * ncol
        v[fc] = ONEK
        for i, pc in enumerate(piv):
            v[pc] = -R[i][fc]
        out.append(v)
    return out


# --------------------------------------------------------------- binary forms
def bfz(d):
    return [ZEROK] * (d + 1)


def bfadd(f, g):
    return [a + b for a, b in zip(f, g)]


def bfscal(f, c):
    return [a * c for a in f]


def bfmul(f, g):
    out = [ZEROK] * (len(f) + len(g) - 1)
    for i, a in enumerate(f):
        if a:
            for j, b in enumerate(g):
                if b:
                    out[i + j] = out[i + j] + a * b
    return out


def bfzero(f):
    return all(c.is_zero() for c in f)


def bfsubs(f, N):
    d = len(f) - 1
    L1, L2 = [N[0][0], N[0][1]], [N[1][0], N[1][1]]
    out = bfz(d)
    for k, c in enumerate(f):
        if not c:
            continue
        t = [ONEK]
        for _ in range(d - k):
            t = bfmul(t, L1)
        for _ in range(k):
            t = bfmul(t, L2)
        out = bfadd(out, bfscal(t, c))
    return out


def m2inv(M):
    det = M[0][0] * M[1][1] - M[0][1] * M[1][0]
    di = det.inv()
    return [[M[1][1] * di, -M[0][1] * di], [-M[1][0] * di, M[0][0] * di]]


def sym2_act(M, S):
    s11, s12, s22 = S
    E = [[s11, s12], [s12, s22]]
    out = [[ZEROK, ZEROK], [ZEROK, ZEROK]]
    for i in range(2):
        for j in range(2):
            acc = ZEROK
            for k in range(2):
                for l in range(2):
                    acc = acc + M[i][k] * E[k][l] * M[j][l]
            out[i][j] = acc
    return [out[0][0], out[0][1], out[1][1]]


def invariants_of(action, dim, mats, signs):
    eqs = []
    for M, sg in zip(mats, signs):
        cols = []
        for e in range(dim):
            b = [ZEROK] * dim
            b[e] = ONEK
            cols.append(action(M, b))
        for r in range(dim):
            eqs.append([cols[e][r] - (K.rat(sg) if e == r else ZEROK)
                        for e in range(dim)])
    return nullspace(eqs, dim)


# ============================================================ self-test of K
def selftest():
    log('== 0.  self-test of the exact field Q(om,nu) ==')
    check(OM * OM + OM + ONEK == ZEROK, 'om^2+om+1 = 0')
    check(NU * NU == K.rat(-11), 'nu^2 = -11')
    check(DELTA * DELTA == K.rat(-3), 'delta^2 = -3')
    check(R33 * R33 == K.rat(33), 'sqrt33^2 = 33')
    check(OM ** 3 == ONEK, 'om^3 = 1')
    for x in (OM, NU, DELTA, R33, kfrom(3, -2, F(5, 7), F(-1, 3)),
              kfrom(0, 1, 1, 1)):
        check(x * x.inv() == ONEK, 'inverse of %r' % x)
    check((R33 + K.rat(1)) * (R33 - K.rat(1)) == K.rat(32), 'sqrt33^2-1 = 32')
    # numeric embedding sanity
    from mpmath import mp, mpf, sqrt
    mp.dps = 40
    check(abs(R33.num() - sqrt(mpf(33))) < mpf(10) ** -35,
          'sqrt33 embeds to the positive real root')
    check(abs(NU.num().real) < mpf(10) ** -35 and NU.num().imag > 0,
          'nu embeds to +i sqrt 11')
    log('0   %d field self-tests passed; the embedding is '
        'om = e^{2 pi i/3}, nu = +i sqrt(11), sqrt33 = -nu.delta = +5.744...'
        % NCHECK[0])
    log('')


# ================================================== the independent rebuild
def rebuild():
    log('== 1.  independent rebuild of the sigma-frame (NO group theory) ==')
    Rm = [[K.rat(-1, 2), (ONEK - NU) / 4], [(-ONEK - NU) / 4, K.rat(-1, 2)]]
    Tm = [[ONEK, ZEROK], [ZEROK, -ONEK]]
    log('1a  INPUT (certified, FIX-H1 payload A4): rho|_{W^-} = '
        '[[-1/2,(1-nu)/4],[(-1-nu)/4,-1/2]] , tau|_{W^-} = diag(1,-1)')
    check(Rm[0][0] + Rm[1][1] == -ONEK, 'trace rho|W^- = -1')
    check(Rm[0][0] * Rm[1][1] - Rm[0][1] * Rm[1][0] == ONEK, 'det rho|W^- = 1')
    # rho^3 = 1, tau^2 = 1, (rho tau)^2 = 1
    def mm(A, B):
        return [[sum((A[i][k] * B[k][j] for k in range(2)), ZEROK)
                 for j in range(2)] for i in range(2)]
    I2 = [[ONEK, ZEROK], [ZEROK, ONEK]]
    check(mm(mm(Rm, Rm), Rm) == I2, 'rho^3 = 1')
    check(mm(Tm, Tm) == I2, 'tau^2 = 1')
    check(mm(mm(Tm, Rm), mm(Tm, Rm)) == I2, '(tau rho)^2 = 1')
    log('1a  rho^3 = tau^2 = (tau rho)^2 = 1, trace = -1, det = 1: W^- = std '
        'as an S3-rep  VERIFIED')

    # Q from the SHAPE of normal form (1.1)
    def Qpair(w, S):
        a, b, x = w
        return (a * (OM * S[0] + OM2 * S[2]) + b * (OM2 * S[0] + OM * S[2])
                + x * S[1])

    PHI = [[OM, OM2, ZEROK], [ZEROK, ZEROK, ONEK], [OM2, OM, ZEROK]]
    # PHI[r][col]: Q(w;S) = sum_r PHI-row . w * S_r  -> matrix of w |-> Q(w;.)
    detPHI = (PHI[0][0] * (PHI[1][1] * PHI[2][2] - PHI[1][2] * PHI[2][1])
              - PHI[0][1] * (PHI[1][0] * PHI[2][2] - PHI[1][2] * PHI[2][0])
              + PHI[0][2] * (PHI[1][0] * PHI[2][1] - PHI[1][1] * PHI[2][0]))
    check(not detPHI.is_zero(), 'Q : W^+ -> (Sym^2 W^-)^* is an isomorphism')
    log('1b  Q(w;S) = a(om S11 + om^2 S22) + b(om^2 S11 + om S22) + x S12 '
        '(shape of normal form (1.1))')
    log('1b  the induced map W^+ -> (Sym^2 W^-)^* has det = %r != 0: it is an '
        'ISOMORPHISM.' % detPHI)
    log('1b  Hence the S3-action on W^+ is FORCED by Q-invariance from '
        'rho|_{W^-}, tau|_{W^-}.')

    def induced_Wplus(M):
        """the unique M3 with Q(M3 w ; M S M^T) = Q(w;S) for all w,S."""
        eqs, rhs = [], []
        cols = []
        for j in range(3):
            wj = [ZEROK] * 3
            wj[j] = ONEK
            cols.append(wj)
        # unknowns: the 9 entries of M3 (column-major); equations from
        # Q(M3 e_j ; M S_r M^T) = Q(e_j ; S_r) for j=0..2, r=0..2
        Ssb = []
        for r in range(3):
            b = [ZEROK] * 3
            b[r] = ONEK
            Ssb.append(b)
        rows, rr = [], []
        for j in range(3):
            for r in range(3):
                gS = sym2_act(M, Ssb[r])
                row = [ZEROK] * 9
                for i in range(3):
                    ei = [ZEROK] * 3
                    ei[i] = ONEK
                    row[3 * j + i] = Qpair(ei, gS)
                rows.append(row)
                rr.append(Qpair(cols[j], Ssb[r]))
        # solve rows . vec = rr  (9 unknowns, 9 equations)
        aug = [rows[i] + [rr[i]] for i in range(9)]
        R, piv = rref(aug)
        check(len(piv) == 9 and 9 not in piv,
              'the induced W^+-action is uniquely determined')
        sol = [ZEROK] * 9
        for i, c in enumerate(piv):
            sol[c] = R[i][9]
        return [[sol[3 * j + i] for j in range(3)] for i in range(3)]

    Mrp = induced_Wplus(Rm)
    Mtp = induced_Wplus(Tm)
    check(Mtp == [[ONEK, ZEROK, ZEROK], [ZEROK, ONEK, ZEROK],
                  [ZEROK, ZEROK, -ONEK]],
          'induced tau|_{W^+} = diag(1,1,-1)  (matches the certified frame)')
    log('1c  induced tau|_{W^+} = diag(1,1,-1)  -- agrees with the certified '
        'frame  VERIFIED')
    log('1c  induced rho|_{W^+} =')
    for i in range(3):
        log('       [ %s ]' % ' , '.join(kstr(Mrp[i][j]) for j in range(3)))

    def mm3(A, B):
        return [[sum((A[i][k] * B[k][j] for k in range(3)), ZEROK)
                 for j in range(3)] for i in range(3)]

    I3 = [[ONEK if i == j else ZEROK for j in range(3)] for i in range(3)]
    check(mm3(mm3(Mrp, Mrp), Mrp) == I3, 'rho|_{W^+}^3 = 1')
    check(mm3(Mtp, Mtp) == I3, 'tau|_{W^+}^2 = 1')
    tr = Mrp[0][0] + Mrp[1][1] + Mrp[2][2]
    check(tr == ZEROK, 'trace rho|_{W^+} = 0  (W^+ = triv (+) std)')
    log('1c  rho|_{W^+}^3 = 1, trace = 0  ->  W^+ = triv (+) std  VERIFIED')

    # c_sigma = the S3-fixed line of W^+
    eqs = []
    for M in (Mrp, Mtp):
        for i in range(3):
            eqs.append([M[i][j] - (ONEK if i == j else ZEROK)
                        for j in range(3)])
    fx = nullspace(eqs, 3)
    check(len(fx) == 1, 'dim (W^+)^{S3} = 1')
    cS = [c / fx[0][0] for c in fx[0]]
    beta = cS[1]
    check(cS[2].is_zero(), 'c_sigma lies on ell_V (x = 0)')
    check(beta == -(K.rat(7) + R33) / 4,
          'DERIVED beta = -(7+sqrt33)/4')
    log('1d  c_sigma = (W^+)^{S3}, normalised a = 1 :  DERIVED  '
        'beta = -(7+sqrt33)/4   (NOT assumed)')

    # (kp,km) forced by S3-invariance of F0
    kp, km = solve_F0(Mrp, Mtp)
    check(kp == (K.rat(13) + K.rat(3) * R33) / 16, 'kp = (13+3 sqrt33)/16')
    check(km == (K.rat(13) - K.rat(3) * R33) / 16, 'km = (13-3 sqrt33)/16')
    check(kp + km == K.rat(13, 8) and kp * km == K.rat(-1, 2),
          'kp+km = 13/8, kp.km = -1/2')
    log('1e  (kp,km) forced by S3-invariance of F0 = kp a^3 + km b^3 + '
        '(a+b)x^2 :  DERIVED  kp = (13+3 sqrt33)/16, km = (13-3 sqrt33)/16')
    check((beta ** 3 + K.rat(3) * beta ** 2 + kp).is_zero(),
          'beta^3 + 3 beta^2 + kp = 0')
    cheb = -ONEK - beta
    check(cheb == (K.rat(3) + R33) / 4, 'c = (3+sqrt33)/4')
    check((cheb ** 3 - K.rat(3) * cheb - (kp + K.rat(2))).is_zero(),
          'c^3 - 3c = kp + 2  (the Chebyshev cubic)')
    log('1e  consistency: beta^3+3beta^2+kp = 0 and c = -(1+beta) = '
        '(3+sqrt33)/4 satisfies c^3-3c = kp+2  VERIFIED')
    log('')
    return dict(Rm=Rm, Tm=Tm, Mrp=Mrp, Mtp=Mtp, cS=cS, beta=beta, kp=kp,
                km=km, cheb=cheb, Qpair=Qpair)


def solve_F0(Mrp, Mtp):
    """the unique (kp,km) making F0 = kp a^3 + km b^3 + (a+b) x^2 invariant."""
    # monomials of degree 3 in (a,b,x)
    monos = [(i, j, 3 - i - j) for i in range(4) for j in range(4 - i)]
    idx = {m: k for k, m in enumerate(monos)}

    def subs(coeffs, M):
        """coeffs: dict mono->K ; substitute v -> M v."""
        lin = []
        for i in range(3):
            lin.append({(1 if k == 0 else 0, 1 if k == 1 else 0,
                         1 if k == 2 else 0): M[i][k]
                        for k in range(3) if M[i][k]})
        out = {}
        for m, c in coeffs.items():
            cur = {(0, 0, 0): c}
            for i, e in enumerate(m):
                for _ in range(e):
                    nxt = {}
                    for m1, c1 in cur.items():
                        for m2, c2 in lin[i].items():
                            mm_ = tuple(a + b for a, b in zip(m1, m2))
                            nxt[mm_] = nxt.get(mm_, ZEROK) + c1 * c2
                    cur = nxt
            for m1, c1 in cur.items():
                out[m1] = out.get(m1, ZEROK) + c1
        return {m: c for m, c in out.items() if not c.is_zero()}

    # unknowns u0 = kp, u1 = km ; F0 = u0 a^3 + u1 b^3 + a x^2 + b x^2
    base = {(1, 0, 2): ONEK, (0, 1, 2): ONEK}
    eqs = []
    for M in (Mrp, Mtp):
        cols = []
        for u in range(2):
            c = {(3, 0, 0): ONEK} if u == 0 else {(0, 3, 0): ONEK}
            d = subs(c, M)
            cols.append({m: d.get(m, ZEROK) - c.get(m, ZEROK) for m in monos})
        d0 = subs(base, M)
        rhsm = {m: base.get(m, ZEROK) - d0.get(m, ZEROK) for m in monos}
        for m in monos:
            eqs.append([cols[0][m], cols[1][m], rhsm[m]])
    R, piv = rref(eqs)
    assert piv[:2] == [0, 1] and 2 not in piv, 'F0 invariance underdetermined'
    return R[0][2], R[1][2]


def kstr(x):
    """print x in the basis 1, om, nu, sqrt33 when possible."""
    c0, c1, c2, c3 = x.c
    # nu*om = -(nu + sqrt33)/2  =>  c2 nu + c3 nu om = (c2 - c3/2) nu
    #                                                 - (c3/2) sqrt33
    parts = []
    for c, nm in ((c0, ''), (c1, '*om'), (c2 - c3 / 2, '*nu'),
                  (-c3 / 2, '*sqrt33')):
        if c == 0:
            continue
        parts.append('%s%s' % (c, nm))
    return ' + '.join(parts).replace('+ -', '- ') if parts else '0'


# ================================================== reading the producer JSON
def load_payload():
    p = os.path.join(HERE, 'payloads', 'l1_constants.json')
    with open(p) as fh:
        return json.load(fh)


def fromjson(entry):
    """K-element from the producer's K4 = [c1, cw, cnu, c33] strings."""
    if entry.get('K4') is None:
        return None
    c1, cw, cnu, c33 = [F(s) for s in entry['K4']]
    return kfrom(c1, cw, cnu, c33)


# ============================================================ the verification
def main():
    log('# FIX-L1 INDEPENDENT VERIFIER')
    log('# self-contained exact field Q(om,nu); frame rebuilt WITHOUT group '
        'theory')
    log('')
    selftest()
    FRM = rebuild()
    Rm, Tm, Mrp, Mtp = FRM['Rm'], FRM['Tm'], FRM['Mrp'], FRM['Mtp']
    cS, beta, kp, km, cheb = (FRM['cS'], FRM['beta'], FRM['kp'], FRM['km'],
                              FRM['cheb'])
    Qpair = FRM['Qpair']
    P = load_payload()

    log('== 2.  the frame constants ==')
    check(fromjson(P['frame']['kp']) == kp, 'payload kp')
    check(fromjson(P['frame']['km']) == km, 'payload km')
    check(fromjson(P['frame']['beta_c_sigma']) == beta, 'payload beta')
    check(fromjson(P['frame']['chebyshev_c']) == cheb, 'payload c')
    for i in range(2):
        for j in range(2):
            check(fromjson(P['frame']['rho_Wminus'][i][j]) == Rm[i][j],
                  'payload rho|W^-')
            check(fromjson(P['frame']['tau_Wminus'][i][j]) == Tm[i][j],
                  'payload tau|W^-')
    for i in range(3):
        for j in range(3):
            check(fromjson(P['frame']['rho_Wplus'][i][j]) == Mrp[i][j],
                  'payload rho|W^+ [%d][%d]' % (i, j))
            check(fromjson(P['frame']['tau_Wplus'][i][j]) == Mtp[i][j],
                  'payload tau|W^+')
    log('2a  kp, km, beta, c, rho|W^-, tau|W^-, rho|W^+, tau|W^+  all MATCH '
        'the producer payload  (rho|W^+ independently DERIVED here)')

    F0c = kp + km * beta ** 3
    check(F0c == (K.rat(81) + K.rat(15) * R33) / 16, 'F0(c_sigma)')
    check(F0c == cheb ** 3, 'F0(c_sigma) = c^3')
    check(not F0c.is_zero(), 'F(c_sigma) != 0')
    check(fromjson(P['F0_c_sigma']) == F0c, 'payload F0(c_sigma)')
    log('2b  F(c_sigma) = F0(c_sigma) = kp + km beta^3 = (81+15 sqrt33)/16 '
        '= c^3 != 0  VERIFIED  (A3 split reproduces the H1 fact)')

    # A3 shape: reconstruct F and split it
    Fnf = {(3, 0, 0, 0, 0): kp, (0, 3, 0, 0, 0): km,
           (1, 0, 2, 0, 0): ONEK, (1, 0, 0, 2, 0): OM, (1, 0, 0, 0, 2): OM2,
           (0, 1, 2, 0, 0): ONEK, (0, 1, 0, 2, 0): OM2, (0, 1, 0, 0, 2): OM,
           (0, 0, 1, 1, 1): ONEK}
    degs = sorted({e[3] + e[4] for e in Fnf})
    check(degs == [0, 2], 'A3 shape: only (y,z)-degrees 0 and 2 occur')
    log('2c  A3 shape re-verified: F(w+y) = F0(w) + Q(w;y,y), no (y,z)-degree '
        '1 or 3 terms.')

    Om_sp = invariants_of(sym2_act, 3, [Rm, Tm], [1, 1])
    check(len(Om_sp) == 1, 'dim (Sym^2 W^-)[triv] = 1')
    Om = [c / Om_sp[0][0] * (ONEK - NU) for c in Om_sp[0]]
    check(Om == [ONEK - NU, ZEROK, ONEK + NU], 'Omega = diag(1-nu,1+nu)')

    def form_act(M, S):
        return sym2_act([[M[j][i] for j in range(2)] for i in range(2)], S)

    q0_sp = invariants_of(form_act, 3, [Rm, Tm], [1, 1])
    check(len(q0_sp) == 1, 'dim Sym^2(W^-)^*[triv] = 1')
    q0 = [c / q0_sp[0][0] * (ONEK + NU) for c in q0_sp[0]]
    check(q0 == [ONEK + NU, ZEROK, ONEK - NU], 'q0 = (1+nu)y^2+(1-nu)z^2')
    check(q0[0] * Om[0] + q0[2] * Om[2] == K.rat(24), '<q0,Omega> = 24')
    for i in range(3):
        check(fromjson(P['Omega'][i]) == Om[i], 'payload Omega')
        check(fromjson(P['q0'][i]) == q0[i], 'payload q0')
    log('2d  Omega = diag(1-nu,1+nu), q0 = (1+nu)y^2+(1-nu)z^2, <q0,Omega> = 24'
        '   MATCH')

    ell = [Qpair([ONEK, ZEROK, ZEROK], Om), Qpair([ZEROK, ONEK, ZEROK], Om),
           Qpair([ZEROK, ZEROK, ONEK], Om)]
    check(ell == [R33 - ONEK, -(ONEK + R33), ZEROK], 'ell closed form')
    alpha = Qpair(cS, Om)
    check(alpha == K.rat(9) + K.rat(3) * R33, 'alpha = 9 + 3 sqrt33')
    check(alpha == K.rat(12) * cheb, 'alpha = 12 c')
    check(alpha == K.rat(16) * kp - K.rat(4), 'alpha = 16 kp - 4')
    check(not alpha.is_zero(), 'alpha != 0')
    check(fromjson(P['alpha']) == alpha, 'payload alpha')
    log('2e  alpha = Q(c_sigma;Omega) = 9 + 3 sqrt33 = 12 c = 16 kp - 4 ;  '
        'alpha != 0   MATCH')
    log('2e     alpha^3 = 1728 . F(c_sigma), so alpha = 0 <=> c_sigma in X : '
        'independently re-derived.')
    check(alpha ** 3 == K.rat(1728) * F0c, 'alpha^3 = 1728 F(c_sigma)')

    u_p = [ONEK + R33, R33 - ONEK, ZEROK]
    u_m = [ZEROK, ZEROK, ONEK]
    v_p = [ONEK - NU, ZEROK, -(ONEK + NU)]
    v_m = [ZEROK, ONEK, ZEROK]
    for u in (u_p, u_m):
        check(sum((ell[i] * u[i] for i in range(3)), ZEROK).is_zero(),
              'u in ker(ell)')
        check(Qpair(u, Om).is_zero(), 'Q(std; Omega) = 0')
    for v in (v_p, v_m):
        check(Qpair(cS, v).is_zero(), 'Q(c_sigma; std) = 0')
    QB = [[Qpair(u, v) for v in (v_p, v_m)] for u in (u_p, u_m)]
    check(QB[0][0] == K.rat(24) * DELTA and QB[1][1] == ONEK
          and QB[0][1].is_zero() and QB[1][0].is_zero(), 'std block of Q')
    betaC = QB[1][1]
    check(betaC == ONEK and not betaC.is_zero(), 'beta = 1 != 0')
    check(fromjson(P['beta_const']) == betaC, 'payload beta')
    for i in range(2):
        for j in range(2):
            check(fromjson(P['std_block'][i][j]) == QB[i][j],
                  'payload std_block')
    log('2f  std-block of Q = [[24 delta, 0],[0, 1]] : PERFECT pairing; '
        'beta = 1 != 0   MATCH')

    # -------------------------------------------------------------- generators
    log('')
    log('== 3.  generators of V_m[triv], V_m[sgn] ==')

    def Vm_act(M, m, L):
        Mi = m2inv(M)
        Pp, Rr = bfsubs(L[0], Mi), bfsubs(L[1], Mi)
        return (bfadd(bfscal(Pp, M[0][0]), bfscal(Rr, M[0][1])),
                bfadd(bfscal(Pp, M[1][0]), bfscal(Rr, M[1][1])))

    def Vm_iso(m, tw):
        bas = []
        for comp in (0, 1):
            for k in range(m + 1):
                Pp, Rr = bfz(m), bfz(m)
                (Pp if comp == 0 else Rr)[k] = ONEK
                bas.append((Pp, Rr))
        n = len(bas)
        eqs = []
        for M, sg in ((Rm, 1), (Tm, tw)):
            cols = []
            for L in bas:
                gl = Vm_act(M, m, L)
                cols.append(list(gl[0]) + list(gl[1]))
            for r in range(2 * (m + 1)):
                eqs.append([cols[e][r] - (K.rat(sg) if e == r else ZEROK)
                            for e in range(n)])
        out = []
        for v in nullspace(eqs, n):
            Pp, Rr = bfz(m), bfz(m)
            for e, c in enumerate(v):
                if c:
                    Pp = bfadd(Pp, bfscal(bas[e][0], c))
                    Rr = bfadd(Rr, bfscal(bas[e][1], c))
            out.append((Pp, Rr))
        return out

    GEN = {}
    for m in (1, 3):
        for tw, nm in ((1, 'triv'), (-1, 'sgn')):
            sp = Vm_iso(m, tw)
            pred = ((m + 1) - {0: 1, 1: -1, 2: 0}[m % 3]) // 3
            check(len(sp) == pred == 1,
                  'dim V_%d[%s] = 1 (Lemma 5.1)' % (m, nm))
            g = sp[0]
            flat = list(g[0]) + list(g[1])
            piv = next(c for c in flat if c)
            GEN[(m, nm)] = (bfscal(g[0], piv.inv()), bfscal(g[1], piv.inv()))
    check(GEN[(1, 'triv')] == ([ONEK, ZEROK], [ZEROK, ONEK]),
          'V_1[triv] = <id>')
    check(GEN[(1, 'sgn')] == ([ZEROK, ONEK], [(K.rat(5) - NU) / 6, ZEROK]),
          'V_1[sgn] = <[[0,1],[(5-nu)/6,0]]>')
    h1 = (bfz(3), bfz(3))
    h1[0][3] = ONEK
    h1[0][1] = (-K.rat(5) + NU) / 6
    h1[1][2] = (K.rat(5) - NU) / 6
    h1[1][0] = (-K.rat(7) + K.rat(5) * NU) / 18
    check(proportional(list(GEN[(3, 'sgn')][0]) + list(GEN[(3, 'sgn')][1]),
                       h1[0] + h1[1]),
          'V_3[sgn] proportional to the FIX-H1 generator')
    GEN[(3, 'sgn')] = h1
    log('3a  dim V_m[triv] = dim V_m[sgn] = 1 for m = 1, 3  (Lemma 5.1)  '
        'VERIFIED')
    log('3b  V_1[triv] = <id> ;  V_1[sgn] = <[[0,1],[(5-nu)/6,0]]> '
        '(off-diagonal)   MATCH')
    log('3c  V_3[sgn] proportional to the FIX-H1 PAYLOAD generator   MATCH')
    for k in GEN:
        key = 'm%d_%s' % k
        pj = P['generators'][key]
        for i, c in enumerate(GEN[k][0]):
            check(fromjson(pj['P'][i]) == c, 'payload gen P %s' % key)
        for i, c in enumerate(GEN[k][1]):
            check(fromjson(pj['R'][i]) == c, 'payload gen R %s' % key)
    log('3d  all four generators match the producer payload coefficient by '
        'coefficient')

    # ------------------------------------------------------------- transfer
    log('')
    log('== 4.  transfer data and the nondegeneracy verdicts ==')

    def split(S):
        t = [(q0[0] * a + q0[2] * b) / 24 for a, b in zip(S[0], S[2])]
        cp = [(a - c * Om[0]) / (ONEK - NU) for a, c in zip(S[0], t)]
        for a, c, e in zip(S[2], t, cp):
            check((a - c * Om[2] + e * (ONEK + NU)).is_zero(),
                  'std split of Sym^2 W^- is consistent')
        return t, cp, list(S[1])

    def Wp_act(M3, Mm, TH):
        Mi = m2inv(Mm)
        C_ = [bfsubs(TH[i], Mi) for i in range(3)]
        return [bfadd(bfadd(bfscal(C_[0], M3[i][0]), bfscal(C_[1], M3[i][1])),
                      bfscal(C_[2], M3[i][2])) for i in range(3)]

    def Theta_inv(k):
        bas = []
        for comp in range(3):
            for j in range(k + 1):
                TH = [bfz(k) for _ in range(3)]
                TH[comp][j] = ONEK
                bas.append(TH)
        n = len(bas)
        eqs = []
        for M3, Mm in ((Mrp, Rm), (Mtp, Tm)):
            cols = []
            for TH in bas:
                gt = Wp_act(M3, Mm, TH)
                cols.append(gt[0] + gt[1] + gt[2])
            for r in range(3 * (k + 1)):
                eqs.append([cols[e][r] - (ONEK if e == r else ZEROK)
                            for e in range(n)])
        out = []
        for v in nullspace(eqs, n):
            TH = [bfz(k) for _ in range(3)]
            for e, c in enumerate(v):
                if c:
                    for i in range(3):
                        TH[i] = bfadd(TH[i], bfscal(bas[e][i], c))
            out.append(TH)
        return out

    def bf_inv(d):
        eqs = []
        for M, sg in ((Rm, 1), (Tm, 1)):
            Mi = m2inv(M)
            cols = []
            for k in range(d + 1):
                f = bfz(d)
                f[k] = ONEK
                cols.append(bfsubs(f, Mi))
            for r in range(d + 1):
                eqs.append([cols[e][r] - (K.rat(sg) if e == r else ZEROK)
                            for e in range(d + 1)])
        return nullspace(eqs, d + 1)

    SUMM = []
    for key in ((1, 'triv'), (1, 'sgn'), (3, 'triv'), (3, 'sgn')):
        m, nm = key
        Pp, Rr = GEN[key]
        S = [bfmul(Pp, Pp), bfmul(Pp, Rr), bfmul(Rr, Rr)]
        t, cp, cm = split(S)
        pj = P['transfer']['m%d_%s' % key]
        for i, c in enumerate(t):
            check(fromjson(pj['gg_t'][i]) == c, 'payload gg_t %s' % (key,))
        for i, c in enumerate(cp):
            check(fromjson(pj['gg_s_vplus'][i]) == c, 'payload gg_s v+')
        for i, c in enumerate(cm):
            check(fromjson(pj['gg_s_vminus'][i]) == c, 'payload gg_s v-')
        nz_t = not bfzero(t)
        nz_s = not (bfzero(cp) and bfzero(cm))
        check(nz_t or nz_s, '(alpha (gg)_t, beta (gg)_s) != (0,0)')

        k = m + 1
        TH_sp = Theta_inv(k)
        tinv = bf_inv(k)
        check(len(TH_sp) == pj['dimTheta'], 'dim Hom(Sym^%d W^-,W^+)^{S3}' % k)
        check(len(tinv) == pj['n_tchannel'], 't-channel dimension')
        tchan = [[bfscal(f, cS[0]), bfscal(f, cS[1]), bfz(k)] for f in tinv]
        eqs = []
        for j in range(k + 1):
            eqs.append([ell[0] * TH[0][j] + ell[1] * TH[1][j]
                        + ell[2] * TH[2][j] for TH in TH_sp])
        schan = []
        for v in nullspace(eqs, len(TH_sp)):
            TH = [bfz(k) for _ in range(3)]
            for e, c in enumerate(v):
                if c:
                    for i in range(3):
                        TH[i] = bfadd(TH[i], bfscal(TH_sp[e][i], c))
            schan.append(TH)
        check(len(schan) == pj['n_schannel'], 's-channel dimension')

        def value(TH):
            A_, B_, X_ = TH
            return bfadd(bfadd(
                bfmul(A_, bfadd(bfscal(S[0], OM), bfscal(S[2], OM2))),
                bfmul(B_, bfadd(bfscal(S[0], OM2), bfscal(S[2], OM)))),
                bfmul(X_, S[1]))

        # sec.5.8 bookkeeping, independently
        for f, TH in zip(tinv, tchan):
            check(value(TH) == [alpha * c for c in bfmul(f, t)],
                  't-channel = alpha . f . (gg)_t')
        for TH in schan:
            Ap = [c / (ONEK + R33) for c in TH[0]]
            check(all((b - a * (R33 - ONEK)).is_zero()
                      for a, b in zip(Ap, TH[1])), 's-channel lands in std')
            Am = list(TH[2])
            want = [betaC * c for c in bfadd(
                bfscal(bfmul(Ap, cp), K.rat(24) * DELTA), bfmul(Am, cm))]
            check(value(TH) == want,
                  's-channel = beta.[24 delta A+ (gg)_{v+} + A- (gg)_{v-}]')
        rows = [value(TH) for TH in tchan + schan]
        rk = rank(rows)
        check(rk == pj['rank'], 'transfer rank for %s' % (key,))
        ker = nullspace([[rows[i][j] for i in range(len(rows))]
                         for j in range(3 * m + 2)], len(rows))
        check(len(ker) == pj['kerdim'], 'transfer kernel dim')
        check(rk > 0, 'transfer condition NONVACUOUS for %s' % (key,))
        tnz = [not bfzero(rows[i]) for i in range(len(tinv))]
        snz = [not bfzero(rows[len(tinv) + j]) for j in range(len(schan))]
        check(tnz == pj['t_image_nonzero'], 't-image nonzero flags')
        check(snz == pj['s_image_nonzero'], 's-image nonzero flags')
        SUMM.append((m, nm, len(TH_sp), rk, len(ker), nz_t, nz_s))
        log('4   m=%d %-5s : dim Theta-space %d , transfer rank %d , solution '
            'dim %d , (gg)_t %s , (gg)_s %s , NONVACUOUS'
            % (m, nm, len(TH_sp), rk, len(ker),
               'nonzero' if nz_t else 'ZERO', 'nonzero' if nz_s else 'ZERO'))

    # ------------------------------------------------------- 40-digit numerics
    log('')
    log('== 5.  40-digit numerics (sanity layer, decisions are exact) ==')
    from mpmath import mp, mpf, sqrt
    mp.dps = 40
    items = [('sqrt33', R33, sqrt(mpf(33))),
             ('kp', kp, (13 + 3 * sqrt(mpf(33))) / 16),
             ('km', km, (13 - 3 * sqrt(mpf(33))) / 16),
             ('beta(c_sigma)', beta, -(7 + sqrt(mpf(33))) / 4),
             ('c (Chebyshev)', cheb, (3 + sqrt(mpf(33))) / 4),
             ('F(c_sigma)', F0c, (81 + 15 * sqrt(mpf(33))) / 16),
             ('alpha', alpha, 9 + 3 * sqrt(mpf(33))),
             ('beta', betaC, mpf(1))]
    for nm, x, want in items:
        got = x.num(40)
        check(abs(got - want) < mpf(10) ** -35, '40-digit value of %s' % nm)
        log('5   %-14s = %s' % (nm, mp.nstr(got.real, 40)))
    log('5   all 40-digit values agree with the closed forms to 1e-35.')

    log('')
    log('== SUMMARY ==')
    log('    alpha = 9 + 3 sqrt33 = 3(3+sqrt33) = 12 c = 16 kp - 4   !=  0')
    log('    beta  = 1                                               !=  0')
    for (m, nm, dt, rk, kd, nzt, nzs) in SUMM:
        log('    m=%d %-5s : transfer rank %d of %d  ->  NONVACUOUS '
            '(proper condition of codimension %d)' % (m, nm, rk, dt, rk))
    log('    %d exact checks passed.' % NCHECK[0])
    return NCHECK[0]


def proportional(u, v):
    lam = None
    for a, b in zip(u, v):
        if a or b:
            if a.is_zero() or b.is_zero():
                return False
            lam = b / a
            break
    if lam is None:
        return True
    return all((b - lam * a).is_zero() for a, b in zip(u, v))


if __name__ == '__main__':
    n = main()
    log('')
    log('elapsed %.1f s' % (time.time() - T0))
    os.makedirs(os.path.join(HERE, 'logs'), exist_ok=True)
    os.makedirs(os.path.join(HERE, 'payloads'), exist_ok=True)
    body = '\n'.join(LOG) + '\nFIX_L1_VERIFY_OK  (%d checks)\n' % n
    with open(os.path.join(HERE, 'logs', 'VERIFY.log'), 'w') as fh:
        fh.write(body)
    # *.log is gitignored repo-wide; keep the verification record in payloads/
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_VERIFY.txt'), 'w') as fh:
        fh.write(body)
    print('FIX_L1_VERIFY_OK  (%d checks)' % n)
