# G5.0 — valuation models and residue G-torsors at `f5`, `f6`

## Marker

```text
G5-RESIDUE-TORSOR-MODEL-PASS
```

## Setup

Let \(G=\operatorname{PSL}_2(\mathbf F_{11})\) act on the five-dimensional Klein
representation \(W\), and write

\[
K_{\mathrm{aff}}=\mathbf C(W)^G,\qquad
K_{\mathrm{proj}}=\mathbf C(\mathbf P(W))^G,
\]

so \(\operatorname{trdeg}_{\mathbf C}K_{\mathrm{proj}}=4\) and
\(K_{\mathrm{aff}}/K_{\mathrm{proj}}\) is purely transcendental of degree one.
Let \(T/K_{\mathrm{proj}}\) be the genuine generic \(G\)-torsor and
\(X_T={}^TX\) the sealed universal cubic
(`goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json`).

The invariant ring admits the sealed Hironaka presentation

\[
A=\mathbf C[f_3,f_5,f_6,f_8,f_{11}],\qquad
\operatorname{rank}_A R=12
\]

with secondary basis

\[
1,f_7,f_9,f_{10},f_{12},f_{14},f_7^2,f_7f_9,f_9^2,f_9f_{10},f_7^3,f_9^2f_{10}.
\]

## Site `f5 = 0`

### Center and uniformizer

- Source divisor: the invariant quintic \(V(f_5)\subset\mathbf P(W)\).  It is
  geometrically integral and normal (Jacobian cone dimension \(2\) in
  \(\mathbf P^4\); Serre \(R_1+S_2\)).
- Quotient center: the image \(D_5\) of \(V(f_5)\) in the geometric quotient.
  Geometric integrality downstairs follows from upstairs integrality and
  finite group quotient.
- Affinely, \(f_5\) is a uniformizer of the corresponding height-one valuation
  of \(K_{\mathrm{aff}}\): source order one forces
  \(e(E_5/D_5)=1\) and \(v_{D_5}(f_5)=1\).
- On \(K_{\mathrm{proj}}\), a weight-zero uniformizer on the open
  \(f_3f_8\neq0\) is
  \[
  \pi_5=\frac{f_3f_5}{f_8}.
  \]

### Inertia and decomposition

Inertia is trivial: a nonidentity element of \(G\subset\operatorname{PGL}(W)\)
cannot fix an irreducible nonlinear hypersurface pointwise, so the generic
decomposition group of the quotient valuation is the full group \(G\).  This
matches the V3 survivor list \(\{G,11{:}5\}\) after maximal-\(A_5\) elimination;
here the component is the full-group boundary named by V3.

### Residue field

\[
\kappa_5^{\mathrm{aff}}=\operatorname{Frac}\bigl(R/(f_5)\bigr),
\]

free of rank \(12\) over \(\mathbf C(f_3,f_6,f_8,f_{11})\) as a vector space
(the secondary basis remains free after killing the regular parameter \(f_5\)).
The projective residue field \(\kappa_5\) of the \(K_{\mathrm{proj}}\)-valuation
is the degree-zero part, of transcendence degree three over \(\mathbf C\).
In particular \(\kappa_5\) is not \(C_1\), so V3 does not force solubility.

### Residue \(G\)-torsor

Because inertia is trivial, the generic torsor cocycle factors through the
residue Galois group.  Finite-étale equivalence for henselian local rings
(Stacks Tag `04GK`) extends the torsor over the valuation ring; its special
fibre is a genuine \(G\)-torsor \(\overline T_5/\kappa_5\), not merely the
reduction of one chosen Hilbert--90 matrix.  Twisting the honest rank-five
representation and the invariant cubic yields the smooth proper model used in
G5.1.

### Gauge independence

Any two Hilbert--90 frames of the twisted five-space differ by an element of
\(\operatorname{GL}_5\) on a common open.  On the open where both frames are
integral with unit determinant at \(D_5\), their reductions define isomorphic
residue twists.  The sealed secondary-basis multiplication table provides the
coordinate change data on that open.

### Retired bounded fact

The V3 certificate `V-F5-DEGREE16-SUPPORT-LE5-EMPTY` excludes degree-\(16\)
homogeneous landings of support size \(\le5\) on the Hironaka quotient at
\(f_5=0\).  It is consumed only as a finite support theorem and is **not** a
model of the full five-coordinate residue cubic.

## Site `f6 = 0`

### Center and uniformizer

- Source divisor: the invariant sextic \(V(f_6)\).  Geometric integrality is
  recorded by the same good-reduction singular-cone test used for the gauge
  audit (singular cone dimension \(1\) in characteristic \(67\), lifting to
  characteristic zero).
- Affinely, \(f_6\) is a uniformizer (\(e=1\)).
- At \(f_6=0\) with \(f_3f_5\neq0\), the weight-one ratio
  \(q_6=f_3^2/f_5\) is a unit gauge (coprime to \(f_6\)).

### Inertia, decomposition, residue

Exactly as for \(f_5\): inertia trivial, decomposition group full \(G\),
residue transcendence degree three for the \(K_{\mathrm{proj}}\) valuation,
genuine residue \(G\)-torsor \(\overline T_6/\kappa_6\) by unramified
finite-étale reduction.

### Components

Both generic divisors are treated as single primes.  No split into several
valuations is required; if a future factorization of a related discriminant
appears, each component must be renamed and re-audited separately.

## Binding to V3

V3 supplies the normal form: a negative henselian site must be unramified,
non-\(C_1\), of residue transcendence degree \(\ge2\), rank at most two, and
decomposition group \(G\) or \(11{:}5\).  The sites \(f_5=0\) and \(f_6=0\) are
exactly the named full-\(G\) divisorial models in that normal form.  This
packet installs their residue torsors and (in G5.1) their residue cubics; it
does not reopen ramified, \(C_1\), rank\(\ge3\), or maximal-\(A_5\) missions.

## Machine payload

```text
valuation_models.json
```
