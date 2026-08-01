# Primitive-quartic descent: exact frontier after the degree-four alternative

## Verdict

This packet does **not** decide the Goal G headline.  It proves that the
suggested small-permutation shortcut points in the opposite direction from
what would be needed: the primitive quartic is forced to remain independent
of the connected generic `PSL(2,11)` splitting field.  It also constructs the
canonical cubic-resolvent point and gives a finite presentation of the exact
primitive-quartic gate.

Throughout,

\[
 K=K_{\rm proj},\qquad E=\mathbf C(\mathbf P(W)),\qquad
 \operatorname{Gal}(E/K)=G=\operatorname{PSL}_2(\mathbf F_{11}),
\]

and `X/K` is the genuine twist represented by `../../generic_cubic.json`.
Assume that `X` has no `K`-point and let `L/K` be the primitive quartic point
supplied by the installed point-or-quartic theorem.  Write `N/K` for its
Galois closure and `H=Gal(N/K)`, so `H=A4` or `S4`.

The external input is Claire Voisin, *Rank 2 vector bundles and degrees of
points of del Pezzo surfaces*, Theorem 1.5 and Remarks 1.6--1.7,
<https://arxiv.org/abs/2509.17996>, applied exactly as audited in
`../zero_cycle_containment/REPORT.md`.  This packet does not enlarge that
theorem's hypotheses.

## 1. Forced disjointness, not missing containment

There is an unconditional equality

\[
                         \boxed{E\cap N=K}.                 \tag{1.1}
\]

Indeed, `E/K` and `N/K` are Galois, so `E cap N` is Galois over `K` and its
Galois group is a quotient of both `G` and `H`.  The group `G` is nonabelian
simple.  Thus a quotient of `G` is trivial or has order `660`, whereas
`|H|` is `12` or `24`.  Only the trivial quotient is possible.

Consequently:

1. `L tensor_K E` is a field of degree four over `E`;
2. its Galois closure is `EN/E`, still with group `A4` or `S4`;
3. the four embeddings still form a primitive permutation action after
   base change to `E`; and
4. the cubic resolvent field introduced below is also linearly disjoint from
   `E`.

Thus the quartic does not become four points over the generic torsor field.
In particular it does **not** define a homomorphism `G -> S4`.  Its
`A4/S4` monodromy comes from the separate extension `N/K`.  Simplicity of
`G` therefore proves persistence of the quartic rather than its descent.

Thus bare field theory cannot prove `E`-containment: containment is
incompatible with (1.1).  A genuinely Klein-specific geometric theorem
forcing containment would still be useful, but only because it would
contradict (1.1) and thereby eliminate the quartic branch.

## 2. Exact restrictions in the no-point branch

Let `Gamma` be the degree-four closed point on the smooth cubic-surface
section `S subset X` used in the point-or-quartic theorem.  Then all of the
following are forced.

### 2.1 Integral and primitive

An effective degree-four cycle which is not integral has a component of
degree one or two.  A degree-one component is a `K`-point.  A quadratic
component gives a `K`-point by joining its conjugates and taking the residual
third intersection with the cubic.  Hence `Gamma` is integral.

If the action on the four embeddings preserves a partition into two pairs,
let `K'/K` be the quadratic field selecting one block.  For each block, the
joining line either meets the surface in a residual `K'`-point or is contained
in the surface and is itself a `K'`-line.  In the latter case choose any
`K'`-point on that line.  Applying the construction to the conjugate block
gives the conjugate point, so the two points form an effective degree-two
cycle over `K`; secant descent again gives a `K`-point.  Hence the action is
primitive.  The primitive transitive subgroups of `S4` are exactly `A4` and
`S4`.

### 2.2 Full projective span

The Galois-stable span of `Gamma` is defined over `K`.  A zero-dimensional
span is a `K`-point.  A line containing four points of a cubic surface is
contained in the surface and is a `K`-line, hence has `K`-points.

If the span is a plane, primitivity implies that no three conjugates are
collinear: `A4` and `S4` are transitive on the four triples, so one collinear
triple would make every triple collinear and force a line span.  The pencil
of plane conics through the four points consequently has no fixed curve
component.  Over the infinite field `K`, choose a member meeting the plane
cubic properly.  Scheme-theoretic residual intersection to the length-four
quartet has length `6-4=2`, and its effective degree-two cycle again descends
to a `K`-point.

Therefore, on the no-point side,

\[
                         \langle\Gamma\rangle=\mathbf P^3_K. \tag{2.1}
\]

## 3. The canonical cubic-resolvent point

Over `N`, label the four conjugates `P0,P1,P2,P3`.  Neither `A4` nor `S4`
can preserve a contained chord.  Both groups are transitive on the six
pairs.  If one chord `PiPj` lay on the smooth cubic surface, all six edges of
the tetrahedron would lie on it.  At each vertex the three independent edge
directions would then lie in the two-dimensional tangent plane, making the
surface singular.

Let `Qij` be the residual third intersection of the chord `PiPj` with `S`.
The three partitions

```text
01|23,  02|13,  03|12
```

form one orbit.  Let `M/K` be the degree-three field selecting one
partition.  Its Galois closure is `C3` when `H=A4` and `S3` when `H=S4`.
The unordered pair `{Qij,Qkl}` attached to the selected partition is a
degree-two cycle over `M`.  If it is already split, it gives an `M`-point.
Otherwise, join the conjugate pair and take the third intersection; if the
line is contained in `S`, the `M`-line itself has `M`-points.  In every case,

\[
                              \boxed{X(M)\ne\varnothing},
                 \qquad [M:K]=3.                         \tag{3.1}
\]

Under `X(K)=empty`, this point has exact residue degree three.  Moreover
`E cap M=K` by (1.1), so the resolvent point does not enter the generic
splitting field either.

Equation (3.1) is the complete output of pairing descent.  It is not a
ground-field point: every cubic surface already has degree-three linear
sections, and no valid prime-to-three descent theorem applies to this cubic
extension.

## 4. Why the symmetric-power point is not a small `G`-set

The quartic is a `K`-point of the integral etale locus of
`Hilb^4(X)` (equivalently of the corresponding open in `Sym^4(X)`).  By
twisting adjunction it is a degree-four `G`-equivariant rational
correspondence from the generic projective source to the Klein cubic.  The
incidence cover of that correspondence has its own `A4/S4` monodromy.

After pulling the correspondence back from `K` to `E`, (1.1) says that its
incidence cover is still connected of degree four.  Hence the four sheets
are not a four-element set on which `G` acts.  The small-permutation lemma
from the previous packet applies only to a cycle already split by `E`; it
cannot be applied to this connected pullback.

## 5. Exact finite presentation of the surviving gate

The primitive-quartic alternative can be written without any unspecified
geometry.  Let

\[
 f(T)=T^4+b_3T^3+b_2T^2+b_1T+b_0
\]

and, in the quartic algebra `A=K[T]/(f)`, write a projective point as

\[
 A_i(T)=u_{i0}+u_{i1}T+u_{i2}T^2+u_{i3}T^3,
 \qquad 0\le i\le4.
\]

Substitute these five elements into the certified 35-term cubic `Phi` and
reduce modulo `f`:

\[
 \Phi(A_0(T),\ldots,A_4(T))\bmod f
     =R_0+R_1T+R_2T^2+R_3T^3.                           \tag{5.1}
\]

Thus the quartic landing locus is exactly the four equations

\[
                         R_0=R_1=R_2=R_3=0.             \tag{5.2}
\]

There are five projective charts.  On the chart where `A_j` is nonzero,
scale in the field `A` so that `A_j=1`.  Each chart therefore has 20 scalar
parameters: four coefficients of `f` and sixteen coefficients of the other
four projective coordinates, subject to the four equations (5.2).

The no-point branch is the arithmetic open/predicate locus inside (5.2)
defined by all three conditions below.

1. `f` is irreducible and separable.
2. Its cubic resolvent

   \[
   \rho_f(Y)=Y^3-b_2Y^2+(b_3b_1-4b_0)Y
      +(4b_2b_0-b_3^2b_0-b_1^2)                         \tag{5.3}
   \]

   is irreducible.  This is precisely primitivity of the transitive quartic
   action; the discriminant distinguishes `A4` from `S4`.
3. The `4 x 5` coefficient matrix `U=(u_ri)` has rank four.  Indeed the
   matrix of the four conjugate projective points is a Vandermonde matrix
   times `U`, and the Vandermonde determinant is nonzero by separability.
   Hence this rank condition is exactly the full-span condition (2.1).

The verifier reconstructs all four remainders from the 35 certified triples,
checks cubic homogeneity, derives (5.3) from the action on pairings, and
checks the chart and rank ledgers.  This is a finite-type presentation over
`K`, not a finite bound on numerator degrees in the four transcendence
parameters of `K`; it therefore does not itself decide whether a `K`-point
of this locus exists.

## 6. Exact smooth countermodel to universal geometric shortcuts

The following example proves that smoothness alone cannot force a primitive
quartic to be imprimitive, coplanar, or singular.  Put

\[
 f(t)=t^4-t-1,
 \qquad \nu(t)=[1:t:t^2:t^3]\in\mathbf P^3,
\]

and set

\[
\begin{aligned}
 q_1&=x_0x_2-x_1^2,&q_2&=x_0x_3-x_1x_2,&q_3&=x_1x_3-x_2^2,\\
 F_0&=x_0x_1x_3-x_0^2x_1-x_0^3,\\
 F&=F_0+(x_0+x_1+x_2+x_3)q_1\\
  &\quad +(x_0+2x_1+3x_2+5x_3)q_2
          +(2x_0-x_1+4x_2+x_3)q_3.
\end{aligned}
\]

The three quadrics vanish on the twisted cubic and

\[
                            F(\nu(t))=t^4-t-1.
\]

The quartic is irreducible, its resolvent `y^3+4y-1` is irreducible, and its
discriminant is `-283`; hence its Galois group is `S4`.  The four conjugate
points span `P3` by the nonzero Vandermonde determinant.  Exact Jacobian
Groebner calculations in all four affine charts show that `F=0` is a smooth
cubic surface.

This surface is **not** asserted to be pointless and is not the genuine
Klein twist.  The example has one precise role: it refutes any universal
claim that a primitive full-span `S4` quartet is incompatible with a smooth
cubic surface.  A terminal argument must use additional special information
about the genuine generic Klein twist.

## 7. Remaining theorem

The sharp unresolved alternative is still

\[
 X(K)\ne\varnothing
 \quad\text{or}\quad
 \text{the finite gate (5.2)--(5.3) has a primitive full-span solution}.
\]

Voisin's theorem guarantees the second object if the first fails; the
present packet proves that neither generic-torsor simplicity nor the cubic
resolvent collapses it.  A headline proof now needs a genuinely
Klein-specific correspondence from this primitive locus to `X(K)`, or an
exact obstruction eliminating the primitive locus.  No such theorem is
claimed here.

## Replay

From the goal directory:

```text
/opt/homebrew/bin/python3 G_ALL_DEGREE/attacks/primitive_quartic_v2/verify.py
```

Expected terminal markers:

```text
PRIMITIVE_QUARTIC_FORCED_DISJOINTNESS_OK
PRIMITIVE_QUARTIC_CUBIC_RESOLVENT_OK
PRIMITIVE_QUARTIC_FINITE_GATE_OK
PRIMITIVE_QUARTIC_S4_SMOOTH_COUNTERMODEL_OK
PRIMITIVE_QUARTIC_ROUTE_AUDIT_OK
HEADLINE_OPEN
```
