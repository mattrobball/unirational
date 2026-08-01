# Stage-B exact-CAS audit

## Outcome

The existing 48-row and 96-row saturation runs cannot prove emptiness,
independently of term order or available memory: both retained contraction
systems have exact nonzero projective points.

- For `r48`, every contraction vanishes on
  `P(span(q4,...,q11))`; consequently the subsystem contains
  `P^7 x P^5` in the Stage-B boundary.
- For `r96`, at `q=e5` the `96 x 6` cubic matrix has rank `3`; one exact
  kernel vector is `b=(17,8,57,1,0,0)` over `F_89`.
- For `r256`, all 37 coordinate evaluations have rank `6`. This is only a
  useful preflight: it is not an emptiness result.

The replay is:

```text
/opt/homebrew/bin/python3 \
  P25_LANDING_SUPPORT/parallel/stageb_cas/audit_coordinate_witnesses.py
```

It rebuilds the coordinate evaluations from the stored cubic coefficients,
computes exact modular RREFs, verifies each displayed kernel vector, checks
all 120 cubics restricted to the `r48` eight-coordinate subspace, and writes
`coordinate_witnesses.json`. The latter consumes the contraction hashes

```text
r48   ba6d0533ab7fdb8bd93fb9309ce5b7d615f0a4799b22aa5e502e2dfec0bc21bb
r96   7bfa9b41cabbb2446041ac0fb561b4fa6b35b5a7c00f7e843598de543878c979
r256  2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea
```

These are points of necessary contraction subsystems, not candidates for the
690 seed equations. They prove only that the corresponding saturation cannot
be the unit ideal.

## Exact module reformulation

Let `A(q)` be the retained `r x 6` matrix of cubic `P3` contractions and let
`N` be the row-generated submodule of

```text
S^6,  S=F_89[q0,...,q36].
```

Then Stage B for this contraction subsystem is exactly

```text
Proj Supp(S^6/N) = {q : rank A(q) < 6}.
```

Thus `dim(S^6/N)=0` is an exact global emptiness certificate. This removes
all six `b1` variables, removes the `b1`-irrelevant saturation, and avoids
expanding maximal minors. On an affine chart `qi=1`, the criterion is simply
`N=S^6`. `produce_module_preflights.py` writes both Singular encodings and
`run_bounded.py` supplies a hard RSS/wall fence.

The formulation is materially smaller than the current 43-variable ideal,
but the stored row counts explain why it is not by itself decisive. In degree
`d`, at most

```text
r * dim S_(d-3)
```

vectors can span the `6*dim S_d` target. For `r=256`, the source remains
smaller through degree 15; degree 16 is the first dimensionally possible
full component:

```text
d=15: 17,835,144,823,808 < 19,132,051,388,520
d=16: 67,224,776,643,584 > 62,179,167,012,690.
```

Consequently a raw `r256` module Gröbner basis still faces an impossible
generic degree floor. The value of the module formulation is that it exposes
the right stronger input: use the complete 10,767-dimensional linear-syzygy
space, rather than more saturation tuning on 256 rows.

## Recommended decisive computation

Let `K` be the full 10,767-dimensional space of degree-one left syzygies of
`M2`, and define the exact graded Macaulay map

```text
Phi_d : K tensor S_(d-3) -> S_d^6
        C tensor h |-> h * (C(q) M1(q)).
```

Surjectivity of one `Phi_d` proves `N_d=S_d^6`, hence empty projective
Stage B for this safe contraction system. The first dimensionally possible
degree is only `d=5`:

```text
d=4: source   398,379; target   548,340  (impossible)
d=5: source 7,569,201; target 4,496,388  (first possible)
```

This is the recommended heavy-slot run. It should be implemented as a
streamed, representation-blocked exact rank calculation over `F_89`, not as
10,767 dense polynomial strings and not as an ordinary Gröbner basis. The
producer should generate matrix blocks directly from the sealed `M1`, `M2`
tensors and monomial multiplication maps. The accepted certificate should
contain either:

1. exact full rank `4,496,388`, with deterministic pivot/block records and an
   independent block replay; or
2. an explicit nonzero cokernel vector, which directs the next representation
   block or degree rather than being misreported as nonemptiness.

FFLAS-FFPACK 2.5.0 is installed and already used by the syzygy producer, but
a raw dense double matrix would be far too large. Isotypic decomposition (or
another exact invariant block decomposition) is therefore part of the run,
not an optional optimization. If no decomposition is available, do not start
the 4.5-million-column matrix.

## Bounded measurements

All RSS numbers below are `libproc` samples, not claimed peaks. Every job was
killed by its wall fence and none is a certificate.

| Encoding | Exact command suffix | Wall | RSS sample | Last exact progress |
|---|---:|---:|---:|---|
| homogeneous module, r12 | `run_bounded.py module_r12_hom_C.sing --timeout 30 --rss-gib 2` | 30.038 s | 963.1 MiB | Singular entered degree 5 |
| affine `q0=1` module, r12 | `run_bounded.py module_r12_q0_1_ordC.sing --timeout 30 --rss-gib 2` | 30.039 s | 901.9 MiB | Singular entered degree 5 |
| affine `q0=1` module, r43, order `C` | `run_bounded.py module_r43_q0_1_ordC.sing --timeout 60 --rss-gib 3.5` | 60.045 s | 1435.2 MiB | degree 4, trace count 72 |
| affine `q0=1` module, r43, order `c` | `run_bounded.py module_r43_q0_1_ordc_lower.sing --timeout 60 --rss-gib 3.5` | 60.020 s | 1435.3 MiB | identical trace through degree 4 |
| affine `q0=1,b1_0=1` ideal, r48, msolve | `run_bounded.py /absolute/.../syzygy_r48_q0_b0_0_b1_0_1.ms --engine msolve --timeout 45 --rss-gib 3.5` | 45.046 s | 1060.6 MiB | degree 4: `48 x 54114`; degree 5: `2001 x 681630` |
| same affine ideal, r256, msolve | analogous r256 command | 45.055 s | 719.9 MiB | 220-MiB text input had not finished parsing |

The `C`/`c` module orders gave byte-for-byte identical progress traces in the
r43 window. Dehomogenizing `q0` saved about 6 percent RSS for r12 but did not
change the degree reached. There is no measured basis for preferring either
component order.

Installed exact tools checked here are Singular 4.4.1, Macaulay2 1.26.06,
msolve 0.10.1, and FFLAS-FFPACK 2.5.0. The executable named `groebner` is
4ti2's toric/lattice solver, not a general polynomial Gröbner engine; `gfan`
does not remove the need for an initial Gröbner basis.

## Orders, saturations, and rejected encodings

- If the old ideal route is retained, `b1`-first then `q` saturation is the
  correct sequential order. `option(redSB)` should stay off during discovery;
  reducing the final basis is unnecessary for a unit test.
- A two-block order preserves the bigrading but does not repair the fatal
  `r48`/`r96` survivors. The module formulation is the exact version of the
  useful `b`-elimination and is preferable to either block order.
- Expanding the Fitting ideal is infeasible: `r256` has
  `binomial(256,6)=368,532,802,176` maximal minors, each of degree 18.
  Random row-compressed minors are safe necessary equations, but their dense
  degree-18 determinants are a worse encoding than the module.
- One Rabinowitsch equation `1-t*l(q)` checks only one open chart and is not a
  global projective certificate. The exact dot-product encoding
  `1-sum(u_i q_i), 1-sum(v_j b_j)` adds 43 auxiliary variables with large
  positive-dimensional fibres. It is exact but algorithmically worse.
- Six `b` charts times 37 `q` charts are exact, but the module removes the six
  `b` charts entirely. A 37-chart flag is a fallback only after the full
  degree-5 module map is unavailable.
- A proposed `690 x (37*27)` Stage-A-style flattening is invalid: the `b1`
  block is quadratic in `q`, while the `b2` block is linear. Any valid lift
  must retain the shared-`q` Veronese constraints and does not yield a plain
  rank-one kernel test.

## Scope

This audit supplies no Stage-B or P25 verdict. It rules out two expensive
contraction saturations as mathematically incapable of returning a unit and
identifies the full-syzygy degree-5 module rank as the first materially
plausible exact certificate.
