# Exact attack ledger after the generic-cubic reduction

## Requirement-level verdict

The all-degree problem is still equivalent to the single binary question

\[
V(\Phi)(K_{\rm proj})\ne\varnothing
\quad\text{or}\quad
V(\Phi)(K_{\rm proj})=\varnothing.
\]

No attack in this ledger decides that question.  Each one instead proves an
exact theorem that removes a broad shortcut and leaves a smaller named gate.

| attack | exact result | implication | surviving gate |
|---|---|---|---|
| `constructive_point` | all ten two-frame cubics are absolutely irreducible; the constant normalized-coordinate matrix has rank 35 | a point must have at least three nonzero frame coordinates with nonconstant ratios | find an exact point on a ternary or larger subcubic, then clear and verify it |
| `ternary_kproj_v2` | the exact `x,C,D` plane has no `K_proj,C`-point; 110 common-pencil and 10 fixed common-plane constant-secondary ansatze are empty | one genuine ternary plane is closed, but the finite ansatze impose no rational-function height bound | decide another unrestricted ternary plane or the four-/five-frame cubic |
| `local_infinite_descent` | complete `V4` symbolic recurrence; gcd-one order-three class in the projective-character model; all odd orders carry the corresponding unsaturated local state | the actual character correction has a common line factor, and scalar jet killing refutes only unsaturated point constraints | decide primitive saturation and the global nonlinear plus-plane overlap |
| `valuation_obstruction` | every standard successive complete-DVR field of a saturated geometric length-three/four Parshin chain is soluble | no integral tropical or completion-pointlessness certificate exists for those successive fields | pass to the exact henselian residue analysis in `low_rank_valuations_v2` |
| `low_rank_valuations_v2` | every Krull valuation trivial on `C`, of arbitrary rank and with `C1` residue, is soluble over its henselization | any negative site in this valuation convention is unramified, has non-`C1` residue, and has exceptional decomposition group | analyze the remaining non-`C1` residues, especially divisorial trdeg 3 and saturated rank-two trdeg 2 |
| `zero_cycle_containment` | the genuine twist has a point or a primitive `A4/S4` quartic point | the no-point branch is reduced to one integral primitive quartic | decide the actual primitive-quartic locus using Klein-specific geometry or arithmetic |
| `primitive_quartic_v2` | `E cap N=K` is forced; the quartic stays primitive over `E`; its three pairings give a cubic-resolvent point; its full-span locus has four explicit remainder equations | `E`-containment is impossible in the no-point branch and cubic-resolvent descent stops in degree three | construct a Klein-specific descent from the primitive locus or obstruct that locus exactly |

## Constructive support exclusion

The five certified frame columns are `x,C,D,E,K`.  For every pair `U,V`, the
binary cubic `F(U+tV)` is absolutely irreducible in
`C[x0,...,x4,t]`.  It therefore has no root in `C(W)`, and hence none in the
subfield `K_proj`.  Normalizing the frame only rescales `t` by a nonzero
invariant.  Separately, simultaneous expansion in the normalized Hironaka
basis gives a rational 98-by-35 matrix of rank 35, so no constant
projective frame vector lands.

This excludes support size at most two and constant frame ratios, not a
general rational point.

## Ternary support closure

The ten normalized coefficients on the `x,C,D` coordinate plane are
literally identical to the sealed general-slice model over the same
`K_proj,C`.  Proper specialization at `f6=0`, with horizontal-degree image
`3Z`, proves that this plane cubic has no `K_proj,C`-point.  Hence it also has
no quadratic closed point, by secant descent.

Separately, exact coefficient expansion and good reduction at `p=101`
exclude 110 projective `P5` ansatze in which three active frame coordinates
share `Span_C{beta_0,beta_s}`, and ten projective `P8` ansatze sharing
`Span_C{beta_0,beta_1,beta_2}`.  Empty geometric special fibres imply empty
characteristic-zero projective ansatz loci by properness.  These 120 systems
are finite constant-secondary-support families; they neither bound
rational-function height nor decide any other unrestricted ternary plane.

## Local stopping theorem

For the three axes at a generic `V4` line, put

\[
J_m=(y,z)^m\cap(x,z)^m\cap(x,y)^m,
\qquad h=xyz,
\qquad I=J_1.
\]

The exact identities

\[
J_m=hJ_{m-2}+((xy)^m,(xz)^m,(yz)^m)
=\sum_{j=0}^{\lfloor m/2\rfloor}h^jI^{m-2j}
\]

hold in every order, and multiplication by `h` injects
`J_(m-2)/J_m` into `J_m/J_(m+2)`.  Before the inverse-character correction,
the characteristic-zero trisection tuple is gcd-one in the abstract
projective-character model.  The correction needed for an actual `W`-valued
class multiplies every component by the same line factor, so the corrected
tuple is not literally primitive.  Powers of `h` still propagate the
associated unsaturated landing states to every odd order.  Common scalar
factors can annihilate prescribed finite point jets without killing the
generic line state; this rules out only an unsaturated point-constraint
argument.  A saturated primitive point-link obstruction remains possible.
The residual-`S3` degree-three marked triples show that elliptic trace
divisibility by three is sharp.

The plane interpolation producing a global linear symbolic section is not
known to preserve the nonlinear cubic identity.  The local states are not
global covariants.

## Valuation stopping theorem

Every Klein twist has an effective degree-55 cycle from the contained
`D12`-line orbit.  After any scalar extension, some closed-point degree in
that cycle is prime to three.  Coray's complete-DVR theorem promotes such a
point to a rational point whenever the residue field has the cubic
Cassels--Swinnerton-Dyer property.  Iterating from terminal residue fields of
transcendence degree at most one over `C` proves points over the standard
successive complete-DVR fields attached to saturated geometric Parshin chains
of length three or four on the four-dimensional field `K_proj`.

The companion `low_rank_valuations_v2` theorem treats henselizations directly.
For every Krull valuation of `K_proj` trivial on `C`, of arbitrary rank and
with `C1` residue, nontrivial inertia gives a point by the exact
`PSL_2(F_11)` centralizer geometry, while trivial inertia gives a finite-etale
model whose five-variable residue cubic has a point by `5>3`; smooth Hensel
lifting finishes.  Thus any negative valuation in this convention is
unramified with non-`C1` residue and exceptional decomposition group `G`, one
of the two maximal `A5` classes, or maximal `11:5`.

This is local solubility only.  It gives no global point.  Unramified
non-`C1` residues remain outside the theorem; the geometric divisorial
trdeg-three and saturated rank-two trdeg-two rows are central examples but
not an exhaustive valuation census.

## Residual splitting and quartic boundary

The effective degree-55 `D12` line orbit meets a general smooth cubic-surface
section in a degree-55 point.  Voisin's characteristic-zero theorem therefore
gives a point on the genuine generic twist or an effective degree-four point.
In the no-point branch the latter is one integral quartic: degree-one and
degree-two components already descend to a point.  Repeating quadratic
secant descent excludes an intermediate quadratic field, so its Galois
closure is `A4` or `S4`.

Let `E/K` be the connected generic projective `G`-extension.  If a finite etale
cycle of degree at most four is split by `E`, its geometric points carry a
`G -> S_4` action.  Simplicity and `660>|S_4|` force that action to be
trivial, so the cycle has a `K`-point.  In the actual primitive-quartic branch,
however, if `N/K` is the `A4` or `S4` Galois closure, then

\[
E\cap N=K:
\]

the intersection is a Galois quotient of both the simple group of order 660
and a group of order at most 24.  Thus the quartic necessarily remains a
degree-four field over `E`; containment is impossible rather than merely
unproved.

The three partitions of the four conjugates produce a canonical cubic
resolvent field `M/K` and an exact point `X(M)`.  This is degree three, not a
ground-field point.  The surviving quartic branch is recorded on five charts
by substituting a general quartic-algebra point into the 35-term `Phi` and
setting its four remainders to zero, together with irreducibility,
irreducible-resolvent, and rank-four conditions.  A verified smooth `S4`
countermodel shows that smooth cubic-surface geometry alone cannot eliminate
such a primitive full-span quartet.

Balestrieri's Theorem 3.6 gives a new prime-to-three degree at most 107 from
degree 55, but its numerical conclusion permits the strictly growing
iteration `n -> 2n-3`.  It is not an unconditional descent to degree two.

## Replay

All seven exact attack packets are invoked by

```text
/opt/homebrew/bin/python3 G_ALL_DEGREE/verify_all.py
```

The aggregate marker remains

```text
SCOPE G-STRUCTURAL-UNDECIDED; HEADLINE SUPPORT REMAINS OPEN
```
