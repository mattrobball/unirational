# Goal A5Q — convert an `A_5` degree-eleven point by a degree-four residual construction

**Pinned state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`  
**Priority:** 6, high risk  
**Possible headline direction:** positive

## Mission

Exploit the exact rational points on the two maximal `A_5` generic twists to
construct a rational point on the full generic `G=PSL_2(F_11)` twist.

The intended mechanism is not an unsupported odd-degree descent theorem.
Instead:

1. descend an exact degree-eleven closed point `Z` on the full generic twist;
2. find a `K`-morphism

   ```text
   phi:P^1_K -> P^4_K
   ```

   defined by basepoint-free binary quartics, together with a degree-eleven
   point `tau in P^1(L)`, such that `phi(tau)` is the `A_5` point;
3. then the binary form `F(phi)` has degree twelve and is divisible by the
   degree-eleven divisor polynomial of `tau`;
4. if `phi(P^1)` is not contained in the cubic, the residual factor is linear
   over `K`, and its root gives a `K`-point of the genuine twist.

A nondegenerate rational normal quartic is the cleanest case, but any
basepoint-free degree-four map with nonzero `F(phi)` is acceptable.

## Binding input

There are two conjugacy classes of maximal `A_5` subgroups `H_i<=G`, each of
index eleven.  The post-pinned packets give, separately for each class, an
exact rational point on the genuine generic `H_i` twist via a degree-eleven
Reynolds covariant.

Those points live over the stipulated `A_5` invariant fields.  The first task
is to instantiate them on the `H_i`-reduction of the full generic Schur
torsor.  Do not assume this field comparison or the degree-eleven closed point
without constructing it.

## Work packages

### A5Q.0 — exact subgroup-to-full-twist descent

Let `E/K` be the connected generic `G`-torsor used for the authoritative Schur
twist and put

```text
L_i = E^{H_i},  [L_i:K]=11.
```

For each maximal class:

1. construct `L_i/K` exactly, either by a primitive resolvent or a certified
   `H_i`-fixed subfield interface;
2. identify the induced `H_i`-torsor `E/L_i` with a specialization of the
   versal `A_5` torsor used by the point packet;
3. transport the exact `A_5` point to

   ```text
   P_i in X_T(L_i);
   ```

4. verify its coordinates in the authoritative full Schur-twist equation;
5. prove that its conjugates define a reduced effective degree-eleven closed
   subscheme `Z_i subset X_T` over `K`;
6. give trace/norm or multiplication-matrix data allowing independent replay
   without expanding the full Galois closure.

A point on an abstract generic `A_5` twist is not enough.  The output must be
an exact point over the specific field `E^{H_i}` attached to the full torsor.

Required marker:

```text
A5Q_INDEX11_CLOSED_POINT_OK
```

### A5Q.1 — formulate the degree-four interpolation incidence

Choose one class `i`, a primitive element for `L_i/K`, and write the point
coordinates as `P=(P_0:...:P_4)` in `L_i`.

Parameterize

```text
phi_j(s,t) = sum_{k=0}^4 c_{j,k} s^{4-k} t^k,
c_{j,k} in K,
```

and a parameter `tau=(alpha:beta) in P^1(L_i)` of exact degree eleven over
`K`.  Impose

```text
(phi_0(tau):...:phi_4(tau)) = P.
```

Use a scalar `lambda in L_i^*` and expand equality in a fixed `K`-basis of
`L_i`.  Quotient the natural `PGL_2` and projective scaling freedoms by exact
charts.  Include:

- basepoint-free conditions for the five quartics;
- exact degree eleven of `tau`;
- the condition `F(phi)` is not the zero binary form;
- optional nondegeneracy or birationality conditions only when useful, not as
  unnecessary restrictions.

Exploit that the equations are linear in the `c_{j,k}` once `tau` and
`lambda` are fixed.  Reduce to determinantal/Fitting conditions in the
coordinates of `tau` before nonlinear elimination.

### A5Q.2 — solve the interpolation incidence

Proceed in this order:

1. determine the generic rank and expected codimension of the evaluation
   matrix;
2. use the two maximal `A_5` classes separately;
3. test symmetry-adapted choices of `tau`, including low-support expressions
   in the degree-eleven field;
4. perform modular discovery at split good primes;
5. reconstruct any low-degree component or smooth point over `K`;
6. verify all field, basepoint, and interpolation equations exactly and at an
   unused holdout prime.

The incidence is finite and exact, but a failed bounded support search is not
an emptiness theorem.  If the full incidence is attacked for emptiness, use a
projective saturation or finite affine cover.

### A5Q.3 — exact residual-point theorem

For a solution, let `g_tau(s,t)` be the homogeneous degree-eleven polynomial
whose zero divisor is the conjugate orbit of `tau`.  Prove exactly that

```text
F(phi(s,t)) = g_tau(s,t) * ell(s,t)
```

with `ell` a nonzero linear form over `K`.

Then:

1. compute the `K`-rational root `rho` of `ell`;
2. prove `rho` is not a base point of `phi`;
3. verify `phi(rho)` is a nonzero point of the authoritative generic twist;
4. check that it is the residual intersection scheme-theoretically, including
   multiplicities at the degree-eleven divisor;
5. execute the accepted Schur-versality bridge to a positive headline.

If `F(phi)=0` identically, the map gives a rational curve on the twist and is
already an even stronger positive output; verify that case separately.

### A5Q.4 — scoped refutation and variants

If the degree-four incidence is empty, record only

```text
A5Q-DEGREE4-RESCUE-EMPTY-SCOPED.
```

Then test, without headline promotion, whether:

- a degree-five map leaves a useful residual degree-four point compatible
  with the installed Sarkisov quartic branch;
- the two distinct degree-eleven cycles together lie on a lower-complexity
  scroll or reducible rational curve;
- secant/tangent constructions among conjugate `A_5` points produce a
  degree-one residual cycle.

Every variant must output an actual point or explicit rational curve, not a
formal gcd of zero-cycle degrees.

## Exits

```text
A5Q-RESIDUAL-POINT-HEADLINE-POSITIVE
A5Q-RATIONAL-CURVE-HEADLINE-POSITIVE
A5Q-INDEX11-CLOSED-POINT-PASS
A5Q-DEGREE4-RESCUE-EMPTY-SCOPED
A5Q-UNDECIDED
A5Q-DESCENT-BRIDGE-FAIL
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_bd610a/A5Q_QUARTIC_RESCUE/
```

Provide at least:

```text
INPUT_MANIFEST.json
SUBGROUP_DESCENT.md
FIELD_L1.json
FIELD_L2.json
INDEX11_POINT_CLASS1.json
INDEX11_POINT_CLASS2.json
INTERPOLATION_INCIDENCE.md
RESIDUAL_IDENTITY.md
POINT.md when applicable
BRIDGE_A5Q_POS.md when applicable
produce_*.py or exact CAS scripts
verify_*.py
SEAL.json
STATUS.md
```

The independent verifier must reconstruct the degree-eleven field action,
substitute the transported point in the full twist, verify the interpolation,
and divide the binary degree-twelve form by `g_tau` exactly.