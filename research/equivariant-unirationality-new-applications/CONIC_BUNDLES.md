# Conic bundles

## 1. Surface result

The central result is the infinite family in `THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md`.

For every odd \(g\ge3\), the rational exceptional conic bundle

\[
S_g\to\mathbf P^1
\]

with \(2g+2\) singular fibers carries

\[
G_g=D_{2g}\times C_2
\]

such that:

\[
S_g^A\neq\varnothing\quad\text{for every abelian }A\le G_g,
\]

but \(S_g\) is not weakly \(G_g\)-versal. Thus Condition (A) is not sufficient on the conic-bundle branch of the rational-surface \(G\)-MMP.

This is the conceptual answer to the principal surface question: Problem F was not isolated. Positive-genus fixed curves produced by the singular-fiber data give a systematic family of exceptional-path/central-obstruction phenomena.

## 2. General conic-bundle criterion

Let \(\pi:S\to\mathbf P^1\) be a smooth rational conic-bundle surface and let \(j\in Z(G)\) be a fiberwise involution. Suppose:

1. the fixed locus \(S^j\) is a smooth multisection \(C\) of positive genus, possibly together with isolated points;
2. every positive-dimensional component of \(S^j\) has positive genus;
3. \(S^G=\varnothing\).

Then the repository central obstruction proves that \(S\) is not weakly \(G\)-versal.

In a standard equation

\[
y^2-a(t)z^2=0
\]

on the generic fiber, the fixed multisection is governed by the squarefree divisor of \(a(t)\). Its genus is therefore read directly from the number of degenerate fibers. The odd exceptional family is the symmetric case in which the residual dihedral action also makes Condition (A) transparent.

## 3. Threefold conic bundles

Let \(\pi:X\to S\) be a conic-bundle threefold with a central fiber involution. Its fixed locus is naturally a double cover or branch surface over the base, closely related to the discriminant cover.

There are two regimes.

### Non-uniruled fixed surface

If the fixed surface is non-uniruled, the residual-RCC theorem can apply after classifying residual-stable rational curves. A K3, abelian, or general-type discriminant cover is ideal.

### Rational fixed surface

For the rational Fano family No. 2.18, the covering involution fixes the `(2,2)` branch surface, a degree-2 del Pezzo surface. The entire fixed surface is residual-stable and RCC, so neither the original central theorem nor its residual-RCC refinement contracts the survivor.

The missing input is a **three-dimensional exceptional-network theorem**: source eigensurfaces and their exceptional divisors must map into a connected network of residual-stable curves and surfaces, with normal characters controlling passage between them.

## 4. Special No. 2.18 targets

### Fermat discriminant

Abe's explicit model has discriminant

\[
x^4+y^4+z^4=0
\]

and total automorphism group of order \(192\). It is the best next target because:

- the total space is rational;
- all automorphisms are explicit;
- involution and centralizer enumeration is finite;
- the branch del Pezzo surface has a completely explicit curve configuration;
- current intermediate-Jacobian results concern linearizability, not \(G\)-unirationality.

### Klein discriminant

The analogous special model with Klein quartic discriminant has a large simple-group symmetry on the discriminant. Its ranking is lower only because the exact liftable subgroup and lift index need to be frozen before fixed-locus work begins.

## 5. Finite work order for the Fermat case

1. Extract the order-192 group generators from Abe's model.
2. Enumerate involution classes and centralizers.
3. Compute \(X^\sigma\) and \(X^{C_G(\sigma)}\) for one representative per class.
4. On the deck-fixed del Pezzo surface, enumerate residual-stable rational curves of anticanonical degree at most 2.
5. Compute normal characters at their intersections with nondeck fixed curves.
6. Formulate and prove the connected exceptional-fiber propagation lemma.

No broad CAS search is needed; all six steps are finite and representation-forced.
