#!/usr/bin/env python3
"""Independent finite replay for the KT equivariant-diagonal audit."""

from functools import reduce
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
E = HERE.parents[1]


def require(path: Path, needles: tuple[str, ...]) -> None:
    text = path.read_text(encoding="utf-8")
    for needle in needles:
        assert needle in text, f"missing {needle!r} in {path}"


def main() -> None:
    order = 660
    sylow_orders = {2: 4, 3: 3, 5: 5, 11: 11}
    indices = {p: order // q for p, q in sylow_orders.items()}
    assert indices == {2: 165, 3: 220, 5: 132, 11: 60}
    assert reduce(gcd, indices.values()) == 1
    assert -13 * indices[11] + 3 * indices[5] + indices[2] + indices[3] == 1

    require(
        E / "goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR/STATUS.md",
        ("at **all six** points of `X^{V4}`", "`X^{A4} = ∅`"),
    )
    require(
        E / "goal_runs_20260808/FULL_G_C3_C5_GRAPH_LOCALIZATION/THEOREM.md",
        (
            "`C3` fixed points",
            "has six points",
            "four `C5` fixed points",
            "exact stabilizer `C5`",
        ),
    )
    require(
        E / "goal_runs_20260808/KERNEL_BIRATIONAL/THEOREM.md",
        ("coordinate vertices are exactly `X^C11`",),
    )
    require(
        E / "goal_runs_after_35fa/D2_STACK_INVARIANT/SYLOW_DETECTION.md",
        (
            "-13\\cdot60+3\\cdot132+165+220=1",
            "X^{P_2}\\ne\\varnothing",
            "X^{P_3}\\ne\\varnothing",
            "X^{P_5}\\ne\\varnothing",
            "X^{P_{11}}\\ne\\varnothing",
        ),
    )
    require(
        E
        / "goal_runs_20260808/DELTA1_EQUIVARIANT_MINIMAL_CLASS_AUDIT/THEOREM.md",
        (
            "Hypothesis (1.1) implies",
            r"G\)-equivariant integral decomposition of the diagonal",
            "DELTA1-EQUIVARIANT-MINIMAL-CLASS-OBSTRUCTION-DOES-NOT-CLOSE-RETRACTION",
        ),
    )
    require(
        E / "goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS/STATUS.md",
        ("All 20 `G`-orbits of strata", "says nothing about the existence"),
    )

    print("DELTA1-EQUIVARIANT-DIAGONAL-FINITE-AUDIT-OK")


if __name__ == "__main__":
    main()
