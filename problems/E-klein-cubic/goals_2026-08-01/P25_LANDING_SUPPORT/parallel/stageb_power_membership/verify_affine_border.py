#!/usr/bin/env python3
"""Independent exact replay of the axis-0 affine-border packet.

This verifier deliberately does not import the producer or reducer.  It
reconstructs the affine monomial partition from the sealed P3 tensor, checks
the selected inverse exactly over F_89, and recomputes every normalized pure
cubic tail in bounded column chunks.  It also binds the stored nonzero border
remainder and bounded Singular run to their sealed bytes.

Passing this verifier certifies the normalized border subsystem and the fact
that the chosen deterministic reduction has a nonzero stored remainder.  It
does not certify nonmembership: cubic-only relations and border ambiguities
are not quotiented here.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import time

import numpy as np


P = 89
NQ = 37
R = 10767
AXIS = 0
HERE = Path(__file__).resolve().parent
P3_PATH = HERE.parent / "stageb_global_basis" / "full_p3_contractions.npy"

EXPECTED = {
    "p3_file": "93eb010020c7b808039243cd64aede54677c95f74c17efe8e3abb03c5dbf2019",
    "selected_file": "9399ceda054a7c6e49ab856f4bb8e77a2ee3cee2ede152ac78621fa3c5ba60ee",
    "inverse_file": "39f65bd254787b16b887126f579a611a4e4c008df4324f0c1f026a78b531707f",
    "inverse_data": "8ba1074907d53fb7e7bb244deebd7a69e98ed179f43b9f1c1beaf472ffe1585f",
    "low_data": "700b95dd3e441872a06ff2742e5ea0266070373b7bbfc4a7289c5943dc72c45d",
    "minor_data": "bd9a6a1b73a2b89f76a2ff78ad72ba99664a5598c0fd5ba5e9152dab89819fc8",
    "tails_file": "badcbf56207481ba5350f1547d7a88aec3ed846ce0e672f3ba4f1f56e006f25d",
    "tails_data": "1d139e8fc969a177e3e64b9525560d35202dd12abfa5d41b2652784e41d55eb6",
    "packet_file": "147306837c5077d6b917a8d6392ff43297fecc4faf12254153e09a8a05c41aa2",
    "reduction_file": "ef3111f516522558d1f8920dad6e711c62421c7d350be14a47c5ac16ad3270f2",
    "terminal_data": "bc38ad975f5da24460257426fa71474104aa14150887ede93ef61dd11470a0d9",
    "singular_input_file": "2394fd6136f4f8c3c3266513e8db516019fa38f257952115f4a04271ac67b65c",
    "singular_log_file": "c0ec66a7a03af58bbbc6ecabe80194f3ae08b14c55b62cbd98e7b71e3502ecd8",
}


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            answer.append((first,) + tail)
    return answer


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> None:
    started = time.monotonic()
    selected_path = HERE / "axis0_selected_rows.npy"
    inverse_path = HERE / "axis0_low_inverse.npy"
    tails_path = HERE / "axis0_border_tails.npy"
    packet_path = HERE / "axis0_border_packet.npz"
    reduction_path = HERE / "axis0_border_reduction.npz"
    singular_input_path = HERE / "direct_axis0_component0_degree5.sing"
    singular_log_path = HERE / "direct_axis0_component0_degree5.log"
    singular_run_path = HERE / "direct_axis0_component0_degree5.run.json"

    file_checks = {
        "p3_file": sha256_file(P3_PATH),
        "selected_file": sha256_file(selected_path),
        "inverse_file": sha256_file(inverse_path),
        "tails_file": sha256_file(tails_path),
        "packet_file": sha256_file(packet_path),
        "reduction_file": sha256_file(reduction_path),
        "singular_input_file": sha256_file(singular_input_path),
        "singular_log_file": sha256_file(singular_log_path),
    }
    for key, actual in file_checks.items():
        require(actual == EXPECTED[key], f"sealed file hash mismatch: {key}")
    print("sealed file hashes: PASS", flush=True)

    p3 = np.load(P3_PATH, mmap_mode="r")
    require(p3.shape == (R, 6, 9139), f"unexpected P3 shape {p3.shape}")
    require(p3.dtype == np.uint8, f"unexpected P3 dtype {p3.dtype}")
    require(int(np.max(p3)) < P, "P3 contains a noncanonical coefficient")

    q3 = weak_compositions(3, NQ)
    require(len(q3) == 9139, "cubic monomial census changed")
    affine_degree = np.asarray([3 - monomial[AXIS] for monomial in q3])
    low_monomials = np.flatnonzero(affine_degree <= 2).astype(np.int32)
    high_monomials = np.flatnonzero(affine_degree == 3).astype(np.int32)
    require(low_monomials.shape == (703,), "low monomial census changed")
    require(high_monomials.shape == (8436,), "pure cubic census changed")
    low_columns = np.asarray(
        [component * len(q3) + int(index)
         for component in range(6) for index in low_monomials],
        dtype=np.int32,
    )
    high_columns = np.asarray(
        [component * len(q3) + int(index)
         for component in range(6) for index in high_monomials],
        dtype=np.int32,
    )

    with np.load(packet_path, allow_pickle=False) as packet:
        require(int(packet["axis"]) == AXIS, "packet axis mismatch")
        require(int(packet["prime"]) == P, "packet prime mismatch")
        require(np.array_equal(packet["low_monomials"], low_monomials),
                "packet low monomial order mismatch")
        require(np.array_equal(packet["high_monomials"], high_monomials),
                "packet high monomial order mismatch")
        require(np.array_equal(packet["low_columns"], low_columns),
                "packet low column order mismatch")
        require(np.array_equal(packet["high_columns"], high_columns),
                "packet high column order mismatch")
        require(str(packet["low_block_sha256"]) == EXPECTED["low_data"],
                "packet low-block digest mismatch")
        require(str(packet["minor_sha256"]) == EXPECTED["minor_data"],
                "packet minor digest mismatch")
        require(str(packet["inverse_data_sha256"]) == EXPECTED["inverse_data"],
                "packet inverse digest mismatch")
        require(str(packet["tails_data_sha256"]) == EXPECTED["tails_data"],
                "packet tail digest mismatch")

    flat = p3.reshape(R, -1)
    low = np.ascontiguousarray(flat[:, low_columns], dtype=np.uint8)
    require(low.shape == (R, 4218), "unexpected low block shape")
    require(sha256_array(low) == EXPECTED["low_data"],
            "reconstructed low-block digest mismatch")
    selected = np.load(selected_path, allow_pickle=False)
    inverse = np.load(inverse_path, allow_pickle=False)
    require(selected.shape == (4218,) and selected.dtype == np.int32,
            "unexpected selected-row array")
    require(len(np.unique(selected)) == 4218, "selected rows are not unique")
    require(int(np.min(selected)) >= 0 and int(np.max(selected)) < R,
            "selected row outside P3 range")
    require(inverse.shape == (4218, 4218) and inverse.dtype == np.uint8,
            "unexpected inverse array")
    require(int(np.max(inverse)) < P, "inverse has noncanonical coefficients")
    require(sha256_array(inverse) == EXPECTED["inverse_data"],
            "inverse canonical-data digest mismatch")
    minor = np.ascontiguousarray(low[selected], dtype=np.uint8)
    require(sha256_array(minor) == EXPECTED["minor_data"],
            "selected-minor digest mismatch")
    del low

    # The integer dot-product bound 4218*88^2 is below 2^53, so the
    # float64 GEMM followed by reduction modulo 89 is exact over F_89.
    left = inverse.astype(np.float64)
    product = left @ minor.astype(np.float64)
    np.remainder(product, float(P), out=product)
    require(np.array_equal(product.astype(np.uint8),
                           np.eye(4218, dtype=np.uint8)),
            "stored matrix is not a left inverse of the selected minor")
    del product, minor
    print("selected inverse over F_89: PASS", flush=True)

    tails = np.load(tails_path, mmap_mode="r")
    require(tails.shape == (4218, 50616) and tails.dtype == np.uint8,
            "unexpected tail array")
    tail_digest = hashlib.sha256()
    for row_start in range(0, 4218, 32):
        tail_digest.update(np.ascontiguousarray(tails[row_start:row_start + 32]).tobytes())
    require(tail_digest.hexdigest() == EXPECTED["tails_data"],
            "tail canonical-data digest mismatch")

    chunk = 512
    for start in range(0, len(high_columns), chunk):
        end = min(len(high_columns), start + chunk)
        columns = high_columns[start:end]
        right = np.ascontiguousarray(
            flat[selected[:, None], columns[None, :]], dtype=np.float64
        )
        recomputed = left @ right
        np.remainder(recomputed, float(P), out=recomputed)
        require(np.array_equal(recomputed.astype(np.uint8), tails[:, start:end]),
                f"normalized tail mismatch in columns {start}:{end}")
        print(f"normalized tails {end}/{len(high_columns)}: PASS", flush=True)
        del right, recomputed
    del left

    with np.load(reduction_path, allow_pickle=False) as reduction:
        require(int(reduction["axis"]) == AXIS, "reduction axis mismatch")
        require(int(reduction["prime"]) == P, "reduction prime mismatch")
        require(np.array_equal(reduction["target_components"],
                               np.asarray([0], dtype=np.int8)),
                "reduction target mismatch")
        terminal = reduction["terminal_degree5"]
        lifts = reduction["normalized_lifts"]
        require(terminal.shape == (1, 6, 658008) and terminal.dtype == np.uint8,
                "unexpected terminal remainder")
        require(lifts.shape == (1, 4218, 703) and lifts.dtype == np.uint8,
                "unexpected normalized lift")
        require(int(np.max(terminal)) < P and int(np.max(lifts)) < P,
                "reduction contains a noncanonical coefficient")
        require(int(np.count_nonzero(terminal)) == 3_879_712,
                "terminal nonzero count mismatch")
        require(int(np.count_nonzero(lifts)) == 529_886,
                "lift nonzero count mismatch")
        require(sha256_array(terminal[0]) == EXPECTED["terminal_data"],
                "terminal canonical-data digest mismatch")
        require(str(reduction["border_packet_sha256"]) == EXPECTED["packet_file"],
                "reduction packet binding mismatch")
        require(str(reduction["border_tails_sha256"]) == EXPECTED["tails_file"],
                "reduction tail-file binding mismatch")
        require(str(reduction["border_tails_data_sha256"]) == EXPECTED["tails_data"],
                "reduction tail-data binding mismatch")
        require(str(reduction["border_inverse_sha256"]) == EXPECTED["inverse_file"],
                "reduction inverse binding mismatch")

    run = json.loads(singular_run_path.read_text())
    require(run["stop_reason"] == "timeout", "Singular stop reason changed")
    require(run["complete"] is False and run["returncode"] == -9,
            "Singular run unexpectedly marked complete")
    require(run["input_sha256"] == EXPECTED["singular_input_file"],
            "Singular input binding mismatch")
    require(run["log_sha256"] == EXPECTED["singular_log_file"],
            "Singular log binding mismatch")
    require(run["timeout_seconds"] == 300.0,
            "Singular timeout bound mismatch")
    require(run["rss_limit_bytes"] == 8_589_934_592,
            "Singular RSS bound mismatch")
    require(run["peak_rss_bytes_polled"] == 1_281_376_256,
            "Singular peak RSS record mismatch")

    result = {
        "status": "PASS_EXACT_BORDER_NONVERDICT_REPLAY",
        "prime": P,
        "axis": AXIS,
        "source_p3_sha256": EXPECTED["p3_file"],
        "checks": {
            "sealed_file_hashes": True,
            "affine_partition_dimensions": [6, 222, 4218, 50616],
            "selected_minor_inverse_exact": True,
            "all_50616_normalized_tail_columns_recomputed": True,
            "stored_terminal_remainder_nonzero": True,
            "stored_terminal_remainder_nnz": 3_879_712,
            "bounded_singular_run_stopped_by_timeout": True,
        },
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "scope": (
            "Exact replay of the normalized axis-0 affine border and byte binding "
            "of its nonzero deterministic remainder. This is not a nonmembership "
            "certificate: cubic-only relations and border ambiguities remain."
        ),
    }
    result_path = HERE / "verify_affine_border_result.json"
    result_path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(json.dumps(result, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
