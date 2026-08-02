# Goal T3A — exact RUR exhaustiveness and the authoritative common open

**Depends on:** pinned state and inputs in `README.md`  
**Worker:** local algebra/CAS runner plus theorem auditor  
**Expected class:** finite exact computation  
**Output subdirectory:** `T3A_RUR_EXHAUSTIVENESS/`

## Mission

Turn the corrected degree-six RUR from a verified component into an exact and
**exhaustive** description of the dominant singular locus of the simple-fold
algebra over `K=Q(A,u)`.

The terminal theorem must identify, on one explicit localization,

```text
I_sing = (q, B*q_Z-NB, Y*q_Z-NY)
```

inside `K[B,Y,Z]`, prove that the quotient is the degree-six field
`K[Z]/(q)`, and prove that every named gate is a unit there.  This supplies the
height-one prime required by normalization.

A collection of special fibres, interpolation alone, or a modular Gröbner
basis without a characteristic-zero transfer certificate is not enough.

## 1. Exact object

Let

```text
R0 = Q[A,u,B,Y,Z]
I0 = (P,P_u,P_A,P_B,P_Y,P_Z)
```

and localize by the factors required by the accepted simple-fold chart:

```text
B, ell, Q4, P_uu, C, delta
```

plus every denominator introduced by the RUR.  If the chosen fold object also
inverts the complementary resultant factor `G`, state that explicitly and
include its relevant factors in the common-open polynomial `h`.

Do not silently alternate between `D(Sigma)` and `D(G Sigma)`.

Define

```text
q   = QZ(A,u,Z),
r_B = B*q_Z - NB(A,u,Z),
r_Y = Y*q_Z - NY(A,u,Z),
p_RUR = (q,r_B,r_Y).
```

The corrected signs in these formulas are binding.

## 2. Accepted lower-bound data

Replay and independently audit:

```text
goals_after_bd610a/scratch_t3/generic_rur_A_grid.json
goals_after_bd610a/scratch_t3/verify_t111_generic_rur_identities_result.json
goals_after_bd610a/scratch_t3/verify_t111_q_and_special_fibre_result.json
```

These establish, subject to source-hash checks:

- all six generators of `I0` vanish under the RUR over `Q(A,u)`;
- `q` is irreducible and squarefree of degree six over `Q(A,u)`;
- hence `R0/p_RUR` contributes a degree-six domain to the localized critical
  scheme.

The new work is the matching upper bound and gate/exhaustiveness theorem.

## 3. Required local CAS run

Run the existing generic modular upper-bound calculation **locally**:

```sh
cd problems/E-klein-cubic/goals_after_bd610a
python3 scratch_t3/emit_mod101_generic_upper_bound.py
Singular scratch_t3/mod101_generic_upper_bound.sing \
  | tee scratch_t3/mod101_generic_upper_bound.out
```

Use the installed local executable path if `Singular` is not on `PATH`.
Record version, wall time, and peak RSS.  Do not add a GitHub Actions workflow.

The discovery target is a zero-dimensional localized quotient of length six
over `F_101(A,u)`.  Raw lines such as

```text
DIM=0, VDIM=6
```

are not yet the final certificate.

## 4. Characteristic-zero upper-bound certificate

Convert the successful modular computation into a checkable
characteristic-zero rank certificate.

A preferred certificate is a border basis with standard monomials

```text
1, Z, Z^2, Z^3, Z^4, Z^5
```

or another explicitly listed six-element basis.  For every border monomial,
produce a finite Macaulay matrix whose rows come from the **original localized
critical equations** (Rabinowitsch variables are allowed for saturation), and
record a pivot minor nonzero modulo 101.  Since that integer/rational-function
minor is then nonzero in characteristic zero, the same six monomials span the
characteristic-zero quotient.

The certificate must address all of the following.

1. The coefficient denominators and leading coefficients are included in `h`.
2. Saturation is represented by exact equations, not by an unrecorded solver
   state.
3. The degree at which the border closes is stated and justified.
4. The modular pivot data is replayable without trusting Singular's stored
   booleans.
5. The rank direction is written correctly:

   ```text
   rank_Q >= rank_F101  =>  quotient dimension over Q(A,u) <= 6.
   ```

Combined with the RUR lower bound `>=6`, conclude equality.

An alternative exact-Q Gröbner or border-basis computation is acceptable if
it completes locally within the resource budget and has an independent
verifier.

## 5. Ideal equality and prime theorem

After proving the localized critical quotient has dimension six over `K`,
prove

```text
I0 K[B,Y,Z] localized at h = p_RUR K[B,Y,Z] localized at h.
```

Required ingredients:

- containment `I0 subset p_RUR` from the exact RUR identities;
- equality of quotient dimensions;
- reducedness/separability from `gcd(q,q_Z)=1`;
- irreducibility of `q`, hence the quotient is a field;
- no embedded or residual localized component.

Then spread the result to a finite flat algebra over
`Q[A,u,h^{-1}]`, preferably with free basis `1,Z,...,Z^5` and coordinate
formulas

```text
B = NB/q_Z,
Y = NY/q_Z.
```

Clear denominators and record the exact algebra presentation used for later
colon and normalization computations.

## 6. Unit and common-open ledger

Compute exact nonzero norms or inverses in `K[Z]/(q)` for every inverted
factor.  At minimum audit

```text
B, ell, Q4, P_uu, C, delta, q_Z
```

and the selected factors of `G` if `G` is inverted.  Do not expand a giant
product merely to saturate.  Store each factor and its norm separately.

Choose one polynomial

```text
h(A,u) != 0
```

whose inversion simultaneously guarantees:

- `q` remains degree six and separable;
- the RUR coordinate formulas are defined;
- all accepted gates are units;
- the quotient is finite free of rank six;
- the exact ideal equality holds.

`COMMON_OPEN.md` must list every factor of `h`, its role, and the exact
certificate of nonvanishing.

## 7. Geometric conclusion

Let `S` be the chosen three-dimensional localized fold algebra.  The RUR
prime must define a finite degree-six scheme over the two-parameter base
`Spec Q[A,u,h^{-1}]`; therefore it is a two-dimensional height-one prime in
`Spec S`.

Prove that it is the **entire** codimension-one singular locus of `S` on this
open.  The ideal equality above is the preferred proof.  A dimension count
alone is not sufficient.

## 8. Required outputs

```text
COMMON_OPEN.md
RUR_EXHAUSTIVENESS.md
rur_exhaustiveness_payload.json
rur_basis.json
unit_norms.json
produce_mod101_upper_bound.py or exact wrapper
mod101_generic_upper_bound.sing
compact mod101 output summary
produce_border_certificate.py / .cpp / .m2 as appropriate
independent verify_rur_exhaustiveness.py
REPLAY.md
SEAL.json
STATUS.md
```

Do not commit large generated Macaulay matrices if they exceed repository
policy.  Commit a deterministic generator, hashes, dimensions, pivot indices,
and compact exact minors sufficient for replay.

## 9. Exits

```text
T3A-RUR-EXHAUSTIVE
T3A-RUR-NONEXHAUSTIVE
T3A-RUR-MODEL-REFUTED
T3A-UNDECIDED
```

`T3A-RUR-NONEXHAUSTIVE` requires an exact residual component or a certified
localized quotient dimension greater than six.  `T3A-UNDECIDED` must identify
the smallest missing pivot/border/saturation certificate and measured local
resource floor.
