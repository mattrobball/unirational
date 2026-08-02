#!/usr/bin/env python3
"""Constant-row-precondition the exact r66 module, without launching Singular."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
PACKET = P25 / "parallel" / "global_compatibility" / "support_augmented_r66_stageBC.npz"
EXPECTED_PACKET = "b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84"
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
    return [(i,) + tail for i in range(total + 1) for tail in weak_compositions(total - i, parts - 1)]


def dp_key(exponents: tuple[int, ...]) -> tuple[int, tuple[int, ...]]:
    return sum(exponents), tuple(-value for value in reversed(exponents))


def polynomial(coefficients: np.ndarray, monomials: list[tuple[int, ...]]) -> str:
    terms = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        factors = []
        for variable in range(1, NQ):
            power = exponent[variable]
            if power:
                factors.append(f"q{variable}" if power == 1 else f"q{variable}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def immutable_write(path: Path, content: str) -> None:
    if path.exists():
        if path.read_text() != content:
            raise SystemExit(f"refusing to overwrite mismatching immutable file {path}")
    else:
        path.write_text(content)


def main() -> None:
    if sha256(PACKET) != EXPECTED_PACKET:
        raise AssertionError("r66 packet hash mismatch")
    with np.load(PACKET, allow_pickle=False) as frozen:
        p3 = frozen["p3"].astype(np.int64)
        if int(frozen["prime"]) != P or p3.shape != (66, 6, 9139):
            raise AssertionError("r66 P3 mismatch")
    q3 = weak_compositions(3, NQ)
    term_columns = [
        (dp_key(tuple(exponent[1:])), component, component * len(q3) + monomial)
        for component in range(6)
        for monomial, exponent in enumerate(q3)
    ]
    order = np.asarray([entry[2] for entry in sorted(term_columns, reverse=True)], dtype=np.int32)
    work = p3.reshape(66, -1)[:, order].copy()
    transform = np.eye(66, dtype=np.int64)
    pivots: list[int] = []
    rank = 0
    for column in range(work.shape[1]):
        candidates = np.flatnonzero(work[rank:, column] % P)
        if not len(candidates):
            continue
        pivot = rank + int(candidates[0])
        if pivot != rank:
            work[[rank, pivot]] = work[[pivot, rank]]
            transform[[rank, pivot]] = transform[[pivot, rank]]
        inverse = pow(int(work[rank, column]) % P, -1, P)
        work[rank] = work[rank] * inverse % P
        transform[rank] = transform[rank] * inverse % P
        factors = work[:, column].copy() % P
        factors[rank] = 0
        work = (work - factors[:, None] * work[rank]) % P
        transform = (transform - factors[:, None] * transform[rank]) % P
        pivots.append(column)
        rank += 1
        if rank == 66:
            break
    if rank != 66:
        raise AssertionError("r66 module rows lost rank over F_89")
    if any(int(work[row, pivots[row]]) != 1 for row in range(66)):
        raise AssertionError("pivot normalization failed")
    pivot_block = work[:, pivots] % P
    if not np.array_equal(pivot_block, np.eye(66, dtype=np.int64)):
        raise AssertionError("RREF pivot block is not identity")
    restored = np.empty_like(work)
    restored[:, order] = work
    preconditioned = restored.reshape(66, 6, 9139).astype(np.uint8)

    certificate = HERE / "module_preconditioner.npz"
    if not certificate.exists():
        np.savez_compressed(
            certificate,
            transform=transform.astype(np.uint8),
            ordered_columns=order,
            pivot_positions=np.asarray(pivots, dtype=np.int32),
            preconditioned_p3=preconditioned,
            prime=np.int32(P),
            packet_sha256=np.asarray(EXPECTED_PACKET),
        )
    else:
        with np.load(certificate, allow_pickle=False) as frozen:
            if not np.array_equal(frozen["transform"], transform.astype(np.uint8)):
                raise SystemExit("immutable preconditioner mismatch")

    include = HERE / "r66_stageB_q0_1_module_preconditioned.inc"
    if not include.exists():
        with include.open("w") as stream:
            stream.write("module N=\n")
            for row in range(66):
                entries = [polynomial(preconditioned[row, component], q3) for component in range(6)]
                stream.write("[" + ",".join(entries) + "]")
                stream.write(",\n" if row < 65 else ";\n")

    job_name = "r66_stageB_q0_1_all_b_module_preconditioned_std_notBuckets.sing"
    qvars = [f"q{i}" for i in range(1, NQ)]
    job = "\n".join(
        [
            f"ring R={P},({','.join(qvars)}),(dp,C);",
            "option(prot);",
            "option(notBuckets);",
            'execute(read("r66_stageB_q0_1_module_preconditioned.inc"));',
            'print("R66_PRECONDITIONED_MODULE_INPUT characteristic="+string(char(R))+",vars="+string(nvars(R))+",rows="+string(size(N)));',
            "timer=1;",
            "module G=std(N);",
            "int elapsed=timer;",
            "module rem=simplify(reduce(freemodule(6),G),2);",
            "int remainder_zero=(size(rem)==0);",
            "int quotient_dim=dim(G);",
            "int full=(remainder_zero && quotient_dim==-1);",
            'print("R66_PRECONDITIONED_MODULE_RESULT full="+string(full)+",remainder_zero="+string(remainder_zero)+",quotient_dim="+string(quotient_dim)+",basis_gens="+string(size(G))+",elapsed_ms="+string(elapsed));',
            'write(":w r66_stageB_q0_1_all_b_module_preconditioned_std_notBuckets.result.txt","full="+string(full)+",remainder_zero="+string(remainder_zero)+",quotient_dim="+string(quotient_dim)+",basis_gens="+string(size(G))+",elapsed_ms="+string(elapsed));',
            "quit;",
            "",
        ]
    )
    immutable_write(HERE / job_name, job)
    payload = {
        "status": "PREPARED_NOT_RUN",
        "prime": P,
        "packet_sha256": EXPECTED_PACKET,
        "transform_rank": rank,
        "pivot_count": len(pivots),
        "pivot_block_identity": True,
        "proof": "The invertible constant 66x66 transform preserves the row module exactly.",
        "certificate": {"file": certificate.name, "bytes": certificate.stat().st_size, "sha256": sha256(certificate)},
        "include": {"file": include.name, "bytes": include.stat().st_size, "sha256": sha256(include)},
        "job": {"file": job_name, "bytes": (HERE / job_name).stat().st_size, "sha256": sha256(HERE / job_name)},
        "criterion": "A completed full=1 proves N=R^6 on q0=1 and excludes all Stage-B b1 directions there.",
        "cas_launched": False,
    }
    immutable_write(HERE / "preconditioned_manifest.json", json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PREPARED_NOT_RUN")
    print(json.dumps(payload["job"], sort_keys=True))


if __name__ == "__main__":
    main()

