#!/usr/bin/env python3
"""Fast independent audit of the pinned degree-16 leading-ideal output.

This does not recompute the Groebner basis.  It verifies the integrity and
the exact monomial-ideal consequence of the saved upstream msolve output.
The Hilbert calculation grows only standard monomials, rather than naively
enumerating every degree-four monomial in eighty variables.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import re
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
METADATA_PATH = HERE / "degree16_fano_exclusion.json"
EXPECTED_RELATIVE_BASIS = (
    "../../goals_2026-08-01/"
    "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/"
    "degree16_l44_leading.out"
)
EXPECTED_SHA256 = "aa9958021e630be5ab19884a5b74520b492710bb7b32a4e6568b6ee435e113d2"
EXPECTED_BYTES = 512494
PRIME = 23
COVARIANT_DEGREE = 16
DIMENSION = 80
BASIS_LENGTH = 28383
EXPECTED_TALLY = {2: 1313, 3: 26984, 4: 86}
EXPECTED_HILBERT = [1, 80, 1927, 86, 0]
FACTOR = re.compile(r"a([0-9]+)\^([0-9]+)")


def parse_and_pin_metadata() -> tuple[dict, Path]:
    metadata = json.loads(METADATA_PATH.read_text())
    assert metadata["format"] == "c5-degree16-matched-fano-leading-certificate-v1"
    upstream = metadata["upstream"]
    assert upstream["basis_path_from_packet"] == EXPECTED_RELATIVE_BASIS
    assert upstream["basis_sha256"] == EXPECTED_SHA256
    assert upstream["basis_bytes"] == EXPECTED_BYTES
    system = metadata["coefficient_system"]
    assert system["prime"] == PRIME
    assert system["covariant_degree"] == COVARIANT_DEGREE
    assert system["covariant_dimension"] == DIMENSION
    certificate = metadata["leading_ideal_certificate"]
    assert certificate["basis_length"] == BASIS_LENGTH
    assert {
        int(degree): count
        for degree, count in certificate["leading_degree_tally"].items()
    } == EXPECTED_TALLY
    assert certificate["hilbert_function_degrees_0_through_4"] == EXPECTED_HILBERT
    basis_path = (HERE / EXPECTED_RELATIVE_BASIS).resolve()
    assert basis_path.is_file(), f"missing pinned upstream basis: {basis_path}"
    return metadata, basis_path


def parse_leading_basis(text: str) -> list[tuple[int, ...]]:
    variables = ", ".join(f"a{index}" for index in range(DIMENSION))
    expected_header = [
        "#Leading ideal data",
        "#---",
        f"#field characteristic: {PRIME}",
        f"#variable order:       {variables}",
        "#monomial order:       graded reverse lexicographical",
        (
            f"#length of basis:      {BASIS_LENGTH} elements sorted by "
            "increasing leading monomials"
        ),
        "#---",
    ]
    assert text.splitlines()[: len(expected_header)] == expected_header
    assert text.rstrip().endswith("]:")

    body = text[text.index("[") + 1 : text.rindex("]")]
    monomials: list[tuple[int, ...]] = []
    for raw_expression in body.split(","):
        expression = raw_expression.strip()
        if not expression:
            continue
        factors = [(int(i), int(e)) for i, e in FACTOR.findall(expression)]
        assert factors
        assert "*".join(f"a{i}^{e}" for i, e in factors) == expression
        assert all(0 <= index < DIMENSION and exponent > 0 for index, exponent in factors)
        assert all(left[0] < right[0] for left, right in zip(factors, factors[1:]))
        expanded = tuple(
            index
            for index, exponent in factors
            for _copy in range(exponent)
        )
        monomials.append(expanded)

    assert len(monomials) == BASIS_LENGTH
    assert len(set(monomials)) == BASIS_LENGTH
    return monomials


def pure_power_profile(monomials: list[tuple[int, ...]]) -> dict[int, int]:
    pure_rows = [monomial for monomial in monomials if len(set(monomial)) == 1]
    assert len(pure_rows) == DIMENSION
    pure = {monomial[0]: len(monomial) for monomial in pure_rows}
    assert len(pure) == DIMENSION
    expected = {
        **{index: 2 for index in range(50)},
        **{index: 3 for index in range(50, 79)},
        79: 4,
    }
    assert pure == expected
    return pure


def hilbert_function(monomials: list[tuple[int, ...]]) -> list[int]:
    """Count standard monomials inductively through the vanishing degree."""

    leads_by_degree = {
        degree: {monomial for monomial in monomials if len(monomial) == degree}
        for degree in EXPECTED_TALLY
    }
    position_choices = {
        (candidate_degree, divisor_degree): tuple(
            itertools.combinations(range(candidate_degree), divisor_degree)
        )
        for candidate_degree in range(2, 5)
        for divisor_degree in range(2, candidate_degree + 1)
    }

    def is_in_leading_ideal(candidate: tuple[int, ...]) -> bool:
        candidate_degree = len(candidate)
        for divisor_degree, leads in leads_by_degree.items():
            if divisor_degree > candidate_degree:
                continue
            for positions in position_choices[(candidate_degree, divisor_degree)]:
                divisor = tuple(candidate[position] for position in positions)
                if divisor in leads:
                    return True
        return False

    standard = {()}
    values = [1]
    for degree in range(1, 5):
        next_standard: set[tuple[int, ...]] = set()
        for prefix in standard:
            first_variable = prefix[-1] if prefix else 0
            for variable in range(first_variable, DIMENSION):
                candidate = prefix + (variable,)
                if not is_in_leading_ideal(candidate):
                    next_standard.add(candidate)
        standard = next_standard
        values.append(len(standard))
        assert values[-1] == EXPECTED_HILBERT[degree]
    return values


def main() -> None:
    _metadata, basis_path = parse_and_pin_metadata()
    raw = basis_path.read_bytes()
    assert len(raw) == EXPECTED_BYTES
    digest = hashlib.sha256(raw).hexdigest()
    assert digest == EXPECTED_SHA256
    text = raw.decode("ascii")
    monomials = parse_leading_basis(text)

    tally = dict(sorted(Counter(map(len, monomials)).items()))
    assert tally == EXPECTED_TALLY
    pure = pure_power_profile(monomials)
    hilbert = hilbert_function(monomials)
    assert hilbert[-1] == 0

    print(f"PASS pinned upstream SHA256 {digest} ({len(raw)} bytes)")
    print(
        "PASS header characteristic=23 variables=a0,...,a79 "
        "order=grevlex basisLength=28383"
    )
    print(f"PASS leading-degree tally {tally}")
    print(
        "PASS pure powers cover all 80 variables "
        f"with exponent tally {dict(sorted(Counter(pure.values()).items()))}"
    )
    print(f"PASS Hilbert function H[0..4]={hilbert}")
    print("PASS saved leading ideal has irrelevant radical and empty projective locus")
    print(
        "SCOPE homogeneous Fano-valued covariants only through degree 16; "
        "not a K_proj point/nonpoint or an all-degree verdict"
    )
    print("C5_DEGREE16_FANO_EXCLUSION_INDEPENDENTLY_VERIFIED")


if __name__ == "__main__":
    main()
