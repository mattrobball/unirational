#!/usr/bin/env python3
"""F55 landing-ladder rung d: emit the exact cubic coefficient system as an
msolve generator file and decide projective emptiness by Groebner basis.

This is a re-implementation of the combinatorics of
`director_probes_20260806/f55_ladder_m2.py` (Note IX Sec 8.8), which emitted
Macaulay2 scripts asking for `saturate(I, ideal vars R) == ideal(1_R)`.  The
d = 6 rung of that M2 form was killed after ~45 h CPU on the s = 0 twist and
left no output (NOTEBOOK wave 32).  The ideal itself is small -- 19 unknowns --
so the rung is re-attacked here with msolve's F4 instead of M2's `saturate`.

Setup (unchanged from the M2 generator, and re-derived here rather than copied
from the untracked .m2 artifacts):

  Klein cubic  F = sum_i x_i^2 x_{i+1}                     (indices mod 5)
  h: x_i -> zeta_11^{a_i} x_i  with  a = (1,9,4,3,5)       (a_{i+1} = -2 a_i)
  c: (c.x)_i = x_{i-1}

Every character of F55 is trivial on C11, so an equivariant T : P(W) --> X has
T_i of h-weight exactly a_i and T_i = omega^{s i} shift^i(T_0) for a twist
s in Z/5, omega a primitive fifth root of unity.  Writing T_0 in the
weight-a_0 monomial basis of degree d gives n_d unknowns c_0..c_{n-1}, and
landing is the cubic system coeffs(F(T)) = 0.

Emptiness criterion.  `-g 2` gives the reduced DRL Groebner basis.  The
projective cone is empty exactly when the basis contains, for every variable,
an element whose leading monomial is a pure power of that variable (then every
solution has all coordinates nilpotent, i.e. c = 0).  This is the same
`gb_verdict` rule the A5-ladder packet uses.

Char-0 scope.  V(I) is a closed subscheme of P^{n-1}_{Z[omega]}, and the image
of a proper morphism is closed.  If the fibre over a prime p is empty then p is
not in the image; were the generic fibre nonempty the image would contain the
generic point and hence, being closed, all of Spec, including p.  So emptiness
at a single good prime already gives emptiness in characteristic zero.  Two
primes are run anyway, per the packet convention.

usage:  f55_ladder_msolve.py <d> <p> <outdir> [<twist> ...]
"""
import sys, os, json, subprocess, time

A = [1, 9, 4, 3, 5]


def monomials(d):
    out = []
    for e0 in range(d + 1):
        for e1 in range(d + 1 - e0):
            for e2 in range(d + 1 - e0 - e1):
                for e3 in range(d + 1 - e0 - e1 - e2):
                    out.append((e0, e1, e2, e3, d - e0 - e1 - e2 - e3))
    return out


def weight(m):
    return sum(e * ai for e, ai in zip(m, A)) % 11


def shift(m):
    return (m[4], m[0], m[1], m[2], m[3])


def omega_of(p):
    """a primitive fifth root of unity in F_p (p = 1 mod 5)"""
    assert p % 5 == 1, 'need p = 1 mod 5 for a primitive fifth root'
    for t in range(2, p):
        if pow(t, 5, p) == 1 and t != 1:
            return t
    raise RuntimeError('no fifth root of unity mod %d' % p)


def ladder_system(d, p, s):
    """the exact cubic rows of F(T) = 0 for degree d and twist s.

    Returns (n, rows) with rows a list of dicts ((k1,k2),k3) -> coefficient."""
    base = [m for m in monomials(d) if weight(m) == A[0] % 11]
    n = len(base)
    om = omega_of(p)
    sysq = {}
    for i in range(5):
        sh_i = base
        for _ in range(i):
            sh_i = [shift(m) for m in sh_i]
        sh_i1 = [shift(m) for m in sh_i]
        tw = pow(om, (3 * i + 1) * s % 5, p)
        for k1 in range(n):
            for k2 in range(n):
                for k3 in range(n):
                    mm = tuple(x + y + z for x, y, z in
                               zip(sh_i[k1], sh_i[k2], sh_i1[k3]))
                    key = (tuple(sorted((k1, k2))), k3)
                    d0 = sysq.setdefault(mm, {})
                    d0[key] = (d0.get(key, 0) + tw) % p
    rows = []
    for mm, terms in sysq.items():
        row = {k: v % p for k, v in terms.items() if v % p}
        if row:
            rows.append(row)
    return n, rows


def write_ms(n, rows, p, path):
    names = ','.join('c%d' % k for k in range(n))
    polys = []
    for row in rows:
        terms = []
        for (k1, k2), k3 in sorted(row):
            cf = row[((k1, k2), k3)]
            if k1 == k2:
                terms.append('%d*c%d^2*c%d' % (cf, k1, k3))
            else:
                terms.append('%d*c%d*c%d*c%d' % (cf, k1, k2, k3))
        polys.append('+'.join(terms))
    src = names + '\n' + str(p) + '\n' + ',\n'.join(polys) + '\n'
    assert '(' not in src, 'msolve parenthesis landmine'
    open(path, 'w').write(src)
    return len(polys)


def gb_verdict(body, n):
    """EMPTY iff the reduced GB has a pure power of every variable as a
    leading monomial (identical rule to the A5-ladder packet)."""
    import re
    b = body.strip().rstrip(':').strip()
    if b in ('[1]', '[-1]'):
        return 'UNIT'
    pure = set()
    for elt in b.strip('[]').split(',\n'):
        elt = elt.strip()
        if not elt:
            continue
        lead = re.split(r'(?<![\^*])[+\-]', elt)[0].strip()
        m = re.fullmatch(r'1\*c(\d+)(?:\^(\d+))?', lead)
        if m:
            pure.add(int(m.group(1)))
    return 'EMPTY' if pure >= set(range(n)) else 'NONEMPTY-OR-UNRESOLVED'


def run(d, p, outdir, twists, cap=None, threads=2):
    cap = int(os.environ.get('LADDER_CAP', '7200')) if cap is None else cap
    os.makedirs(outdir, exist_ok=True)
    res = {}
    for s in twists:
        n, rows = ladder_system(d, p, s)
        ms = os.path.join(outdir, 'f55land_d%d_s%d_p%d.ms' % (d, s, p))
        npoly = write_ms(n, rows, p, ms)
        out = ms.replace('.ms', '.out')
        t0 = time.time()
        try:
            subprocess.run(['msolve', '-t', str(threads), '-g', '2',
                            '-f', ms, '-o', out], check=True, timeout=cap,
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            st = 'OK'
        except subprocess.TimeoutExpired:
            st = 'TIMEOUT'
        except subprocess.CalledProcessError as e:
            st = 'ERROR rc=%s' % e.returncode
        secs = round(time.time() - t0, 1)
        if st == 'OK' and os.path.exists(out) and os.path.getsize(out) > 0:
            body = ''.join(l for l in open(out) if not l.startswith('#')).strip()
            verdict = gb_verdict(body, n) if body else 'ERROR empty body'
        else:
            verdict = 'UNDECIDED-TIMEOUT' if st == 'TIMEOUT' else 'ERROR 0-byte output'
        res[s] = {'n_unknowns': n, 'n_cubics': npoly, 'msolve': st,
                  'secs': secs, 'verdict': verdict}
        print('LADDER d=%d s=%d p=%d  n=%d  cubics=%d  %s  %s  (%.1fs)'
              % (d, s, p, n, npoly, st, verdict, secs), flush=True)
    return res


if __name__ == '__main__':
    d = int(sys.argv[1])
    p = int(sys.argv[2])
    outdir = sys.argv[3]
    twists = [int(x) for x in sys.argv[4:]] or list(range(5))
    r = run(d, p, outdir, twists)
    jp = os.path.join(outdir, 'ladder_d%d_p%d.json' % (d, p))
    json.dump(r, open(jp, 'w'), indent=1)
    print(json.dumps(r, indent=1))
