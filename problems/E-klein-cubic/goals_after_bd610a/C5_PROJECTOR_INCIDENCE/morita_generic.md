# Exact generic Morita coefficient DAG

This packet materializes the five genuine common-right-`D`-line equations as
exact lazy `K_proj` circuits.  It does not assert a `K_proj`-point.

## Full system and denominator-minimal formula

Put

```text
d_alpha=e*M_alpha*e,  M=(1,frame[1],frame[2],frame[3]),
G=(1,frame[1],frame[2]),
q_r=sum_alpha u_(4*r+alpha)d_alpha.
```

For `B_i=Q(V_i)` and `e=-P*Q/s`, the ordered coefficient of
`u_(4r+alpha)u_(4s+beta)` is

```text
-Tr(P*M_alpha^T*Q*P*G_r^T*B_i*G_s*P*Q*M_beta)/(2*s^3).
```

This follows directly from the original Morita pairing by substituting
`star(X)=Q^-1 X^T Q`, `S_i=Q^-1 B_i`, using `e^2=e`, and cycling the ordinary
matrix trace.  In particular, no corner Cramer inverse and no expanded
36-dimensional multiplication table is needed.

`morita_generic_dag.json` contains all `5*78=390` upper-triangular
homogeneous coefficients.  It also contains the three charts `q_r=1_D`, each
with `5*(1+8+36)=225` coefficient records.  Because the generic quaternion
`D` is division, every nonzero component is invertible, so these three charts
cover every generic right-`D` line.  The `q_0=1_D` chart alone is retained as
the chart containing the sealed residue seed.

The explicit trace denominator is `2*s^3`.  The installed normalized frame
adds at most `f14^4`; required opens are `2`, `Pf(Q)`, `s`, `f14`, the selected
corner minor, and the selected Morita-module minor.  Constant denominators
come from the sealed `Q(zeta11,t)` RUR.

## Exact inputs and APIs

The builder binds hashes of:

```text
goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/
  c2_morita.json
  ambient_degree12_rur_char0.json
  ambient_degree12_global_exact.json
  ambient_degree12_a47_chart.json
goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/
  compressed_algebra.json
  involution.json
  distinguished_five_plane.json
tmp/pfaffian_representation_alignment/core.py
tmp/pfaffian_representation_alignment/certificate.json
tmp/generic_twist/phi_coefficients.py
certificates/fano_c2/produce_c2.py
tmp/pfaffian_rank2_idempotent_attack/certificate.json
```

The exact constant model is
`Q(zeta11,t)/(Phi_11(zeta11),w(t))`; choosing `t` is legitimate because the
mathematical base contains the algebraically closed constant field `C`.

## Lift gate and split-fibre caveat

In old descended corner coordinates, the sealed residue line is

```text
[1,0,0,0 | 13,9,8,10 | 0,20,7,1].
```

Fixing `(u9,u10,u11)=(20,7,1)`, the Jacobian in
`(u4,u5,u6,u7,u8)` has determinant `11 mod 23`.  Therefore the residue line
has a unique formal/Henselian lift after those three free coordinates are
fixed.  The smallest exact global gate is the denominator-saturated
zero-dimensional algebra of those five equations: its `u8` eliminant must
have a `K_proj`-linear factor reducing to the selected simple root, and
back-substitution must show that the selected etale factor has residue degree
one.

The special-fibre `4+4` linearization cannot be used for that generic gate.
It requires an identification `D_23=Mat_2(F_23)`, while generic `D` is a
quaternion division algebra.  Independently, every old coordinate
`u4,...,u11` has a nonzero square coefficient at the good specialization;
hence no nonempty jointly-linear coordinate subset exists generically in the
descended basis.

A single simple residue root proves an etale/formal local section only.  It
does not prove that the selected eliminant factor has degree one over
`K_proj`.

Replay:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u morita_generic_build.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u morita_generic_verify.py
```

Terminal marker:

```text
C5-MORITA-GENERIC-390-COEFFICIENT-DAG-INDEPENDENTLY-VERIFIED
```
