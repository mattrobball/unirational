# S0 bridge audit and binding incompatibility

## Verdict

The upstream residual-degree-two implication is valid only for an ambient
curve meeting the cubic properly.  The exact target in the dispatched goal
instead puts the curve inside the cubic.  Those requirements cannot be
satisfied simultaneously, so the positive bridge has no input object under
the literal goal contract.

## Coherent positive bridge

Let `F=K_Schur`, let `X_T` be the generic Schur twist in its twisted
projective ambient space, let `M` be the descended hyperplane, and let `Z` be
the certified degree-55 closed point.  The audited bridge has the following
arrows.

1. An `F`-defined pure degree-19 curve `B` in `M`, with no component contained
   in `X_T`, meets the cubic properly in degree `3*19=57`.
2. If `Z` occurs with local intersection multiplicity one at each of its 55
   geometric points, the scheme-theoretic residual is an effective
   `F`-zero-cycle of degree `57-55=2` on `X_T`.
3. If that cycle already has `F`-support, it gives an `F`-point.  Otherwise it
   is a quadratic closed point; its conjugate geometric points span an
   `F`-line.  The accepted no-`F`-line theorem says that line is not contained
   in `X_T`, so its third intersection with the cubic is an `F`-point.
4. The accepted Schur projective-source and quadratic-descent comparison turns
   an `F`-point of the generic Schur twist into the positive Klein-cubic
   headline.

All cycles and joining lines in these arrows are formed over `F`; no split
marked point or residue-field cycle is promoted to an `F`-object.

## The missing hypothesis is explicit upstream

The audited definition requires:

- Q3: no irreducible component of the ambient curve lies in `X_T`;
- Q4: its intersection with `X_T` is zero-dimensional.

These are not optional regularity conditions.  They are the hypotheses that
make hypersurface Bezout and residual subtraction applicable.

## Literal target versus bridge input

The dispatched exact target says `C subset X_F cap M`.  For closed subschemes,

```text
C subset X_F
  iff (f3) subset I_C
  iff f3 belongs to I_C.
```

Consequently

```text
I_(C cap X_F) = I_C + (f3) = I_C,
C cap X_F = C,
dim(C cap X_F) = 1.
```

There is no proper zero-dimensional intersection cycle of degree 57 and hence
no residual degree-two cycle or residual line.  This also violates Q3 directly:
geometric integrality gives one component and containment puts it in `X_F`.

## Minimal repair of the work order

The coherent exact target is an ambient rescue curve:

```text
C subset M
no geometric component of C is contained in X_F
Z subset C cap X_F with local intersection multiplicity one
```

That repaired problem is the one described by the upstream Gate 1 audit.  It
remains open because the `epsilon=0` and `epsilon=1` marked Hilbert strata have
not been proved empty or supplied with an `F`-point.  This packet does not
silently substitute that repaired, open target for the contradictory binding
target.
