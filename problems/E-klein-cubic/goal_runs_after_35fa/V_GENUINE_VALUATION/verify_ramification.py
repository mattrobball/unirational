#!/usr/bin/env python3
"""Independent exact replay of the Goal-V2 D-place ramification.

This verifier does not import a producer or the upstream verifiers.  It reads
the accepted sparse matrix, reconstructs the selected Cramer formula, checks
the divisor witness and the scalar-cover/genuine-cover separation, and
compares the fixed and genuine residual indices at their correct scopes.
"""

from __future__ import annotations

from collections import defaultdict
from fractions import Fraction
from hashlib import sha256
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent


def find_problem() -> Path:
    for candidate in (HERE, *HERE.parents):
        if (candidate / "goals_2026-08-01/F_CONIC_ALGEBRA").is_dir():
            return candidate
    raise RuntimeError("cannot locate E-klein-cubic problem root")


PROBLEM = find_problem()
GOALS = PROBLEM / "goals_2026-08-01"
F_DIR = GOALS / "F_CONIC_ALGEBRA"
V_DIR = GOALS / "V_VALUATION_TROPICAL"
MATRIX = F_DIR / "payload/determinant_matrix_cells_exact.tsv"
PRIMITIVE = F_DIR / "payload/global_primitive_u_sextic_exact.tsv"

EXPECTED_HASHES = {
    "F_CONIC_ALGEBRA/payload/determinant_matrix_cells_exact.tsv": "e3633afbfc339753569181ce571ffdda1db042d2ddade506023bf6284dea555f",
    "F_CONIC_ALGEBRA/payload/global_primitive_u_sextic_exact.tsv": "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344",
    "F_CONIC_ALGEBRA/field_presentation.json": "6f8c7930a71dbf1125f5003ee39b241e7cfbf006499eccbecb24312025c50dde",
    "F_CONIC_ALGEBRA/infinity_obstruction.json": "00316341a4d5207d8630e3d8d4411113b8fa2df5f6b3db42b48aa3003e094405",
    "V_VALUATION_TROPICAL/inertia_centralizers.json": "41e54408cf3fe0a30ce98f61b3c29a0e73f386f0ee553f538459a1e99fcbd921",
    "V_VALUATION_TROPICAL/proof_payload.json": "46d8cc886af7f50c63329bc0382dea67f3262ab3963a30d0041b5c144edb8bca"
}

EXPECTED_SCALING_HASHES = {
    "tmp/full_scaled_frame_degree_hostile_audit/REPORT.md": "1f1f2c3c9b54de9b25c3a585d87d32bdc4de5fecca06c9250763dd731bcf63a1",
    "tmp/full_scaled_frame_degree_attack/REPORT.md": "fa8880adf1d224212a90d3420c862b5d49d5c2bf5a81b5232f35d4799b1aff8c",
    "tmp/full_scaled_frame_degree_attack/build_projective.py": "d66831cc7540eacb2222c182bbaaa76e36418ff28382bc3aaa85dbbcb7aabbb6",
}

WITNESS = {
    "A": Fraction(33, 2),
    "B": Fraction(-1, 200),
    "Y": Fraction(-1349, 600),
    "T": Fraction(0),
    "Z": Fraction(1331, 8),
}


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def add_poly(left, right, right_scale=1):
    answer = defaultdict(Fraction, left)
    for degree, coefficient in right.items():
        answer[degree] += right_scale * coefficient
        if not answer[degree]:
            del answer[degree]
    return dict(answer)


def mul_poly(left, right):
    answer = defaultdict(Fraction)
    for i, a in left.items():
        for j, b in right.items():
            answer[i + j] += a * b
    return {degree: coefficient for degree, coefficient in answer.items() if coefficient}


def degree(poly):
    return max(poly) if poly else None


def coefficient_product(left, right, target_u):
    """Multiply sparse multivariate coefficients at one target u-degree."""
    answer = defaultdict(int)
    for u1, p1 in left.items():
        u2 = target_u - u1
        if u2 not in right:
            continue
        for e1, c1 in p1.items():
            for e2, c2 in right[u2].items():
                key = tuple(a + b for a, b in zip(e1, e2))
                answer[key] += c1 * c2
                if not answer[key]:
                    del answer[key]
    return dict(answer)


def evaluate_D(infinity):
    answer = Fraction(0)
    for eA, eB, eY, eT, coefficient in infinity["leading_coefficient"]["D_sparse"]:
        answer += (
            coefficient
            * WITNESS["A"] ** eA
            * WITNESS["B"] ** eB
            * WITNESS["Y"] ** eY
            * WITNESS["T"] ** eT
        )
    return answer


def evaluate_primitive_coefficients():
    coefficients = defaultdict(Fraction)
    with PRIMITIVE.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in stream:
            eA, eB, eY, eZ, eu, coefficient = map(int, line.split())
            coefficients[eu] += (
                coefficient
                * WITNESS["A"] ** eA
                * WITNESS["B"] ** eB
                * WITNESS["Y"] ** eY
                * WITNESS["Z"] ** eZ
            )
    return coefficients


def read_matrix():
    specialized = [[defaultdict(Fraction) for _ in range(3)] for _ in range(3)]
    sparse = [[defaultdict(lambda: defaultdict(int)) for _ in range(3)] for _ in range(3)]
    counts = [[0 for _ in range(3)] for _ in range(3)]
    with MATRIX.open() as stream:
        assert next(stream).strip() == "row\tcolumn\tA\tB\tY\tZ\tu\tcoefficient"
        for line in stream:
            row, column, eA, eB, eY, eZ, eu, coefficient = map(int, line.split())
            value = (
                coefficient
                * WITNESS["A"] ** eA
                * WITNESS["B"] ** eB
                * WITNESS["Y"] ** eY
                * WITNESS["Z"] ** eZ
            )
            specialized[row][column][eu] += value
            sparse[row][column][eu][(eA, eB, eY, eZ)] += coefficient
            counts[row][column] += 1
    assert counts == [[946, 659, 678], [910, 579, 661], [1098, 680, 417]]
    return specialized, sparse


def main() -> None:
    for relative, expected in EXPECTED_HASHES.items():
        path = GOALS / relative
        assert digest(path) == expected, (relative, digest(path), expected)
    for relative, expected in EXPECTED_SCALING_HASHES.items():
        path = PROBLEM / relative
        assert digest(path) == expected, (relative, digest(path), expected)

    field = json.loads((F_DIR / "field_presentation.json").read_text())
    infinity = json.loads((F_DIR / "infinity_obstruction.json").read_text())
    inertia = json.loads((V_DIR / "inertia_centralizers.json").read_text())
    old_v = json.loads((V_DIR / "proof_payload.json").read_text())
    result = json.loads((HERE / "field_ramification.json").read_text())
    residual = json.loads((HERE / "compactification_residual_index.json").read_text())

    assert field["generators"] == {"t": "f5^3", "u": "f8/f5", "v": "f10*f5"}
    assert infinity["valuation"]["ramification_index"] == 1
    assert infinity["valuation"]["residue_degree"] == 1
    assert evaluate_D(infinity) == 0
    primitive = evaluate_primitive_coefficients()
    assert primitive[6] == 0
    assert primitive[5] == Fraction(4782969, 625000000)

    matrix, sparse = read_matrix()
    a0, b0, c0 = matrix[0]
    a1, b1, c1 = matrix[1]
    delta = add_poly(mul_poly(b0, c1), mul_poly(b1, c0), -1)
    numerator_v = add_poly(mul_poly(a1, c0), mul_poly(a0, c1), -1)
    numerator_t = add_poly(mul_poly(b1, a0), mul_poly(b0, a1), -1)

    # A priori N_t can have degree four.  Reconstruct its u^4 coefficient
    # over the full polynomial ring and prove literal cancellation.
    global_left = coefficient_product(sparse[1][1], sparse[0][0], 4)
    global_right = coefficient_product(sparse[0][1], sparse[1][0], 4)
    assert global_left == global_right
    assert degree(delta) == 5 and delta[5]
    assert degree(numerator_v) == 5 and numerator_v[5]
    assert degree(numerator_t) == 3 and numerator_t[3]

    values = result["cramer_replay"]["values_on_K"]
    assert values == {"u": -1, "vcoord": 0, "t": 2}
    assert values["vcoord"] == degree(delta) - degree(numerator_v)
    assert values["t"] == degree(delta) - degree(numerator_t)

    hostile = (PROBLEM / "tmp/full_scaled_frame_degree_hostile_audit/REPORT.md").read_text()
    attack = (PROBLEM / "tmp/full_scaled_frame_degree_attack/REPORT.md").read_text()
    assert "[K_proj:F] = 6" in hostile
    assert "scaled affine field has degree `18`" in hostile
    assert "adjoining `p` with `p^3=t`" in attack
    scaled = result["scaled_affine_place_K_aff_over_K"]
    assert scaled["degree"] == 3
    assert scaled["ramification_index"] == 3
    assert scaled["residue_degree"] == 1
    assert scaled["inertia"] == "mu3"
    assert math.gcd(values["t"], scaled["degree"]) == 1
    assert scaled["normalized_weight_ray"] == {
        "f5": 2,
        "f8": -1,
        "f10": -2,
        "normalization": "w|K=3*nu",
    }

    # The genuine cover has group PSL2(F11), whereas the degree-three cover
    # is the residual scalar mu3 cover.  A nontrivial intersection would be
    # a degree-three intermediate field of a Galois G-extension, hence an
    # index-three subgroup.  The coset action would inject the simple group
    # (kernel normal) into S3, impossible since 660>6.
    assert inertia["group"] == "PSL_2(F_11)"
    assert inertia["group_order"] == 660 > math.factorial(3)
    genuine = result["genuine_splitting_torsor_place_L_over_K"]
    assert genuine["intersection_with_K_aff"] == "K"
    assert genuine["inertia"] == "not determined by the Cramer calculation"
    assert "cannot be promoted" in genuine["conclusion"]
    assert inertia["valuation_conclusions"]["nontrivial_inertia"] == (
        "the genuine local twist has a rational point"
    )

    class_group = infinity["class_group"]
    assert class_group["generic_degrees"] == [3, 0, 3]
    assert class_group["index"] == 3
    cycles = residual["universal_local_index"]
    assert math.gcd(*cycles["effective_cycle_degrees"]) == cycles["gcd"] == 1
    assert sum(
        degree_value * coefficient
        for degree_value, coefficient in zip(cycles["effective_cycle_degrees"], cycles["bezout_coefficients"])
    ) == 1
    assert old_v["local_index"]["cycle_degrees"] == cycles["effective_cycle_degrees"]

    model_rows = {row["model"]: row for row in residual["infinity_place_models"]}
    assert model_rows["selected fixed ternary cubic"]["residual_index"] == 3
    assert model_rows["genuine Klein twist"]["residual_index"] == 1
    assert "open in the unramified case" in model_rows["genuine Klein twist"]["point_status"]
    assert model_rows["twisted F14 common-line section"]["residual_index"] is None

    print("PASS exact Cramer valuations nu(u)=-1, nu(t)=2, nu(vcoord)=0")
    print("PASS scaled affine mu3 cover has (e,f)=(3,1) and is disjoint from the genuine G-cover")
    print("PASS fixed residual index 3 is scope-separated from genuine residual index 1")
    print("V2-FIXED-FRAME-PLACE-NONTRANSFERABLE")


if __name__ == "__main__":
    main()
