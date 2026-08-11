# Adjudication of PR #38 — `agent/retract-landscape-20260811`

**Date:** 2026-08-11. **Adjudicator:** independent session, working on the PR
branch only (no merge to `main`).
**Verdict: READY-WITH-TRIMS → now READY.** Three citation errors fixed in
place, one claim **refuted** and retracted with the refutation recorded, one
mis-citation of the repository's own sealed layer corrected, verifier
strengthened 4 → 7 checks.

Problem E headline: **OPEN**, unchanged.

This is a landscape note, not a theorem packet. It is correctly labelled as
such throughout, and it correctly flags its central four-step chain as an
assembly of published theorems rather than a published statement. The
adjudication therefore concentrated on (i) whether the citations exist and say
what is claimed, (ii) whether the escape-chain reasoning is sound and
consistent with the repository's sealed results, and (iii) whether any
statement overreaches its evidence.

---

## 1. External citations — checked against the papers, not the abstracts

Every item was re-checked; items 1, 4, 5, 6, 9 by extracting the actual paper
text.

| # | citation | verdict |
|---|---|---|
| 1 | EGFS, arXiv:2507.15704, Thm 1.3 / Cor 1.4 | **CONFIRMED verbatim.** Thm 1.3: "Let `Y ⊂ P^4_C` be a very general cubic hypersurface. Then the homology class of any curve `C ⊂ JY` … is an even multiple of the minimal class `[Θ_Y]^4/4!`". Cor 1.4: "Very general cubic threefolds … do not admit a decomposition of the diagonal. Hence they are neither stably rational, nor retract rational, nor `A^1`-connected." Abstract content matches the note's paraphrase |
| 2 | Schreieder, arXiv:2510.13679, ICM 2026 survey, MSC includes 05B35 | **CONFIRMED.** Page states "will appear in the Proceedings of the ICM 2026"; MSC 14J70, 14E08, **05B35**, 14M20, 14C25 |
| 3 | Banerjee, arXiv:2509.06013, unrefereed | **CONFIRMED.** Abstract: "we prove that a very general cubic threefold does not admit a universal codimension-two cycle and hence is stably irrational" |
| 4 | Beckmann–de Gaay Fortman, arXiv:2202.05230, Thm 1.2, Compositio 159 (2023) | **CONFIRMED verbatim, and this was the load-bearing one.** Thm 1.2 reads "Let `C_1,…,C_n` be smooth projective curves over `C`. Then the integral Hodge conjecture for one-cycles holds for the product of Jacobians `J(C_1) × ⋯ × J(C_n)`." It is a standalone theorem, not a misattributed corollary of the more general Thm 1.1, and it carries **no** polarization hypothesis — exactly what step (ii) needs. Venue: Compositio Math. 159 (2023), issue 6, 1188–1213 |
| 5 | Voisin, arXiv:1407.7261, JEMS 19 (2017) 6, 1619–1653, Thm 1.7 / Cor 4.4 | **CONFIRMED verbatim.** Thm 1.7: "Let `X` be a smooth cubic threefold. Then `X` has universally trivial `CH0` group if and only if the class `θ^4/4!` on `J(X)` is algebraic." Cor 4.4 restates it. Venue exact |
| 6 | Voisin, arXiv:2212.03046, PAMQ (2024), Thm 1.15 | **CONFIRMED with a sharpening.** Thm 1.15 is one-directional: "A smooth cubic threefold admits a universal codimension 2 cycle **if** the minimal class of its intermediate Jacobian is algebraic" (Thm 1.16 is the partial converse). The note used it loosely ("tied to the same … property"); **FIXED-IN-PLACE** to state the implication and note that the "if" direction is exactly the one supplied by step (iii). Venue completed: PAMQ **20** (2024), no. 5, 2469–2496 |
| 7 | Colliot-Thélène–Voisin, Duke 161 (2012) 5, 735–801 | **FIXED-IN-PLACE.** Bibliographic data confirmed. But the vanishing is of unramified `H^3(-, **Q/Z**)` on uniruled threefolds; the note wrote `H^3(-, Z)`. Corrected in §2 and in DEPENDENCIES |
| 8 | Adler, J. Algebra 72 (1981) 1, 146–165 | **FIXED-IN-PLACE.** Bibliographic data confirmed; the published title is "On the automorphism **groups** of certain hypersurfaces" (plural). The note followed Roulleau's bibliography, which has the singular. Corrected, with the discrepancy noted |
| 9 | Roulleau, arXiv:1001.4853, J. Math. Kyoto Univ. 49 (2009) | **CONFIRMED.** Theorem 2 does concern the period lattice `H_1(S,Z) ⊂ H^0(Ω_S)^*` of the Fano surface, and the introduction remark is verbatim as quoted, including "isomorphic to `E^5` but … not an isomorphism of principally polarized abelian varieties". Pages 113–129. The packet's own `verifier.py` greps this out of a fresh `pdftotext` extraction and passes |

## 2. The escape chain — sound

| step | verdict |
|---|---|
| (i) `J(Klein) ≅ E^5` **as abelian varieties**, not as p.p.a.v. | **CONFIRMED** (item 9, plus Adler 1981 by Roulleau's own attribution) |
| (ii) IHC for 1-cycles on a product of Jacobians, polarization-free | **CONFIRMED** (item 4). The polarization-freeness is real: Thm 1.2's hypothesis is on the abelian variety, and IHC for 1-cycles is a statement about *all* integral Hodge classes in `H^{2n-2}`, so it transports along any isomorphism of abelian varieties |
| (iii) the minimal class `θ^4/4!` is algebraic on `J(Klein)` | **CONFIRMED.** `θ^4/4!` is an integral Hodge class on a 5-dimensional p.p.a.v. (standard), so (ii) applies. The polarization enters only to *define* the class; algebraicity comes from (ii). This is exactly the manoeuvre the note advertises and it is legitimate |
| (iv) universally trivial `CH0` / integral decomposition of the diagonal | **CONFIRMED** (item 5's equivalence, applied left-to-right) |
| "decomposition of the diagonal is necessary, not sufficient" | **CONFIRMED** and correctly flagged as Voisin's own caveat |
| the chain is an assembly, not a published statement | **CONFIRMED** — stated in DEPENDENCIES tier C and repeated in §2 |

## 3. The one refuted claim

> **REFUTED.** "the Klein cubic is the one member of that family the July-2025
> landscape event provably does not reach"; "among all smooth cubic threefolds,
> the Klein cubic is currently **maximally favorable** … no other named or
> general member of the family has all of these obstructions simultaneously
> vanish".

Two independent refutations, one of them from a paper the note itself cites:

1. **Voisin's Theorem 1.7 continues past the sentence the note quotes:**
   *"This happens (at least) on a countable union of closed subvarieties of
   codimension ≤ 3 of the moduli space of `X`."* Her Theorem 4.5 constructs
   them explicitly — cubic threefolds with an order-3 automorphism acting as
   `(X_0, jX_1, j^2X_2, X_3, X_4)`, where an odd-degree isogeny of `J(X)` to a
   Jacobian of a reducible curve plus the fact that `2·θ^4/4!` is always
   algebraic on a Prym forces `θ^4/4!` itself to be algebraic. That is a
   **positive-dimensional, Zariski-dense countable union** of cubic threefolds
   with universally trivial `CH0`, published in **2017**, and it uses neither
   the Klein cubic, nor CM, nor step (ii).
2. **The step-(i) input is not unique to Klein.** Roulleau, *"Fano surfaces
   with 12 or 30 elliptic curves"*, arXiv:1001.4855, **Theorem 23**: for the
   **Fermat** cubic threefold the intermediate Jacobian is *isomorphic* to
   `E^4 × E'` with `E = C/Z[α]`, `E' = C/Z[3α]`, `α` a primitive cube root of
   unity — a product of elliptic curves, hence of Jacobians, so steps
   (ii)–(iv) run verbatim. (Worth recording: it is `E^4 × E'`, **not** `E^5`;
   `E` and `E'` are 3-isogenous but not isomorphic, so secondary sources
   writing `J ∼ E^5` for Fermat are asserting an isogeny.) Roulleau,
   *"Elliptic curve configurations on Fano surfaces"*, arXiv:0804.1861,
   **Theorem 27**, gives a one-parameter family `F_λ` whose Albanese is
   isomorphic to a product of elliptic curves at the CM values of `λ`.

**Recorded, not deleted.** The refutation is written into `THEOREM.md` §2.1,
which states what survives: the Klein cubic *is* in the escaping locus, with
the sharpest published form of the input (an isomorphism, not an isogeny), and
its Problem-E interest comes from `Aut(X) = PSL(2,11)`, which genuinely is
unique to it. A regression check in `verifier.py` now fails if the retracted
phrases reappear as assertions.

The related claim that EGFS is "the first-ever retract-irrationality result for
cubic threefolds" was **softened**, not refuted: it is a survey judgement this
packet cannot verify, and is now labelled as one.

## 4. Repository citations in §3 — two corrections

| claim | verdict |
|---|---|
| `RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md` Thm 3.1 forces `delta` to be a norm from `Q(sqrt(-11))` | **CONFIRMED.** The CLEAN branch gives `u_phi^† u_phi = delta·id_V`, hence `delta = x^2 + xy + 3y^2`; exit `RESTRICTED-CLEAN-CM-NORM-PROVED` |
| "… and `delta >= 3` is sealed there [in Thm 3.1]" | **FIXED-IN-PLACE.** Theorem 3.1 proves no lower bound. The packet's only `delta >= 3` is a property of one *constructed* tangent-residual self-map ("exact degree not computed; only `delta >= 3`"). The real statement is that `2` is not a norm and `delta = 1` is the retraction case, so the *non-retraction* branch starts at `3` — which is `COMBINED_DEGREE_SIEVE`'s framing, not Thm 3.1's. As written the sentence also contradicted the note's own next sentence, which treats `delta = 1` as live |
| "the fork between a retraction and `delta >= 12` stays open" | **REFUTED, FIXED-IN-PLACE → `delta >= 3`.** `delta >= 12` appears nowhere in the repository except in this packet. `COMBINED_DEGREE_SIEVE/STATUS.md` says the opposite: "the cell `delta = 3` satisfies every sealed constraint at every live degree, so no residue class mod any modulus dies", and §4 there runs the all-ambient branch over "exactly the norms in `[3, d^3-d]` … minimum always `3`". The `12` looks like a conflation with `FIX-VIII-A5LADDER-EMPTY-THROUGH-10`'s undecided rungs 11 and 12, which are values of the coordinate degree `d` of `A5`-equivariant landing data, not of `delta` |
| `RETRACTION_DEGREE_BOUND.md`: any retraction has `d >= 24`, exit `DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24` | **CONFIRMED** (file §Theorem, boxed) |
| `FIX_P2_GATEWAY_D36` empties both branches for `22 <= d <= 30`, exit `FIX-P2-SWEEP2-EMPTY-THROUGH-30` | **CONFIRMED** (its `STATUS.md`, and `COMBINED_DEGREE_SIEVE` §4) |
| `COMBINED_DEGREE_SIEVE`: retractions covered through `d <= 30`; `31 <= d <= 60` both branches live; no congruence sieve can close it | **CONFIRMED** (`STATUS.md` §4–5, exit `COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED`) |
| `FIX_VIII_A5LADDER` is `EMPTY-THROUGH-10` with rungs 11, 12 boxed undecided; read-only reference | **CONFIRMED** |
| the retraction normal form `T = H·x + F·Q`, `deg H = d-1`, `deg Q = d-3`, `H ≡ -grad(F)·Q mod F` | **CONFIRMED** — it is `RETRACTION_DEGREE_BOUND.md` (1.1) plus identity (1.2). **FIXED-IN-PLACE**: the note reused the letters `A`, `B` for that file's `H`, `Q`, while the source's own `A`, `B` are `Phi(x,x,Q)` and `Phi(x,Q,Q)`. Renamed to the source's letters with the clash flagged |
| `delta = 1` means the restricted self-map is the identity, i.e. an honest `G`-equivariant retraction | **CONFIRMED** as the repository uses it (`COMBINED_DEGREE_SIEVE` §3–4 treats the retraction branch as the single value `delta = 1`) |

## 5. Two elliptic curves (§4)

**CONFIRMED.** `E` (CM by `Q(sqrt(-11))`, the `J(X) ≅ E^5` factor) and
`E_sigma` (`j = 8192/11`, non-CM because `8192/11` is not an algebraic
integer) are correctly distinguished, and `E_sigma`'s data matches the sealed
`FIX-A0-C3-ELLIPTIC-J-PASS` exactly. This §4 is a genuinely useful guard and
it is right.

## 6. Verifier — strengthened, 4 → 7 checks

The original four checks were thin but not vacuous (a real PDF, a real
`pdftotext` grep of the quoted sentence, a real rational-arithmetic check).
Nothing mechanical guarded §3, which is where both mis-citations were. Added:

* `RETRACT-LANDSCAPE-REPO-PATHS-RESOLVE` — all 6 in-repo paths named in §3
  exist on disk;
* `RETRACT-LANDSCAPE-REPO-EXITS-RESOLVE` — all 5 exit markers attributed to
  packets appear verbatim in those packets' own files;
* `RETRACT-LANDSCAPE-REFUTED-CLAIMS-STAY-RETRACTED` — the three retracted
  phrases may appear only inside an explicit retraction passage.

`VERIFY: PASS — all 7 checks passed.`

## 7. Theorem-strength language audit

No statement in the note is presented as a theorem of this packet. The
"Proved / Not claimed" boundary is stated in §2 ("What this does and does not
prove"), DEPENDENCIES tier C, and the closing "Not claimed" paragraph, and all
three are accurate after the trims. The only overreaches were the uniqueness
and maximality claims of §3 above, which are now retracted in place, and the
two repository mis-citations of §4, now corrected. `E51` (LIT-AUDIT) is the
right entry: the packet's own argument for it over `E56` is correct.

## 8. Merge readiness

**READY.** `scripts/check_manifest_parity.py` passes at the final commit of
this branch.
