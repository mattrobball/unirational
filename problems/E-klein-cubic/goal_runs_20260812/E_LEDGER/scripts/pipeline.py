#!/usr/bin/env python3
"""
E_LEDGER producer.  Runs every layer and writes results/*.json.

    python3 scripts/pipeline.py            # both split primes (default)
    E_LEDGER_PRIMES=331 python3 scripts/pipeline.py

Layers, in the order the data spec fixes them:
  0  chow.py      calibration anchors (FATAL) and the C1 reproduction (FATAL)
  1  census.py    the 14 orbits cited, and the arrangement rebuilt (FATAL:
                  it must return 940 / 220 / 55 in 14 orbits)
  2  e2           Lemma F proved + the three congruences + the d = 35 instance
  3  e3           the covering families certified + the exact LP
  4  e4           the system emitted, its rank, the ND corollary
"""

import json
import os
import sys
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, ".."))
sys.path.insert(0, HERE)

import chow                                         # noqa: E402
import census                                       # noqa: E402
import e2_congruences as e2                         # noqa: E402
import e3_movable as e3                             # noqa: E402
import e4_system as e4                              # noqa: E402
import lp                                           # noqa: E402
from psl211 import Model, SPLIT_PRIMES              # noqa: E402

RESULTS = os.path.join(ROOT, "results")
D = 35


def primes():
    v = os.environ.get("E_LEDGER_PRIMES")
    if v:
        return tuple(int(x) for x in v.split(","))
    return SPLIT_PRIMES


# ------------------------------------------------------------------ E3 LP

def e3_rows(cert):
    """Turn the certified families into LP rows (labelled by census name)."""
    rows = []
    for f in cert["certified"]:
        if f["status"] != "CERTIFIED":
            continue
        coeffs = {}
        for k, v in f["incidence"].items():
            coeffs[cert["labels"][k]] = v
        rows.append({"name": f["name"], "coeffs": coeffs})
    # de-duplicate
    seen, out = set(), []
    for r in rows:
        key = tuple(sorted(r["coeffs"].items()))
        if key in seen:
            continue
        seen.add(key)
        out.append(r)
    return out


def run_lp(rows, include_cone):
    labels = e4.ORDER
    idx = {l: k for k, l in enumerate(labels)}
    A, b, names = [], [], []
    for r in rows:
        row = [Fraction(0)] * len(labels)
        for l, c in r["coeffs"].items():
            row[idx[l]] += c
        A.append(row)
        b.append(Fraction(1))
        names.append(r["name"])
    if include_cone:
        row = [Fraction(0)] * len(labels)
        row[idx["P_sigma"]] = Fraction(3)
        row[idx["ell_V"]] = Fraction(-2)
        A.append(row)
        b.append(Fraction(0))
        names.append("cone_coupling_3m_P<=2m_ellV")

    out = {"rows": [{"name": nm, "coeffs": {labels[j]: str(A[i][j])
                                            for j in range(len(labels))
                                            if A[i][j] != 0},
                     "rhs": str(b[i])} for i, nm in enumerate(names)],
           "objectives": {}}
    for k, l in enumerate(labels):
        c = [Fraction(1) if j == k else Fraction(0) for j in range(len(labels))]
        res = lp.solve_max(c, A, b)
        chk = lp.check_certificate(c, A, b, res)
        out["objectives"][l] = {
            "max_m_over_d": str(res["value"]) if res["value"] is not None else None,
            "status": res["status"],
            "max_m_at_d=%d" % D: (str(Fraction(D) * res["value"])
                                  if res["value"] is not None else None),
            "floor_at_d=%d" % D: (int(Fraction(D) * res["value"])
                                  if res["value"] is not None else None),
            "primal_x": [str(v) for v in res["x"]] if res["x"] else None,
            "dual_y": [str(v) for v in res["y"]] if res["y"] else None,
            "certificate_recheck": chk,
        }
    return out, A, b, names, labels


def run_pinning(A, b, names, labels):
    """Feasibility of the pinned lower bounds, and the degree bound they give."""
    lower = [Fraction(e3.PINNED_D35[l][0], D) for l in labels]   # as m/d
    viol, slack = [], []
    for i in range(len(A)):
        s = sum(A[i][j] * lower[j] for j in range(len(labels)))
        slack.append({"row": names[i], "lhs": str(s), "rhs": str(b[i]),
                      "ok": s <= b[i]})
        if s > b[i]:
            viol.append(names[i])
    # smallest d for which the (absolute) pinned lower bounds satisfy every row
    absl = [Fraction(e3.PINNED_D35[l][0]) for l in labels]
    dmin = 0
    for i in range(len(A)):
        if b[i] == 0:
            continue                     # the homogeneous cone-coupling row
        s = sum(A[i][j] * absl[j] for j in range(len(labels)))
        dmin = max(dmin, s)
    return {"pinned_lower_bounds": {l: {"m_min": e3.PINNED_D35[l][0],
                                        "source": e3.PINNED_D35[l][1]}
                                    for l in labels},
            "feasible_at_d=%d" % D: not viol,
            "violated_rows": viol,
            "row_slack": slack,
            "min_degree_forced_by_E3_plus_pinning": str(dmin),
            "note": "d >= max over covering families of sum(incidence * "
                    "pinned lower bound); this is the unconditional degree "
                    "bound the certified degree-1 movable cone gives."}


# ------------------------------------------------------------------ main

def main():
    os.makedirs(RESULTS, exist_ok=True)
    out = {}

    # ---- layer 0 ----------------------------------------------------
    anchors = chow.run_anchors()
    c1 = chow.run_c1_reproduction()
    out["anchors"] = anchors
    out["c1_reproduction"] = c1
    fatal = [k for k, v in anchors.items() if not v["pass"]]
    fatal += [k for k, v in c1.items() if not v["pass"]]
    out["fatal_gate_layer0"] = {"failed": fatal, "pass": not fatal}
    if fatal:
        json.dump(out, open(os.path.join(RESULTS, "e_ledger.json"), "w"), indent=1)
        raise SystemExit("FATAL: calibration/C1 gate failed: %r" % fatal)

    # ---- layer 1 ----------------------------------------------------
    out["census_cited"] = {"orbits": {k: {"dim": v[0], "size": v[1],
                                          "pointwise_stab": v[2],
                                          "setwise_stab": v[3],
                                          "|setwise_stab|": v[4]}
                                      for k, v in census.CENSUS.items()},
                           "source": census.CENSUS_SRC,
                           "totals": census.census_totals()}
    out["rebuild"] = {}
    out["e3_by_prime"] = {}
    geoms = {}
    for p in primes():
        G = e3.Geometry(p)
        geoms[p] = G
        prof = G.A.profile()
        labmap = census.label_orbits(G.A)
        rb = {"points": prof[1][0], "lines": prof[2][0], "planes": prof[3][0],
              "orbit_sizes_dim0": prof[1][1], "orbit_sizes_dim1": prof[2][1],
              "orbit_sizes_dim2": prof[3][1],
              "n_orbits": len(G.A.orbits),
              "labels": {str(i): labmap[i] for i in sorted(labmap)},
              "matches_cited_census": (
                  prof[1][0] == 940 and prof[2][0] == 220 and prof[3][0] == 55
                  and len(G.A.orbits) == 14
                  and sorted(census.CENSUS[l][1] for l in census.CENSUS)
                  == sorted(len(o) for o in G.A.orbits))}
        # plus-plane pairwise meeting (feeds FLAG E2-G-ORBIT)
        planes = G.orbits[G.planes[0]]
        pair = {"meet_in_a_point": 0, "meet_in_a_line": 0, "disjoint": 0}
        for i in range(len(planes)):
            for j in range(i + 1, len(planes)):
                dd = G.meet_dim(planes[i], planes[j])
                pair["disjoint" if dd == 0 else
                     ("meet_in_a_point" if dd == 1 else "meet_in_a_line")] += 1
        rb["plus_plane_pairs"] = pair
        rb["plus_plane_union_is_connected"] = (pair["disjoint"] == 0)
        out["rebuild"][str(p)] = rb

        cert = e3.enumerate_families(G, budget=200)
        cert["labels"] = {str(i): labmap[i] for i in sorted(labmap)}
        out["e3_by_prime"][str(p)] = cert

    # both primes must give the same incidence vectors
    keys = sorted(out["e3_by_prime"])
    vecs = {}
    for p in keys:
        vecs[p] = sorted(tuple(sorted(r["coeffs"].items()))
                         for r in e3_rows(out["e3_by_prime"][p]))
    out["e3_two_prime_agreement"] = {"primes": keys,
                                     "agree": len({json.dumps(v) for v in vecs.values()}) == 1}

    # ---- layer 2 ----------------------------------------------------
    m = Model(int(keys[0]))
    orders, _ = e2.derive_subgroup_orders(m)
    lemma = e2.lemma_F_check(orders)
    coeffs = e2.congruence_coefficients(orders)
    heavy = {}
    for p in e2.PRIMES:
        heavy[str(p)] = sorted(
            {lab: {"orbit_size": v[1], "|Stab|": v[4],
                   "n mod %d" % p: v[1] % p}
             for lab, v in census.CENSUS.items() if v[4] % p == 0}.items())
    out["e2"] = {
        "subgroup_orders_derived_from_the_660_matrices": orders,
        "lemma_F": lemma,
        "congruence_coefficients": coeffs,
        "fourth_powers": {str(p): e2.fourth_powers(p) for p in e2.PRIMES},
        "census_orbits_surviving_the_filter": heavy,
        "d35_order11": e2.d35_order11(
            [lab for lab, v in census.CENSUS.items() if v[4] % 11 == 0]),
        "instance_d35": e2.instance(D, orders),
    }

    # ---- layer 3 ----------------------------------------------------
    rows = e3_rows(out["e3_by_prime"][keys[0]])
    lp_core, A, b, names, labels = run_lp(rows, include_cone=False)
    lp_cone, A2, b2, n2, _ = run_lp(rows, include_cone=True)
    out["e3_lp_core"] = lp_core
    out["e3_lp_with_cone_coupling"] = lp_cone
    out["e3_pinning_core"] = run_pinning(A, b, names, labels)
    out["e3_pinning_with_cone"] = run_pinning(A2, b2, n2, labels)
    out["e3_cone_coupling_source"] = e3.CONE_COUPLING_SRC

    # ---- layer 4 ----------------------------------------------------
    out["e4"] = e4.build(D)
    out["e4_nd_corollary"] = e4.nd_corollary(D, None)

    with open(os.path.join(RESULTS, "e_ledger.json"), "w") as fh:
        json.dump(out, fh, indent=1, default=str)
    print("wrote", os.path.join(RESULTS, "e_ledger.json"))
    return out


if __name__ == "__main__":
    main()
