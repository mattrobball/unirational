# Authoritative source binding

The implementation audit at the pinned state designates

```text
goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/
```

as the authoritative proper-subgroup packet.  This H4 packet consumes only
its `label = "11:5"` record and its subgroup bridge.

| input | SHA-256 |
|---|---|
| `goals_after_35fa8f/GOAL_H4_11_5_GENERIC_TWIST.md` | `8b2e48f89ebc8daa971e618d341390e6803d21f22f411b88abb3dcc28cf0ef2f` |
| `goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json` | `e97a32d6f22a8028528bc2b4d27ee009901caeb047fd2ffe5ac2bdd1fab743cd` |
| `goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/BRIDGE.md` | `660577dd5848eb5f9acb747b4c82877968d3ba5c59181581eb4ba8907d8aa2f8` |
| `certificates/exact_weil_check.py` | `14c9bda195ccc39e3ae2cd6d6d42bbb8f45397e114b5137947fb41dd665cc2b2` |
| `certificates/strata/exact_strata.py` | `a630b3a85d41eb0b60902a81cf8851c15fd0aa9c615c2d8a36584071dca34810` |
| `certificates/strata/normal_characters.py` | `8cb2a9a7d8b0405672308fc300cecd639de994cd73e29ef272328fa919e5b671` |

The canonical record uses the projective generators

\[
 \begin{pmatrix}1&1\\0&1\end{pmatrix},\qquad
 \begin{pmatrix}2&0\\0&6\end{pmatrix}
\]

and the seed

\[
 c(y)=\frac{y_0}{y_0+2y_1+3y_2+4y_3+5y_4}.
\]

Its anchor at `p=89`, `zeta11=2`, `y=(1,1,1,1,3)` has denominator
product `86`, frame determinant `87`, and 35 recorded cubic coefficients.
Both `produce.py` and the independent verifier reproduce this exact gauge.

For the structural calculation it is convenient to square both displayed
generators inside the same subgroup.  This gives

```text
T = rho([1,2,0,1]) = diag(zeta^(1,9,4,3,5)),
P = rho([4,0,0,3]),  P(e_i)=e_(i+1).
```

They satisfy `P*T*P^-1=T^5` and generate the same order-55 subgroup.  The
new trace frame is compared to the canonical frame by the invariant matrix
`A_canonical^-1 B`; it is not silently substituted for it.
