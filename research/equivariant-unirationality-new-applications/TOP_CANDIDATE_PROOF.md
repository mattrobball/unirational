# Top candidate proof: the smooth Klein-invariant quartic double solid

## Theorem

Let

\[
B=\{2x_0^4+6x_0x_1x_2x_3+x_1x_3^3+x_1^3x_2+x_2^3x_3=0\}
\subset\mathbf P^3,
\]

and let

\[
X=\{w^2=B(x)\}\subset\mathbf P(1,1,1,1,2).
\]

Let \(H=C_7\rtimes C_3\) act through

\[
a=[1,\zeta^4,\zeta^2,\zeta],
\qquad
b(x_0,x_1,x_2,x_3)=(x_0,x_2,x_3,x_1),
\]

where \(\zeta^7=1\) is primitive, and let \(\tau(w)=-w\). Put

\[
G=H\times\langle\tau\rangle.
\]

Then:

1. \(X\) satisfies Condition (A);
2. the equivariant universal-torsor obstruction and every higher Amitsur group vanish;
3. \(X\) is not weakly \(G\)-versal, hence is not \(G\)-unirational.

## Proof

### Step 1 — the action is exact

Every monomial of the quartic has total \(a\)-weight zero modulo \(7\). The coordinate cycle \(b\) permutes the last three cubic-linear monomials and fixes the other two terms. Moreover

\[
bab^{-1}=a^4.
\]

Thus \(a,b\) generate \(H=C_7\rtimes C_3\), and the action lifts to \(X\) with \(w\) fixed. The deck involution \(\tau\) commutes with \(H\).

Avila–Ortiz–Troncoso identify this equation as the unique smooth quartic invariant under the primitive \(\operatorname{PSL}_2(\mathbf F_7)\)-action. Smoothness is also independently checked in `verify_klein_quartic_double_solid.py`.

### Step 2 — the deck-fixed K3 surface has no global residual fixed point

Since \(\tau\) is the deck involution,

\[
X^\tau=B.
\]

The four \(C_7\)-eigendirections are the coordinate points. Direct evaluation gives

\[
B(e_0)=2,
\qquad
B(e_1)=B(e_2)=B(e_3)=0.
\]

Therefore

\[
B^{C_7}=\{e_1,e_2,e_3\}.
\]

The element \(b\) cycles these three points, while its remaining fixed coordinate point \(e_0\) is not on \(B\). Hence

\[
B^H=\varnothing
\quad\text{and consequently}\quad
X^G=\varnothing.
\tag{2.1}
\]

### Step 3 — no \(H\)-stable rational curve exists on \(B\)

Assume that an irreducible rational curve \(C\subset B\) is \(H\)-stable. The action on its normalization gives a homomorphism

\[
H\longrightarrow\operatorname{PGL}_2(\mathbf C)
\]

with normal kernel \(K\triangleleft H\). The normal subgroups of the Frobenius group \(H=C_7\rtimes C_3\) are

\[
1,\qquad C_7,\qquad H.
\]

- If \(K=1\), then \(H\) embeds in \(\operatorname{PGL}_2\), impossible because a nonabelian group of order \(21\) is not cyclic, dihedral, \(A_4\), \(S_4\), or \(A_5\).
- If \(K=C_7\), then \(C\subset B^{C_7}\), contradicting the finiteness above.
- If \(K=H\), then \(C\subset B^H=\varnothing\).

Thus

\[
B\text{ contains no }H\text{-stable rational curve}.
\tag{3.1}
\]

The surface \(B\) is a K3 surface and is not rationally chain connected. A positive-dimensional irreducible RCC subvariety of a surface is either a rational curve or the whole surface. By (3.1), every \(G\)-stable irreducible RCC subvariety of \(X^\tau=B\) is therefore a point.

### Step 4 — apply the residual-RCC central obstruction

The element \(\tau\) is central. The two hypotheses of the theorem in `GENERALIZATIONS.md` are now:

\[
\begin{aligned}
&\text{every }G\text{-stable irreducible RCC subvariety of }X^\tau
  \text{ is a point},\\
&X^G=\varnothing.
\end{aligned}
\]

They were proved in Steps 3 and 2. Hence no faithful linear \(G\)-representation admits a \(G\)-equivariant rational map to \(X\). In particular, the generic linear \(G\)-torsor does not give a point on the corresponding twist of \(X\), so \(X\) is not weakly \(G\)-versal.

### Step 5 — Condition (A) nevertheless passes

Every abelian subgroup of \(H\) lies in \(C_7\) or in a conjugate of \(C_3\).

- The three points \(e_1,e_2,e_3\in B\) give fixed points for every subgroup of \(C_7\).
- The \(1\)-eigenspace of \(b\) is the projective line \([s:t:t:t]\). The quartic restricts to
  \[
  2s^4+6st^3+3t^4,
  \]
  so it meets \(B\) and gives a \(C_3\)-fixed point. Conjugacy handles every order-3 subgroup.

If an abelian subgroup of \(G=H\times\langle\tau\rangle\) contains \(\tau\), the same branch point remains fixed because \(\tau\) acts trivially on \(B\). Thus \(X^A\neq\varnothing\) for every abelian \(A\le G\).

### Step 6 — all higher Amitsur groups are silent

For a smooth quartic double solid,

\[
\operatorname{Pic}(X)=\mathbf Z\cdot H,
\qquad H=\pi^*\mathcal O_{\mathbf P^3}(1).
\]

The explicit projective action on \(\mathbf P^3\) supplies a \(G\)-linearization of \(H\). Hence the equivariant universal-torsor obstruction vanishes. Scavia–Tschinkel–Zhang prove that, for a smooth projective \(G\)-variety with free finitely generated Picard group, this implies

\[
\operatorname{Am}^n(X,G)=0
\qquad(n\ge2).
\]

Thus the theorem is not detected by Condition (A), the ordinary Amitsur group, any higher Amitsur group, or the universal-torsor obstruction. The fixed K3 geometry supplies the missing obstruction. \(\square\)

## Why this is the top application

The conic-bundle surface family is broader, but this threefold example is the sharper comparison with current methods:

- the underlying Fano threefold is classically unirational;
- the action is given by four explicit coordinates and one central deck involution;
- Condition (A) passes;
- every currently available Amitsur-type obstruction vanishes;
- the proof uses exactly the strengthened residual-group geometry requested in the mission.

## Replay

```text
python3 verify_klein_quartic_double_solid.py
```

Expected final line:

```text
KLEIN_PSL27_QUARTIC_DOUBLE_SOLID_VERIFY_OK
```
