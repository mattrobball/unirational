#!/usr/bin/env python3
"""Independent verifier for G3C (does not import produce)."""
from __future__ import annotations

import hashlib
import itertools
import json
import sys
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
G3A_STATUS = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md"
G3B_STATUS = ROOT / "goal_runs_after_0aecc89/G3B_LINE_CONIC_SEARCH/STATUS.md"
G3B_RECIPE = ROOT / "goal_runs_after_0aecc89/G3B_LINE_CONIC_SEARCH/formal_line_recipe.json"

T3, T6, T8, T11 = sp.symbols("t3 t6 t8 t11")
DIM_SEC = 12
N_AMB = 5


def fail(msg: str) -> None:
    print(f"G3C_VERIFY_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def entry_to_vec(entries):
    v = [sp.S.Zero] * DIM_SEC
    for e in entries:
        sec = e["secondary"]
        e3, e6, e8, e11 = e["projective_exponents"]
        mon = (
            sp.Rational(e["numerator"], e["denominator"])
            * (T3**e3)
            * (T6**e6)
            * (T8**e8)
            * (T11**e11)
        )
        v[sec] += mon
    return tuple(map(sp.cancel, v))


def load_alpha(payload):
    alpha = [
        [[tuple(sp.S.Zero for _ in range(DIM_SEC)) for _ in range(N_AMB)] for _ in range(N_AMB)]
        for _ in range(N_AMB)
    ]
    for item in payload["coefficients"]:
        triple = tuple(item["triple"])
        cvec = entry_to_vec(item["normalized_entries"])
        perms = list(set(itertools.permutations(triple)))
        share = tuple(sp.cancel(c / len(perms)) for c in cvec)
        for i, j, k in perms:
            alpha[i][j][k] = share
    return alpha


def phi_vec(alpha, a):
    out = [sp.S.Zero] * DIM_SEC
    for i, j, k in itertools.product(range(N_AMB), repeat=3):
        mon = a[i] * a[j] * a[k]
        if mon == 0:
            continue
        for s in range(DIM_SEC):
            c = alpha[i][j][k][s]
            if c != 0:
                out[s] += c * mon
    return [sp.expand(x) for x in out]


def polar_vec(alpha, u, v, w):
    out = [sp.S.Zero] * DIM_SEC
    for i, j, k in itertools.product(range(N_AMB), repeat=3):
        mon = u[i] * v[j] * w[k]
        if mon == 0:
            continue
        for s in range(DIM_SEC):
            c = alpha[i][j][k][s]
            if c != 0:
                out[s] += c * mon
    return [sp.expand(x) for x in out]


def vec_is_zero(v) -> bool:
    return all(c == 0 for c in v)


def eval_sparse_kproj_eq(eq_terms, param_values):
    """Evaluate a sparse K_proj polynomial (list of monoms with kproj comps)."""
    acc = [sp.S.Zero] * DIM_SEC
    for term in eq_terms:
        mon = sp.S.One
        for exp, val in zip(term["exponents"], param_values):
            if exp:
                mon *= val**exp
        for comp in term["kproj_components"]:
            s = comp["secondary"]
            # parse numerator/denominator sympy strings
            num = sp.sympify(comp["numerator"], locals={"t3": T3, "t6": T6, "t8": T8, "t11": T11})
            den = sp.sympify(comp["denominator"], locals={"t3": T3, "t6": T6, "t8": T8, "t11": T11})
            acc[s] += mon * (num / den)
    return [sp.cancel(sp.expand(c)) for c in acc]


def main() -> None:
    require(G3A_STATUS.is_file(), "missing G3A STATUS")
    require(G3B_STATUS.is_file(), "missing G3B STATUS")
    g3a = G3A_STATUS.read_text().splitlines()[0].strip()
    g3b = G3B_STATUS.read_text().splitlines()[0].strip()
    require(g3a == "G3A-ARITHMETIC-DOMINANCE-PASS", f"G3A exit {g3a}")
    require(g3b == "G3B-UNDECIDED", f"G3B exit {g3b}")

    status_path = HERE / "STATUS.md"
    man_path = HERE / "INPUT_MANIFEST.json"
    fano_path = HERE / "line_fano_kproj.json"
    require(status_path.is_file(), "missing STATUS.md")
    require(man_path.is_file(), "missing INPUT_MANIFEST.json")
    require(fano_path.is_file(), "missing line_fano_kproj.json")
    require((HERE / "LINE_FANO_KPROJ.md").is_file(), "missing LINE_FANO_KPROJ.md")
    require((HERE / "REPLAY.md").is_file(), "missing REPLAY.md")
    require((HERE / "produce.py").is_file(), "missing produce.py")

    exit_str = status_path.read_text().splitlines()[0].strip()
    require(
        exit_str
        in {
            "G3C-POINT-PASS",
            "G3C-UNDECIDED",
            "G3C-CANONICAL-INPUT-FAIL",
            "G3C-BLOCKED",
        },
        f"bad exit {exit_str}",
    )

    man = json.loads(man_path.read_text())
    for row in man["inputs"]:
        p = ROOT / row["path"]
        require(p.is_file(), f"manifest missing {row['path']}")
        require(sha256(p) == row["sha256"], f"hash mismatch {row['path']}")

    # G3B recipe chart layout matches
    recipe = json.loads(G3B_RECIPE.read_text())
    require(len(recipe["charts"]) == 10, "G3B recipe not 10 charts")

    fano = json.loads(fano_path.read_text())
    require(fano["schema"] == "g3c-line-fano-kproj-v1", "bad fano schema")
    require(fano["n_charts"] == 10, "expected 10 charts")
    require(len(fano["charts"]) == 10, "charts length")
    require(fano["equations_per_chart_K_proj"] == 4, "4 K_proj eqs")
    require(fano["component_equations_per_chart_P0"] == 48, "48 component eqs")

    # each chart: 6 params, 4 eqs, B_AAB linear in free B
    for ch, sm in zip(fano["charts"], fano["chart_summaries"]):
        require(ch["n_parameters"] == 6, "n_parameters")
        require(len(ch["equations"]) == 4, "4 equations")
        require(
            sm["linear_elimination"]["B_AAB_linear_in_free_B"] is True,
            f"B_AAB not linear in free B for pivots {ch['pivots']}",
        )
        baab = next(e for e in ch["equations"] if e["name"] == "B_AAB")
        require(baab["term_count"] > 0, "empty B_AAB")
        # degrees in B free params <= 1
        bdegs = baab["degree_profile"]["max_degree_per_param"][3:6]
        require(all(d <= 1 for d in bdegs), f"B_AAB not deg<=1 in B: {bdegs}")

    # Independent: rebuild for chart (0,1) and match full-term ledger if present.
    payload = json.loads(GENERIC.read_text())
    alpha = load_alpha(payload)
    ch0 = fano["charts"][0]
    require(ch0["pivots"] == [0, 1], "first chart pivots")
    require(ch0.get("stores_full_terms") is True, "chart0 should store full terms")
    vals = [sp.Integer(v) for v in (1, -1, 2, 0, 1, -2)]
    A = [1, 0, vals[0], vals[1], vals[2]]
    B = [0, 1, vals[3], vals[4], vals[5]]
    direct = {
        "Phi_A": phi_vec(alpha, A),
        "B_AAB": polar_vec(alpha, A, A, B),
        "B_ABB": polar_vec(alpha, A, B, B),
        "Phi_B": phi_vec(alpha, B),
    }
    for eq in ch0["equations"]:
        name = eq["name"]
        require("terms" in eq, f"chart0 missing terms for {name}")
        from_ledger = eval_sparse_kproj_eq(eq["terms"], vals)
        for s in range(DIM_SEC):
            diff = sp.simplify(direct[name][s] - from_ledger[s])
            require(diff == 0, f"chart0 eq {name} sec{s} mismatch: {diff}")

    # Independent re-expand: term counts + B_AAB linearity for every chart
    A_syms = sp.symbols("A0:3")
    B_syms = sp.symbols("B0:3")
    for ch in fano["charts"]:
        piv = tuple(ch["pivots"])
        free_cols = [c for c in range(N_AMB) if c not in piv]
        i, j = piv
        A = [sp.S.Zero] * N_AMB
        B = [sp.S.Zero] * N_AMB
        A[i], A[j] = sp.S.One, sp.S.Zero
        B[i], B[j] = sp.S.Zero, sp.S.One
        for k, c in enumerate(free_cols):
            A[c] = A_syms[k]
            B[c] = B_syms[k]
        params = list(A_syms) + list(B_syms)
        comps = {
            "Phi_A": phi_vec(alpha, A),
            "B_AAB": polar_vec(alpha, A, A, B),
            "B_ABB": polar_vec(alpha, A, B, B),
            "Phi_B": phi_vec(alpha, B),
        }
        for eq in ch["equations"]:
            name = eq["name"]
            # count monoms by expanding component 0..11 into free params
            monoms = set()
            max_b = [0, 0, 0]
            for s, expr in enumerate(comps[name]):
                if expr == 0:
                    continue
                p = sp.Poly(sp.expand(expr), *params)
                for exps in p.as_dict():
                    monoms.add(tuple(int(e) for e in exps))
                    for bi in range(3):
                        max_b[bi] = max(max_b[bi], int(exps[3 + bi]))
            require(
                len(monoms) == eq["term_count"],
                f"term_count mismatch chart {piv} {name}: {len(monoms)} vs {eq['term_count']}",
            )
            if name == "B_AAB":
                require(all(d <= 1 for d in max_b), f"B_AAB not linear in B on {piv}")

    # Coordinate lines: recompute and match ledger
    for row in fano["coordinate_pair_lines_full_K_proj"]:
        A, B = row["A"], row["B"]
        on = all(
            vec_is_zero(v)
            for v in (
                phi_vec(alpha, A),
                polar_vec(alpha, A, A, B),
                polar_vec(alpha, A, B, B),
                phi_vec(alpha, B),
            )
        )
        require(on == row["on_cubic_full_K_proj"], f"coord line mismatch {A},{B}")

    # Point exit consistency
    if exit_str == "G3C-POINT-PASS":
        require(fano.get("K_proj_line_found") is True, "POINT-PASS without flag")
        require((HERE / "POINT.md").is_file(), "missing POINT.md")
    else:
        require(fano.get("K_proj_line_found") is False, "line flag true without POINT-PASS")
        # modular-only must not flip exit
        mod = fano.get("modular_discovery_full_components", {})
        total_mod = sum(mod[p]["n_found"] for p in mod)
        if total_mod > 0:
            require(exit_str == "G3C-UNDECIDED", "modular hits must not force POINT-PASS")

    # residual gates named
    require(len(fano.get("smallest_open_gates", [])) >= 1, "missing open gates")
    require("specialized secondary-0 residual CAS is not K_proj emptiness" in fano.get("nonclaims", []), "missing nonclaim")

    seal_path = HERE / "SEAL.json"
    sums_path = HERE / "SHA256SUMS"
    require(seal_path.is_file(), "missing SEAL.json")
    require(sums_path.is_file(), "missing SHA256SUMS")
    seal = json.loads(seal_path.read_text())
    require(seal.get("exit") == exit_str, "SEAL exit mismatch")
    require(seal.get("headline") == "OPEN", "headline OPEN")
    require(
        seal.get("K_proj_line_found") == fano.get("K_proj_line_found"),
        "seal line flag",
    )
    for name, expected in seal.get("files", {}).items():
        path = HERE / name
        require(path.is_file(), f"sealed missing {name}")
        require(sha256(path) == expected, f"seal hash mismatch {name}")
    for line in sums_path.read_text().splitlines():
        line = line.strip()
        if not line:
            continue
        parts = line.split()
        require(len(parts) == 2, f"bad SHA256SUMS line {line!r}")
        digest, name = parts
        if name == "SHA256SUMS":
            continue
        p = HERE / name
        require(p.is_file(), f"SHA256SUMS missing file {name}")
        require(sha256(p) == digest, f"SHA256SUMS mismatch {name}")

    print("G3C_VERIFY_OK")
    print(exit_str)
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
