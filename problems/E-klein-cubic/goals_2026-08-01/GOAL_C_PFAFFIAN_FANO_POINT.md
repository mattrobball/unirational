# Goal C — construct a genuine twisted-Fano point by Pfaffian–Morita descent

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous theorem/CAS worker in goal mode  
**Priority:** 2  
**Permitted headline direction:** positive  
**Current headline:** **OPEN**

## 0. Mission

Construct a \(K_{\rm proj}\)-rational point of the **genuine** twisted Fano threefold \(F_{14,T}\), equivalently a common isotropic right line for the five descended Hermitian forms after the exact Pfaffian–Morita reduction. Verify the point in the original equations and complete the accepted positive bridge to a \(G\)-unirational parametrization of the Klein cubic.

The auxiliary Pfaffian characteristic cubic in `Sym(A,sigma)` is not the target. A point of the open Morita-projector plane is not the target. Individual isotropic lines for individual Hermitian forms are not the target. The result must solve the simultaneous codimension-five common-line problem defining \(F_{14,T}\).

## 1. Binding current state

Consume the current files and packets:

```text
problems/E-klein-cubic/HANDOFF.md
problems/E-klein-cubic/CURRENT_PATHS.md
problems/E-klein-cubic/REPAIR.md
problems/E-klein-cubic/WORKORDER_CAS_T11_P25V_C3.md
problems/E-klein-cubic/certificates/projective_algebra*/
problems/E-klein-cubic/certificates/c3*/
```

At the pinned baseline:

1. The Pfaffian representation alignment and the specific descended degree-six central simple algebra \(A_{\rm proj}\) are fixed.
2. The generic Brauer class has period and index two, and a sigma-self-adjoint reduced-rank-two idempotent exists abstractly. This does **not** place the idempotent on the genuine Fano section.
3. A 36-element Reynolds frame and ordinary multiplication circuit are installed, with exact generator alignment. The full characteristic-zero regular representation is not installed.
4. The maximal-étale compression is modularly certified. For \(a=e_1\), \(E=K_{\rm proj}[a]\) has degree six and is separable at all tested split primes; \(1,b,\ldots,b^5\) is a right \(E\)-basis. The rectangular basis
   \[
   \{b^j a^i:0\le i,j<6\}
   \]
   is therefore valid on a nonempty generic open.
5. The compressed model consists of six minimal-polynomial coefficients plus 42 elements of \(E\), hence 258 scalar rational functions. Modular probes show that many have total degree at least five. Entrywise reconstruction of the historical \(36^3\) structure constants is forbidden and unnecessary.
6. The exact symplectic involution, quaternion/Morita corner, five global Hermitian matrices, and a genuine common line are not yet installed in this compressed model.

## 2. Exact theorem boundary

The headline-positive target is:

\[
F_{14,T}(K_{\rm proj})\ne\varnothing.
\]

An acceptable equivalent formulation is the existence of a one-dimensional right \(D\)-submodule

\[
\ell\subset D^3
\]

that is simultaneously isotropic for the five exact Hermitian forms \(h_1,\ldots,h_5\) obtained from the **specific** descended algebra with involution and the distinguished five-plane.

The final proof must include:

1. exact construction of the genuine descended algebra and involution over \(K_{\rm proj}\);
2. exact Morita/quaternion identification and transport of the distinguished five-plane;
3. an exact common isotropic line or equivalent Plücker/Fano point;
4. substitution into the original genuine Fano equations;
5. the complete bridge from this point to a \(K_{\rm proj}\)-point of the generic Klein twist and then to \(G\)-unirationality.

An emptiness theorem for this one model is at most a scoped negative result unless a separate exhaustiveness theorem is supplied. This goal file authorizes only a positive headline exit.

## 3. Work packages

### C0 — install the compressed characteristic-zero algebra

Use the maximal-étale/right-module basis. Reconstruct exactly:

- the degree-six minimal polynomial \(m_a(T)\);
- the six coefficients \(e_j\in E\) in
  \[
  b^6=\sum_{j=0}^5 b^j e_j;
  \]
- the entries of \(L_a\in\operatorname{Mat}_6(E)\), or an equivalent complete compressed multiplication interface.

Requirements:

1. adaptive multiprime reconstruction over the named invariant generators of \(K_{\rm proj}\);
2. degree search beginning at the certified floor rather than assuming degree at most four;
3. at least one unused holdout prime and direct substitution into modular multiplication tables;
4. exact verification of associativity, unit, centrality, degree-six dimension, and the generator alignments `A -> TSTS`, `B -> T^8 S`;
5. a proof that the rectangular determinant is nonzero on the generic open used later.

Do not reconstruct 46,656 structure constants. Do not promote agreement at several primes without rational reconstruction and holdout verification.

### C1 — reconstruct the involution in the compressed basis

Transport the exact symplectic involution to the rectangular model. Prove directly:

\[
\sigma^2=1,
\qquad
\sigma(xy)=\sigma(y)\sigma(x),
\]

and verify compatibility with the exact representation/Pfaffian form. Identify the fixed symmetric subspace and reproduce the accepted dimensions.

Every coordinate formula must be checked in the original 36-frame at one independent good specialization and symbolically on the generic open.

### C2 — Morita/quaternion corner and the five Hermitian forms

Choose an exact sigma-self-adjoint reduced-rank-two idempotent, form the quaternion corner \(D\), and construct the Morita equivalence

\[
(A_{\rm proj},\sigma)\simeq
\bigl(\operatorname{End}_D(D^3),\operatorname{ad}_h\bigr).
\]

Then transport the distinguished five-dimensional linear section to five explicit Hermitian matrices

\[
H_1,\ldots,H_5\in\operatorname{Herm}_3(D).
\]

Acceptance checks:

- the corner has the correct Brauer class and dimension;
- the involution type is correct;
- the five transported forms span the intended five-plane, not an arbitrary five-plane;
- specialization back to the installed Pfaffian representation reproduces the original linear section.

A construction that works for an arbitrary degree-six CSA but does not use the repository's specific aligned algebra is insufficient.

### C3 — solve the simultaneous common-line problem

Find a nonzero vector/right line \(\ell\subset D^3\) satisfying

\[
H_i|_\ell=0
\qquad(i=1,\ldots,5).
\]

The worker may use any exact route that preserves the field and section:

- a rational parametrization of an open Morita chart;
- elimination after a justified variable reduction;
- descent from a finite extension with an explicit corestriction/descent argument;
- a geometric fibration or torsor whose rational point is proved over \(K_{\rm proj}\);
- a directly guessed point followed by exact verification.

Local solubility, an abstract idempotent, separate isotropy of each \(H_i\), a point after an uncontrolled extension, or a point on the auxiliary characteristic cubic does not complete C3.

### C4 — original-equation and headline verification

Translate the common line to the original Plücker/Fano coordinates. Verify:

1. all defining equations of the genuine \(F_{14,T}\);
2. every required open condition;
3. descent under the exact generators of \(G\) and the field \(K_{\rm proj}\);
4. the full positive implication chain to a point on the generic Klein twist;
5. the final \(G\)-unirationality theorem.

## 4. Acceptance and exits

### Headline success

```text
C-POINT-HEADLINE-POSITIVE
```

Required payload:

- exact compressed algebra and involution;
- exact Morita/quaternion data;
- five exact Hermitian matrices;
- exact common line/Fano point;
- substitution in the original equations;
- independently checked positive bridge to \(G\)-unirationality.

### Scoped route failure

```text
C-NO-COMMON-LINE-SCOPED
```

Use only after an exact emptiness proof for the genuine common-line scheme. Do not call this non-\(G\)-unirationality without a separate theorem showing this Fano model is necessary.

### Honest stop

```text
C-UNDECIDED
```

Name the smallest unreconstructed rational function, algebra identity, or common-line incidence and give a measured resource floor.

## 5. Prohibitions and stopping rules

1. Do not confuse the auxiliary Pfaffian characteristic cubic with \(F_{14,T}\).
2. Do not infer a common line from individual isotropy or from odd-degree multisections.
3. Do not fall back to the full \(36^3\) structure-constant reconstruction.
4. Prime 67 may be a regression fibre but never the sole decision fibre.
5. No modular table becomes characteristic-zero data without reconstruction, congruence checks, and an unused holdout.
6. Every proposed point must be substituted into the original Fano/Pfaffian equations.
7. An exact point over an extension is not a \(K_{\rm proj}\)-point without an explicit descent.
8. No Magma dependency is permitted.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/C_PFAFFIAN_FANO/
```

and do not modify sealed historical packets. Provide:

```text
STATUS.md
MODEL.md
POINT.md
compressed_algebra.json
produce_*.py / *.jl / *.sage as appropriate
verify_*.py
SEAL.json
```

`STATUS.md` must begin with one of the three exits above. Independent verification must rebuild the key multiplication, involution, Hermitian, and point checks rather than read stored pass flags.