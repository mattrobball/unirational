#!/usr/bin/env python3
"""Exact fixed-frame ternary-cubic discriminant for Goal T3 discovery.

This reads only accepted/sealed inputs.  It reconstructs the fixed-frame
depressed cubic over Q(zeta_11), substitutes its seven coefficients in the
audited universal c4/c6 tables, and writes only t3_disc_* discovery outputs
beside this script.
"""

from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import signal
from fractions import Fraction
from pathlib import Path

from sympy.polys.domains import GF, QQ
from sympy.polys.rings import ring


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FORMS_PATH = ROOT / "certificates/fixed_frame_arithmetic/five_forms.json"
FORMS_SEAL = ROOT / "certificates/fixed_frame_arithmetic/SEAL.json"
UNIVERSAL_PATH = ROOT / "tmp/pfaffian_minimal_ternary_model/certificate.json"
BRANCH_PATH = ROOT / "tmp/full_scaled_frame_branch_line_hostile_audit/certificate.json"
GLOBAL_H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
RUR_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/qq_rur_hprime_certificate.json"
SAMPLES_PATH = ROOT / "tmp/wp_t1_mod3/discovery_p67.json"
PAYLOAD_GZ = HERE / "t3_disc_delta_cub_qzeta11.json.gz"
SUMMARY_PATH = HERE / "t3_disc_summary.json"
SINGULAR_FACTOR_RESULT = HERE / "t3_disc_factor_singular_result.json"

K = QQ.cyclotomic_field(11)
ZETA = K.unit
PR, A, B, Y, Z = ring("A,B,Y,Z", K)


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_hash(value) -> str:
    encoded = json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


def deserialize_k11(data):
    value = K.zero
    power = K.one
    for numerator, denominator in data:
        value += K(numerator) / K(denominator) * power
        power *= ZETA
    return value


def serialize_k11(value):
    raw = list(reversed(value.to_list()))
    raw += [QQ.zero] * (10 - len(raw))
    assert len(raw) == 10
    return [[int(item.numerator), int(item.denominator)] for item in raw]


def poly_stats(poly):
    terms = poly.terms()
    return {
        "terms": len(terms),
        "total_degree": max((sum(monomial) for monomial, _ in terms), default=-1),
        "variables": [str(generator) for generator in poly.ring.gens],
        "degrees": [
            max((monomial[index] for monomial, _ in terms), default=-1)
            for index in range(poly.ring.ngens)
        ],
    }


def serialized_poly(poly):
    return [
        {"exponents": list(monomial), "coefficient_qzeta11": serialize_k11(coefficient)}
        for monomial, coefficient in poly.terms()
    ]


def eval_universal(terms, coefficients):
    answer = PR.zero
    for term in terms:
        value = PR(term["coefficient"])
        for coefficient, exponent in zip(coefficients, term["exponents"]):
            if exponent:
                value *= coefficient**exponent
        answer += value
    return answer


def build_fixed_coefficients(forms_payload):
    slots = forms_payload["binary_slots"]
    slot = {name: [deserialize_k11(value) for value in values] for name, values in slots.items()}
    q = [PR(slot["q0"][i]) + A * PR(slot["qA"][i]) + Y * PR(slot["qY"][i]) for i in range(3)]
    kappa = K(-11) / K(18)
    r = [
        PR(slot["r0"][i])
        + A * PR(slot["rA"][i])
        + B * PR(slot["rB"][i])
        + Y * PR(slot["rY"][i])
        + (Z + PR(kappa) * A**2) * PR(slot["rZ"][i])
        for i in range(4)
    ]

    # Bind the compact binary-slot representation to the ten coefficient vectors.
    expected = {
        "F0": [K.one, K.zero, K.zero, *slot["q0"], *slot["r0"]],
        "FA": [K.zero, K.zero, K.zero, *slot["qA"], *slot["rA"]],
        "FB": [K.zero, K.zero, K.zero, K.zero, K.zero, K.zero, *slot["rB"]],
        "FY": [K.zero, K.zero, K.zero, *slot["qY"], *slot["rY"]],
        "FZ": [K.zero, K.zero, K.zero, K.zero, K.zero, K.zero, *slot["rZ"]],
    }
    for name, vector in expected.items():
        assert vector == [deserialize_k11(value) for value in forms_payload["forms"][name]]
    return q + r


def unary_from_records(records, variable_name="s"):
    SR, s = ring(variable_name, K)
    answer = SR.zero
    for record in records:
        assert len(record["exponents"]) == 1
        coefficient = K(record["numerator"]) / K(record["denominator"])
        answer += SR(coefficient) * s ** record["exponents"][0]
    return SR, s, answer


def specialize_to_line(poly):
    SR, s = ring("s", K)
    answer = SR.zero
    for (a, b, y, z), coefficient in poly.terms():
        answer += SR(coefficient * K(2) ** b * K(3) ** y) * s**z
    return SR, s, answer


def poly_low_to_high(values, SR, t):
    answer = SR.zero
    for exponent, raw in enumerate(values):
        value = Fraction(raw)
        answer += SR(K(value.numerator) / K(value.denominator)) * t**exponent
    return answer


def rur_pullback(poly, rur_payload):
    SR, t = ring("t", K)
    h = poly_low_to_high(rur_payload["H_low_to_high"], SR, t)
    hp = poly_low_to_high(rur_payload["Hprime_low_to_high"], SR, t)
    ny = poly_low_to_high(rur_payload["NY_low_to_high"], SR, t)
    nz = poly_low_to_high(rur_payload["NZ_low_to_high"], SR, t)
    inverse, _, gcd = hp.gcdex(h)
    assert gcd.degree() == 0
    inverse = (inverse / gcd.LC) % h
    y_value = ny * inverse % h
    z_value = nz * inverse % h
    value = SR.zero
    for (a, b, y, z), coefficient in poly.terms():
        assert a == 0 or K(0) ** a == K.zero
        if a:
            continue
        term = SR(coefficient * K(2) ** b)
        term = term * (y_value**y % h) % h
        term = term * (z_value**z % h) % h
        value = (value + term) % h
    common = value.gcd(h)
    return {
        "H_degree": h.degree(),
        "delta_remainder_degree": value.degree() if value else -1,
        "delta_remainder_zero": not bool(value),
        "gcd_degree": common.degree(),
        "gcd_is_unit": common.degree() == 0,
        "delta_remainder_sha256": canonical_hash(serialized_unary(value)),
    }


def serialized_unary(poly):
    return [
        {"exponent": monomial[0], "coefficient_qzeta11": serialize_k11(coefficient)}
        for monomial, coefficient in poly.terms()
    ]


def reduce_coefficient(coefficient, prime, zeta_value):
    answer = 0
    for exponent, (numerator, denominator) in enumerate(serialize_k11(coefficient)):
        assert denominator % prime
        answer += numerator * pow(denominator, -1, prime) * pow(zeta_value, exponent, prime)
    return answer % prime


def reduce_poly(poly, prime=67, zeta_value=9):
    FP = GF(prime)
    MR, a, b, y, z = ring("A,B,Y,Z", FP)
    answer = MR.zero
    for monomial, coefficient in poly.terms():
        reduced = reduce_coefficient(coefficient, prime, zeta_value)
        if reduced:
            answer += MR(reduced) * a ** monomial[0] * b ** monomial[1] * y ** monomial[2] * z ** monomial[3]
    return MR, answer


def evaluate_mod(poly, point, prime):
    answer = 0
    for monomial, coefficient in poly.terms():
        term = int(coefficient) % prime
        for value, exponent in zip(point, monomial):
            term = term * pow(value, exponent, prime) % prime
        answer = (answer + term) % prime
    return answer


class FactorTimeout(Exception):
    pass


def factor_with_timeout(poly, seconds):
    def handler(_signum, _frame):
        raise FactorTimeout

    prior = signal.signal(signal.SIGALRM, handler)
    signal.alarm(seconds)
    try:
        unit, factors = poly.factor_list()
        return {
            "status": "PASS",
            "unit_qzeta11": serialize_k11(unit),
            "factors": [
                {
                    "exponent": exponent,
                    **poly_stats(factor),
                    "terms_sha256": canonical_hash(serialized_poly(factor)),
                }
                for factor, exponent in factors
            ],
        }
    except FactorTimeout:
        return {"status": "TIMEOUT", "seconds": seconds}
    except Exception as error:  # factorization support is best-effort discovery
        return {"status": "ERROR", "type": type(error).__name__, "message": str(error)}
    finally:
        signal.alarm(0)
        signal.signal(signal.SIGALRM, prior)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--factor-exact-seconds", type=int, default=180)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    forms_payload = json.loads(FORMS_PATH.read_text())
    universal = json.loads(UNIVERSAL_PATH.read_text())["universal_genus_one_interface"]
    coefficients = build_fixed_coefficients(forms_payload)
    c4 = eval_universal(universal["c4_terms"], coefficients)
    c6 = eval_universal(universal["c6_terms"], coefficients)
    delta = (c4**3 - c6**2) / K(1728)
    assert delta
    print("c4", poly_stats(c4), flush=True)
    print("c6", poly_stats(c6), flush=True)
    print("delta", poly_stats(delta), flush=True)

    delta_terms = serialized_poly(delta)
    delta_hash = canonical_hash(delta_terms)

    _, _, delta_line = specialize_to_line(delta)
    branch_payload = json.loads(BRANCH_PATH.read_text())
    _, _, h21 = unary_from_records(branch_payload["branch_factor"]["polynomial"]["serialized"])
    line_gcd = delta_line.gcd(h21)
    line_factor = factor_with_timeout(delta_line, min(args.factor_exact_seconds, 60))
    print(
        "line",
        {"delta_degree": delta_line.degree(), "H21_degree": h21.degree(), "gcd_degree": line_gcd.degree()},
        flush=True,
    )

    rur = rur_pullback(delta, json.loads(RUR_PATH.read_text()))
    print("rur", rur, flush=True)

    mod_ring, delta_mod = reduce_poly(delta)
    try:
        mod_factor_unit, mod_factors = delta_mod.factor_list()
        modular_factorization = {
            "status": "PASS",
            "prime": 67,
            "zeta11": 9,
            "unit": int(mod_factor_unit),
            "factors": [
                {"exponent": exponent, **poly_stats(factor)}
                for factor, exponent in mod_factors
            ],
        }
    except NotImplementedError as error:
        modular_factorization = {
            "status": "SYMPY_UNAVAILABLE",
            "prime": 67,
            "zeta11": 9,
            "message": str(error),
        }
    samples = json.loads(SAMPLES_PATH.read_text())["slice_hits"]
    sample_results = []
    confusion = {}
    for row in samples:
        point = row["point"][:4]
        value = evaluate_mod(delta_mod, point, 67)
        actual = value == 0
        proxy = row["cubic_singular"]
        key = f"proxy{int(proxy)}_delta{int(actual)}"
        confusion[key] = confusion.get(key, 0) + 1
        sample_results.append(
            {"point_ABYZ": point, "u": row["point"][4], "delta_mod67": value, "proxy": proxy}
        )
    print("sample_confusion", confusion, flush=True)

    exact_factorization = factor_with_timeout(delta, args.factor_exact_seconds)
    print("exact_factorization", exact_factorization, flush=True)

    global_h_meta = {
        "path": str(GLOBAL_H_PATH.relative_to(ROOT)),
        "sha256": file_hash(GLOBAL_H_PATH),
        "accepted_irreducible_total_degree": 43,
        "delta_total_degree": poly_stats(delta)["total_degree"],
        "conclusion": (
            "The full degree-43 polynomial H cannot divide nonzero Delta; generic "
            "noncontainment of the selected target component is certified separately "
            "by gcd(Delta|(1,2,3,s),H21)=1."
        ),
    }

    payload = {
        "schema": "klein-cubic-t3-fixed-frame-discriminant-discovery-v1",
        "field": "QQ[zeta11]/(zeta11^10+...+zeta11+1)",
        "parameter_order": ["A", "B", "Y", "Z"],
        "coefficient_basis": [f"zeta11^{i}" for i in range(10)],
        "formula": {
            "cubic": "X^3+X*(Q0*v^2+Q1*v*w+Q2*w^2)+R0*v^3+R1*v^2*w+R2*v*w^2+R3*w^3",
            "Q": "q0+A*qA+Y*qY",
            "R": "r0+A*rA+B*rB+Y*rY+(Z-11*A^2/18)*rZ",
            "Delta": "(c4^3-c6^2)/1728",
        },
        "source_sha256": {
            str(FORMS_PATH.relative_to(ROOT)): file_hash(FORMS_PATH),
            str(FORMS_SEAL.relative_to(ROOT)): file_hash(FORMS_SEAL),
            str(UNIVERSAL_PATH.relative_to(ROOT)): file_hash(UNIVERSAL_PATH),
            str(BRANCH_PATH.relative_to(ROOT)): file_hash(BRANCH_PATH),
            str(RUR_PATH.relative_to(ROOT)): file_hash(RUR_PATH),
            str(SAMPLES_PATH.relative_to(ROOT)): file_hash(SAMPLES_PATH),
        },
        "c4_stats": poly_stats(c4),
        "c6_stats": poly_stats(c6),
        "delta_stats": poly_stats(delta),
        "delta_terms_sha256": delta_hash,
        "delta_terms": delta_terms,
    }
    summary = {
        "schema": "klein-cubic-t3-fixed-frame-discriminant-summary-v1",
        "payload": PAYLOAD_GZ.name,
        "payload_uncompressed_terms_sha256": delta_hash,
        "source_sha256": payload["source_sha256"],
        "c4_stats": payload["c4_stats"],
        "c6_stats": payload["c6_stats"],
        "delta_stats": payload["delta_stats"],
        "global_target_factor": global_h_meta,
        "target_line": {
            "line": "(A,B,Y,Z)=(1,2,3,s)",
            "delta_degree": delta_line.degree(),
            "H21_degree": h21.degree(),
            "gcd_degree": line_gcd.degree(),
            "gcd_is_unit": line_gcd.degree() == 0,
            "delta_line_terms_sha256": canonical_hash(serialized_unary(delta_line)),
            "factorization": line_factor,
        },
        "degree12_RUR_A0_B2": rur,
        "mod67_factorization": modular_factorization,
        "mod67_slice_sample_confusion": confusion,
        "mod67_slice_samples": sample_results,
        "exact_factorization": exact_factorization,
        "boundary": (
            "Exact Delta is authoritative, but componentwise pullback valuations on the "
            "normal target branch and conductor/infinity exhaustiveness are not computed here."
        ),
    }
    if SINGULAR_FACTOR_RESULT.exists():
        summary["singular_factorization"] = json.loads(SINGULAR_FACTOR_RESULT.read_text())

    if args.write:
        encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
        PAYLOAD_GZ.write_bytes(gzip.compress(encoded, compresslevel=9, mtime=0))
        summary["payload_gzip_sha256"] = file_hash(PAYLOAD_GZ)
        summary["payload_uncompressed_bytes"] = len(encoded)
        summary["payload_gzip_bytes"] = PAYLOAD_GZ.stat().st_size
        SUMMARY_PATH.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
        print(f"wrote={PAYLOAD_GZ}", flush=True)
        print(f"wrote={SUMMARY_PATH}", flush=True)
    else:
        print(json.dumps(summary, indent=2, sort_keys=True), flush=True)
    print("T3_FIXED_FRAME_DISCRIMINANT_DISCOVERY_DONE", flush=True)


if __name__ == "__main__":
    main()
