# Top candidate proof: the six-fiber de Jonquières conic bundle

## Exact pair

Take `m=3` in the odd-dihedral family:

\[
S=\{UV=(X^6+Z^6)W^2\}
  \subset\mathbf P_{\mathbf P^1}
  (\mathcal O\oplus\mathcal O(3)\oplus\mathcal O(3)),
\]

and

\[
G=C_2(\delta)\times D_6\simeq C_2\times S_3.
\]

The rotation has order three on the base, the reflection exchanges `X,Z`,
and `delta` exchanges `U,V`.

## Theorem

\[
\boxed{S\text{ is a rational surface satisfying Condition (A), all
higher Amitsur and universal-torsor obstructions vanish, but }S
\text{ is not weakly }G\text{-versal}.}
\]

## Proof

1. **Rationality.** The conic bundle has the section `[W:U:V]=[0:1:0]`,
   so it is birational to a ruled surface.
2. **Central fixed curve.** The fixed locus of `delta` is
   `C: y^2=x^6+1`, a smooth genus-two curve.
3. **No deep fixed point.** A `D_6`-fixed point on `C` would project to a
   common fixed point of the rotation and reflection on `P^1`; none
   exists.
4. **Condition (A).** Any abelian subgroup of `D_6=S_3` is cyclic of order
   two or three. The order-three subgroup fixes the two points over `x=0`.
   Each reflection fixes a base point with `x^3=1`, and then `y^2=2`.
   Including the central `delta` does not remove these points because they
   already lie on `C`.
5. **Obstruction.** `delta` is central, `S^delta=C` contains no rational
   curve, and `S^G=emptyset`; Corollary T3.1 applies.
6. **Cohomology.** The 2-Sylow `C_2 x C_2` fixes a reflection point on
   `C`, and the 3-Sylow fixes a point over `x=0`. Therefore the
   universal-torsor class restricts trivially to all Sylows and is zero by
   restriction-corestriction. The same holds for every subgroup. All
   higher Amitsur groups vanish.

No large computation is involved. The replay script enumerates the finite
group and subgroup assertions for several odd values of `m` and checks the
symbolic fixed-point identities.

## Why this is the best next theorem

- It is the first explicit rational `G`-conic-bundle surface in this
  repository where Condition (A) passes but weak versality fails.
- The group and equation are elementary.
- The fixed curve is the classical de Jonquières invariant of the
  fiberwise involution.
- Existing cohomological obstructions are silent.
- The product with `P^1` immediately tests the requested threefold
  refinement: the fixed surface contains rational curves, so only the
  residual-RCC theorem closes it.
