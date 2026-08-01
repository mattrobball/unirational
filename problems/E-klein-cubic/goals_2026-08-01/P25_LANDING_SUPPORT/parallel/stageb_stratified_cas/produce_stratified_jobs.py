#!/usr/bin/env python3
"""Generate, but do not launch, exact H8-complement saturation jobs.

The closed stratum is L8=P<span(q4,...,q11)> and its complement is defined by
the nonvanishing of the ideal

    H8=(q0,...,q3,q12,...,q36).

For Stage B we first saturate by H8 and then by the b1 irrelevant ideal.  The
order is mathematically equivalent to the reverse order, but removes the known
old-r48 component L8 x P^5 before the b1 saturation.  For Stage C, b0=1 has
already been normalized and only H8 saturation is needed on the complement.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
GLOBAL = P25 / "parallel" / "stageb_global_basis"
STRATA = P25 / "parallel" / "stageb_strata"
NEW_PACKET = GLOBAL / "support_balanced_r43_stageBC.npz"
OLD_PACKET = P25 / "syzygy_r48_q0_contracted.npz"
CLOSED_CERT = STRATA / "closed_L_degree6_certificate.json"
CLOSED_VERIFY = STRATA / "verify_closed_L_degree6_result.json"
RUNNER = P25 / "parallel" / "stageb_cas" / "run_bounded.py"
METADATA = HERE / "stratified_jobs.json"

P = 89
NQ = 37
L8 = tuple(range(4, 12))
H8 = tuple(list(range(0, 4)) + list(range(12, 37)))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def polynomial_string(
    coefficients: np.ndarray, monomials: list[tuple[int, ...]]
) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        factors: list[str] = []
        for variable, power in enumerate(exponent):
            if power:
                factors.append(
                    f"q{variable}" if power == 1 else f"q{variable}^{power}"
                )
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def ring_header(handle) -> None:
    b_variables = [f"b1_{j}" for j in range(6)]
    q_variables = [f"q{i}" for i in range(NQ)]
    handle.write('LIB "elim.lib";\n')
    handle.write(
        f"ring R={P},({','.join(b_variables + q_variables)}),"
        "(dp(6),dp(37));\n"
    )
    handle.write("option(prot);\n")
    handle.write("ideal bideal=" + ",".join(b_variables) + ";\n")
    handle.write("ideal hideal=" + ",".join(f"q{i}" for i in H8) + ";\n")


def write_stageb(
    script: Path,
    result: Path,
    p3: np.ndarray,
    q3: list[tuple[int, ...]],
    label: str,
) -> None:
    rows = p3.shape[0]
    with script.open("w") as handle:
        ring_header(handle)
        handle.write("ideal I=\n")
        for row in range(rows):
            equation = "+".join(
                f"({polynomial_string(p3[row, component], q3)})*b1_{component}"
                for component in range(6)
            )
            handle.write(equation)
            handle.write(",\n" if row + 1 < rows else ";\n")
        handle.write(f'print("packet={label} input_gens="+string(size(I)));\n')
        handle.write("timer=1; ideal JH=sat(I,hideal); int elapsed_H=timer;\n")
        handle.write('print("H8_sat_gens="+string(size(JH)));\n')
        handle.write("timer=1; ideal J=sat(JH,bideal); int elapsed_b=timer;\n")
        handle.write("int decisive=(reduce(1,J)==0);\n")
        handle.write(
            'print("final_unit="+string(decisive)+" final_gens="+string(size(J)));\n'
        )
        handle.write(
            f'write(":w {result}","decisive="+string(decisive)'
            '+",H8_saturated_generators="+string(size(JH))'
            '+",final_generators="+string(size(J))'
            '+",H8_elapsed_ms="+string(elapsed_H)'
            '+",b1_elapsed_ms="+string(elapsed_b));\n'
        )
        handle.write("quit;\n")


def write_stagec(
    script: Path,
    result: Path,
    p3: np.ndarray,
    p4: np.ndarray,
    q3: list[tuple[int, ...]],
    q4: list[tuple[int, ...]],
) -> None:
    rows = p3.shape[0]
    with script.open("w") as handle:
        ring_header(handle)
        handle.write("ideal I=\n")
        for row in range(rows):
            equation = polynomial_string(p4[row], q4) + "+" + "+".join(
                f"({polynomial_string(p3[row, component], q3)})*b1_{component}"
                for component in range(6)
            )
            handle.write(equation)
            handle.write(",\n" if row + 1 < rows else ";\n")
        handle.write('print("packet=new-r43-stageC input_gens="+string(size(I)));\n')
        handle.write("timer=1; ideal J=sat(I,hideal); int elapsed_H=timer;\n")
        handle.write("int decisive=(reduce(1,J)==0);\n")
        handle.write(
            'print("H8_sat_unit="+string(decisive)+" final_gens="+string(size(J)));\n'
        )
        handle.write(
            f'write(":w {result}","decisive="+string(decisive)'
            '+",saturated_generators="+string(size(J))'
            '+",H8_elapsed_ms="+string(elapsed_H));\n'
        )
        handle.write("quit;\n")


def job_record(script: Path, result: Path, criterion: str) -> dict:
    command = (
        f"/opt/homebrew/bin/python3 {RUNNER} {script} "
        "--timeout 43200 --rss-gib 64"
    )
    return {
        "script": script.name,
        "script_sha256": sha256(script),
        "script_bytes": script.stat().st_size,
        "result": result.name,
        "criterion": criterion,
        "suggested_command_not_run": command,
    }


def main() -> None:
    for path in (NEW_PACKET, OLD_PACKET, CLOSED_CERT, CLOSED_VERIFY, RUNNER):
        if not path.is_file():
            raise FileNotFoundError(path)
    with np.load(NEW_PACKET, allow_pickle=False) as frozen:
        new_p3 = frozen["p3"].astype(np.uint8)
        new_p4 = frozen["p4"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("new packet prime mismatch")
    with np.load(OLD_PACKET, allow_pickle=False) as frozen:
        old_p3 = frozen["p3"].astype(np.uint8)
        old_p4 = frozen["p4"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("old packet prime mismatch")
    if new_p3.shape != (43, 6, 9139) or new_p4.shape != (43, 91390):
        raise AssertionError("new r43 packet shape mismatch")
    if old_p3.shape != (48, 6, 9139) or old_p4.shape != (48, 91390):
        raise AssertionError("old r48 packet shape mismatch")

    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    jobs: dict[str, dict] = {}
    specifications = [
        (
            "stageB_new_r43_L8_complement_Hfirst",
            new_p3,
            "new-r43",
        ),
        (
            "stageB_old_r48_L8_complement_Hfirst",
            old_p3,
            "old-r48",
        ),
    ]
    for stem, tensor, label in specifications:
        script = HERE / f"{stem}.sing"
        result = HERE / f"{stem}_result.txt"
        write_stageb(script, result, tensor, q3, label)
        jobs[stem] = job_record(
            script,
            result,
            (
                "unit of sat(sat(I,H8),b1_irrelevant) proves the selected "
                "Stage-B contraction incidence empty on P36 minus L8"
            ),
        )

    stagec_stem = "stageC_new_r43_L8_complement_Hfirst"
    stagec_script = HERE / f"{stagec_stem}.sing"
    stagec_result = HERE / f"{stagec_stem}_result.txt"
    write_stagec(stagec_script, stagec_result, new_p3, new_p4, q3, q4)
    jobs[stagec_stem] = job_record(
        stagec_script,
        stagec_result,
        (
            "unit of sat(I,H8) proves the selected normalized Stage-C "
            "contraction incidence empty on P36 minus L8"
        ),
    )

    with CLOSED_VERIFY.open() as handle:
        closed_verify = json.load(handle)
    if closed_verify.get("status") != "PASS" or not closed_verify.get(
        "determinant_nonzero"
    ):
        raise AssertionError("closed-L8 independent replay is not decisive")
    if closed_verify.get("certificate_sha256") != sha256(CLOSED_CERT):
        raise AssertionError("closed-L8 certificate/replay hash mismatch")

    metadata = {
        "status": "JOBS_GENERATED_NOT_LAUNCHED",
        "prime": P,
        "closed_stratum": {
            "name": "L8",
            "coordinates": list(L8),
            "definition": "q_i=0 for i in H8",
            "stageB_status": "independently certified empty",
            "certificate": str(CLOSED_CERT.relative_to(P25)),
            "certificate_sha256": sha256(CLOSED_CERT),
            "independent_replay": str(CLOSED_VERIFY.relative_to(P25)),
            "independent_replay_sha256": sha256(CLOSED_VERIFY),
            "determinant_mod_89": closed_verify["determinant_mod_89"],
        },
        "open_complement": {
            "outside_ideal_name": "H8",
            "outside_coordinates": list(H8),
            "geometric_open": "P36 minus L8",
            "saturation_order_stageB": ["H8", "b1 irrelevant ideal"],
            "order_reason": (
                "the saturations commute, while H8-first removes the known "
                "old-r48 L8 x P5 component before the b1 computation"
            ),
        },
        "inputs": {
            "new_r43_stageBC": {
                "path": str(NEW_PACKET.relative_to(P25)),
                "sha256": sha256(NEW_PACKET),
                "p3_nnz": int(np.count_nonzero(new_p3)),
                "p4_nnz": int(np.count_nonzero(new_p4)),
            },
            "old_r48_stageBC": {
                "path": str(OLD_PACKET.relative_to(P25)),
                "sha256": sha256(OLD_PACKET),
                "p3_nnz": int(np.count_nonzero(old_p3)),
                "p4_nnz": int(np.count_nonzero(old_p4)),
            },
        },
        "jobs": jobs,
        "not_launched": True,
        "not_launched_reason": (
            "shared PID 13036 Singular job is live; these exact jobs are intentionally deferred"
        ),
        "theorem_logic": {
            "stageB": (
                "closed-L8 emptiness plus a unit from either Stage-B H8-complement "
                "job proves true Stage B empty globally"
            ),
            "stageC": (
                "a closed-L8 Stage-C unit plus the new-r43 Stage-C H8-complement "
                "unit proves true Stage C empty globally"
            ),
            "nonunit_guard": (
                "a nonunit, timeout, crash, or missing output is only a contraction "
                "nonverdict and is not a true incidence point"
            ),
        },
        "L9_guard": (
            "The larger L9=P<span(q4,...,q12)> is deliberately not used because "
            "the upstream q12 chart certificate has not yet received an independent replay."
        ),
    }
    METADATA.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata, sort_keys=True))


if __name__ == "__main__":
    main()

