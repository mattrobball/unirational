G-STRUCTURAL-UNDECIDED

# Isolated Goal G delta

This directory contains only the work of the present run.  A concurrently
active worker was already changing the pre-existing `G_ALL_DEGREE/` packet,
so this sibling directory is the authoritative isolation boundary for this
delta.

The headline problem is not decided.  The proved structural results are:

1. at every odd plane order, the first landing equation is the same
   quadratic-Veronese syzygy and forces the even successor into the ideal of
   the primitive odd leading pair;
2. the first transverse layer surviving the common-line gate satisfies
   `(J_(2r+1))_(3r+3)=(xyz)^(r-1)(J_3)_6`;
3. for coefficients constant along the triple line, the complete order-one
   and order-three projective landing schemes have empty geometric special
   fibre at 67, and hence empty characteristic-zero generic fibre by proper
   good reduction; the recurrence propagates this emptiness to every odd
   symbolic order.
4. positive line degree has an exact evaluation recurrence modulo the
   invariant boundary cubic `D_L`, with an 11-dimensional evaluation
   quotient and an 8-rank central-equality map;
5. the residual `D12` point module is finite length, so the apparent
   low-degree equality `kernel=D_L*(lower degree)` cannot continue: at
   boundary power 23 and line degree two, a 3-space survives the linear
   boundary map and is not a `D_L` multiple over split `F_67`;
6. the corresponding nonlinear boundary-value scheme is nonempty even
   though the whole-line central-compatible ideals are empty in line degrees
   two and three.  Hence no nonlinear divisibility induction follows;
7. in line degree four, the three primitive charts complementary to
   `D_L H_1` are unit ideals over split `F_67` in both msolve and Singular.
   The full support is nevertheless nonempty because it contains the
   degree-48 support inherited from line degree one.  The default recovered
   RUR claiming a primitive component is rejected by direct substitution.
8. a new eight-chart scheme audit proves that the full split-67 line-degree-
   four scheme equals the inherited `D_L` multiple scheme
   scheme-theoretically: every chart has length 48 and all three primitive
   coordinates have zero normal form.  The 2,024 maximal normal-Jacobian
   minors have unit degeneracy ideal on every chart;
9. the complete degree-one characteristic-zero coefficient ideal is now
   reconstructed over `Q(zeta_11)`: an exact RREF reduces all 760 unisolvent
   coefficient rows to rank 14, and Singular gives length 48 both in
   characteristic zero and after reduction at `(67,zeta_11-64)`.  The
   resulting DVR algebra is finite flat of rank 48.  Nakayama therefore
   upgrades the degree-four equality to characteristic zero:
   `X_4=D_L X_1`, with no primitive degree-four point on this layer.

The smallest local frontier is now a genuine all-line-degree theorem; the
former characteristic-zero degree-four transfer gap is closed.  Even such an
all-line theorem would still leave every higher transverse layer and the
global image problem.  Globally the exact unresolved question is existence
of a rational point on the explicit generic twisted cubic over the projective
invariant field.

Replay from `goals_2026-08-01`:

```text
python3 G_ALL_DEGREE_ROOT_20260801/produce.py
python3 G_ALL_DEGREE_ROOT_20260801/verify.py
python3 G_ALL_DEGREE_ROOT_20260801/verify_boundary_recurrence.py
python3 G_ALL_DEGREE_ROOT_20260801/verify_line4_primitive.py
python3 G_ALL_DEGREE_ROOT_20260801/verify_line4_primitive_rur.py
python3 G_ALL_DEGREE_ROOT_20260801/verify_line4_normal_rigidity.py
/opt/homebrew/bin/python3 G_ALL_DEGREE_ROOT_20260801/verify_line1_char0.py
```
