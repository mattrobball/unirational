# Source audit

## Primary sources

1. Ivan Cheltsov and Constantin Shramov, *Five embeddings of one simple
   group*, Theorem A.5,
   <https://arxiv.org/abs/0910.1783>.

   This is the original cited proof that the Klein cubic is
   \(\operatorname{PSL}_2(\mathbf F_{11})\)-birationally superrigid.

2. Ivan Cheltsov, Igor Krylov, and Sione Ma'u, *G-birationally rigid cubic
   threefolds*, <https://arxiv.org/abs/2604.20426>.

   The introduction defines \(G\)-birational superrigidity by the
   birational/Mori-fibre condition and equality of the groups of
   **\(G\)-equivariant** birational and regular selfmaps (the
   corresponding centralizers of \(G\)).  Theorem 3,
   Corollary 4(ii), and Remark 5 cover the full automorphism action on the
   Klein cubic.  The proof of Theorem 10 records the exact mobile-system
   criterion: non-superrigidity is equivalent to a \(G\)-invariant mobile
   \(\mathcal M\subset|\mathcal O_X(n)|\) for which
   \((X,(2/n)\mathcal M)\) is not canonical.

3. Arnaud Beauville, *Endomorphisms of hypersurfaces and other manifolds*,
   <https://arxiv.org/abs/math/0008205>.

   This rules out regular endomorphisms of degree greater than one for the
   smooth cubic threefold.  It is used only after the normalized graph has
   been proved to be a \(G\)-Mori fibre space and hence identified
   biregularly with \(X\).

4. ATLAS of Finite Group Representations, *Linear group \(L_2(11)\)*,
   <https://brauer.maths.qmul.ac.uk/Atlas/v3/lin/L211/>.

   The table gives \(|G|=660\), two degree-11 permutation
   representations, and the complete maximal-subgroup structures
   \(A_5,A_5,11{:}5,D_{12}\).  Their orders are \(60,60,55,12\), so the
   least index of a proper subgroup is exactly \(11\).  This is the finite
   input used to exclude all Galois deck degrees \(2\) through \(11\).
   The associated representation page
   <https://brauer.maths.qmul.ac.uk/Atlas/v3/matrep/L211G1-f3r5aB0>
   certifies an absolutely irreducible five-dimensional representation over
   \(\mathbf F_3\).  It supplies the precise larger abelian boundary
   example \(D=(C_3)^5\), for which
   \(G\hookrightarrow\operatorname{Aut}(D)\) and \(D^G=1\).

## Exact local inputs

* `../FULL_G_RESTRICTION_DOMINANCE/THEOREM.md` supplies the dominant
  restriction and the positive integer \(\delta\).
* `../GENERIC_FIBER_STEIN_MORI/THEOREM.md` supplies the normalized Stein
  graph and its conditional Mori lemma.

The cited primary sources were checked against a local extraction during the
audit, but that cache is deliberately not part of this packet.  The portable
replay checks the source URLs and theorem-scope statements recorded above,
then hashes the two repository inputs below.  It does not purport to
machine-prove the cited birational-superrigidity theorem.

Pinned hashes at the time of this audit:

```text
3288a39f44017ba054be11799fc5f855ffb7b255d361294789cbda3d403de560  goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/THEOREM.md
1beeb26f1e0eac5a7d1720f6f21b9d11edd8b2ea5c3f5fd0920cc9c2b6b87311  goal_runs_20260808/GENERIC_FIBER_STEIN_MORI/THEOREM.md
```
