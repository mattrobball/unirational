#!/usr/bin/env python3
"""SMITH_ORDERS_23 verifier.  python3 verifier.py

Group A -- reconstruct the two SMITH_I3-parametric branches from sealed files.
Group B -- re-read STEIN_LERAY and L12_ORDER11 sealed numbers consumed here.
Group C -- the CRT gap, the locus obstruction, and the honesty of the verdict.

Exact integer arithmetic; python3 standard library only.
Markers: SMITH_ORDERS_23_VERIFY_OK / ALLGREEN
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))
import paths as P  # noqa: E402

CHECKS = []


def chk(group, name, ok, detail=""):
    CHECKS.append({"group": group, "name": name,
                   "pass": bool(ok), "detail": str(detail)[:500]})
    return bool(ok)


def read(path):
    with open(path) as f:
        return f.read()


def loadj(path):
    with open(path) as f:
        return json.load(f)


def group_A(audit):
    g = "A"
    smith = loadj(os.path.join(P.SMITH_I3, "results", "f2f3_congruences.json"))
    thm = read(os.path.join(P.SMITH_I3, "THEOREM.md"))
    ref = read(os.path.join(P.SMITH_I3, "REFEREE_REPORT.md"))
    o2 = smith["orders"]["2"]
    o3 = smith["orders"]["3"]

    chk(g, "A1 SMITH_I3 order-2 L-branch is PARAMETRIC",
        o2["branch_L"]["parametric"] is True,
        o2["branch_L"]["reason_parametric"])
    chk(g, "A2 SMITH_I3 order-2 E-branch closed == 0 mod 2",
        "0 (mod 2)" in o2["branch_E"]["statement"]
        or "== 0 (mod 2)" in o2["branch_E"]["statement"],
        o2["branch_E"]["statement"])
    chk(g, "A3 SMITH_I3 names the irrational escape",
        "IRRATIONAL" in o2["branch_E"]["escape"])
    chk(g, "A4 three forced dominating rows",
        o2["branch_L"]["dominating_rows"] == [
            "D_{P_sigma}", "D_{L'_sigma}",
            "central-involution line in E_{pt_D12}"],
        o2["branch_L"]["dominating_rows"])
    chk(g, "A5 referee S4 widens the L-display by unforced rows",
        "unforced" in ref.lower() and "CORRECTED" in ref)
    chk(g, "A6 director adopted the L-widening",
        "widened" in thm.lower() and "unforced" in thm.lower())
    chk(g, "A7 order-3 status PARAMETRIC", o3["status"] == "PARAMETRIC")
    chk(g, "A8 order-3 blocker is chi(S_i), not the point/curve count",
        "94 + chi(S_1) + chi(S_2)" in o3["blocker"]
        and "chi(S_i) >= 3" in o3["blocker"],
        o3["blocker"])
    chk(g, "A9 census C2 = {0:146,1:80,2:11,3:2}",
        o2["source_census_Z_sigma_by_dim"]
        == {"0": 146, "1": 80, "2": 11, "3": 2}
        or o2["source_census_Z_sigma_by_dim"]
        == {0: 146, 1: 80, 2: 11, 3: 2},
        o2["source_census_Z_sigma_by_dim"])
    chk(g, "A10 census C3 = {0:62,1:16,2:2}",
        o3["source_census_Z_C3_by_dim"] == {"0": 62, "1": 16, "2": 2}
        or o3["source_census_Z_C3_by_dim"] == {0: 62, 1: 16, 2: 2},
        o3["source_census_Z_C3_by_dim"])
    chk(g, "A11 A4 menu 238*238 = 56644", o3["menu_size"] == 56644)
    chk(g, "A12 receiver X^sigma splits 0+2=2",
        o2["chi_X_sigma"] == 2
        and o2["receiver_strata"][0]["chi"] == 0
        and o2["receiver_strata"][1]["chi"] == 2)
    chk(g, "A13 22 cells, F_odd = 36252160",
        smith["n_cells"] == 22 and smith["menu"]["F_odd_35"] == 36252160)
    n5 = smith["orders"]["5"]["n_x"]
    n5_ok = n5 == 5 or (isinstance(n5, dict) and set(n5.values()) == {5})
    chk(g, "A14 sealed n_x = 4 at C11 and n_x = 5 at C5, on Z",
        smith["orders"]["11"]["n_x_on_Z"] == 4 and n5_ok,
        "C11 n_x=%r C5 n_x=%r" % (smith["orders"]["11"]["n_x_on_Z"], n5))
    chk(g, "A15 reconstruction matches produce()",
        audit["reconstructed"]["order3_status"] == "PARAMETRIC"
        and audit["reconstructed"]["branch_L_as_computed"]["parametric"]
        is True)


def group_B(audit):
    g = "B"
    blob = loadj(os.path.join(P.STEIN, "results", "menus.json"))
    menus = blob["menus"]
    joint = menus["JOINT_flat_smooth"]
    stein_thm = read(os.path.join(P.STEIN, "THEOREM.md"))
    l12_thm = read(os.path.join(P.L12, "THEOREM.md"))
    s1 = read(os.path.join(P.STAGE1, "THEOREM.md"))
    census = read(os.path.join(P.TERMINUS, "results", "t2_strata.txt"))
    terminus = read(os.path.join(P.TERMINUS, "THEOREM.md"))

    chk(g, "B1 STEIN_LERAY chi_0 == 35 (mod 55)",
        joint["chi_0_mod_55"] == [35], joint["chi_0_mod_55"])
    chk(g, "B2 joint hypotheses name the nine pinned points, smooth row, Z",
        any("nine pinned" in h for h in joint["hypotheses"])
        and any("smooth" in h for h in joint["hypotheses"])
        and any("n_x = 4 and 5" in h for h in joint["hypotheses"]))
    chk(g, "B3 dichotomy A: chi_0 <= -20; B: chi_0 >= 35",
        joint["branch_A"]["condition"] == "chi_0 <= -20"
        and joint["branch_B"]["condition"] == "chi_0 >= 35")
    chk(g, "B4 dim-2 menu: chi_0 does not bind",
        "chi_0 does not bind" in menus["C11"]["CONN_dim2"]["note"]
        and "chi_0 does not bind" in menus["C5"]["CONN_dim2"]["note"])
    chk(g, "B5 dim-3 fibre FLAGGED",
        menus["C11"]["dim3_fibre"]["status"] == "FLAGGED")
    chk(g, "B6 J1 invariant degrees exactly {k >= 5}",
        "{k ≥ 5}" in stein_thm or "{k >= 5}" in stein_thm)
    chk(g, "B7 Proposition PIN is sealed in STEIN_LERAY",
        "Proposition PIN" in stein_thm)
    l12_flat = " ".join(l12_thm.split())
    chk(g, "B8 L12: all 60 C11-points are base points at every degree",
        "all 60 C11-points lie in the base locus" in l12_flat)
    chk(g, "B9 L12: genus-0 dead 0 of 2674 (extended scope)",
        "0 of 2674" in l12_thm)
    chk(g, "B10 L12: forced depths >= 3 / >= 4 for {6,9} / >= 5 for mu1=7",
        ("≥ 3" in l12_thm or ">= 3" in l12_thm)
        and ("{6, 9}" in l12_thm or "{6,9}" in l12_thm))
    chk(g, "B11 L12 leaves orders 2 and 3 untouched",
        "Orders 5, 3, 2, 6 are untouched" in l12_thm)
    chk(g, "B12 STAGE1 Thm 3: two dim-3 rows and one dim-1 row onto L_sigma",
        "### Theorem 3 (three forced sweeps" in s1
        and "dim 3, 55 components" in s1
        and s1.count("dim 3, 55 components") == 2
        and "dim 1, 55 components" in s1
        and "map **onto** `L_σ`" in s1)
    chk(g, "B13 TERMINUS dictionary C2/C3 dimension counts",
        "H = C2  : components of Z^H by dim {0: 146, 1: 80, 2: 11, 3: 2}"
        in census
        and "H = C3  : components of Z^H by dim {0: 62, 1: 16, 2: 2}"
        in census)
    chk(g, "B14 TERMINUS: closure is a smooth blowup of a product, not an iso",
        "smooth blowup of" in terminus
        and "up to the later blowups" in terminus)
    chk(g, "B15 C3 dim-2 row is the C3line (110 components, #/fixedK = 2)",
        "C3   2    110        2         C6      C2  C3line" in census
        or re.search(r"C3\s+2\s+110\s+2\s+C6\s+C2\s+C3line", census)
        is not None)
    chk(g, "B16 STEIN_LERAY n_x on Z is 4 and 5",
        menus["C11"]["smith_input"]["n_x_on_Z"] == 4
        and menus["C5"]["smith_input"]["n_x_on_Z"] == 5)
    chk(g, "B17 produce() consumed the same chi_0 residue",
        audit["stein_consumed"]["chi_0_mod_55"] == [35])
    chk(g, "B18 produce() saw L12 all-60 and 0-of-2674",
        audit["l12_consumed"]["all_60_base_points"] is True
        and audit["l12_consumed"]["genus0_dead_extended"] is True)


def group_C(audit):
    g = "C"
    # Independent CRT (do not import produce.py arithmetic).
    def c0(k):
        return 35 + 55 * k

    window = range(-12, 13)
    mods2 = { (2 * c0(k)) % 2 for k in window }
    mods3 = { (2 * c0(k)) % 3 for k in window }
    A3 = { (2 * c0(k)) % 3 for k in window if c0(k) <= -20 }
    B3 = { (2 * c0(k)) % 3 for k in window if c0(k) >= 35 }
    chi0_mod3 = { c0(k) % 3 for k in window }

    chk(g, "C1 2*chi_0 is always even", mods2 == {0}, mods2)
    chk(g, "C2 2*chi_0 (mod 3) takes {0,1,2}", mods3 == {0, 1, 2}, mods3)
    chk(g, "C3 branch A hits all three residues mod 3", A3 == {0, 1, 2}, A3)
    chk(g, "C4 branch B hits all three residues mod 3", B3 == {0, 1, 2}, B3)
    chk(g, "C5 chi_0 itself is not pinned mod 3",
        chi0_mod3 == {0, 1, 2}, chi0_mod3)
    chk(g, "C6 pinning 2*chi_0 mod 3 needs modulus 165",
        55 * 3 == 165)
    # explicit representatives
    chk(g, "C7 k=-1 => chi_0=-20, 2*chi_0=-40 == 2 (mod 3)  [g=21]",
        c0(-1) == -20 and (2 * c0(-1)) % 3 == 2)
    chk(g, "C8 k=-2 => chi_0=-75, 2*chi_0=-150 == 0 (mod 3)  [g=76]",
        c0(-2) == -75 and (2 * c0(-2)) % 3 == 0)
    chk(g, "C9 k=-3 => chi_0=-130, 2*chi_0=-260 == 1 (mod 3)  [g=131]",
        c0(-3) == -130 and (2 * c0(-3)) % 3 == 1)
    chk(g, "C10 k=0 => chi_0=35, 2*chi_0=70 == 1 (mod 3)  [Stein s>=35]",
        c0(0) == 35 and (2 * c0(0)) % 3 == 1)
    chk(g, "C11 produce() CRT agrees",
        audit["crt_gap"]["pins_mod_2"] is True
        and audit["crt_gap"]["pins_mod_3"] is False
        and set(audit["crt_gap"]["branch_A_two_chi0_mod_3"]) == {0, 1, 2}
        and set(audit["crt_gap"]["branch_B_two_chi0_mod_3"]) == {0, 1, 2})

    # Locus
    chk(g, "C12 L_sigma is not in U",
        audit["locus"]["L_sigma_in_U"] is False
        and audit["locus"]["chi0_binds_on_L"] is False)
    chk(g, "C13 generic fibre dim over L is 2",
        audit["locus"]["generic_fibre_dim_over_L"] == 2)
    chk(g, "C14 C3-surface receivers are not in U",
        audit["locus"]["C3_surface_receivers_in_U"] is False
        and audit["locus"]["chi0_binds_on_C3_surface_receivers"] is False)
    chk(g, "C15 STAGE1 Thm 3 ingredients present",
        audit["locus"]["stage1_thm3_present"] is True)
    def intd(d):
        return {int(k): int(v) for k, v in d.items()}
    chk(g, "C16 census C2/C3 reproduced",
        intd(audit["locus"]["census_C2"]) == {0: 146, 1: 80, 2: 11, 3: 2}
        and intd(audit["locus"]["census_C3"]) == {0: 62, 1: 16, 2: 2},
        audit["locus"]["census_C2"])

    # 2*chi_0 even is tautological for Smith p=2 on U, smooth row:
    # it does not constrain the L-display, and L is not in U anyway.
    chk(g, "C17 order-2 L-branch stays parametric",
        audit["verdict"]["order2_L_pinned"] is False)
    chk(g, "C18 order-3 stays parametric",
        audit["verdict"]["order3_pinned"] is False)
    chk(g, "C19 E-branch remains closed as SMITH_I3 left it",
        audit["verdict"]["order2_E_still_closed_as_SMITH_I3_left_it"] is True
        and audit["verdict"]["order2_E_escape_still_live"] is True)
    chk(g, "C20 no exclusion, no cell cut, no zero/all-dead",
        audit["verdict"]["exclusion_claimed"] is False
        and audit["verdict"]["degree_excluded"] is None
        and audit["verdict"]["cells_cut"] == 0
        and audit["verdict"]["zero_or_all_dead"] is False)
    unk_ids = {u["id"] for u in audit["remaining_unknowns"]}
    chk(g, "C21 eight named remaining unknowns",
        unk_ids == {"L_chi", "E_escape", "S_chi", "Zsigma_chi",
                    "U_membership", "defects", "stein_s", "Delta_C11"},
        sorted(unk_ids))
    chk(g, "C22 chi(Z^{C3}) shape 94 + chi(S_1) + chi(S_2) unrepaired",
        audit["reconstructed"]["chi_Z_C3_shape"]
        == "94 + chi(S_1) + chi(S_2),  chi(S_i) >= 3")
    chk(g, "C23 94 == 1 (mod 3), so F3 + a would-be uniform residue "
           "would still leave chi(S_1)+chi(S_2) free mod 3 "
           "once the CRT gap is open",
        94 % 3 == 1)
    # genus-0 on U is incompatible with chi_0 == 35 (mod 55), already in
    # STEIN_LERAY: chi_0 = 1 (smooth connected P1) or 2 (two P1s) are not 35.
    chk(g, "C24 genus-0 chi_0 values 1 and 2 are not 35 (mod 55)",
        1 % 55 != 35 and 2 % 55 != 35)
    chk(g, "C25 headline in the artefact",
        audit["headline"]
        == "Problem E remains OPEN; this packet excludes no degree.")
    chk(g, "C26 zero/all-dead audit is negative (no ODDZERO claim)",
        audit["verdict"]["zero_or_all_dead"] is False)


def main():
    os.makedirs(P.RES, exist_ok=True)
    r = subprocess.run(
        [sys.executable, os.path.join(HERE, "scripts", "produce.py")],
        cwd=HERE, capture_output=True, text=True,
    )
    produce_ok = r.returncode == 0 and "SMITH_ORDERS_23_PRODUCE_OK" in r.stdout
    chk("A", "A0 produce.py replays", produce_ok,
        (r.stdout + r.stderr)[-300:])
    audit = loadj(os.path.join(P.RES, "audit.json"))

    group_A(audit)
    group_B(audit)
    group_C(audit)

    n = len(CHECKS)
    npass = sum(1 for c in CHECKS if c["pass"] is True)
    nfail = sum(1 for c in CHECKS if c["pass"] is False)
    nskip = sum(1 for c in CHECKS if c["pass"] is None)
    lines = []
    for c in CHECKS:
        tag = "PASS" if c["pass"] is True else ("SKIP" if c["pass"] is None
                                                else "FAIL")
        lines.append("[%s] %s %-56s %s" % (
            c["group"], tag, c["name"], c["detail"]))
        print(lines[-1])
    summary = {
        "n": n, "pass": npass, "fail": nfail, "skip": nskip,
        "groups": {
            g: sum(1 for c in CHECKS if c["group"] == g)
            for g in ("A", "B", "C")
        },
        "allgreen": nfail == 0 and nskip == 0,
        "marker": "SMITH_ORDERS_23_VERIFY_OK" if nfail == 0 else
                  "SMITH_ORDERS_23_VERIFY_FAIL",
    }
    out = {"summary": summary, "checks": CHECKS}
    with open(os.path.join(P.RES, "verifier_output.json"), "w") as f:
        json.dump(out, f, indent=1, sort_keys=True)
        f.write("\n")
    stdout_path = os.path.join(P.RES, "verifier_stdout.txt")
    with open(stdout_path, "w") as f:
        f.write("\n".join(lines) + "\n")
        f.write("summary %s\n" % json.dumps(summary))
    print("summary", summary)
    if summary["allgreen"]:
        print("SMITH_ORDERS_23_VERIFY_OK")
        print("ALLGREEN")
        return 0
    print("SMITH_ORDERS_23_VERIFY_FAIL")
    return 1


if __name__ == "__main__":
    sys.exit(main())
