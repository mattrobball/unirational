# Sources and scope audit

## Primary literature

1. Alexander Duncan and Zinovy Reichstein, *Versality of algebraic group
   actions and rational points on twisted varieties*,
   <https://arxiv.org/abs/1109.6093>.

   Proposition 10.8 records
   \(3\leq\operatorname{ed}_{\mathbf C}(\operatorname{PSL}_2(\mathbf
   F_{11}))\leq4\), identifies the irreducible five-dimensional Klein
   representation, and notes that \(X^G=\varnothing\).  The cached text used
   here is `tmp/pdfs/duncan-reichstein-1109.6093.txt`, lines 1006--1022.

2. Ivan Cheltsov and Constantin Shramov, *Five embeddings of one simple
   group*, especially Definitions 1.9--1.10 and Theorem A.5,
   <https://arxiv.org/abs/0910.1783>.

   The theorem proves full-\(G\) birational superrigidity of the Klein cubic.
   Its definitions concern birational maps/Mori regularizations, not
   generically finite rational maps of degree greater than one.

3. Ivan Cheltsov, Igor Krylov, and Sione Ma'u, *G-birationally rigid cubic
   threefolds*, Theorem 3, Corollary 4(ii), and Remark 5,
   <https://arxiv.org/abs/2604.20426>.

   This gives a second primary-source statement of full-\(G\) birational
   superrigidity and spells out its birational scope.  The cached text is
   `tmp/pdfs/cheltsov-krylov-mau-2604.20426.txt`, introduction and lines
   containing Theorem 3 through Remark 5.

4. Arnaud Beauville, *Endomorphisms of hypersurfaces and other manifolds*,
   <https://arxiv.org/abs/math/0008205>.

   This excludes endomorphisms of degree greater than one for smooth
   hypersurfaces of degree greater than two and dimension greater than one.
   It applies to morphisms, not rational selfmaps with base locus.

5. Nathan Chen and David Stapleton, *Rational endomorphisms of Fano
   hypersurfaces*, especially the introduction following Theorem A,
   <https://arxiv.org/abs/2103.12207>.

   The authors explicitly state that every smooth cubic hypersurface of
   dimension at least two is unirational and therefore admits many rational
   endomorphisms.  Their theorem imposes congruences for **very general**
   hypersurfaces satisfying separate numerical hypotheses; it gives no
   degree-one theorem for the special Klein cubic.  This is primary-source
   confirmation that the rational, as opposed to regular, selfmap branch is
   genuine.

## Exact repository sources

1. `goals_2026-08-01/D_EQUIVARIANT_MOTIVE/BLOWUP_CLOSURE.md` constructs the
   free 660-component Prym-curve orbit and the exceptional rational
   \(G\)-Hodge/motive retraction.  Its own lines 20--23 and 223--226 state
   the exact limitation: the center is not claimed to be an actual landing
   base locus.

2. `goals_2026-08-01/KLS_MINIMALITY/INTERFACE_AUDIT.md`, section 5, records
   the exact finite surjective quartic \(G\)-endomorphism of \(\mathbf P(W)\)
   and the degree-growth consequence under precomposition.

3. `RESOLUTION.md`, lines 3434--3435 in the inspected snapshot, already
   records the correct scope boundary: equivariant birational superrigidity
   excludes birational linearization, not a dominant equivariant map of
   higher degree.

## Pinned text hashes

```text
86248770200401a3874ee7c128b1aaf8246b106b65405b7f10804d037c4dab42  tmp/pdfs/duncan-reichstein-1109.6093.txt
01a6eef59c618ac120fb60b4ccf84e90210ba117694b1539a05fcd3201e427e9  tmp/pdfs/cheltsov-krylov-mau-2604.20426.txt
59ba39953c81e1275b057b5d417af20e02f9d6b37dd4ca78877e4b26b5b0164d  goals_2026-08-01/D_EQUIVARIANT_MOTIVE/BLOWUP_CLOSURE.md
3d18edebfdb7e6c0f4563abf089d953d7a7e06cec80736c4dac47cc51215e084  goals_2026-08-01/KLS_MINIMALITY/INTERFACE_AUDIT.md
```

The hashes pin the exact local evidence read by this audit.  The web links
above are the source-of-record citations.
