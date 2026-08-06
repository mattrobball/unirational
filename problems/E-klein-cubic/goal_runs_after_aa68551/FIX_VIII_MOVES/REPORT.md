# FIX-VIII-MOVES — cross-V4 move catalog

p=67, G=PSL(2,11). 60 CHECK / 0 FAIL (`results/checks.log`), ~80 s. **Exit `FIX-VIII-MOVES-NO-COLLAPSE`**, with a theory correction (F1).

**Setup verified.** 55/55 projectors land in X; dim V₋=2, V₊=3; 165 commuting pairs / 55 V4-triples / 165 vertices; X∩Π_V4 = the 3 lines (all 201 F_p-pts, all 55 planes); chord 578/578 on X + collinear; Z(v) = 55 distinct pts, rank 5. New: the 55 lines lie on X **and V(H)** (all 3740 pts); all 60 F_p-pts of the Hessian curve C lie on X. *Bug fixed mid-run:* V₋(σ) is the **image** of π_σ, not its row space (they differ for 50/55 and permute the line labels).

**A — pairs.** ord(στ): 2→165, 3→330, 5→660, 6→330. Conjugation orbits **(2,165),(3,165),(3,165),(5,330),(5,330),(6,330)** — all **≡0 mod 3**. ⟨σ,τ⟩ geometry: V4 (55, coplanar, 3 meets); S3 (2 classes × 55, lines span a P³, 0 meets — no second triangle calculus); D10 (66); D12 (55, 7 lines, 9 meets = its 3 V4s). Cycles at 4 random v (`payload/orbit_table.json`); all pts on X, span rank 5. Orbit / ord / |O| / distinct / incidences (lines, V(H), P₊, vertices, C):

    O0 ord2 165  146–157   all  all  11  11  0     <- the Menelaus cycle
    O1 ord3 165  164–165    14   18   3   3  0
    O2 ord3 165      165    12   12   2   1  0
    O3 ord5 330  328–330    28   35   8   1  0
    O4 ord5 330  327–330    28   33   3   0  0
    O5 ord6 330  329–330    24   34   4   3  0

No collapse — the 1–3 deficits are F_p birthday collisions that move with v. Orbit 0's 165 pts sit on the 55 lines, 3 per line (chord(π_a v,π_b v) ∈ L_c, 936/936); undefined chords ⟺ a projection hits a vertex (354/354, codim 1). Cross-V4 chords land back on Z(v) ~2–3 % (250× chance) but never for all 8 v ⇒ codim-1 accidents; 124/138 have the hit index inside ⟨σ,τ⟩.

**B — axes at 15 special sources** (`payload/axes_table.json`). **Plücker rank 10 at every source** — no drop anywhere. No axis collapses to a point, none lies in a plus-plane, every axis point is on a V4-line. *Correction:* the axes **do** meet — 85/87 meets over 12 v are line-sharing triangle pairs (Π_s∩Π_t = L_i, both axes cross L_i: codim 1); the residual 2 matches the codim-2 rate for the other 1320 pairs. Degenerations: 1–5 at generic v, 12 at a vertex, **0 at all 60 points of C**. C ∩ plus-plane is empty over F_67 (no sextet points).

**C — second layer** (`payload/reductions.json`). Any canonical reduction factors through a G-stable partition, so block systems settle it. Involutions 55: **none — D12 is maximal, the action is primitive**. Triangles 55: two systems, 11 blocks of 5. Pair-orbits/vertices 165: blocks 3, 15 → 55, 11. Pair-orbits 330: blocks 2,3,5,6,30 → 165,110,66,55,11. Executed the G-stable pairing on each 330-orbit: its chord-reduction is a clean degree-165 cycle on X (163–165 distinct, rank 5) — residue unmoved. The only collinear triple system anywhere is the V4 one (212/212 = Menelaus); the other 24 give 0–12/440. The 165 P³-spanning plane-pairs are exactly line-sharing triangles (no new points). 11-block route: the 15 Menelaus pts per block impose independent quadric conditions (15/15 bar 3/16 accidents), the 5 axes span P⁴ and are pairwise disjoint. dim W^{D12}=1 → 55 constant points, all in plus-planes, **none on X**; dim W^{A5}=0 → no constant 11-cycle.

**Reachable degrees: {11,55,66,110,165,330}; only 55 is ≡1 mod 3.** Nothing below 55, nothing of degree 1. Reason: |G/H| ≢ 0 mod 3 forces 3 | |H|, so the only transitive G-sets ≡1 mod 3 are 1, 55 (D12, A4), 220 (C3); below 55 the sole ≡1 combination is 11+11 = 22, needing a canonical point per A5-coset in both classes — killed linearly by W^{A5}=0.

**Findings ranked.**

F1. **Theory note §3 item 1 is wrong**: there is no 110-element pair-orbit (order-3 products give 330 pairs in two orbits of 165). All six orbits are ≡0 mod 3, so no first-layer cross-V4 chord cycle moves the residue.

F2. **The 55-cycle is combinatorially irreducible**: G on the 55 involutions is primitive, so no G-equivariant rule merges the projections. Any 55 → k must break the indexing, not refine it. Sharpest new constraint.

F3. Only door left below 55: the 11-block structure on the 55 *triangles*, needing a canonical 5-triangles → 1 point rule; linear and quadric versions dead.

F4. C is a distinguished source locus — zero degeneration at all 60 points vs 1–5 generically, and it is where Note VI's CM geometry sits.

F5. Clean negatives: no rank drop, no axis collapse, no new incidence at any special source; the in-plane points stay pinned to the lines.

**Assessment.** Do not spend another packet on the chord/pair catalog — the reachable-degree census closes it. Worth a packet: (a) the 11-block question directly — any G-equivariant map from a block of 5 triangles to a point of X, allowing nonlinear/covariant constructions, not just fixed vectors; (b) sources on C, degeneration-free and CM-priced. Everything in catalog item 3 built from lines, planes and chords is now excluded by measurement.
