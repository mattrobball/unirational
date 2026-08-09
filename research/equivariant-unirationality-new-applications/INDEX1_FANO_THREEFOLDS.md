# Index-one Fano threefolds

## 1. Current benchmark

The repository's genus-8 threefold \(V_{14}\) is the model case. For
\(G=\operatorname{PSL}_2(\mathbf F_{11})\) and an involution \(\sigma\),

\[
C_G(\sigma)=D_{12},
\]

\[
V_{14}^\sigma=C_6\sqcup\{p_1,p_2\},
\qquad g(C_6)=1,
\]

and

\[
V_{14}^{D_{12}}=\varnothing.
\]

The centralizer obstruction therefore proves that \(V_{14}\) is not weakly \(G\)-versal. This remains the only index-one application in the repository with every fixed-scheme input sealed.

## 2. Best second target: the Mukai–Umemura \(V_{22}\)

Let \(X_{MU}\) be the Mukai–Umemura prime Fano threefold of genus \(12\), index \(1\), and degree \(22\). It is a compactification of \(\mathbf A^3\), hence rational, and

\[
\operatorname{Aut}(X_{MU})\simeq\operatorname{PGL}_2.
\]

Take the icosahedral subgroup

\[
G=A_5\subset\operatorname{PGL}_2.
\]

This gives an exact intrinsic action. Choose an involution \(\sigma\in A_5\). Then

\[
C_G(\sigma)=V_4.
\]

This is the closest available analogue of the \(V_{14}\) centralizer configuration.

### Finite fixed-locus target

The Mukai–Umemura model is the zero locus of the net of \(\operatorname{SL}_2\)-invariant skew forms on \(\operatorname{Gr}(3,7)\). Restricting the 7-dimensional representation to \(V_4\) makes the following calculation finite:

1. decompose the ambient representation into \(\sigma\)-eigenspaces and \(V_4\)-characters;
2. intersect the corresponding fixed Grassmannians with the three invariant skew-form equations;
3. normalize each positive-dimensional component;
4. compute its genus and residual \(C_G(\sigma)/\langle\sigma\rangle\simeq C_2\) action;
5. compute \(X_{MU}^{V_4}\).

If the outcome is

\[
X_{MU}^\sigma=C\sqcup\{\text{points}\},
\qquad g(C)>0,
\qquad X_{MU}^{V_4}=\varnothing,
\]

the \(V_{14}\) proof applies verbatim. If rational components occur, the generalized residual-RCC theorem reduces the problem to classifying the \(V_4\)-stable rational curves among them.

### Literature boundary

The literature gives the homogeneous/Grassmannian model, rationality, automorphism group, and extensive curve geometry of \(X_{MU}\). This audit found no published table of the involution and \(V_4\) fixed schemes and no theorem deciding \(A_5\)-unirationality or weak versality of this action. The status is therefore

```text
LITERATURE-STATUS-UNCERTAIN
```

rather than `OPEN-CONFIRMED`: the finite fixed-locus calculation should be completed before claiming a new open case.

## 3. Why most other prime index-one families rank lower

The systematic search was filtered by three requirements: the underlying variety should be rational or at least known unirational, a substantial finite action should be explicit, and one involution should have geometrically rigid fixed locus.

### Genera 2 and 3

Double-cover models provide central involutions, but the fixed branch surface is often K3. This is promising only when the residual group preserves no rational curve. The smooth quartic double-solid theorem in this packet is the successful index-2 version. Prime index-1 double covers frequently have ordinary rationality or unirationality questions of their own, lowering their immediate value.

### Genera 4 through 10

Special highly symmetric complete intersections and linear sections exist, but the search found no second action for which both the involution fixed curve and the deeper centralizer locus are already computed. Generic members have finite automorphism groups too small to make the centralizer criterion effective.

### Genus 12

The Mukai–Umemura member is exceptional: it is rational, has positive-dimensional automorphism group, and contains every icosahedral finite subgroup through the natural \(\operatorname{PGL}_2\)-action. It is therefore the clear first finite computation.

## 4. Other index-one directions

### Special Gushel–Mukai and Verra threefolds

Their double-cover involutions fix K3 or related surfaces. Current work describes period maps and derived categories, but the residual finite-group actions on rational curves of the fixed surfaces are not yet organized for versality. They become attractive only after a specific large finite subgroup and a silent cohomological obstruction are identified.

### Del Pezzo fibrations

A central involution may fix a positive-genus multisection. This is formally closer to the conic-bundle surface theorem than to \(V_{14}\). No explicit rational index-one del Pezzo fibration with all residual fixed data tabulated was found in this pass.

## 5. Answer to the \(V_{14}\)-phenomenon question

> Does the \(V_{14}\) centralizer phenomenon occur on another index-one Fano threefold?

No second **verified** occurrence was found. The Mukai–Umemura pair

\[
(X_{MU},A_5),
\qquad C_{A_5}(\sigma)=V_4,
\]

is the strongest concrete candidate. Its status hinges on one finite fixed-locus calculation, not on a new all-degree covariant search.

## 6. Work order

```text
MU-A5-FIXED-LOCUS-AUDIT
```

1. Freeze the standard \(\operatorname{SL}_2\)-equivariant Grassmannian model.
2. Write matrices for one icosahedral \(A_5\subset\operatorname{PGL}_2\).
3. Compute one involution fixed scheme exactly over its splitting field.
4. Compute the simultaneous \(V_4\)-fixed scheme.
5. Apply the centralizer or residual-RCC theorem.

This is a theorem-forced finite computation and is the recommended next index-one experiment.
