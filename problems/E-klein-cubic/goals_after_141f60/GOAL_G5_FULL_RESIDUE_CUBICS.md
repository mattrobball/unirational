# Goal G5 — decide the full `f5` and `f6` residue cubics

**Pinned state:** `141f6042f628f984771fc79d8d16beb12cedcb94`  
**Priority:** 5  
**Headline direction:** negative  
**Accepted structural input:** `V3-RESIDUE-NORMAL-FORM-PASS`

## Mission

Decide the genuine five-coordinate residue twist at one of the two remaining
full-decomposition divisors

```text
f5 = 0,
f6 = 0.
```

By V3, these are the smallest installed full-`G` valuation sites still capable
of being negative.  Pointlessness of either smooth residue cubic gives a
pointless henselian completion of the generic twist and closes Problem E
negatively.  A residue point proves only local solubility and retires that
site.

## Binding inputs

Consume and hash:

```text
goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/
goal_runs_after_35fa/G_UNIVERSAL/
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
goals_2026-08-01/V_VALUATION_TROPICAL_CODEX_ROOT_20260801/
```

For `f5`, also consume the exact degree-16 support-at-most-five exclusion as a
retired bounded fact.  It is not a model of the full residue cubic.

## G5.0 — exact valuation and residue fields

For each divisor separately:

1. construct the corresponding rank-one valuation of `K_proj` from the
   invariant quotient, including its center and uniformizer;
2. prove inertia is trivial and the decomposition group is the full `G`;
3. identify the residue field and its transcendence basis over `C`;
4. construct the genuine residue `G`-torsor, not merely the reduction of a
   chosen Hilbert--90 matrix;
5. prove the residue field/model is independent of all gauge choices on the
   common open.

If the generic divisor is reducible or has several valuations, separate every
component and state which one is being used.

Required marker:

```text
G5-RESIDUE-TORSOR-MODEL-PASS
```

## G5.1 — specialize the universal cubic

Reduce the G3 normalized cubic coefficientwise at the chosen valuation.
Produce an exact residue cubic

\[
\overline X_{f_i}=V(\overline\Phi_{f_i})
\subset\mathbf P^4_{\kappa_i}.
\]

Requirements:

1. choose integral coordinates with at least one unit coefficient;
2. specialize all 35 coefficients through the authoritative secondary-basis
   multiplication table;
3. remove common powers of the uniformizer without changing the projective
   model;
4. verify directly that the result agrees with reduction of the genuine
   Hilbert--90 twist;
5. prove smoothness over the residue field or classify every singular branch;
6. verify the residue has index one using the universal cycles, without
   claiming a point.

Deliver compact exact equations usable by G3's chart, line/conic, and polar
workers over the residue field.

Required markers:

```text
G5-F5-CUBIC-MODEL-PASS
G5-F6-CUBIC-MODEL-PASS
```

as applicable.

## G5.2 — direct residue decision

Apply the G3 arithmetic lanes to the lower-dimensional residue field.

### Lane A — rational point

Search projective charts, line and conic Fano schemes, polar geometry, and
rational fibrations.  A residue point must be verified exactly and then lifted
by smooth Hensel lifting to the genuine completion.  Record local solubility
only; do not promote it to a global point.

### Lane B — exact pointlessness

Permitted obstructions are:

- a complete anisotropic fibration invariant;
- a point-dependent torsor not killed by Q2.1;
- an exact specialization to a known pointless smooth cubic;
- a complete descent/classification of rational points on the residue model;
- a second unramified valuation whose terminal residue is proved pointless.

Any iterated valuation must respect V3: ramified, `C1`, or rank-at-least-three
branches are automatically soluble and cannot be used as terminal negatives.

### Lane C — recursive boundary analysis

Factor the discriminants of the most promising residue fibrations and build a
finite tree of unramified rank-one or Abhyankar rank-two sites.  At each leaf,
compute the actual residue field and decomposition group.  Stop branches as
soon as V3 forces solubility.  A finite tropical tree without final residue
anisotropy is not a decision.

## G5.3 — global negative bridge

For a pointless residue cubic:

1. verify the torsor and smooth cubic extend over the henselian valuation
   ring;
2. use properness and smooth Hensel equivalence to prove the generic
   completion has no point;
3. identify this completion as a scalar extension of the genuine generic
   Klein twist;
4. conclude `X_gen(K_proj)=empty` and invoke G3's source-exhaustiveness bridge.

Deliver

```text
BRIDGE_RESIDUE_NEG.md.
```

## Deliverables

Write under

```text
problems/E-klein-cubic/goal_runs_after_141f60/G5_FULL_RESIDUE_CUBICS/
```

Use separate `f5/` and `f6/` subdirectories.  Provide at least:

```text
INPUT_MANIFEST.json
VALUATION_MODELS.md
f5/residue_cubic.json
f6/residue_cubic.json
SMOOTHNESS.md
POINT_SEARCH.md
POINT.md or POINTLESSNESS.md per decided site
BRIDGE_RESIDUE_NEG.md when applicable
produce_residues.py
verify_models.py
verify_decision.py
REPLAY.md
SEAL.json
STATUS.md
```

## Authorized exits

```text
G5-F5-POINTLESS-HEADLINE-NEGATIVE
G5-F6-POINTLESS-HEADLINE-NEGATIVE
G5-F5-RESIDUE-POINT
G5-F6-RESIDUE-POINT
G5-F5-CUBIC-MODEL-PASS
G5-F6-CUBIC-MODEL-PASS
G5-RESIDUE-TORSOR-MODEL-PASS
G5-UNDECIDED
G5-CANONICAL-INPUT-FAIL
```

Only the two pointless exits are headline candidates.
