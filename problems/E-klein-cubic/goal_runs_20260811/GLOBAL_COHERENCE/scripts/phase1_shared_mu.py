"""Phase 1 — shared-mu enumeration of the 22 immune rows.

For each residue d mod 330:
  F_odd(d) = #{distinct joint value-vectors of the 22 rows}

under joint mu-assignments per center orbit (sharing ON), subject to the
sealed second-order constraints.  With sharing OFF the A4 block reproduces
3^8 and the C5/C11 blocks are single-pattern (STAGE2 §4 anchors).

Reuses s2pin.IMMUNE_ROWS, pathA_weight, pathB_* — never rewrites them.
"""
import json
import os
import sys
from collections import defaultdict
from itertools import product

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from paths import RESULTS, K_TABLE  # noqa: E402
from centers import (  # noqa: E402
    CENTERS, ROW_ORDER, center_value_vectors, residual_count_A4,
    admissible_mus_A4, admissible_mus_C11, admissible_mus_C5,
    admissible_mus_D10, row_weight, d10_branch_for_mu0,
)
from s2pin import (  # noqa: E402
    pathA_weight, pathB_level0, pathB_level1, pathB_level2,
    IMMUNE_ROWS, QR11, SPECTRUM,
)


def f_odd_factors(d, sharing=True):
    """Per-center pattern counts and the vector lists (not the full product)."""
    factors = {}
    for c in CENTERS:
        vecs = sorted(center_value_vectors(c, d, sharing=sharing))
        factors[c["id"]] = {
            "n": len(vecs),
            "nrows": len(c["rows"]),
            "row_names": [r["name"] for r in c["rows"]],
            "vectors": [list(v) for v in vecs],
        }
    return factors


def f_odd_count(d, sharing=True):
    """F_odd(d) = product of per-center pattern counts (centers independent)."""
    fac = f_odd_factors(d, sharing=sharing)
    n = 1
    for c in CENTERS:
        n *= fac[c["id"]]["n"]
    return n, fac


def config_count_A4_orbit(d, base, sharing=True):
    """Number of residual assignments for one A4 orbit (configuration count,
    not distinct-vector count — used as a diagnostic)."""
    if not sharing:
        return 3 ** 4
    total = 0
    rows = [r for r in IMMUNE_ROWS if r["n"] == 3 and r["base"] == base]
    seen = set()
    for mu1, mu2 in admissible_mus_A4():
        rc = residual_count_A4(mu1)
        if rc is None:
            continue
        weights = []
        for r in rows:
            ch = r["chain"]
            mus = (mu1,) if len(ch) == 1 else (mu1, mu2)
            weights.append(row_weight(3, d, base, ch, mus))
        key = (tuple(weights), rc)
        if key in seen:
            continue
        seen.add(key)
        if rc == 0:
            total += 1
        else:
            n = 1
            for w in weights:
                n *= (1 if w == 0 else rc)
            total += n
    return total


def H_immune_D10(d, sharing=True):
    """Join of immune residuals with the D10 C2-line branch under shared mu0.

    Counts configurations:
        product over non-D10 centers of (# patterns)
        times sum_{mu0 admissible} D10_branch(mu0) * 1_{D10 pattern of mu0}

    Since each mu0 gives one D10 pattern and branch size 13 or 10,
        sum_mu0 branch(mu0) = 13+10+13+10 = 46
    (mu0 = 1,2,3,4).  With sharing off the same D10 sum is used (single
    pattern per mu0 class still), and A4 contributes 3^8.

    This is the factor that replaces D10(mu1) * 3^8 in the product formula
    when patterns are summed over admissible mu rather than fixed per map.
    """
    n_other = 1
    for c in CENTERS:
        if c["id"] == "D10":
            continue
        vecs = center_value_vectors(c, d, sharing=sharing)
        n_other *= len(vecs)
    # D10: sum over mu0 of branch size (each mu0 gives a distinct pattern
    # among {1,2,3,4}, and both parities appear twice)
    d10_sum = sum(d10_branch_for_mu0(mu0, d) for mu0 in admissible_mus_D10())
    return n_other * d10_sum, n_other, d10_sum


def run_phase1(mod=330, verbose=True):
    os.makedirs(RESULTS, exist_ok=True)
    records = []
    F_on = []
    F_off = []
    # store per-center factors for every residue (compact); full joint
    # vectors = cartesian product of the per-center lists
    factors_on = {}
    factors_off = {}
    H_on = []
    H_off = []

    for d in range(mod):
        n_on, fac_on = f_odd_count(d, sharing=True)
        n_off, fac_off = f_odd_count(d, sharing=False)
        h_on, _, d10s_on = H_immune_D10(d, sharing=True)
        h_off, _, d10s_off = H_immune_D10(d, sharing=False)
        F_on.append(n_on)
        F_off.append(n_off)
        H_on.append(h_on)
        H_off.append(h_off)
        # store factors only as counts + vectors for a representative of
        # each (d mod 165) class to keep the artifact small; full data for
        # d=35 and for every residue the counts.
        rec = {
            "d_mod_330": d,
            "d_mod_6": d % 6,
            "d_mod_3": d % 3,
            "d_mod_5": d % 5,
            "d_mod_11": d % 11,
            "d_mod_165": d % 165,
            "F_odd": n_on,
            "F_odd_sharing_off": n_off,
            "H_immune_D10": h_on,
            "H_immune_D10_sharing_off": h_off,
            "d10_branch_sum": d10s_on,
            "factors": {cid: fac_on[cid]["n"] for cid in fac_on},
            "factors_off": {cid: fac_off[cid]["n"] for cid in fac_off},
        }
        records.append(rec)
        if d == 35 or d % 165 == d:   # always true; store full factors for d=35
            pass
        if d == 35:
            factors_on["35"] = fac_on
            factors_off["35"] = fac_off
        # store full factor vectors for every residue class mod 165 (period
        # of the odd-order layer) — 165 is enough; F_odd depends only on
        # (d mod 3,5,11) through the congruence, plus second-order is
        # d-independent at A4.
        key165 = str(d % 165)
        if key165 not in factors_on:
            factors_on[key165] = fac_on
            factors_off[key165] = fac_off

    # profile
    profile = {
        "mod": mod,
        "F_odd_min": min(F_on),
        "F_odd_max": max(F_on),
        "F_odd_typical": sorted(F_on)[len(F_on) // 2],
        "F_odd_sharing_off_min": min(F_off),
        "F_odd_sharing_off_max": max(F_off),
        "F_odd_at_35": F_on[35],
        "H_at_35": H_on[35],
        "A4_block_sharing_off": 3 ** 8,
        "unique_F_odd_values": sorted(set(F_on)),
    }

    with open(os.path.join(RESULTS, "F_odd_counts.json"), "w") as f:
        json.dump({
            "profile": profile,
            "records": records,
        }, f, indent=1)

    with open(os.path.join(RESULTS, "F_odd_factors.json"), "w") as f:
        json.dump({
            "note": (
                "Per-center value-vector lists.  Joint 22-row vectors are "
                "the cartesian product over centers (independent orbits).  "
                "Keyed by d mod 165 (the odd-order lattice)."
            ),
            "sharing_on": factors_on,
            "sharing_off": factors_off,
        }, f)

    with open(os.path.join(RESULTS, "F_odd_table.txt"), "w") as f:
        f.write("F_odd(d mod 330)  shared-mu enumeration of the 22 immune rows\n")
        f.write("profile: min=%d max=%d typical=%d  F_odd(35)=%d\n"
                % (profile["F_odd_min"], profile["F_odd_max"],
                   profile["F_odd_typical"], profile["F_odd_at_35"]))
        f.write("sharing-off A4 block target: 3^8 = %d\n\n" % (3 ** 8))
        f.write("%5s %4s %4s %4s %4s %12s %12s %14s\n"
                % ("d", "d6", "d3", "d5", "d11", "F_odd", "F_off", "H_imm_D10"))
        for r in records:
            f.write("%5d %4d %4d %4d %4d %12d %12d %14d\n"
                    % (r["d_mod_330"], r["d_mod_6"], r["d_mod_3"],
                       r["d_mod_5"], r["d_mod_11"], r["F_odd"],
                       r["F_odd_sharing_off"], r["H_immune_D10"]))

    if verbose:
        print("Phase1 profile:", json.dumps(profile, indent=2))
        # sharing-off A4 check at d=35
        fac = factors_off["35"]
        a4 = fac["A4a"]["n"] * fac["A4b"]["n"]
        print("sharing-off A4 block at d=35: %d  (target 3^8=%d)" % (a4, 3 ** 8))
        print("sharing-off C11/C5/D10 at d=35:",
              {k: fac[k]["n"] for k in ("C11", "C5a", "C5b", "D10")})
        print("sharing-on  factors at d=35:",
              {k: factors_on["35"][k]["n"] for k in factors_on["35"]})
        print("PHASE1_OK")
    return profile, records


def path_crosscheck(max_d=40):
    """Reuse the s2pin two-path w(R) cross-check (same scope as s2tables)."""
    bad = 0
    tested = 0
    for n in (3, 5, 6, 11):
        a = SPECTRUM[n]["weights"]
        for d in range(1, max_d):
            b0 = pathB_level0(n, d)
            for k in range(5):
                wA = pathA_weight(n, d, a[k], [])
                tested += 1
                if wA != b0[k][0]:
                    bad += 1
            for mu in range(0, min(d, 13) + 1):
                b1 = pathB_level1(n, d, 0, mu)
                for j, (wB, _) in b1.items():
                    c = (a[j] - a[0]) % n
                    wA = pathA_weight(n, d, a[0], [(mu, c)])
                    tested += 1
                    if wA != wB:
                        bad += 1
                for mu2 in range(0, mu + 1):
                    b2 = pathB_level2(n, d, 0, 1, mu, mu2)
                    for j2, (wB, _) in b2.items():
                        c1 = (a[1] - a[0]) % n
                        c2 = (a[j2] - a[1]) % n
                        wA = pathA_weight(n, d, a[0], [(mu, c1), (mu2, c2)])
                        tested += 1
                        if wA != wB:
                            bad += 1
    return {"tested": tested, "mismatches": bad}


if __name__ == "__main__":
    cc = path_crosscheck()
    print("path A/B crosscheck:", cc)
    run_phase1()
