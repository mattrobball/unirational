#!/usr/bin/env python3
# F55 target-side curve inventory on the V14 (the machine's layer 5).
# Degree 1: for each pair of the five C11-points, is the joining line on
# V14 (y_a ^ y_b = 0)?  Degree 2: equivariant conics z0^2 m0 + z0 z1 m1
# + z1^2 m2 with m0 = y_a, m2 = y_b, m1 = lam * v_gamma, gamma = (a+b)/2
# (the character progression), conditions: y_a^v_gamma = 0, v_gamma^y_b
# = 0, and 2 y_a^y_b + lam^2 v_gamma^v_gamma = 0 solvable for lam != 0.
import sys
from itertools import combinations
p = int(sys.argv[1]) if len(sys.argv) > 1 else 397
exec(open(__file__.replace('v14_f55_curves.py', 'v14_f55_weights.py')).read().split("# tangent cone")[0])
# from the exec: wt = {e: [vec]} eigen-lines of M, onV = [(e, y)] the five points
eig = {e: V[0] for e, V in wt.items() if len(V) == 1}
onset = dict(onV)
exps = sorted(onset.keys())
print("five points at characters", exps)
inv2 = pow(2, p-2, p)
def is_zero(v): return all(x % p == 0 for x in v)
print("--- degree 1: lines on V14 between the five points ---")
lines = []
for (a, b) in combinations(exps, 2):
    w = wprod(onset[a], onset[b])
    z = is_zero(w)
    if z: lines.append((a, b))
    print(f"pair ({a},{b}) ratio {b * pow(a, p-2, p) % p if False else (b * pow(a, 9, 11)) % 11}: line on V14: {z}")
print("lines found:", lines)
print("--- degree 2: equivariant conics (progression character middle) ---")
for (a, b) in combinations(exps, 2):
    s = (a + b) % 11
    if s % 2 == 0:
        g = (s * inv2) % 11 if False else (s * 6) % 11  # 1/2 = 6 mod 11
    else:
        g = (s * 6) % 11
    if g == 0:
        print(f"pair ({a},{b}): middle char 0 -> NO conic (no trivial character in M)")
        continue
    vg = eig[g]
    c1 = wprod(onset[a], vg); c2 = wprod(vg, onset[b])
    c3 = wprod(onset[a], onset[b]); c4 = wprod(vg, vg)
    ok1, ok2 = is_zero(c1), is_zero(c2)
    # need 2*c3 + lam^2 * c4 = 0 as vectors: c3, c4 proportional and ratio = square * (-2)^{-1}...
    stat = None
    if not ok1 or not ok2:
        stat = f"NO (tangency fails: y_a^v={ok1}, v^y_b={ok2})"
    else:
        if is_zero(c4) and is_zero(c3):
            stat = "YES (both wedges vanish: plane conic family)"
        elif is_zero(c4):
            stat = "NO (c4=0 but y_a^y_b != 0)"
        else:
            # proportionality of c3, c4 in Lambda^4
            lam2v = None; prop = True
            for i in range(15):
                x3, x4 = c3[i] % p, c4[i] % p
                if x4 == 0 and x3 == 0: continue
                if x4 == 0: prop = False; break
                r = (-2) * x3 * pow(x4, p-2, p) % p
                if lam2v is None: lam2v = r
                elif lam2v != r: prop = False; break
            if not prop: stat = "NO (wedges not proportional)"
            elif lam2v == 0: stat = "degenerate (lam=0 -> the line, not a conic)"
            else:
                sq = any(t*t % p == lam2v for t in range(p))
                stat = f"YES mod {p} (lam^2 = {lam2v}, square: {sq})" if sq else f"conditional (lam^2 = {lam2v} nonsquare mod {p}; sign/field-dep)"
    print(f"pair ({a},{b}) middle {g}: {stat}")
