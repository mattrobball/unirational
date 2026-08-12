#!/usr/bin/env python3
"""CELL_SYNTHESIS verifier.  python3 verifier.py

Group A — identity of the 22 and the uncollapsed menus (fatal: if any
          A check fails, B and C still run, but ALLGREEN is refused).
Group B — every sealed constant this packet consumes, re-read at source.
Group C — CRT, forced depths, genus-0 zeros, intersection emptiness,
          headline, no claimed kill.

Exact integer arithmetic; python3 standard library only.
Writes results/verifier_output.json.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))
import paths as P  # noqa: E402
from assemble import (  # noqa: E402
    HEADLINE,
    L12_EXTENDED,
    crt_chi0,
    forced_depth_from_l12,
    joint_genera,
    sha256_of,
)

CHECKS = []


def chk(group, name, ok, detail=""):
    CHECKS.append({
        "group": group,
        "name": name,
        "pass": bool(ok),
        "detail": str(detail)[:500],
    })
    return bool(ok)


def load(path):
    with open(path) as f:
        return json.load(f)


def replay_assemble():
    r = subprocess.run(
        [sys.executable, os.path.join(HERE, "scripts", "assemble.py")],
        cwd=HERE,
        capture_output=True,
        text=True,
    )
    return r.returncode == 0, r.stdout + r.stderr


def main():
    ok_run, out = replay_assemble()
    chk("A", "A0 assemble.py replays", ok_run and "CELL_SYNTHESIS_ASSEMBLE_OK" in out,
        out[-400:])

    syn = load(os.path.join(P.RESULTS, "synthesis.json"))
    smith = load(P.SMITH)
    stein_ledger = load(P.STEIN_LEDGER)
    stein_menus = load(P.STEIN_MENUS)
    l12 = load(P.L12)
    depth_sum = load(P.DEPTH_SUM)
    keep331 = load(P.KEEP_331)
    keep661 = load(P.KEEP_661)
    vectors = load(P.VECTORS)
    audit = load(P.AUDIT)

    # ---- A: identity + menus ----
    ids = audit["survivors22"]["ids"]
    hashes = audit["survivors22"]["content_hashes"]
    chk("A", "A1 22 ids",
        len(ids) == 22
        and [c["cell_id"] for c in syn["cells"]] == ids)
    chk("A", "A1b 22 unique hashes", len(hashes) == 22 and len(set(hashes)) == 22)
    chk("A", "A2 sealed id list",
        ids == [5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47,
                53, 55, 61, 63, 69, 71, 697, 699, 701, 703])
    chk("A", "A3 SMITH ids match AUDIT",
        [c["cell_id"] for c in smith["cells"]] == ids)
    chk("A", "A4 SMITH hashes match AUDIT",
        [c["content_hash_p331"] for c in smith["cells"]] == hashes)
    chk("A", "A5 STEIN ids match AUDIT", stein_menus["cells_22_ids"] == ids)
    chk("A", "A6 STEIN hashes match AUDIT",
        stein_menus["cells_22_content_hashes_p331"] == hashes)
    chk("A", "A7 STEIN ledger 22 rows", stein_ledger["n_rows"] == 22)
    chk("A", "A8 packet cells 22", syn["n_cells"] == 22 and len(syn["cells"]) == 22)
    chk("A", "A9 packet keyed by AUDIT hashes",
        [c["content_hash_p331"] for c in syn["cells"]] == hashes)
    chk("A", "A10 sigma-band shared", syn["identity"]["sigma_band_shared"] is True)
    band = syn["identity"]["sigma_band"]
    chk("A", "A11 sigma-band values",
        band["m_options_L"] == [35] and band["m_options_P"] == [1]
        and band["a35_L_options"] == [[35, 0]] and band["a35_P_options"] == [[34, 1]]
        and band["min_m"] == 1 and band["max_m"] == 1)

    factors = vectors["per_center"]
    prod = 1
    for k in ("C11", "C5a", "C5b", "D10", "A4a", "A4b"):
        prod *= factors[k]["n"]
    chk("A", "A12 F_odd product 36252160",
        prod == 36252160 == vectors["F_odd"] == syn["menus"]["product"])
    chk("A", "A13 factor sizes uncollapsed",
        syn["menus"]["factor_sizes"] == {"C11": 10, "C5a": 4, "C5b": 4,
                                         "D10": 4, "A4a": 238, "A4b": 238})
    chk("A", "A14 cell-menu pairs 797547520",
        syn["menus"]["n_cell_menu_pairs"] == 22 * 36252160 == 797547520)
    chk("A", "A15 C11 menu has 10 distinct vectors",
        len(factors["C11"]["vectors"]) == 10
        and len(set(map(tuple, factors["C11"]["vectors"]))) == 10)
    smith_vecs = {tuple(e["vector"]) for e in smith["orders"]["11"]["menu"]}
    vec_vecs = {tuple(v) for v in factors["C11"]["vectors"]}
    chk("A", "A16 C11 vector SET matches SMITH (not collapsed)",
        smith_vecs == vec_vecs and len(smith_vecs) == 10)
    chk("A", "A17 C5 joint menu 64",
        len(smith["orders"]["5"]["menu"]) == 64
        and syn["menus"]["C5_joint_64"]["n"] == 64)
    chk("A", "A18 C5 n_x uniform (5,5,5,5)",
        syn["menus"]["C5_joint_64"]["n_x_uniform"] is True)
    chk("A", "A19 A4 menus 238+238 not collapsed",
        syn["menus"]["A4a"]["n"] == 238 and syn["menus"]["A4b"]["n"] == 238
        and syn["menus"]["A4a"]["n_vectors"] == 238
        and syn["menus"]["A4b"]["n_vectors"] == 238)
    a4 = load(os.path.join(P.RESULTS, "a4_vectors.json"))
    chk("A", "A20 A4a sha matches sealed vectors",
        sha256_of(a4["A4a"]) == syn["menus"]["A4a"]["vectors_sha256"]
        and sha256_of(factors["A4a"]["vectors"]) == syn["menus"]["A4a"]["vectors_sha256"])
    chk("A", "A21 A4b sha matches sealed vectors",
        sha256_of(a4["A4b"]) == syn["menus"]["A4b"]["vectors_sha256"]
        and sha256_of(factors["A4b"]["vectors"]) == syn["menus"]["A4b"]["vectors_sha256"])
    chk("A", "A22 no cell-to-menu linkage (SMITH)",
        smith["menu"]["linkage"].startswith("NOT DETERMINED"))

    # ---- B: sealed constants ----
    chk("B", "B1 SMITH d=35", smith["d"] == 35 and smith["n_cells"] == 22)
    chk("B", "B2 SMITH n_cell_menu_pairs",
        smith["n_cell_menu_pairs"] == 797547520)
    chk("B", "B3 SMITH order-11 n_x=4",
        smith["orders"]["11"]["n_x_on_Z"] == 4)
    chk("B", "B4 SMITH order-5 n_x=5 and uniform",
        smith["orders"]["5"]["n_x"] == {"1": 5, "2": 5, "3": 5, "4": 5}
        and smith["orders"]["5"]["uniform_across_menu"] is True)
    chk("B", "B5 SMITH order-5 menu size 64", smith["orders"]["5"]["menu_size"] == 64)
    chk("B", "B6 SMITH order-3 parametric",
        smith["orders"]["3"]["status"] == "PARAMETRIC")
    chk("B", "B7 SMITH F_odd factors",
        smith["menu"]["factors"] == {"A4a": 238, "A4b": 238, "C11": 10,
                                     "C5a": 4, "C5b": 4, "D10": 4})
    chk("B", "B8 STEIN chi0_mod_55 is [35]",
        stein_menus["menus"]["JOINT_flat_smooth"]["chi_0_mod_55"] == [35])
    brA = stein_menus["menus"]["JOINT_flat_smooth"]["branch_A"]
    brB = stein_menus["menus"]["JOINT_flat_smooth"]["branch_B"]
    chk("B", "B9 STEIN branch A chi0<=-20, h1==21 mod 55",
        brA["condition"] == "chi_0 <= -20" and brA["connected_case"]["h1_mod_55"] == 21)
    chk("B", "B10 STEIN branch B s>=35",
        brB["condition"] == "chi_0 >= 35" and "s >= 35" in brB["consequence"])
    chk("B", "B11 STEIN RH first common genus 21",
        stein_menus["menus"]["JOINT_flat_smooth"]["cross_check_RH"]["common_solutions"][0] == 21)
    chk("B", "B12 STEIN ledger both branches live on every row",
        all("BOTH BRANCHES LIVE" in r["verdict"] for r in stein_ledger["rows"]))
    chk("B", "B13 L12 json totals 1540/0/118/0",
        l12["totals"] == {"towers": 1540, "genus0": 0, "integral": 118, "menu": 0})
    chk("B", "B14 L12 genus0 pass is 0 on every mu",
        all(l12["genus0_and_menu"][str(mu)]["n_genus0_pass"] == 0 for mu in range(1, 11)))
    chk("B", "B15 L12 menu pass is 0 on every mu",
        all(l12["genus0_and_menu"][str(mu)]["n_menu_pass"] == 0 for mu in range(1, 11)))
    chk("B", "B16 L12 cells.verified (constancy over 22)",
        l12["cells"]["verified"] is True)
    chk("B", "B17 L12 extended-scope sealed numbers",
        L12_EXTENDED["n_towers"] == 2674
        and L12_EXTENDED["n_integral"] == 226
        and L12_EXTENDED["n_genus0_pass"] == 0
        and L12_EXTENDED["n_menu_pass"] == 0)
    # parse THEOREM.md for the extended-scope digits
    with open(P.L12_THM) as f:
        thm = f.read()
    chk("B", "B18 L12 THEOREM contains 2674 and 0 of 2674",
        "2674" in thm and "0 of 2674" in thm)
    chk("B", "B19 L12 THEOREM contains 226 integrality-survivors",
        "226 integrality-survivors" in thm or "226 integral" in thm)
    chk("B", "B20 DEPTH keep-pass 0 dead / 22 live / dim 37 both primes",
        keep331["n_dead"] == 0 and keep331["n_live"] == 22
        and keep331["live_dims"] == [37]
        and keep661["n_dead"] == 0 and keep661["n_live"] == 22
        and keep661["live_dims"] == [37]
        and depth_sum["keep_pass_d35"]["n_dead_closed"] == 0)
    chk("B", "B21 DEPTH period hist rid1 36/6/12",
        depth_sum["general_table"]["rid1_period_histogram"] == {"1": 36, "2": 6, "3": 12})
    chk("B", "B22 DEPTH period hist rid2 12/6",
        depth_sum["general_table"]["rid2_period_histogram"] == {"2": 12, "3": 6})
    chk("B", "B23 vectors_d35 d/F_odd/K",
        vectors["d"] == 35 and vectors["F_odd"] == 36252160 and vectors["K"] == 756)
    chk("B", "B24 AUDIT split 756=336+398+22",
        audit["split"]["total"] == 756
        and audit["split"]["ord0_L_survivors"] == 22
        and audit["n_patterns"] == 756)
    chk("B", "B25 keep_pass content_hash SET equals AUDIT",
        set(d["content_hash"] for d in keep331["detail"]) == set(hashes))
    chk("B", "B26 keep_pass id<->hash pairing FLAG is recorded",
        syn["identity"]["keep_pass_id_hash_pairing_FLAG"] is True)
    chk("B", "B27 STEIN menus cell-independent",
        stein_menus["menus_are_cell_independent"] is True)
    chk("B", "B28 STEIN C11 n_x constant",
        stein_menus["C11_n_x_constant"] is True
        and stein_menus["C5_n_x_constant"] is True)
    chk("B", "B29 C11 defined-rows never 4 (STAGE2 Thm 2.1)",
        max(e["n_defined_rows"] for e in smith["orders"]["11"]["menu"]) == 3
        and 4 not in [e["n_defined_rows"] for e in smith["orders"]["11"]["menu"]])

    # ---- C: derived intersection ----
    crt = crt_chi0()
    chk("C", "C1 CRT chi0 == 35 (mod 55)",
        crt["chi0_mod_55"] == 35 and crt["chi0_mod_11"] == 2 and crt["chi0_mod_5"] == 0)
    chk("C", "C2 packet CRT matches in-packet recompute",
        syn["crt"]["chi0_mod_55"] == 35)
    genera = joint_genera()
    chk("C", "C3 first joint genus is 21, then 76",
        genera[:4] == [21, 76, 131, 186])
    chk("C", "C4 joint genera are 21 (mod 55)",
        all((g - 21) % 55 == 0 for g in genera))
    depths = forced_depth_from_l12(l12)
    expect_depth = {1: 3, 2: 3, 3: 3, 4: 3, 5: 3, 6: 4, 7: 5, 8: 3, 9: 4, 10: 3}
    chk("C", "C5 forced depths 3/4/5 by mu",
        {mu: depths[mu]["forced_total_depth"] for mu in range(1, 11)} == expect_depth)
    chk("C", "C6 packet per-C11 depths match",
        {r["mu"]: r["forced_total_depth"] for r in syn["per_c11_menu"]} == expect_depth)
    chk("C", "C7 genus0 pass 0 on every C11 row",
        all(r["genus0_C14_at_depth_le_3"]["pass"] == 0 for r in syn["per_c11_menu"]))
    chk("C", "C8 mu 6,7,9 have 0 integrality at depth<=3 and forced depth>3",
        all(r["integrality_at_depth_le_3_empty"] and r["empty_integrality_expected"]
            for r in syn["per_c11_menu"] if r["mu"] in (6, 7, 9)))
    chk("C", "C9 mu not in {6,7,9} have integrality survivors at depth<=3",
        all(r["genus0_C14_at_depth_le_3"]["integral"] > 0
            for r in syn["per_c11_menu"] if r["mu"] not in (6, 7, 9)))
    chk("C", "C10 no C11 row intersection empty",
        all(r["intersection_empty"] is False and r["FLAG_KILL"] is False
            for r in syn["per_c11_menu"]))
    c5_rows = load(os.path.join(P.RESULTS, "per_c5_menu.json"))
    chk("C", "C11 64 C5 rows, none empty",
        len(c5_rows) == 64
        and all(r["intersection_empty"] is False and r["FLAG_KILL"] is False
                for r in c5_rows))
    chk("C", "C12 22 cell rows, none empty, none claimed dead",
        len(syn["per_cell"]) == 22
        and all(r["intersection_empty"] is False
                and r["FLAG_KILL"] is False
                and r["claimed_dead"] is False
                for r in syn["per_cell"]))
    chk("C", "C13 all 22 share the same must_look_like",
        syn["all_22_identical_fiber_verdict"] is True
        and len({json.dumps(r["must_look_like"], sort_keys=True)
                 for r in syn["per_cell"]}) == 1)
    scan = syn["contradiction_scan"]
    chk("C", "C14 no flagged kills claimed",
        scan["n_flagged_kills"] == 0 and scan["claimed_kills"] == 0
        and scan["claimed_degree_exclusion"] is False
        and scan["ODDZERO_audit_triggered"] is False)
    flag_ids = {f["id"] for f in scan["flags"]}
    chk("C", "C15 FLAG-M near-kill is recorded, not claimed",
        "FLAG_M_SMOOTH_TRACE_NEAR_KILL" in flag_ids
        and all(f.get("claimed") is False
                for f in scan["flags"] if f["id"] == "FLAG_M_SMOOTH_TRACE_NEAR_KILL"))
    chk("C", "C16 keep-pass pairing FLAG recorded",
        "KEEP_PASS_IDENTITY_PAIRING" in flag_ids)
    chk("C", "C17 headline exact", syn["headline"] == HEADLINE)
    para = open(os.path.join(P.RESULTS, "plain_paragraph.txt")).read().strip()
    chk("C", "C18 plain paragraph present and agrees",
        para == syn["plain_paragraph"] and "no degree is excluded" in para
        and "22 remaining candidate cells" in para
        and "genus at least 21" in para
        and "degree at least 35" in para
        and "sixty order-11 points" in para
        and "genus-0 fiber branch" in para)
    chk("C", "C19 no claimed kill / no claimed exclusion in synthesis",
        syn["claimed_kills"] == 0 and syn["claimed_degree_exclusion"] is False)
    # no REPORT.md
    chk("C", "C20 no REPORT.md in the packet",
        not os.path.exists(os.path.join(P.PACKET, "REPORT.md")))
    # STEIN C11-alone g=10 is NOT in the joint list
    chk("C", "C21 g=10 is in C11-alone menu and NOT in the joint list",
        10 in stein_menus["menus"]["C11"]["CONN_dim1_smooth"]["h1_menu"]
        and 10 not in genera)
    chk("C", "C22 g=21 is in C11-alone, C5-alone, and the joint list",
        21 in stein_menus["menus"]["C11"]["CONN_dim1_smooth"]["h1_menu"]
        and 21 in stein_menus["menus"]["C5"]["CONN_dim1_smooth"]["h1_menu"]
        and 21 in genera)
    # l12 json towers sum
    chk("C", "C23 L12 depth<=3 tower sum 1540",
        sum(l12["integrality_info"]["I2"][str(mu)]["n_towers"] for mu in range(1, 11)) == 1540)
    chk("C", "C24 L12 depth<=3 integral sum 118",
        sum(l12["integrality_info"]["I2"][str(mu)]["n_integral"] for mu in range(1, 11)) == 118)
    chk("C", "C25 keep_pass all LIVE both primes",
        all(d["verdict"] == "LIVE" for d in keep331["detail"])
        and all(d["verdict"] == "LIVE" for d in keep661["detail"]))
    chk("C", "C26 invariant table names the sealed sources",
        {inv["id"] for inv in syn["invariants"]}
        >= {"BS_C11_ALL_DEGREES", "CHI_TOP_C11", "CHI_TOP_C5", "CHI0_MOD_55",
            "STEIN_DICHOTOMY", "GENUS0_C14_DEAD", "C11_FORCED_DEPTH",
            "PIN_AND_J1", "KEEP_PASS_CLOSED"})

    n_pass = sum(1 for c in CHECKS if c["pass"] is True)
    n_fail = sum(1 for c in CHECKS if c["pass"] is False)
    n_skip = sum(1 for c in CHECKS if c["pass"] is None)
    allgreen = n_fail == 0 and n_skip == 0 and n_pass == len(CHECKS)
    out_obj = {
        "n_checks": len(CHECKS),
        "n_pass": n_pass,
        "n_fail": n_fail,
        "n_skip": n_skip,
        "ALLGREEN": allgreen,
        "marker": "CELL_SYNTHESIS_VERIFY_OK" if allgreen else "CELL_SYNTHESIS_VERIFY_FAIL",
        "headline": HEADLINE,
        "checks": CHECKS,
    }
    os.makedirs(P.RESULTS, exist_ok=True)
    with open(os.path.join(P.RESULTS, "verifier_output.json"), "w") as f:
        json.dump(out_obj, f, indent=2, sort_keys=True)
        f.write("\n")
    lines = [
        "checks %d  pass %d  fail %d  skip %d" % (len(CHECKS), n_pass, n_fail, n_skip),
    ]
    if allgreen:
        lines.extend(["CELL_SYNTHESIS_VERIFY_OK", "ALLGREEN", HEADLINE])
        rc = 0
    else:
        for c in CHECKS:
            if c["pass"] is not True:
                lines.append("FAIL %s %s %s" % (c["group"], c["name"], c["detail"]))
        lines.append("CELL_SYNTHESIS_VERIFY_FAIL")
        rc = 1
    text = "\n".join(lines) + "\n"
    with open(os.path.join(P.RESULTS, "verifier_stdout.txt"), "w") as f:
        f.write(text)
    sys.stdout.write(text)
    return rc


if __name__ == "__main__":
    sys.exit(main())
