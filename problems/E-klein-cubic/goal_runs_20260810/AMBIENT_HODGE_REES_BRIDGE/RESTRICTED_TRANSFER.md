# Transfer to the restricted normalized graph

## 1. The two graphs

The ambient normalized graph is

\[
Y=\widehat P
=\operatorname{Proj}_{\mathbf P^4}\overline{\mathcal R(I_A)}.
\]

The normalized graph of the primitive restricted ideal is

\[
\Gamma
=\operatorname{Proj}_{X}\overline{\mathcal R(J)}.
\]

Let

\[
i:X\hookrightarrow\mathbf P^4.
\]

The existing ambient-Rees comparison theorem identifies `Gamma` with the
normalization of the component dominating `X` in the relevant inverse image of
the restricted graph.  It does not identify all components of
`Y×_{P4}X` with `Gamma`, and it does not identify ambient and restricted Rees
valuations.

## 2. What survives without any support theorem

Write

\[
\pi_\Gamma,q_\Gamma:\Gamma\to X.
\]

The restricted selfmap is dominant and generically finite.  Resolving `Gamma`
and applying the usual trace identity gives

\[
q_\Gamma^*:H^3(X,\mathbf Q)
\hookrightarrow H^3(\Gamma,\mathbf Q).
\tag{2.1}
\]

As in the ambient case, there is therefore a canonical pure lift

\[
\alpha_\Gamma:
V\hookrightarrow IH^3(\Gamma,\mathbf Q)(1).
\tag{2.2}
\]

Thus the actual landing Hodge structure survives on the restricted normalized
graph as a whole.  This is not yet an exceptional-carrier theorem.

On any common smooth resolution, restriction of the ambient class is the
actual restricted pullback.  In particular, the actual class does not vanish
when one passes from the ambient graph to the dominant restricted component.
What is undecided is whether the *proper ambient strict-support component* of
that class survives as a proper strict support on `Gamma`.

## 3. Why the ambient proof does not repeat over \(X\)

Apply the decomposition theorem to

\[
\pi_\Gamma:\Gamma\to X.
\]

Because `pi_Gamma` is birational and `X` is smooth, the full-support term is

\[
IC_X^H=\mathbf Q_X^H[3].
\]

Its degree-three hypercohomology is

\[
H^0(X,\mathbf Q_X[3])=H^3(X),
\]

which already contains the full target Hodge structure `V`.  Unlike the
ambient base `P4`, there is no vanishing theorem analogous to
`H^3(P4)=0` that forces (2.2) into a proper support.

In the degree-one branch the primitive restricted graph may be `X` itself; then
(2.2) is entirely the full-support summand.  The existence of such an ambient
retraction in the Klein problem is open, but the example shows that the
restricted decomposition theorem alone cannot force an exceptional carrier.

## 4. Proper base change stops before normalization

Let

\[
Y_X=Y\times_{\mathbf P^4}X,
\qquad
\widetilde i:Y_X\to Y,
\qquad
p_X:Y_X\to X.
\]

Proper base change gives a canonical identity

\[
i^*Rp_*IC_Y^H
\simeq
Rp_{X*}\widetilde i^*IC_Y^H.
\tag{4.1}
\]

This does not produce the desired bridge for three separate reasons.

### 4.1 Restriction of an intersection complex

In general

\[
\widetilde i^*IC_Y^H
\not\simeq IC_{Y_X}^H[-1].
\]

The difference is measured by nearby and vanishing cycles.  A clean equality
requires non-characteristic or local acyclicity hypotheses.  The ambient base
ideal is unknown, so these hypotheses are not available.

### 4.2 Component selection

The raw fiber product can contain vertical components.  The restricted graph
uses only the component dominating `X`.  A selected ambient support may meet a
vertical component but miss the dominant component.

### 4.3 Normalization

After selecting the dominant component one still passes to its normalization.
Finite normalization preserves dimensions but may separate branches and alter
local-system and intersection-complex data.  The joint-residue field inclusion
controls centers and dimensions; it does not control the map on the selected
Hodge-module summand.

## 5. A small unconditional geometric statement

Let `S` be a proper ambient strict support.

- If `dim S≥1`, then `S∩X` is nonempty because `X` is an ample hypersurface in
  `P4`.
- If `dim S=2`, the expected intersection is a curve unless `S⊂X`.
- If `dim S=1`, the expected intersection is finite unless `S⊂X`.
- A point support may be disjoint from `X`.

This proves set-theoretic contact for positive-dimensional supports.  It does
not prove nonvanishing of the `V`-projection after restriction.  For example,
a global `H^1` class on a support curve may restrict trivially to a finite
intersection, with the restricted target class appearing instead in a
full-support or vanishing-cycle block.

## 6. Resolution-level restriction

Choose a smooth blowup resolution `Z→P4` in which the strict transform of the
source cubic is resolved simultaneously.  The restriction of `g^*V` to the
resolved dominant transform is injective.  Consequently, in the blowup
formula for this particular resolution, the sum of the center contributions
whose restrictions are nonzero receives `V`.

This gives a useful but nonintrinsic statement:

```text
some actual center contribution survives on a simultaneous resolution.
```

It does not identify a center on `Y` or `Gamma`, and weak factorization can move
that surviving contribution between centers.  The ambient strict-support
package is the resolution-independent replacement; transferring that package
requires the next theorem.

## 7. Exact conditional transfer theorem

Let `(S,j_0,M_{S,j_0})` be an ambient strict-support block receiving `V`.  The
ambient-to-restricted bridge holds for this block if the following three
conditions are satisfied.

### CT1 — dominant-component incidence

A component of the inverse image of `K_S` meets the component of `Y_X`
dominating `X`, and its image remains positive-dimensional or carries the
relevant fiber cohomology after normalization to `Gamma`.

### CT2 — clean Hodge-module restriction

On a dense open of the relevant intersection, the inclusion `i` is
non-characteristic for the selected strict-support Hodge module.  The
restriction has no `V`-isotypic vanishing-cycle kernel.

### CT3 — nonzero comparison after normalization

The composite from the selected ambient perverse graded piece through (4.1),
dominant-component projection, and finite normalization is nonzero on the
`V`-isotypic image.

Under CT1--CT3, a strict-support block for `pi_Gamma` receives a nonzero map
from `Res_H V`.  If that block satisfies the finite-monodromy Tate hypothesis,
there is a finite-cover carrier `C` with

\[
\operatorname{Hom}_{\mathrm{HS},H}
\left(
\operatorname{Res}_H V,H^1(C,\mathbf Q)
\right)\ne0.
\]

## 8. Why the joint-residue theorem is insufficient

For a divisorial valuation `v`, the inclusions

\[
L_v\subset\mathbf C(K_v)\subset\kappa(v)
\]

and the equality `dim K_v=trdeg L_v` determine whether a divisor survives as a
Rees divisor and what the function field of its center contains.  They do not
determine:

- the monodromy local system in a decomposition-theorem support;
- the pullback map on intersection cohomology;
- vanishing cycles along `X`;
- which component of the raw inverse image receives a cohomology class;
- the map after normalization.

In particular, a field inclusion does not force an `E_{-11}` factor to descend
to the Albanese of the center.

## 9. Arrangement localization and free support

No theorem in the repository proves that every ambient strict support meets the
55 involution/`V4` arrangement.  A support with trivial generic stabilizer is
legal.  Its `G`-orbit contribution is induced from the trivial subgroup and is
representation-theoretically capable of containing `V`.

The free-support escape is therefore:

1. a free orbit of ambient supports receives the actual `V`-projection;
2. its intersection with `X` avoids the forced fixed arrangement or meets it
   only in Hodge-inessential points;
3. after restriction, the target class is absorbed by full support or by
   vanishing-cycle data rather than by a fixed carrier.

Excluding this requires a new geometric theorem about the genuine landing
ideal, not a subgroup calculation.

## 10. Exact remaining implication

The smallest unresolved statement is

\[
\boxed{
\begin{minipage}{0.86\textwidth}
For at least one ambient strict-support orbit receiving the actual image of
`V`, the CT1--CT3 comparison to the normalized dominant restricted component
is nonzero.
\end{minipage}}
\tag{RT}
\]

No current decomposition-theorem, Rees-valuation, fixed-locus, or motivic
argument proves (RT).  No explicit Klein-compatible counterexample to (RT) is
known either.

The correct exit is therefore

```text
AMBIENT-HODGE-SUPPORT-PROVED
RESTRICTED-TRANSFER-UNDECIDED
```
