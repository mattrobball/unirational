"""Helpers shared by the live Lean emitters.

Only functions that are byte-identical across emitters whose output has been
re-verified byte-for-byte against the committed tree belong here.  The
polynomial-arithmetic families (`add`, `mul`, `sub`, `trim`, `reduce_phi`)
stay per-script on purpose: the copies differ for real reasons —
`export_sigma_plus_identities.add` trims trailing zeros while
`export_sigma_carrier_lean.add` preserves length, `reduce_phi` is a checked
division in one script and an unchecked in-place reduction in another, and
`replay_sigma_minus_arithmetic` re-implements the arithmetic deliberately, as
an audit independent of the emitters it checks.
"""
from fractions import Fraction


def lean_rat(x: Fraction) -> str:
    if x.denominator == 1:
        return str(x.numerator)
    return f"({x.numerator} / {x.denominator} : ℚ)"
