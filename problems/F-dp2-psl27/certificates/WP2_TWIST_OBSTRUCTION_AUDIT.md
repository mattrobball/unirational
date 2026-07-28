# WP-2 certificate: generic twist, index one, and obstruction audit

Date: 2026-07-28.

## Verdict

Let

\[
G=\operatorname{PSL}_2(\mathbf F_7),\qquad
S=\{w^2=x^3y+y^3z+z^3x\}\subset\mathbf P(1,1,1,2)
\]

with the honest Klein action fixed in
[WP1_FIXED_LOCI.md](WP1_FIXED_LOCI.md). This audit proves two strong but
non-binary statements.

1. For every extension \(K/\mathbf C\), every \(G\)-torsor \(T/K\), and
   \(X={}^T S\), there are effective zero-cycles on \(X\) of degrees \(2\)
   and \(21\). Thus

   \[
   \operatorname{ind}(X)=1.
   \]

2. For the complex \(G\)-surface \(S\), the equivariant universal-torsor
   obstruction

   \[
   \beta(S\righttoleftarrow G)\in
   H^2\bigl(G,T_{\rm NS}(\mathbf C)\bigr)
   \]

   vanishes. Consequently every higher Amitsur group of
   Scavia--Tschinkel--Zhang vanishes, in every degree \(n\ge2\) and with
   coefficients in every split \(G\)-torus.

Neither statement gives a rational point on the generic twist. The exact
remaining alternative is a closed point of degree \(3\) or \(7\), and the
degree-\(3\) alternative occurs on other index-one degree-\(2\) del Pezzo
surfaces without rational points. Therefore **this is a closure of the
index/Amitsur obstruction routes, not a resolution of Problem F**.

There is no executable attached to this note. The only computational input
is WP-1's exact verification of the Sylow-\(3\) and Sylow-\(7\) fixed
points; the Sylow-\(2\), zero-cycle, and cohomological arguments below are
representation-theoretic.

## 1. The projective generic torsor is the sharp generic test

Put

\[
L_0=\mathbf C(\mathbf P(V)),\qquad K_0=L_0^G,\qquad
T_0=\operatorname{Spec}L_0\longrightarrow\operatorname{Spec}K_0.
\]

The projective action is faithful. For each nonidentity \(g\in G\), its
projective fixed locus is proper, so the complement of the union of these
finitely many loci is free. Hence \(L_0/K_0\) is a \(G\)-Galois extension
and \(T_0\) is a \(G\)-torsor.

Moreover, the projective action lifts to the honest three-dimensional
representation \(V\). Duncan--Reichstein, Proposition 9.1, therefore makes
\(\mathbf P(V)\) a very versal (in particular, versal) \(G\)-variety.
This is the two-parameter projective generic torsor; \(K_0\) has
transcendence degree \(2\) over \(\mathbf C\).

Twisting adjunction identifies

\[
({}^{T_0}S)(K_0)
\quad\longleftrightarrow\quad
\{G\text{-equivariant rational maps }\mathbf P(V)\dashrightarrow S\}.
\]

Any such map is dominant. Indeed, let \(Z\subseteq S\) be its image
closure. It is not a point because \(S^G=\varnothing\). If \(Z\) were a
curve, its normalization would be a unirational complex curve, hence
\(\mathbf P^1\). The kernel of the induced \(G\)-action is normal. It is
not all of \(G\), because then \(Z\subseteq S^G\); simplicity of \(G\)
would therefore make the action faithful. This would embed \(G\) in
\(\operatorname{PGL}_2(\mathbf C)\), contrary to the classification of its
finite subgroups. Thus \(\dim Z=2\).

Conversely, if \(S\) is \(G\)-unirational, Duncan--Reichstein
Theorem 1.1(c) implies that every twist, and in particular
\({}^{T_0}S\), is \(K_0\)-unirational and has a \(K_0\)-point. We
therefore have the precise criterion

\[
\boxed{
S\text{ is }G\text{-unirational}
\iff ({}^{T_0}S)(K_0)\ne\varnothing .}
\]

The affine torsor coming from
\(\mathbf C(V)/\mathbf C(V)^G\), used in the earlier audit, is also valid.
The projective torsor is the sharper test and lowers the generic base from
transcendence degree \(3\) to \(2\). This distinction matters for the
field-dimension discussion below.

## 2. Every twist has an effective zero-cycle of degree 2

Let \(K/\mathbf C\), let \(T/K\) be a \(G\)-torsor, and put
\(X={}^T S\). Twist the anticanonical double cover

\[
S\longrightarrow\mathbf P(V).
\]

Because the projective representation lifts to \(V\), its twist is

\[
{}^T\mathbf P(V)=\mathbf P(E)\simeq\mathbf P^2_K,\qquad
E=T\times^G V.
\]

This is also Duncan--Reichstein Lemma 10.1(a). The twisted anticanonical
map \(X\to\mathbf P(E)\) is finite of degree \(2\). Since
\(K\supset\mathbf C\) is infinite, choose a \(K\)-point of
\(\mathbf P(E)\) outside the branch quartic. Its inverse image is a finite
étale \(K\)-scheme of degree \(2\), hence an effective zero-cycle \(z_2\)
of degree \(2\) on \(X\).

## 3. Every twist has an effective zero-cycle of degree 21

Let \(P\le G\) be a Sylow \(2\)-subgroup. Then \(P\simeq D_8\). Every
irreducible complex representation of \(D_8\) has dimension \(1\) or
\(2\), so the restriction of the three-dimensional \(V\) contains a
character line \(\ell=\mathbf Cv\). (Faithfulness in fact forces the
decomposition \(1+2\), but only the line is needed.) Every character of
\(D_8\) has square one; write \(hv=\chi(h)v\), with \(\chi^2=1\).

This line always lifts to a \(P\)-fixed point of \(S\). If \(q_4(v)=0\),
use the branch point \([v:0]\). If \(q_4(v)\ne0\), choose
\(w\in\mathbf C\) with \(w^2=q_4(v)\). For every \(h\in P\), weighted
projective scaling gives

\[
h[v:w]=[\chi(h)v:w]=[v:w],
\]

because scaling the weight-one coordinates by \(\chi(h)\) scales the
weight-two coordinate by \(\chi(h)^2=1\). Thus \(S^P\ne\varnothing\).

Fix \(s\in S^P\). For any torsor \(T/K\), the rule

\[
T/P\longrightarrow{}^T S,\qquad tP\longmapsto[t,s]
\]

is a well-defined \(K\)-morphism. The finite étale \(K\)-scheme \(T/P\)
has degree

\[
[G:P]=168/8=21.
\]

Pushing its fundamental zero-cycle forward gives an effective zero-cycle
\(z_{21}\) of degree \(21\) on \(X\). Combining the two constructions,

\[
\operatorname{ind}(X)\mid\gcd(2,21)=1,
\]

so \(\operatorname{ind}(X)=1\). Explicitly, \(11z_2-z_{21}\) is a
(not necessarily effective) zero-cycle of degree one.

WP-1's Sylow-\(3\) and Sylow-\(7\) fixed points similarly give effective
cycles

\[
z_{56}\quad\text{and}\quad z_{24},
\qquad
\deg z_{56}=[G:C_3]=56,\quad
\deg z_{24}=[G:C_7]=24.
\]

Thus the degree-\(3\) and degree-\(7\) zero-cycle classes can already be
written in the induced-orbit ledger:

\[
\deg(z_{24}-z_{21})=3,\qquad
\deg(3z_{21}-z_{56})=7.
\]

These are signed zero-cycles, not closed points, and they do not select
which of Colliot-Thélène's effective alternatives occurs.

This argument uses a Sylow fixed point only. It does **not** assert that
the Sylow action is unirational.

## 4. What index one gives, and what it does not give

Colliot-Thélène, Theorem 4.1, proves that a degree-\(2\) del Pezzo surface
over a characteristic-zero field which has a zero-cycle of degree \(1\)
has a closed point of degree \(1\), \(3\), or \(7\). It applies to every
twist above, so in particular

\[
{}^{T_0}S
\quad\text{has a closed point of degree }1,3,\text{ or }7.
\]

This does not force degree \(1\). Colliot-Thélène's Remark 4.3 constructs
degree-\(2\) del Pezzo surfaces with points of degrees \(3\) and \(5\)
(hence index \(1\)) but no rational point. Thus there is no general
"index one implies a point" theorem to insert here.

The projective generic field \(K_0\), being a function field of
transcendence degree \(2\) over an algebraically closed field, is \(C_2\).
This still supplies no automatic point: the defining weighted quartic
does not meet the variable-count hypotheses of the \(C_2\) axiom.
More decisively, Colliot-Thélène's construction can itself be run over a
rational \(C_2\) field. Take \(k=\mathbf C(u)\), a split conic
\(C\simeq\mathbf P^1_k\), and on it the reduced degree-\(8\) divisor

\[
(s^3-u r^3)(s^5-(u+1)r^5)=0.
\]

The two factors are irreducible by Eisenstein at \(u\) and \(u+1\), are
separable and coprime, and hence define two closed points of degrees \(3\)
and \(5\). The restriction map
from plane quartics to \(\mathcal O_C(8)\) is surjective, and a general
lift \(Q\) is smooth and meets \(C\) transversely. Taking the nonsquare
\(a=u\), Remark 4.3's surface over

\[
F=k(t)=\mathbf C(u,t),\qquad
z^2-aC^2+tQ=0,
\]

has the degree-\(3\) and degree-\(5\) points but no \(F\)-point. Since
\(F\) is \(C_2\), even a rational \(C_2\) base plus index one is
insufficient in general. Any positive upgrade here must use the special
generic Klein torsor, not just the field class.

## 5. The universal-torsor and all higher Amitsur obstructions vanish

The Picard group of \(S\) is free of rank \(8\), so the equivariant
universal-torsor class of Scavia--Tschinkel--Zhang is defined:

\[
\beta=\beta(S\righttoleftarrow G)
\in H^2\bigl(G,T_{\rm NS}(\mathbf C)\bigr).
\]

For a subgroup \(H\le G\), naturality identifies the restriction of
\(\beta\) with \(\beta(S\righttoleftarrow H)\). An \(H\)-fixed point
\(x\in S\) kills this class. One concrete way to see this from the
four-term divisor extension is to replace \(\operatorname{Div}(S)\) by
the divisors whose support avoids \(x\). They still surject onto
\(\operatorname{Pic}(S)\), and the rational functions mapping to them are
\(\mathcal O_{S,x}^{\times}\). Evaluation at the fixed point gives an
\(H\)-equivariant retraction

\[
\mathcal O_{S,x}^{\times}\longrightarrow\mathbf C^{\times}
\]

of the constant inclusion. Hence the corresponding Yoneda two-extension,
and therefore \(\beta(S\righttoleftarrow H)\), is zero.

The exact WP-1 audit gives fixed points for the Sylow subgroups \(C_3\)
and \(C_7\), while Section 3 above gives one for the Sylow subgroup
\(D_8\). Therefore

\[
\operatorname{res}^{G}_{G_p}(\beta)=0
\qquad(p=2,3,7).
\]

For a Sylow \(G_p\), restriction--corestriction gives

\[
\operatorname{cor}_{G_p}^{G}\operatorname{res}_{G_p}^{G}(\beta)
=[G:G_p]\,\beta=0.
\]

The three indices are \(21\), \(56\), and \(24\), whose gcd is \(1\).
Consequently

\[
\boxed{\beta(S\righttoleftarrow G)=0.}
\]

Scavia--Tschinkel--Zhang Theorem 1.2 now yields

\[
\boxed{
\operatorname{Am}^{n}(S\righttoleftarrow G,R)=0
\quad\text{for every }n\ge2
\text{ and every split }G\text{-torus }R.}
\]

There is also a direct check of the second box: Theorem 5.1(2) makes each
Sylow restriction vanish because that Sylow has a fixed point, and
Theorem 5.1(3) is exactly the required restriction--corestriction passage
back to \(G\). Theorem 5.1(6) says these groups must vanish on a
\(G\)-unirational variety, so the entire higher-Amitsur family is a
necessary test which this action passes. Neither Theorem 1.2 nor
Theorem 5.1 states a converse for del Pezzo surfaces.

For context, Proposition 8.1 of the same paper treats a different
degree-\(2\) del Pezzo action, by the modular group of order \(16\), where
every abelian subgroup has a fixed point and all
\(\mathbf G_m\)-coefficient higher Amitsur groups vanish but
\(\beta\ne0\). That negative example does not restrict to the present
simple group; here the stronger class \(\beta\) itself vanishes.

## 6. Why the degree-3 and degree-7 alternatives do not collapse

Let \(E/K_0\) be the residue field of a closed point on
\({}^{T_0}S\), let \(M/K_0\) be its Galois closure, and recall that
\(L_0/K_0\) is \(G\)-Galois. The intersection \(L_0\cap M\) is Galois
over \(K_0\). Since \(G\) is simple, it is either \(K_0\) or \(L_0\).

- If \([E:K_0]=3\), then \([M:K_0]\le6\), so
  \(L_0\cap M=K_0\). The generic \(G\)-torsor stays connected after base
  change to \(E\), but this does not descend the \(E\)-point.
  Geometrically, the point produces the relevant equivariant map only
  after passage to a generically finite degree-\(3\) cover of the
  quotient. Its pullback to \(\mathbf P(V)\) need not be rational or
  unirational, so the rational-curve image argument of Section 1 is
  unavailable.

- If \([E:K_0]=7\), both intersections are possible. The group \(G\) has
  index-\(7\) subgroups \(H\simeq S_4\), giving the natural degree-\(7\)
  intermediate fields \(L_0^H/K_0\). In this model case twisting
  adjunction reduces only to an \(S_4\)-equivariant situation. Unlike
  \(G\), \(S_4\) embeds in \(\operatorname{PGL}_2(\mathbf C)\), so a
  one-dimensional rational image is no contradiction. In the disjoint
  case, the same generically finite-cover issue as in degree \(3\)
  remains.

In particular, the absence of an index-\(3\) subgroup of \(G\) does not
rule out a degree-\(3\) closed point: its residue field is an arbitrary
finite extension of \(K_0\), not necessarily an intermediate field of
\(L_0/K_0\). The orbit/stabilizer route therefore gives no upgrade from
degrees \(3\) or \(7\) to degree \(1\).

## 7. Exact remaining boundary

For the projective generic twist \(X_0={}^{T_0}S\), the audit now gives

\[
\operatorname{ind}(X_0)=1,\qquad
X_0\text{ has a point of degree }1,3,\text{ or }7,
\]

and for the governing equivariant action it gives

\[
\beta(S\righttoleftarrow G)=0,\qquad
\operatorname{Am}^{n}(S\righttoleftarrow G,R)=0
\quad(n\ge2).
\]

Problem F is equivalent to deciding whether the degree-\(1\) alternative
for \(X_0\) occurs. A positive resolution must produce a \(K_0\)-point
(equivalently, a dominant \(G\)-equivariant map
\(\mathbf P(V)\dashrightarrow S\)); a negative resolution needs an
obstruction finer than index, the universal-torsor class, and every higher
Amitsur group.

## Primary references

1. A. Duncan and Z. Reichstein, *Versality of algebraic group actions and
   rational points on twisted varieties*,
   [arXiv:1109.6093](https://arxiv.org/abs/1109.6093), Theorem 1.1,
   Proposition 9.1, and Lemma 10.1.
2. J.-L. Colliot-Thélène, *Zéro-cycles sur les surfaces de del Pezzo
   (Variations sur un thème de Daniel Coray)*,
   [arXiv:2005.06876](https://arxiv.org/abs/2005.06876), Theorem 4.1 and
   Remark 4.3.
3. F. Scavia, Y. Tschinkel, and Z. Zhang, *Birational invariance of higher
   Amitsur groups*, [arXiv:2605.02763](https://arxiv.org/abs/2605.02763),
   Theorems 1.2 and 5.1 and Proposition 8.1.
