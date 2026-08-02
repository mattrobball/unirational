# H5.1 — constructive search (first wave)

## Scope discipline

The following are **already known** and are bound only by path+hash in
`INPUT_MANIFEST.json`.  They were **not** re-run as if exhaustive:

- homogeneous `11:5` landing covariants in degrees 1–9 empty;
- constant-coefficient two-Laurent ansatze at arbitrary exponents empty;
- two-Kummer-basis ansatze with arbitrary coefficient ratio empty;
- single-monomial patterns on three-coordinate Kummer planes empty;
- four-Kummer Laurent-monomial hyperplane patterns empty;
- pure Laurent monoms empty (H4);
- `c=r_2^{-1}` has exact order 11 modulo `d\mapsto d^2\sigma(d)`.

## Method

A candidate formula for `a\in E` is accepted as a `K`-point only if
`Phi(a)=0` holds **identically** on the product-one torus (equivalently, as an
element of `K`).  Multi-prime random specializations are used as a one-sided
test:

- a single specialization with `Phi\neq 0` **refutes** the identity;
- survival on all samples is recorded as a candidate and would require exact
  follow-up (none survived).

Modular zeros on individual fibres are **not** promoted to `K`-points.

## Screens run (machine payload: `constructive_search.json`)

| Screen | Scope | Identity hits |
|---|---|---:|
| constant `z\in\{-3..3\}^5` up to scaling | `a=Z(r_0)` constant coeffs | 0 |
| additive monom `a=m-\sigma(m)` | Laurent exp bound 2, nondegenerate | 0 |
| multiplicative monom `a=m/\sigma(m)` | reduced monoms, bound 2 | 0 |
| partial cyclic sums `sum_{j<k}\sigma^j(m)` | `k=2,3,4`, bound 2 | 0 |
| `a=u+v\sigma(u)+w\sigma^2(u)` | monom `u`, small fixed rational `(v,w)` | 0 |
| `a=1+s m+t n` identity in `(s,t)` | monom exp bound 1 | 0 |
| `a=sum c_i r_i` / `sum c_i/r_i` | `c_i\in\{-2..2\}` | 0 |
| `z_j` from low cyclic invariants | 8-name menu, all 5-tuples | 0 |

**Points found over `K`:** none.

Degenerate diagonal monoms (powers of `r_0\cdots r_4=1`) were excluded from
additive/multiplicative counts because they give `a=0`.

## Modular fibre screen (`modular_screen.json`)

For primes

```text
31, 41, 61, 71, 89, 101, 131, 151, 181, 199
```

and random product-one `r` over `F_p`, random search routinely finds nonzero
`z` with `Phi(z)=0`.  Sample points are stored and independently replayed
(including holdout prime `199`).  Interpretation:

```text
specialized fibres are typically F_p-nonempty
  =/=>  a K-rational point
  =/=>  pointlessness fails
```

This is an honest nonverdict for the binary decision; it only rules out the
naive hope that every reduction is empty.

## Not attempted in this wave (next gates)

1. **H5.1.A exact** three-or-more Laurent supports with coefficients in `K`
   (not only `C`), with elimination to fibrations.
2. **H5.1.B** full transformation law for `a=b/\sigma(b)` and `a=b-\sigma(b)` with
   general `b\in E`, not monoms.
3. **H5.1.C** projection from the degree-five closed point / Galois-stable
   secants to a residual conic or genus-one fibration.
