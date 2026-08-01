#!/usr/bin/env python3
"""Screen all ten nonsingular triples of the full fold singular generators.

This is finite-field discovery only.  It asks whether a triple among
Pu,PA,PB,PY,PZ has Delta-open, gate-open points which are not points of the
full six-generator singular ideal.  One such point refutes that triple with
the named gates, exactly as for the already-dead (PB,PY,PZ) chart.
"""
from __future__ import annotations

import hashlib
import itertools
import json
from collections import defaultdict
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
P_PATH = PROBLEM / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
FACTORS = PROBLEM / "certificates/fold_normalization_t2r/saturation_factors"
F27_PATH = PROBLEM / "tmp/t2r45/G_modp/F27_p101.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
P = 101
PAIRS = [(63, 35), (2, 3), (5, 7), (100, 50), (0, 1), (10, 10), (-1, 2), (20, 7)]
GEN_NAMES = ("Pu", "PA", "PB", "PY", "PZ")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path: Path, nvars: int):
    out = defaultdict(int)
    with path.open() as fh:
        next(fh)
        for line in fh:
            row = tuple(map(int, line.split()))
            assert len(row) == nvars + 1
            out[row[:-1]] += row[-1]
    return {e: c for e, c in out.items() if c}


def deriv(poly, axis):
    out = defaultdict(int)
    for exps, c in poly.items():
        if exps[axis]:
            e = list(exps)
            out[tuple(e[:axis] + [e[axis] - 1] + e[axis + 1 :])] += c * e[axis]
    return {e: c for e, c in out.items() if c}


def specialize(poly, A0, u0):
    out = defaultdict(int)
    for (a, b, y, z, uu), c in poly.items():
        out[(b, y, z)] += (c % P) * pow(A0 % P, a, P) * pow(u0 % P, uu, P)
    return {e: c % P for e, c in out.items() if c % P}


def powers():
    x = np.arange(P, dtype=np.int64)
    ans = np.ones((P, 7), dtype=np.int64)
    for i in range(1, 7):
        ans[:, i] = ans[:, i - 1] * x % P
    return ans


POW = powers()


def grid(poly3):
    coeff = np.zeros((7, 7, 7), dtype=np.int64)
    for e, c in poly3.items():
        coeff[e] = c % P
    t1 = np.einsum("ijk,zk->ijz", coeff, POW, optimize=True) % P
    t2 = np.einsum("ijz,yj->iyz", t1, POW, optimize=True) % P
    return np.einsum("iyz,bi->byz", t2, POW, optimize=True) % P


def eval_poly(poly, point):
    A, B, Y, Z, u = point
    total = 0
    for exps, c in poly.items():
        values = (A, B, Y, Z, u)
        term = c % P
        for value, exponent in zip(values, exps):
            term = term * pow(value % P, exponent, P) % P
        total = (total + term) % P
    return total


def as5(poly4):
    return {(a, b, y, z, 0): c for (a, b, y, z), c in poly4.items()}


def main():
    assert sha256(P_PATH) == EXPECTED_P
    primitive = load(P_PATH, 5)
    gens = {
        "P": primitive,
        "Pu": deriv(primitive, 4),
        "PA": deriv(primitive, 0),
        "PB": deriv(primitive, 1),
        "PY": deriv(primitive, 2),
        "PZ": deriv(primitive, 3),
    }
    jac = {(name, axis): deriv(gens[name], axis) for name in GEN_NAMES for axis in (1, 2, 3)}
    gates = {
        "ell": as5(load(FACTORS / "ell_lc_u.tsv", 4)),
        "C": as5(load(FACTORS / "C_content.tsv", 4)),
        "Q4": as5(load(FACTORS / "G_factor_Q4.tsv", 4)),
        "Puu": load(FACTORS / "P_uu.tsv", 5),
        "delta": load(FACTORS / "delta_Cramer.tsv", 5),
        "F27": as5(load(F27_PATH, 4)),
    }
    rows = []
    for A0, u0 in PAIRS:
        gen_grids = {name: grid(specialize(poly, A0, u0)) for name, poly in gens.items()}
        jac_grids = {key: grid(specialize(poly, A0, u0)) for key, poly in jac.items()}
        full = np.ones((P, P, P), dtype=bool)
        for name in gens:
            full &= gen_grids[name] == 0
        for triple in itertools.combinations(GEN_NAMES, 3):
            mask = np.ones_like(full)
            for name in triple:
                mask &= gen_grids[name] == 0
            a, b, c = (jac_grids[(triple[0], i)] for i in (1, 2, 3))
            d, e, f = (jac_grids[(triple[1], i)] for i in (1, 2, 3))
            g, h, i = (jac_grids[(triple[2], j)] for j in (1, 2, 3))
            det = (a * ((e * i - f * h) % P) - b * ((d * i - f * g) % P) + c * ((d * h - e * g) % P)) % P
            chart = mask & (det != 0)
            candidates = np.argwhere(chart)
            good = int(np.count_nonzero(chart & full))
            bad_gate_open = []
            for B0, Y0, Z0 in candidates:
                if full[B0, Y0, Z0]:
                    continue
                point = (A0 % P, int(B0), int(Y0), int(Z0), u0 % P)
                gv = {name: eval_poly(poly, point) for name, poly in gates.items()}
                gv["L"] = (point[0] - 15) % P
                gv["M"] = point[1]
                gv["G"] = 48 * gv["L"] * pow(gv["M"], 4, P) * gv["Q4"] * pow(gv["F27"], 2, P) % P
                if all(gv.values()):
                    bad_gate_open.append({
                        "point": list(point),
                        "generator_values": {name: int(gen_grids[name][B0, Y0, Z0]) for name in gens},
                        "gates": gv,
                        "Delta": int(det[B0, Y0, Z0]),
                    })
                    if len(bad_gate_open) == 2:
                        break
            row = {
                "A": A0,
                "u": u0,
                "triple": list(triple),
                "chart_points": int(len(candidates)),
                "full_singular_points": good,
                "gate_open_extraneous_count_lower_bound": len(bad_gate_open),
                "gate_open_extraneous_examples": bad_gate_open,
            }
            rows.append(row)
            print(A0, u0, triple, len(candidates), good, len(bad_gate_open), flush=True)
        del gen_grids, jac_grids, full
    summary = {}
    for triple in itertools.combinations(GEN_NAMES, 3):
        rs = [r for r in rows if tuple(r["triple"]) == triple]
        summary["/".join(triple)] = {
            "pairs_screened": len(rs),
            "total_chart_points": sum(r["chart_points"] for r in rs),
            "total_full_singular_points": sum(r["full_singular_points"] for r in rs),
            "pairs_with_gate_open_extraneous_witness": sum(bool(r["gate_open_extraneous_examples"]) for r in rs),
        }
    payload = {
        "schema": "klein-t-all-chart-triples-screen-v1",
        "claim_scope": "finite-field discovery; an explicit witness refutes only the indicated chart with the named gates",
        "prime": P,
        "primitive_P_sha256": EXPECTED_P,
        "pairs": PAIRS,
        "summary": summary,
        "rows": rows,
    }
    (HERE / "all_chart_triples_p101.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("ALL_CHART_TRIPLES_SCREEN_COMPLETE")


if __name__ == "__main__":
    main()
