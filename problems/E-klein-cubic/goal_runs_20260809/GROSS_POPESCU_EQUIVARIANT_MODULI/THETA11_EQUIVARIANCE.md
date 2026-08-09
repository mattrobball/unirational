# Functorial equivariance of `Theta_11`

## The multiplicity-plane construction

Fix a theta marking and identify the Schrödinger module with `V=C(F_11)`.
For a level-polarized embedded abelian surface `A` put

```text
Q_A = H^0(I_A(2)) subset Sym^2(V).
```

As an `H_11`-module,

```text
Sym^2(V) ~= V' tensor V_+,
```

where `V'` is the unique weight-two Schrödinger module and `V_+` is the
six-dimensional even Weil multiplicity module.  On the Gross--Popescu dense
open, `Q_A` is `V' tensor W_A` for a unique two-plane `W_A subset V_+`, and

```text
Theta_11(A,lambda,alpha) = [W_A] in Gr(2,V_+).
```

This formulation removes the auxiliary choice of one odd two-torsion point:
all six give the same plane precisely because they encode the same ideal of
quadrics.

## Transport under a marking change

Let `g in SL2(F11)`.  The split normalizer supplies a lift whose Schrödinger
operator is `rho_11(g)`.  Replacing `alpha` by `alpha o g^{-1}` transports the
embedded ideal functorially:

```text
Q_{g.A} = rho_11(g) . Q_A
```

with the harmless inverse/dual adjustment dictated by whether points or
coordinate functions are used.  The isomorphism

```text
Sym^2(V) ~= V' tensor V_+
```

is an isomorphism of normalizer modules.  Therefore transport acts on the
multiplicity factor by `rho_+(g)` and gives

```text
W_{g.A} = rho_+(g) W_A.
```

With the right-action convention of `MODULI_ACTION.md`, this is

```text
Theta_11(g.A) = rho_+(g) Theta_11(A).
```

Changing to the opposite marking convention replaces `g` by `g^{-1}` on
both sides and changes no equivariant-birational conclusion.

## The center

Gross--Popescu have `rho_11(-I)=-iota`.  On `V_+`, where `iota=+1`, the center
acts by `-1`; hence it acts trivially on `Gr(2,V_+)`.  This exactly matches the
2-trivial action of `-I` on the moduli stack and proves that the displayed
map descends to the effective `G=PSL2(F11)` action.

## Conclusion

Invariance of the image alone would not prove equivariance.  The preceding
multiplicity-space transport proves the stronger functorial identity and
establishes the exit **GP-THETA11-G-EQUIVARIANT**.
