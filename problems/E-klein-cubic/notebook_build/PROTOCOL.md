# Problem E notebook protocol

`problems/E-klein-cubic/NOTEBOOK.md` is still the one file you grep. It is
still committed, still complete, still ordered the same way. The only change:
**it is generated, not edited.** Its sources live here, one file per entry, so
two sessions working at the same time no longer collide.

```
notebook_build/
  sections/NNN-<slug>.md              stable preamble + E01-E56 core, in NNN order
  entries/<date>-<nn>-<slug>.md       dated entries and supplements, in name order
  branches/<branch with / as %2F>     remote-branch inventory, one file each
  parent_head                         the pin: commit this revision was authored against
  generate_notebook.py                sections + entries -> NOTEBOOK.md, byte-deterministic
  reconcile.py                        regenerate + stamp the pin + stage    <- the one command
  register_branch.py                  add a branch marker
  migrate_split.py                    re-derive the sources from a hand-edited NOTEBOOK.md
  merge_driver.py                     git merge driver for the generated digest
  setup_merge_driver.sh               install that driver in your clone
  tests/                              acceptance tests T1, T2a, T2b, T3
```

The digest is exactly

```
"\n\n".join(part.strip("\n") for part in sections + entries) + "\n"
```

with both lists in plain filename order. Nothing is reordered or reformatted,
so heading anchors, cross-references, exit markers and grep context are the
same bytes they were before the split.

## Add an entry (the normal case)

1. Write `notebook_build/entries/<YYYY-MM-DD>-<nn>-<slug>.md`, where `<nn>` is a
   two-digit ordinal within that day (`ls entries/ | tail` to see the last one;
   if another session took your number, pick the next one — different slugs
   mean different file names either way, and the order is whatever the sort
   says). Start the file with its heading, exactly the markdown you want to see
   in the digest:

   ```markdown
   <!-- MY_PACKET_20260812 -->

   # Notebook supplement — 2026-08-12: what was found

   ## Exits
   ...
   ```

   Do not add blank lines at the top or bottom; the generator handles spacing.

2. `python3 problems/E-klein-cubic/notebook_build/reconcile.py`
   — regenerates `NOTEBOOK.md`, stamps `parent_head` to the current `HEAD`, and
   stages all of it.

3. `python3 problems/E-klein-cubic/scripts/check_manifest_parity.py` — must
   print `RESULT: PASS`. Commit.

Never edit `NOTEBOOK.md` by hand: the parity checker's `digest_freshness`
check compares it byte-for-byte against the generator output and fails.

To change stable material (dashboard, verification debt, the E01-E56 core, the
preamble), edit the matching file in `sections/`, then reconcile as above. Two
sessions editing two different sections do not conflict; two sessions editing
the same section conflict in that section only, which is a real content
conflict and is resolved on its merits.

## Register a branch

```
python3 problems/E-klein-cubic/notebook_build/register_branch.py            # current branch
python3 problems/E-klein-cubic/notebook_build/register_branch.py agent/foo  # a named one
python3 problems/E-klein-cubic/notebook_build/register_branch.py --missing  # what is unregistered
```

One new file per branch, so registration never conflicts — and the content is
deterministic (`branch: <name>`), so two sessions registering the *same* branch
write identical bytes and git resolves that add/add silently too. The file
*name* is authoritative (`/` encoded as `%2F`, `%` as `%25`). The checker reads
this directory; the old `manifest.json` `known_branches` array is gone, and if a
merge ever brings it back the checker unions it in and warns until
`migrate_split.py` moves it out again.

## Reconcile / resolve a merge

Source files merge cleanly by construction — different sessions write different
files. The *generated digest* is the one place two branches always touch the
same bytes, and it is never merged textually:

- **With the merge driver installed** (`sh notebook_build/setup_merge_driver.sh`,
  or just run `reconcile.py` once — it installs the driver if your clone lacks
  it): `git merge` completes with no conflict. The driver throws both textual
  sides away and regenerates the digest from the three-way merge of the *source*
  trees, and resolves `parent_head` to the merge's `HEAD`. Driver config cannot
  be committed, so each clone installs it once.
- **Without the driver**: the merge conflicts in `NOTEBOOK.md` (and
  `parent_head`). One command fixes it, and it is the only thing you should do:

  ```
  python3 problems/E-klein-cubic/notebook_build/reconcile.py --resolve-merge
  git commit --no-edit
  ```

  Never resolve a digest conflict by hand and never pick a side: regenerate.

If the driver reports that a *source* part conflicts, that is a genuine content
conflict in `sections/` or `entries/`. Resolve that file, then run
`reconcile.py --resolve-merge`.

## The pin

`notebook_build/parent_head` holds the commit the current notebook revision was
authored against. Semantics are unchanged from when it lived in the preamble:

- pre-commit, it equals `HEAD` (`reconcile.py` stamps it);
- post-commit / replay on a fresh clone, it equals the parent of the last commit
  that touched the notebook.

`scripts/check_manifest_parity.py` accepts either. It sits in its own file so
that stamping it no longer rewrites the digest on every branch.

## Re-deriving the sources (`migrate_split.py`)

If `NOTEBOOK.md` on `main` has drifted back to hand-edited form — an in-flight
branch landing an old-style supplement, say — rebuild the sources from it:

```
python3 problems/E-klein-cubic/notebook_build/migrate_split.py --force
python3 problems/E-klein-cubic/notebook_build/reconcile.py
python3 problems/E-klein-cubic/scripts/check_manifest_parity.py
```

It is idempotent and re-runnable: it parses whatever the digest currently says,
rewrites `sections/` and `entries/` from scratch, regenerates, and refuses to
proceed unless the regenerated bytes equal its input (after moving the pin out
of the preamble, the one declared transform). The head of the file — everything
before the first `#` heading after the title — becomes sections split at `##`;
the rest becomes entries split at `#` and at dated `##`. A heading that is not
preceded by exactly one blank line is deliberately *not* a split point, which is
what makes byte-identical reassembly true rather than hoped for.

## Tests

```
sh problems/E-klein-cubic/notebook_build/tests/run_tests.sh
```

T1 migrate/regenerate/parity, T2a zero-touch merge with the driver, T2b
one-command merge resolution without it, T3 grep-discoverability against the
pre-migration digest. They use scratch clones and leave the worktree alone.
