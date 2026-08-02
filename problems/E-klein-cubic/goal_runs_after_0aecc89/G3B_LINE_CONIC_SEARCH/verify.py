#!/usr/bin/env python3
"""Independent verifier for G3B line/conic lane (does not import produce_g3b)."""

from __future__ import annotations

import hashlib
import itertools
import json
import sys
from fractions import Fraction
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
G3A_STATUS = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md"


def fail(msg: str) -> None:
    print(f"G3B_VERIFY_FAIL: {msg}", file=sys.stderr)
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


def load_alpha(payload, t_values=(1, 1, 1, 1)):
    alpha = [[[Fraction(0)] * 5 for _ in range(5)] for _ in range(5)]
    t3, t6, t8, t11 = t_values
    for item in payload["coefficients"]:
        triple = tuple(item["triple"])
        c = Fraction(0)
        for e in item["normalized_entries"]:
            if e["secondary"] != 0:
                continue
            e3, e6, e8, e11 = e["projective_exponents"]
            mon = (t3**e3) * (t6**e6) * (t8**e8) * (t11**e11)
            c += Fraction(e["numerator"], e["denominator"]) * mon
        perms = list(set(itertools.permutations(triple)))
        share = c / len(perms)
        for i, j, k in perms:
            alpha[i][j][k] = share
    return alpha


def phi(alpha, a):
    s = Fraction(0)
    for i, j, k in itertools.product(range(5), repeat=3):
        s += alpha[i][j][k] * a[i] * a[j] * a[k]
    return s


def polar_B(alpha, u, v, w):
    s = Fraction(0)
    for i, j, k in itertools.product(range(5), repeat=3):
        s += alpha[i][j][k] * u[i] * v[j] * w[k]
    return s


def eval_eq_terms(terms, values):
    total = Fraction(0)
    for term in terms:
        mon = Fraction(term["coefficient"][0], term["coefficient"][1])
        for exp, val in zip(term["exponents"], values):
            if exp:
                mon *= val**exp
        total += mon
    return total


def rebuild_chart(alpha, pivots):
    free_cols = [c for c in range(5) if c not in pivots]
    A_syms = sp.symbols(f"A0:{len(free_cols)}")
    B_syms = sp.symbols(f"B0:{len(free_cols)}")
    i, j = pivots
    A = [0] * 5
    B = [0] * 5
    A[i], A[j] = 1, 0
    B[i], B[j] = 0, 1
    for k, c in enumerate(free_cols):
        A[c] = A_syms[k]
        B[c] = B_syms[k]
    s, t = sp.symbols("s t")
    P = [s * A[r] + t * B[r] for r in range(5)]
    expr = 0
    for a, b, c in itertools.product(range(5), repeat=3):
        expr += (
            sp.Rational(alpha[a][b][c].numerator, alpha[a][b][c].denominator)
            * P[a]
            * P[b]
            * P[c]
        )
    poly = sp.Poly(sp.expand(expr), s, t)
    params = list(A_syms) + list(B_syms)
    eqs = []
    for mon in [(3, 0), (2, 1), (1, 2), (0, 3)]:
        coeff = sp.expand(poly.coeff_monomial(mon))
        p = sp.Poly(coeff, *params, domain=sp.QQ)
        terms = []
        for exps, raw in p.as_dict().items():
            if raw == 0:
                continue
            rat = sp.Rational(raw)
            terms.append(
                {
                    "exponents": list(exps),
                    "coefficient": [int(sp.fraction(rat)[0]), int(sp.fraction(rat)[1])],
                }
            )
        eqs.append(terms)
    return eqs, [str(p) for p in params]


def terms_equal(a, b) -> bool:
    def key(t):
        return tuple(t["exponents"])

    sa, sb = sorted(a, key=key), sorted(b, key=key)
    if len(sa) != len(sb):
        return False
    for x, y in zip(sa, sb):
        if list(x["exponents"]) != list(y["exponents"]):
            return False
        if list(x["coefficient"]) != list(y["coefficient"]):
            return False
    return True


def main() -> None:
    for name in (
        "INPUT_MANIFEST.json",
        "line_scheme.json",
        "line_search.json",
        "conic_search.json",
        "formal_line_recipe.json",
        "LINE_CONIC_SEARCH.md",
        "produce_g3b.py",
        "verify.py",
        "REPLAY.md",
        "SEAL.json",
        "STATUS.md",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("G3B-UNDECIDED\n") or status.startswith("G3-UNDECIDED\n")
            or status.startswith("G3B-LINE-CONIC-STRUCTURAL-PASS\n"),
            "STATUS exit")
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("exit") in (
        "G3B-UNDECIDED",
        "G3-UNDECIDED",
        "G3B-LINE-CONIC-STRUCTURAL-PASS",
    ), "SEAL exit")
    require(seal.get("headline") == "OPEN", "headline OPEN")
    require(seal.get("exit") != "G3-POINT-HEADLINE-POSITIVE", "no false positive")
    require(G3A_STATUS.read_text().startswith("G3A-ARITHMETIC-DOMINANCE-PASS\n"),
            "G3A not frozen pass")

    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    require(man.get("g3a_exit") == "G3A-ARITHMETIC-DOMINANCE-PASS", "manifest g3a")
    for item in man["inputs"]:
        if item["path"].endswith("generic_cubic.json"):
            require(sha256(GENERIC) == item["sha256"], "generic_cubic hash")
        if item["path"].endswith("G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md"):
            require(sha256(G3A_STATUS) == item["sha256"], "G3A status hash")

    payload = json.loads(GENERIC.read_text())
    alpha = load_alpha(payload)

    scheme = json.loads((HERE / "line_scheme.json").read_text())
    require(scheme["n_charts"] == 10, "10 Grassmann charts")
    require(scheme["equations_per_chart"] == 4, "4 eqs")
    # Rebuild every chart and match stored equations
    for chart in scheme["charts"]:
        piv = tuple(chart["pivots"])
        rebuilt, names = rebuild_chart(alpha, piv)
        require(names == chart["parameter_names"], f"param names {piv}")
        require(len(chart["equations"]) == 4, "4 stored eqs")
        for i, eq in enumerate(chart["equations"]):
            require(terms_equal(eq["terms"], rebuilt[i]), f"eq mismatch chart {piv} #{i}")

    # Coordinate spans: independent Phi restriction
    line_search = json.loads((HERE / "line_search.json").read_text())
    for item in line_search["coordinate_pair_lines"]:
        A, B = item["A"], item["B"]
        on = (
            phi(alpha, A) == 0
            and phi(alpha, B) == 0
            and polar_B(alpha, A, A, B) == 0
            and polar_B(alpha, A, B, B) == 0
        )
        require(on == item["on_cubic"], f"coord line mismatch {A}{B}")
        # At least some conditions nonzero for non-lines (most coordinate pairs)
        if not on:
            cond = {
                "Phi_A": phi(alpha, A),
                "Phi_B": phi(alpha, B),
                "B_AAB": polar_B(alpha, A, A, B),
                "B_ABB": polar_B(alpha, A, B, B),
            }
            require(any(v != 0 for v in cond.values()), "nonline has obstruction")

    require(
        line_search["sparse_support_search"]["lines_found_on_cubic"] == []
        or seal.get("exit") == "G3-POINT-HEADLINE-POSITIVE",
        "sparse lines found but no positive exit — inconsistent",
    )
    # modular labeled discovery-only
    for p, block in line_search["modular_discovery"].items():
        require("discovery" in block["scope"].lower(), f"mod {p} scope")

    # Conic ledger: re-factor a sample of planes
    conic = json.loads((HERE / "conic_search.json").read_text())
    require(conic["K_proj_conic_found"] is False, "no K_proj conic claimed")
    require(conic["planes_checked"] >= 10, "enough planes")
    # Rebuild factorization for first 3 planes
    for res in conic["results"][:3]:
        v0, v1, v2 = res["v0"], res["v1"], res["v2"]
        x0, x1, x2 = sp.symbols("x0 x1 x2")
        P = [x0 * v0[i] + x1 * v1[i] + x2 * v2[i] for i in range(5)]
        expr = 0
        for a, b, c in itertools.product(range(5), repeat=3):
            expr += (
                sp.Rational(alpha[a][b][c].numerator, alpha[a][b][c].denominator)
                * P[a]
                * P[b]
                * P[c]
            )
        fl = sp.factor_list(sp.expand(expr), [x0, x1, x2])
        degrees = [int(sp.total_degree(f)) for f, _ in fl[1]]
        require(degrees == res["factor_degrees"], f"factor degrees {res['label']}")
        require(
            (sorted(degrees) == [1, 2]) == res["splits_as_line_conic"],
            f"split flag {res['label']}",
        )

    # SEAL file hashes
    for name, expected in seal.get("files", {}).items():
        path = HERE / name
        require(path.is_file(), f"sealed missing {name}")
        require(sha256(path) == expected, f"seal hash mismatch {name}")

    # No headline positive without POINT.md coordinates
    require(not (HERE / "POINT.md").is_file() or seal.get("exit") == "G3-POINT-HEADLINE-POSITIVE",
            "POINT.md without positive exit")
    require("G3-POINT-HEADLINE-POSITIVE" not in status.splitlines()[0], "status not positive")

    print("G3B_LINE_SCHEME_OK")
    print("G3B_LINE_SEARCH_LEDGER_OK")
    print("G3B_CONIC_LEDGER_OK")
    print("G3B_VERIFY_OK")
    print(seal["exit"])
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
