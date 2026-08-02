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

## Fences and monitoring (2026-08-02 update)

Hard review: the historical **4.5 GiB** RSS fence is **theater** after the
~**4.275 GiB** incomplete stop.  Defaults are now:

| Fence | Default | Flag range |
|---|---:|---|
| RSS | **16 GiB** | 8–32 GiB (`--rss-gib`) |
| Wall | **1200 s** | 60–3600 s (`--timeout-seconds`) |
| Threads | 4 | fixed |
| Prelaunch free+speculative | ≥14 GiB | fixed |

The runner **does not require `ps`**.  Live process census and RSS use macOS
`libproc` (`proc_listpids` / `proc_pidinfo`) plus best-effort
`sysctl(KERN_PROCARGS2)` argv strings.  Every unavailable census or RSS poll
fails closed.

## Why still not launched

At the latest gate check:

- free+speculative memory was far above 14 GiB;
- libproc census **succeeded**;
- a **competing COV_M1** msolve job was live (~3.5 GiB), so the competing-probe
  gate fails;
- mission policy prefers structural alternates while COV is heavy.

No run artifact exists under this directory.  See parent
`LAUNCH_READINESS.md` and `ALTERNATE_ATTACK.md`.

A future completed exact unit ideal proves only this affine chart empty.  Any
other outcome is a strict nonverdict.

Preparation and replay:

```sh
/opt/homebrew/bin/python3 prepare_chart.py
/opt/homebrew/bin/python3 verify_prepared.py
```

Only after all launch gates pass and the parent has been messaged immediately
before launch, the proposed command is exactly:

```sh
/opt/homebrew/bin/python3 -u /Users/worker/unirational/problems/E-klein-cubic/goals_2026-08-01/P25_LANDING_SUPPORT/parallel/r66_pair_split/run_pair_split.py --confirm-parent-notified --rss-gib 16 --timeout-seconds 1200
```
