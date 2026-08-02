# Convention and equivalence audit

## Verdict

The self-adjoint-projector equivalence asserted by Goal C5 is false in the
installed convention.  The failure is intrinsic, not a row/column typo.

The smallest inconsistent set is:

1. the installed distinguished frame starts with `V_0=x`;
2. `S_i=Q(x)^{-1}Q(V_i(x))`, hence `S_0=1_A`;
3. Goal C5 imposes `e^2=e`, `Trd(e)=2`, and `eS_0e=0`.

Items 2 and 3 imply `e=e^2=eS_0e=0`, while `Trd(e)=2`.  Thus the mandatory
convention gate cannot be passed.

## Installed Morita convention

Let

```text
A = End_D(P),
D = e_0 A e_0,
P = A e_0,
```

where `e_0` is the sealed auxiliary sigma-self-adjoint projector.  Then `P`
is a right `D`-module of rank three and `A` acts on `P` on the left.  The
installed involution is `sigma=ad_h` for the nondegenerate Hermitian form

```text
h(xe_0,ye_0)=e_0 sigma(x) y e_0.
```

For the five sigma-self-adjoint elements `S_i`, define

```text
h_i(u,v)=h(u,S_i v).
```

This is the form transported to the matrices `H_i` in `c2_morita.json`.

## Correct idempotent-to-line map

Let `f in A` be any idempotent of reduced trace two.  Then

```text
U = fP
```

is a rank-one right `D`-submodule, and

```text
I_U = fA
```

is the associated right ideal of reduced dimension two.  Notice the sides:
`fA` is a right ideal, while `Ae_0` is the right-`D` Morita module.  Replacing
either by `Af` or `e_0A` silently changes the object.

Conversely, a right `D`-line `U` and a chosen right-`D` complement `W` give
the idempotent `f_{U,W}` projecting `P=U direct-sum W` onto `U`.  Forgetting
the complement is not injective, so lines and idempotents are not literally
mutually inverse without chart/complement data.  On a graph chart the fixed
coordinate complement supplies that data.

## Correct restriction equation

For arbitrary `f`, nondegeneracy of `h` gives

```text
h_i(fu,fv)
  = h(fu,S_i f v)
  = h(u,sigma(f) S_i f v).
```

Therefore

```text
h_i restricted to fP is zero
    iff
sigma(f) S_i f = 0.
```

In split column matrices, writing `B_i=Q S_i`, this is the same identity:

```text
f^t B_i f = Q sigma(f) S_i f.
```

Thus the genuine equations are

```text
f^2=f,
Trd(f)=2,
sigma(f) S_i f=0  for all i,
```

with no self-adjointness condition.

If one additionally assumes `sigma(f)=f`, the restriction equations become
`fS_if=0`.  But the member `S_0=1` then forces `f^2=0`, so the only such
idempotent is zero.  A sigma-self-adjoint idempotent projects onto an
`h`-nondegenerate summand; the Fano line is `h`-isotropic.  These are opposite
geometric conditions.

## Why the auxiliary projector cannot seed this target chart

The sealed auxiliary bivector `p` defines

```text
s = <Q(x),p>,
e_0 = -P Q(x)/s
```

on the open `s != 0`.  But the first genuine Fano hyperplane is `B_0=Q(x)`,
so its Plucker equation is exactly

```text
<Q(x),p> = s = 0.
```

The auxiliary projector open is therefore disjoint from the genuine Fano
section.  It remains valid for constructing the Morita corner and the
matrices `H_i`; it cannot be a chart seed for a target self-adjoint projector.

## Convention changes do not repair the system

- In column convention the restriction is `sigma(f)S_if=0`.
- Transposition/row convention moves the adjoint to the opposite side but
  gives the transposed equivalent equation.
- Passing from `fA` to `Af` changes right ideals to left ideals and does not
  turn an isotropic line into a nondegenerate summand.
- Imposing self-adjointness in any of these versions again conflicts with the
  member representing the base form itself.

Hence no silent `Ae/eA`, row/column, or transpose swap validates the Goal C5
equations.

