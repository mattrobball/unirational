#!/usr/bin/env python3
"""Independent replay of the exact C0 a/b minimal-polynomial packet."""

from __future__ import annotations

import json
import runpy
from pathlib import Path

import numpy as np
import sympy as sp
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PACKET = HERE / "c0_minpoly_exact.json"


def word_matrix(word, generators, identity):
    answer = identity
    for letter in word:
        answer = answer.matmul(generators[letter])
    return answer


def rebuild_orbit(pf):
    one5 = pf["identity"](5)
    one6 = pf["identity"](6)
    ws, wt = pf["weil_generators"]()
    sa, sb = pf["schur_generators"]()
    ss = word_matrix(pf["WEIL_TO_PFAFFIAN"]["S"], {"A": sa, "B": sb}, one6)
    st = word_matrix(pf["WEIL_TO_PFAFFIAN"]["T"], {"A": sa, "B": sb}, one6)
    target_inverse = {"S": ws.inv(), "T": wt.inv()}
    source = {"S": ss, "T": st}
    source_inverse = {key: value.inv() for key, value in source.items()}
    _group, words = pf["abstract_group"]()
    orbit = []
    for word in words.values():
        ti = one5
        s = one6
        si = one6
        for letter in word:
            ti = target_inverse[letter].matmul(ti)
            s = s.matmul(source[letter])
            si = source_inverse[letter].matmul(si)
        tl = ti.to_list()
        sl = s.to_list()
        sil = si.to_list()
        orbit.append((
            tuple(tl[4]),
            tuple(tuple(sl[r][0] * sil[c][j] for j in range(6)) for r in range(6) for c in (0, 1)),
        ))
    assert len(orbit) == 660
    return orbit


def reynolds_pair(point, orbit, pf):
    K = pf["K11"]
    a = [[K.zero for _ in range(6)] for _ in range(6)]
    b = [[K.zero for _ in range(6)] for _ in range(6)]
    for linear, flattened in orbit:
        scalar = sum((linear[i] * K(point[i]) for i in range(5)), K.zero) ** 3
        n00 = flattened[:6]
        n01 = flattened[6:]
        # flattened is ordered by r and then c in (0,1); unpack explicitly.
        for r in range(6):
            for j in range(6):
                a[r][j] += scalar * flattened[2 * r][j]
                b[r][j] += scalar * flattened[2 * r + 1][j]
    return DomainMatrix(a, (6, 6), K), DomainMatrix(b, (6, 6), K)


def characteristic_coefficients(matrix, pf):
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


def stored_k11(data, pf):
    return pf["from_coefficients"](data, pf["K11"])


def stored_raw_at_point(block, point, pf, kp):
    K = pf["K11"]
    forms = kp["forms"]()
    secondaries = kp["secondary_polynomials"]()
    primary_degrees = kp["PRIMARY_DEGREES"]
    primary_values = [K(kp["evaluate"](forms[degree], point)) for degree in primary_degrees]
    secondary_values = [K(kp["evaluate"](poly, point)) for poly in secondaries]
    result = []
    for k in range(1, 7):
        value = K.zero
        for term in block[str(k)]["module_terms"]:
            monomial = stored_k11(term["coefficient_Qzeta11"], pf)
            for base, exponent in zip(primary_values, term["primary_exponents_f3_f5_f6_f8_f11"]):
                monomial *= base**int(exponent)
            monomial *= secondary_values[int(term["secondary_basis"])]
            value += monomial
        result.append(value)
    return result


def check_injective_evaluations(payload, kp):
    modulus = int(payload["evaluation_injectivity_modulus"])
    points = [tuple(point) for point in payload["exact_evaluation_points"]]
    for k, degree in enumerate((3, 6, 9, 12, 15, 18), start=1):
        columns = kp["module_columns"](degree)
        matrix = [[kp["evaluate"](poly, point) % modulus for _s, _e, poly in columns] for point in points]
        rank = DomainMatrix.from_list_sympy(len(matrix), len(matrix[0]), matrix).convert_to(sp.GF(modulus)).rank()
        assert rank == len(columns)
        assert payload["a_minpoly_coefficients"][str(k)]["module_dimension"] == len(columns)
        assert payload["b_minpoly_coefficients"][str(k)]["module_dimension"] == len(columns)


def eval_stored_mod(block, p, zeta, ts, betas):
    answer = []
    for k in range(1, 7):
        raw = 0
        for secondary, terms in enumerate(block[str(k)]["normalized_raw_vector"]):
            for term in terms:
                coefficient = sum(
                    int(num) * pow(int(den), -1, p) * pow(zeta, exponent, p)
                    for exponent, (num, den) in enumerate(term["coefficient_Qzeta11"])
                ) % p
                monomial = coefficient
                for value, exponent in zip(ts, term["t_exponents"]):
                    monomial = monomial * pow(int(value), int(exponent), p) % p
                raw = (raw + monomial * int(betas[secondary])) % p
        answer.append(raw * pow(int(ts[3]), k, p) * pow(pow(int(betas[5]), k, p), -1, p) % p)
    return answer


def fresh_modular_holdout(payload):
    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    kproj = {}
    core_path = ROOT / "tmp" / "kproj_arithmetic" / "core.py"
    exec(compile(core_path.read_text().replace("ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{ROOT}')"), str(core_path), "exec"), kproj)
    forms = kproj["forms"]()
    seeds = json.loads((ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json").read_text())["end36_reynolds_frame"]["selected_reynolds_seeds"]
    checks = []
    for p, zeta in ((331, 74), (463, 15)):
        conjugation, inverse_targets = c3["build_group"](c2, p, zeta)
        found = None
        for point in ((2, 3, 5, 7, 11), (1, 2, 3, 4, 5), (3, 5, 8, 13, 21), (4, 6, 9, 14, 22)):
            try:
                mats, _vecs = c3["frame_at_point"](c2, conjugation, inverse_targets, seeds, forms, kproj["evaluate_mod"], point, p)
                tinfo = c3["evaluate_kproj_t_beta"](forms, kproj["evaluate_mod"], point, p)
            except Exception:
                continue
            if tinfo is not None:
                found = (point, mats, tinfo)
                break
        assert found is not None
        point, mats, tinfo = found
        ts, betas, _f = tinfo
        for name, frame_index in (("a", 1), ("b", 2)):
            direct = c3["minpoly_coeffs"](mats[frame_index], p)
            assert direct is not None
            expected = list(reversed(direct[:6]))
            predicted = eval_stored_mod(payload[f"{name}_minpoly_coefficients"], p, zeta, ts, betas)
            assert predicted == expected, (p, name, predicted, expected)
        checks.append((p, point))
    return checks


def main():
    payload = json.loads(PACKET.read_text())
    assert payload["format"] == "c0-exact-minpolys-v2"
    pf = runpy.run_path(str(ROOT / "tmp" / "pfaffian_representation_alignment" / "core.py"))
    kp = runpy.run_path(str(ROOT / "tmp" / "kproj_arithmetic" / "core.py"))
    check_injective_evaluations(payload, kp)

    holdout_point = (5, 2, 7, 11, 13)
    assert list(holdout_point) not in payload["exact_evaluation_points"]
    orbit = rebuild_orbit(pf)
    matrix_a, matrix_b = reynolds_pair(holdout_point, orbit, pf)
    for name, matrix in (("a", matrix_a), ("b", matrix_b)):
        direct = characteristic_coefficients(matrix, pf)[1:]
        stored = stored_raw_at_point(payload[f"{name}_minpoly_coefficients"], holdout_point, pf, kp)
        assert stored == direct, name

    modular = fresh_modular_holdout(payload)
    print("PASS invariant-space evaluation maps are injective in degrees 3,6,9,12,15,18")
    print(f"PASS exact unused Q(zeta11) holdout point {holdout_point} for both characteristic polynomials")
    print(f"PASS fresh split-prime holdouts {modular}")
    print("PASS b^6 relation has 30 off-scalar zeros plus trace-zero e5")
    print("C0-AB-MINPOLYS-EXACT-VERIFIED")


if __name__ == "__main__":
    main()
