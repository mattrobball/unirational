# A worked example: one pair (T, r), checked end to end — and what fell out

Director, 2026-08-11. Written to be checked, in plain language. Script:
`scripts/director_worked_example.py`; outputs:
`results/worked_example_p331.json`, `..._p661.json`. Everything below was
computed twice, independently, in arithmetic modulo the two primes 331 and
661, and every number agrees.

**Bottom line, stated carefully: at degree 35, every one of the 756
candidate blueprints is now ruled out at the current depth of the analysis
— pending an independent audit (see "What could be wrong", below).
Problem E remains OPEN; the window statement does not change until that
audit passes.**

> **CORRECTED SAME DAY — read §6 before this document.** The census
> behind the bottom line above is retracted (its keep-kill inference was
> valid only at the six value-alternating locations). The sound final
> state, §6: **336 + 398 of the 756 dead by certain closed conditions;
> 22 survivors at dimension ≤ 37 each.**

## 1. The objects, in plain words

A **candidate formula** `T` is a possible way to write the map we are
trying to rule out: five polynomials of degree 35. After all previously
sealed constraints, the space of possible `T`'s has exactly **39 remaining
degrees of freedom** (this packet reproduced that count from scratch).

A **blueprint** `r` (the campaign calls these boundary patterns) says, for
each special curve and surface in the source space, where the map is
supposed to send it. The sealed enumeration produced exactly **756**
blueprints compatible with degree 35. A **pair** is one candidate formula
together with one blueprint; the attack asks, for each blueprint: does any
of the 39-degrees-of-freedom worth of formulas actually do what the
blueprint says? If not, that blueprint is dead.

A blueprint's demands come in two kinds at each special location: either
"the formula takes a nonzero surface reading here, with this value" (a
KEEP), or "the surface reading is zero here and the true value appears one
level deeper" (a FLIP). One level of the geometry pins each reading to a
single line, so:

- a FLIP demand is one linear equation on the 39 degrees of freedom;
- a KEEP demand is the requirement that a specific linear expression is
  NOT identically forced to zero.

## 2. What was computed

**Step 1 — the six unavoidable flips.** At odd degree, six specific
locations are forced to flip in every blueprint (this is exactly the
mechanism the ODDZERO audit established). We built those six linear
equations from scratch — our own coordinates, not the enumeration's — and
imposed them on the 39-dimensional space. Their combined effect has rank
2. So: **every blueprint's formula space is at most 37-dimensional.**
The 6-row check matrix is saved in the JSON
(`universal_matrix_6x39`) so anyone can recompute its rank in any system.

Three built-in checks pass perfectly and are worth knowing about, because
they make a silent frame or bookkeeping error essentially impossible:

- **3,822 rigidity checks per prime** (each of the 637 building-block
  formulas, at each of the six locations, must give a reading lying
  exactly on the line the theory predicts — all do; a wrong coordinate
  choice would fail this massively);
- **702 profile checks** (readings that sealed constraints say must
  vanish, do vanish);
- the six equations, applied to the full 637-dimensional ambient space,
  have rank exactly 2 — the number the sealed ODDZERO audit computed by a
  completely different route.

**Step 2 — one full pair.** We took blueprint number 0, pulled its actual
demands out of the enumeration's own data (via the Stage-1 machinery's
frame, which turned out to use literally the same matrices — the
alignment worry was real but resolvable), and imposed them: its flip
demands cut the 37-dimensional space to 36; then we tested its keep
demands. **Every one of its 36 keep demands fails**: the readings it
insists are nonzero are identically zero for all 36 remaining degrees of
freedom. Blueprint 0 is dead. (31,850 rigidity checks passed along the
way — per prime.)

**Step 3 — why that death is not special.** The keep failures did not
depend on the blueprint: we computed, for every special location on the
first divisor row, whether ANY of the 39 degrees of freedom gives a
nonzero surface reading there. Answer: at **14 of the 18 value-carrying
locations, no candidate formula can take a nonzero surface reading at
all** — the geometry of the 39-dimensional space forces the map deeper at
those places, no matter what. Any blueprint that KEEPS any of those 14
locations is dead on arrival.

**Step 4 — the census.** Sweep all 756 blueprints against that table:

| fate | count |
|---|---:|
| dead earlier (wrong vanishing orders, packet §3) | 336 |
| dead now (keeps a location where keeping is impossible) | 420 |
| **still alive at this layer** | **0** |

Identical at both primes.

## 3. What this means, and what it does not

It does NOT yet mean degree 35 is closed. The 756 blueprints were built
believing surface readings were available everywhere the module theory
allowed; the new fact — 14 locations force every formula deeper — was not
part of that enumeration. The correct next step is to REBUILD the
blueprint list with those 14 forced-deeper locations imposed from the
start. Two outcomes are possible: the rebuilt list is empty (then degree
35 closes, after audit), or new, deeper blueprints exist (then the attack
continues one level down, on a much shorter list).

## 4. What could be wrong (read before trusting)

1. **The enumeration's tables rebuild differently run to run.** The link
   from a stored blueprint to its concrete demands goes through an index
   into tables that are rebuilt on each run, and we caught the rebuild
   being non-deterministic (same command, different flip/keep splits for
   blueprint 0 across runs — final censuses agreed, but this is a real
   defect). The census above is valid for the rebuild the script performed;
   the audit must first make blueprint-to-demand linkage stable (store
   demands by content, not by position), then re-run everything.
2. Only the FIRST of the two special divisor rows was used. That can only
   have made the kill weaker, not stronger — the second row adds demands.
3. The 14-location vanishing table is the load-bearing new fact. It is
   pattern-independent and cross-primed, but it deserves the same
   treatment the odd-zero got: an independent rebuild by someone trying to
   BREAK it (different coordinates, different extraction route).

Per the campaign's standing rule: the all-dead census is **FLAGGED, not
claimed**. Promotion gate: an adversarial audit at the ODDZERO standard
covering points 1–3, plus the deeper-level blueprint rebuild.

## 5. How to check this yourself

```sh
cd goal_runs_20260811/PAIR_ATTACK_D35/scripts
python3 director_worked_example.py 331     # ~2 minutes
python3 director_worked_example.py 661
```

Expect: rigidity 0 violations of 3,822 and of 31,850; ambient rank 2;
slice rank 2 (so 39 → 37); blueprint 0 DEAD; 14 forced-deeper locations;
census 336 / 420 / 0. Then, independently: load
`results/worked_example_p331.json`, take the 6×39 matrix stored under
`universal_matrix_6x39`, and row-reduce it modulo 331 in any system you
trust — the rank must be 2.

---

## 6. CORRECTION AND COMPLETION (same day, later)

**Correction (retraction of the census in §2 steps 3–4 and the "bottom
line").** The census argument killed blueprints for KEEPING a location
where the surface reading vanishes for all candidates. That inference is
only valid where a deeper reading CHANGES the demanded value — which
happens exactly at the six special locations (where the value alternates
with depth) and nowhere else. At the other locations the value is the
same at every depth, so a vanishing surface reading just means "delivered
deeper", not "impossible". Since every blueprint already flips the six,
the 420-kill claimed in §2 step 4 is **retracted**. What stands from
§§1–2: the 39 → 37 universal cut with all its checks; the vanishing table
itself (true, reinterpreted: readings live deeper at those 14 locations);
blueprint 0's cut to dimension 36. The all-dead headline is withdrawn.

**Completion (the sound finisher).** The blueprints' own line-row data
split them by the order of vanishing demanded along the 55 special lines:
0, 2, or 4 (`scripts/director_finish_d35.py`). Two computations, both
primes, saturation-checked:

- Vanishing to order ≥ 2 along the lines is **impossible**: imposing it
  on the 39-dimensional space leaves dimension exactly **0**.
  Consequently the **398** blueprints all of whose line-branches demand
  order ≥ 2 are dead — certainly, with no depth-semantics caveats.
- The **22** blueprints with an order-0 line branch survive; their
  line-branch assignments impose no further certain (closed) demands
  (`scripts/director_survivors22.py`), leaving each at dimension ≤ 37.

**Final census for degree 35, this session (both primes identical):**

| fate | count | mechanism |
|---|---:|---|
| dead | 336 | wrong vanishing orders on the plus-row (packet §3) |
| dead | 398 | line vanishing order ≥ 2 impossible in the 39-space |
| **live** | **22** | order-0 line branch; dim ≤ 37 each |

What remains to close the window, and belongs to the audit cycle: the
open-condition analysis on the 22 (nonzero-reading demands, with the
correct depth-parity semantics — the subtlety that sank the census), the
jet and realization layers, an independent hostile rebuild of the
order-2-impossibility and vanishing tables, and the reproducibility
repair from §4.1. Problem E remains OPEN; degree 35 is not closed; it is
now a fight over 22 explicit cells instead of 756.
