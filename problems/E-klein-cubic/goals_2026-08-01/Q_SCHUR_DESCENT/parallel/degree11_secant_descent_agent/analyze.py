#!/usr/bin/env python3
"""Exact good-fibre audit of the six transferred A5 degree-11 orbits.

This extends the sealed rational-normal-quartic probe in two directions:

* the two class-1 roots living in F_(89^2) are included;
* all 55 pair secants are intersected with the Klein cubic and compared with
  the corresponding D12 contained-line orbit.

The finite-field computation is used only through closed/rank conditions:
nonzero minors and nonincidence at this good fibre certify that the analogous
generic identities are not identically zero.
"""

from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
import importlib.util
import itertools
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
RNC = HERE.parent / "a5_orbit_rnc_agent" / "probe_rnc_rank.py"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


BASE = load_module("sealed_a5_rnc_probe", RNC)
P = BASE.P
NONSQUARE = 65


@dataclass(frozen=True)
class F89x2:
    """F_89[u]/(u^2-65), with enough Python arithmetic for BASE helpers."""

    a: int = 0
    b: int = 0

    def __post_init__(self):
        object.__setattr__(self, "a", self.a % P)
        object.__setattr__(self, "b", self.b % P)

    @staticmethod
    def coerce(value):
        return value if isinstance(value, F89x2) else F89x2(int(value), 0)

    def __add__(self, other):
        other = self.coerce(other)
        return F89x2(self.a + other.a, self.b + other.b)

    __radd__ = __add__

    def __neg__(self):
        return F89x2(-self.a, -self.b)

    def __sub__(self, other):
        return self + (-self.coerce(other))

    def __rsub__(self, other):
        return self.coerce(other) - self

    def __mul__(self, other):
        other = self.coerce(other)
        return F89x2(
            self.a * other.a + NONSQUARE * self.b * other.b,
            self.a * other.b + self.b * other.a,
        )

    __rmul__ = __mul__

    def inverse(self):
        norm = (self.a * self.a - NONSQUARE * self.b * self.b) % P
        if not norm:
            raise ZeroDivisionError
        unit = pow(norm, -1, P)
        return F89x2(self.a * unit, -self.b * unit)

    def __truediv__(self, other):
        return self * self.coerce(other).inverse()

    def __rtruediv__(self, other):
        return self.coerce(other) / self

    def __pow__(self, exponent: int, modulus=None):
        if exponent < 0:
            return self.inverse() ** (-exponent)
        out = F89x2(1)
        base = self
        while exponent:
            if exponent & 1:
                out = out * base
            base = base * base
            exponent >>= 1
        return out

    def __mod__(self, modulus):
        assert modulus == P
        return self

    def __bool__(self):
        return bool(self.a or self.b)

    def __eq__(self, other):
        try:
            other = self.coerce(other)
        except (TypeError, ValueError):
            return False
        return self.a == other.a and self.b == other.b

    def __repr__(self):
        if not self.b:
            return str(self.a)
        return f"({self.a}+{self.b}u)"


def rank(rows):
    return BASE.matrix_rank(rows)


def linear_row(point):
    return list(point)


def field_to_json(value):
    if isinstance(value, F89x2):
        return [value.a, value.b]
    return int(value) % P


def vector_to_json(vector):
    return [field_to_json(value) for value in vector]


def singular_coefficient(value):
    value = F89x2.coerce(value)
    if not value.b:
        return str(value.a)
    return f"({value.a}+{value.b}*u)"


def polynomial_string(coefficients, exponents):
    terms = []
    for coefficient, exponent in zip(coefficients, exponents):
        coefficient = F89x2.coerce(coefficient)
        if not coefficient:
            continue
        monomial = "*".join(
            f"x{i}^{power}" for i, power in enumerate(exponent) if power
        ) or "1"
        terms.append(f"{singular_coefficient(coefficient)}*{monomial}")
    return "+".join(terms) or "0"


def parse_hilbert_vector(line):
    return [int(value) for value in line.strip().split(",") if value.strip()]


def quadric_base_audit(points):
    """Check the four-quadric base and its intersection with X in Singular."""
    kernel = BASE.nullspace([BASE.quadric_row(point) for point in points])
    assert len(kernel) == 4
    quadrics = [polynomial_string(row, BASE.QUADRICS) for row in kernel]
    jacobian_ranks = []
    for point in points:
        gradients = []
        for coefficients in kernel:
            gradient = []
            for variable in range(5):
                value = 0
                for coefficient, exponent in zip(coefficients, BASE.QUADRICS):
                    if exponent[variable]:
                        monomial = coefficient * exponent[variable]
                        for index, power in enumerate(exponent):
                            adjusted = power - int(index == variable)
                            monomial = monomial * point[index] ** adjusted
                        value = value + monomial
                gradient.append(value % P)
            gradients.append(gradient)
        jacobian_ranks.append(rank(gradients))

    point_ideals = []
    for point in points:
        pivot = next(index for index, value in enumerate(point) if value)
        generators = []
        for index in range(5):
            if index == pivot:
                continue
            generators.append(
                f"{singular_coefficient(point[pivot])}*x{index}"
                f"-{singular_coefficient(point[index])}*x{pivot}"
            )
        point_ideals.append(",".join(generators))
    klein_terms = []
    for i in range(5):
        exponent = [0] * 5
        exponent[i] = 2
        exponent[(i + 1) % 5] += 1
        klein_terms.append("*".join(f"x{j}^{e}" for j, e in enumerate(exponent) if e))
    klein = "+".join(klein_terms)
    point_code = " ".join(
        f"ideal Z{index}={generators};" for index, generators in enumerate(point_ideals)
    )
    intersection_code = "ideal Z=Z0; " + " ".join(
        f"Z=intersect(Z,Z{index});" for index in range(1, len(point_ideals))
    )
    code = (
        "ring r=(89,u),(x0,x1,x2,x3,x4),dp; minpoly=u2-65; "
        f"ideal I={','.join(quadrics)}; ideal G=std(I); "
        'print("BASE_DIM"); print(dim(G)); print("BASE_HILB"); hilb(G,2); '
        f"ideal J=I,{klein}; ideal H=std(J); "
        'print("ON_X_DIM"); print(dim(H)); print("ON_X_HILB"); hilb(H,2); '
        + point_code + " " + intersection_code
        + ' ideal R=quotient(I,Z); ideal RG=std(R); print("RES_DIM"); print(dim(RG)); print("RES_HILB"); hilb(RG,2); '
        + f" poly f={klein}; print(\"RES_F_ZERO\"); print(reduce(f,RG)==0);"
        + f" ideal RF=R,f; ideal RFG=std(RF); print(\"RES_ON_X_DIM\"); print(dim(RFG));"
        + ' print("RES_ON_X_HILB"); hilb(RFG,2); exit;'
    )
    process = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", "--execute", code],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=120,
        check=True,
    )
    lines = [line.strip() for line in process.stdout.splitlines() if line.strip()]
    positions = {
        marker: lines.index(marker)
        for marker in (
            "BASE_DIM", "BASE_HILB", "ON_X_DIM", "ON_X_HILB",
            "RES_DIM", "RES_HILB", "RES_F_ZERO", "RES_ON_X_DIM", "RES_ON_X_HILB",
        )
    }
    base_dimension = int(lines[positions["BASE_DIM"] + 1])
    base_hilbert = parse_hilbert_vector(lines[positions["BASE_HILB"] + 1])
    on_x_dimension = int(lines[positions["ON_X_DIM"] + 1])
    on_x_hilbert = parse_hilbert_vector(lines[positions["ON_X_HILB"] + 1])
    residual_dimension = int(lines[positions["RES_DIM"] + 1])
    residual_hilbert = parse_hilbert_vector(lines[positions["RES_HILB"] + 1])
    residual_f_zero = bool(int(lines[positions["RES_F_ZERO"] + 1]))
    residual_on_x_dimension = int(lines[positions["RES_ON_X_DIM"] + 1])
    residual_on_x_hilbert = parse_hilbert_vector(
        lines[positions["RES_ON_X_HILB"] + 1]
    )
    return {
        "quadric_kernel_dimension": len(kernel),
        "quadric_base_affine_cone_dimension": base_dimension,
        "quadric_base_h_vector": base_hilbert,
        "quadric_base_projective_degree": sum(base_hilbert),
        "quadric_base_intersect_klein_affine_cone_dimension": on_x_dimension,
        "quadric_base_intersect_klein_h_vector": on_x_hilbert,
        "quadric_base_intersect_klein_projective_degree": sum(on_x_hilbert),
        "orbit_point_quadric_jacobian_ranks": jacobian_ranks,
        "linked_residual_affine_cone_dimension": residual_dimension,
        "linked_residual_h_vector": residual_hilbert,
        "linked_residual_projective_degree": sum(residual_hilbert),
        "linked_residual_linear_span_dimension": (
            (residual_hilbert[0] + residual_hilbert[1] - 1)
            if len(residual_hilbert) >= 2 else 0
        ),
        "linked_residual_plus_klein_affine_dimension": residual_on_x_dimension,
        "klein_vanishes_identically_on_linked_residual": residual_f_zero,
        "linked_residual_intersect_klein_h_vector": residual_on_x_hilbert,
        "linked_residual_intersect_klein_degree_if_projective_nonempty": (
            sum(residual_on_x_hilbert) if residual_on_x_dimension == 1 else 0
        ),
    }


def parameter_vector(radical_sign, alpha):
    relations = json.loads(
        (BASE.POINT / "degree11_reconstructed_relations.json").read_text()
    )["relations"]
    coordinates = [1]
    for index in (1, 2, 3):
        value = 0
        for degree in range(3):
            coefficient = BASE.field_constant(
                relations[f"a{index}_{degree}"], radical_sign
            )
            value = value + coefficient * alpha**degree
        coordinates.append(value % P)
    coordinates.append(alpha)
    return tuple(coordinates)


def alpha_cubic(radical_sign):
    relations = json.loads(
        (BASE.POINT / "degree11_reconstructed_relations.json").read_text()
    )["relations"]
    return tuple(
        BASE.field_constant(relations[name], radical_sign)
        for name in ("p2", "p1", "p0")
    )


def cubic_value(alpha, coefficients):
    p2, p1, p0 = coefficients
    return alpha**3 + p2 * alpha**2 + p1 * alpha + p0


def class1_roots():
    # t^3+56t^2+69t+18=(t-80)(t^2+47t+2), and disc=65.
    u = F89x2(0, 1)
    roots = (F89x2(80), F89x2(21) + 45 * u, F89x2(21) - 45 * u)
    coefficients = alpha_cubic(-1)
    assert coefficients == (56, 69, 18)
    assert all(not cubic_value(root, coefficients) for root in roots)
    assert roots[1] ** P == roots[2]
    return roots


def class2_roots():
    roots = tuple(F89x2(value) for value in (49, 51, 75))
    coefficients = alpha_cubic(1)
    assert coefficients == (3, 31, 9)
    assert all(not cubic_value(root, coefficients) for root in roots)
    return roots


def coset_data(subgroup):
    representatives = BASE.right_coset_representatives(subgroup)
    cosets = [
        frozenset(BASE.PRODUCE.gmul(representative, h) for h in subgroup)
        for representative in representatives
    ]
    owner = {element: index for index, coset in enumerate(cosets) for element in coset}
    assert len(owner) == 660
    return representatives, cosets, owner


def pair_stabilizer(pair, representatives, owner):
    i, j = pair
    target = {i, j}
    return frozenset(
        g
        for g in BASE.PRODUCE.GROUP
        if {
            owner[BASE.PRODUCE.gmul(g, representatives[i])],
            owner[BASE.PRODUCE.gmul(g, representatives[j])],
        }
        == target
    )


def group_order_distribution(group):
    return dict(sorted(Counter(BASE.PRODUCE.ORDERS[g] for g in group).items()))


def line_coefficients(left, right):
    """Coefficients of s^2 t and s t^2 in F(s left+t right)."""
    a = sum(
        left[i] * left[i] * right[(i + 1) % 5]
        + 2 * left[i] * right[i] * left[(i + 1) % 5]
        for i in range(5)
    ) % P
    b = sum(
        right[i] * right[i] * left[(i + 1) % 5]
        + 2 * left[i] * right[i] * right[(i + 1) % 5]
        for i in range(5)
    ) % P
    return a, b


def third_intersection(left, right):
    a, b = line_coefficients(left, right)
    if not a and not b:
        return None
    point = [(b * x - a * y) % P for x, y in zip(left, right)]
    assert any(point) and BASE.klein(point) == 0
    return point


def contained_d12_line(stabilizer):
    central_involutions = [
        g
        for g in stabilizer
        if BASE.PRODUCE.ORDERS[g] == 2
        and all(
            BASE.PRODUCE.gmul(g, h) == BASE.PRODUCE.gmul(h, g)
            for h in stabilizer
        )
    ]
    assert len(central_involutions) == 1
    tau = central_involutions[0]
    matrix = BASE.PRODUCE.RHO[tau]
    columns = [
        [int(i == j) - matrix[i][j] for i in range(5)]
        for j in range(5)
    ]
    basis = []
    for column in columns:
        if any(column) and rank(basis + [column]) > len(basis):
            basis.append(column)
    assert len(basis) == 2
    assert line_coefficients(basis[0], basis[1]) == (0, 0)
    return tuple(tuple(value % P for value in vector) for vector in basis)


def point_on_line(point, line):
    return rank([list(line[0]), list(line[1]), list(point)]) == 2


def build_orbit(record, radical_sign, alpha, covariants):
    subgroup = tuple(tuple(value) for value in record["subgroup_elements"])
    generators = tuple(tuple(value) for value in record["generators"])
    abstract_map = {
        tuple(row["h"]): tuple(row["permutation"]) for row in record["source_map"]
    }
    intertwiner = BASE.ambient_intertwiner(generators, abstract_map)
    vector = (1, 4, 5, 5, 6)
    frame = BASE.transfer_frame(vector, subgroup, abstract_map)
    assert frame is not None and BASE.determinant(frame)
    parameters = parameter_vector(radical_sign, alpha)
    representatives, _cosets, owner = coset_data(subgroup)

    def q_at(full_source_point):
        local_frame = BASE.transfer_frame(full_source_point, subgroup, abstract_map)
        assert local_frame is not None and BASE.determinant(local_frame)
        source_point = [local_frame[row][0] for row in range(3)]
        canonical = BASE.canonical_point(source_point, parameters, covariants)
        return BASE.mat_vec(intertwiner, canonical)

    base = q_at(vector)
    assert any(base) and BASE.klein(base) == 0
    for h in generators:
        assert q_at(BASE.mat_vec(BASE.PRODUCE.RHO[h], vector)) == BASE.mat_vec(
            BASE.PRODUCE.RHO[h], base
        )

    points = []
    for representative in representatives:
        moved_source = BASE.mat_vec(
            BASE.PRODUCE.RHO[BASE.PRODUCE.ginv(representative)], vector
        )
        raw = q_at(moved_source)
        points.append(BASE.mat_vec(BASE.PRODUCE.RHO[representative], raw))
    normalized = [BASE.projective_normalize(point) for point in points]
    assert len(set(normalized)) == 11

    pairs = list(itertools.combinations(range(11), 2))
    pair_groups = [pair_stabilizer(pair, representatives, owner) for pair in pairs]
    assert len(set(pair_groups)) == 55
    assert all(len(group) == 12 for group in pair_groups)
    assert all(
        group_order_distribution(group) == {1: 1, 2: 7, 3: 2, 6: 2}
        for group in pair_groups
    )
    lines = [contained_d12_line(group) for group in pair_groups]
    residuals = [third_intersection(points[i], points[j]) for i, j in pairs]
    assert all(point is not None for point in residuals)
    residuals = [point for point in residuals if point is not None]
    normalized_residuals = [BASE.projective_normalize(point) for point in residuals]
    assert len(set(normalized_residuals)) == 55

    corresponding_line_hits = sum(
        point_on_line(point, line) for point, line in zip(residuals, lines)
    )
    all_line_hits = sum(
        point_on_line(point, line) for point in residuals for line in lines
    )
    linear_rank = rank([linear_row(point) for point in points])
    quadratic_rank = rank([BASE.quadric_row(point) for point in points])
    residual_linear_rank = rank([linear_row(point) for point in residuals])
    residual_quadratic_rank = rank([BASE.quadric_row(point) for point in residuals])
    assert linear_rank == 5 and quadratic_rank == 11
    assert residual_linear_rank == 5
    base_audit = quadric_base_audit(points)
    assert base_audit["quadric_base_affine_cone_dimension"] == 1
    assert base_audit["quadric_base_projective_degree"] == 16
    assert base_audit["quadric_base_intersect_klein_affine_cone_dimension"] == 1
    assert base_audit["quadric_base_intersect_klein_projective_degree"] == 11
    assert base_audit["linked_residual_affine_cone_dimension"] == 1
    assert base_audit["linked_residual_projective_degree"] == 5

    return {
        "class": record["label"],
        "alpha": field_to_json(alpha),
        "parameters": vector_to_json(parameters),
        "point_count": 11,
        "point_linear_rank": linear_rank,
        "point_quadric_rank": quadratic_rank,
        "quadrics_through_points": 15 - quadratic_rank,
        "proper_pair_secants": 55,
        "distinct_third_intersections": 55,
        "pair_stabilizer_order": 12,
        "pair_stabilizer_order_distribution": {"1": 1, "2": 7, "3": 2, "6": 2},
        "third_intersection_linear_rank": residual_linear_rank,
        "third_intersection_quadric_rank": residual_quadratic_rank,
        "third_intersections_on_corresponding_d12_line": corresponding_line_hits,
        "third_intersection_d12_line_union_incidences": all_line_hits,
        "four_quadric_base": base_audit,
    }


def main():
    assert pow(NONSQUARE, (P - 1) // 2, P) == P - 1
    twists = json.loads((BASE.SUBGROUP / "twists.json").read_text())
    covariants = BASE.load_covariants()
    records = []
    for record, radical_sign, roots in (
        (twists["records"][0], -1, class1_roots()),
        (twists["records"][1], 1, class2_roots()),
    ):
        for root_index, alpha in enumerate(roots):
            result = build_orbit(record, radical_sign, alpha, covariants)
            result["root_index"] = root_index
            records.append(result)
            print(
                result["class"],
                "ROOT", root_index,
                "ALPHA", alpha,
                "LINEAR_RANK", result["point_linear_rank"],
                "QUADRIC_RANK", result["point_quadric_rank"],
                "PROPER_SECANTS", result["proper_pair_secants"],
                "DISTINCT_RESIDUALS", result["distinct_third_intersections"],
                "D12_LINE_HITS", result["third_intersection_d12_line_union_incidences"],
            )
    payload = {
        "format": "A5-DEGREE11-SECANT-DESCENT-v1",
        "prime": P,
        "quadratic_extension": "F_89[u]/(u^2-65)",
        "records": records,
    }
    (HERE / "computed.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    assert len(records) == 6
    assert all(row["point_linear_rank"] == 5 for row in records)
    assert all(row["point_quadric_rank"] == 11 for row in records)
    assert all(row["proper_pair_secants"] == 55 for row in records)
    assert all(row["distinct_third_intersections"] == 55 for row in records)
    print("A5_ALL_SIX_DEGREE11_ORBITS_SECANT_AUDIT_OK")


if __name__ == "__main__":
    main()
