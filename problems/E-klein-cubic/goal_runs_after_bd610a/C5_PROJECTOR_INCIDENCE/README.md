# C5 direct-projector incidence audit

This packet gives a decisive convention verdict and a corrected structural
frontier.

The installed five-plane contains `S_x=1`.  Hence the requested self-adjoint
idempotent equations contain both `e^2=e` and `e^2=0`, while requiring
`Trd(e)=2`.  `projector_incidence.json` contains a degree-zero unit-ideal
certificate, and `verify.py` reconstructs the load-bearing identity from the
sealed Hilbert--90 and involution data.

This is not emptiness of the genuine twisted Fano threefold.  The exhaustive
repair is the projective self-adjoint square-zero model

```text
n^2=0,
Trd(n*S_i)=0,  i=0,...,4.
```

`CORRECTED_INCIDENCE.md` proves its equivalence to the genuine Pluecker
section, including the essential trace equation and projective left/right
dictionary.  `verify_corrected_incidence.py` independently reconstructs and
replays the exact QQ scheme certificate and the three finite-field geometry
certificates.  `verify_modular_seed_p23.py` also gives a smooth point in the
installed 15-variable basis at one split fibre, while
`verify_morita_seed_p23.py` independently gives a smooth common line on a
second split fibre.  Both have strictly modular scope.  No accepted
`K_proj`-point is present.

Current authorized exit:

```text
C5-UNDECIDED
```

Exact diagnostic marker:

```text
C5_CONVENTION_GATE_FAIL
```
