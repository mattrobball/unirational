#!/usr/bin/env python3
"""Symbolic F_67 audit of the two-transversal 19-line-cover family.

This is a scoped discovery/exclusion calculation.  It parameterizes the two
P1 families of transversals for triples (3,31,34) and (17,27,30), builds the
unique hyperplane containing a chosen pair, and extracts the pairwise line
intersection polynomials on the affine parameter chart and h4 != 0.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import re
import subprocess
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
FAMILY = HERE.parent / "CODEX_ROOT_20260801_7B4E" / "universal_marked_family.json"
OUTPUT = HERE / "two_transversal_family_mod67.json"
P = 67
ZETA = 64
A_TRIPLE = (3, 31, 34)
B_TRIPLE = (17, 27, 30)
COVER = (
    (0, 5, 51), (1, 6, 45), (2, 7, 50), A_TRIPLE, (4, 9, 49),
    (7, 18, 21), (8, 12, 20), (10, 13, 16), (11, 35, 42),
    (14, 37, 41), (15, 39, 43), B_TRIPLE, (19, 36, 40),
    (22, 24, 38), (23, 32, 33), (25, 44, 54), (26, 52, 53),
    (28, 48, 49), (29, 46, 47),
)
a, b = sp.symbols("a b")


def cmod(coefficients):
    return sum(int(c) * pow(ZETA, i, P) for i, c in enumerate(coefficients)) % P


def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def rref(matrix):
    x = [[int(v) % P for v in row] for row in matrix]
    row = 0
    pivots = []
    for column in range(len(x[0])):
        pivot = next((i for i in range(row, len(x)) if x[i][column]), None)
        if pivot is None:
            continue
        x[row], x[pivot] = x[pivot], x[row]
        inv = pow(x[row][column], -1, P)
        x[row] = [v * inv % P for v in x[row]]
        for i in range(len(x)):
            if i != row and x[i][column]:
                value = x[i][column]
                x[i] = [(u - value * v) % P for u, v in zip(x[i], x[row])]
        pivots.append(column)
        row += 1
        if row == len(x):
            break
    return x, pivots


def nullspace(matrix):
    reduced, pivots = rref(matrix)
    free = [j for j in range(len(matrix[0])) if j not in pivots]
    answer = []
    for j in free:
        vector = [0] * len(matrix[0])
        vector[j] = 1
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = -reduced[row][j] % P
        answer.append(vector)
    return answer


def vadd(u, v):
    return [sp.expand(x + y) for x, y in zip(u, v)]


def vscale(c, u):
    return [sp.expand(c * x) for x in u]


def dot(u, v):
    return sp.expand(sum(x * y for x, y in zip(u, v)))


def transversal(lines, triple, parameter):
    u, v, w = [lines[i] for i in triple]
    vectors = (u[0], u[1], v[0], v[1], [-x for x in w[0]], [-x for x in w[1]])
    basis = nullspace([[vectors[j][i] for j in range(6)] for i in range(5)])
    assert len(basis) == 2
    relation = [basis[0][i] + parameter * basis[1][i] for i in range(6)]
    point_u = vadd(vscale(relation[0], u[0]), vscale(relation[1], u[1]))
    point_v = vadd(vscale(relation[2], v[0]), vscale(relation[3], v[1]))
    return point_u, point_v


def det_poly(matrix):
    answer = sp.Poly(0, a, b, modulus=P)
    for permutation in itertools.permutations(range(4)):
        inversions = sum(permutation[i] > permutation[j]
                         for i in range(4) for j in range(i + 1, 4))
        term = sp.Poly(1, a, b, modulus=P)
        for row in range(4):
            term *= matrix[row][permutation[row]]
        answer = answer - term if inversions % 2 else answer + term
    return answer


def hyperplane(rows):
    h = []
    for column in range(5):
        minor = [[row[j] for j in range(5) if j != column] for row in rows]
        h.append(((-1) ** column) * sp.Matrix(minor).det())
    assert all(sp.Poly(dot(h, row), a, b, modulus=P).is_zero for row in rows)
    return primitive_vector([sp.Poly(x, a, b, modulus=P) for x in h])[0]


def primitive_vector(vector):
    common = next(polynomial for polynomial in vector if not polynomial.is_zero)
    for polynomial in vector:
        if not polynomial.is_zero:
            common = sp.gcd(common, polynomial)
    answer = []
    for polynomial in vector:
        quotient, remainder = sp.div(polynomial, common, domain=sp.GF(P))
        assert remainder.is_zero
        answer.append(sp.Poly(quotient, a, b, modulus=P))
    return answer, sp.Poly(common, a, b, modulus=P).monic()


def marked_points(lines, h):
    points = []
    for u, v in lines:
        hv = sum((h[i] * v[i] for i in range(5)), sp.Poly(0, a, b, modulus=P))
        hu = sum((h[i] * u[i] for i in range(5)), sp.Poly(0, a, b, modulus=P))
        point, _ = primitive_vector([hv * u[i] - hu * v[i] for i in range(5)])
        points.append(point)
    return points


def projective(vector):
    pivot = next((x % P for x in vector if x % P), None)
    if pivot is None:
        return None
    inv = pow(pivot, -1, P)
    return tuple(x * inv % P for x in vector)


def good_marked_fiber(lines, hvalues):
    points = []
    for u, v in lines:
        hu = sum(hvalues[i] * u[i] for i in range(5)) % P
        hv = sum(hvalues[i] * v[i] for i in range(5)) % P
        if not hu and not hv:
            return False
        point = [(hv * u[i] - hu * v[i]) % P for i in range(5)]
        key = projective(point)
        if key is None:
            return False
        points.append(key)
    return len(set(points)) == 55


def line_scale(line):
    plucker = [line[0][i] * line[1][j] - line[0][j] * line[1][i]
               for i, j in itertools.combinations(range(5), 2)]
    _, common = primitive_vector(plucker)
    return common


def singular_factors(polynomial):
    expression = str(polynomial.as_expr()).replace("**", "^")
    code = (
        "ring r=67,(a,b),dp; poly f=" + expression + "; "
        'list L=factorize(f); print("BEGIN"); print(L); print("END"); exit;'
    )
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", "-c", code],
        check=True, capture_output=True, text=True,
    ).stdout
    block = result.split("BEGIN\n", 1)[1].split("\nEND", 1)[0]
    first, second = block.split("[2]:", 1)
    factors = re.findall(r"_\[\d+\]=(.*)", first)
    exponents_line = next(line.strip() for line in second.splitlines() if line.strip())
    exponents = [int(value) for value in exponents_line.split(",")]
    assert len(factors) == len(exponents)
    return [(factor, exponent) for factor, exponent in zip(factors[1:], exponents[1:])]


def singular_expression(polynomial):
    return str(polynomial.as_expr()).replace("**", "^")


def singular_closure_bound(factor_edges, scalar_edges, h4, points, cover_lines):
    factors = sorted(factor_edges)
    edge_number = {edge: i + 1 for i, edge in enumerate(scalar_edges)}
    polynomial_list = ",".join(factors)
    edge_lists = []
    for factor in factors:
        indices = sorted({edge_number[edge] for edge, _ in factor_edges[factor]})
        edge_lists.append("intvec(" + ",".join(map(str, indices)) + ")")
    zeros = ",".join("0" for _ in scalar_edges)
    h4_expression = singular_expression(h4)
    point_list = ",".join(singular_expression(polynomial)
                          for point in points for polynomial in point)
    plucker_vectors = []
    for line in cover_lines:
        plucker_vectors.append([
            line[0][i] * line[1][j] - line[0][j] * line[1][i]
            for i, j in itertools.combinations(range(5), 2)
        ])
    plucker_list = ",".join(singular_expression(polynomial)
                            for vector in plucker_vectors for polynomial in vector)
    code = f'''LIB "primdec.lib";
ring r=67,(a,b),dp;
list F={polynomial_list};
list EM={','.join(edge_lists)};
list PP={point_list};
list PL={plucker_list};
poly hh={h4_expression};
int maximum=0;
int goodHighCount=0;
int maxi=0;
int maxj=0;
int maxq=0;
int i,j,q,k,m,n,count,good,zero,same,ii,jj,c,d,u,v;
ideal SI,SQ;
list ML;
intvec seen,ee;
for (i=1;i<=size(F);i++)
{{
  for (j=i+1;j<=size(F);j++)
  {{
    SI=std(ideal(F[i],F[j]));
    if (SI[1]!=1)
    {{
      ML=minAssGTZ(SI);
      for (q=1;q<=size(ML);q++)
      {{
        SQ=std(ML[q]);
        if (reduce(hh,SQ)!=0)
        {{
          seen={zeros};
          for (k=1;k<=size(F);k++)
          {{
            if (reduce(F[k],SQ)==0)
            {{
              ee=EM[k];
              for (m=1;m<=size(ee);m++) {{ seen[ee[m]]=1; }}
            }}
          }}
          count=0;
          for (n=1;n<=size(seen);n++) {{ count=count+seen[n]; }}
          if (count>maximum)
          {{
            maximum=count; maxi=i; maxj=j; maxq=q;
            print("NEWMAX "+string(maximum)+" "+string(maxi)+" "+string(maxj)+" "+string(maxq));
          }}
          if (count>=16)
          {{
            good=1;
            // Every marked projective vector must be nonzero.
            for (ii=1;ii<=55;ii++)
            {{
              if (good==1)
              {{
                zero=1;
                for (c=1;c<=5;c++)
                {{ if (reduce(PP[5*(ii-1)+c],SQ)!=0) {{ zero=0; }} }}
                if (zero==1) {{ good=0; }}
              }}
            }}
            // The 55 marked projective points must be pairwise distinct.
            for (ii=1;ii<=55;ii++)
            {{
              for (jj=ii+1;jj<=55;jj++)
              {{
                if (good==1)
                {{
                  same=1;
                  for (c=1;c<=5;c++)
                  {{
                    for (d=c+1;d<=5;d++)
                    {{
                      if (reduce(PP[5*(ii-1)+c]*PP[5*(jj-1)+d]
                                -PP[5*(ii-1)+d]*PP[5*(jj-1)+c],SQ)!=0)
                      {{ same=0; }}
                    }}
                  }}
                  if (same==1) {{ good=0; }}
                }}
              }}
            }}
            // Distinct degree-one components are required for a 19-line union.
            for (ii=1;ii<=19;ii++)
            {{
              for (jj=ii+1;jj<=19;jj++)
              {{
                if (good==1)
                {{
                  same=1;
                  for (u=1;u<=10;u++)
                  {{
                    for (v=u+1;v<=10;v++)
                    {{
                      if (reduce(PL[10*(ii-1)+u]*PL[10*(jj-1)+v]
                                -PL[10*(ii-1)+v]*PL[10*(jj-1)+u],SQ)!=0)
                      {{ same=0; }}
                    }}
                  }}
                  if (same==1) {{ good=0; }}
                }}
              }}
            }}
            if (good==1)
            {{
              goodHighCount=goodHighCount+1;
              print("GOOD_HIGH "+string(count)+" "+string(i)+" "+string(j)+" "+string(q));
              print(SQ);
            }}
          }}
        }}
      }}
    }}
  }}
  if (i%20==0) {{ print("PROGRESS "+string(i)+" / "+string(size(F))); }}
}}
print("ALGEBRAIC_CLOSURE_MAX_NONIDENTICAL_EDGES "+string(maximum));
print("ARGMAX "+string(maxi)+" "+string(maxj)+" "+string(maxq));
print("DISTINCT_MARKS_AND_LINES_WITH_AT_LEAST_16_NONIDENTICAL_EDGES "+string(goodHighCount));
exit;'''
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q"], input=code, check=True,
        capture_output=True, text=True,
    )
    return result.stdout


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--factors", action="store_true")
    parser.add_argument("--closure-bound", action="store_true")
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    run_closure = arguments.closure_bound or arguments.write or arguments.check
    payload = json.loads(FAMILY.read_text())
    lines = []
    for record in payload["lines"]:
        lines.append(([cmod(x) for x in record["u"]], [cmod(x) for x in record["v"]]))
    trans_a = transversal(lines, A_TRIPLE, a)
    trans_b = transversal(lines, B_TRIPLE, b)
    h = hyperplane((*trans_a, *trans_b))
    h4 = h[4]
    assert not h4.is_zero
    points = marked_points(lines, h)
    cover_lines = [(points[t[0]], points[t[1]]) for t in COVER]
    cover_line_scales = [line_scale(line) for line in cover_lines]

    identically_meeting = []
    scalars = {}
    factor_histogram = {}
    for i, j in itertools.combinations(range(19), 2):
        matrix = [[cover_lines[i][column][row] for column in range(2)]
                  + [cover_lines[j][column][row] for column in range(2)]
                  for row in range(4)]
        determinant = det_poly(matrix)
        if determinant.is_zero:
            identically_meeting.append((i, j))
            continue
        quotient, remainder = sp.div(determinant, h4, domain=sp.GF(P))
        assert remainder.is_zero, (i, j)
        quotient, remainder = sp.div(
            quotient, cover_line_scales[i] * cover_line_scales[j],
            domain=sp.GF(P),
        )
        assert remainder.is_zero, (i, j, "line scales")
        quotient = sp.Poly(quotient, a, b, modulus=P).monic()
        scalars[(i, j)] = quotient
        signature = (quotient.degree(a), quotient.degree(b), quotient.total_degree())
        factor_histogram[str(signature)] = factor_histogram.get(str(signature), 0) + 1

    print("h4", h4.as_expr())
    print("identically_meeting", identically_meeting)
    print("nonzero_intersection_scalars", len(scalars))
    print("factor_histogram", factor_histogram)
    factor_edges = {}
    multiplicities = []
    factor_multiplicity_histogram = {}
    closure_output = ""
    if arguments.factors or run_closure:
        factor_edges = {}
        for edge, polynomial in scalars.items():
            for factor, exponent in singular_factors(polynomial):
                factor_edges.setdefault(factor, []).append((edge, exponent))
        multiplicities = sorted(
            ((len(records), factor, records) for factor, records in factor_edges.items()),
            reverse=True,
        )
        print("distinct_irreducible_factors", len(factor_edges))
        factor_multiplicity_histogram = {
            count: sum(len(records) == count for records in factor_edges.values())
            for count in sorted({len(records) for records in factor_edges.values()})
        }
        print("factor_edge_multiplicity_histogram", factor_multiplicity_histogram)
        print("top_factor_edge_groups", multiplicities[:20])
        if run_closure:
            closure_output = singular_closure_bound(
                factor_edges, list(scalars), h4, points, cover_lines,
            )
            print(closure_output, end="")
    maximum = (-1, None, None)
    count_histogram = {}
    good_count = 0
    for av in range(P):
        for bv in range(P):
            if int(h4.eval({a: av, b: bv})) % P == 0:
                continue
            hvalues = [int(polynomial.eval({a: av, b: bv})) % P for polynomial in h]
            if not good_marked_fiber(lines, hvalues):
                continue
            good_count += 1
            count = len(identically_meeting) + sum(
                int(polynomial.eval({a: av, b: bv})) % P == 0
                for polynomial in scalars.values()
            )
            count_histogram[count] = count_histogram.get(count, 0) + 1
            maximum = max(maximum, (count, av, bv))
    print("affine_h4_nonzero_edge_count_histogram", count_histogram)
    print("affine_h4_nonzero_distinct_marked_fibers", good_count)
    print("affine_h4_nonzero_maximum", maximum)
    print("special_parameter_edges", end=" ")
    special = {a: -1, b: 14}
    edges = list(identically_meeting)
    for edge, polynomial in scalars.items():
        if int(polynomial.eval(special)) % P == 0:
            edges.append(edge)
    print(edges)
    if arguments.write or arguments.check:
        closure_maximum = int(re.search(
            r"ALGEBRAIC_CLOSURE_MAX_NONIDENTICAL_EDGES (\d+)", closure_output,
        ).group(1))
        qualified_high = int(re.search(
            r"DISTINCT_MARKS_AND_LINES_WITH_AT_LEAST_16_NONIDENTICAL_EDGES (\d+)",
            closure_output,
        ).group(1))
        data = {
            "schema": "s19-two-transversal-family-mod67-v1",
            "source_sha256": {"universal_marked_family.json": sha256(FAMILY)},
            "field": {"prime": P, "zeta11": ZETA},
            "scope": {
                "transversal_parameters": "affine (a,b) chart in P1 x P1",
                "hyperplane_chart": "h4 != 0",
                "cover_line_count": 19,
                "marked_cover": [list(triple) for triple in COVER],
            },
            "intersection_equations": {
                "identically_meeting_edges": [list(edge) for edge in identically_meeting],
                "nonzero_scalar_count": len(scalars),
                "bidegree_histogram": factor_histogram,
                "irreducible_factor_count": len(factor_edges),
                "factor_edge_multiplicity_histogram": {
                    str(key): value for key, value in factor_multiplicity_histogram.items()
                },
                "maximum_single_factor_edge_multiplicity": multiplicities[0][0],
            },
            "algebraic_closure_audit": {
                "all_pairwise_irreducible_factor_intersections_checked": True,
                "maximum_nonidentical_edges_before_qualification": closure_maximum,
                "required_nonidentical_edges_for_connected_graph": 16,
                "points_with_at_least_16_nonidentical_edges_and_distinct_55_marks_and_19_lines": qualified_high,
            },
            "rational_fiber_audit": {
                "distinct_marked_fibers": good_count,
                "edge_count_histogram": {str(key): value for key, value in count_histogram.items()},
                "maximum": {"edge_count": maximum[0], "a": maximum[1], "b": maximum[2]},
            },
            "exact_witness_reduction": {
                "parameters": {"a": P - 1, "b": 14},
                "intersection_edges": [list(edge) for edge in edges],
                "note": "the third modular edge is accidental; the exact Q(zeta11) union has only the first two",
            },
            "terminal_marker": "S19_TWO_TRANSVERSAL_AFFINE_H4_MOD67_NO_LINE_TREE",
            "strict_nonclaims": [
                "This is a finite-characteristic result on one parameter and hyperplane chart.",
                "It does not exclude algebraic points on the parameter-at-infinity or h4=0 charts.",
                "It does not imply characteristic-zero emptiness of this family or of either S19 Rao branch.",
                "It concerns one fixed 19-triple cover and does not exhaust other reducible or integral constructions.",
            ],
        }
        encoded = json.dumps(data, indent=2, sort_keys=True) + "\n"
        if arguments.write:
            OUTPUT.write_text(encoded)
            print(f"wrote {OUTPUT}")
        if arguments.check:
            if OUTPUT.read_text() != encoded:
                raise SystemExit("two-transversal modular payload mismatch")
            print("S19_TWO_TRANSVERSAL_MOD67_REPRODUCES")
    print("S19_TWO_TRANSVERSAL_FAMILY_SYMBOLIC_MOD67_READY")


if __name__ == "__main__":
    main()
