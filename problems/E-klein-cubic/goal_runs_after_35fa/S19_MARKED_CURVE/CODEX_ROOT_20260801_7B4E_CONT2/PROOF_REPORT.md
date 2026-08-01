# Proof report

The main positive technical result is a lossless incidence reduction.  For
distinct affine source parameters `tau_i`, a target coordinate `y0` avoiding
the 55 marks, ratios `r_ji=yj(p_i)/y0(p_i)`, and Reed--Solomon dual weights
`w_i`, define

```text
H[(j,m),k] = sum_i w_i*r_ji*tau_i^(m+k),
j=1,2,3; m=0,...,34; k=0,...,19.
```

Then marked degree-19 incidence is equivalent to `rank(H)<20` with a kernel
polynomial nonzero at all marks.  The kernel reconstructs the four map forms
by degree-19 interpolation.  The independent planted control drops rank to
19 and reconstructs the map, while the actual 5,468 tested parameter vectors
remain full rank.

The exact degeneration route reaches degree 19 but fails the Hilbert gate:
19 trisecants cover all marks, yet their union has 17 components and
`p_a=-16`.  A modular algebraic-closure audit then excludes the obvious
two-parameter repair on its stated chart.  These are exact scoped advances,
not a decision of the saturated relative marked-Hilbert incidence.

No claim in this packet changes the Klein-cubic headline or the parent
packet's `S19-UNDECIDED` exit.
