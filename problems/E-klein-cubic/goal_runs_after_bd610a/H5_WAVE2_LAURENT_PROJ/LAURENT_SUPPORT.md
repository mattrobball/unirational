# Laurent support classification (wave 2)

## Support moves retained from the goal

Supports are considered up to:

- cyclic shift (`σ` on exponents),
- common monomial multiplication (diagonal translation of exponents),
- inversion / gauge `d ↦ d^2 σ(d)` only as a **recorded** constraint (order-11
  class of `c`; not used as a pointlessness theorem).

## K-coefficients

See structure theorem in `CONSTRUCTIVE_SEARCH.md`: nonconstant Laurent monoms
are never in `K`. Screens use the invariant menu

```text
1, p_k = sum r_i^k, p_{-k}, e_{ab} = sum r_i^a r_{i+1}^b,
and low products of these.
```

## Classes searched

1. Two distinct monoms, free menu coeffs.
2. Three-term cyclic orbit of one monom, free menu coeffs.
3. Four-term incomplete cyclic orbit, free menu coeffs.
4. Binary deformation `1 + s m` with `s` in the menu.
5. Additive / multiplicative Hilbert-90 monoms scaled by menu elements.
6. Sparse power-basis `z` with menu entries.
7. Local cyclic polynomials `a_i = f(r_i,r_{i+1},r_{i+2})`.

No class produced a K-identity in the stated bounds.
