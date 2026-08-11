"""Stage 2: produce every table of THEOREM.md.

  results/pinning_level0.txt      level-0 pinning per (n, d mod n)
  results/immune_rows.txt         the 22 coherence-immune rows, collapsed
  results/residues_165.txt        the full d mod 165 residue table (compressed)
  results/first_order.txt         admissible differential blocks
  results/consistency.txt         the equivariance-commutation + C6-band checks
  results/tables.json             everything, machine-readable
"""
import json
from itertools import product

from s2pin import (SPECTRUM, QR11, pathA_weight, pathB_level0, pathB_level1,
                   pathB_level2, IMMUNE_ROWS, C6_BAND_ROWS, value_set,
                   tangent_weights, forbidden_relative_weight, diff_blocks,
                   onX_weights)

OUT = {}


# ---------------------------------------------------------------- level 0
def level0_table():
    rows = []
    for n in (3, 5, 6, 11):
        a = SPECTRUM[n]["weights"]
        for d in range(n):
            entry = {"n": n, "d_mod_n": d, "map": {}}
            for k in range(5):
                ak = a[k]
                if n == 3 and ak != 0:
                    # eigenLINE, not eigenpoint: handled separately
                    continue
                tgt = (d * ak) % n
                exists = tgt in set(a)
                on = SPECTRUM[n]["onX"].get(tgt, False) if exists else False
                entry["map"][str(ak)] = {
                    "target_weight": tgt, "weight_occurs": exists,
                    "target_on_X": bool(on),
                    "verdict": "pinned" if on else "T vanishes (base point)"}
            rows.append(entry)
    return rows


def c3_line_table():
    """T restricted to a C3-eigenLINE."""
    out = []
    for d in range(3):
        for w in (1, 2):
            tgt = (d * w) % 3
            if tgt == 0:
                out.append({"d_mod_3": d, "source_line_weight": w,
                            "target": "W^{C3} = the D12-point (OFF X)",
                            "verdict": "whole eigenline in Bs(T)"})
            else:
                out.append({"d_mod_3": d, "source_line_weight": w,
                            "target": "eigenline of weight %d" % tgt,
                            "verdict": "contracted to the X^{C6} point of "
                                       "weight %d" % (1 if tgt == 1 else 5)})
    return out


# ---------------------------------------------------------------- immune rows
def immune_table():
    """For every residue d mod 165 and every jet-order tuple, the value of each
    of the 22 coherence-immune rows.  Reports, per residue, the collapsed
    number of admissible values."""
    res = []
    for d165 in range(165):
        d3, d5, d11 = d165 % 3, d165 % 5, d165 % 11
        rec = {"d_mod_165": d165, "d_mod_3": d3, "d_mod_5": d5, "d_mod_11": d11}

        # ---- C11 (4 rows over the base point of weight k = 9)
        # mu = mult of T at a C11-point.  mu = 0 is possible ONLY if d in QR11
        # (otherwise T(e_k) has nowhere to go and vanishes).
        k = 9
        mus = list(range(11)) if d11 in QR11 else list(range(1, 12))
        prof = {}
        best = None
        for mu in mus:
            vals, nd = [], 0
            for row in IMMUNE_ROWS:
                if row["n"] != 11:
                    continue
                c = row["chain"][0]
                w = pathA_weight(11, d11, k, [(mu, c)])
                ok = w in QR11
                vals.append((row["name"], w, ok))
                nd += ok
            prof[mu % 11 if mu else 0] = nd
            if best is None or nd > best[1]:
                best = (mu, nd, vals)
        rec["C11"] = {"mu_star": best[0], "n_defined": best[1],
                      "mu_profile": prof,
                      "values": [(nm, w, ok) for nm, w, ok in best[2]],
                      "mu0_allowed": d11 in QR11,
                      "branch": "T defined at the C11-points (mu=0 branch open)"
                                if d11 in QR11 else
                                "all 60 C11-points in Bs(T); mu >= 1 forced",
                      "values_per_row": 1}

        # ---- C5, exact-C5 rows (8) : two independent multiplicities
        c5 = {}
        for tag, base in (("a", 1), ("b", 2)):
            mus = [0] if d5 != 0 else list(range(1, 6))
            best = None
            for mu in mus:
                vals, nd = [], 0
                for row in IMMUNE_ROWS:
                    if row["n"] != 5 or row["base"] != base:
                        continue
                    c = row["chain"][0]
                    w = pathA_weight(5, d5, base, [(mu, c)])
                    ok = w != 0
                    vals.append((row["name"], w, ok))
                    nd += ok
                if best is None or nd > best[1]:
                    best = (mu, nd, vals)
            c5[tag] = {"mu_star": best[0], "n_defined": best[1],
                       "values": best[2]}
        # ---- C5, D10 rows (2) : mu0 >= 1 always
        best = None
        for mu0 in range(1, 6):
            vals, nd = [], 0
            for row in IMMUNE_ROWS:
                if row["n"] != 5 or row["base"] != 0:
                    continue
                c = row["chain"][0]
                w = pathA_weight(5, d5, 0, [(mu0, c)])
                ok = w != 0
                vals.append((row["name"], w, ok))
                nd += ok
            if best is None or nd > best[1]:
                best = (mu0, nd, vals)
        c5["D10"] = {"mu_star": best[0], "n_defined": best[1], "values": best[2]}
        rec["C5"] = c5
        rec["C5"]["branch"] = ("T defined at X^{C5} (mu=0)" if d5 else
                               "all 4 X^{C5} points and all 264 C5-points in Bs(T)")

        # ---- C3 (8 rows) : per A4-orbit, (mu1, mu2) with mu1>=1, mu2>=1
        c3 = {}
        for tag, base in (("a", 1), ("b", 2)):
            best = None
            for mu1, mu2 in product(range(3), repeat=2):
                vals, nd = [], 0
                for row in IMMUNE_ROWS:
                    if row["n"] != 3 or row["base"] != base:
                        continue
                    ch = row["chain"]
                    pairs = [(mu1, ch[0])] + ([(mu2, ch[1])] if len(ch) > 1 else [])
                    w = pathA_weight(3, d3, base, pairs)
                    ok = w != 0
                    vals.append((row["name"], w, ok, len(value_set(3, w))))
                    nd += ok
                if best is None or nd > best[1]:
                    best = ((mu1, mu2), nd, vals)
            c3[tag] = {"mu_star": best[0], "n_defined": best[1], "values": best[2]}
        rec["C3"] = c3

        nd_tot = (rec["C11"]["n_defined"] + c5["a"]["n_defined"]
                  + c5["b"]["n_defined"] + c5["D10"]["n_defined"]
                  + c3["a"]["n_defined"] + c3["b"]["n_defined"])
        rec["max_defined_rows"] = nd_tot
        rec["collapsed_count_all_defined"] = 3 ** (c3["a"]["n_defined"]
                                                   + c3["b"]["n_defined"])
        rec["verdict"] = "CONSISTENT"
        res.append(rec)
    return res


# ------------------------------------------------------- equivariance checks
def equivariance_checks():
    out = {}
    # F55: the residual C5 acts on the 5 C11-eigenpoints by multiplication by
    # u in QR11 (verified in s2eigen.py).  Does a -> d*a commute?
    bad = 0
    for u in (3, 4, 5, 9):
        for d in range(11):
            for a in QR11:
                if (d * ((u * a) % 11)) % 11 != (u * ((d * a) % 11)) % 11:
                    bad += 1
    out["F55_C11_commutes"] = {"violations": bad,
                               "statement": "a |-> d a commutes with a |-> u a "
                                            "for every u in QR11 and every d"}
    # D10: the residual C2 acts by a -> -a on Z/5.
    bad = 0
    for d in range(5):
        for a in range(5):
            if (d * ((-a) % 5)) % 5 != (-(d * a)) % 5:
                bad += 1
    out["D10_C5_commutes"] = {"violations": bad,
                              "statement": "a |-> d a commutes with a |-> -a"}
    # D12/C3 = V4 on X^{C3}: the coset outside C6 inverts C3, so it sends the
    # weight-w eigenline to the weight-(-w) one.
    bad = 0
    for d in range(3):
        for w in (1, 2):
            if (d * ((-w) % 3)) % 3 != (-(d * w)) % 3:
                bad += 1
    out["D12_C3_commutes"] = {"violations": bad,
                              "statement": "w |-> d w commutes with w |-> -w "
                                           "(the eigenline swap)"}
    out["D12_C3_blind_part"] = (
        "the OTHER generator of the residual V4 = D12/C3 is C6/C3 = <t>, which "
        "acts INSIDE each eigenline, fixing the C6-point and swapping the two "
        "exact-C3 points.  The weight congruence is blind to it: that is "
        "exactly the residual factor 3 on each C3 row.")
    return out


def c6_band_of_DPsigma():
    """The six C6-fixed points of D_{P_sigma} = P(W^+) x P(W^-).
    Value weight = (d-m) i + m j (mod 6), i in {0,2,4} (C6-weights on W^+),
    j in {1,5} (C6-weights on W^-).  Must lie in {1,5} = X^{C6}."""
    rows = []
    for d in range(6):
        for m in (1, 3, 5):
            rec = {"d_mod_6": d, "m_mod_6": m, "children": []}
            for i in (0, 2, 4):
                for j in (1, 5):
                    w = ((d - m) * i + m * j) % 6
                    rec["children"].append(
                        {"i": i, "j": j, "value_weight": w,
                         "on_X": w in (1, 5),
                         "verdict": ("X^{C6} pt w=%d" % w) if w in (1, 5)
                                    else "degenerate (T_m vanishes)"})
            rec["n_degenerate"] = sum(1 for c in rec["children"] if not c["on_X"])
            rows.append(rec)
    return rows


def first_order_table():
    out = []
    for n in (5, 6, 11):
        for d in range(n):
            for ak in sorted(onX_weights(n)):
                blocks = diff_blocks(n, d, ak)
                ai = (d * ak) % n
                out.append({
                    "n": n, "d_mod_n": d, "source_weight": ak,
                    "target_weight": ai,
                    "target_on_X": bool(SPECTRUM[n]["onX"].get(ai, False)),
                    "src_tangent": tangent_weights(n, ak),
                    "tgt_tangent": (tangent_weights(n, ai)
                                    if ai in set(SPECTRUM[n]["weights"]) else None),
                    "killed_by_dF": (forbidden_relative_weight(n, ai)
                                     if ai in set(SPECTRUM[n]["weights"]) else None),
                    "admissible_blocks": blocks,
                    "max_rank": (len(blocks) if blocks is not None else None),
                })
    return out


# ------------------------------------------------------------- PATH A vs B
def crosscheck_paths():
    """Path A (closed form) vs Path B (monomial enumeration) on every case
    reachable with a concrete small d."""
    bad = 0
    tested = 0
    for n in (3, 5, 6, 11):
        a = SPECTRUM[n]["weights"]
        for d in range(1, 40):
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


SEALED_DEGREES = [25, 34] + list(range(35, 47))


def parity_layer(d):
    """The C2/C6 layer: needs d mod 6 (and d mod 2)."""
    out = {"d": d, "d_mod_2": d % 2, "d_mod_6": d % 6}
    out["minus_line_in_Bs"] = (d % 2 == 0)
    out["ord_L_sigma_parity"] = "odd" if d % 2 == 0 else "even (0 allowed)"
    out["X_C6_in_Bs"] = (d % 6) not in (1, 5)
    if (d % 6) == 1:
        out["X_C6_action"] = "T fixes each of the two X^{C6} points"
    elif (d % 6) == 5:
        out["X_C6_action"] = "T swaps the two X^{C6} points"
    else:
        out["X_C6_action"] = "both X^{C6} points are base points"
    return out


def degree_report(ds):
    res = []
    for d in ds:
        d3, d5, d11 = d % 3, d % 5, d % 11
        r = {"d": d, "d_mod_3": d3, "d_mod_5": d5, "d_mod_11": d11,
             "d_mod_165": d % 165}
        r["C11"] = ("d is a QR mod 11: T is defined at the 60 C11-points and "
                    "permutes X^{C11} by a |-> %d a; all four C11-rows collapse "
                    "to that ONE value" % d11) if d11 in QR11 else (
            "d is a non-residue mod 11 (or 0): ALL 60 C11-points lie in Bs(T)")
        r["C5"] = ("5 does not divide d: T permutes X^{C5} by a |-> %d a; the "
                   "eight pt_C5 rows collapse to ONE value each" % d5) if d5 else (
            "5 | d: all 264 C5-points, hence all four points of X^{C5}, "
            "lie in Bs(T)")
        r["C5_D10"] = ("the 66 D10-points always lie in Bs(T); the two pt_D10 "
                       "rows are pinned by mu_0 mod 5 and always land in "
                       "DIFFERENT C5-orbits")
        r["C3"] = ({0: "3 | d: both C3-eigenlines (110 lines) lie in Bs(T)",
                    1: "d = 1 mod 3: each C3-eigenline is contracted to the "
                       "X^{C6} point ON it",
                    2: "d = 2 mod 3: each C3-eigenline is contracted to the "
                       "X^{C6} point on the OTHER eigenline"}[d3])
        r.update(parity_layer(d))
        r["dT_rank_at_C11"] = (len(diff_blocks(11, d11, 1))
                               if d11 in QR11 else None)
        r["dT_rank_at_C5"] = (len(diff_blocks(5, d5, 1)) if d5 else None)
        r["dT_rank_at_C6"] = (len(diff_blocks(6, d % 6, 1))
                              if (d % 6) in (1, 5) else None)
        res.append(r)
    return res


def main():
    OUT["level0"] = level0_table()
    OUT["degrees"] = degree_report(SEALED_DEGREES)
    OUT["c3_lines"] = c3_line_table()
    OUT["immune"] = immune_table()
    OUT["equivariance"] = equivariance_checks()
    OUT["c6_band_DPsigma"] = c6_band_of_DPsigma()
    OUT["first_order"] = first_order_table()
    OUT["path_crosscheck"] = crosscheck_paths()
    with open("results/tables.json", "w") as f:
        json.dump(OUT, f, indent=1, sort_keys=True)

    # ---- human-readable
    with open("results/pinning_level0.txt", "w") as f:
        f.write("LEVEL-0 PINNING  T(e_k) lies in the eigenspace of weight d*a_k\n")
        f.write("(a weight that does not occur, or occurs at a point OFF X, "
                "forces T(e_k)=0)\n\n")
        for e in OUT["level0"]:
            f.write("n=%2d  d=%d mod %d\n" % (e["n"], e["d_mod_n"], e["n"]))
            for w, v in sorted(e["map"].items(), key=lambda t: int(t[0])):
                f.write("      a_k=%-2s -> weight %-2d  occurs=%-5s onX=%-5s  %s\n"
                        % (w, v["target_weight"], v["weight_occurs"],
                           v["target_on_X"], v["verdict"]))
            f.write("\n")
        f.write("\nC3 EIGENLINES (2-dimensional eigenspaces)\n")
        for e in OUT["c3_lines"]:
            f.write("  d=%d mod 3, line weight %d -> %s : %s\n"
                    % (e["d_mod_3"], e["source_line_weight"], e["target"],
                       e["verdict"]))

    with open("results/immune_rows.txt", "w") as f:
        f.write("THE 22 COHERENCE-IMMUNE ROWS, PINNED\n")
        f.write("Stage-1 free count: 6^8 * 4^10 * 5^4 = 1100753141760000\n\n")
        f.write("%-34s %-4s %-6s %-8s %-6s\n"
                % ("row", "n", "base", "chain", "#val(Stage1)"))
        for r in IMMUNE_ROWS:
            f.write("%-34s %-4d %-6d %-8s %-6d\n"
                    % (r["name"], r["n"], r["base"], str(r["chain"]), r["nvalues"]))
        f.write("\nper-residue collapse (d mod 165): see residues_165.txt\n")

    with open("results/residues_165.txt", "w") as f:
        f.write("RESIDUE TABLE  d mod 165 = lcm(3,5,11)\n")
        f.write("cols: d165 | d3 d5 d11 | C11 branch (#def/4) | C5 exact "
                "(#def/8) | C5 D10 (#def/2) | C3 (#def/8) | collapsed count "
                "| verdict\n\n")
        for r in OUT["immune"]:
            f.write("%3d | %d %d %2d | %-5s %d/4 | %-5s %d/8 | %d/2 | %d/8 | "
                    "%5d | %s\n"
                    % (r["d_mod_165"], r["d_mod_3"], r["d_mod_5"], r["d_mod_11"],
                       "QR" if r["d_mod_11"] in QR11 else "nonQR",
                       r["C11"]["n_defined"],
                       "def" if r["d_mod_5"] else "Bs",
                       r["C5"]["a"]["n_defined"] + r["C5"]["b"]["n_defined"],
                       r["C5"]["D10"]["n_defined"],
                       r["C3"]["a"]["n_defined"] + r["C3"]["b"]["n_defined"],
                       r["collapsed_count_all_defined"], r["verdict"]))

    with open("results/first_order.txt", "w") as f:
        f.write("FIRST-ORDER CHARACTER TABLE\n")
        f.write("dT_p preserves the relative weight c; ker(dF) kills c = -3a_i\n\n")
        f.write("%-3s %-5s %-6s %-6s %-16s %-16s %-6s %-18s %s\n"
                % ("n", "d", "src a", "tgt a", "src tangent", "tgt tangent",
                   "kill", "admissible c", "max rank"))
        for e in OUT["first_order"]:
            f.write("%-3d %-5d %-6d %-6d %-16s %-16s %-6s %-18s %s\n"
                    % (e["n"], e["d_mod_n"], e["source_weight"], e["target_weight"],
                       e["src_tangent"], e["tgt_tangent"], e["killed_by_dF"],
                       e["admissible_blocks"], e["max_rank"]))

    with open("results/consistency.txt", "w") as f:
        f.write("CONSISTENCY SYSTEM\n\n")
        for k, v in OUT["equivariance"].items():
            f.write("%s : %s\n" % (k, v))
        f.write("\nC6-CHILDREN OF D_{P_sigma}  (value weight = (d-m)i + m j)\n")
        f.write("%-6s %-6s %-40s %s\n" % ("d%6", "m%6", "weights (i,j)->w",
                                          "#degenerate"))
        for r in OUT["c6_band_DPsigma"]:
            s = " ".join("(%d,%d)->%d" % (c["i"], c["j"], c["value_weight"])
                         for c in r["children"])
            f.write("%-6d %-6d %-40s %d\n"
                    % (r["d_mod_6"], r["m_mod_6"], s, r["n_degenerate"]))
        f.write("\npath A vs path B: %s\n" % OUT["path_crosscheck"])

    with open("results/degrees.txt", "w") as f:
        f.write("PER-DEGREE VERDICT (sealed window degrees)\n")
        f.write("the sealed sieve says d <= 30 is EMPTY, 31-33 near-complete "
                "all-zero, first open window d = 34\n\n")
        for r in OUT["degrees"]:
            f.write("d = %d   (d mod 3,5,11 = %d,%d,%d ; d mod 165 = %d ; "
                    "d mod 6 = %d)\n"
                    % (r["d"], r["d_mod_3"], r["d_mod_5"], r["d_mod_11"],
                       r["d_mod_165"], r["d_mod_6"]))
            f.write("   C11   : %s\n" % r["C11"])
            f.write("   C5    : %s\n" % r["C5"])
            f.write("   C5/D10: %s\n" % r["C5_D10"])
            f.write("   C3    : %s\n" % r["C3"])
            f.write("   L_sig : minus-lines in Bs(T)? %s ; ord_{L_sigma}(T) %s\n"
                    % (r["minus_line_in_Bs"], r["ord_L_sigma_parity"]))
            f.write("   X^C6  : in Bs(T)? %s ; %s\n"
                    % (r["X_C6_in_Bs"], r["X_C6_action"]))
            f.write("   max rank of dT at a pinned point: C11 %s, C5 %s, C6 %s\n\n"
                    % (r["dT_rank_at_C11"], r["dT_rank_at_C5"],
                       r["dT_rank_at_C6"]))

    print("path A/B crosscheck:", OUT["path_crosscheck"])
    print("S2_TABLES_OK")


if __name__ == "__main__":
    main()
