# Characteristic-five two-residue progression status

**Date:** 2026-08-08  
**Headline:** `OPEN`  
**Exact bounded result:** `F55-CHAR5-TWO-RESIDUE-EMPTY-THROUGH-45`

For every one of the sixteen progression families

\[
 f=x^{a_d}H^5+x^{b_{d,r}}K^5,
 \qquad d,r\in\mathbf F_5^*,
\]

the full Klein landing identity has no solution with nonzero equal-degree
roots `H,K` in root degrees one through seven.  Equivalently, the branch has
no landing coordinate through covariant degree `10+5*7=45`.

Root degrees one through four are covered by exact coefficient-ideal chart
computations.  Root degrees five and six are covered by exact Boolean-support
exhaustion.  Root degree seven is covered by the sealed, dependency-free
static certificate in `N7_STATIC_CERTIFICATE/`; its strict replay checks
141,092 nodes and 70,554 conflicts and ends with

```text
F55-CHAR5-DEGREE45-SUPPORT-UNSAT-CERTIFICATE-OK
```

The root-degree-eight CaDiCaL run in `N8_PREFLIGHT/` returned UNSAT for all
sixteen reconstructed support CNFs, but it has no checked proof object.  Its
status is therefore `UNSAT_PREFLIGHT_ONLY`, and covariant degree fifty is not
part of the theorem.

No degree-independent peeling lemma is presently available.  The auxiliary
212-row degree-seven core contains no complete cyclic row orbit and yields no
stable finite template under degree increase.  Multiplication by the cyclic
invariant `Q=x_0x_1x_2x_3x_4` propagates an existing landing upward by five
root degrees; descending would require a new theorem forcing `Q` to divide
both roots.  Coordinate-boundary valuations alone do not force that.

Root degree at least eight, all supports with three or more Frobenius
residues, the full characteristic-five dominance problem, and the
characteristic-zero non-`PSL(2,11)`-unirationality headline remain open.
