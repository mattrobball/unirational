# Sources

## Repository theorem boundary consumed

- `problems/E-klein-cubic/NOTEBOOK.md`
- `problems/E-klein-cubic/REPAIR.md`
- `goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/THEOREM.md`
- `goal_runs_20260808/FULL_G_SUPERRIGID_SELFMAP_AUDIT/THEOREM.md`
- `goal_runs_20260808/GENERIC_FIBER_STEIN_MORI/THEOREM.md`
- `goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md`
- `goal_runs_20260808/DELTA3_S3_RESOLVENT_AUDIT/THEOREM.md`
- `goal_runs_20260808/FULL_G_GRAPH_DEGREE_LOCALIZATION/THEOREM.md`
- `goal_runs_20260809/FIXED_NETWORK_MAP_CLASSIFICATION/`
- `goal_runs_20260809/DEGREE25_MARKED_ELLIPTIC_EXTENSION/`
- `certificates/STRATA_EXACT.md`
- `certificates/NORMAL_CHARACTERS.md`
- `certificates/MARKED_S3_GEOMETRY.md`, subject to the binding correction in
  `goal_runs_20260809/FIXED_NETWORK_MAP_CLASSIFICATION/MARKED_S3_CORRIGENDUM.md`
- `theory/FIX_I_bcomplex.md`
- `theory/FIX_T_gate.md`

## Cubic tangent construction and equivariant unirationality

- I. Cheltsov, Y. Tschinkel, Z. Zhang,
  *Equivariant unirationality of Fano threefolds*, arXiv:2502.19598,
  especially Proposition 3.5 and Theorem 5.1.
  <https://arxiv.org/abs/2502.19598>
- D. Huybrechts, *The Geometry of Cubic Hypersurfaces*, Cambridge Studies in
  Advanced Mathematics 206, 2023.
  <https://doi.org/10.1017/9781009280020>

## Birational rigidity and automorphisms

- I. Cheltsov, C. Shramov, *Five embeddings of one simple group*,
  arXiv:0910.1783.
  <https://arxiv.org/abs/0910.1783>
- I. Cheltsov, I. Krylov, S. Ma'u,
  *G-birationally rigid cubic threefolds*, arXiv:2604.20426.
  <https://arxiv.org/abs/2604.20426>

## Regular and rational endomorphisms

- A. Beauville, *Endomorphisms of hypersurfaces and other manifolds*,
  arXiv:math/0008205.
  <https://arxiv.org/abs/math/0008205>
- N. Chen, D. Stapleton, *Rational endomorphisms of Fano hypersurfaces*,
  arXiv:2103.12207.
  <https://arxiv.org/abs/2103.12207>

## Fano surface and intermediate Jacobian

- X. Roulleau, *The Fano surface of the Klein cubic threefold*,
  J. Math. Kyoto Univ. 49 (2009), 113--129; arXiv:1001.4853.
  <https://arxiv.org/abs/1001.4853>
- C. H. Clemens, P. A. Griffiths,
  *The intermediate Jacobian of the cubic threefold*, Ann. of Math. 95
  (1972), 281--356.
- J. P. Murre, work on the algebraic representative and intermediate
  Jacobian of cubic threefolds.

## Equivariant resolution and fixed points

- Z. Reichstein, B. Youssin,
  *Equivariant resolution of points of indeterminacy*,
  arXiv:math/0006099.
  <https://arxiv.org/abs/math/0006099>
- J. Kollár, E. Szabó,
  *Fixed points of group actions and rational maps*,
  arXiv:math/9905053.
  <https://arxiv.org/abs/math/9905053>

## Birational maps from cubic threefolds

- J. Blanc, S. Lamy, *On birational maps from cubic threefolds*,
  arXiv:1409.7778.
  <https://arxiv.org/abs/1409.7778>

## Exact computation

The only new CAS check is `verify_tangent_residual.py`. It verifies the
polynomial cubic identity and the two representative-independence statements.
No coefficient search, degree sweep, or Gröbner search was used.
