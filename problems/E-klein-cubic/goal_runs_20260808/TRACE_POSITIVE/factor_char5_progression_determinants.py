#!/usr/bin/env python3
"""Factor the four fixed linearized progression determinants over F5.

SymPy constructs the determinants; Singular performs exact multivariate
factorization over the finite field.
"""

import subprocess
import sympy as sp

z = sp.symbols("z0:5")


def progression_matrix(c):
    matrix = [[sp.Integer(0) for _ in range(5)] for _ in range(5)]
    for t in range(5):
        i0 = t
        i1 = (t + c) % 5
        i2 = (t + 2 * c) % 5
        i3 = (t + 3 * c) % 5
        matrix[t][i0] += 1
        matrix[t][i1] += z[(i1 + 1) % 5] + 2 * z[i1]
        matrix[t][i2] += 2 * z[i2] * z[(i2 + 1) % 5] + z[i2] ** 2
        matrix[t][i3] += z[i3] ** 2 * z[(i3 + 1) % 5]
    return sp.Matrix(matrix)


for c in range(1, 5):
    determinant = sp.Poly(progression_matrix(c).det(), *z, modulus=5)
    expression = str(determinant.as_expr()).replace("**", "^")
    singular_input = f"""
ring r=5,(z0,z1,z2,z3,z4),dp;
poly determinant={expression};
list factors=factorize(determinant);
size(factors[1]);
factors[2];
"""
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q"],
        input=singular_input,
        text=True,
        check=True,
        capture_output=True,
    )
    print(f"c={c} total_degree={determinant.total_degree()} "
          f"terms={len(determinant.terms())}")
    lines = [line.strip() for line in result.stdout.splitlines() if line.strip()]
    assert lines == ["2", "1,1"], lines
    print("  F5_FACTOR_COUNT=1 MULTIPLICITY=1")

print("F55-CHAR5-PROGRESSION-DETERMINANTS-F5-IRREDUCIBLE")
