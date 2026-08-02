#!/usr/bin/env python3
"""Independent verifier for M3B G1 degree-4 section equation packet.

Rebuilds modular Klein frames and degree-4 cubics from exact_frame.json.
Re-checks sealed residual section witnesses. Does not import produce_g1.
"""

from __future__ import annotations

import hashlib
import json
import sys
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


def fail(msg: str) -> None:
    print(f"M3B_VERIFY_FAIL: {msg}", file=sys.stderr)
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


def split_root(prime: int) -> int:
    roots = [v for v in range(2, prime) if pow(v, 11, prime) == 1 and v != 1]
    require(bool(roots), f"no zeta11 mod {prime}")
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


def phi_expr(frame) -> tuple[sp.Expr, tuple]:
    a = sp.symbols("a0:5")
    linear = [sum(frame[r][c] * a[c] for c in range(5)) for r in range(5)]
    expr = sp.expand(sum(linear[r] ** 2 * linear[(r + 1) % 5] for r in range(5)))
    return expr, a


def expand_degree4(phi: sp.Expr, a_syms, prime: int) -> list[dict]:
    s, t = sp.symbols("s t")
    A = [sp.symbols(f"A{i}_0:5") for i in range(3)]
    r_coeffs = sp.symbols("r_0:4")
    forms = [
        sum(A[i][j] * s ** (4 - j) * t ** j for j in range(5)) for i in range(3)
    ]
    rform = sum(r_coeffs[j] * s ** (3 - j) * t ** j for j in range(4))
    identity = sp.expand(
        phi.subs(
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
    pst = sp.Poly(identity, s, t)
    cubics = []
    for k in range(13):
        coeff_expr = sp.expand(pst.coeff_monomial((12 - k, k)))
        cpoly = sp.Poly(coeff_expr, *params, domain=sp.ZZ)
        terms = []
        for exps, raw in cpoly.as_dict().items():
            coeff = int(raw) % prime
            if coeff:
                terms.append({"exponents": list(exps), "coefficient": coeff})
        cubics.append(terms)
    return cubics, [str(p) for p in params]


def eval_cubic(terms: list[dict], point: list[int], prime: int) -> int:
    total = 0
    for term in terms:
        prod = term["coefficient"] % prime
        for exp, val in zip(term["exponents"], point):
            if exp:
                prod = (prod * pow(int(val) % prime, int(exp), prime)) % prime
        total = (total + prod) % prime
    return total


def binary_gcd_degree(point: list[int], prime: int) -> int:
    s = sp.symbols("s")

    def to_uni(coeffs):
        deg = len(coeffs) - 1
        return sum((int(c) % prime) * s ** (deg - j) for j, c in enumerate(coeffs))

    A0, A1, A2, r = point[0:5], point[5:10], point[10:15], point[15:19]
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


def jacobian_rank(cubics_terms, var_names, point, prime: int) -> int:
    params = sp.symbols(" ".join(var_names))
    rows = []
    for terms in cubics_terms:
        expr = 0
        for term in terms:
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


def terms_equal(a: list[dict], b: list[dict]) -> bool:
    def key(t):
        return tuple(t["exponents"])

    sa = sorted(a, key=key)
    sb = sorted(b, key=key)
    if len(sa) != len(sb):
        return False
    for x, y in zip(sa, sb):
        if list(x["exponents"]) != list(y["exponents"]):
            return False
        if int(x["coefficient"]) != int(y["coefficient"]):
            return False
    return True


def main() -> None:
    for name in (
        "INPUT_MANIFEST.json",
        "G1_THEOREM.md",
        "g1_equations_p23.json",
        "g1_equations_p67.json",
        "produce_g1.py",
        "verify.py",
        "REPLAY.md",
        "SEAL.json",
        "STATUS.md",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("M3B-G1-MODULAR-NONEMPTY-PASS\n"), "STATUS exit")
    require("OPEN" in status and "SECTION" in status.upper() or "section" in status,
            "status must discuss section residual")
    require("K_Schur" in status or "K_{\\mathrm{Schur}}" in status or "over K" in status
            or "characteristic-zero" in status or "char-0" in status.lower()
            or "not a K" in status.lower() or "still open" in status.lower()
            or "section question" in status.lower(),
            "status must fence K-section")
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("exit") == "M3B-G1-MODULAR-NONEMPTY-PASS", "SEAL exit")
    require(seal.get("headline") == "OPEN", "SEAL headline")
    require(seal.get("section_question") == "UNDECIDED", "section still undecided")
    require(
        seal.get("parent_exit") == "M3-INTEGRAL-DEGREE4-MULTISECTION",
        "parent multisection exit",
    )

    # Parent STATUS unchanged terminal
    parent_status = (PARENT / "STATUS.md").read_text().splitlines()[0].strip()
    require(parent_status == "M3-INTEGRAL-DEGREE4-MULTISECTION", "parent exit drift")

    cert = json.loads(FRAME.read_text())
    for prime in PRIMES:
        path = HERE / f"g1_equations_p{prime}.json"
        stored = json.loads(path.read_text())
        require(stored["prime"] == prime, f"prime field {prime}")
        require(stored["n_equations"] == 13, "need 13 cubics")
        require(stored["n_variables"] == 19, "need 19 vars")
        require(len(stored["equations"]) == 13, "equations length")

        zeta, frame = frame_mod_prime(cert, prime)
        require(stored.get("zeta11") == zeta, f"zeta drift p={prime}")
        phi, a_syms = phi_expr(frame)
        rebuilt_terms, var_names = expand_degree4(phi, a_syms, prime)
        require(var_names == stored["variable_names"], "variable names drift")

        for i, cubic in enumerate(stored["equations"]):
            require(
                terms_equal(cubic["terms"], rebuilt_terms[i]),
                f"cubic {i} mismatch at p={prime}",
            )

        residual = json.loads(
            (PARENT / f"modular_residual_section_p{prime}.json").read_text()
        )
        point = [int(x) for x in residual["residual_parameters"]]
        require(len(point) == 19, "witness length")
        for i, cubic in enumerate(stored["equations"]):
            z = eval_cubic(cubic["terms"], point, prime)
            require(z == 0, f"witness fails eq {i} at p={prime}")
        gcd_deg = binary_gcd_degree(point, prime)
        require(gcd_deg == 0, f"witness gcd degree {gcd_deg} at p={prime}")
        rank = jacobian_rank(
            [c["terms"] for c in stored["equations"]],
            stored["variable_names"],
            point,
            prime,
        )
        require(rank == 13, f"jacobian rank {rank} at p={prime}")

        # stored witness check fields must match independent values
        w = stored.get("sealed_residual_witness_check") or {}
        require(w.get("equations_all_zero") is True, "stored witness flag")
        require(w.get("gcd_degree") == 0, "stored gcd")
        require(w.get("jacobian_rank") == 13, "stored rank")

    # SEAL file hashes
    for name, expected in seal.get("files", {}).items():
        path = HERE / name
        require(path.is_file(), f"sealed missing {name}")
        require(sha256(path) == expected, f"seal hash mismatch {name}")

    # No headline-positive claim (allow explicit non-claim mentions)
    require(
        "M3-SECTION-HEADLINE-POSITIVE" not in status.split("non-claim")[0]
        if "non-claim" in status.lower()
        else "exit" in seal and seal.get("exit") != "M3-SECTION-HEADLINE-POSITIVE",
        "false section positive exit",
    )
    require(seal.get("exit") != "M3-SECTION-HEADLINE-POSITIVE", "false section positive")
    require(
        not any(
            line.strip().startswith("BRIDGE_SARKISOV_POS")
            for line in status.splitlines()
        ),
        "false bridge claim line",
    )

    print("M3B_G1_VERIFY_OK")
    print("M3B-G1-MODULAR-NONEMPTY-PASS")
    print("SECTION_QUESTION_STILL_UNDECIDED")
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
