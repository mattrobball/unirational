# Work scope

This directory contains a stratified exact-CAS continuation for Stage B and
Stage C.  The independently certified closed stratum is

```text
L8 = P<span(q4,...,q11)>.
```

All open-complement jobs use

```text
H8 = (q0,...,q3,q12,...,q36),
```

so that `V(H8)=L8`.  No job in this directory is launched while the shared
PID 13036 Singular computation is live.  A unit result is decisive in the
stated stratum; a nonunit, timeout, crash, or absent result is a nonverdict.

