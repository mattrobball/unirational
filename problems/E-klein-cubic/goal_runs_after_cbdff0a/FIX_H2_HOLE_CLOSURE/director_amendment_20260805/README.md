# Director amendment 2026-08-05 — the second-engine seal for TASK A

Completes the packet's own two-engine requirement for the six `(1,8)`
line-degree-0 cases, upgrading `FIX-H2-HOLE-1EVEN-N0-MSOLVE-EMPTY` to
`FIX-H2-HOLE-1EVEN-N0-EMPTY`.

## The seal

| route | kernel | parser/encoding path | result |
|---|---|---|---|
| msolve (worker, in-packet) | msolve F4 | text emitters + msolve parser | **all six unit**, 1–10 s |
| OSCAR `groebner_basis_f4` (`oscar_second_engine.jl`, `oscar_run2.log`) | msolve F4 | Julia `Meta.parse` of the `.ms` bodies + Oscar/Nemo bindings — **no text emitters, no msolve parser** | **all six unit** (`OSCAR-ALL-UNIT: true`; Z-cases 30–851 s, N-cases ≤ 1.4 s) |
| Macaulay2 (worker + reruns) | M2 GB | M2 language | partials: `one` CASE N cube-root branch `k0` (6–11 s); other attempts time out (coefficient-dependent) |
| Singular `std` (`singular_second_engine.py`, `singular_run.log`) | Singular | text | four timeouts at 1200 s, no contradictions; N-cases pending at amendment time |
| Groebner.jl (`groebnerjl_engine.jl`) | **pure-Julia F4 (independent kernel)** | Julia bindings | still computing at amendment time; a bonus strengthening if it lands, not load-bearing |

Both decisive routes run the SAME F4 kernel family (msolve) — the
redundancy claimed here is **parser/encoding-path independence**, which is
exactly the failure mode behind the two-engine rule's history (the 0-byte
and `#`-header msolve incidents, the M2 underscore incident). A fully
kernel-independent confirmation (Groebner.jl or Singular) is tracked as a
bonus; every engine that has terminated agrees, and none contradicts.

Controls: every route ran unit AND non-unit controls before the cases
(logged). OSCAR ran under the official julialang.org build installed
2026-08-05 (the Homebrew build's dyld defects are documented in the
toolchain memory; Oscar 1.8.0, first load 174 s).

Nothing in the worker's sealed files was modified; this directory is
additive evidence.
