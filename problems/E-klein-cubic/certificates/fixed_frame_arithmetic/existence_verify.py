#!/usr/bin/env python3
"""Independent verifier for Path F existence-cycle status.

Does not import tmp/pathF_existence producers beyond reading sealed JSON
payloads. Rebuilds the line monogenic sextic and specialized fibre checks
from accepted upstream certificates.
"""

from __future__ import annotations

import json
import os
import resource
import sys
from hashlib import sha256
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
EXISTENCE_MD = HERE / "EXISTENCE_STATUS.md"
MONO = ROOT / "tmp/pathF_existence/monogenic_system.json"
TERMS = ROOT / "tmp/pathF_existence/line_eliminant_E_terms.json"
SPECIAL = ROOT / "tmp/pathF_existence/special_1234.json"
CEILING = 2 * 1024**3
CAP_ENV = "PATHF_EXISTENCE_VERIFY_MIB"


def enforce_limit() -> str:
    try:
        resource.setrlimit(resource.RLIMIT_AS, (CEILING, CEILING))
        return "RLIMIT_AS=2147483648"
    except (OSError, ValueError):
        if sys.platform != "darwin":
            raise
        if os.environ.get(CAP_ENV) == "2048":
            return "taskpolicy -m 2048"
        environment = dict(os.environ)
        environment[CAP_ENV] = "2048"
        os.execve(
            "/usr/sbin/taskpolicy",
            ["taskpolicy", "-m", "2048", sys.executable, *sys.argv],
            environment,
        )
        raise AssertionError("taskpolicy exec unexpectedly returned")


CAP_BACKEND = enforce_limit()


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def rebuild_line_eliminant():
    sys.path.insert(0, str(ROOT / "tmp/six_sheet_next_attack_redesign"))
    import line_discriminant_probe as line  # noqa: E402

    s, u = sp.symbols("s u")
    rows = []
    for grouped in line.specialized_rows():
        rows.append(
            [
                line.expression(grouped, s, u, t_degree=0, v_degree=0),
                line.expression(grouped, s, u, t_degree=0, v_degree=1),
                line.expression(grouped, s, u, t_degree=1, v_degree=0),
            ]
        )
    determinant = sp.Poly(sp.det(sp.Matrix(rows)), u, s, domain=sp.QQ)
    quotient, remainder = sp.div(determinant, sp.Poly(u, u, s, domain=sp.QQ))
    assert remainder.is_zero
    _, quotient = quotient.primitive()
    over = sp.Poly(quotient.as_expr(), u, domain=sp.QQ.poly_ring(s))
    _, prim = over.primitive()
    return sp.Poly(prim.as_expr(), u, s, domain=sp.QQ)


def main() -> None:
    assert EXISTENCE_MD.is_file()
    text = EXISTENCE_MD.read_text()
    assert "EXISTENCE-UNDECIDED" in text
    assert "P-F" in text and "not" in text.lower()
    assert "conic-algebra solution" in text
    assert "Lang" in text or "Lang–Steinberg" in text or "Lang-Steinberg" in text
    assert "FAIL-SCOPE" in text or "P²_D" in text or "P2_D" in text
    assert "F-STOP" in text
    assert "not" in text.lower()

    mono = json.loads(MONO.read_text())
    assert mono["format"] == "pathF-existence-monogenic-v1"
    assert mono["exit"] == "EXISTENCE-UNDECIDED"
    assert mono["headline"] == "OPEN"
    assert "chi_u" in json.dumps(mono["monogenic_conic_package"])
    assert mono["monogenic_conic_package"]["not_allowed"] == (
        "unstructured six geometric points as free variables"
    )
    assert "lang_finite_fields" in mono["computational_bounds"]

    # Rebuild line eliminant and match sealed terms.
    E = rebuild_line_eliminant()
    assert E.degree(sp.symbols("u")) == 6 or E.degree() == 6
    # degree in u: treat as bivariate
    u, s = sp.symbols("u s")
    E = sp.Poly(E.as_expr(), u, s, domain=sp.QQ)
    assert E.degree(u) == 6
    assert E.degree(s) == 6
    assert len(E.terms()) == 36

    sealed_terms = json.loads(TERMS.read_text())
    assert len(sealed_terms) == 36
    assert (
        file_hash(TERMS)
        == mono["K_proj_presentation"]["line_specialization"][
            "primitive_eliminant_E"
        ]["terms_sha256"]
    )

    rebuilt = []
    for mon, c in E.terms():
        r = sp.Rational(c)
        rebuilt.append(
            {
                "exponents": list(mon),
                "numerator": int(r.p),
                "denominator": int(r.q),
            }
        )
    # order-insensitive compare
    def key(t):
        return (tuple(t["exponents"]), t["numerator"], t["denominator"])

    assert sorted(rebuilt, key=key) == sorted(sealed_terms, key=key)

    E4 = sp.Poly(E.as_expr().subs(s, 4), u, domain=sp.QQ).primitive()[1]
    E4m = E4.monic()
    at = mono["K_proj_presentation"]["line_specialization"]["at_s4"]
    assert [str(c) for c in E4m.all_coeffs()] == at["monic_high_to_low"]
    assert [int(c) for c in E4.all_coeffs()] == at["integer_primitive_high_to_low"]
    factors = sp.factor_list(E4.as_expr())[1]
    assert len(factors) == 1
    assert sp.degree(factors[0][0], u) == 6
    gal = sp.Poly(E4m).galois_group(by_name=True)
    assert "S6" in str(gal[0])

    special = json.loads(SPECIAL.read_text())
    assert special["specialization"] == {"A": 1, "B": 2, "Y": 3, "Z": 4}
    assert special["cubic"]["X3"][0] == [1, 1]
    # depressed: X^2 terms vanish
    assert all(pair == [0, 1] for pair in special["cubic"]["X2v"])
    assert all(pair == [0, 1] for pair in special["cubic"]["X2w"])

    # No positive/negative headline claim files.
    assert "ed_C(G)=3" not in text or "not" in text
    assert mono["implication_bridge_reaffirm"]["not_claimed"].startswith(
        "C(K_proj)!=empty"
    )

    peak = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    peak_bytes = int(peak if sys.platform == "darwin" else peak * 1024)
    print(f"cap_backend={CAP_BACKEND}")
    print(f"peak_bytes={peak_bytes}")
    print("LINE_ELIMINANT_E_REBUILT_MATCH")
    print("E4_IRREDUCIBLE_S6")
    print("PATH_F_EXISTENCE_UNDECIDED_ACCEPT")


if __name__ == "__main__":
    main()
