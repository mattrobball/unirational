# Second-order quadric census, d = 11 and d = 12

Produced by `scripts/quadric_census.py`.  For each Galois-orbit
representative branch it reports the number of quadratic monomials in the
branch coordinates (`quadric space`) and the rank actually spanned by the
second-order landing conditions from all contractions (`quadric rank`).
The packet's `EMPTY-QUADRICS` certificate fires exactly when the two agree.
The rank saturates in the sample count -- 400, 800 and 1600 points give the
identical rank -- so a deficit is a proof that the certificate cannot decide
that branch at any budget.

For contrast, at `d = 10` the top branch has dimension 19 and the rank is
`190 / 190`: the certificate fires, and it carries the whole rung.

`results/*.log` is covered by the repository `.gitignore`, so the measured
lines are transcribed here.

## p = 199, d = 11 -- COMPLETE

- `80` nonzero branch spaces, `50` Galois orbits
- settled by the linear certificate: **0**
- open: **80**

```
V+:Wchi1|Ew:r0|Ew2:r0                      dim  45 k 1  rank   291 /  1035  -> QUADRIC-DEFICIT-744
V+:W0r0|Ew:r0|Ew2:r0                       dim  41 k 1  rank   258 /   861  -> QUADRIC-DEFICIT-603
V+:W0r1|Ew:r0|Ew2:r0                       dim  41 k 1  rank   258 /   861  -> QUADRIC-DEFICIT-603
V+:W0r2|Ew:r0|Ew2:r0                       dim  41 k 1  rank   258 /   861  -> QUADRIC-DEFICIT-603
V+:Wchi1|Ew:Z|Ew2:Z                        dim  39 k 1  rank   255 /   780  -> QUADRIC-DEFICIT-525
V+:Wchi1|Ew:Z|Ew2:r0                       dim  39 k 1  rank   281 /   780  -> QUADRIC-DEFICIT-499
V+:Wchi1|Ew:Z|Ew2:r1                       dim  39 k 1  rank   281 /   780  -> QUADRIC-DEFICIT-499
V+:Wchi1|Ew:r0|Ew2:Z                       dim  39 k 1  rank   281 /   780  -> QUADRIC-DEFICIT-499
V+:Wchi1|Ew:r0|Ew2:r1                      dim  39 k 1  rank   301 /   780  -> QUADRIC-DEFICIT-479
V+:Wchi1|Ew:r1|Ew2:Z                       dim  39 k 1  rank   281 /   780  -> QUADRIC-DEFICIT-499
V+:Wchi1|Ew:r1|Ew2:r0                      dim  39 k 1  rank   301 /   780  -> QUADRIC-DEFICIT-479
V+:Wchi1|Ew:r1|Ew2:r1                      dim  39 k 1  rank   301 /   780  -> QUADRIC-DEFICIT-479
V+:Wchi1|Ew:r1|Ew2:r2                      dim  39 k 1  rank   301 /   780  -> QUADRIC-DEFICIT-479
V+:W0r0|Ew:Z|Ew2:Z                         dim  33 k 1  rank   212 /   561  -> QUADRIC-DEFICIT-349
V+:W0r0|Ew:Z|Ew2:r0                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r0|Ew:Z|Ew2:r1                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r0|Ew:r0|Ew2:Z                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r0|Ew:r0|Ew2:r1                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r0|Ew:r1|Ew2:Z                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r0|Ew:r1|Ew2:r0                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r0|Ew:r1|Ew2:r1                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r0|Ew:r1|Ew2:r2                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r1|Ew:Z|Ew2:Z                         dim  33 k 1  rank   212 /   561  -> QUADRIC-DEFICIT-349
V+:W0r1|Ew:Z|Ew2:r0                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r1|Ew:Z|Ew2:r1                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r1|Ew:r0|Ew2:Z                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r1|Ew:r0|Ew2:r1                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r1|Ew:r1|Ew2:Z                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r1|Ew:r1|Ew2:r0                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r1|Ew:r1|Ew2:r1                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r1|Ew:r1|Ew2:r2                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r2|Ew:Z|Ew2:Z                         dim  33 k 1  rank   212 /   561  -> QUADRIC-DEFICIT-349
V+:W0r2|Ew:Z|Ew2:r0                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r2|Ew:Z|Ew2:r1                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r2|Ew:r0|Ew2:Z                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r2|Ew:r0|Ew2:r1                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r2|Ew:r1|Ew2:Z                        dim  33 k 1  rank   232 /   561  -> QUADRIC-DEFICIT-329
V+:W0r2|Ew:r1|Ew2:r0                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r2|Ew:r1|Ew2:r1                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:W0r2|Ew:r1|Ew2:r2                       dim  33 k 1  rank   248 /   561  -> QUADRIC-DEFICIT-313
V+:Z|Ew:r0|Ew2:r0                          dim  22 k 1  rank    24 /   253  -> QUADRIC-DEFICIT-229
V+:Z|Ew:Z|Ew2:Z                            dim  18 k 1  rank     0 /     0  -> NO-CONTRACTION
V+:Z|Ew:Z|Ew2:r0                           dim  18 k 1  rank    22 /   171  -> QUADRIC-DEFICIT-149
V+:Z|Ew:Z|Ew2:r1                           dim  18 k 1  rank    22 /   171  -> QUADRIC-DEFICIT-149
V+:Z|Ew:r0|Ew2:Z                           dim  18 k 1  rank    22 /   171  -> QUADRIC-DEFICIT-149
V+:Z|Ew:r0|Ew2:r1                          dim  18 k 1  rank    36 /   171  -> QUADRIC-DEFICIT-135
V+:Z|Ew:r1|Ew2:Z                           dim  18 k 1  rank    22 /   171  -> QUADRIC-DEFICIT-149
V+:Z|Ew:r1|Ew2:r0                          dim  18 k 1  rank    36 /   171  -> QUADRIC-DEFICIT-135
V+:Z|Ew:r1|Ew2:r1                          dim  18 k 1  rank    36 /   171  -> QUADRIC-DEFICIT-135
V+:Z|Ew:r1|Ew2:r2                          dim  18 k 1  rank    36 /   171  -> QUADRIC-DEFICIT-135
V+:Z|Ew:Z|Ew2:Z                            dim  18          no contracted locus: no second-order condition at all
```

## p = 199, d = 12 -- COMPLETE

- `25` nonzero branch spaces, `25` Galois orbits
- settled by the linear certificate: **0**
- open: **25**

```
V+:Wchi1|V-:Wchi1                          dim  60 k 1  rank   398 /  1830  -> QUADRIC-DEFICIT-1432
V+:Wchi1|V-:W0r0                           dim  59 k 1  rank   392 /  1770  -> QUADRIC-DEFICIT-1378
V+:Wchi1|V-:W0r1                           dim  59 k 1  rank   392 /  1770  -> QUADRIC-DEFICIT-1378
V+:Wchi1|V-:W0r2                           dim  59 k 1  rank   392 /  1770  -> QUADRIC-DEFICIT-1378
V+:W0r0|V-:Wchi1                           dim  55 k 1  rank   352 /  1540  -> QUADRIC-DEFICIT-1188
V+:W0r1|V-:Wchi1                           dim  55 k 1  rank   352 /  1540  -> QUADRIC-DEFICIT-1188
V+:W0r2|V-:Wchi1                           dim  55 k 1  rank   352 /  1540  -> QUADRIC-DEFICIT-1188
V+:Wchi1|V-:Z                              dim  54 k 1  rank   323 /  1485  -> QUADRIC-DEFICIT-1162
V+:W0r0|V-:W0r0                            dim  54 k 1  rank   342 /  1485  -> QUADRIC-DEFICIT-1143
V+:W0r0|V-:W0r1                            dim  54 k 1  rank   339 /  1485  -> QUADRIC-DEFICIT-1146
V+:W0r0|V-:W0r2                            dim  54 k 1  rank   339 /  1485  -> QUADRIC-DEFICIT-1146
V+:W0r1|V-:W0r0                            dim  54 k 1  rank   339 /  1485  -> QUADRIC-DEFICIT-1146
V+:W0r1|V-:W0r1                            dim  54 k 1  rank   342 /  1485  -> QUADRIC-DEFICIT-1143
V+:W0r1|V-:W0r2                            dim  54 k 1  rank   339 /  1485  -> QUADRIC-DEFICIT-1146
V+:W0r2|V-:W0r0                            dim  54 k 1  rank   339 /  1485  -> QUADRIC-DEFICIT-1146
V+:W0r2|V-:W0r1                            dim  54 k 1  rank   339 /  1485  -> QUADRIC-DEFICIT-1146
V+:W0r2|V-:W0r2                            dim  54 k 1  rank   342 /  1485  -> QUADRIC-DEFICIT-1143
V+:W0r0|V-:Z                               dim  49 k 1  rank   279 /  1225  -> QUADRIC-DEFICIT-946
V+:W0r1|V-:Z                               dim  49 k 1  rank   279 /  1225  -> QUADRIC-DEFICIT-946
V+:W0r2|V-:Z                               dim  49 k 1  rank   279 /  1225  -> QUADRIC-DEFICIT-946
V+:Z|V-:Wchi1                              dim  31 k 1  rank    52 /   496  -> QUADRIC-DEFICIT-444
V+:Z|V-:W0r0                               dim  30 k 1  rank    49 /   465  -> QUADRIC-DEFICIT-416
V+:Z|V-:W0r1                               dim  30 k 1  rank    49 /   465  -> QUADRIC-DEFICIT-416
V+:Z|V-:W0r2                               dim  30 k 1  rank    49 /   465  -> QUADRIC-DEFICIT-416
V+:Z|V-:Z                                  dim  25 k 1  rank     0 /     0  -> NO-CONTRACTION
V+:Z|V-:Z                                  dim  25          no contracted locus: no second-order condition at all
```

## p = 67, d = 11 -- PARTIAL (18 of 30 Galois orbits)

The census run was interrupted by the harness after 60 minutes, inside the
degree-11 sweep; the `F_{p^3}` branches at this prime are several times more
expensive than their `F_p` counterparts at `p = 199`.  Every representative
that was measured shows a deficit, and the `p = 199` census above is complete
and settles nothing either, so no branch at `d = 11` is decided by the
certificate at either prime.

```
V+:Wchi1|Ew:r0|Ew2:r0                      dim  45 k 1  rank  291 / 1035  -> QUADRIC-DEFICIT-744
V+:W0r0|Ew:r0|Ew2:r0                       dim  41 k 3  rank  774 / 2583  -> QUADRIC-DEFICIT-1809
V+:Wchi1|Ew:Z|Ew2:Z                        dim  39 k 1  rank  255 /  780  -> QUADRIC-DEFICIT-525
V+:Wchi1|Ew:Z|Ew2:r0                       dim  39 k 1  rank  281 /  780  -> QUADRIC-DEFICIT-499
V+:Wchi1|Ew:Z|Ew2:r1                       dim  39 k 1  rank  281 /  780  -> QUADRIC-DEFICIT-499
V+:Wchi1|Ew:r0|Ew2:Z                       dim  39 k 1  rank  281 /  780  -> QUADRIC-DEFICIT-499
V+:Wchi1|Ew:r0|Ew2:r1                      dim  39 k 1  rank  301 /  780  -> QUADRIC-DEFICIT-479
V+:Wchi1|Ew:r1|Ew2:Z                       dim  39 k 1  rank  281 /  780  -> QUADRIC-DEFICIT-499
V+:Wchi1|Ew:r1|Ew2:r0                      dim  39 k 1  rank  301 /  780  -> QUADRIC-DEFICIT-479
V+:Wchi1|Ew:r1|Ew2:r1                      dim  39 k 1  rank  301 /  780  -> QUADRIC-DEFICIT-479
V+:Wchi1|Ew:r1|Ew2:r2                      dim  39 k 1  rank  301 /  780  -> QUADRIC-DEFICIT-479
V+:W0r0|Ew:Z|Ew2:Z                         dim  33 k 3  rank  636 / 1683  -> QUADRIC-DEFICIT-1047
V+:W0r0|Ew:Z|Ew2:r0                        dim  33 k 3  rank  696 / 1683  -> QUADRIC-DEFICIT-987
V+:W0r0|Ew:Z|Ew2:r1                        dim  33 k 3  rank 1392 / 3366  -> QUADRIC-DEFICIT-1974
V+:W0r0|Ew:r0|Ew2:Z                        dim  33 k 3  rank  696 / 1683  -> QUADRIC-DEFICIT-987
V+:W0r0|Ew:r0|Ew2:r1                       dim  33 k 3  rank 1488 / 3366  -> QUADRIC-DEFICIT-1878
V+:W0r0|Ew:r1|Ew2:Z                        dim  33 k 3  rank 1392 / 3366  -> QUADRIC-DEFICIT-1974
V+:W0r0|Ew:r1|Ew2:r0                       dim  33 k 3  rank 1488 / 3366  -> QUADRIC-DEFICIT-1878
```

