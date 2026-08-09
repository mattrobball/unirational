# Gross--Popescu equivariant moduli audit -- status

Audit base: `AUDIT_BASE_COMMIT`.

## Verdict

The natural change-of-level action on the moduli problem is the Gross--Popescu
`V14` action, not the standard regular action on the Klein cubic.

Established exits:

- **GP-NATURAL-PSL2-ACTION-PASS**;
- **GP-THETA11-G-EQUIVARIANT**;
- **GP-MODULI-EQUIVARIANTLY-BIRATIONAL-V14**;
- **GP-MODULI-NON-G-UNIRATIONAL**;
- **GP-MODULAR-ACTION-IS-V14-NOT-KLEIN**.

Not established, and not implied by this packet:

- `GP-BRIDGE-KLEIN-NONUNIRATIONAL`;
- `KLEIN-PSL2(11)-NONUNIRATIONAL`;
- `GP-BRIDGE-KLEIN-HEADLINE-POSITIVE`.

Consequently the Problem-E headline remains **OPEN**.

## The theorem chain

1. On the marking presentation of the moduli stack, the natural group is
   `SL2(F11)`.  Its center `{+I,-I}` acts 2-isomorphically to the identity,
   because `[-1]_A` changes a symplectic marking by `-I`.  The effective
   stack/coarse group is therefore `G=PSL2(F11)`.
2. The coarse action is faithful and generically free.  The generic
   forgetful fiber has `1320/2=660` points, and
   `C(A_11^lev)^G=C(A_11)`.
3. Gross--Popescu's map `Theta_11` is equivariant functorially: changing the
   theta marking by `g` transports the ideal of quadrics and its
   `H_11`-multiplicity plane by the even Weil representation `rho_+(g)`.
4. After the exact basis change between Gross--Popescu's projected even
   basis and the repository's cosine basis, their five Pluecker equations
   cut the same invariant `10'` summand of `Lambda^2(V_+)` used by the
   sealed repository `V14`.
5. Hence `A_11^lev ~_G V14` for the natural effective level action.
6. The sealed `V14` centralizer obstruction therefore proves that this
   natural modular action is not `G`-unirational and is not weakly versal.
7. The Fano--Iskovskikh map `V14 -->> K` loses equivariance exactly when a
   hyperplane in `P(V_+^*)` is fixed.  No invariant hyperplane exists.
   Retaining the hyperplane/vector-bundle parameter gives the twisted stable
   correspondence of Tschinkel--Zhang, not an equivariant birational map.
8. The standard Klein action and the transported modular action are not
   `G`-birationally conjugate, even after relabeling by an automorphism of
   `G`.  Birational superrigidity is the decisive invariant; the differing
   involution strata are a visible diagnostic, not by themselves the proof.

## Exact replay

```bash
python3 problems/E-klein-cubic/goal_runs_20260809/\
  GROSS_POPESCU_EQUIVARIANT_MODULI/scripts/verify_v14_identification.py
```

Expected terminal line:

```text
V14_IDENTIFICATION_PASS
```

The verifier works exactly over `Q(zeta_11)`.  It proves the basis-corrected
five-plane is stable under both Weil generators and deliberately checks that
the uncorrected Gross--Popescu equations fail the Fourier-generator test.

## Boundary of the result

The packet does not supply an independent intrinsic computation of the
compactified PEL/Shimura fixed curve or a classification of every special
modular point at which the rational map `Theta_11` may be undefined.  The
non-unirationality theorem instead uses the proved equivariant birational
identification and the sealed smooth projective `V14` compactification, so no
unproved statement about boundary fixed strata enters the theorem.
