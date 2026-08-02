# Polar system

With symmetric trilinear polarization \(B\) normalized by \(\Phi(x)=B(x,x,x)\),

\[
P_v(t)=\Phi(q+tv)=\Phi(q)+3t\,B(q,q,v)+3t^2\,B(q,v,v)+t^3\Phi(v).
\]

## Objects

| Symbol | Equation | Geometry |
|---|---|---|
| \(H_q\) | \(B(q,q,v)=0\) | second-polar hyperplane |
| \(Q_q\) | \(B(q,v,v)=0\) | first-polar quadric |
| \(D_q\) | \(\mathrm{disc}_t(P_v)=0\) | tangent/discriminant locus in directions |
| \(I_q\) | \(P_v(t)=P_v'(t)=0\) | resolved tangent incidence |

Directions are considered in \(\mathbf P(k^5)\) and, when stated, in the quotient
by the irrelevant line \(\langle q\rangle\).

Machine ledger: `polar_system.json`.

## Marker

```text
G3P-POLAR-SYSTEM-PASS
```

Polarization identity checks for several \((q,v,t)\) samples are stored in the
JSON (`polarization.identity_checks`).
