#!/usr/bin/env python3
"""Independent verifier for the ten characteristic-zero chart obstructions."""
from __future__ import annotations

import hashlib
import itertools
import json
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PAYLOAD = HERE / "chart_triple_obstructions.json"
P_PATH = PROBLEM / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
FACTORS = PROBLEM / "certificates/fold_normalization_t2r/saturation_factors"
F27_PATH = PROBLEM / "tmp/t2r45/G_modp/F27_p101.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
MOD = 101
NAMES = ("Pu", "PA", "PB", "PY", "PZ")


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
        n = exps[axis]
        if n:
            e = list(exps)
            e[axis] -= 1
            out[tuple(e)] += c * n
    return {e: c for e, c in out.items() if c}


def as5(poly4):
    return {(a, b, y, z, 0): c for (a, b, y, z), c in poly4.items()}


def evaluate(poly, point):
    ans = 0
    for exps, c in poly.items():
        term = c % MOD
        for x, n in zip(point, exps):
            term = term * pow(x % MOD, n, MOD) % MOD
        ans = (ans + term) % MOD
    return ans


def det3(rows):
    (a, b, c), (d, e, f), (g, h, i) = rows
    return (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % MOD


def main() -> None:
    assert sha256(P_PATH) == EXPECTED_P
    payload = json.loads(PAYLOAD.read_text())
    assert payload["prime"] == MOD
    primitive = load(P_PATH, 5)
    gens = {
        "P": primitive,
        "Pu": deriv(primitive, 4),
        "PA": deriv(primitive, 0),
        "PB": deriv(primitive, 1),
        "PY": deriv(primitive, 2),
        "PZ": deriv(primitive, 3),
    }
    gates = {
        "ell": as5(load(FACTORS / "ell_lc_u.tsv", 4)),
        "C": as5(load(FACTORS / "C_content.tsv", 4)),
        "Q4": as5(load(FACTORS / "G_factor_Q4.tsv", 4)),
        "Puu": load(FACTORS / "P_uu.tsv", 5),
        "delta": load(FACTORS / "delta_Cramer.tsv", 5),
        "F27": as5(load(F27_PATH, 4)),
    }
    expected = {"/".join(t) for t in itertools.combinations(NAMES, 3)}
    assert set(payload["witnesses"]) == expected
    checks = {}
    for key in sorted(expected):
        witness = payload["witnesses"][key]
        triple = tuple(witness["triple"])
        point = tuple(witness["point"])
        assert point[0] == witness["fixed_parameters"]["A"] % MOD
        assert point[4] == witness["fixed_parameters"]["u"] % MOD
        values = {name: evaluate(poly, point) for name, poly in gens.items()}
        assert all(values[name] == 0 for name in triple)
        assert values["P"] != 0
        rows = [[evaluate(deriv(gens[name], axis), point) for axis in (1, 2, 3)] for name in triple]
        Delta = det3(rows)
        assert Delta != 0
        gate_values = {name: evaluate(poly, point) for name, poly in gates.items()}
        gate_values["L"] = (point[0] - 15) % MOD
        gate_values["M"] = point[1] % MOD
        gate_values["G"] = (
            48
            * gate_values["L"]
            * pow(gate_values["M"], 4, MOD)
            * gate_values["Q4"]
            * pow(gate_values["F27"], 2, MOD)
        ) % MOD
        assert all(gate_values.values())
        assert Delta == witness["Delta"]
        assert values == witness["generator_values"]
        assert gate_values == witness["gates"]
        checks[key] = {
            "point": list(point),
            "Delta": Delta,
            "P": values["P"],
            "all_named_gates_nonzero": True,
            "hensel_conclusion": (
                "with A=A0+s and u=u0+t, unique Z_101[[s,t]] lift solving "
                "the triple; P and gates remain units"
            ),
        }
    result = {
        "schema": "klein-t-chart-triple-hensel-obstructions-verify-v1",
        "status": "ACCEPT",
        "primitive_P_sha256": EXPECTED_P,
        "checks": checks,
        "mathematical_implication": (
            "Nonsingular multivariate Hensel over Z_101[[s,t]], after setting "
            "A=A0+s and u=u0+t, lifts each witness over an injective copy of "
            "Q(A,u). Since P is a unit at the lift, the localized triple "
            "strictly contains the full singular scheme after "
            "characteristic-zero base change."
        ),
    }
    (HERE / "verify_chart_triple_obstructions_result.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    print("CHART_TRIPLE_OBSTRUCTION_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
