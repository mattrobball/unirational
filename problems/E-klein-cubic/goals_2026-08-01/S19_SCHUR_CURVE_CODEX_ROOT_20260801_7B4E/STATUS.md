S19-NO-CURVE-SCOPED

# Status — literal S19 target is empty

## Binary verdict

No curve satisfies every condition of the exact target in
`GOAL_S19_SCHUR_CURVE.md`.  The target requires

\[
C\subset X_F\cap M,
\]

while the incorporated `BR-SCHUR19-POS` definition requires that no
irreducible component of the curve lie in \(X_F\) and that its intersection
with \(X_F\) be zero-dimensional.

Indeed, if \(I_C\) is the homogeneous ideal of \(C\subset M\) and
\(X_F=V(f_3)\), containment gives \(f_3\in I_C\).  Therefore

\[
I_{C\cap X_F}=I_C+(f_3)=I_C,
\]

so \(C\cap X_F=C\) is one-dimensional, not a proper intersection of length
57.  The residual expression of length \(57-55=2\) is unavailable.
Equivalently, a geometrically integral \(C\subset X_F\) has its unique
geometric component in \(X_F\), directly contradicting qualification Q3.

The contradiction is independent of Rao data and commutes with every field
extension.  Hence the literal goal-qualified locus is empty in both live Rao
branches `epsilon_0` and `epsilon_1`, over \(F=K_{\rm Schur}\) and over
\(\bar F\).

## Exact scope

This is not an emptiness theorem for the coherent ambient-curve problem.
That corrected problem asks for

\[
B\subset M,\qquad B\not\subset X_F,\qquad
Z_{55}\subset B\cap X_F
\]

with multiplicity one at every marked point.  The upstream packet records
both non-ACM Rao branches of that corrected problem as undecided.  No rational
point is constructed and the PSL\((2,11)\)-unirationality headline remains
**OPEN**.

## Repository state

- Pinned mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`
- Live commit consumed: `2140419410cfff2f7d7dcca166acef8c16a0d41b`
- Goal-introducing commit: `67218b64ed1bf727f13bdcd7639c8651cd374897`
- Produced commit: **NONE** — this is an isolated uncommitted packet; no
  repository metadata or sibling path was modified.

## Replay

From this directory:

```text
python3 produce_certificate.py --check
python3 verify.py
```

Expected final markers:

```text
S19_LITERAL_TARGET_IDEAL_CONTRADICTION_OK
S19_BOTH_GOAL_QUALIFIED_BRANCHES_EMPTY_OK
S19_NO_CURVE_SCOPED_VERIFY_OK
HEADLINE_OPEN
```
