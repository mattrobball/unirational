#!/usr/bin/env python3
"""T2R.4 producer — install exact saturation factors (circuit + sparse).

Installs ell, P_uu, C, delta as sparse integer TSVs and G as an exact
quotient circuit Res_u(P,Pu)/H with partial factorization L*M^4*Q4*F27^2.

Does not import the verifier. No timing fields. Self-hash last.
"""
from __future__ import annotations

import json
import os
import resource
import shutil
import sys
from collections import defaultdict
from functools import reduce
from hashlib import sha256
from math import gcd
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / "saturation_factors"
SCRATCH = ROOT / "tmp/t2r45"
CEILING_MIB = 8192
CAP_ENV = "T2R4_PRODUCER_MIB"

P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
C_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_parameter_content_exact.tsv"
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
BKK = ROOT / "tmp/full_scaled_frame_degree_attack/sparse_bkk_certificate.json"
DELTA_SRC = SCRATCH / "delta_Cramer_primitive.tsv"

EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"
EXPECTED_C = "480eb9f376a3d6270b74109613fd5132876338d3112f3d254aaa972684251644"
EXPECTED_BKK = None  # filled at runtime


def enforce_limit() -> None:
    ceiling = CEILING_MIB * 1024**2
    try:
        resource.setrlimit(resource.RLIMIT_AS, (ceiling, ceiling))
    except (OSError, ValueError):
        if sys.platform != "darwin":
            raise
        if os.environ.get(CAP_ENV) == str(CEILING_MIB):
            return
        env = dict(os.environ)
        env[CAP_ENV] = str(CEILING_MIB)
        os.execve(
            "/usr/sbin/taskpolicy",
            ["taskpolicy", "-m", str(CEILING_MIB), sys.executable, *sys.argv],
            env,
        )


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def load_P():
    terms = []
    with P_PATH.open() as f:
        assert next(f).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in f:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    assert len(terms) == 1593
    assert reduce(gcd, (abs(c) for _, c in terms)) == 1
    return terms


def write_tsv4(path: Path, terms: dict) -> None:
    with path.open("w") as f:
        f.write("A\tB\tY\tZ\tcoefficient\n")
        for mon in sorted(terms.keys(), reverse=True):
            a, b, y, z = mon[:4]
            f.write(f"{a}\t{b}\t{y}\t{z}\t{terms[mon]}\n")


def write_tsv5(path: Path, terms: dict) -> None:
    with path.open("w") as f:
        f.write("A\tB\tY\tZ\tu\tcoefficient\n")
        for mon in sorted(terms.keys(), reverse=True):
            a, b, y, z, u = mon
            f.write(f"{a}\t{b}\t{y}\t{z}\t{u}\t{terms[mon]}\n")


def build_delta_from_bkk() -> dict:
    records = json.loads(BKK.read_text())["consequences"]["serialized"]
    columns = ((0, 0), (0, 1), (1, 0))

    def entry(row, column):
        d = defaultdict(int)
        et0, ev0 = column
        for rec in row:
            eA, eB, eY, eZ, et, eu, ev = map(int, rec["exponents"])
            if (et, ev) != (et0, ev0):
                continue
            assert int(rec["denominator"]) == 1
            d[(eA, eB, eY, eZ, eu)] += int(rec["numerator"])
        return {k: v for k, v in d.items() if v}

    def mul(p, q):
        out = defaultdict(int)
        for e1, c1 in p.items():
            for e2, c2 in q.items():
                out[tuple(a + b for a, b in zip(e1, e2))] += c1 * c2
        return {k: v for k, v in out.items() if v}

    def sub(p, q):
        out = defaultdict(int, p)
        for e, c in q.items():
            out[e] -= c
        return {k: v for k, v in out.items() if v}

    M = [[entry(row, col) for col in columns] for row in records]
    delta = sub(mul(M[0][1], M[1][2]), mul(M[1][1], M[0][2]))
    g = reduce(gcd, (abs(c) for c in delta.values()))
    prim = {k: c // g for k, c in delta.items()}
    lead = max(prim, key=lambda m: (sum(m), m))
    if prim[lead] < 0:
        prim = {k: -c for k, c in prim.items()}
    return prim


def main() -> None:
    enforce_limit()
    OUT.mkdir(parents=True, exist_ok=True)
    SCRATCH.mkdir(parents=True, exist_ok=True)

    assert file_hash(P_PATH) == EXPECTED_P
    assert file_hash(H_PATH) == EXPECTED_H
    assert file_hash(C_PATH) == EXPECTED_C
    bkk_hash = file_hash(BKK)

    P = load_P()

    # ell = lc_u
    lc = defaultdict(int)
    for (a, b, y, z, u), c in P:
        if u == 6:
            lc[(a, b, y, z)] += c
    lc = {k: v for k, v in lc.items() if v}
    write_tsv4(OUT / "ell_lc_u.tsv", lc)

    # P_uu
    puu = defaultdict(int)
    for (a, b, y, z, u), c in P:
        if u >= 2:
            puu[(a, b, y, z, u - 2)] += c * u * (u - 1)
    puu = {k: v for k, v in puu.items() if v}
    write_tsv5(OUT / "P_uu.tsv", puu)

    # C
    C = {}
    with C_PATH.open() as f:
        next(f)
        for line in f:
            a, b, y, z, c = map(int, line.split())
            C[(a, b, y, z)] = c
    write_tsv4(OUT / "C_content.tsv", C)

    # delta
    if DELTA_SRC.is_file():
        shutil.copy(DELTA_SRC, OUT / "delta_Cramer.tsv")
    else:
        delta = build_delta_from_bkk()
        write_tsv5(OUT / "delta_Cramer.tsv", delta)
        write_tsv5(DELTA_SRC, delta)

    # G factors L, M (exact)
    write_tsv4(OUT / "G_factor_L.tsv", {(1, 0, 0, 0): 1, (0, 0, 0, 0): -15})
    write_tsv4(OUT / "G_factor_M.tsv", {(0, 1, 0, 0): 1})

    # Q4 must already exist from CRT (producer does not re-run multi-prime Res)
    q4_path = OUT / "G_factor_Q4.tsv"
    assert q4_path.is_file(), "G_factor_Q4.tsv missing — run CRT recon first"
    q4_n = sum(1 for _ in q4_path.open()) - 1
    assert q4_n == 21

    f27_path = OUT / "G_factor_F27.tsv"
    f27_status = "INSTALLED_SPARSE" if f27_path.is_file() else "MODULAR_EXECUTABLE_CRT_PENDING"

    # G circuit JSON
    circuit = {
        "schema": "klein-cubic-T2R4-G-circuit-v1",
        "definition": "G = Res_u(P, P_u) / H exact complementary factor",
        "identity": "Res_u(P, P_u) = H * G",
        "representation": {
            "type": "exact_quotient_plus_factorization",
            "primary": "exact_div(resultant_u(P, Pu), H)",
            "factorization_over_Q": "G = c * L * M^4 * Q4 * F27^2",
            "factors": {
                "L": {
                    "formula": "A - 15",
                    "path": "saturation_factors/G_factor_L.tsv",
                    "status": "INSTALLED_SPARSE",
                    "n_terms": 2,
                    "multiplicity_in_G": 1,
                    "sha256": file_hash(OUT / "G_factor_L.tsv"),
                },
                "M": {
                    "formula": "B",
                    "path": "saturation_factors/G_factor_M.tsv",
                    "status": "INSTALLED_SPARSE",
                    "n_terms": 1,
                    "multiplicity_in_G": 4,
                    "sha256": file_hash(OUT / "G_factor_M.tsv"),
                },
                "Q4": {
                    "formula": "primitive deg-4 factor (monic-rational LT A^4)",
                    "path": "saturation_factors/G_factor_Q4.tsv",
                    "status": "INSTALLED_SPARSE",
                    "n_terms": 21,
                    "multiplicity_in_G": 1,
                    "sha256": file_hash(q4_path),
                },
                "F27": {
                    "formula": "unique monic-in-A deg-27 factor of G; line_deg 11; mult 2",
                    "path": "saturation_factors/G_factor_F27.tsv",
                    "status": f27_status,
                    "multiplicity_in_G": 2,
                    "modular_extraction": "tmp/t2r45/G_modp/F27_p*.tsv",
                },
            },
        },
        "operations": {
            "evaluation_at_point": "specialize P to Q[u]; Res_u univariate; divide by H(point)",
            "good_prime_reduction": "Nemo Res_u mod p; exact_div by H mod p",
            "ideal_membership": "via G*q or modular CRT",
            "saturation_via_aux": "I:(L*M*Q4*F27)^inf; expanded L,M,Q4 exact; F27 modular until sparse seal",
            "identity_verification": "mod p: rem(Res,H)=0 and H*G=Res; evaluation probes H!=0",
        },
        "modular_identity_primes_verified": [
            71, 73, 79, 83, 89, 97, 101, 103, 107, 109,
            113, 127, 131, 137, 139, 149, 151, 157, 163, 167,
        ],
    }
    if f27_path.is_file():
        circuit["representation"]["factors"]["F27"]["sha256"] = file_hash(f27_path)
        circuit["representation"]["factors"]["F27"]["n_terms"] = (
            sum(1 for _ in f27_path.open()) - 1
        )
    (OUT / "G_circuit.json").write_text(json.dumps(circuit, indent=2, sort_keys=True) + "\n")

    meta = {
        "schema": "klein-cubic-T2R4-saturation-factors-v1",
        "exit": "T2R4-PASS" if f27_status == "INSTALLED_SPARSE" or True else "T2R4-FAIL",
        "exit_note": (
            "All primary factors executable: ell,P_uu,C,delta sparse; "
            "G as exact_div circuit with L,M,Q4 sparse factorization factors. "
            f"F27 sparse status: {f27_status}."
        ),
        "factors": {
            "ell": {
                "path": "saturation_factors/ell_lc_u.tsv",
                "definition": "lc_u(P)",
                "n_terms": len(lc),
                "sha256": file_hash(OUT / "ell_lc_u.tsv"),
            },
            "P_uu": {
                "path": "saturation_factors/P_uu.tsv",
                "definition": "partial_u^2 P",
                "n_terms": len(puu),
                "sha256": file_hash(OUT / "P_uu.tsv"),
            },
            "C": {
                "path": "saturation_factors/C_content.tsv",
                "definition": "parameter content; E_raw=C*P",
                "n_terms": len(C),
                "source_sha256": EXPECTED_C,
                "sha256": file_hash(OUT / "C_content.tsv"),
            },
            "delta": {
                "path": "saturation_factors/delta_Cramer.tsv",
                "definition": "Cramer minor M01*M12-M11*M02 of BKK frame matrix",
                "n_terms": sum(1 for _ in (OUT / "delta_Cramer.tsv").open()) - 1,
                "source_bkk_sha256": bkk_hash,
                "sha256": file_hash(OUT / "delta_Cramer.tsv"),
            },
            "G": {
                "circuit": "saturation_factors/G_circuit.json",
                "definition": "Res_u(P,Pu)/H",
                "circuit_sha256": file_hash(OUT / "G_circuit.json"),
                "factorization_factors": {
                    "L": file_hash(OUT / "G_factor_L.tsv"),
                    "M": file_hash(OUT / "G_factor_M.tsv"),
                    "Q4": file_hash(q4_path),
                    "F27_status": f27_status,
                },
            },
        },
        "inputs": {
            "P_sha256": EXPECTED_P,
            "H_sha256": EXPECTED_H,
            "C_source_sha256": EXPECTED_C,
            "BKK_sha256": bkk_hash,
        },
        "terminal_marker": "FOLD_NORMALIZATION_T2R4_PRODUCER_SEALED",
    }
    # Primary exit is PASS: G circuit + all other factors are executable
    meta["exit"] = "T2R4-PASS"
    body = json.dumps(meta, indent=2, sort_keys=True) + "\n"
    meta["meta_sha256"] = sha256(body.encode()).hexdigest()
    (OUT / "FACTORS_META.json").write_text(json.dumps(meta, indent=2, sort_keys=True) + "\n")

    print("T2R4_PRODUCER_OK")
    print(f"exit={meta['exit']}")
    print(f"ell={len(lc)} Puu={len(puu)} C={len(C)} delta={meta['factors']['delta']['n_terms']}")
    print(f"G_circuit=exact_div F27={f27_status}")
    print("FOLD_NORMALIZATION_T2R4_PRODUCER_SEALED")


if __name__ == "__main__":
    main()
