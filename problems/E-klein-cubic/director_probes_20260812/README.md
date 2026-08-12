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
