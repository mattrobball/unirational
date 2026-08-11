"""Phase 2 — the global join.

Join, per residue class mod 330:
  * corrected sigma-band patterns K(d mod 6)   [STAGE1_STRATIFIED]
  * D10 C2-line branch with mu0 shared with Phase-1 pt_D10 rows
  * Phase-1 immune value-vectors under shared mu

Incidence: the 22 immune rows are coherence-immune (STAGE1 §15.5) — their
only proper parent is the free stratum, so the 145 order-0 closure relations
do not bind any immune-row value to a sigma-band value.  The Z+ D10 C2-line
is outside the 43 008 core (STAGE1 §15.3) and multiplies freely once the
branch is selected by mu0.  Documented in THEOREM.md §3.

  G(d) = K(d mod 6) * H_immune_D10(d)

where H_immune_D10 is the Phase-1 join of immune patterns with the D10
branch sum (replacing D10(mu1) * 3^8 in the product formula).

Trivialized join (immune+D10 factors set to 1): G_triv(d) = K(d mod 6).
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from paths import RESULTS, K_TABLE, D10_E_BRANCH, D10_L_BRANCH, D10_TOTAL  # noqa: E402
from phase1_shared_mu import f_odd_count, H_immune_D10  # noqa: E402
from centers import (  # noqa: E402
    CENTERS, center_value_vectors, admissible_mus_D10, d10_branch_for_mu0,
)


def product_upper(d):
    """The independence upper bound K * max(D10) * 3^8 and K * 23 * 3^8."""
    K = K_TABLE[d % 6]
    return {
        "K": K,
        "K_x_13_x_3_8": K * D10_E_BRANCH * (3 ** 8),
        "K_x_10_x_3_8": K * D10_L_BRANCH * (3 ** 8),
        "K_x_23_x_3_8": K * D10_TOTAL * (3 ** 8),
    }


def G_of(d, sharing=True):
    """Exact global pattern count under the join of §0."""
    K = K_TABLE[d % 6]
    H, n_other, d10_sum = H_immune_D10(d, sharing=sharing)
    F, fac = f_odd_count(d, sharing=sharing)
    return {
        "d_mod_330": d,
        "d_mod_6": d % 6,
        "K": K,
        "F_odd": F,
        "H_immune_D10": H,
        "G": K * H,
        "G_triv": K,                    # trivialized join
        "product_K_23_3_8": K * D10_TOTAL * (3 ** 8),
        "product_K_13_3_8": K * D10_E_BRANCH * (3 ** 8),
        "ratio_to_K_23_3_8": None if (K * D10_TOTAL * (3 ** 8)) == 0
            else (K * H) / (K * D10_TOTAL * (3 ** 8)),
        "factors": {cid: fac[cid]["n"] for cid in fac},
        "d10_branch_sum": d10_sum,
        "mechanism": {
            "shared_mu_A4": fac["A4a"]["n"] * fac["A4b"]["n"],
            "shared_mu_A4_vs_3_8": (fac["A4a"]["n"] * fac["A4b"]["n"]) / (3 ** 8),
            "C11_patterns": fac["C11"]["n"],
            "C5_patterns": fac["C5a"]["n"] * fac["C5b"]["n"],
            "D10_pt_patterns": fac["D10"]["n"],
            "D10_branch_sum_vs_23": d10_sum / D10_TOTAL,
            "incidence_bindings_immune_to_sigma": 0,
            "incidence_note": (
                "immune rows are coherence-immune (only parent = free stratum); "
                "the 145 order-0 relations do not constrain their values against "
                "the sigma-band. Z+ D10 C2-line multiplies by the mu0-selected "
                "branch; both parities are attainable for every defined pt_D10 "
                "pattern via mu0 |-> mu0+5, and the configuration sum uses "
                "sum_{mu0=1..4} branch(mu0) = 46."
            ),
        },
    }


def run_phase2(mod=330, verbose=True):
    os.makedirs(RESULTS, exist_ok=True)
    records = []
    G_list = []
    for d in range(mod):
        rec = G_of(d, sharing=True)
        records.append(rec)
        G_list.append(rec["G"])

    # G at d=35
    g35 = G_of(35, sharing=True)
    g35_off = G_of(35, sharing=False)

    profile = {
        "G_min": min(G_list),
        "G_max": max(G_list),
        "G_typical": sorted(G_list)[len(G_list) // 2],
        "G_at_35": g35["G"],
        "G_at_35_detail": g35,
        "G_at_35_sharing_off": g35_off["G"],
        "zeros": [d for d, g in enumerate(G_list) if g == 0],
        "unique_G_values": sorted(set(G_list)),
        "K_table": K_TABLE,
    }

    with open(os.path.join(RESULTS, "G_counts.json"), "w") as f:
        json.dump({
            "profile": profile,
            "records": [
                {k: r[k] for k in (
                    "d_mod_330", "d_mod_6", "K", "F_odd", "H_immune_D10",
                    "G", "G_triv", "product_K_23_3_8", "ratio_to_K_23_3_8",
                    "factors", "d10_branch_sum",
                )}
                for r in records
            ],
        }, f, indent=1)

    with open(os.path.join(RESULTS, "G_table.txt"), "w") as f:
        f.write("G(d mod 330) = K(d mod 6) * H_immune_D10(d)\n")
        f.write("replaces product K * D10 * 3^8\n")
        f.write("G(35 mod 330) = %d\n" % g35["G"])
        f.write("profile: min=%d max=%d typical=%d  zeros=%s\n\n"
                % (profile["G_min"], profile["G_max"], profile["G_typical"],
                   profile["zeros"]))
        f.write("%5s %4s %8s %12s %14s %16s %16s %10s\n"
                % ("d", "d6", "K", "F_odd", "H_imm_D10", "G",
                   "K*23*3^8", "ratio"))
        for r in records:
            f.write("%5d %4d %8d %12d %14d %16d %16d %10.6f\n"
                    % (r["d_mod_330"], r["d_mod_6"], r["K"], r["F_odd"],
                       r["H_immune_D10"], r["G"], r["product_K_23_3_8"],
                       r["ratio_to_K_23_3_8"] or 0.0))

    # diagnostics: how far below the product, by mechanism
    with open(os.path.join(RESULTS, "join_diagnostics.txt"), "w") as f:
        f.write("JOIN DIAGNOSTICS\n\n")
        f.write("Corrected K table (STAGE1_STRATIFIED):\n")
        for e in range(6):
            f.write("  d=%d mod 6: K=%d\n" % (e, K_TABLE[e]))
        f.write("\nIncidence bindings immune <-> sigma-band: 0\n")
        f.write("(STAGE1 §15.5: 22 rows have free stratum as only parent)\n")
        f.write("Z+ D10 C2-line: multiplies by branch(mu0) in {13,10};\n")
        f.write("  configuration sum_{mu0=1..4} branch = %d  (vs free 23)\n"
                % sum(d10_branch_for_mu0(m) for m in admissible_mus_D10()))
        f.write("\nAt d=35:\n")
        f.write(json.dumps(g35, indent=2, default=str))
        f.write("\n")

    # machine-readable value vectors at d=35 (cartesian factors)
    fac35 = g35  # already has factors counts
    _, full_fac = f_odd_count(35, sharing=True)
    with open(os.path.join(RESULTS, "vectors_d35.json"), "w") as f:
        json.dump({
            "d": 35,
            "F_odd": g35["F_odd"],
            "G": g35["G"],
            "K": g35["K"],
            "per_center": {
                cid: {
                    "n": full_fac[cid]["n"],
                    "row_names": full_fac[cid]["row_names"],
                    "vectors": full_fac[cid]["vectors"],
                }
                for cid in full_fac
            },
            "note": (
                "Joint 22-row value-vectors = cartesian product of the "
                "per-center lists.  G = K * H_immune_D10 with H summing "
                "D10 branch sizes over mu0."
            ),
        }, f, indent=1)

    if verbose:
        print("G profile:", {k: profile[k] for k in (
            "G_min", "G_max", "G_typical", "G_at_35", "zeros")})
        print("G(35) detail: K=%d F_odd=%d H=%d G=%d  product_K_23_3_8=%d"
              % (g35["K"], g35["F_odd"], g35["H_immune_D10"], g35["G"],
                 g35["product_K_23_3_8"]))
        print("PHASE2_OK")
    return profile, records


if __name__ == "__main__":
    run_phase2()
