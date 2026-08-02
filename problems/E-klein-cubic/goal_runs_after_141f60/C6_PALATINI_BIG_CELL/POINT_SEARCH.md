# C6.2 — rational-point attack (residual update)

**Result:** exact constant points \(u\in D(\mathbf Q)\) with
\(\mathrm{rank}\,M(u)=4\) and reconstructed common lines over
\(\mathbf Q(\zeta_{11})\) were obtained.  They are **split-model** certificates.
No \(K_{\mathrm{proj}}\)-point of \(F_{14,T}\) and no headline bridge.

## Lane A — singular / linear / rank \(\le 3\) (exact / multi-prime)

Multi-prime sieve on the common rational fibre \(x=(1,2,3,4,5)\) at primes
331, 419, 463, 617 for height \(\le 2\):

- **no** multi-prime singular candidates;
- **no** multi-prime rank \(\le 3\) candidates;
- **no** full coordinate line or plane contained in \(D\);
- many smooth points of \(D(\mathbf Q)\) (height \(\le 1\): 12 multiprime
  hits, all certified exact).

Exact generic singular-locus GB remains a residual gate (linear charts preferred;
no dense char-0 GB was run).

## Lane B — coordinate / invariant slices

All coordinate \(\mathbf P^2\) slices were probed; many contain height-bounded
rational points of \(D\).  Restricted univariate line specializations were
factored over \(F_p\).  No slice produced a \(K_{\mathrm{proj}}\) Fano section.

## Lane C — multi-prime → exact

Bare CRT of modular seeds across unrelated \(x\)-fibres is invalid and was not
used.  Exact points came from the multi-prime rational sieve plus exact minor /
Plücker verification.  Secondary-basis reconstruction of the old modular seeds
was not obtained (consistent with C5 degree-16 exclusion).

## Lane D — residual after linear elim

On the rank-4 open, \(v\) is recovered by linear kernel / \(4\times 4\) minor charts;
the residual condition on \(u\) is the single quartic \(Q(u)=0\).  For each
certified exact \(u\), the reconstructed \(L\) satisfies the five Plücker
hyperplanes coefficientwise in \(x\).

## Peak resource (residual producer)

- wall \(\approx 11.38\) s
- peak RSS \(\approx 80.5\) MB
- msolve / Singular GB: **not invoked**

## Artifacts

- `residual_search.json` — lanes A–D residual ledger
- `exact_points.json` — certified points and Plücker data
- `POINT.md` — human-readable exact-point note (not headline)
