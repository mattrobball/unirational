#!/usr/bin/env python3
"""FIX-N2C: decode an msolve `-P 1` rational parametrization over F_p and turn
it into explicit points, validated against the original system.

msolve's sign/denominator convention is not documented in the binary's help, so
every convention is tried and the one that actually satisfies the input system
is used; if none does, that is reported (and is itself a finding).
"""
import ast
import itertools
import re
import sys


def read_param(path):
    txt = open(path).read().strip()
    assert txt.endswith(':'), txt[:80]
    txt = txt[:-1]
    txt = txt.replace("'", '"')
    data = ast.literal_eval(txt)
    return data


def poly_eval(coeffs, t, p):
    v = 0
    for c in reversed(coeffs):
        v = (v * t + c) % p
    return v


def roots_fp(coeffs, p):
    """all roots in F_p of the polynomial with the given coefficient list."""
    return [t for t in range(p) if poly_eval(coeffs, t, p) == 0]


def parse_system(path):
    """(names, p, [ {exponent_tuple: coeff} ]) from an msolve .ms file."""
    lines = open(path).read().strip().split('\n')
    names = [s.strip() for s in lines[0].split(',')]
    p = int(lines[1])
    polys = []
    for line in lines[2:]:
        line = line.rstrip(',').replace('-', '+-')
        d = {}
        for term in line.split('+'):
            term = term.strip()
            if not term:
                continue
            c, e = 1, [0]*len(names)
            for f in term.split('*'):
                m = re.match(r'^(-?\d+)(?:/(\d+))?$', f)
                if m:
                    c = c*int(m.group(1)) % p
                    if m.group(2):
                        c = c*pow(int(m.group(2)), p-2, p) % p
                    continue
                m = re.match(r'^([A-Za-z]\w*)(?:\^(\d+))?$', f)
                e[names.index(m.group(1))] += int(m.group(2) or 1)
            k = tuple(e)
            d[k] = (d.get(k, 0) + c) % p
        d = {k: v for k, v in d.items() if v}
        if d:
            polys.append(d)
    return names, p, polys


def evaluate(polys, vals, p):
    out = []
    for d in polys:
        s = 0
        for k, c in d.items():
            m = c
            for j, e in enumerate(k):
                if e:
                    m = m*pow(vals[j], e, p) % p
            s = (s + m) % p
        out.append(s % p)
    return out


def points(param_path, ms_path):
    data = read_param(param_path)
    names, p, polys = parse_system(ms_path)
    assert data[0] == 0, 'not a 0-dimensional parametrization: %s' % (data[:2],)
    blk = data[1]
    dim, deg, nv, varnames, linform, rest = blk[0], blk[1], blk[2], blk[3], blk[4], blk[5]
    char, body = rest[0], rest[1]
    elim = body[0][1]
    dnm = body[1][1]
    nums = [(t[0][1], t[1]) for t in body[2]]
    print('# dim=%s deg=%s nvars=%s vars=%s linform=%s' % (dim, deg, nv, varnames, linform))
    print('# eliminant degree %d ; %d numerators' % (len(elim)-1, len(nums)))
    rts = roots_fp(elim, p)
    print('# roots of the eliminant in F_%d : %d of %d' % (p, len(rts), len(elim)-1))
    found = []
    for t in rts:
        d = poly_eval(dnm, t, p)
        if d == 0:
            print('#   t=%d : denominator vanishes' % t)
            continue
        di = pow(d, p-2, p)
        for sgn in (-1, 1):
            vals = []
            for (nc, cf) in nums:
                vals.append(sgn*poly_eval(nc, t, p)*di % p * cf % p)
            # the linear form recovers the last coordinate(s)
            for tail in _tails(linform, vals, t, p, len(varnames)):
                v = vals + tail
                if len(v) != len(names):
                    continue
                if all(q == 0 for q in evaluate(polys, v, p)):
                    found.append(tuple(v))
    found = sorted(set(found))
    return names, p, polys, found


def _tails(linform, vals, t, p, nvars):
    """recover the coordinates the parametrization does not list explicitly."""
    k = nvars - len(vals)
    if k == 0:
        return [[]]
    if k != 1:
        return []
    # t = sum linform[i] * x_i ; solve for the missing last coordinate
    c = linform[-1] % p
    if c == 0:
        return [[t % p], [(-t) % p]]
    s = sum(linform[i]*vals[i] for i in range(len(vals))) % p
    return [[(t - s)*pow(c, p-2, p) % p], [(-t - s)*pow(c, p-2, p) % p],
            [t % p], [(-t) % p]]


if __name__ == '__main__':
    names, p, polys, pts = points(sys.argv[1], sys.argv[2])
    print('# %d validated points over F_%d' % (len(pts), p))
    for v in pts:
        print('  ' + '  '.join('%s=%d' % (n, c) for n, c in zip(names, v)))
