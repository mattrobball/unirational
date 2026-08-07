#!/usr/bin/env python3
# F55 landing ladder on the Klein cubic, monomial coordinates.
# Klein: F = sum_i x_i^2 x_{i+1} (indices mod 5), h: x_i -> zeta^{a_i} x_i
# with a = (1,9,4,3,5) (a_{i+1} = -2 a_i), c: (c.x)_i = x_{i-1}.
# Equivariant T: T_i has h-weight a_i (characters of F55 are trivial on
# C11), and T_i = omega^{s i} shift^i(T_0), s in Z/5.  Landing: F(T) = 0
# identically.  For each degree d and twist s: the cone of coefficient
# vectors of T_0 (dim n_d) cut by the cubic system coeffs(F(T)).
# Output: M2 scripts per (d, s) checking the cone is empty (saturate =
# irrelevant) and a brute scan for d = 3.
import sys, os
from itertools import product
p = 661
a = [1, 9, 4, 3, 5]
def monomials(d):
    out = []
    for e0 in range(d+1):
        for e1 in range(d+1-e0):
            for e2 in range(d+1-e0-e1):
                for e3 in range(d+1-e0-e1-e2):
                    e4 = d-e0-e1-e2-e3
                    out.append((e0,e1,e2,e3,e4))
    return out
def weight(m): return sum(e*ai for e, ai in zip(m, a)) % 11
def shift(m):  # x_j -> x_{j+1}: exponent vector rotates right
    return (m[4], m[0], m[1], m[2], m[3])
D = int(sys.argv[1]) if len(sys.argv) > 1 else 3
mons = monomials(D)
base = [m for m in mons if weight(m) == a[0] % 11]
n = len(base)
print(f"d = {D}: dim of T_0 coefficient space = {n}")
# T_i monomial support: shift^i of base, coefficient c_k (shared), times omega^{s i}
# F(T) = sum_i T_i^2 T_{i+1}
# coefficient bookkeeping over F_p with omega: work in F_p with omega = element of order 5
om = next(t for t in range(2, p) if pow(t, 5, p) == 1 and t != 1)
big = monomials(3*D)
bigidx = {m: i for i, m in enumerate(big)}
def madd(m1, m2, m3):
    return tuple(x+y+z for x, y, z in zip(m1, m2, m3))
for s in range(5):
    # F(T) coefficients: dict big-monomial -> dict (k1<=k2, k3) -> coeff
    # T_i = omega^{s i} * sum_k c_k x^{shift^i base_k}
    # T_i^2 T_{i+1} = omega^{s(2i+i+1)} sum_{k1,k2,k3} c_{k1}c_{k2}c_{k3} x^{...}
    sysq = {}
    for i in range(5):
        sh_i = base
        for _ in range(i): sh_i = [shift(m) for m in sh_i]
        sh_i1 = [shift(m) for m in sh_i]
        tw = pow(om, (3*i+1)*s % 5, p)
        for k1 in range(n):
            for k2 in range(n):
                for k3 in range(n):
                    mm = madd(sh_i[k1], sh_i[k2], sh_i1[k3])
                    key = (tuple(sorted((k1, k2))), k3)
                    d0 = sysq.setdefault(mm, {})
                    d0[key] = (d0.get(key, 0) + tw) % p
    eqs = []
    for mm, terms in sysq.items():
        row = {k: v % p for k, v in terms.items() if v % p}
        if row: eqs.append(row)
    print(f"  s = {s}: {len(eqs)} cubic equations in {n} unknowns")
    if D == 3:
        # brute scan P^{n-1}(F_p)
        found = []
        def evalrow(row, c):
            t = 0
            for ((k1, k2), k3), cf in row.items():
                t = (t + cf * c[k1] * c[k2] * c[k3]) % p
            return t
        for lead in range(n):
            ranges = [range(1, 2) if j == lead else (range(p) if j > lead else range(1)) for j in range(n)]
            # normalize: c_j = 0 for j < lead, c_lead = 1
            import itertools as it
            for tail in it.product(*[range(p) for _ in range(n-lead-1)]):
                c = [0]*lead + [1] + list(tail)
                ok = True
                for row in eqs:
                    if evalrow(row, c): ok = False; break
                if ok: found.append(tuple(c))
        print(f"    brute scan: {len(found)} projective solutions mod {p}", found[:5])
    else:
        vs = ",".join(f"c{k}" for k in range(n))
        lines = [f"kk = ZZ/{p}; R = kk[{vs}];"]
        polys = []
        for row in eqs:
            terms = []
            for ((k1, k2), k3), cf in row.items():
                if k1 == k2:
                    terms.append(f"{cf}*c{k1}^2*c{k3}")
                else:
                    terms.append(f"{cf}*c{k1}*c{k2}*c{k3}")
            polys.append("+".join(terms))
        lines.append("I = ideal(" + ",".join(polys) + ");")
        lines.append('<< "LADDER d=' + str(D) + ' s=' + str(s) +
                     ' empty " << (saturate(I, ideal vars R) == ideal(1_R)) << " dim " << dim I << endl;')
        fn = f"f55land_d{D}_s{s}.m2"
        open(fn, "w").write("\n".join(lines))
        print(f"    wrote {fn}")
