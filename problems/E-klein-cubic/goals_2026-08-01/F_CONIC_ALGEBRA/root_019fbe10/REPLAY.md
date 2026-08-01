# Replay

From `F_CONIC_ALGEBRA/root_019fbe10/` run:

```sh
/opt/homebrew/bin/python3 verify_root_audit.py
```

Expected terminal markers:

```text
ROOT_PARENT_TERMINAL_PACKET_ACCEPT
ROOT_INFINITY_NORMALIZATION_INVERSE_ACCEPT
ROOT_BASE_SCHEME_NAKAYAMA_LIFT_INPUTS_ACCEPT
ROOT_UNIVERSAL_NET_NORMALITY_CHARTS_ACCEPT
ROOT_GOAL_F_CONIC_CRITERION_EMPTY_ACCEPT
```

The verifier first replays the sealed parent field and infinity-obstruction
packet.  It then checks the birational inverse identities omitted from the
parent verifier, independently checks every algebraic hypothesis in the
proper Nakayama lift of the base ideal, and reruns all nine good-reduction
charts covering `P^2_z x P^2_lambda`.  Finally it verifies the isolated seal.

The modular chart calculation certifies an upper bound on the singular-locus
dimension; normality and the class-group implication are the exact arguments
recorded in `RESOLUTION.md`.  Exact inclusion, flatness of the claimed
degree-three subscheme, and special-fibre ideal equality are checked
separately; the lift itself is the proper-support and Nakayama argument in the
resolution.
