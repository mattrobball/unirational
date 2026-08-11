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

M2 --script eckardt_klein.m2
M2 --script cone_surface_countermodel.m2
```

Each python script prints one `[ok  ]`/`[FAIL]` line per assertion and exits
nonzero on any failure. Expected terminal lines:

```
verify_conic_slice.py                    RESULT: PASS
verify_landing_identity.py               RESULT: PASS
verify_normal_surface_countermodel.py    RESULT: PASS
verify_slice_universality.py             RESULT: PASS
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
