# Modular degree audit for the first varying `L_a` coordinate

At the deterministic decision prime `p=353`, the coordinate `L_a[0,1,0]`
was tested in the certified rank-12 `K_proj/P0` basis with

```text
x q(t) = sum_s p_s(t) beta_s,
deg p_s <= D, deg q <= D.
```

| `D` | samples | numerator columns | denominator columns | augmented rank | nullity |
|---:|---:|---:|---:|---:|---:|
| 4 | 3,300 | 840 | 70 | 910 | 0 |
| 5 | 3,300 | 1,512 | 126 | 1,638 | 0 |
| 6 | 3,300 | 2,520 | 210 | 2,730 | 0 |
| 7 | 5,000 | 3,960 | 330 | 4,290 | 0 |
| 8 | 7,500 | 5,940 | 495 | 6,435 | 0 |

The degree-eight test therefore proves only the modular floor `D >= 9` for
this equal numerator/denominator total-degree ansatz.  It is not a
characteristic-zero nonexistence theorem.  The exact Cramer DAG is retained
instead of promoting an invalid low-degree fit.

Replay uses the shared read-only scripts:

```sh
/opt/homebrew/bin/python3 -u ../C_PFAFFIAN_FANO/produce_la_samples.py
/opt/homebrew/bin/python3 -u ../C_PFAFFIAN_FANO/probe_la_rational_degree.py --degree 8
```
