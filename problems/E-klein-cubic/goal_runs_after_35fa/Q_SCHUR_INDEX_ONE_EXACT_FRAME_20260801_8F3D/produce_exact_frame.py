#!/usr/bin/env python3
"""Construct the exact degree-eight Reynolds frame for the Schur twist.

The source is the six-dimensional Schur representation and the target is
the five-dimensional Weil representation carrying the Klein cubic.  This
script intentionally uses the exact generator alignment already certified
in ``tmp/pfaffian_representation_alignment/core.py``.
"""

from __future__ import annotations

import argparse
import json
import runpy
from hashlib import sha256
from math import comb
from pathlib import Path

from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
CORE_PATH = HERE / "exact_representation_core.py"
UPSTREAM_CORE = REPO / "tmp" / "pfaffian_representation_alignment" / "core.py"
OUT = HERE / "exact_frame.json"
DEGREE = 8
WITNESS = (22, 2, 13, 21, 22, 4)


def word_matrix(word, generators, identity):
    answer = identity
    for letter in word:
        answer = answer.matmul(generators[letter])
    return answer


def group_records(pf):
    """Return one exact lift of every projective group element."""
    one5 = pf["identity"](5)
    one6 = pf["identity"](6)
    ws, wt = pf["weil_generators"]()
    sa, sb = pf["schur_generators"]()
    source_s = word_matrix(
        pf["WEIL_TO_PFAFFIAN"]["S"], {"A": sa, "B": sb}, one6
    )
    source_t = word_matrix(
        pf["WEIL_TO_PFAFFIAN"]["T"], {"A": sa, "B": sb}, one6
    )
    targets_inverse = {"S": ws.inv(), "T": wt.inv()}
    sources = {"S": source_s, "T": source_t}
    _group, words = pf["abstract_group"]()
    records = []
    for abstract, word in words.items():
        target_inverse = one5
        source = one6
        for letter in word:
            # (rho(g_1)...rho(g_r))^-1 is accumulated on the left.
            target_inverse = targets_inverse[letter].matmul(target_inverse)
            source = source.matmul(sources[letter])
        records.append((abstract, word, target_inverse.to_list(), source.to_list()))
    assert len(records) == 660
    return records, (source_s, source_t), (ws, wt)


def exact_frame_value(point, records, pf):
    """Evaluate all five Reynolds columns without expanding polynomials."""
    K = pf["K11"]
    frame = [[K.zero for _ in range(5)] for _ in range(5)]
    invariant = K.zero
    for _abstract, _word, target_inverse, source in records:
        value = sum((source[5][i] * point[i] for i in range(6)), K.zero) ** DEGREE
        invariant += value
        for row in range(5):
            for seed in range(5):
                frame[row][seed] += target_inverse[row][seed] * value
    return frame, invariant


def reduce_matrix(matrix, pf, modulus=23, zeta=2):
    return [
        [pf["reduce_k11"](entry, zeta, modulus) for entry in row]
        for row in matrix
    ]


def determinant(matrix, field):
    return DomainMatrix(matrix, (len(matrix), len(matrix)), field).det()


def cubic_coefficient_table():
    """Expand sum_i L_i^2 L_(i+1) in five abstract frame columns.

    A factor ``[r,c]`` means the exact Reynolds polynomial Q[r,c].
    Keeping the entries as a straight-line table avoids an unnecessary and
    enormous expansion into degree-24 source monomials while specifying every
    coefficient without ellipses.
    """
    table = {}
    for i in range(5):
        for j in range(5):
            for k in range(5):
                for ell in range(5):
                    exponent = [0] * 5
                    for column in (j, k, ell):
                        exponent[column] += 1
                    key = ",".join(map(str, exponent))
                    table.setdefault(key, []).append(
                        [[i, j], [i, k], [(i + 1) % 5, ell]]
                    )
    assert len(table) == 35
    assert sum(map(len, table.values())) == 625
    return [
        {"a_exponents": [int(x) for x in key.split(",")], "products": table[key]}
        for key in sorted(table)
    ]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    pf = runpy.run_path(str(CORE_PATH))
    records, source_generators, target_generators = group_records(pf)

    frame, invariant = exact_frame_value(WITNESS, records, pf)
    det = determinant(frame, pf["K11"])
    reduced = reduce_matrix(frame, pf)
    invariant_mod23 = pf["reduce_k11"](invariant, 2, 23)
    det_mod23 = pf["reduce_k11"](det, 2, 23)
    print(f"projectiveGroupOrder={len(records)}")
    print(f"frameAtWitnessMod23={reduced}")
    print(f"frameDeterminantAtWitnessMod23={det_mod23}")
    print(f"scalarInvariantAtWitnessMod23={invariant_mod23}")
    assert det != pf["K11"].zero
    assert invariant != pf["K11"].zero

    # Direct exact covariance/invariance checks at the witness.
    K = pf["K11"]
    for source_generator, target_generator in zip(source_generators, target_generators):
        source_rows = source_generator.to_list()
        transformed_point = tuple(
            sum((source_rows[row][column] * K(WITNESS[column]) for column in range(6)), K.zero)
            for row in range(6)
        )
        transformed_frame, transformed_invariant = exact_frame_value(
            transformed_point, records, pf
        )
        expected = target_generator.matmul(DomainMatrix(frame, (5, 5), K)).to_list()
        assert transformed_frame == expected
        assert transformed_invariant == invariant
    print("PASS exact generator covariance and scalar invariance at witness")
    print("PASS exact Reynolds frame has generically nonzero determinant")

    if args.write:
        coefficient_table = cubic_coefficient_table()
        payload = {
            "format": "q-schur-exact-degree8-frame-v1",
            "headline": "EXACT_FRAME_NONDEGENERATE",
            "field": "Q(zeta_11), Phi_11(zeta_11)=0",
            "source": "six-dimensional Schur representation",
            "target": "five-dimensional Weil representation carrying the Klein cubic",
            "degree": DEGREE,
            "projective_group_order": len(records),
            "reynolds_seed": [0, 0, 0, 0, 0, 8],
            "frame_seeds": [[j, [0, 0, 0, 0, 0, 8]] for j in range(5)],
            "frame_entry_formula": {
                "Q_rj(v)": "sum_g (rho5(g)^(-1))_rj * ((rho6(g)v)_5)^8",
                "group": "the 660 projective words listed in projective_words",
                "indices": "r,j=0,...,4; source coordinate 5 is zero-based",
                "normalized_frame": "R=Q/I8 with I8(v)=sum_g((rho6(g)v)_5)^8",
                "projective_equation": "sum_i (sum_j Q_ij a_j)^2 (sum_j Q_(i+1)j a_j)=0",
            },
            "projective_words": [word for _abstract, word, _ti, _s in records],
            "source_generators_ST": [
                pf["serialize_matrix"](matrix, 10) for matrix in source_generators
            ],
            "target_generators_ST": [
                pf["serialize_matrix"](matrix, 10) for matrix in target_generators
            ],
            "cubic_coefficient_table": coefficient_table,
            "cubic_coefficient_table_semantics": {
                "entry": "coefficient of a^a_exponents",
                "products": "sum of products of the three Q entries indexed by [row,column]",
                "number_of_coefficients": len(coefficient_table),
                "number_of_ordered_products": sum(
                    len(entry["products"]) for entry in coefficient_table
                ),
            },
            "witness": list(WITNESS),
            "frame_at_witness": [
                [pf["coefficients"](entry, 10) for entry in row] for row in frame
            ],
            "determinant_at_witness": pf["coefficients"](det, 10),
            "scalar_invariant_at_witness": pf["coefficients"](invariant, 10),
            "good_reduction": {
                "prime": 23,
                "zeta_11": 2,
                "frame": reduced,
                "determinant": det_mod23,
                "scalar_invariant": invariant_mod23,
            },
            "generator_alignment": {
                "A": pf["PFAFFIAN_TO_WEIL"]["A"],
                "B": pf["PFAFFIAN_TO_WEIL"]["B"],
                "S": pf["WEIL_TO_PFAFFIAN"]["S"],
                "T": pf["WEIL_TO_PFAFFIAN"]["T"],
            },
            "source_core": {
                "packet_path": CORE_PATH.name,
                "sha256": sha256(CORE_PATH.read_bytes()).hexdigest(),
                "upstream_relative_path": str(UPSTREAM_CORE.relative_to(REPO)),
                "upstream_sha256": sha256(UPSTREAM_CORE.read_bytes()).hexdigest(),
            },
            "monomial_count_per_entry_upper_bound": comb(DEGREE + 5, 5),
        }
        OUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
        print(f"WROTE {OUT.name}")


if __name__ == "__main__":
    main()
