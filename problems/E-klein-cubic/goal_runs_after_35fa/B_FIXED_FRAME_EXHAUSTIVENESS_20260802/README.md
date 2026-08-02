# Goal B successor — fixed-frame exhaustiveness

This packet closes the **bridge/exhaustiveness theorem** requested in Goal B.
It does not edit the sealed historical `B_FIXED_FRAME_BRIDGE` packet.

The exit is

```text
B-BRIDGE-REFUTED
```

The selected ternary frame has image of dimension at most one in the right-line
space.  The subgroup of the five-plane-preserving gauge that acts effectively
on the genuine Fano threefold is finite, because the split target is a smooth
Picard-rank-one Fano threefold of genus eight, whose automorphism group is
finite.  Hence the gauge saturation of the fixed-frame image still has
dimension at most one and cannot exhaust the three-dimensional twisted Fano
section.

A concrete counterexample to universal exhaustiveness is the generic point of
`F14_T` over `K_proj(F14_T)`.  This is a theorem-level refutation of the bridge,
not a `K_proj`-rational point.  The direct arithmetic questions
`F14_T(K_proj)` and `X_gen(K_proj)` remain undecided, and the Klein-cubic
headline remains open.

Replay:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 -u produce.py
PYTHONDONTWRITEBYTECODE=1 python3 -u produce_seal.py
PYTHONDONTWRITEBYTECODE=1 python3 -u verify.py
```
