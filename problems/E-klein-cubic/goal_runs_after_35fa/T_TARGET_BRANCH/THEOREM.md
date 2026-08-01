# T2 target-branch route-refutation theorem

## Verdict

The normalization program in Goal T2 cannot imply pointlessness of the
genuine generic Klein twist.  Its terminal exit is

```text
T2-ROUTE-REFUTED
```

and the Problem E headline remains **OPEN**.

## The two valuation objects are different

Put `F=C(A,B,Y,Z)` and let `K_proj/F` be the accepted degree-six extension.
The exact conic packet constructs an infinity divisor `D_inf` whose
reciprocal polynomial has a simple root.  Its selected ordered place satisfies

```text
e(R_inf/D_inf)=1,  f(R_inf/D_inf)=1.
```

The genuine multiplicity-one target branch `D_tar` comes from the simple
discriminant factor of the primitive sextic.  Its selected ordered prime
satisfies

```text
e(R_tar/D_tar)=2,  f(R_tar/D_tar)=1.
```

Ramification index is invariant under equality of ordered valuations.
Therefore `R_inf` and `R_tar` are not the same ordered place.  In particular,
the exact index-three residual net over `k(D_inf)` cannot be transferred to
the T2 target branch merely by calling both divisors “the target branch.”
Even an abstract birational identification of their residue fields would not
preserve the required ordered embedding because the ramification indices
differ.

## The headline arrow is unavailable even hypothetically

Let `C_fix/F` be the full fixed-frame Pfaffian plane cubic.  Suppose, more
strongly than current evidence, that T2.0--T2.3 constructed the normalization
of `D_tar`, its conductor and local class groups, and proved

```text
ind(C_fix over k(D_tar))=3.
```

Residue degree one and proper specialization would then imply only

```text
C_fix(K_proj)=empty.
```

The genuine generic Klein twist `X_gen/K_proj` is a different object.  A
projector-open point of `C_fix` yields a self-adjoint reduced-rank-two Morita
projector.  The accepted Fano/Klein bridge requires separately a common
isotropic right quaternionic line for all five descended Hermitian Klein
forms.  The authoritative bridge audit labels the projector-to-common-line
arrow false as written, and the fixed-frame terminality audit explicitly
withholds any implication from the fixed-frame point problem to Klein
unirationality.  There is no converse/exhaustiveness theorem sending every
`X_gen(K_proj)` point into the selected ternary frame.

Therefore the hypothetical normalization/index theorem still would not meet
T2.4.

## Exact counterexample to the formal section inference

Let `K=C((s))((t))` and

```text
C0: x^3+s*y^3+t*z^3=0  in P2_K.
```

The curve is smooth and has no `K`-point.  Indeed, the three terms have
`t`-valuation classes `0,0,1` modulo three.  In a vanishing sum the minimum
must occur at least twice, so the first two terms have equal minimum.  Their
leading coefficients would make `-s` a cube in `C((s))`, contradicting
`v_s(-s)=1`.  A line gives a degree-three divisor, while genus-one index one
would give a rational point.  Hence `ind(C0/K)=3`.

Now consider

```text
Y: x^3+s*y^3+t*z^3+w^2*x+q^3=0  in P4_K.
```

It contains `C0` as `w=q=0` and has the smooth rational point
`[0:0:0:1:0]`.  It is globally smooth because its derivative ideal contains
powers of every homogeneous coordinate; for `x,w` use

```text
3*x^3 = x*Y_x-(w/2)*Y_w,
w^3   = w*Y_x-(3*x/2)*Y_w.
```

Thus an index-three plane section does not force pointlessness even for a
smooth cubic threefold.  In the repository the fixed-frame curve is not a
section of `X_gen` at all, but of an auxiliary projector cubic, so the formal
inference is weaker still.

## Boundary

This theorem refutes Goal T2’s proposed headline route.  It does not
construct the target normalization, does not decide its horizontal
three-primary class group, and does not decide whether the genuine generic
Klein twist has a rational point.
