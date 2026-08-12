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
