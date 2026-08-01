# Resolvent-incidence generality audit

## Exact generic theorem

For the split Klein cubic, `probe_dominance.py` gives one rational full-span
quartet on a smooth hyperplane section and computes, over `QQ`, differential
ranks

```text
quartet -> three resolvent points:                 9
quartet -> (spanning hyperplane, resolvent triple): 10
quartet on the fixed smooth section -> triple:      6
```

These are the dimensions of the corresponding targets.  Hence the resolvent
map is dominant, jointly with the spanning hyperplane and after restriction
to a general smooth cubic-surface section.  Combined with the smooth,
irreducible six-dimensional twisted-cubic locus and Zinger's enumerative
count eight, this shows that a general quartet has a resolvent triple in the
dense open where the three-point incidence is finite, reduced, and transverse.

The script also verifies the chosen hyperplane section is smooth in all four
affine charts and checks all secant and residual incidences exactly.

## Why this does not apply to the installed quartic

Voisin's proof does not select a general representative of the resulting
degree-four cycle.  In Proposition 3.2 the given subscheme is replaced by
the generic point of a Hilbert scheme; the construction is then returned to
the original field by Fulton specialization of a `CH_0` class.  This preserves
effectivity, but it does not preserve avoidance of a chosen closed locus,
integrality, reducedness, or transversality.  Example 3.5 explicitly records
the difficulty for nongeneric subschemes.

Therefore the exact dominance theorem does not prove that the particular
quartic supplied on the generic Schur surface has a good resolvent triple.
Even a good triple would leave the independent incidence splitting-field gap
recorded in `parallel/incidence_splitting/`.

Primary theorem inputs are Harris--Roth--Starr, Theorem 4.4,
<https://arxiv.org/abs/math/0202067>; Zinger, p. 1058,
<https://msp.org/gt/2014/18-2/gt-v18-n2-p12-s.pdf>; and Voisin,
Proposition 3.2 and Example 3.5, <https://arxiv.org/abs/2509.17996>.

Verdict: `Q-UNDECIDED`.

```text
Q_SCHUR_RESOLVENT_DOMINANCE_EXACT
```
