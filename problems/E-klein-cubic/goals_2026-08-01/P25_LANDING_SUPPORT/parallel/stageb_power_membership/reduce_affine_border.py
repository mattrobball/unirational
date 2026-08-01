#!/usr/bin/env python3
"""Triangularly reduce q_axis^5 e_j with exact affine border rules.

The normalized rules have leading affine degrees at most two and pure cubic
tails.  A deterministic divisor rule eliminates output degrees 0 through 4,
using only multipliers of affine degree at most two.  The remaining degree-5
vector is exact:

* zero gives a complete pure-power membership witness;
* nonzero is only a remainder modulo this chosen border subsystem.  It is not
  a nonmembership witness because the 6,549 cubic-only generator combinations
  and border ambiguities may still kill it.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import time

import numpy as np


P = 89
NQ = 37
HERE = Path(__file__).resolve().parent


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            answer.append((first,) + tail)
    return answer


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def embed_outside(exp: tuple[int, ...], axis: int, axis_power: int) -> tuple[int, ...]:
    out = list(exp)
    out.insert(axis, axis_power)
    return tuple(out)


def first_divisor(exp: tuple[int, ...], degree: int) -> tuple[tuple[int, ...], tuple[int, ...]]:
    """Take the first `degree` variable occurrences as divisor."""
    divisor = [0] * len(exp)
    left = degree
    for variable, power in enumerate(exp):
        take = min(left, power)
        divisor[variable] = take
        left -= take
        if left == 0:
            break
    if left:
        raise AssertionError("requested divisor degree exceeds monomial degree")
    quotient = [exp[i] - divisor[i] for i in range(len(exp))]
    return tuple(divisor), tuple(quotient)


def weighted_tail(weights: np.ndarray, tails: np.ndarray) -> np.ndarray:
    nz = np.flatnonzero(weights)
    if len(nz) == 0:
        return np.zeros(tails.shape[1], dtype=np.uint8)
    # Exact modular-double dot bound is len(nz)*88^2 <= 4218*88^2 < 2^53.
    product = weights[nz].astype(np.float64) @ np.ascontiguousarray(
        tails[nz], dtype=np.float64
    )
    np.remainder(product, float(P), out=product)
    return product.astype(np.uint8)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--axis", type=int, default=0)
    parser.add_argument("--component", type=int, action="append")
    args = parser.parse_args()
    axis = args.axis
    if axis < 0 or axis >= NQ:
        raise SystemExit("axis outside 0,...,36")
    components = args.component if args.component is not None else list(range(6))
    if any(component < 0 or component >= 6 for component in components):
        raise SystemExit("component outside 0,...,5")

    started = time.monotonic()
    packet_path = HERE / f"axis{axis}_border_packet.npz"
    tails_path = HERE / f"axis{axis}_border_tails.npy"
    inverse_path = HERE / f"axis{axis}_low_inverse.npy"
    if not packet_path.is_file() or not tails_path.is_file():
        raise FileNotFoundError("run produce_affine_border.py first")
    with np.load(packet_path, allow_pickle=False) as frozen:
        if int(frozen["axis"]) != axis or int(frozen["prime"]) != P:
            raise AssertionError("border packet axis/prime mismatch")
        low_monomials = frozen["low_monomials"].astype(np.int32)
        high_monomials = frozen["high_monomials"].astype(np.int32)
        claimed_tails_sha = str(frozen["tails_data_sha256"])
    tails = np.load(tails_path, mmap_mode="r")
    if tails.shape != (4218, 50616) or tails.dtype != np.uint8:
        raise AssertionError("unexpected tail matrix")

    global_q3 = weak_compositions(3, NQ)
    outside = NQ - 1
    ym = {degree: weak_compositions(degree, outside) for degree in range(6)}
    yi = {degree: {m: i for i, m in enumerate(ym[degree])} for degree in range(6)}
    global_index = {m: i for i, m in enumerate(global_q3)}
    low_position = {int(global_m): pos for pos, global_m in enumerate(low_monomials)}
    high_position = {int(global_m): pos for pos, global_m in enumerate(high_monomials)}
    # Bind the tail column order to component-major affine cubics.
    for pos, exp in enumerate(ym[3]):
        global_exp = embed_outside(exp, axis, 0)
        if high_position[global_index[global_exp]] != pos:
            raise AssertionError("unexpected pure-cubic tail order")

    beta = ym[0] + ym[1] + ym[2]
    beta_index = {m: i for i, m in enumerate(beta)}
    if len(beta) != 703:
        raise AssertionError("multiplier census changed")
    lifts = np.zeros((6, 4218, 703), dtype=np.uint8)
    remainders = {
        degree: np.zeros((6, len(ym[degree])), dtype=np.uint8)
        for degree in range(6)
    }

    def low_rule(component: int, outside_exp: tuple[int, ...]) -> int:
        degree = sum(outside_exp)
        if degree > 2:
            raise AssertionError("border rule requested above degree two")
        global_exp = embed_outside(outside_exp, axis, 3 - degree)
        monomial = global_index[global_exp]
        return component * 703 + low_position[monomial]

    # Reduce each of the six constant component targets independently but use
    # batched exact tail combinations for the expensive degree-3/4 steps.
    final = np.empty((len(components), 6, len(ym[5])), dtype=np.uint8)
    lift_packets = np.empty((len(components), 4218, 703), dtype=np.uint8)
    per_target = []
    for target_ordinal, target_component in enumerate(components):
        for array in remainders.values():
            array[:] = 0
        lifts[target_component] = 0
        remainders[0][target_component, 0] = 1

        # Degree 0: one normalized constant rule.
        p0 = low_rule(target_component, ym[0][0])
        c0 = int(remainders[0][target_component, 0])
        lifts[target_component, p0, beta_index[ym[0][0]]] = c0
        remainders[0][target_component, 0] = 0
        tail0 = np.asarray(tails[p0]).reshape(6, len(ym[3]))
        remainders[3] = (-c0 * tail0.astype(np.int16) % P).astype(np.uint8)

        # Degree 3: use a quadratic leading rule times one outside variable.
        groups3: dict[tuple[int, ...], np.ndarray] = {}
        for component in range(6):
            for monomial_index, exp in enumerate(ym[3]):
                coefficient = int(remainders[3][component, monomial_index])
                if not coefficient:
                    continue
                divisor, quotient = first_divisor(exp, 2)
                p = low_rule(component, divisor)
                weights = groups3.setdefault(quotient, np.zeros(4218, dtype=np.uint8))
                weights[p] = (int(weights[p]) + coefficient) % P
                bi = beta_index[quotient]
                lifts[target_component, p, bi] = (
                    int(lifts[target_component, p, bi]) + coefficient
                ) % P
        remainders[3][:] = 0
        for quotient, weights in groups3.items():
            combo = weighted_tail(weights, tails).reshape(6, len(ym[3]))
            for cubic_index, cubic in enumerate(ym[3]):
                out = tuple(cubic[v] + quotient[v] for v in range(outside))
                idx = yi[4][out]
                remainders[4][:, idx] = (
                    remainders[4][:, idx].astype(np.int16)
                    - combo[:, cubic_index].astype(np.int16)
                ) % P

        # Degree 4: use a quadratic leading rule times an outside quadratic.
        groups4: dict[tuple[int, ...], np.ndarray] = {}
        for component in range(6):
            for monomial_index, exp in enumerate(ym[4]):
                coefficient = int(remainders[4][component, monomial_index])
                if not coefficient:
                    continue
                divisor, quotient = first_divisor(exp, 2)
                p = low_rule(component, divisor)
                weights = groups4.setdefault(quotient, np.zeros(4218, dtype=np.uint8))
                weights[p] = (int(weights[p]) + coefficient) % P
                bi = beta_index[quotient]
                lifts[target_component, p, bi] = (
                    int(lifts[target_component, p, bi]) + coefficient
                ) % P
        remainders[4][:] = 0
        for group_number, (quotient, weights) in enumerate(groups4.items()):
            combo = weighted_tail(weights, tails).reshape(6, len(ym[3]))
            for cubic_index, cubic in enumerate(ym[3]):
                out = tuple(cubic[v] + quotient[v] for v in range(outside))
                idx = yi[5][out]
                remainders[5][:, idx] = (
                    remainders[5][:, idx].astype(np.int16)
                    - combo[:, cubic_index].astype(np.int16)
                ) % P
            if group_number % 64 == 0:
                print(
                    f"target {target_component}: degree-4 groups "
                    f"{group_number + 1}/{len(groups4)}",
                    flush=True,
                )
        final[target_ordinal] = remainders[5]
        lift_packets[target_ordinal] = lifts[target_component]
        nnz = int(np.count_nonzero(remainders[5]))
        per_target.append(
            {
                "component": target_component,
                "terminal_degree5_nnz": nnz,
                "terminal_degree5_zero": nnz == 0,
                "terminal_degree5_sha256": sha256_array(remainders[5]),
                "normalized_lift_nnz": int(np.count_nonzero(lifts[target_component])),
            }
        )
        print(json.dumps(per_target[-1], sort_keys=True), flush=True)

    result_path = HERE / f"axis{axis}_border_reduction.npz"
    np.savez_compressed(
        result_path,
        axis=np.int32(axis),
        prime=np.int32(P),
        terminal_degree5=final,
        normalized_lifts=lift_packets,
        target_components=np.asarray(components, dtype=np.int8),
        border_packet_sha256=np.asarray(sha256(packet_path)),
        border_tails_sha256=np.asarray(sha256(tails_path)),
        border_tails_data_sha256=np.asarray(claimed_tails_sha),
        border_inverse_sha256=np.asarray(sha256(inverse_path)),
    )
    manifest = {
        "status": (
            "PASS_PURE_POWER_MEMBERSHIP_BY_BORDER"
            if all(item["terminal_degree5_zero"] for item in per_target)
            else "NONVERDICT_NONZERO_BORDER_REMAINDERS"
        ),
        "prime": P,
        "axis": axis,
        "targets": per_target,
        "all_six_memberships_proved": all(
            item["terminal_degree5_zero"] for item in per_target
        ),
        "result": {"file": result_path.name, "sha256": sha256(result_path)},
        "inputs": {
            "border_packet": {"file": packet_path.name, "sha256": sha256(packet_path)},
            "border_tails": {"file": tails_path.name, "sha256": sha256(tails_path)},
            "border_inverse": {"file": inverse_path.name, "sha256": sha256(inverse_path)},
        },
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "scope": (
            "A zero terminal remainder is an exact membership proof. A nonzero "
            "remainder is only relative to this deterministic border reduction; "
            "cubic-only relations and border ambiguities remain available."
        ),
    }
    manifest_path = HERE / f"axis{axis}_border_reduction.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    print(json.dumps(manifest, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
