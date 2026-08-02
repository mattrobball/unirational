# Completion audit for Goal P25/COV

The goal is not complete.  This table distinguishes exact progress from the
remaining acceptance gates.

| package | binding requirement | current evidence | state |
|---|---|---|---|
| PC.0 | ranks 690, 56, 746; exact multiplication kernel; full transition/commutator subspaces; independent replay | `pc0_rank_certificate.json`, `verify_pc0_result.json` | **complete over F_89** |
| PC.1 finite kernel | explicit finite transition-stable presentation | exact 25200-state nonminimal hull through degree 6; border circuits prove stability and kernel equality | complete over F_89, nonminimal |
| PC.1 minimal ledger | actual minimal transition-stable module, graded generators/ranks/characters/syzygies/normal forms/matrices | exact minimal degrees 3 and 4; degree-4 rank 29880; degree-5/6 minimal data absent | **pending** |
| PC.1 characters/carrier | representation ledger and carrier minimality | canonical coefficient action is trivial; 720 pure-K permutations audited; 28-state carrier minimal | complete at scoped degree-4 boundary |
| PC.2 Stage A | `b0=b1=0` | inherited exact emptiness replay | complete |
| PC.2 Stage B/C on `L8` | both remaining strata on named closed subspace | inherited ranks `10296/10296`, `6435/6435` | complete on `L8` only |
| PC.2 bounded support | all q-support at most three | 7770 exact rank-75 restrictions and independent determinants | complete on bounded union only |
| PC.2 global | every q chart, Stage B and Stage C | no unit saturation or `dim(S^7/N)=0` output | **pending** |
| PC.3 inputs | literal bases and complete landing cubics | dimensions `198/361`, cubics `5349/8555` | installed upstream |
| PC.3 false quotient | do not use `K1/(R_+K1)` as primitive quotient | two independently replayed Bezout counterexamples | refuted exactly |
| PC.3 ambient P25 multipliers | exact strict-space maps by `f6` and `f10` | exact circuits, rank-43 `198x43`/`361x43` maps at 419 and 463; determinant-74 authoritative-frame repair at 89 | complete as ambient maps |
| PC.3 P25 scheme images | compute multiplier images from authoritative PC.2 scheme | PC.2 nonlinear scheme unresolved | **pending** |
| PC.3 common-factor incidences | exhaustive actual common-scalar-factor locus | 11 and 15 kernel-aware proper-image graphs, two-prime replay | complete as auxiliary-coordinate closed incidences |
| PC.3 remaining incidences | authoritative multiplier-image, composition, and ansatz loci with total union/intersections/closures | common-factor part only | **pending** |
| PC.3 affine covers | exhaust based and all nonbased charts away from actual incidences | 47 and 101 characteristic-zero charts remain | **pending** |
| PC.4 positive | exact lift, original equations, equivariance, gcd one, incidence exclusion, Jacobian rank four | no candidate | **pending** |
| PC.4 negative | complete good-fibre projective emptiness and properness transfer | conditional DVR bridge only | **pending** |

## Exit audit

Authorized:

```text
PC-UNDECIDED
```

Not authorized: every positive exit, every degree-wide empty exit,
`PC25-STABLE-PRESENTATION-PASS`, and `PC-FACTOR-INCIDENCE-PASS`.

`EMPTY_Q_SUPPORT_LE3.md` is a scoped stratum theorem and must not be consumed
as `PC25-DEGREE-EMPTY-SCOPED`.
