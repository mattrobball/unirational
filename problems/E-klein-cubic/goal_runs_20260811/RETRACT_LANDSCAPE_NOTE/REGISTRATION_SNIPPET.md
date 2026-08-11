# Proposed NOTEBOOK.md / manifest registration for `RETRACT_LANDSCAPE_NOTE`

**Do not apply here.** Per the negative-route focus and to avoid a race with
concurrent sessions on `NOTEBOOK.md` and `notebook_build/manifest.json`
(see `concurrent-session-manifest-race`), this packet does not touch either
file, and no state-changing git operations were run. Whoever merges should
re-check the entry number and run `scripts/check_manifest_parity.py` before
committing, and should land the NOTEBOOK edit and the manifest edit in the
**same commit** as this packet, per the notebook-maintenance protocol.

---

## Entry number: `E51`, not `E56` — and why

The task brief offered `E56` as a default, with the option to use `E51`
(LIT-AUDIT) instead "if you find a better-fitting E-number for literature
audits." `E51` is the better fit, for a concrete reason visible in
`NOTEBOOK.md` itself:

- `E51` is **already defined** (`NOTEBOOK.md`, `<a id="e51"></a>` section) as
  exactly this category: *"Recent-literature and computational-tool audit
  ... recurring due-diligence sweep for a turnkey theorem or software that
  would shortcut a route."* This packet is precisely that: a due-diligence
  sweep of a newly-arrived piece of literature (the July-2025 Engel-de Gaay
  Fortman-Schreieder landscape event) to determine whether it shortcuts
  Problem E. It does not, and the reason it does not is itself a literature-
  assembly finding — squarely `E51`'s remit.
- `E56`, by contrast, is used in the manifest as a **generic wave/session
  label** attached to dozens of structurally unrelated `FIX_*` packets
  (involution arrangement, Burnside symbols, cell classification, Prym
  seal, ...) spanning nearly the entire `goal_runs_after_*` history. It
  functions as a rolling "which wave was this done in" marker, not a
  topical bucket, and has no particular affinity to literature review.

Using `E51` also gives this packet's finding a natural home next to the
existing `E51` entry's 2026-08-06 CTZ-manuscript sub-note in `NOTEBOOK.md`,
continuing the same "ongoing-clearance" thread rather than starting a new
one.

---

## 1. `notebook_build/manifest.json` — append to `records`

```json
{
 "path": "goal_runs_20260811/RETRACT_LANDSCAPE_NOTE",
 "entry": "E51",
 "kind": "goal_run",
 "verification_class": "ANALYTIC-PROOF-REVIEW",
 "primary_exit": "RETRACT-LANDSCAPE-NOTE-ASSEMBLED",
 "superseded_by": null,
 "char0_scope": "The Roulleau quote (DEPENDENCIES tier B) is verified exactly against the local PDF text by verifier.py, and the E_sigma non-CM arithmetic (8192/11 not an algebraic integer) is exact. All other citations (DEPENDENCIES tier A: Engel-de Gaay Fortman-Schreieder, Schreieder ICM survey, Banerjee, Beckmann-de Gaay Fortman, Voisin JEMS 2017, Voisin PAMQ 2024, Colliot-Thelene-Voisin Duke 2012) are literature citations, not locally computed; their titles/authors/arXiv IDs were confirmed live against arxiv.org and one web search on 2026-08-11, but their internal theorem numbers and full proofs were not independently re-verified in this packet -- they are transcribed on the director's prior reading. The four-step assembled chain in THEOREM.md section 2 is explicitly NOT a published statement (see DEPENDENCIES tier C) and carries no verification class of its own beyond internal logical consistency of the assembly.",
 "tracked": "main",
 "notes": "Requested classification for this entry: LITERATURE-INGESTION + adjudication (a literature-landscape audit that ingests a new external result and adjudicates its reach against the repository's existing object, here the Klein cubic). Recorded as an ONGOING-CLEARANCE-style finding continuing E51's existing thread, not a new conjecture and not a headline-relevant proof. Content: (1) records the July-2025 Engel-de Gaay Fortman-Schreieder retract-irrationality result for very general cubic threefolds (arXiv:2507.15704, Thm 1.3/Cor 1.4), endorsed in Schreieder's ICM survey (arXiv:2510.13679), with an unrefereed independent duplicate (Banerjee arXiv:2509.06013); (2) assembles a four-step published-theorem chain (Roulleau J(Klein)=E^5 as abelian varieties + Beckmann-de Gaay Fortman polarization-free IHC for products of Jacobians + Voisin JEMS 2017 minimal-class/CH0 machinery) showing the Klein cubic is the one cubic threefold this July-2025 machinery provably does not reach, and that every known bare-variety obstruction to retract rationality vanishes for it, while decomposition of the diagonal remains necessary-not-sufficient (Voisin's own caveat) so no rationality statement is proved; (3) states precisely how this bears on Problem E: the sealed CLEAN/CARRIER self-map dichotomy's delta=1 case is an equivariant retraction that would witness this bare-variety retract rationality, the July-2025 machinery cannot decide it (by construction, per (2)), no bare-variety method can, and the fork stays open per the repository's own sealed degree bookkeeping (retraction excluded through ambient coordinate degree d<=30; delta=3 cell's realizability still uncomputed per the 2026-08-10 Wave-33 routing note; FIX_VIII_A5LADDER -- read-only reference, not touched -- empty through rung 10, boxed undecided at 11-12); (4) keeps E (CM, the J(Klein)=E^5 factor) and E_sigma (non-CM, j=8192/11, the involution-fixed curve, sealed FIX-A0) explicitly distinct. Headline status: unaffected, still OPEN. Does not touch FIX_VIII_A5LADDER, NOTEBOOK.md, or notebook_build/manifest.json."
}
```

## 2. Dated section -- insert in `problems/E-klein-cubic/NOTEBOOK.md` (append under the existing `E51` thread, or as a new dated entry cross-referencing `E51`)

```markdown
## 2026-08-11 Retract-rationality literature landscape: the Klein cubic
provably escapes the July-2025 obstruction, and Problem E's delta=1 fork
stays open

Packet: `goal_runs_20260811/RETRACT_LANDSCAPE_NOTE/`. Entry [E51](#e51).
Problem E remains **OPEN**.

Engel-de Gaay Fortman-Schreieder (arXiv:2507.15704, Thm 1.3/Cor 1.4, July
2025) prove very general cubic threefolds are neither stably nor retract
rational -- the first-ever retract-irrationality result for cubic
threefolds, endorsed in Schreieder's ICM survey (arXiv:2510.13679); an
unrefereed independent duplicate is Banerjee arXiv:2509.06013.

This packet assembles (not proves new) a four-step published-theorem chain
showing the Klein cubic is the one cubic threefold that machinery provably
does not reach: `J(Klein) ~= E^5` as abelian varieties (Roulleau
arXiv:1001.4853 Thm 2 + intro remark, quoted from the PDF; also Adler 1981)
+ the integral Hodge conjecture for 1-cycles on any product of Jacobians is
polarization-free (Beckmann-de Gaay Fortman arXiv:2202.05230 Thm 1.2) =>
the minimal class is algebraic on `J(Klein)` despite the polarization not
being the product one => the Klein cubic has universally trivial `CH0` and
an integral decomposition of the diagonal (Voisin JEMS 2017 arXiv:1407.7261
Thm 1.7/Cor 4.4). Every known bare-variety obstruction to retract
rationality vanishes for the Klein cubic; it is maximally favorable among
all cubic threefolds; retract rationality of the bare Klein cubic stays
OPEN in both directions (decomposition of the diagonal is necessary, not
sufficient -- Voisin's own caveat).

Relevance to Problem E: the sealed self-map dichotomy's `delta = 1` case
(an equivariant retraction of `P^4` onto `X`) would witness exactly this
bare-variety retract rationality. The July-2025 machinery cannot decide it
either way (it needs the minimal class to fail algebraicity, which it does
not here); no bare-variety method can; killing `delta = 1` requires the
group action. The repository's own degree bookkeeping excludes retractions
through ambient coordinate degree `d <= 30`
(`AMBIENT_REES_SELFMAP_CLASSIFICATION` + `FIX_P2_GATEWAY_D36` +
`COMBINED_DEGREE_SIEVE`) without closing the fork; the `delta = 3` cell's
realizability is still uncomputed (2026-08-10 Wave-33 routing note). The
fork between a retraction and `delta >= 12` stays open.

Keep `E` (CM, `J(Klein) ~= E^5`'s factor, `j = j((-1+sqrt(-11))/2)`) and
`E_sigma` (non-CM, `j = 8192/11`, the involution-fixed curve, sealed
`FIX-A0`) distinct -- both appear in this landscape and are easy to
conflate.

Exits: `RETRACT-LANDSCAPE-NOTE-ASSEMBLED` (primary),
`RETRACT-LANDSCAPE-ROULLEAU-PDF-PRESENT`,
`RETRACT-LANDSCAPE-ROULLEAU-QUOTE-FOUND`,
`RETRACT-LANDSCAPE-8192-11-NON-CM-OK`.

Not claimed: any rationality statement about the Klein cubic; any movement
on the `delta = 1` fork; that the section-2 chain is a published theorem of
any single cited paper (it is an assembly, flagged as such). Headline
status unchanged: OPEN.
```
