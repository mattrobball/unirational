# Proposed NOTEBOOK registration for `STANDARD_FORM_PW`

**Do not apply blindly.** This file exists because concurrent sessions were
editing `NOTEBOOK.md` and `notebook_build/manifest.json` while this packet was
being built, so the packet deliberately did **not** touch either file. Whoever
merges should re-check the `entry` number and the parity checker
(`scripts/check_manifest_parity.py`) before committing, and must include the
NOTEBOOK edit and the manifest edit in the **same commit** as this packet, per
the notebook-maintenance protocol.

---

## 1. `notebook_build/manifest.json` — append to `records`

```json
{
 "path": "goal_runs_20260810/STANDARD_FORM_PW",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "SOURCE-STANDARD-FORM-TOWER-SEALED",
 "superseded_by": null,
 "char0_scope": "The local layer -- the boundary-tracking multiset automaton, its transition rule, the acceptance criterion, the elimination lemma for nonabelian stabilizers, the tangent representations of the D12/D10/A4 points, Lemma B, and the terminus tables read as statements about local models -- is EXACT character arithmetic and carries no prime dependence at all. The global layer (level-0 stratification and its orbit counts, tangent/normal characters, the full incidence table, and the smoothness/disjointness of the centre of every stage over all 940 points, all 1540 incident line pairs and all 1485 plane pairs) is computed at the two split primes 331 and 661, each coprime to |G| = 660 with 5, 11 | p-1, so reduction is a bijection on irreducible characters and on the lattice of subrepresentations and every rank/dimension/incidence statement used is stable under it. One representative chart per stage genre (point / curve / surface blow-up) is verified exactly over QQ in Macaulay2, 24/24, including isPrime and codim on a crossing. SAMPLED, and flagged: the global smoothness and irreducibility of every crossing D_I (def:toroidal(a)) is argued from the projective-bundle structure and checked in M2 for one representative crossing only, not for all 1215 divisors.",
 "tracked": "main",
 "notes": "Builds and verifies the COMPLETE standard (toroidal) form of the SOURCE P(W) = P^4 for G = PSL(2,11), the permanent source-side atlas for the obstruction machine. The tower is exactly THREE blow-ups: T0 the 940 points of the point strata (10 G-orbits), T1 the strict transforms of the 220 lines (55 ell_V, 110 C3-eigenlines, 55 minus-lines), T2 the strict transforms of the 55 plus-planes -- i.e. blow up every stratum of the level-0 stabilizer stratification in order of increasing dimension, and nothing else. Boundary: 1215 divisors in 14 G-orbits, of which exactly 110 in 2 orbits (E_sigma over P_sigma, E'_sigma over L'_sigma) have nontrivial pointwise stabilizer, always C2; no C3-, C5-, C6-, C11- or V4-stabilized boundary divisor is ever created by this tower (though a C3-one is possible on some other toroidal model). Nonabelian elimination is exact: D12 and D10 need 1 round, A4 needs 2, and the A4 case exhibits a genuine TERMINAL CYCLE -- repeated point blow-ups at an A4-point regenerate it forever (T_q = 1' + 3 reproduces itself), the only eliminating centre being a curve tangent to the 1'-line, which on P(W) is ell_V (new structural fact: W^{V4} = 1' + 1'' as an A4-module, so ell_V is the line joining the two A4-points and they are the residual-C3 eigenpoints of ell_V). No stratum of P(W) has pointwise stabilizer S3: both S3-classes fix only D12-points. The boundary-tracking automaton generalises DUNCAN_CORNER_F2's V4 transition rule to exact character arithmetic for every abelian stabilizer plus boundary flags; acceptance is 'the boundary normal characters generate the character group'; the resolution rule (blow up the fixed locus of the WHOLE defect group) reproduces Lemma C automatically. Every class reaches a toroidal terminus in at most 2 rounds; the reachable state space is finite (245 states); no dead ends; at most 3 boundary branches through any point. Terminus atlas: point stabilizers are exactly the seven abelian subgroup types {1,C2,C3,V4,C5,C6,C11}, in 42 distinct local models; crossing stabilizers are 1 or C2 at |I| = 2 and C2 at |I| = 3, so THE TERMINUS CARRIES NO FABULOUS CORNER -- DUNCAN_CORNER_F2's 330 V4-corners are created by ONE FURTHER legal blow-up (their T3, the surface M_tau^V inside E_V), which the toroidal condition does not require but cor:cofinal licenses; the exhaustive closure confirms V4 is the only non-cyclic crossing stabilizer reachable at all, so that inventory stands complete. Dimension profile: Fix(C5), Fix(C6), Fix(C11) stay ZERO-DIMENSIONAL through the whole recursion (the tangent weights at those points are four distinct nontrivial characters and the twisting never produces a trivial one), while Fix(C2) acquires components of dimension 1, 2 and 3 and Fix(C3) of dimension 0, 1 and 2 -- so Fix(C2) is NOT purely divisorial at the terminus. New crossing types beyond the corner packet: a |I| = 3 crossing with stabilizer C2, and 1155 + 440 C2-fixed loci of dimension 1 and 2 inside the point exceptional divisors. Source-class invariant: V4 is the unique non-cyclic entry of the abelian atlas and hence the entire reason fabulous corners exist here, and it is exactly the row a SPIN source lacks (P(U)^{V4} = empty since the V4-preimage in SL(2,11) is Q8), cross-referencing SPIN_SOURCE_NETWORK/KLEIN_SPIN_COMPLEX.md section 1 and closing theory/FIX_IX_v14.md:261-266. NO HEADLINE CLAIM: source-side normal form only; nothing about X, about equivariant unirationality, or about ed_C(PSL(2,11)). The only EXTERNAL-UNVERIFIED import that touches a conclusion is thm:pairs, used for exactly one sentence (reading 'no non-cyclic crossing stabilizer' as 'no fabulous corner'); the computed statement is unconditional. Re-verifies certificates/STRATA_EXACT.md:108-123 and certificates/NORMAL_CHARACTERS.md:71-90 from scratch without importing their producers. Marker STANDARD_FORM_PW_VERIFY_OK / ALLGREEN, 158 CHECK lines, 0 failures."
}
```

## 2. `NOTEBOOK.md` — proposed log entry

Place in the 2026-08-10 wave alongside `DUNCAN_CORNER_F2`, `SPIN_SOURCE_NETWORK`
and the other `goal_runs_20260810/` packets.

```markdown
### `STANDARD_FORM_PW` (08-10, `goal_runs_20260810/`) — the source-side atlas

**No headline claim; source-side normal form only.** Problem E remains OPEN.

The complete standard (toroidal) reduction of the source `P(W) = P⁴`,
`G = PSL(2,11)`. The tower is **three blowups** — the 940 points of the point
strata, then the 220 lines, then the 55 plus-planes, i.e. *every stratum of the
level-0 stabilizer stratification in order of increasing dimension, and nothing
else*. Terminus: **1215 boundary divisors in 14 `G`-orbits**, exactly **110 in
2 orbits** with pointwise stabilizer (always `C2`); point stabilizers exactly
the seven abelian types `{1, C2, C3, V4, C5, C6, C11}` in 42 local models;
crossings up to `|I| = 3` with stabilizer `1` or `C2`.

Four things worth carrying forward:

1. **`A4` is the hard case, and it is a terminal cycle.** Blowing up an
   `A4`-point regenerates it forever (`T_q = 1' ⊕ 3 ↦ 1' ⊕ 3`); the only
   eliminating centre is a curve tangent to the `1'`-line — which is `ℓ_V`,
   because `W^{V4} = 1' ⊕ 1''` as an `A4`-module, so `ℓ_V` joins the two
   `A4`-points and they are its residual-`C3` eigenpoints. `D12` and `D10` need
   one round; **no stratum of `P(W)` has stabilizer `S3`** (both `S3`-classes fix
   only `D12`-points).
2. **The minimal standard form has no fabulous corner.** Every crossing of the
   terminus has cyclic generic stabilizer. `DUNCAN_CORNER_F2`'s 330 `V4`-corners
   need **one further legal blowup** (their T3). That packet's inventory is
   confirmed complete — `V4` is the only non-cyclic crossing stabilizer reachable
   at all — but any argument using the corners must say "pass to a further
   toroidal model", which `cor:cofinal` licenses.
3. **`C5`-, `C6`- and `C11`-fixed loci stay zero-dimensional** through the whole
   recursion (their tangent weights are four distinct nontrivial characters and
   twisting never yields a trivial one), while **`Fix(C2)` is not purely
   divisorial** at the terminus — it has components of dimension 1 and 2 as well
   as the 110 divisors.
4. **The `V4` row is the source-class invariant.** It is the unique non-cyclic
   entry of the permanent abelian atlas, hence the whole reason the Duncan corner
   mechanism has purchase here — and it is exactly what a spin source lacks
   (`P(U)^{V4} = ∅`, `Q8` preimage; `SPIN_SOURCE_NETWORK/KLEIN_SPIN_COMPLEX.md`
   §1, closing `theory/FIX_IX_v14.md:261–266`).

Machine: `python3 verifier.py` → `STANDARD_FORM_PW_VERIFY_OK`, `ALLGREEN`,
158 CHECK lines, 0 failures; both split primes 331 and 661, exact character
arithmetic for the automaton, exact `QQ` in Macaulay2 for the charts.
Re-verifies `STRATA_EXACT.md:108–123` and `NORMAL_CHARACTERS.md:71–90` from
scratch. Sampled and flagged: global irreducibility of every crossing `D_I`.
```

## 3. Cross-references to add elsewhere (suggested, not applied)

* `goal_runs_20260810/DUNCAN_CORNER_F2/STATUS.md` — its residual-uncertainty
  item 3 ("T4, the rest of the toroidal resolution, is asserted … the global
  bookkeeping for the remainder of `P(W)` is not carried out") is **discharged**
  by this packet: T4 is T0–T2 here, and the corner packet's T3 is shown to be an
  *optional* blowup beyond toroidality rather than part of it.
* `goal_runs_20260810/SPIN_SOURCE_NETWORK/` — the `V4`-row comparison in §6(ii)
  of this packet's `THEOREM.md` is the linear-source half of that packet's
  dichotomy.
