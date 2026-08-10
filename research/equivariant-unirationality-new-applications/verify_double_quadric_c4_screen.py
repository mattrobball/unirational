#!/usr/bin/env python3
"""Exact fixed-point and line-character check for the C4 double-quadric screen."""
from __future__ import annotations

import sympy as sp


def main() -> None:
    I = sp.I

    # The four-cycle c=(0123) on the first four coordinates of C^5, fixing x_4.
    # Column j of the matrix is the image of the basis vector e_j.
    permutation = {0: 1, 1: 2, 2: 3, 3: 0, 4: 4}
    matrix = sp.zeros(5, 5)
    for source, target in permutation.items():
        matrix[target, source] = 1
    assert matrix**4 == sp.eye(5)
    assert matrix**2 != sp.eye(5)

    # Exact eigen-decomposition: eigenvalue 1 with multiplicity two, and
    # -1, i, -i each with multiplicity one.
    eigenvalues = matrix.eigenvals()
    assert eigenvalues == {
        sp.Integer(1): 2,
        sp.Integer(-1): 1,
        I: 1,
        -I: 1,
    }, eigenvalues

    # The quadratic form of the Fermat quadric threefold Q subset P^4.
    quadratic_form = sp.eye(5)
    assert quadratic_form.det() != 0  # Q is smooth

    def q_value(vector):
        column = sp.Matrix(vector)
        return sp.expand(sp.simplify((column.T * quadratic_form * column)[0, 0]))

    # c preserves Q: the permutation matrix is orthogonal for the Fermat form.
    assert sp.simplify(matrix.T * quadratic_form * matrix - quadratic_form) == sp.zeros(5, 5)

    # Eigenvectors, verified as eigenvectors rather than assumed.  With this
    # matrix convention the line spanned by (1,mu,mu^2,mu^3,0) is the
    # eigenline for the eigenvalue mu^(-1), which is again a fourth root of
    # unity; the three nontrivial eigenlines are therefore mu=-1,i,-i.
    def eigenvector(mu):
        return [sp.Integer(1), mu, mu**2, mu**3, sp.Integer(0)]

    for mu in (sp.Integer(-1), I, -I):
        vector = sp.Matrix(eigenvector(mu))
        assert sp.simplify(matrix * vector - mu ** (-1) * vector) == sp.zeros(5, 1)

    q_values = {mu: q_value(eigenvector(mu)) for mu in (sp.Integer(-1), I, -I)}
    assert q_values[sp.Integer(-1)] == 4  # the -1 eigenline is NOT on Q
    assert q_values[I] == 0  # this eigenline lies on Q
    assert q_values[-I] == 0  # this eigenline lies on Q

    # The +1 eigenspace is spanned by (1,1,1,1,0) and (0,0,0,0,1); verify both.
    plus_basis = [
        [sp.Integer(1)] * 4 + [sp.Integer(0)],
        [sp.Integer(0)] * 4 + [sp.Integer(1)],
    ]
    for vector in plus_basis:
        column = sp.Matrix(vector)
        assert sp.simplify(matrix * column - column) == sp.zeros(5, 1)

    # Q restricted to a*(1,1,1,1,0)+b*(0,0,0,0,1) is 4a^2+b^2; on the
    # projective line b/a=t this is t^2+4, which is squarefree of degree two,
    # so it contributes exactly two reduced points.
    a, b, t = sp.symbols("a b t")
    restriction = q_value([a, a, a, a, b])
    assert sp.expand(restriction - (4 * a**2 + b**2)) == 0
    plus_polynomial = sp.Poly(restriction.subs({a: 1, b: t}), t)
    assert plus_polynomial.degree() == 2
    assert sp.gcd(plus_polynomial, plus_polynomial.diff(t)) == 1

    fixed_points = 2 + 1 + 1
    assert fixed_points == 4

    # O_Q(-1) has fiber character lambda on the eigenline with eigenvalue
    # lambda, so O_Q(4) has character lambda^(-4)=1 at every fixed point,
    # because every eigenvalue of c is a fourth root of unity.
    fixed_eigenvalues = [sp.Integer(1), sp.Integer(1), I, -I]
    for lam in fixed_eigenvalues:
        assert lam**4 == 1
        assert sp.simplify(lam ** (-4)) == 1

    # Tangent characters at each fixed point p=[v] with c-eigenvalue lam:
    #   T_p P^4 = Hom(<v>, C^5/<v>) has characters lam^(-1)*mu, where mu runs
    #   over the eigenvalues of c on C^5 with one copy of lam removed;
    #   T_p Q = ker(dq_p) removes one copy of the character of O(2)_p, namely
    #   lam^(-2), which occurs because Q is smooth at p.
    # The screening lemma needs the TRIVIAL character to be absent from T_p Q,
    # equivalently (T_p Q)^c = 0, equivalently p isolated in Q^c.
    ambient_characters = [sp.Integer(1), sp.Integer(1), sp.Integer(-1), I, -I]
    tangent_characters = {}
    for label, lam in (("P_plus", sp.Integer(1)), ("P_minus", sp.Integer(1)),
                       ("P_i", I), ("P_minus_i", -I)):
        remaining = list(ambient_characters)
        remaining.remove(lam)
        projective = [sp.simplify(lam ** (-1) * mu) for mu in remaining]
        conormal = sp.simplify(lam ** (-2))
        assert conormal in projective, (label, projective, conormal)
        projective.remove(conormal)
        assert len(projective) == 3
        assert sp.Integer(1) not in projective, (label, projective)
        tangent_characters[label] = projective

    # Consequence recorded in QUADRATIC_DOUBLE_SOLIDS.md: the rejection is
    # exact for a genuinely invariant section, and the characters that a
    # semi-invariant section would have to carry to escape it are exactly
    # those occurring in the tangent space.
    assert set(tangent_characters["P_i"]) == {I, -I}
    assert set(tangent_characters["P_minus_i"]) == {I, -I}
    assert set(tangent_characters["P_plus"]) == {sp.Integer(-1), I, -I}
    assert set(tangent_characters["P_minus"]) == {sp.Integer(-1), I, -I}

    print(f"DOUBLE_QUADRIC_C4_SCREEN_OK fixed_points={fixed_points}")


if __name__ == "__main__":
    main()
