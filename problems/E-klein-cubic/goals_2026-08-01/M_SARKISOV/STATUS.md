M-NEW-MORI-FIBRE-STRUCTURAL

# Goal M status

## Verdict

The generic Klein cubic twist over
\(K_0=\mathbf C(W)^G\) admits an exact type-I Sarkisov link

\[
 X_{\mathrm{gen}} \xleftarrow{\ \pi\ }
 Y=\operatorname{Bl}_{C}(X_{\mathrm{gen}})
 \xrightarrow{\ f\ } \mathbf P^1_{K_0},
\]

where \(C=X_{\mathrm{gen}}\cap\{a_3=a_4=0\}\) is a smooth plane
cubic and the generic fibre of \(f\) is a smooth cubic surface.  Thus Goal M
exits at its explicitly permitted structural target
`M-NEW-MORI-FIBRE-STRUCTURAL`.

This is **not** a positive or negative resolution of the Problem E headline.
A rational section of \(f\) would give a \(K_0\)-point of the generic twist
and hence a headline-positive result, but the packet neither constructs nor
rules out all sections.

## Exact scope

- base field: \(K_0=\mathbf C(W)^G\), the affine generic-torsor field;
- source: the genuine generic twist of the Klein cubic threefold;
- center: one explicitly descended geometrically smooth plane cubic;
- modification: blow up the pencil base curve;
- terminal model: smooth, hence terminal and \(\mathbf Q\)-factorial;
- endpoint: degree-3 del Pezzo Mori fibre space over \(\mathbf P^1_{K_0}\);
- relative Picard rank: \(\rho(Y/\mathbf P^1)=1\).

There is an arithmetic refinement inside the same link family.  The accepted
exact \(D_{12}\)-line certificate gives a transitive degree-55 finite scheme
of lines on the generic twist.  A \(K_0\)-plane can be chosen simultaneously
to cut a smooth cubic and avoid all 55 lines.  Projection turns those lines
into a closed point of degree 55 on the generic cubic-surface fibre.
Voisin's 2026 theorem gives the unconditional dichotomy

\[
 \text{rational section}\quad\text{or}\quad
 \text{degree-four multisection}.
\]

The second alternative is not a section.  This dichotomy does not decide the
Problem E headline.

## Deliberate proof boundaries

1. Split \(G\)-birational superrigidity is not descended to generic-twist
   rigidity.  Untwisting produces a semilinear, parameter-dependent map, not
   one fixed complex \(G\)-equivariant map.
2. The exceptional divisor is \(C\times\mathbf P^1\).  Closed points of
   \(C\) give multisections; only a \(K_0\)-point gives an exceptional
   section.  Other sections are not excluded.
3. The fibration appears only after blowing up the cubic twist; no fibration
   is asserted on the unmodified Picard-rank-one genus-8 Fano model.
4. `CENTRES.md` classifies only the standard smooth geometrically integral
   weak-Fano curve blowups.  No exhaustive singular/weighted/orbit-center
   rigidity theorem is claimed.
5. Index one of the generic cubic surface is not promoted to a point.  The
   only upgrade used is Voisin's cited section-or-degree-four theorem.

## Reproduction

From `goals_2026-08-01` run:

```sh
/opt/homebrew/bin/python3 M_SARKISOV/verify.py
```

The verifier checks sealed local artifacts, pinned upstream exact inputs,
the Hilbert--90 frame, the specialized plane and all projective smoothness
charts, the blowup intersection identities, and the degree-55 frontier.
