P25-UNDECIDED

# Degree-25 landing support status

The complete projective degree-25 landing scheme is **not decided** by this
packet.  No characteristic-zero covariant was constructed, and no exact unit
ideal was obtained for the complete special fibre.

The smallest unresolved piece is Stage B:

```text
b0 = 0, b1 != 0,
sat(<P3(q)b1>, (q0,...,q36)*(b1_0,...,b1_5)).
```

What is exact and independently replayed:

- the prime-89 rank-43 DVR model and its transfer boundary;
- complete landing-row rank `746` (not the retired 842-row packet);
- the `56 + 690` monic-border/seed decomposition;
- Stage A (`b0=b1=0`) is empty;
- deterministic linear syzygies `C(q)M2(q)=0` and all stored `P4/P3`
  contractions rebuild coefficient-by-coefficient.

What is not proved:

- the Stage B double saturation is the unit ideal;
- the Stage C `b0=1` saturation is the unit ideal;
- special-fibre or characteristic-zero degree-25 emptiness;
- a degree-25 covariant or the headline unirationality statement.

The strongest bounded Stage B run used all 256 verified contractions.  It was
stopped after `2572.24` seconds wall / `1812.78` seconds user CPU, with sampled
resident memory about `10.2 GiB`, before Singular returned even the first
`b1`-saturated basis.  Missing output is recorded only as a resource floor.

Problem E therefore remains **OPEN**.
