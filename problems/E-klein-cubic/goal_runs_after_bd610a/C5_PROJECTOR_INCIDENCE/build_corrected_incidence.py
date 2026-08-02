#!/usr/bin/env python3
"""Build the corrected 15-variable genuine Fano incidence.

The characteristic-zero equations are stored as exact lazy-circuit
descriptors.  The structural finite-field audit uses the equivalent Pluecker
linear section of Gr(2,6) and runs Singular at two discovery primes and one
separately designated holdout prime.
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
SINGULAR = Path("/opt/homebrew/bin/Singular")
POINT = (1, 2, 3, 4, 5)
PRIMES = (
    (331, "discovery"),
    (463, "discovery"),
    (419, "holdout"),
)
PAIRS = tuple(combinations(range(6), 2))
PAIR_INDEX = {pair: index for index, pair in enumerate(PAIRS)}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def primitive_11th_root(prime: int) -> int:
    assert (prime - 1) % 11 == 0
    return next(value for value in range(2, prime) if pow(value, 11, prime) == 1)


def reduce_q11(coefficient, prime: int, zeta: int) -> int:
    return sum(
        int(num) * pow(int(den), -1, prime) * pow(zeta, power, prime)
        for power, (num, den) in enumerate(coefficient)
    ) % prime


def evaluate_integer_polynomial(terms: list[dict], point, prime: int) -> int:
    answer = 0
    for term in terms:
        monomial = int(term["coefficient"]) % prime
        for coordinate, exponent in zip(point, term["exponents"]):
            monomial = monomial * pow(int(coordinate), int(exponent), prime) % prime
        answer = (answer + monomial) % prime
    return answer


def determinant_mod(matrix: list[list[int]], prime: int) -> int:
    work = [[entry % prime for entry in row] for row in matrix]
    answer = 1
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            answer = -answer
        scalar = work[column][column] % prime
        answer = answer * scalar % prime
        inverse = pow(scalar, -1, prime)
        work[column] = [value * inverse % prime for value in work[column]]
        for row in range(column + 1, len(work)):
            factor = work[row][column]
            if factor:
                work[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(work[row], work[column])
                ]
    return answer % prime


def rref(matrix: list[list[int]], prime: int):
    work = [[entry % prime for entry in row] for row in matrix]
    row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot = next((candidate for candidate in range(row, len(work)) if work[candidate][column]), None)
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [value * inverse % prime for value in work[row]]
        for other in range(len(work)):
            if other != row and work[other][column]:
                factor = work[other][column]
                work[other] = [
                    (left - factor * right) % prime
                    for left, right in zip(work[other], work[row])
                ]
        pivots.append(column)
        row += 1
        if row == len(work):
            break
    return work, pivots


def add_poly(left: dict[tuple[int, int], int], right: dict[tuple[int, int], int], scalar: int, prime: int):
    answer = dict(left)
    for monomial, coefficient in right.items():
        answer[monomial] = (answer.get(monomial, 0) + scalar * coefficient) % prime
        if answer[monomial] == 0:
            del answer[monomial]
    return answer


def multiply_linear(left: dict[int, int], right: dict[int, int], prime: int):
    answer: dict[tuple[int, int], int] = {}
    for i, a in left.items():
        for j, b in right.items():
            monomial = tuple(sorted((i, j)))
            answer[monomial] = (answer.get(monomial, 0) + a * b) % prime
    return {monomial: coefficient for monomial, coefficient in answer.items() if coefficient}


def normalize_poly(poly: dict[tuple[int, int], int], prime: int):
    if not poly:
        return ()
    leading = min(poly)
    inverse = pow(poly[leading], -1, prime)
    return tuple((monomial, coefficient * inverse % prime) for monomial, coefficient in sorted(poly.items()))


def polynomial_string(poly, prime: int) -> str:
    terms = []
    for (i, j), coefficient in poly:
        signed = coefficient if coefficient <= prime // 2 else coefficient - prime
        monomial = f"z{i}^2" if i == j else f"z{i}*z{j}"
        if signed == 1:
            terms.append(f"+{monomial}")
        elif signed == -1:
            terms.append(f"-{monomial}")
        elif signed > 0:
            terms.append(f"+{signed}*{monomial}")
        else:
            terms.append(f"{signed}*{monomial}")
    expression = "".join(terms)
    return expression[1:] if expression.startswith("+") else expression


def section_data(prime: int, involution: dict, five_plane: dict):
    zeta = primitive_11th_root(prime)
    q_coefficients = involution["Q_linear_coefficients"]
    frame = five_plane["hilbert90_frame"]["vectors"]
    names = five_plane["hilbert90_frame"]["names"]
    vectors = [
        [evaluate_integer_polynomial(component, POINT, prime) for component in frame[name]]
        for name in names
    ]
    frame_matrix = [[vectors[column][row] for column in range(5)] for row in range(5)]
    frame_determinant = determinant_mod(frame_matrix, prime)
    assert frame_determinant

    def q_of(vector):
        return [
            [
                sum(
                    reduce_q11(q_coefficients[row][column][i], prime, zeta) * vector[i]
                    for i in range(5)
                ) % prime
                for column in range(6)
            ]
            for row in range(6)
        ]

    forms = [q_of(vector) for vector in vectors]
    q = forms[0]
    q_determinant = determinant_mod(q, prime)
    assert q_determinant
    linear_rows = [[form[i][j] for i, j in PAIRS] for form in forms]
    reduced, pivots = rref(linear_rows, prime)
    assert len(pivots) == 5
    free = [index for index in range(15) if index not in pivots]
    free_position = {index: position for position, index in enumerate(free)}
    expressions: list[dict[int, int]] = [{} for _ in range(15)]
    for index in free:
        expressions[index] = {free_position[index]: 1}
    for row, pivot in enumerate(pivots):
        expressions[pivot] = {
            free_position[index]: -reduced[row][index] % prime
            for index in free if reduced[row][index]
        }

    quadrics = []
    for i, j, k, l in combinations(range(6), 4):
        poly = multiply_linear(expressions[PAIR_INDEX[(i, j)]], expressions[PAIR_INDEX[(k, l)]], prime)
        poly = add_poly(poly, multiply_linear(expressions[PAIR_INDEX[(i, k)]], expressions[PAIR_INDEX[(j, l)]], prime), -1, prime)
        poly = add_poly(poly, multiply_linear(expressions[PAIR_INDEX[(i, l)]], expressions[PAIR_INDEX[(j, k)]], prime), 1, prime)
        normalized = normalize_poly(poly, prime)
        if normalized and normalized not in quadrics:
            quadrics.append(normalized)
    assert quadrics
    return {
        "prime": prime,
        "zeta11": zeta,
        "point": list(POINT),
        "frame_determinant": frame_determinant,
        "q_determinant": q_determinant,
        "linear_rank": len(pivots),
        "pivot_pluecker_indices": pivots,
        "free_pluecker_indices": free,
        "section_rows": linear_rows,
        "quadrics": quadrics,
    }


def singular_source(data: dict, role: str) -> str:
    prime = data["prime"]
    expressions = [polynomial_string(poly, prime) for poly in data["quadrics"]]
    ideal = ",\n  ".join(expressions)
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


def parse_singular(output: str):
    ring_dim = int(re.search(r"C5_RING_DIM=(\d+)", output).group(1))
    gb_size = int(re.search(r"C5_GB_SIZE=(\d+)", output).group(1))
    projective_dimension = int(re.search(r"dimension \(proj\.\)\s*=\s*(-?\d+)", output).group(1))
    degree = int(re.search(r"degree \(proj\.\)\s*=\s*(\d+)", output).group(1))
    hilbert = output.split("C5_HILBERT_BEGIN\n", 1)[1].split("\nC5_HILBERT_END", 1)[0].strip()
    assert "C5_STRUCTURAL_GEOMETRY_DONE" in output
    return {
        "ring_dimension": ring_dim,
        "projective_dimension": projective_dimension,
        "degree": degree,
        "groebner_basis_size": gb_size,
        "hilbert_numerator": hilbert,
    }


def poly_add(left, right, scalar, prime):
    answer = dict(left)
    for monomial, coefficient in right.items():
        answer[monomial] = (answer.get(monomial, 0) + scalar * coefficient) % prime
        if answer[monomial] == 0:
            del answer[monomial]
    return answer


def poly_mul(left, right, prime):
    answer = {}
    for left_monomial, left_coefficient in left.items():
        for right_monomial, right_coefficient in right.items():
            monomial = tuple(sorted((*left_monomial, *right_monomial)))
            answer[monomial] = (
                answer.get(monomial, 0) + left_coefficient * right_coefficient
            ) % prime
    return {monomial: coefficient for monomial, coefficient in answer.items() if coefficient}


def affine_polynomial_string(poly, prime):
    if not poly:
        return "0"
    terms = []
    for monomial, coefficient in sorted(poly.items()):
        signed = coefficient if coefficient <= prime // 2 else coefficient - prime
        powers = []
        for variable in sorted(set(monomial)):
            power = monomial.count(variable)
            powers.append(f"y{variable}" if power == 1 else f"y{variable}^{power}")
        body = "*".join(powers) if powers else "1"
        if body == "1":
            term = str(signed)
        elif signed == 1:
            term = body
        elif signed == -1:
            term = f"-{body}"
        else:
            term = f"{signed}*{body}"
        if terms and not term.startswith("-"):
            term = "+" + term
        terms.append(term)
    return "".join(terms)


def grassmann_chart_equations(section_rows, pivot_pair, prime):
    a, b = pivot_pair
    remaining = [column for column in range(6) if column not in pivot_pair]
    top = []
    bottom = []
    next_variable = 0
    for column in range(6):
        if column == a:
            top.append({(): 1})
            bottom.append({})
        elif column == b:
            top.append({})
            bottom.append({(): 1})
        else:
            top.append({(next_variable,): 1})
            bottom.append({(next_variable + 1,): 1})
            next_variable += 2
    assert next_variable == 8 and len(remaining) == 4
    pluecker = []
    for i, j in PAIRS:
        value = poly_mul(top[i], bottom[j], prime)
        value = poly_add(value, poly_mul(top[j], bottom[i], prime), -1, prime)
        pluecker.append(value)
    equations = []
    for row in section_rows:
        equation = {}
        for coefficient, coordinate in zip(row, pluecker):
            equation = poly_add(equation, coordinate, coefficient, prime)
        equations.append(equation)
    return equations


def smoothness_source(data, role):
    prime = data["prime"]
    blocks = [
        f"// Corrected C5 smoothness cover; {role} prime.\n"
        f"ring r={prime},(y0,y1,y2,y3,y4,y5,y6,y7),dp;\n"
    ]
    for chart, pivot_pair in enumerate(PAIRS):
        equations = grassmann_chart_equations(data["section_rows"], pivot_pair, prime)
        ideal_text = ",".join(affine_polynomial_string(equation, prime) for equation in equations)
        blocks.append(f"ideal I{chart}={ideal_text};")
        blocks.append(f"matrix J{chart}=jacob(I{chart});")
        blocks.append(f"ideal K{chart}=std(I{chart}+minor(J{chart},5));")
        blocks.append(
            f'if (reduce(1,K{chart})==0) {{ print("C5_CHART_{chart}_SMOOTH=1"); }} '
            f'else {{ print("C5_CHART_{chart}_SMOOTH=0"); }}'
        )
    blocks.extend(['print("C5_SMOOTHNESS_COVER_DONE");', "quit;"])
    return "\n".join(blocks) + "\n"


def parse_smoothness(output):
    values = {
        int(chart): int(value)
        for chart, value in re.findall(r"C5_CHART_(\d+)_SMOOTH=(\d+)", output)
    }
    assert set(values) == set(range(15))
    assert "C5_SMOOTHNESS_COVER_DONE" in output
    return {
        "grassmann_charts_checked": 15,
        "smooth_chart_flags": [values[index] for index in range(15)],
        "projectively_smooth": all(values.values()),
    }


def standard_nilpotent_scheme_source() -> str:
    """Exact split-model check, including the essential trace equation."""

    return '''// Corrected C5 square-zero scheme over QQ in a standard symplectic splitting.
ring r=0,(p01,p02,p03,p04,p05,p12,p13,p14,p15,p23,p24,p25,p34,p35,p45),dp;
matrix P[6][6]=
  0,p01,p02,p03,p04,p05,
  -p01,0,p12,p13,p14,p15,
  -p02,-p12,0,p23,p24,p25,
  -p03,-p13,-p23,0,p34,p35,
  -p04,-p14,-p24,-p34,0,p45,
  -p05,-p15,-p25,-p35,-p45,0;
matrix Q[6][6]=
  0,0,0,1,0,0,
  0,0,0,0,1,0,
  0,0,0,0,0,1,
  -1,0,0,0,0,0,
  0,-1,0,0,0,0,
  0,0,-1,0,0,0;
matrix N=P*Q;
matrix N2=N*N;
poly trN=N[1,1]+N[2,2]+N[3,3]+N[4,4]+N[5,5]+N[6,6];
ideal I0=
  N2[1,1],N2[1,2],N2[1,3],N2[1,4],N2[1,5],N2[1,6],
  N2[2,1],N2[2,2],N2[2,3],N2[2,4],N2[2,5],N2[2,6],
  N2[3,1],N2[3,2],N2[3,3],N2[3,4],N2[3,5],N2[3,6],
  N2[4,1],N2[4,2],N2[4,3],N2[4,4],N2[4,5],N2[4,6],
  N2[5,1],N2[5,2],N2[5,3],N2[5,4],N2[5,5],N2[5,6],
  N2[6,1],N2[6,2],N2[6,3],N2[6,4],N2[6,5],N2[6,6];
ideal I=I0,trN;
ideal J=trN,
  p01*p23-p02*p13+p03*p12,
  p01*p24-p02*p14+p04*p12,
  p01*p25-p02*p15+p05*p12,
  p01*p34-p03*p14+p04*p13,
  p01*p35-p03*p15+p05*p13,
  p01*p45-p04*p15+p05*p14,
  p02*p34-p03*p24+p04*p23,
  p02*p35-p03*p25+p05*p23,
  p02*p45-p04*p25+p05*p24,
  p03*p45-p04*p35+p05*p34,
  p12*p34-p13*p24+p14*p23,
  p12*p35-p13*p25+p15*p23,
  p12*p45-p14*p25+p15*p24,
  p13*p45-p14*p35+p15*p34,
  p23*p45-p24*p35+p25*p34;
ideal G0=std(I0);
ideal GI=std(I);
ideal GJ=std(J);
ideal remIJ=reduce(I,GJ);
ideal remJI=reduce(J,GI);
if ((size(std(remIJ))==0) and (size(std(remJI))==0))
{
  print("C5_TRACE_REPAIRED_IDEAL_EQUALITY=1");
}
else
{
  print("C5_TRACE_REPAIRED_IDEAL_EQUALITY=0");
}
print("C5_SQUARE_ZERO_RING_DIM="+string(dim(G0)));
print("C5_SQUARE_ZERO_DEGREE_BEGIN");
string degree0=degree(G0);
print(degree0);
print("C5_SQUARE_ZERO_DEGREE_END");
print("C5_REDUCED_RING_DIM="+string(dim(GJ)));
print("C5_REDUCED_DEGREE_BEGIN");
string degreeJ=degree(GJ);
print(degreeJ);
print("C5_REDUCED_DEGREE_END");
print("C5_STANDARD_NILPOTENT_SCHEME_DONE");
quit;
'''


def parse_standard_nilpotent_scheme(output: str):
    assert "C5_TRACE_REPAIRED_IDEAL_EQUALITY=1" in output
    assert "C5_STANDARD_NILPOTENT_SCHEME_DONE" in output
    degree_blocks = re.findall(r"degree \(proj\.\)\s*=\s*(\d+)", output)
    assert len(degree_blocks) == 2
    return {
        "square_zero_affine_dimension": int(re.search(r"C5_SQUARE_ZERO_RING_DIM=(\d+)", output).group(1)),
        "square_zero_projective_degree": int(degree_blocks[0]),
        "trace_repaired_affine_dimension": int(re.search(r"C5_REDUCED_RING_DIM=(\d+)", output).group(1)),
        "trace_repaired_projective_degree": int(degree_blocks[1]),
        "trace_repaired_ideal_equals_trace_plus_pluecker": True,
    }


def main() -> None:
    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    involution = json.loads((ROOT / manifest["authoritative_inputs"]["involution"]["path"]).read_text())
    five_plane = json.loads((ROOT / manifest["authoritative_inputs"]["distinguished_five_plane"]["path"]).read_text())
    basis_certificate_path = ROOT / manifest["authoritative_inputs"]["symmetric_basis_certificate"]["path"]
    basis_certificate = json.loads(basis_certificate_path.read_text())
    symmetric = basis_certificate["symmetric_jordan_reduction"]["symmetric_basis"]
    indices = symmetric["frame_indices"]
    assert len(indices) == 15 and symmetric["dimension"] == 15

    exact = {
        "format": "c5-corrected-self-adjoint-nilpotent-incidence-v1",
        "field": manifest["field"],
        "ambient": "P(Sym(A,sigma))=P^14",
        "symmetric_basis": [
            {
                "name": f"q_{position}",
                "definition": f"M_{frame_index}+sigma(M_{frame_index})",
                "frame_index": frame_index,
                "rectangle_coordinates": f"R^-1*vec(M_{frame_index}+Q(x)^-1*M_{frame_index}^t*Q(x))",
            }
            for position, frame_index in enumerate(indices)
        ],
        "generic_element": "n(t)=sum_{j=0}^14 t_j*q_j",
        "homogeneous_equations": {
            "square_zero": [{"source": "n(t)^2", "rectangle_coordinate": index, "degree": 2} for index in range(36)],
            "fano_hyperplanes": [{"source": f"Trd(n(t)*S_{i})", "degree": 1} for i in range(5)],
            "discarded_full_algebra_coordinates": 0,
        },
        "projective_cover": [{"chart": index, "normalization": f"t_{index}=1"} for index in range(15)],
        "opens": [
            "char(K_proj) != 2 and the degree-six Azumaya/CSA open",
            "f14*f11*disc(m_a)*det(R)*Pf(Q(x)) != 0 when using the maximal-etale presentation",
            "the sealed 15x15 symmetric-basis minor != 0",
            "the distinguished five-plane rank minor != 0",
            "projective nonzero condition covered by t_j!=0",
            "no target inverse of <Q(x),p_U>; that quantity is the first Fano equation and equals zero",
        ],
        "rank_argument": "sigma(n)=n makes Qn alternating; n^2=0 gives rank(n)<=3; alternating rank is even, so every nonzero point has ordinary rank two",
        "projective_scalar_quotient": "nonzero n determines its right ideal nA and image nP; scalar multiples determine the same D-line, so the bijection is projective",
        "fano_equivalence": "for n=P_U*Q(x), Trd(n*S_i)=Tr(P_U*Q(V_i))=-2*<Q(V_i),p_U>; zero is exactly the five Pluecker hyperplanes",
        "scheme_caveat": "entries(n^2) alone define a doubled degree-28 structure; the retained i=0 equation Trd(n*S_0)=Trd(n)=0 is essential and makes the ideal equal to Trd(n) plus the fifteen Pluecker quadrics after splitting",
        "basis_source_sha256": sha256(basis_certificate_path),
        "scope": "exact exhaustive genuine Fano incidence; no K_proj-rational point is supplied",
    }
    (HERE / "corrected_incidence.json").write_text(json.dumps(exact, indent=2) + "\n")

    standard_source_path = HERE / "corrected_nilpotent_scheme_QQ.sing"
    standard_output_path = HERE / "corrected_nilpotent_scheme_QQ.out"
    standard_source_path.write_text(standard_nilpotent_scheme_source())
    standard_completed = subprocess.run(
        [str(SINGULAR), "-q", str(standard_source_path)],
        check=True,
        text=True,
        capture_output=True,
        timeout=120,
    )
    standard_output_path.write_text(standard_completed.stdout)
    standard_result = parse_standard_nilpotent_scheme(standard_completed.stdout)
    assert standard_result == {
        "square_zero_affine_dimension": 8,
        "square_zero_projective_degree": 28,
        "trace_repaired_affine_dimension": 8,
        "trace_repaired_projective_degree": 14,
        "trace_repaired_ideal_equals_trace_plus_pluecker": True,
    }

    geometry = {
        "format": "c5-corrected-incidence-three-prime-geometry-v1",
        "model": "Gr(2,6) intersect the five installed Pluecker hyperplanes",
        "holdout_prime": 419,
        "fibres": [],
        "standard_nilpotent_scheme": {
            "singular_input_sha256": sha256(standard_source_path),
            "singular_output_sha256": sha256(standard_output_path),
            **standard_result,
        },
        "geometric_integrality_lemma": {
            "ambient": "the Pluecker coordinate ring of Gr(2,6) over an algebraic closure is an integral Cohen-Macaulay standard graded ring",
            "ambient_ring_dimension": 9,
            "linear_forms": 5,
            "verified_quotient_ring_dimension": 4,
            "regular_sequence_step": "height five in a Cohen-Macaulay ring makes the five linear forms a regular sequence",
            "connectedness_step": "the quotient has depth four, so its positive-dimensional Proj is geometrically connected",
            "smoothness_step": "the fifteen standard Grassmann charts cover Proj and their Jacobian singular-locus ideals are units",
            "conclusion": "geometrically smooth plus geometrically connected gives exactly one geometrically integral component",
        },
        "scope": "structural good-reduction evidence and certificates; not a characteristic-zero rational point",
    }
    for prime, role in PRIMES:
        data = section_data(prime, involution, five_plane)
        source = singular_source(data, role)
        input_path = HERE / f"corrected_fano_p{prime}.sing"
        output_path = HERE / f"corrected_fano_p{prime}.out"
        input_path.write_text(source)
        completed = subprocess.run(
            [str(SINGULAR), "-q", str(input_path)],
            check=True,
            text=True,
            capture_output=True,
            timeout=120,
        )
        output_path.write_text(completed.stdout)
        result = parse_singular(completed.stdout)
        assert result["ring_dimension"] == 4
        assert result["projective_dimension"] == 3
        assert result["degree"] == 14
        smooth_input_path = HERE / f"corrected_fano_smoothness_p{prime}.sing"
        smooth_output_path = HERE / f"corrected_fano_smoothness_p{prime}.out"
        smooth_input_path.write_text(smoothness_source(data, role))
        smooth_completed = subprocess.run(
            [str(SINGULAR), "-q", str(smooth_input_path)],
            check=True,
            text=True,
            capture_output=True,
            timeout=120,
        )
        smooth_output_path.write_text(smooth_completed.stdout)
        smoothness = parse_smoothness(smooth_completed.stdout)
        assert smoothness["projectively_smooth"]
        geometry["fibres"].append(
            {
                "role": role,
                "prime": prime,
                "zeta11": data["zeta11"],
                "point": data["point"],
                "frame_determinant": data["frame_determinant"],
                "q_determinant": data["q_determinant"],
                "linear_rank": data["linear_rank"],
                "pivot_pluecker_indices": data["pivot_pluecker_indices"],
                "free_pluecker_indices": data["free_pluecker_indices"],
                "distinct_restricted_pluecker_quadrics": len(data["quadrics"]),
                "singular_input_sha256": sha256(input_path),
                "singular_output_sha256": sha256(output_path),
                "smoothness_input_sha256": sha256(smooth_input_path),
                "smoothness_output_sha256": sha256(smooth_output_path),
                **result,
                **smoothness,
                "component_count": 1,
                "geometrically_integral": True,
            }
        )
    (HERE / "corrected_incidence_geometry.json").write_text(json.dumps(geometry, indent=2) + "\n")
    print("WROTE corrected_incidence.json")
    print("WROTE corrected_incidence_geometry.json")
    print("C5-CORRECTED-FULL-INCIDENCE-THREE-PRIME-GEOMETRY")


if __name__ == "__main__":
    main()
