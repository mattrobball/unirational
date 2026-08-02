# Exact degree-16 matched-Fano exclusion

Date: 2026-08-01

## Result

The upstream exact finite-field run supplies a saved `msolve` leading basis
for the complete degree-16 homogeneous Fano-target covariant coefficient
space at characteristic `23`.  This packet does not copy the 500 KB basis.
It consumes the read-only upstream file

```text
../../goals_2026-08-01/
  C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/
  degree16_l44_leading.out
```

and pins its SHA256 as

```text
aa9958021e630be5ab19884a5b74520b492710bb7b32a4e6568b6ee435e113d2.
```

The filename's `l44` substring is historical.  The upstream status records
this as an exact 2,203-second `msolve` run; the producer workflow at this
small characteristic checks exact linear algebra option `2`.  The replay in
this packet checks the saved output, not the solver transcript or a fresh
Groebner computation.

## Independently checked certificate

The pinned ASCII output declares characteristic `23`, grevlex order, the
eighty variables `a0,...,a79` in that order, and `28,383` leading monomials.
The independent parser accepts only the canonical monomial syntax and obtains

```text
degree 2:   1,313
degree 3:  26,984
degree 4:      86
```

Every variable has a pure power in the leading ideal:

```text
a0^2,...,a49^2,
a50^3,...,a78^3,
a79^4.
```

Hence the leading ideal has irrelevant radical.  A second, sharper check
grows only standard monomials and gives the exact Hilbert function

```text
H(0),...,H(4) = [1,80,1927,86,0].
```

The zero in degree four proves that the saved homogeneous leading ideal, and
therefore the corresponding special-fibre ideal, has empty projective zero
locus.  In the accepted complete matched-covariant producer model, this
excludes a degree-16 homogeneous covariant landing in the Fano cone.

## Replay

From the Klein-cubic problem directory, run

```sh
/opt/homebrew/bin/python3 -u \
  goals_after_bd610a/C5_PROJECTOR_INCIDENCE/verify_degree16_fano_exclusion.py
```

The final marker is

```text
C5_DEGREE16_FANO_EXCLUSION_INDEPENDENTLY_VERIFIED
```

The verifier requires the pinned upstream basis at its declared relative
path.  `degree16_fano_exclusion.json` records the compact metadata and scope.

## Exact scope

Directly established here: the saved degree-16 leading ideal has empty
projective locus.  Combined with the previously accepted complete
lower-degree exclusions, this excludes homogeneous Fano-valued covariants
only through degree `16`.

It does **not** construct a `K_proj`-point, prove that the corrected incidence
has no `K_proj`-point, or give an all-degree obstruction.  The projective-map
reduction permits a primitive homogeneous representative of some degree but
provides no upper bound on that degree; degree `17` and above remain open at
this certificate's scope.
