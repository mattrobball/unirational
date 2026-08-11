# Carried inputs — provenance

Two sealed packets this classification consumes are **not on `main`** at the time
of writing. They were read read-only (`git show` / `git archive`, no checkout, no
state-changing git), and the two derived data files needed here are carried in
this directory so the packet is self-contained and replayable.

| file | source | branch | repo path |
|---|---|---|---|
| `terminus_t2_strata.json` | `TERMINUS_STRATA_PW` `results/t2_strata.json` | `origin/agent/terminus-strata-pw-20260810` | `problems/E-klein-cubic/goal_runs_20260810/TERMINUS_STRATA_PW/results/t2_strata.json` |
| `terminus_t4_poset.json` | `TERMINUS_STRATA_PW` `results/t4_poset.json` | `origin/agent/terminus-strata-pw-20260810` | `problems/E-klein-cubic/goal_runs_20260810/TERMINUS_STRATA_PW/results/t4_poset.json` |

They are used **only** as a cross-check: `verifier.py` A6/A7 compare this
packet's independent component-level rebuild of the terminus census against
them. Nothing in the classification depends on them as an input — the source
complex is rebuilt from the 660 matrices in `scripts/s1source.py`.

`RECEIVER_LEDGER_X` (branch `origin/agent/receiver-ledger-x-20260810`) is
consumed as *statements*, all re-verified here at `p = 331, 661` in
`scripts/s1target.py` and `verifier.py` B1–B8: the ten target cells with their
sizes and stabilizers, the incidence rules, `X^{D12} = X^{A4} = X^{D10} =
X^{F55} = ∅`, and the receiver dichotomy (`X^H` finite for every `H ∉ {1, C2}`).
No file from it is carried.

`scripts/psl211.py` is a byte-identical copy of
`problems/E-klein-cubic/goal_runs_20260810/DUNCAN_CORNER_F2/scripts/psl211.py`
(on `main`), itself the split-prime reduction of the repository's exact
`Q(ζ₁₁)` matrices in `certificates/exact_weil_check.py`.
