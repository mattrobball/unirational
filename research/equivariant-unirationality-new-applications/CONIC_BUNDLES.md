# Conic bundles

## A. Surface theorem: odd-dihedral de Jonquières bundles

The family and proof are in `THEOREM_DIHEDRAL_DEJONQUIERES.md`. It gives a
complete positive answer to the principal surface question:

> Condition (A) is not sufficient for `G`-unirationality of rational
> `G`-conic-bundle surfaces.

The mechanism is exactly geometric. The central fiberwise involution has a
positive-genus fixed bisection/double cover of the base, while the residual
dihedral group has no fixed point on that cover.

### Smallest model

\[
S_3:\ UV=(X^6+Z^6)W^2,
\quad G=C_2\times D_6\simeq C_2\times S_3.
\]

- dimension: 2;
- singular fibers: 6;
- ordinary rationality: yes, via a section;
- central fixed curve: genus 2;
- Condition (A): pass;
- full fixed locus: empty;
- universal torsor and all higher Amitsur: vanish;
- verdict: not weakly `G`-versal.

## B. Threefold amplification

\[
X_m=\mathbf P^1\times S_m
\]

is a rational conic-bundle threefold. The central fixed surface is

\[
\mathbf P^1\times C_m.
\]

It contains rational curves, so the original central theorem does not
apply. Projection to `C_m` is the MRC quotient. Any residual-stable RCC
subvariety would lie over a residual fixed point of `C_m`, and none exists.
This is the cleanest verified application of the generalized theorem.

## C. Mori--Mukai No. 2.18: an audited failure of the deck route

A smooth member is a double cover

\[
X\to\mathbf P^1\times\mathbf P^2
\]

branched in a smooth `(2,2)` surface `B`. It is rational and has a standard
conic bundle over `P^2` with quartic discriminant. Abe proves that the
general member is linearizable for its full automorphism group, so it is not
a negative target.

The special-member deck involution is also less useful than it first
appears. By adjunction,

\[
K_B=(-2H_1-3H_2+2H_1+2H_2)|_B=-H_2|_B,
\]

and

\[
(-K_B)^2=H_2^2(2H_1+2H_2)=2.
\]

Thus `B` is a degree-two del Pezzo surface. In particular it is rationally
connected, and the whole fixed divisor `X^delta=B` is already a
positive-dimensional residual-stable RCC subvariety. Theorem G1 therefore
fails for the deck involution on **every** smooth No. 2.18 member, regardless
of whether the automorphism group enlarges.

A future negative theorem here would have to use more than the fixed divisor:
for example, a dimension restriction on the surviving source stratum or an
exceptional-network/incidence obstruction inside `B`. The proposed task of
merely classifying residual-invariant rational curves would not suffice,
because `B` itself is an admissible RCC image.

**Status:** `ALREADY-DECIDED` for the general full action; `AUDITED-MECHANISM-FAILURE`
for the central deck route on special members. Headline feasibility: 22/100.

## D. Sarkisov conic-bundle models

The Burkhardt `D_5` action admits a conic-bundle model over the degree-five
del Pezzo surface with discriminant the union of all ten `(-1)`-curves.
This is explicit, but the discriminant is rational and highly reducible;
the simple fixed-curve obstruction has no immediate leverage. The open
linearizability problem should not be confused with an open
`G`-unirationality problem.

Kummer double solids also admit birational bundle models after small
resolutions, but their central fixed K3 contains many rational curves and
the attractive quaternionic cases are already cohomologically obstructed.

## E. Reusable conic-bundle criterion

Let `pi:X->S` be a smooth projective conic bundle with central involution
`delta` acting nontrivially on the generic conic. Suppose the divisorial
fixed locus has a residual-equivariant morphism

\[
F\to\widetilde\Delta
\]

onto the discriminant cover or another non-uniruled base. If:

1. every residual-stable RCC subvariety of `F` lies over a residual fixed
   point of `\widetilde\Delta`;
2. `\widetilde\Delta` has no such fixed point;
3. `X^G=emptyset`;

then `X` is not weakly `G`-versal.

For surfaces, `F` itself is often the discriminant double cover. For
threefolds, `F` can be a ruled surface over that cover, which is precisely
why the residual-RCC refinement is needed.
