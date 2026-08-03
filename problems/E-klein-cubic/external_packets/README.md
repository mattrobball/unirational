# external_packets — archival snapshots of branch-only evidence

Immutable copies of Problem E packets that exist only on unmerged agent
branches, archived here so their evidence is reproducible from `main`.
**Non-canonical**: presence here is archival, not endorsement — each packet's
mathematical status is whatever its own STATUS.md states, read under
NOTEBOOK.md's binding rules, and neither packet has been merged into the
canonical `goal_runs_*` trees.

| Snapshot | Source branch | Branch head (pinned) | Notebook entry |
|---|---|---|---|
| `g3p-a5-semilinear-20260802_G3P_A5_SEMILINEAR_QUADRATIC/` | `agent/g3p-a5-semilinear-20260802` (`goal_runs_after_eb21458/G3P_A5_SEMILINEAR_QUADRATIC/`) | `086e08928bd3a0d360018e6f809739517f72702e` | E17 |
| `m3-sarkisov-section-residual_M3_SARKISOV_SECTION/` | `agent/m3-sarkisov-section-residual` (`goal_runs_after_bd610a/M3_SARKISOV_SECTION/`) | `6fdac74fc2c850dd062288691bf6daba5ec0228d` | E24 |

Snapshots were produced with `git archive <branch> -- <packet path>`; byte
identity with the pinned branch heads can be re-checked the same way. A
merge-or-retire decision for both branches is tracked in NOTEBOOK.md's
verification debt.
