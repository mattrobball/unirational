# Q Schur descent — isolated Codex root run

This directory is the exclusive write scope for the Codex root run begun on
2026-08-01.  The initially selected conventional path `Q_SCHUR_DESCENT/` was
claimed and modified concurrently during commit
`80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c` (`waypoint`).  It is therefore
treated here only as read-only evidence; no result in this directory relies on
ownership of uncommitted files there.

The authoritative target is `../GOAL_Q_SCHUR_INDEX_ONE_DESCENT.md`.  The only
accepted terminal outcomes are:

1. a verified `K_Schur`-point of the original full twist, followed by the
   accepted bridge to the headline action; or
2. a genuine obstruction proving the full generic Schur twist has no
   `K_Schur`-point, hence a headline counterexample.

An index-one zero-cycle, failure of selected fibrations, a bounded-degree
search, or the absence of a currently known point is not a terminal outcome.

All checked-in and concurrent artifacts are re-audited from the live worktree;
the checkpoint consumed at isolation time is
`80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c`.

The exact packet status is in `STATUS.md`; `REPLAY.md` gives the fast verifier
and complete regeneration commands.  `SEAL.json` hashes every regular file in
this isolated directory.

The packet also contains `QUARTIC_FRONTIER.md`, which reduces any no-point
branch to a primitive linearly independent `A4/S4` quartic, and
`QUARTIC_TANGENT_AUDIT.md`, which exactly refutes automatic degree lowering by
the most direct fourfold-tangent twisted-cubic operation.

`COMPLETION_AUDIT.md` maps every binding positive and negative requirement to
current evidence.  It records why the sealed packet is not a complete
resolution and why the repeatedly unchanged all-degree/full-twist boundary
meets the persistent-goal blocked criterion.
