<!-- FULL_G_SELFMAP_CLASSIFICATION_20260809 -->

# Notebook supplement: arbitrary full-\(G\) selfmaps exist

**Date:** 2026-08-09  
**Packet:** `goal_runs_20260809/FULL_G_SELFMAP_CLASSIFICATION/`

## Binding correction to the selfmap strategy

The proposed theorem

\[
\operatorname{End}^{\mathrm{rat,dom}}_G(X)=\{1\}
\]

and the weaker claim that every dominant \(G\)-equivariant rational selfmap
has degree one are both false.

For every smooth cubic there is an intrinsic tangent-residual map

\[
\rho:\mathbf P(T_X)\dashrightarrow X,
\]

sending a tangent direction to the residual third point of the tangent line.
For the Klein cubic it is \(G\)-equivariant. On the free quotient
\(U\to B=U/G\), the projectivized tangent bundle descends to
\(\mathbf P(T_B)\). A first-jet common-complement argument produces a rational
section whose composite with the descended residual map is dominant and
nonidentity. Pullback to \(U\) gives an actual dominant nonidentity
\(G\)-equivariant rational selfmap of \(X\).

The accepted degree-one rigidity and degree-two deck exclusions imply that
this map has degree at least three. Its iterates have degrees \(\delta^m\).
Therefore

```text
FULL-G-NONTRIVIAL-RATIONAL-SELFMAPS-EXIST
FULL-G-SELFMAP-DEGREES-UNBOUNDED
TARGET-A-REFUTED
TARGET-B-REFUTED
ARBITRARY-SELFMAP-ROUTE-CANNOT-CLOSE-PROBLEM-E
```

## Exact generic classification

Let \(K=\mathbf C(X)^G\), let \(L=\mathbf C(X)\), and let
\(\alpha\in H^1(K,G)\) be the generic torsor. Dominant equivariant selfmaps
are equivalent to pairs

\[
(\psi,\iota),
\qquad
\psi:X/G\dashrightarrow X/G\text{ dominant},
\qquad
\iota:\psi^*\alpha\simeq\alpha.
\]

This is exact at the generic-field level but is not a finite list.

## Problem-E boundary after the correction

The new selfmaps are intrinsic. Lifting their coordinate sections to
homogeneous forms on \(\mathbf P(W_5)\) gives only

\[
F(P)=F(x)A(x).
\]

An ambient landing map requires \(A=0\) identically. Hence the arbitrary
selfmap route cannot reduce Problem E to retractions.

The remaining decisive problem is the ambient-normal-extension / normalized
Rees problem:

> classify the torsor-preserving quotient selfmaps whose lifted coordinates
> satisfy the global landing identity, and compute the actual exceptional
> horizontal carriers forced by that identity.

The degree-one ambient branch is still the exact retraction problem

\[
T=Hx+FQ,
\qquad
F(x+tQ)=(Ht-F)(St^2-Rt-1),
\]

with the nonsquare residual-discriminant branch open.

## New exact verifier

Run

```text
python3 goal_runs_20260809/FULL_G_SELFMAP_CLASSIFICATION/verify_tangent_residual.py
```

Expected markers:

```text
TANGENT_RESIDUAL_KLEIN_IDENTITY_OK
TANGENT_DIRECTION_REPRESENTATIVE_INDEPENDENCE_OK
TANGENT_BASE_REPRESENTATIVE_INDEPENDENCE_OK
```

## Current exit

```text
FULL-G-SELFMAP-CLASSIFICATION-UNDECIDED
FULL-G-AMBIENT-SELFMAP-CLASSIFICATION-OPEN
KLEIN-PSL2(11)-NONUNIRATIONAL-NOT-PROVED
```
