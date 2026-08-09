# Exceptional propagation in dimension three

## 1. What proper birational geometry gives

Let

\[
p:Z\to X
\]

be the smooth resolved graph over the normal threefold `X`. Since `p` is proper birational and `X` is normal,

\[
p_*O_Z=O_X.
\]

By Stein factorization every fiber `p^{-1}(x)` is connected.

For a tower of smooth blowups, the fiber is assembled from projective bundles and their transforms. In the examples relevant here the total fiber is rationally chain connected, but neither connectedness nor RCC is inherited by a subgroup-fixed locus.

At the first `V_4` blowup,

\[
D=P^2,
\qquad
D^{V_4}=\{p_z,p_s,p_r\},
\]

and, for an involution `z`,

\[
D^z=p_z\sqcup \ell_{sr}.
\]

Thus the failure occurs before any complicated higher blowup.

## 2. Pointwise-fixed rational components

Let `h` be a nonidentity group element and let `R=P^1` be a rational curve on which `h` acts pointwise. For a `G`-morphism `q:Z->X`,

\[
q(R)\subset X^h.
\]

If `q(R)` lies in an elliptic component of `X^h`, then `q|_R` is constant because an elliptic curve contains no rational curve. If it lies in the rational component `L_h`, it may be nonconstant.

This is the exact going-down statement available for individual exceptional curves. The target decomposition

\[
X^h=E_h\sqcup L_h
\]

is therefore load-bearing: pointwise fixedness does not imply constancy without first forcing the elliptic target component.

## 3. Valid propagation lemma

Let `K` be a connected reduced curve in a resolved fiber, written as a union of irreducible rational components. Suppose:

1. every component of `K` is pointwise fixed by the same nonidentity element `h`;
2. every component maps into `E_h`, not `L_h`;
3. the component-incidence graph of `K` is connected.

Then `q|_K` is constant.

**Proof.** Every irreducible component maps constantly to `E_h`. Two components meeting at a point have the same constant value because `q` is a morphism. Connectedness of the incidence graph propagates equality through all components. `QED`.

A slightly more general cover version allows different elements `h_i`: if each component is pointwise fixed by an element whose relevant target fixed component contains no rational curve, and consecutive components have a common point, the same argument propagates constants.

This is the precise higher-dimensional remnant of the Problem-F exceptional-path theorem.

## 4. Why the hypotheses fail at type I and type II

At a `V_4` point, the first exceptional divisor contains the line

\[
\ell_{sr}=P(\chi_s\oplus\chi_r),
\]

which is pointwise `z`-fixed. Its target is allowed to be the rational line `L_z`, so hypothesis 2 fails.

Moreover, `D^z` is disconnected, so a fixed-locus path from the `z` character direction to the other two directions is absent; hypothesis 3 may fail even though the full fiber is connected.

Finally, the invariant conic

\[
x_z^2+x_s^2+x_r^2=0
\]

has faithful `V_4` action. No nonidentity element fixes it pointwise, so hypothesis 1 fails.

These are three independent failures of the surface mechanism.

## 5. Dual complexes are insufficient by themselves

The SNC exceptional divisor has a dual complex, and the total fiber has a connected incidence complex. Neither object remembers:

- the fixed locus of a chosen subgroup inside an exceptional surface;
- whether a rational connector maps to `E_h` or `L_h`;
- whether a horizontal curve has faithful stabilizer action;
- the degree of the actual map on that curve;
- the base multiplicity defining the carrier.

A path in the divisor dual complex can therefore pass through surfaces while the relevant fixed curve is disconnected, or can use a rational line-valued bypass.

The correct object would have to be a **carrier incidence complex** whose vertices are essential horizontal fixed curves/valuations and whose higher cells record actual intersections inside normalized Rees fibers. Such an object is not constructed by the current formal transition machinery.

## 6. Arbitrary centers and fixed-genus creation

The fixed-locus blowup formula shows that if a later smooth center has an `H`-fixed component `S` of positive genus, a new fixed component `P(N_chi)->S` carries the same nonrational base. Hence the claim that all fixed strata on all models are RCC is false.

This does not destroy the componentwise going-down argument; it means only that one must apply it to the actual component and its MRC quotient rather than assume every component is rational.

For a positive-genus fixed component mapping to `E_h`, a nonconstant map can exist. Arbitrary refinement can therefore manufacture component maps not present on a minimal carrier model. This is another reason to classify essential carriers rather than all components.

## 7. Refinement-invariant propagation statement

The following formulation is invariant under further blowup:

> Let `Gamma` be the graph of essential one-dimensional horizontal valuations in the normalized principalization fiber over a marked stratum. Join two valuations when their centers meet on a common model. If every vertex is represented by a rational curve pointwise fixed by some `h`, every corresponding target component is nonrational, and `Gamma` is connected, then all endpoint specializations agree.

The proof is obtained on a common dominating model from the valid propagation lemma. The missing issue is not the proof; it is establishing the hypotheses for the actual Klein-cubic base ideal.

## 8. Required ambient input

A useful exceptional-propagation theorem for Problem E must prove all of:

1. the essential carrier incidence complex over every type-I and type-II point is connected in the needed directions;
2. every rational connector has a nontrivial pointwise stabilizer kernel, or faithful-action connectors are excluded;
3. every pointwise-`h` connector lands in `E_h`, not `L_h`;
4. the conclusions are compatible under the residual `C_3` and across all 55 configurations.

The first exceptional `P^2` gives counterexamples to each statement as a theorem of representation theory alone. Any proof must use the normalized Rees algebra or equations of the actual ambient covariant.

## 9. Conclusion

The Problem-F path theorem has a valid conditional analogue, but its hypotheses are not automatic in dimension three. Connected total fibers, RCC, and divisor dual complexes do not provide the required propagation. The unresolved task is to prove an ambient carrier theorem that removes the explicit rational bypasses.
