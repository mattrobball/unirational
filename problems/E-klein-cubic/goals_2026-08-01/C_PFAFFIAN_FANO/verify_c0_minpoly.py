#!/usr/bin/env python3
"""Independent verifier for ``c0_minpoly_exact.json``.

The verifier does not import the producer.  It rebuilds the exact Reynolds
matrix at a new characteristic-zero point, checks all six invariant-module
formulas there, proves the stored evaluation maps injective, and compares the
normalized coefficients with fresh direct modular matrices at two primes.
"""

from __future__ import annotations

import json
import runpy
from pathlib import Path

import sympy as sp
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
DATA = HERE / "c0_minpoly_exact.json"


def word_matrix(word, generators, identity):
    answer = identity
    for letter in word:
        answer = answer.matmul(generators[letter])
    return answer


def exact_reynolds_a(point, pf):
    K = pf["K11"]
    one5 = pf["identity"](5)
    one6 = pf["identity"](6)
    ws, wt = pf["weil_generators"]()
    sa, sb = pf["schur_generators"]()
    source_s = word_matrix(pf["WEIL_TO_PFAFFIAN"]["S"], {"A": sa, "B": sb}, one6)
    source_t = word_matrix(pf["WEIL_TO_PFAFFIAN"]["T"], {"A": sa, "B": sb}, one6)
    targets = {"S": ws, "T": wt}
    sources = {"S": source_s, "T": source_t}
    target_inverses = {name: matrix.inv() for name, matrix in targets.items()}
    source_inverses = {name: matrix.inv() for name, matrix in sources.items()}

    out = [[K.zero for _ in range(6)] for _ in range(6)]
    _group, words = pf["abstract_group"]()
    for word in words.values():
        target_inverse = one5
        source = one6
        source_inverse = one6
        for letter in word:
            target_inverse = target_inverses[letter].matmul(target_inverse)
            source = source.matmul(sources[letter])
            source_inverse = source_inverses[letter].matmul(source_inverse)
        trows = target_inverse.to_list()
        srows = source.to_list()
        sirows = source_inverse.to_list()
        value = sum((trows[4][i] * K(point[i]) for i in range(5)), K.zero) ** 3
        for r in range(6):
            for c in range(6):
                out[r][c] += value * srows[r][0] * sirows[0][c]
    return DomainMatrix(out, (6, 6), K)


def char_coefficients(matrix, pf):
    K = pf["K11"]
    power = pf["identity"](6)
    traces = []
    for _ in range(6):
        power = power.matmul(matrix)
        rows = power.to_list()
        traces.append(sum((rows[i][i] for i in range(6)), K.zero))
    coeffs = [K.one]
    for k in range(1, 7):
        coeffs.append(-sum((coeffs[k - i] * traces[i - 1] for i in range(1, k + 1)), K.zero) / K(k))
    return coeffs


def coefficient_value(data, pf):
    return pf["from_coefficients"](data, pf["K11"])


def exact_formula_value(entry, point, pf, kp):
    K = pf["K11"]
    forms = kp["forms"]()
    secondaries = kp["secondary_polynomials"]()
    values = {degree: kp["evaluate"](poly, point) for degree, poly in forms.items()}
    total = K.zero
    for term in entry["module_terms"]:
        coefficient = coefficient_value(term["coefficient_Qzeta11"], pf)
        primary = 1
        for exponent, degree in zip(term["primary_exponents_f3_f5_f6_f8_f11"], kp["PRIMARY_DEGREES"]):
            primary *= values[degree] ** exponent
        secondary = kp["evaluate"](secondaries[term["secondary_basis"]], point)
        total += coefficient * K(primary * secondary)
    return total


def verify_injective_maps(payload, kp):
    modulus = payload["evaluation_injectivity_modulus"]
    points = [tuple(point) for point in payload["exact_evaluation_points"]]
    for k, degree in enumerate((3, 6, 9, 12, 15, 18), start=1):
        columns = kp["module_columns"](degree)
        rows = [[kp["evaluate"](poly, point) % modulus for _s, _e, poly in columns] for point in points]
        matrix = DomainMatrix.from_list_sympy(len(rows), len(columns), rows).convert_to(sp.GF(modulus))
        assert matrix.rank() == len(columns)
        assert payload["coefficients"][str(k)]["module_dimension"] == len(columns)


def load_modular_kproj():
    namespace = {}
    core = ROOT / "tmp" / "kproj_arithmetic" / "core.py"
    exec(compile(core.read_text().replace("ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{ROOT}')"), str(core), "exec"), namespace)
    return namespace


def evaluate_normalized_entry(entry, ts, betas, p, zeta):
    raw = 0
    for secondary, terms in enumerate(entry["normalized_raw_vector"]):
        for term in terms:
            coefficient = 0
            for exponent, (numerator, denominator) in enumerate(term["coefficient_Qzeta11"]):
                coefficient = (coefficient + numerator * pow(denominator, -1, p) * pow(zeta, exponent, p)) % p
            monomial = 1
            for value, exponent in zip(ts, term["t_exponents"]):
                monomial = monomial * pow(int(value), int(exponent), p) % p
            raw = (raw + coefficient * monomial * int(betas[secondary])) % p
    return raw


def fresh_modular_checks(payload):
    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    kpm = load_modular_kproj()
    forms = kpm["forms"]()
    seeds = json.loads((ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json").read_text())["end36_reynolds_frame"]["selected_reynolds_seeds"]
    candidates = ((2, 3, 5, 7, 11), (3, 4, 6, 8, 13), (1, 3, 4, 9, 15), (2, 5, 8, 12, 17))
    checks = []
    for p, zeta in ((331, 74), (463, 15)):
        conjugation, inverses = c3["build_group"](c2, p, zeta)
        accepted = None
        for point in candidates:
            try:
                frame, _vectors = c3["frame_at_point"](c2, conjugation, inverses, seeds, forms, kpm["evaluate_mod"], point, p)
            except ValueError:
                continue
            direct = c3["minpoly_coeffs"](frame[1], p)
            tinfo = c3["evaluate_kproj_t_beta"](forms, kpm["evaluate_mod"], point, p)
            if direct is not None and len(direct) == 7 and tinfo is not None:
                accepted = (point, direct, tinfo)
                break
        assert accepted is not None, p
        point, direct, (ts, betas, _f) = accepted
        predicted = []
        for k in range(1, 7):
            raw = evaluate_normalized_entry(payload["coefficients"][str(k)], ts, betas, p, zeta)
            value = raw * pow(int(ts[3]), k, p) % p
            value = value * pow(pow(int(betas[5]), k, p), -1, p) % p
            predicted.append(value)
        expected = list(reversed(direct[:6]))
        assert predicted == expected, (p, predicted, expected)
        checks.append((p, point))
    return checks


def main():
    payload = json.loads(DATA.read_text())
    assert payload["format"] == "c0-exact-minpoly-v1"
    assert set(payload["coefficients"]) == {str(k) for k in range(1, 7)}
    pf = runpy.run_path(str(ROOT / "tmp" / "pfaffian_representation_alignment" / "core.py"))
    kp = runpy.run_path(str(ROOT / "tmp" / "kproj_arithmetic" / "core.py"))

    verify_injective_maps(payload, kp)
    point = (5, 2, 7, 3, 11)  # deliberately absent from producer rows
    assert list(point) not in payload["exact_evaluation_points"]
    direct = char_coefficients(exact_reynolds_a(point, pf), pf)
    for k in range(1, 7):
        assert exact_formula_value(payload["coefficients"][str(k)], point, pf, kp) == direct[k]

    checks = fresh_modular_checks(payload)
    print("PASS six invariant-module evaluation maps are injective")
    print(f"PASS exact Q(zeta11) Reynolds characteristic polynomial at unused point {point}")
    print(f"PASS normalized K_proj formulas against fresh modular direct matrices {checks}")
    print("SCOPE exact m_a only; b^6/L_a, involution, Morita, Hermitian, and common line remain open")
    print("C0-MINPOLY-EXACT-VERIFIED")


if __name__ == "__main__":
    main()
