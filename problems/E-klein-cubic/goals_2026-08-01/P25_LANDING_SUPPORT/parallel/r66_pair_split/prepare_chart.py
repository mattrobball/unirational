#!/usr/bin/env python3
"""Independently regenerate the immutable r66 Stage-B q0=b1_0=1 chart."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
PACKET = P25 / "parallel" / "global_compatibility" / "support_augmented_r66_stageBC.npz"
BASELINE = P25 / "parallel" / "determinantal_cover" / "r66_stageB_qflag00_bflag0.ms"
OUTPUT = HERE / "r66_stageB_q0_1_b1_0_1_m100.ms"
MANIFEST = HERE / "input_manifest.json"

P = 89
NQ = 37
EXPECTED_PACKET_SHA256 = "b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84"
EXPECTED_INPUT_SHA256 = "9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b"
EXPECTED_INPUT_BYTES = 41_537_116
EXPECTED_TERMS = 2_363_052


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    """Enumerate exactly in increasing-first-coordinate recursive order."""
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def q_monomial(exponent: tuple[int, ...]) -> str:
    """Specialize q0=1, leaving q1,...,q36 as affine variables."""
    factors: list[str] = []
    for index, power in enumerate(exponent):
        if index == 0 or power == 0:
            continue
        factors.append(f"q{index}" if power == 1 else f"q{index}^{power}")
    return "*".join(factors) if factors else "1"


def equation(p3_row: np.ndarray, q3: list[tuple[int, ...]]) -> tuple[str, int]:
    terms: list[str] = []
    for component in range(6):
        bvar = None if component == 0 else f"b1_{component}"
        for raw, exponent in zip(p3_row[component], q3):
            coefficient = int(raw) % P
            if coefficient == 0:
                continue
            qpart = q_monomial(exponent)
            factors: list[str] = []
            if qpart != "1":
                factors.append(qpart)
            if bvar is not None:
                factors.append(bvar)
            monomial = "*".join(factors) if factors else "1"
            terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0", len(terms)


def main() -> None:
    if sha256(PACKET) != EXPECTED_PACKET_SHA256:
        raise AssertionError("r66 packet hash mismatch")
    if sha256(BASELINE) != EXPECTED_INPUT_SHA256:
        raise AssertionError("audited baseline chart hash mismatch")

    with np.load(PACKET, allow_pickle=False) as frozen:
        if sorted(frozen.files) != sorted(
            [
                "p4", "p3", "syzygies", "full_basis_columns", "added_columns",
                "prime", "full_basis_sha256", "full_p3_sha256",
                "relation_matrix_sha256", "r64_source_sha256",
            ]
        ):
            raise AssertionError("unexpected r66 packet schema")
        if int(frozen["prime"]) != P:
            raise AssertionError("r66 packet characteristic mismatch")
        p3 = frozen["p3"].astype(np.uint8)
        if frozen["p4"].shape != (66, 91_390) or p3.shape != (66, 6, 9_139):
            raise AssertionError("r66 tensor shape mismatch")

    variables = [f"b1_{j}" for j in range(1, 6)] + [f"q{i}" for i in range(1, NQ)]
    if len(variables) != 41:
        raise AssertionError("wrong affine variable count")
    q3 = weak_compositions(3, NQ)
    if len(q3) != 9_139:
        raise AssertionError("wrong cubic monomial count")

    temporary = OUTPUT.with_suffix(OUTPUT.suffix + ".tmp")
    if temporary.exists():
        raise SystemExit(f"refusing stale temporary artifact {temporary.name}")
    if OUTPUT.exists():
        if OUTPUT.stat().st_size != EXPECTED_INPUT_BYTES or sha256(OUTPUT) != EXPECTED_INPUT_SHA256:
            raise SystemExit("refusing to overwrite mismatching immutable chart")
        printed_terms = EXPECTED_TERMS
    else:
        printed_terms = 0
        with temporary.open("w") as handle:
            handle.write(",".join(variables) + "\n")
            handle.write(f"{P}\n")
            for row in range(66):
                polynomial, count = equation(p3[row], q3)
                printed_terms += count
                handle.write(polynomial)
                handle.write(",\n" if row < 65 else "\n")
            handle.flush()
            os.fsync(handle.fileno())
        if temporary.stat().st_size != EXPECTED_INPUT_BYTES:
            raise AssertionError("regenerated chart byte count mismatch")
        if sha256(temporary) != EXPECTED_INPUT_SHA256:
            raise AssertionError("regenerated chart hash mismatch")
        temporary.replace(OUTPUT)

    if printed_terms != EXPECTED_TERMS:
        raise AssertionError("regenerated printed-term count mismatch")
    if OUTPUT.read_bytes() != BASELINE.read_bytes():
        raise AssertionError("independent regeneration differs from audited chart")

    payload = {
        "status": "PASS_IMMUTABLE_R66_CHART_REGENERATED",
        "prime": P,
        "chart": {"q0": 1, "b1_0": 1},
        "equations": 66,
        "variables": 41,
        "printed_terms": printed_terms,
        "input": OUTPUT.name,
        "input_bytes": OUTPUT.stat().st_size,
        "input_sha256": sha256(OUTPUT),
        "byte_for_byte_equal_to_audited_baseline": True,
        "audited_baseline": str(BASELINE.relative_to(P25)),
        "r66_packet": str(PACKET.relative_to(P25)),
        "r66_packet_sha256": sha256(PACKET),
        "r66_p3_shape": list(p3.shape),
        "specialization": "Stage B: retain P3 only; q0=1; b1_0=1; no zero flags",
        "scope_guard": (
            "This is one affine chart only. A completed exact unit ideal proves "
            "only this chart empty; every other CAS result is a nonverdict."
        ),
    }
    encoded = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if MANIFEST.exists() and MANIFEST.read_text() != encoded:
        raise SystemExit("refusing to overwrite mismatching immutable input manifest")
    MANIFEST.write_text(encoded)
    print(payload["status"])


if __name__ == "__main__":
    main()

