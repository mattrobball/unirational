# Audit of prior valuation and Schur-descent packets

## Q_SCHUR_DESCENT

The reusable theorem is the universal effective degree-55 cycle coming from
the contained `D12` line.  The following statements are also correct but do
not prove a point over `K_proj`:

- effective cycles of degrees 3 and 55 imply index one;
- the identity `55-18*3=1` is a signed zero-cycle;
- `Br(Y)/Br(K)=0` eliminates ordinary Brauer evaluation;
- ten genus-one fibrations of generic fibre index three are not exhaustive
  for points on the threefold.

This packet does not turn index one into a point globally.  It uses the
effective prime-to-three point only after passing to complete-DVR towers
where Coray's theorem is applicable.

The generic Schur source field and the generic projective source field are
different torsors.  Only the `D12` orbit theorem is transferred, because it
holds functorially for every `G`-torsor twist.  No equation or field specific
to `K_Schur` is identified with `K_proj`.

## V_VALUATION_TROPICAL and the root audit

The reusable negative-boundary results are:

- every scalar extension retains index one, ruling out specialization
  claims forcing degree subgroup `3Z`;
- the ordinary relative Brauer group is zero;
- the five axis divisors `F(x),F(C),F(D),F(E),F(K)` have simple residue
  points and Hensel lifts;
- nonemptiness of the real tropical hypersurface alone is not a valued-field
  solution or obstruction.

The new theorem retires a different, infinite class: the successive
rank-three/four complete-DVR fields attached to saturated geometric Parshin
chains.  It does not claim the axis divisors exhaust rank-one valuations,
and it does not use the old bounded searches at `f5` or `f6`.

## Rejected fallacies

1. **Index one implies point.** False in general and not used.
2. **One bad reduction implies generic pointlessness.** False without the
   proper/local bridge and not used.
3. **Prime 67 decides characteristic zero.** Not used; the group/line
   reconstruction is exact over the cyclotomic characteristic-zero model.
4. **A point over a completion is a global point.** False; only local
   solubility is asserted.
5. **A completion point automatically lies in the henselization.** No such
   descent is asserted.
6. **Every valuation is a Parshin chain.** False; the theorem names the
   covered geometric complete-DVR towers explicitly.
