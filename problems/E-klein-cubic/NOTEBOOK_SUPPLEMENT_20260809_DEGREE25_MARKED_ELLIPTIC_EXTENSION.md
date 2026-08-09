# Notebook supplement — degree-25 marked elliptic extension

**Date:** 2026-08-09  
**Parent main:** `091d4f5d4314c556da96d1804c49be13f48a78c8`  
**Authoritative packet:** `goal_runs_20260809/DEGREE25_MARKED_ELLIPTIC_EXTENSION/`  
**Decision:** `DEGREE25-BOUNDARY-EXTENSION-OBSTRUCTED`  
**Global Problem E headline:** **OPEN**

## Exact theorem boundary

The componentwise map

\[
[-5]:E_t\to E_t,\qquad \operatorname{id}:L_t\to L_t
\]

is intrinsic, fixes the complete marked configuration, is transported by
\(G\), and glues on the reduced fixed-curve network. The gluing uses the exact
type-I and type-II incidence geometry; all scheme intersections are reduced
ordinary triple points, so no tangent-jet compatibility is required.

The simultaneous reflection formula is corrected as follows. After choosing a
type-I reflection-fixed origin,

\[
\rho(P)=P+q_t,\qquad s_k(P)=kq_t-P,\quad k=0,1,2.
\]

The three offsets are not simultaneously three different two-torsion points.
Their fixed-point union remains
\(E_t[2]+\langle q_t\rangle\), so the installed marked set and the
origin-independence of \([-5]\) survive unchanged.

The actual plane polarization is symmetric and

\[
[-5]^*\mathcal O_{E_t}(1)\simeq\mathcal O_{E_t}(25).
\]

However the identity on a fixed line pulls back \(\mathcal O(1)\) to
\(\mathcal O(1)\), not \(\mathcal O(25)\). Hence no single homogeneous tuple is
regular on all of \(D\) and induces this morphism.

More decisively, every homogeneous landing \(G\)-covariant vanishes on every
involution plus-plane. Its restriction to every \(E_t\) is therefore zero,
whereas the \([-5]\) coordinate tuple is nonzero and basepoint-free. This
rules out the exact canonical boundary construction even if componentwise
rational cancellation is allowed.

The existing degree-25 normal-lifting survivor is unrelated: it is odd-order
\(E_-\)-valued data on the exceptional normal-direction bundle, not nonzero
order-zero \(E_+\)-valued data on \(E_t\).

## Scope

This is an exact obstruction to the proposed boundary extension, not an
all-degree nonexistence theorem for landing covariants. The Klein cubic
\(G\)-unirationality question remains open.

```text
DEGREE25-BOUNDARY-EXTENSION-OBSTRUCTED
KLEIN-PSL2(11)-UNIRATIONALITY-REMAINS-OPEN
```
