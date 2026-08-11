## Binding rules (read before trusting any status below)

1. **Precedence (layered, not a fixed document ranking).** Where documents
   conflict, resolve in this order:
   (i) **Theorem-boundary correction layers override anything they predate,
   within their stated scope** — `REPAIR.md` (2026-07-31 08:50, `db37f58`;
   applied by `07d1c4e`) and the `audit_a1` layer (2026-07-31 21:38, `78abba4`).
   A pre-repair claim never overrides its post-repair replacement. Audit A1 is
   same-day but later; it corrects only artifacts predating it (the 07-31
   T8/T9/T10/P25 exits) and does not override the 08-01/08-02 goal-wave
   artifacts.
   (ii) A later artifact supersedes an earlier one **only** via an explicit
   supersession statement that itself survives its own verification class.
   (iii) Otherwise order by **chronology and dependency**, never by document
   identity.
   (iv) Bounded or modular results **never** override characteristic-zero
   statements (see rule 2).
   (v) Narrative documents never override packet-level artifacts.
   *This layered rule replaced the earlier static order (`REPAIR.md` >
   `CURRENT_PATHS.md` > run `STATUS.md` > workorders > narrative docs) after the
   2026-08-03 review round, whose degree-25 case showed that a static order
   freezes stale states: the highest-ranked document simply kept an outdated
   verdict that a later packet had partially superseded.*
2. **Ledger rule.** Finite computations, modular ranks, and formal states are
   not headline conclusions unless an explicit characteristic-zero geometric
   bridge is supplied.
3. **Replay ≠ verification.** Hash/verifier replay certifies file presence and
   internal packet consistency — not the analytic implications a verifier merely
   reads from JSON or Markdown. Method tags below distinguish `CAS` (replayable),
   `formal` (kernel-checked), and `analytic` (audited only by reading).
4. **Provenance.** `source: repo` entries cite in-repo artifacts. `source:
   external-chatgpt` entries record offline sessions (see
   `external_sessions/`); their claims are **not machine-verifiable** and must
   be re-derived in-repo before affecting the headline.
5. **`tmp/` is local-only.** Every `tmp/...` citation in this notebook refers to
   local scratch that is **not tracked in the pushed repository** — all 50 of the
   50 cited `tmp` paths are untracked, and the problem-level `.gitignore`
   excludes `/tmp/`. These directories are retained for local replay only;
   portable provenance is `goal_runs_*/`, `certificates/`, and the committed
   documents. Where an entry's only provenance is `tmp/`, its evidence is
   **local-only** and cannot be checked by anyone working from the pushed repo.
6. **Maintenance protocol (live-program discipline).** Every commit that
   lands a packet, theory note, or route-status change must, in the *same*
   commit: update the owning entry's Status and (if changed) the Index row
   and dashboard; add the manifest record; add a Supersession-map row when
   anything is superseded; adjust Verification debt (retire or add); bump
   the parent head. Enforcement: `scripts/check_manifest_parity.py` fails on
   unmapped run dirs, stale parent heads, unaccounted `tmp/` or documents,
   and — as of 2026-08-04 — on any packet exit not surfaced verbatim in this
   notebook (`exits_surfaced_in_notebook`). Run the checker before every
   commit; a red checker is a stop.
7. **Nomenclature.** Bare route letters are ambiguous historical tokens — `F`
   alone names three unrelated programs, `dP` four. The canonical citation
   form is the **E-number** (optionally plus a run directory). The
   Nomenclature glossary below is the disambiguation authority; new documents
   must not introduce bare-letter route names, and any historical status line
   keyed to a bare token (e.g. "F terminal") is unresolvable without the
   glossary and must not be consumed as a status.
8. **Stop-rule (adopted wave 26, 2026-08-06, user-prompted; binding).**
   Every CAS run must be attached to a NAMED FINITE QUESTION whose both
   outcomes redirect the program; no unbounded degree/parameter sweeps.
   Existing runs that violate it are stopped and recorded
   stopped-not-finished (first application: the (1,6) n = 4/5 modular
   sweep, E56 wave 26). Bounded ladders state their cap and the
   structural justification required to extend past it.
