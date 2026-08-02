C5-UNDECIDED

# Goal C5 status

The prescribed self-adjoint-idempotent incidence is inconsistent.  The packet
supplies an exact executable split replacement and the universal descended
Morita formula, but not yet an exact generic interpreter for the serialized
`K_proj` source leaves.  It does not supply a `K_proj`-point.

## Convention verdict

The authoritative frame is

```text
V_0,...,V_4 = x,C,D,E,K,
S_i = Q(x)^(-1) Q(V_i(x)).
```

Thus `S_0=1_A`.  The prescribed equations contain

```text
e^2=e,   Trd(e)=2,   e*S_0*e=0,
```

so the first and third give `e=0`, contradicting the trace equation.
`projector_incidence.json` contains an exact coefficientwise unit-ideal
certificate.  This refutes the proposed encoding, not the genuine Fano
threefold.

## Corrected incidence and current executability boundary

The corrected projective model is a nonzero self-adjoint square-zero operator
`n` of reduced rank two with

```text
n^2=0,
Trd(n*S_i)=0,  i=0,...,4.
```

The first trace equation is essential scheme-theoretically: the exact split
calculation gives degree `28` before it is imposed and the reduced degree-`14`
Pluecker ideal afterward.

Two complementary presentations are sealed:

- `generic_pluecker_incidence.json` serializes all five generic
  `Q(zeta11)[x]` Pluecker hyperplanes without interpolation, all fifteen
  Pluecker quadrics, and all fifteen Grassmann charts.  The five term counts
  are `[75,450,675,1050,1800]`; the canonical equation hash is
  `c8119e3a1956757fa1833d141f8b14261dd4dcbffb0c3418f87590c96b5d5c4a`.
- `morita_generic_dag.json` specifies the same target intrinsically over
  `K_proj`: five homogeneous quadrics in twelve scalar coordinates, all
  `5*78=390` coefficients, and all three `q_r=1_D` division-algebra charts
  with `3*5*45=675` coefficient records.  Every coefficient is the exact
  denominator-minimal trace circuit

  ```text
  -Tr(P M_alpha^T Q P G_r^T B_i G_s P Q M_beta)/(2*s^3).
  ```

  The denominator/open ledger is explicit.  The three normalized charts
  cover every `K_proj`-line because the certified generic quaternion algebra
  is division; the fifteen Pluecker charts retain the exhaustive geometric
  cover after splitting.

The Pluecker verifier rebuilds every generic split coefficient and checks the
recorded primes `331,463,419` plus the unused prime `617`.  The Morita verifier
reconstructs the intended formula at the accepted `p=23` fibre, but it does
not interpret every serialized `ordered_trace_terms` record and its generic
source leaves are prose labels.  Record-level corruption can therefore pass
that semantic verifier after resealing.

`morita_generic_split_dag.json` gives a second, independently wired
`q_0=1` realization.  Its 517-node DAG has 225 invariant coefficient roots
and 225 ambient split-chart roots.  The verifier checks the exact wiring at
the accepted fibre and proves only that the selected structural ansatz
`v=0` is generically inconsistent (`rank A(0)=4`, `Delta(0)=1 mod 23`).
It does not exclude the full chart.

The written trace-conjugation argument proves that the intended coefficients
are invariant rational functions, hence elements of `K_proj`.  This proves
mathematical descent membership, but it is not a replayable exact generic
source interpreter.  Until the source leaves and every transform node are
resolved and independently consumed, `C5-EXECUTABLE-FULL-INCIDENCE` is not
claimed.

## Geometry and rational-point boundary

At `p=331,463` and the holdout `p=419`, independent exact replays give smooth
geometrically integral projective threefolds of dimension three and degree
fourteen.  At `p=23`, the installed-coordinate and Morita verifiers give
smooth common-line seeds.  These are finite-fibre checks, not a rational
section.

`THEORETIC_DESCENT_BOUNDARY.md` proves that every pair of forms in the
five-plane has a common `K_proj`-line, using the degree-55 orbit,
Springer, and Amer--Brumer.  The same sources explicitly do not extend this
point theorem to three or five forms.  `PROJECTIVE_MIXED_REDUCTION.md` proves
that rational projective formulas reduce to homogeneous covariants of some
degree, but supplies no degree bound.

The bounded covariant/word audits are also sealed with their actual scope.
The saved exact leading ideal excludes homogeneous landing covariants through
degree 16.  At degree 17, every coefficient support of size at most four is
excluded, as are 341 short Morita words, 1,275,340 two-word combinations, and
the listed constant twelve-word ansatz.  None is a full degree-17 or
all-degree verdict.

No exact common line over `K_proj`, no characteristic-zero rational-point
obstruction, and no `BR-FANO-POS` headline are claimed.  The strongest honest
listed exit is therefore `C5-UNDECIDED`.

```text
C5_CONVENTION_GATE_FAIL
C5_GENERIC_PLUECKER_INCIDENCE_INDEPENDENTLY_VERIFIED
C5-MORITA-GENERIC-390-COEFFICIENT-DAG-INDEPENDENTLY-VERIFIED
MORITA-GENERIC-SPLIT-DAG-VERIFIED
C5_CORRECTED_INCIDENCE_GEOMETRY_INDEPENDENTLY_VERIFIED
C5_MODULAR_SEED_P23_OK
C5-MORITA-SEED-P23-INDEPENDENTLY-VERIFIED
C5_PROJECTIVE_MIXED_REDUCTION_OK
C5_DEGREE16_FANO_EXCLUSION_INDEPENDENTLY_VERIFIED
```
