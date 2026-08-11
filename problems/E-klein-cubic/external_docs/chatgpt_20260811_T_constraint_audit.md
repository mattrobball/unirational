# External audit (ChatGPT), 2026-08-11: exhaustive constraint list for landing tuples T

Source: https://chatgpt.com/share/6a7b559c-4814-83ea-8891-668fb1660cd9
("List constraints on T maps"). Extracted 2026-08-11 from the share page's
embedded stream by the director; inline `fileciteturnNN...` markers are the
source's own citation artifacts and were left in place. The share also
contained the model's intermediate reasoning summaries; only the user prompt
and the final answer are archived here.

Adjudication (director, 2026-08-11): checked against the sealed repository
state -- no conflicts found. The document's one pending dependency (its part
VIII.1 asks for the odd-residue-zero audit) was resolved the same day by
`goal_runs_20260811/ODDZERO_AUDIT`: verdict ARTIFACT, so that shortcut to
closing d = 35 is dead and the rest of the document is unaffected. The new
mechanisms it contributes are folded into
`theory/CONSTRAINT_ADDITIONS_20260811.md`.

---

## The prompt

In mattrobball/unirational, we have landed on the following strategy to narrow the potential shapes of maps for PSL(2,11) unirationality of the Klein cubic. Identify ALL constraints from the scheme map of the complexes of orbits with actions on a given T : P^4 --> P^4 landing in Klein of degree d. Identify all constraints for such T that would allow it to lift through the twisted stable birational equivalence with V_14, which is not G-unirational. 

Familiarize yourself with these. Then EXHAUSTIVELY list out all other constraints existing and potential we can throw at T.

---

## The answer

# Current theorem boundary

Let \(W\) be the five-dimensional Klein representation of

\[
G=\operatorname{PSL}(2,11),
\qquad
X=\{F=0\}\subset \mathbf P(W),
\]

where \(F\in \operatorname{Sym}^{3}W^\vee\) is the Klein cubic. A degree-\(d\) candidate is a primitive homogeneous tuple

\[
T=(T_0,\ldots,T_4)\in
M_d:=
\left(\operatorname{Sym}^{d}W^\vee\otimes W\right)^G,
\]

with

\[
F(T_0,\ldots,T_4)\equiv 0.
\]

It defines

\[
[T]\colon \mathbf P(W)\dashrightarrow X.
\]

Primitivity means that the \(T_i\) have no common polynomial factor. Dominance means that the only algebraic relation among the \(T_i\) is the Klein cubic, equivalently

\[
\ker\!\left(
\mathbf C[y_0,\ldots,y_4]\longrightarrow
\mathbf C[W],
\quad
y_i\longmapsto T_i
\right)
=(F).
\tag{0.1}
\]

Two corrections are essential.

First, a dominant map \(\mathbf P^4\dashrightarrow X^3\) has **one-dimensional generic fiber**. It is not generically finite. The Jacobian, relative-curve, and foliation constraints are therefore primary.

Second, the repository’s precise conclusion is not that \(V_{14}\) is “not \(G\)-unirational” without qualification. It is **not linearly \(G\)-unirational**, and there is no—even outer-twisted—\(G\)-equivariant rational map \(X\dashrightarrow V_{14}\). The **spin-unirationality** of \(V_{14}\) is the open face transported from the Klein problem. fileciteturn43file0L1-L10 fileciteturn54file0L1-L2

The latest degree boundary is

\[
\boxed{\mathscr T_d=\varnothing\quad\text{for }d\le 34.}
\]

The first surviving necessary linear/profile slice is now

\[
\boxed{d=35,\qquad (m,r)=(1,6),\qquad n=d-r=29,}
\]

of dimension at most \(39\) before imposing the full nonlinear landing equations and dominance. This is not an existence result. The degree-\(34\) slice was reduced

\[
576\longrightarrow316\longrightarrow16\longrightarrow2\longrightarrow0
\]

by the plus-plane, \(V_4\)-line, minus-line, and \(C_3\)-eigenline conditions. fileciteturn72file0L1-L2

I will use three levels throughout:

1. **Orbit-complex constraints:** constraints on the decorated strata and their order-zero images.
2. **Tuple constraints:** conditions that one global element \(T\in M_d\) must satisfy simultaneously.
3. **Graph/torsor constraints:** conditions on the actual normalized graph, its generic fiber, its restriction to \(X\), and the twisted \(V_{14}\) correspondence.

The main danger is treating a permissible level-1 pattern as though it were realized at levels 2 or 3.

---

# I. Complete constraint content of the orbit-complex map

## 1. The global algebraic conditions

Every actual \(T\) satisfies the following before any fixed-locus analysis.

### 1.1 Exact equivariance

Because \(G\) is perfect, there is no character twist:

\[
T(gv)=gT(v),
\qquad
T\in M_d.
\tag{1.1}
\]

### 1.2 Global landing identity

The five coordinate forms must satisfy the polynomial identity

\[
F(T)\equiv 0
\tag{1.2}
\]

in degree \(3d\). This is stronger than landing modulo \(F(x)\), stronger than obtaining a selfmap of \(X\), and stronger than satisfying the identity on selected fixed strata.

### 1.3 Primitivity

\[
\gcd(T_0,\ldots,T_4)=1.
\tag{1.3}
\]

Thus the ambient base locus has codimension at least two. A common divisor appearing only after restriction to \(X\) is a separate phenomenon discussed below.

### 1.4 Exact image condition

Dominance is equivalent to (0.1). A tuple can satisfy \(F(T)=0\) while having image a surface, curve, point, or a proper subvariety of \(X\).

### 1.5 Global degree coherence

All local orders, normal jets, transverse characters, and component maps must arise from one homogeneous degree-\(d\) tuple. Local choices cannot be made independently.

---

## 2. What the Stage-1 complex actually classifies

The source terminus has 80 \(G\)-orbits of strata, 11,076 components, and 145 closure relations. The target complex has ten geometric cell types. The Stage-1 packet classifies order-zero decorated boundary patterns satisfying the fixed-locus, residual-action, closure, and evaluation constraints. It explicitly does **not** classify global covariants or actual maps. The coherent count

\[
1\,088\,847\,395\,778\,723\,840\,000
\]

is a count of permissible order-zero boundary patterns, not a count of maps. fileciteturn38file0L1-L2

Its complete constraint content can be expressed as follows.

### 2.1 Pointwise stabilizer constraint

If a source stratum has pointwise stabilizer \(H\), every defined value must lie in

\[
X^H.
\tag{2.1}
\]

If \(X^H=\varnothing\), the source stratum is necessarily contained in the base locus unless an exceptional valuation lowers the generic pointwise stabilizer.

### 2.2 Setwise stabilizer and residual-action constraint

If a component \(S\) has setwise stabilizer \(N\), then its image component and its map must be equivariant for the residual action

\[
N/H.
\tag{2.2}
\]

This pairs components, forces orbit sizes, rules out arbitrary choices among fixed points, and distinguishes pointwise from setwise stabilizers.

### 2.3 Dimension and genus constraint

A rational source curve cannot dominate an elliptic target. More generally, the dimension and birational type of the source component bound the possible target component and the degree of the component map.

This is why many involution-fixed exceptional curves can map onto \(L_\sigma\), but cannot sweep \(E_\sigma\).

### 2.4 Closure constraint

If \(S'\subset\overline S\), then the image of \(S'\) must lie in the closure of the image of \(S\), with compatible residual action and component specialization.

This is stronger than checking each row independently.

### 2.5 Free-stratum dominance

The free source stratum must map dominantly to the free target cell \(X\). Permissible boundary data without a dominant free-stratum map is not an admissible map profile.

### 2.6 Directional and normal-character compatibility

At a flag \(S'\subset\overline S\), the normal character of the source direction determines the target eigenspace in which the leading normal term may land.

### 2.7 Evaluation coherence

When several boundary rows arise by restricting one component of a global section, their values must belong to the image of a **single joint evaluation map**. Stage 1 found many locally admissible tuples that are not in that image.

This locks eight sweeps, rigidifies 12 of 18 \(V_4\)-rows, and eliminates most componentwise combinations that pass only arc consistency.

### 2.8 Model boundary

Only the two named divisors over the involution plus-plane and minus-line are forced on every common equivariant refinement. Most codimension-two rows depend on factoring through the chosen wonderful/terminus model. A proof using those rows must either work on that model or show invariance under further birational modifications. fileciteturn38file0L1-L2

---

## 3. Complete receiver fixed-locus dictionary

The target fixed loci for all subgroup conjugacy classes are now known. The table below contains the target-side possibilities that every source row must respect.

| \(H\) | \(X^H\) | Consequence |
|---|---|---|
| \(1\) | \(X\) | Free stratum must dominate \(X\). |
| \(C_2=\langle\sigma\rangle\) | \(E_\sigma\sqcup L_\sigma\) | \(E_\sigma\) is a non-CM elliptic cubic; \(L_\sigma\simeq\mathbf P^1\). Rational source curves cannot sweep \(E_\sigma\). |
| \(C_3\) | six points | Two are \(C_6\)-points and four have exact stabilizer \(C_3\). The isolated \(D_{12}\)-fixed source eigenpoint is off \(X\). |
| \(V_4\) | six points | Three type-I and three type-II points, each forming a free residual \(C_3\)-orbit. Global incidence constraints permit only type I on the relevant actual rows. |
| \(C_5\) | four points | Residual \(C_2\) gives two free two-orbits. |
| \(C_6\) | two points | Both lie on an involution minus-line and are exchanged by the residual \(C_2\). |
| \(C_{11}\) | five points | One residual \(C_5\)-orbit. |
| both \(S_3\) classes | \(\varnothing\) | Any corresponding fixed source point is a base point. |
| \(D_{10}\) | \(\varnothing\) | The \(D_{10}\)-points are base points in every degree. |
| \(A_4\) | \(\varnothing\) | The two \(A_4\)-character points are off \(X\). |
| \(D_{12}\) | \(\varnothing\) | Every \(D_{12}\)-point is a base point. |
| \(C_{11}\!:\!C_5\), both \(A_5\) classes, \(G\) | \(\varnothing\) | Corresponding fixed source loci cannot carry defined values. |

The global point orbits on \(X\) are

\[
165_{\mathrm{I}}+165_{\mathrm{II}}+110_{C_6}
+220_{C_3}+132_{C_5}+132_{C_5}+60_{C_{11}}.
\]

The residual normalizer actions on each row are also determined. fileciteturn69file0L1-L2

---

## 4. Nontrivial forced row outcomes

After imposing the preceding rules and the closure/evaluation data, the important positive-dimensional outcomes are:

1. The exceptional divisor over every involution plus-plane \(P_\sigma\) maps **onto** \(L_\sigma\).

2. The exceptional divisor over every involution minus-line \(L_\sigma\) maps **onto** \(L_\sigma\).

3. The central involution-fixed line over a \(D_{12}\)-point also maps **onto** \(L_\sigma\).

4. The relevant \(C_2/V_4\) rows can land on \(L_\sigma\) or a type-I point, but not on a type-II point.

5. The relevant \(C_2/C_6\) rows can land on \(L_\sigma\) or one of the two \(C_6\)-points.

6. Exact-\(C_3\) rows range over the six \(C_3\)-fixed points; rows with setwise \(C_6\)-symmetry range only over the two \(C_6\)-points.

7. \(V_4\)-rows are forced into type-I points. The type-II target is globally excluded despite being locally present in \(X^{V_4}\).

8. \(C_5\), \(C_6\), and \(C_{11}\) rows have respectively four, two, and five target values before the global degree and jet constraints are added.

9. The exceptional \(C_2\)-line over a \(D_{10}\)-point originally had 23 order-zero values. The degree/weight refinement splits these into an elliptic-side branch of 13 values and a line-side branch of 10 values; a fixed map belongs to only one branch. fileciteturn38file0L1-L2 fileciteturn51file0L1-L2

---

# II. Degree, weight, multiplicity, and higher-jet constraints

## 5. Master character formula

Let a cyclic element of order \(N\) act on a source eigenline with projective weight \(a\), and let the normal variables have weights \(c_\ell\). If the first nonzero local term of \(T\) has normal multiorder \(\mu_\ell\), its target weight is

\[
\boxed{
w\equiv da+\sum_\ell\mu_\ell c_\ell\pmod N.
}
\tag{5.1}
\]

If the corresponding target eigenspace misses \(X\), the term vanishes. If the relevant target fixed locus is finite, the local map is forced to be constant or base.

This formula supplies constraints invisible to the order-zero complex. fileciteturn39file0L1-L2

---

## 6. Involution constraints

For every involution \(\sigma\),

\[
W=W_\sigma^+\oplus W_\sigma^-,
\qquad
\dim W_\sigma^+=3,\quad \dim W_\sigma^-=2.
\]

The installed constraints are:

\[
P_\sigma=\mathbf P(W_\sigma^+)\subset\operatorname{Bs}(T)
\quad\text{for all }d;
\tag{6.1}
\]

\[
\operatorname{ord}_{P_\sigma}(T^-)\equiv1\pmod2;
\qquad
\operatorname{ord}_{P_\sigma}(T^+)\equiv0\pmod2
\quad\text{and is at least }2;
\tag{6.2}
\]

\[
\operatorname{ord}_{L_\sigma}(T)\equiv d+1\pmod2.
\tag{6.3}
\]

Consequently, when \(d\) is even,

\[
L_\sigma\subset\operatorname{Bs}(T)
\quad\text{for all 55 involutions}.
\tag{6.4}
\]

For odd \(d\), the minus-line order is even and may be zero; this is exactly the escape that leaves \(d=35\) open after \(d=34\) dies. fileciteturn39file0L1-L2 fileciteturn72file0L1-L2

---

## 7. Odd-order fixed-point and eigenline constraints

### 7.1 \(C_{11}\)

Let

\[
Q=\{1,3,4,5,9\}\subset\mathbf Z/11
\]

be the quadratic-residue weight set of \(W\).

All five \(C_{11}\)-fixed points are base points whenever

\[
d\bmod11\notin Q.
\tag{7.1}
\]

The four-row simultaneous-value condition is possible only under the precise congruences

\[
d\in Q,\qquad
\mu\equiv0\ \text{or}\ d\pmod{11}.
\tag{7.2}
\]

For nonresidue \(d\), at most three of the four values can occur; for \(11\mid d\), at most two.

### 7.2 \(C_5\)

All four \(C_5\)-fixed points are base points when

\[
5\mid d.
\tag{7.3}
\]

The ten coherence-immune \(C_5\)-rows are globally coupled to one pattern rather than ten independent choices.

### 7.3 \(C_3\)

Both \(C_3\)-eigenline families lie in the base locus when

\[
3\mid d.
\tag{7.4}
\]

When \(3\nmid d\), each eigenline is contracted to the \(C_6\)-fixed value dictated by (5.1). The eight previously immune rows reduce from six choices each to three.

### 7.4 \(C_6\)

For the two \(C_6\)-points,

\[
d\equiv1\pmod6
\quad\Longrightarrow\quad
\text{the pair is fixed pointwise},
\]

\[
d\equiv5\pmod6
\quad\Longrightarrow\quad
\text{the pair is exchanged},
\]

and for

\[
d\equiv0,2,3,4\pmod6
\]

both points are base. fileciteturn39file0L1-L2

---

## 8. Full-flag degree coherence and saturation

The degree \(d\) enters the Stage-1 order-zero \(\sigma\)-band directly through exactly two rows: the divisors over \(P_\sigma\) and \(L_\sigma\). These are the only rows whose slot dimensions exhaust all five dimensions of \(W\). On those two rows the transverse character is forced to be trivial and the slot degrees sum to \(d\).

For every other row, the Stage-1 character \(\psi\) absorbs transverse degrees that were not explicitly recorded. Forcing \(\psi=1\) there is invalid.

The joint evaluation images are now proved to saturate at multidegree threshold

\[
\Theta=6.
\tag{8.1}
\]

Thus the Stage-1 coherent count is genuinely an all-multidegree count.

The degree-indexed \(\sigma\)-band factors are

\[
K(0\bmod6)=10\,752,
\qquad
K(2\bmod6)=K(4\bmod6)=672.
\tag{8.2}
\]

The current computation returns \(K=0\) for odd residues, but that conclusion is explicitly **not yet a theorem**. The independent `ODDZERO_AUDIT` is required before it may be used. Since \(35\equiv5\pmod6\), this audit is potentially decisive for the present first window. fileciteturn51file0L1-L2 fileciteturn66file0L1-L2

---

## 9. \(A_4\)-point multiplicity and second-order jets

At either \(A_4\)-point,

\[
W|_{A_4}=\omega\oplus\omega^2\oplus\Theta,
\]

where \(\Theta\) is the three-dimensional irreducible representation. If

\[
\mu=\operatorname{mult}_q(T)
\]

and \(\Phi_\mu\) is the first nonzero normal jet, then

\[
\Phi_\mu(\psi_h w)=\omega(h)^{-d}h\Phi_\mu(w),
\qquad
F(\Phi_\mu(w))=0.
\tag{9.1}
\]

The exact current table is:

| \(\mu\) | Consequence on each immune \(C_3\)-row |
|---:|---|
| \(1\) | Impossible. |
| \(2\) | No target value; the row is base. |
| \(3\) | The \(C_6\)-point is excluded; the two exact-\(C_3\) points survive. |
| \(4\) | No target value; the row is base. |
| \(5\) | All three values survive. |

Thus

\[
\mu\in\{2,4\}\Rightarrow 3^8\mapsto1,
\qquad
\mu=3\Rightarrow3^8\mapsto2^8,
\]

while \(\mu=5\) leaves \(3^8\) unchanged. There is no unconditional collapse because \(\mu\) is not globally pinned, and orders \(\mu\ge6\) have not been classified. fileciteturn52file0L1-L2

The missing constraint is not another rowwise computation: it is **shared-\(\mu\) global coupling**. The multiplicity is constant on each complete \(G\)-orbit and must be compatible with the V4-line profile, the \(C_3\)-eigenline contractions, and the degree-\(d\) global jet image.

---

## 10. \(C_{11}\)-point multiplicity and the 60-line orbit

At a \(C_{11}\)-point,

\[
\mu\le d
\tag{10.1}
\]

always. If one of the ten \(C_{11}\)-coordinate lines is not in the base locus, then

\[
2\mu\le d.
\tag{10.2}
\]

Under the stated no-fixed-component hypothesis on a \(C_{11}\)-coordinate plane,

\[
d^2\ge 3\mu^2+55e^2.
\tag{10.3}
\]

At \(\mu=1\), the leading form has rank at most two, so at most two of the four \(C_{11}\)-rows can carry values, and in seven residue classes only one can.

There is also a newly identified \(G\)-orbit of 60 lines on \(X\) joining selected pairs of \(C_{11}\)-fixed points. These lines supply additional incidence and restriction constraints not yet integrated into the global profile sieve. fileciteturn52file0L1-L2

---

## 11. V4-line profile and corrected normal-jet bounds

Every candidate has a global profile

\[
(r;m,m,m)
\]

along a \(V_4\)-line, with

\[
m\ \text{odd},
\qquad
r\ge\frac{3m+1}{2}.
\tag{11.1}
\]

Write

\[
e=r-m,
\qquad
n=d-r.
\]

The corrected own-point normal-jet condition is

\[
n\ge2e,
\qquad\text{equivalently}\qquad
d\ge3r-2m.
\tag{11.2}
\]

For the line datum \(\Lambda\),

\[
\operatorname{ord}_{c_\sigma}\Lambda\ge2e,
\tag{11.3}
\]

\[
\lambda_{2e}\in V[\operatorname{sgn}^{e}],
\tag{11.4}
\]

\[
\lambda_{2e+1}\in\operatorname{Im}(\operatorname{ev}_{v_0}).
\tag{11.5}
\]

The order \(2e\) is attached to the pair \((\sigma,c_\sigma)\). It does **not** mean that one fixed \(\sigma\)-datum vanishes to order \(2e\) at all three \(D_{12}\)-points. The old bound

\[
d\ge7r-6m
\]

is withdrawn. fileciteturn64file0L1-L2

For the present first open profile,

\[
d=35,\qquad m=1,\quad r=6,\quad e=5,\quad n=29,
\]

so the own-point line datum has order at least \(10\).

---

## 12. The exact current \(d=35\) signature

Since

\[
35\bmod(2,3,5,6,11)=(1,2,0,5,2),
\]

every degree-\(35\) candidate must satisfy:

1. all 55 plus-planes are in the base locus;
2. the minimal open V4 profile is \((m,r)=(1,6)\);
3. all \(C_5\)-fixed points are base points because \(5\mid35\);
4. all \(C_{11}\)-fixed points are base points because \(2\) is a nonresidue modulo \(11\);
5. each \(C_3\)-eigenline is contracted to its forced \(C_6\)-value because \(3\nmid35\);
6. the two \(C_6\)-points are exchanged because \(35\equiv5\pmod6\);
7. each \(A_4\)-point has multiplicity at least two and is subject to the table in §9;
8. the minus-lines are not automatically in the base locus, because their order is even;
9. the flagged odd-residue Stage-1 computation would kill the window, but is not yet usable;
10. the surviving linear/profile space has dimension at most \(39\), before \(F(T)=0\) and dominance.

This is the smallest current finite problem.

---

# III. Constraints from restricting \(T\) to \(X\)

## 13. Common factor and induced selfmap

Restrict \(T\) to \(X\). There may be a common divisor on \(X\):

\[
T|_X=h\,T',
\qquad
h\in H^0(X,\mathcal O_X(k))^G.
\tag{13.1}
\]

The induced primitive map

\[
\varphi=[T']\colon X\dashrightarrow X
\]

has coordinate degree

\[
d'=d-k.
\]

The invariant-factor constraint is

\[
k=0\quad\text{or}\quad k\ge5.
\tag{13.2}
\]

Thus every \(T\) splits into two branches:

- **no restricted common factor**, \(k=0\);
- **surface-factor branch**, \(k\ge5\), where \(D_X=(h=0)\subset X\) becomes part of the Hodge/Rees geometry.

The normalized graph of \(\varphi\) is three-dimensional and its target map is generically finite of some degree \(\delta\).

---

## 14. Excess-intersection constraints

After principalizing the restricted base ideal, the selfmap degree satisfies an excess formula of the form

\[
3\delta
=
3d'^3-3d'\zeta-e,
\tag{14.1}
\]

or

\[
\delta=d'^3-d'\zeta-a,
\tag{14.2}
\]

where the correction terms are nonnegative Segre/excess contributions determined by the actual base scheme.

There are also Bézout-capacity inequalities such as

\[
\sum_Z \operatorname{mult}_Z(J)\deg Z\le d'^c
\tag{14.3}
\]

in codimension \(c\). These must be evaluated on complete \(G\)-orbits, not on isolated centers. fileciteturn40file0L1-L2

---

## 15. CLEAN versus CARRIER

Let

\[
V=H^3(X,\mathbf Q)(1).
\]

The restricted normalized graph yields the dichotomy:

- **CARRIER:** a proper support of dimension at most one in the restricted base locus carries a nonzero copy of \(\operatorname{Res}_H V\);
- **CLEAN:** the full-support correspondence satisfies

\[
u_\varphi^\dagger u_\varphi=\delta\,\operatorname{id}_V.
\tag{15.1}
\]

Since

\[
\operatorname{End}_{G\text{-HS}}(V)
=
\mathbf Q(\sqrt{-11}),
\]

the CLEAN branch forces

\[
\boxed{\delta=x^2+xy+3y^2.}
\tag{15.2}
\]

A nonrepresented \(\delta\) forces CARRIER; it does not by itself exclude \(T\). fileciteturn41file0L1-L10

The actual-landing transfer theorem sharpens this:

- if \(D_X=0\), then CARRIER occurs;
- CLEAN can escape only through a surface component of \(D_X\);
- leakage to full support can occur only in perverse degree zero through a block

\[
IC_S(\mathcal U)(-1),
\]

and only the constant quotient of \(\mathcal U\) leaks;
- for \(5\le k\le10\), every component of \(D_X\) is individually \(G\)-stable;
- its normalized resolution must carry the full \(E_{-11}^{\,5}\)-isotypic Hodge factor. fileciteturn42file0L1-L10

---

# IV. Normalized-Rees and ambient Hodge constraints

## 16. Ambient normalized graph

Let

\[
I_T=(T_0,\ldots,T_4),
\qquad
Y_T=
\operatorname{Proj}_{\mathbf P^4}
\overline{\mathcal R(I_T)}.
\]

Then

\[
p:Y_T\to\mathbf P^4,
\qquad
q:Y_T\to X
\]

are the canonical source and target maps. The dominant transform of \(X\) in \(Y_T\), after normalization, is the normalized graph of the restricted selfmap. Thus ambient and restricted constraints apply to the **same actual tuple**, not to unrelated formal ideals. fileciteturn46file0L1-L13

---

## 17. Ambient Hodge-support constraint

There is a canonical injection

\[
H^3(X,\mathbf Q)
\hookrightarrow
IH^3(Y_T,\mathbf Q).
\tag{17.1}
\]

Because \(H^3(\mathbf P^4)=0\), the actual copy of \(V\) must enter the perverse filtration through at least one proper strict support

\[
S\subset\operatorname{Bs}(I_T),
\qquad
\dim S\le2.
\tag{17.2}
\]

For \(H=\operatorname{Stab}_G(S)\),

\[
\operatorname{Hom}_{\mathrm{HS},H}
\left(
\operatorname{Res}_H V,\,
H^{-1-j_0}
(\mathbf P^4,\mathcal M_{S,j_0})(1)
\right)
\ne0.
\tag{17.3}
\]

The resulting abelian factor contains a nonzero \(E_{-11}\)-isotypic component. This Hodge information may lie in fiber cohomology and monodromy, not in the ordinary Albanese of \(S\). fileciteturn49file0L1-L2

---

## 18. Rees-valuation and carrier constraints

For a divisorial valuation \(v\) centered on \(Z\), let

\[
L_v=
\mathbf C(Z)
\left(
\overline{T_i/T_j}
\right)
\subset\kappa(v),
\]

where \(T_j\) has minimal \(v\)-order. If \(K_v\) is the corresponding center on the normalized graph, then

\[
\dim K_v
=
\operatorname{trdeg}_{\mathbf C}L_v.
\tag{18.1}
\]

Consequences:

1. A point-centered divisor survives as a Rees divisor only when its initial target image is two-dimensional.

2. Point-centered line-, elliptic-, or curve-valued divisors are contracted.

3. A surviving \(V_4\)-stable point-centered Rees divisor has faithful generic \(V_4\)-action and maps generically finitely to a \(V_4\)-stable surface.

4. The ordinary carrier over \(E_\sigma\) is line-valued: its first nonzero ordinary normal term maps to \(L_\sigma\), not back to \(E_\sigma\).

5. Any elliptic-target carrier is necessarily secondary: a curve component of a normalized fiber or a fixed slice inside a surface-valued divisor.

6. Carrier profiles are finite for one fixed ideal, but no uniform finite list over all landing ideals has been proved. fileciteturn48file0L1-L2

At a type-II \(V_4\)-point, the local restricted ideal satisfies

\[
I_P\subset(bc,bd,cd),
\]

and a quadratic initial tuple has coefficients

\[
\alpha\,cd,\qquad\beta\,bd,\qquad\gamma\,bc
\]

with the landing condition

\[
\boxed{\alpha\beta\gamma=0.}
\tag{18.2}
\]

The remaining objects are curve components of normalized point fibers and fixed slices inside surface carriers, not line-valued Rees divisors. fileciteturn45file0L1-L2

---

# V. What “lifting through the twisted \(V_{14}\) equivalence” actually means

## 19. Stable equivalence and the spin factor

The stable relation has the form

\[
V_{14}\times\mathbf P^2\times\mathbf P(U)
\dashrightarrow
X\times\mathbf P^2\times\mathbf P(U),
\tag{19.1}
\]

where \(U\) is the six-dimensional spin representation of the Schur cover. The action on \(\mathbf P(U)\) is projective, not induced by an honest linear \(G\)-representation.

Given a dominant \(T\), one obtains over \(\mathbf C\)

\[
\mathbf P(W)\times\mathbf P^2\times\mathbf P(U)
\dashrightarrow
X\times\mathbf P^2\times\mathbf P(U)
\dashrightarrow
V_{14}.
\tag{19.2}
\]

Because the first map is dominant, its image meets the domain of the inverse stable birational correspondence. Thus the stabilized rational lift exists generically after resolving indeterminacy.

The folding lemma then dominates the product source by a single **spin** projective source. Therefore

\[
X\text{ linearly }G\text{-unirational}
\Longrightarrow
V_{14}\text{ spin-}G\text{-unirational}.
\tag{19.3}
\]

There is no implication that \(V_{14}\) becomes linearly \(G\)-unirational. fileciteturn60file0L1-L2

So over \(\mathbf C\), “liftability through the stable equivalence” is not an extra generic condition on \(T\). The constraints arise when one demands:

1. an explicit single-source spin covariant;
2. compatibility with the exceptional loci of the stable correspondence;
3. a lift on twisted forms over nonclosed fields;
4. descent and Brauer compatibility.

---

## 20. Twisted form and Brauer obstruction

For a \(G\)-torsor \(\tau\) over a field \(K\), twisting (19.1) gives

\[
(V_{14})_\tau\times\mathbf P^2\times SB_\tau
\dashrightarrow
X_\tau\times\mathbf P^2\times SB_\tau,
\tag{20.1}
\]

where \(SB_\tau\) is a Severi–Brauer fivefold with class

\[
\beta_\tau\in\operatorname{Br}(K)[2].
\]

For the generic versal torsor,

\[
\beta_\tau\ne0,
\qquad
SB_\tau(K)=\varnothing.
\tag{20.2}
\]

Thus both stabilized products are pointless and Lang–Nishimura transfers no rational point. On the liftable locus

\[
\beta_\tau=0,
\]

the Severi–Brauer variety splits and points cross both ways. fileciteturn60file0L1-L2

Therefore an actual twisted point-lift requires one of:

1. \(\beta_\tau=0\);
2. a specified splitting field and a descent argument;
3. an index-reduction mechanism compatible with the generic fiber;
4. a zero-cycle argument strong enough to descend a point.

The stable birational equivalence alone supplies none of these for the generic torsor.

---

## 21. Necessary certificate for an explicit spin lift

An explicit lift associated with \(T\) would have to include a spin representation \(D\) and a dominant map

\[
\Psi_T:\mathbf P(D)\dashrightarrow V_{14}
\tag{21.1}
\]

satisfying all of the following.

### 21.1 Central-character condition

\(D\) must have spin central character. A faithful linear source cannot simply absorb the \(\mathbf P(U)\)-factor without flipping to the spin side.

### 21.2 Even coordinate degree

Every equivariant spin map to \(V_{14}\) has even coordinate degree. This is a condition on the induced map \(\Psi_T\), **not** on the original degree \(d\) of \(T\).

### 21.3 Plücker and linear-section equations

In the model

\[
V_{14}=\operatorname{Gr}(2,U)\cap\mathbf P(M)\subset\mathbf P^9,
\]

the coordinates of \(\Psi_T\) must satisfy all Plücker/decomposability quadrics and the linear-section condition defining \(\mathbf P(M)\).

### 21.4 Primitivity and dominance

The spin tuple must not vanish identically on \(V_{14}\), have no removable common content, and have image of dimension three.

### 21.5 Indeterminacy compatibility

The graph of \(T\times\operatorname{id}\) must meet the dominant component of the stable correspondence. Any exceptional divisor mapped into the correspondence’s indeterminacy locus must be accounted for on a common equivariant resolution.

### 21.6 Spin fixed-network constraints

The induced spin map must respect:

- the 110 involution eigenplanes;
- their 1,980 incidences;
- the 352 distinct incidence points;
- the 12 additional \(F_{55}\)-points;
- the resulting 364-point mandatory base locus;
- the \(V_4/Q_8\) central-character obstruction;
- all residual normalizer actions.

### 21.7 Spin Hodge-support constraints

The actual \(H^3(V_{14})(1)\), which is the same rational \(G\)-module \(V\), must enter a proper strict-support block of the spin source graph. It must carry the \(E_{-11}^{\,5}\) Hodge type.

The repository has shown that the current spin Hodge-support census is **method-insufficient**: every support cell has a total-degeneration witness. Hence the lift must be attacked through the map, not merely through an abstract support decomposition. The three remaining map-level channels are:

1. fiber-degree bounds over mandatory points;
2. branched or singular finite covers of ample divisors carrying \(E_{-11}\);
3. nonconstant eigen-stratum local systems. fileciteturn54file0L1-L2

### 21.8 Quotient-torsor compatibility

On the free loci, the equivariant square is cartesian. Therefore the generic \(G\)-torsor associated with the source quotient is the pullback of the target generic torsor. Every cohomological invariant of the generic \(G\)-torsor, especially the spin Schur–Brauer class, must pull back compatibly.

### 21.9 Galois descent

Any construction performed after splitting \(\beta_\tau\) must carry a descent datum satisfying the cocycle condition. A quadratic splitting argument without this descent datum is not a lift over the original field.

### 21.10 Outer-automorphism compatibility

The two five-dimensional target slots are complex conjugates and are exchanged by the outer automorphism. A stable lift must specify which slot appears and how the correspondence acts on the \(G\)-action.

---

## 22. Constraints coming from maps \(V_{14}\dashrightarrow X\)

There is a nonconstructive \(G\)-equivariant rational map

\[
V_{14}\dashrightarrow X,
\]

but it does not provide a direct obstruction to \(T\). Conversely, there is no \(G\)-equivariant rational map \(X\dashrightarrow V_{14}\).

The explicit covariant calculation now proves that neither five-dimensional target slot admits a map

\[
V_{14}\dashrightarrow X
\]

defined by forms of degree at most five. Any explicit realization of the nonconstructive map must use a linear system

\[
|eH|,
\qquad e\ge6.
\tag{22.1}
\]

This constrains any chosen explicit stable correspondence or reverse map, but it does **not** imply \(d\ge6\), \(6\mid d\), or any direct numerical restriction on the degree of \(T\). fileciteturn53file0L1-L2

---

# VI. All additional independent constraints available to impose on \(T\)

The following list is exhaustive at the level of distinct mechanisms. Some are already partially present in the repository; others are immediate formal consequences of the existence of \(T\); the remaining ones require a new theorem or computation.

## A. Global covariant and landing-scheme constraints

### 23. The full global jet-evaluation map

For every fixed degree \(d\), construct one map

\[
\operatorname{Ev}^{(\le N)}_d:
M_d
\longrightarrow
\prod_{\mathcal O}
J^{\le N}_{S_{\mathcal O}}
\bigl(\mathcal O_{\mathbf P(W)}(d)\otimes W\bigr)
\tag{23.1}
\]

over representatives of **all** source-stratum orbits.

The actual allowed local profiles are the image of this one map—not the product of the images of separate rowwise maps.

This simultaneously enforces:

- shared multiplicities on complete \(G\)-orbits;
- the common \(D_{10}\)-branch;
- shared \(A_4\)-multiplicity \(\mu\);
- shared \(C_{11}\)-multiplicity;
- compatibility at every incidence flag;
- full transverse degree, not merely the residual character \(\psi\);
- all-order closure compatibility.

For \(d=35\), this should be computed first on the current at-most-39-dimensional slice.

### 24. The exact landing scheme

Define the cubic polynomial map

\[
\Phi_d:
M_d\longrightarrow
\left(\operatorname{Sym}^{3d}W^\vee\right)^G,
\qquad
T\longmapsto F(T).
\tag{24.1}
\]

On the current linear slice \(L_{35}\subset M_{35}\), compute

\[
\mathscr L_{35}
=
V\!\left(\Phi_{35}|_{L_{35}}\right)
\subset\mathbf P(L_{35}).
\tag{24.2}
\]

This is the exact nonlinear problem. It avoids expanding all degree-\(105\) monomials by working in the invariant target basis.

The required certificate is one of:

- the ideal is the unit ideal, proving \(d=35\) empty;
- every component lies in the content locus;
- every component is nondominant;
- a component survives and yields an explicit map.

### 25. Tangent and obstruction spaces of the landing scheme

At a candidate \(T\), an infinitesimal deformation \(S\in M_d\) must satisfy

\[
d\Phi_{d,T}(S)
=
\sum_{i=0}^{4}
\frac{\partial F}{\partial y_i}(T)\,S_i
=0.
\tag{25.1}
\]

Second-order deformation is constrained by

\[
\sum_{i,j}
\frac{\partial^2F}{\partial y_i\partial y_j}(T)
S_iS_j
+
2\sum_i
\frac{\partial F}{\partial y_i}(T)R_i
=0.
\tag{25.2}
\]

Computing these spaces distinguishes:

- reduced isolated solutions;
- nonreduced phantom components;
- components arising only by multiplication with invariants;
- genuinely deformable landing families.

### 26. Full polar/Hessian identities

Differentiating \(F(T)=0\) with respect to source variables gives

\[
\nabla F(T)\,J_T=0.
\tag{26.1}
\]

Differentiating again gives, for tangent vectors \(u,v\),

\[
H_F(T)\bigl(dT(u),dT(v)\bigr)
+
\nabla F(T)\cdot d^2T(u,v)
=0.
\tag{26.2}
\]

Since \(F\) is cubic, one obtains a finite tower of explicit polar identities. These should be imposed on the fixed-stratum jets before attempting algebraization.

### 27. “Only one relation” elimination test

Landing gives \((F)\subseteq\ker(y_i\mapsto T_i)\). Dominance requires equality. Compute the elimination ideal

\[
\ker\!\left(
\mathbf C[y_0,\ldots,y_4]\to\mathbf C[W]
\right).
\tag{27.1}
\]

Any second relation immediately proves that the image has dimension at most two or lies in a proper subvariety of \(X\).

### 28. Special-fiber algebra constraint

Let \(I_T=(T_0,\ldots,T_4)\). Dominance onto \(X\) forces the special-fiber algebra, after regrading, to be

\[
\mathcal F(I_T)
\simeq
\mathbf C[y_0,\ldots,y_4]/(F).
\tag{28.1}
\]

Therefore it must be:

- four-dimensional;
- Cohen–Macaulay;
- Gorenstein;
- degree three;
- of Hilbert series

\[
\frac{1-z^3}{(1-z)^5}.
\tag{28.2}
\]

Equivalently, the analytic spread of \(I_T\) is exactly four. Any candidate ideal with analytic spread at most three or with extra fiber equations is nondominant.

### 29. Equivariant syzygy constraints

The minimal free resolution of \(I_T\) is \(G\)-equivariant. Every syzygy module must decompose into allowable \(G\)-representations.

The Rees ideal

\[
\mathcal J_T\subset
\mathbf C[x_0,\ldots,x_4,y_0,\ldots,y_4]
\]

must satisfy

\[
\mathcal J_T\cap\mathbf C[y_0,\ldots,y_4]=(F).
\tag{29.1}
\]

One should compute:

- linear syzygies;
- Jacobian/polar syzygies from (26.1);
- moving quadrics and cubics;
- the relation type and reduction number;
- whether the ideal is of fiber type.

### 30. Covariant module over the invariant ring

Instead of treating each \(M_d\) separately, compute the graded module

\[
\mathcal M
=
\bigoplus_{d\ge0}
\left(\operatorname{Sym}^dW^\vee\otimes W\right)^G
\]

over

\[
R=\operatorname{Sym}(W^\vee)^G.
\]

Minimal generators and relations would identify:

- degrees that are merely invariant multiples of lower-degree tuples;
- genuinely new primitive covariant classes;
- possible all-degree recurrences;
- the effect of postcomposition by selfmaps.

---

## B. Differential and generic-fiber constraints

### 31. Generic Jacobian-rank constraint

On the domain of definition,

\[
\operatorname{rank}d[T]\le3.
\]

Dominance onto \(X\) requires

\[
\operatorname{rank}d[T]=3
\quad\text{generically}.
\tag{31.1}
\]

Equivalently, the affine Jacobian \(J_T\) has generic rank four after accounting for the radial directions.

Thus a surviving landing solution must pass a determinantal saturation test: its rank-three projective minors cannot vanish identically outside the base locus.

### 32. Kernel foliation

The generic kernel

\[
\mathcal F_T=\ker\left(
d[T]:T_{\mathbf P^4}\dashrightarrow[T]^*T_X
\right)
\tag{32.1}
\]

is a rank-one algebraic foliation whose leaves are the generic fibers of \(T\).

This foliation must be:

- \(G\)-invariant;
- compatible with every fixed stratum and normal character;
- integrable;
- singular along a \(G\)-stable determinantal scheme;
- compatible with the base-ideal resolution.

On a resolution \(p:Z\to\mathbf P^4\), one can compute its saturated line bundle from

\[
0\to T_{Z/X}\to T_Z\to q^*T_X
\]

together with the degeneracy torsion. Chern-class and Baum–Bott/Thom–Porteous calculations can then constrain its singular scheme.

This entire package is presently missing from the orbit-complex program.

### 33. Relative-canonical and generic-fiber genus identity

Let

\[
p:Z\to\mathbf P^4,\qquad q:Z\to X
\]

resolve \(T\). Write

\[
H=p^*\mathcal O_{\mathbf P^4}(1),
\]

\[
q^*H_X=dH-\sum_E m_EE,
\tag{33.1}
\]

and

\[
K_Z=-5H+\sum_E a_EE.
\tag{33.2}
\]

Because \(K_X=-2H_X\),

\[
\boxed{
K_{Z/X}
=
(2d-5)H
+
\sum_E(a_E-2m_E)E.
}
\tag{33.3}
\]

For the smooth geometric generic fiber \(C\),

\[
2g(C)-2
=
(2d-5)\nu
+
\sum_E(a_E-2m_E)e_E,
\tag{33.4}
\]

where

\[
\nu=H\cdot C,
\qquad
e_E=E\cdot C.
\]

Since \(q^*H_X\cdot C=0\),

\[
d\nu=\sum_E m_Ee_E.
\tag{33.5}
\]

Equations (33.4)–(33.5) give an exact genus/base-multiplicity constraint. They can be combined with the forced 55-plane, 55-line, \(V_4\)-line, \(C_5\), and \(C_{11}\) base contributions.

This is one of the strongest unused numerical constraints.

### 34. General-hyperplane multisection

A general hyperplane \(\mathbf P^3\subset\mathbf P^4\), after strict transform and resolution, gives a generically finite map

\[
S\dashrightarrow X
\]

of degree

\[
\nu=H\cdot C.
\]

Its ramification formula is

\[
K_S=f^*K_X+R,
\qquad R\ge0.
\tag{34.1}
\]

Expressing both sides in terms of \(d\), base multiplicities, and exceptional discrepancies yields inequalities independent of equivariance. This converts the relative-dimension-one map into a generically finite threefold map for intersection-theoretic purposes.

### 35. Special-fiber Riemann–Hurwitz constraints

For \(x\in X^H\), the normalized fiber \(C_x\) carries an \(H\)-action. The source complex records fixed sections, fixed points, and exceptional components in this fiber.

For every connected \(H\)-stable component,

\[
2g(C_x)-2
=
|H|\bigl(2g(C_x/H)-2\bigr)
+
\sum_{P\in C_x}(|H_P|-1).
\tag{35.1}
\]

Apply this for

\[
H=C_2,C_3,V_4,C_5,C_6,C_{11}
\]

using the exact fixed-point incidence table. This can turn order-zero fixed data into numerical genus contradictions when combined with (33.4).

### 36. Critical and discriminant loci

The rank-drop locus of \(d[T]\) and its image in \(X\) form \(G\)-stable critical and discriminant cycles. Their classes can be computed by Thom–Porteous after resolution.

Their components must be unions of permissible \(G\)-orbits and must meet the fixed curves and points with the multiplicities dictated by the local jets.

### 37. Variation of the generic-fiber curve

Classify the generic fiber into:

- genus zero;
- genus one;
- genus at least two.

Each branch has extra data:

- genus zero: a Brauer/conic or ruled-fibration class and possible multisection index;
- genus one: a Jacobian torsor and monodromy;
- higher genus: a nontrivial variation \(R^1q_*\mathbf Q\).

The resulting variation must be compatible with the ambient Hodge-support localization of \(V\).

---

## C. Higher jets, local ideals, and Rees geometry

### 38. All-order \(A_4\) jets

Extend the \(\mu\le5\) calculation to every order, preferably structurally rather than by unbounded brute force:

\[
\operatorname{Hom}_{A_4}
\left(
\operatorname{Sym}^{\mu}N,
W\otimes\omega^{-d}
\right)
\]

with the cubic landing ideal and eigenline condition imposed.

The goal is a periodicity or finite-generation theorem in \(\mu\), followed by a shared-\(\mu\) global evaluation.

### 39. All-order \(C_{11}\) jets

Classify the possible initial maps at a \(C_{11}\)-point for every \((d,\mu)\bmod11\), including their ranks on all ten coordinate lines and planes.

The 60 lines on \(X\) should be included in the interpolation scheme. A global tuple must realize one shared \(C_{11}\)-jet profile over the entire 60-point orbit.

### 40. Full normal-cone data at V4 intersections

Replace the scalar profile \((m,r)\) by the complete initial ideal and complete graded tuple in

\[
\operatorname{gr}_{I_{\ell_V}}\mathcal O_{\mathbf P^4}
\]

and require compatibility with all three incident involution planes. This should detect constraints not visible in the orders \(m,r\) alone.

### 41. Formal obstruction tower

Write the local tuple as

\[
T=T_m+T_{m+1}+T_{m+2}+\cdots
\]

in normal degree. At each level, the cubic landing equation has the form

\[
L_r(T_r)=\Theta_r(T_{<r}),
\tag{41.1}
\]

so the obstruction lies in

\[
\operatorname{coker}L_r.
\]

The finite marked-state and purely linear inverse-limit models are known not to obstruct. The nonlinear right-hand side, common stabilizer character, and global interpolation must all be retained. fileciteturn28file0L1-L2 fileciteturn29file0L1-L2

### 42. Formal-to-global algebraization

A compatible formal system is not yet a homogeneous covariant. It must satisfy:

- one global degree;
- one \(G\)-representation class;
- regularity away from the prescribed centers;
- primitivity;
- exact landing;
- dominance.

The appropriate object is the inverse system of global jet-evaluation images, not the product of completed local rings.

### 43. Integral closure and local normalized slice ideals

At every type-I and type-II point, classify:

- the integral closure of the completed base ideal;
- its Rees valuations;
- the normalized two-dimensional transverse slices;
- all higher normal-jet deformations;
- which prime divisors, curve components, and fixed slices survive normalization.

This directly targets the present exceptional-carrier gap.

### 44. Arc-space and contact-locus constraints

For every forced base orbit, compute the contact loci

\[
\operatorname{Cont}^{\ge m}(I_T)
\]

and their \(G\)-orbits. The dimensions of these loci constrain log discrepancies, Rees valuations, and possible exceptional divisors.

The master weight formula extends naturally to weighted arcs and can couple several normal orders at once.

---

## D. Multidegrees, Segre classes, and birational geometry

### 45. Ambient graph multidegrees

Let

\[
g_i=
\int_{\Gamma_T}
h_1^{4-i}h_2^i,
\qquad 0\le i\le4.
\tag{45.1}
\]

For a primitive dominant \(T\),

\[
g_0=1,
\qquad
g_1=d,
\qquad
g_4=0.
\tag{45.2}
\]

If \(\nu\) is the degree of a general hyperplane multisection of the generic fiber, then

\[
g_3=3\nu
\tag{45.3}
\]

because \(\deg X=3\).

The multidegree sequence must satisfy the standard positivity and log-concavity inequalities, in particular

\[
g_1^2\ge g_0g_2,
\qquad
g_2^2\ge g_1g_3.
\tag{45.4}
\]

Thus

\[
g_2^2\ge3d\nu.
\tag{45.5}
\]

The values \(g_2,g_3\) can be computed from the Segre class of the actual base ideal. This is a direct numerical link between \(d\), the generic-fiber degree, and the base scheme.

### 46. Full Segre-class computation

Compute

\[
s(\operatorname{Bs}(I_T),\mathbf P^4)
\]

equivariantly, orbit by orbit. The forced planes, lines, and points contribute to the projective degrees with multiplicities determined by the normal jets.

The current profile inequalities use only fragments of this information.

### 47. Discrepancy and Noether–Fano constraints

For each exceptional divisor \(E\), record

\[
a_E=\operatorname{discrepancy}(E;\mathbf P^4),
\qquad
m_E=v_E(I_T).
\]

Equations (33.3)–(33.5) and the fiber-type map to the Fano threefold \(X\) should be combined with log-canonical threshold and maximal-singularity inequalities.

This could exclude multiplicity profiles that are linearly realizable but birationally impossible.

### 48. Relative MMP and canonical-bundle formula

Run an equivariant relative MMP for

\[
q:Z\to X.
\]

The output is a curve fibration over \(X\), possibly with discriminant and moduli parts. The fixed-network and base-orbit data must survive on the resulting Mori fiber model.

This can convert the arbitrary resolution into a bounded list of generic-fiber types.

### 49. Classification of the restricted common-factor surface

In the \(k\ge5\) branch of (13.2), classify every possible

\[
D_X\in|\mathcal O_X(k)|^G
\]

for the relevant small \(k\). For each component determine:

- normality;
- rational versus nonrational singularities;
- normalization and conductor;
- irregularity and Albanese;
- stabilizer;
- whether a finite cover can carry \(E_{-11}^{\,5}\);
- its intersections with \(E_\sigma,L_\sigma\), and the fixed points.

This is the exact remaining receiver problem in the CLEAN branch.

### 50. Refined type-II cluster exclusion

The quadratic condition \(\alpha\beta\gamma=0\) should be extended to all higher jets and then orbit-summed across all type-II points.

The target is a theorem that the resulting pointed rational-curve families cannot realize the full-support Hodge endomorphism required by CLEAN—not a false line-only normal form.

---

## E. Equivariant global-cycle and trace constraints

### 51. Burnside-mark constraints on fibers

For a proper resolved map \(q:Z\to X\), define for \(x\in X^H\)

\[
m_K(x)=
\chi\bigl(q^{-1}(x)^K\bigr),
\qquad K\le H.
\tag{51.1}
\]

The vector \((m_K(x))_{K\le H}\) must be the mark vector of an actual \(H\)-variety and hence satisfies the Burnside/Dress congruences.

The orbit complex currently records which fixed pieces may occur, but not whether their Euler characteristics assemble into a realizable \(H\)-fiber. This is a genuine strengthening of fixed-locus analysis.

### 52. Equivariant Riemann–Roch on the graph

Apply equivariant GRR to

\[
Rq_*\mathcal O_Z,
\quad
Rq_*\omega_{Z/X}^{\,m},
\quad
Rq_*p^*\mathcal O_{\mathbf P^4}(a).
\]

Their characters on each conjugacy class can be computed from fixed strata and compared with the receiver ledger. This couples fiber genus, multiplicities, and normal characters globally.

### 53. Lefschetz traces of the restricted selfmap

For the induced selfmap \(\varphi:X\dashrightarrow X\), resolve its graph and compute the Lefschetz number of

\[
g\circ\varphi
\]

for each element order \(2,3,5,6,11\). Its \(H^3\)-contribution is determined by the element of

\[
\mathbf Z\!\left[\frac{1+\sqrt{-11}}2\right]
\]

induced on \(V\), while the graph intersection with the fixed loci is controlled by the orbit-complex profile.

This can couple the CM norm \(\delta\) to actual fixed-point and fixed-curve multiplicities.

### 54. Inertia-stack compatibility

The map on free loci induces

\[
[\mathbf P(W)/G]\dashrightarrow[X/G].
\]

It must induce compatible maps on every inertia component, including:

- stabilizer homomorphisms;
- normal eigencharacters;
- ages;
- equivariant normal bundles;
- specialization along subgroup flags.

Orbifold Chow groups or equivariant \(K\)-theory can encode all subgroup rows simultaneously, rather than treating them as a combinatorial table.

### 55. Generic quotient-torsor invariants

Let

\[
K_X=\mathbf C(X)^G,
\qquad
K_P=\mathbf C(\mathbf P(W))^G.
\]

The quotient map induced by \(T\) gives

\[
K_X\hookrightarrow K_P
\]

and pulls the generic \(G\)-torsor on \(X/G\) to the generic torsor on \(\mathbf P(W)/G\).

Therefore every invariant

\[
\alpha\in H^r(G,\mu_n^{\otimes s})
\]

must have compatible values and residues under this field extension. The most relevant one is the spin Schur–Brauer class. Its residues along the divisors selected by the normalized Rees graph should be computed explicitly.

### 56. Restriction to every subgroup

For every subgroup \(H\le G\), the same \(T\) is an \(H\)-equivariant dominant map. One can impose:

- \(H\)-essential-dimension constraints;
- canonical-dimension constraints;
- twisted point constraints;
- subgroup-specific fixed-fiber genus;
- subgroup-specific Brauer residues.

The \(D_{12}\) case is particularly valuable because the \(V_{14}\) is spin-unirational but not linearly unirational there, so it provides a controlled model of exactly how the stable-equivalence escape operates.

---

## F. Lines, conics, rational curves, and Abel–Jacobi constraints

### 57. The 55 involution lines

Restrict \(T\), its Jacobian foliation, and its base ideal to the complete orbit

\[
\{L_\sigma\}_{\sigma}.
\]

Track:

- whether each line is base;
- its vanishing order;
- the induced map after blowing it up;
- the intersection of the generic fibers with it;
- the resulting cycles on the Fano surface.

### 58. The 60 \(C_{11}\)-lines

Use the new 60-line orbit to couple different \(C_{11}\)-fixed points. Restriction of one global tuple to these lines must satisfy all endpoint multiplicities, contraction values, and incidence compatibilities simultaneously.

This should be incorporated into the \(C_{11}\)-jet evaluation map rather than treated as an after-the-fact geometric observation.

### 59. Hilbert schemes of fiber curves

The generic and special fibers determine points in Hilbert schemes of curves in \(\mathbf P^4\). Their degenerations over fixed target strata must lie in \(G\)-stable Hilbert-scheme components with the correct Hilbert polynomial.

This supplies constraints on:

- number and degree of components;
- arithmetic genus;
- attachment at exceptional divisors;
- monodromy between components;
- admissibility of the orbit-complex degeneration.

### 60. Orbit-summed Abel–Jacobi classes

Exceptional rational-curve families and special fiber components determine cycles on \(X\) and classes in

\[
J(X)\sim E_{-11}^{\,5}.
\]

Their orbit-summed Abel–Jacobi correspondences must realize the same \(G\)-equivariant endomorphism of \(V\) as the restricted graph.

This is the correct global form of the proposed pointed-rational-curve exclusion. A componentwise vanishing statement is insufficient; the orbit sum and polarization must be computed.

### 61. Conic and higher-degree carrier slices

The line-only local model is false: conic-valued slice maps exist. The proper classification must include all low-degree rational curves permitted by the local landing equations and determine which survive normalization and orbit summation.

---

## G. Hodge, integral-lattice, and derived constraints

### 62. Full support-orbit representation census

For every possible proper support \(S\) and \(H=\operatorname{Stab}(S)\), calculate

\[
\operatorname{Hom}_{H}
\left(
\operatorname{Res}_H V,\,
IH^\bullet(\overline S,\mathcal L)(1)
\right).
\]

This should include:

- constant and nonconstant local systems;
- finite and infinite monodromy;
- surface and curve supports;
- singular support compactifications;
- the exact perverse degree.

The current Hodge theorem guarantees at least one such block but does not classify the actual support selected by \(I_T\).

### 63. Integral and polarized \(E_{-11}^{\,5}\) constraint

Rational occurrence of five CM elliptic factors is weaker than the actual polarized integral lattice. Impose:

- the \(\mathcal O_{-11}\)-lattice;
- Rosati involution;
- polarization type;
- discriminant;
- \(G\)-action;
- compatibility with the graph correspondence.

This is stronger than the rational norm condition (15.2) and may exclude surface or curve carriers that contain the right rational Hodge structure with the wrong integral polarization.

### 64. Perverse monodromy constraint

If \(V\) is carried by a local system over a positive-dimensional support, compute its monodromy representation. The monodromy must simultaneously:

- contain the required \(E_{-11}\)-type;
- respect the stabilizer \(H\);
- arise from the actual family of exceptional fibers;
- match degeneration around all incidence strata.

The simple assertion that nonconstant monodromy is impossible is false; the repository has an explicit order-two witness. The task is classification, not blanket exclusion.

### 65. Derived/Pfaffian–Grassmannian kernel

The \(X\)–\(V_{14}\) relation comes from Pfaffian–Grassmannian geometry. An explicit stabilized lift should induce a compatible class in equivariant numerical \(K\)-theory or an appropriate Fourier–Mukai kernel.

Compute the Chern character of the graph and test whether it lies in the image allowed by the Pfaffian–Grassmannian correspondence. This is higher-risk but potentially gives a global constraint unavailable to fixed-locus methods.

### 66. Integral equivariant diagonal/correspondence constraints

The rational conductor/Gysin receiver cannot be excluded: Bloch–Srinivas supplies it. The remaining possible strengthening is integral and genuinely \(G\)-equivariant, with the known \(660\)-multiple issue made explicit.

No argument should assume an algebraic Chow projector merely because a decomposition-theorem projector exists cohomologically.

---

## H. Twisted \(V_{14}\) and Brauer constraints

### 67. Pullback of the spin Brauer class

Compute the spin class

\[
\beta_X\in\operatorname{Br}(K_X)[2]
\]

and its pullback to \(K_P\). Record its residues at every divisorial valuation corresponding to a base-orbit or Rees divisor.

A map \(T\) forces these residues to agree with the generic source torsor. This can constrain the vertical divisors and the generic-fiber field extension.

### 68. Index reduction along the generic fiber

The extension

\[
K_X\subset K_P
\]

has transcendence degree one. Determine whether the generic fiber curve reduces the index of \(\beta_X\), and under what conditions.

The possible cases are:

- index remains two;
- index drops after adjoining the generic fiber function field;
- index drops only after a multisection of specified degree.

This directly measures whether the stable \(\mathbf P(U)\)-factor can be eliminated or descended.

### 69. Explicit folded spin-covariant scheme

Construct the actual folded spin representation \(D\), the corresponding covariant module

\[
\bigoplus_e
\left(
\operatorname{Sym}^eD^\vee\otimes M
\right)^{\widetilde G},
\]

and impose:

- even \(e\);
- all mandatory spin base points;
- all Plücker quadrics;
- dominance onto \(V_{14}\);
- compatibility with \(T\) through the stable correspondence.

This gives a genuine algebraic “lift scheme,” rather than an informal appeal to stable birationality.

### 70. Compatibility of the two five-dimensional slots

Any reverse map or stabilized correspondence must be checked in both conjugate five-dimensional slots. The degree-\(\le5\) audit shows that the two slots alternate in whether their covariants vanish on \(V_{14}\); symmetric-power multiplicity alone cannot distinguish them. fileciteturn53file0L1-L2

---

## I. Arithmetic and computational constraints

### 71. Exact multi-prime emptiness certificates

For each fixed degree/profile:

1. define the covariant and jet spaces over an integral cyclotomic model;
2. prove their ranks are flat under reduction;
3. compute at several good primes;
4. certify that rank zero modulo one good prime implies characteristic-zero rank zero;
5. independently rebuild the representation matrices or character route.

This is the method that closed \(d=34\).

### 72. Modular solutions require Hensel/deformation lifting

A positive-dimensional or nonzero modular solution is not evidence of a characteristic-zero map until one checks:

- smoothness of the landing scheme at the point;
- lifting through \(p^2,p^3,\ldots\);
- compatibility across primes;
- primitivity;
- dominance.

The degree-25 modular branches were exactly subject to this failure mode.

### 73. Point counts of the landing scheme

For the finite-dimensional \(d=35\) landing scheme, count points over several extensions \(\mathbf F_{p^r}\). This can distinguish:

- empty schemes;
- zero-dimensional components;
- positive-dimensional components;
- components defined only over extensions;
- nonreduced behavior.

The point counts should supplement, not replace, ideal-theoretic certificates.

### 74. Tropical and Newton-polytope constraints

A \(G\)-covariant has monomial support in complete \(G\)-orbits. Tropicalizing

\[
F(T)=0
\]

forces cancellation among the three tropical terms at every weight vector. This may exclude support patterns before constructing full coefficient matrices.

Mixed-volume calculations can also bound the generic-fiber degree \(\nu\) and the projective multidegrees.

### 75. Gröbner-fan classification of local ideals

For the small-dimensional \(d=35\) slice, enumerate the initial ideals of \(I_T\) compatible with:

- the fixed-plane and fixed-point multiplicities;
- analytic spread four;
- special fiber \(\mathbf C[X]\);
- the type-II initial restrictions;
- the forced eigenline contractions.

This is more targeted than an unrestricted Gröbner computation in the full covariant space.

---

## J. Deformation, semigroup, and dynamical constraints

### 76. Moduli of primitive landing tuples

Study

\[
\mathscr T_d
=
\left\{
[T]\in\mathbf P(M_d):
F(T)=0,\ \operatorname{im}T=X,\ \gcd(T_i)=1
\right\}.
\]

Determine:

- irreducible components;
- tangent dimensions;
- stabilizers;
- closures in the content and nondominant loci;
- specialization between degree profiles.

This makes “possible shapes” a scheme-theoretic statement rather than a finite state enumeration.

### 77. Factorization by invariant multiplication

Multiplication by \(R=\operatorname{Sym}(W^\vee)^G\) maps lower-degree covariants into higher degrees. Primitive components should be separated from invariant multiples at the scheme level.

### 78. Postcomposition by \(G\)-selfmaps of \(X\)

If one landing map exists, postcomposition with dominant \(G\)-equivariant rational selfmaps of \(X\) can produce maps of unbounded degree. Therefore no uniform finite list of all degrees or all carrier profiles can exist without quotienting by this semigroup.

Classify \(T\) into:

- primitive/indecomposable landing maps;
- postcompositions;
- common-factor modifications.

Then track how the base ideal, multidegrees, Hodge endomorphism, and Rees valuations transform.

### 79. Dynamical-degree and ramification constraints

For the restricted selfmap \(\varphi\), compare:

- its topological degree \(\delta\);
- its action on \(\operatorname{Pic}(X)\);
- its action on \(V\);
- its dynamical degrees;
- the ramification and exceptional divisors.

Iteration magnifies any incompatibility between the CM norm, fixed-locus behavior, and base multiplicities.

---

# VII. Constraints that must not be counted as established

The following are either explicitly refuted or not yet proved.

1. **The nonempty Stage-1 state space is not evidence for a map.**

2. **The zero at odd residues modulo six is not yet a theorem.**

3. **The \(d=35\) 39-dimensional slice is not a landing family.**

4. **A formal jet system does not algebraize automatically.**

5. **A modular solution does not lift automatically to characteristic zero.**

6. **The old bound \(d\ge7r-6m\) is withdrawn.**

7. **There is no direct \(G\)-map \(X\dashrightarrow V_{14}\), so \(T\) cannot be factored through such a map.**

8. **Stable \(G\)-birationality does not transfer rational points on the generic twist because the spin Severi–Brauer factor is pointless.**

9. **The abstract spin Hodge-support census is method-insufficient; repeating it cannot close the problem.**

10. **A normal surface need not have \(IH^1=0\).**

11. **The conductor/local-genus Gysin receiver exclusion is false over \(\mathbf Q\).**

12. **The line-only transverse slice normal form is false; conic slices occur.**

13. **A non-CM involution elliptic curve cannot carry the \(E_{-11}\)-type, but this does not exclude monodromy or secondary carriers.**

14. **A nonrepresented \(\delta\) in the CM norm form forces CARRIER, not nonexistence.**

15. **No canonical Chow-correspondence projector has been constructed.**

16. **Point-centered curve-valued Rees divisors contract, but curve components of normalized fibers and fixed slices inside surface carriers remain.**

17. **There is no uniform finite carrier list over all possible landing ideals.**

---

# VIII. Highest-yield integrated attack

The present problem should be attacked in the following order.

## 1. Audit the odd-residue zero

Since \(35\equiv5\pmod6\), a valid proof of the Stage-1 odd-residue zero would close the first window immediately. This is the smallest possible computation.

## 2. Build the definitive \(d=35\) global jet image

Start with the current at-most-39-dimensional \((1,6)\) slice and impose, in one joint evaluation map:

- all \(C_5\)-point vanishing;
- all \(C_{11}\)-point vanishing;
- all \(C_3\)-eigenline contractions;
- the \(C_6\)-pair swap;
- the own-\(D_{12}\) order-ten line jet;
- shared \(A_4\)-multiplicity and the \(\mu=2,3,4,5\) table;
- the 60 \(C_{11}\)-line incidences.

## 3. Solve the exact cubic landing scheme

Compute

\[
V\!\left(\Phi_{35}|_{L_{35}}\right)
\]

over several good primes, with a characteristic-zero flatness certificate. Then saturate by:

- the content ideal;
- the nondominance/Jacobian-rank ideal;
- lower-profile loci.

## 4. Compute the ambient graph multidegrees and generic-fiber genus

For every surviving component, compute

\[
(g_0,g_1,g_2,g_3,g_4)
=
(1,35,g_2,3\nu,0),
\]

the Segre corrections, and the genus identity

\[
2g(C)-2
=
65\nu+\sum_E(a_E-2m_E)e_E.
\]

Combine this with the fixed-fiber Riemann–Hurwitz and Burnside-mark constraints.

## 5. Split by the restricted common factor

Determine whether \(D_X=0\) or \(D_X\ne0\).

- \(D_X=0\) forces a proper Hodge carrier.
- \(D_X\ne0\) requires an invariant surface receiver carrying the full polarized \(E_{-11}^{\,5}\) factor.

## 6. Construct the actual spin-lift certificate

Only after a candidate survives the preceding steps should one form the folded spin source, impose the Plücker equations for \(V_{14}\), track the spin Brauer class, and test descent on twists.

The most important conceptual upgrade is therefore:

\[
\boxed{
\text{orbit-complex pattern}
\ \longrightarrow\
\text{one global all-jet evaluation image}
\ \longrightarrow\
\text{landing scheme}
\ \longrightarrow\
\text{normalized graph and generic-fiber curve}
\ \longrightarrow\
\text{spin/twisted }V_{14}\text{ certificate}.
}
\]

The current repository is strong at the first level, partial at the second and fourth, and has not yet performed the decisive third-level calculation for \(d=35\).
