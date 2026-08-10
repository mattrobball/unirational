# Status

```text
equivariant Ext spectral sequence                     APPLIED EXACTLY
Ext^1(M,N)=((N/11N) tensor M^vee)^C5                 PROVED
Ext^n(M,N)=0 for n>=2, N torsion-free                PROVED
Ext table for N=exterior^q I, q=0,...,4              PROVED
actual cyclotomic sequence is unique nonzero Ext1     PROVED
all exterior Smith forms                              VERIFIED
top exterior cokernel Q4=F11(trivial)                 PROVED
twisted character M absent from Q4                    PROVED
all exterior Tate-cohomology maps are isomorphisms    PROVED
first mod-11 group-cohom invariants in degrees 9,10   PROVED
their torsor evaluations vanish by Kummer Bockstein   PROVED
rank-four determinant/Yoneda ed4 route                REFUTED
ordinary ed_K(A)=4                                    OPEN
Klein PSL2(F11)-NO                                    OPEN
```

Replay:

```text
/opt/homebrew/bin/python3 \
  goal_runs_20260808/CYCLOTOMIC_EXT_AUDIT/verify.py
```

Expected marker:

```text
CYCLOTOMIC-EXT-EXTERIOR-AUDIT-OK
```
