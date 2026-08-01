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

where \(C=X_{\mathrm{gen}}\cap\{a_3=a_4=0\}\) is a smooth plane cubic and
the generic fibre of \(f\) is a smooth cubic surface.  Thus Goal M exits at
the explicitly permitted structural target `M-NEW-MORI-FIBRE-STRUCTURAL`.

This is **not** a positive or negative resolution of the Problem E headline.
A rational section of \(f\) would give a \(K_0\)-point of
\(X_{\mathrm{gen}}\), hence a headline-positive result, but the packet neither
constructs nor rules out all sections.  In particular, it never substitutes
a multisection for a section.

## Exact scope

- base field: \(K_0=\mathbf C(W)^G\);
- source: the generic twist of the Klein cubic threefold;
- center: one explicitly descended, geometrically smooth plane cubic;
- link: blow up the base curve of the descended hyperplane pencil and project
  to that pencil;
- terminal model: smooth, hence terminal and \(\mathbf Q\)-factorial;
- endpoint: degree-3 del Pezzo Mori fibre space over \(\mathbf P^1_{K_0}\);
- relative Picard rank: \(\rho(Y/\mathbf P^1)=1\).
- generic-fibre index: certified to divide \(3\); equality to one is not
  asserted.

## Deliberate proof boundaries

1. Split \(G\)-birational superrigidity is not descended to a rigidity
   assertion for the generic twist.  Untwisting a generic-twist map gives a
   semilinear, parameter-dependent map, not automatically one fixed complex
   \(G\)-equivariant map.
2. The exceptional divisor is \(C\times\mathbf P^1\).  It gives
   multisections whose degrees are degrees of closed points of \(C\); it gives
   a section exactly when \(C(K_0)\ne\varnothing\).  Other sections are not
   excluded.
3. The unmodified index-one Fano threefold of genus 8 still has no direct Mori
   fibration.  The fibration here appears only after blowing up a center on
   the cubic twist.
4. The classical center table in `CENTRES.md` is a census for smooth
   geometrically integral curve blowups with weak-Fano anticanonical model;
   it is not advertised as an exhaustive classification of all singular,
   weighted, orbit, or higher-rank Sarkisov extractions.
5. `COMPLETION_AUDIT.md` records the requirement-by-requirement scope of the
   structural exit; incomplete headline work is not relabeled complete.

## Reproduction

From `goals_2026-08-01` run:

```sh
/opt/homebrew/bin/python3 M_SARKISOV_CODEX_ROOT_20260801/verify.py
```

The verifier checks the sealed local artifacts, pinned upstream exact inputs,
the full Hilbert--90 frame certificate, the specialized plane equation and
smoothness in all projective charts, and every displayed intersection/cone
identity.

## Repository state

- live repository HEAD consumed: `2140419410cfff2f7d7dcca166acef8c16a0d41b`;
- pinned Problem E mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`;
- produced artifact state: uncommitted worktree under
  `M_SARKISOV_CODEX_ROOT_20260801/`;
- no commit was created; the final packet does not consume or seal the
  concurrently owned `M_SARKISOV/` directory.
