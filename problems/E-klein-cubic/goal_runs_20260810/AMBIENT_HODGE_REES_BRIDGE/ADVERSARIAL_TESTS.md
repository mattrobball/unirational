# Adversarial tests

Every theorem recorded in this packet was weakened until it survived the tests
below.

## Test 1 — artificial free-orbit refinement

### Operation

Start with a resolution

\[
Z\to Y\to\mathbf P^4
\]

and blow up a free `G`-orbit of smooth positive-genus curves disjoint from the
old exceptional locus.  Let

\[
h:Z'\to Z.
\]

The blowup formula adds

\[
\bigoplus_{a\in G} H^1(C_a)(-1)
\simeq
\operatorname{Ind}_{1}^{G}H^1(C)(-1),
\]

which may contain `V` abstractly.

### Actual-image calculation

The new landing morphism is `g h`, and

\[
(g h)^*V=h^*g^*V.
\]

Under the blowup decomposition this lies in the pullback of `H^3(Z)` and has
zero component in the new curve summands.  The ambient normalized graph `Y`,
the map `alpha_A`, and its perverse support blocks are unchanged.

### Verdict

**PASS.**  The invariant ignores artificial occurrence and follows the actual
canonical image.

## Test 2 — two blowup factorizations

### Operation

Replace one smooth resolution dominating `Y` by another.  Weak factorization
connects them through blowups and blowdowns with smooth centers.  The list,
order, genera, and stabilizers of the centers can change.

### Invariant

The packet does not select “the first center receiving `V`.”  It selects:

\[
\alpha_A(V)\subset IH^3(Y)(1),
\]

the canonical perverse jump `j_0`, and the canonical nonempty set of strict-support orbits in

\[
{}^pH^{j_0}(Rp_*IC_Y^H)
\]

receiving the image.

### Verdict

**PASS.**  The resolution centers may change; the normalized graph and
strict-support package do not.

## Test 3 — contraction of positive-genus geometry

### Model

Use the resolution of the projective cone over a positive-genus curve from
`CONTRACTION_COUNTERMODEL.md`:

\[
\tau:T\to S.
\]

The exceptional section is `C`, with

\[
H^1(T)=H^1(C).
\]

After contraction,

\[
H^1(S)=0,
\qquad
\operatorname{Alb}(S)=0,
\]

but

\[
IH^1(S)=H^1(C).
\]

### Verdict

**FAIL for ordinary Albanese descent; PASS for strict support.**  Any theorem
requiring a positive-irregularity image on the normalized graph is false in
this generality.  Intersection complexes are necessary.

## Test 4 — trivial-stabilizer support

### Screen

Let `S` have trivial generic stabilizer.  Its orbit block is induced from
`H=1`.  No character-theoretic obstruction prevents

\[
V\hookrightarrow
\operatorname{Ind}_{1}^{G}W_S
\]

for a suitable weight-one Hodge structure `W_S`.

The ambient theorem permits `H=1`.  It does not claim that every support meets
the involution/`V4` fixed arrangement.  Positive-dimensional supports meet the
source cubic set-theoretically by ampleness, but may do so entirely away from
the forced fixed network; point supports may be disjoint from the cubic.

### Verdict

**PASS only after retaining the free-support escape.**  A “no-free-support”
theorem remains unproved.

## Test 5 — the Hessian genus-26 carrier

### Existing candidate

The ambient representation contains the canonical genus-26 Hessian/`X(11)`
curve whose `H^1` has the required Weil piece.  Therefore representation theory
cannot exclude all ambient supports.

### Packet response

The strict-support theorem is compatible with the Hessian curve.  It says that
a support block must carry the actual image; it does not say that the Hessian
curve cannot carry it.  To exclude the Hessian candidate one would need to
prove that it cannot occur in the base locus or in the relevant fiber
cohomology of an actual landing ideal, or that its `V`-projection dies under the
landing correspondence.

### Verdict

**PASS.**  No false representation-theoretic impossibility is claimed.

## Test 6 — genus-four and Prym covers over \(E_t\)

### Existing geometry

The fixed elliptic has

\[
j(E_t)=8192/11
\]

and is non-CM, while

\[
j(E_{-11})=-32768.
\]

Hence

\[
\operatorname{Hom}(E_t,E_{-11})=0.
\]

This only excludes the literal elliptic factor.  The repository constructs
finite covers and genus-four/Prym geometries over `E_t` whose Jacobians may
contain `E_{-11}` factors.

### Packet response

The local exclusion condition is always

\[
\operatorname{Hom}_{\mathrm{HS},H}
\left(
\operatorname{Res}_H V,H^1(C)
\right)=0
\]

for the actual cover or Prym carrier `C`.  No argument replaces `C` by `E_t`.
The retraction Fano carrier is treated as a viable Hodge carrier, not an
obstruction.

### Verdict

**PASS.**

## Test 7 — ambient versus restricted normalized graph

### Comparison

The ambient graph is a fourfold; the restricted graph is a threefold.  The
ambient support is a strict-support block for

\[
p:Y\to\mathbf P^4.
\]

The restricted object is obtained only after derived restriction, component
selection, and normalization.

### Failure mode

The full-support term for `Gamma→X` already contributes `H^3(X)`.  Therefore a
nonzero restricted landing class need not lie in a proper restricted support.
Vanishing cycles can also alter the restriction of an ambient intersection
complex.

### Verdict

**TRANSFER UNDECIDED.**  No identification of ambient and restricted Rees
divisors or Hodge supports is made.

## Test 8 — a point-supported ambient Hodge module

For a nonsemismall birational fourfold map, a point-supported constituent of

\[
{}^pH^{-1}(Rp_*IC_Y^H)
\]

can contribute a pure weight-three Hodge structure to `IH^3(Y)`.  Such a
constituent may be supplied by odd cohomology of a complicated exceptional
fiber over an isolated base point.  It has no positive-dimensional support and
need not meet the source cubic.

### Verdict

**PASS only in the Hodge-module formulation.**  A theorem asserting that every
ambient support is a curve, surface, Rees divisor, or finite cover of such an
object is not justified.

## Consolidated verdict

The strongest statement surviving all tests is:

```text
actual image in a canonical proper strict-support block of the ambient
normalized graph, with an associated weight-one abelian factor up to isogeny.
```

The stronger statement

```text
that block survives as an exceptional H^1-carrier on the restricted normalized
graph
```

remains open.
