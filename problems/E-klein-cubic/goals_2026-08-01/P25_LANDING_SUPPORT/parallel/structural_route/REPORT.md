# Structural route: exact complex audit and paired Stage-B cover

## Outcome

This packet gives one material exact reduction and two exact shortcut audits:

1. using the already certified closed stratum
   `L8=P<span(q4,...,q11)>`, Stage B on its complement is covered by **34**
   paired Reed--Solomon affine opens, rather than the `29*6=174` coordinate
   pairs;
2. the `M2=[I_690|T]` block is identified with a Steiner-type presentation
   whose transpose cokernel has exact Hilbert function `(21,87,0,...)`, but
   the standard Koszul and Eagon--Northcott/Buchsbaum--Rim shortcuts do not
   apply to the later `M1/M0` compatibility maps; and
3. the canonical systematic `21x21` pivot minor on every `D(q_i)`,
   `5<=i<=36`, is nonconstant and hence vanishes somewhere over the algebraic
   closure.  Thus the identity block does not provide a uniform chartwise
   polynomial left inverse.

This packet does **not** decide any of the 34 all-690 affine systems.  It does
not prove Stage B, Stage C, or P25 empty, and it constructs no landing point.

## 1. Binding tensor

Every structural calculation reconstructs the `M2` block from

```text
/Users/worker/unirational/problems/E-klein-cubic/certificates/degree25_finite_module/relation_matrix.npz
SHA256 6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb
```

No historical 842-row tensor is used.  No action of PSL on the 37 coefficient
coordinates is assumed.

## 2. Exact 34-open paired cover on `D(H8)`

Put

```text
H8=(q0,q1,q2,q3,q12,...,q36),  dim H8=29,
V(H8)=L8.
```

For the 34 distinct nodes `a=0,...,33` in `F_89`, define

```text
ell_a(q) = sum_{j=0}^{28} a^j q_{H8[j]},
m_a(b1)  = sum_{j=0}^{5}  a^j b1_j.
```

Over every extension of `F_89`, a nonzero polynomial of degree at most 28
vanishes at at most 28 of these nodes, so the q evaluation word has support at
least 6.  A nonzero polynomial of degree at most 5 gives a b1 word with
support at least 29.  Since

```text
6 + 29 = 35 > 34,
```

the supports intersect.  Consequently

```text
D(H8) x P5_b1
  = union_{a=0}^{33} (D(ell_a) x D(m_a)).
```

On chart `a`, normalize `ell_a(q)=m_a(b1)=1`.  Both forms have coefficient
one on `q0` and `b1_0`, so these two coordinates can be eliminated explicitly;
the direct Stage-B system still has the same 62 remaining variables and uses
all 690 seed equations.  A unit ideal on all 34 charts, together with the
existing exact closed-`L8` Stage-B certificate, would prove Stage B empty.

The number 34 is optimal **within this paired linear-code construction**.
For length `n`, Singleton bounds the two minimum supports by at most
`n-28` and `n-5`; guaranteed intersection requires their sum to exceed `n`,
hence `n>=34`.  This is not a claim about the minimum size of every possible
nonlinear affine cover.

Artifacts:

```text
stageB_H8_mds_cover.npz
stageB_H8_mds_cover.json
verify_mds_cover.py
verify_mds_cover_result.json
```

The independent replay ends

```text
PASS_INDEPENDENT_STAGEB_H8_MDS_COVER
```

Stage C has `b0=1`, so the differently twisted `b0` and `b1` coordinates are
not mixed.  This packet makes no paired Stage-C claim; the safe complement
cover remains 29 q-opens plus the exact closed-`L8` certificate.

## 3. Exact M2 complex

Transpose the linear M2 block to obtain

```text
S(-1)^690 -> S^21 -> C -> 0,
S=F_89[q0,...,q36].
```

The exact systematic coefficient matrix is `[I_690|T]`, with 87 free degree-
one coordinates.  The sealed degree-two multiplication map has rank

```text
rank(S_1 tensor F_89^690 -> S_2 tensor F_89^21)
  = 14763 = 21*dim S_2.
```

Multiplication then propagates surjectivity to every degree at least two.
Thus

```text
Hilbert(C) = 21 + 87*t,
reg(C) = 1,
sheaf(C) = 0 on P36.
```

This is the precise useful Steiner statement behind Stage A.  It also
explains the first Buchberger layer.  The 21 components have respectively

```text
5,5,5,4,...,4
```

standard degree-one coordinates, so their standard degree-two block has

```text
3*C(6,2) + 18*C(5,2) = 225
```

coordinates.  The verified pivot order produces

```text
3*C(32,2) + 18*C(33,2) = 10992
```

same-component first S-pairs.  Full rank of the 225-dimensional residual
block leaves exactly

```text
10992 - 225 = 10767
```

linear M2 syzygies, agreeing with the independently sealed full basis.  This
is a Schreyer/Steiner bookkeeping identity, not a resolution of the full
landing module: contracting those syzygies with M1 produces the still
undecided P3 compatibility tensor, and M0 adds Stage C.

The usual complexes do not finish the problem:

- the 690 linear relations are not a regular sequence, so a Koszul
  resolution is inapplicable;
- a generic `21 x 690` maximal-minor/Buchsbaum--Rim complex would require
  grade `690-21+1=670`, impossible in a 37-variable ring;
- the word “Steiner” records the exact projective surjection of M2 but imposes
  no automatic injectivity on the subsequent six-column M1 map or the M0
  extension.

No small regularity bound for Stage B or Stage C follows from M2 alone.

## 4. Why the systematic identity does not make charts uniform

For each `i=5,...,36`, the singleton columns give 21 rows whose M2 submatrix
has the form

```text
q_i I_21 + q0 A_i + q1 A_i1 + ... + q4 A_i4.
```

`audit_structure.py` reconstructs these rows from the sealed tensor.  Along
the exact line `q_i=1`, `q0=t`, all other q coordinates zero, it checks

```text
det(I_21) = 1,
det(I_21 + A_i) != 1
```

for every one of the 32 values of `i`.  Therefore each determinant polynomial
`det(I_21+t A_i)` is nonconstant and has a root over the algebraic closure.
The chosen systematic minor cannot remain invertible on all of `D(q_i)`.
Other rows keep M2 full rank by Stage A, but selecting them is a genuine
determinantal problem rather than a free consequence of `[I|T]`.

The exact tail has rank 87, 59,375 nonzero entries, and its support graph
couples every ordered pair of the 21 b2 coordinate components (between 123
and 165 terms per ordered pair).  This rules out a support-disjoint block
decomposition in the sealed coordinate bases.  It does not rule out an
unknown non-monomial simultaneous change of bases.

No full-tensor q-space automorphism, chart-transitive symmetry, or uniform
identification of the 34 MDS chart coefficient systems was reconstructed.
Accordingly the cover packet treats all 34 charts as distinct exact systems.

## 5. Replay and theorem boundary

From `goals_2026-08-01`:

```bash
/opt/homebrew/bin/python3 -u P25_LANDING_SUPPORT/parallel/structural_route/produce_mds_cover.py
/opt/homebrew/bin/python3 -u P25_LANDING_SUPPORT/parallel/structural_route/verify_mds_cover.py
/opt/homebrew/bin/python3 -u P25_LANDING_SUPPORT/parallel/structural_route/audit_structure.py
/opt/homebrew/bin/python3 -u P25_LANDING_SUPPORT/parallel/structural_route/verify_seal.py
```

Exact conclusions:

- Stage B on `D(H8)` has a valid 34-open paired all-690 cover;
- the M2-only cokernel and first Schreyer layer have the stated exact
  Hilbert/rank structure;
- the canonical systematic minors and coordinate-support decomposition do not
  yield a global shortcut.

Not concluded:

- unit ideal on any of the 34 Stage-B charts;
- Stage-B or Stage-C emptiness on `D(H8)`;
- lower-support or P25 emptiness;
- existence of a landing point.

Final marker for this packet:

```text
STRUCTURAL-ROUTE-EXACT-COVER-REDUCTION-NONVERDICT
```

