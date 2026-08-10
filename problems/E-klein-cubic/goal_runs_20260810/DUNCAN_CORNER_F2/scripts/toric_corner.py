"""Independent confirmation of the corner stabilizer via DUNCAN'S OWN formula.

duncan_higher_obstruction_20260805.tex, lines 602-604 (rem:toric_criterion):

        H_tau  =  intersection over m in tau^perp cap M  of  ker chi^m ,

for the toric local model of a stratum.  At a general point of ell_V the local
V4-weights are psi = (0, a, b, c) on (u1,u2,u3,u4) with a+b+c = 0 in the
character group V4^ = F_2^2, and the lattice is N = Z^4 with dual M = Z^4,
chi^m = sum_i m_i psi_i.

The packet's tower is the following sequence of star subdivisions of the
positive orthant:

    v0 = (0,1,1,1)          T1: blow up ell_V   = V(u2,u3,u4)
    v1 = (0,0,1,1)          T2: blow up P~_z    = V(u3,u4)      (Fix(z))
    v2 = v0 + e3 = (0,1,2,1) T3: blow up M~_s   = cone(v0,e3)   (Fix(s) in E_V)

and the corner is the 2-dimensional cone tau = cone(v1, v2).

This script computes H_tau by brute force over a box of M, verifying that the
lattice tau^perp cap M is fully captured (its image in M/2M must be exactly
2-dimensional, since tau^perp cap M is saturated of rank 2).  No CAS needed.
"""
import itertools, os, sys

# characters of V4 as elements of F_2^2, encoded 0..3 with XOR addition
ZERO, A, B, C = 0, 1, 2, 3          # a = chi_z, b = chi_s, c = chi_r, a^b = c
PSI = [ZERO, A, B, C]
V4 = [0, 1, 2, 3]                   # group elements, also F_2^2


def pairing(chi, g):
    return (chi & 1) * (g & 1) ^ ((chi >> 1) & 1) * ((g >> 1) & 1)


def chi_m(m):
    out = 0
    for i in range(4):
        if m[i] % 2:
            out ^= PSI[i]
    return out


def H_cone(gens, box=4):
    """H_tau and a check that the box captured the full saturated lattice."""
    ker = []
    rng = range(-box, box + 1)
    for m in itertools.product(rng, repeat=4):
        if all(sum(m[i] * v[i] for i in range(4)) == 0 for v in gens):
            ker.append(m)
    span = {0}
    for m in ker:
        red = 0
        for i in range(4):
            if m[i] % 2:
                red |= 1 << i
        span |= {x ^ red for x in span}
    rank2 = len(span).bit_length() - 1
    expected = 4 - len(gens)          # tau^perp has rank 4 - dim(tau)
    H = [g for g in V4 if all(pairing(chi_m(m), g) == 0 for m in ker)]
    return H, rank2, expected


def main():
    out = []

    def say(*a):
        s = " ".join(str(x) for x in a)
        print(s)
        out.append(s)

    e = [(1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1)]
    v0, v1, v2 = (0, 1, 1, 1), (0, 0, 1, 1), (0, 1, 2, 1)
    tests = [
        ("E_V      (ray v0 = ell_V)", [v0], 1),
        ("E_z      (ray v1 = P~_z)", [v1], 2),
        ("E_s      (ray v2 = M~_s)", [v2], 2),
        ("cone(v0,e3) = M_s before T3", [v0, e[2]], 2),
        ("CORNER   tau = cone(v1,v2)", [v1, v2], 4),
    ]
    ok = True
    for name, gens, exp in tests:
        H, r, expected_rank = H_cone(gens)
        good = (len(H) == exp) and (r == expected_rank)
        say(f"{name:32s} |H_tau| = {len(H)}  H = {H}   "
            f"(saturated rank captured: {r}/{expected_rank})  "
            f"{'OK' if good else 'FAIL'}")
        ok &= good
    # kernels, named
    say("")
    say("ker(a) = ker(chi_z) = <z> = {0,2};  ker(b) = ker(chi_s) = <s> = {0,1};  "
        "encoding: g in F_2^2")
    Hz, _, _ = H_cone([v1])
    Hs, _, _ = H_cone([v2])
    Ht, _, _ = H_cone([v1, v2])
    say(f"G_{{E_z}} = {Hz} (order 2), G_{{E_s}} = {Hs} (order 2), "
        f"G_{{D_ij}} = {Ht} (order {len(Ht)})")
    say(f"G_{{E_z}} != G_{{E_s}}: {Hz != Hs}   G_{{D_ij}} = whole V4: {len(Ht) == 4}")
    ok &= (Hz != Hs and len(Ht) == 4)

    # unimodularity of the corner cone (so it is a smooth 2-cone of the fan)
    minors = [v1[i] * v2[j] - v1[j] * v2[i] for i in range(4) for j in range(4) if i < j]
    uni = any(abs(x) == 1 for x in minors)
    say(f"corner cone 2x2 minors {minors}; unimodular (smooth cone): {uni}")
    ok &= uni

    say("")
    say("CONCLUSION: Duncan's own toric formula gives G_{D_ij} = V4, NON-CYCLIC,")
    say("so the corner is FABULOUS by thm:pairs (line 728).  This agrees with the")
    say("independent chart computation in w1_corner_charts.m2.")
    tag = "TORIC_CORNER_" + ("OK" if ok else "FAIL")
    say(tag)
    here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    with open(os.path.join(here, "results", "toric_corner.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
