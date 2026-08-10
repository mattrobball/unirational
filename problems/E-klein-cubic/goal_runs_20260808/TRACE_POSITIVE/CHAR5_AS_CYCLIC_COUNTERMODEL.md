# Artin--Schreier cyclic countermodels for the progression systems

**Date:** 2026-08-08  
**Status:** `EXACT DIFFERENCE-FIELD FORCING COUNTERMODEL`  
**Strict scope:** this is not a homogeneous polynomial landing covariant and
does not settle the characteristic-five or characteristic-zero problem.

## 1. Question tested

For the four universal two-residue progression systems of
`CHAR5_PROGRESSION_UNIVERSAL_IDEAL.md`, put

\[
 z_i=\sigma^i(z),\qquad u_i=\sigma^i(u),\qquad
 a_i=u_i^2u_{i+1}.
\]

The five equations are

\[
\begin{split}
0=F_t={}&a_t
 +a_{t+c}(z_{t+c+1}+2z_{t+c})\\
 &+a_{t+2c}(2z_{t+2c}z_{t+2c+1}+z_{t+2c}^2)\\
 &+a_{t+3c}z_{t+3c}^2z_{t+3c+1},
 \qquad t\in\mathbf F_5,                              \tag{1.1}
\end{split}
\]

where `c=1,2,3,4`.  Unlike the earlier independent-symbol witnesses, (1.1)
imposes the full cyclic compatibility on both `z_i` and `u_i`, as well as the
multiplicative condition `a_i=u_i^2u_(i+1)`.

The proposed Artin--Schreier/Newton strategy would need an additional theorem
asserting that these conditions force `z` to be invariant, force one of the
two pure Klein equations, or otherwise prevent cancellation among the four
Newton vertices.  The fixed countermodels below show that no such assertion
follows from the abstract order-five difference-field identities alone.

## 2. Exact field and witnesses

Work in

\[
 L=\mathbf F_5[t]/(t^5-t-1)=\mathbf F_{5^5},
 \qquad \sigma(x)=x^5,
\]

so `sigma(t)=t+1` and `sigma` has order five.  Coefficient vectors in the
table use the basis `(1,t,t^2,t^3,t^4)`.

| `c` | `z` | `u` | `K(u)=sum u_i^2u_(i+1)` | `K(zu)` |
|---:|---|---|---:|---:|
| 1 | `(0,0,0,0,1)` | `(1,1,1,4,0)` | 1 | 2 |
| 2 | `(0,0,0,0,2)` | `(1,1,3,0,2)` | 3 | 3 |
| 3 | `(0,0,0,0,2)` | `(1,0,4,1,3)` | 1 | 2 |
| 4 | `(0,0,0,0,1)` | `(1,4,0,3,4)` | 3 | 3 |

For every row:

1. both `z` and `u` have five distinct conjugates;
2. the matrix `M_c(z,sigma(z),...,sigma^4(z))` has rank four;
3. its kernel contains the conjugate vector
   `(u_i^2u_(i+1))_(i in F_5)`;
4. all five equations (1.1) vanish exactly;
5. neither pure Klein equation vanishes.

Thus the cancellation is nonproportional, cyclically compatible,
multiplicatively compatible, and does not arise from a lower pure landing.

The complete fixed-field count gives respectively

```text
c=1: 800 non-invariant determinant zeros
c=2: 840 non-invariant determinant zeros
c=3: 840 non-invariant determinant zeros
c=4: 800 non-invariant determinant zeros
```

among the `5^5=3125` possible values of `z`.  This enumeration is not a
degree or support search; it is the complete point set of one analytically
forced degree-five Artin--Schreier field.

## 3. Consequence and strict boundary

The result refutes a **formal** closure based only on:

- `sigma^5=1` and the Artin--Schreier finite-difference basis;
- the four progression bucket identities;
- determinant/Newton-vertex cancellation;
- cyclic conjugacy of the ten values; and
- the multiplicative relation `a_i=u_i^2u_(i+1)`.

Any successful characteristic-five proof must use structure absent here,
notably that the values arise from ordinary homogeneous polynomials in the
specific faithful five-space, their `C11` weights, and the geometry of the
specific rational function extension over an algebraically closed constant
field.

In particular, this finite-field model does **not** provide polynomials
`h,k`, does not satisfy the original homogeneity/nonnegative-exponent
requirements, and does not construct an `F55`-covariant.  Since the
nontrivial automorphism here acts on a finite constant extension, it also
does not refute a valuation lemma whose hypotheses use the ramification of
the particular geometric Artin--Schreier extension.  It proves only that
those extra hypotheses are indispensable.

Replay:

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/TRACE_POSITIVE/verify_char5_as_cyclic_countermodel.py
```

Expected terminal marker:

```text
F55-CHAR5-AS-CYCLIC-PROGRESSION-COUNTERMODEL-OK
```
