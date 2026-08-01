# Primary-source ledger

## Used directly

1. F. Balestrieri, *Degrees of closed points on hypersurfaces*,
   [arXiv:2304.04562v2](https://arxiv.org/abs/2304.04562).
   Theorem 3.6 supplies the polynomial factor construction; Theorem 3.8 gives
   degree `1` or `5` from a simple quartic extension; Corollary 3.10 controls
   the possible successor from a quintic.  The paper's “simple” means a
   simple/monogenic field extension.

2. C. Voisin, *Rank 2 vector bundles and degrees of points of del Pezzo
   surfaces*, [arXiv:2509.17996v2](https://arxiv.org/abs/2509.17996).
   Theorem 1.5 and Remarks 1.6--1.7 give the point-or-effective-degree-four
   alternative for a characteristic-zero smooth cubic surface of index one.
   They do not descend the quartic point.

3. Q. Ma, *Closed points on cubic hypersurfaces*,
   [arXiv:1908.03139](https://arxiv.org/abs/1908.03139).
   Proposition 4.1 gives rational maps to symmetric powers of degree
   `1`, `4`, or `10`; it does not force degree one from the quartic branch.

4. A. Duncan, *G-unirationality of del Pezzo surfaces of degree 3 and 4*,
   [arXiv:1410.8434](https://arxiv.org/abs/1410.8434).
   Lemma 7.3 concerns a genuine automorphism action on a cubic surface.  It
   is recorded only to delimit scope: the Galois group of a quartic residue
   point is not such an action.

5. I. Cheltsov, Y. Tschinkel, and Z. Zhang, *Equivariant unirationality of
   Fano threefolds*, [author PDF dated 2026-07-18](https://math.nyu.edu/~tschinke/papers/yuri/25bguni/bguni.pdf).
   Theorem 5.1 and the discussion on page 22 retain the Klein cubic
   `PSL2(F11)` case as open.

## Exact in-repository inputs

- `Q_SCHUR_DESCENT/QUARTIC_FRONTIER.md`: Voisin reduction, primitive
  `A4/S4` frontier, full span, cubic resolvent, and `E cap N=K`.
- `Q_SCHUR_DESCENT/ZERO_CYCLE_LEDGER.md`: degree `55`, degree `3`, and the
  signed index-one ledger.
- `certificates/schur_degree19/marked_hilbert.json`: certified Hilbert
  function `1,4,10,19,31,45,55,...` for the selected `Z_55`.
- `Q_SCHUR_DESCENT_CODEX_ROOT_20260801_5F31/QUARTIC_TANGENT_AUDIT.md`:
  exact counterexamples to automatic tangent-twisted-cubic descent.

