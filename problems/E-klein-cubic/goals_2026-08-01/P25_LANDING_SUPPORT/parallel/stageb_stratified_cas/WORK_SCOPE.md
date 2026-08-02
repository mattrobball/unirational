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

so that `V(H8)=L8`.  The large open-complement saturation jobs are generated
and hash-bound but are not launched while the shared PID 13036 Singular
computation is live.  The closed-`L8` compatibility producer and independent
verifier were run with hard 6 GiB RSS fences.  A unit complement result is
decisive in the stated open; a nonunit, timeout, crash, or absent result is a
nonverdict.

The exact closed-stratum status is now stronger than the initial work scope:

- Stage B is independently certified empty by the degree-six rank certificate.
- Normalized Stage C is independently certified empty by the degree-eight
  compatibility certificate in this directory.
