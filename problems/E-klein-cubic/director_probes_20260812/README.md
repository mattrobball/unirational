# Director probes, 2026-08-12

`molien_ext126.py` — the exact Molien engine (copy of
`../director_probes_20260811/molien_director.py` with `DMAX = 126`; same
anchors, all passing). Purpose: the invariant ceiling for the landing
system. Every landing cubic `c ↦ F(T_c(x))` lies in the image of
`Sym³(cell) → Inv^{3d}` (the target is the degree-3d INVARIANTS, since
`F` is invariant and `T_c` equivariant), so `P3(d) ≤ I(3d)`.

Readout at d = 35: `I(105) = 8555` versus the observed `P3 = 1380` —
the ceiling is NOT attained (deficit 7175). So the landing system is
doubly degenerate: rank 1380 inside a target of 8555, over only 37
unknowns. Two consequences: (a) no clean rep-theoretic closed form for
`P3` at this level — the 7759-dimensional cubic kernel is structural and
unexplained (open question); (b) practical: the invariant-side ambient
(8555 at d=35; 9545 at d=36 versus 43680 for raw Sym³ of the 63-cell)
is the right coordinate system for pushing the Hilbert ladder at d ≥ 36
— dispatched as WORKORDER_LANDING_INVARIANT_SIDE.md.

I(3d) for the sweep windows: 8555 (105), 9545 (108), 10614 (111),
11776 (114), 13026 (117), 14379 (120), 15828 (123), 17391 (126).

`jacobian_rank_probe.py` / `jacobian_rank_probe_p331.json` — the
determinantal-layer probe at `d = 35`. Generic Jacobian rank on the
sealed 37-cell is **5** (three random members, Euler control
`J(w)·w = 35·T(w)` exact each time; ambient control also 5). Two
consequences:

1. `det J_T ≡ 0` is a NONTRIVIAL closed condition on the 37 parameters —
   its `x`-coefficients are quintics in the cell coordinates, and they
   are not satisfied by generic members.
2. But they vanish on the landing locus (differentiating `F(T) ≡ 0`
   gives `∇F(T)·J_T = 0`, and `∇F(T) ≢ 0` unless `T ≡ 0` since `X` is
   smooth, so `det J_T ≡ 0` follows). So they lie in the RADICAL of the
   landing ideal and **cannot cut the variety** — they can only enlarge
   the ideal.

That is exactly what the stalled Hilbert ladder needs: new degree-5
equations the cubic-only computation never had. Recommended next
measurement: how many independent quintics the determinant contributes,
and whether they lie in `I_5` (the degree-5 part of the ideal generated
by the 1380 cubics). The variety-cutting leverage, separately, must come
from the OPEN side — showing every landing solution has Jacobian rank
≤ 3, i.e. is not dominant.

**Correction to the sealed reading of the section probes:** origin-only
on random 4-dimensional subspaces of the 37-cell bounds the landing cone
only by `dim ≤ 33` (a cone of dim `k` meets a generic `m`-dim subspace
nontrivially iff `k + m ≥ 38`). The Hilbert data is far stronger: the
growth ratio `HF(4)/HF(3) ∈ [5.2, 11.0]` puts the cone dimension near
**7–9** (heuristic — asymptotic growth read at `t = 3, 4`).

`section_deficiency_probe.py` / `section_deficiency_p331.json` — the
landing system restricted to random sections of the 37-cell:

| m | dim Sym³(L) | rank | HF_L(3) | generic space would give |
|---|---|---|---|---|
| 6, 8, 10, 18 | 56, 120, 220, 1140 | full | 0 | full |
| 20 | 1540 | **1380** | 160 | 1380 |
| 22 | 2024 | **1380** | 644 | 1380 |

**No structural deficiency anywhere.** Through `m = 22` the landing
cubics restrict exactly as a generic 1380-dimensional space of cubics
would (and the restriction is injective on the global span from `m = 20`
on). The system's specialness is invisible to sections — which is also
why the sealed "origin-only" section probes carried so little: they ran
where every system behaves alike.

## CORRECTION (director, same day) — two claims withdrawn

1. **My "landing cone has dimension ≈ 7–9" estimate is WRONG** (stated
   earlier today from the `HF(4)/HF(3)` growth ratio). `HF(4) ≥ 40330`
   is not a measurement: `I₄` is spanned by `37 × 1380 = 51 060`
   products inside a 91 390-dimensional space, so `HF(4) ≥ 40 330` is
   forced by COUNTING ALONE, whatever the solution set is. A system with
   no nonzero solutions shows the same `HF(3) = 7759`, `HF(4) ≈ 40 330`.
   The ratio carries no dimension information at these degrees.
2. **The sealed conclusion "the linear-algebra ladder cannot close the
   `d = 35` certificate" is a NON SEQUITUR.** It was drawn from `HF(4)`
   being large — but degree 4 could never have been surjective:
   `37 × 1380 = 51 060 < 91 390`. **Degree 5 is the first degree where
   surjectivity is numerically possible at all**:
   `703 × 1380 = 970 140 > 749 398`. The ladder was stopped one degree
   short of the first degree that could have decided anything.

Net effect of this probe round: no evidence against emptiness (the
sections look generic, and a generic 1380-dimensional space of cubics in
37 variables has no nonzero zeros), and the emptiness route is NOT
closed — it is untested at the only degree that matters. The decisive
computation is the rank of the degree-5 Macaulay matrix (970 140
structured sparse rows, 749 398 columns; each row is a monomial shift of
a cubic, ≤ 9139 nonzeros).
