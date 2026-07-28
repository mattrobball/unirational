# WP-3 certificate: exact exclusion of degree 32

Date: 2026-07-28.

## Verdict and boundary

The complete degree-32 homogeneous Klein-covariant space contains no
dominant landing covariant. The proof uses only the landing equation

\[
F(p)=h^2
\]

and the already-certified exclusion of degree 28. The stronger structural
requirement \(F^2\mid J_p/X\) is therefore not needed at this degree.

This is a bounded exclusion, not a resolution of Problem F by itself.
Together with the degree-30 certificate, it leaves degree \(34\) as the
first homogeneous degree not yet excluded.

## Complete space and reduction modulo \(F\)

Write

\[
\begin{aligned}
p={}&AF^6\psi+BF^3D^2\psi+PD^4\psi+QFDC\psi\\
   &+RF^4\phi+SFD^2\phi+TF^2Df+UCf. \tag{1}
\end{aligned}
\]

Modulo the Klein quartic \(F=0\), only two directions survive:

\[
p\equiv PD^4\psi+UCf\pmod F. \tag{2}
\]

The \(F\)-free invariant space of weight \(128=4\cdot32\) has basis

\[
D^{19}C,\qquad D^{12}C^4,\qquad D^5C^7.
\]

Exact reconstruction gives

\[
\begin{aligned}
[D^{19}C]F(p)&=-108P^3(P+1568U),\\
[D^{12}C^4]F(p)&=14U(P^3-3024P^2U+1016064PU^2+303464448U^3),\\
[D^5C^7]F(p)&=-2744U^3(5P+1064U). \tag{3}
\end{aligned}
\]

On the other hand, modulo \(F\), an invariant of weight
\(64=2\cdot32\) is a scalar multiple of \(D^6C^2\). Its square has
support only at \(D^{12}C^4\). Thus the first and third expressions in
(3) must vanish. Their projective zero loci do not meet: if
\(P,U\ne0\), they would require

\[
P=-1568U,\qquad 5P=-1064U,
\]

which are incompatible. The cases \(P=0\) or \(U=0\) force the other
coefficient to vanish as well. Hence

\[
P=U=0. \tag{4}
\]

After (4), every coordinate in (1) has the common invariant factor \(F\),
and removing it gives the complete degree-28 space

\[
AF^5\psi+BF^2D^2\psi+QDC\psi+RF^3\phi+SD^2\phi+TFDf.
\]

That space is excluded by the separate exact degree-28 certificate.
Therefore degree 32 is excluded.

## Exact replay

From the repository root, run

    python3 certificates/wp3_degree32_landing.py

The terminal marker is

    WP3_DEGREE32_EXCLUSION_OK

The checker works over \(\mathbf Q\). It restricts to the exact field
\(\mathbf Q[z]/(z^3+z+1)\) on \(x=y=1,F=0\); the restriction matrix for
the three invariant basis elements is asserted invertible, so the three
coefficients in (3) are reconstructed uniquely and exactly.
