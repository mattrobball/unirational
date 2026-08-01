# P25 acceptance audit

This audit maps the binding goal to authoritative evidence.  A row marked
`pending` is not satisfied and prevents a terminal exit.

| Requirement | Evidence | State |
|---|---|---|
| Fixed free rank-43 DVR coefficient model at `p=89` | `certificates/degree25_direct_support/DVR_MODEL.md`, `verify_dvr.py`, `dvr_certificate.json` | established upstream; replay required in final verifier |
| Exact complete special-fibre landing-row rank 746 | `certificates/degree25_rowrank/verify_rowrank.py`; 2343-dimensional invariant basis and unisolvent evaluation matrix | established upstream; replay required in final verifier |
| 56 monic `K^3` rules and 690 residual relations | `certificates/degree25_finite_module/verify_presentation.py`; sealed rewrite and relation matrices | established upstream; replay required in final verifier |
| Historical 842-row and rank-28-isomorphism claims excluded | all new inputs use only the `p=89` 746-row packet and its row-equivalent rewrite/seed basis | satisfied by construction |
| Remaining degree-four closure handled honestly | P25V proves the 690-seed span is not closed; the emptiness route may bypass exact closure by using any genuine landing-equation subsystem whose projective locus is empty | satisfied as theorem boundary; no exactness claim made |
| Complete projective special fibre decided | exhaust Stage A, `b0=0,b1!=0`, and `b0!=0`; the latter two require exact irrelevant-saturated unit ideals for the verified syzygy-contracted over-approximation | **not satisfied**; Stage B is smallest unresolved stratum |
| Independent equation/upstream replay | `verify_syzygy_empty.py --equations-only` reconstructs the overwritten deterministic syzygies, checks `C(q)M2(q)=0`, rebuilds every `P3/P4` coefficient, and replays Stage A, rank 746, border, and DVR checks | **PASS**; terminal line explicitly disclaims an emptiness verdict |
| Transfer to characteristic zero | projective DVR properness from `DVR_MODEL.md`: empty special fibre implies empty generic fibre | logically available after special-fibre emptiness |
| Headline discipline | no positive/negative theorem without the missing exact gate; honest stop must be `P25-UNDECIDED` | satisfied; Problem E remains open |
| Required artifacts | `STATUS.md`, `SUPPORT.md`, `candidate_or_empty.json`, producers, verifier, `SEAL.json` | supplied for honest-stop exit |

## Exact incidence certificate

Write the sealed lower-presentation equation as

```text
M0(q)b0 + M1(q)b1 + M2(q)b2 = 0.
```

The 48 verified linear left syzygies `C(q)` annihilate `M2(q)` exactly.  Hence
every seed-incidence point satisfies

```text
P4(q)b0 + P3(q)b1 = 0.
```

The Stage-A certificate excludes `b0=b1=0`.  Double saturation of
`P3(q)b1` by the `q` and `b1` irrelevant ideals excludes
`b0=0,b1!=0`.  On the remaining stratum normalize `b0=1`; saturation of
`P4(q)+P3(q)b1` by the `q` irrelevant ideal excludes it.  Unit ideals in both
computations therefore make the lower-presentation support empty.  Since the
lower presentation surjects onto the true landing quotient, this implication
does not require the false rank-28 presentation-isomorphism claim.

No such unit ideals were obtained.  `saturation_attempts.json` records only
incomplete resource measurements.  Therefore this implication is not invoked
and the terminal status is `P25-UNDECIDED`.
