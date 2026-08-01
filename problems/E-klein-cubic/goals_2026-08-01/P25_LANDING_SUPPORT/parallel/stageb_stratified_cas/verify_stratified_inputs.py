#!/usr/bin/env python3
"""Verify every input and generated job in the L8 stratified packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
ROOT = HERE.parents[3]
GLOBAL = P25 / "parallel" / "stageb_global_basis"
STRATA = P25 / "parallel" / "stageb_strata"
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
NEW_PACKET = GLOBAL / "support_balanced_r43_stageBC.npz"
NEW_REPLAY = GLOBAL / "verify_sparse_packet_result.json"
OLD_SYZYGIES = P25 / "linear_syzygies_r48_reconstructed.npz"
OLD_PACKET = P25 / "syzygy_r48_q0_contracted.npz"
CLOSED_CERT = STRATA / "closed_L_degree6_certificate.json"
CLOSED_VERIFY = STRATA / "verify_closed_L_degree6_result.json"
METADATA = HERE / "stratified_jobs.json"
OUTPUT = HERE / "verify_stratified_inputs_result.json"

P = 89
NQ = 37
H8 = tuple(list(range(4)) + list(range(12, 37)))


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


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(target)}
    answer = np.empty((NQ, len(source)), dtype=np.int32)
    for variable in range(NQ):
        for source_index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, source_index] = target_index[tuple(exponent)]
    return answer


def direct_syzygy_check(syzygy: np.ndarray, m2: np.ndarray) -> bool:
    raw = (
        syzygy.T.astype(np.int64) @ m2.reshape(690, -1).astype(np.int64)
    ) % P
    raw = raw.reshape(NQ, 21, NQ)
    for u in range(NQ):
        if np.any(raw[u, :, u]):
            return False
        for v in range(u + 1, NQ):
            if np.any((raw[u, :, v] + raw[v, :, u]) % P):
                return False
    return True


def contract_batch(
    syzygies: np.ndarray,
    blocks: np.ndarray,
    components: int,
    source_monomials: int,
    product_map: np.ndarray,
    target_monomials: int,
) -> np.ndarray:
    rows = len(syzygies)
    output = np.zeros((rows, components, target_monomials), dtype=np.uint8)
    block_double = np.ascontiguousarray(blocks, dtype=np.float64)
    for variable in range(NQ):
        product = (
            np.ascontiguousarray(syzygies[:, :, variable], dtype=np.float64)
            @ block_double
        )
        np.remainder(product, float(P), out=product)
        addition = product.astype(np.uint8).reshape(rows, components, source_monomials)
        indices = product_map[variable]
        for component in range(components):
            updated = output[:, component, indices].astype(np.uint16)
            updated += addition[:, component]
            np.remainder(updated, P, out=updated)
            output[:, component, indices] = updated.astype(np.uint8)
    return output


def main() -> None:
    required = [
        RELATION,
        NEW_PACKET,
        NEW_REPLAY,
        OLD_SYZYGIES,
        OLD_PACKET,
        CLOSED_CERT,
        CLOSED_VERIFY,
        METADATA,
    ]
    for path in required:
        if not path.is_file():
            raise FileNotFoundError(path)

    with NEW_REPLAY.open() as handle:
        new_replay = json.load(handle)
    if new_replay.get("status") != "PASS_EXACT_PACKET_REPLAY":
        raise AssertionError("new r43 exact replay is not PASS")
    replay_hashes = new_replay.get("hashes", {})
    packet_key = str(NEW_PACKET)
    if replay_hashes.get(packet_key) != sha256(NEW_PACKET):
        raise AssertionError("new r43 packet/replay hash mismatch")

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    with np.load(OLD_SYZYGIES, allow_pickle=False) as frozen:
        syzygies = frozen["syzygies"].astype(np.uint8)
        chosen = frozen["chosen_syzygies"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("old syzygy prime mismatch")
    with np.load(OLD_PACKET, allow_pickle=False) as frozen:
        stored_p3 = frozen["p3"].astype(np.uint8)
        stored_p4 = frozen["p4"].astype(np.uint8)
        stored_chosen = frozen["chosen_syzygies"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("old contraction prime mismatch")
    if syzygies.shape != (48, 690, NQ):
        raise AssertionError("old syzygy shape mismatch")
    if stored_p3.shape != (48, 6, 9139) or stored_p4.shape != (48, 91390):
        raise AssertionError("old contraction shape mismatch")
    if not np.array_equal(chosen, stored_chosen):
        raise AssertionError("old syzygy selection mismatch")

    q1 = weak_compositions(1, NQ)
    q2 = weak_compositions(2, NQ)
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    variable_of = [monomial.index(1) for monomial in q1]
    m2 = np.empty((690, 21, NQ), dtype=np.uint8)
    for component in range(21):
        block = seeds[
            :, int(offsets[7 + component]) : int(offsets[8 + component])
        ]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, component, variable] = block[:, monomial_index]
    for row, syzygy in enumerate(syzygies):
        if not direct_syzygy_check(syzygy, m2):
            raise AssertionError(f"old syzygy {row} fails C(q)M2(q)=0")

    map23 = multiplication_map(q2, q3)
    m1_blocks = np.concatenate(
        [
            seeds[:, int(offsets[1 + component]) : int(offsets[2 + component])]
            for component in range(6)
        ],
        axis=1,
    )
    rebuilt_p3 = contract_batch(
        syzygies, m1_blocks, 6, len(q2), map23, len(q3)
    )
    if not np.array_equal(rebuilt_p3, stored_p3):
        raise AssertionError("old r48 P3 reconstruction failed")

    map34 = multiplication_map(q3, q4)
    b0_block = seeds[:, int(offsets[0]) : int(offsets[1])]
    rebuilt_p4 = contract_batch(
        syzygies, b0_block, 1, len(q3), map34, len(q4)
    )[:, 0]
    if not np.array_equal(rebuilt_p4, stored_p4):
        raise AssertionError("old r48 P4 reconstruction failed")

    with CLOSED_VERIFY.open() as handle:
        closed = json.load(handle)
    if closed.get("status") != "PASS" or closed.get("determinant_mod_89") != 28:
        raise AssertionError("closed L8 independent certificate failed")
    if closed.get("certificate_sha256") != sha256(CLOSED_CERT):
        raise AssertionError("closed L8 certificate hash mismatch")

    with METADATA.open() as handle:
        metadata = json.load(handle)
    if metadata.get("status") != "JOBS_GENERATED_NOT_LAUNCHED":
        raise AssertionError("job metadata status changed")
    if metadata["open_complement"]["outside_coordinates"] != list(H8):
        raise AssertionError("wrong H8 coordinate set")
    if metadata["open_complement"]["saturation_order_stageB"] != [
        "H8",
        "b1 irrelevant ideal",
    ]:
        raise AssertionError("unsafe Stage-B saturation order")

    script_hashes: dict[str, str] = {}
    for name, job in metadata["jobs"].items():
        script = HERE / job["script"]
        if sha256(script) != job["script_sha256"]:
            raise AssertionError(f"generated script hash mismatch: {name}")
        text = script.read_text()
        expected_hideal = "ideal hideal=" + ",".join(f"q{i}" for i in H8) + ";"
        if expected_hideal not in text:
            raise AssertionError(f"wrong H8 definition: {name}")
        if name.startswith("stageB_"):
            first = text.index("ideal JH=sat(I,hideal)")
            second = text.index("ideal J=sat(JH,bideal)")
            if first >= second:
                raise AssertionError(f"H8 saturation is not first: {name}")
        else:
            if "ideal J=sat(I,hideal)" not in text:
                raise AssertionError("Stage-C complement does not saturate by H8")
        script_hashes[name] = sha256(script)

    payload = {
        "status": "PASS_STRATIFIED_INPUT_REPLAY",
        "prime": P,
        "relation_matrix_sha256": sha256(RELATION),
        "new_r43_packet_sha256": sha256(NEW_PACKET),
        "new_r43_upstream_replay_sha256": sha256(NEW_REPLAY),
        "old_r48_syzygies_sha256": sha256(OLD_SYZYGIES),
        "old_r48_contractions_sha256": sha256(OLD_PACKET),
        "old_r48_syzygies_checked": 48,
        "old_r48_p3_rows_rebuilt": 48,
        "old_r48_p4_rows_rebuilt": 48,
        "closed_L8_certificate_sha256": sha256(CLOSED_CERT),
        "closed_L8_independent_replay_sha256": sha256(CLOSED_VERIFY),
        "H8_coordinates": list(H8),
        "generated_script_hashes": script_hashes,
        "jobs_launched": False,
        "scope": "Exact input and script replay only; no open-complement saturation result.",
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS: stratified Stage-B/Stage-C inputs and H8-first scripts replayed")


if __name__ == "__main__":
    main()

