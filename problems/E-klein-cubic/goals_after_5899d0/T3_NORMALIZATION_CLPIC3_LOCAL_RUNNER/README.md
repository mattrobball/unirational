# T3 — normalization and horizontal `Cl/Pic[3]`

**Dispatch baseline:** `5899d0589c329955fa1b54ffcdd63f5cd80c2483`  
**Execution venue:** local runner only  
**GitHub Actions / hosted CAS:** forbidden  
**Problem E headline:** open  
**Task-B bridge status:** `B-BRIDGE-REFUTED`

## Mission

Finish the normalization and three-primary divisor-class calculation for the
genuine multiplicity-one target branch of the fixed-frame cubic incidence.
The terminal mathematical decision is

```text
(Cl/Pic)[3]_horizontal = 0
```

or an explicit exact horizontal three-primary Weil class.

A vanishing result proves the fixed-frame residual cubic over the selected
branch field has horizontal degree image `3 Z` and hence index three. It does
**not** by itself prove pointlessness of the genuine generic Klein twist:
Task B has now proved that the selected ternary frame is not exhaustive in the
three-dimensional common-isotropic Fano variety. Any headline conversion must
come from a separate direct C/C5 arithmetic theorem, not from this packet.

## Binding object

Work on one common exact open of

```text
S_G = (Q[A,B,Y,Z,u]/(P,P_u))[(ell*P_uu*delta*C*G)^(-1)].
```

Here `P` is the sealed primitive sextic, `G` is the complementary resultant
factor, and `ell`, `P_uu`, `delta`, and `C` are the accepted fold/Cramer gates.
Do not combine `S_2` on `D(G Sigma)` with singular-locus calculations on a
larger or differently saturated scheme.

The corrected candidate dominant singular prime is

```text
p = (QZ,
     B*QZ_Z-NB,
     Y*QZ_Z-NY)
```

over `Q(A,u)`, using the corrected signs and the sealed `QZ/NB/NY` tables.

## Current exact frontier

The following may be consumed after replay:

- the fold is finite birational over the target branch on the accepted open;
- `S_G` is a three-dimensional complete intersection and is `S_2`;
- the corrected degree-six RUR satisfies all six critical equations over
  `Q(A,u)` by the stored interpolation-with-degree-bound certificates;
- `QZ` is irreducible and squarefree over `Q(A,u)`;
- an exact characteristic-zero fibre at `(A,u)=(-6,-6)` is a nonsplit ordinary
  node with normalization residue degree two and conductor exponent one;
- the authoritative fixed-frame discriminant is exact and irreducible;
- exact normalized contact orders already proved are `2` on
  `S=(A-15L,Y-12L)` and `4` on every generic branch above `E=(L,A)`;
- generic local types on the special curves `L`, `D`, and `C` inside `S` have
  no actual-field three-primary class;
- the candidate conductor prime is not contained in the cubic discriminant;
- normalization/local class groups above the raw-target singular curves
  `J1`, `J2`, and `F15`, generic RUR exhaustiveness, and the global
  localization sequence remain open.

## Required result directory

Write all returned computations and proofs under

```text
problems/E-klein-cubic/goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/
```

Do not modify or relabel historical sealed packets. Copy only the minimum
needed data into the result directory and record source hashes.

## Terminal exits

```text
T3-FIXED-FRAME-INDEX3-PASS
T3-DANGEROUS-3-CLASS
T3-NORMALIZATION-PASS-CLPIC3-OPEN
T3-RUR-NOT-EXHAUSTIVE
T3-LOCAL-RUNNER-BLOCKED
```

`T3-FIXED-FRAME-INDEX3-PASS` is a complete T3 success but is not a Problem-E
headline exit. `T3-DANGEROUS-3-CLASS` must contain the exact divisor or local
class and the proof that it is horizontal and survives descent.

Read `WORK_ORDER.md`, `LOCAL_RUNNER_COMMANDS.md`, and
`ACCEPTANCE_MATRIX.md` before starting.
