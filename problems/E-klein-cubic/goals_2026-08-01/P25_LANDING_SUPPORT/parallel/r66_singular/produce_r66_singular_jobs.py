#!/usr/bin/env python3
"""Prepare, but never launch, exact r66 Stage-B Singular jobs over F_89."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
PACKET = P25 / "parallel" / "global_compatibility" / "support_augmented_r66_stageBC.npz"
EXPECTED_PACKET_SHA256 = "b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84"
EXPECTED_CANONICAL_MS_SHA256 = "9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b"
P = 89
NQ = 37


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def immutable_write(path: Path, content: str) -> None:
    if path.exists():
        if path.read_text() != content:
            raise SystemExit(f"refusing to overwrite mismatching immutable file {path}")
        return
    path.write_text(content)


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def specialized_q_term(exponent: tuple[int, ...]) -> str:
    factors: list[str] = []
    for variable, power in enumerate(exponent):
        if variable == 0 or power == 0:
            continue
        factors.append(f"q{variable}" if power == 1 else f"q{variable}^{power}")
    return "*".join(factors) if factors else "1"


def polynomial(coefficients: np.ndarray, monomials: list[tuple[int, ...]]) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        monomial = specialized_q_term(exponent)
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def scalar_equation(p3: np.ndarray, row: int, q3: list[tuple[int, ...]]) -> tuple[str, int]:
    terms: list[str] = []
    count = 0
    for component in range(6):
        bname = None if component == 0 else f"b1_{component}"
        for raw, exponent in zip(p3[row, component], q3):
            coefficient = int(raw) % P
            if not coefficient:
                continue
            qpart = specialized_q_term(exponent)
            factors = [] if qpart == "1" else [qpart]
            if bname is not None:
                factors.append(bname)
            monomial = "*".join(factors) if factors else "1"
            terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
            count += 1
    return "+".join(terms) if terms else "0", count


def scalar_job(stem: str, variables: list[str], algorithm: str, memory_mode: bool) -> str:
    options = ["option(prot);"]
    if memory_mode:
        options.append("option(notBuckets);")
    result = f"{stem}.result.txt"
    return "\n".join(
        [
            f"ring R={P},({','.join(variables)}),dp;",
            *options,
            'execute(read("r66_stageB_q0_1_b10_1_equations.inc"));',
            'print("R66_SCALAR_INPUT characteristic="+string(char(R))+",vars="+string(nvars(R))+",eqs="+string(size(I)));',
            "timer=1;",
            f"ideal G={algorithm}(I);",
            "int elapsed=timer;",
            "poly one_nf=reduce(1,G);",
            "int unit=(one_nf==0);",
            'print("R66_SCALAR_RESULT unit="+string(unit)+",basis_gens="+string(size(G))+",elapsed_ms="+string(elapsed));',
            f'write(":w {result}","unit="+string(unit)+",basis_gens="+string(size(G))+",elapsed_ms="+string(elapsed));',
            "quit;",
            "",
        ]
    )


def module_job() -> str:
    qvars = [f"q{i}" for i in range(1, NQ)]
    stem = "r66_stageB_q0_1_all_b_module_std_notBuckets"
    return "\n".join(
        [
            f"ring R={P},({','.join(qvars)}),(dp,C);",
            "option(prot);",
            "option(notBuckets);",
            'execute(read("r66_stageB_q0_1_module.inc"));',
            'print("R66_MODULE_INPUT characteristic="+string(char(R))+",vars="+string(nvars(R))+",rows="+string(size(N)));',
            "timer=1;",
            "module G=std(N);",
            "int elapsed=timer;",
            "module E=freemodule(6);",
            "module rem=simplify(reduce(E,G),2);",
            "int remainder_zero=(size(rem)==0);",
            "int quotient_dim=dim(G);",
            "int full=(remainder_zero && quotient_dim==-1);",
            'print("R66_MODULE_RESULT full="+string(full)+",remainder_zero="+string(remainder_zero)+",quotient_dim="+string(quotient_dim)+",basis_gens="+string(size(G))+",elapsed_ms="+string(elapsed));',
            f'write(":w {stem}.result.txt","full="+string(full)+",remainder_zero="+string(remainder_zero)+",quotient_dim="+string(quotient_dim)+",basis_gens="+string(size(G))+",elapsed_ms="+string(elapsed));',
            "quit;",
            "",
        ]
    )


def main() -> None:
    if sha256(PACKET) != EXPECTED_PACKET_SHA256:
        raise AssertionError("sealed r66 packet hash mismatch")
    with np.load(PACKET, allow_pickle=False) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        if int(frozen["prime"]) != P or p3.shape != (66, 6, 9139):
            raise AssertionError("unexpected r66 P3 tensor")
    q3 = weak_compositions(3, NQ)
    if len(q3) != 9139:
        raise AssertionError("cubic monomial census mismatch")

    scalar_path = HERE / "r66_stageB_q0_1_b10_1_equations.inc"
    module_path = HERE / "r66_stageB_q0_1_module.inc"
    canonical_hash = hashlib.sha256()
    msolve_variables = [f"b1_{j}" for j in range(1, 6)] + [f"q{i}" for i in range(1, NQ)]
    canonical_hash.update((",".join(msolve_variables) + f"\n{P}\n").encode())
    printed_terms = 0

    if not scalar_path.exists() or not module_path.exists():
        if scalar_path.exists() or module_path.exists():
            raise SystemExit("refusing a partial immutable regeneration")
        with scalar_path.open("w") as scalar, module_path.open("w") as module:
            scalar.write("ideal I=\n")
            module.write("module N=\n")
            for row in range(66):
                equation, count = scalar_equation(p3, row, q3)
                entries = [polynomial(p3[row, component], q3) for component in range(6)]
                printed_terms += count
                suffix = ",\n" if row < 65 else ";\n"
                scalar.write(equation + suffix)
                module.write("[" + ",".join(entries) + "]" + suffix)
                canonical_hash.update(equation.encode())
                canonical_hash.update(b",\n" if row < 65 else b"\n")
    else:
        raw = scalar_path.read_text()
        if not raw.startswith("ideal I=\n") or not raw.endswith(";\n"):
            raise AssertionError("malformed immutable scalar include")
        body = raw[len("ideal I=\n") : -2]
        equations = body.split(",\n")
        if len(equations) != 66:
            raise AssertionError("scalar equation count drift")
        for row, equation in enumerate(equations):
            canonical_hash.update(equation.encode())
            canonical_hash.update(b",\n" if row < 65 else b"\n")
        printed_terms = sum(eq.count("+") + 1 for eq in equations)

    canonical_ms_sha256 = canonical_hash.hexdigest()
    if canonical_ms_sha256 != EXPECTED_CANONICAL_MS_SHA256:
        raise AssertionError("independent canonical msolve chart hash mismatch")
    if printed_terms != 2363052:
        raise AssertionError("printed-term census mismatch")

    qfirst = [f"q{i}" for i in range(1, NQ)] + [f"b1_{j}" for j in range(1, 6)]
    bfirst = [f"b1_{j}" for j in range(1, 6)] + [f"q{i}" for i in range(1, NQ)]
    jobs = {
        "r66_stageB_q0_1_b10_1_std_qfirst_notBuckets.sing": scalar_job(
            "r66_stageB_q0_1_b10_1_std_qfirst_notBuckets", qfirst, "std", True
        ),
        "r66_stageB_q0_1_b10_1_std_bfirst_notBuckets.sing": scalar_job(
            "r66_stageB_q0_1_b10_1_std_bfirst_notBuckets", bfirst, "std", True
        ),
        "r66_stageB_q0_1_b10_1_slimgb_qfirst.sing": scalar_job(
            "r66_stageB_q0_1_b10_1_slimgb_qfirst", qfirst, "slimgb", False
        ),
        "r66_stageB_q0_1_all_b_module_std_notBuckets.sing": module_job(),
    }
    for name, content in jobs.items():
        immutable_write(HERE / name, content)

    manifest = {
        "status": "PREPARED_NOT_RUN",
        "prime": P,
        "field": "F_89",
        "packet": str(PACKET.relative_to(P25)),
        "packet_sha256": sha256(PACKET),
        "p3_shape": list(p3.shape),
        "chart": {"q0": 1, "b1_0": 1},
        "scalar_equations": 66,
        "scalar_variables": 41,
        "printed_terms": printed_terms,
        "canonical_msolve_sha256": canonical_ms_sha256,
        "canonical_msolve_expected_sha256": EXPECTED_CANONICAL_MS_SHA256,
        "includes": {
            scalar_path.name: {"bytes": scalar_path.stat().st_size, "sha256": sha256(scalar_path)},
            module_path.name: {"bytes": module_path.stat().st_size, "sha256": sha256(module_path)},
        },
        "jobs": {
            name: {"bytes": (HERE / name).stat().st_size, "sha256": sha256(HERE / name)}
            for name in sorted(jobs)
        },
        "strongest_job": "r66_stageB_q0_1_all_b_module_std_notBuckets.sing",
        "strongest_criterion": (
            "A completed full=1 result proves the r66 P3 row module equals R^6 "
            "on q0=1, hence excludes every projective b1 and in particular b1_0=1."
        ),
        "scalar_criterion": (
            "A completed unit=1 result proves only the exact affine chart q0=1,b1_0=1 empty."
        ),
        "nonverdict_guard": (
            "Not run. Timeout, resource stop, crash, missing result, completed scalar nonunit, "
            "or completed non-full selected module is not an emptiness verdict."
        ),
    }
    immutable_write(HERE / "jobs_manifest.json", json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    print("PREPARED_NOT_RUN")
    print(json.dumps({"strongest_job": manifest["strongest_job"], "sha256": manifest["jobs"][manifest["strongest_job"]]["sha256"]}, sort_keys=True))


if __name__ == "__main__":
    main()

