# Isolated work scope: r66 normalized Stage C on `D(q0)`

This directory is owned by the `r66_stagec` worker.  It reads, but does not
modify, the sealed packet

```text
P25_LANDING_SUPPORT/parallel/global_compatibility/support_augmented_r66_stageBC.npz
```

The only mathematical object prepared here is the affine system over
`F_89` obtained from the 66 selected necessary contractions

```text
P4(q) + P3(q) b1 = 0
```

after the normalizations `q0=1` and `b0=1`.  It has 42 affine variables:
six `b1` variables and `q1,...,q36`.

No CAS job is launched while the main Singular process is active and memory
is contested.  A completed exact unit ideal would prove emptiness of this one
selected affine chart.  A nonunit result, timeout, resource stop, crash,
missing sentinel, or incomplete output is a nonverdict.  In particular, this
directory alone cannot establish global Stage-C emptiness or a P25 verdict.

