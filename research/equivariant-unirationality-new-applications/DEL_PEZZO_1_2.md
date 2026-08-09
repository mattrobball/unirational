# Degree-1 and degree-2 del Pezzo surfaces

## Question answered

> Are there additional degree-1 or degree-2 actions to which the Problem-F exceptional-path theorem applies essentially verbatim?

**Result of this audit:** no second verbatim application was found. The remaining cases separate into already-decided actions, Condition-(A) failures, fixed-point actions, and actions requiring a genuinely different endpoint/network analysis.

## Degree 2

Write a degree-2 del Pezzo surface as

\[
S=\{w^2=f_4(x,y,z)\}\subset\mathbf P(1,1,1,2).
\]

### Closed cases

1. **Klein action.** The \(\operatorname{PSL}_2(\mathbf F_7)\)-action is closed by Problem F. Condition (A) passes, but a \(V_4\)-controlled exceptional path forces two distinct endpoint values to coincide.
2. **Fermat order-16 actions.** The repository's exact T3 packet identifies 13 action classes with a central nondeck involution whose fixed locus is an elliptic curve plus points and with empty full fixed locus. They are not weakly versal by the central theorem.
3. **Q8 actions in the 2026 cohomological classification.** The actions satisfying Condition (A) have nonzero third Amitsur group and are already non-\(G\)-unirational.

### Remaining degree-2 boundary

The current classification does not expose another action with all of the following simultaneously:

- Condition (A) passes;
- ordinary and higher Amitsur obstructions vanish;
- no central/centralizer theorem already applies;
- two forced, distinct endpoint values lie in fixed curves;
- a single stabilizer fixes the unique exceptional path and supplies the required normal characters.

This is not a proof that Problem F is isolated. It means a second example cannot be obtained by merely substituting a different automorphism group into the existing proof.

## Degree 1

A degree-1 del Pezzo surface has a unique anticanonical base point, and many natural finite automorphism groups fix it. A global \(G\)-fixed point implies weak versality for a complete variety, so these actions cannot be targets for **non-weak-versality**.

They could still fail to be \(G\)-unirational, because weak versality is weaker than very versality. The present central obstruction cannot distinguish these notions once a global fixed point exists.

The Bertini involution fixes a positive-genus curve, but the anticanonical base point supplies the forbidden conclusion of the central argument rather than a contradiction. A new theorem would have to use dominance, dimensions, or incompatible endpoint values, not merely contraction to a fixed point.

## Best degree-1 research direction

Choose a \(G\)-minimal degree-1 action with:

- a unique global fixed anticanonical base point;
- a Bertini fixed curve of genus 4;
- at least two stabilizer-fixed tangent directions at the base point;
- no \(G\)-stable rational pencil compatible with those directions.

Resolve a hypothetical dominant linear-source map and ask whether all positive-dimensional source eigenspaces are forced into the fixed point, contradicting dominance even though weak versality remains possible. This would be a **very-versality obstruction**, distinct from the theorem proved here.

## Conclusion

The highest-value new surface theorem did not come from another del Pezzo action. It came from the other branch of the surface \(G\)-MMP: the exceptional conic bundles in `THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md`.
