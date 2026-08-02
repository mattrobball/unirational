# G4A replay

```bash
python3 goal_runs_after_141f60/G4A_INDUCTION_PROJECTORS/produce_g4a.py
python3 goal_runs_after_141f60/G4A_INDUCTION_PROJECTORS/verify_all.py
```

Independent verifier rebuilds both coset actions from sealed H generators,
matches `s_perm`/`t_perm`, rebuilds all eleven G3-frame substitutions,
checks F_Klein=0, projector algebra (P1,P10,P5×2), and operation matrices.
