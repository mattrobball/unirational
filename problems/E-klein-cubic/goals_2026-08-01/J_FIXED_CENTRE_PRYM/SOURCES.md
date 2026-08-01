# Sources and consumed evidence

## Repository sources

The producer records and the verifier checks SHA-256 hashes for:

- `certificates/hodge_centers/character_screen.json` — exact subgroup
  restrictions of \(H^{2,1}(X)\);
- `certificates/strata/incidence_exact.json` — exact type-I/type-II and
  multiple-fixed incidence counts;
- `certificates/strata/marked_s3_geometry.json` — the computed value
  \(j(E_t)=8192/11\) and residual action input, consumed only after applying
  the corrections in `ONE_MOTIVE.md`;
- `certificates/strata/normal_characters.json` — normalizer and normal
  eigenspace data;
- `certificates/exact_weil_check.py` — exact \(G\)-representation source.

The binding goal is `GOAL_J_FIXED_CENTRE_PRYM.md`; the pinned baseline is
`715faf441289e2589b9325311b6613ea0331bf88`, and the live consumed head is
`2140419410cfff2f7d7dcca166acef8c16a0d41b`.

## Literature used for the Hodge/isogeny statements

1. X. Roulleau, *The Fano surface of the Klein cubic threefold*, J. Math.
   Kyoto Univ. 49 (2009), arXiv:1001.4853,
   <https://arxiv.org/abs/1001.4853>.  The introduction and Theorem 2 identify
   \(\operatorname{Alb}(F(X))\) with \(J(X)\), compute the period lattice
   and theta form, and state that \(J(X)\simeq E_{11}^5\) as an abelian
   variety but not as a product ppav.
2. M. Hartlieb, *Special subvarieties in the locus of intermediate Jacobians
   of cubic threefolds*, Math. Z. 310 (2025), Article 52,
   <https://link.springer.com/article/10.1007/s00209-025-03745-3>.
   Remark 23 independently records \(J(X)\sim E_{11}^5\) with CM by
   \(\mathbf Q(\sqrt{-11})\).
3. C. H. Clemens and P. A. Griffiths, *The intermediate Jacobian of the cubic
   threefold*, Ann. of Math. 95 (1972), 281–356,
   <https://annals.math.princeton.edu/1972/95-2/p06>.  Used for the standard
   intermediate-Jacobian/Fano-surface and polarization background cited by
   Roulleau.

## Verification boundary

`verify.py` recomputes finite group cohomology, marked permutation-character
decompositions, source hashes, selected subgroup restriction rows, packet
integrity, and the seal.  The algebraic-geometric stabilization lemmas are
proved in the Markdown files; they are not booleans read from JSON and are
not represented as CAS-certified theorems.
