Q-UNDECIDED

# Live status — generic Schur descent

This is a live research status, not a terminal resolution.

- Initial repository commit: `2140419410cfff2f7d7dcca166acef8c16a0d41b`
- Live repository audit through: `53e267a59b2d24de93c58dd9ddacc2f995fc2d68`
- Pinned mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`
- Output directory: `goals_2026-08-01/Q_SCHUR_DESCENT/`
- Headline: **OPEN**

The exact unresolved binary statement is

\[
X_{\rm Schur}(K_{\rm Schur})\ne\varnothing
\quad\text{or}\quad
X_{\rm Schur}(K_{\rm Schur})=\varnothing.
\]

Q0 is now reconstructed in `ZERO_CYCLE_LEDGER.md` and
`OBSTRUCTION_LEDGER.md`.  The index-one combination is signed, the standard
Picard/Albanese/Brauer/Amitsur packages vanish, and none of the ten audited
genus-one fibrations is exhaustive for points on the total threefold.
Accordingly none of those facts decides the displayed statement.

Q1 has one sharp new theorem-level reduction.  A general smooth cubic-surface
hyperplane section contains the degree-55 point, so Voisin's 2026 cubic-surface
theorem gives a `K`-point or an integral quartic point.  In the no-point branch,
secant descent excludes every imprimitive quartic action; its Galois closure
must be `A4` or `S4`, it spans the full `P3`, and its Galois closure is linearly
disjoint from the degree-660 Schur splitting field.  Pairing the four
conjugates canonically gives a point over the cubic resolvent field, but not
over `K`.  See `QUARTIC_FRONTIER.md`.  The primitive quartic case is not known
to descend to `K`.

The degree-12 projective-source attack is recorded in
`COVARIANT_ATTACK.md`.  Over `F_23`, the pure 32-dimensional primitive block
has exact sampled landing-row rank 669.  Exact Groebner runs at pair batches
2000 and 512 both timed out and therefore do not decide that block.  Fifteen
selected `D_12`-plus-three-primitive slices are empty.  The nested slices

```text
D_12 + <p0,...,p(k-1)>,  k=4,5,6,7
```

are exactly projectively empty, with the `k=7` run completing after 581.6
seconds.  These are bounded coefficient-support exclusions, not an all-degree
or full degree-12 theorem.

Completion still requires one of the two headline exits in the goal file.

The external theorem boundary is current as of this audit.  Cheltsov,
Tschinkel, and Zhang, *Equivariant unirationality of Fano threefolds*
(dated 2026-07-18), Theorem 5.1 and the discussion on p. 22, still list the
`PSL(2,11)` action on the Klein cubic as open:
<https://math.nyu.edu/~tschinke/papers/yuri/25bguni/bguni.pdf>.
