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

> **DISAMBIGUATION (director, after a reader was misled by the wording
> above — read this before §CORRECTION).** Two polynomial rings are in
> play and "degree" means different things in each:
>
> * `C[x₀..x₄]` — the SOURCE coordinates. `deg T = d` lives here; it is
>   the campaign's degree. **Every `d ≤ 34` is excluded and sealed; the
>   first open window is `d = 35`, unchanged by anything in this file.**
> * `C[c₁..c₃₇]` — the PARAMETER coordinates of the sealed cell at the
>   fixed degree `d = 35`. For each `x`, the landing condition
>   `F(T_c(x)) = 0` is a CUBIC in `c`; the ideal these generate is graded
>   in `c`-degree 3, 4, 5, …
>
> Every "degree 3/4/5" in the CORRECTION section above is a `c`-degree —
> a graded piece of the parameter ideal at `d = 35` — never a map degree.
> "The ladder was stopped one degree short" means: the parameter ideal
> was computed in `c`-degrees 3 and 4 only, and `c`-degree 5 is the first
> piece that can decide emptiness.

`cone_dimension_probe.py` — bounding the dimension of the landing cone
`V = {c ∈ 37-cell : F(T_c(x)) ≡ 0}` at `d = 35`. Two levers make this
cheap where the sealed attempt was not: a SUBSET of the landing cubics
suffices (`V(subset) ⊇ V`, so a trivial subset locus proves `V = {0}`),
and a generic `m`-section bounds the cone (`dim(V ∩ L) = max(0, k+m−37)`,
so `V ∩ L = {0}` gives `dim V ≤ 37 − m`).

**Result obtained for free from the deficiency measurements**
(no Gröbner basis needed): at `m = 18` AND `m = 19` the restricted
cubics span ALL of `Sym³(L)` — in particular every `t_i³` lies in the
restricted ideal, so `V ∩ L = {0}` outright. Hence

> **dim V ≤ 18** (landing cone at `d = 35`, both from `m = 19`;
> the sealed record's section probes gave only `≤ 33`).

The free argument stops at `m = 19`: `C(21,3) = 1330 ≤ 1380 < 1540 =
C(22,3)`, so from `m = 20` on the restricted cubics can no longer fill
`Sym³(L)` and a real Gröbner computation is required. Status of that
step: Macaulay2 timed out (30 min) on 35 cubics in 20 variables, but
**msolve CLEARED the `m = 20` rung** (240 generators,
`cone_m20_p331.ms`): the leading ideal contains a pure power of every
one of the 20 variables (exponents 3,3,…,3,4,4,4,4,4,5,5,5,5,5), so the
restricted ideal is zero-dimensional and `V ∩ L₂₀ = {0}`. Hence

> **dim V ≤ 17** (landing cone at `d = 35`, machine-certified at
> `p = 331` via the leading ideal; `cone_m20_lead.out`).

Ladder status: free rungs to `m = 19`; `m = 20` cleared by msolve.
Each further rung tightens by one. The decisive case is the unrestricted
system (`m = 37`), where `V = {0}` would close `d = 35` outright — that
is the sealed record's walled computation, retried here with far fewer
generators (a subset suffices, and 45–60 cubics already overdetermine
37 unknowns).
