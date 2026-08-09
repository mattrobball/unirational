# Status

**Date:** 2026-08-09  
**Exit:** `FULL-G-SELFMAP-CLASSIFICATION-UNDECIDED`

## Executive verdict

The requested identity theorem and degree-one theorem are **false** for the
category of all dominant \(G\)-equivariant rational selfmaps of the Klein
cubic.

The packet proves an actual existence theorem. The cubic tangent-residual map

\[
\rho:\mathbf P(T_X)\dashrightarrow X
\]

descends over the free quotient \(B=X^{\mathrm{free}}/G\). A rational section
of the descended \(\mathbf P^2\)-bundle can be chosen, by a first-jet argument,
so that its composite with the descended residual map is dominant and
nonidentity. Pulling the section back gives a dominant nonidentity
\(G\)-equivariant rational selfmap \(\varphi:X\dashrightarrow X\).

The accepted degree-one rigidity and degree-two deck arguments then imply

\[
\deg\varphi\ge3.
\]

Iteration gives maps of degrees \((\deg\varphi)^m\). Hence the dominant
\(G\)-equivariant rational selfmap monoid is infinite and has unbounded degree.

## Closed conclusions

```text
FULL-G-NONTRIVIAL-RATIONAL-SELFMAPS-EXIST
FULL-G-SELFMAP-DEGREES-UNBOUNDED
TARGET-A-REFUTED
TARGET-B-REFUTED
ARBITRARY-SELFMAP-ROUTE-CANNOT-CLOSE-PROBLEM-E
```

The construction is intrinsic. It does not provide homogeneous forms on
\(\mathbf P(W_5)\) satisfying the global Klein landing equation. Therefore it
does not decide the ambient-extendable submonoid arising from Problem E.

## Exact remaining boundary

A rational selfmap represented by lifted forms \(P_i\) only satisfies

\[
F(P)=F(x)A(x).
\]

Problem E requires \(A=0\) identically. The remaining theorem is an
ambient-normal-extension / normalized-Rees theorem that classifies the
selfmaps for which the factor \(A\) can be killed while respecting full
\(G\)-equivariance and the forced base strata.

The degree-one retraction branch remains exactly as in
`DELTA1_RETRACTION_POLAR_IDENTITY`: the nonsquare residual-discriminant branch
is not excluded.

## Nonclaims

This packet does not determine:

- the least degree of a nonidentity \(G\)-selfmap;
- the degree or monodromy of the section-selected map;
- whether any tangent-residual selfmap is ambient-extendable;
- the normalized Rees carriers of an ambient landing ideal;
- the headline \(G\)-unirationality question.

## Replay

```text
python3 verify_tangent_residual.py
```

Expected markers:

```text
TANGENT_RESIDUAL_KLEIN_IDENTITY_OK
TANGENT_DIRECTION_REPRESENTATIVE_INDEPENDENCE_OK
TANGENT_BASE_REPRESENTATIVE_INDEPENDENCE_OK
```
