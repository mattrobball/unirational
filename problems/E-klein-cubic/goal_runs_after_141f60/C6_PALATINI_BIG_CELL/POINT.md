# C6 residual — exact points of \(D\) (split model)

**Not a headline claim.**  No `K_proj`-point of \(F_{14,T}\) is asserted.
Primary packet exit remains `C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS`.

## Exact points of \(D=V(Q)\)

The following constant vectors \(u\in\mathbf P^5(\mathbf Q)\) satisfy
\(\mathrm{rank}\,M(u)=4\) and \(m(u)=0\) (equivalently \(Q(u)=0\)) at every
tested exact fibre \(x\), by direct evaluation of the five-form matrix over
\(\mathbf Q(\zeta_{11})\):

- `u = [1, -1, -1, -1, 1, -1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, -1, -1, 1, -1, 1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, -1, 1, -1, -1, 1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, -1, 1, 1, -1, -1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, -1, 1, 1, 1, -1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, -1, 1, 1, 1, 1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, 1, -1, -1, -1, -1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, 1, -1, -1, 1, 1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, 1, -1, 1, -1, -1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, 1, -1, 1, 1, -1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, 1, 1, -1, -1, 1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)
- `u = [1, 1, 1, -1, 1, 1]` with L over `Q(zeta_11)` (Plücker hyperplanes identically zero: True)

Full certificates (kernel bases, normalized Plücker coordinates as length-10
\(\mathbf Q\)-vectors for the cyclotomic basis \(1,\zeta,\ldots,\zeta^9\)) are in
`exact_points.json`.

## Reconstructed common lines

For each such \(u\), linear kernel charts give
\(L=\mathbf P(\ker M(u))\) with Plücker coordinates in
\(\mathbf Q(\zeta_{11})\), independent of \(x\).  Independently:

1. all five sealed generic Plücker hyperplanes vanish on \(L\)
   **coefficientwise as polynomials in \(x\)** (not merely at sample fibres);
2. all fifteen Grassmann–Plücker quadrics vanish;
3. all five alternating pairings \(\omega_i\) vanish on a kernel basis.

Galois conjugates of the Plücker coordinates are nontrivial, so \(L\) is **not**
defined over \(\mathbf Q\).  It is a point of the **split** five-form Fano model
over \(\mathbf Q(\zeta_{11})\), not a verified \(K_{\mathrm{proj}}\)-point of the
twisted form \(F_{14,T}\).

## Morita / \(K_{\mathrm{proj}}\) descent (see `phase_morita_descent/`)

Independently certified residual:

- every line has Gal-orbit size 2 over \(\mathbf Q(\zeta_{11})/\mathbf Q\) and
  Plücker coordinates in \(\mathbf Q(\sqrt{-11})\);
- constant sections fail twisted Plücker \(G\)-equivariance:
  \(\dim(\wedge^2 V)^G=0\) at \(p=23\);
- no new height-bounded \(D\)-point over \(\mathbf Q(\sqrt{-11})\) beyond
  projectively rational ones.

Marker: `C6-MORITA-DESCENT-OBSTRUCTION`.  Still **not** a \(K_{\mathrm{proj}}\)
Fano point.

## Positive-degree residual (see `phase_positive_degree/`)

Bounded non-constant ansätze for sections of \(D\) and Morita-linear words were
run and sealed as `C6-POSITIVE-DEGREE-RESIDUAL` (no constructive \(K_{\mathrm{proj}}\)
Fano point within the named degree/support bounds).  Not an emptiness claim for
all of \(D(K_{\mathrm{proj}})\).

## What is still residual

- Higher-degree / larger-support positive-degree sections beyond the sealed bounds;
- Pfaffian–Klein bridge and G3A dominance for a true \(K_{\mathrm{proj}}\) Fano point;
- scheme-theoretic singular locus and rank \(\le 3\) primary decomposition over
  \(K_{\mathrm{proj}}\).

## Marker

```text
C6-EXACT-SPLIT-POINTS-PASS
```

Headline remains **OPEN**.  Do not treat this file as `BRIDGE_FANO_POS.md`.
