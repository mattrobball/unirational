# Exact emptiness of both literal goal-qualified branches

Let

\[
H=\operatorname{Hilb}^{19t+1}(M/F),\qquad M\simeq\mathbf P^3_F,
\]

and let \(H_Z\subset H\) be the marked locus defined by \(Z\subset C\).
The authoritative packet has two live numerical strata:

| branch | Rao data through degree five | upstream status |
|---|---|---|
| \(H_{Z,0}\) | \((0,16,29,38,42,40)\), no quintic | nonemptiness undecided |
| \(H_{Z,1}\) | \((0,16,29,38,42,41)\), unique quintic carrier | nonemptiness undecided |

For \(\epsilon\in\{0,1\}\), define two additional subfunctors:

- \(H^X_{Z,\epsilon}\): the exact-target locus \(C\subset X_F\);
- \(U^{\rm prop}_{Z,\epsilon}\): the bridge locus where no component of
  \(C_{\bar F}\) lies in \(X_F\) and \(C\cap X_F\) is zero-dimensional.

Every literal S19 solution would lie in their intersection.  But for any
field extension \(E/F\) and any \(C_E\in H^X_{Z,\epsilon}(E)\),

\[
(f_3)\subset I_{C_E},\qquad
I_{C_E\cap X_E}=I_{C_E}+(f_3)=I_{C_E}.
\]

Thus \(C_E\cap X_E=C_E\) has dimension one and does not lie in the proper
intersection locus.  Consequently

\[
H^X_{Z,0}\cap U^{\rm prop}_{Z,0}=\varnothing,
\qquad
H^X_{Z,1}\cap U^{\rm prop}_{Z,1}=\varnothing.
\]

This proof is independent of \(E\) and of the Rao module, so it covers the
generic invariant field and every base change.

## Decision table

| statement | decision |
|---|---|
| literal `epsilon_0` locus satisfying every target and bridge clause | **EMPTY** |
| literal `epsilon_1` locus satisfying every target and bridge clause | **EMPTY** |
| upstream ambient marked locus \(H_{Z,0}\) without containment in \(X\) | **UNDECIDED** |
| upstream ambient marked locus \(H_{Z,1}\) without containment in \(X\) | **UNDECIDED** |
| corrected ambient rescue curve | **UNDECIDED** |
| Klein-cubic \(G\)-unirationality | **OPEN** |

No very-general Picard replacement, finite-field transfer, or unexpanded
degree-55 coordinate interface enters the proof.
