# Constructive-point subroute status

## Verdict

```text
NO-CONFLICT / POSITIVE-NOT-FOUND
```

No exact point of the fixed-frame cubic over `K_proj`, no exact conic over
`F`, and no conic-intersection algebra isomorphism were found here.  The
recorded work is a bounded modular probe of one proper ansatz and does not
oppose the terminal infinity obstruction.

## Restricted ansatz tested

For four specializations over `GF(67)`, the probe imposed

```text
X = a0 + a1*u + a2*u^2,
y = b0 + b1*u + b2*u^2,
w = 1,
c(X,y,1) = lam*P(u),
lam*invlam = 1.
```

Thus it seeks a polynomial quadratic parameterization using the installed
primitive `u`.  After homogenization, `w=V^2`; a nondegenerate member is a
conic tangent to the fixed line at infinity.  This is not the universal
conic family.  Moreover, the computation saturated only `lam`, not the rank
of the parameterization, so boundary line maps may remain.

The `lam != 0` saturation is essential.  Without it, constant maps to the
cubic give a positive-dimensional `lam=0` boundary.

## Exact finite-fibre output

`msolve` returned a zero-dimensional RUR of degree 144 in each saturated
fibre.  Its separating linear form is `invlam`.  Independent refactorization
of the degree-144 separating polynomial gives:

| `(A,B,Y,Z)` | irreducible factor degrees over `GF(67)` | `GF(67)` roots of the separator |
|---|---|---|
| `(1,2,3,4)` | `1,24,119` | `9` |
| `(1,1,1,1)` | `4,4,6,19,20,23,27,41` | none |
| `(2,3,5,7)` | `1,1,1,4,15,34,88` | `26,60,66` |
| `(3,1,4,2)` | `2,7,9,32,34,60` | none |

In particular, the second and fourth finite fibres have no base-field point
in this saturated ansatz: any such point would give a base-field value of
the separating coordinate and hence a linear factor.  The other two fibres
only supply modular candidates.  No candidate was lifted to
`C(A,B,Y,Z)`, and finite fibres cannot rule out a rational formula whose
denominator vanishes on the sampled parameters.

## Stopped generic-line computation

`build_quadratic_u_line_singular.py` and `quadratic_u_line_p67.sing` encode
the same restricted ansatz over the line

```text
(A,B,Y,Z) = (1,2,3,s) over GF(67)(s).
```

The Gröbner basis computation was interrupted while still running after the
terminal negative proof became available.  It produced no decision and is
not cited as evidence.

## Replay marker

From this directory, run:

```bash
/opt/homebrew/bin/python3 verify_finite_fibres.py
```

The final line must be:

```text
ALL CHECKS PASS -- FINITE ANSATZ PACKET VERIFIED
```

To regenerate the four discovery outputs (requires `msolve`):

```bash
/opt/homebrew/bin/python3 probe_quadratic_u_param.py --run --timeout 300
```

## Scope relative to Goal F

The exact Goal F system remains the six cubic remainders in twelve
`F`-unknowns plus the projector open.  This packet neither solves nor
refutes that universal system.  It contains no exact positive object and
therefore has no conflict with `F-CONIC-CRITERION-EMPTY` established by the
separate infinity-place argument.
