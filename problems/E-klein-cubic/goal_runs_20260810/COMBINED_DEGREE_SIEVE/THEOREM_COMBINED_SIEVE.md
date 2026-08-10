# The combined degree sieve for the CLEAN branch

**Date:** 2026-08-10
**Field:** \(\mathbf C\)
**Group:** \(G=\operatorname{PSL}_2(\mathbf F_{11})\), \(|G|=660\)
**Threefold:** the smooth Klein cubic \(X=V(F)\subset\mathbf P(W)\), \(\dim W=5\)

**Exits:**

```text
COMBINED-SIEVE-TABLE
SELFMAP-EXCESS-DEGREE-IDENTITY-PROVED
COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED
CLEAN-INERT-VALUATION-CRITERION-PROVED
COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED
```

The requested all-degree periodic closure **does not exist** from the sealed
ledger, and §5 proves that it cannot exist: at every live degree the cell
\(\delta=3\) satisfies every sealed constraint simultaneously.  What the sieve
does produce is the exact survivor table of §5 and the exact identification of
the single missing ingredient in §6.

---

## 0. Standing hypotheses

Let

\[
A=(A_0,\ldots,A_4),\qquad
A_i\in\operatorname{Sym}^dW^\vee,
\]

be a nonzero primitive \(G\)-covariant ambient landing tuple, i.e.
\(A\in(\operatorname{Sym}^dW^\vee\otimes W)^G\) with \(F(A)\equiv0\), whose
induced rational map \(\mathbf P(W)\dashrightarrow X\) is dominant.  Write
\(\varphi=A|_X:X\dashrightarrow X\) for the restricted selfmap and assume, as
in `RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md` §1, that
\(\varphi\) is dominant, of degree \(\delta\).  Dominance of \(\varphi\) is an
inherited hypothesis, not proved here; see the scope note in `STATUS.md`.

Throughout, \(H=\mathcal O_X(1)\), \(H^3=3\), \(\operatorname{Pic}(X)=\mathbf ZH\)
and \(H^4(X,\mathbf Z)=\mathbf Z\ell\) with \(H\cdot\ell=1\), \(H^2=3\ell\)
(Grothendieck--Lefschetz for a smooth hypersurface of dimension three).

---

## 1. The character data of \(W\)

The character table of \(\operatorname{PSL}_2(\mathbf F_{11})\) is a standard
external input.  Its eight classes, with sizes and element orders, are

| class | 1A | 2A | 3A | 5A | 5B | 6A | 11A | 11B |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| size | 1 | 55 | 110 | 132 | 132 | 110 | 60 | 60 |
| order | 1 | 2 | 3 | 5 | 5 | 6 | 11 | 11 |

and the two conjugate degree-five characters take the values

\[
\chi_W=\Bigl(5,\;1,\;-1,\;0,\;0,\;1,\;\tfrac{-1+\sqrt{-11}}2,\;
\tfrac{-1-\sqrt{-11}}2\Bigr).
\]

### Lemma 1.1 (eigenvalue multisets)

The eigenvalues of a representative of each class on \(W\), written as
exponents of a primitive root of unity of the element's order, are

| class | eigenvalue exponents |
|---|---|
| 1A | \(0,0,0,0,0\) |
| 2A | \(0,0,0,1,1\) |
| 3A | \(0,1,1,2,2\) |
| 5A, 5B | \(0,1,2,3,4\) |
| 6A | \(0,1,2,4,5\) |
| 11A | \(\{1,3,4,5,9\}=\mathrm{QR}_{11}\) |
| 11B | \(\{2,6,7,8,10\}=\mathrm{QNR}_{11}\) |

and these multisets are uniquely determined by \(\chi_W\).

**Proof.** For an element \(g\) of order \(n\) the multiplicity vector
\((m_0,\ldots,m_{n-1})\) of the eigenvalues satisfies
\(\sum_i m_i\zeta_n^{ij}=\chi_W(g^j)\) for \(0\le j<n\); this is an invertible
discrete Fourier transform, so the multiset is determined by the values
\(\chi_W(g^j)\).  Solving:

* \(n=2\): \(m_0-m_1=1\), \(m_0+m_1=5\), so \((3,2)\).
* \(n=3\): \(m_0+m_1\zeta_3+m_2\zeta_3^2=-1\) and \(\sum m_i=5\) give
  \(m_1=m_2=2\), \(m_0=1\).
* \(n=6\): \(\chi(g)=1\), \(\chi(g^2)=-1\), \(\chi(g^3)=1\) force
  \(m_3=0\) and \(m_i=1\) otherwise, i.e. every sixth root of unity except
  \(-1\).
* \(n=5\): all four nontrivial power sums vanish, so all \(m_i\) are equal
  to \(1\).
* \(n=11\): \(g^j\) lies in 11A for \(j\in\mathrm{QR}_{11}\) and in 11B
  otherwise, so the power sums are the two Gauss periods; the transform gives
  \(m_a=1\) for \(a\in\mathrm{QR}_{11}\) and \(0\) otherwise.  Note
  \(\sum_{a\in\mathrm{QR}_{11}}\zeta_{11}^a=(-1+\sqrt{-11})/2\), which is the
  stated character value. \(\square\)

Since \(-1\in\mathrm{QNR}_{11}\), the eigenvalue exponents on \(W^\vee\) are
\(\mathrm{QNR}_{11}\) at 11A and \(\mathrm{QR}_{11}\) at 11B; on the other six
classes the multisets are stable under inversion.

### Lemma 1.2 (independent confirmation)

With the data of Lemma 1.1, the Molien computation gives

\[
\dim\left(\operatorname{Sym}^dW^\vee\otimes W\right)^G
=32,41,49,59,73,86,100
\qquad(d=15,\ldots,21),
\]

which agrees term by term with the covariant-dimension column of
`goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/LOW_DEGREE_DOMINANT_MAPS.md`,
computed there by exact Reynolds averaging of Weil matrices modulo the split
prime \(67\).  The two computations share no code and no method.  This is
recorded as an assertion in `verify_combined_sieve.py`.

---

## 2. The removed divisor and the set of admissible \(d'\)

### Lemma 2.1

\(A|_X\ne0\).

**Proof.** \(A\) is primitive on \(\mathbf P(W)\), so \(\operatorname{Bs}(A)\)
has codimension at least two, hence dimension at most two.  The hypersurface
\(X\) has dimension three, so \(X\not\subset\operatorname{Bs}(A)\). \(\square\)

### Lemma 2.2 (the common factor is a \(G\)-invariant)

Let \(D\) be the divisorial part of the zero scheme of \(A|_X\) on \(X\).
Then \(D\in|\mathcal O_X(k)|\) for a unique \(k\ge0\), \(D\) is \(G\)-invariant,
and its equation \(h\in H^0(X,\mathcal O_X(k))\) is \(G\)-invariant.  Writing
\(A_i|_X=h\cdot B_i\), the tuple \(B=(B_0,\ldots,B_4)\) is primitive of degree

\[
d'=d-k
\]

and defines the same map \(\varphi\).

**Proof.** \(\operatorname{Cl}(X)=\operatorname{Pic}(X)=\mathbf ZH\) by
Grothendieck--Lefschetz, and the homogeneous coordinate ring of a smooth
hypersurface of dimension at least three is a unique factorisation domain, so
the greatest common divisor \(h\) of the \(A_i|_X\) exists and is unique up to
scalar, with \(\operatorname{div}(h)=D\in|kH|\).  Equivariance means
\(A(g\cdot x)=g\cdot A(x)\), so \(g\) permutes the ideal generated by the
\(A_i|_X\) and therefore fixes \(D\).  Hence \(g\cdot h=\chi(g)h\) for a
character \(\chi\) of \(G\); since \(G\) is perfect, \(\chi\) is trivial and
\(h\) is invariant. \(\square\)

### Lemma 2.3 (the exact invariant-degree set)

\[
\dim H^0(X,\mathcal O_X(k))^G
=\dim(\operatorname{Sym}^kW^\vee)^G-\dim(\operatorname{Sym}^{k-3}W^\vee)^G,
\]

and with the data of Lemma 1.1 this equals

| \(k\) | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| \(\dim\) | 1 | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 2 | 2 | 3 |

with \(\dim\ge1\) for every \(k\ge5\).  Hence

\[
\boxed{
k\in S:=\{0\}\cup\{5,6,7,8,\ldots\},
\qquad\text{equivalently}\qquad
d'\in\{2,\ldots,d-5\}\cup\{d\}
}
\]

in the branch where \(\varphi\) is not the identity (see Lemma 2.5).

**Proof.** Taking \(G\)-invariants is exact in characteristic zero, and
multiplication by \(F\) identifies \(\operatorname{Sym}^{k-3}W^\vee\) with the
kernel of \(\operatorname{Sym}^kW^\vee\to H^0(X,\mathcal O_X(k))\), so the
displayed dimension formula holds.  The invariant dimensions
\(\dim(\operatorname{Sym}^kW^\vee)^G\) are read off the Molien series built
from Lemma 1.1; the difference sequence is the table.  That the difference is
positive for all \(k\ge5\) is verified for \(k\le64\) in
`verify_combined_sieve.py` and holds for all \(k\) because
\(\dim H^0(X,\mathcal O_X(k))^G\ge\dim H^0(X,\mathcal O_X(k-5))^G\) via
multiplication by the degree-five invariant, which is a nonzerodivisor on
\(X\). \(\square\)

Note \(k=3\) is excluded: the unique cubic invariant is \(F\) itself, which
vanishes identically on \(X\).

### Lemma 2.4 (Bézout bound for \(k\))

\(D\subset\operatorname{Bs}(A)\) is a codimension-two component of the ambient
base locus of degree \(3k\) in \(\mathbf P(W)\), so the refined-Bézout capacity
(1.1) of `RT_SPLIT_AND_DICHOTOMY/DEGREE_ACCOUNTING.md` gives

\[
3k\le d^2.
\]

This is not binding for \(k\le d\) once \(d\ge3\), and is recorded only for
completeness.

### Lemma 2.5 (the two branches)

If \(d'=1\) then \(\varphi\) is induced by a linear map, hence is an
automorphism of \(X\) commuting with \(G\); as
\(\operatorname{Aut}(X)=G\) has trivial centre, \(\varphi=\operatorname{id}\)
and \(\delta=1\).  Conversely \(\delta=1\) with the accepted degree-one
rigidity forces \(\varphi=\operatorname{id}\).  So exactly two branches occur:

* **retraction branch:** \(\varphi=\operatorname{id}\), \(\delta=1\),
  \(d'=1\), \(k=d-1\);
* **all-ambient branch:** \(\varphi\ne\operatorname{id}\), \(d'\ge2\),
  \(\delta\ge2\), and in the CLEAN case \(\delta\ge3\) because \(2\) is not a
  norm (§4).

---

## 3. The excess-intersection identity for \(\delta\)

Let \(B\) be the primitive degree-\(d'\) tuple of Lemma 2.2, \(J\subset
\mathcal O_X\) its ideal and \(Z=V(J)\) its base scheme; \(\dim Z\le1\) by
primitivity.  Choose a smooth variety \(Y\) with a projective birational
\(p:Y\to X\) such that \(J\cdot\mathcal O_Y=\mathcal O_Y(-E)\) for an effective
Cartier divisor \(E\), and let \(g=\varphi\circ p:Y\to X\) be the induced
morphism.  Then

\[
g^*H=d'\,p^*H-E.
\tag{3.1}
\]

Put

\[
z:=-\,H\cdot p_*(E^2)\in\mathbf Z,
\qquad
e:=E^3\in\mathbf Z .
\]

### Lemma 3.1

\(p_*[E]=0\) in \(H^2(X,\mathbf Z)\), and \(E\cdot p^*\alpha\cdot p^*\beta=0\)
for all \(\alpha,\beta\in H^2(X,\mathbf Z)\).

**Proof.** \(p(E)\subset Z\) has dimension at most one, while \([E]\) is a
two-dimensional cycle class; a proper pushforward drops to zero when the image
has smaller dimension.  The second statement is the projection formula. \(\square\)

### Theorem 3.2 (exact degree identity)

\[
\boxed{\;3\delta=3d'^3-3d'z-e\;}
\tag{3.2}
\]

and, in Segre-class form (Fulton, *Intersection Theory* 2nd ed., Prop. 4.4,
with \(L=\mathcal O_X(d')\), \(n=3\)),

\[
3\delta
=3d'^3-\int c(L)^3\cap s(Z,X)
=3d'^3-\Bigl(3\,d'\,\deg\bigl(H\cap s_1(Z,X)\bigr)+\deg s_0(Z,X)\Bigr),
\tag{3.3}
\]

so \(z=\deg(H\cap s_1(Z,X))\) and \(e=\deg s_0(Z,X)\).  The term
\(3d'z+e\) is the **contribution of \(Z\)**.  By Fulton §4.3, the
top-dimensional part of the Segre class is the fundamental cycle, so

\[
z=\sum_{C\subset Z,\ \dim C=1}m_C\deg C,
\qquad m_C=\text{geometric multiplicity of }Z\text{ along }C\ \ge1,
\]

and \(z=0\) when \(\dim Z\le0\).

**Proof of (3.2).** Cube (3.1) and use Lemma 3.1:

\[
3\delta=(g^*H)^3
=d'^3(p^*H)^3-3d'^2(p^*H)^2E+3d'(p^*H)E^2-E^3
=3d'^3+3d'\bigl(H\cdot p_*E^2\bigr)-e .
\]

The middle term vanished by Lemma 3.1 and \((p^*H)^3=H^3=3\).  Substituting
\(H\cdot p_*E^2=-z\) gives (3.2).  For (3.3), expand
\(\sum_{i\ge1}(-1)^{i-1}\binom3i (d'H)^{3-i}\cap p_*(E^i)\) and compare with the
definition \(s(Z,X)=p_*\bigl(\sum_{i\ge1}(-1)^{i-1}E^i\bigr)\). \(\square\)

### Theorem 3.3 (integrality and positivity)

\[
3\mid z,
\qquad
E\cdot(g^*H)^2=2d'z+e=3a
\quad\text{with } a\in\mathbf Z_{\ge0},
\]

and consequently

\[
\boxed{\;\delta=d'^3-d'\zeta-a,\qquad \zeta:=z/3\in\mathbf Z_{\ge0},\ a\in\mathbf Z_{\ge0}.\;}
\tag{3.4}
\]

**Proof.** *Integrality.* \(\ell\in H^4(X,\mathbf Z)\) and \(H^2=3\ell\), so by
(3.1) and Lemma 3.1

\[
p_*g^*\ell=\tfrac13\,p_*\bigl(d'^2p^*H^2-2d'\,p^*H\cdot E+E^2\bigr)
=\Bigl(d'^2-\tfrac z3\Bigr)\ell .
\]

Both \(g^*\) and \(p_*\) preserve integral cohomology on the smooth \(Y\), and
\(H^4(X,\mathbf Z)=\mathbf Z\ell\), so \(z/3\in\mathbf Z\).

*Positivity.* By the projection formula \(E\cdot(g^*H)^2=g_*[E]\cdot H^2\).
The class \(g_*[E]\) is an effective two-dimensional cycle class (or zero), and
\(H^2(X,\mathbf Z)=\mathbf ZH\), so \(g_*[E]=aH\) with \(a\ge0\); then
\(g_*[E]\cdot H^2=aH^3=3a\).  Expanding \(E\cdot(g^*H)^2\) with (3.1) and
Lemma 3.1, and using \((p^*H)\cdot E^2=H\cdot p_*E^2=-z\),

\[
E\cdot(d'p^*H-E)^2
=d'^2\,E\,(p^*H)^2-2d'\,(p^*H)E^2+E^3
=0+2d'z+e .
\]

Hence \(2d'z+e=3a\), and substituting \(e=3a-2d'z\) into (3.2):

\[
3\delta=3d'^3-3d'z-3a+2d'z=3d'^3-d'z-3a,
\]

i.e. \(\delta=d'^3-d'(z/3)-a\), which is (3.4). \(\square\)

### Lemma 3.4 (Bézout bound for \(\deg Z\))

\[
z\le3d'^2 .
\]

**Proof.** Take two general members \(f,g\) of the degree-\(d'\) system on
\(X\).  Primitivity means they have no common divisor on \(X\), so
\(V(f,g)\cap X\) is a curve, of degree \(\deg X\cdot d'\cdot d'=3d'^2\) in
\(\mathbf P(W)\).  Since \((f,g)\subseteq J\), for each one-dimensional
component \(C\) of \(Z\) the local ring of \(V(f,g)\) at the generic point of
\(C\) surjects onto that of \(Z\), so its length is at least \(m_C\).  Summing
degrees gives \(\sum_C m_C\deg C\le3d'^2\). \(\square\)

### Corollary 3.5 (the exact \(\delta\)-interval, and the absence of congruences)

If \(\dim Z=1\) then \(\zeta\ge1\) (indeed \(z\ge3\) by Theorem 3.3), so

\[
\boxed{\;1\le\delta\le d'^3-d'\;}
\qquad(\dim Z=1),
\qquad\qquad
1\le\delta\le d'^3
\qquad(\dim Z\le0).
\]

Moreover **(3.4) implies no congruence condition on \(\delta\)**: with
\(\zeta\) fixed at \(1\) the free parameter \(a\) sweeps every integer value in
\([0,d'^3-d'-1]\), so every integer in the interval is compatible with the
identity.  The excess-intersection bookkeeping contributes an interval and
nothing else.

*Remark.* If \(Z=\emptyset\) then \(\varphi\) is a surjective endomorphism of a
smooth Fano threefold of Picard number one that is not \(\mathbf P^3\), hence
an automorphism (Amerik--Rovinsky--Van de Ven; Hwang--Mok); this returns the
retraction branch.  Nothing below depends on this remark.

---

## 4. The CLEAN norm condition as inert-prime valuations

`RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md` (4.4), exit
`RESTRICTED-CLEAN-CM-NORM-PROVED`, gives: in the CLEAN branch

\[
\delta=N_{K/\mathbf Q}(u_\varphi)=x^2+xy+3y^2,
\qquad K=\mathbf Q(\sqrt{-11}),\quad h(K)=1 .
\]

### Theorem 4.1 (valuation criterion)

A positive integer \(\delta\) is represented by \(x^2+xy+3y^2\) if and only if

\[
\boxed{\;v_p(\delta)\ \text{is even for every prime }p\ \text{inert in }K,\;}
\]

and the inert primes are exactly

\[
\boxed{\;p\ne11\ \text{with}\ p\bmod11\in\{2,6,7,8,10\}\;}
\]

i.e. \(p=2,7,13,17,19,29,41,43,\ldots\).  In particular \(2\) is inert.

**Proof.** Since \(h(K)=1\), every ideal is principal and
\(x^2+xy+3y^2\) is the unique reduced form of discriminant \(-11\); thus
\(\delta\) is represented iff \(\delta=N(\mathfrak a)\) for an integral ideal
\(\mathfrak a\), which happens iff each inert prime occurs to even order
(split primes and the ramified prime \(11\) impose no condition).

For the inert list: for odd \(p\ne11\), quadratic reciprocity gives
\(\bigl(\tfrac{11}p\bigr)=(-1)^{(p-1)/2}\bigl(\tfrac p{11}\bigr)\), hence

\[
\Bigl(\tfrac{-11}p\Bigr)
=(-1)^{(p-1)/2}\Bigl(\tfrac{11}p\Bigr)
=\Bigl(\tfrac p{11}\Bigr),
\]

so \(p\) is inert iff \(p\) is a nonresidue mod \(11\), i.e.
\(p\bmod11\in\{2,6,7,8,10\}\).  For \(p=2\) the Kronecker symbol gives
\(\bigl(\tfrac{-11}2\bigr)=-1\) because \(-11\equiv5\equiv-3\pmod8\); and
\(2\bmod11=2\) is also a nonresidue, so the same rule applies verbatim.  (The
inertness of \(2\) is the same fact used in the class-number-one argument of
the source theorem: \(T^2-T+3\equiv T^2+T+1\pmod2\) is irreducible.) \(\square\)

### Corollary 4.2 (congruence form usable in a sieve)

* \(v_2(\delta)\) even, hence \(\delta\not\equiv2\pmod4\);
* \(v_7(\delta)\) even, hence \(\delta\not\equiv7j\pmod{49}\) for
  \(j=1,\ldots,6\);
* \(v_{13}(\delta)\) even, hence \(\delta\not\equiv13j\pmod{169}\) for
  \(j=1,\ldots,12\); and likewise for every inert \(p\), detected modulo
  \(p^2\).

The smallest excluded values are \(\delta=2,6,7,8,10,13,14,17,\ldots\);
\(\delta=1,3,4,5,9,11,12,15,16,20,23,25,\ldots\) are represented.

### Corollary 4.3 (the retraction case)

\(\delta=1=N(1)\) is always a norm, so the retraction branch is never touched
by the norm condition.  The associated \(\pm1\) rigidity \(u_\varphi=\pm1\) is a
statement about the correspondence, not about \(\delta\), and is out of sieve
scope.

---

## 5. The combined sieve

The sieve intersects, for each ambient degree \(d\):

(a) the degree window — \(d\ge22\) (`AMBIENT-LANDING-COORDINATE-DEGREE-AT-LEAST-22`),
    \(d\ge24\) in the retraction branch
    (`DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24`), and the unconditional
    emptiness through \(d=30\) (`FIX-P2-SWEEP2-EMPTY-THROUGH-30`), so the live
    window is \(d\ge31\);

(b) the splitting \(d=d'+k\), \(k\in S=\{0\}\cup\{5,6,\ldots\}\) (Lemma 2.3),
    with \(3k\le d^2\) (Lemma 2.4);

(c) the interval \(1\le\delta\le d'^3-d'\) and the identity
    \(\delta=d'^3-d'\zeta-a\), \(\zeta\ge1\), \(a\ge0\), \(\zeta\le d'^2\)
    (Corollary 3.5, Lemma 3.4);

(d) the norm-valuation condition of Theorem 4.1, plus \(\delta\ge3\) in the
    all-ambient branch (Lemma 2.5 with \(2\) not a norm).

Every unsealed constraint listed in `CONSTRAINT_LEDGER.md` §B is excluded from
the intersection.

### Theorem 5.1 (survivor table)

For \(22\le d\le60\):

* \(22\le d\le30\): **both branches dead**, killed by
  `FIX-P2-SWEEP2-EMPTY-THROUGH-30`.  (For \(d\in\{22,23\}\) the retraction
  branch is independently dead by
  `DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24`.)
* \(31\le d\le60\): **both branches alive**.
  * retraction: the single value \(\delta=1\), with removed divisor of degree
    \(d-1\ge30\), which lies in \(S\);
  * all-ambient: exactly the norms in \([3,\;d^3-d]\); the count runs from
    \(6782\) at \(d=31\) to \(44364\) at \(d=60\), and the minimum is
    \(\delta=3\) at every degree.

The full table is printed by `verify_combined_sieve.py`.

### Theorem 5.2 (no periodic closure exists)

For every \(d\ge31\) the cell

\[
k=0,\qquad d'=d,\qquad z=3\ (\zeta=1),\qquad a=d^3-d-3,\qquad \delta=3
\]

satisfies **every** constraint (a)--(d) simultaneously: \(k=0\in S\);
\(3k=0\le d^2\); \(1\le\zeta=1\le d^2\); \(a\ge0\);
\(\delta=d^3-d\cdot1-a=3\); \(3\le\delta\le d^3-d\); and
\(3=N\bigl(\tfrac{-1+\sqrt{-11}}2\bigr)\) is a norm.

Consequently, for **every** modulus \(M\) and **every** residue class
\(r\bmod M\), the least \(d\ge31\) with \(d\equiv r\pmod M\) survives the
sieve.  No residue class dies, and

\[
\boxed{\text{no periodic (mod }M\text{) infeasibility statement of the
requested shape exists from the sealed ledger.}}
\]

`verify_combined_sieve.py` certifies this for \(10724\) explicit
\((M,r)\) pairs, \(M\le120\) together with \(M=165,330,660,2310\), by
exhibiting the admissible cell in each case.

### Theorem 5.3 (why: the sieve is blind to small \(\delta\))

Every constraint in the sealed ledger is either an **upper** bound on
\(\delta\) (Corollary 3.5) or a **membership** condition on \(\delta\)
(Theorem 4.1).  None is a lower bound beyond \(\delta\ge3\).  Since \(3\) is a
norm, the CLEAN branch survives at every degree.  Any argument that closes
CLEAN must therefore exclude small \(\delta\) — in particular \(\delta=3\) —
and cannot be arithmetic in \(d\) alone.

---

## 6. The exact missing ingredient

Suppose one adjoined a lower bound \(\delta\ge L(d)\).  The cell at \(d\) dies
only if the interval \([\,\max(3,L(d)),\,d^3-d\,]\) contains no norm.  The
largest gap between consecutive norms in \([1,215940]\) is \(34\), so for
\(31\le d\le60\) the bound would have to satisfy

\[
L(d)>d^3-d-34,
\]

e.g. \(L(31)>29726\) against a range topping out at \(29760\).  A lower bound
that strong is a statement that \(\varphi\) is almost base-point free, which
contradicts the compulsory base strata already certified in
`certificates/LOCAL_TRANSITION_MODULES.md` §4E.

The honest conclusion is therefore:

> **The CLEAN branch cannot be closed by degree/norm arithmetic.**  The
> missing ingredient is not a further congruence but a *geometric* exclusion
> of the small-degree cells, above all
> \(\delta=3\), \(u_\varphi=\pm\frac{-1\pm\sqrt{-11}}2\).

This is exactly the cell that the existing tangent-residual construction of
`goal_runs_20260809/FULL_G_SELFMAP_CLASSIFICATION` makes plausible: that
packet produces nonidentity dominant \(G\)-selfmaps with \(\delta\ge3\) and
does not compute their degree.  Deciding whether some tangent-residual selfmap
has \(\delta=3\), and whether such a map is ambient-extendable, is the
smallest question that would move the CLEAN branch.

---

## 7. Scope and nonclaims

This packet does **not**:

* analyse the CARRIER branch (curve or point carriers); wherever the CLEAN
  branch survives, `CARRIER remains` is the standing alternative;
* prove that \(\varphi=A|_X\) is dominant (inherited hypothesis, §0);
* use any of the unsealed constraints in `CONSTRAINT_LEDGER.md` §B, in
  particular the mod-330 residue sieve, the \(D\)-parity statements, or the
  \(V_4\)-line order bound;
* assert an upper bound for \(d\), or decide any degree above \(60\) beyond
  the structural statement of Theorem 5.2, which is uniform in \(d\).
