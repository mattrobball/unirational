C5-UNDECIDED

# Goal C5 status

The mandatory convention gate refutes the incidence prescribed in
`GOAL_C5_DIRECT_PROJECTOR_INCIDENCE.md`.  The packet also installs and
independently replays the corrected genuine-Fano incidence, but it does not
solve that incidence over `K_proj`.

The canonical packets agree on the distinguished frame

```text
V_0,...,V_4 = x,C,D,E,K
```

and on

```text
S_i = Q(x)^(-1) Q(V_i(x)).
```

Consequently `S_0=1_A`.  The proposed equations contain

```text
e^2=e,
Trd(e)=2,
e*S_0*e=0.
```

The first and third equations give `e=0`, contradicting the trace equation.
The exact coordinate ideal is the unit ideal; `projector_incidence.json`
contains an explicit coefficientwise certificate.

This is not `C5-FULL-FANO-SCHEME-EMPTY-SCOPED`.  It proves that the proposed
self-adjoint projector scheme is not the genuine Fano scheme.  The correct
right-ideal equations use an arbitrary idempotent `f` and read

```text
f^2=f,
Trd(f)=2,
sigma(f)*S_i*f=0  for i=0,...,4,
```

without `sigma(f)=f`.  Equivalently one should retain the installed Morita
common-line equations `q^* H_i q=0`.

The canonical inputs themselves do not disagree, so
`C5-CANONICAL-INPUT-FAIL` is not claimed.  The corrected 15-variable direct
model uses a projective nonzero self-adjoint square-zero reduced-rank-two
operator `n` with

```text
n^2=0,
Trd(n*S_i)=0,  i=0,...,4.
```

The `i=0` trace equation is essential scheme-theoretically: an exact split
calculation shows that square-zero alone is a degree-28 doubled structure,
whereas adjoining `Trd(n)=0` gives the reduced degree-14 Pluecker ideal.
The exact corrected inventory covers all 36 square-zero coordinates, all
five trace equations, and all 15 projective charts.

At `p=331,463`, and the designated holdout `p=419`, independent replays give
smooth geometrically integral projective threefold fibres of dimension three
and degree fourteen.  These finite-fibre theorems provide structural checks,
not a characteristic-zero rational point.

At the certified `p=23` fibre, `verify_modular_seed_p23.py` additionally
reconstructs a smooth rank-two point in the installed 15-element symmetric
basis and proves that no constant coefficient vector works across six regular
fibres.  An independent Morita-coordinate replay finds and exhaustively
checks a smooth common right-`D` line on a second split `p=23` fibre.  These
are modular chart seeds and bounded evidence only.

No point, negative headline, or emptiness statement for the genuine
`F_{14,T}` is claimed.  The Klein-cubic headline remains open.

```text
C5_CONVENTION_GATE_FAIL
C5_CORRECTED_INCIDENCE_GEOMETRY_INDEPENDENTLY_VERIFIED
C5_MODULAR_SEED_P23_OK
C5-MORITA-SEED-P23-INDEPENDENTLY-VERIFIED
```
