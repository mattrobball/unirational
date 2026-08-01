#!/usr/bin/env python3
"""Run the independent shared verifier against this isolated payload."""

from pathlib import Path
import runpy
from itertools import product
import math
import json

import sympy as sp
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
SHARED = HERE.parent / "C_PFAFFIAN_FANO" / "verify_compressed_algebra.py"


def main():
    namespace = runpy.run_path(str(SHARED))
    payload = json.loads((HERE / "compressed_algebra.json").read_text())
    assert payload["format"] == "c0-compressed-algebra-lazy-v1"
    expected_hashes = {
        "pfaffian_alignment_core.py": namespace["ROOT"] / "tmp/pfaffian_representation_alignment/core.py",
        "pfaffian_alignment_certificate.json": namespace["ROOT"] / "tmp/pfaffian_representation_alignment/certificate.json",
        "kproj_core.py": namespace["ROOT"] / "tmp/kproj_arithmetic/core.py",
        "kproj_table.json": namespace["ROOT"] / "tmp/kproj_arithmetic/normalized_kproj_table.json",
        "fano_c3_producer.py": namespace["ROOT"] / "certificates/fano_c3/produce_c3.py",
        "exact_minpolys": namespace["ROOT"] / "goals_2026-08-01/C_PFAFFIAN_FANO/c0_minpoly_exact.json",
    }
    for name, path in expected_hashes.items():
        assert payload["source_hashes"][name] == namespace["digest"](path)

    pf = runpy.run_path(str(namespace["ROOT"] / "tmp/pfaffian_representation_alignment/core.py"))
    kp = runpy.run_path(str(namespace["ROOT"] / "tmp/kproj_arithmetic/core.py"))
    records = namespace["orbit_data"](pf)

    exponents = [value for value in product(range(4), repeat=5) if sum(value) == 3]
    def rebuild(matrix_unit):
        K = pf["K11"]
        polynomials = [[{} for _ in range(6)] for _ in range(6)]
        for linear, blocks in records:
            block = blocks[matrix_unit]
            for exponent in exponents:
                coefficient = K(math.factorial(3))
                for power in exponent:
                    coefficient /= K(math.factorial(power))
                for value, power in zip(linear, exponent):
                    coefficient *= value ** power
                if coefficient == K.zero:
                    continue
                for row in range(6):
                    for column in range(6):
                        polynomials[row][column][exponent] = polynomials[row][column].get(exponent, K.zero) + coefficient * block[row][column]
        return [
            [[
                {"exponents": list(exponent), "coefficient_Qzeta11": pf["coefficients"](coefficient, 10)}
                for exponent, coefficient in sorted(poly.items()) if coefficient != K.zero
            ] for poly in row]
            for row in polynomials
        ]

    assert rebuild(0) == payload["generators"]["a"]["C_a"]
    assert rebuild(1) == payload["generators"]["b"]["C_b"]

    c3 = runpy.run_path(str(namespace["ROOT"] / "certificates/fano_c3/produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    kpm = {}
    kpcore = namespace["ROOT"] / "tmp/kproj_arithmetic/core.py"
    exec(compile(kpcore.read_text().replace("ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{namespace['ROOT']}')"), str(kpcore), "exec"), kpm)
    forms = kpm["forms"]()
    seeds = json.loads((namespace["ROOT"] / "tmp/pfaffian_representation_alignment/certificate.json").read_text())["end36_reynolds_frame"]["selected_reynolds_seeds"]

    def eval_mod(data, point, p, zeta):
        answer = []
        for row in data:
            output_row = []
            for polynomial in row:
                value = 0
                for term in polynomial:
                    coefficient = sum(
                        int(num) * pow(int(den), -1, p) * pow(zeta, exponent, p)
                        for exponent, (num, den) in enumerate(term["coefficient_Qzeta11"])
                    ) % p
                    monomial = coefficient
                    for coordinate, power in zip(point, term["exponents"]):
                        monomial = monomial * pow(int(coordinate), int(power), p) % p
                    value = (value + monomial) % p
                output_row.append(value)
            answer.append(output_row)
        import numpy as np
        return np.asarray(answer, dtype=np.int64)

    modular = []
    for p, zeta, point in ((331, 74, (2, 3, 5, 7, 11)), (463, 15, (2, 3, 5, 7, 11))):
        conjugation, inverses = c3["build_group"](c2, p, zeta)
        frame, _vectors = c3["frame_at_point"](c2, conjugation, inverses, seeds, forms, kpm["evaluate_mod"], point, p)
        scale = kpm["evaluate_mod"](forms[11], point, p) * pow(kpm["evaluate_mod"](forms[14], point, p), -1, p) % p
        a = eval_mod(payload["generators"]["a"]["C_a"], point, p, zeta) * scale % p
        b = eval_mod(payload["generators"]["b"]["C_b"], point, p, zeta) * scale % p
        import numpy as np
        assert np.array_equal(a, frame[1] % p)
        assert np.array_equal(b, frame[2] % p)
        columns = [matrix.reshape(-1) for matrix in c3["rectangle_matrices"](a, b, p)]
        rectangle = np.stack(columns, axis=1) % p
        inverse = c3["inv_mat"](rectangle, p)
        assert c3["det_mod"](rectangle, p) != 0
        for j in range(6):
            target = (a @ c3["mat_pow"](b, j, p) % p).reshape(-1)
            coords = inverse @ target % p
            assert np.array_equal(rectangle @ coords % p, target)
        one = np.eye(6, dtype=np.int64) % p
        x, y, z = a, b, a @ b % p
        assert np.array_equal(one @ x % p, x)
        assert np.array_equal((x @ y % p) @ z % p, x @ (y @ z % p) % p)
        modular.append((p, int(c3["det_mod"](rectangle, p))))

    print("PASS source hashes and exact generator alignment are current")
    print("PASS independent coefficient-by-coefficient rebuild of both Reynolds matrices")
    print(f"PASS fresh split-prime rectangle/L_a/unit/associativity replays {modular}")
    print("PASS nonzero modular rectangle determinants prove the characteristic-zero generic open is nonempty")
    print("SCOPE lazy exact K_proj interface; expanded invariant coordinates and C1-C4 remain open")
    print("C3-APROJ-LAZY-EXECUTABLE-VERIFIED")


if __name__ == "__main__":
    main()
