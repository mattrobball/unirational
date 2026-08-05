#!/usr/bin/env python3
"""FIX-N2B: fast modular evaluation of the C3-equivariant landing systems.

Used for (a) witness checking, (b) random probes on the cone, (c) modular rank
certificates.  Emptiness verdicts are NEVER taken from here -- see STATUS.md;
the modular layer is a search/filter device and a cross-check.
"""
import random

import n2b_lib as L
from n2b_lib import ONE, OM, OM2

P = 100057
OMP, KPP = 1140, 74361
KMP = (13 * pow(8, P - 2, P) - KPP) % P
assert (OMP ** 2 + OMP + 1) % P == 0
assert (8 * KPP ** 2 - 13 * KPP - 4) % P == 0
assert (KPP * KMP + pow(2, P - 2, P)) % P == 0


def compile_eqs(block, p=P, omp=OMP, kpp=KPP, orbit_reduce=False):
    """list of [(param_exponent_tuple, int_coeff)] modulo p."""
    out = []
    for pc in L.equations(block, orbit_reduce=orbit_reduce):
        t = [(pm, L.kmod_p(c, p, omp, kpp)) for pm, c in pc.items()]
        t = [(pm, c) for pm, c in t if c]
        if t:
            out.append(t)
    return out


def ev(eqs, v, p=P):
    out = []
    for t in eqs:
        s = 0
        for pm, c in t:
            m = c
            for j, e in enumerate(pm):
                if e:
                    m = m * pow(v[j], e, p) % p
            s = (s + m) % p
        out.append(s)
    return out


def landing_uvw_modp(block, v, p=P, omp=OMP, kpp=KPP):
    """the landing polynomial evaluated at the parameter point v, mod p."""
    Lp = L.landing_cpoly(block)
    out = {}
    for mo, pc in Lp.items():
        s = 0
        for pm, c in pc.items():
            m = L.kmod_p(c, p, omp, kpp)
            for j, e in enumerate(pm):
                if e:
                    m = m * pow(v[j], e, p) % p
            s = (s + m) % p
        if s:
            out[mo] = s
    return out


def cube_root_kp(p=P, kpp=KPP):
    """all B in F_p with (B^3-1)^2/B^3 = kp  (used to place the known witnesses)."""
    out = []
    for B in range(1, p):
        if (B ** 3 - 1) ** 2 % p * pow(B, 3 * (p - 2), p) % p == kpp:
            out.append(B)
        if len(out) >= 6:
            break
    return out
