# Klein cubic — execution goals after `0aecc89`

**Audited state:** `main @ 0aecc89f0598cfd982295107352e6cc6e9fb04e9`  
**Date:** 2026-08-02  
**Problem E headline:** **OPEN**

This folder refines, and does not replace,
[`goals_after_141f60/`](../goals_after_141f60/).  The earlier folder correctly
records the post-G2 route portfolio.  The present folder isolates the first
small packets that should actually be dispatched and adds one cross-class
route not separately present there.

## 1. Binding state

The following facts are now consumed as settled.

1. `G2-FINITE-GENERATION-PASS` proves exact equivalence among

   ```text
   a K_proj-point of the generic Klein twist X_gen=V(Phi),
   a G-equivariant rational map P(W) --> X,
   a nonzero homogeneous landing covariant in some degree,
   and a primitive landing covariant modulo constants.
   ```

   The complete all-degree problem is therefore the rational-point problem for
   one explicit cubic with 35 coefficients over `K_proj`.  No further
   universal-object theorem, multi-Rees theorem, or finite first-degree bound
   is needed.

2. `V3` puts every possible valuation obstruction into normal form.  A
   henselian nonpoint must be unramified, have non-`C1` residue, rational and
   Krull rank at most two, and decomposition group `G` or maximal `11:5`.
   The only residue cubics left are the full `f5`, full `f6`, and the genuine
   `11:5` trace cubic.

3. Both nonconjugate maximal `A5` classes have exact generic-twist points.
   For a generic `G`-torsor, each class therefore produces an induced
   degree-eleven closed point of `X_gen`.  Goal G4 treats the two induced
   cycles separately.  Their **cross-incidence geometry** is not yet isolated
   as its own exact task.

4. `B-BRIDGE-REFUTED` forbids promotion of fixed-frame pointlessness to the
   genuine Fano or Klein twist by the proposed exhaustiveness mechanism.

5. Q2.1 closes standard transfer-compatible descent obstructions.  Any new
   negative obstruction must be an actual pointless residue cubic or a
   genuinely point-dependent/non-transfer construction.

6. The goal files G3, C6, G4, H6, G5, Q3, and R0 have landed, but no result
   packet from those new missions had landed at this audit.

## 2. Why another folder is useful

The post-`141f60` goals are intentionally broad.  A local worker should not be
asked simultaneously to reconstruct the exact invariant field, settle the
headline dominance bridge, search five projective charts, compute the Fano
surface of lines, and discover a new obstruction.  The first two G3 gates are
mechanical enough to separate and are dependencies of every later point
search.

There is also a new finite group-geometric interface.  The two maximal `A5`
classes give two eleven-element coset sets.  Exact group theory is expected to
make their cross-incidence the symmetric `2-(11,5,2)` design, with incidence
matrix `N` satisfying

```text
N*N^t = 3*I + 2*J.
```

This is only motivation until reconstructed from the installed group.  If it
holds, the design gives canonical maps between the two degree-eleven etale
algebras and between their two `5+5` augmentation constituents.  Applying
those maps to the two exact point cycles supplies operations unavailable from
one `A5` class alone.

## 3. Dispatch order

| Priority | Goal | Dependency | Target |
|---:|---|---|---|
| 0 | `G3A` exact arithmetic and dominance | G2 | authoritative `K_proj` engine and final point-to-headline bridge |
| 1 | `G7A` double-`A5` design | group and H2/H3 packets | exact cross-incidence and projectors |
| 2 | `G3P` polar/odd-degree descent | G3A; may consume G4 | a direct point or a rational quadric/conic fibration |
| 3 | `G7B` induced double cycle | G4 induced-cycle output + G7A | both eleven-point cycles in one exact algebraic interface |
| 4 | `G7C` cross-residual geometry | G7B | a `K_proj`-point, line, conic, or lower-degree effective cycle |
| 5 | integration | all returned packets | headline promotion or the next smallest gate |

`G3A` and `G7A` are independent and should run immediately in parallel.
`G3P` may begin its formal polar calculations after `G3A`; its use of the
induced `A5` point waits for G4.  `G7B` and `G7C` are sequential.

## 4. Local-runner rules

- Run all CAS locally.  Do not create or invoke GitHub Actions or hosted CAS.
- Each worker writes only under its assigned directory in
  `goal_runs_after_0aecc89/`.
- At most one unrelated memory-heavy job may run at a time.  Existing T3
  normalization work retains its own serialized heavy slot.
- Bind every input by repository path and SHA-256 hash.
- Producers and verifiers must be independent.  A verifier may not certify a
  rank, dimension, factorization, or point merely by reading a stored value.
- Modular calculations are discovery unless accompanied by exact
  reconstruction or a proved specialization implication in the correct
  direction.
- Timeouts, OOMs, killed processes, empty output, and solver crashes are
  nonverdicts.
- Do not edit sealed historical packets.  Record corrections beside them.
- Re-fetch `main` before starting.  If a named dependency has returned, consume
  it rather than repeating its work.

## 5. Headline exits

The only headline candidates in this folder are

```text
G3P-POINT-HEADLINE-POSITIVE
G7-POINT-HEADLINE-POSITIVE
G7-EFFECTIVE-DEGREE2-HEADLINE-POSITIVE
```

A degree-eleven point, a design identity, a rational tensor, a modular point,
or a fixed-frame theorem is not a headline.

No new negative headline mission is introduced here.  H6 and G5 already own
all valuation sites surviving V3; duplicating them would weaken rather than
broaden the search.