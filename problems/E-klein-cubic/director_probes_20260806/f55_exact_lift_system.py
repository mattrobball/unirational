#!/usr/bin/env python3
"""f55_exact_lift_system.py -- the exact-lift campaign, step C: THE SYSTEM.

Builds the exact algebraic system pinned by a degeneration profile and emits
it for Macaulay2, Singular and msolve.

THE SYSTEM (reconstructed in full; see the report for the derivation).
  A C11-equivariant map  P^1 --> V14 = Gr(2,U) cap P(M)  of degree e whose two
  C11-fixed points map to the pentagram pair (y_{49}, y_{15}) is the same
  thing as fifteen binary forms D_ab (a<b in L = {0,1,3,4,5,9}) of degree e,
  not all zero, with

   (1) PLUCKER   D_ij D_kl - D_ik D_jl + D_il D_jk = 0   for i<j<k<l in L
                 (15 quadrics; this is "the plane is a plane")
   (2) MEMBER    D_{c_q d_q} = t_q * D_{0q}, q in QR={1,3,4,5,9},
                 {c,d} = {3,9},{5,9},{1,3},{1,4},{4,5},
                 t = (1/2,-1/2,1/2,-1/2,-1/2)      (this is "the plane in P(M)")
   (3) EQUIVAR   supp(D_ab) subset {k = sigma*(a+b-2) mod 11}
   (4) PROFILE   ord_0 D_ab = w_ab  and  deg_z D_ab = e - w'_ab, exactly.
       In particular w_49 = 0 (the z=0 point is y_{49}) and w'_15 = 0
       (the z=oo point is y_{15}); those two are the incidence conditions.

Field: Q for characteristic 0 (t_q are rational!), F_p for p = 1 mod 11.
"""
import sys, json, os
from fractions import Fraction
from itertools import combinations

L = [0, 1, 3, 4, 5, 9]
PAIRS = [tuple(sorted(c)) for c in combinations(L, 2)]
QUADS = [tuple(sorted(c)) for c in combinations(L, 4)]
QR = [1, 3, 4, 5, 9]
CD = {1: (3, 9), 3: (5, 9), 4: (1, 3), 5: (1, 4), 9: (4, 5)}
TQ = {1: Fraction(1, 2), 3: Fraction(-1, 2), 4: Fraction(1, 2),
      5: Fraction(-1, 2), 9: Fraction(-1, 2)}
DIAG = {tuple(sorted(CD[q])): (q, TQ[q]) for q in QR}      # D_cd = t_q D_0q
INDEP = [pr for pr in PAIRS if pr not in DIAG]             # the ten free forms

LETTERS = 'abcdefghijklmnopqrstuvwxyz'


def vname(pr, i):
    return f"c{pr[0]}{pr[1]}{LETTERS[i]}"                  # no underscores (M2!)


class System:
    def __init__(self, sigma, e, w=None, wp=None, corner=(4, 9), free=False):
        self.sigma, self.e, self.corner, self.free = sigma, e, corner, free
        sh = corner[0] + corner[1]
        self.cls = {pr: sigma * (pr[0] + pr[1] - sh) % 11 for pr in PAIRS}
        self.exps = {}
        for pr in PAIRS:
            lo = 0 if free else w[pr]
            hi = e if free else e - wp[pr]
            self.exps[pr] = [k for k in range(lo, hi + 1) if k % 11 == self.cls[pr] % 11]
            assert self.exps[pr], (pr, lo, hi, self.cls[pr])
        self.vars = []
        for pr in INDEP:
            for i in range(len(self.exps[pr])):
                self.vars.append(vname(pr, i))

    def form(self, pr):
        """D_pr as dict exponent -> linear form (dict var->Fraction)."""
        if pr in DIAG:
            q, t = DIAG[pr]
            base = (0, q)
            out = {}
            for i, k in enumerate(self.exps[base]):
                out[k] = {vname(base, i): t}
            # supports must agree
            assert self.exps[pr] == self.exps[base], (pr, self.exps[pr], self.exps[base])
            return out
        return {k: {vname(pr, i): Fraction(1)} for i, k in enumerate(self.exps[pr])}

    def plucker_polys(self):
        """the 15 Plucker relations, each as dict exponent -> quadratic poly
           (dict of sorted var-pair -> Fraction)."""
        out = []
        for (i, j, k, l) in QUADS:
            terms = [(+1, (i, j), (k, l)), (-1, (i, k), (j, l)), (+1, (i, l), (j, k))]
            acc = {}
            for sgn, p1, p2 in terms:
                F1, F2 = self.form(p1), self.form(p2)
                for e1, L1 in F1.items():
                    for e2, L2 in F2.items():
                        tgt = acc.setdefault(e1 + e2, {})
                        for v1, a1 in L1.items():
                            for v2, a2 in L2.items():
                                key = tuple(sorted((v1, v2)))
                                tgt[key] = tgt.get(key, Fraction(0)) + sgn * a1 * a2
            acc = {ex: {m: c for m, c in poly.items() if c != 0} for ex, poly in acc.items()}
            out.append(((i, j, k, l), {ex: poly for ex, poly in acc.items() if poly}))
        return out

    def equations(self):
        eqs = []
        for quad, acc in self.plucker_polys():
            for ex in sorted(acc):
                eqs.append((quad, ex, acc[ex]))
        return eqs

    def extremal(self):
        """(trailing, leading) coefficient variables of the ten free forms."""
        tr = [vname(pr, 0) for pr in INDEP]
        ld = [vname(pr, len(self.exps[pr]) - 1) for pr in INDEP]
        return tr, ld


def poly_str(poly, denom_clear=True, mod=None):
    """quadratic poly (dict monomial->Fraction) to a string with INTEGER coeffs."""
    if mod is None:
        d = 1
        for c in poly.values():
            d = d * c.denominator // _gcd(d, c.denominator)
        parts = []
        for m, c in sorted(poly.items()):
            n = c * d
            assert n.denominator == 1
            n = int(n)
            mono = "*".join(m)
            parts.append(("+" if n > 0 else "-") + (f"{abs(n)}*" if abs(n) != 1 else "") + mono)
        s = "".join(parts)
        return s[1:] if s.startswith('+') else s
    parts = []
    for m, c in sorted(poly.items()):
        n = int(c.numerator) * pow(int(c.denominator), mod - 2, mod) % mod
        if n == 0:
            continue
        mono = "*".join(m)
        parts.append(f"+{n}*{mono}")
    s = "".join(parts) or "0"
    return s[1:] if s.startswith('+') else s


def _gcd(a, b):
    while b:
        a, b = b, a % b
    return a


def build_ideal(S, mod=None, normalize=True, rabino=True):
    """returns (varlist, generators) for the emptiness question
       'is there a solution with all extremal coefficients nonzero?'"""
    eqs = S.equations()
    tr, ld = S.extremal()
    gens = [poly_str(p, mod=mod) for (_, _, p) in eqs]
    varlist = list(S.vars)
    if normalize:
        # projective scaling: the z^0 coefficient of D_49 is nonzero (w_49 = 0)
        n49 = vname((4, 9), 0)
        gens.append(f"{n49}-1")
    nz = sorted(set(tr) | set(ld))
    if rabino:
        varlist = varlist + ['uu']
        gens.append("uu*" + "*".join(nz) + "-1")
    return varlist, gens, nz


def emit(S, tag, mod, outdir='.'):
    varlist, gens, nz = build_ideal(S, mod=mod)
    base = os.path.join(outdir, f"f55_exact_lift_{tag}")
    kk = f"ZZ/{mod}" if mod else "QQ"
    with open(base + ".m2", 'w') as f:
        f.write(f"kk = {kk};\n")
        f.write(f"R = kk[{','.join(varlist)}];\n")
        f.write("I = ideal(\n  " + ",\n  ".join(gens) + "\n);\n")
        f.write('G = gb I; g = flatten entries gens G;\n')
        f.write('isunit = (#g == 1 and (first g) == 1_R);\n')
        f.write(f'<< "TAG {tag} M2 dim=" << dim I << " unit=" << isunit << endl;\n')
    with open(base + ".sing", 'w') as f:
        ring = f"ring r = {mod if mod else 0},({','.join(varlist)}),dp;"
        f.write(ring + "\n")
        f.write("ideal I = " + ",\n  ".join(gens) + ";\n")
        f.write("ideal G = std(I);\n")
        f.write(f'"TAG {tag} SINGULAR size=" + string(size(G)) + " leadone=" '
                f'+ string(size(G)==1 && lead(G[1])==1) + " dim=" + string(dim(G));\n')
        f.write("quit;\n")
    if mod:
        with open(base + ".ms", 'w') as f:
            f.write(",".join(varlist) + "\n")
            f.write(f"{mod}\n")
            f.write(",\n".join(gens) + "\n")
    return base, varlist, gens, nz


if __name__ == '__main__':
    print(__doc__)
