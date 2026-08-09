# Reproduction and source map

## Exact finite check

```bash
python3 scripts/verify_v14_identification.py
```

The script uses only the Python standard library and exact rational
arithmetic in `Q(zeta_11)`.

## Repository dependencies

- `NOTEBOOK.md`, `REPAIR.md`, `RESOLUTION.md`;
- `goals_2026-08-01/Q_SCHUR_DESCENT/parallel/constructive_point/`
  `GROSS_POPESCU_AUDIT.md` and `verify_gross_popescu_boundary.py`;
- `theory/FIX_I_bcomplex.md`, `theory/FIX_T_gate.md`,
  `theory/FIX_IX_v14.md`;
- `goal_runs_after_c53d89a/FIX_IX_SEAL/REPORT.md` and its exact scripts;
- `certificates/STRATA_EXACT.md`, `NORMAL_CHARACTERS.md`,
  `MARKED_S3_GEOMETRY.md`;
- Problem-F and Fermat sealing packets listed in the mission prompt.

## Literature dependencies

- Gross--Popescu, arXiv:math/9902017: Sections 1--2, Theorems 2.2 and 2.6,
  Lemmas 2.1/2.5/2.7, Remark 2.8;
- Tschinkel--Zhang, arXiv:2409.08392: Pfaffian--Grassmannian vector bundles,
  fixed strata, nonbirationality, and twisted stable birationality;
- Cheltsov--Tschinkel--Zhang, arXiv:2502.19598: current open-case list;
- current `G`-birational rigidity work and the Klein superrigidity result it
  cites.

## Verification classes

The stack/coarse and equivariance arguments are theorem proofs.  The only new
CAS-style component is a theorem-forced exact representation check.  No
covariant sweep, random hyperplane search, finite-field point search, or
uncontrolled Groebner experiment is used.
