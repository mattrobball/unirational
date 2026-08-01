# Worklog

## Isolation event

- Initial HEAD: `2140419410cfff2f7d7dcca166acef8c16a0d41b`.
- Live waypoint after concurrent work: `80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c`.
- Collision: another worker wrote to `Q_SCHUR_DESCENT/` while this run was
  active.  That directory is now read-only input for this run.
- Unique output root: `Q_SCHUR_DESCENT_CODEX_ROOT_20260801_5F31/`.

## Exact checks already replayed

The following independent parent-repository checkers completed successfully
before the waypoint re-audit:

- `tmp/schur_unrestricted_point_attack_audit/verify.py`;
- `tmp/schur_structural_routes/verify.py`;
- `tmp/schur_fibration_picard_obstruction/verify.py`;
- `certificates/subgroup_orbit_check.py`.

They certify the exact degree-55 line orbit and its core-free residue field,
the standard effective zero-cycles, the ten coordinate genus-one fibrations,
and the relevant subgroup exclusions.  Their scope does **not** decide whether
the full twist has a rational point.

## Current mathematical boundary

The full Schur twist has an exact closed point of degree 55 and effective
cycles of degrees 60, 132, 165, and 220, so its index is one.  The signed
identities

`-13*60 + 3*132 + 165 + 220 = 1` and `55 - 18*3 = 1`

do not supply an effective degree-one point.  The standard Picard, Brauer,
Albanese, stable-cohomology, and higher-Amitsur obstructions already vanish.
Ten genus-one fibration generic fibres have period and index three, but that
does not obstruct points on special fibres or on the total threefold.

Status at isolation: neither accepted terminal outcome has yet been proved.

## Strengthened quartic frontier

The exact degree-55 line-orbit point can be restricted to a general smooth
cubic-surface hyperplane section while retaining a connected degree-55
residue field.  Voisin's cubic-surface theorem then gives the unconditional
alternative

`X_Schur(K_Schur) != empty OR X_Schur has an integral degree-4 closed point`.

The integrality in the no-point branch follows because a degree-one component
is already a rational point and a quadratic point on a cubic hypersurface
produces the rational residual point on its conjugate secant line.  This is a
strict improvement over the bare index-one statement, but it does not decide
which side of the alternative occurs.  Exact details and replay are in
`QUARTIC_FRONTIER.md` and `verify_quartic_frontier.py`.

The no-point branch is narrower still: the quartic residue field cannot have
an intermediate quadratic field, since two successive quadratic secant
descents would give a `K_Schur`-point.  Exact enumeration of the transitive
subgroups of `S4` therefore leaves only primitive Galois closure `A4` or
`S4`.  This refinement also remains nonterminal.

## Complete five-coordinate R8 gate

The first non-ternary low-height gate was run with all five installed Schur
frame columns and the complete four-dimensional `R8` invariant coefficient
space.  The resulting 20-variable homogeneous landing system has exact sampled
row rank 700 over the good fibre `(23, zeta_11=2)`.  Exact `msolve` completed;
its leading ideal contains `a0^3,...,a19^3`.  Thus the projective landing locus
for this entire ansatz is empty, and proper specialization excludes the same
ansatz in characteristic zero.

Replay:

```sh
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r8.py build --samples 2500 --stagnant 160
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r8.py solve --timeout 300 --threads 4
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  verify_full_frame_r8.py
```

This is a bounded coefficient-degree-eight exclusion, not an all-height
pointlessness theorem and not a terminal outcome under the governing goal.

## Full-frame R10 and first R12 enlargement

The complete four-dimensional `R10` coefficient space on all five frame
columns is also projectively empty.  Its 700-dimensional sampled landing row
space is exactly the same as the independently generated `R8` row space, and
its leading ideal again contains the cube of every one of the 20 variables.
See `FULL_FRAME_R10_REPORT.md` and `verify_full_frame_r10.py`.

At degree 12 the complete scalar invariant space jumps to dimension 14.  One
explicit five-dimensional Reynolds slice on all five frame columns was tested
as a 25-variable system.  Its exact row rank is 1,225 and its leading ideal
contains the cube of every variable, proving that displayed slice empty.  The
scope is only that five-dimensional slice: the other nine scalar directions,
the non-scalar primitive covariants, and all higher degrees remain open.  See
`FULL_FRAME_R12D5_REPORT.md` and `verify_full_frame_r12d5.py`.

## Primitive quartic span and tangent-curve audit

The no-point quartic frontier was sharpened once more.  An integral quartic
point spanning a plane lies on a ground-field plane conic whose proper
intersection with the plane cubic leaves an effective degree-two cycle; the
usual secant construction then gives a rational point.  Spans of dimension at
most one also give a point or a contained ground-field line.  Hence the only
surviving quartic is linearly independent and spans the full `P3` hyperplane.

Choosing a primitive element of its quartic field identifies its four
coordinates with a power basis, hence puts the point on a `K`-defined
transport of the rational normal cubic.  Proper intersection with the cubic
surface has degree nine.  In the no-point branch the pullback has the quartic
factor with multiplicity one and an irreducible quintic residual: every other
partition of five contains a degree-one or degree-two component.  This gives
an exact integral `4+5` incidence ledger, but still no effective degree one.

A natural successor was tested exactly: choose a twisted cubic through the
four conjugates and require double contact with the cubic surface at all four.
After moving the points to the coordinate vertices, tangency is a 4-by-4
linear system in the coordinate scales; its determinant, after removing
boundary factors, is a quartic in the cross ratio.  Each tangent curve has one
residual intersection point, so the construction produces another quartic
cycle rather than a point unless additional geometry intervenes.

Three deterministic smooth cubic surfaces give separable `S4` tangency
quartics and nonzero residual span determinants.  They refute automatic
coplanarity of the residual quartic.  The independent checker reconstructs
the first smooth surface, tangency determinant, residual factorization, and
span determinant from exact rational arithmetic.  See
`QUARTIC_TANGENT_AUDIT.md` and `verify_quartic_tangent_probe.py`.  This closes
the shortcut only; it does not instantiate or decide the unknown Schur
quartic.

The possible descent-datum loophole was then tested separately.  The
irreducible quartic `u^4-u+1` has discriminant 229 and Galois group `S4`; the
power-basis point `[1:u:u^2:u^3]` spans `P3` and lies on one explicit smooth
rational cubic surface.  `probe_primitive_quartic_tangent.gp` builds the
degree-24 splitting field and proves that the associated tangent scheme is
quartic, separable, and has a residual quartic with nonzero span determinant.
`verify_primitive_quartic_tangent.py` independently checks the Galois group,
incidence, surface smoothness, rational-point scope, and clean GP replay.
Thus a primitive `S4` input alone does not force the residual into a plane.
The example surface has a rational point, so this remains a shortcut
refutation rather than a pointless-surface construction.
