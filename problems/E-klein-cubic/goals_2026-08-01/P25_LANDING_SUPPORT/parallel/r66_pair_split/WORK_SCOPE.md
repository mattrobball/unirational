# r66 Stage-B pair-split retry

This directory is the complete write boundary for this worker.

The prepared computation is the already-audited affine chart

```text
q0 = 1, b1_0 = 1
```

of the exact 66-row Stage-B incidence system over `F_89`.  The chart source is
regenerated independently from
`../global_compatibility/support_augmented_r66_stageBC.npz` and must have the
already-audited SHA256
`9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b`.

The ordinary msolve retry preserves every baseline option except

```text
-m 0  ->  -m 100
```

so no F4 matrix selects more than 100 pairs.  Hash-table reset remains off.
Default fences: 1,200 seconds wall, **16 GiB** live RSS (flag range 8–32),
four threads.  The historical 4.5 GiB fence is retired as theater after the
~4.28 GiB incomplete stop.

No launch is permitted unless all of the following hold:

1. free plus speculative memory is at least 14 GiB;
2. a live process census succeeds via **libproc** (not `ps`);
3. no other competing CAS probe is active, except shared PID 13036 if still
   the historical boundary job;
4. the parent agent has been messaged immediately before launch.

The runner fails closed if either `vm_stat` or any live libproc RSS/census
poll is unavailable.  A completed exact unit ideal decides emptiness of this
chart only.  Every timeout, resource stop, crash, incomplete output, or
completed nonunit output is a strict nonverdict.

