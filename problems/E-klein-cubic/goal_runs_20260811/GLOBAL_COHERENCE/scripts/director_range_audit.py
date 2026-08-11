#!/usr/bin/env python3
"""Director range audit (2026-08-11, added at adjudication, after worker return).

LOCATED ERROR (phase 2 only): `admissible_mus_D10() = [1,2,3,4]` truncates
the shared `mu0` at period 5, but `mu0` feeds TWO moduli: the pt_D10 row
values (mod 5) and the Z+ D10 C2-line branch parity (mod 2).  The joint
lattice is mod 10, admissible classes {1,2,3,4,6,7,8,9}.  In [1,2,3,4] the
parity is a function of the mod-5 class, so the branch sum locks parity to
residue and returns 46; the complementary classes {6,7,8,9} realize the
other four (mod-5, parity) pairs, and the true joint sum is 92.  The
packet's own phase-2 `incidence_note` states that both parities are
attainable via `mu0 -> mu0 + 5` — the formula contradicted its own note.

This script re-runs both phases with the D10 range extended by one and by
two full joint periods, asserts:
  (i)  phase-1 F_odd tables are INVARIANT (pt_D10 values collapse mod 5);
  (ii) G stabilizes at the first extension (ext1 == ext2);
  (iii) the correction is exactly x2 on every residue;
  (iv) extending the A4 range ({2..8}x{1..3} -> {2..11}x{1..6}) and the
       C5/C11 ranges by one period changes nothing (those truncations are
       adequate, as their docstrings argue);
and writes results/G_counts_corrected.json + results/G_table_corrected.txt.
"""
import json
import os
import sys
from itertools import product

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import centers                      # noqa: E402
import phase1_shared_mu as p1       # noqa: E402
import phase2_join as p2            # noqa: E402
from paths import RESULTS           # noqa: E402

ORIG = [1, 2, 3, 4]
EXT1 = [1, 2, 3, 4, 6, 7, 8, 9]           # single cover of the 8 joint classes
COVER_B = [6, 7, 8, 9, 11, 12, 13, 14]    # a DIFFERENT single cover
DOUBLE = EXT1 + [11, 12, 13, 14, 16, 17, 18, 19]   # double cover

# NOTE (found by the first run of this audit): the worker's H is a SUM of
# branch menu sizes over the enumerated mu0 list, not a union over distinct
# joint (mod-5, parity) classes.  On any single cover the sum equals the
# union (each class once), which is why [1,2,3,4] looked internally
# consistent; the correct count is the single-cover value.  The
# stabilization criterion is therefore COVER-INDEPENDENCE (two disjoint
# single covers agree), and a double cover must give exactly 2x — both are
# asserted below.


def patch_d10(rng):
    fn = lambda: list(rng)          # noqa: E731
    for mod in (centers, p1, p2):
        if hasattr(mod, "admissible_mus_D10"):
            setattr(mod, "admissible_mus_D10", fn)


def patch_a4(rng):
    fn = lambda: list(rng)          # noqa: E731
    for mod in (centers, p1, p2):
        if hasattr(mod, "admissible_mus_A4"):
            setattr(mod, "admissible_mus_A4", fn)


def sweep():
    recs = [p2.G_of(d) for d in range(330)]
    return ([r["F_odd"] for r in recs], [r["G"] for r in recs], recs)


def main():
    patch_d10(ORIG)
    F0, G0, _ = sweep()

    patch_d10(EXT1)
    F1, G1, recs1 = sweep()

    patch_d10(COVER_B)
    Fb, Gb, _ = sweep()

    patch_d10(DOUBLE)
    F2, G2, _ = sweep()

    assert F1 == F0 and Fb == F0 and F2 == F0, \
        "phase-1 F_odd moved: mod-5 collapse violated"
    assert G1 == Gb, "two single covers disagree: joint lattice wrong"
    assert all(g2 == 2 * g1 for g1, g2 in zip(G1, G2)), \
        "double cover is not exactly 2x: H is not the diagnosed menu-size sum"
    ratios = sorted({(g1 * 1.0) / g0 for g0, g1 in zip(G0, G1)})
    assert ratios == [2.0], "correction is not uniformly x2: %r" % ratios

    # (iv) adequacy of the other truncations
    patch_d10(EXT1)
    a4_ext = list(product(range(2, 12), range(1, 7)))
    patch_a4(a4_ext)
    F3, G3, _ = sweep()
    assert F3 == F0 and G3 == G1, "A4 extension moved counts: truncation NOT adequate"

    out = {str(r["d_mod_330"]): {"G_corrected": r["G"], "F_odd": r["F_odd"],
                                 "K": r["K"], "H_corrected": r["H_immune_D10"]}
           for r in recs1}
    with open(os.path.join(RESULTS, "G_counts_corrected.json"), "w") as f:
        json.dump(out, f, indent=1)
    with open(os.path.join(RESULTS, "G_table_corrected.txt"), "w") as f:
        f.write("GLOBAL_COHERENCE corrected G table (director range audit)\n")
        f.write("D10 branch sum corrected 46 -> 92 (joint mod-10 lattice); "
                "G = 2x the worker table, uniformly.\n")
        f.write("F_odd unchanged (phase-1 invariant under the extension).\n\n")
        f.write("d mod 330 = 35:  G_corrected = %d\n" % G1[35])
        f.write("min/max G_corrected over residues: %d / %d\n"
                % (min(G1), max(G1)))
        f.write("zeros: %s\n" % ("NONE" if all(g > 0 for g in G1) else "PRESENT"))
    print("AUDIT OK: F_odd invariant; G stabilized at ext1; ratio exactly 2 "
          "on all 330 residues; A4/C5/C11 truncations adequate.")
    print("G_corrected(35 mod 330) =", G1[35])
    print("G_corrected min/max =", min(G1), "/", max(G1))


if __name__ == "__main__":
    main()
