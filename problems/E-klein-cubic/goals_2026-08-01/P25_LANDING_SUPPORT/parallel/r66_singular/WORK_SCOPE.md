# Work scope

This directory is the isolated `r66` Singular-preparation worker.  It may read
the sealed upstream packet

```text
../global_compatibility/support_augmented_r66_stageBC.npz
```

but writes only here.  Its binding task is to regenerate the exact Stage-B
chart `q0=1, b1_0=1` over `F_89` and prepare lower-memory Singular jobs.

No CAS job was launched.  Every generated job is `PREPARED_NOT_RUN`; a
timeout, resource stop, crash, or completed nonunit basis is a nonverdict.
Only a completed exact unit ideal (scalar chart), or a completed equality
`N=R^6` (the stronger module job), is decisive.

