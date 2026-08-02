#!/usr/bin/env python3
"""M3B producer: expand H-degree-4 section cubics at good primes 23 and 67."""
from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PARENT = ROOT / "goals_after_bd610a" / "M3_SARKISOV_SECTION"
FRAME = (
    ROOT
    / "goals_2026-08-01"
    / "Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D"
    / "exact_frame.json"
)
PRIMES = (23, 67)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def split_root(prime: int) -> int:
    roots = [v for v in range(2, prime) if pow(v, 11, prime) == 1 and v != 1]
    if not roots:
        raise ValueError(f"no zeta11 mod {prime}")
    return min(roots)


def reduce_k11(data, prime: int, zeta: int) -> int:
    value = 0
    for exponent, (numerator, denominator) in enumerate(data):
        value += numerator * pow(denominator, -1, prime) * pow(zeta, exponent, prime)
    return value % prime


def frame_mod_prime(certificate: dict, prime: int):
    zeta = split_root(prime)
    frame = [
        [reduce_k11(entry, prime, zeta) for entry in row]
        for row in certificate["frame_at_witness"]
    ]
    return zeta, frame


def transformed_klein(frame, prime: int) -> sp.Expr:
    a = sp.symbols("a0:5")
    linear = [sum(frame[r][c] * a[c] for c in range(5)) for r in range(5)]
    expr = sum(linear[r] ** 2 * linear[(r + 1) % 5] for r in range(5))
    return sp.expand(expr), a


def expand_degree4(phi_expr: sp.Expr, a_syms, prime: int) -> dict:
    s, t = sp.symbols("s t")
    A = [sp.symbols(f"A{i}_0:5") for i in range(3)]
    r_coeffs = sp.symbols("r_0:4")
    forms = [
        sum(A[i][j] * s ** (4 - j) * t ** j for j in range(5)) for i in range(3)
    ]
    rform = sum(r_coeffs[j] * s ** (3 - j) * t ** j for j in range(4))
    identity = sp.expand(
        phi_expr.subs(
            {
                a_syms[0]: forms[0],
                a_syms[1]: forms[1],
                a_syms[2]: forms[2],
                a_syms[3]: s * rform,
                a_syms[4]: t * rform,
            }
        )
    )
    params = list(A[0]) + list(A[1]) + list(A[2]) + list(r_coeffs)
    assert len(params) == 19
    # Poly in s,t with symbolic coefficients in A,r
    pst = sp.Poly(identity, s, t)
    cubics = []
    for k in range(13):
        monom = (12 - k, k)
        coeff_expr = pst.coeff_monomial(monom)
        coeff_expr = sp.expand(coeff_expr)
        # Reduce integer coefficients mod prime inside the multivariate poly
        cpoly = sp.Poly(coeff_expr, *params, domain=sp.ZZ)
        terms = []
        for exps, raw in cpoly.as_dict().items():
            coeff = int(raw) % prime
            if coeff == 0:
                continue
            terms.append({"exponents": list(exps), "coefficient": coeff})
        cubics.append(
            {
                "monomial_s_t": [12 - k, k],
                "term_count": len(terms),
                "terms": terms,
            }
        )
    return {
        "prime": prime,
        "variable_names": [str(p) for p in params],
        "n_variables": 19,
        "n_equations": 13,
        "equations": cubics,
        "schema": "m3b-g1-degree4-section-cubics-v1",
    }


def eval_cubic(cubic: dict, point: list[int], prime: int) -> int:
    total = 0
    for term in cubic["terms"]:
        prod = term["coefficient"] % prime
        for exp, val in zip(term["exponents"], point):
            if exp:
                prod = (prod * pow(int(val) % prime, int(exp), prime)) % prime
        total = (total + prod) % prime
    return total


def binary_gcd_degree(point: list[int], prime: int) -> int:
    s = sp.symbols("s")
    A0, A1, A2, r = point[0:5], point[5:10], point[10:15], point[15:19]

    def to_uni(coeffs):
        deg = len(coeffs) - 1
        return sum((int(c) % prime) * s ** (deg - j) for j, c in enumerate(coeffs))

    polys = [sp.Poly(to_uni(c), s, modulus=prime) for c in (A0, A1, A2, r)]
    g = polys[0]
    for p in polys[1:]:
        g = sp.gcd(g, p)
    return int(g.degree())


def mat_rank(mat, p: int) -> int:
    a = [[int(x) % p for x in row] for row in mat]
    n, m = len(a), len(a[0])
    r = 0
    col = 0
    while r < n and col < m:
        piv = None
        for i in range(r, n):
            if a[i][col] % p != 0:
                piv = i
                break
        if piv is None:
            col += 1
            continue
        a[r], a[piv] = a[piv], a[r]
        inv = pow(a[r][col], -1, p)
        a[r] = [(v * inv) % p for v in a[r]]
        for i in range(n):
            if i == r:
                continue
            fac = a[i][col] % p
            if fac:
                a[i] = [(a[i][j] - fac * a[r][j]) % p for j in range(m)]
        r += 1
        col += 1
    return r


def jacobian_rank(eqs: dict, point: list[int], prime: int) -> int:
    params = sp.symbols(" ".join(eqs["variable_names"]))
    rows = []
    for cubic in eqs["equations"]:
        expr = 0
        for term in cubic["terms"]:
            mon = term["coefficient"]
            for exp, var in zip(term["exponents"], params):
                if exp:
                    mon = mon * var ** exp
            expr = expr + mon
        row = []
        for var in params:
            d = sp.diff(expr, var)
            val = int(sp.expand(d).subs({params[i]: point[i] for i in range(19)})) % prime
            row.append(val)
        rows.append(row)
    return mat_rank(rows, prime)


def check_witness(eqs: dict, residual: dict, prime: int) -> dict:
    point = [int(x) for x in residual["residual_parameters"]]
    assert len(point) == 19
    zeros = [eval_cubic(c, point, prime) for c in eqs["equations"]]
    return {
        "equations_all_zero": all(z == 0 for z in zeros),
        "gcd_degree": binary_gcd_degree(point, prime),
        "jacobian_rank": jacobian_rank(eqs, point, prime),
        "point": point,
    }


def main() -> None:
    cert = json.loads(FRAME.read_text())
    commit = subprocess.check_output(["git", "rev-parse", "HEAD"], text=True).strip()
    HERE.mkdir(parents=True, exist_ok=True)

    inputs = [
        FRAME,
        PARENT / "modular_residual_section_p23.json",
        PARENT / "modular_residual_section_p67.json",
        PARENT / "SECTION_RESIDUAL.md",
        PARENT / "residual_gate.json",
        PARENT / "SECTION_CLASSES.json",
        PARENT / "STATUS.md",
        PARENT / "SEAL.json",
    ]
    manifest = {
        "goal": "M3B_SECTION_RESIDUAL_G1",
        "consumed_commit": commit,
        "parent_exit": "M3-INTEGRAL-DEGREE4-MULTISECTION",
        "section_question": "UNDECIDED",
        "headline": "OPEN",
        "inputs": [
            {
                "path": str(p.relative_to(ROOT)),
                "sha256": sha256(p),
                "exists": p.is_file(),
            }
            for p in inputs
        ],
    }
    (HERE / "INPUT_MANIFEST.json").write_text(json.dumps(manifest, indent=2) + "\n")

    report: dict = {"primes": {}, "schema": "m3b-g1-produce-report-v1"}
    for prime in PRIMES:
        zeta, frame = frame_mod_prime(cert, prime)
        phi_expr, a_syms = transformed_klein(frame, prime)
        eqs = expand_degree4(phi_expr, a_syms, prime)
        eqs["zeta11"] = zeta
        eqs["frame_source"] = str(FRAME.relative_to(ROOT))
        residual = json.loads(
            (PARENT / f"modular_residual_section_p{prime}.json").read_text()
        )
        check = check_witness(eqs, residual, prime)
        assert check["equations_all_zero"], f"witness fails equations at p={prime}"
        assert check["gcd_degree"] == 0, f"witness not gcd-free at p={prime}"
        assert check["jacobian_rank"] == 13, f"jacobian rank {check['jacobian_rank']}"
        eqs["sealed_residual_witness_check"] = {
            "equations_all_zero": check["equations_all_zero"],
            "gcd_degree": check["gcd_degree"],
            "jacobian_rank": check["jacobian_rank"],
            "source": f"modular_residual_section_p{prime}.json",
        }
        path = HERE / f"g1_equations_p{prime}.json"
        path.write_text(json.dumps(eqs, indent=2) + "\n")
        report["primes"][str(prime)] = {
            "zeta11": zeta,
            "term_counts": [c["term_count"] for c in eqs["equations"]],
            "witness": {
                "equations_all_zero": check["equations_all_zero"],
                "gcd_degree": check["gcd_degree"],
                "jacobian_rank": check["jacobian_rank"],
            },
            "path": path.name,
        }
        print(f"p={prime} terms={report['primes'][str(prime)]['term_counts']} ok")

    (HERE / "produce_report.json").write_text(json.dumps(report, indent=2) + "\n")
    print("M3B_G1_PRODUCE_OK")


if __name__ == "__main__":
    main()
