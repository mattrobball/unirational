# Fixed-frame local gate: bounded stop

The exact selected membership question

```text
P in (P_A,P_B,P_Y)_m
```

was **not decided**.  Work stopped when the authoritative
`T_TARGET_BRANCH_INDEX3` audit showed that this fixed-frame gate cannot decide
the genuine Schur twist.

The strongest exact result obtained before the stop is a component separator
in the aligned good fibre at `p=13`.  Put

```text
J0 = (g1,g2,g3)|_(z=v=0) in F_13[a,b,y],
m0 = (a,b,y).
```

The exact colon computation produced a 269-term polynomial `q` with

```text
q in (J0:m0),    q(0)=5 != 0.
```

Therefore, after inverting `q`,

```text
(J0)_q = (m0)_q.
```

Thus the selected point on this special fibre is exactly the reduced isolated
component; the dimension-one global contamination is removed.  The polynomial
and its checks are printed in `special_fibre_min_separator_p13.log`.

This is only a modular special-fibre isolation theorem.  It does not lift the
separator in the free directions `(z,v)`, does not prove a characteristic-zero
statement, and gives neither membership nor nonmembership of `P` in the full
localized ideal.  Augmented-standard-basis, incremental-standard-basis, lift,
and direct-reduction variants did not finish within their bounded caps and are
nonverdicts.
