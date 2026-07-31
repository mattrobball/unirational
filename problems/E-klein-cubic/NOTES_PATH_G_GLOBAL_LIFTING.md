# Path G — global lifting and analytic-algebraization notes

**Status:** OPEN  
**Written:** 2026-07-31  
**Pinned base:** `9bee33a1be121a81dfa8fd8724a653d7e08d7aec`  
**Scope:** synthesis of the certified Path G computations and an analytic audit of the proposed boundary/formal/G3 completion.

---

## 0. Headline and theorem boundary

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),
\qquad
X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}
\subset \mathbf P(W)\simeq\mathbf P^4.
\]

The accepted reduction remains

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]

Path G has produced substantial exact information about normal jets, global compatibility, and finite polynomial truncation. It has **not** produced a landing covariant, a rational map \(\mathbf P(W)\dashrightarrow X\), or a proof of \(G\)-unirationality.

The analytic audit below also does **not** close the problem. It identifies two false implications in the proposed analytic completion and isolates the genuine global formal-lifting theorem that would be required.

\[
\boxed{\text{Problem E remains OPEN.}}
\]

---

## 1. Authoritative repository inputs

The principal tracked inputs are:

```text
certificates/GLOBAL_TRANSITION_DIAGRAM.md
certificates/TRANSITION_CATEGORY_REPAIR.md
certificates/NONLINEAR_LIFTING_EQUATIONS.md
certificates/lifting/OBSTRUCTION_TOWER.md
certificates/global_lifting/GLOBAL_STATE_IMAGE.md
certificates/global_lifting_decision/DECISION.md
certificates/global_lifting_decision/FORK_GB.md
certificates/global_finite_lifting/FINITE_TRUNCATION_THEOREM.md
certificates/global_finite_lifting/TERMINAL_PATTERN.md
certificates/global_finite_lifting/degree7/*
certificates/global_finite_lifting/degree13/*
certificates/global_finite_lifting/degree19/*
```

The exact stabilizer packet is authoritative. In particular, type-II \(V_4\)-points are triple intersections of the three local fixed elliptics. Any earlier candidate statement saying that positive-dimensional fixed loci meet only at type-I points is superseded.

The repaired category keeps distinct:

1. the source involution line \(L_t^{\mathrm{src}}\subset\mathbf P(W)\);
2. the exceptional normal-direction factor \(\mathbf P(E_-(t))^N\subset\mathbf P(N_{Z_t/Y})\);
3. the target involution line \(L_t^{\mathrm{tgt}}\subset X^t\).

No argument below identifies these three objects.

---

# Part I — repository-certified Path G findings

## 2. The global transition machine gives necessary states only

The global transition package assembles local normal-jet modules over the exact incidence category. Its fixed-order architecture is

```text
plane normalization
    -> triple-line equalizer
    -> residual point kernel.
```

It retains the finite irrelevant-torsion correction and does not replace the arrangement by a false short Čech complex.

Three Level-1 marked-state families survive:

```text
based_minus_lines_odd_m
residual_e1_swap_both
residual_e_ge7_generic_swap_both
```

At Level 2, the corrected linear inverse-limit module is nonzero for every fixed odd plane order \(m\) and all sufficiently large polynomial degrees \(d\). The reason is structural: plane jets grow quadratically in \(d\), whereas the total line and point compatibility targets grow only linearly.

The theorem proved by this package is one-way:

\[
\text{landing covariant}
\Longrightarrow
\text{compatible element of the transition module}.
\]

The converse is not proved. A marked state records stabilizers, target-component labels, endpoint permutations, characters, and charges. It is not an actual map on the exceptional boundary. A Level-2 element is compatible associated-graded data. It is not a formal morphism and not a covariant.

This distinction remains binding throughout these notes.

## 3. The nonlinear polar operators are generically surjective

For an involution decomposition

\[
W=E_+\oplus E_-,
\]

write the first nonzero odd normal term as \(a_m\), with subsequent terms

\[
\begin{aligned}
p_-&=a_m+a_{m+2}+a_{m+4}+\cdots,\\
p_+&=b_{m+1}+b_{m+3}+b_{m+5}+\cdots.
\end{aligned}
\]

The Klein cubic is even in the normal variable:

\[
F(z+y)=F_+(z)+B(z;y,y).
\]

The first nonautomatic equations include

\[
B(b_{m+1};a_m,a_m)=0
\]

and

\[
B(b_{m+3};a_m,a_m)
+2B(b_{m+1};a_m,a_{m+2})
+F_+(b_{m+1})=0.
\]

More generally, at every nonautomatic odd stage the newest correction enters through the same type of polar operator

\[
L_{2k+1}(b)=B(b;a_m,a_m).
\]

The certified all-\(m\) rank theorem gives generic full codomain rank for these free polar operators. In particular:

\[
\operatorname{null}L_1=4,
\qquad
\operatorname{null}L_3=8
\]

on the generic free fibre, with analogous full-rank behavior at higher isolable stages.

This proves local/free formal smoothness on a nonempty open of leading jets. It does not prove global polynomial solvability.

## 4. Global states meet the generically surjective open

The scheme-theoretic image of globally compatible leading states was compared with the rank-drop locus of \(L_3\). Exact characteristic-zero witnesses show open meeting at

\[
(m,d)=(1,7),\quad(1,13),\quad(3,19).
\]

Thus the global equalizers do not force every leading state into the first nonlinear rank-drop locus at these bidegrees.

One correction is important: the pure residual-\(S_3\)-trivial free fibre works at \(m=1\) but drops rank at \(m=3\). The \((3,19)\) open meeting uses a more general based residual state. The \(m=1\) witness cannot be extrapolated naively.

These open-meeting results reclassify the early nonlinear machine as constructive rather than obstructive. They still do not produce a covariant.

## 5. Fixed-degree algebraization is finite, not an infinite Artin problem

For a homogeneous degree-\(d\) polynomial map \(p\), the cubic \(F(p)\) has degree \(3d\). If \(I\) is the ideal of an involution plus-plane, then

\[
F(p)\in I^{3d+1}
\quad\Longrightarrow\quad
F(p)=0.
\]

Therefore the normal-order lifting problem at fixed \(d\) terminates by order \(3d\). There is no infinite formal-series algebraization problem at a fixed polynomial degree. The correct object is a finite terminal system.

This theorem explains why early free surjectivity is insufficient: the degree bound eventually removes the correction term that would be needed to kill the next residual.

## 6. The finite terminal obstruction pattern

The complete or extended finite towers have been analyzed at

\[
(m,d)=(1,7),\quad(1,13),\quad(3,19).
\]

The certified pattern is:

| \((m,d)\) | terminal \(F\)-order | last isolable \(E_+\) order | first non-isolable \(F\)-order |
|---|---:|---:|---:|
| \((1,7)\) | \(21\) | \(8\) | \(10\) |
| \((1,13)\) | \(39\) | \(14\) | \(16\) |
| \((3,19)\) | \(57\) | \(24\) | \(26\) |

The general isolation cutoff is proved:

\[
\boxed{
\text{first non-isolable }F\text{-order}=d+2m+1.
}
\]

Equivalently, the last isolable \(E_+\)-valued order is

\[
(d-1)+2m.
\]

At the three tested bidegrees, a nonzero mixed residual survives at or after the cutoff, and no polynomial tower closes. The resulting exits are scoped obstructions at those bidegrees.

What is **not** proved:

- that the cutoff residual is nonzero for every \((m,d)\);
- an all-degree periodicity theorem;
- an all-degree negative theorem;
- existence of a degree where the terminal residual vanishes.

The data do not support a classification by \(d-6m\): the pairs \((1,7)\) and \((3,19)\) have the same value \(d-6m=1\), but their first non-isolable orders are \(10\) and \(26\).

---

# Part II — analytic completion audit

## 7. The proposed analytic route

The proposed route was:

1. interpret a surviving marked state as a nonconstant equivariant rational map
   \[
   f_0:E\dashrightarrow X
   \]
   on the reduced exceptional boundary of a wonderful modification;
2. lift \(f_0\) equivariantly through infinitesimal neighborhoods on an affine open;
3. use connectedness and the Hironaka–Matsumura G3 theorem to identify the formal-rational field with \(K(\mathbf P(W))\);
4. obtain a nonconstant rational equivariant map \(\mathbf P(W)\dashrightarrow X\);
5. use \(\operatorname{ed}_{\mathbf C}(G)\ge3\) to prove dominance.

The audit finds that steps 1 and 3 are not justified. One interpolation lemma used in step 1 is false as stated, and the affine-to-global formal-field passage in step 3 is false.

## 8. A marked state is not a boundary map

The certified family `residual_e1_swap_both` is a discrete/linear compatibility state. It does not provide, for every irreducible component \(B\subset E\), an actual rational map

\[
B\dashrightarrow T_B\subset X
\]

with the required restrictions on every incidence divisor.

In particular, the state does not supply:

- vector representatives of all projective boundary values;
- a common stabilizer character for those representatives;
- a rational interpolant on each boundary component;
- compatibility of the interpolants on all multiple intersections;
- regularity on the full boundary required for global deformation theory.

Thus the statement

\[
\text{“the accepted marked state realizes }f_0:E\dashrightarrow X\text{”}
\]

is a new theorem, not a consequence already contained in the transition certificates.

## 9. Nonequivariant semilocal interpolation is valid

Let \(B\) be integral, let \(D_1,\dots,D_s\subset B\) be distinct prime divisors, and prescribe rational maps

\[
\phi_i:D_i\dashrightarrow\mathbf P(V).
\]

Choose nonzero vector representatives

\[
v_i\in V\otimes k(D_i).
\]

In the semilocal ring of \(B\) at the generic points of the \(D_i\), the maximal ideals are pairwise comaximal. The Chinese remainder theorem gives

\[
v\in V\otimes k(B)
\]

with the prescribed residues. Since at least one residue is nonzero, \(v\neq0\), and \([v]\) defines a rational extension

\[
B\dashrightarrow\mathbf P(V).
\]

This proves the nonequivariant interpolation statement.

## 10. The equivariant interpolation lemma is false as stated

Let

\[
B=\mathbf P^1\times\mathbf P^1
\]

and let \(H=C_2\) act trivially on \(B\). Let \(H\) act on the target \(\mathbf P^1\) by

\[
[u:v]\longmapsto[u:-v].
\]

The fixed locus is

\[
\{[1:0],[0:1]\}.
\]

Take the disjoint divisors

\[
D_0=\{0\}\times\mathbf P^1,
\qquad
D_\infty=\{\infty\}\times\mathbf P^1
\]

and prescribe the equivariant constant maps

\[
\phi_0\equiv[1:0],
\qquad
\phi_\infty\equiv[0:1].
\]

Any \(H\)-equivariant rational map from \(B\) must have image in the target fixed locus, because the source action is trivial. Since \(B\) is irreducible, such a rational map must be constant. It cannot realize both prescribed values.

Therefore projectively equivariant boundary data do not automatically admit an equivariant rational interpolant. Applying a Reynolds operator to arbitrary vector lifts can annihilate the lift or change its projective restrictions.

### Correct replacement

A Reynolds argument works after adding a common-character lifting hypothesis. Suppose there is a character

\[
\chi:H\to\mathbf C^\times
\]

and vector representatives \(v_i\) such that

\[
h(v_i)=\chi(h)v_{h(i)}
\]

for all \(h\in H\). Lift the \(v_i\) semilocally and apply the \(\chi\)-projector

\[
P_\chi(v)
=
\frac1{|H|}
\sum_{h\in H}\chi(h)^{-1}h(v).
\]

At each boundary generic point its residue is still the prescribed \(v_i\), so it is nonzero and defines an equivariant rational interpolation.

The missing finite boundary-realization theorem must verify this common-character condition component by component.

## 11. Affine square-zero lifting is valid

Let \(S\hookrightarrow S'\) be a square-zero thickening with ideal \(J\), let \(S\) be affine, and let

\[
f:S\to X
\]

be a morphism to the smooth cubic threefold.

The obstruction to lifting \(f\) to \(S'\) lies in

\[
H^1(S,f^*T_X\otimes J),
\]

which vanishes because \(S\) is affine. Hence a lift exists.

If \(G\) acts and \(f\) is equivariant, the set of lifts is an affine torsor under

\[
M=H^0(S,f^*T_X\otimes J).
\]

The failure of one lift to be equivariant is a group \(1\)-cocycle in \(M\). Since \(|G|\) is invertible over \(\mathbf C\),

\[
H^1(G,M)=0.
\]

Translating the lift by a suitable element of \(M\) gives an equivariant lift.

Thus an equivariant morphism on an affine boundary thickening lifts equivariantly through every affine square-zero extension.

This is a local/affine theorem only.

## 12. Shrinking the boundary destroys the G3 conclusion

The claim

\[
K(\widehat V_{E^\circ})
=
K(\widehat{\widetilde Y}_E)
\]

for an affine open \(V\subset\widetilde Y\) is false in general.

### Counterexample

Let

\[
Y=\mathbf P^2,
\qquad
Z=\{y=0\}\simeq\mathbf P^1.
\]

The full line \(Z\) is G3 in \(\mathbf P^2\). Take the affine chart

\[
V=\{z\neq0\}\simeq\mathbf A^2
\]

with coordinates \(x,y\), so

\[
Z^\circ=Z\cap V=\{y=0\}\simeq\mathbf A^1.
\]

The completion is

\[
\widehat V_{Z^\circ}
=
\operatorname{Spf}\mathbf C[x][[y]].
\]

The formal function

\[
g(x,y)=x+e^y
=x+\sum_{n\ge0}\frac{y^n}{n!}
\]

defines a formal morphism to \(\mathbf P^1\), and its restriction to \(Z^\circ\) is the nonconstant algebraic map \(x\mapsto[1:x+1]\).

But

\[
e^y\notin\mathbf C(x,y).
\]

Indeed, a rational function satisfying \(r'=r\) has no poles, hence is a polynomial, and no nonzero polynomial satisfies that equation.

Therefore the affine formal completion contains formal-rational data that do not come from \(K(Y)\). The G3 theorem controls the **full projective completion**, not an arbitrary affine piece.

Consequently, affine formal lifting cannot be followed directly by global G3 algebraization.

## 13. The genuine global obstruction groups

Assume, after a further equivariant modification if necessary, that there is a regular equivariant boundary morphism

\[
f_0:E\to X
\]

on the full exceptional boundary. Let \(\mathcal J\) be the ideal of \(E\subset\widetilde Y\), and let

\[
E_n=V(\mathcal J^{n+1}).
\]

Given a global lift

\[
f_n:E_n\to X,
\]

the obstruction to extending it to \(E_{n+1}\) lies in

\[
\boxed{
o_n(f_n)
\in
H^1\!\left(
E,
 f_0^*T_X\otimes
 \mathcal J^{n+1}/\mathcal J^{n+2}
\right)^G.
}
\]

If this class vanishes, lifts form a torsor under the corresponding \(H^0\), and exactness of invariants gives an equivariant lift.

The affine argument kills the restrictions of these obstruction classes to an affine open. It does not prove that the global classes vanish.

No current Path G certificate computes these cohomology groups or the actual obstruction classes.

The genuine analytic lifting problem is therefore global:

\[
\boxed{
\text{construct }f_0:E\to X
\text{ and prove }o_n(f_n)=0
\text{ for all }n.
}
\]

## 14. Connectedness of the plane arrangement is proved analytically

Let \(\Gamma\) be the graph whose vertices are the \(55\) involution plus-planes and whose edges record common \(V_4\)-lines.

Each plane contains three \(V_4\)-lines, and each such line lies in three planes. Thus each plane has six distinct neighboring planes.

The group acts transitively on the \(55\) vertices. The vertex set of each connected component is therefore a block. Its size divides \(55\). A simple connected \(6\)-regular graph has at least seven vertices, so a component has size \(11\) or \(55\).

If the component size were \(11\), there would be five components. The induced action

\[
G\to S_5
\]

would be nontrivial; otherwise each component would be \(G\)-stable, contradicting transitivity on all \(55\) planes. Since \(G\) is simple, the map would be injective, impossible because

\[
660>|S_5|=120.
\]

Hence the graph, and therefore the plane arrangement, is connected.

## 15. The G3 and dominance steps are conditionally valid

Assume there is a nonconstant equivariant formal rational map on the **entire** completion

\[
\widehat f:
\widehat{\widetilde Y}_E
\dashrightarrow X
\]

which gives a point

\[
\xi\in X\!\left(K(\widehat{\widetilde Y}_E)\right).
\]

Because the original connected positive-dimensional plane arrangement is G3 in projective space, and because the Hironaka–Matsumura proper-mapping theorem applies to the proper birational modification and its full inverse-image support, one obtains

\[
K(\widehat{\widetilde Y}_E)
\simeq
K(\widehat Y_Z)
=
K(Y).
\]

Thus \(\xi\) defines an equivariant rational map

\[
f:Y\dashrightarrow X.
\]

If the formal boundary map is nonconstant, then \(f\) is nonconstant. Let \(M\) be the closure of the image. The kernel of \(G\) acting on \(M\) is normal, hence trivial or all of \(G\). It cannot be all of \(G\), since then

\[
M\subset X^G
\]

while \(X^G=\varnothing\). Thus \(M\) is a faithful compression. The accepted lower bound

\[
\operatorname{ed}_{\mathbf C}(G)\ge3
\]

forces

\[
\dim M\ge3.
\]

Since \(\dim X=3\), the rational map is dominant.

Therefore the final analytic implication is valid:

\[
\boxed{
\text{nonconstant global equivariant formal map along }E
\Longrightarrow
\text{dominant equivariant rational map }Y\dashrightarrow X.
}
\]

What is missing is the antecedent.

---

# Part III — corrected conditional theorem and research target

## 16. Corrected conditional theorem

Let

\[
\pi:\widetilde Y\to Y=\mathbf P(W)
\]

be a proper equivariant modification whose full reduced inverse-image boundary \(E\) lies over the connected involution-plane arrangement.

Assume:

1. there is a nonconstant \(G\)-equivariant morphism
   \[
   f_0:E\to X;
   \]
2. for every \(n\ge0\), the obstruction class
   \[
   o_n(f_n)
   \in
   H^1\!\left(
   E,
   f_0^*T_X\otimes
   \mathcal J^{n+1}/\mathcal J^{n+2}
   \right)^G
   \]
   vanishes, so that \(f_0\) extends to a global equivariant formal map on \(\widehat{\widetilde Y}_E\).

Then there is a dominant \(G\)-equivariant rational map

\[
\mathbf P(W)\dashrightarrow X,
\]

and hence

\[
\operatorname{ed}_{\mathbf C}(G)=3.
\]

The theorem is conditional because hypotheses 1 and 2 are not presently established.

## 17. Exact remaining Path G questions

### G-A — boundary realization

For each boundary-component orbit, produce:

```text
component B
setwise stabilizer H_B
assigned target T_B
incident divisors D_i
projective boundary maps on D_i
vector representatives v_i
common character chi_B
H_B-equivariant interpolating map B -> T_B
```

The common-character condition must be verified, not inferred from projective endpoint labels.

### G-B — regularity on the full boundary

Resolve the indeterminacy of the componentwise rational maps by a further equivariant modification and prove that they glue to a regular morphism

\[
f_0:E\to X
\]

on the full boundary used in the G3 theorem.

### G-C — global obstruction classes

Compute or annihilate

\[
H^1\!\left(
E,
 f_0^*T_X\otimes
 \mathcal J^{n}/\mathcal J^{n+1}
\right)^G
\]

and the actual classes \(o_n\).

Possible analytic tools include:

- an exact Čech calculation on the SNC boundary;
- normalization/equalizer sequences retaining multiple intersections;
- positivity or negativity of the normal line bundles;
- decomposition into stabilizer characters followed by induction to \(G\);
- Serre duality on rational boundary components;
- comparison between these global obstruction classes and the terminal polynomial residuals already found in degrees \(7,13,19\).

### G-D — relation to the finite terminal towers

Determine whether the mixed residual at order

\[
d+2m+1
\]

is a concrete representative of one of the global obstruction classes above. Such an identification could turn the three scoped polynomial obstructions into a structural global theorem, or explain why formal boundary lifting and fixed-degree polynomial lifting diverge.

---

## 18. Gate report

| Claim | Status |
|---|---|
| Three marked-state families survive | **certified** |
| Linear inverse-limit states exist for large \(d\) | **certified** |
| Global states meet the first generic-surjective open at three bidegrees | **certified** |
| Generic free polar operators are surjective for all \(m\) | **certified** |
| Fixed-degree tower terminates by order \(3d\) | **certified** |
| Isolation cutoff \(d+2m+1\) | **certified** |
| Nonzero terminal residual at \((1,7),(1,13),(3,19)\) | **certified, scoped** |
| Marked state gives a boundary map | **not proved** |
| Equivariant interpolation from projective endpoint data | **false without a common-character hypothesis** |
| Affine formal lifting | **proved** |
| Affine completion has the same formal-rational field as the full completion | **false** |
| Connectedness of the plane arrangement | **proved analytically** |
| Full-completion G3 algebraization | **valid conditionally** |
| Dominance of a nonconstant resulting equivariant rational map | **valid conditionally** |
| \(G\)-unirationality | **not proved** |

---

## 19. CAS ledger for this analytic audit

No new CAS computation was used to obtain the analytic findings in Parts II–III.

The repository-certified numerical and representation-theoretic statements cited in Part I come from the existing independently verified packets. The counterexamples, obstruction-theory statements, connectedness argument, and corrected conditional theorem are analytic.

Any future computation under G-A or G-C must be issued as a separate work order with an exact theorem boundary and an independent verifier.

---

## 20. Final status

Path G now has a clear division:

1. the **polynomial tower** has exact finite truncation and scoped terminal obstructions;
2. the proposed **analytic shortcut** fails at boundary realization and affine-to-global formal algebraization;
3. the **valid G3 theorem** begins only after a nonconstant global equivariant formal map on the full exceptional completion has been constructed.

The exact analytic target is therefore

\[
\boxed{
\text{construct }f_0:E\to X
\text{ and kill the global obstruction classes }o_n.
}
\]

Until that target or a genuine polynomial covariant is reached,

\[
\boxed{\text{Problem E remains OPEN.}}
\]
