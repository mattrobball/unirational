# Gate A2 — marked degree-55 point and \(V_Z\)

**Date:** 2026-07-30  
**Packet:** `certificates/schur_krylov/`  
**Gate:** A2 (marked point half)  
**Headline:** OPEN

---

## 0. Goal

Install an **abstract geometric construction** of projective coordinates

\[
z=[z_0:z_1:z_2:z_3]\in\mathbf P^3(L)
\]

of the hyperplane-selected degree-55 closed point \(Z\), the four-dimensional
\(F\)-span

\[
V_Z=\operatorname{span}_F(z_0,z_1,z_2,z_3)\subset L,
\]

and an independent verifier of residue degree, point equations, and field
action.  This is a marked-evaluation **interface**, not expanded executable
generic data (`REPAIR.md` §10).  Power-basis coordinates of the \(z_i\) and
the exact Plücker point of \(V_Z\subset L\) are **not** installed.

---

## 1. Geometric construction over \(L\)

### 1.1 Twisted line

Let \(U_-\subset W\) be the unique two-dimensional \(H\)-summand on which the
Klein form vanishes identically (certified in
`tmp/schur_unrestricted_point_attack`, reconstructed from
`certificates/exact_weil_check.py`).  Then \(\ell=\mathbf P(U_-)\subset X\)
is the \(D_{12}\)-line of full stabilizer \(H\).

Over \(L=E^H\), the generic \(G\)-torsor reduces to an \(H\)-torsor.  Hilbert
90 for \(\operatorname{GL}_2\) trivialises the twisted module:

\[
{}^T U_-\simeq L^{\oplus 2}
\qquad\text{as \(L\)-vector spaces}.
\]

Hence the twisted line is standard \(\mathbf P^1_L\).  The twisted inclusion

\[
{}^T U_-\hookrightarrow{}^T W\simeq W_L\simeq L^{\oplus 5}
\]

is a rank-two \(L\)-subspace of \(W_L\), i.e. a line in \(\mathbf P^4_L\) lying
on the twisted cubic \(X_T\).  (Ambient split because \(W\) is honest;
equation \(G\)-invariant.)

### 1.2 Hyperplane selection

The accepted \(G\)-stable open \(\mathcal U\subset\mathbf P(W^\vee)\) of good
hyperplanes (`tmp/schur_degree19_structural_design`) is nonempty.  Twisting
supplies a torsor-dependent hyperplane \(M\simeq\mathbf P^3_F\) over \(F\)
cutting each of the 55 conjugate lines in a single point and giving the
exact Hilbert function

\[
H_Z(d)\in\bigl(1,4,10,19,31,45,55,55,\ldots\bigr)
\]

for \(d=0,1,2,\ldots\).  Restrict the twisted line to \(M_L\): one obtains a
single \(L\)-point

\[
z\in X_T(L)\cap M(L)\subset\mathbf P^3(L).
\]

Pushforward to \(F\) recovers the closed point \(Z=\operatorname{Spec} L\).

### 1.3 Coordinates as elements of \(L\)

Choose an \(L\)-basis \((e_1,e_2)\) of \({}^T U_-\) and write the unique
intersection with \(M_L\) as

\[
z_W=s\,e_1+t\,e_2\in W_L\setminus\{0\},
\]

with \([s:t]\in\mathbf P^1(L)\).  After the linear change of coordinates
cutting out \(M\), the four remaining homogeneous coordinates are \(L\)-linear
forms in \((s,t)\).  Scaling in \(\mathbf P^3\) gives

\[
z=[z_0:z_1:z_2:z_3],\qquad z_i\in L.
\]

In the monogenic **schema** \(L=F(\alpha)\) of `field_algebra.md`, each \(z_i\)
is formally a coordinate vector of length 55 over \(F\):

\[
z_i=\sum_{k=0}^{54} a_{ik}\,\alpha^k,\qquad a_{ik}\in F.
\]

The coefficients \(a_{ik}\) are **not** expanded as explicit elements of a
concrete model of \(F\).  The machine interface is `marked_point.json` →
`coordinates_power_basis` (schema only).

---

## 2. The subspace \(V_Z\)

### 2.1 Definition

\[
V_Z:=\operatorname{span}_F(z_0,z_1,z_2,z_3)\subset L.
\]

### 2.2 Dimension four

The Hilbert function of \(Z\subset M\simeq\mathbf P^3_F\) begins

\[
H_Z(0)=1,\quad H_Z(1)=4.
\]

In particular the four linear forms \(x_0,x_1,x_2,x_3\) remain linearly
independent on \(Z\): their images in \(H^0(Z,\mathcal O_Z(1))\simeq L\) (after
choosing a generator of the pulled-back \(\mathcal O(1)\)) are \(F\)-independent.
Equivalently \(\dim_F V_Z=4\).

(If the four coordinates were \(F\)-dependent, \(Z\) would lie in a hyperplane
of \(M\), contradicting \(H_Z(1)=4\).)

### 2.3 Point equations

The closed point lies on the cubic and on no unexpected lower-degree form
through degree two:

\[
f_3(z)=0,\qquad
H_Z(d)=\binom{d+3}{3}\quad(d\le 2),
\]

and through degree five the ideal is controlled by \(f_3\) and the invariant
quintic \(f_5\) as in the structural design packet
(\(\dim I_Z(5)=11=4+1\) from \(f_3 S_2\oplus\langle f_5\rangle\) in the split
model of the hyperplane-selected point).

---

## 3. Fibre witness (shape only, not the generic point)

The constant hyperplane \(x_0+x_1+x_2+2x_3+7x_4=0\) is a **witness** that the
good open \(\mathcal U\) is nonempty over \(\mathbf C\), not the torsor-dependent
hyperplane over \(F\).  On the certified \(D_{12}\)-line over
\(\mathbf Q(\zeta_{11})\) one computes the unique intersection point with that
hyperplane, verifies the Klein equation, and checks that the four \(\mathbf P^3\)
coordinates are \(\mathbf Q\)-linearly independent inside
\(\mathbf Q(\zeta_{11})\):

| Check | Result |
|---|---|
| on hyperplane | yes |
| on Klein cubic | yes |
| nonzero \(\mathbf P^3\) coordinates | 4 of 4 |
| \(\operatorname{rank}_{\mathbf Q}(z_0,z_1,z_2,z_3)\) | 4 |

Data: `tmp/pathA_krylov/fibre_marked_point.json`,
`tmp/pathA_krylov/d12_line_basis.json`.

**House rule.**  This fibre calculation is a shape and non-degeneracy witness.
It is **not** advertised as the characteristic-zero generic Schur closed
point over \(F\).  The generic coordinates are the \(L\)-point of §1.

---

## 4. Field action

Gal\((E/F)\simeq G\) permutes the 55 geometric points of \(Z_{\overline F}\)
simply transitively (stabilizer of one geometric point equals a conjugate of
\(H\)).  On the residue field \(L=E^H\), the only \(F\)-automorphisms are
trivial (\(\operatorname{Aut}(L/F)=1\)).  Multiplication matrices of §
`field_algebra.md` encode the full \(F\)-algebra structure used by the Krylov
incidence; no additional Galois action on \(L\) is required for containment
tests \(\lambda V_Z\subseteq U_\tau\).

---

## 5. Independent verifier requirements

`verify_marked_point.py` must, without importing a producer:

1. recompute \([G:H]=55\) and residue degree 55;
2. confirm \(H_Z(1)=4\Rightarrow\dim V_Z=4\);
3. confirm the residual budget \(3\cdot 19-55=2\);
4. rebuild the fibre witness from the sealed line basis and check
   hyperplane + cubic + rank 4 (exact \(\mathbf Q(\zeta_{11})\) arithmetic);
5. confirm the monogenic coordinate interface length 55 for each \(z_i\).

---

## 6. Theorem boundary (`REPAIR.md` §10)

| Sealed (abstract interface) | Not sealed (expanded executable generic data) |
|---|---|
| Geometric construction of \(z\in\mathbf P^3(L)\) | Coefficient vectors \(a_{ik}\in F\) as explicit invariant rational functions |
| \(\dim_F V_Z=4\) from Hilbert function | A single numerical 4×55 matrix over \(\mathbf Q\) claimed to be generic |
| Fibre non-degeneracy witness (shape only) | Identification of the fibre point with the generic \(Z\) |
| Marked-evaluation API for incidence shape | Exact Plücker point of \(V_Z\subset L\); executable generic \((L,V_Z)\) |

```text
abstract degree-55 algebra and marked-evaluation interface installed;
exact executable marked algebra-code pair (L,V_Z) not installed.
```

Expanded coefficients of \(z_i\) in the power basis of a concrete primitive
element require an explicit model of \(F\) (invariant field of \(G\) on
\(V_6\)) and the torsor-dependent hyperplane.  That computation is the next
exact point problem if the Krylov incidence is authorised; it is not a
blocker for sealing the incidence **shape**, linear-elimination plan, or
memory floors.  The later `A_EMPTY_UNDECIDED` packet correctly records this
boundary.

---

## 7. Terminal marker

```text
SCHUR_KRYLOV_A2_MARKED_POINT_SEALED
```
