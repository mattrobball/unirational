#!/usr/bin/env python3
"""Independent verifier for residual_gate.json.

Does not import produce_residual_gate.py.  Rebuilds the transitive S4 lattice,
rechecks sealed input hashes and monodromy/Brauer firewalls, and compares the
producer stdout JSON for byte-level reproducibility of the logical ledger.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = HERE / "residual_gate.json"
PRODUCER = HERE / "produce_residual_gate.py"
PYTHON = "/opt/homebrew/bin/python3"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def sha256_path(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(4))


IDENTITY = tuple(range(4))
S4 = tuple(itertools.permutations(range(4)))
PARTITIONS = (
    frozenset((frozenset((0, 1)), frozenset((2, 3)))),
    frozenset((frozenset((0, 2)), frozenset((1, 3)))),
    frozenset((frozenset((0, 3)), frozenset((1, 2)))),
)


def closure(generators: tuple[tuple[int, ...], ...]) -> frozenset[tuple[int, ...]]:
    subgroup = {IDENTITY}
    queue = [IDENTITY]
    while queue:
        value = queue.pop()
        for generator in generators:
            candidate = compose(value, generator)
            if candidate not in subgroup:
                subgroup.add(candidate)
                queue.append(candidate)
    return frozenset(subgroup)


def inverse(perm: tuple[int, ...]) -> tuple[int, ...]:
    result = [0, 0, 0, 0]
    for index, image in enumerate(perm):
        result[image] = index
    return tuple(result)


def is_transitive(group: frozenset[tuple[int, ...]]) -> bool:
    return {element[0] for element in group} == set(range(4))


def is_imprimitive(group: frozenset[tuple[int, ...]]) -> bool:
    for partition in PARTITIONS:
        if all(
            frozenset(
                frozenset(element[index] for index in block) for block in partition
            )
            == partition
            for element in group
        ):
            return True
    return False


def compose_power(element: tuple[int, ...], exponent: int) -> tuple[int, ...]:
    value = IDENTITY
    for _ in range(exponent):
        value = compose(value, element)
    return value


def element_order(element: tuple[int, ...]) -> int:
    for order in range(1, 5):
        if compose_power(element, order) == IDENTITY:
            return order
    raise AssertionError("order not found")


def classify(group: frozenset[tuple[int, ...]]) -> str:
    order = len(group)
    if order == 24:
        return "S4"
    if order == 12:
        return "A4"
    if order == 8:
        return "D4"
    if order == 4:
        orders = {element_order(element) for element in group if element != IDENTITY}
        return "C4" if 4 in orders else "V4"
    raise AssertionError(f"unexpected transitive order {order}")


def rebuild_lattice() -> dict[str, dict]:
    seeds = {
        "C4": ((1, 2, 3, 0),),
        "V4": ((1, 0, 3, 2), (2, 3, 0, 1)),
        "D4": ((1, 2, 3, 0), (1, 0, 3, 2)),
        "A4": ((1, 2, 0, 3), (1, 3, 2, 0)),
        "S4": ((1, 0, 2, 3), (1, 2, 3, 0)),
    }
    found: dict[str, frozenset[tuple[int, ...]]] = {}
    for seed_name, generators in seeds.items():
        for conjugator in S4:
            conjugate_gens = tuple(
                compose(compose(conjugator, generator), inverse(conjugator))
                for generator in generators
            )
            group = closure(conjugate_gens)
            require(is_transitive(group), f"non-transitive conjugate of {seed_name}")
            name = classify(group)
            found.setdefault(name, group)
    require(set(found) == {"C4", "V4", "D4", "A4", "S4"}, f"types={set(found)}")
    return {
        name: {
            "order": len(group),
            "imprimitive": is_imprimitive(group),
            "primitive": not is_imprimitive(group),
        }
        for name, group in found.items()
    }


def main() -> None:
    data = json.loads(DATA.read_text())
    require(data["schema"] == "m3-section-residual-gate-v1", "schema")
    require(data["terminal_exit_unchanged"] == "M3-INTEGRAL-DEGREE4-MULTISECTION", "exit")
    require(data["section_question"] == "UNDECIDED", "section_question")
    require(data["headline"] == "OPEN", "headline")
    require(data["verdict"]["section_still_undecided"] is True, "still undecided")
    require(
        data["verdict"]["integral_degree_four_multisection_sealed"] is True,
        "multisection sealed",
    )
    require(data["verdict"]["residual_stratum_if_no_section"] == ["A4", "S4"], "stratum")
    require(all(value is False for value in data["strict_boundaries"].values()), "boundaries")

    # Input hashes.
    for name, digest in data["inputs_sha256"].items():
        path = HERE / name
        require(path.is_file(), f"missing input {name}")
        require(sha256_path(path) == digest, f"hash drift {name}")

    # STATUS and quartic firewalls.
    status = (HERE / "STATUS.md").read_text()
    require(status.splitlines()[0] == "M3-INTEGRAL-DEGREE4-MULTISECTION", "STATUS exit")
    require("section_question: UNDECIDED" in status, "STATUS section")
    quartic = json.loads((HERE / "quartic_branch.json").read_text())
    require(quartic["verdict"]["section_question"] == "UNDECIDED", "quartic section")
    require(
        quartic["verdict"]["integral_degree_four_multisection_exists"] is True,
        "quartic multisection",
    )
    require(quartic["decomposition_group_reduction"]["remaining"] == ["A4", "S4"], "quartic remaining")
    require(
        quartic["decomposition_group_reduction"]["excluded"] == ["C4", "V4", "D4"],
        "quartic excluded",
    )

    # Elementary obstruction arithmetic.
    elementary = data["elementary_obstruction"]
    require(elementary["effective_zero_cycle_degrees"] == [3, 55], "degrees")
    require(elementary["index_divides"] == 1, "index")
    require(elementary["bezout_degree"] == 1, "bezout")
    require(elementary["elementary_obstruction"] == 0, "ob")
    require(elementary["is_rational_point_theorem"] is False, "ob not point theorem")

    # S4 lattice independent rebuild.
    rebuilt = rebuild_lattice()
    stored = data["s4_transitive_lattice"]["transitive_types"]
    require(set(stored) == set(rebuilt), "type keys")
    for name, info in rebuilt.items():
        require(stored[name]["order"] == info["order"], f"{name} order")
        require(stored[name]["imprimitive"] == info["imprimitive"], f"{name} imprim")
        require(stored[name]["primitive"] == info["primitive"], f"{name} prim")
    require(
        data["s4_transitive_lattice"]["no_section_excluded"] == ["C4", "V4", "D4"],
        "excluded list",
    )
    require(
        data["s4_transitive_lattice"]["no_section_remaining"] == ["A4", "S4"],
        "remaining list",
    )

    # Residual alternative shape.
    branches = data["residual_alternative"]["branches"]
    require("R1_section" in branches and "R2_no_section" in branches, "branches")
    require(
        data["residual_alternative"]["multisection_selects_branch"] is False,
        "multisection selects",
    )
    require(
        branches["R2_no_section"]["galois_remaining"] == ["A4", "S4"],
        "R2 remaining",
    )

    # Ordered gates and smallest gate.
    gate_ids = [gate["id"] for gate in data["ordered_gates"]]
    require(gate_ids == ["G0", "G1", "G2", "G3", "G4", "G5"], f"gates={gate_ids}")
    require(data["smallest_decision_gate"]["id"] == "G1", "smallest")
    g1 = next(gate for gate in data["ordered_gates"] if gate["id"] == "G1")
    require(g1["K_point_known"] is False, "G1 K-point")
    require(g1["geometric_emptiness_known"] is False, "G1 emptiness")
    require(g1["coefficient_equations"] == 13, "G1 eqs")

    # Monodromy/Brauer conditional ledger.
    mono = data["monodromy_brauer_ledger"]
    sealed_mono = json.loads((HERE / "line_monodromy.json").read_text())
    require(mono["actual_geometric_27_line_monodromy"] == "UNRESOLVED", "geo monodromy")
    require(mono["actual_arithmetic_27_line_monodromy"] == "UNRESOLVED", "arith monodromy")
    require(mono["algebraic_brauer_group_computed"] is False, "brauer computed")
    require(mono["does_not_decide_section"] is True, "monodromy decides")
    require(
        mono["conditional_H1_full_W_E6"]
        == sealed_mono["integral_W_E6_lattice"]["H1_full_Weyl_group"]["conclusion"],
        "H1 conclusion",
    )
    require(
        "NOT ESTABLISHED" in mono["conditional_H1_applies_to_generic_fibre"],
        "H1 applicability",
    )

    frobenius = json.loads((HERE / "line_frobenius_specializations.json").read_text())
    require(
        mono["frobenius_specializations"]["count"] == len(frobenius["specializations"]),
        "frobenius count",
    )
    require(
        mono["frobenius_specializations"]["status_marker"]
        == frobenius["strict_scope"]["status_marker"],
        "frobenius marker match",
    )
    require(
        mono["frobenius_specializations"]["status_marker"]
        == "ACTUAL_GENERIC_27_LINE_MONODROMY_UNRESOLVED",
        "frobenius unresolved marker",
    )
    for entry in mono["frobenius_specializations"]["element_counts"]:
        require(int(entry["element_count"]) > 0, "W(E6) count")

    # Section classes agreement on d=4 gate.
    section_classes = json.loads((HERE / "SECTION_CLASSES.json").read_text())
    require(section_classes["degree_four_gate"]["K_point_known"] is False, "classes K-point")
    require(
        section_classes["conditional_congruence"]["admissible_degrees"]
        == next(g for g in data["ordered_gates"] if g["id"] == "G5")["admissible_prefix"],
        "admissible degrees",
    )

    # Reproducibility: producer stdout JSON equals stored file.
    completed = subprocess.run(
        [PYTHON, "-u", str(PRODUCER)],
        cwd=HERE.parents[1],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        env={**__import__("os").environ, "PYTHONDONTWRITEBYTECODE": "1"},
    )
    require(
        "M3_RESIDUAL_GATE_CERTIFICATE_OK" in completed.stdout,
        f"missing producer marker:\n{completed.stdout}",
    )
    require(
        "SECTION_QUESTION_STILL_UNDECIDED" in completed.stdout,
        f"missing undecided marker:\n{completed.stdout}",
    )
    # Producer prints JSON then markers; isolate the JSON object.
    text = completed.stdout
    start = text.index("{")
    end = text.rindex("}") + 1
    fresh = json.loads(text[start:end])
    require(fresh == data, "producer output differs from residual_gate.json")

    print("PASS residual S4 transitive lattice and A4/S4 residual stratum")
    print("PASS elementary obstruction arithmetic and sealed input hashes")
    print("PASS monodromy/Brauer conditional firewall (not computed)")
    print("PASS ordered gates and G1 smallest decision gate")
    print("PASS reproducible residual_gate.json")
    print("M3_RESIDUAL_GATE_CERTIFICATE_OK")
    print("SECTION_QUESTION_STILL_UNDECIDED")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:  # pragma: no cover - surface failure clearly
        print(f"FAIL {exc}", file=sys.stderr)
        raise
