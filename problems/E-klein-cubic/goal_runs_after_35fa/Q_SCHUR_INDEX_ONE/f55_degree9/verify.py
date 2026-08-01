#!/usr/bin/env python3
"""Independent reconstruction and full exact replay of the degree-nine theorem."""
from __future__ import annotations

import hashlib
from itertools import product
import json
from pathlib import Path
import re
import struct
import subprocess
import tempfile

HERE = Path(__file__).resolve().parent
P = 331
WEIGHTS = (1, 9, 4, 3, 5)


def independent_basis():
    # Cartesian enumeration is deliberately independent of the recursive
    # compositions enumeration in generate_instance.py.
    return tuple(
        exponents
        for exponents in product(range(10), repeat=5)
        if sum(exponents) == 9
        and sum(e * w for e, w in zip(exponents, WEIGHTS)) % 11 == 1
    )


def translate(exponents, amount):
    return tuple(exponents[(index - amount) % 5] for index in range(5))


def independent_expansion(character):
    basis = independent_basis()
    coordinates = []
    for index in range(5):
        scalar = pow(64, character * index, P)
        coordinates.append(
            [
                (translate(exponents, index), coefficient, scalar)
                for coefficient, exponents in enumerate(basis)
            ]
        )
    landing = {}
    for index in range(5):
        for ea, a, sa in coordinates[index]:
            for eb, b, sb in coordinates[index]:
                for ec, c, sc in coordinates[(index + 1) % 5]:
                    source = tuple(
                        ea[position] + eb[position] + ec[position]
                        for position in range(5)
                    )
                    term = tuple(sorted((a, b, c)))
                    polynomial = landing.setdefault(source, {})
                    polynomial[term] = (
                        polynomial.get(term, 0) + sa * sb * sc
                    ) % P
    return {
        source: {term: value for term, value in polynomial.items() if value}
        for source, polynomial in landing.items()
        if any(polynomial.values())
    }


def support_hash(equations):
    digest = hashlib.sha256()
    for source in sorted(equations):
        digest.update(
            (str(source) + ":" + str(sorted(equations[source])) + "\n").encode()
        )
    return digest.hexdigest()


def encode(equations):
    result = bytearray(struct.pack("<II", len(independent_basis()), len(equations)))
    for polynomial in equations.values():
        result.extend(struct.pack("<I", len(polynomial)))
        for term in polynomial:
            low = high = 0
            for variable in set(term):
                if variable < 64:
                    low |= 1 << variable
                else:
                    high |= 1 << (variable - 64)
            result.extend(struct.pack("<QQ", low, high))
    return bytes(result)


def main():
    certificate = json.loads((HERE / "certificate.json").read_text())
    assert certificate["schema"] == "klein-f55-degree9-singleton-deletion-certificate-v1"
    assert certificate["split_good_fibre"] == {
        "prime": 331,
        "prime_mod_55": 1,
        "primitive_fifth_root": 64,
    }
    assert pow(64, 5, 331) == 1 and 64 != 1
    assert all(
        WEIGHTS[(index + 1) % 5] == -2 * WEIGHTS[index] % 11
        for index in range(5)
    )

    basis = independent_basis()
    assert len(basis) == certificate["complete_instance"]["coefficient_dimension"] == 65
    expansions = {character: independent_expansion(character) for character in range(5)}
    hashes = {character: support_hash(equations) for character, equations in expansions.items()}
    expected_support_hash = certificate["complete_instance"][
        "term_support_sha256_all_characters"
    ]
    assert set(hashes.values()) == {expected_support_hash}
    equations = expansions[0]
    assert len(equations) == certificate["complete_instance"]["equation_count"] == 2860
    assert (
        sum(len(polynomial) for polynomial in equations.values())
        == certificate["complete_instance"]["coefficient_term_count"]
        == 697125
    )
    raw = encode(equations)
    assert len(raw) == certificate["complete_instance"]["generated_instance_bytes"] == 11165448
    assert (
        hashlib.sha256(raw).hexdigest()
        == certificate["complete_instance"]["generated_instance_sha256"]
        == "6d76ef7393f5a03131787ec149b9e6f3c43d39464befac19c8bebe312730be03"
    )
    print("PASS independent degree-nine basis and all-character landing expansion", flush=True)
    print("PASS exact generated instance hash without installing the 11 MB instance", flush=True)

    frozen = (HERE / "terminal_reverse.out").read_text()
    assert frozen == (
        "INSTANCE VARIABLES=65 EQUATIONS=2860 TERMS=697125 ORDER=REVERSE\n"
        "RESULT NO_STOPPING_SUPPORT NODES=26912397 SEEN=26912397\n"
    )

    with tempfile.TemporaryDirectory(prefix="f55_degree9_verify_") as temporary:
        temporary = Path(temporary)
        instance = temporary / "degree9.instance"
        executable = temporary / "delete_supports"
        instance.write_bytes(raw)
        subprocess.run(
            [
                "c++",
                "-O3",
                "-std=c++17",
                str(HERE / "delete_supports.cpp"),
                "-o",
                str(executable),
            ],
            check=True,
        )
        process = subprocess.Popen(
            [str(executable), str(instance)],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        assert process.stdout is not None
        lines = []
        for line in process.stdout:
            print(line, end="", flush=True)
            lines.append(line)
        return_code = process.wait()
        assert return_code == 0
        output = "".join(lines)

    terminal = re.search(
        r"^RESULT (NO_STOPPING_SUPPORT|FOUND_STOPPING_SUPPORT) "
        r"NODES=(\d+) SEEN=(\d+)$",
        output,
        re.MULTILINE,
    )
    assert terminal
    expected = certificate["deletion_certificate"]
    assert terminal.group(1) == expected["terminal_result"] == "NO_STOPPING_SUPPORT"
    assert int(terminal.group(2)) == expected["visited_nodes"] == 26912397
    assert int(terminal.group(3)) == expected["memoized_supports_seen"] == 26912397
    print("PASS full exact reverse-order deletion replay: 26912397 supports exhausted")
    print("PASS no nonempty stopping support in the complete degree-nine coefficient space")
    print("F55_DEGREE9_SINGLETON_CERTIFICATE_INDEPENDENT_REPLAY_OK")


if __name__ == "__main__":
    main()
