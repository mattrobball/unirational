H-11_5-NORM-MODEL-PASS

# Goal H4 status

The exact generic `11:5` twist has been rewritten as a cyclic trace cubic
over a minimal four-parameter presentation of its invariant field.  The
result is birationally equivalent, in both directions on one explicit open,
to the authoritative Hilbert--90 twist installed at the pinned state.

Put

\[
 E=\mathbf C(r_0,\ldots,r_4)/(r_0r_1r_2r_3r_4-1),
 \qquad \sigma(r_i)=r_{i+1},\qquad K=E^{\langle\sigma\rangle}.
\]

Then `FIELD_MODEL.md` proves

\[
 K=\mathbf C(U_1,U_2,U_3,U_4)
\]

and gives forward and inverse maps.  In the `K`-basis
`1,r0,r0^2,r0^3,r0^4` of `E`, with
`Z(T)=z0+z1*T+...+z4*T^4`, the genuine twist is

\[
 \boxed{\;
 \Phi(z)=\sum_{i\in\mathbf Z/5}
 \frac{Z(r_i)^2 Z(r_{i+1})}{r_{i+2}}
 =\operatorname{Tr}_{E/K}
 \left(r_2^{-1}Z(r_0)^2\sigma(Z(r_0))\right)=0.
 \;}
\]

This is not an auxiliary cubic.  `TWIST_MODEL.md` constructs the exact frame

\[
 B_{ij}=\sigma^i(\beta)r_i^j,\qquad \beta=y_2/y_3,
\]

proves `B(gy)=rho(g)B(y)`, and shows that
`C=A_canonical^-1 B` lies in `GL5(K)`.  Thus `u=Cz` and `z=C^-1u` give the
two coordinate maps between the canonical equation and `Phi=0`.

No `K`-rational point and no pointlessness theorem is proved.  The five
`C11` eigenpoints become an exact degree-five point over `E`; together with
a degree-three linear section they prove index one only.  The coefficient
`r2^-1` has norm one but has exact order eleven modulo the degree-33 isogeny
`d -> d^2 sigma(d)`, so ordinary multiplicative Hilbert 90 does not remove
it.  The smallest remaining theorem is exactly

\[
 \exists\,0\ne a\in E:
 \operatorname{Tr}_{E/K}(r_2^{-1}a^2\sigma(a))=0\ ?
\]

Problem E therefore remains **OPEN**.  The output is the permitted
`H-11_5-NORM-MODEL-PASS` exit, not a positive or negative headline.

## Repository binding

- pinned mathematical state: `35fa8f59b6a1423cc89300aeaceefe91552be5ba`;
- live commit consumed at construction: `37d61c19a108781cf74af837e24810a9f7f7c3be`;
- produced commit: none;
- canonical source: `goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/`.

## Replay

From `problems/E-klein-cubic` run:

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_35fa/H_11_5_TWIST/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_35fa/H_11_5_TWIST/seal.py
/opt/homebrew/bin/python3 -u goal_runs_after_35fa/H_11_5_TWIST/verify.py
```

The final marker is

```text
H_11_5_INDEPENDENT_VERIFY_OK
```
