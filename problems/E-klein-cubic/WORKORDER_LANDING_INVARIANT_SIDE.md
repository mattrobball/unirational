# WORKORDER — The landing system in invariant coordinates
# (cycle 5, lane A: make the Hilbert ladder feasible at general degree)

Issued 2026-08-12 (director). python3 (+ msolve/M2 on reduced systems
only); never gap/gp/sage/magma (shell aliases trap); primes 331, 661; no
git; packet `goal_runs_20260812/LANDING_INVARIANT_SIDE/` only.

## A. The structural fact to exploit

Every landing equation on a window cell lies in the degree-`3d`
INVARIANTS: `c ↦ F(T_c)` maps the cell into `Inv^{3d} ⊂ Sym^{3d}W*`
(`F` invariant, `T_c` equivariant). Director probe
(`director_probes_20260812/`): `I(105) = 8555` while the observed
`P3(35) = 1380` — the ceiling is far from attained (open structural
question: what is the 7759-dim cubic kernel?). Practical payoff: the
invariant side is a VASTLY smaller ambient than raw `Sym³(cell)` from
`d = 36` up (`I(108) = 9545` versus `C(65,3) = 43680`), so representing
the sampled system by its invariant-coefficient vectors (Reynolds-basis
coordinates of `F(T_c)` rather than pointwise values) should un-wall the
ladder where `LANDING_SWEEP` reported "unsaturated / too large".

## B. Tasks

1. **Build the invariant-side representation** at `d = 35` first, as the
   control: coordinates of `F(T_c)` in a basis of `Inv^{105}` (Reynolds
   seeds of degree 105 — reuse the D34 engine's seed machinery; you only
   ever need the RANK, so a sampled/sketched basis of `Inv` functionals
   is fine if exactness is certified by saturation at two primes).
   Reproduce `P3(35) = 1380` in these coordinates.
2. **Exact `P3(36)`** (the sweep left it `≥ 1500`, unsaturated) and, as
   feasible, `P3(37)`, `P3(38)`; report `HF3(d) = C(cell+2,3) − P3(d)`
   and `P3(d)` versus the `I(3d)` ceiling (the probe's table). Any
   emerging closed form or stable ratio: state as observation with data.
3. **The d = 35 ladder, continued:** with the compressed representation,
   push `HF(4)` toward an exact value (the sealed bound is
   `≥ 40 330`); if the multiply is still too heavy exactly, give
   certified two-sided bounds (sketch ranks with two independent seeds,
   both primes). Any degree where `HF` provably stops growing relative
   to the free growth — report the structural meaning.
4. **The kernel question (exploratory, timeboxed):** the 7759-dim kernel
   of `Sym³(cell) → Inv^{105}` — test the obvious candidate explanation:
   polarization degeneracy from `T_c` ranging over a LINEAR space of
   tuples inside the quadratically-sized `M_35` (rank bounds via the
   tuple-multiplication structure). One clean statement or a documented
   dead end; do not sink the packet into it.

## C. Framing

Headline: "Problem E remains OPEN; this packet excludes no degree."
Packet protocol as always (`THEOREM.md` — never REPORT.md — scripts/,
results/ with heavy binaries gitignored + regeneration notes (50 MB
hosting limit), replayable `verifier.py`, `REGISTRATION_SNIPPET.md`
(ODDZERO format, entry E56, goal_run, tracked true), honesty tiering,
exits `LANDING-INV-*`, "Not claimed"). Summary ≤ 25 lines: P3/HF3 table
with ceilings, the HF(4) status at 35, kernel-question verdict.
