# Stable presentation status

`STABLE_PRESENTATION.json` now records an exact finite **nonminimal** stable
presentation over `F_89`.  Starting from the 690 cubic residual seeds and a
canonical 210-row commutator forest, the order-ideal states

```text
B = 1 + K + Sym2(K)
```

give 19,320 seed states through degree 5 and 5,880 commutator states through
degree 6.  The border certificate proves all 56 constant, 336 linear, and
1,176 quadratic frontier identities coefficientwise; consequently the
25,200-state hull is preserved by every transition operator.  Monic reduction
and commuting induced transitions prove that this hull equals the true
relation kernel.

Equivalently, it gives the exact (nonminimal on the left) presentation

```text
S(-3)^690 + S(-4)^4350 + S(-5)^15750 + S(-6)^4410
    -> F -> R/J -> 0.
```

Thus the minimal generator counts satisfy `beta_0,3=690`,
`beta_0,4=4350`, `beta_0,5<=15750`, `beta_0,6<=4410`, and
`beta_0,d=0` for every `d>=7`.

This is a finite presentation certificate, but it is deliberately redundant.
The minimal degree-5 and degree-6 quotient ranks, graded syzygies and Betti
data, minimal normal-form bases, and minimal transition matrices have not
been computed.  The monomial `(K)^3` resolution still does not supply those
data: its first lifted overlaps reduce to nonzero commutators.

Therefore the scoped status is `PC1-NONMINIMAL-STABLE-KERNEL-PRESENTATION-PASS`,
while the binding `PC25-STABLE-PRESENTATION-PASS` exit and the mission remain
unauthorized.  The only goal-level exit is `PC-UNDECIDED`.
