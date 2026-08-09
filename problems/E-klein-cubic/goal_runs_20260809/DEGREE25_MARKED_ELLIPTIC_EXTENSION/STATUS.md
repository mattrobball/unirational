# Degree-25 marked-elliptic extension — status

**Parent repository state:** `091d4f5d4314c556da96d1804c49be13f48a78c8` (`main`, 2026-08-09)  
**Decision:** `DEGREE25-BOUNDARY-EXTENSION-OBSTRUCTED`  
**Global Klein-cubic headline:** **OPEN**

## Verdict

The proposed componentwise map is geometrically real:

\[
\lambda_D|_{E_t}=[-5],\qquad \lambda_D|_{L_t}=\operatorname{id}.
\]

It is intrinsic, globally \(G\)-equivariant, and glues scheme-theoretically on
the complete reduced fixed-curve network \(D\).

It does **not** extend to the requested homogeneous degree-25 landing
covariant. There are two exact obstructions, in increasing strength.

1. **Literal morphism/polarization obstruction.** If one homogeneous tuple of
degree \(d\) were regular on all of \(D\) and induced \(\lambda_D\), then on an
elliptic component it would force \(d=25\), while on a line component it would
force \(d=1\). Thus no homogeneous tuple of any degree restricts to
\(\lambda_D\) as a morphism on all of \(D\).

2. **Landing obstruction, surviving rational cancellation.** Every homogeneous
\(G\)-covariant \(p:W\to W\) satisfying \(F(p)=0\) vanishes identically on every
involution plus-plane \(Z_t=\mathbf P(E_+(t))\). Hence it vanishes on
\(E_t\subset Z_t\). The canonical \([-5]\) coordinate tuple on \(E_t\) is
nonzero and basepoint-free. Therefore no landing covariant can induce this
boundary map even after allowing componentwise projective cancellation,
invariant scalar multiplication, or primitive reduction.

The second obstruction is the first exact obstruction relevant to the relaxed
rational interpretation of “extension.” It is theorem-level and applies to
this exact canonical boundary map, not to a generic degree-25 search.

## What is proved in this packet

- the corrected coordinate-free residual \(S_3\) formulas;
- origin independence of \([-5]\);
- global \(G\)-equivariance;
- reduced scheme-theoretic gluing at all type-I and type-II points;
- \([-5]^*\mathcal O_{E_t}(1)\simeq\mathcal O_{E_t}(25)\);
- the incompatible multidegrees on elliptics and lines;
- the exact eight-isotypic decomposition of the degree-25 source, with
  invariant dimension \(189\);
- the exact eight-isotypic decomposition of the network target, with invariant
  dimension \(41\);
- the zeroth-order plus-plane obstruction;
- nonidentification of the stored degree-25 formal tower with this boundary
  morphism.

## What is not claimed

- No degree-25 landing covariant is produced.
- No claim is made that all degree-25 landing covariants are absent.
- No claim is made that the Klein cubic is not \(G\)-unirational.
- The surviving degree-25 normal-lifting state is not promoted to a global
  polynomial or to boundary data on \(D\).

```text
DEGREE25-BOUNDARY-EXTENSION-OBSTRUCTED
KLEIN-PSL2(11)-UNIRATIONALITY-REMAINS-OPEN
```
