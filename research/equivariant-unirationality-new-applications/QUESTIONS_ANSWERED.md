# Answers to the eight required questions

## 1. Additional degree-1 or degree-2 del Pezzo path applications?

No second **verbatim** Problem-F application was found. The strongest degree-2 cases are already decided by the repository central theorem, Problem F, or the 2026 third-Amitsur obstruction. Degree-1 actions have the common anticanonical base point fixed by the full automorphism group, so they cannot fail weak versality; a dominance-only obstruction would be needed to disprove `G`-unirationality.

## 2. Rational conic-bundle surfaces passing Condition (A) but not `G`-unirational?

Yes. For every odd `g≥3`, the rational exceptional conic bundle

\[
S_g:\ T_0T_1(T_0^{2g}+T_1^{2g})+T_2T_3=0
\]

with

\[
G_g=D_{2g}\times C_2
\]

passes Condition (A) but is not weakly `G_g`-versal. This is proved in `THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md`.

## 3. Central fiber involutions on conic-bundle threefolds?

Yes. They naturally produce a discriminant or branch surface as fixed locus. If that surface is non-uniruled, the residual-RCC theorem can work after excluding residual-stable rational curves. If it is rational, as in Mori–Mukai family No. 2.18, a one-stratum central theorem is insufficient and a connected three-dimensional fixed-network theorem is needed.

## 4. Special rational Fano conic-bundle threefolds with large automorphism groups?

Yes. Abe's special No. 2.18 members with Fermat and Klein quartic discriminants are explicit and rational. The Fermat-discriminant member has total automorphism group of order 192 and is the best current laboratory for a three-dimensional exceptional-network theorem. Abe's displayed `C4×C2deck` subgroup has a fixed point and is weakly versal, so the relevant target must be a nonabelian subgroup of the full group.

## 5. Kummer quartic double solids despite rational curves in the fixed K3?

Possibly, but not uniformly. Q8-containing actions are already killed by `Am^3`. For a non-Q8 subgroup one must compute the residual action on the 16 exceptional and 16 trope curves. The specific test subgroup

\[
C_2^{\rm deck}\times(C_4^2\rtimes C_3)
\]

is recorded in `KUMMER_DOUBLE_SOLIDS.md`; its Condition-(A) and stable-curve audits remain open.

## 6. A second `V14`-type index-one centralizer phenomenon?

The best candidate is now the rational Klein threefold

\[
X_{22}=\operatorname{VSP}(C_{\rm Klein},6)
\]

with

\[
G=\operatorname{PSL}_2(\mathbf F_7).
\]

For an involution `σ`, the centralizer is `D8`. Condition (A) is published for the whole Mori–Mukai No. 1.10 family, and the equivariant universal-torsor and all higher-Amitsur obstructions vanish. The exact missing calculation is

\[
(X_{22}^{\sigma},X_{22}^{D_8}).
\]

No second index-one centralizer theorem is claimed yet.

## 7. Condition (A) and all known cohomology silent, but unresolved?

Before this packet, the smooth quartic double solid with

\[
G=(C_7\rtimes C_3)\times C_2^{\rm deck}
\]

passed Condition (A), had vanishing equivariant universal-torsor obstruction and therefore vanishing higher Amitsur groups, while no weak-versality result was found. This packet closes it negatively by fixed-K3 geometry.

A published unresolved example remains: the rational Klein `V22` with `PSL2(F7)` passes Condition (A), has vanishing universal-torsor and higher-Amitsur obstructions, and no equivariant-unirationality decision was found through the search cutoff.

## 8. Best candidate for a second genuinely new theorem?

The search produced two new theorems. The strongest single completed application is the smooth quartic double solid because all currently available Amitsur-type obstructions vanish. The infinite odd exceptional-conic-bundle family is the strongest structural application.

After those, the best unresolved target is

\[
\boxed{
(\operatorname{VSP}(C_{\rm Klein},6),\operatorname{PSL}_2(\mathbf F_7)).
}
\]

It is rational, explicit, passes Condition (A), has a silent cohomological hierarchy, and is separated from the residual-centralizer theorem by one finite involution/`D8` fixed-scheme audit.