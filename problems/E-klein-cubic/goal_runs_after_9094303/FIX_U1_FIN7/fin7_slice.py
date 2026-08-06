#!/usr/bin/env python3
"""FIX-U1-FIN7 -- global dimension of the projectivized r = 7 cone by an
explicit linear slice.

If a projective variety V has dimension d, EVERY linear subspace of codimension
<= d meets it.  So a SINGLE explicit linear subspace L of codimension k with
V ∩ L = empty proves dim V <= k - 1.  No genericity is needed.

The slice is chosen with small INTEGER coefficients, so the sliced scheme is
defined over O_K.  `Proj` of it is PROPER over `Spec O_K`; hence if the fibre
over one prime of O_K is empty, so is the generic fibre.  A single modular
emptiness certificate therefore gives the characteristic-zero bound.
"""
import random

import sympy as sp

import fin7_lib as L
import fin7_modular as M


def make_slice(codim, seed, nvar=39, lo=-9, hi=9):
    """express `codim` of the variables as integer-linear combinations of the
    rest; returns (elim, keep, coeff) with
        x_elim[a] = sum_b coeff[a][b] x_keep[b] .
    """
    rnd = random.Random(seed)
    idx = list(range(nvar))
    rnd.shuffle(idx)
    elim = sorted(idx[:codim])
    keep = sorted(idx[codim:])
    coeff = [[rnd.randint(lo, hi) for _ in keep] for _ in elim]
    return elim, keep, coeff


def sliced_cubics(codim, seed, p, omp, kpp, nvar=39):
    """the 52 cubics restricted to the slice, over F_p, as term lists in the
    kept variables (dense expansion, integer coefficients, no parentheses)."""
    names, eqs = L.landing_terms()
    elim, keep, coeff = make_slice(codim, seed, nvar)
    pos = {v: a for a, v in enumerate(elim)}
    kpos = {v: b for b, v in enumerate(keep)}
    nk = len(keep)

    def lin(t):
        """variable t as a dict {kept index: coefficient mod p}."""
        if t in kpos:
            return {kpos[t]: 1}
        row = coeff[pos[t]]
        return {b: row[b] % p for b in range(nk) if row[b] % p}

    lins = [lin(t) for t in range(nvar)]
    eqp = M.eqs_mod(eqs, p, omp, kpp)
    out = []
    for _mon, tl in eqp:
        acc = {}
        for c, (i, j, k) in tl:
            for a, ca in lins[i].items():
                for b, cb in lins[j].items():
                    cab = ca*cb % p
                    if not cab:
                        continue
                    for d, cd in lins[k].items():
                        key = tuple(sorted((a, b, d)))
                        acc[key] = (acc.get(key, 0) + c*cab % p*cd) % p
        acc = {k2: v for k2, v in acc.items() if v}
        if acc:
            out.append(acc)
    return keep, nk, out


def emit_msolve(nk, cubics, p, extra=None):
    vs = ['v%d' % b for b in range(nk)]
    lines = []
    for acc in cubics:
        terms = ['%d*%s*%s*%s' % (v, vs[a], vs[b], vs[d])
                 for (a, b, d), v in sorted(acc.items())]
        lines.append('+'.join(terms))
    if extra:
        lines.extend(extra)
    src = '%s\n%d\n%s\n' % (','.join(vs), p, ',\n'.join(lines))
    assert '(' not in src, 'msolve parenthesis landmine'
    return src


def emit_m2(nk, cubics, p, extra=None, task='dim'):
    vs = ['v%d' % b for b in range(nk)]
    lines = []
    for acc in cubics:
        terms = ['%d*%s*%s*%s' % (v, vs[a], vs[b], vs[d])
                 for (a, b, d), v in sorted(acc.items())]
        lines.append('+'.join(terms))
    if extra:
        lines.extend(extra)
    body = ',\n'.join(lines)
    return ('R = ZZ/%d[%s];\nI = ideal(\n%s);\n'
            'time G = gb I;\n'
            'print("dim   = "|toString dim I);\n'
            'print("codim = "|toString codim I);\n'
            'print("UNIT  = "|toString (1 %% I == 0));\n'
            'exit 0\n' % (p, ','.join(vs), body))
