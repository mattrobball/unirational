# Point and valuation audit

## Rational point

No `K`-rational point was found.  The exact positive payload is instead the
degree-five point over `E` in `NORM_MODEL.md`.  A general `K`-line section
gives a degree-three zero-cycle.  Their gcd is one, so the twist has index
one; neither cycle is promoted to a point.

The trace model makes the unresolved point problem smaller and exact:

```text
Find nonzero a in E with Tr_E/K(r2^-1*a^2*sigma(a))=0.
```

Every pure Laurent monomial `a` is excluded, but that is an infinite ansatz
screen, not an exhaustive rational-function theorem.

## Norm and torus torsors

The coefficient `c=r2^-1` has norm one.  Multiplicative Hilbert 90 applies
to `d/sigma(d)` and does not solve the needed equation
`d^2*sigma(d)=c^-1`.  The latter map has degree `33`, and the coefficient
class has exact order eleven.  This precisely records the surviving torus
torsor; it does not assert a cohomological obstruction to trace zero.

## Valuations

No valuation with pointless residue was constructed.  In particular, this
packet makes none of the invalid implications

```text
special fibre has no visible point => generic twist is pointless,
index one => rational point,
nontrivial multiplicative class => trace cubic is pointless.
```

A future negative valuation must be taken on the explicit four-parameter
field in `FIELD_MODEL.md`, extend every hypothetical point by properness,
and prove the resulting residual trace cubic pointless.  The
`valuation_obstruction` field in `decision.json` is deliberately `null`.

## Decision

The exact result is the structural exit

```text
H-11_5-NORM-MODEL-PASS
```

not `H-11_5-RATIONAL-POINT`, not
`H-11_5-POINTLESS-HEADLINE-NEGATIVE`, and not an unscoped decision for
Problem E.
