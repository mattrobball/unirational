#!/usr/bin/env python3
"""Construct the exact minimal polynomial of the installed C3 generator ``a``.

This is a deliberately compressed C0 computation.  The installed generator is
the degree-three Reynolds covariant attached to ``x5^3 E_00``, homogenized by
``f11/f14``.  Its characteristic coefficients before homogenization are
homogeneous invariants of degrees 3,6,...,18.  The certified Hironaka basis of
the invariant ring has dimensions only 1,2,3,6,10,17 in those degrees, so the
coefficients can be reconstructed exactly from an injective evaluation map.

The output represents each coefficient as

    t11^k * raw_k / beta_f14^k,

where ``raw_k`` is a 12-vector over Q(zeta_11)(t3,t6,t8,t11) in the certified
``K_proj/P0`` basis.  No 36^3 multiplication table is reconstructed.
"""

from __future__ import annotations

import json
import runpy
import sys
import time
from pathlib import Path

import sympy as sp
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
ALIGN = ROOT / "tmp" / "pfaffian_representation_alignment"
KPROJ = ROOT / "tmp" / "kproj_arithmetic"
OUT = HERE / "c0_minpoly_exact.json"


def load_inputs():
    # core.py imports end36_frame only inside compute_certificate, so run_path is
    # safe and keeps the sealed packet read-only.
    pf = runpy.run_path(str(ALIGN / "core.py"))
    kp = runpy.run_path(str(KPROJ / "core.py"))
    return pf, kp


def matrix_word(word, generators, identity):
    result = identity
    for letter in word:
        result = result.matmul(generators[letter])
    return result


def exact_orbit_data(pf):
    """Precompute (fifth row of g^-1, gE00g^-1) for all 660 elements."""

    K = pf["K11"]
    one5 = pf["identity"](5)
    one6 = pf["identity"](6)
    weil_s, weil_t = pf["weil_generators"]()
    schur_a, schur_b = pf["schur_generators"]()

    source_s = matrix_word(pf["WEIL_TO_PFAFFIAN"]["S"], {"A": schur_a, "B": schur_b}, one6)
    source_t = matrix_word(pf["WEIL_TO_PFAFFIAN"]["T"], {"A": schur_a, "B": schur_b}, one6)
    target = {"S": weil_s, "T": weil_t}
    source = {"S": source_s, "T": source_t}
    target_inv = {key: value.inv() for key, value in target.items()}
    source_inv = {key: value.inv() for key, value in source.items()}

    _group, words = pf["abstract_group"]()
    records = []
    for word in words.values():
        tg_inv = one5
        sg = one6
        sg_inv = one6
        for letter in word:
            tg_inv = target_inv[letter].matmul(tg_inv)
            sg = sg.matmul(source[letter])
            sg_inv = source_inv[letter].matmul(sg_inv)
        tgi = tg_inv.to_list()
        sgl = sg.to_list()
        sgi = sg_inv.to_list()
        linear = tuple(tgi[4])
        # The installed a=e_1 uses E_00.  Keep E_01 as an exact alignment
        # cross-check for the installed b=e_2 without using it in this output.
        n00 = tuple(tuple(sgl[r][0] * sgi[0][c] for c in range(6)) for r in range(6))
        n01 = tuple(tuple(sgl[r][0] * sgi[1][c] for c in range(6)) for r in range(6))
        records.append((linear, n00, n01))

    assert len(records) == 660
    # Reynolds of the constant E00 is scalar, an inexpensive exact sanity gate.
    constant = [[K.zero for _ in range(6)] for _ in range(6)]
    for _linear, n00, _n01 in records:
        for r in range(6):
            for c in range(6):
                constant[r][c] += n00[r][c]
    scalar = constant[0][0]
    assert scalar != K.zero
    assert all(constant[r][c] == (scalar if r == c else K.zero) for r in range(6) for c in range(6))
    return records


def reynolds_at(point, orbit_data, pf, matrix_unit=0):
    K = pf["K11"]
    out = [[K.zero for _ in range(6)] for _ in range(6)]
    for linear, n00, n01 in orbit_data:
        value = sum((linear[i] * K(point[i]) for i in range(5)), K.zero) ** 3
        block = n00 if matrix_unit == 0 else n01
        for r in range(6):
            for c in range(6):
                out[r][c] += value * block[r][c]
    return DomainMatrix(out, (6, 6), K)


def characteristic_coefficients(matrix, pf):
    """Return [1,c1,...,c6] for det(TI-M) by Newton identities."""

    K = pf["K11"]
    power = pf["identity"](6)
    traces = []
    for _ in range(6):
        power = power.matmul(matrix)
        rows = power.to_list()
        traces.append(sum((rows[i][i] for i in range(6)), K.zero))
    coeffs = [K.one]
    for k in range(1, 7):
        total = K.zero
        for i in range(1, k + 1):
            total += coeffs[k - i] * traces[i - 1]
        coeffs.append(-total / K(k))
    return coeffs


def evaluation_points(kp):
    """Find one small set whose evaluation maps are injective in all six degrees."""

    degrees = (3, 6, 9, 12, 15, 18)
    columns = {degree: kp["module_columns"](degree) for degree in degrees}
    modulus = 1009
    candidates = []
    for a in range(1, 9):
        for b in range(1, 8):
            candidates.append((a, b, a + b, 2 * a + b, a + 2 * b))
    for t in range(1, 40):
        candidates.append((1, 2, 3, 4, t))
        candidates.append((t, 1, 2, 3, 4))

    rows = []
    for point in candidates:
        row18 = [kp["evaluate"](poly, point) % modulus for _s, _e, poly in columns[18]]
        if sp.polys.matrices.DomainMatrix.from_list_sympy(len(rows) + 1, len(row18), rows + [row18]).convert_to(sp.GF(modulus)).rank() > len(rows):
            rows.append(row18)
            if len(rows) == len(columns[18]):
                break
    assert len(rows) == 17

    # Recover the actual points corresponding to the selected greedy rows.
    selected = []
    rows = []
    for point in candidates:
        row18 = [kp["evaluate"](poly, point) % modulus for _s, _e, poly in columns[18]]
        rank_before = DomainMatrix.from_list_sympy(len(rows), 17, rows).convert_to(sp.GF(modulus)).rank() if rows else 0
        rank_after = DomainMatrix.from_list_sympy(len(rows) + 1, 17, rows + [row18]).convert_to(sp.GF(modulus)).rank()
        if rank_after > rank_before:
            selected.append(point)
            rows.append(row18)
            if len(selected) == 17:
                break

    # Full degree-18 rank generally forces the smaller degree maps too, but
    # assert it rather than assume it.
    for degree in degrees:
        mat = [[kp["evaluate"](poly, point) % modulus for _s, _e, poly in columns[degree]] for point in selected]
        rank = DomainMatrix.from_list_sympy(len(mat), len(mat[0]), mat).convert_to(sp.GF(modulus)).rank()
        assert rank == len(columns[degree]), (degree, rank, len(columns[degree]))
    return selected, columns, modulus


def independent_row_indices(integer_rows, ncols, modulus):
    chosen = []
    rank = 0
    for index, row in enumerate(integer_rows):
        trial = chosen + [index]
        matrix = [[integer_rows[i][j] % modulus for j in range(ncols)] for i in trial]
        new_rank = DomainMatrix.from_list_sympy(len(matrix), ncols, matrix).convert_to(sp.GF(modulus)).rank()
        if new_rank > rank:
            chosen.append(index)
            rank = new_rank
            if rank == ncols:
                break
    assert rank == ncols
    return chosen


def k11_data(value, pf):
    return pf["coefficients"](value, 10)


def reconstruct_module_coefficients(points, char_values, columns, modulus, pf, kp):
    K = pf["K11"]
    result = {}
    for k, degree in enumerate((3, 6, 9, 12, 15, 18), start=1):
        cols = columns[degree]
        integer_rows = [[kp["evaluate"](poly, point) for _s, _e, poly in cols] for point in points]
        indices = independent_row_indices(integer_rows, len(cols), modulus)
        rows = [[K(integer_rows[i][j]) for j in range(len(cols))] for i in indices]
        rhs = [[char_values[i][k]] for i in indices]
        matrix = DomainMatrix(rows, (len(cols), len(cols)), K)
        vector = matrix.inv().matmul(DomainMatrix(rhs, (len(cols), 1), K)).to_list()
        coeffs = [entry[0] for entry in vector]

        # Replay on every unused exact evaluation row.
        for i, point in enumerate(points):
            predicted = sum((coeffs[j] * K(integer_rows[i][j]) for j in range(len(cols))), K.zero)
            assert predicted == char_values[i][k], (k, point)

        terms = []
        raw_vector = [[] for _ in range(12)]
        for coefficient, (secondary, primary_exp, _poly) in zip(coeffs, cols):
            if coefficient == K.zero:
                continue
            t_exp = (primary_exp[0] + 2 * primary_exp[1], primary_exp[2], primary_exp[3], primary_exp[4])
            term = {
                "secondary_basis": secondary,
                "primary_exponents_f3_f5_f6_f8_f11": list(primary_exp),
                "normalized_t_exponents": list(t_exp),
                "coefficient_Qzeta11": k11_data(coefficient, pf),
            }
            terms.append(term)
            raw_vector[secondary].append({
                "t_exponents": list(t_exp),
                "coefficient_Qzeta11": k11_data(coefficient, pf),
            })
        result[str(k)] = {
            "degree_before_homogenization": degree,
            "module_dimension": len(cols),
            "injective_rows": indices,
            "module_terms": terms,
            "normalized_raw_vector": raw_vector,
            "coefficient_formula": f"t11^{k} * raw_{k} / beta_f14^{k}",
        }
    return result


def evaluate_stored_coefficients(coefficients, p, zeta, ts, betas):
    predicted = []
    for k in range(1, 7):
        raw = 0
        for secondary, terms in enumerate(coefficients[str(k)]["normalized_raw_vector"]):
            for term in terms:
                coeff = 0
                for exponent, (num, den) in enumerate(term["coefficient_Qzeta11"]):
                    coeff = (coeff + num * pow(den, -1, p) * pow(zeta, exponent, p)) % p
                monomial = 1
                for value, exponent in zip(ts, term["t_exponents"]):
                    monomial = monomial * pow(int(value), int(exponent), p) % p
                raw = (raw + coeff * monomial * int(betas[secondary])) % p
        value = raw * pow(int(ts[3]), k, p) % p
        value = value * pow(pow(int(betas[5]), k, p), -1, p) % p
        predicted.append(value)
    return predicted


def modular_check(payload):
    """Compare the exact formulas with direct installed modular matrices."""

    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    # Independent of the exact interpolation points.  Prime 199 is one of the
    # historical C3 modular checks, but this direct comparison is rebuilt here.
    checks = []
    # build_projective_reynolds_frame uses the sealed witness point internally.
    for p, zeta, point in ((89, 2, (1, 2, 3, 4, 5)), (199, 18, (1, 2, 3, 4, 5))):
        frame = c2["build_projective_reynolds_frame"](p, zeta)
        direct_a = c3["minpoly_coeffs"](frame["basis_mats"][1], p)
        direct_b = c3["minpoly_coeffs"](frame["basis_mats"][2], p)
        assert direct_a is not None and len(direct_a) == 7
        assert direct_b is not None and len(direct_b) == 7
        kpns = {}
        core_path = ROOT / "tmp" / "kproj_arithmetic" / "core.py"
        exec(compile(core_path.read_text().replace("ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{ROOT}')"), str(core_path), "exec"), kpns)
        forms = kpns["forms"]()
        tinfo = c3["evaluate_kproj_t_beta"](forms, kpns["evaluate_mod"], point, p)
        assert tinfo is not None
        ts, betas, _f = tinfo
        predicted_a = evaluate_stored_coefficients(payload["a_minpoly_coefficients"], p, zeta, ts, betas)
        predicted_b = evaluate_stored_coefficients(payload["b_minpoly_coefficients"], p, zeta, ts, betas)
        # minpoly_coeffs stores ascending powers [constant,...,T^5,1],
        # while the exact packet stores [c1,...,c6] in descending order.
        expected_a = list(reversed(direct_a[:6]))
        expected_b = list(reversed(direct_b[:6]))
        assert predicted_a == expected_a, (p, "a", predicted_a, expected_a)
        assert predicted_b == expected_b, (p, "b", predicted_b, expected_b)
        checks.append({
            "prime": p,
            "zeta11": zeta,
            "point": list(point),
            "direct_a_c1_to_c6": expected_a,
            "direct_b_c1_to_c6": expected_b,
        })
    return checks


def main():
    started = time.perf_counter()
    pf, kp = load_inputs()
    orbit_data = exact_orbit_data(pf)
    points, columns, modulus = evaluation_points(kp)
    char_values_a = []
    char_values_b = []
    for index, point in enumerate(points):
        matrix_a = reynolds_at(point, orbit_data, pf, matrix_unit=0)
        matrix_b = reynolds_at(point, orbit_data, pf, matrix_unit=1)
        char_values_a.append(characteristic_coefficients(matrix_a, pf))
        char_values_b.append(characteristic_coefficients(matrix_b, pf))
        print(f"exact Reynolds/charpoly a,b point {index + 1}/{len(points)} {point}", flush=True)

    coefficients_a = reconstruct_module_coefficients(points, char_values_a, columns, modulus, pf, kp)
    coefficients_b = reconstruct_module_coefficients(points, char_values_b, columns, modulus, pf, kp)
    payload = {
        "format": "c0-exact-minpolys-v2",
        "generators": {
            "a": {
                "name": "a=e_1",
                "reynolds_seed": "x5^3 E_00",
                "projective_homogenization": "a=(f11/f14) C_a",
            },
            "b": {
                "name": "b=e_2",
                "reynolds_seed": "x5^3 E_01",
                "projective_homogenization": "b=(f11/f14) C_b",
            },
        },
        "coefficient_field": "Q(zeta11)(t3,t6,t8,t11) tensor_P0 K_proj",
        "kproj_basis": ["1", "f7", "f9", "f10", "f12", "f14", "f7^2", "f7*f9", "f9^2", "f9*f10", "f7^3", "f9^2*f10"],
        "normalization": "beta_d=secondary_d/tau^d; t_d=f_d/tau^d; tau=f3^2/f5",
        "minimal_polynomial_template": "T^6 + c1*T^5 + c2*T^4 + c3*T^3 + c4*T^2 + c5*T + c6",
        "a_minpoly_coefficients": coefficients_a,
        "b_minpoly_coefficients": coefficients_b,
        "b6_relation": {
            "identity": "b^6 = e0 + b*e1 + b^2*e2 + b^3*e3 + b^4*e4 + b^5*e5",
            "E_coordinates": {
                "e0": "-b_c6 * 1_E",
                "e1": "-b_c5 * 1_E",
                "e2": "-b_c4 * 1_E",
                "e3": "-b_c3 * 1_E",
                "e4": "-b_c2 * 1_E",
                "e5": "-b_c1 * 1_E",
            },
            "structural_zero_count_in_6x6_E_coordinate_array": 30,
            "additional_trace_zero": "b_c1=0, hence e5=0 and the total zero count is 31",
        },
        "exact_evaluation_points": [list(point) for point in points],
        "evaluation_injectivity_modulus": modulus,
        "proof_boundary": {
            "proved": "all six exact coefficients of m_a and m_b, hence all six E-scalars in b^6, in the certified K_proj basis",
            "not_proved": "the L_a compressed block, involution, Morita corner, Hermitian five-plane, or common line",
        },
    }
    payload["modular_direct_checks"] = modular_check(payload)
    payload["elapsed_seconds"] = round(time.perf_counter() - started, 3)
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"WROTE {OUT}")
    print("C0-MINPOLY-EXACT")


if __name__ == "__main__":
    main()
