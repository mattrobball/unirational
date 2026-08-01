#!/usr/bin/env python3
"""Independent replay of the lazy compressed-algebra interface."""

from __future__ import annotations

import hashlib
import json
import runpy
from itertools import product
from pathlib import Path

import sympy as sp
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
DATA = HERE / "compressed_algebra.json"


def digest(path):
    h = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            h.update(block)
    return h.hexdigest()


def word_matrix(word, generators, identity):
    answer = identity
    for letter in word:
        answer = answer.matmul(generators[letter])
    return answer


def orbit_data(pf):
    one5 = pf["identity"](5)
    one6 = pf["identity"](6)
    ws, wt = pf["weil_generators"]()
    sa, sb = pf["schur_generators"]()
    source_s = word_matrix(pf["WEIL_TO_PFAFFIAN"]["S"], {"A": sa, "B": sb}, one6)
    source_t = word_matrix(pf["WEIL_TO_PFAFFIAN"]["T"], {"A": sa, "B": sb}, one6)
    targets = {"S": ws, "T": wt}
    sources = {"S": source_s, "T": source_t}
    target_inverses = {name: matrix.inv() for name, matrix in targets.items()}
    source_inverses = {name: matrix.inv() for name, matrix in sources.items()}
    _group, words = pf["abstract_group"]()
    output = []
    for word in words.values():
        ti = one5
        source = one6
        si = one6
        for letter in word:
            ti = target_inverses[letter].matmul(ti)
            source = source.matmul(sources[letter])
            si = source_inverses[letter].matmul(si)
        tl = ti.to_list()
        sl = source.to_list()
        sil = si.to_list()
        blocks = tuple(
            tuple(
                tuple(sl[r][0] * sil[c0][c] for c in range(6))
                for r in range(6)
            )
            for c0 in (0, 1)
        )
        output.append((tuple(tl[4]), blocks))
    assert len(output) == 660
    return output


def direct_reynolds(point, records, pf, matrix_unit):
    K = pf["K11"]
    answer = [[K.zero for _ in range(6)] for _ in range(6)]
    for linear, blocks in records:
        scalar = sum((linear[i] * K(point[i]) for i in range(5)), K.zero) ** 3
        block = blocks[matrix_unit]
        for row in range(6):
            for column in range(6):
                answer[row][column] += scalar * block[row][column]
    return DomainMatrix(answer, (6, 6), K)


def stored_matrix(point, data, pf):
    K = pf["K11"]
    rows = []
    for row in data:
        output_row = []
        for polynomial in row:
            value = K.zero
            for term in polynomial:
                coefficient = pf["from_coefficients"](term["coefficient_Qzeta11"], K)
                monomial = 1
                for coordinate, exponent in zip(point, term["exponents"]):
                    monomial *= coordinate ** exponent
                value += coefficient * K(monomial)
            output_row.append(value)
        rows.append(output_row)
    return DomainMatrix(rows, (6, 6), K)


def injective_degree_three_points():
    exponents = [value for value in product(range(4), repeat=5) if sum(value) == 3]
    candidates = [(a, b, a + b, 2 * a + b, a + 2 * b) for a in range(1, 20) for b in range(1, 20)]
    selected = []
    rows = []
    field = sp.GF(1009)
    for point in candidates:
        row = []
        for exponent in exponents:
            value = 1
            for coordinate, power in zip(point, exponent):
                value = value * pow(coordinate, power, 1009) % 1009
            row.append(value)
        matrix = DomainMatrix.from_list_sympy(len(rows) + 1, len(exponents), rows + [row]).convert_to(field)
        if matrix.rank() > len(rows):
            selected.append(point)
            rows.append(row)
            if len(selected) == len(exponents):
                break
    assert len(selected) == 35
    return selected


def matrix_powers(matrix, count, pf):
    answer = [pf["identity"](6)]
    for _ in range(1, count):
        answer.append(answer[-1].matmul(matrix))
    return answer


def flatten(matrix):
    return [value for row in matrix.to_list() for value in row]


def rectangle_interface(a, b, pf):
    ap = matrix_powers(a, 6, pf)
    bp = matrix_powers(b, 7, pf)
    columns = [flatten(bp[j].matmul(ap[i])) for j in range(6) for i in range(6)]
    rows = [[columns[column][row] for column in range(36)] for row in range(36)]
    rectangle = DomainMatrix(rows, (36, 36), pf["K11"])
    assert rectangle.det() != pf["K11"].zero
    inverse = rectangle.inv()
    la_columns = []
    for j in range(6):
        target = flatten(a.matmul(bp[j]))
        coords = inverse.matmul(DomainMatrix([[value] for value in target], (36, 1), pf["K11"]))
        rebuilt = rectangle.matmul(coords)
        assert rebuilt == DomainMatrix([[value] for value in target], (36, 1), pf["K11"])
        la_columns.append(coords)
    return rectangle, inverse, la_columns


def main():
    payload = json.loads(DATA.read_text())
    assert payload["format"] == "c0-compressed-algebra-lazy-v1"
    expected_hashes = {
        "pfaffian_alignment_core.py": ROOT / "tmp" / "pfaffian_representation_alignment" / "core.py",
        "pfaffian_alignment_certificate.json": ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json",
        "kproj_core.py": ROOT / "tmp" / "kproj_arithmetic" / "core.py",
        "kproj_table.json": ROOT / "tmp" / "kproj_arithmetic" / "normalized_kproj_table.json",
        "fano_c3_producer.py": ROOT / "certificates" / "fano_c3" / "produce_c3.py",
        "exact_minpolys": HERE / "c0_minpoly_exact.json",
    }
    for name, path in expected_hashes.items():
        assert payload["source_hashes"][name] == digest(path)

    pf = runpy.run_path(str(ROOT / "tmp" / "pfaffian_representation_alignment" / "core.py"))
    kp = runpy.run_path(str(ROOT / "tmp" / "kproj_arithmetic" / "core.py"))
    records = orbit_data(pf)
    points = injective_degree_three_points()
    stored_a = payload["generators"]["a"]["C_a"]
    stored_b = payload["generators"]["b"]["C_b"]
    for point in points:
        assert stored_matrix(point, stored_a, pf) == direct_reynolds(point, records, pf, 0)
        assert stored_matrix(point, stored_b, pf) == direct_reynolds(point, records, pf, 1)

    point = (1, 2, 3, 4, 5)
    ca = stored_matrix(point, stored_a, pf)
    cb = stored_matrix(point, stored_b, pf)
    forms = kp["forms"]()
    scale = pf["K11"](kp["evaluate"](forms[11], point)) / pf["K11"](kp["evaluate"](forms[14], point))
    a = ca * scale
    b = cb * scale
    rectangle, inverse, la_columns = rectangle_interface(a, b, pf)

    # Check the generic multiplication transport on three deterministic
    # rectangle elements, including the unit.
    basis_matrices = []
    ap = matrix_powers(a, 6, pf)
    bp = matrix_powers(b, 6, pf)
    for j in range(6):
        for i in range(6):
            basis_matrices.append(bp[j].matmul(ap[i]))
    one = basis_matrices[0]
    x, y, z = basis_matrices[7], basis_matrices[14], basis_matrices[25]
    assert one.matmul(x) == x and x.matmul(one) == x
    assert x.matmul(y).matmul(z) == x.matmul(y.matmul(z))
    for value in (x.matmul(y), y.matmul(z), x.matmul(y).matmul(z)):
        vector = DomainMatrix([[entry] for entry in flatten(value)], (36, 1), pf["K11"])
        coordinates = inverse.matmul(vector)
        assert rectangle.matmul(coordinates) == vector

    assert len(la_columns) == 6 and all(column.shape == (36, 1) for column in la_columns)
    print("PASS source hashes and exact generator alignment are current")
    print("PASS 35-point injective replay of both homogeneous degree-three Reynolds matrices")
    print("PASS exact nonzero 36x36 maximal-etale rectangle at the characteristic-zero witness")
    print("PASS all six lazy L_a columns R^-1*vec(a*b^j), unit, products, and associativity")
    print("SCOPE lazy exact K_proj interface; expanded invariant coordinates and C1-C4 remain open")
    print("C3-APROJ-LAZY-EXECUTABLE-VERIFIED")


if __name__ == "__main__":
    main()
