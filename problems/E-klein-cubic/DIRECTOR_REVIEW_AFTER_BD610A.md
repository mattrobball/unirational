# Director review after `bd610a`

**Repository:** `mattrobball/unirational`  
**Reviewed state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`  
**Question:** `PSL_2(F_11)`-unirationality of the Klein cubic threefold  
**Headline verdict:** **OPEN**

This memorandum consumes the post-`35fa8f` dispatches and their published
returns.  It attempts every currently authorized promotion to a headline
conclusion before issuing the next worker portfolio.

## 1. What the latest returns actually establish

### Genuine positive progress

1. The canonical generic `A_4` twist has an exact rational point, obtained
   from a corrected degree-three projectively equivariant map.  The previous
   degree-one-through-four emptiness search is invalid because its covariance
   matrix was transposed incorrectly.
2. Both maximal `A_5` generic twists have exact rational points, obtained from
   separate degree-eleven Reynolds covariants and independently verified
   landing identities.
3. The Schur generic Klein twist admits an exact type-I Sarkisov link, after
   blowing up a smooth plane cubic, to a relative degree-three del Pezzo
   fibration over `P^1`.  The fibration has multisections of degrees `3` and
   `55`, hence index one, and the accepted theorem gives the alternative

   ```text
   rational section  OR  integral degree-four multisection.
   ```

4. The `11:5` generic twist has been reduced exactly to the genuine cyclic
   trace cubic

   ```text
   Tr_{E/K}(r_2^(-1) a^2 sigma(a)) = 0,
   ```

   over a rational four-parameter invariant field.  This is not an auxiliary
   model.
5. The literal plane-order-one covariant modules in degrees `31` and `35`,
   together with all landing cubics and the `C3/C6` linear gates, are now
   executable finite systems.

### Genuine negative information about routes

1. Pointlessness of the fixed-frame ternary cubic does not transfer to the
   generic Klein twist.  Its infinity valuation has a different ramification
   model from the genuine multiplicity-one target branch, and the fixed
   projector slice is not exhaustive in the full Fano/projector variety.
2. The unrestricted equivariant motive/Hodge invariant is too flexible:
   admissible blowup centres can reproduce the required summand.
3. The refined Prym/one-motive obstruction remains resolution-dependent;
   an equivariant resolution can be further refined by inserting the desired
   Prym-bearing centre.
4. The proposed KLS minimality-to-discrepancy reduction does not produce a
   nontrivial finite list.  In the literal landing problem the smooth-image
   case is exactly the original problem; in the broader rank-drop problem no
   proved theorem controls the conductor support.
5. Additive torsion-valued stack invariants with restriction/corestriction
   split prime by prime and are killed by the Sylow fixed-point data.  Any
   successor invariant must be genuinely nonadditive and stable under the
   actual base-locus blowups and arbitrary multisection degrees.
6. The linear quotient `K1/R_+K1` is not a primitive-covariant quotient.
   Exact Bezout witnesses show that sums of factorable directions can have
   component gcd one.  Therefore the degree-35 zero linear quotient is not a
   degree-wide emptiness theorem.

## 2. Attempted headline promotions

The accepted headline bridges are those in `WORKORDER_CAS_HEADLINE.md`.
Every currently plausible promotion fails at a precise hypothesis.

### 2.1 Positive promotion from the `A_4` and `A_5` points

The subgroup points close the corresponding subgroup point obstructions.
They do not construct a dominant `G`-equivariant map to the threefold.  The
published `A_5` maps have two-dimensional image.

For a maximal `A_5`, reduction of a generic `G`-torsor produces a degree-eleven
closed point on the full twist once the specialization/descent bridge is made
explicit.  However, there is no accepted odd-degree descent theorem turning a
degree-eleven point on a cubic threefold into a rational point.  Index one is
not sufficient.  Consequently the `A_5` returns cannot be promoted.

### 2.2 Positive promotion from the Sarkisov link

A rational section of the degree-three del Pezzo fibration would give a
rational curve on the generic twist and close the headline positively.  The
current packet does not select the section branch.  A degree-four
multisection, even together with the degree-three and degree-fifty-five
multisections, proves only index one and cannot be promoted to a section.

### 2.3 Negative promotion from the fixed-frame cubic

The exact fixed-frame cubic is pointless, but it is an auxiliary ternary
slice.  The successful infinity valuation is not the genuine target-branch
valuation, and a point of the full projector/Fano scheme need not lie in the
fixed slice.  The bridge required by `BR-T-NEG` or `BR-FANO-POS` is absent.

### 2.4 Negative promotion from the target branch

The target branch has residue degree one and smooth generic residual cubic;
the residual cubic over the base has index three.  Ordinary Picard theory is
complete.  The sole remaining escape is the horizontal three-primary part of

```text
Cl(T_D) / Pic(T_D)
```

after normalization.  Neither its vanishing nor a dangerous class has been
proved.  The exact slice critical curve shows that isolated-node heuristics
are invalid, so no local normality shortcut is available.

### 2.5 Negative promotion from the `11:5` twist

A pointless generic `11:5` twist would close the full headline negatively by
restriction.  The exact trace model is now sufficiently small to attack, but
no pointlessness theorem is present.  Conversely, a rational point would
retire only this subgroup obstruction.

### 2.6 Positive promotion from finite-degree covariant work

No exact primitive landing self-covariant of generic Jacobian rank four has
been constructed.  Degree `25` still requires the enlarged transition-stable
presentation and projective support decision.  Degrees `31` and `35` still
require saturation of their based and nonbased `C3/C6` charts and are coupled
to degree `25` by invariant multiplication.

## 3. Headline conclusion

No positive or negative headline follows from the published returns.  The
problem remains open at `bd610a`.

This is not a lack of progress.  The latest round has removed several false
bridges, replaced the important subgroup twists by exact equations, and
reduced the strongest positive Fano route to one explicit projector-incidence
scheme.

## 4. Ranked next paths

### Rank 1 — direct full projector incidence (`C5`)

Avoid making the quaternion Morita model a prerequisite.  In the exact lazy
algebra with involution, a common isotropic right line is represented directly
by a self-adjoint reduced-rank-two idempotent `e` satisfying

```text
e^2=e,  sigma(e)=e,  Trd(e)=2,  e S_i e=0  for i=1,...,5.
```

All ingredients except the final full incidence solve are already available.
An exact point executes `BR-FANO-POS` and closes the headline positively.

### Rank 2 — genuine `11:5` trace cubic (`H5`)

This is the smallest exact genuine twist left.  It supports both a constructive
three-or-more-term search and toric/valuation attempts at pointlessness.
Pointlessness executes `BR-SUBGROUP-NEG` immediately.

### Rank 3 — normalized target branch modulo three (`T3`)

This remains the strongest developed negative route.  The needed facts are
finite and local: dominant singular components, exact integral bases,
discriminant contact orders modulo three, and the residual codimension-three
punctured Picard groups.

### Rank 4 — select the Sarkisov alternative (`M3`)

Use the exact del Pezzo fibration to search for a section in Cox coordinates,
then certify the corresponding rational curve.  A section is a direct
positive headline.  If only degree-four multisections exist in the searched
components, record their exact geometry without promoting index one.

### Rank 5 — transition-stable covariant support (`P25/COV`)

Rebuild degree `25` using the enlarged transition-stable module and decide its
Fitting support.  Then consume the already reduced degree `31/35` systems.
Any exact survivor must be lifted to characteristic zero, made primitive, and
checked for Jacobian rank four.

### Rank 6 — `A_5` degree-eleven quartic rescue (`A5Q`)

First install the degree-eleven closed point on the full generic twist.  Then
test whether it lies on a descended rational normal quartic in the ambient
`P^4`.  Such a quartic meets the cubic in degree twelve, so a scheme-theoretic
length-eleven intersection would leave a rational residual point.  This is a
high-risk but finite new positive route.

## 5. Routes not to redispatch unchanged

Do not spend another round on:

- a fixed-frame valuation without an exact identification with a genuine
  versal divisor;
- unrestricted additive motive, Hodge, or Mackey-valued invariants;
- resolution-dependent centre Pryms or one-motives;
- KLS conductor enumeration without a new representation-specific theorem;
- bounded degree ladders presented as all-degree evidence;
- the invalid `A_4` covariance convention;
- characteristic-zero emptiness certified only by `msolve`;
- the dead `(P_B,P_Y,P_Z)` target-branch chart with the old gate set;
- raw expansion of the compressed algebra when the lazy multiplication oracle
  suffices.

The next portfolio is indexed in `goals_after_bd610a/README.md`.