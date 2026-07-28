# WP-3 certificate: exact exclusion of degree 34

## Verdict and boundary

The complete degree-\(34\) homogeneous Klein-covariant space contains no
dominant landing covariant. Together with the earlier certificates, this
moves the bounded homogeneous frontier from \(34\) to \(36\).

This remains a bounded result. It is not an all-degree obstruction and is
not by itself a binary resolution of Problem F.

## Complete space

Using \(F,D,C\) in degrees \(4,6,14\) and the primitive even covariants
\(\psi,\phi,f\) in degrees \(8,16,18\), write

\[
\begin{aligned}
p={}&AF^5D\psi+BF^2D^3\psi+QF^3C\psi+RD^2C\psi\\
&+SF^3D\phi+TD^3\phi+UFC\phi+VF^4f+WFD^2f. \tag{1}
\end{aligned}
\]

For a primitive dominant landing covariant, the structural Jacobian theorem
gives

\[
J_p=Xh\,k,\qquad \deg k=10.
\]

The degree-\(10\) invariant space is spanned by \(FD\). Consequently

\[
J_p=XFDK,\qquad \deg K=68,\qquad K=c h\quad(c\ne0). \tag{2}
\]

Thus, for some nonzero scalar \(\rho=c^2\),

\[
K^2=\rho F(p). \tag{3}
\]

## Exact residue reductions

The checker substitutes (1) into the cached universal quartic tensor
\(F(u\psi+v\phi+wf)\).

### The divisor \(D=0\)

The coefficient of \(F^{27}C^2\) is \(9834496V^4\), while the preceding
\(F^{34}\) coefficient is zero. Square support therefore forces \(V=0\).
The remaining binary-quartic discriminant factors exactly as

\[
(Q-48U)^4
(Q^2-320QU+19328U^2)
(9Q^2-192QU+19840U^2). \tag{4}
\]

Here the three adjacent factors are multiplied. Hence either \(Q=U=0\),
or, after scaling \(U=1\), \(Q\) belongs to one of the five roots encoded
by (4).

If \(Q=U=0\), every coordinate of \(p\) has the common factor \(D\), and
removing it gives a degree-\(28\) covariant. The complete degree-\(28\)
space is already excluded.

### Top \(C\)-support

With \(V=0\), the three possible \(C^8\) coefficients of \(F(p)\) are

\[
-2744U^3(Q-34U),\qquad -2744RU^3,\qquad 0. \tag{5}
\]

The corresponding \(C^4\) part of a square root has two coefficients.
For every nonzero ratio in (4), \(Q-34U\ne0\). The first value in (5) is
therefore nonzero; the last value forces the second root coefficient to
vanish, and then the middle value forces

\[
R=0. \tag{6}
\]

The \(F\)-free Jacobian coefficient is

\[
[D^{13}](J_p/X)=2239104T(6R+13T)(T+2W). \tag{7}
\]

After (6), either \(T=0\), in which case (1) is \(F\) times a degree-\(30\)
covariant, or \(T\ne0\) and (7) forces \(W=-T/2\). Degree \(30\) is already
excluded, so only the latter branch remains.

Finally, the \(D\)-free Jacobian coefficient after \(V=0\) is

\[
[F^9C^3](J_p/X)
=102(Q-48U)(-14AU+5Q^2+14QS-312QU-2816U^2). \tag{8}
\]

For \(Q/U=48\), (8) is automatic. On either quadratic pair in (4), it
determines \(A\) linearly after the normalization \(U=1\).

## Saturated exact elimination

For each of the three rational branch types (one ratio \(48\) and the two
quadratic conjugate pairs), the checker:

1. reconstructs every coefficient of \(J_p/X\) from an exact full-rank
   \(24\times24\) invariant evaluation matrix;
2. divides by the forced \(FD\) to form \(K\);
3. equates every coefficient of \(K^2-\rho F(p)\);
4. adjoins \(Z\) and \(\rho Z-1\), thereby excluding the nondominant
   \(\rho=0\) locus;
5. computes exact Gröbner bases over \(\mathbf Q\).

The unit ideal appears after \(10\) sorted coefficient equations on the
ratio-\(48\) branch and after \(13\) equations for each quadratic pair.
This excludes every remaining branch.

## Exact replay

From the repository root, run

~~~text
python3 certificates/even_quartic_tensor.py
python3 certificates/wp3_degree34_exclusion.py
~~~

The terminal markers are

~~~text
EVEN_QUARTIC_TENSOR_CACHE_LOAD_OK terms=15
WP3_DEGREE34_EXCLUSION_OK
~~~

The cache can be independently regenerated from the defining Klein forms
and exact invariant reconstruction with

~~~text
python3 certificates/generate_even_quartic_tensor_cache.py
~~~

Its marker is EVEN_QUARTIC_TENSOR_CACHE_OK terms=15.
