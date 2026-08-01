# Abstract descent audit

## Verdict

The accepted (E[3])-module and (S_6)-closure data prove, without a cube
test, that

```text
res: H^1(F,E[3]) -> H^1(K_proj,E[3])
```

is injective.  In particular, the installed lift `xi` of the nonzero
plane-cubic torsor class remains nonzero over `K_proj`.

This statement alone is **not** a no-point theorem: if `C(K_proj)` were
nonempty, the nonzero restricted class could lie in the Kummer image
`delta(E(K_proj)/3E(K_proj))`.  Thus the formerly planned test
"is `alpha_R` a cube?" has a forced answer (no), but noncubeness is not the
same as pointlessness.

The independently produced infinity-divisor packet now proves the stronger
statement

```text
C(K_proj) = empty.
```

The two conclusions are cohomologically consistent.  The valuation theorem
says that the image of `res(xi)` in `H^1(K_proj,E)[3]` is nonzero, whereas
this packet independently proves that `res(xi)` itself is nonzero.

Exact arguments and the adversarial comparison are in `THEOREM.md`.  Replay
with:

```sh
/opt/homebrew/bin/python3 -u \
  F_CONIC_ALGEBRA/root_019fbe10/agent_abstract_descent/produce.py
/opt/homebrew/bin/python3 -u \
  F_CONIC_ALGEBRA/root_019fbe10/agent_abstract_descent/verify.py
```

Required terminal markers:

```text
GOAL_F_ABSTRACT_DESCENT_PRODUCED
GOAL_F_E3_RESTRICTION_INJECTIVE_ACCEPT
GOAL_F_INFINITY_COHOMOLOGY_CONSISTENT_ACCEPT
```

