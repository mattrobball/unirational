#!/usr/bin/env python3
"""Produce all RAMIFICATION_COMPLEX artefacts."""
from __future__ import annotations

import json
import os
import sys

import paths
from weight_rule import (
    pathA_weight, pathB_weight_monomial, SPECTRUM, relative_weights,
    forbidden_relative_weight, differential_blocks, QR11,
)
from tangent_cone import build_receiver_tc_table, all_c11_tangent_cones
from conormal_tables import build_all_tables, build_s2_index
from join_ramcx import run_join
from d35_effects import run_d35


def crosscheck_pathAB(n_samples=200):
    """PATH A vs PATH B on random (n,d,base,chain,k) — must agree."""
    import random
    random.seed(42)
    mismatches = 0
    checked = 0
    for n in (3, 5, 6, 11):
        a = SPECTRUM[n]["weights"]
        for _ in range(n_samples):
            d = random.randint(0, 40)
            k0 = random.randrange(5)
            a_k = a[k0]
            # one-step chain
            js = [j for j in range(5) if j != k0]
            j = random.choice(js)
            c = (a[j] - a_k) % n
            mu = random.randint(0, min(d, 6))
            wA = pathA_weight(n, d * a_k, [(mu, c)])
            # PATH B monomial x_k^{d-mu} x_j^{mu}
            exp = [0] * 5
            exp[k0] = d - mu
            exp[j] = mu
            wB = pathB_weight_monomial(n, exp)
            checked += 1
            if wA != wB:
                mismatches += 1
    return dict(checked=checked, mismatches=mismatches, ok=(mismatches == 0))


def main():
    RES = paths.RESULTS
    print("=== RAMIFICATION_COMPLEX producer ===", flush=True)

    # 1. PATH A/B cross-check
    print("PATH A/B cross-check...", flush=True)
    ab = crosscheck_pathAB(300)
    json.dump(ab, open(os.path.join(RES, "pathAB_crosscheck.json"), "w"),
              indent=1)
    print("  ", ab, flush=True)
    assert ab["ok"], "PATH A/B mismatch"

    # 2. Receiver tangent-cone tables
    print("Receiver tangent-cone tables...", flush=True)
    tc = build_receiver_tc_table()
    json.dump(tc, open(os.path.join(RES, "receiver_tangent_cone.json"), "w"),
              indent=1)
    print("  C11 formula match:", tc["C11_formula_all_match"],
          "machine:", tc["C11_machine_ok"], flush=True)

    # 3. Per-row conormal + admissible tables (both primes for frame match)
    all_summaries = {}
    for p in paths.PRIMES:
        print("Conormal tables p=%d..." % p, flush=True)
        tables, summary = build_all_tables(p=p, kmax=6)
        json.dump(tables, open(os.path.join(RES, "conormal_tables_p%d.json" % p),
                               "w"), indent=1)
        json.dump(summary, open(os.path.join(RES, "conormal_summary_p%d.json" % p),
                                "w"), indent=1)
        all_summaries[str(p)] = summary
        print("  tabulated=%d live_vals=%d dead_vals=%d" % (
            summary["n_tabulated"], summary["total_live_values"],
            summary["total_dead_values"]), flush=True)

    # human-readable per-row sizes
    lines = ["id role  K    n_conorm n_val live dead chain / s2_name",
             "-" * 72]
    for r in all_summaries["331"]["per_row"]:
        lines.append(
            "#%02d %-6s %-4s %5d %5d %4d %4d  %s | %s" % (
                r["id"], r["role"], r["K"], r["n_conormal"],
                r["n_value_options"], r["n_live_values"], r["n_dead_values"],
                r["chain"], r["s2_name"] or ""))
    open(os.path.join(RES, "conormal_table_sizes.txt"), "w").write(
        "\n".join(lines) + "\n")

    # 4. Join onto J census
    print("Join onto J census...", flush=True)
    status, join_sum = run_join(kmax=8)
    json.dump(status, open(os.path.join(RES, "immune_residue_status.json"), "w"),
              indent=1)
    json.dump(join_sum, open(os.path.join(RES, "join_summary.json"), "w"),
              indent=1)
    # also per-class joint table text
    jt = ["rho  J_sealed  J_ram  cut  zero  killed_rows",
          "-" * 60]
    for r in join_sum["per_class"]:
        jt.append("%d    %7d  %5d  %4d  %s  %s" % (
            r["d_mod6"], r["J_sealed"], r["J_ram"], r["cut"],
            "FLAG" if r["zero"] else "no",
            len(r["killed_rows"])))
    open(os.path.join(RES, "joint_table.txt"), "w").write("\n".join(jt) + "\n")
    print("  ramification_free=%s any_zero=%s" % (
        join_sum["ramification_free"], join_sum["any_zero"]), flush=True)
    for r in join_sum["per_class"]:
        print("  ρ=%d  J=%d → J_ram=%d  cut=%d" % (
            r["d_mod6"], r["J_sealed"], r["J_ram"], r["cut"]), flush=True)

    # 5. d=35 effects on the 22
    print("d=35 effects on the 22...", flush=True)
    d35 = run_d35()
    json.dump(d35, open(os.path.join(RES, "d35_effects.json"), "w"), indent=1)
    print("  anchor intact:", d35["anchor_22_intact"],
          "closed kills on 22:", d35["n_closed_kills_on_22"], flush=True)
    print("  immune closed:", d35["n_immune_closed"], flush=True)

    # 6. Master summary
    master = dict(
        headline="Problem E remains OPEN; this packet excludes no degree.",
        primes=list(paths.PRIMES),
        pathAB=ab,
        tc_C11_ok=tc["C11_formula_all_match"] and all(tc["C11_machine_ok"].values()),
        conormal=dict(
            n_tabulated=all_summaries["331"]["n_tabulated"],
            n_sweep=all_summaries["331"]["n_sweep"],
            n_immune=all_summaries["331"]["n_immune"],
            total_live_values=all_summaries["331"]["total_live_values"],
            total_dead_values=all_summaries["331"]["total_dead_values"],
            per_row_sizes=[
                dict(id=r["id"], role=r["role"], n_conormal=r["n_conormal"],
                     n_val=r["n_value_options"], live=r["n_live_values"],
                     dead=r["n_dead_values"])
                for r in all_summaries["331"]["per_row"]
            ],
        ),
        join=dict(
            J_sealed=join_sum["J_sealed"],
            J_ram=[r["J_ram"] for r in join_sum["per_class"]],
            cuts=[r["cut"] for r in join_sum["per_class"]],
            zeros=join_sum["zeros"],
            any_zero=join_sum["any_zero"],
            ramification_free=join_sum["ramification_free"],
        ),
        d35=dict(
            anchor_intact=d35["anchor_22_intact"],
            n_closed_kills_on_22=d35["n_closed_kills_on_22"],
            n_immune_closed=d35["n_immune_closed"],
            cross_prime_count_agree=d35["cross_prime_count_agree"],
        ),
    )
    json.dump(master, open(os.path.join(RES, "summary.json"), "w"), indent=1)
    print("=== PRODUCE OK ===", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
