Q-UNDECIDED

# Live status — generic Schur descent

This is a live research status, not a terminal resolution.

- Initial repository commit: `2140419410cfff2f7d7dcca166acef8c16a0d41b`
- Live repository audit through: `35fa8f59b6a1423cc89300aeaceefe91552be5ba`
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

Five independent completion audits have now tested the strongest remaining
interfaces.

1. The valuation audit proves that any henselian local nonpoint must be
   unramified, have residue transcendence degree at least two and rational
   rank at most three, and have decomposition group `PSL(2,11)`, one of the
   two maximal `A5` classes, or maximal `11:5`.  All rational-rank-at-least-four
   valuations are soluble.  It also proves that a morphism from the full twist
   to a torsor under a commutative algebraic group can land only in a trivial
   torsor.  The surviving residue cubic is still an index-one point problem,
   not a pointlessness certificate.
2. The primitive quartic is linked on a `K`-twisted cubic to an
   integral quintic, but Balestrieri's construction is exactly the loop
   `4 -> 5 -> 4`.  The residue compositum has degree 20, and its Galois package
   is disjoint from the Schur splitting field.  Thus neither linkage nor raw
   field intersection descends the quartic.
3. The three points produced by the quartic's pairing-resolvent construction
   are not universally collinear: five exact smooth rational test surfaces
   have projective rank three.  Hence there is no formal second secant descent
   from the cubic resolvent cycle.
4. Two full-five-coordinate constant-Krylov point ansatzes over `K_proj` are
   exactly empty, with Hilbert functions `[1,10,55,80,50,0]` and
   `[1,15,120,435,820,351,50,0]`.  Gross--Popescu supplies the genuine
   intertwiner `Lambda^2(V6) ~= Sym^2(W5)`, but its final birational
   identification with the Klein cubic is explicitly non-equivariant.  These
   facts close those two constructive shortcuts, not the unrestricted point
   problem.
5. Rational-curve incidence gives virtual point counts 192 in degree four
   and 8 in degree three.  The quartic count allows fixed-point-free `A4` and
   `S4` actions; the cubic count would force a fixed curve in the `C3` case
   only if the special resolvent triple lay in a reduced enumerative general
   fibre and its curves split over the cubic closure.  Neither hypothesis is
   proved, and `S3` admits fixed-point-free actions on eight objects.  Exact
   differential ranks `(9,10,6)` show that a general quartet does have a
   general resolvent triple, but Voisin's Fulton specialization supplies no
   such generality for the installed quartic.  Moreover, the generic
   three-point incidence cover is integral of degree eight even after the
   three marked points split, so cubic-closure splitting would have to be a
   new Schur-specific theorem.  On the output side the bridge is complete:
   any actual descended degree-three stable map, including a reducible one,
   or any generalized-twisted-cubic Hilbert point forces a `K_Schur`-point.

The requirement-by-requirement verdict and the precise missing implications
are recorded in `COMPLETION_AUDIT.md`.  Every finite certificate listed in
`REPLAY.md` has an independent verifier.  There is deliberately no
`SEAL.json`, because neither binary headline is proved.

Completion still requires one of the two headline exits in the goal file.

The external theorem boundary is current as of this audit.  Cheltsov,
Tschinkel, and Zhang, *Equivariant unirationality of Fano threefolds*
(dated 2026-07-18), Theorem 5.1 and the discussion on p. 22, still list the
`PSL(2,11)` action on the Klein cubic as open:
<https://math.nyu.edu/~tschinke/papers/yuri/25bguni/bguni.pdf>.
