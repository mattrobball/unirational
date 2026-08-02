#!/usr/bin/env python3
"""Produce the exact normalized r66 Stage-C chart on D(q0), without CAS.

The sealed tensor uses the weak-composition order in 37 q variables.  This
producer independently enumerates that order, substitutes q0=1 and b0=1,
and streams the 66 equations

    P4(q) + sum(j=0..5, P3_j(q) * b1_j) = 0

to both msolve and Singular inputs.  It refuses to overwrite a mismatching
artifact.  Running this file performs input generation only; it never starts
msolve or Singular.
"""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
from typing import Iterable

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
PACKET = P25 / "parallel" / "global_compatibility" / "support_augmented_r66_stageBC.npz"
STEM = "r66_stageC_q0_1_b0_1"
MSOLVE_INPUT = HERE / f"{STEM}.ms"
SINGULAR_INPUT = HERE / f"{STEM}.sing"
MANIFEST = HERE / f"{STEM}.json"
P = 89
NQ = 37
ROWS = 66

EXPECTED_PACKET_SHA256 = "b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84"
EXPECTED_P3_SHA256 = "00b2ea7c59b74741982d4731424ac7d19df8b31770aa1a56a190ca7c456030c9"
EXPECTED_P4_SHA256 = "32197337d815ed4b2600d3d2965499a276fab5a3589559f10d8fe2488199771b"
EXPECTED_SOURCE_HASHES = {
    "full_basis_sha256": "3571e9879bf1af6d6a405d9761522d4253e76e40edd129afd4b9363287d60ca3",
    "full_p3_sha256": "93eb010020c7b808039243cd64aede54677c95f74c17efe8e3abb03c5dbf2019",
    "relation_matrix_sha256": "6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb",
    "r64_source_sha256": "c50de97aa4fc9465793f3fe84b544731b36cec1a2807113e94817c955897be2b",
}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> Iterable[tuple[int, ...]]:
    """Yield weak compositions in the packet's recursive lexicographic order."""
    if parts == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            yield (first,) + tail


def affine_monomials(total: int) -> tuple[list[str], np.ndarray]:
    """Return q0=1 monomials and their affine q degrees in packet order."""
    monomials: list[str] = []
    degrees: list[int] = []
    for exponent in weak_compositions(total, NQ):
        factors: list[str] = []
        for index, power in enumerate(exponent[1:], start=1):
            if power:
                factors.append(f"q{index}" if power == 1 else f"q{index}^{power}")
        monomials.append("*".join(factors) if factors else "1")
        degrees.append(total - exponent[0])
    return monomials, np.asarray(degrees, dtype=np.uint8)


def encoded_term(coefficient: int, qmonomial: str, bvar: str | None) -> str:
    if bvar is None:
        monomial = qmonomial
    elif qmonomial == "1":
        monomial = bvar
    else:
        monomial = f"{bvar}*{qmonomial}"
    return monomial if coefficient == 1 else f"{coefficient}*{monomial}"


def terms_for(
    coefficients: np.ndarray, monomials: list[str], bvar: str | None
) -> tuple[list[str], np.ndarray]:
    nonzero = np.flatnonzero(coefficients)
    terms = [
        encoded_term(int(coefficients[index]) % P, monomials[int(index)], bvar)
        for index in nonzero
    ]
    return terms, nonzero


def commit_generated(temporary: Path, target: Path) -> None:
    """Install a new file, or prove a pre-existing file is byte-identical."""
    if target.exists():
        if sha256_file(temporary) != sha256_file(target):
            raise SystemExit(f"refusing to overwrite mismatching artifact {target}")
        temporary.unlink()
    else:
        os.replace(temporary, target)


def write_json_exact(path: Path, payload: dict) -> None:
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if path.exists():
        if path.read_text() != text:
            raise SystemExit(f"refusing to overwrite mismatching manifest {path}")
    else:
        path.write_text(text)


def main() -> None:
    if sha256_file(PACKET) != EXPECTED_PACKET_SHA256:
        raise AssertionError("sealed r66 packet hash mismatch")
    with np.load(PACKET, allow_pickle=False) as frozen:
        if int(frozen["prime"]) != P:
            raise AssertionError("packet prime mismatch")
        p4 = frozen["p4"]
        p3 = frozen["p3"]
        syzygies = frozen["syzygies"]
        columns = frozen["full_basis_columns"]
        added = frozen["added_columns"]
        source_hashes = {key: str(frozen[key]) for key in EXPECTED_SOURCE_HASHES}
    if p4.shape != (ROWS, 91390) or p4.dtype != np.uint8:
        raise AssertionError("P4 tensor shape/dtype mismatch")
    if p3.shape != (ROWS, 6, 9139) or p3.dtype != np.uint8:
        raise AssertionError("P3 tensor shape/dtype mismatch")
    if syzygies.shape != (ROWS, 690, NQ) or syzygies.dtype != np.uint8:
        raise AssertionError("syzygy tensor shape/dtype mismatch")
    if sha256_array(p4) != EXPECTED_P4_SHA256:
        raise AssertionError("P4 byte hash mismatch")
    if sha256_array(p3) != EXPECTED_P3_SHA256:
        raise AssertionError("P3 byte hash mismatch")
    if source_hashes != EXPECTED_SOURCE_HASHES:
        raise AssertionError("embedded upstream source ledger mismatch")
    if columns.shape != (ROWS,) or added.tolist() != [8740, 9490]:
        raise AssertionError("r66 row-selection ledger mismatch")

    q4_monomials, q4_degrees = affine_monomials(4)
    q3_monomials, q3_degrees = affine_monomials(3)
    if len(q4_monomials) != 91390 or len(q3_monomials) != 9139:
        raise AssertionError("monomial enumeration length mismatch")

    variables = [f"b1_{j}" for j in range(6)] + [f"q{i}" for i in range(1, NQ)]
    ms_tmp = MSOLVE_INPUT.with_suffix(".ms.tmp")
    sing_tmp = SINGULAR_INPUT.with_suffix(".sing.tmp")
    for stale in (ms_tmp, sing_tmp):
        if stale.exists():
            stale.unlink()

    row_audit: list[dict] = []
    global_p4_degrees = np.zeros(5, dtype=np.int64)
    global_p3_q_degrees = np.zeros((6, 4), dtype=np.int64)
    p4_total = 0
    p3_component_totals = np.zeros(6, dtype=np.int64)

    with ms_tmp.open("w") as ms, sing_tmp.open("w") as singular:
        ms.write(",".join(variables) + f"\n{P}\n")
        singular.write(
            "// Exact selected necessary equations only: q0=1, b0=1, GF(89).\n"
        )
        singular.write(
            f"// r66 packet sha256: {EXPECTED_PACKET_SHA256}\n"
        )
        singular.write(f"ring R={P},({','.join(variables)}),dp;\n")
        singular.write("option(prot);\n")

        for row in range(ROWS):
            p4_terms, p4_indices = terms_for(p4[row], q4_monomials, None)
            terms = list(p4_terms)
            row_p3_counts: list[int] = []
            row_p3_degree_counts: list[list[int]] = []
            for component in range(6):
                component_terms, indices = terms_for(
                    p3[row, component], q3_monomials, f"b1_{component}"
                )
                terms.extend(component_terms)
                count = int(len(indices))
                row_p3_counts.append(count)
                p3_component_totals[component] += count
                degree_counts = np.bincount(
                    q3_degrees[indices], minlength=4
                ).astype(np.int64)
                global_p3_q_degrees[component] += degree_counts
                row_p3_degree_counts.append(degree_counts.astype(int).tolist())
            p4_degree_counts = np.bincount(
                q4_degrees[p4_indices], minlength=5
            ).astype(np.int64)
            global_p4_degrees += p4_degree_counts
            p4_total += len(p4_indices)
            equation = "+".join(terms) if terms else "0"
            ms.write(equation)
            ms.write(",\n" if row + 1 < ROWS else "\n")
            singular.write(f"poly f{row}={equation};\n")
            row_audit.append(
                {
                    "row": row,
                    "p4_terms": int(len(p4_indices)),
                    "p4_affine_q_degree_counts_0_to_4": p4_degree_counts.astype(int).tolist(),
                    "p3_terms_by_component": row_p3_counts,
                    "p3_affine_q_degree_counts_0_to_3_by_component": row_p3_degree_counts,
                    "total_terms": len(terms),
                    "equation_sha256": hashlib.sha256(equation.encode()).hexdigest(),
                }
            )

        singular.write("ideal I=" + ",".join(f"f{i}" for i in range(ROWS)) + ";\n")
        singular.write("timer=1; ideal G=std(I); int elapsed_ms=timer;\n")
        singular.write("poly remainder_one=reduce(1,G);\n")
        singular.write("int unit=(remainder_one==0);\n")
        singular.write("int ideal_dim=dim(G);\n")
        singular.write(
            'write(\":w r66_stageC_q0_1_b0_1.singular.result.txt\",'
            '"R66_STAGEC_Q0_COMPLETE unit="+string(unit)+",dim="+string(ideal_dim)'
            '+",std_gens="+string(size(G))+",elapsed_ms="+string(elapsed_ms));\n'
        )
        singular.write("quit;\n")

    commit_generated(ms_tmp, MSOLVE_INPUT)
    commit_generated(sing_tmp, SINGULAR_INPUT)

    p3_total = int(p3_component_totals.sum())
    total_terms = int(p4_total + p3_total)
    if p4_total != int(np.count_nonzero(p4)):
        raise AssertionError("P4 term audit does not match tensor nonzeros")
    if p3_total != int(np.count_nonzero(p3)):
        raise AssertionError("P3 term audit does not match tensor nonzeros")
    if total_terms != sum(item["total_terms"] for item in row_audit):
        raise AssertionError("row/global term ledger mismatch")

    payload = {
        "status": "PREPARED_NOT_RUN",
        "scope": "one normalized selected Stage-C chart D(q0), b0=1 only",
        "prime": P,
        "normalization": {"q0": 1, "b0": 1},
        "equations": ROWS,
        "variables": len(variables),
        "variable_order": variables,
        "maximum_ordinary_total_degree": 4,
        "packet": str(PACKET.relative_to(P25)),
        "packet_sha256": EXPECTED_PACKET_SHA256,
        "packet_arrays": {
            "p4_shape": list(p4.shape),
            "p4_sha256": EXPECTED_P4_SHA256,
            "p3_shape": list(p3.shape),
            "p3_sha256": EXPECTED_P3_SHA256,
            "syzygies_shape": list(syzygies.shape),
            "syzygies_sha256": sha256_array(syzygies),
            "full_basis_columns": columns.astype(int).tolist(),
            "full_basis_columns_sha256": sha256_array(columns),
            "added_columns": added.astype(int).tolist(),
        },
        "upstream_hash_ledger": source_hashes,
        "term_audit": {
            "p4_terms": int(p4_total),
            "p3_terms": p3_total,
            "p3_terms_by_component": p3_component_totals.astype(int).tolist(),
            "total_terms": total_terms,
            "p4_affine_q_degree_counts_0_to_4": global_p4_degrees.astype(int).tolist(),
            "p3_affine_q_degree_counts_0_to_3_by_component": global_p3_q_degrees.astype(int).tolist(),
            "rows": row_audit,
        },
        "inputs": {
            "msolve": {
                "file": MSOLVE_INPUT.name,
                "bytes": MSOLVE_INPUT.stat().st_size,
                "sha256": sha256_file(MSOLVE_INPUT),
            },
            "singular": {
                "file": SINGULAR_INPUT.name,
                "bytes": SINGULAR_INPUT.stat().st_size,
                "sha256": sha256_file(SINGULAR_INPUT),
                "completion_sentinel_prefix": "R66_STAGEC_Q0_COMPLETE",
            },
        },
        "criterion": (
            "A completed exact unit ideal proves this selected affine chart empty. "
            "Every other outcome is a nonverdict and has no global Stage-C/P25 force."
        ),
        "cas_launched": False,
    }
    write_json_exact(MANIFEST, payload)
    print(json.dumps({
        "status": payload["status"],
        "equations": ROWS,
        "variables": len(variables),
        "total_terms": total_terms,
        "msolve_bytes": MSOLVE_INPUT.stat().st_size,
        "singular_bytes": SINGULAR_INPUT.stat().st_size,
    }, sort_keys=True))


if __name__ == "__main__":
    main()

