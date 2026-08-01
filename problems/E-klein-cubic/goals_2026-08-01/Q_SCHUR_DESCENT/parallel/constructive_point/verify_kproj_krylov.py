#!/usr/bin/env python3
"""Exact replay of the two constant-Krylov exclusions in ``K_proj``.

Run with Homebrew Python (NumPy is required):

    /opt/homebrew/bin/python3 verify_kproj_krylov.py

The replay reconstructs every sampled coefficient equation from the
authoritative generic cubic and multiplication table, recomputes ranks over
GF(199), checks the pair ideal by homogeneous multiplication, and reruns
msolve for the triple ideal.  A zero Hilbert value for a homogeneous quotient
means that its projective zero locus is empty.
"""

from __future__ import annotations

from collections import Counter
import hashlib
import itertools
import json
from math import comb
from pathlib import Path
import re
import subprocess
import tempfile

import numpy as np

import probe_kproj_krylov as probe


HERE = Path(__file__).resolve().parent
EXPECTED_INPUT_HASHES = {
    "generic": "2573277995d439011c9051f01c3412519059c505a729def80cde58aa2ca09d53",
    "table": "5def3f471698753cb81a6c4c8a3f97f0a4a6e7989d5fdcec196a6e754af0ae7f",
}
EXPECTED = {
    "pair": {
        "indices": (0, 1),
        "variables": 10,
        "monomials": 220,
        "rank": 140,
        "semantic": "0750a458db7770dff8a7c4f3f7e6bf4336785c1370c78874f493bc5827171703",
        "input": "b14f8cea79d56e2565742c85605171b180ca36c7f5e2595bf213e9f131f06998",
        "hilbert": [1, 10, 55, 80, 50, 0],
    },
    "triple": {
        "indices": (0, 1, 6),
        "variables": 15,
        "monomials": 680,
        "rank": 245,
        "semantic": "598e87240cba3a5c99b6438ca5c2a619077e72e167b6f008c1352e66f508f10c",
        "input": "5a5927bcddb95f308024bb886deea8d903c915a50f1c689d9614c13138d41b49",
        "leading": "6a416f3ec1fb82897efd13321336f18983073efe01b75cfdce77b6992715e8b5",
        "leading_count": 802,
        "degree_tally": {3: 245, 4: 65, 5: 492},
        "hilbert": [1, 15, 120, 435, 820, 351, 50, 0],
    },
}


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def semantic(array: np.ndarray) -> str:
    return sha256_bytes(np.ascontiguousarray(array).view(np.uint8))


def check_denominators(value) -> int:
    """Recursively count literal rational denominators and check p-integrality."""
    count = 0
    if isinstance(value, dict):
        if "denominator" in value:
            denominator = int(value["denominator"])
            assert denominator != 0 and denominator % probe.PRIME != 0
            count += 1
        for child in value.values():
            count += check_denominators(child)
    elif isinstance(value, list):
        for child in value:
            count += check_denominators(child)
    return count


def expected_input_text(independent: np.ndarray, monomials) -> str:
    variables = next(
        n for n in range(1, 100) if comb(n + 2, 3) == independent.shape[1]
    )
    texts = [probe.monomial_text(monomial) for monomial in monomials]
    output = [",".join(f"a{i}" for i in range(variables)), str(probe.PRIME)]
    for row_index, row in enumerate(independent):
        terms = []
        for column in np.flatnonzero(row):
            coefficient = int(row[column])
            monomial = texts[int(column)]
            terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
        output.append("+".join(terms) + ("," if row_index + 1 < len(independent) else ""))
    return "\n".join(output) + "\n"


def parse_leading_monomials(text: str, variables: int):
    assert f"#field characteristic: {probe.PRIME}" in text
    assert "#monomial order:       graded reverse lexicographical" in text
    match = re.search(r"#length of basis:\s+(\d+) elements", text)
    assert match
    body = text[text.index("[") + 1 : text.rindex("]")]
    expressions = [entry.strip() for entry in body.split(",") if entry.strip()]
    leads = []
    for expression in expressions:
        exponents = [0] * variables
        factors = re.findall(r"a(\d+)\^(\d+)", expression)
        assert factors
        for raw_variable, raw_exponent in factors:
            variable, exponent = int(raw_variable), int(raw_exponent)
            assert 0 <= variable < variables and exponent > 0
            assert exponents[variable] == 0
            exponents[variable] = exponent
        rebuilt = "*".join(
            f"a{variable}^{exponent}"
            for variable, exponent in enumerate(exponents)
            if exponent
        )
        assert rebuilt == expression
        leads.append(tuple(exponents))
    assert len(leads) == int(match.group(1)) == len(set(leads))
    return leads


def hilbert_from_monomial_ideal(leads, variables: int):
    output = []
    for degree in range(10):
        relevant = [lead for lead in leads if sum(lead) <= degree]
        survivors = 0
        for monomial in itertools.combinations_with_replacement(range(variables), degree):
            exponents = [0] * variables
            for variable in monomial:
                exponents[variable] += 1
            if not any(
                all(left <= right for left, right in zip(lead, exponents))
                for lead in relevant
            ):
                survivors += 1
        output.append(survivors)
        if survivors == 0:
            break
    return output


def check_case(case: str):
    expected = EXPECTED[case]
    result_path = HERE / f"krylov_{case}_result.json"
    rows_path = HERE / f"krylov_{case}_rows.npz"
    input_path = HERE / f"krylov_{case}.in"
    result = json.loads(result_path.read_text())
    assert result["status"] == "empty"
    assert tuple(result["basis_indices"]) == expected["indices"]
    assert result["variables"] == expected["variables"]
    assert result["cubic_monomials"] == expected["monomials"]
    assert result["cubic_rank"] == expected["rank"]
    assert result["hilbert_function"] == expected["hilbert"]
    assert result["field_characteristic"] == probe.PRIME == 199
    assert result["sample_count"] == probe.SAMPLE_COUNT == 64
    assert result["rng_seed"] == probe.RNG_SEED == 202608011733
    assert result["input_sha256"] == expected["input"] == sha256(input_path)

    saved = np.load(rows_path, allow_pickle=False)
    points = saved["points"]
    rows = saved["rows"]
    independent_indices = saved["independent_indices"]
    rng = np.random.default_rng(probe.RNG_SEED)
    expected_points = rng.integers(
        1, probe.PRIME, size=(probe.SAMPLE_COUNT, 4), dtype=np.int32
    )
    assert np.array_equal(points, expected_points)
    assert points.shape == (64, 4)
    assert rows.shape == (768, expected["monomials"])
    assert semantic(rows) == result["rows_semantic_sha256"] == expected["semantic"]

    # Full semantic reconstruction from the two upstream exact objects.
    rebuilt, monomials = probe.cubic_rows(expected["indices"], points)
    assert np.array_equal(rows, rebuilt)
    assert len(monomials) == expected["monomials"]
    assert probe.rank(rows) == expected["rank"]
    independent = rows[independent_indices]
    assert len(independent_indices) == expected["rank"]
    assert len(set(map(int, independent_indices))) == expected["rank"]
    assert probe.rank(independent) == expected["rank"]
    rendered = expected_input_text(independent, monomials).encode()
    assert rendered == input_path.read_bytes()

    if case == "pair":
        degree_rows, degree_monomials = independent, monomials
        hilbert = [1, expected["variables"], comb(expected["variables"] + 1, 2)]
        ranks = {3: expected["rank"]}
        hilbert.append(comb(expected["variables"] + 2, 3) - expected["rank"])
        for degree in (4, 5):
            degree_rows, degree_monomials, degree_rank = probe.multiply_degree(
                degree_rows, degree_monomials, expected["variables"], degree - 1
            )
            ranks[degree] = degree_rank
            hilbert.append(comb(expected["variables"] + degree - 1, degree) - degree_rank)
        assert ranks == {3: 140, 4: 665, 5: 2002}
        assert hilbert == expected["hilbert"]
        return {"case": case, "ranks": ranks, "hilbert": hilbert}

    leading_path = HERE / "krylov_triple_leading.out"
    assert sha256(leading_path) == result["leading_sha256"] == expected["leading"]
    leads = parse_leading_monomials(leading_path.read_text(), expected["variables"])
    assert len(leads) == result["leading_count"] == expected["leading_count"]
    tally = dict(sorted(Counter(map(sum, leads)).items()))
    assert tally == expected["degree_tally"]
    hilbert = hilbert_from_monomial_ideal(leads, expected["variables"])
    assert hilbert == expected["hilbert"]

    # Rerun the exact Groebner computation.  The leading ideal is deterministic
    # for the fixed input and seed; timing text is intentionally not compared.
    with tempfile.TemporaryDirectory(prefix="verify_krylov_triple_") as raw_temp:
        fresh = Path(raw_temp) / "leading.out"
        command = [
            "msolve", "-f", str(input_path), "-o", str(fresh),
            "-t", "4", "-v", "0", "-g", "1", "-l", "2",
            "-q", "0", "-r", "0", "-s", "20", "-m", "2000",
            "--random-seed", "0",
        ]
        completed = subprocess.run(
            command, text=True, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, timeout=300, check=False,
        )
        assert completed.returncode == 0, completed.stdout
        assert sha256(fresh) == expected["leading"]
    return {
        "case": case,
        "leading_count": len(leads),
        "degree_tally": tally,
        "hilbert": hilbert,
    }


def main():
    assert probe.PRIME % 11 == 1 and 660 % probe.PRIME != 0
    assert sha256(probe.GENERIC) == EXPECTED_INPUT_HASHES["generic"]
    assert sha256(probe.TABLE) == EXPECTED_INPUT_HASHES["table"]
    generic, table = probe.load_inputs()
    denominator_count = check_denominators(generic) + check_denominators(table)
    assert denominator_count > 0
    summary = {
        "prime": probe.PRIME,
        "prime_is_split_mod_11": True,
        "prime_is_tame_for_group_order_660": True,
        "checked_denominators": denominator_count,
        "cases": [check_case("pair"), check_case("triple")],
        "scope": (
            "projective emptiness only for five coordinates with constant "
            "coefficients in <1,f7> or <1,f7,f7^2>"
        ),
    }
    print(json.dumps(summary, indent=2, sort_keys=True))
    print("Q_CONSTRUCTIVE_KPROJ_KRYLOV_EXACT")


if __name__ == "__main__":
    main()
