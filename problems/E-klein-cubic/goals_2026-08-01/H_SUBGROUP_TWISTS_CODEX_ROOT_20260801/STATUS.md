H-SWEEP-UNDECIDED

# Proper-subgroup generic twists of the Klein cubic

## Verdict

No proper-subgroup generic twist is proved pointless.  Therefore
`BR-SUBGROUP-NEG` does not fire and the `PSL_2(F_11)` headline remains open.

The sweep is nevertheless terminal at the exact current theorem boundary:
all proper subgroups other than the two maximal `A5` classes and maximal
`11:5` are known positive, while those three remaining actions are precisely
proper-subgroup instances retained as possible exceptions by
Cheltsov--Tschinkel--Zhang, Theorem 5.1.

## Exact decisions

| subgroup class | generic twist / theorem | decision |
|---|---|---|
| maximal `A5`, class 1 | exact `C(P2)^A5` twist in `a5_twist_payload.json` | unresolved; index one; no homogeneous landing covariant through degree 9 |
| maximal `A5`, class 2 | separately constructed nonconjugate twist | unresolved; index one; no homogeneous landing covariant through degree 9 |
| maximal `11:5` | exact `C(P4)^(11:5)` twist in `11_5_twist_payload.json` | unresolved; index one from degrees 3 and 5 |
| `D12` | invariant contained projective line | every torsor twist has a point |
| `A4` | CTZ Theorem 5.1 plus inherited Condition (A) | `A4`-unirational; every twist has a point |
| `D10` | invariant contained projective line | every torsor twist has a point |

The maximal-subgroup classification has types `A5`, `11:5`, and `D12`.
Every proper subgroup of an `A5` or `11:5` not already displayed is outside
the possible exceptions of CTZ Theorem 5.1 and inherits Condition (A), hence
is positive.  Thus the table is a complete proper-subgroup decision boundary,
not a finite sample.

## Two A5 classes

The two classes were not identified.  The producers use concrete exact
`(2,3,5)` pairs in `PSL_2(F_11)`, enumerate their conjugacy orbits through
all 660 group elements, and obtain two disjoint orbits of eleven maximal
subgroups.  An exact degree-zero Fourier/Hilbert--90 frame is constructed
for each class separately.  Both determinants are nonzero modulo 89, and
the independent verifier finds a nonzero witness again modulo 331.

## Pointlessness screens

- **H-A:** no henselian divisorial reduction is proved pointless.  Index one
  excludes any proposed residue argument whose conclusion would force the
  global index to be divisible by three.
- **H-B:** the fixed-locus/normalizer screen gives no contradiction; normal
  exceptional exits remain.  The named `D12` and `D10` cases instead have
  contained lines and are positive.
- **H-C:** both `A5` twists have a degree-three cycle and an orbit cycle of
  degree prime to three; `11:5` has exact cycles of degrees three and five.
  Hence all three unresolved generic twists have index one.
- **H-D:** for each `A5` class the complete honest homogeneous covariant
  landing schemes through degree nine are empty.  Their dimensions in
  degrees `0,...,9` are `0,0,1,0,2,1,3,2,5,3`; all projective parameter
  charts are certified by exact unit ideals modulo 89.  The degree-four
  two-column function-field cubic and all ten lines in a full five-column
  covariant frame also have no geometric rational-function root, certified
  by factorization over both `F_89` and `F_(89^3)`.  These are bounded
  exclusions, not an all-degree pointlessness theorem.

## Smallest unresolved twist

The smallest unresolved object is either one of the two separately recorded
maximal `A5` twists over the transcendence-degree-two field

\[
K_i=\mathbf C(\mathbf P^2)^{H_i}.
\]

For class 1 it is the explicit equation

\[
\sum_{j\in\mathbf Z/5}(A_1(y)z)_j^2(A_1(y)z)_{j+1}=0,
\]

with `A_1` defined in `BRIDGE.md` and instantiated in
`a5_twist_payload.json`.  The exact remaining theorem is binary:

\[
X_{\tau_{H_1}}(K_1)=\varnothing
\quad\text{or}\quad
X_{\tau_{H_1}}(K_1)\ne\varnothing.
\]

The `11:5` twist has a similarly explicit equation but its displayed versal
field has transcendence degree four, so it ranks after the two `A5` twists.

## Repository state

- pinned mathematical baseline consumed: `715faf441289e2589b9325311b6613ea0331bf88`;
- live repository commit at final audit: `53e267a`;
- worker start commit: `2140419`; the concurrently committed Goal-H packet
  through `53e267a` was inspected.  It also exits `H-SWEEP-UNDECIDED`, but
  ranks `A4` as unresolved; the July 18 CTZ theorem removes `A4`, so this
  isolated packet records the sharper current boundary;
- produced commit: none (this is an uncommitted isolated worker packet).

## Replay

From `problems/E-klein-cubic/goals_2026-08-01`:

```sh
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/build_a5_twists.py
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/low_degree_search.py
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/a5_degree5_7_search.py
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/a5_degree8_9_search.py
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/probe_degree4_function_field.py
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/a5_covariant_line_search.py
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/build_11_5_twist.py
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/verify.py
```

The terminal verification marker is

```text
H_SUBGROUP_TWISTS_INDEPENDENT_VERIFY_OK
```
