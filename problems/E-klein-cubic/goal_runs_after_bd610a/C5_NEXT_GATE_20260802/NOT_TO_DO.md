# Explicit non-goals and quarantines (C5 / C front)

## Stale RUR quarantine

Do **not** consume any namespace-mutated cyclotomic RUR, conjugate RUR
siblings, or historical ambient-degree-12 RUR blobs outside the sealed hashes
in:

```text
goals_after_bd610a/C5_PROJECTOR_INCIDENCE/INPUT_MANIFEST.json
goals_after_bd610a/C5_PROJECTOR_INCIDENCE/morita_generic_dag.json  (source_sha256)
goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/c2_morita.json
```

Authoritative char-0 projector parameter RUR:

```text
goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/ambient_degree12_rur_char0.json
```

Any older `tmp/*rur*`, mutated Singular dumps, or unhashed conjugacy copies
are **out of band**. If a second copy disagrees with the sealed SHA-256, stop
with `C5-CANONICAL-INPUT-FAIL`.

## Do not

1. **Expand full \(L_a\) / \(36^3\) structure constants.** Use lazy Cramer-DAG /
   rectangular multiplication oracles already installed.
2. **Re-run the literal self-adjoint idempotent incidence**
   \(e^2=e\), \(\sigma(e)=e\), \(\operatorname{Trd}(e)=2\), \(e S_i e=0\) with \(S_0=1\).
   It is the unit ideal; that encoding is refuted.
3. **Promote modular emptiness or modular points to \(K_{\mathrm{proj}}\)** without
   reconstruction, holdout, and descent.
4. **Claim a Fano / common-line point** without original-equation (Plücker /
   genuine \(F_{14,T}\)) substitution.
5. **Use Magma.**
6. **Treat pairwise Amer–Brumer common lines as a five-form point.**
7. **Treat degree-≤16 (or sparse deg-17) covariant emptiness as all-degree.**
8. **Treat Hensel/formal lift of a smooth \(p=23\) seed as a rational section.**
9. **Co-schedule multi-GiB F4/`msolve` jobs** with other heavy Wave-B CAS.
10. **Edit sealed historical packets** under
    `goals_after_bd610a/C5_PROJECTOR_INCIDENCE/` or sealed `goals_2026-08-01/C_*`
    exits; write only under new `goal_runs_after_bd610a/C5_*` dirs (or clear
    live STATUS with director authority).
11. **Confuse the auxiliary Pfaffian characteristic cubic** or ambient
    projector scheme with \(F_{14,T}\).
12. **Lower coefficients into Hironaka 12-basis by unconstrained interpolation**
    without unisolvent orbit verification and holdout.

## Preferred positive paths (when resuming)

- Finish `G_MORITA_SOURCE_INTERPRETER` (this packet’s gate).
- Then `G_HENSEL_ELIMINANT_LINEAR_FACTOR` on the \(q_0=1\) chart, **or**
  a controlled char-0 chart of the already-serialized generic Plücker system
  with G-descent.
- Keep multiprime modular probes light; prepare Singular/`msolve` inputs rather
  than OOM on full expanded charts.
