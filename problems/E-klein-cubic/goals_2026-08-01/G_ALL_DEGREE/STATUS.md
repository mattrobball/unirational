G-STRUCTURAL-UNDECIDED

# Goal G status

This is the isolated workspace for the 2026-08-01 Goal G run.  The live
repository commit at intake was
`2140419410cfff2f7d7dcca166acef8c16a0d41b`; the shared waypoint advanced
through `53e267a59b2d24de93c58dd9ddacc2f995fc2d68` and then
`35fa8f59b6a1423cc89300aeaceefe91552be5ba` during the run.  The pinned
mathematical baseline in the work order is
`715faf441289e2589b9325311b6613ea0331bf88`, and the verifier checks that it
is an ancestor of the live commit.

No headline conclusion is claimed.  The structural exit rests on ten exact
advances:

1. `FINITE_GENERATION.md` gives a counterexample to the inference from a
   finite module presentation to a bound for the first primitive cubic zero.
2. `UNIVERSAL_OBJECT.md` replaces the proposed local-state object with the
   filtered global covariant module and proves that existence in any degree
   is equivalent to a rational point on one explicit generic twisted cubic.
3. `FIRST_GATE.md` proves, for every odd plane order, the
   quadratic-Veronese successor identity, its elliptic trace consequence,
   and the first post-minimum triple-line recurrence.
4. `attacks/local_infinite_descent/` proves the complete `V4` symbolic-Rees
   recurrence and exhibits a gcd-one order-three class in the abstract
   projective-character model which propagates to every odd order.  Restoring
   the actual `W`-character introduces a common inverse-character line
   factor, so this is not a primitive actual covariant.  It defeats the
   unsaturated local-emptiness strategy but leaves primitive saturation and
   global overlap open.
5. `attacks/constructive_point/` excludes all ten two-frame lines over the
   larger splitting field and excludes constant normalized frame
   coordinates.  Points with at least three nonconstant coordinates remain.
6. `attacks/valuation_obstruction/` proves actual solubility over the standard
   successive complete-DVR field attached to every saturated geometric
   Parshin chain of length three or four.  This packet alone makes no claim
   about arbitrary henselizations or the global point question.
7. `attacks/zero_cycle_containment/` applies Voisin's cubic-surface theorem
   to the genuine degree-55 line-orbit point: either the generic twist has a
   rational point, or it has a primitive quartic point with Galois closure
   `A4` or `S4`.  Existing degree bounds do not force termination.
8. `attacks/ternary_kproj_v2/` binds the normalized `x,C,D` restriction to
   the sealed general-slice theorem and proves that plane has no
   `K_proj,C`-point.  It also excludes 120 exact constant-secondary-support
   ansatze.  The other unrestricted ternary planes and four-/five-frame
   supports remain open.
9. `attacks/low_rank_valuations_v2/` proves that every arbitrary-rank Krull
   valuation trivial on `C` with `C1` residue gives a point over its
   henselization.  Any negative valuation in that convention must be
   unramified with non-`C1` residue and exceptional decomposition group; the
   divisorial transcendence-degree-three and saturated rank-two
   transcendence-degree-two sites remain central examples.
10. `attacks/primitive_quartic_v2/` proves forced disjointness
    `E cap N=K`, constructs the canonical cubic-resolvent degree-three point,
    and writes the primitive full-span quartic branch as four exact remainder
    equations on five normalized charts.  Thus generic-field containment is
    impossible in the no-point branch and no descent to a ground-field point
    follows.

The 35 coefficients of the generic cubic are stored in
`generic_cubic.json`; the producer derives them over `QQ` from the original
Klein equation and the independent verifier reconstructs every expanded
polynomial identity.  These results remove the degree ladder and narrow the
all-degree problem to one exact arithmetic support question.  They do not
decide that question.

`ATTACKS.md` gives the requirement-level scope ledger for all seven attack
packets and names the surviving constructive, global-overlap, valuation, and
primitive-quartic gates.  `LITERATURE_FRONTIER.md` records the current primary
literature check: the July 18, 2026 author manuscript still lists the
`PSL_2(F_11)` Klein action as open.

The current decision gate is binary:

* exhibit and verify a point of the generic twist, yielding
  `G-COVARIANT-HEADLINE-POSITIVE`; or
* give an exact pointlessness certificate for the generic twist (equivalently
  an all-degree landing-emptiness theorem), yielding
  `G-ALL-DEGREE-EMPTY-HEADLINE-NEGATIVE` after the source bridge is audited.

Until one of those is proved, this file must not be upgraded to a headline
exit.  In particular, `G-STRUCTURAL-UNDECIDED` is not a refutation or a
construction of a landing covariant.

## Replay

```text
/opt/homebrew/bin/python3 G_ALL_DEGREE/produce_generic_cubic.py
/opt/homebrew/bin/python3 G_ALL_DEGREE/verify_all.py
```
