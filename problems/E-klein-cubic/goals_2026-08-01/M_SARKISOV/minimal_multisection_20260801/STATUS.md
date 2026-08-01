DEGREE-3-MULTISECTION-PROVED

# Smaller multisection verdict

Yes.  The exact discovered fibration has a connected integral constant-field
multisection of degree **3**, far smaller than the orbit-line multisection of
degree 55.  Its normalization is \(\mathbf P^1_{K_3}\) for a cubic extension
\(K_3/K_0\).

Let \(C\) be the smooth pointless plane-cubic center and
\(B=\mathbf P^1_{K_0}\).  The exceptional divisor is

\[
 E\simeq C\times B,
\]

with the fibration restricting to the second projection.  A general
\(K_0\)-line in the center plane meets \(C\) transversely in a connected
degree-three point \(Z=\operatorname{Spec}K_3\).  Therefore

\[
 M_3=Z\times B\simeq\mathbf P^1_{K_3}\longrightarrow Y
\]

is a \(K_0\)-defined integral multisection and \(M_3\to B\) is finite etale of
degree three.  It is rational over its constant field \(K_3\), but it is not
\(K_0\)-rational or geometrically integral over \(K_0\).

The exact minimum is conditional only on the still-open section problem:

\[
 \min\deg(\text{multisection})=
 \begin{cases}
 1,&\text{if a rational section exists},\\
 3,&\text{if no rational section exists}.
 \end{cases}
\]

Degree two is never the minimum: a degree-two multisection on a cubic-
surface fibration produces a rational section by the residual-third-point
construction.

## Replay

From `goals_2026-08-01` run

```sh
/opt/homebrew/bin/python3 M_SARKISOV/minimal_multisection_20260801/verify.py
```
