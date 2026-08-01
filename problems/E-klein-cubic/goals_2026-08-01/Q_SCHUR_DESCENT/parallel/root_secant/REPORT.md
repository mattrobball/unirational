# Cubic-resolvent secant audit

## Scope

Assume a smooth cubic surface `S/K` has a separable quartic point with
geometric conjugates `P_1,...,P_4`.  For every pair let `Q_ij` be the third
point on the chord through `P_i,P_j`, and for each partition
`pi = ij|kl` let `R_pi` be the third point on the chord through `Q_ij,Q_kl`.
The three partitions form the usual cubic-resolvent Galois set.

The secant identities give, in `CH_0(S_bar)` (and as Galois-equivariant
families),

```
[P_i] + [P_j] + [Q_ij] = h,
[Q_ij] + [Q_kl] + [R_pi] = h,
```

where `h` is the class of a line section.  Hence the `R_pi` form an effective
degree-three zero-cycle over `K`, or equivalently an `M`-point for the cubic
resolvent algebra `M/K`.  In the primitive cases isolated by the main quartic
reduction, the partition image is `C3` for `A4` and `S3` for `S4`.

## Exact negative result for the shortcut

The three residual points are **not** universally collinear.  The producer
`resolvent_geometry_probe.py` constructs five deterministic cubic surfaces
over `QQ` through four rational coordinate vertices, recomputes every chord
and pairing residual exactly, proves smoothness in all four affine charts by
Groebner bases, and finds projective rank three for the three `R_pi` in every
example.  The independent verifier reconstructs the first example from the
JSON certificate and repeats the smoothness, incidence, and rank checks
without importing the producer.

Thus the cubic-resolvent cycle does not automatically become a `K`-rational
line section, and the naive collinearity route cannot lower degree three to a
`K`-point.

## Boundary

These are split test configurations over `QQ`, not the Schur twist or a
primitive quartic orbit.  They refute only a universal secant identity.  They
do not rule out an additional Schur-specific identity, and they do not prove
or refute `X(K) != empty`.

Replay from the repository root:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u goals_2026-08-01/Q_SCHUR_DESCENT/parallel/root_secant/resolvent_geometry_probe.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u goals_2026-08-01/Q_SCHUR_DESCENT/parallel/root_secant/verify_resolvent_geometry.py
```
