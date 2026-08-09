# Conic bundles

## 1. Surface theorem

The central result is the infinite family in `THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md`.

For every odd `g≥3`, the rational exceptional conic bundle

\[
S_g\to\mathbf P^1
\]

with `2g+2` singular fibers carries

\[
G_g=D_{2g}\times C_2,
\qquad |D_{2g}|=2g,
\]

such that

\[
S_g^A\neq\varnothing
\quad\text{for every abelian }A\le G_g,
\]

but `S_g` is not weakly `G_g`-versal. Thus Condition (A) is not sufficient on the conic-bundle branch of the rational-surface equivariant MMP.

This is the conceptual answer to the main surface question. Problem F was not isolated: positive-genus fixed curves arising from the singular-fiber data give an infinite, equation-level family. The proof itself is a central fixed-locus proof rather than an exceptional-path proof; the path machinery is needed only when rational fixed components intervene.

## 2. Exact family

Let

\[
Y_g=
\{T_0T_1(T_0^{2g}+T_1^{2g})+T_2T_3=0\}
\subset\mathbf P(1,1,g+1,g+1),
\]

and let `S_g` be its minimal resolution. The two singular points resolve to disjoint sections, so `S_g` is rational.

For a primitive `2g`-th root `ξ`, define

\[
r(T_0,T_1)=(\xi T_0,\xi^{-1}T_1),
\qquad
s(T_0,T_1)=(T_1,T_0),
\qquad
j(T_2,T_3)=(T_3,T_2).
\]

Because `g` is odd, `g+1` is even; in the weighted projective quotient `r^g` is the scalar `-1`, so `r` has order `g`. The fixed curve of `j` is

\[
C_g:\ U^2=-T_0T_1(T_0^{2g}+T_1^{2g}),
\]

a smooth hyperelliptic curve of genus `g`. The dihedral group has no global fixed point on the base, hence `C_g^{D_{2g}}=∅`.

Condition (A) is visible without enumeration:

- every rotation subgroup fixes the two ramification points over `0` and `∞`;
- every reflection fixes points over its two base fixed points;
- the central involution `j` fixes all of `C_g`.

## 3. General surface criterion

Let `π:S→P1` be a smooth rational conic-bundle surface and let `j∈Z(G)` be a fiberwise involution. Suppose:

1. every positive-dimensional component of `S^j` has positive genus;
2. `S^G=∅`.

Then the repository central obstruction proves that `S` is not weakly `G`-versal.

In a standard generic-fiber equation

\[
y^2-a(t)z^2=0,
\]

the fixed multisection is governed by the squarefree divisor of `a(t)`. Its genus can often be read directly from the number and orbit structure of the degenerate fibers. The odd exceptional family is the symmetric case in which the residual dihedral action also makes Condition (A) transparent.

## 4. Threefold conic bundles

Let `π:X→S` be a conic-bundle threefold with a central fiber involution. Its fixed locus is naturally a finite cover or branch surface over the base, closely related to the discriminant cover.

### Non-uniruled fixed surface

If the fixed surface is non-uniruled, the residual-RCC theorem applies after classifying residual-stable rational curves. A K3, abelian, or general-type discriminant cover is ideal.

### Rational fixed surface

For rational Mori–Mukai family No. 2.18, the covering involution fixes the `(2,2)` branch surface, a degree-2 del Pezzo surface. The entire fixed surface is residual-stable and RCC, so neither the original central theorem nor its residual-RCC refinement contracts the source survivor.

The missing input is a **three-dimensional exceptional-network theorem**: source eigensurfaces and exceptional divisors must map into a connected network of residual-stable curves and surfaces, with normal characters controlling passage between them.

## 5. Special No. 2.18 targets

### Fermat discriminant

Abe's explicit model has

\[
Q_1=ix^2+y^2,
\qquad Q_2=z^2,
\qquad Q_3=ix^2-y^2,
\]

and discriminant

\[
x^4+y^4+z^4=0.
\]

The total automorphism group has order 192. Abe's explicit subgroup

\[
G_1=\langle\alpha,\tau\rangle\simeq C_4\times C_2^{\rm deck}
\]

is not projectively linearizable, but it has a fixed point and is therefore weakly versal. Its possible failure of `G_1`-unirationality is a dominance problem, not an application of the fixed-point obstruction.

The higher-value target is instead the full order-192 action or a class-named nonabelian subgroup that:

```text
passes Condition (A),
has empty full-group fixed locus,
and contains a useful nondeck involution centralizer.
```

These gates have not yet been audited.

### Klein discriminant

The analogous special model with Klein quartic discriminant has large simple symmetry on the discriminant. Its ranking is lower because the exact liftable subgroup and lift index must first be frozen.

## 6. Finite work order for the Fermat case

1. Extract the order-192 group generators from Abe's model.
2. Enumerate subgroup classes with Condition (A), prioritizing nonabelian groups with empty global fixed locus.
3. Enumerate involution classes and centralizers inside the surviving groups.
4. Compute `X^σ` and `X^{C_G(σ)}`.
5. On the deck-fixed del Pezzo surface, enumerate residual-stable rational curves of anticanonical degree at most 2.
6. Compute normal characters at their intersections with nondeck fixed curves.
7. Formulate and prove the connected exceptional-fiber propagation lemma.

No broad CAS search is needed; each step is finite and theorem-forced.

## 7. Answers supplied by this packet

- **Surface conic bundles:** yes, Condition (A) can pass while weak versality fails; the odd family proves it.
- **Threefold central fiber involutions:** they produce the right fixed cover, but usefulness depends on its MRC geometry.
- **Special rational Fano conic bundles:** the Fermat No. 2.18 member is the best current three-dimensional network laboratory, not yet a theorem.