# Integral quartic multisections

## Accepted alternative

For the generic cubic surface \(S/K(q)\), the installed degree-three and
degree-55 zero-cycles have coprime degrees, so \(\operatorname{ind}(S)=1\).
The accepted characteristic-zero theorem then gives the exact alternative

\[
S(K(q))\ne\varnothing
\quad\text{or}\quad
S\text{ has a closed point of degree }4.
\]

The M2 arithmetic audit excludes the degree-two branch in the cited
formulation, so the no-section alternative is an integral degree-four
multisection of \(Y/\mathbf P^1\).

## Residual-field theorem

The degree-55 point splits over \(E(q)\), whose Galois group over \(K(q)\) is
\(G=\operatorname{PSL}_2(\mathbf F_{11})\).  Since \(G\) has no subgroup of
index four, an integral quartic residue field cannot be contained in
\(E(q)\).

Thus the quartic alternative is not a hidden four-element orbit of the
55-line cover.  It necessarily introduces a new extension of \(K(q)\).

This is compatible with the current Q2.1 descent audit, which leaves the
primitive `A4/S4` quartic descent frontier open after exhausting standard
finite-torsor obstructions.

## Why this does not force the section branch

The degree-four point theorem is obtained through rational equivalence,
effectivity of residual zero-cycles, and a rank-two vector-bundle argument.
Neither its statement nor the cited proof supplies containment of the
quartic residue field in the splitting field of the input zero-cycles.
Consequently, excluding quartic subfields of \(E(q)\) does not exclude the
quartic branch itself.

A direct quartic parameter space may be described as the open locus of
integral length-four closed subschemes in the relative Hilbert/Chow space of
the fibres.  Equivalently, one may introduce a primitive quartic algebra
\(L/K(q)\), coordinates of a point in \(\mathbf P^3(L)\), impose the cubic
equation, and impose descent and integrality.  This packet does not solve
that arithmetic scheme.

## Verdict

```text
explicit integral quartic multisection: NOT PRODUCED
quartic locus empty:                    NOT PROVED
quartic contained in E(q):              PROVED IMPOSSIBLE
```

The theorem remains useful as a binary fallback: if every section component
is pointless, an integral quartic exists, but it is genuinely external to
the installed line splitting field.
