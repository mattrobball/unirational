#!/usr/bin/env python3
"""Independent exact audit of the prepared r66 Stage-C q0 chart.

Unlike the producer, this verifier parses every printed term back into a
coefficient tensor and compares it entrywise with the sealed P4/P3 arrays.
It also checks that the msolve and Singular equation streams are identical,
that all hashes and ledgers are bound, and that no CAS-result artifact has
been promoted.  It never launches a CAS.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Iterator

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
PACKET = P25 / "parallel" / "global_compatibility" / "support_augmented_r66_stageBC.npz"
STEM = "r66_stageC_q0_1_b0_1"
MSOLVE_INPUT = HERE / f"{STEM}.ms"
SINGULAR_INPUT = HERE / f"{STEM}.sing"
MANIFEST = HERE / f"{STEM}.json"
RESULT = HERE / "verify_stagec_q0_result.json"
P = 89
NQ = 37
ROWS = 66
EXPECTED_PACKET_SHA256 = "b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84"
EXPECTED_P3_SHA256 = "00b2ea7c59b74741982d4731424ac7d19df8b31770aa1a56a190ca7c456030c9"
EXPECTED_P4_SHA256 = "32197337d815ed4b2600d3d2965499a276fab5a3589559f10d8fe2488199771b"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def compositions(total: int, slots: int) -> Iterator[tuple[int, ...]]:
    """A verifier-local implementation of the packet's composition order."""
    if slots == 1:
        yield (total,)
    else:
        for head in range(total + 1):
            for rest in compositions(total - head, slots - 1):
                yield (head,) + rest


def monomial_ledger(total: int) -> tuple[dict[str, int], np.ndarray]:
    lookup: dict[str, int] = {}
    degrees: list[int] = []
    for position, exponent in enumerate(compositions(total, NQ)):
        factors = []
        for qindex in range(1, NQ):
            power = exponent[qindex]
            if power:
                factors.append(f"q{qindex}" if power == 1 else f"q{qindex}^{power}")
        key = "*".join(factors) if factors else "1"
        if key in lookup:
            raise AssertionError("q0 specialization created an impossible duplicate")
        lookup[key] = position
        degrees.append(total - exponent[0])
    return lookup, np.asarray(degrees, dtype=np.uint8)


def parse_term(token: str) -> tuple[int, int | None, str]:
    factors = token.split("*")
    coefficient = 1
    if factors and factors[0].isdigit() and factors[0] != "1":
        coefficient = int(factors.pop(0))
    elif len(factors) > 1 and factors[0] == "1":
        # The producer never prints an explicit coefficient 1 before a product.
        raise AssertionError(f"noncanonical coefficient in term {token!r}")
    if not (1 <= coefficient < P):
        raise AssertionError(f"coefficient outside canonical F_89 range in {token!r}")
    b_factors = [factor for factor in factors if factor.startswith("b1_")]
    if len(b_factors) > 1:
        raise AssertionError(f"more than one b1 factor in {token!r}")
    component: int | None = None
    if b_factors:
        bfactor = b_factors[0]
        try:
            component = int(bfactor.removeprefix("b1_"))
        except ValueError as error:
            raise AssertionError(f"invalid b1 factor {bfactor!r}") from error
        if component not in range(6):
            raise AssertionError(f"invalid b1 component {component}")
        factors.remove(bfactor)
    qkey = "*".join(factors) if factors else "1"
    return coefficient, component, qkey


def expected_singular_footer() -> str:
    return (
        "ideal I=" + ",".join(f"f{i}" for i in range(ROWS)) + ";\n"
        "timer=1; ideal G=std(I); int elapsed_ms=timer;\n"
        "poly remainder_one=reduce(1,G);\n"
        "int unit=(remainder_one==0);\n"
        "int ideal_dim=dim(G);\n"
        'write(\":w r66_stageC_q0_1_b0_1.singular.result.txt\",'
        '"R66_STAGEC_Q0_COMPLETE unit="+string(unit)+",dim="+string(ideal_dim)'
        '+",std_gens="+string(size(G))+",elapsed_ms="+string(elapsed_ms));\n'
        "quit;\n"
    )


def write_exact_json(path: Path, payload: dict) -> None:
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if path.exists() and path.read_text() != text:
        raise SystemExit(f"refusing to overwrite mismatching verification {path}")
    if not path.exists():
        path.write_text(text)


def main() -> None:
    manifest = json.loads(MANIFEST.read_text())
    if manifest.get("status") != "PREPARED_NOT_RUN" or manifest.get("cas_launched") is not False:
        raise AssertionError("manifest is not a fail-closed unlaunched preparation")
    if manifest.get("equations") != ROWS or manifest.get("variables") != 42:
        raise AssertionError("manifest equation/variable count mismatch")
    variables = [f"b1_{j}" for j in range(6)] + [f"q{i}" for i in range(1, NQ)]
    if manifest.get("variable_order") != variables:
        raise AssertionError("manifest variable order mismatch")
    if manifest.get("packet_sha256") != EXPECTED_PACKET_SHA256:
        raise AssertionError("manifest packet binding mismatch")
    if sha256_file(PACKET) != EXPECTED_PACKET_SHA256:
        raise AssertionError("sealed packet file hash mismatch")
    if manifest["inputs"]["msolve"]["sha256"] != sha256_file(MSOLVE_INPUT):
        raise AssertionError("msolve input hash mismatch")
    if manifest["inputs"]["singular"]["sha256"] != sha256_file(SINGULAR_INPUT):
        raise AssertionError("Singular input hash mismatch")
    if manifest["inputs"]["msolve"]["bytes"] != MSOLVE_INPUT.stat().st_size:
        raise AssertionError("msolve byte count mismatch")
    if manifest["inputs"]["singular"]["bytes"] != SINGULAR_INPUT.stat().st_size:
        raise AssertionError("Singular byte count mismatch")

    with np.load(PACKET, allow_pickle=False) as frozen:
        p4 = frozen["p4"]
        p3 = frozen["p3"]
        prime = int(frozen["prime"])
        added = frozen["added_columns"].astype(int).tolist()
        columns = frozen["full_basis_columns"].astype(int).tolist()
    if prime != P or p4.shape != (ROWS, 91390) or p3.shape != (ROWS, 6, 9139):
        raise AssertionError("sealed tensor metadata mismatch")
    if sha256_array(p4) != EXPECTED_P4_SHA256 or sha256_array(p3) != EXPECTED_P3_SHA256:
        raise AssertionError("sealed tensor byte hash mismatch")
    if added != [8740, 9490] or manifest["packet_arrays"]["full_basis_columns"] != columns:
        raise AssertionError("r66 selected-row ledger mismatch")

    q4_lookup, q4_degrees = monomial_ledger(4)
    q3_lookup, q3_degrees = monomial_ledger(3)
    if len(q4_lookup) != 91390 or len(q3_lookup) != 9139:
        raise AssertionError("verifier monomial ledger mismatch")

    global_p4 = 0
    global_p3 = np.zeros(6, dtype=np.int64)
    global_p4_degrees = np.zeros(5, dtype=np.int64)
    global_p3_degrees = np.zeros((6, 4), dtype=np.int64)
    manifest_rows = manifest["term_audit"]["rows"]

    with MSOLVE_INPUT.open() as ms, SINGULAR_INPUT.open() as singular:
        if ms.readline().rstrip("\n") != ",".join(variables):
            raise AssertionError("msolve variable header mismatch")
        if ms.readline().rstrip("\n") != str(P):
            raise AssertionError("msolve field header mismatch")
        expected_header = [
            "// Exact selected necessary equations only: q0=1, b0=1, GF(89).\n",
            f"// r66 packet sha256: {EXPECTED_PACKET_SHA256}\n",
            f"ring R={P},({','.join(variables)}),dp;\n",
            "option(prot);\n",
        ]
        for expected in expected_header:
            if singular.readline() != expected:
                raise AssertionError("Singular header mismatch")

        for row in range(ROWS):
            raw = ms.readline()
            if not raw:
                raise AssertionError(f"missing msolve equation row {row}")
            raw = raw.rstrip("\n")
            should_have_comma = row + 1 < ROWS
            if raw.endswith(",") != should_have_comma:
                raise AssertionError(f"msolve row delimiter mismatch at row {row}")
            equation = raw[:-1] if should_have_comma else raw
            if singular.readline() != f"poly f{row}={equation};\n":
                raise AssertionError(f"msolve/Singular equation mismatch at row {row}")
            if hashlib.sha256(equation.encode()).hexdigest() != manifest_rows[row]["equation_sha256"]:
                raise AssertionError(f"row hash mismatch at row {row}")

            reconstructed_p4 = np.zeros(91390, dtype=np.uint8)
            reconstructed_p3 = np.zeros((6, 9139), dtype=np.uint8)
            row_p4 = 0
            row_p3 = np.zeros(6, dtype=np.int64)
            row_p4_degrees = np.zeros(5, dtype=np.int64)
            row_p3_degrees = np.zeros((6, 4), dtype=np.int64)
            tokens = equation.split("+")
            for token in tokens:
                coefficient, component, qkey = parse_term(token)
                if component is None:
                    try:
                        index = q4_lookup[qkey]
                    except KeyError as error:
                        raise AssertionError(f"invalid quartic q monomial {qkey!r}") from error
                    if reconstructed_p4[index] != 0:
                        raise AssertionError(f"duplicate P4 term at row {row}")
                    reconstructed_p4[index] = coefficient
                    row_p4 += 1
                    row_p4_degrees[int(q4_degrees[index])] += 1
                else:
                    try:
                        index = q3_lookup[qkey]
                    except KeyError as error:
                        raise AssertionError(f"invalid cubic q monomial {qkey!r}") from error
                    if reconstructed_p3[component, index] != 0:
                        raise AssertionError(f"duplicate P3 term at row {row}, component {component}")
                    reconstructed_p3[component, index] = coefficient
                    row_p3[component] += 1
                    row_p3_degrees[component, int(q3_degrees[index])] += 1
            if not np.array_equal(reconstructed_p4, p4[row]):
                raise AssertionError(f"entrywise P4 replay failed at row {row}")
            if not np.array_equal(reconstructed_p3, p3[row]):
                raise AssertionError(f"entrywise P3 replay failed at row {row}")
            ledger = manifest_rows[row]
            if ledger["row"] != row or ledger["p4_terms"] != int(row_p4):
                raise AssertionError(f"P4 row ledger mismatch at row {row}")
            if ledger["p3_terms_by_component"] != row_p3.astype(int).tolist():
                raise AssertionError(f"P3 row ledger mismatch at row {row}")
            if ledger["total_terms"] != len(tokens):
                raise AssertionError(f"total row ledger mismatch at row {row}")
            if ledger["p4_affine_q_degree_counts_0_to_4"] != row_p4_degrees.astype(int).tolist():
                raise AssertionError(f"P4 degree ledger mismatch at row {row}")
            if ledger["p3_affine_q_degree_counts_0_to_3_by_component"] != row_p3_degrees.astype(int).tolist():
                raise AssertionError(f"P3 degree ledger mismatch at row {row}")
            global_p4 += row_p4
            global_p3 += row_p3
            global_p4_degrees += row_p4_degrees
            global_p3_degrees += row_p3_degrees

        if ms.read() != "":
            raise AssertionError("unexpected text after final msolve equation")
        if singular.read() != expected_singular_footer():
            raise AssertionError("Singular completion logic/footer mismatch")

    audit = manifest["term_audit"]
    if global_p4 != audit["p4_terms"] or int(global_p3.sum()) != audit["p3_terms"]:
        raise AssertionError("global P4/P3 term count mismatch")
    if global_p3.astype(int).tolist() != audit["p3_terms_by_component"]:
        raise AssertionError("global component term ledger mismatch")
    if global_p4 + int(global_p3.sum()) != audit["total_terms"]:
        raise AssertionError("global total term ledger mismatch")
    if global_p4_degrees.astype(int).tolist() != audit["p4_affine_q_degree_counts_0_to_4"]:
        raise AssertionError("global P4 degree ledger mismatch")
    if global_p3_degrees.astype(int).tolist() != audit["p3_affine_q_degree_counts_0_to_3_by_component"]:
        raise AssertionError("global P3 degree ledger mismatch")

    forbidden_results = [
        HERE / f"{STEM}.msolve.result.txt",
        HERE / f"{STEM}.singular.result.txt",
    ]
    if any(path.exists() for path in forbidden_results):
        raise AssertionError("a CAS result exists despite PREPARED_NOT_RUN status")

    payload = {
        "status": "PASS_INPUT_REPLAY_PREPARED_NOT_RUN",
        "manifest": MANIFEST.name,
        "manifest_sha256": sha256_file(MANIFEST),
        "packet_sha256": sha256_file(PACKET),
        "p4_sha256": sha256_array(p4),
        "p3_sha256": sha256_array(p3),
        "equations_replayed_entrywise": ROWS,
        "variables": len(variables),
        "p4_terms": int(global_p4),
        "p3_terms": int(global_p3.sum()),
        "total_terms": int(global_p4 + global_p3.sum()),
        "msolve_sha256": sha256_file(MSOLVE_INPUT),
        "singular_sha256": sha256_file(SINGULAR_INPUT),
        "cas_launched": False,
        "scope_guard": (
            "Prepared exact necessary equations for only D(q0), b0=1. "
            "No chart emptiness, global Stage-C result, or P25 verdict is claimed."
        ),
    }
    write_exact_json(RESULT, payload)
    print("PASS_INPUT_REPLAY_PREPARED_NOT_RUN")


if __name__ == "__main__":
    main()

