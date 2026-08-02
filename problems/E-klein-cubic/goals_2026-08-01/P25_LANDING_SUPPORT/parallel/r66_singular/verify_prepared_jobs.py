#!/usr/bin/env python3
"""Independent, CAS-free audit of the prepared exact r66 jobs."""

from __future__ import annotations

import hashlib
import json
from math import comb
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
PACKET = P25 / "parallel" / "global_compatibility" / "support_augmented_r66_stageBC.npz"
EXPECTED_PACKET = "b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84"
EXPECTED_MS = "9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b"
P = 89
NQ = 37


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            answer.append((first,) + tail)
    return answer


def qterm(exponent: tuple[int, ...]) -> str:
    factors = []
    for index in range(1, NQ):
        power = exponent[index]
        if power:
            factors.append(f"q{index}" if power == 1 else f"q{index}^{power}")
    return "*".join(factors) if factors else "1"


def polynomial(coefficients: np.ndarray, monomials: list[tuple[int, ...]]) -> str:
    terms = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if coefficient:
            monomial = qterm(exponent)
            terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def dp_key(exponents: tuple[int, ...]) -> tuple[int, tuple[int, ...]]:
    return sum(exponents), tuple(-value for value in reversed(exponents))


def leading_profile(p3: np.ndarray, q3: list[tuple[int, ...]], order: str) -> dict:
    leads: list[tuple[int, ...]] = []
    components: list[int] = []
    for row in range(66):
        best_key = None
        best_exp = None
        best_component = -1
        for component in range(6):
            b = [0] * 5
            if component:
                b[component - 1] = 1
            for raw, exponent in zip(p3[row, component], q3):
                if not int(raw) % P:
                    continue
                q = list(exponent[1:])
                exponents = tuple(q + b if order == "qfirst" else b + q)
                key = dp_key(exponents)
                if best_key is None or key > best_key:
                    best_key = key
                    best_exp = exponents
                    best_component = component
        if best_exp is None:
            raise AssertionError("zero scalar equation")
        leads.append(best_exp)
        components.append(best_component)
    multiplicities: dict[tuple[int, ...], int] = {}
    for lead in leads:
        multiplicities[lead] = multiplicities.get(lead, 0) + 1
    component_census = {str(i): components.count(i) for i in range(6)}
    return {
        "variable_order": order,
        "leading_component_census": component_census,
        "distinct_initial_leading_monomials": len(multiplicities),
        "equal_leading_monomial_pairs": sum(comb(count, 2) for count in multiplicities.values()),
        "max_equal_leading_multiplicity": max(multiplicities.values()),
        "scope": "input-leading-term scheduling diagnostic only; not a Groebner or emptiness certificate",
    }


def main() -> None:
    manifest = json.loads((HERE / "jobs_manifest.json").read_text())
    if manifest["status"] != "PREPARED_NOT_RUN":
        raise AssertionError("status drift")
    if sha256(PACKET) != EXPECTED_PACKET or manifest["packet_sha256"] != EXPECTED_PACKET:
        raise AssertionError("r66 packet provenance mismatch")
    for name, entry in {**manifest["includes"], **manifest["jobs"]}.items():
        path = HERE / name
        if not path.is_file() or path.stat().st_size != entry["bytes"] or sha256(path) != entry["sha256"]:
            raise AssertionError(f"immutable artifact mismatch: {name}")

    scalar = (HERE / "r66_stageB_q0_1_b10_1_equations.inc").read_text()
    if not scalar.startswith("ideal I=\n") or not scalar.endswith(";\n"):
        raise AssertionError("malformed scalar include")
    body = scalar[len("ideal I=\n") : -2]
    equations = body.split(",\n")
    if len(equations) != 66 or any("q0" in equation or "b1_0" in equation for equation in equations):
        raise AssertionError("affine substitution or equation count mismatch")
    canonical = hashlib.sha256()
    variables = [f"b1_{j}" for j in range(1, 6)] + [f"q{i}" for i in range(1, NQ)]
    canonical.update((",".join(variables) + f"\n{P}\n").encode())
    for row, equation in enumerate(equations):
        canonical.update(equation.encode())
        canonical.update(b",\n" if row < 65 else b"\n")
    if canonical.hexdigest() != EXPECTED_MS or manifest["canonical_msolve_sha256"] != EXPECTED_MS:
        raise AssertionError("canonical independent affine-chart hash mismatch")

    with np.load(PACKET, allow_pickle=False) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        if int(frozen["prime"]) != P or p3.shape != (66, 6, 9139):
            raise AssertionError("P3 tensor semantics mismatch")
    q3 = weak_compositions(3, NQ)
    module_hash = hashlib.sha256()
    module_hash.update(b"module N=\n")
    for row in range(66):
        entries = [polynomial(p3[row, component], q3) for component in range(6)]
        module_hash.update(("[" + ",".join(entries) + "]").encode())
        module_hash.update(b",\n" if row < 65 else b";\n")
    expected_module_hash = manifest["includes"]["r66_stageB_q0_1_module.inc"]["sha256"]
    if module_hash.hexdigest() != expected_module_hash:
        raise AssertionError("independent module reconstruction mismatch")

    qvars = ",".join(f"q{i}" for i in range(1, NQ))
    bvars = ",".join(f"b1_{j}" for j in range(1, 6))
    for name in manifest["jobs"]:
        raw = (HERE / name).read_text()
        if "ring R=89" not in raw or "option(prot);" not in raw or "degBound" in raw or "option(redSB)" in raw:
            raise AssertionError(f"unsafe or inexact job declaration: {name}")
        if "slimgb" in name:
            if "ideal G=slimgb(I);" not in raw or "option(notBuckets)" in raw:
                raise AssertionError("slimgb job syntax/option mismatch")
        elif "module" in name:
            if f"ring R=89,({qvars}),(dp,C);" not in raw or "module G=std(N);" not in raw:
                raise AssertionError("module ring/order mismatch")
            if "option(notBuckets);" not in raw or "freemodule(6)" not in raw:
                raise AssertionError("module criterion mismatch")
        else:
            if "ideal G=std(I);" not in raw or "option(notBuckets);" not in raw:
                raise AssertionError("scalar std memory mode mismatch")
            expected = f"ring R=89,({qvars},{bvars}),dp;" if "qfirst" in name else f"ring R=89,({bvars},{qvars}),dp;"
            if expected not in raw:
                raise AssertionError("scalar variable order mismatch")

    forbidden = list(HERE.glob("*.run.json")) + list(HERE.glob("*.log")) + list(HERE.glob("*.result.txt"))
    if forbidden:
        raise AssertionError(f"jobs were unexpectedly launched: {[path.name for path in forbidden]}")
    profiles = {
        "status": "PASS_CAS_FREE_INPUT_LEADING_PROFILES",
        "qfirst": leading_profile(p3, q3, "qfirst"),
        "bfirst": leading_profile(p3, q3, "bfirst"),
        "warning": "These exact input-leading profiles are scheduling evidence only.",
    }
    (HERE / "leading_profiles.json").write_text(json.dumps(profiles, indent=2, sort_keys=True) + "\n")
    result = {
        "status": "PASS_R66_SINGULAR_PREPARED_NOT_RUN_AUDIT",
        "field": "F_89",
        "packet_sha256": EXPECTED_PACKET,
        "canonical_affine_chart_sha256": EXPECTED_MS,
        "module_include_sha256": expected_module_hash,
        "strongest_job": manifest["strongest_job"],
        "strongest_job_sha256": manifest["jobs"][manifest["strongest_job"]]["sha256"],
        "cas_launched": False,
        "theorem_status": "P25-UNDECIDED",
    }
    (HERE / "verify_prepared_jobs_result.json").write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS_R66_SINGULAR_PREPARED_NOT_RUN_AUDIT")


if __name__ == "__main__":
    main()

