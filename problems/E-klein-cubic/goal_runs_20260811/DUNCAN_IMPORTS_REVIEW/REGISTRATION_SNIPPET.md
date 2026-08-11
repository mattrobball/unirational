# Proposed NOTEBOOK registration for `DUNCAN_IMPORTS_REVIEW`

**Do not apply blindly.** This packet deliberately did **not** edit
`notebook_build/manifest.json`, and its only edits outside its own directory are
the three citation-drift banners of deliverable 2 (listed in §3 below).
Concurrent sessions have been editing `NOTEBOOK.md` and the manifest; whoever
merges must re-check the `entry` number, re-run
`scripts/check_manifest_parity.py`, and put the NOTEBOOK edit and the manifest
edit in the **same commit** as this packet, per the notebook-maintenance
protocol.

---

## 1. `notebook_build/manifest.json` — append to `records`

```json
{
 "path": "goal_runs_20260811/DUNCAN_IMPORTS_REVIEW",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ANALYTIC-PROOF-REVIEW + spot CAS",
 "primary_exit": "DUNCAN-IMPORTS-REVIEWED-SOUND",
 "superseded_by": null,
 "char0_scope": "The review itself is characteristic-zero throughout, matching the source: the tex works over C, and every external input the two proofs use is char-0 (equivariant resolution of singularities and of indeterminacy, semisimplicity of finite-order elements of PGL_2, Galois descent for a fixed geometric point, Tsen for C(P^1), closedness of rational-chain-equivalence classes on a proper variety over an uncountable char-0 field). The four machine checks are exact finite arithmetic over Z and Q/Z (finite abelian groups, gcd/CRT, integer Newton polyhedra and normal fans) with no prime reduction and no floating point, so they carry no prime dependence at all; they are exhaustive over the stated finite ranges (abelian groups of order <= 100 with <= 3 cyclic factors; all 483672 triples (m,c1,c2) with m <= 120 and gcd(c1,c2,m)=1; 8302 (chi_1,chi_2) configurations over 81 groups of order <= 36; 91 coprime weight pairs (a,b) with a,b <= 12; 940 cyclic and 6366 non-cyclic severing configurations) and are spot checks of finite assertions inside the proofs, NOT proofs of the theorems.",
 "tracked": "main",
 "notes": "In-repo proof review of the two EXTERNAL-UNVERIFIED imports from external_docs/duncan_higher_obstruction_20260805.tex on which DUNCAN_CORNER_F2 and STAGE1_COMPLEX_MAPS depend. BOTH VERDICTS: REVIEWED-SOUND; no gap found; nothing is demoted. (1) thm:pairs 4.1 (D_ij fabulous <=> G_{D_ij} non-cyclic), reviewed step by step through prop:noncyclic_fabulous 4.3, lem:number_theory 4.4 and prop:cyclic_not_fabulous 4.5, plus lem:tree 4.2. The forward direction rests on exactly one fact -- a non-cyclic abelian group has no faithful character, so the subgroup ker(psi_B) acting trivially on each path component B of the fibre tree is non-trivial (tex 802-803); the converse rests on the coprime weighted blowup whose exceptional curve H acts on faithfully (tex 880-884). Two implicit steps supplied in the review: H acts trivially on the coordinates along D_ij because it fixes D_ij pointwise, and 'trivial stabilizer in H' really is 'not in W_nt' because G_w is contained in G_x = H for w over x. (2) prop:rcc_total 4.11 (total RCC for |I| = 2 with rational D_I), reviewed step by step including the Serre tree fixed-point step (correct even when the edge is inverted: the two components swap but their unique node is fixed), the Severi-Brauer/Tsen step, and the Kollar closedness upgrade; the load-bearing choice is that the rational curve C is required to MEET the good open set, which is what makes the geometric generic fibre of Z_C -> P^1 a tree. Also audited thm:fabulous 3.8, whose proof objects prop:rcc_total consumes. FOUR HYGIENE ITEMS, none a gap: prop:rcc_total does not restate the inherited hypothesis 'D_I is fabulous' (cor:pn_resolved 4.16 supplies it); its proof does not treat dim D_I = 0 (immediate there); 'a general line through two general preimages' is unique, the genericity is in the two points; prop:noncyclic_fabulous quotes lem:tree for Phi rather than Phi_red. THREE USAGE CONDITIONS recorded for the dependent packets: the standing convention G_{D_i} != 1 must hold for BOTH divisors of a corner or thm:pairs does not apply; the RCC conclusion is about T_I^dagger (the image of the DOMINATING components), not T_I; and on a resolution of P^N the rationality of D_I needs a stabilizer-stratified tower (def:stratified_tower 4.14 + lem:rational_strata_propagate 4.15, packaged as cor:pn_resolved 4.16), not lem:linear_strata 4.10. Consequence for the packets: DUNCAN_CORNER_F2's claim A, (F2) and Theorem E stand, and STAGE1_COMPLEX_MAPS' Z+ type-II exclusion stands; both may be re-graded EXTERNAL-UNVERIFIED -> IMPORT-REVIEWED (in-repo, analytic). SECONDARY: the tex numbering was recomputed from the shared [section] counter (31 labels, 0 mismatches), confirming all eight numbers recorded at NOTEBOOK.md:6459-6467, and three <= 6-line correction banners were inserted (NOTEBOOK.md:19-24, theory/FIX_I_bcomplex.md:243-248, theory/FIX_T_gate.md:272-277) mapping old-draft numbers to current labels; no history rewritten, no existing citation edited. TERTIARY: the Tschinkel-Zhang pin for V14_MAP_DICHOTOMY Theorem B is PARTIAL, exit TZ-CHI-PI-PIN-PARTIAL. chi_Pi is TZ eq. (3.3) p. 7 (attributed to [Kuz04, Remark 2.19]); TZ imposes NO genericity on Pi (genericity attaches to the net f), so the packet's 'general L-rational hyperplane' is more conservative than the source and is safe because L is infinite. NOT FLAGGED for analyticity: the paper contains no Hodge-theoretic, transcendental, monodromy or topological step anywhere in its own text, and TZ Remark 3.1 p. 7 says explicitly that the underlying proof is linear algebra, which is also what it leans on for equivariance ('their constructions are canonical', p. 8) and hence for descent. TWO OPEN ITEMS instead: TZ's declared base field is 'an algebraically closed field k of characteristic zero' (p. 1), so applying the construction over the non-closed L is our step, not TZ's; and TZ records the genuine arithmetic caveat itself in Remark 3.2 p. 8 (over a nonclosed field a smooth cubic threefold is Pfaffian iff it carries an elliptic normal quintic defined over k, [Bea00, Thm 8.2]), so the packet's load-bearing hypothesis is the existence of an L-RATIONAL regular net f, which it should state. The terminal source [Kuz04, Rem. 2.19] is not in external_docs/ and closing the pin tight requires ingesting it. Machine: 5 scripts, 5/5 PASS, 0 failures. NO HEADLINE CLAIM; Problem E remains OPEN."
}
```

## 2. `NOTEBOOK.md` — proposed log entry

Place in the 2026-08-11 wave, cross-referenced from the `DUNCAN_CORNER_F2` and
`STAGE1_COMPLEX_MAPS` entries.

```markdown
### `DUNCAN_IMPORTS_REVIEW` (08-11, `goal_runs_20260811/`) — the two Duncan imports, reviewed

**No headline claim.** Problem E remains OPEN. What changes is a grade, not a
verdict: `thm:pairs` and `prop:rcc_total` were graded *"import candidates
pending our own proof review"*; that review is now done and both are
**REVIEWED-SOUND**. No gap was found, so nothing is demoted — `(F2)` on `Z⁺`
and Theorem E of the corner packet stand, and the label on them moves from
EXTERNAL-UNVERIFIED to **IMPORT-REVIEWED (in-repo, analytic)**.

1. **`thm:pairs` 4.1 turns on one fact.** A non-cyclic abelian group has no
   faithful character, so on every component `B` of the path joining
   `D̃_i ∩ Φ` to `D̃_j ∩ Φ` inside the fibre tree, the subgroup `ker ψ_B` acting
   trivially on `B` is non-trivial and `B ⊆ W_nt` (tex 802–803). The converse
   is the coprime weighted blowup: `lem:number_theory` 4.4 produces coprime
   `a,b > 0` with `χ_1^bχ_2^{-a}` injective, the ray `(a,b)` is forced into the
   normal fan of the Newton polyhedron, and `E_{(a,b)}` is free off its two
   nodes, severing `Φ ∩ W_nt` (tex 880–884). Both re-derived and
   machine-checked here.
2. **`prop:rcc_total` 4.11's load-bearing move** is not Serre or Tsen — those
   are clean — but the requirement that the rational curve `C ⊆ D_I` **meet**
   the good open set, which is exactly what makes the geometric generic fibre of
   `Z_C → P¹` a tree of rational curves. The tex includes that clause. The
   Serre step is also correct when the edge is *inverted*: the two components
   swap, but their unique node is fixed.
3. **Three usage conditions**, recorded for whoever cites these next: the
   convention `G_{D_i} ≠ 1` must hold for **both** divisors of a corner; the RCC
   conclusion is about `T_I^†` (dominating components only), not `T_I`; and on a
   resolution of `Pᴺ`, rationality of `D_I` comes from `def:stratified_tower`
   4.14 + `lem:rational_strata_propagate` 4.15 (packaged as `cor:pn_resolved`
   4.16), **not** from `lem:linear_strata` 4.10.
4. **Citation drift closed.** Numbering recomputed from the tex (31 labels, 0
   mismatches); all eight numbers at `NOTEBOOK.md:6459–6467` confirmed. Three
   ≤ 6-line banners inserted (`NOTEBOOK.md:19–24`,
   `theory/FIX_I_bcomplex.md:243–248`, `theory/FIX_T_gate.md:272–277`) mapping
   old-draft numbers to labels. Cite by label.
5. **TZ pin for `V14_MAP_DICHOTOMY` Theorem B: `TZ-CHI-PI-PIN-PARTIAL`.**
   `χ_Π` is TZ (3.3), p. 7, attributed to [Kuz04, Rem. 2.19]; TZ puts **no**
   genericity on `Π`, so the packet's "general `L`-rational hyperplane" is the
   conservative reading and is fine over the infinite `L`. **Not** flagged for
   analyticity — the paper has no Hodge/transcendental/monodromy step anywhere,
   and TZ Remark 3.1 says the proof is linear algebra. Two real items: TZ's
   declared field is *algebraically closed* char 0 (p. 1), so the non-closed-field
   use is ours; and TZ's own Remark 3.2 (p. 8, [Bea00, Thm 8.2]) shows that over
   a nonclosed field "is Pfaffian" is a condition — so Theorem B's real
   hypothesis is the existence of an **`L`-rational regular net `f`**, which the
   packet should state. [Kuz04] is not ingested.

Machine: `python3 scripts/chk{0,1,2,3,4}_*.py` → 5/5 PASS, 0 failures
(exhaustive finite arithmetic, no prime reduction, no floating point).
```

## 3. Files changed outside this packet directory

Banner insertions only; nothing else in these files was touched, and no history
was rewritten.

| file | lines inserted | anchor |
|---|---|---|
| `problems/E-klein-cubic/NOTEBOOK.md` | 19–24 (+ blank 25) | file head, after the ledger paragraph — the drifted citations occur in three separate places, so the head is the only single-point fix |
| `problems/E-klein-cubic/theory/FIX_I_bcomplex.md` | 243–248 (+ blank 249) | immediately before the Correction I-C block, the first affected citation |
| `problems/E-klein-cubic/theory/FIX_T_gate.md` | 272–277 (+ blank 278) | immediately after the `## T2′` heading, the first affected citation |

## 4. Cross-references to add elsewhere (suggested, not applied)

* `goal_runs_20260810/DUNCAN_CORNER_F2/STATUS.md` — residual-uncertainty item 1
  ("the two EXTERNAL-UNVERIFIED imports") is discharged as far as *soundness*
  goes; replace the grade, keep the dependency, and add the three usage
  conditions of `THEOREM.md` §4.
* `goal_runs_20260810/STAGE1_COMPLEX_MAPS/THEOREM.md:720` (branch
  `agent/stage1-complex-maps-20260810`) — the dependency row
  "`thm:pairs`, `prop:rcc_total` (Duncan) | only (F2) on `Z⁺` (§7) |
  **EXTERNAL-UNVERIFIED**" should become **IMPORT-REVIEWED**.
* `goal_runs_20260810/V14_MAP_DICHOTOMY/REPORT.md:51–63` — attach the pin note
  and add one sentence on where the `L`-rational net comes from.
