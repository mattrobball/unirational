#!/usr/bin/env python3
"""Independent replay of the corrected genuine-Fano incidence geometry.

This verifier does not import ``build_corrected_incidence.py``.  It rebuilds
the five Pluecker hyperplanes and their restricted Grassmann quadrics from
the sealed involution/five-plane sources, checks every generated Singular
input byte-for-byte, reruns Singular, and checks the three-prime geometry.
"""

from __future__ import annotations

import hashlib
import json
import re
import subprocess
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SINGULAR = "/opt/homebrew/bin/Singular"
POINT = (1, 2, 3, 4, 5)
FIBRES = ((331, "discovery"), (463, "discovery"), (419, "holdout"))
PAIRS = tuple(combinations(range(6), 2))
PAIR_INDEX = {pair: index for index, pair in enumerate(PAIRS)}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def primitive_root_11(prime: int) -> int:
    assert (prime - 1) % 11 == 0
    return next(a for a in range(2, prime) if pow(a, 11, prime) == 1)


def q11_value(coefficient, prime: int, root: int) -> int:
    answer = 0
    for exponent, fraction in enumerate(coefficient):
        numerator, denominator = map(int, fraction)
        answer += numerator * pow(denominator, -1, prime) * pow(root, exponent, prime)
    return answer % prime


def polynomial_value(terms, point, prime: int) -> int:
    answer = 0
    for term in terms:
        value = int(term["coefficient"]) % prime
        for coordinate, exponent in zip(point, term["exponents"]):
            value = value * pow(coordinate, int(exponent), prime) % prime
        answer = (answer + value) % prime
    return answer


def determinant(matrix, prime: int) -> int:
    work = [[entry % prime for entry in row] for row in matrix]
    result = 1
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            result = -result
        diagonal = work[column][column]
        result = result * diagonal % prime
        inverse = pow(diagonal, -1, prime)
        for row in range(column + 1, len(work)):
            factor = work[row][column] * inverse % prime
            for j in range(column, len(work)):
                work[row][j] = (work[row][j] - factor * work[column][j]) % prime
    return result % prime


def row_reduce(matrix, prime: int):
    work = [[entry % prime for entry in row] for row in matrix]
    pivots = []
    row = 0
    for column in range(len(work[0])):
        pivot = next((i for i in range(row, len(work)) if work[i][column]), None)
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [entry * inverse % prime for entry in work[row]]
        for i in range(len(work)):
            if i == row or work[i][column] == 0:
                continue
            factor = work[i][column]
            work[i] = [(a - factor * b) % prime for a, b in zip(work[i], work[row])]
        pivots.append(column)
        row += 1
        if row == len(work):
            break
    return work, pivots


def quadratic_product(left, right, prime: int):
    answer = {}
    for i, a in left.items():
        for j, b in right.items():
            monomial = tuple(sorted((i, j)))
            answer[monomial] = (answer.get(monomial, 0) + a * b) % prime
    return {monomial: coefficient for monomial, coefficient in answer.items() if coefficient}


def quadratic_add(left, right, scalar: int, prime: int):
    answer = dict(left)
    for monomial, coefficient in right.items():
        answer[monomial] = (answer.get(monomial, 0) + scalar * coefficient) % prime
        if answer[monomial] == 0:
            del answer[monomial]
    return answer


def normalized(poly, prime: int):
    if not poly:
        return ()
    lead = min(poly)
    inverse = pow(poly[lead], -1, prime)
    return tuple((monomial, coefficient * inverse % prime) for monomial, coefficient in sorted(poly.items()))


def quad_string(poly, prime: int) -> str:
    terms = []
    for (i, j), coefficient in poly:
        signed = coefficient if coefficient <= prime // 2 else coefficient - prime
        body = f"z{i}^2" if i == j else f"z{i}*z{j}"
        if signed == 1:
            term = "+" + body
        elif signed == -1:
            term = "-" + body
        elif signed > 0:
            term = f"+{signed}*{body}"
        else:
            term = f"{signed}*{body}"
        terms.append(term)
    result = "".join(terms)
    return result[1:] if result.startswith("+") else result


def fibre_data(prime: int, involution: dict, five_plane: dict):
    root = primitive_root_11(prime)
    frame = five_plane["hilbert90_frame"]
    vectors = [
        [polynomial_value(component, POINT, prime) for component in frame["vectors"][name]]
        for name in frame["names"]
    ]
    frame_matrix = [[vectors[column][row] for column in range(5)] for row in range(5)]
    q_coefficients = involution["Q_linear_coefficients"]

    def form(vector):
        return [[
            sum(q11_value(q_coefficients[i][j][k], prime, root) * vector[k] for k in range(5)) % prime
            for j in range(6)
        ] for i in range(6)]

    forms = [form(vector) for vector in vectors]
    assert all(forms[0][i][j] == -forms[0][j][i] % prime for i in range(6) for j in range(6))
    rows = [[matrix[i][j] for i, j in PAIRS] for matrix in forms]
    reduced, pivots = row_reduce(rows, prime)
    assert len(pivots) == 5
    free = [index for index in range(15) if index not in pivots]
    positions = {coordinate: index for index, coordinate in enumerate(free)}
    substitutions = [{} for _ in range(15)]
    for coordinate in free:
        substitutions[coordinate] = {positions[coordinate]: 1}
    for row, pivot in enumerate(pivots):
        substitutions[pivot] = {
            positions[coordinate]: -reduced[row][coordinate] % prime
            for coordinate in free if reduced[row][coordinate]
        }
    quadrics = []
    for i, j, k, l in combinations(range(6), 4):
        poly = quadratic_product(substitutions[PAIR_INDEX[(i, j)]], substitutions[PAIR_INDEX[(k, l)]], prime)
        poly = quadratic_add(poly, quadratic_product(substitutions[PAIR_INDEX[(i, k)]], substitutions[PAIR_INDEX[(j, l)]], prime), -1, prime)
        poly = quadratic_add(poly, quadratic_product(substitutions[PAIR_INDEX[(i, l)]], substitutions[PAIR_INDEX[(j, k)]], prime), 1, prime)
        value = normalized(poly, prime)
        if value and value not in quadrics:
            quadrics.append(value)
    return {
        "root": root,
        "frame_determinant": determinant(frame_matrix, prime),
        "q_determinant": determinant(forms[0], prime),
        "rows": rows,
        "pivots": pivots,
        "free": free,
        "quadrics": quadrics,
    }


def expected_structural_source(prime: int, role: str, quadrics) -> str:
    ideal = ",\n  ".join(quad_string(poly, prime) for poly in quadrics)
    return f'''// Corrected C5 genuine Pluecker section; {role} prime.
LIB "sing.lib";
ring r={prime},(z0,z1,z2,z3,z4,z5,z6,z7,z8,z9),dp;
ideal I=
  {ideal};
ideal G=std(I);
print("C5_RING_DIM="+string(dim(G)));
print("C5_GB_SIZE="+string(size(G)));
print("C5_DEGREE_BEGIN");
string degree_text=degree(G);
print(degree_text);
print("C5_DEGREE_END");
print("C5_HILBERT_BEGIN");
hilb(G,1);
print("C5_HILBERT_END");
print("C5_STRUCTURAL_GEOMETRY_DONE");
quit;
'''


def poly_add(left, right, scalar: int, prime: int):
    answer = dict(left)
    for monomial, coefficient in right.items():
        answer[monomial] = (answer.get(monomial, 0) + scalar * coefficient) % prime
        if answer[monomial] == 0:
            del answer[monomial]
    return answer


def poly_mul(left, right, prime: int):
    answer = {}
    for m1, c1 in left.items():
        for m2, c2 in right.items():
            monomial = tuple(sorted((*m1, *m2)))
            answer[monomial] = (answer.get(monomial, 0) + c1 * c2) % prime
    return {monomial: coefficient for monomial, coefficient in answer.items() if coefficient}


def affine_string(poly, prime: int) -> str:
    if not poly:
        return "0"
    terms = []
    for monomial, coefficient in sorted(poly.items()):
        signed = coefficient if coefficient <= prime // 2 else coefficient - prime
        factors = []
        for variable in sorted(set(monomial)):
            exponent = monomial.count(variable)
            factors.append(f"y{variable}" if exponent == 1 else f"y{variable}^{exponent}")
        body = "*".join(factors) if factors else "1"
        if body == "1":
            term = str(signed)
        elif signed == 1:
            term = body
        elif signed == -1:
            term = "-" + body
        else:
            term = f"{signed}*{body}"
        if terms and not term.startswith("-"):
            term = "+" + term
        terms.append(term)
    return "".join(terms)


def chart_equations(rows, pivot_pair, prime: int):
    a, b = pivot_pair
    top, bottom = [], []
    variable = 0
    for column in range(6):
        if column == a:
            top.append({(): 1}); bottom.append({})
        elif column == b:
            top.append({}); bottom.append({(): 1})
        else:
            top.append({(variable,): 1}); bottom.append({(variable + 1,): 1})
            variable += 2
    assert variable == 8
    coordinates = []
    for i, j in PAIRS:
        value = poly_mul(top[i], bottom[j], prime)
        coordinates.append(poly_add(value, poly_mul(top[j], bottom[i], prime), -1, prime))
    equations = []
    for row in rows:
        equation = {}
        for coefficient, coordinate in zip(row, coordinates):
            equation = poly_add(equation, coordinate, coefficient, prime)
        equations.append(equation)
    return equations


def expected_smoothness_source(prime: int, role: str, rows) -> str:
    blocks = [
        f"// Corrected C5 smoothness cover; {role} prime.\n"
        f"ring r={prime},(y0,y1,y2,y3,y4,y5,y6,y7),dp;\n"
    ]
    for chart, pair in enumerate(PAIRS):
        equations = chart_equations(rows, pair, prime)
        blocks.append(f"ideal I{chart}=" + ",".join(affine_string(poly, prime) for poly in equations) + ";")
        blocks.append(f"matrix J{chart}=jacob(I{chart});")
        blocks.append(f"ideal K{chart}=std(I{chart}+minor(J{chart},5));")
        blocks.append(
            f'if (reduce(1,K{chart})==0) {{ print("C5_CHART_{chart}_SMOOTH=1"); }} '
            f'else {{ print("C5_CHART_{chart}_SMOOTH=0"); }}'
        )
    blocks.extend(['print("C5_SMOOTHNESS_COVER_DONE");', "quit;"])
    return "\n".join(blocks) + "\n"


def singular_replay(path: Path, expected_output: Path) -> str:
    completed = subprocess.run(
        [SINGULAR, "-q", str(path)],
        check=True,
        capture_output=True,
        text=True,
        timeout=120,
    )
    assert completed.stderr == ""
    assert completed.stdout == expected_output.read_text()
    return completed.stdout


def check_standard_nilpotent_scheme(record: dict) -> None:
    """Audit and rerun the characteristic-zero ideal equality."""

    source_path = HERE / "corrected_nilpotent_scheme_QQ.sing"
    output_path = HERE / "corrected_nilpotent_scheme_QQ.out"
    source = source_path.read_text()
    assert "ring r=0,(p01,p02,p03,p04,p05,p12,p13,p14,p15,p23,p24,p25,p34,p35,p45),dp;" in source
    assert "matrix N=P*Q;" in source and "matrix N2=N*N;" in source
    assert "ideal I=I0,trN;" in source and "ideal J=trN," in source
    assert "size(std(remIJ))==0" in source and "size(std(remJI))==0" in source
    for row in range(1, 7):
        for column in range(1, 7):
            assert source.count(f"N2[{row},{column}]") == 1
    variable = {(i, j): f"p{i}{j}" for i, j in PAIRS}
    for i, j, k, l in combinations(range(6), 4):
        pfaffian = (
            f"{variable[(i, j)]}*{variable[(k, l)]}"
            f"-{variable[(i, k)]}*{variable[(j, l)]}"
            f"+{variable[(i, l)]}*{variable[(j, k)]}"
        )
        assert source.count(pfaffian) == 1
    assert sha256(source_path) == record["singular_input_sha256"]
    assert sha256(output_path) == record["singular_output_sha256"]
    replay = singular_replay(source_path, output_path)
    assert "C5_TRACE_REPAIRED_IDEAL_EQUALITY=1" in replay
    assert "C5_STANDARD_NILPOTENT_SCHEME_DONE" in replay
    dimensions = [
        int(value)
        for value in re.findall(r"C5_(?:SQUARE_ZERO|REDUCED)_RING_DIM=(\d+)", replay)
    ]
    degrees = [int(value) for value in re.findall(r"degree \(proj\.\)\s*=\s*(\d+)", replay)]
    assert dimensions == [8, 8]
    assert degrees == [28, 14]
    assert record == {
        "singular_input_sha256": sha256(source_path),
        "singular_output_sha256": sha256(output_path),
        "square_zero_affine_dimension": 8,
        "square_zero_projective_degree": 28,
        "trace_repaired_affine_dimension": 8,
        "trace_repaired_projective_degree": 14,
        "trace_repaired_ideal_equals_trace_plus_pluecker": True,
    }


def main() -> None:
    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    corrected = json.loads((HERE / "corrected_incidence.json").read_text())
    geometry = json.loads((HERE / "corrected_incidence_geometry.json").read_text())
    involution = json.loads((ROOT / manifest["authoritative_inputs"]["involution"]["path"]).read_text())
    five_plane = json.loads((ROOT / manifest["authoritative_inputs"]["distinguished_five_plane"]["path"]).read_text())
    basis_path = ROOT / manifest["authoritative_inputs"]["symmetric_basis_certificate"]["path"]
    basis = json.loads(basis_path.read_text())["symmetric_jordan_reduction"]["symmetric_basis"]

    assert corrected["format"] == "c5-corrected-self-adjoint-nilpotent-incidence-v1"
    assert corrected["basis_source_sha256"] == sha256(basis_path)
    assert basis["dimension"] == 15
    assert [row["frame_index"] for row in corrected["symmetric_basis"]] == basis["frame_indices"]
    equations = corrected["homogeneous_equations"]
    assert len(equations["square_zero"]) == 36
    assert len(equations["fano_hyperplanes"]) == 5
    assert equations["discarded_full_algebra_coordinates"] == 0
    assert [chart["normalization"] for chart in corrected["projective_cover"]] == [f"t_{i}=1" for i in range(15)]
    assert "projective" in corrected["projective_scalar_quotient"]
    assert "degree-28" in corrected["scheme_caveat"]
    assert any("disc(m_a)" in condition for condition in corrected["opens"])
    assert any("no target inverse" in condition for condition in corrected["opens"])

    assert geometry["holdout_prime"] == 419
    integrality = geometry["geometric_integrality_lemma"]
    assert integrality["ambient_ring_dimension"] == 9
    assert integrality["linear_forms"] == 5
    assert integrality["verified_quotient_ring_dimension"] == 4
    assert "Cohen-Macaulay" in integrality["ambient"]
    assert "regular sequence" in integrality["regular_sequence_step"]
    assert "depth four" in integrality["connectedness_step"]
    assert "fifteen standard Grassmann charts" in integrality["smoothness_step"]
    assert "geometrically integral" in integrality["conclusion"]
    check_standard_nilpotent_scheme(geometry["standard_nilpotent_scheme"])
    assert [(row["prime"], row["role"]) for row in geometry["fibres"]] == list(FIBRES)
    for recorded, (prime, role) in zip(geometry["fibres"], FIBRES):
        data = fibre_data(prime, involution, five_plane)
        assert data["frame_determinant"] != 0 and data["q_determinant"] != 0
        assert recorded["zeta11"] == data["root"]
        assert recorded["point"] == list(POINT)
        assert recorded["frame_determinant"] == data["frame_determinant"]
        assert recorded["q_determinant"] == data["q_determinant"]
        assert recorded["linear_rank"] == 5
        assert recorded["pivot_pluecker_indices"] == data["pivots"]
        assert recorded["free_pluecker_indices"] == data["free"]
        assert recorded["distinct_restricted_pluecker_quadrics"] == len(data["quadrics"]) == 15

        structural = HERE / f"corrected_fano_p{prime}.sing"
        structural_output = HERE / f"corrected_fano_p{prime}.out"
        smoothness = HERE / f"corrected_fano_smoothness_p{prime}.sing"
        smoothness_output = HERE / f"corrected_fano_smoothness_p{prime}.out"
        assert structural.read_text() == expected_structural_source(prime, role, data["quadrics"])
        assert smoothness.read_text() == expected_smoothness_source(prime, role, data["rows"])
        assert recorded["singular_input_sha256"] == sha256(structural)
        assert recorded["singular_output_sha256"] == sha256(structural_output)
        assert recorded["smoothness_input_sha256"] == sha256(smoothness)
        assert recorded["smoothness_output_sha256"] == sha256(smoothness_output)

        structural_text = singular_replay(structural, structural_output)
        smoothness_text = singular_replay(smoothness, smoothness_output)
        assert "dimension (proj.)  = 3" in structural_text
        assert "degree (proj.)   = 14" in structural_text
        assert recorded["ring_dimension"] == 4
        assert recorded["projective_dimension"] == 3
        assert recorded["degree"] == 14
        flags = [int(value) for value in re.findall(r"C5_CHART_\d+_SMOOTH=(\d+)", smoothness_text)]
        assert flags == [1] * 15 == recorded["smooth_chart_flags"]
        assert recorded["projectively_smooth"] is True
        assert recorded["component_count"] == 1
        assert recorded["geometrically_integral"] is True

    print("PASS independently rebuilt all three five-hyperplane Pluecker sections")
    print("PASS exact QQ ideal equality after retaining the essential trace equation")
    print("PASS every structural and 15-chart smoothness Singular input is exact")
    print("PASS fresh Singular replays give smooth integral degree-14 threefold fibres at 331, 463, and holdout 419")
    print("SCOPE corrected genuine incidence and structural fibres; no K_proj-rational point")
    print("C5_CORRECTED_INCIDENCE_GEOMETRY_INDEPENDENTLY_VERIFIED")


if __name__ == "__main__":
    main()
