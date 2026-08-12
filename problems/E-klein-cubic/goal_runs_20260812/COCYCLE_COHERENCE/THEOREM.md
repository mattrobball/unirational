# The cocycle layer: 2-chain coherence is already implied

**Packet:** `goal_runs_20260812/COCYCLE_COHERENCE/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

> # VERDICT: **COCYCLE-ALREADY-IMPLIED**
>
> The existing Stage-1 canon/transversal scheme, together with pairwise arc
> consistency on all 145 order-0 closure edges and the evaluation-table join,
> already forces the 2-chain (triangle) cocycle condition on value assignments.
> The triangle layer adds no cut. Joint residue table `J` is unchanged; the
> degree-35 class (1264 census, 22-anchor) is unchanged.

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
COCYCLE-ALREADY-IMPLIED
COCYCLE-NO-DEGREE-EXCLUSION
COCYCLE-J-IDENTITY
COCYCLE-D35-UNCHANGED
```

Machine markers: `COCYCLE_COHERENCE_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — both primes `p = 331, 661`).

---

## Summary (≤ 25 lines)

1. **Audit first (mandatory).** What is imposed, with line refs: BFS transversals
   (`s1source.py:337-357`); pairwise cons `(child, Id, parent, tr[j])`
   (`s1enum.py:164-169`); arc consistency (`s1enum.py:160-187`); `img_contains`
   (`s1enum.py:130-157`); block enumeration (`s1enum.py:211-239`); evaluation
   kids carry `tr` (`s1coherence.py:196-197`); own-frame transport
   (`s1recount.py:64-69`, `s3sweep.py:166-172`); join = edges + tables
   (`s1recount.py:93-200`). No separate 2-chain predicate in code.
2. **Poset fact (machine, both primes):** 145 orbit edges; **66** triangles;
   **`missing_direct = 0`** — every 2-chain has its long edge among the 145.
3. **BFS section:** stored transversals rebuild exactly from the generator BFS
   (`n_fail = 0`, all 11076 components covered).
4. **Geometric 2-chain section:** for every component triangle
   `c.rep < j_m < k' = tr_m · k0`, `transversal[k'] = tr_m * tr_k0` up to right
   mult by setwise stab of the parent rep (`66/66` ok; strict equality on 25–27).
5. **Point lemma.** On any triangle with all three edges constrained, any
   point-valued assignment satisfying the three pairwise `img_contains`
   equalities is automatically path-independent: composed transport equals
   direct on that value. Triangle = conjunction of three already-imposed edges.
6. **Dom lemma.** Same for `dom L_σ` (line equality / point-on-line); distinct
   minus-lines are disjoint, so a point determines its line.
7. **Eval lemma.** Usable patterns are single-germ joint evaluations; restriction
   is transitive; child-edge arc failures among 97 patterns: **0**.
8. **Verdict: `COCYCLE-ALREADY-IMPLIED`.** Stop per workorder §B.1. No triangle
   filter; no J re-count.
9. **J before/after (all degrees, residue classes):** identity with sealed
   `TUPLE_JOINT_RESIDUE`: `11594/1408/2018/10752/1596/1264`. Cut `0` every class.
10. **Degree 35 (`ρ = 5`):** J stays 1264; 22-anchor unchanged; dead-1242
    bookkeeping unchanged.
11. **Not claimed:** no degree exclusion; Problem E remains OPEN; this is not a
    Stage-2 single-map coherence cut (§15.4 still stands).

---

## 0. Stakes

Workorder `WORKORDER_COCYCLE_COHERENCE`: a morphism of quotient complexes must
satisfy the cocycle condition on 2-chains, not only pairwise shared-child
value equality after transversal transport. Abstractly pairwise need not imply
triangle. The audit asks whether *this* census's scheme already forces it.

If yes: prove and stop (`COCYCLE-ALREADY-IMPLIED`).
If no: build the triangle layer, re-run the tuple-level `J` census, report
effects at degree 35.

---

## 1. What the machinery imposes (line references)

| mechanism | where | what |
|---|---|---|
| BFS transversals | `s1source.py:337-357` | per G-orbit of source components; rep has `Id`; `tr[t] = g·tr[j]` when `t` first reached as `g·j` |
| Constraint list | `s1enum.py:164-169` | for each row rep and each component `j` above it: `(child, Id, parent_orbit, tr[j])` |
| Arc consistency | `s1enum.py:160-187` | pairwise filter of value sets through `img_contains` |
| Image test | `s1enum.py:130-157` | point-point: label equality after transport; dom: same `L` / point on `L` |
| Block count | `s1enum.py:211-239` | exact enumeration imposing every local edge |
| Evaluation kids | `s1coherence.py:196-197` | `tr = S.transversal[j]` on each child component |
| Own-frame transport | `s1recount.py:64-69`, `s3sweep.py:166-172` | `T.act(matinv(tr), cell, U)` into child row frame |
| Usable filter | `s1recount.py:73-75` | drop eval patterns outside arc-consistent domains |
| Coherent join | `s1recount.py:93-200` | pairwise cons + per-sweep table match |
| 145 relations | `THEOREM.md` §4 (`STAGE1_COMPLEX_MAPS`) | order-0 incidence at component level with transversal bookkeeping |
| Stratum-local note | `THEOREM.md` §15.6(3) | coherence per swept row; between sweeps only via shared values; full single-map coherence is Stage 2 |

**No 2-chain predicate appears in code.** The question is whether the triangle
condition on *assignments* is nonetheless a consequence of the above.

---

## 2. The orbit poset and its 2-chains

An **orbit edge** is a pair of Stage-1 rows `(child, parent)` for which some
component of the parent orbit lies above the child representative
(`s1enum.py:69-96`, `orbit_relations`). There are **145** such edges (both
primes; matches §4).

A **triangle** (orbit 2-chain) is a triple of rows `(c, mid, p)` with edges
`c → mid`, `mid → p`, and — if present — `c → p`.

**Machine (both primes):**

| quantity | 331 | 661 |
|---|---:|---:|
| orbit edges | 145 | 145 |
| triangles (2-chains with long edge) | 66 | 66 |
| 2-chains missing the long edge | **0** | **0** |

So every combinatorial 2-chain of the closure poset already carries its
diagonal among the 145 constraints. The abstract counterexample to
"pairwise ⇒ triangle" (two short edges without the long edge) does not occur
in this poset.

---

## 3. Transversal section identities

### 3.1 BFS rebuild

Rebuilding transversals from the same generators used in
`s1source.py:337-357` reproduces the stored table exactly:
`n_ok = 11076`, `n_fail = 0`, all components covered (both primes).

### 3.2 Geometric 2-chain section

For an orbit triangle `(c, mid, p)` and component witnesses
`j_m` of the mid-orbit above `c.rep` (transversal `tr_m`) and `k0` of the
parent-orbit above `mid.rep` (transversal `tr_k0`), set
`k' = tr_m · k0` (component action). Then `k'` lies above `c.rep`, and

```
transversal[k']  =  tr_m · tr_k0
```

holds strictly or up to right multiplication by an element of the setwise
stabilizer of the parent representative (BFS coset ambiguity).

**Machine:** 66/66 geometric tests ok both primes; strict equality on 25 (p=331)
and 27 (p=661).

This is the group-level content of "composed transversal equals direct, up to
stabilizer" on source indexing.

---

## 4. Lemmas: triangle on assignments is three pairwise edges

### Lemma A (point-valued triangle).

Let `c < mid < p` be an orbit triangle (all three edges among the 145), and let
`val` assign a point value `(cell, lab)` to each of the three rows. The
constraint list carries one or more transversal witnesses per edge; arc
consistency and block enumeration require `img_contains` on **every** witness
(`s1enum.py:174-184`, `229-233`).

Fix a witness triple `(τ_cm, τ_mp, τ_cp)` on which all three point constraints
hold. By `img_contains` for points (`s1enum.py:153-157`):

```
lab_c   = τ_cm · lab_mid
lab_mid = τ_mp · lab_p
lab_c   = τ_cp · lab_p
```

Compose the first two: `lab_c = τ_cm · τ_mp · lab_p`. The third says
`lab_c = τ_cp · lab_p`. Therefore composed transport and direct transport
agree on the assigned parent value.

**The triangle cocycle condition on this assignment is exactly the conjunction
of the three pairwise equalities — already imposed.**

### Lemma B (dom-valued triangle).

If the parent is `("dom", "L", σ)`, `img_contains` requires equality of
transported `L`-labels (dom-dom) or incidence of a point on the transported
`L` (pt-dom) (`s1enum.py:139-146`). Distinct minus-lines are disjoint, so a
point determines its line. Three pairwise incidences/equalities on a triangle
force the composed `L`-identification to equal the direct one. No extra cut.

### Lemma C (evaluation tables).

Each usable evaluation pattern is the joint evaluation of a **single** multiform
germ on all children of a sweep row (`s1coherence.py` classes →
`s1recount.py:51-76`). Restriction of a germ is transitive:
`φ|_{S''} = (φ|_{S'})|_{S''}`. Patterns that fail arc consistency on any
child-edge are dropped (`s1recount.py:73-75`).

**Machine:** 97 usable patterns, **0** child-edge arc failures (both primes).

### Remark (raw transport on arbitrary labels).

Composed and direct own-frame maps may disagree on target labels that no
pairwise-consistent assignment can carry (coset noise: `vtr` disagree counts
are positive). Such labels are excluded by the three pairwise edges before any
triangle filter would see them. They are not a residual cut.

---

## 5. Verdict

**`COCYCLE-ALREADY-IMPLIED`.**

The triangle layer on value assignments is the conjunction of the three pairwise
`img_contains` constraints on every 2-chain of the 145-edge poset. That
conjunction is already enforced by arc consistency and coherent block
enumeration. Evaluation tables are single-germ and arc-closed. Workorder §B.1:
prove and stop — do not build a redundant filter, do not re-run the J census as
a cutting layer.

---

## 6. Consequences for `J` and degree 35

Because the triangle layer adds no cut:

| residue `ρ` | `J` before (sealed) | `J` after | cut |
|---:|---:|---:|---:|
| 0 | 11 594 | 11 594 | 0 |
| 1 | 1 408 | 1 408 | 0 |
| 2 | 2 018 | 2 018 | 0 |
| 3 | 10 752 | 10 752 | 0 |
| 4 | 1 596 | 1 596 | 0 |
| 5 | 1 264 | 1 264 | 0 |

**Degree 35 (`ρ = 5`):** sealed 1264-census and 22-anchor from
`D35_EXTENDED_SIEVE` / `TUPLE_JOINT_RESIDUE` are untouched. Dead-1242
bookkeeping unchanged. No FLAG (no class zero).

---

## 7. Honesty tiering

**Tier 1 — sealed, quoted.** 145 order-0 relations and evaluation-coherence
join from `STAGE1_COMPLEX_MAPS`; corrected `K` and joint `J` from
`STAGE1_STRATIFIED` / `TUPLE_JOINT_RESIDUE`; 22-anchor / 1264 census from
`D35_EXTENDED_SIEVE`.

**Tier 2 — two-prime finite exact.** Orbit triangle census; `missing_direct=0`;
BFS rebuild; geometric 2-chain section; eval arc-closed; core 43008;
cross-prime agreement on all of the above.

**Tier 3 — flagged.** Lemmas A–B are algebra of the published `img_contains`
predicates (no new geometry). The packet does not re-derive Stage-2 global
single-map coherence; §15.4 still marks that as Stage 2.

---

## 8. Not claimed

* No degree exclusion. Problem E remains OPEN.
* No claim that pairwise edge consistency implies 2-cocycle fillers in an
  abstract constraint graph that omits long edges — only that *this* census
  includes every long edge.
* No claim that raw BFS transversals are a strict group homomorphism on the
  nose (coset ambiguity remains; it is absorbed by setwise stabilizers and by
  the pairwise constraints on assignments).
* No Stage-2 single-map coherence; no transport zero; no change to the 22.

---

## 9. Replay

```bash
cd problems/E-klein-cubic/goal_runs_20260812/COCYCLE_COHERENCE
python3 scripts/produce.py 331 661    # writes results/
python3 verifier.py                   # live re-audit both primes
```

python3 only; primes 331 and 661; no gap/gp/sage/magma; no git.

Artefacts: `results/audit_implied.json`, `results/summary.json`,
`results/j_table.txt`.

## Director adjudication (2026-08-12, appended before sealing)

Replayed clean: ALLGREEN. Provenance: executed by a weak-model lane
before the Fable-only rule for morphism work was instituted; the
execution is mechanically sound (verifier replayed by the director) and
the result is an honest null — this layer is now SPENT WITH NO CUT at
the current depth. Landed for the ledger's completeness, not for bite.
