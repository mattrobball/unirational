M3-SECTION-COMPONENT-PASS

# Goal M3 status

## Verdict

The residual-Galois and light section-scheme subroutes are finished at their
honest theorem boundary, but the section-versus-integral-quartic alternative
is **not selected**.

Proved:

1. exceptional sections are exactly the points of the center cubic
   \(C_{012}\);
2. nonexceptional sections of \(H\)-degree one and two are impossible by the
   binding no-line and no-conic theorems;
3. the first nonexceptional degree-three section scheme has a horizontal
   projective four-dimensional geometric component, certified by standard-
   smooth points modulo 23 and 67;
4. the 55-line splitting field has Galois group
   \(\operatorname{PSL}_2(\mathbf F_{11})\) and contains no quartic subfield;
5. all six pair orbits of the 55 horizontal line sections have non-singleton
   fibrewise-secant images, with minimum image cardinality 55 at both split
   primes.

Not proved:

```text
Y/P1 has a K-rational section                 NOT PROVED
Y/P1 has no K-rational section                NOT PROVED
an integral degree-four multisection is explicit  NOT PROVED
integral degree-four locus is empty           NOT PROVED
```

Thus the Klein-cubic headline remains **OPEN**.

## Smallest remaining gates

The lowest section gate is \(C_{012}(K)\).  After that, the first
nonexceptional gate is a \(K\)-point of the degree-three section component;
higher degrees remain possible.  If all section components are pointless,
the accepted cubic-surface theorem supplies an integral quartic over a new
extension not contained in the 55-line field.

## Repository state consumed

- pinned M3 state: `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`;
- exact M2 Sarkisov packet under
  `goal_runs_after_35fa/M_SARKISOV/`;
- exact Schur frame under
  `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/exact_schur_frame/`;
- binding no-line/no-conic statements in `SPEC.md` and the rational-curve
  structural packet;
- live head audited before production: `b49fc8148ca3ad8a23b959c140d68e7544fc8031`.
