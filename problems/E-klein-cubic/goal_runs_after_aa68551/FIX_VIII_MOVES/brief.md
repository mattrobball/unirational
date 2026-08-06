# FIX-VIII-MOVES — the cross-V4 move catalog: experiment and assess

CAS worker packet (exploratory but disciplined). Work ONLY here;
repo root `/Users/worker/unirational`. Theory context:
`problems/E-klein-cubic/theory/FIX_VIII_italian.md` (read §§1–3
first). Prime p = 67; group recipe and payloads in
`problems/E-klein-cubic/goal_runs_after_ac61998/FIX_VII_GATE/payload/G660_p67.json`
(generators g11, s5, S; BFS closure gives the 660 projective
classes; director probe `director_probes_20260806/cycle55.py` shows
the working setup — reuse its code freely).

## Hard rules
No git. Incremental writes (`results/`, `payload/`). `CHECK`
lines in `results/checks.log` for every claim you assert. Final
chat report < 30 lines. python3 + numpy (+M2 if wanted). This
packet is EXPLORATORY: negative findings (no collapse) are
findings; report honestly. Wall-clock budget: aim ≤ 2 h.

## Setup (verify, cheap)
55 involutions; projectors `π_σ = (I−σ)/2` land in X (55/55); 165
commuting pairs in 55 V4-triples; triangles = plane sections of X;
chord map `chord(a,b) = D_aF(b)·a − D_bF(a)·b` (verify F(chord)=0
on X-point pairs). The base 55-cycle `Z(v) = {π_σ(v)}`.

## Experiment A — cross-V4 chord cycles (the main sweep)
Classify unordered pairs of DISTINCT involutions {σ,τ} by the
order of στ (2 ⇒ commuting/V4; else 3, 5, 6, 11 — verify which
occur and orbit sizes under conjugation; expected total C(55,2) =
1485 = 165 + noncommuting orbits). For each noncommuting orbit O:
  cycle `C_O(v) = { chord(π_σ v, π_τ v) : {σ,τ} ∈ O }` at ≥ 3
  random v. Measure and tabulate: |O|; |O| mod 3; all points on X
  (must — CHECK); # DISTINCT points (a collapse |C_O| < |O| is a
  FINDING — recheck at 2 more v and both signs of normalization);
  span rank; incidence of the points with the canonical loci:
  the 55 lines, the 55 triangle-planes, the 165 vertices, the 55
  plus-planes P(V₊(σ)), V(H) (Hessian quintic), the plane cubics
  E_σ (test F₀-membership inside the plus-plane), and the Hessian
  curve (test via the saturated ideal I_C reduced mod p — recipe
  in GATE's stage 4 scripts). Also compute the G-orbit structure
  OF the cycle points themselves (transitive? how many orbits?).

## Experiment B — Menelaus axes at special source points
The axis `ℓ_{V4}(v)` (chord-triple of the three sibling
projections; collinear). At random v the 55 axes have Plücker
rank 10 and (verify) generically no two axes meet. Now measure
rank + pairwise-incidence counts + incidences with canonical loci
for v ON: (i) X (random point of X(F_p)); (ii) V(H); (iii) a
plus-plane; (iv) a line L_τ (own triangle degenerates — describe
how, then measure the other 54); (v) a vertex; (vi) a point of
the Hessian curve C (get points from GATE's `cpoints_p67.json`);
(vii) a sextet point (C ∩ plus-plane). Any rank drop, new
incidence, or axis-collapse is a FINDING.

## Experiment C — second-layer reductions
For the most promising first-layer cycles (any collapse from A, or
the degree-110 orbit if none): search for CANONICAL pairings of
the cycle points: pairs lying on a common canonical object (same
triangle-plane, same plus-plane, same line) — if a G-stable
pairing exists, the chord-reduction of that pairing is a NEW
canonical cycle: compute its degree, degree mod 3, and iterate
once more. Track the reachable degrees mod 3; FLAG any canonical
cycle of degree ≡ 1 mod 3 with degree < 55, and especially any
of degree 1 (that would be the headline — triple-verify before
claiming, at 3 v's and both primes if you get there).

## Deliverables
`payload/orbit_table.json` (per-orbit measurements),
`payload/axes_table.json`, `payload/reductions.json`.
`REPORT.md` ≤ 60 lines: the tables compressed, findings ranked,
your assessment of which moves deserve the next packet. Exits:
`FIX-VIII-MOVES-COLLAPSE-FOUND` (any canonical collapse or
≡1-mod-3 cycle below 55) / `FIX-VIII-MOVES-NO-COLLAPSE` /
`FIX-VIII-MOVES-DEVIATION`.
