# Goal Q2 — decide the genuine index-one Schur twist

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 9  
**Possible headline directions:** positive or negative, subject to the exact generic-twist bridge

## Mission

Decide whether the genuine generic Schur twist has a rational point. It has a genuine degree-55 closed point and index one, but no rational point is known and pointlessness has not been proved.

This route is broader than the marked degree-19 construction. It may use any exact zero-cycle descent, fibration, torsor, or obstruction on the full twist.

## Work packages

### Q2.0 — canonical genuine twist model

Install the full generic Schur twist over a minimal invariant-field presentation. Verify the exact relation between the degree-55 point, the ten coordinate-line fibrations, and the original Klein twist. Remove all stale language asserting pointlessness from index one.

### Q2.1 — index-one descent obstruction

Compute the obstruction to converting the known coprime-degree zero-cycles into a point. Candidates include:

- elementary obstruction / Picard torsor;
- unramified Brauer group;
- descent under a torus or intermediate Jacobian torsor;
- zero-cycle moving and rational-equivalence classes;
- R-equivalence or universal `CH_0`;
- a concrete torsor attached to the degree-55 orbit.

The usual index is already one and cannot be reused.

### Q2.2 — unrestricted fibration search

The ten coordinate-line genus-one fibrations all have fibre-degree image `3Z` and no section. Search beyond them:

- noncoordinate lines/conics and their blowups;
- pencils selected by the degree-55 point;
- rational surfaces or conic bundles on birational models;
- multisections of degree prime to three;
- direct rational curves through the degree-55 point.

Prove that any selected family is defined over the base field and covers the genuine twist.

### Q2.3 — exact point or pointlessness

#### Point

Construct exact coordinates, substitute into the full twist, and execute the positive generic-twist bridge.

#### Pointlessness

Produce a functorial obstruction applying to the genuine generic twist and every rational point, not merely to the ten fibrations. Execute the negative bridge only after re-auditing versality.

## Exits

```text
Q-SCHUR-POINT-HEADLINE-POSITIVE
Q-SCHUR-POINTLESS-HEADLINE-NEGATIVE
Q-NEW-DESCENT-OBSTRUCTION
Q-NEW-FIBRATION-PASS
Q-UNDECIDED
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/
```

Provide `GENUINE_TWIST.md`, `ZERO_CYCLE_LEDGER.md`, descent/fibration payloads, exact point/obstruction, independent verifiers, and `SEAL.json`.