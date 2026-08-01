# Degree-12 projective-source attack

## Exact coefficient model

The audited degree-12 Schur-source covariant space over the split good prime
23 has the deterministic decomposition

\[
M_{12}=D_{12}\oplus P_{12},\qquad
\dim D_{12}=16,\quad\dim P_{12}=32.
\]

`D_12` is the multiplication span
`R4*M8 + R6*M6 + R8*M4`; `P_12` is the deterministic Reynolds complement
reconstructed by the upstream `primitive_one_slices.py`.  The scripts here
reconstruct that basis and compare fast symmetric-tensor contraction with the
independent sparse cubic expansion.

## Pure primitive block

`degree12_primitive_block.py` evaluates 700 genuine source points, stores the
700 by 5,984 coefficient matrix, and computes its exact row rank with FFPACK:

```text
rank over F_23 = 669
rows SHA-256 = 2d001b002bf6118a608d0558fee0c5050d55ef6a2b117d64c063bc0c9948760a
solver-input SHA-256 = adb4261fbcf4c9c0f81b01cf3c34a2b27b732d12303efa4a7b7faf1b8ca47abe
```

Two exact msolve configurations were bounded:

| maximum pairs | bound | exact progress | verdict |
|---:|---:|---|---|
| 2000 | 600 s | degree 4 complete; first `56328 x 182002` degree-5 matrix begun | timeout |
| 512 | 900 s | degree 4 complete; three degree-5 batches complete | timeout |

A timeout proves neither emptiness nor nonemptiness.  In particular, no pure
primitive exclusion is claimed.

## Three-direction slices

The upstream certificate already proves `D_12` plus any zero, one, or two
chosen primitive basis vectors empty.  `degree12_triple_slices.py` constructs
the first untested 19-variable slices directly.  Fifteen slices were solved:
indices `0..4`, `1000..1004`, and `4955..4959`.  Every one has exact equation
rank 669 and empty projective Hilbert function

```text
[1, 19, 190, 661, 0].
```

This is a sampled coordinate-triple set, not all 4,960 triples.

## Nested support

`degree12_nested_slices.py` solves the initial nested primitive supports.  The
exact results are:

| primitive count | coefficient dimension | Hilbert function | seconds | verdict |
|---:|---:|---|---:|---|
| 4 | 20 | `[1,20,210,871,0]` | 21.49 | empty |
| 5 | 21 | `[1,21,231,1102,0]` | 75.25 | empty |
| 6 | 22 | `[1,22,253,1355,0]` | 220.63 | empty |
| 7 | 23 | `[1,23,276,1631,0]` | 581.64 | empty |

The `k=7` leading-ideal SHA-256 is
`0472d0c3add1f7dd92fde3b5525057bae6d54252ebfcb9da6a6f3bed51585754`.

## Proof boundary

Every empty slice is a rigorous special-fibre exclusion because its equations
are necessary landing equations.  None of the results covers:

- the full 48-dimensional degree-12 coefficient space;
- every coordinate support of size three or larger;
- a change of primitive complement basis;
- any degree above 12;
- pointlessness of the generic Schur twist.

A positive result still requires a nonzero coefficient vector, verification
against the complete 1,124-row special-fibre equation basis, lifting or
reconstruction in characteristic zero, and substitution in the original
Klein cubic identity.
