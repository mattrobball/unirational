# Problem D handoff

Updated: 2026-07-23 07:17 EDT

Repository: `/Users/worker/unirational`

Branch and base commit:

```text
main
3d0238c 2026-07-23T06:35:38-04:00 Literature audit: verify boundary claims against primary sources
```

This is a pause checkpoint for the active objective “Resolve
[`SPEC.md`](SPEC.md).”  The objective is **not complete**.  The current
worktree contains an accepted new scoped theorem and its status integration,
but those changes have not been committed.

## 1. Accepted result from this work session

The proper-high, seven-distinct-singleton \([3,2^7]\) row is now absent on
the base-point-free locus.

The previously accepted results already excluded the all-proper,
exactly-one-nonproper, and exactly-two-nonproper rows.  The two new theorem
packages close the exactly-three-nonproper row:

1. [`certificates/k2_profile327_n3_simultaneous_jet_frontier.md`](certificates/k2_profile327_n3_simultaneous_jet_frontier.md)
   excludes all seven integral deleted-adjoint cubics.
2. [`certificates/k2_profile327_n3_nonintegral_block_exclusion.md`](certificates/k2_profile327_n3_nonintegral_block_exclusion.md)
   excludes the complete nonintegral complement: line--conic and three-line
   factorizations, nonreduced cubics, the common low-degree branch factor,
   and the final integral and reducible residual-conic rows.

The second theorem passed an independent hostile mathematical audit after
three boundary repairs were made explicit:

- tangent line--conic gluing at the high point;
- a selected tangent to an integral residual conic;
- the unique nonforced selected-tangent row for a reducible residual conic.

The final proof also explicitly separates the splitting, ramification,
cross-incidence, and configuration ledgers.  In the worst reducible-residual
row it applies the codimension-four three-jumping-line-plus-ramification
lemma to one component line, the outside marked line, and the selected
marked line, leaving the other component splitting conditions unused.

Exact scope: this closes only the proper-high, seven-distinct-singleton
subrow.  It does **not** close a nonproper high center, repeated essential
trees, isolated-base alignments, or other cluster types.  It does not close
Problem D or its headline.

## 2. New and modified theorem artifacts

The final SHA-256 hashes are:

```text
64c862cf0a48442408c5b49b30df6c81694563533a22fa0bdaae96c0e055ac42  certificates/k2_profile327_n3_simultaneous_jet_frontier.md
eacac05fac5666ddbc89478558152508792d61f918b23f025118e47c8fbd0781  certificates/k2_profile327_n3_simultaneous_jet_checks.py
9c1fb346d720b9627adecbf48088b914ff545c4fc4db2d95ba9da4d732d007cc  certificates/k2_profile327_n3_simultaneous_jet_checks.log
962f438292380ee04134783ebbbea0e2be0e07b6f121d0ad8d5e1946616d87fc  certificates/k2_profile327_n3_nonintegral_block_exclusion.md
902a8eb44cd8757baf54616ce399e584cca7ba30011b135f85fd46b473dcb2ee  certificates/k2_profile327_n3_nonintegral_block_checks.py
b1bc53e1ed3980a9c763446139e8d89fa33b80367a894d3e0127814fae9fb50d  certificates/k2_profile327_n3_nonintegral_block_checks.log
```

The simultaneous-jet note's mathematical content was hostile-audited before
the final hash; the only later change was its clearly labeled “Subsequent
closure” pointer to the nonintegral-block theorem.  Its checker and log did
not change after the audit.

The nonintegral-block checker has 62 output lines.  The simultaneous-jet
checker has 39 output lines.  Both current outputs are byte-identical to the
recorded logs.

## 3. Status integration already performed

The accepted result has been integrated into:

- [`../../README.md`](../../README.md);
- [`../README.md`](../README.md);
- [`SPEC.md`](SPEC.md);
- [`RESOLUTION.md`](RESOLUTION.md);
- [`certificates/README.md`](certificates/README.md);
- [`certificates/k2_double_dodecic_frontier.md`](certificates/k2_double_dodecic_frontier.md);
- [`certificates/k2_profile327_multiple_nonproper_frontier.md`](certificates/k2_profile327_multiple_nonproper_frontier.md);
- the successor pointer in
  [`certificates/k2_profile327_n3_simultaneous_jet_frontier.md`](certificates/k2_profile327_n3_simultaneous_jet_frontier.md).

The current wording consistently says that the entire proper-high
seven-distinct-singleton row is absent and consistently preserves the open
nonproper-high, repeated-tree, isolated-base, and other-cluster boundaries.
Historical theorem-local statements explaining why an earlier note alone
left \(n=3\) open remain in place and are followed by successor notices.

## 4. Verification state

The complete certificate census before adding this handoff file was:

```text
49 Python checkers
49 recorded logs
51 certificate Markdown files
53 Problem D Markdown files
```

This handoff itself makes the last count 54.  It is not a theorem
certificate and is not listed in the checker manifests.

Both command manifests enumerate exactly the same 49 scripts as the
filesystem, with no duplicates, omissions, or extras:

- [`certificates/README.md`](certificates/README.md);
- [`RESOLUTION.md`](RESOLUTION.md).

The certificate README correctly records one SymPy checker and 48
standard-library checkers.  Script/log basename bijection is exact.

All 49 checkers were replayed with `/opt/homebrew/bin/python3` and compared
byte-for-byte with their logs.  The final result was:

```text
SUMMARY checked=49 failed=0
```

The successful replay used this read-only loop from the repository root:

```zsh
setopt pipefail
cert_dir=problems/D-2d-conic-bundles/certificates
checked=0
failed=0
for script in "$cert_dir"/*.py; do
  log="${script%.py}.log"
  if /opt/homebrew/bin/python3 "$script" 2>/dev/null | cmp - "$log"; then
    echo "PASS ${script:t}"
  else
    echo "FAIL ${script:t}"
    failed=$((failed+1))
  fi
  checked=$((checked+1))
done
echo "SUMMARY checked=$checked failed=$failed"
[[ $failed -eq 0 ]]
```

Additional integrity results before this handoff file was added:

```text
53 Problem D Markdown files
366 local Markdown links
0 broken links
55 files when root/problems READMEs are included
374 local Markdown links in that expanded set
0 broken links in that expanded set
0 TeX delimiter/fence failures
git diff --check: clean
```

Re-run link, delimiter, and `git diff --check` audits after any future edit.

## 5. Current dirty worktree

Do not reset or discard this worktree.  At the pause, `git status --short`
reported the following theorem and integration changes:

```text
 M README.md
 M problems/D-2d-conic-bundles/RESOLUTION.md
 M problems/D-2d-conic-bundles/SPEC.md
 M problems/D-2d-conic-bundles/certificates/README.md
 M problems/D-2d-conic-bundles/certificates/k2_double_dodecic_frontier.md
 M problems/D-2d-conic-bundles/certificates/k2_profile327_multiple_nonproper_frontier.md
 M problems/D-2d-conic-bundles/certificates/k2_profile327_n3_simultaneous_jet_checks.log
 M problems/D-2d-conic-bundles/certificates/k2_profile327_n3_simultaneous_jet_checks.py
 M problems/D-2d-conic-bundles/certificates/k2_profile327_n3_simultaneous_jet_frontier.md
 M problems/README.md
?? problems/D-2d-conic-bundles/certificates/k2_profile327_n3_nonintegral_block_checks.log
?? problems/D-2d-conic-bundles/certificates/k2_profile327_n3_nonintegral_block_checks.py
?? problems/D-2d-conic-bundles/certificates/k2_profile327_n3_nonintegral_block_exclusion.md
```

This `HANDOFF.md` is one additional untracked file.  No nonproper-high
research artifact was created.  No commit was made.

## 6. Best next boundary: nonproper high center

The accepted starting point is
[`certificates/k2_profile327_nonproper_high_reduction.md`](certificates/k2_profile327_nonproper_high_reduction.md).
It proves that the high center is a free chain \(p<q\) with

\[
(r_p,r_q;m_p,m_q)=(5,6;5,5),
\]

that its cubic point basis is \((2,1)\), and that at most two of the other
six singleton lows are nonproper.  The unfinished target is therefore the
six-singleton row with \(n=0,1,2\).

Two independent agents agreed on the following calculations.  These are a
research checkpoint, **not an accepted theorem**.

### 6.1 Established ledger

- The local high-chain cubic contact is

  \[
  2\cdot5+1\cdot5=15.
  \]

- The high point basis has length four; together with six simple low
  origins, the cubic cluster has length ten.  Cubic evaluation is an
  isomorphism, giving six singleton-deleted projective cubics \(C_i\).
- If an integral deleted cubic contains \(s\) selected nonproper origins,
  then

  \[
  R_C=35-s,\qquad
  \dim(\text{determinant target})=2+s,\qquad
  \operatorname {codim}_{54}=29-s.
  \]

- For a nonproper deletion, the outside six-jet gives effective codimension
  six.  This gives integral-cubic margins two for \(n=1\) and one for
  \(n=2\).
- For a proper deletion:
  - \(n=0\): fixed codimension 29 plus the proper outside four-jet gives
    margin one, including the all-unbalanced-pencil alternative;
  - \(n=1\): fixed codimension 28 plus one selected transverse six-jet gives
    margin one;
  - \(n=2\): fixed codimension 27 plus the accepted two-line bound
    \(6-e\), against moving dimension \(32-e\), gives margin one.
- The factorwise high contacts are \((10,5)\) for a line plus conic and
  \((10,5,0)\) for three lines.  The corresponding low-weight capacities
  are

  \[
  (2,19),\qquad (7,14),\qquad (2,7,12).
  \]

- Reduced nonintegral cubics without a branch component have a candidate
  fixed bound

  \[
  \operatorname {codim}_{54}\ge26-s-j,
  \]

  where \(j\) counts unbalanced line factors.  Candidate configuration
  dimensions are at most twelve for line--conic and eleven for three-line
  factorizations.
- The branch-free geometric possibilities reduce to:
  - \(T_0\cup Q\), with no low on \(T_0\) and all five selected lows on a
    transverse conic;
  - a conic tangent to \(T_0\) plus a transverse \(p\)-line carrying one or
    two lows, necessarily involving nonproper lows;
  - \(T_0\cup L\cup M\), with low distribution \((0,2,3)\), where the pair
    contains a nonproper low.
- Nonreduced cubics should always supply a low-degree branch factor.

### 6.2 Promising unproved lemma

If \(T_0\nmid C\), then \(C|_{T_0}\) has order exactly three at \(p\), so
extension differences restrict to the high line as \(t^3S\).  The proposed
translate-uniform lemma is that

\[
\det(Q+t^3S)=0\pmod {t^{10}}
\]

cuts codimension at least two for every affine translate and for both
splittings of the kernel on \(T_0\).

The suggested proof separates
\(r=\min\operatorname {ord}(Q)\le2\), where two determinant coefficients
should be triangular, from \(r\ge3\), where one reduces to the determinant
condition on arbitrary first jets.  This argument has **not** been written
or hostile-audited.  It must be made uniform in all leading-rank, zero,
unbalanced, and affine-tail strata.

Conditional on this lemma and a complete three-line/gluing audit, every
branch-free factorization is excluded except possibly one proper-deleted

\[
C_i=T_0Q_i
\]

with \(Q_i\) integral.  At most one such exception should occur: two such
conics share \(p\) and four common low origins, so Bézout makes them equal,
and equality violates the omitted-point condition.

The proposed final common-support argument is then:

- at least five of the six linearly independent cubics have a low-degree
  branch factor;
- the low-degree factor-pair theorem forces those factors to be one common
  component \(H\);
- the \(H\)-divisible cubic subspace has dimension at most three for a
  conic \(H\), and at most two, four, or five for a line according as
  \(p\notin H\), \(p\in H\ne T_0\), or \(H=T_0\);
- in the last case the sole exceptional cubic is also \(T_0\)-divisible,
  which would put all six independent cubics in a five-dimensional space.

### 6.3 Required hostile audit before acceptance

Do not promote the preceding outline to theorem status until all of the
following are proved:

1. the translate-uniform high-line lemma in both splitting types and every
   affine/rank boundary;
2. the exact determinant gluing for concurrent/tangent three-line rows;
3. a disjoint allocation of factor-line, high-line, outside-line, and
   selected-line splitting conditions;
4. the rows where an unbalanced factor line coincides with a selected marked
   tangent (following the tangent should add contact three, but the
   exhaustion is not yet written);
5. the exceptional \(T_0Q_i\) classification, including reducible and
   nonreduced boundaries;
6. the six-cubic linear-independence/common-support dimension argument.

The recommended artifact names, only after those audits pass, are:

```text
certificates/k2_profile327_nonproper_high_singleton_exclusion.md
certificates/k2_profile327_nonproper_high_singleton_checks.py
certificates/k2_profile327_nonproper_high_singleton_checks.log
```

## 7. Broader remaining frontier

The authoritative current boundary is in [`SPEC.md`](SPEC.md),
[`RESOLUTION.md`](RESOLUTION.md), and
[`certificates/k2_double_dodecic_frontier.md`](certificates/k2_double_dodecic_frontier.md).
In particular:

- the two primitive squarefree profiles remain
  \([3^2,2^4]\) and \([3,2^7]\), although many subrows are excluded;
- for \([3,2^7]\), nonproper-high, repeated-essential-tree, isolated-base,
  and other cluster rows remain beyond the newly closed proper-high
  seven-distinct-singleton row;
- the isolated-base squared-line row \(e=1\) and combined branch/base
  clusters remain;
- the global \(k\ge2\) and Problem D headline remain open;
- on the D3 side, open-residual fold/cusp and higher-Morin models, isolated
  multiple-value collisions, and other covariant constructions remain.

No surviving stratum is asserted to exist merely because the current
incidence arguments have not excluded it.

## 8. Safe re-entry checklist

1. Start in `/Users/worker/unirational`; do not work only from the original
   `problems/B-conic-bundle-multisections` shell directory.
2. Read this file, then reopen [`SPEC.md`](SPEC.md),
   [`RESOLUTION.md`](RESOLUTION.md), and the exact certificate notes named
   above.  Treat the current files, not this prose alone, as authoritative.
3. Run `git status --short` and preserve every existing modification and
   untracked theorem artifact.
4. Re-run the 49-checker byte comparison and repository link/delimiter/diff
   audits before changing status claims.
5. Attack the translate-uniform high-line lemma first.  If it fails, record
   the exact affine/rank counter-row rather than weakening the claimed final
   objective.
6. Obtain an independent hostile audit before integrating any nonproper-high
   exclusion into the main status files.
7. Keep the active objective open.  Do not mark Problem D complete unless a
   requirement-by-requirement audit of [`SPEC.md`](SPEC.md) proves the full
   headline and every named remaining boundary.
