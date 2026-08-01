S19-NO-CURVE-SCOPED

# Status — literal S19 target is empty

**Headline:** OPEN.  This is not a proof of non-unirationality of the Klein
cubic and is not an emptiness theorem for the corrected ambient-curve marked
Hilbert problem.

**Repository commit consumed:**
`80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c`

**Goal-file commit consumed:**
`67218b64ed1bf727f13bdcd7639c8651cd374897`

**Commit produced:** none for the final audit refinement.  Commit
`80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c` is the repository waypoint that
first contains the core isolated packet; the current worktree may contain the
later completion-audit refinement.

## Binary verdict

No curve can satisfy all conditions in the exact target of
`GOAL_S19_SCHUR_CURVE.md`.  The target requires

\[
C\subset X_F\cap M,
\]

whereas the incorporated definition of a qualifying curve requires that no
irreducible component lie in `X_T` and that the intersection with `X_T` be
zero-dimensional.  If `I_C` is the homogeneous ideal of `C` and `X_F` is cut
out by the cubic `f3`, containment gives `f3 in I_C`; hence

\[
I_{C\cap X_F}=I_C+(f_3)=I_C.
\]

Thus `C cap X_F = C` scheme-theoretically and has dimension one, not length
57.  The residual expression of length `57-55=2` is not defined.  Equivalently,
the unique geometric component of a geometrically integral `C` lies in `X_F`,
directly contradicting qualification condition Q3.

The contradiction is independent of Rao data.  It therefore empties the
literal goal-qualified locus in both live branches `epsilon=0` and
`epsilon=1`, over `F=K_Schur` and after every field extension.

## Exact scope

The intended, mathematically coherent rescue problem replaces the containment
condition by

\[
C\subset M,\qquad C\not\subset X_F,\qquad
Z\subset C\cap X_F
\]

with multiplicity one at all 55 marked points.  The existing upstream packet
states that the two Rao branches of this corrected problem remain undecided.
Nothing here closes those corrected branches or the headline problem.

## Replay

From this directory:

```text
/usr/bin/python3 produce_certificate.py --check
/usr/bin/python3 verify.py
```

Expected final markers:

```text
S19_LITERAL_TARGET_IDEAL_CONTRADICTION_OK
S19_BOTH_GOAL_QUALIFIED_BRANCHES_EMPTY_OK
S19_NO_CURVE_SCOPED_VERIFY_OK
HEADLINE_OPEN
```
