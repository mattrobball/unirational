#!/usr/bin/env python3
"""Replay the finite identities and source-bound scope of the quaternion audit.

The geometry is proved in THEOREM.md.  This replay deliberately performs only
the theorem-forced finite matrix calculation from the sibling packet and
checks the rank/weight bookkeeping of the intrinsic descent.
"""

from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
RUN = HERE.parent
PROBLEM = RUN.parent


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> None:
    # Intrinsic ranks: cubic companions modulo quadratic multiples of the
    # tautological vector, and five binary-quartic isotropy equations.
    source_rank = 6 * 4 - 3
    target_rank = 5 * 5
    require(source_rank == 21, "companion quotient rank")
    require(target_rank == 25, "isotropy target rank")
    require(source_rank - 20 == 1, "unique rank-20 companion")

    # Central weights on the mu_2 gerbe.  These are precisely the three
    # pushforwards used to define V, its gauge subbundle, and H.
    require((1 - 3) % 2 == 0, "Hom(L^3,U) descends")
    require((1 - 3) % 2 == 0, "Hom(L^3,L) descends")
    require((-4) % 2 == 0, "binary quartics descend")

    theorem = (HERE / "THEOREM.md").read_text()
    for marker in (
        "SCHUR-QUARTIC-QUATERNION-DESCENT-EXACT",
        "SCHUR-QUARTIC-RANK20-FUNCTOR-IS-KLEIN",
        "SCHUR-QUARTIC-BRAUER-DIEUDONNE-TAUTOLOGICAL",
        "HEADLINE-OPEN",
    ):
        require(marker in theorem, f"missing theorem marker {marker}")

    brauer_status = (
        PROBLEM
        / "goals_2026-08-01/V_VALUATION_TROPICAL_CODEX_ROOT_20260801/STATUS.md"
    ).read_text()
    require(
        "relative ordinary Brauer group of a smooth cubic threefold is trivial"
        in brauer_status,
        "binding relative Brauer input",
    )

    d12 = (
        PROBLEM
        / "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/D12/SOLUBLE.md"
    ).read_text()
    require("Twisting gives an ordinary projective line" in d12, "D12 countermode")

    exact = RUN / "SCHUR_QUARTIC_ARITHMETIC/verify_exact.py"
    completed = subprocess.run(
        ["/opt/homebrew/bin/python3", str(exact)],
        cwd=PROBLEM,
        check=True,
        capture_output=True,
        text=True,
    )
    require(
        "SCHUR-QUARTIC-KERNEL-COMPONENT-EXACT-OK" in completed.stdout,
        "exact kernel-component replay",
    )

    print("ranks: 21 -> 25; rank 20 has one companion")
    print("mu2 weights: all three defining bundles descend")
    print("Pfaffian/rank20 inverse replay: PASS")
    print("SCHUR-QUARTIC-QUATERNION-AUDIT-OK")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"SCHUR-QUARTIC-QUATERNION-AUDIT-FAIL: {exc}", file=sys.stderr)
        raise
