#!/usr/bin/env python3
"""Independent, fan-free replay of the F55 tropical lifting construction.

Context.  Proposition 3.3 of F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md
gives the tropical/Newton necessary condition for a Laurent zero of

    Phi(a) = sum_{i in Z/5} sigma^i( chi^{-e_2} a^2 sigma(a) ).

Writing nu(w) = min_{s in Newt(a)} <w,s> for the order function of a at a
weight w in N = {w in Z^5 : sum w_i = 0}, the condition is

    (T)  for every w, the minimum over i in Z/5 of
             F(sigma^i w) := 2 nu(sigma^i w) + nu(sigma^{i-1} w)
                             - <sigma^i w, e_2>
         is attained at least TWICE.

(The support-function/max form of Proposition 3.3 is the same statement read
at -w; see THEOREM_TROPICAL_INSUFFICIENCY.md, Lemma 1.)

The repository already established that (T) is satisfiable -- theory/FIX_IX_v14.md
sections 8.28 and 8.30, two independent engines.  This script re-derives the
LOAD-BEARING step of that construction from the checked-in witness data, using
no fan, no cell algebra and no wall list: only

  * the cellwise slopes U_d of the value-form witness d
    (director_probes_20260806/f55_qpre_data_P01.json, ..._P34.json),
  * the operator identity (2+x)G(x) = 33 in Z[x]/(x^5-1).

What is verified here
---------------------
1. d >= 0 at sampled lattice points and all their sigma-translates.
2. TWICE-MIN: at every sampled w, at least two of the five values d(sigma^i w)
   vanish.  Since m := sum_j d o sigma^j is sigma-invariant and F = d + m, this
   is exactly (T) for the lifted h.
3. THE LIFT.  Define h directly by the 33-identity,
        h(w) := (1/33) * sum_k g_k * G_t(sigma^{-k} w),
        G_t(w) := d(w) + m(w) + <w, e_2>,   G = 16 - 8x + 4x^2 - 2x^3 + x^4.
   Then
     (a) 2h(w) + h(sigma^{-1} w) - <w,e_2> = d(w) + m(w) identically
         (an algebraic consequence of (2+x)G(x) = 33);
     (b) h is INTEGER valued at every sampled lattice point -- the lift is
         integral, not merely rational;
     (c) the twice-min of (T) holds for h itself, computed from h alone.
4. THE CRT SPLIT of section 8.28, re-derived rather than assumed:
     mod 3  the divisibility is AUTOMATIC once m = sum_j d o sigma^j is chosen,
            because G = 1+x+x^2+x^3+x^4 mod 3 and sum_i w_i = 0 on N;
     mod 11 the divisibility is a genuine congruence on d -- congruence (3).
   Negative control: perturbing d breaks the mod-11 layer, so the test is live.

Terminal marker: F55_TROPICAL_LIFT_REPLAY_OK
"""

import json
import os
import random
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
PROBES = os.path.normpath(os.path.join(HERE, "..", "..",
                                       "director_probes_20260806"))

G_COEFFS = [16, -8, 4, -2, 1]          # G(x) = 16 - 8x + 4x^2 - 2x^3 + x^4

FAIL = []


def check(name, cond, detail=""):
    print(f"  [{'OK  ' if cond else 'FAIL'}] {name}" + (f"   {detail}" if detail else ""))
    if not cond:
        FAIL.append(name)


# --------------------------------------------------------------------------

def shift_plus(w):
    """(sigma w)_i = w_{i-1}."""
    return tuple(w[(i - 1) % 5] for i in range(5))


def shift_minus(w):
    return tuple(w[(i + 1) % 5] for i in range(5))


def dot(u, v):
    return sum(a * b for a, b in zip(u, v))


class Witness:
    def __init__(self, path):
        data = json.load(open(path))
        self.pattern = data["pattern"]
        self.normals = [tuple(v) for v in data["normals"]]
        self.ud = {k: tuple(v) for k, v in data["ud"].items()}
        self.walls = data["walls"]

    def cell(self, w):
        s = []
        for nu in self.normals:
            x = dot(nu, w)
            if x == 0:
                return None
            s.append("+" if x > 0 else "-")
        return "".join(s)

    def d(self, w):
        c = self.cell(w)
        if c is None or c not in self.ud:
            return None
        return dot(self.ud[c], w)


def random_lattice_point(rng, bound=40):
    while True:
        v = [rng.randint(-bound, bound) for _ in range(4)]
        v.append(-sum(v))
        if any(v):
            return tuple(v)


def orbit(w, shift):
    o = [w]
    for _ in range(4):
        o.append(shift(o[-1]))
    return o


def analyse(W, shift, e2_index, samples, rng):
    """Return per-sample data or None if the cell lookup fails."""
    out = []
    for _ in range(samples):
        w = random_lattice_point(rng)
        orb = orbit(w, shift)
        ds = [W.d(x) for x in orb]
        if any(x is None for x in ds):
            continue
        # <sigma^i w, e_2>
        ls = [x[e2_index] for x in orb]
        out.append((w, orb, ds, ls))
    return out


def main():
    print("F55 tropical lift -- independent fan-free replay")
    print("=" * 72)
    rng = random.Random(20260811)

    paths = [os.path.join(PROBES, f)
             for f in ("f55_qpre_data_P01.json", "f55_qpre_data_P34.json")]
    for p in paths:
        check(f"witness data present: {os.path.basename(p)}", os.path.exists(p))
    if FAIL:
        raise SystemExit(1)

    # ---------------------------------------------------------------
    # 0. calibrate the two sign conventions (sigma direction, e_2 slot)
    # ---------------------------------------------------------------
    print("\n0. convention calibration (the repo pins sigma_M = shift_-1; we")
    print("   re-derive the working convention from 33-integrality alone)")
    W = Witness(paths[0])
    best = None
    for sname, shift in (("shift_+1", shift_plus), ("shift_-1", shift_minus)):
        for e2i in range(5):
            data = analyse(W, shift, e2i, 200, random.Random(7))
            if not data:
                continue
            ok = 0
            for w, orb, ds, ls in data:
                Dsum = sum(ds)
                Gt = [ds[i] + Dsum + ls[i] for i in range(5)]
                good = True
                for i in range(5):
                    num = sum(G_COEFFS[k] * Gt[(i - k) % 5] for k in range(5))
                    if num % 33 != 0:
                        good = False
                        break
                ok += good
            if best is None or ok > best[0]:
                best = (ok, sname, shift, e2i, len(data))
    ok, sname, shift, e2i, ntest = best
    print(f"    best convention: sigma = {sname}, <w,e_2> = w[{e2i}]")
    print(f"    33-integrality of the lift held at {ok} of {ntest} samples")
    check("a convention exists in which the 33-lift is integral at EVERY "
          "sampled point", ok == ntest and ntest > 100,
          f"{ok}/{ntest}")

    # ---------------------------------------------------------------
    # 1-4. the substantive checks, on both witness families
    # ---------------------------------------------------------------
    for path in paths:
        name = os.path.basename(path)
        print(f"\n--- witness family {name} (pattern shown below) ---")
        W = Witness(path)
        print(f"    pattern = {W.pattern}, cells = {len(W.ud)}, "
              f"normals = {len(W.normals)}, walls = {len(W.walls)}")
        data = analyse(W, shift, e2i, 4000, rng)
        check(f"[{name}] generic lattice samples obtained", len(data) > 3000,
              f"{len(data)} generic of 4000 drawn")

        neg = sum(1 for _, _, ds, _ in data if any(x < 0 for x in ds))
        check(f"[{name}] 1. d >= 0 at every sample and every sigma-translate",
              neg == 0, f"{neg} violations in {5*len(data)} evaluations")

        bad_tm = sum(1 for _, _, ds, _ in data if sum(1 for x in ds if x == 0) < 2)
        check(f"[{name}] 2. TWICE-MIN: at least two of the five d(sigma^i w) "
              f"vanish", bad_tm == 0,
              f"{bad_tm} violations in {len(data)} samples")
        mult = {}
        for _, _, ds, _ in data:
            k = sum(1 for x in ds if x == 0)
            mult[k] = mult.get(k, 0) + 1
        print(f"        multiplicity histogram of the minimum: "
              f"{dict(sorted(mult.items()))}")

        bad_a = bad_b = bad_c = 0
        bad_11 = bad_3 = 0
        for w, orb, ds, ls in data:
            Dsum = sum(ds)
            Gt = [ds[i] + Dsum + ls[i] for i in range(5)]
            hnum = [sum(G_COEFFS[k] * Gt[(i - k) % 5] for k in range(5))
                    for i in range(5)]
            # (b) integrality of h
            if any(x % 33 != 0 for x in hnum):
                bad_b += 1
            h = [Fraction(x, 33) for x in hnum]
            # (a) the defining identity  2h_i + h_{i-1} - l_i = d_i + m
            for i in range(5):
                if 2 * h[i] + h[(i - 1) % 5] - ls[i] != ds[i] + Dsum:
                    bad_a += 1
                    break
            # (c) twice-min read off h itself
            F = [2 * h[i] + h[(i - 1) % 5] - ls[i] for i in range(5)]
            mn = min(F)
            if sum(1 for x in F if x == mn) < 2:
                bad_c += 1
            # (4) the CRT split
            if any(x % 3 != 0 for x in hnum):
                bad_3 += 1
            if any(x % 11 != 0 for x in hnum):
                bad_11 += 1

        check(f"[{name}] 3a. 2h(w) + h(sigma^-1 w) - <w,e_2> = d + m "
              f"identically", bad_a == 0, f"{bad_a} violations")
        check(f"[{name}] 3b. the lift h is INTEGER valued (33 divides the "
              f"numerator)", bad_b == 0, f"{bad_b} violations")
        check(f"[{name}] 3c. twice-min of (T) holds when read off h alone",
              bad_c == 0, f"{bad_c} violations")
        check(f"[{name}] 4a. the mod-3 layer holds", bad_3 == 0,
              f"{bad_3} violations")
        check(f"[{name}] 4b. the mod-11 layer (congruence (3)) holds",
              bad_11 == 0, f"{bad_11} violations")

    # ---------------------------------------------------------------
    # 5. the mod-3 layer is automatic; the mod-11 layer is not
    # ---------------------------------------------------------------
    print("\n5. structure of the CRT split, re-derived")
    g3 = [c % 3 for c in G_COEFFS]
    check("G(x) = 1 + x + x^2 + x^3 + x^4  (mod 3)", g3 == [1, 1, 1, 1, 1],
          f"G mod 3 = {g3}")
    print("        => (G*d)_i = sum_j d_j = m (mod 3) for every i, and")
    print("           (G*l)_i = sum_i w_i = 0 (mod 3) because w lies in N;")
    print("           with the free sigma-invariant term contributing 11m,")
    print("           the numerator is m + 0 + 11m = 12m = 0 (mod 3).")
    print("        The mod-3 layer is therefore automatic once m = sum_j d o")
    print("        sigma^j is chosen.  This is section 8.28's 'mod-3 surprise',")
    print("        satisfiable exactly because m is free.")
    g11 = [c % 11 for c in G_COEFFS]
    print(f"        G mod 11 = {g11}: NOT the all-ones vector, so the mod-11")
    print("        layer is a genuine congruence on d -- congruence (3).")
    check("G(x) is not constant-coefficient mod 11 (the layer is live)",
          len(set(g11)) > 1)

    # negative control: perturb d and watch the mod-11 layer break
    print("\n6. negative control (the integrality test is live, not vacuous)")
    W = Witness(paths[0])
    data = analyse(W, shift, e2i, 400, random.Random(99))
    broke = 0
    for w, orb, ds, ls in data:
        pert = list(ds)
        pert[0] += 1                      # a unit perturbation of the witness
        Dsum = sum(pert)
        Gt = [pert[i] + Dsum + ls[i] for i in range(5)]
        hnum = [sum(G_COEFFS[k] * Gt[(i - k) % 5] for k in range(5))
                for i in range(5)]
        if any(x % 33 != 0 for x in hnum):
            broke += 1
    check("a unit perturbation of d destroys 33-integrality at (almost) every "
          "sample", broke > 0.9 * len(data),
          f"{broke} of {len(data)} samples now fail")

    print()
    if FAIL:
        print("FAILURES: " + ", ".join(FAIL))
        raise SystemExit(1)
    print("F55_TROPICAL_LIFT_REPLAY_OK")


if __name__ == "__main__":
    main()
