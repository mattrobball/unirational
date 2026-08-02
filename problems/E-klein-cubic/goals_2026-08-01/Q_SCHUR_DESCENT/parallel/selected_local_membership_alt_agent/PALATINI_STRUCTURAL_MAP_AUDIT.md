# Invariant Palatini quartic: structural map audit

## Outcome

No genuine rational `G`-map

```text
P(V6)  --->  W={I4=0} subset P(V6)
```

was constructed.  The exact representation and the classical ruling geometry
instead give three sharp obstructions to the most canonical attempts:

1. the singular/focal curve cannot be the image of such a map;
2. the true polar map lands in `P(V6*)`, and `V6` has no invariant linear
   self-duality;
3. the first canonical self-covariant secant line meets `W` in a generically
   irreducible quartic, so it has no invariant-rationally selected point.

The ruling incidence shows that any other map to the smooth locus of `W` would
already recover a rational map to `V14`, i.e. the original unresolved point
gate rather than an easier surrogate.

## 1. Exact singular geometry in the installed good fibre

The scripts reconstruct the 126-term Reynolds quartic from the exact Schur
representation reduced at `(23,zeta_11-2)`.  Singular gives:

```text
I4 irreducible of degree 4,
dim Proj F_23[x0,...,x5]/(dI4) = 1,
degree Sing(W_23) = 25.
```

The second Hilbert-series numerator is

```text
1,4,10,14,11,-4,-16,-10,10,4,1.
```

Its sum is `25` and its derivative at `1` is `50`, hence

```text
p_a = 1 - 25 + 50 = 26.
```

Adding all 225 four-by-four minors of the `6 x 6` Hessian to the gradient
ideal leaves a zero-dimensional homogeneous cone.  Thus the projective
degree-25 genus-26 curve is smooth in this good fibre.  This is the exact
special-fibre realization of the classical focal curve

```text
Gamma = Sing(W) = Hilb_lines(V14).
```

The characteristic-zero identification comes from the already installed exact
Palatini lift and the Puts/Fano incidence theorem; the modular calculation is
not used to overstate a new all-primes theorem.

## 2. Why the singular locus and its planes do not produce the map

The incidence

```text
U = P(S|_V14)  --ev-->  W
```

is generically one-to-one: a general point of `W` lies on a unique ruling line
`l_x`, `x in V14`.  Over `Gamma`, a Schubert pencil of points of `V14`
corresponds to ruling lines through one focus `p`; their union is a distinguished
plane contained in `W`.  Thus the focal curve also parametrizes the exceptional
planes/pencils of the ruling resolution.

There is no rational map `P5 --> Gamma` with nonconstant image: a rationally
connected variety cannot dominate the smooth genus-26 curve.  A constant
`G`-equivariant map would require a fixed projective point.  The exact good-fibre
action has one-dimensional commuting endomorphism algebra in characteristic
`23` (which does not divide the group order), so `V6` is absolutely irreducible;
in particular it has no invariant line and `P(V6)` has no fixed point.  Hence
there is no rational `G`-map from `P(V6)` to `Gamma` at all.  Selecting one of
the distinguished planes through its focus therefore cannot start a rational
construction.

On `W\Gamma`, inverse ruling-line recovery gives a rational map `W --> V14`.
Consequently any rational `G`-map `P(V6) --> W` not contained in `Gamma` would
compose to the missing rational `G`-map `P(V6) --> V14`.  This is a useful
equivalence of difficulty, not a construction.

The standard birational maps `V14 --> W cap L` and `X --> W cap L` also require
a chosen hyperplane `L subset P(V6)`.  Irreducibility gives no fixed `G`-stable
hyperplane, exactly explaining why this classical birationality does not supply
the required equivariant arrow.

## 3. Polar and secant maps

The genuine cubic polar is

```text
[x] |--> [dI4_x] in P(V6*).
```

Solving `g^t B g=B` for both exact generators in the good fibre gives

```text
dim Hom_(2.G)(V6,V6*) = 0.
```

Good reduction therefore rules out an invariant characteristic-zero bilinear
identification `V6 ~= V6*`.  The polar map cannot be silently reinterpreted as
a self-map of `P(V6)` or as a point of `W`.

There is a different, unique degree-three Reynolds self-covariant `q3`.  It is
not the gradient.  The most economical self-covariant secant construction is

```text
ell_x = <x,q3(x)>,qquad I4(x+t q3(x))=0.
```

The installed exact certificate factors this polynomial over `F_(23^m)` for
`m=1,2,3,4`; in every case it remains one irreducible factor of `t`-degree
four.  Since any algebraic-constant linear factor has Frobenius orbit of size
at most four, the source-bound valuation/specialization argument excludes a
root already in `C(x0,...,x5)`.  Thus this canonical secant line gives no
rational point of `W`.  The same packet excludes nine other displayed
two-covariant pencils over the stated arithmetic constant field, but those are
bounded family exclusions rather than a universal no-map theorem.

## 4. Interaction with the new degree-11 point

Using the newly completed maximal-`A5` theorem together with the parent
weak-versality specialization argument, the full torsor has a degree-11 point.
Proper birational transport gives a degree-11 zero-cycle on `V14`; choosing a
point on the corresponding line after the degree-11 extension gives a
degree-11 zero-cycle on `W`.

Because `W` is a quartic in a split `P5`, a general `K`-line cuts a degree-four
zero-cycle.  Hence the degrees `4` and `11` prove only

```text
ind(W)=1.
```

They do not produce an effective degree-one point.  No operation pulls this
cycle back to the codimension-three focal curve `Gamma`; the closed inclusion
only pushes zero-cycles from `Gamma` to `W`.

There are two exact residual-degree-12 exits worth preserving:

* If the transported degree-11 cycle on `W` lies on a `K`-defined cubic curve
  `D subset P5` not contained in `W`, then Bezout gives
  `length(D cap W)=3*4=12`; a scheme-theoretic residual point would be a
  `K`-point of `W`, hence of `V14` and the Klein cubic.
* If the original degree-11 cycle on the cubic threefold lies on a `K`-defined
  quartic curve `C subset P4` not contained in the cubic, then
  `length(C cap X)=4*3=12`, with the same residual-point conclusion.

The Palatini/Tregub--Takeuchi rational normal quartics are **contained** in the
cubic, so they do not satisfy the second proper-intersection hypothesis.  A
degree-11 point over an extension produces conjugate contained quartics, not a
single `K`-defined noncontained quartic through the degree-11 cycle.  Likewise,
the Palatini ruling supplies lines and focal planes, not a cubic curve through
the transported cycle.  Constructing either residual curve is therefore a
genuine new incidence theorem and remains open.

## Replay and scope

From this directory run:

```sh
/opt/homebrew/bin/python3 -u verify_palatini_structural.py
```

The terminal markers are:

```text
PALATINI_SINGULAR_CURVE_DEGREE=25
PALATINI_SINGULAR_CURVE_ARITHMETIC_GENUS=26
PALATINI_Q1_Q3_CONSTANT_EXTENSION_CERTIFICATE_BOUND
PALATINI_STRUCTURAL_AUDIT_MOD23_OK
SCOPE: exact good-fibre geometry and source-bound pencil obstruction; no rational G-map
```

This audit neither constructs a rational `G`-map nor proves that none exists.
It closes only the singular-locus, invariant-linear-polar, and first canonical
self-covariant secant routes, and isolates the degree-12 residual-incidence
gates created by the new degree-11 input.
