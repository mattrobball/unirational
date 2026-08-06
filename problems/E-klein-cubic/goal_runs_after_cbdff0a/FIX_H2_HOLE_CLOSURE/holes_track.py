#!/usr/bin/env python3
"""FIX-H1: branch-and-reduce WITH reconstruction tracking.

Same exact reductions as `holes_solve`, but every original block coordinate is
carried along as a polynomial in the CURRENT variables, so a leaf solution
reconstructs to a full point of the eigenblock.  Used both to produce witnesses
and to certify emptiness leaf by leaf.
"""
import sys

import holes_lib as H
import holes_reduce as RD
import holes_solve as SV
import holes_strata as ST
import holes_xy as XY
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, ZERO


class Branch:
    __slots__ = ('names', 'polys', 'env', 'path')

    def __init__(self, names, polys, env, path=''):
        self.names, self.polys, self.env, self.path = names, polys, env, path

    def copy(self):
        return Branch(list(self.names), [dict(q) for q in self.polys],
                      {k: dict(v) for k, v in self.env.items()}, self.path)


def start(names, polys, extra_zero=()):
    n = len(names)
    env = {}
    for i, nm in enumerate(names):
        e = [0] * n
        e[i] = 1
        env[nm] = {tuple(e): ONE}
    b = Branch(list(names), RD.dedup(polys), env)
    for z in extra_zero:
        b = do_setzero(b, b.names.index(z))
    return b


def do_subst(b, i, expr):
    b.polys = [S.p_substitute(q, i, expr) for q in b.polys]
    b.polys = [q for q in b.polys if q]
    b.polys = [S.p_drop(q, {i}) for q in b.polys]
    b.env = {k: S.p_drop(S.p_substitute(v, i, expr), {i}) if v else v
             for k, v in b.env.items()}
    b.names = [x for j, x in enumerate(b.names) if j != i]
    b.polys = RD.dedup(b.polys)
    return b


def do_setzero(b, i):
    b.polys = [S.p_setvar(q, i, ZERO) for q in b.polys]
    b.polys = [q for q in b.polys if q]
    b.polys = [S.p_drop(q, {i}) for q in b.polys]
    b.env = {k: S.p_drop(S.p_setvar(v, i, ZERO), {i}) if v else v
             for k, v in b.env.items()}
    b.names = [x for j, x in enumerate(b.names) if j != i]
    b.polys = RD.dedup(b.polys)
    return b


def reduce_branch(b, maxdeg=6):
    while True:
        b.polys = RD.dedup(b.polys)
        for q in b.polys:
            if SV.is_const(q, len(b.names)):
                return None
        cands = RD.linear_candidates(b.names, b.polys)
        cands = [c for c in cands if RD._expr_deg(b.polys[c[0]], c[1]) <= maxdeg]
        if not cands:
            return b
        cands.sort(key=lambda c: (RD._expr_deg(b.polys[c[0]], c[1]),
                                  len(b.polys[c[0]]), c[1]))
        qi, i, nm = cands[0]
        q = b.polys[qi]
        rest, lin = {}, None
        for k, v in q.items():
            if k[i] == 1:
                lin = v
            else:
                rest[k] = v
        expr = S.p_scal(S.p_scal(rest, S.kinv(lin)), L.kneg(ONE))
        b = do_subst(b, i, expr)


def solve(b, maxdeg=6, maxleaves=2000, leaves=None):
    if leaves is None:
        leaves = []
    b = reduce_branch(b, maxdeg)
    if b is None:
        return leaves
    if not b.polys:
        leaves.append(b)
        return leaves
    best = None
    for qi, q in enumerate(b.polys):
        g = SV.common_monomial(q)
        if not any(g):
            continue
        vs = [i for i, e in enumerate(g) if e]
        h = SV.divide_monomial(q, g)
        cost = len(vs) + (0 if SV.is_const(h, len(b.names)) else 1)
        if best is None or cost < best[0]:
            best = (cost, qi, vs, h)
    if best is None:
        # (R5) exact factorisation over K.  First take RADICALS: V(g) =
        # V(rad g), no branching.  Only if that changes nothing do we branch on
        # the distinct factors,  V(g) = union V(h_i).
        import holes_factor as FA
        for q in sorted(b.polys, key=len)[:2]:
            facs = FA.factor_gen_safe(b.names, q, maxterms=6)
            if not facs:
                continue
            qi = b.polys.index(q)
            rest = b.polys[:qi] + b.polys[qi + 1:]
            if any(m > 1 for _, m in facs):
                rad = {tuple([0] * len(b.names)): ONE}
                for d, _ in facs:
                    rad = S.p_mul(rad, d)
                nb = Branch(list(b.names), [dict(t) for t in rest] + [rad],
                            {k: dict(v) for k, v in b.env.items()},
                            b.path + '/[radical]')
                return solve(nb, maxdeg, maxleaves, leaves)
            for d, mult in facs:
                nb = Branch(list(b.names), [dict(t) for t in rest] + [dict(d)],
                            {k: dict(v) for k, v in b.env.items()},
                            b.path + '/[factor]')
                solve(nb, maxdeg, maxleaves, leaves)
                if len(leaves) > maxleaves:
                    raise RuntimeError('too many leaves')
            return leaves
        leaves.append(b)
        return leaves
    _, qi, vs, h = best
    rest = b.polys[:qi] + b.polys[qi + 1:]
    for i in vs:
        nb = Branch(list(b.names), [dict(q) for q in rest],
                    {k: dict(v) for k, v in b.env.items()},
                    b.path + '/%s=0' % b.names[i])
        nb = do_setzero(nb, i)
        solve(nb, maxdeg, maxleaves, leaves)
        if len(leaves) > maxleaves:
            raise RuntimeError('too many leaves')
    if not SV.is_const(h, len(b.names)):
        nb = Branch(list(b.names), [dict(q) for q in rest] + [dict(h)],
                    {k: dict(v) for k, v in b.env.items()},
                    b.path + '/[cofactor]')
        solve(nb, maxdeg, maxleaves, leaves)
    return leaves


# --------------------------------------------------------------------------
def stratum_branch(r, lam, which, orbit_reduce=True):
    """the (X,Y)-coordinate stratum as a tracked Branch."""
    one_var, zero_var = ST.STRATA[which]
    names, polys, b = XY.xy_system(r, lam, orbit_reduce=orbit_reduce)
    po1 = H.po1_params(b)
    if one_var.startswith('B'):
        one_var = po1[0] if one_var == 'B6' else po1[1]
    if zero_var.startswith('B'):
        zero_var = po1[0] if zero_var == 'B6' else po1[1]
    br = start(names, polys)
    br = do_setzero(br, br.names.index(zero_var))
    i = br.names.index(one_var)
    # set one_var := 1 (dehomogenisation), tracked
    br.polys = [S.p_setvar(q, i, ONE) for q in br.polys]
    br.polys = [q for q in br.polys if q]
    br.polys = [S.p_drop(q, {i}) for q in br.polys]
    br.env = {k: S.p_drop(S.p_setvar(v, i, ONE), {i}) if v else v
              for k, v in br.env.items()}
    br.env[one_var] = {tuple([0] * (len(br.names) - 1)): ONE}
    br.names = [x for j, x in enumerate(br.names) if j != i]
    br.polys = RD.dedup(br.polys)
    br.path = '%s=1/%s=0' % (one_var, zero_var)
    return br, b, (one_var, zero_var)


def eval_env(env, blocknames, values, p, omp, kpp):
    """evaluate the reconstruction at a modular leaf point -> XY-coordinates."""
    out = []
    for nm in blocknames:
        q = env[nm]
        s = 0
        for k, c in q.items():
            t = L.kmod_p(c, p, omp, kpp)
            for j, e in enumerate(k):
                if e:
                    t = t * pow(values[j], e, p) % p
            s = (s + t) % p
        out.append(s)
    return out


if __name__ == '__main__':
    r, lam, which = int(sys.argv[1]), sys.argv[2], sys.argv[3]
    br, blk, vs = stratum_branch(r, lam, which)
    print('stratum %s: %d vars %s, %d gens' % (which, len(br.names), br.names,
                                               len(br.polys)))
    leaves = solve(br)
    print('%d leaves' % len(leaves))
    for lf in leaves:
        print('  %-60s vars=%d gens=%d' % (lf.path[:60], len(lf.names),
                                           len(lf.polys)))
