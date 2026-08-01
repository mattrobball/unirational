#!/usr/bin/env python3
"""Write, but do not launch, exact Stage-B module and saturation jobs."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np

from produce_full_basis import NQ, P, sha256, weak_compositions


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "support_balanced_r43_stageBC.npz"
LINE_CERTIFICATE = HERE / "support_balanced_coordinate_line_minors.npz"
LINE_REPLAY = HERE / "verify_coordinate_lines_result.json"
MODULE_SCRIPT = HERE / "support_balanced_r43_stageB_module.sing"
MODULE_RESULT = HERE / "support_balanced_r43_stageB_module_result.txt"
SAT_SCRIPT = HERE / "support_balanced_r43_stageB_saturation.sing"
SAT_RESULT = HERE / "support_balanced_r43_stageB_saturation_result.txt"
STAGEC_SCRIPT = HERE / "support_balanced_r43_stageC_saturation.sing"
STAGEC_RESULT = HERE / "support_balanced_r43_stageC_saturation_result.txt"
BOUNDED_RUNNER = HERE.parent / "stageb_cas" / "run_bounded.py"


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
                name = f"q{variable}"
                factors.append(name if power == 1 else f"{name}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def main() -> None:
    if not SOURCE.is_file():
        raise FileNotFoundError(SOURCE)
    with np.load(SOURCE, allow_pickle=False) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        p4 = frozen["p4"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("packet prime mismatch")
    if p3.shape != (43, 6, 9139):
        raise AssertionError(f"unexpected P3 shape {p3.shape}")
    if p4.shape != (43, 91390):
        raise AssertionError(f"unexpected P4 shape {p4.shape}")
    for path in (LINE_CERTIFICATE, LINE_REPLAY, BOUNDED_RUNNER):
        if not path.is_file():
            raise FileNotFoundError(path)
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    polys3 = [
        [polynomial_string(p3[row, component], q3) for component in range(6)]
        for row in range(43)
    ]
    polys4 = [polynomial_string(p4[row], q4) for row in range(43)]
    q_variables = [f"q{i}" for i in range(NQ)]

    with MODULE_SCRIPT.open("w") as handle:
        handle.write(f"ring R={P},({','.join(q_variables)}),(dp,C);\n")
        handle.write("option(prot);\n")
        handle.write("module N=\n")
        for row, entries in enumerate(polys3):
            handle.write("[" + ",".join(entries) + "]")
            handle.write(",\n" if row < 42 else ";\n")
        handle.write('print("input module gens="+string(size(N)));\n')
        handle.write("timer=1; module G=std(N); int elapsed=timer;\n")
        handle.write("int decisive=(dim(G)==0);\n")
        handle.write(
            'print("std gens="+string(size(G))+" dim="+string(dim(G))'
            '+" elapsed_ms="+string(elapsed));\n'
        )
        handle.write(
            f'write(":w {MODULE_RESULT}","decisive="+string(decisive)'
            '+",dim="+string(dim(G))+",std_gens="+string(size(G))'
            '+",elapsed_ms="+string(elapsed));\n'
        )
        handle.write("quit;\n")

    b_variables = [f"b1_{j}" for j in range(6)]
    with SAT_SCRIPT.open("w") as handle:
        handle.write('LIB "elim.lib";\n')
        handle.write(
            f"ring R={P},({','.join(b_variables + q_variables)}),dp;\n"
        )
        handle.write("option(prot);\n")
        handle.write("ideal qideal=" + ",".join(q_variables) + ";\n")
        handle.write("ideal bideal=" + ",".join(b_variables) + ";\n")
        handle.write("ideal I=\n")
        for row, entries in enumerate(polys3):
            equation = "+".join(
                f"({entries[component]})*b1_{component}"
                for component in range(6)
            )
            handle.write(equation)
            handle.write(",\n" if row < 42 else ";\n")
        handle.write('print("input gens="+string(size(I)));\n')
        handle.write("timer=1; ideal Jb=sat(I,bideal); int elapsed_b=timer;\n")
        handle.write('print("b-saturated gens="+string(size(Jb)));\n')
        handle.write("timer=1; ideal J=sat(Jb,qideal); int elapsed_q=timer;\n")
        handle.write("int decisive=(reduce(1,J)==0);\n")
        handle.write(
            'print("sat unit="+string(decisive)+" ngens="+string(size(J)));\n'
        )
        handle.write(
            f'write(":w {SAT_RESULT}","decisive="+string(decisive)'
            '+",saturated_generators="+string(size(J))'
            '+",b_elapsed_ms="+string(elapsed_b)'
            '+",q_elapsed_ms="+string(elapsed_q));\n'
        )
        handle.write("quit;\n")

    with STAGEC_SCRIPT.open("w") as handle:
        handle.write('LIB "elim.lib";\n')
        handle.write(
            f"ring R={P},({','.join(b_variables + q_variables)}),dp;\n"
        )
        handle.write("option(prot);\n")
        handle.write("ideal qideal=" + ",".join(q_variables) + ";\n")
        handle.write("ideal I=\n")
        for row, entries in enumerate(polys3):
            equation = polys4[row] + "+" + "+".join(
                f"({entries[component]})*b1_{component}"
                for component in range(6)
            )
            handle.write(equation)
            handle.write(",\n" if row < 42 else ";\n")
        handle.write('print("input gens="+string(size(I)));\n')
        handle.write("timer=1; ideal J=sat(I,qideal); int elapsed_q=timer;\n")
        handle.write("int decisive=(reduce(1,J)==0);\n")
        handle.write(
            'print("q-sat unit="+string(decisive)+" ngens="+string(size(J)));\n'
        )
        handle.write(
            f'write(":w {STAGEC_RESULT}","decisive="+string(decisive)'
            '+",saturated_generators="+string(size(J))'
            '+",q_elapsed_ms="+string(elapsed_q));\n'
        )
        handle.write("quit;\n")

    metadata = {
        "prime": P,
        "rows": 43,
        "source": SOURCE.name,
        "source_sha256": sha256(SOURCE),
        "expanded_p3_terms": int(np.count_nonzero(p3)),
        "expanded_p4_terms": int(np.count_nonzero(p4)),
        "coordinate_line_guard": {
            "certificate": LINE_CERTIFICATE.name,
            "certificate_sha256": sha256(LINE_CERTIFICATE),
            "independent_replay": LINE_REPLAY.name,
            "independent_replay_sha256": sha256(LINE_REPLAY),
            "scope": "rank six on all 666 coordinate lines",
        },
        "module_job": {
            "script": MODULE_SCRIPT.name,
            "script_sha256": sha256(MODULE_SCRIPT),
            "script_bytes": MODULE_SCRIPT.stat().st_size,
            "result": MODULE_RESULT.name,
            "criterion": "dim(S^6/N)=0",
        },
        "saturation_job": {
            "script": SAT_SCRIPT.name,
            "script_sha256": sha256(SAT_SCRIPT),
            "script_bytes": SAT_SCRIPT.stat().st_size,
            "result": SAT_RESULT.name,
            "saturation_order": ["b1 irrelevant ideal", "q irrelevant ideal"],
            "criterion": "sequentially saturated unit ideal",
        },
        "stageC_saturation_job": {
            "script": STAGEC_SCRIPT.name,
            "script_sha256": sha256(STAGEC_SCRIPT),
            "script_bytes": STAGEC_SCRIPT.stat().st_size,
            "result": STAGEC_RESULT.name,
            "normalization": "b0=1",
            "saturation_order": ["q irrelevant ideal"],
            "criterion": "q-saturated unit ideal",
        },
        "bounded_runner": {
            "path": str(BOUNDED_RUNNER),
            "path_sha256": sha256(BOUNDED_RUNNER),
            "suggested_wall_seconds": 7200,
            "suggested_rss_gib": 32,
            "commands_not_run": [
                f"/opt/homebrew/bin/python3 {BOUNDED_RUNNER} {MODULE_SCRIPT} --timeout 7200 --rss-gib 32",
                f"/opt/homebrew/bin/python3 {BOUNDED_RUNNER} {SAT_SCRIPT} --timeout 7200 --rss-gib 32",
                f"/opt/homebrew/bin/python3 {BOUNDED_RUNNER} {STAGEC_SCRIPT} --timeout 7200 --rss-gib 32",
            ],
        },
        "not_run_by_producer": True,
        "logical_scope": (
            "A decisive Stage-B module/saturation result proves Stage B empty; "
            "a decisive q-saturated Stage-C result proves the normalized b0=1 "
            "stratum empty. A nonunit, timeout, crash, or missing output is not "
            "a candidate or verdict on the original incidence."
        ),
    }
    metadata_path = HERE / "stageb_cas_jobs.json"
    metadata_path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata, sort_keys=True))


if __name__ == "__main__":
    main()
