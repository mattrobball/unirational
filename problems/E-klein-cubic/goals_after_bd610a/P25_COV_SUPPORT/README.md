# P25/COV finite-support packet

This packet closes PC.0 and records several exact finite advances, but it
does not decide the mission.  The authorized exit is `PC-UNDECIDED`; Problem
E remains **OPEN**.

Over `F_89` the independent PC.0 replay proves

```text
rank(V0)=690, rank(W)=56, V0 intersect W=0,
rank(V0+W)=746,
rank(S1 tensor (V0+W) -> S4)=27583,
kernel dimension=19.
```

The actual coupled degree-four closure has rank `29880`: it consists of the
`25530` independent q-multiples of the cubic seeds, all `4140` transition
rows, and `210` independent commutator defects.  This is stronger than the
`2053`-dimensional pure-q projection.  A later all-coordinate border-circuit
certificate proves that a 25,200-state hull through degree 6 is transition
stable and equals the true relation kernel over `F_89`.  This is an exact
finite but redundant presentation.  The minimal degree-5/6 ranks, syzygies,
normal forms, characters, and transition matrices required by PC.1 remain
open.
The canonical coefficient-side `PSL_2(F_11)` action is exactly trivial, so
the character ledger is constant on all eight classes; an exhaustive 720-case
audit finds no nontrivial pure-K permutation symmetry.  The 28-state carrier
is minimal over `S`, but the installed relation generators are not minimal.

For support, `412` genuine contraction identities are replayed and all
`C(37,3)=7770` coordinate q-planes have exact restricted rank `75/75`.
Consequently Stage B and normalized Stage C have no point with q-support at
most three.  Support at least four remains open.  Inherited exact work also
closes Stage A and both remaining strata on the named `L8`, but no global
Stage-B or Stage-C unit certificate exists.

The structural audit proves exact raw-Macaulay dimension thresholds
`D=49,38,17` for the 43-, 64-, and 412-row packets, and recomputes rank 476
for the non-pure projection of their selected-row union.  It also records a
safe degree-22 Schur-complement route conditional on a global Stage-B minor
cover.  These are route constraints, not a support decision.

Degrees 31 and 35 remain undecided in the literal coefficient spaces.  The
positive-invariant-multiple quotient is explicitly forbidden: exact Bezout
witnesses show primitive sums inside that linear span.  The actual
common-scalar-factor loci are now constructed exhaustively as 11 and 15
kernel-aware projective graph components in degrees 31 and 35.  The other
required composition and named-family loci, their total union and
intersections, and the remaining 47 and 101 characteristic-zero affine
charts are open.
Exact arithmetic circuits now give rank-43 maps from the full strict
degree-25 coefficient space into the degree-31 and degree-35 literal spaces by
multiplication with `f6` and `f10`; the nonlinear PC.2 scheme and hence its
actual images remain unknown.  The original characteristic-zero Cramer chart
degenerates at `p=89`, but a separately replayed unit chart of determinant 74
repairs both ambient maps in the authoritative `Q(37)|K(6)` frame.

Run the full independent replay with

```bash
python3 -B -u P25_COV_SUPPORT/verify_all.py \
  --log P25_COV_SUPPORT/VERIFY_LOG.txt
python3 -B -u P25_COV_SUPPORT/make_seal.py
python3 -B -u P25_COV_SUPPORT/verify_seal.py
```

The full replay is intentionally substantial: it rebuilds the load-bearing
ranks and all 7,770 coordinate-plane minors instead of trusting stored counts.
`verify_all.py --quick` checks only input identity and is not acceptance
evidence.

The exact theorem boundaries are in `INDEPENDENT_RANK_REPLICATION.md`,
`TRANSITION_CLOSURE.md`, `P25_SUPPORT.md`, and the two COV support reports.
`COMPLETION_AUDIT.md` maps every work package to its current state.
