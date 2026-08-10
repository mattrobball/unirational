# Provenance of the 2026-08-10 salvage

The worker session dispatched on 2026-08-06 (see `INFLIGHT.md`) was killed
while `msolve` was running.  It left uncommitted edits in the working tree of
the main checkout `/Users/worker/unirational` at
`problems/E-klein-cubic/goal_runs_after_88f0967/FIX_VIII_A5LADDER/`.  Those
edits were adjudicated file by file against `main` (`263dd8d`) before any of
them was copied here.  Nothing from that dirty tree was assumed correct.

## Adopted (genuine partial progress)

| file | change | why adopted |
|---|---|---|
| `scripts/fq.py` | `optimize=True` on four `np.einsum` calls | pure contraction-order hint; no semantic change |
| `scripts/loci.py` | `optimize=True` on five `np.einsum` calls | same |
| `scripts/land.py` | `optimize=True`; `write_ms` / `write_ms_ext` accept an empty cubic row list | needed to emit a generator file that carries only the second-order quadrics |
| `scripts/probe_quadrics.py` | unpack 4-tuples from `enumerate_branches` | bug fix: `enumerate_branches` returns `(key, space, contractions, combo)` and the committed probe unpacked three |
| `scripts/stage3_land.py` | quadric stage reworked: work in the effective subfield, stop as soon as the quadrics span, and — when the full-rank linear certificate is out of reach — hand the quadrics **alone** to `msolve`; new verdict `EMPTY-QUADRICS-GB`; new ledger line `land_verdicts_d<d>_p<p>` | strictly more decisive: the quadrics-only system is ~10x smaller than the saturated cubic system and every quadric is a necessary landing condition, so emptiness of its zero set still certifies an empty branch cone |
| `verifier.py` | `VDMAX` environment cap on the degree loop; ignore non-numeric `argv` | lets the independent verifier be re-run at a bounded degree without editing it |
| `REPORT.md` | prose only (Galois-orbit sentence, "strengthening of the briefed method" clarification) | both versions carry the same placeholders; the dirty text is the more accurate description of what was run |
| `payload/land_p67_8_12.json` | adds the `d = 10` block | real new result; `d = 8, 9` blocks agree with the committed ones |
| `payload/land_p199_8_12.json`, `payload/verdicts.json` | new | the per-degree ledger the run was writing |
| `results/land_d9_b1_p199.ms` | regenerated generator file | same branch, different random sample; harmless |
| `results/*.log`, `results/*.out` | run logs | ignored by the repository `.gitignore`, copied here only so that new `CHECK` lines append to the existing ledger |

## Not adopted (abandoned probes / dead artifacts)

* `results/land_d11_b1_p{67,199}.ms`, `results/land_d11_b1_p{67,199}_q.ms`,
  `results/land_d12_b1_p67.ms`, `results/land_d10_b3_p67.ms` — msolve inputs
  whose `.out` files are **0 bytes**.  Under the packet's own msolve landmine
  rule a 0-byte output is an error, not a verdict.  These are the record of
  where the session died, not results.  They are regenerated from scratch by
  this branch and are `.gitignore`d in any case.
* `scripts/__pycache__/` — build residue.
* `payload/land_p67_8_8.json`, `payload/land_p67_9_9.json` — single-degree
  runs superseded by the `8..12` sweep; the committed copies are kept.

## Reconstructed stopping point

`payload/verdicts.json` and `results/checks.log` show the ladder finished
`d = 2 .. 10` at **both** primes with every branch `EMPTY`.  The last two lines
written to the run logs are

```text
d=11: 80 nonzero branch spaces -> 30 Galois orbits      (p = 67)
d=11: 80 nonzero branch spaces -> 50 Galois orbits      (p = 199)
```

and no branch verdict follows.  The session was inside the **first** `d = 11`
branch (`b1`, `dim 45`, `k_eff = 1`) at both primes when it was killed.
