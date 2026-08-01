# Replay commands

Run from `problems/E-klein-cubic` unless noted otherwise.

```sh
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goals_2026-08-01/Q_SCHUR_DESCENT/verify_q0.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  tmp/schur_unrestricted_point_attack_audit/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  certificates/subgroup_orbit_check.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  tmp/step4_essential_dimension/verify_reductions.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  tmp/schur_structural_routes/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  tmp/schur_fibration_picard_obstruction/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goals_2026-08-01/Q_SCHUR_DESCENT/verify_quartic_frontier.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goals_2026-08-01/Q_SCHUR_DESCENT/verify_covariant_attack.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goals_2026-08-01/Q_SCHUR_DESCENT/degree12_primitive_block.py \
  --generate --samples 700 --write-input

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goals_2026-08-01/Q_SCHUR_DESCENT/degree12_triple_slices.py \
  --start-index 0 --stop-index 5 --timeout 60 --threads 2

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goals_2026-08-01/Q_SCHUR_DESCENT/degree12_nested_slices.py \
  --start-size 4 --stop-size 8 --timeout 900 --threads 4
```

Expected terminal markers are, respectively:

```text
Q_SCHUR_Q0_LEDGER_EXACT
SCHUR_DEGREE55_ADVERSARIAL_AUDIT_EXACT
(successful subgroup PASS ledger, exit 0)
BOUNDARY all arithmetic reductions pass; no checked identity proves or disproves C_gen(K_proj) != empty
SCHUR_STRUCTURAL_ROUTES_EXACT
SCHUR_FIBRATION_PICARD_OBSTRUCTION_EXACT
Q_SCHUR_QUARTIC_FRONTIER_EXACT
Q_SCHUR_DEGREE12_SCOPED_ATTACK_EXACT
rankOverF23=669/700
tripleIndex=4 triple=(0, 1, 6) rank=669 status=empty
primitiveCount=7 dimension=23 rank=669 status=empty
```

The explicit `BOUNDARY` lines are intentional.  A passing Q0 replay certifies
the zero-cycle and scoped-model ledgers, not a headline point or pointlessness
claim.

The completion-audit packets replay from `goals_2026-08-01` as follows:

```sh
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/verify_completion_audit.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/negative_obstruction/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/negative_obstruction/verify_theorem_search.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/quartic_descent/verify_field_certificate.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/quartic_descent/verify_linked_quintic_certificate.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/quartic_descent/verify_geometry_certificate.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/root_secant/verify_resolvent_geometry.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/constructive_point/verify_kproj_krylov.py

env PYTHONDONTWRITEBYTECODE=1 /usr/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/constructive_point/verify_gross_popescu_boundary.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/curve_incidence/verify_incidence.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/incidence_generality/probe_dominance.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/incidence_splitting/verify_splitting_logic.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/fixed_curve_bridge/verify_bridge_cases.py
```

Expected markers are:

```text
Q_SCHUR_COMPLETION_AUDIT_NONTERMINAL_EXACT
Q_NEGATIVE_OBSTRUCTION_INTERFACE_ACCEPT
Q_RESIDUE_THEOREM_SEARCH_ACCEPT
Q_SCHUR_QUARTIC_FIELD_INDEPENDENCE_EXACT
Q_SCHUR_LINKED_QUINTIC_FIELD_LATTICE_EXACT
Q_SCHUR_QUARTIC_GEOMETRY_GATES_EXACT
Q_SCHUR_RESOLVENT_GEOMETRY_INDEPENDENT_REPLAY_OK
Q_CONSTRUCTIVE_KPROJ_KRYLOV_EXACT
GROSS_POPESCU_EQUIVARIANCE_BOUNDARY_EXACT
Q_SCHUR_CURVE_INCIDENCE_ARITHMETIC_REPLAY_OK
Q_SCHUR_CURVE_INCIDENCE_NO_DESCENT_FORCE_EXACT
Q_SCHUR_RESOLVENT_DOMINANCE_EXACT
Q_SCHUR_INCIDENCE_SPLITTING_BOUNDARY_EXACT
Q_SCHUR_FIXED_CURVE_BRIDGE_EXACT
```

Each packet also records an explicit nonclaim.  In particular, these markers
certify arithmetic, group theory, Hilbert-function exclusions, or a theorem
applicability boundary; none certifies a point or pointlessness.

The primitive-block Groebner runs are preserved as bounded negative results:

```text
degree12_primitive_result.json       timeout after 600 seconds, max pairs 2000
degree12_primitive_m512_result.json  timeout after 900 seconds, max pairs 512
```

Neither timeout is a mathematical verdict.
