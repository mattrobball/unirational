# Work scope

This directory is the isolated output for
`GOAL_H4_11_5_GENERIC_TWIST.md`.  No sibling goal-run directory is an input
unless it is named in `SOURCE_BINDING.md`, and no sibling worker artifact was
modified to produce this packet.

The mathematical baseline is the pinned commit
`35fa8f59b6a1423cc89300aeaceefe91552be5ba`.  The worktree contained many
unrelated modifications and untracked goal packets; they were preserved.

The packet consumes the authoritative sealed `11:5` record in
`goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/`.  It does not consume the
alternate frame in `H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/` and does not mix
the two gauges' finite-field matrices.

All generated JSON is deterministic.  `verify.py` does not import
`produce.py`; it rebuilds the load-bearing group, frame, lattice, field,
Kummer, trace, and transition calculations independently.
