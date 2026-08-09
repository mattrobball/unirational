#!/usr/bin/env python3
"""Consistency audit for the Schur-conic theorem packet.

This intentionally uses no CAS.  It checks only packet integrity and the
elementary parity enumeration stated in Proposition 5.1.
"""

from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
TEXT_FILES = [
    HERE / "THEOREM.md",
    HERE / "STATUS.md",
    HERE / "SOURCES.md",
    HERE / "REPLAY.md",
]


def allowed_pairs(degree: int) -> list[tuple[int, int]]:
    return [
        (a, degree - a)
        for a in range(degree // 2 + 1)
        if a <= degree - a
        and (a == degree - a or (a % 2 == 1 and (degree - a) % 2 == 1))
    ]


def main() -> None:
    theorem = (HERE / "THEOREM.md").read_text()
    status = (HERE / "STATUS.md").read_text()

    for path in TEXT_FILES:
        contents = path.read_text()
        controls = [
            (index, ord(character))
            for index, character in enumerate(contents)
            if ord(character) < 32 and character not in "\n\t"
            or ord(character) == 127
        ]
        assert controls == [], (path, controls)
        assert contents.count(r"\(") == contents.count(r"\)"), path
        assert contents.count(r"\[") == contents.count(r"\]"), path

    formatting_markers = [
        r"\(\beta\)",
        r"\(\operatorname{SB}(A)\)",
        r"\(\alpha(Q)=\beta\)",
        r"\(\square\)",
    ]
    for marker in formatting_markers:
        assert marker in theorem, marker

    markers = [
        "SCHUR-CONIC-CRITERION-AND-DEGREE2-EXCLUSION-OK",
        "HEADLINE-OPEN",
        "alpha(Q)=e\\beta",
        "(1,3),(2,2)",
    ]
    for marker in markers:
        assert marker in theorem or marker in status, marker

    required = [
        ROOT / "goal_runs_20260808/SCHUR_V14/THEOREM.md",
        ROOT / "theory/FIX_IX_v14.md",
        ROOT / "RESOLUTION.md",
        ROOT
        / "goals_2026-08-01/R_RATIONAL_CURVES_ROOT_JACOBIAN_ZERO/THEOREM.md",
        ROOT
        / "goals_2026-08-01/H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/D12/STATUS.md",
    ]
    for path in required:
        assert path.is_file(), path

    expected = {
        2: [(1, 1)],
        4: [(1, 3), (2, 2)],
        6: [(1, 5), (3, 3)],
        8: [(1, 7), (3, 5), (4, 4)],
    }
    for degree, pairs in expected.items():
        assert allowed_pairs(degree) == pairs

    for degree in range(1, 101, 2):
        assert allowed_pairs(degree) == []

    print("SCHUR-CONIC-AUDIT PASS")
    for degree, pairs in expected.items():
        print(f"degree {degree}: {pairs}")


if __name__ == "__main__":
    main()
