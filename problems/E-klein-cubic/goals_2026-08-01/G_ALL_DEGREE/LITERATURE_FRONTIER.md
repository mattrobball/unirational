# Current literature frontier

This source audit was refreshed on 2026-08-01.  It is evidence about the
current research frontier, not a substitute for the packet's exact positive
or negative acceptance criterion.

## July 18, 2026 classification manuscript

Cheltsov--Tschinkel--Zhang, *Equivariant unirationality of Fano threefolds*,
author manuscript dated July 18, 2026,
<https://math.nyu.edu/~tschinke/papers/yuri/25bguni/bguni.pdf>, states in
Theorem 5.1 that the `PSL_2(F_11)` action on the Klein cubic remains among the
possible exceptions.  Page 23 is explicit that the `C11 semidirect C5` and
`PSL_2(F_11)` actions on the Klein cubic have open equivariant
unirationality.

The locally archived source used for this check is

```text
../tmp/pdfs/bguni-author-2026.pdf
sha256 3fbc3ae9c55adcef5b61bc49c215c289610202e8943b6ec8cf47761e79967cd3
PDF creation date 2026-07-18
```

`verify_literature_frontier.py` checks this hash, the manuscript date, and the
open-status sentence extracted from the PDF.

## Essential-dimension formulation

Dolgachev, *The essential and Cremona dimensions of a group*, arXiv v3 dated
May 1, 2026, <https://arxiv.org/abs/2507.15096v3>, Section 7, says that
`PSL_2(F_11)` remains a possible essential-dimension-three group conditional
on the Cassels--Swinnerton-Dyer assertion that a cubic hypersurface with a
zero-cycle of degree one has a rational point.  The same discussion notes the
tension between that conjecture and the nonrational Klein cubic.  It does not
prove the conditional rational-point assertion.

## Degree-four frontier

Voisin, *Rank 2 vector bundles and degrees of points of del Pezzo surfaces*,
<https://arxiv.org/abs/2509.17996>, Theorem 1.5, is the external input used in
`attacks/zero_cycle_containment/`: a prime-to-three point on the cubic-surface
section yields a point of degree at most four.  The installed audit correctly
extracts the point-or-primitive-quartic alternative.  The theorem does not
control the intersection of that quartic's Galois closure with the generic
`PSL_2(F_11)` splitting field; `attacks/primitive_quartic_v2/` proves instead
that this intersection is forced to be the ground field.

## Consequence for this packet

The refreshed primary sources do not supply the missing point or
pointlessness theorem for `V(Phi)` over `K_proj`.  They therefore support, but
do not themselves prove, the honest packet exit `G-STRUCTURAL-UNDECIDED`.

## Replay

```text
/opt/homebrew/bin/python3 G_ALL_DEGREE/verify_literature_frontier.py
```
