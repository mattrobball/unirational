# G5.2 — residue point search and decision boundary

## Verdict on points

| site | residue point | pointlessness |
|---|---|---|
| `f5` | **UNDECIDED** | **NOT PROVED** |
| `f6` | **UNDECIDED** | **NOT PROVED** |

No `POINT.md`, no `POINTLESSNESS.md`, and no `BRIDGE_RESIDUE_NEG.md` is issued.
A residue point would be **local solubility only** and must not be promoted to
a global \(X_{\mathrm{gen}}(K_{\mathrm{proj}})\) point.  A pointless smooth
residue cubic would be a negative headline candidate only after the G5.3
bridge; that bridge is not entered.

Machine ledger: `point_search.json`.

## Lane A — rational point attempts

### Constant coordinates

All projective representatives with coordinates in \(\{-2,\ldots,2\}\) were
tested by evaluating \(\Phi(a)\) in the free Hironaka module after killing
\(f_i\).  A hit would mean \(\Phi(a)\) is identically zero in \(R/(f_i)\).

Result: **no hits** at either site.

### Coordinate lines

For each of the ten coordinate lines \(\operatorname{span}(e_i,e_j)\), the
restriction of the residue cubic is a collection of binary cubics, one per
free-module component.  Their gcd is a unit (total degree \(0\)) at every
line and both sites.  Hence **no coordinate-line rational point** over the
residue field (not even over an algebraic closure of the coefficient field of
those binary forms).

### Coordinate planes

Small-integer searches on the ten coordinate planes similarly produced no
constant points (producer diagnostic; not re-sealed as a complete plane
classification).

### Modular specializations (discovery only)

Specializing residual primaries and secondary generators to random
\(\mathbf F_{67}\) values always produced smooth points of the specialized
cubic (40/40 trials at each site).  The same holds at \(p=23\) and \(p=11\).

**Interpretation.** Finite-field fibres of a cubic threefold are expected to
have points.  This does **not** construct a point over the generic residue
field \(\kappa_i\) of transcendence degree three, and it is **not** used as an
exit.

### Hessian-kernel line at `f5` (upstream)

The V tropical packet excludes the canonical Hessian-kernel line on the
source base change of the `f5` residue twist.  That exclusion is retained as
a one-line probe only; it is not full residue pointlessness.

### Degree-16 support \(\le5\) (retired bounded fact)

`V-F5-DEGREE16-SUPPORT-LE5-EMPTY` excludes sparse degree-16 homogeneous
landings.  It is **not** evidence that the full five-coordinate residue cubic
is pointless, and it is not used as a negative exit here.

## Lane B — exact pointlessness

No authorized obstruction was completed:

- no complete anisotropic fibration invariant;
- no point-dependent torsor beyond Q2.1;
- no exact specialization to a known pointless smooth cubic;
- no complete classification of \(\kappa_i\)-points;
- no second unramified valuation with a terminal residue proved pointless
  under the V3 fences (ramified / \(C_1\) / rank\(\ge3\) branches are soluble
  and cannot terminate a negative tree).

## Lane C — recursive boundary

Not launched as a sealed tree.  Any future Parshin / Abhyankar recursion must
stop when V3 forces solubility and must not treat a finite tropical tree
without final anisotropy as a decision.

## Residual gates (named)

1. Produce an exact \(\kappa_5\)-point of \(\overline X_{f_5}\), or prove
   pointlessness by an authorized Lane-B method.
2. Same for \(\kappa_6\).
3. Only after a proved pointless smooth residue cubic: run G5.3
   (`BRIDGE_RESIDUE_NEG.md`) for a headline-negative candidate.

## Hard non-evidence (honoured)

Finite-degree empty searches, empty fixed frames, index one alone, modular
emptiness without transfer, V3-soluble branches, tropical value-group
arguments, and `f5` support-\(\le5\) emptiness are **not** used as negatives.
