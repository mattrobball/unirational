# r66 pair-split retry: PREPARED_NOT_RUN

The exact ordinary-msolve retry is prepared but was not launched.

The source is independently regenerated from the bound r66 packet for the
already-audited Stage-B chart `q0=1,b1_0=1`.  Preparation must reproduce the
audited 41,537,116-byte source with SHA256
`9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b`.

The retry preserves the ordinary exact F4 command, four threads, seed,
monomial order, linear algebra, source, and field.  Its only non-path option
change is `-m 0` to `-m 100`.  Local msolve 0.10.1 documents `-m` as the
maximal number of pairs used per matrix.  Therefore it prevents the observed
1,708 degree-six pairs from entering one F4 matrix.  It does not promise a
fixed partition into 18 batches: new basis elements can change the later pair
list.  Hash reset remains OFF because the purpose of this first retry is to
isolate the pair-cap change.

The immutable fences are 1,200 seconds, 4.5 GiB aggregate process-group RSS,
four threads, at least 14 GiB free-plus-speculative memory before launch, and
a successful live process census showing no competing P25 bounded probe other
than shared PID 13036.  The runner fails closed on every unavailable `ps`
poll.

At the no-launch decision, the parent reported only about 5.85 GiB of
free-plus-speculative memory, below the required 14 GiB.  Memory is volatile:
the final preparation verifier observed a later snapshot above the threshold.
That later memory snapshot does not authorize a launch.  The managed sandbox
still denies the mandatory live `ps` census/RSS polling, the account's
escalation quota is exhausted until 2026-08-08, and the parent explicitly
instructed this worker not to launch.  No run artifact exists.
`verify_prepared_result.json` contains the exact final no-run snapshot.

A future completed exact unit ideal proves only this affine chart empty.  Any
other outcome is a strict nonverdict.

Preparation and replay:

```sh
/opt/homebrew/bin/python3 prepare_chart.py
/opt/homebrew/bin/python3 verify_prepared.py
```

Only after all launch gates pass and the parent has been messaged immediately
before launch, the proposed unsandboxed command is exactly:

```sh
/opt/homebrew/bin/python3 -u /Users/worker/unirational/problems/E-klein-cubic/goals_2026-08-01/P25_LANDING_SUPPORT/parallel/r66_pair_split/run_pair_split.py --confirm-parent-notified
```

It must not be invoked in the managed sandbox: an unavailable `ps` poll is a
binding failure, not permission to continue.
