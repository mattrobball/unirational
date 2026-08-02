B-UNDECIDED

# Goal B status

The selected fixed-frame cubic has no `K_proj`-points while the auxiliary
projector open does, so its map on `K_proj`-points is not exhaustive.  No
rational orbit of the genuine twisted Fano section is known to bypass it.
Its infinity valuation is not the genuine target branch.  Exact
details are in `BRIDGE_THEOREM.md`,
`INCIDENCE_DIAGRAM.md`, and `BRANCH_COMPARISON.md`.

## Remaining gate (precise)

The missing implication is

```text
C(K_proj)=empty  =>  F14_T(K_proj)=empty
```

(neither proved nor refuted).  Full statement, F-scope consistency, and the
two closures are in `REMAINING_GATE.md`:

- **positive:** common isotropic right `D`-line for `H_T` outside the
  selected ternary frame;
- **negative:** exhaustiveness under
  `Γ = PGU(h_struct) ∩ Stab_{PGL_3(D)}(H_T)`.

Auxiliary projector non-exhaustiveness and Goal F infinity ≠ target branch
retire two false promotions; they do not decide the implication.  Fixed-frame
emptiness stays scoped to Goal F (`F-CONIC-CRITERION-EMPTY`); this packet does
not claim a headline.  The Klein-cubic headline remains **OPEN**.
