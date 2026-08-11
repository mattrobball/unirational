# Notebook supplement — 2026-08-10: the Klein `V22` twin of the sealed `V14` centralizer theorem

Cross-reference only; the work lives in the sibling packet
`research/equivariant-unirationality-new-applications/` (outside this
notebook's manifest scope), files `EXIT_KLEIN_V22.md`, `REPLAY_KLEIN_V22.md`,
`verify_klein_v22.py`.

## What was asked

`FIX_IX_v14.md` Cor IX.1 (sealed) needs, for an involution `sigma` and
`N = C_G(sigma)`: (a) no positive-dimensional irreducible `N`-stable RCC
subvariety of `Y^sigma`, and (b) `Y^N` empty.  The packet's top-ranked open
target was the second index-one instance: `X = VSP(C_Klein, 6)`, the
Cheltsov--Shramov rational `V22` with `G = PSL2(F7)`, `sigma` an involution,
`N = C_G(sigma) = D8`.

## Verdict: `V22-D8-GATE-FAILS`

Exact over `Q(sqrt(-7))` in Mukai's model `X = Gr(3,7) cap P^13` on the
7-dimensional irreducible of `PSL2(F7)` (the net is one of the two
3-dimensional irreducibles in `Lambda^2` of it; these are the only invariant
nets, and they are Galois-conjugate).  Independently confirmed in Macaulay2
over `Q(sqrt(-7))` and mod 11 and mod 23.

```text
X^sigma = C  disjoint-union  {p1, p2}
    C   irreducible, anticanonical degree 6, Hilbert polynomial 6i+1,
        p_a = 0  =>  SMOOTH RATIONAL, and canonically D8-stable
    p1, p2   one D8-orbit of length 2, stabiliser C4
    chi(X^sigma) = 4, matching the Lefschetz number
X^{D8}  = empty
gate (a) FAILS ,  gate (b) HOLDS
```

So the sealed centralizer theorem does **not** transfer to the `V22`.  Nothing
is claimed about `G`-unirationality or weak `G`-versality of the Klein `V22`;
both remain open, and no literature computes either fixed locus.

## Two facts that generalize

1. **Character-forced failure.**  `chi_7(2A) = chi_3(2A) = -1` forces the
   eigenvalue profiles `(3,4)` on the 7-dimensional module and `(1,2)` on the
   net.  With that profile the positive-dimensional part of `X^sigma` is always
   a plane conic in `P(A_+) = P^2`, hence always rational; smoothness of
   `X^sigma` even rules out its degenerating into two lines that `D8` could
   swap.  Contrast the `V14`, where the same construction yields a genus-one
   sextic.
2. **Euler rigidity of the `b_3 = 0` Fano threefolds.**  For `X` with
   `b_2 = 1`, `b_3 = 0` (Mukai's list `P^3, Q^3, V_5, V_22`) every finite-order
   automorphism acts trivially on `H^0, H^2, H^4, H^6`, so `chi(X^g) = 4` and
   `X^g` is never empty.  Hypothesis (b) therefore requires a **non-cyclic**
   centralizer.  In `PSL2(F7)` the centralizers of elements of order 3, 4, 7
   are `C3, C4, C7`, so the involution is the only candidate — and it is the
   one that fails at (a).  There is no substitute element on this target.

## Named open theory task: `V22-D8-NORMAL-CHAIN`

The measured escape is the `FIX_IX` section 6 shape: `D8/<sigma> = V4` acts on
`C = P^1` as the Klein four-group in `PGL2`, fixed-point free, and swaps the
two isolated points.  A sharpening of Cor IX.1 that tracks a single `N`-fixed
point up the resolution tower instead of the whole `P(V_+)` would conclude from
gate (b) alone — which holds here — provided the `sigma`-invariant part of the
normal bundle is nonzero at every stage where the tracked point lies in a
blow-up centre.  When it vanishes, `sigma` acts by `-1` and the fibre is a sum
of copies of the 2-dimensional irreducible of `D8`, which has no invariant
line: that is exactly the escape, and exactly the spin-flank boundary the
`V14` analysis already recorded.  Deriving or refuting the chain lemma is a
theory task, not a computation.
