# Next order — degree-five A5 classifying maps and a genuine quadratic interface

**Parent packet:** `G3P-A5-SEMILINEAR-MATERIALIZATION-PASS`  
**Headline:** OPEN  
**Execution:** local runner only; no GitHub Actions or hosted CAS

## Mission

Decide whether either exact degree-eleven A5 point can be routed through an
actual `K_proj`-defined quadratic object with an explicit inverse to the
resolved tangent incidence or to `X_gen`.

The canonical degree-three map and the entire degree-four classifying family
are closed negatively for direct membership in `H_q` and `Q_q`. The first
unexamined constant-coefficient family is

\[
\mathcal Y_{H,5}=\operatorname{Hom}_H(\operatorname{Sym}^5W,V_3),
\qquad \dim\mathcal Y_{H,5}=5.
\]

Treat the two maximal A5 classes separately throughout.

## Allowed CAS

Use locally installed Singular, Macaulay2, Magma, Sage/FLINT, or msolve as
appropriate. Do not invoke a GitHub runner. Modular calculations are
**discovery only** unless followed by exact characteristic-zero reconstruction
or a proved integral specialization argument in the correct direction.

At most one unrelated memory-heavy CAS job may run at a time.

## C0 — bind and rebuild

Consume by path and SHA-256:

```text
goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/
goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/
goal_runs_after_35fa/H_A5_TWISTS/
goal_runs_after_eb21458/G3P_A5_SEMILINEAR_QUADRATIC/
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
```

Rebuild exactly over the characteristic-zero coefficient field:

1. both A5 subgroups and installed three-spaces;
2. a basis `Y0,...,Y4` of `mathcal Y_{H,5}`;
3. the exact H-A5 landing covariant `Psi_H`;
4. the normalized G3 circuit
   `a_c=B_G3^{-1} Psi_H(sum c_i Y_i)`.

An independent verifier must reconstruct the map space and not read its
dimension from JSON.

## C1 — polar identity ideals

For projective parameters `[c0:...:c4]`, construct

\[
N_H(w,c)=B_F(w,w,\Psi_H(Y_c(w)))
\]

of `w`-degree 57 and parameter degree 11, and

\[
N_Q(w,c)=B_F(w,\Psi_H(Y_c(w)),\Psi_H(Y_c(w)))
\]

of `w`-degree 111 and parameter degree 22.

Do **not** materialize a dense `6,913,340`-monomial degree-111 ambient vector
without a resource preflight. Preferred exact representations:

- an exact basis of the relevant A5-invariant form spaces;
- an independently certified unisolvent evaluation grid;
- sparse straight-line circuits followed by exact coefficient recovery.

Form the saturated projective ideals of the coefficient conditions

```text
I_H = coefficients_w(N_H)
I_Q = coefficients_w(N_Q)
```

in the parameter projective four-space. Use primes 89, 199, and 331 for
screening when good; every promoted component needs exact reconstruction over
the characteristic-zero field.

Permitted scoped exit:

```text
G3P-A5-DEG5-POLAR-EMPTY-PASS
```

only if both projective ideals are proved empty exactly for both A5 classes.

## C2 — quadratic interface, not merely polar membership

A parameter point in `V(I_H)` or `V(I_Q)` is only an input. It is not a
Springer reduction by itself.

For every surviving component, construct a quadratic or conic object `Z/K_proj`
and explicit rational maps

\[
Z\dashrightarrow I_q
\quad\text{or}\quad
Z\dashrightarrow X_{gen}.
\]

Required ledger:

1. the A5 point gives `Z(L_H) != empty`;
2. `Z` and every coefficient descend to `K_proj`;
3. `[L_H:K_proj]=11` on the recorded open;
4. rank, discriminant, singular locus, and Clifford data of `Z`;
5. Springer is applied only to `Z`;
6. the descended isotropic vector is pushed through written inverse formulas
   to `(v,t)` and then `r=q+t v`;
7. `Phi(r)=0` is checked in the authoritative 35-coefficient model.

A `K_proj`-point of `Q_q` with no inverse map is a nonverdict.

## C3 — resolved tangent fallback

If both direct polar ideals are empty, use the materialized A5 point to search
inside the resolved tangent incidence rather than abandoning route 1.

For `p=a_H` and the line through `p` and `q`, retain the residual binary
quadratic and its discriminant. Search for a Galois-functorial construction
of a `K_proj` quadric/conic fibre whose `L_H`-point is explicit. Allowed
operations include:

- polar contractions and the nondegenerate form `B(q,-,-)`;
- trace/norm of semilinear tensors, with degree and scaling audited;
- the Paley-biplane incidence map only on the abstract two étale algebras;
- third-intersection formulas, which are multihomogeneous.

Forbidden:

- pairing the eleven conjugates by a nonfunctorial chord tree;
- summing independently scaled projective representatives;
- using the invalid constant orbit `rho(g)e0`;
- invoking Springer directly on the cubic.

## C4 — positive promotion

A positive candidate must include:

```text
POINT.md
BRIDGE_POLAR_POS.md
point.json
quadratic_interface.json
produce.py
independent verifier
REPLAY.md
SEAL.json
```

and must verify denominator opens, exact landing, original Klein substitution,
generator equivariance after denominator clearing, and the G3A dominance
ledger.

Authorized exits:

```text
G3P-POINT-HEADLINE-POSITIVE
G3P-QUADRATIC-SPRINGER-REDUCTION-PASS
G3P-A5-DEG5-POLAR-EMPTY-PASS
G3P-UNDECIDED
```

Only the first is a Problem-E headline candidate.
