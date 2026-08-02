# Secant and residual constructions

The collinear operation on the installed degree-three multisection is
determined exactly.  The binary pair recipe on the degree-55 construction was
exhausted at one sealed split reduction.  No accepted degree-one curve over
the characteristic-zero base was produced.

## Curve classes

Let

\[
q=(H,D,L)=(0,-1,1),\qquad
\ell=(H,D,L)=(1,1,0).
\]

The exceptional trisection has aggregate class \(3q\), and the 55 horizontal
involution-line sections have aggregate class \(55(q+\ell)\). Formal
subtraction of these zero-cycle degrees is not a section.

For the exceptional trisection, the three points in a fibre are the
intersection with one plane line. Secant residual of any pair simply returns
the third point, so this operation preserves the degree-three cover.

## Gcd-free residual sections in two split reductions

At each of `p=23` and `p=67`, the polar third intersection of two distinct
usable involution-line sections gives a genuine specialized section of class
\(q+4\ell\).  Independent reconstruction verifies the two input lines, the
polar formula, the cubic and graph identities, coordinate gcd one, all 13
degree-four coefficient equations, and Jacobian rank 13.  Thus each point is
smooth of local projective dimension five in the saturated section locus:

```text
prime   coordinate gcd degree   Jacobian rank / 13   local dimension
23      0                       13                   5
67      0                       13                   5
```

These are sections only over the frozen split finite fields.  They supply no
descent datum, invariant characteristic-zero branch, or
\(K_{\rm Schur}(q)\)-point.  The producers and ledgers are
`produce_modular_residual_sections.py` and
`modular_residual_section_p23.json`/`p67.json`; the polar data are replayed
independently by `verify_fibration_sections.py`.

## All pairs in the 55-line construction

At the exact sealed finite-field witness

\[
(p,\zeta_{11},v)=(23,2,(13,9,5,5,8,19)),
\]

the producer reconstructs all 55 specialized lines, parametrizes each as a
degree-one section of the specialized pencil, and applies the polar
third-intersection
formula

\[
\alpha_{ij}=d\Phi_{P_i}(P_j),\qquad
\beta_{ij}=d\Phi_{P_j}(P_i),\qquad
R_{ij}=-\beta_{ij}P_i+\alpha_{ij}P_j.
\]

All 1,485 unordered pairs satisfy both the cubic and graph identities over
\(\mathbf F_{23}\). Their six orbits for the specialized 660-action have sizes

\[
165,\ 330,\ 165,\ 330,\ 165,\ 330.
\]

The first orbit consists of 55 line triangles. Its 165 pair residuals map
three-to-one onto the original 55 specialized line sections. In each of the
other five orbits every output is distinct at the witness. Each contains a
gcd-free projective-degree-four representative of class \(q+4\ell\), and no
specialized orbit is a singleton.

This packet does not construct a characteristic-zero family of those
residual maps or certify the specialization and descent maps needed to
identify an orbit field over \(K\). Consequently the calculation is not a
proof that the generic pair recipe fails to descend. It supplies an exact
finite-field census and no accepted \(K_{\rm Schur}\)-section.

## Quartic input

The degree-four multisection in this packet is proved coordinate-free. Without
an exact quartic field/point tuple there is no scheme-theoretic secant or
tangent input to test against the degree-three or degree-55 covers.

Therefore M3.4 produces no accepted rational curve over \(K\), no
\(K(q)\)-point, and no headline bridge. It does not prove that all residual
constructions fail. The producer, full specialized orbit ledger, and
independent replay are `produce_line_pair_residuals.py`,
`line_pair_residuals.json`, and `verify_line_pair_residuals.py`.
