# WP-3 certificate: exact exclusion of degree 28

Date: 2026-07-28.

## Verdict

The complete degree-28 homogeneous Klein-covariant space contains no
dominant landing covariant.  Together with the all-odd exclusion, the
degree-24 certificate, and the structural degree-26 gap, the first
homogeneous degree not excluded at this stage was \(30\).  The later
degree-30 and degree-32 certificates move the current frontier to \(34\).

The homogeneous covariant model is exhaustive, but degree \(34\) and
higher even degrees remain open.  Thus this is substantial progress on
the full generic-twist problem, not a binary resolution.

## 1. The family and its forced Jacobian divisibility

Every degree-28 covariant is

\[
\begin{aligned}
p={}&AF^5\psi+BF^2D^2\psi+QDC\psi\\
   &+RF^3\phi+SD^2\phi+TFDf. \tag{1}
\end{aligned}
\]

The structural identity \(J_p=Xhk\) has \(\deg k=4\), hence \(k\) is a
scalar multiple of \(F\).  Therefore \(F\mid J_p/X\).  The exact checker
computes the only two \(F\)-exponent-zero coefficients of this quotient:

\[
\begin{aligned}
[D^{10}](J_p/X)
 &=1843968S(6Q+13S)(S+2T),\\
[D^3C^3](J_p/X)
 &=28Q(3Q-14T)(5Q+14S). \tag{2}
\end{aligned}
\]

The unique invariant monomial outside the degree-28 square-support
sumset gives a third necessary equation:

\[
[FD^{18}]F(p)=-265531392S^3(S+2T)=0. \tag{3}
\]

If \(S=0\), equations (2) reduce to \(Q=0\) or
\(T=3Q/14\).  If \(S\ne0\), equation (3) gives \(T=-S/2\), and the second
equation in (2) gives

\[
Q=0,\qquad 3Q+7S=0,\qquad\text{or}\qquad5Q+14S=0.
\]

The case \(Q=S=0\) has a common factor \(F\) and reduces to the excluded
degree-24 problem.  It remains to exclude four normalized branches.

## 2. Exact leading-monomial descent

Order monomials lexicographically with variable order \(C>D>F\).  The
leading exponent of a square is twice the leading exponent of its square
root, hence is even coordinatewise.

On three of the four branches, the checker obtains the following leading
terms of \(F(p)\):

| branch | leading exponent \((F,D,C)\) | coefficient |
|---|---:|---:|
| \(Q=1,\ S=0,\ T=3/14\) | \((0,7,5)\) | \(-108\) |
| \(Q=0,\ S=1,\ T=-1/2\) | \((3,5,5)\) | \(4802\) |
| \(Q=1,\ S=-5/14,\ T=5/28\) | \((1,4,6)\) | \(-1/2\) |

Each exponent has an odd coordinate, so none is a square.

On the remaining branch

\[
Q=1,\qquad S=-3/7,\qquad T=3/14,
\]

successive leading coefficients at odd exponent vectors are

\[
\begin{array}{c|c}
(3,5,5)&-(21B-116)/7\\
(6,3,5)&-3A+588R^2+116R\\
(9,1,5)&-2744R^3.
\end{array}
\]

They force

\[
B=116/21,\qquad A=196R^2+116R/3,\qquad R=0,
\]

and hence \(A=0\).  At that point

\[
42p=D\bigl(42C\psi+232F^2D\psi-18D\phi+9Ff\bigr).
\]

Thus \(p\) has common factor \(D\); removing it reduces the landing
identity to degree \(22\), already excluded by the structural
\(d\ge24\) theorem (and independently by the exact low-degree
certificate).

This exhausts every branch and excludes degree \(28\).

## Replay

From the certificates directory, with Python 3 and SymPy installed:

    python3 wp3_degree28_exclusion.py

It must end with

    EXACT d=28: F|J_p/X branch equations PASS
    EXACT d=28: impossible-support equation PASS
    EXACT d=28: three branches have odd leading exponent PASS
    EXACT d=28: final branch has common factor D and reduces to degree 22
    WP3_DEGREE28_EXCLUSION_OK

All calculations are exact over \(\mathbf Z\) and \(\mathbf Q\); no
finite-field or floating-point inference is used.
