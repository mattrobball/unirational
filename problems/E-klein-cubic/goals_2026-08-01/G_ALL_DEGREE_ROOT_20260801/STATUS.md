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

The smallest local frontier is now the characteristic-zero primitive
saturation in line degree four: the split special fibre is empty on the
nonproper complement, so proper good reduction does not transfer it.  A
genuine all-line-degree recurrence would still leave every higher transverse
layer and the global image problem.  Globally the exact unresolved question
is existence of a rational point on the explicit generic twisted cubic over
the projective invariant field.

Replay from `goals_2026-08-01`:

```text
python3 G_ALL_DEGREE_ROOT_20260801/produce.py
python3 G_ALL_DEGREE_ROOT_20260801/verify.py
python3 G_ALL_DEGREE_ROOT_20260801/verify_boundary_recurrence.py
python3 G_ALL_DEGREE_ROOT_20260801/verify_line4_primitive.py
python3 G_ALL_DEGREE_ROOT_20260801/verify_line4_primitive_rur.py
```
