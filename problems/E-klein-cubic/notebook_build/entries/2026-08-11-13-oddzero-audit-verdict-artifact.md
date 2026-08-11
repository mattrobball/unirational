## 2026-08-11 The odd-residue zero is an ARTIFACT: audit verdict, the located degeneracy-semantics error, and STAGE1's count downgraded to a lower bound

Packet: `goal_runs_20260811/ODDZERO_AUDIT/`. Problem E remains **OPEN**.

Adversarial audit of `STAGE1_TIGHTEN`'s unclaimed `K(1) = K(3) = K(5) = 0`
(which at face value would have excluded every odd degree at order 0).
**Verdict: `ODD-ZERO-ARTIFACT`** -- the zero is real inside the model and is
reproduced exactly (0 agreements / 120 clashes at odd `d`, 90 / 0 at even, both
primes), but the model is wrong at one precise point: `s3sat.py:72-78` decides
degeneracy from the rank of the evaluated basis of the **whole module**
(`s3sweep.py:271-276`), while Theorem 15.1's second branch (`s(q) = 0`) is a
property of the **individual section**. The sections vanishing at the six V4
attaching points over a type-I plus-plane point form a codimension-**2**
subspace (dim `N(d,m) - 2`; 418 at `d = 35`); every non-zero member is still a
dominant sweep (`W^-_sigma` is D12-irreducible), and its next-order value
carries exactly the character closure demands at odd `d` -- with machine
witnesses at every odd `d` in `[3,11]`, both primes, changing no other child's
value. **No odd degree is excluded; the first open window stays at `d = 35`.**

Collateral: the identical test sits upstream (`s1coherence.py:293-296`), so
`STAGE1_COMPLEX_MAPS`'s stratum-coherent count `1.088 x 10^21` is a **lower
bound**, not the count, and its `2^6` arc-consistency cut an upper bound on the
true cut. Correction banners placed in `STAGE1_TIGHTEN` (2.2/2.4/2.5) and
`STAGE1_COMPLEX_MAPS` (15.2/15.3) in this commit; the repair (stratify the
degeneracy test by order of vanishing) is queued work, not done here. Anchors
all reproduced independently (census row multiset equal to sealed
`TERMINUS_STRATA_PW`; `N(d,m)`, H0-1 parity, STAGE2 Prop 1.4(ii)); the 13-row
psi model shown to be a relaxation (can only over-count, cannot make a zero);
`FIX-P1`'s `d = 25` kill and `D34_GUIDED_SWEEP`'s `d = 34` closure confirmed
independent of the artifact. Director adjudication: bug citations verified
against the sources; verifier replayed (52 checks, `ALLGREEN`, `p = 331, 661`).

Exits: `ODDZERO-AUDIT-VERDICT-ARTIFACT`, `ODDZERO-AUDIT-MECHANISM-REPRODUCED`,
`ODDZERO-AUDIT-DEGENERACY-SEMANTICS-ERROR`, `ODDZERO-AUDIT-ESCAPE-WITNESS`,
`ODDZERO-AUDIT-PSI-MODEL-SOUND`, `ODDZERO-AUDIT-ANCHORS-REPRODUCED`,
`ODDZERO-AUDIT-NO-DEGREE-EXCLUSION`,
`ODDZERO-AUDIT-STAGE1-COHERENCE-UNDERCOUNTS`.
