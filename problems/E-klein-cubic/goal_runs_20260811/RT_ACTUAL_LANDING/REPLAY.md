# Replay

Toolchain: Macaulay2 1.26.06, python3 3.14.6 with sympy 1.14.0. No GAP, Sage,
Magma or PARI is used or needed. All arithmetic is exact (over `Q` / `Z`); no
floating point anywhere.

Run from the repository root.

```
cd problems/E-klein-cubic/goal_runs_20260811/RT_ACTUAL_LANDING

python3 verify_conic_slice.py
python3 verify_landing_identity.py
python3 verify_normal_surface_countermodel.py
python3 verify_slice_universality.py

# round 4
python3 verify_forced_foliation.py
python3 verify_interpolation_scope.py
python3 verify_covariant_dimensions.py
python3 verify_d4_covariant.py
python3 verify_low_degree_covariants.py     # ~5 minutes

M2 --script eckardt_klein.m2
M2 --script cone_surface_countermodel.m2
M2 --script forced_foliation_witness.m2
```

Each python script prints one `[ok  ]`/`[FAIL]` line per assertion and exits
nonzero on any failure. Expected terminal lines:

```
verify_conic_slice.py                    RESULT: PASS
verify_landing_identity.py               RESULT: PASS
verify_normal_surface_countermodel.py    RESULT: PASS
verify_slice_universality.py             RESULT: PASS
verify_forced_foliation.py               RESULT: PASS
verify_interpolation_scope.py            RESULT: PASS
verify_covariant_dimensions.py           RESULT: PASS
verify_d4_covariant.py                   RESULT: PASS
verify_low_degree_covariants.py          RESULT: PASS
forced_foliation_witness.m2              RESULT: PASS
```

Runtimes on the reference machine: a few seconds each for the python scripts,
under a minute for each Macaulay2 script.

---

## 1. `verify_conic_slice.py` — the conic countermodel

Refutes the line-only slice normal form (`COUNTERMODEL_CONIC_SLICE.md`).
Assertions `C1`–`C6`: `F(P) = 0` identically; base ideal `(u,v)^2` with explicit
integral rewritings; primitivity; image is a smooth conic (two vanishing linear
forms, `det = -8`, unique quadric `x0^2 + x1x2 + x2^2` of rank 3); the `v=0`
slice `u^2·(1,-2,1,-2,0)` with the primitive value on `X`; degree 1 onto the
image.

Key printed output:

```
[ok  ] C1  F(P(u,v)) == 0 identically   F(P) = 0
[ok  ] C2  span of components = <u^2, uv, v^2> (rank 3)   rank = 3
[ok  ] C4b  the three plane-coordinate quadrics are independent (det != 0)   det = -8
conic equation in the plane {x4=0, x1=x3}: x0**2 + x1*x2 + x2**2
[ok  ] C4c'' the conic is SMOOTH (symmetric matrix has rank 3)   rank = 3, det = -1/4
[ok  ] C5''' F(1,-2,1,-2,0) == 0, i.e. the primitive value lies on X   F(p0) = 0
[ok  ] C7b (I1) H R_0 + 3 Phi(B,B,C) = f R_1 with R_1 = 8   3 Phi(B,B,C) = 8*v
[ok  ] C7c (I3) F(C) = H R_3 with R_3 = -8v   F(C) = -8*u**2*v
RESULT: PASS
```

Blocks `C7`–`C7d` (added with the round-3 port) check the exact landing-identity
data of the conic cell: `H = u^2`, `f = v`, `B = (1,-2,1,-2,0)`,
`C = (-v,-2v,-2u+v,-2v,0)`, and `R_0 = 0`, `R_1 = 8`, `R_3 = -8v`.

## 2. `verify_landing_identity.py` — the landing-identity system

Verifies the boxed system (`BOXED_GLOBAL_COVARIANT.md` Theorem 1.1).
Assertions `L0`–`L6e`: the polarization identity for the Klein `F` symbolically
in 10 variables; the cubic expansion of `F(HB+FC)` on exact random integer
5-tuples of forms; the pencil expansion of `F(B+tC)`; the four-way coefficient
match between `(11)` and `(10)`; `(10) ⟹ F(A) = 0`; `H^3 G(F/H) = F(A)`; the
Gauss's-lemma division step exercised exactly; and the specialization at `B = x`,
`R_0 = 1` to the sealed repository retraction identity, signs included.

Key printed output:

```
[ok  ] L3  t^1 coefficient of (11) is exactly equation 2 of (10)   coeff = -F*R1 + H*R0 + 3*PhiBBC, eqn = -F*R1 + H*R0 + 3*PhiBBC
[ok  ] L4  system (10) => F(HB+FC) == 0 identically   F(A) = 0
[ok  ] L6  (F - Ht)(1 + Rt - St^2) == (Ht - F)(St^2 - Rt - 1): ...
RESULT: PASS
```

The random instances are seeded (`random.seed(20260811)`), so the run is
deterministic and byte-reproducible.

## 3. `verify_normal_surface_countermodel.py` — refutation of "normal ⟹ `IH^1 = 0`"

Part A verifies the countermodel surface; Part B verifies a necessary condition
for Eckardt points on the Klein cubic. Key printed output:

```
[ok  ] A1  X' is a smooth cubic threefold (Jacobian ideal is irrelevant)
[ok  ] A2  the hyperplane section x4=0 is y0^3+y1^3+y2^3 (a cone with vertex [0:0:0:1])   S = {y0**3 + y1**3 + y2**3 = 0}
[ok  ] A3  the base plane cubic z0^3+z1^3+z2^3 is smooth ...
[ok  ] A4  Sing(S) = {y0=y1=y2=0} = the single point [0:0:0:1]
[ok  ] B1  rank(Hess F(p)) <= 2 ... that locus meets X = V(F) only at the origin (hence EMPTY in P^4)
RESULT: PASS
```

## 4. `eckardt_klein.m2` — the Klein cubic has no Eckardt points

Sets up the full Eckardt condition — `3Phi(p,v,v) = (1/2) v^T Hess F(p) v` is
divisible by the linear form `grad F(p)·v` — as `q - ell·lambda = 0` with an
auxiliary linear form `lambda = sum c_i v_i`, extracts the 15 coefficient
equations in the `v`'s, adds `F(p) = 0`, eliminates the `c_i`, and saturates
against the irrelevant ideal. Output:

```
Eckardt ideal on the Klein cubic:
ideal 1
is unit ideal (i.e. NO Eckardt points): true
```

This is the independent full-system computation; the python script checks only
the cheaper necessary condition `rank(Hess F(p)) ≤ 2`, which already comes out
empty.

## 5. `cone_surface_countermodel.m2` — the countermodel, independently

Groebner cross-check of Part A of script 3, in Macaulay2 rather than sympy.
Output:

```
singular locus of X' (should be unit ideal => X' smooth):
ideal 1
X' is smooth: true
X' is irreducible cubic: true
hyperplane section x_4=0 of X' :  y_0^3+y_1^3+y_2^3
singular locus of the surface S = {x_4=0} cap X' in P^3:
ideal (y_2^2, y_1^2, y_0^2)
S is irreducible and reduced: true
the base plane cubic z0^3+z1^3+z2^3 is smooth: true
```

`Sing(S)` has radical `(y_0,y_1,y_2)`, i.e. exactly the vertex `[0:0:0:1]`.

## 6. `verify_slice_universality.py` — the slice classification round

Verifies `SLICE_CLASSIFICATION.md` and the machine-checkable parts of
`REFUTATION_POINTED_CURVE_EXCLUSION.md`. **314 exact assertions**, runtime a few
minutes. Blocks:

* `S0` polarization conventions, the cubic pencil expansion, and
  `(10) => F(HB+fC) = 0`;
* `S1` the local normal form: row operations `B_0A_i - B_iA_0 = f(B_0C_i-B_iC_0)`,
  the Plücker relation `B_0M_{ij} = B_iM_{0j} - B_jM_{0i}`, gauge invariance of
  `A` and of `J`, and `I mod f = (H)`;
* `S2` the universality chain with free `b, Q`: the expansion of `F(t^e b + sQ)`
  for `e = 1..4`, and the two exact divisions (mod-`s`, then mod-`t^e`) that
  produce `R_1` and `R_3`;
* `S3/S4` the chain replayed on explicit pointed rational curves of the **Klein**
  cubic — a line, the conic, an irreducible plane rational cubic (constructed in
  the script by projecting a tangent-plane section from its singular point, and
  checked birational onto its image), multiple covers `A_e` for `e = 1..8`, and
  reparametrized conics — with `R_0 = 0` in every case, plus the
  excess-equals-degree check on the exceptional chart;
* `S5` the depth family `A_N` for `N = 1..12`: `F(A_N)=0`, `(t,s^N)` complete via
  its Newton polyhedron, the free chain of `N` points with excesses
  `(0,...,0,1)`, the degree-1 map on the last component, and the identities with
  all `R_i = 0`;
* `S6` the conic cell in the source's `(u,v)` naming, with `R_0=0, R_1=8,
  R_3=-8v`, and the cross-check that it *is* the `e=2` instance of `S2`.

Key printed output:

```
[ok  ] S1c  Pluecker: B_0 M_ij = B_i M_0j - B_j M_0i, ...
[ok  ] [conic e=2] (I1) H R_0 + 3 Phi(B,B,C) = f R_1 with R_1 = 8
[ok  ] [conic e=2] mod-t^e reduction: t^e | F(C); R_3 = -8*s
[ok  ] S3-cubic  the parametrization is birational onto its image ...   quotient = 1
[ok  ] S5d(N=12)  excesses are (0,...,0,1): rho = [0,0,0,0,0,0,0,0,0,0,0,1]
[ok  ] S6h  the conic cell is exactly the e=2 instance of the universality recipe ...
RESULT: PASS
```

---

## Round 4 scripts

### `forced_foliation_witness.m2` — the exact worked instance

Macaulay2, symbolic over `Q` throughout. Sections 0/0b/0c: smoothness of the
witness cubic and of the **actual Klein cubic**, and the Jacobian-ring Hilbert
function `(1,5,10,10,5,1,0,0,0)` for both, with the socle spanned by the
degree-five Hessian. Sections 1–8: the degree-7 Segre tuple `T` on a smooth
cubic threefold, and every identity of `THEOREM_FORCED_FOLIATION.md` —
`F(T)=0`, primitivity of `T` and of `Q_T`, the chain rule (5), `det J_T = 0`,
rank `4` at an exact point, `adj(J_T)` of degree `24`, exact division by `Q_T`
from **every** column with the same answer, `deg P_T = 10 = 2d-4`, (6), (8),
(10), Piola (11), and `div P_T = 0`. Runtime a few minutes.

Key printed output:

```
  Klein Jacobian ring Hilbert function, degrees 0..8: {1, 5, 10, 10, 5, 1, 0, 0, 0}
  ok   Klein: the degree-5 Hessian is not in the Jacobian ideal, ...
  ok   (6) adj(J_T) = P_T Q_T^t  (all 25 entries)
  ok   (7) deg P_T = 2d-4 = 10
  div P_T = 0
  ok   (12) div P_T = 0
  gcd of the components of P_T has degree 8
RESULT: PASS
```

The last line is the content of `ADJUDICATION.md` R36: the covariant has degree
`10`, the saturated foliation has degree `2`.

### `verify_forced_foliation.py` — the equivariant instance and the lemmas

46 exact sympy checks in five blocks. (A) the entire chain (5)–(12) on a
`mu_3`-**covariant** tuple landing on a conic that is only semi-invariant, so
that the character in (9) is nontrivial: `P(gx) = chi(g)^{-1} g P(x)` holds and
`P(gx) = g P(x)` fails. (B) `adj(gJg^{-1}) = g adj(J) g^{-1}` symbolically with
`det g = 13`, the rank-one adjugate, and Piola for generic maps. (C) the content
step: it is not removable, and it is only sufficient. (D) the `ch_2` defect
identity replayed symbolically in `d`. (E) an independent mod-`p` rank bound on
the Klein Jacobian ring.

### `verify_interpolation_scope.py` — the scope boundary

Exact `Fraction` rank computations. `d_0(Z) = m` for the order-`m` jet in `P^2`
and `P^4`; non-surjectivity for **every** `d` when `Z_d` is the order-`(d+1)`
jet, with deficiency `2,3,4,5,6,7,8`; the achievable values at a `G`-fixed point
are `W^{G_p}` in every degree `0..8`; and the Reynolds construction exhibited on
free orbits, where `d_0` rises from `1` to `3` as `Z` grows.

### `verify_covariant_dimensions.py` — the dimension table

Exact character arithmetic in `Q(zeta_330)` for the eight classes of
`PSL(2,11)` on `W`, giving `dim (Sym^k W^v)^G` and `dim (Sym^k W^v ⊗ W)^G` for
`k <= 24`, with an mpmath cross-check to 25 digits and internal consistency
checks (class sizes, character values, orthonormality, `I(3) = 1`, `C(1) = 1`).
The table was reproduced by a second, independently written implementation
before being recorded in `FOLIATION_REFORMULATION.md`.

### `verify_low_degree_covariants.py` — the table again, by explicit matrices

A third route, sharing no arithmetic with the character computation. Rebuilds
the representation from `sigma`, `tau = diag(z^{(-2)^i})` and the involution
`iota` **reused from the repository's own**
`goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/exact_schur_frame/exact_representation_core.py`
(whose `weil_generators()` second matrix is checked to equal `tau` exactly);
enumerates `|<sigma,tau,iota>| = 660`; checks `F` invariant under all three and
the generator traces against the five-dimensional character; then computes
`Cov_k` for `k <= 8` as the joint kernel of `rho_k(g) - Id` over `Q(zeta_11)`,
and its divergence-free subspace. Reproduces `1,0,0,2,1,2,4,5` and
`0,0,0,1,1,1,2,4`, and outputs the explicit `D_4` and `D_6`. Runtime about five
minutes; `d = 8` is the slow step (56s build, 146s kernel).

### `verify_d4_covariant.py` — the audit of `D_4`

Fast, and deliberately on a fourth arithmetic path: it hardcodes only the
claimed `D_4` and re-derives everything else, including `iota` from the
repository formula and `Q(zeta_11)` as `Q[z]/(z^11-1)` with
`1+z+...+z^10 = 0`. Checks homogeneity, primitivity, `div D_4 = 0`,
`sigma`-covariance by substitution, `tau`-covariance as a weight condition, and
`iota`-covariance — the last being the one that matters, since `iota` is what
cuts `Cov_4` from `7` to `2`. Controls: `iota^2 = 1`, `trace(iota) = 1`,
`F(iota x) = F(x)`, `div(F x) = 8F`.

---

## What is *not* machine-checked

The sheaf-theoretic content — the transfer morphism `Theta`, the `j`-inequalities,
the constant-quotient collapse, `IH^1(S) = H^1(S̃)`, and `IH^1(cone over E) =
H^1(E,Q) = Q^2` — is proved by hand in
`THEOREM_ACTUAL_TRANSFER.md` and `THEOREM_LEAKAGE_CLASSIFICATION.md`. The scripts
verify the algebraic-geometry inputs those proofs consume (that `X'` is smooth,
that `S` is a normal cone over a smooth plane cubic, that the conic is smooth,
that the landing identity holds), not the homological algebra.

The same applies to `REFUTATION_POINTED_CURVE_EXCLUSION.md`: the cohomological
content (`alpha_F` and `B_C` isomorphisms, weak Lefschetz, base change,
projection formula, integrality) is proved by hand there, and the only
machine-checked inputs are the Klein-specific ones — no Eckardt points
(`eckardt_klein.m2`), and the line-type slice form of the generic point of `D`
(`verify_slice_universality.py`, instance `[line e=1]`). One imported
input is flagged in `SOURCES.md` item 4 and `ADJUDICATION.md` item 2: the
object-level "weights ≤ 0" statement, taken from Saito's weight formalism, whose
cohomological shadow we verified against Weber's theorem.

## Round 5

```
cd problems/E-klein-cubic/goal_runs_20260811/RT_ACTUAL_LANDING
python3 verify_source_tangency.py      # RESULT: PASS   (192 checks, sympy/QQ)
python3 verify_d35_dimensions.py       # RESULT: PASS   (112 checks, exact)
M2 --script verify_source_tangency.m2  # RESULT: PASS   (Macaulay2, symbolic/QQ)
```

`verify_source_tangency.py` checks: the pointwise linear-algebra lemma behind
`Delta_T = Jac(T|_cone)` on exact integer data in dimensions `3,4,5,6`; six
exact landing instances on smooth quadrics with `(n,e)` giving residue weights
`w = 1, 2, 3`, common-factor degrees `k = 1,2,3` and restricted degrees
`d' = 1,2,3`; for each, `deg P_T`, `J_T P_T = 0`, `div P_T = 0`, Lemma A,
`T|_X = H B`, `F(B) = 0` on `X`, `deg j_phi = w(d'-1)`, the identity
`Delta_T|_X = (d/d') H^w j_phi`, **and** that both neighbouring exponents and
five alternative constants fail; the scaling lemma `Jac(h beta) =
((k+a)/a) h^w Jac(beta)` directly; the ramification reading of `j_phi` for the
power maps on `P^1 x P^1`; and the degenerate branch where the restricted map is
not dominant.

`verify_d35_dimensions.py` computes `I(k)`, `C(k)` and
`dim H^0(X,O_X(n))^G = I(n)-I(n-3)` by exact linear recurrences over `Z` and
`Z[(1+sqrt(-11))/2]` — an **independent implementation**, different in method
from `verify_covariant_dimensions.py`'s `Q(zeta_330)` route. It re-derives the
`2A/3A/5A/6A` eigenvalue multisets by enumeration against the character values
on all powers, re-derives `e_i` of the quadratic residues mod `11`, and checks
`charpoly(11A)·charpoly(11B) = 1+t+...+t^10`. It then reproduces the packet's
`k <= 24` table, the sealed sieve's `n <= 12` table, and confirms `254`,
`160,145,131,117,105`, the two `1`s at `d' = 4,5`, `C(66) = 6992`,
`I(65) = 1357`, `5635`, `19 266 655`, the `ch_1` cancellation, the
`-10(d-1)` codim-two coefficient, the `340` threshold, and that `2` is inert in
`Q(sqrt(-11))`.

`verify_source_tangency.m2` runs the whole chain on the packet's genuine
degree-`7` cubic-threefold witness and verifies Lemma A there, in the case
`(n,e) = (5,3)` that the repository actually needs. It also establishes that the
witness's restricted map is **primitive** (`H = 1`, `k = 0`, `d' = 7`), so its
`x_0^2 x_1^2` factor is doubled ramification and not a common factor.

For round 4 the corresponding boundary is: the interpolation theorem consumes
**Serre vanishing** (Hartshorne III.5.2) as a citation and is not re-proved;
the exactness of the global complex (16) is **not** re-proved and nothing
depends on it; and "dominance is automatic" is inherited from
`G3-DOMINANCE-AUTOMATIC`, whose own step 6 is an accepted external input
(`ed_C(G) >= 3`, Beauville). Everything else in round 4 — the whole chain
(4)–(13), the degree arithmetic, the socle statement, the `ch_2` identity and
the covariant dimensions — is machine-verified exactly.

For round 5 the boundary is: **dominance of the restricted selfmap** is taken
from `goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/THEOREM.md`, Theorem 1.1,
whose own accepted external input is `ed_C(G) >= 3`; the residue-form
formalism (`dF ^ eta = Omega`) and generic étaleness in characteristic zero are
used as standard facts; `Pic X = Z·H_X` and projective normality of the smooth
cubic threefold (used to write `D_X = div(H|_X)`) are standard and not
re-proved; and the sheaf `E_T` and the excess term `[Q_T]_2` of
`DEFECT_SMITH_CLASSIFICATION.md` §3 are **not** constructed — only the
Chern-class coefficient is exact there. The Smith-form classification is proved
by hand and is not machine-checked. No `H != 1` instance on a cubic threefold is
exhibited; the `H`-dependence is machine-checked on quadrics at the three
relevant weights, and Lemma A is machine-checked on the cubic threefold.
