# ChatGPT conversation

## [1] user

Read the G-rationality obstruction mechanism in the GitHub repo mattrobball/unitational. Use the attached census and derive any restrictions for equivariant necessary to show the Klein cubic is not PSL(2.11) unirational. 

## [2] assistant

I’ll inspect the repository’s obstruction framework and census, then specialize its subgroup, fixed-locus, and stratification constraints to the PSL(2,11)-action on the Klein cubic.

## [3] assistant

```
{"queries":["+(PSL(2,11)) +(Klein cubic) census subgroup fixed loci equivariant unirationality obstruction --QDF=5","+(Klein cubic) census --QDF=5","census"],"source_filter":["file_library"]}
```

## [4] tool

The output of this plugin was redacted.

## [5] tool

The output of this plugin was redacted.

## [6] assistant

```
{"queries":[""],"source_filter":["file_library"],"intent":"nav","file_type_filter":["spreadsheets"]}
```

## [7] tool

The output of this plugin was redacted.

## [8] tool

The output of this plugin was redacted.

## [9] tool

The output of this plugin was redacted.

## [10] assistant

> [thought] I’m parsing the request as involving a repository and an attached census, but I’m not locating the attachment or identifying exactly what “equivariant” restrictions are intended. I need to inspect the available materials more carefully before deriving conclusions.

## [11] assistant

```
{"queries":["+(PSL) +(equivariant) +(unirationality) --QDF=5","+(Klein) +(cubic) +(subgroups) --QDF=5","+(finite simple group) +(census) +(threefold)","+(rationality) +(census) +(group actions)"],"source_filter":["file_library"],"intent":"nav"}
```

## [12] tool

The output of this plugin was redacted.

## [13] assistant

The repository appears to be `mattrobball/unirational`, and since no separately named census attachment is exposed, I’m checking for census-derived tables within it.

## [14] tool

The output of this plugin was redacted.

## [15] assistant

> [thought] I’m identifying the intended repository and checking its obstruction framework. The attached census still isn’t clearly available, so I’m distinguishing verified repository results from restrictions that would need the census to establish a complete non-unirationality argument.

> [thought] I’m assembling the verified Klein fixed-stratum census and the repo’s covariant-reduction mechanism. The key unresolved step is proving global compatibility: local fixed-line data alone don’t exclude all dominant equivariant self-covariants.

## [16] assistant

```
{"queries":["+(Klein cubic) +(census) +(PSL(2,11)) stabilizer subgroup fixed loci --QDF=5","+(55 involutions) +(55 V_4) +(110 C_3 eigenlines) +(165 type-I)","+(D_10 points) +(D_12 points) +(type-II V_4 points) Klein cubic","+(stabilizer census) +(Klein cubic) fixed strata incidence"],"source_filter":["file_library"]}
```

## [17] tool

The output of this plugin was redacted.

## [18] tool

The output of this plugin was redacted.

## [19] assistant

```
{"queries":["+(equivariant rational map obstructions) normalized graph stabilizer monotonicity normal cone necessary conditions","+(normalized equivariant graph) +(stabilizer monotonicity) +(normal cones)","+(rational G-map) +(stabilizer) +(normal cone) arbitrary G-varieties"],"source_filter":["file_library"]}
```

## [20] tool

The output of this plugin was redacted.

## [21] tool

The output of this plugin was redacted.

## [22] assistant

> [thought] I’m now extracting consequences for a homogeneous equivariant self-covariant. Involution symmetry forces parity by normal order, while residual symmetry makes the plus-plane a forced base locus; the remaining challenge is global compatibility across all strata.

## [23] assistant

```
def mins(m, maxn=100):
    out = {(0,0):None,(1,0):None,(0,1):None,(1,1):None}
    witnesses={}
    for a in range(maxn):
        for b in range(maxn):
            for c in range(maxn):
                if b+c>=m and a+c>=m and a+b>=m:
                    ch=((a+c)%2,(b+c)%2)
                    n=a+b+c
                    if out[ch] is None or n<out[ch]:
                        out[ch]=n; witnesses[ch]=(a,b,c)
    return out,witnesses
for m in range(1,12,2):
    print(m, mins(m,20))

```

## [24] assistant

> [thought] I’m combining the repo’s covariant reduction with the census: any proposed nonzero homogeneous self-covariant must vanish on involution plus-planes, satisfy normal-parity constraints, and remain compatible across V4 lines, elliptic strata, and their incidence flags.

> [thought] I’m identifying stronger necessary conditions: multiplicity along V4 lines, character-compatible jets, forced base points from high stabilizers, and global flag compatibility. A complete negative proof still requires an all-degree terminal obstruction, not isolated low-degree failures.

## [25] assistant

```
{"queries":[""],"source_filter":["file_library"],"intent":"nav"}
```

## [26] tool

The output of this plugin was redacted.

## [27] tool

The output of this plugin was redacted.

## [28] assistant

The census forces 55 involution planes and 55 V₄-lines, yet rational fixed lines and D₁₂ transitions defeat the surface-style contradiction. A proof must exclude all-degree homogeneous landing covariants.

## [29] assistant

```
bash -lc rm -rf /tmp/unirational && git clone --depth 1 https://github.com/mattrobball/unirational.git /tmp/unirational && git -C /tmp/unirational rev-parse HEAD && du -sh /tmp/unirational
```

## [30] tool

The output of this plugin was redacted.

## [31] assistant

```
{"query":"The user asks for a technical analysis of the PSL(2,11)-equivariant unirationality obstruction for the Klein cubic using the mattrobball/unirational GitHub repository and an attached stabilizer census. Retrieve any prior user-specific decisions, preferences, or recent discussion about this exact Klein cubic obstruction project that would materially affect how the answer should be framed."}
```

## [32] assistant

The output of this plugin was redacted.

## [33] tool

The output of this plugin was redacted.

## [34] tool

The output of this plugin was redacted.

## [35] tool

The output of this plugin was redacted.

## [36] tool

The output of this plugin was redacted.

## [37] tool

The output of this plugin was redacted.

## [38] tool

The output of this plugin was redacted.

## [39] tool

The output of this plugin was redacted.

## [40] assistant

> [thought] I’m ready to state the derived restrictions while preserving the open status: they sharply constrain any surviving covariant, but do not yet prove non-unirationality without an all-degree global obstruction.

> [thought] I’m consolidating the strongest conditions: common odd multiplicity on all involution planes, a V4-line bound \(d\ge(3m+1)/2\), character-forced base points, and congruence filters at C5, C6, and C11 strata. These remain necessary conditions, not a complete proof.

## [41] tool

The output of this plugin was redacted.

## [42] tool

The output of this plugin was redacted.

## [43] tool

The output of this plugin was redacted.

## [44] tool

The output of this plugin was redacted.

## [45] assistant

```
{"paths":["GitHub"],"query":"search"}
```

## [46] assistant

The output of this plugin was redacted.

## [47] tool

The output of this plugin was redacted.

## [48] assistant

```
{"paths":["GitHub"],"query":"fetch_file"}
```

## [49] assistant

The output of this plugin was redacted.

## [50] tool

The output of this plugin was redacted.

## [51] assistant

The output of this plugin was redacted.

## [52] tool

The output of this plugin was redacted.

## [53] assistant

The output of this plugin was redacted.

## [54] tool

The output of this plugin was redacted.

## [55] assistant

The output of this plugin was redacted.

## [56] tool

The output of this plugin was redacted.

## [57] assistant

The output of this plugin was redacted.

## [58] tool

The output of this plugin was redacted.

## [59] assistant

The output of this plugin was redacted.

## [60] tool

The output of this plugin was redacted.

## [61] assistant

The output of this plugin was redacted.

## [62] tool

The output of this plugin was redacted.

## [63] assistant

The output of this plugin was redacted.

## [64] tool

The output of this plugin was redacted.

## [65] assistant

The output of this plugin was redacted.

## [66] tool

The output of this plugin was redacted.

## [67] assistant

```
{"uri":"/response/turn66","query":"D12_point","start_line":1,"end_line":7}
```

## [68] tool

The output of this plugin was redacted.

## [69] assistant

```
{"uri":"/response/turn66","query":"D12","start_line":1,"end_line":7}
```

## [70] tool

The output of this plugin was redacted.

## [71] assistant

The output of this plugin was redacted.

## [72] tool

The output of this plugin was redacted.

## [73] assistant

The output of this plugin was redacted.

## [74] tool

The output of this plugin was redacted.

## [75] assistant

The output of this plugin was redacted.

## [76] assistant

```
{"uri":"skills://plugins/github/github/skill.md","start_line":1,"num_lines":240}
```

## [77] tool

The output of this plugin was redacted.

## [78] tool

The output of this plugin was redacted.

## [79] tool

The output of this plugin was redacted.

## [80] tool

The output of this plugin was redacted.

## [81] tool

The output of this plugin was redacted.

## [82] tool

The output of this plugin was redacted.

## [83] assistant

## Conclusion

I read `mattrobball/unirational`—the repository name in the prompt appears to be a typo—at commit `4da9f8f0c8f4a8bed38517f4f42d55b371e6595d`. I used the repository’s exact certified realization of the attached candidate `strata.md`; in particular, the certified census corrects the candidate’s inconsistent claim about type-II \(V_4\)-points. The problem remains open at this commit. fileciteturn25file0L2-L2 fileciteturn23file0L2-L2 fileciteturn33file0L2-L2

The census does **not** by itself prove that the Klein cubic is not
\[
G=\operatorname{PSL}_2(\mathbf F_{11})
\]
-unirational. It does, however, force a fairly rigid package of necessary conditions on any hypothetical equivariant map. The strongest additional consequences I can extract are:

1. a common odd symbolic vanishing order along all \(55\) involution planes;
2. a new explicit lower bound and character restriction at every \(V_4\) triple line;
3. a degree-congruence sieve coming from the \(C_3,C_5,C_{11}\) strata;
4. compulsory base points with \(D_{10},D_{12},A_4\) stabilizers and stringent point-link compatibility;
5. a global Hodge requirement forcing nonlinear positive-irregularity components in the base locus.

None of these individually closes the problem, but together they considerably narrow what an all-degree negative proof would have to eliminate.

---

## 1. The exhaustive object that must be excluded

The accepted source-reduction theorem says that \(G\)-unirationality would produce a nonzero homogeneous self-covariant
\[
p\colon W\longrightarrow W,
\qquad
p\in\operatorname{Hom}_G(\operatorname{Sym}^{D}W,W),
\]
for some \(D\geq 1\), satisfying the polynomial identity
\[
F(p)=0,
\qquad
F(x)=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}.
\]
Conversely, every nonzero landing self-covariant is automatically dominant. Thus a negative result must exclude **every** such \(p\) in characteristic zero, in every degree \(D\), after primitive reduction. A bounded-degree calculation, one support pattern, or one formal normal state is insufficient. fileciteturn25file0L2-L2

The normalized-graph/normal-cone mechanism then says that such a \(p\) determines:

- compatible target centers in \(X^H\) for every stabilizer \(H\);
- first nonzero normal jets at every forced base stratum;
- compatible specializations of those jets along every incidence and iterated normal cone;
- all coefficients of the associated-graded and higher-order equations obtained from \(F(p)=0\).

The following are therefore necessary conditions on \(p\).

---

## 2. The \(55\) involution planes are compulsory base components

For an involution \(t\),
\[
W=E_+(t)\oplus E_-(t),
\qquad
\dim E_+=3,\quad \dim E_-=2.
\]
Write
\[
Z_t=\mathbf P(E_+(t))\simeq\mathbf P^2,
\qquad
L_t^{\rm src}=\mathbf P(E_-(t))\simeq\mathbf P^1.
\]

The target fixed locus is
\[
X^t=E_t\sqcup L_t^{\rm tgt},
\]
where
\[
E_t=X\cap\mathbf P(E_+(t))
\]
is a smooth plane elliptic curve and
\[
L_t^{\rm tgt}=\mathbf P(E_-(t))\subset X
\]
is a rational line. The residual group
\[
N_G(\langle t\rangle)/\langle t\rangle\simeq S_3
\]
acts on \(E_t\); its order-three subgroup acts as translation by a nonzero \(3\)-torsion point, hence has no fixed point. fileciteturn10file0L2-L2 fileciteturn12file0L2-L2

For \(z\in E_+\),
\[
t\,p(z)=p(tz)=p(z),
\]
so \(p(z)\in E_+\). Thus a nonzero restriction to \(Z_t\) would give a rational map
\[
\mathbf P^2\dashrightarrow E_t.
\]
It must be constant, while residual \(S_3\)-equivariance would require an \(S_3\)-fixed point of \(E_t\), which does not exist. Consequently,
\[
p|_{Z_t}=0
\]
for every involution \(t\).

Because the \(55\) planes form one \(G\)-orbit, there is a common transverse order \(m\) such that
\[
p\in\bigcap_t I_{Z_t}^{\,m},
\qquad
p\notin I_{Z_t}^{\,m+1}
\quad\text{generically on every }Z_t.
\]
The correct filtration is symbolic/sheaf-theoretic, not the ordinary power of the union ideal.

Parity forces
\[
\boxed{m\ \text{odd}.}
\]
Locally, with \(z\in E_+\) and normal coordinate \(y\in E_-\),
\[
p_-=a_m+a_{m+2}+a_{m+4}+\cdots,
\qquad
p_+=b_{m+1}+b_{m+3}+b_{m+5}+\cdots.
\]
The leading term \(a_m\) is \(E_-\)-valued. Its projectivization gives a nonconstant—and hence dominant—map from the generic normal \(\mathbf P^1\) to \(L_t^{\rm tgt}\). This rational exit is exactly why the surface-style fixed-locus path obstruction fails for the Klein cubic. fileciteturn11file0L2-L2 fileciteturn13file0L2-L2

### Restriction to the source minus-line

For \(y\in E_-\),
\[
t\,p(y)=p(-y)=(-1)^D p(y).
\]

Hence:

- If \(D\) is even, \(p(y)\in E_+\). Landing would give a rational map
  \(\mathbf P^1\dashrightarrow E_t\), necessarily constant, and residual \(S_3\)-equivariance again rules out a constant. Therefore
  \[
  \boxed{D\ \text{even}\quad\Longrightarrow\quad p|_{L_t^{\rm src}}=0.}
  \]

- If \(D\) is odd, \(p(y)\in E_-\), so a nonzero restriction can map to the rational fixed line. Exact \(D_{12}\)-covariance and the common plane order give
  \[
  p|_{E_-}=\Delta_t^{\,m}h_t,
  \qquad
  \deg\Delta_t=6,
  \qquad
  \deg h_t=e=D-6m.
  \]
  Thus a nonzero restriction requires
  \[
  \boxed{D\geq 6m+1,\qquad e=D-6m\ \text{odd}.}
  \]

The endpoint ledger is also restricted:

\[
\begin{array}{c|c}
e & \text{locally allowed endpoint behavior}\\
\hline
1,3 & \text{swap both marked systems only}\\
5 & \text{swap-both or mixed; preserve-both impossible}\\
e\geq7\text{ odd} & \text{all four local ledgers}
\end{array}
\]

After imposing the global point-link equalizer, the current packet retains three formal families: all minus-lines based; the minimal \(e=1\) swap-both family \(D=6m+1\); and a generic \(e\geq7\) swap-both family. These are formal necessary states, not actual covariants. fileciteturn13file0L2-L2 fileciteturn14file0L2-L2 fileciteturn22file0L2-L2

---

## 3. A stronger consequence at every \(V_4\) triple line

This is an elementary but useful additional consequence of the exact incidence census.

For a fixed \(V_4\),
\[
W=A\oplus B\oplus C\oplus D,
\qquad
\dim A=2,\quad \dim B=\dim C=\dim D=1,
\]
where \(A\) is \(V_4\)-trivial and \(B,C,D\) carry its three nontrivial characters. The \(V_4\)-fixed line is
\[
R=\mathbf P(A).
\]
The three involution plus-planes through \(R\) are
\[
\mathbf P(A+B),\qquad
\mathbf P(A+C),\qquad
\mathbf P(A+D).
\]
Thus, at a generic point of \(R\), choose normal coordinates \(u,v,w\) in the \(B,C,D\) directions. The three plane ideals are
\[
(v,w),\qquad (u,w),\qquad (u,v).
\]

Since \(p\) vanishes to order \(m\) along all three planes,
\[
p\in
J_m:=
(v,w)^m\cap(u,w)^m\cap(u,v)^m.
\]

A monomial \(u^\alpha v^\beta w^\gamma\in J_m\) must satisfy
\[
\beta+\gamma\geq m,\qquad
\alpha+\gamma\geq m,\qquad
\alpha+\beta\geq m.
\]
Adding these inequalities gives
\[
2(\alpha+\beta+\gamma)\geq3m.
\]
Since \(m\) is odd, write \(m=2k+1\). Then the normal order along every \(V_4\)-line satisfies
\[
\boxed{\operatorname{ord}_{R}(p)\geq
\left\lceil\frac{3m}{2}\right\rceil
=\frac{3m+1}{2}=3k+2.}
\]
In particular,
\[
\boxed{D\geq\frac{3m+1}{2}}
\]
even in the family where every source minus-line is based.

At equality, the only possible exponent triples are the permutations of
\[
(k,k+1,k+1).
\]
Using
\[
\chi_B\chi_C\chi_D=1,
\]
the three minimal monomials have characters
\[
\begin{aligned}
u^k v^{k+1}w^{k+1}&:\ \chi_B,\\
u^{k+1}v^k w^{k+1}&:\ \chi_C,\\
u^{k+1}v^{k+1}w^k&:\ \chi_D.
\end{aligned}
\]
Therefore the minimal \(V_4\)-line initial term must have the form
\[
u^k v^{k+1}w^{k+1}s_B
+
u^{k+1}v^k w^{k+1}s_C
+
u^{k+1}v^{k+1}w^k s_D,
\]
with values in \(B,C,D\), cyclically related by the residual \(C_3=A_4/V_4\).

This gives the sharper statement:

\[
\boxed{\text{At minimal possible \(V_4\)-order, the exit is necessarily
type-I; a type-II exit is impossible.}}
\]

Indeed, an \(A\)-valued term needs trivial \(V_4\)-character. That forces
\(\alpha,\beta,\gamma\) to have the same parity, so the first possible trivial-character monomial is
\[
(uvw)^{k+1},
\]
of normal order
\[
\boxed{\frac{3(m+1)}2=\frac{3m+3}{2},}
\]
one order later.

The exact census is essential here: type-I points are the triangle vertices, lying on one elliptic and two minus-lines, whereas each type-II point lies on all three elliptics and on no triangle edge. There are \(495\) type-II/elliptic incidence flags. fileciteturn23file0L2-L2

This filtration should be imposed inside the nonlinear lifting tower. It is stronger than merely recording that the \(V_4\)-line is a forced base stratum.

---

## 4. A degree-character sieve from the cyclic strata

For a cyclic subgroup \(H\), let \(v\) span an \(H\)-eigenline with character \(\chi\). Homogeneity and equivariance give
\[
g\,p(v)=p(gv)=p(\chi(g)v)=\chi(g)^D p(v).
\]
Thus
\[
p(v)\in W_{\chi^D}.
\]
Combining this with the exact census gives the following base-or-permutation restrictions.

### \(C_3\)-eigenlines

For a generator of \(C_3\),
\[
W=L_1\oplus U_\omega\oplus U_{\omega^2},
\qquad
\dim=(1,2,2).
\]
The one-dimensional trivial eigenspace is the \(D_{12}\)-point off \(X\), while each projective eigenline meets \(X\) in three reduced points: one \(C_6\)-point and two exact-\(C_3\) points. fileciteturn26file0L2-L2

Consequently, on a source eigenline \(\mathbf P(U_\omega)\),

\[
\boxed{
D\equiv0\pmod3
\quad\Longrightarrow\quad
p|_{\mathbf P(U_\omega)}=0.
}
\]

If \(D\equiv1\) or \(2\pmod3\), the projective image is contained in a reduced three-point scheme, hence is constant whenever nonzero. Imposing the full setwise stabilizer \(C_6\), not merely the pointwise \(C_3\), removes the two exact-\(C_3\) constants: they are exchanged by the residual involution. Therefore

\[
\boxed{
p|_{\mathbf P(U_\omega)}
\text{ is either zero or projectively constant at the unique \(C_6\)-point
in }\mathbf P(U_{\omega^D}).
}
\]

This is a useful strengthening of the purely local \(C_3\)-classification.

### \(C_5\)-points

The five \(C_5\)-eigencharacters all occur once in \(W\). The trivial-character point is the \(D_{10}\)-point off \(X\); the four nontrivial character points lie on \(X\), split into two orbits \(C_5^{(a)}\) and \(C_5^{(b)}\).

Thus:

\[
\boxed{
5\mid D
\quad\Longrightarrow\quad
p\text{ vanishes at all }264\ C_5\text{-points on }X.
}
\]

When \(D\not\equiv0\pmod5\), multiplication by \(D\) on the four nonzero characters determines the induced permutation:

- \(D\equiv\pm1\pmod5\): the two \(C_5\)-orbit types are preserved;
- \(D\equiv\pm2\pmod5\): the \(a\)- and \(b\)-orbits are exchanged.

### \(C_{11}\)-points

For \(C_{11}\), the five characters occurring in \(W\) have exponents
\[
Q=\{1,3,4,5,9\}\subset(\mathbf Z/11)^\times,
\]
the quadratic residues. All five corresponding eigenpoints lie on \(X\).

Hence a nonzero value at a \(C_{11}\)-point is possible only when
\[
D\bmod 11\in Q.
\]
Equivalently,
\[
\boxed{
D\equiv0\pmod{11}
\ \text{or}\ 
\left(\frac D{11}\right)=-1
\quad\Longrightarrow\quad
p\text{ vanishes at all }60\ C_{11}\text{-points}.
}
\]

If \(D\equiv1\pmod{11}\), the five points for each \(C_{11}\) are fixed. If
\[
D\in\{3,4,5,9\}\pmod{11},
\]
multiplication by \(D\) cyclically permutes each five-point configuration.

### \(V_4\)-points

At a type-I point, the source line has a nontrivial \(V_4\)-character \(\chi\). Therefore:

- \(D\) odd: a nonzero value lies on the same type-I character line;
- \(D\) even: a nonzero value lies in \(A\), hence at one of the three type-II points.

At a type-II point the source character is trivial, so every nonzero value is again a type-II point.

These congruence statements do not by themselves constrain \(D\), because a rational map may be based on the corresponding finite orbit. They do produce a finite residue-class sieve, modulo \(2\cdot3\cdot5\cdot11=330\), describing exactly which additional lines and point orbits must enter the base scheme in each degree class.

---

## 5. Compulsory point links

The following projective character points are forced base points in every degree:

\[
\begin{array}{c|c|c}
\text{stabilizer}&\text{number}&\text{reason}\\
\hline
D_{10}&66&\text{the unique \(D_{10}\)-character line is off }X\\
D_{12}&55&\text{the unique \(D_{12}\)-character line is off }X\\
A_4&55+55&\text{both \(A_4\)-character lines are off }X
\end{array}
\]

At such a point \(y\), with \(H=\operatorname{Stab}(y)\) and \(\lambda\) the \(\mathcal O(1)\)-character, the first nonzero point jet must lie in
\[
M_{r,D}(y)=
\left[
\operatorname{Sym}^{r}(T_y\mathbf P(W))^\vee
\otimes\lambda^D\otimes W
\right]^H
\]
and must satisfy the initial equation obtained from \(F(p)=0\).

More importantly, all incident restrictions must arise from **one and the same point jet**:

- each \(D_{10}\)-point is incident to five involution planes;
- each \(D_{12}\)-point is incident to seven involution planes and three \(V_4\)-lines;
- each \(A_4\)-point is incident to three involution planes, four \(C_3\)-lines, and one \(V_4\)-line.

Thus plane jets, \(V_4\)-jets, and \(C_3\)-line states cannot be chosen independently and patched afterward. fileciteturn24file0L2-L2

The off-\(X\) \(C_6\)-point should not be added to this compulsory list without further character analysis: \(X^{C_6}\) is nonempty, so stabilizer monotonicity alone does not force it into the base scheme.

---

## 6. The nonlinear equations that every formal state must satisfy

Writing the Klein cubic on \(E_+\oplus E_-\) as
\[
F(z+y)=F_+(z)+B(z;y,y),
\]
the leading \(E_-\)-term \(a_m\) lands automatically because \(F|_{E_-}=0\). The first two nonautomatic equations are

\[
\boxed{B(b_{m+1};a_m,a_m)=0}
\]
and
\[
\boxed{
B(b_{m+3};a_m,a_m)
+2B(b_{m+1};a_m,a_{m+2})
+F_+(b_{m+1})=0.
}
\]

At every later stage one obtains
\[
L_r(p_{m+r})=-R_r(p_m,\ldots,p_{m+r-1}),
\]
with an obstruction class
\[
\omega_r\in\operatorname{coker}L_r.
\]
These equations must be imposed over the global multi-Rees algebra of the \(55\)-plane arrangement, retaining one global coefficient vector for \(p\). Independent local corrections on \(55\) charts are not legitimate. fileciteturn19file0L2-L2

The current computation shows:

- the finite marked-state system has sections;
- the global linear inverse limit is nonzero;
- all three retained families survive the first two nonautomatic nonlinear stages on their generic free-module loci;
- generically \(L_1\) and \(L_3\) are surjective in the computed models, so the first possible obstruction is concentrated on rank-drop loci or at higher order.

Thus the census rules out a finite-state or purely linear negative proof. fileciteturn14file0L2-L2 fileciteturn20file0L2-L2

---

## 7. A separate global necessity: hidden irregular centers

Suppose the hypothetical map
\[
\mathbf P^4\dashrightarrow X
\]
is resolved equivariantly:
\[
Z\longrightarrow\mathbf P^4,
\qquad
f:Z\longrightarrow X.
\]
Since \(f\) has relative dimension one, a \(G\)-invariant relatively ample class gives a split injection
\[
H^3(X,\mathbf Q)\hookrightarrow H^3(Z,\mathbf Q).
\]
For the Klein cubic,
\[
H^{2,1}(X)\simeq W^*
\]
as a five-dimensional irreducible \(G\)-representation.

The blowup formula then forces
\[
\boxed{
W^*
\hookrightarrow
\bigoplus_j
\operatorname{Ind}_{H_j}^{G}H^{1,0}(C_j)
\ \oplus\
\{\text{analogous irregular-surface contributions}\},
}
\]
where the \(C_j\) are positive-genus resolution centers and \(H_j\) their setwise stabilizers.

Every linear stratum and point in the census has \(H^1=0\). Therefore:

\[
\boxed{
\text{The base scheme of an actual landing covariant cannot be resolved
using only the certified planes, lines, and points.}
}
\]

It must create additional nonlinear positive-genus curves or irregular surfaces carrying the required \(W^*\)-isotypic contribution. The subgroup character screen leaves possibilities—for example an \(A_5\)-orbit of genus at least \(5\), an \(11{:}5\)-orbit with a five-dimensional constituent, or various lower-stabilizer high-orbit configurations—so this is not yet a contradiction. fileciteturn30file0L2-L2

---

## 8. Exact burden of a negative proof

Using this mechanism, a proof that the Klein cubic is not \(G\)-unirational must establish one of the following all-degree statements:

1. **Nonlinear landing emptiness:** for every homogeneous degree \(D\) and every common odd plane order \(m\), the global symbolic multi-Rees lifting scheme is empty after all point-link and higher normal-cone conditions are imposed.

2. **Universal elliptic obstruction:** construct a residual-\(S_3\)-equivariant class in the full \(\operatorname{Pic}^0(E_t)\), not merely the finite \(E[2]\)-charge, and prove that its trace or norm is nonzero for every one of the surviving formal families and every \(m,D\).

3. **Hodge-center impossibility:** classify all possible nonlinear resolution centers compatible with the census, and show that none can supply the required copy of \(W^*\) within the degree, multiplicity, and incidence budget of a primitive covariant.

4. **Arithmetic bypass:** prove the generic Klein twist pointless, or prove a generic twist pointless for one subgroup \(H\leq G\). The exact subgroup census has two maximal \(A_5\)-classes; pointlessness for either one would already disprove \(G\)-unirationality.

The most immediately usable new input is the \(V_4\)-line filtration
\[
\operatorname{ord}_{V_4}(p)\geq\frac{3m+1}{2},
\]
with type-II exits delayed to order at least
\[
\frac{3m+3}{2},
\]
combined with the degree-\(330\) character sieve. These should be incorporated into the global nonlinear obstruction tower before another unrestricted degree search.

## [84] user

Apologies. There was not attached census. That last point is starting to look like a intermediate Jacobian type question. The analogy here is that non-rationally chain connected is generally a weaker condition unirational and hence can obstruct it. In the completed examples, the fixed loci were considered instead of the whole variety -- they were not rationally chain connected but the source fixed locus was. Can we do improve the analysis of the fixed loci by obstructing through intermediate Jacobian-like invariants?

## [85] assistant

```
{"paths":["GitHub"],"query":"search"}
```

## [86] tool

The output of this plugin was redacted.

## [87] assistant

The output of this plugin was redacted.

## [88] tool

The output of this plugin was redacted.

## [89] tool

The output of this plugin was redacted.

## [90] assistant

> [thought] I’m examining how fixed loci and exceptional divisors constrain equivariant rational maps. Curves with nontrivial Jacobians obstruct maps from rational fixed loci, but exits through rational components may evade that invariant.

## [91] assistant

Yes, but the invariant has to be attached to the **fixed-locus transition data**, not merely to the fixed locus as an abstract variety.

For the Klein cubic, the ordinary intermediate Jacobian of the threefold cannot obstruct unirationality: smooth cubic threefolds are unirational, while their intermediate Jacobians obstruct rationality. The useful analogy is instead:

\[
\text{fixed component}
\quad+\quad
\text{normal-cone correspondence}
\quad\longmapsto\quad
\text{Abel–Jacobi or Albanese class}.
\]

In the present case this reduces mostly to Jacobians of the elliptic fixed curves.

## 1. Why the current rational-chain-connected argument stops

For an involution \(t\),
\[
X^t=E_t\sqcup L_t,
\]
with \(E_t\) elliptic and \(L_t\simeq \mathbf P^1\). On the source,
\[
\mathbf P(W)^t=\mathbf P(E_+)\sqcup\mathbf P(E_-)
=\mathbf P^2\sqcup\mathbf P^1.
\]

The restriction
\[
\mathbf P^2\dashrightarrow E_t
\]
must be constant, and residual \(S_3\)-equivariance rules out the constant. This forces the plus-plane into the base locus.

But after blowing up that plane, the exceptional divisor is generically
\[
\mathbf P^2\times\mathbf P^1,
\]
and its normal \(\mathbf P^1\)-fibres can map dominantly to the rational component \(L_t\). Thus the map escapes from the non-rationally-chain-connected component through the rational component.

An invariant that only says
\[
E_t\text{ is not rationally chain connected}
\]
cannot see this escape.

## 2. The first genuine refinement: use the Albanese of \(X^t\)

Since
\[
\operatorname{Alb}(X^t)=\operatorname{Alb}(E_t)\simeq E_t,
\]
one can project any fixed-locus correspondence to the elliptic factor.

A hypothetical equivariant resolution produces, over the involution plane, a correspondence
\[
\Gamma_t\subset \widetilde{\mathbf P(W)}^{\,t}\times X^t.
\]
Its component landing in \(E_t\) induces a homomorphism
\[
(\Gamma_t)_*\colon
\operatorname{Alb}\bigl(\widetilde{\mathbf P(W)}^{\,t}\bigr)
\longrightarrow E_t.
\]

If the resolved fixed source were obtained only by blowing up rational centers, its Albanese would remain zero. Therefore any nonzero induced map to \(E_t\) would be impossible.

This yields a useful dichotomy:

\[
\boxed{
\text{Either the entire fixed correspondence is supported on }L_t,
\text{ or the source resolution contains a positive-irregularity center.}
}
\]

The first alternative is what the current normal-cone analysis permits. The second is already close to the “hidden irregular center” requirement arising from \(H^3\), but now it is localized subgroup-by-subgroup.

## 3. Why the unmarked Jacobian still does not close the problem

The leading normal map along the involution plane lands entirely in \(L_t\). Consequently, its pushforward to
\[
J(E_t)=E_t
\]
is zero.

So the plain Jacobian of \(E_t\) sees nothing at first order. This is analogous to the ordinary intermediate Jacobian failing to obstruct a unirational parametrization of a cubic threefold: a correspondence from a rational source may induce a nontrivial multiple on cohomology, but no birational inverse is available.

The invariant has to incorporate the **marked points where the rational and elliptic fixed components interact**.

## 4. The promising object is a generalized or relative Jacobian

For a fixed involution \(t\), the census gives marked subsets on \(E_t\):

- three type-I points,
- nine type-II points,
- the residual \(S_3\)-action,
- the identification
  \[
  \{\text{type-I}\}=\langle q\rangle,
  \qquad
  \{\text{type-II}\}
  =
  \bigcup_{0\neq e\in E_t[2]}(e+\langle q\rangle).
  \]

The rational line \(L_t\) has six type-I points and two \(C_6\)-points. The transition map on \(L_t\) determines how branches over these marked points are permuted.

The appropriate target is therefore not simply \(J(E_t)\), but a generalized Jacobian or relative Picard group such as
\[
J(E_t,D_t)
=
\operatorname{Pic}^0(E_t,D_t),
\]
where \(D_t\) is the marked type-I/type-II divisor, or a quotient retaining the divisor classes relevant to transitions.

There is an exact sequence
\[
1\longrightarrow T_{D_t}
\longrightarrow J(E_t,D_t)
\longrightarrow J(E_t)
\longrightarrow 0,
\]
where \(T_{D_t}\) is a torus recording relative positions and multiplicities at the marked points.

This has two advantages:

1. it sees transition data even when the generic normal image lies in \(L_t\);
2. it remembers more than the existing finite \(E[2]\)-charge.

The current \(E[2]\)-labeling is essentially the torsion shadow of this larger relative Picard invariant.

## 5. A concrete divisor class to extract

Let \(p\) be a hypothetical landing covariant and fix \(t\). After resolving the involution plane, consider the locus on the exceptional divisor where the leading normal map meets one of the marked points of \(L_t\). Its closure intersects the next exceptional or strict-transform strata above the type-I and type-II incidences.

Pushing these intersections to \(E_t\) should produce a degree-zero divisor
\[
\mathcal D_t(p)
=
\sum_{x\in E_t^{\mathrm{I}}\cup E_t^{\mathrm{II}}}
n_x(p)[x]
-
\deg(\cdots)[O]
\in \operatorname{Pic}^0(E_t).
\]

The integers \(n_x(p)\) are not arbitrary. They are determined by:

- the common involution-plane order \(m\);
- the residual degree \(e=d-6m\);
- vanishing orders of the \(D_{12}\)-binary restriction at the six type-I and two \(C_6\) points;
- the three-plane multiplicities along each \(V_4\)-line;
- point-link compatibility at the \(A_4\) and \(D_{12}\) points.

Using the labeling
\[
E_t^{\mathrm I}=\langle q\rangle,\qquad
E_t^{\mathrm {II}}=e_i+\langle q\rangle,
\]
the class necessarily has the form
\[
\mathcal D_t(p)
=
a(p)q+b_1(p)e_1+b_2(p)e_2
\quad\text{in }E_t,
\]
with \(e_3=e_1+e_2\).

The existing finite-state calculation records only whether the \(e_i\)-part is zero or nonzero. A full Jacobian calculation would retain:

- the integral coefficient of \(q\), modulo \(3\);
- the three \(E[2]\)-coset multiplicities;
- potentially non-torsion contributions arising from unmarked branch divisors.

A contradiction would follow if one proves simultaneously that:

\[
\mathcal D_t(p)=0
\]
because it comes from a rational fixed source or a principal transition divisor, while the local multiplicity formulas force
\[
\mathcal D_t(p)\neq0.
\]

## 6. Residual \(S_3\) makes the calculation unusually rigid

Choose the origin so that the residual order-three element is
\[
\rho(x)=x+q,
\]
and a reflection has the form
\[
\sigma(x)=e-x
\]
for some \(e\in E[2]\).

A divisor class compatible with the full residual \(S_3\) must satisfy strong norm conditions. For example,
\[
1+\rho+\rho^2
\]
kills degree-zero classes coming from a single \(C_3\)-orbit in a controlled way. For a point \(x\),
\[
[x]+[x+q]+[x+2q]-3[O]
\]
has Abel sum
\[
3x+3q=3x.
\]
Thus the norm of an orbit detects the image of \(x\) under multiplication by \(3\), while the reflection compares it with an \(E[2]\)-translate.

This suggests considering the operators
\[
N_{C_3}=1+\rho+\rho^2,
\qquad
1-\sigma,
\qquad
N_{S_3}.
\]

Because \(E_t\) has no complex multiplication and
\[
\operatorname{End}(E_t)=\mathbf Z,
\]
there are very few residual-equivariant endomorphisms available. This is a genuine rigidity advantage: a nonzero normal function cannot disappear through an unexpected CM endomorphism.

## 7. Iterated fixed loci are probably essential

A class on one elliptic curve may vanish by symmetry. The stronger construction should compare the \(55\) elliptic curves simultaneously.

At a \(V_4\)-type-II point, three elliptic curves
\[
E_t,\ E_s,\ E_{ts}
\]
meet. The local transition determines divisor classes
\[
\mathcal D_t,\quad \mathcal D_s,\quad \mathcal D_{ts}
\]
whose specializations must agree at the triple point.

This naturally gives a complex of semiabelian varieties
\[
\prod_t J(E_t,D_t)
\longrightarrow
\prod_{V_4} J(\text{marked triple incidence})
\longrightarrow
\prod_{A_4,D_{12}}\cdots.
\]

The desired obstruction is a class in the kernel or cokernel of this diagram. It is the Jacobian analogue of the current linear inverse-limit module, but it retains nonlinear divisor-class information.

The relevant global object is therefore something like
\[
\mathcal J_G
=
\varprojlim_{\mathcal S}
\operatorname{Pic}^0(S,D_S),
\]
where \(\mathcal S\) is the stabilizer-incidence category.

A landing covariant would define a canonical element
\[
\nu(p)\in\mathcal J_G.
\]
The source geometry should force \(\nu(p)=0\), whereas the local normal orders may force a nonzero torsion or non-torsion class.

## 8. Relation to intermediate Jacobians

There are three levels:

\[
\begin{array}{c|c|c}
\text{geometry}&\text{invariant}&\text{role}\\
\hline
\text{fixed curves}&\operatorname{Pic}^0,\operatorname{Alb}&
\text{divisors and marked transitions}\\
\text{fixed surfaces}&\operatorname{Alb},\operatorname{Pic}^0&
\text{irregularity obstruction}\\
\text{fixed threefold-type correspondences}&J^2&
\text{codimension-two cycles}
\end{array}
\]

For the Klein cubic, the first row is the relevant one. Calling it “intermediate Jacobian-like” is accurate conceptually, but technically it is a **marked Albanese/Jacobian obstruction**.

A more literal intermediate Jacobian can appear after forming the graph resolution. Codimension-two cycles supported over fixed strata can produce a normal function valued in
\[
J^2(X)^H
\]
or in Prym-type pieces attached to the fixed correspondence. But for an involution on the five-dimensional Klein representation, the most visible fixed target is an elliptic curve, so the Abel–Jacobi map factors through its ordinary Jacobian. Starting directly with \(J(E_t,D_t)\) is cleaner.

## 9. What can and cannot work

A plain statement that \(J(E_t)\neq0\) will not improve the existing obstruction. Nor will the nontriviality of \(J^2(X)\): unirationality is compatible with both.

The potentially decisive statement is much sharper:

> The normal-cone transition data of any homogeneous landing covariant determine a principal or Abel–Jacobi-trivial marked divisor system on the \(55\) elliptic fixed curves, but the forced multiplicities at type-I and type-II incidences determine a nonzero class in the equivariant inverse limit of their generalized Jacobians.

That is a plausible route to an all-degree obstruction.

## 10. Best concrete next calculation

The first test should be confined to one \(V_4\)-configuration.

For
\[
V_4=\langle t,s\rangle,
\]
compute the transition divisors on
\[
E_t,\ E_s,\ E_{ts}
\]
created by a general minimal normal jet of common plane order \(m\). Express their Abel sums in the bases
\[
\langle q_t\rangle\oplus E_t[2],\qquad
\langle q_s\rangle\oplus E_s[2],\qquad
\langle q_{ts}\rangle\oplus E_{ts}[2].
\]

Then impose:

1. the three-plane monomial inequalities at the \(V_4\)-line;
2. the residual \(C_3\)-cycling;
3. equality at the three type-II triple intersections;
4. the type-I restrictions coming from the three rational minus-lines;
5. principal-divisor relations inherited from the binary \(D_{12}\)-covariants.

There are two possible outcomes:

- all classes vanish formally, showing that Jacobians add no strength at this level;
- a residue depending on \(m\), \(d-6m\), or the endpoint ledger survives.

The second outcome would give an actual obstruction candidate, probably first as a class in
\[
E[6]\quad\text{or}\quad E[2]\oplus E[3],
\]
before attempting the full non-torsion generalized Jacobian.

My assessment is that this is substantially more promising than applying the intermediate Jacobian of the Klein cubic itself. The correct invariant is the **equivariant marked Picard/Albanese system of the fixed elliptic curves**, assembled over the subgroup-incidence diagram.

## [92] user

Think harder please

## [93] assistant

> [thought] I’m reconsidering the proposed fixed-locus strategy rather than assuming it works automatically. I’ll verify the repository’s exact mechanism and distinguish genuine equivariant obstructions from properties that may not survive restriction to fixed loci.

## [94] assistant

> [thought] I’m distinguishing componentwise maps from invariants of the entire fixed locus. A Jacobian-like obstruction may help only when every allowable target component carries nontrivial invariant data; rational components otherwise provide escape routes.

## [95] assistant

```
{"search_query":[{"q":"site:arxiv.org equivariant intermediate Jacobian G-unirationality fixed loci rationally connected varieties"},{"q":"site:arxiv.org Klein cubic PSL(2,11) equivariant unirationality intermediate Jacobian"},{"q":"site:arxiv.org equivariant birational geometry intermediate Jacobian finite group action cubic threefold"},{"q":"site:arxiv.org fixed locus rationally chain connected equivariant unirationality obstruction"}],"response_length":"long"}
```

## [96] tool

The output of this plugin was redacted.

## [97] tool

The output of this plugin was redacted.

## [98] assistant

> [thought] I’m testing whether intermediate-Jacobian-type invariants can strengthen fixed-locus arguments. They may obstruct maps into nonrational components, but rational target components remain exceptions, so the analysis must be componentwise and subgroup-sensitive.

## [99] assistant

```
{"search_query":[{"q":"site:arxiv.org equivariant intermediate Jacobian unirationality finite group dominant rational map"},{"q":"site:arxiv.org \"equivariant intermediate Jacobian\" cubic threefold group action"},{"q":"site:arxiv.org \"intermediate Jacobian\" \"unirationality\" finite group action"},{"q":"site:arxiv.org \"fixed loci\" \"intermediate Jacobian\" equivariant birational"}],"response_length":"long"}
```

## [100] tool

The output of this plugin was redacted.

## [101] tool

The output of this plugin was redacted.

## [102] assistant

> [thought] I’m separating invariants that obstruct rationality from those that obstruct dominant maps. Intermediate Jacobians usually detect stable rationality, not unirationality; for fixed loci, componentwise geometry and unramified or Chow-theoretic invariants may be more appropriate.

## [103] assistant

```
{"search_query":[{"q":"site:arxiv.org cubic threefold involution fixed elliptic curve line intermediate Jacobian decomposition"},{"q":"site:arxiv.org Eckardt cubic threefold involution fixed line elliptic curve intermediate Jacobian"},{"q":"site:arxiv.org \"fixed elliptic curve\" cubic threefold involution Prym"},{"q":"site:arxiv.org \"Eckardt cubic threefold\" intermediate Jacobian involution"}],"response_length":"long"}
```

## [104] assistant

> [thought] I’m correcting the earlier emphasis: intermediate Jacobians can classify involution-fixed geometry, but they don’t obstruct arbitrary unirational maps. The decisive refinement is componentwise, using fixed curves, Prym data, and equivariant Chow or unramified invariants where rational components cannot absorb the obstruction.

> [thought] I’m formulating the strongest version: require simultaneous, polarization-compatible Prym–Tyurin realizations of every involution’s invariant and anti-invariant intermediate-Jacobian pieces, while tracking stabilizers and incidence. This exceeds RCC, but fixed-locus Jacobians alone still cannot rule out rational-component escape.

> [thought] I’m now separating the viable idea from the dead end: fixed-locus Jacobians alone are insufficient, but a global polarized Prym–Tyurin lattice test across all involutions could strengthen the existing obstruction.

> [thought] I’m treating the Prym construction as a target invariant, not yet an obstruction. The promising next step is an integral, polarization-compatible lattice test, coupled to stabilizer and fixed-locus incidence data across the full group.

> [thought] I’m noting a key limitation: each involution’s Prym is already realized by a natural genus-four cover of its fixed elliptic curve. Thus local Jacobian tests pass automatically; only global stabilizer and lattice compatibility could obstruct.

> [thought] I’m correcting the earlier idea: Jacobians of fixed elliptic components alone cannot obstruct maps, because paths may remain on rational lines. The stronger candidate is a global, polarized Prym–Tyurin compatibility condition on resolution centers.

## [105] assistant

```
{"search_query":[{"q":"site:arxiv.org cubic threefold non-Eckardt involution intermediate Jacobian Prym fixed line plane cubic 2026"},{"q":"site:arxiv.org Fano surface Klein cubic intermediate Jacobian E^5 Roulleau"},{"q":"site:arxiv.org equivariant intermediate Jacobian linearizability cubic threefold group action"},{"q":"site:arxiv.org dominant rational maps intermediate Jacobian splitting unirationality cubic threefold"}],"response_length":"long"}
```

## [106] tool

The output of this plugin was redacted.

## [107] tool

The output of this plugin was redacted.

## [108] assistant

```
{"find":[{"ref_id":"turn118187view0","pattern":"rational points"},{"ref_id":"turn118187view0","pattern":"points defined over Q"},{"ref_id":"turn118187view0","pattern":"Albanese morphism"},{"ref_id":"turn118187view0","pattern":"v0 − v1"},{"ref_id":"turn118187view0","pattern":"curve C0"},{"ref_id":"turn118187view0","pattern":"fixed point"}],"response_length":"long"}
```

## [109] tool

The output of this plugin was redacted.

## [110] assistant

> [thought] I’m correcting the earlier idea: \(J(E_t)\) alone is too weak. The natural object is the polarized Prym \(J(X)^t\), but it obstructs only through a global, integral, \(G\)-compatible center decomposition—not fixed-locus geometry by itself.

> [thought] I’m replacing the naive fixed-elliptic Jacobian with a global polarized Prym–Tyurin condition. The strongest concrete route tracks Abel–Jacobi classes of rational exit lines, then exploits V4 symmetry and Fano-surface incidence relations.

## [111] assistant

```
{"search_query":[{"q":"site:arxiv.org 2210.14397 cubic threefold involution intermediate Jacobian fixed line elliptic curve Prym"},{"q":"site:arxiv.org 1001.4853 Fano surface Klein cubic intermediate Jacobian E^5"},{"q":"site:arxiv.org 1002.4467 genus 2 curve configurations Fano surfaces Klein cubic involutions"},{"q":"site:arxiv.org 2403.06047 Intermediate Jacobians and linearizability"}],"response_length":"long"}
```

## [112] tool

The output of this plugin was redacted.

## [113] tool

The output of this plugin was redacted.

## [114] tool

The output of this plugin was redacted.

## [115] tool

The output of this plugin was redacted.

## [116] assistant

Yes—but the previous answer was aimed at the wrong object.

There are **two distinct improvements**:

1. a fixed-locus **Albanese torsor/index obstruction**, which genuinely strengthens rational-chain-connectedness and plugs into the normal-cone machine; and  
2. an **invariant intermediate Jacobian/Prym obstruction** for the pair \((X,t)\), which strengthens the current Hodge-center screen from representation theory to isogeny theory.

The first gives a concrete new mod-\(3\) restriction on the live normal jets. The second rules out the obvious fixed elliptics as the hidden Hodge centers, but also identifies a canonical genus-\(4\) escape.

## 1. Ordinary intermediate Jacobians do not obstruct unirationality

The naive analogy is not quite right. The intermediate Jacobian obstructs rationality of a cubic threefold, but not unirationality: smooth cubic threefolds are the standard example of varieties that are unirational but not rational. citeturn486730search4

Thus, for a fixed component \(T\subset X^H\), merely showing that \(J(T)\neq 0\) is not in general enough to exclude a dominant rational map from a rational source. One needs either:

\[
\text{a functorial obstruction under dominant maps},
\]

or

\[
\text{a torsor class together with restriction/corestriction}.
\]

The equivariant intermediate-Jacobian-torsor formalism developed recently is designed primarily for equivariant birationality and projective linearizability, where weak factorization gives exact decompositions of principally polarized abelian varieties. It does not transfer unchanged to a dominant map of relative dimension one. citeturn786300view1

For the Klein cubic fixed loci, the relevant positive-genus component is only a curve anyway. Its “intermediate Jacobian” is its Albanese/Jacobian. The real extra information comes from the **normalizer action on the Albanese torsor**, not from the abelian variety alone.

## 2. Important correction: the class lives in an Albanese torsor, not in \(\operatorname{Pic}^0\) as a translated point

For an involution \(t\), write

\[
X^t=E_t\sqcup L_t,
\qquad
N_G(\langle t\rangle)/\langle t\rangle\simeq S_3.
\]

Choose a type-I point \(O\in E_t\) as origin. Let \(\rho\) generate the residual \(C_3\), and choose a reflection \(\sigma\) fixing \(O\). Then

\[
\rho(P)=P+q,\qquad 0\neq q\in E_t[3],
\]
and
\[
\sigma(P)=-P.
\]

Here is the correction to my last response, and also to a convenient shorthand used in the current Picard packet:

> Translation by \(q\) acts trivially on \(\operatorname{Pic}^0(E_t)\) by pullback.  
> The nontrivial \(q\) occurs in the affine action on \(E_t=\operatorname{Alb}^1(E_t)\), or equivalently on \(\operatorname{Pic}^1(E_t)\).

Let

\[
A_t=\operatorname{Alb}(E_t)\simeq E_t.
\]

The **linear** residual action on \(A_t\) is

\[
\rho|_{A_t}=1,\qquad \sigma|_{A_t}=[-1].
\]

The affine action on the torsor \(E_t\) is encoded by the cocycle

\[
c_t(\rho)=q,\qquad c_t(\sigma)=0.
\]

It gives a canonical class

\[
\alpha_t=[c_t]\in H^1(S_3,A_t^{\mathrm{lin}}).
\]

Inflation–restriction for \(C_3\triangleleft S_3\) gives

\[
H^1(S_3,A_t^{\mathrm{lin}})
\simeq A_t[3],
\]

and under this identification

\[
\boxed{\alpha_t=q\neq0.}
\]

Changing the origin changes the cocycle by a coboundary, so the cohomology class is intrinsic.

This is the correct one-dimensional analogue of an equivariant intermediate-Jacobian torsor.

## 3. The fixed elliptic has equivariant index exactly \(3\)

The three type-I points

\[
\{O,O+q,O+2q\}
\]

form an \(S_3\)-invariant divisor of degree \(3\). Therefore the generic residual \(S_3\)-twist of \(E_t\) has a zero-cycle of degree \(3\).

On the other hand, \(\alpha_t\neq0\) has order \(3\). Hence that twisted genus-one curve has

\[
\boxed{\operatorname{period}=\operatorname{index}=3.}
\]

This yields an exact transfer theorem.

### Fixed-elliptic transfer theorem

Let \(B\) be a rationally connected residual-\(S_3\) variety, let

\[
\pi:C\dashrightarrow B
\]

be a dominant generically finite \(S_3\)-equivariant map of degree \(n\), and suppose there is an \(S_3\)-equivariant rational map

\[
\phi:C\dashrightarrow E_t.
\]

Then

\[
\boxed{3\mid n.}
\]

Indeed, on a suitable open subset define the trace

\[
T_\phi(b)
=
\sum_{x\in\pi^{-1}(b)}\phi(x)\in E_t.
\]

Since \(B\) is rationally connected, \(T_\phi:B\dashrightarrow E_t\) is constant. But residual translation gives

\[
T_\phi(\rho b)
=
T_\phi(b)+nq.
\]

Therefore \(nq=0\), so \(3\mid n\).

This contains the old rational-chain obstruction as the case \(n=1\). It also contains the repository’s order-twelve quadratic trace obstruction as the case \(n=2\), where the contradiction is \(2q=-q\neq0\). The current Picard packet proves precisely that special quadratic case, while noting that no bridge to the three surviving global families had been established. fileciteturn5file0L2-L2

This is a genuine strengthening:

\[
\text{RCC says degree \(1\) is impossible;}
\]

\[
\text{the Albanese torsor says every elliptic multisection has degree divisible by \(3\).}
\]

## 4. This gives a new restriction on the first normal-cone degeneracy curve

Fix \(t\), let

\[
Z_t=\mathbf P(E_+(t))\simeq\mathbf P^2,
\]

and write the first terms of a degree-\(d\) covariant of common odd plane order \(m\) as

\[
p=a_m+b_{m+1}+a_{m+2}+b_{m+3}+\cdots,
\]

where the \(a\)'s are \(E_-\)-valued and the \(b\)'s are \(E_+\)-valued.

Put

\[
r=d-m.
\]

On the exceptional divisor

\[
\mathcal E_t
=
\mathbf P(E_+)\times\mathbf P(E_-)
\simeq
\mathbf P^2\times\mathbf P^1,
\]

the two components of \(a_m\) are sections of

\[
\mathcal O_{\mathbf P^2\times\mathbf P^1}(r,m).
\]

Let

\[
C_t=V(a_m)
\subset\mathbf P^2\times\mathbf P^1.
\]

On the regular locus, this is the complete intersection of two divisors of bidegree \((r,m)\). Its projection to the normal-direction factor

\[
\pi_t:C_t\longrightarrow\mathbf P(E_-)\simeq\mathbf P^1
\]

has degree

\[
\deg \pi_t=r^2,
\]

provided there are no vertical components.

At a point of \(C_t\), the leading \(E_-\)-term has vanished. If \(b_{m+1}\) is generically nonzero on a horizontal component, then along the pure next-normal direction it becomes the first nonzero term. The identity \(F(p)=0\) therefore forces

\[
F_+(b_{m+1})=0
\]

on that component, giving a residual-\(S_3\)-equivariant map

\[
[b_{m+1}]:C_t\dashrightarrow E_t.
\]

The transfer theorem gives

\[
3\mid r^2,
\]

hence

\[
\boxed{3\mid d-m.}
\]

More generally, if \(C_t\) is reducible, every residual-\(S_3\)-stable horizontal union on which \(b_{m+1}\) is generically nonzero must have degree divisible by \(3\) over \(\mathbf P^1\).

There is a sharper consequence on the irreducible regular-complete-intersection locus. If \(3\nmid r\), then \(b_{m+1}\) must vanish on \(C_t\). But each component of \(b_{m+1}\) has bidegree

\[
(r-1,m+1).
\]

For a regular complete intersection \(C_t\),

\[
H^0\!\left(
I_{C_t}(r-1,m+1)
\right)=0.
\]

This follows immediately from the Koszul resolution: the would-be coefficients multiplying the equations of \(C_t\) have bidegree \((-1,1)\), and the possible intervening \(H^1\) also vanishes on \(\mathbf P^2\times\mathbf P^1\). Consequently,

\[
\boxed{
C_t\text{ regular and irreducible},\quad
3\nmid(d-m)
\quad\Longrightarrow\quad
b_{m+1}=0.
}
\]

This appears to be a new restriction relative to the present packet. It does not kill the formal family, because \(b_{m+1}=0\) remains possible, but it pushes the family onto a proper closed locus and forces the next exit to occur through \(a_{m+2}\) or a more singular leading scheme.

For the recorded families:

- \(e=1\), \(d=6m+1\):
  \[
  d-m=5m+1,
  \]
  so a nonzero first elliptic exit requires
  \[
  \boxed{m\equiv1\pmod3.}
  \]

- General residual degree \(e=d-6m\):
  \[
  d-m=5m+e,
  \]
  so
  \[
  \boxed{e\equiv m\pmod3}
  \]
  is necessary for a nonzero \(b_{m+1}\) on an irreducible regular \(C_t\).

- In the based-minus-line family:
  \[
  \boxed{d\equiv m\pmod3}
  \]
  or the first plus-valued correction must vanish on the full leading degeneracy curve.

Thus the torsor interpretation is not merely philosophical. It converts the existing isolated quadratic trace into an all-order, degree-theoretic normal-cone condition.

## 5. The literal intermediate Jacobian attached to the involution is a Prym, not \(J(E_t)\)

There is also a genuinely intermediate-Jacobian-level invariant, but it belongs to the **pair**

\[
(X,t),
\]

not to \(E_t\) alone.

An involution of this type on a cubic threefold is a non-Eckardt involution: its fixed locus is a line and a plane cubic. Projecting from the fixed line produces a conic bundle whose discriminant is

\[
E_t\cup Q_t,
\]

where \(Q_t\) is a conic. The associated discriminant cover restricts to a double cover

\[
\widetilde E_t\longrightarrow E_t
\]

branched in the six points \(E_t\cap Q_t\). The invariant part of the intermediate Jacobian is a three-dimensional polarized abelian variety of type \((1,2,2)\), and is the dual Prym of this double cover:

\[
J(X)^t
\simeq
P(\widetilde E_t/E_t)^\vee.
\]

The double cover has genus \(4\), and its Prym has dimension \(3\). citeturn532241search1turn896900view1turn896900view3

For the Klein cubic, Roulleau computes

\[
J(X)\simeq \mathbb E_{-11}^{\,5}
\]

as an unpolarized abelian variety, where

\[
\mathbb E_{-11}
=
\mathbf C/\mathbf Z\!\left[\frac{-1+i\sqrt{11}}2\right]
\]

has CM by \(\mathbf Q(\sqrt{-11})\). citeturn227525view0

On the other hand, the fixed elliptic has

\[
j(E_t)=\frac{8192}{11},
\]

and has no CM. fileciteturn5file0L2-L2

It follows that

\[
E_t\not\sim\mathbb E_{-11}
\]

under isogeny, while

\[
J(X)^t\sim\mathbb E_{-11}^{\,3},
\qquad
J(X)^{-t}\sim\mathbb E_{-11}^{\,2}.
\]

Consequently,

\[
\boxed{
J(E_t)\text{ is not an isogeny factor of }J(X)^t.
}
\]

This is an important conceptual point: the intermediate-Jacobian information of the involution is not the Jacobian of the visible fixed elliptic. It is the Prym supplied by the fixed elliptic **together with its six-point normal/conic-bundle decoration**.

Moreover,

\[
J(\widetilde E_t)
\sim
E_t\times P(\widetilde E_t/E_t)
\sim
E_t\times\mathbb E_{-11}^{\,3}.
\]

So the canonical genus-\(4\) cover \(\widetilde E_t\) simultaneously contains:

- the non-CM elliptic factor needed for a nonconstant fixed-locus map to \(E_t\);
- the CM threefold factor \(J(X)^t\) required by the intermediate Jacobian.

This is both the obstruction and the natural escape.

## 6. The Hodge-center theorem can be strengthened from characters to abelian varieties up to isogeny

The current Hodge-center packet proves that a resolution

\[
Z\longrightarrow\mathbf P^4,
\qquad
f:Z\longrightarrow X
\]

gives a split \(G\)-equivariant injection

\[
H^3(X,\mathbf Q)\hookrightarrow H^3(Z,\mathbf Q),
\]

and hence that \(H^{2,1}(X)\simeq W^*\) must occur among the \(H^{1,0}\) spaces of positive-irregularity blowup centers. It stops at a character-theoretic screen and correctly notes that this has considerable slack. fileciteturn6file0L2-L2

One can strengthen that statement categorically. After a Tate twist, the split injection is an injection of polarizable rational Hodge structures of weight one. Hence, by the equivalence between such Hodge structures and complex abelian varieties up to isogeny,

\[
\boxed{
J(X)
\text{ is a \(G\)-equivariant isogeny factor of the product of the
Jacobians/Albanese varieties of the positive-irregularity centers.}
}
\]

This is strictly stronger than the character screen.

In particular, suppose the only irregular centers introduced were copies of the \(55\) fixed elliptics. Their Albanese contribution would be isogenous to

\[
E_t^{55}.
\]

But

\[
\operatorname{Hom}\!\left(\mathbb E_{-11},E_t\right)=0,
\]

so

\[
\operatorname{Hom}\!\left(J(X),E_t^{55}\right)=0.
\]

Therefore:

\[
\boxed{
\text{The orbit of fixed elliptics cannot supply the required intermediate
Jacobian of the Klein cubic.}
}
\]

This removes a genuine false positive from a purely representation-theoretic center screen: the complex \(G\)-representation may fit while the rational Hodge structure and isogeny type do not.

For an individual involution \(t\), the same refinement says that the center system must supply

\[
\mathbb E_{-11}^{\,3}
\]

in the \(t\)-invariant part and

\[
\mathbb E_{-11}^{\,2}
\]

in the anti-invariant part. For a \(t\)-stable curve center \(C\), these pieces are, up to isogeny,

\[
J(C/t)
\quad\text{and}\quad
P(C/C/t),
\]

respectively.

Thus the correct fixed-locus/Hodge requirement is not merely “some center has positive genus.” It is:

\[
\boxed{
\text{some center carries the correct CM-\(11\) Jacobian/Prym factor with
the correct involution parity.}
}
\]

## 7. The remaining obstruction gap

There are still two genuine escape mechanisms.

First, a dominant equivariant map does not imply that a component of the resolved \(t\)-fixed source dominates \(E_t\). A general point of \(E_t\) may have a source fiber on which \(t\) acts freely. Therefore no invariant of \(E_t\) alone can obstruct the global map until the normal-cone analysis forces an **elliptic exit**. The degeneracy curve \(C_t=V(a_m)\) is precisely the first natural place where such an exit can be forced.

Second, the canonical genus-\(4\) cover

\[
\widetilde E_t\to E_t
\]

shows that the local and global requirements are mutually compatible in principle:

\[
J(\widetilde E_t)
\sim
E_t\times\mathbb E_{-11}^{\,3}.
\]

So the isogeny refinement does not by itself contradict existence. Instead, it predicts the exact minimal kind of hidden center that could evade both obstructions.

## Verdict

The useful strengthening is therefore:

\[
\boxed{
\text{RCC fixed-locus obstruction}
\quad\rightsquigarrow\quad
\text{normalizer-equivariant Albanese torsor of index \(3\)}
}
\]

at the local level, together with

\[
\boxed{
\text{character-valued Hodge-center condition}
\quad\rightsquigarrow\quad
\text{CM Prym/isogeny-valued center condition}
}
\]

at the global level.

The first produces the explicit restriction

\[
3\mid(d-m)
\]

for a generic first elliptic exit and forces \(b_{m+1}=0\) on the regular irreducible leading-degeneracy locus otherwise. The second proves that the \(55\) fixed elliptics themselves cannot be the hidden centers and singles out the genus-\(4\) Prym cover \(\widetilde E_t\) as the minimal plausible escape.

The right next calculation is to construct \(C_t=V(a_m)\) for the live \(e=1\) family as an exact residual-\(S_3\) curve, determine its horizontal component degrees and the restriction of \(b_{m+1}\), and test whether any surviving component can carry the canonical genus-\(4\) cover \(\widetilde E_t\) or its CM Prym factor.

## [117] user

Think harder please and respond

## [118] assistant

```
bash -lc rm -rf /tmp/unirational && git clone --depth 1 https://github.com/mattrobball/unirational.git /tmp/unirational >/tmp/clone.log 2>&1 && echo OK && du -sh /tmp/unirational && git -C /tmp/unirational rev-parse HEAD
```

## [119] tool

The output of this plugin was redacted.

## [120] assistant

```
{"search_query":[{"q":"site:github.com/mattrobball/unirational \"rationally chain connected\""},{"q":"site:github.com/mattrobball/unirational \"fixed locus\" unirationality obstruction"},{"q":"site:github.com/mattrobball/unirational PSL 2 7 fixed locus"}],"response_length":"long"}
```

## [121] tool

The output of this plugin was redacted.

## [122] assistant

```
{"open":[{"ref_id":"https://api.github.com/repos/mattrobball/unirational/git/trees/main?recursive=1"}],"response_length":"long"}
```

## [123] assistant

> [thought] I’m checking the analogy carefully. Rational connectedness transfers through suitable dominant rational maps, while intermediate-Jacobian invariants usually obstruct rationality rather than unirationality. Fixed-locus arguments need equivariant resolution and careful control of induced maps.

## [124] assistant

> [thought] I’m distinguishing broad rational-connectedness obstructions from sharper equivariant invariants. Albanese and \(\mathrm{CH}_0\) arguments may be more reliable for fixed curves, while intermediate Jacobians require precise functorial maps and hypotheses.

## [125] assistant

> [thought] I’m tracing how curve and surface centers contribute to \(H^3\) and the intermediate Jacobian. Equivariance may force compatible group representations, potentially restricting centers, but this remains conditional rather than automatic.

## [126] assistant

> [thought] I’m considering a sharper route: generic twists and intermediate-Jacobian torsors may obstruct rational points directly. Fixed-locus methods could then provide specialized residue obstructions, but the precise subgroup compatibility still needs verification.

## [127] assistant

```
bash -lc true
```

## [128] tool

The output of this plugin was redacted.

## [129] assistant

```
{"search_query":[{"q":"site:arxiv.org equivariant intermediate Jacobian torsor group action cubic threefold fixed locus"},{"q":"site:arxiv.org cubic threefold involution fixed elliptic curve Prym intermediate Jacobian"},{"q":"site:arxiv.org intermediate Jacobian torsors equivariant birationality finite group actions"},{"q":"site:arxiv.org Albanese torsor fixed locus equivariant unirationality"}],"response_length":"long"}
```

## [130] tool

The output of this plugin was redacted.

## [131] assistant

> [thought] I’m correcting the invariant: \(\operatorname{Pic}^n(E_t)\), not merely \(\operatorname{Pic}^0(E_t)\), records residual symmetry. Its fixed classes recover the four marked charges, but they still don’t exclude escape through \(L_t\simeq\mathbf P^1\).

> [thought] I’m narrowing the claim: \(\operatorname{Pic}^n(E_t)\) gives a genuine fixed-locus obstruction, with \(3\mid n\) and charge in \(E_t[2]\). Higher intermediate Jacobians constrain hidden centers, but don’t independently rule out unirational parametrizations.

> [thought] I’m extending the fixed-locus argument: a first elliptic exit of degree \(n\) must satisfy \(3\mid n\), with residual charge in \(E_t[2]\). Normal-jet geometry may impose this sieve, though reducible or later exits remain unresolved.

## [132] assistant

```
import sympy as sp
M=sp.Matrix([[-1,2,0,0],[-1,0,2,0],[-1,0,0,3]])
from sympy.matrices.normalforms import smith_normal_form
from sympy.polys.domains import ZZ
smith_normal_form(M, domain=ZZ)

```

## [133] assistant

```
{"search_query":[{"q":"site:arxiv.org non-Eckardt involution cubic threefold invariant intermediate Jacobian Prym elliptic curve six branch points"},{"q":"site:arxiv.org equivariant intermediate Jacobian torsor unirationality rational maps fixed loci"},{"q":"site:arxiv.org Klein cubic intermediate Jacobian E_-11 fifth power"}],"response_length":"long"}
```

## [134] tool

The output of this plugin was redacted.

## [135] assistant

```
bash -lc rm -rf /tmp/unirational && git clone --depth 1 https://github.com/mattrobball/unirational.git /tmp/unirational >/tmp/clone.log 2>&1; rc=$?; tail -20 /tmp/clone.log; exit $rc
```

## [136] tool

The output of this plugin was redacted.

## [137] assistant

```
{"paths":["GitHub"],"query":"fetch_file"}
```

## [138] tool

The output of this plugin was redacted.

## [139] tool

The output of this plugin was redacted.

## [140] tool

The output of this plugin was redacted.

## [141] tool

The output of this plugin was redacted.

## [142] assistant

```
{"paths":["GitHub"],"query":"directory"}
```

## [143] tool

The output of this plugin was redacted.

## [144] tool

The output of this plugin was redacted.

## [145] tool

The output of this plugin was redacted.

## [146] tool

The output of this plugin was redacted.

## [147] tool

The output of this plugin was redacted.

## [148] tool

The output of this plugin was redacted.

## [149] tool

The output of this plugin was redacted.

## [150] tool

The output of this plugin was redacted.

## [151] tool

The output of this plugin was redacted.

## [152] tool

The output of this plugin was redacted.

## [153] tool

The output of this plugin was redacted.

## [154] tool

The output of this plugin was redacted.

## [155] tool

The output of this plugin was redacted.

## [156] tool

The output of this plugin was redacted.

## [157] assistant

The sharper answer is:

\[
\boxed{\text{No stronger invariant of the abstract fixed locus alone is likely to work.}}
\]

But there is a genuine improvement obtained by replacing the fixed locus with its **normalizer-equivariant Albanese torsor and normal-slice Prym data**. This gives new restrictions on the normal-cone families and strengthens the repository’s Hodge-center screen. It does not yet give a contradiction, because the first viable transition curves have enough Jacobian to absorb all the required factors.

Two claims in my previous answer were too optimistic:

1. non-CM versus CM is useful, but the cleaner obstruction is representation-theoretic;
2. Prym Torelli cannot be applied merely from the existing Hodge injection, since that injection only supplies a rational isogeny factor, not the naturally polarized Prym.

## 1. Why the ordinary intermediate Jacobian is the wrong invariant

For an involution \(t\),
\[
X^t=E_t\sqcup L_t,
\qquad
E_t\text{ elliptic},\quad L_t\simeq\mathbf P^1.
\]

As a variety, the only nontrivial odd Hodge or birational \(1\)-motivic information of \(X^t\) is
\[
\operatorname{Pic}^0(X^t)=J(E_t)=E_t.
\]
There is no higher intermediate Jacobian of the fixed locus waiting to be used. The statement that a rationally chain connected source cannot map nontrivially to \(E_t\) is already exactly the Albanese/Jacobian obstruction.

More generally, an intermediate Jacobian is not monotone in the direction needed for unirationality. Smooth cubic threefolds themselves are unirational and have highly nontrivial intermediate Jacobians; the intermediate Jacobian distinguishes rationality, not unirationality. citeturn629345search5

So the improvement cannot be

\[
X^t\longmapsto J(X^t).
\]

It must remember how components of the resolved source fixed locus are **created by normal-cone blowups**, together with the residual \(S_3\)-action.

## 2. The standard global equivariant IJ-torsor obstruction is already trivial here

The recently developed equivariant intermediate-Jacobian-torsor machinery is aimed principally at equivariant birational linearizability. citeturn631144view1 For the Klein action, its standard degree-one torsor is neutralized by an elementary cycle.

There are \(55\) involution-fixed lines
\[
L_t=\mathbf P(E_-(t))\subset X,
\]
forming one \(G\)-orbit. fileciteturn12file0L2-L2 Let \(h\) be the hyperplane class. Then

\[
\deg h^2=3,\qquad
\deg\left(\sum_t L_t\right)=55.
\]

Therefore
\[
z:=\sum_t [L_t]-18h^2\in CH^2(X)
\]
is a \(G\)-invariant codimension-two cycle of degree
\[
55-18\cdot3=1.
\]

Thus the degree-one intermediate-Jacobian torsor has a \(G\)-fixed point represented by \(z\). In particular,

\[
\boxed{\text{the usual global equivariant IJ-torsor cannot obstruct this action.}}
\]

This is a useful negative result: the promising invariant must be localized at the fixed-stratum transition system, not applied globally in the standard form.

## 3. A concrete improvement of the Hodge-center packet

The residual group on \(E_t\) is
\[
D_{12}/\langle t\rangle\simeq S_3.
\]
After choosing an origin, a residual \(3\)-cycle acts by
\[
\rho(P)=P+q,\qquad 0\neq q\in E_t[3],
\]
while each reflection acts as
\[
\sigma(P)=e-P
\]
for some \(e\in E_t[2]\). fileciteturn16file0L2-L2

Consequently, on the one-dimensional space of differentials,
\[
\rho^*\omega=\omega,\qquad
\sigma^*\omega=-\omega.
\]
Hence
\[
\boxed{
H^{1,0}(E_t)\simeq\operatorname{sgn}_{S_3},
}
\]
inflated to \(D_{12}\).

This resolves an explicit open item in the repository’s Hodge-center packet. That packet computes
\[
\operatorname{Res}^{G}_{S_3}H^{2,1}(X)
\simeq
\mathbf 1\oplus 2\,\mathrm{std},
\]
with **no sign representation**. Equivalently, the \(D_{12}\)-restriction contains the trivial representation and two two-dimensional representations, but no relevant nontrivial linear representation. fileciteturn10file0L2-L2

Therefore Frobenius reciprocity gives
\[
\operatorname{Hom}_{G}\!\left(
H^{2,1}(X),
\operatorname{Ind}_{D_{12}}^G H^{1,0}(E_t)
\right)
=
\operatorname{Hom}_{D_{12}}\!\left(
H^{2,1}(X)|_{D_{12}},
\operatorname{sgn}
\right)
=0.
\]

So:

\[
\boxed{
\text{The orbit of \(55\) fixed elliptics cannot supply the required
\(H^{2,1}(X)\) in a resolution.}
}
\]

This is stronger and cleaner than merely noting that \(E_t\) is non-CM. It removes the most geometrically obvious positive-genus channel from the Hodge-center list. The necessary positive-irregularity centers must be genuinely new curves or irregular surfaces created inside the base-resolution tower. The corrected split injection underlying that requirement is the repository’s relatively ample class argument. fileciteturn9file0L2-L2

## 4. The correct fixed-locus refinement is a blowup-center Albanese invariant

Consider a \(t\)-equivariant blowup
\[
\widetilde Y=\operatorname{Bl}_C(Y).
\]
Over a component of \(C^t\), decompose the normal bundle into \(t\)-eigenspaces:
\[
N_{C/Y}=N_+\oplus N_-.
\]
The new components of \(\widetilde Y^t\) are projective bundles of the form
\[
\mathbf P(N_+)\longrightarrow C^t,
\qquad
\mathbf P(N_-)\longrightarrow C^t.
\]
Their Albanese varieties are therefore the Albanese varieties of the corresponding components of \(C^t\).

This gives an inductive statement:

> If the initial source fixed components have trivial Albanese, then the first resolved fixed component that maps nonconstantly to \(E_t\) must be created over a positive-genus fixed center \(C\), and \(E_t\) must be an isogeny quotient of \(\operatorname{Alb}(C)\).

Thus the appropriate enhancement of rational-chain-connectedness is not the Jacobian of the target fixed locus alone. It is the **Albanese data of the entire fixed-component/center tree**.

For the Klein problem, this center tree is visible in the normal-cone expansion: the first exceptional fixed component maps generically to the rational line \(L_t\), and a center where the leading \(E_-\)-valued jet vanishes is the first place from which a new component could jump to \(E_t\).

## 5. The residual \(S_3\)-torsor has exact index \(3\)

The affine \(S_3\)-action on \(E_t\) defines an intrinsic class
\[
\alpha_t\in H^1(S_3,E_t),
\]
represented after choosing an origin by
\[
\alpha_t(\rho)=q,\qquad
\alpha_t(\sigma)=0.
\]
Its restriction to \(C_3=\langle\rho\rangle\) is the nonzero class \(q\in E_t[3]\). Hence
\[
\operatorname{ord}(\alpha_t)=3.
\]

Equivalently, every residual-\(S_3\)-invariant zero-cycle on \(E_t\) has degree divisible by \(3\): the \(C_3\)-action is free, while the type-I orbit supplies an invariant divisor of degree \(3\). Thus the equivariant period and index are exactly
\[
\boxed{3.}
\]

This produces a genuine strengthening of the RCC argument.

### Transfer lemma

Let \(B\) be rationally chain connected, and suppose
\[
\pi:C\longrightarrow B
\]
is a generically finite residual-\(S_3\)-equivariant morphism of degree \(n\), together with an equivariant nonconstant map
\[
\phi:C\longrightarrow E_t.
\]

Taking the norm of \(\phi\) along \(\pi\) gives a rational map
\[
B\dashrightarrow \operatorname{Pic}^n(E_t).
\]
It is constant because \(B\) is rationally chain connected. But residual translation by \(q\) changes that norm by \(nq\). Therefore
\[
nq=0,
\]
and hence
\[
\boxed{3\mid n.}
\]

The original fixed-locus obstruction is the special case \(n=1\). The refined statement excludes every multisection whose degree is prime to \(3\).

## 6. Application to the first normal-cone transition curve

Let \(d\) be the degree of a hypothetical homogeneous landing covariant and \(m\) its common odd order along the involution plus-planes. Put
\[
r=d-m.
\]

On the first exceptional divisor
\[
M_t=
\mathbf P(E_+(t))\times\mathbf P(E_-(t))
\simeq\mathbf P^2\times\mathbf P^1,
\]
the leading minus-valued jet is
\[
a_m\in
H^0\!\left(M_t,\mathcal O(r,m)\right)\otimes E_-.
\]
Let
\[
C_t=Z(a_m)\subset M_t.
\]

On the regular locus this is the complete intersection of two divisors of bidegree \((r,m)\). Projection to the normal-direction factor gives
\[
\pi_t:C_t\longrightarrow\mathbf P(E_-)\simeq\mathbf P^1
\]
of degree
\[
\deg\pi_t=r^2.
\]

Suppose \(C_t\) is smooth and irreducible and the next plus-valued term
\[
b_{m+1}
\]
is not identically zero on \(C_t\). Then the first nonzero target direction along \(C_t\) is \(E_+\)-valued, and the landing equation forces
\[
[b_{m+1}]:C_t\longrightarrow E_t.
\]
The transfer lemma gives
\[
3\mid r^2,
\]
and therefore
\[
\boxed{3\mid d-m.}
\]

There is a second condition. A residual \(3\)-cycle has:

- three projective fixed points on \(\mathbf P(E_+)\), of weights \(0,1,2\);
- two projective fixed points on \(\mathbf P(E_-)\), of weights \(1,2\).

Thus \(M_t\) has six residual-\(C_3\)-fixed points. Since \(C_3\) acts freely on \(E_t\), an equivariant morphism \(C_t\to E_t\) forces \(C_t\) to avoid those six points.

At a fixed pair of weights \((i,j)\), equivariance permits \(a_m\) to be nonzero only in target weight
\[
ri+mj\pmod3.
\]
Once \(3\mid r\), this is nonzero at all six fixed points exactly when
\[
3\nmid m.
\]

Hence on the smooth irreducible first-exit locus,
\[
\boxed{
d-m\equiv0\pmod3,\qquad m\not\equiv0\pmod3.
}
\]

For the minimal residual family
\[
d=6m+1,
\]
this becomes
\[
5m+1\equiv0\pmod3,
\]
so
\[
m\equiv1\pmod3.
\]
Since \(m\) is already odd,
\[
\boxed{m\equiv1\pmod6.}
\]

More generally, writing
\[
e=d-6m,
\]
the condition is
\[
\boxed{e\equiv m\pmod3,\qquad 3\nmid m.}
\]

These statements are conditional on a smooth irreducible horizontal transition curve. In the reducible case, the corresponding divisibility applies to every residual-\(S_3\)-stable horizontal union on which the elliptic exit is actually defined; components on which all plus-valued corrections vanish can absorb the forbidden fixed points.

## 7. The transition curve has much more Jacobian than the fixed elliptic

The same calculation shows why this is not already a contradiction.

For a smooth regular complete intersection \(C_t\) of type
\[
(r,m),(r,m)
\quad\text{in}\quad
\mathbf P^2\times\mathbf P^1,
\]
adjunction gives
\[
g(C_t)
=
1+r(3rm-3m-r).
\]

Assume the residual \(C_3\) acts freely and the section is generic along the reflection-fixed loci. Each reflection has two fixed \(\mathbf P^1\)'s on \(M_t\), and the restriction of \(a_m\) gives one degree-\(r\) equation on each. Thus each reflection fixes \(2r\) points of \(C_t\).

Let
\[
H^0(C_t,\omega_{C_t})
\simeq
\mathbf1^{\,a}
\oplus
\operatorname{sgn}^{\,b}
\oplus
\operatorname{std}^{\,c}.
\]
Riemann–Hurwitz and the \(C_3\)-free condition give
\[
\begin{aligned}
a&=
1+\frac{r(3rm-3m-r-3)}6,\\[2mm]
b&=
\frac{r(3rm-3m-r+3)}6,\\[2mm]
c&=
\frac{r(3rm-3m-r)}3.
\end{aligned}
\]

The first live \(e=1\) case is
\[
(m,d,r)=(1,7,6).
\]
Then
\[
g(C_t)=55
\]
and
\[
H^0(C_t,\omega_{C_t})
\simeq
\mathbf1^{\,7}
\oplus
\operatorname{sgn}^{\,12}
\oplus
\operatorname{std}^{\,18}.
\]

So this first bridge curve contains:

- abundant sign representations, enough to map to \(E_t\);
- abundant trivial and standard representations, enough at the character level to supply \(H^{2,1}(X)^t\simeq\mathbf1\oplus\operatorname{std}\).

Therefore:

\[
\boxed{\text{the character-valued Jacobian obstruction does not kill the first live family.}}
\]

This is the important correction to an overly optimistic “genus-four bridge” picture. The canonical genus-four cover is the smallest conceptual model, but the actual first normal-cone transition curve can have genus \(55\).

## 8. The genuine intermediate-Jacobian object is a Prym attached to \((X,t)\)

For a non-Eckardt involution on a cubic threefold, the fixed locus consists of a line and a smooth plane cubic. Projection from the pointwise fixed line produces a double cover
\[
\widetilde E_t\longrightarrow E_t
\]
branched at six points. The invariant part of the intermediate Jacobian is a three-dimensional abelian variety with polarization type \((1,2,2)\), and
\[
J(X)^t
\simeq
P(\widetilde E_t/E_t)^\vee.
\]
Moreover, this Prym determines the involutive cubic threefold by a global Torelli theorem. citeturn160125view0

This is the correct “intermediate Jacobian of the fixed locus,” but it is not an invariant of \(E_t\) alone. It uses

\[
\boxed{\text{the fixed elliptic }+\text{ its six-point normal/conic-bundle decoration}.}
\]

For the Klein cubic, Roulleau proves that, as an unpolarized abelian variety,
\[
J(X)\simeq \mathbb E_{-11}^{\,5},
\qquad
\mathbb E_{-11}
=
\mathbf C/
\mathbf Z\!\left[\frac{-1+i\sqrt{11}}2\right].
\]
citeturn939366view0

Consequently,
\[
J(X)^t\sim\mathbb E_{-11}^{\,3}
\]
up to isogeny.

By contrast,
\[
j(E_t)=\frac{8192}{11},
\]
so \(E_t\) has no CM. fileciteturn16file0L2-L2

This gives an **isogeny-level** refinement of the Hodge-center screen:

> The relevant trivial-plus-standard part of the Jacobians or Albanese varieties of the resolution centers must contain an \(\mathbb E_{-11}^{\,3}\) factor, while any actual elliptic bridge contributes the non-CM sign factor \(E_t\).

This is much sharper than checking only complex characters.

## 9. Why Prym Torelli does not immediately finish the argument

The canonical double cover has genus
\[
g(\widetilde E_t)=4,
\]
and up to isogeny
\[
J(\widetilde E_t)
\sim
E_t\times P(\widetilde E_t/E_t).
\]

Thus one curve can simultaneously carry:

- the non-CM elliptic sign factor \(E_t\);
- the CM threefold factor \(J(X)^t\).

This is an explicit geometric compatibility mechanism, not a contradiction.

Furthermore, the Hodge-center injection in the repository is obtained from
\[
s(\beta)=\frac1n f_*(\eta\cup\beta).
\]
It is an injection of rational polarized Hodge structures up to a scalar determined by \(\eta\). It does not identify the natural integral polarization on a center’s Prym with the \((1,2,2)\)-polarization on \(J(X)^t\). Therefore global Prym Torelli cannot be invoked merely from the statement that \(J(X)^t\) is an isogeny factor. fileciteturn8file0L2-L2

A second gap is that \(H^3(X)^t\) need not come only from centers lying in the \(t\)-fixed normal-cone tower. A pair of positive-genus centers exchanged by \(t\) also contributes a diagonal \(t\)-invariant copy of \(H^1\). Thus the Prym factor need not be carried by the same curve that mediates the elliptic exit.

This is the central obstruction to turning the idea into an immediate proof.

## 10. The strongest viable formulation

The correct invariant is a combination of two systems.

### The fixed-transition \(1\)-motive

For every subgroup \(H\leq G\), retain:

\[
\operatorname{Alb}^1(X^H),
\quad
\operatorname{Pic}^0(X^H),
\]
their normalizer actions, the restriction maps along \(K\supseteq H\), and norm maps in the opposite direction.

For the involution nodes this includes the order-three affine torsor
\[
\alpha_t\in H^1(S_3,E_t).
\]
The existing \(E[2]\)-charge ledger is only the finite torsion shadow of this larger object.

Equivariant blowups add the Albanese \(1\)-motives of the fixed parts of their centers. Thus the natural structure is a Mackey-type \(1\)-motive over the subgroup orbit category, with blowup-center corrections.

### The Hodge/Prym isogeny system

The resolution must also satisfy
\[
H^3(X,\mathbf Q)
\hookrightarrow
\bigoplus_i
\operatorname{Ind}_{H_i}^G
H^1(C_i,\mathbf Q)(-1)
\oplus
\{\text{irregular-surface terms}\}
\]
as rational \(G\)-Hodge structures.

The refinement is to require not merely the correct character but the actual CM Hodge structure:
\[
J(X)\sim\mathbb E_{-11}^{\,5}
\]
must occur as a \(G\)-equivariant isogeny factor.

For a fixed involution, this requires
\[
\mathbb E_{-11}^{\,3}
\]
inside the residual
\[
\mathbf1\oplus\operatorname{std}
\]
sector, while any bridge to \(E_t\) creates a sign-sector quotient.

An obstruction would follow from the all-center statement
\[
\operatorname{Hom}_{\mathrm{HS},S_3}
\left(
H^1(J(X)^t),
\bigoplus_i H^1(C_i)_{\mathbf1\oplus\operatorname{std}}
\right)
=0
\]
for every center system admitted by the normal-cone tower and its \(t\)-exchanged companions.

## 11. The most productive next computation

The first serious test should be the live family
\[
(m,d)=(1,7).
\]

For its universal smooth bridge curve
\[
C_t=Z(a_1)\subset\mathbf P^2\times\mathbf P^1,
\qquad
C_t\text{ of type }(6,1)^2,
\]
the following can be done exactly:

1. Compute the quotient curves
   \[
   C_t/C_3,\qquad C_t/S_3,
   \]
   and the Prym factors corresponding to the sign and standard idempotents of \(\mathbf Q[S_3]\).

2. Verify the map to \(E_t\) on the sign factor and recover the index-three transfer condition.

3. Test whether the
   \[
   \mathbf1\oplus\operatorname{std}
   \]
   factor contains
   \[
   \mathbb E_{-11}^{\,3}.
   \]
   At the arithmetic level this imposes divisibility of the relevant Frobenius polynomials by the Frobenius polynomial of \(\mathbb E_{-11}\) to the required powers at every good prime.

4. Perform this test over the actual global equalizer/landing locus, not on arbitrary local \(D_{12}\)-sections. A generic non-CM result is insufficient: the landing equations may cut out a special Hodge locus.

5. Add centers exchanged by \(t\) through the full Mackey induction calculation. Otherwise a missing Prym factor in \(C_t\) alone is not yet an obstruction.

If the required CM factor is absent from every permitted center channel, this would be a genuine all-degree obstruction. If it is present, it should identify an explicit geometric Prym mechanism behind a possible \(G\)-unirational parametrization.

## Verdict

The refined picture is:

\[
\boxed{
\begin{aligned}
\text{abstract fixed locus}
&\Rightarrow \text{nothing beyond RCC/Albanese};\\
\text{marked fixed locus}
&\Rightarrow \text{an exact index-three transfer obstruction};\\
\text{normal-decorated fixed pair}
&\Rightarrow \text{a CM Prym/isogeny requirement}.
\end{aligned}}
\]

The immediate rigorous gains are:

\[
\boxed{
H^{1,0}(E_t)=\operatorname{sgn},
\quad
\text{so the \(55\) fixed elliptics cannot supply }H^{2,1}(X);
}
\]

and, for a smooth irreducible first elliptic-exit curve,

\[
\boxed{
d-m\equiv0\pmod3,\qquad 3\nmid m.
}
\]

For the minimal \(e=1\) family this forces
\[
\boxed{m\equiv1\pmod6.}
\]

But the first surviving bridge curve has genus \(55\) and ample trivial, sign, and standard isotypic pieces. Consequently the next genuinely stronger obstruction must be **isogeny-valued**, detecting the required \(\mathbb E_{-11}^{\,3}\) Prym factor, not merely genus, rational connectedness, or representation multiplicities.

## [158] user

Read the current state of the repository mattrobball/unirational in folder problem E for the Klein cubic. Then 
1. Answer the question: what degrees for a G-unirational map been excluded? Follow up, if a large range of degrees are excluded computationally, then that would seem to point to non-unirationality, right? 
2. Answer the question: have we exhausted the potential applications of the obstructions similar to the exact applications of OD_16 del Pezzo and Fermat cubic? This means we can negatively conclude unirationality just by inspecting the image of particular H-fixed subvarieties.
3. Answer the question: what are the most promising remaining methods for complete resolution of headline problem? 
4. For each of the ones in 3, author markdown files providing the exact problem and goal. Push those to a folder in the repo. I will put codex sol ultra in goal mode - one instance for each problem.

## [159] assistant

```
{"query":"The user asks for a current technical audit of the Klein cubic Problem E in mattrobball/unirational and to create/push work-order markdown files. Retrieve any prior user preferences about how these mathematical work orders should be structured, ranked, or pushed to the repository."}
```

## [160] assistant

```
{"paths":["GitHub"],"query":"commit"}
```

## [161] assistant

The output of this plugin was redacted.

## [162] tool

The output of this plugin was redacted.

## [163] assistant

The output of this plugin was redacted.

## [164] tool

The output of this plugin was redacted.

## [165] assistant

The output of this plugin was redacted.

## [166] tool

The output of this plugin was redacted.

## [167] assistant

The output of this plugin was redacted.

## [168] tool

The output of this plugin was redacted.

## [169] assistant

The output of this plugin was redacted.

## [170] tool

The output of this plugin was redacted.

## [171] assistant

```
{"paths":["GitHub"],"query":"tree"}
```

## [172] assistant

The output of this plugin was redacted.

## [173] tool

The output of this plugin was redacted.

## [174] assistant

```
{"paths":["GitHub"],"query":"file"}
```

## [175] assistant

The output of this plugin was redacted.

## [176] tool

The output of this plugin was redacted.

## [177] assistant

The output of this plugin was redacted.

## [178] tool

The output of this plugin was redacted.

## [179] assistant

The output of this plugin was redacted.

## [180] tool

The output of this plugin was redacted.

## [181] assistant

```
{"uri":"/response/turn18","query":"excluded through"}
```

## [182] tool

The output of this plugin was redacted.

## [183] tool

The output of this plugin was redacted.

## [184] tool

The output of this plugin was redacted.

## [185] assistant

```
{"uri":"/response/turn18","query":"Landing self-covariants are now excluded through degree 24"}
```

## [186] tool

The output of this plugin was redacted.

## [187] tool

The output of this plugin was redacted.

## [188] assistant

The output of this plugin was redacted.

## [189] tool

The output of this plugin was redacted.

## [190] assistant

```
{"uri":"/response/turn18","query":"earlier quotient calculations still supply the exclusions through degree 15"}
```

## [191] tool

The output of this plugin was redacted.

## [192] assistant

```
{"uri":"/response/turn19","query":"Landing self-covariants are now excluded through degree 24"}
```

## [193] tool

The output of this plugin was redacted.

## [194] tool

The output of this plugin was redacted.

## [195] tool

The output of this plugin was redacted.

## [196] assistant

> [thought] I’m reviewing the available research context to identify the most promising paths. The main options involve a normalization branch, a difficult chart calculation, or a degree-25 covariant-support approach that remains unresolved.

## [197] assistant

The output of this plugin was redacted.

## [198] tool

The output of this plugin was redacted.

## [199] assistant

The output of this plugin was redacted.

## [200] tool

The output of this plugin was redacted.

## [201] assistant

```
{"paths":["GitHub"],"query":"contents"}
```

## [202] assistant

```
{"uri":"/response/turn15","start_line":1,"num_lines":60}
```

## [203] tool

The output of this plugin was redacted.

## [204] tool

The output of this plugin was redacted.

## [205] assistant

```
{"uri":"/response/turn19","query":"16"}
```

## [206] tool

The output of this plugin was redacted.

## [207] tool

The output of this plugin was redacted.

## [208] tool

The output of this plugin was redacted.

## [209] tool

The output of this plugin was redacted.

## [210] tool

The output of this plugin was redacted.

## [211] tool

The output of this plugin was redacted.

## [212] tool

The output of this plugin was redacted.

## [213] tool

The output of this plugin was redacted.

## [214] tool

The output of this plugin was redacted.

## [215] tool

The output of this plugin was redacted.

## [216] tool

The output of this plugin was redacted.

## [217] assistant

```
{"uri":"/response/turn19","query":"Degree 22 is closed"}
```

## [218] tool

The output of this plugin was redacted.

## [219] tool

The output of this plugin was redacted.

## [220] tool

The output of this plugin was redacted.

## [221] tool

The output of this plugin was redacted.

## [222] tool

The output of this plugin was redacted.

## [223] assistant

```
{"uri":"/response/turn19","query":"Degree 25 is the first"}
```

## [224] tool

The output of this plugin was redacted.

## [225] tool

The output of this plugin was redacted.

## [226] tool

The output of this plugin was redacted.

## [227] assistant

> [thought] I’m distinguishing homogeneous covariant degree from the projective degree of a rational map. The current result excludes primitive self-covariants through degree 24; degree 25 remains open, while invariant factors may complicate direct degree comparisons.

## [228] assistant

The output of this plugin was redacted.

## [229] tool

The output of this plugin was redacted.

## [230] assistant

The output of this plugin was redacted.

## [231] tool

The output of this plugin was redacted.

## [232] assistant

The output of this plugin was redacted.

## [233] tool

The output of this plugin was redacted.

## [234] assistant

> [thought] I’m mapping how fixed source components interact with target fixed loci. The obstruction forces base behavior in some components, but residual normal-direction maps can still survive, so the mechanism may not yet exhaust all cases.

## [235] assistant

> [thought] I’m assessing whether fixed-locus arguments are fully exhausted. The current picture suggests they are: positive-dimensional components either force base behavior or still permit normal-direction exits, leaving no immediate global contradiction.

## [236] assistant

The output of this plugin was redacted.

## [237] tool

The output of this plugin was redacted.

## [238] assistant

The output of this plugin was redacted.

## [239] tool

The output of this plugin was redacted.

## [240] assistant

The output of this plugin was redacted.

## [241] tool

The output of this plugin was redacted.

## [242] assistant

> [thought] I’m preparing a ranked research plan: confirm exclusions through degree 24, explain why fixed-locus tests remain inconclusive, then define bounded work packages for degree 25, nonlinear support, and cohomological obstructions with reproducible certificates and stopping rules.

> [thought] I’m prioritizing two headline routes: a negative degree-three/index obstruction through normalized target geometry, and a positive twisted-Fano construction. Secondary packages will test degree 25 and nonlinear cohomological obstructions with explicit certificates.

## [243] assistant

The output of this plugin was redacted.

## [244] tool

The output of this plugin was redacted.

## [245] assistant

The output of this plugin was redacted.

## [246] tool

The output of this plugin was redacted.

## [247] assistant

```
{"uri":"/response/turn19","query":"exhaust"}
```

## [248] tool

The output of this plugin was redacted.

## [249] tool

The output of this plugin was redacted.

## [250] tool

The output of this plugin was redacted.

## [251] tool

The output of this plugin was redacted.

## [252] tool

The output of this plugin was redacted.

## [253] tool

The output of this plugin was redacted.

## [254] tool

The output of this plugin was redacted.

## [255] tool

The output of this plugin was redacted.

## [256] tool

The output of this plugin was redacted.

## [257] tool

The output of this plugin was redacted.

## [258] tool

The output of this plugin was redacted.

## [259] assistant

The output of this plugin was redacted.

## [260] tool

The output of this plugin was redacted.

## [261] assistant

```
{"uri":"/response/turn29","query":"self-covariant"}
```

## [262] tool

The output of this plugin was redacted.

## [263] assistant

The output of this plugin was redacted.

## [264] tool

The output of this plugin was redacted.

## [265] assistant

```
{"uri":"/response/turn30","query":"landing self-covariant"}
```

## [266] tool

The output of this plugin was redacted.

## [267] assistant

```
{"paths":["GitHub"],"query":"ref"}
```

## [268] assistant

```
{"uri":"/response/turn26","query":"tree"}
```

## [269] tool

The output of this plugin was redacted.

## [270] assistant

```
{"uri":"/response/turn26","start_line":1,"num_lines":20}
```

## [271] tool

The output of this plugin was redacted.

## [272] tool

The output of this plugin was redacted.

## [273] assistant

The output of this plugin was redacted.

## [274] tool

The output of this plugin was redacted.

## [275] assistant

```
{"uri":"/response/turn27","query":"# 4. Track P25V"}
```

## [276] tool

The output of this plugin was redacted.

## [277] tool

The output of this plugin was redacted.

## [278] assistant

The output of this plugin was redacted.

## [279] tool

The output of this plugin was redacted.

## [280] assistant

The output of this plugin was redacted.

## [281] tool

The output of this plugin was redacted.

## [282] assistant

The output of this plugin was redacted.

## [283] tool

The output of this plugin was redacted.

## [284] assistant

The output of this plugin was redacted.

## [285] tool

The output of this plugin was redacted.

## [286] assistant

The output of this plugin was redacted.

## [287] tool

The output of this plugin was redacted.

## [288] assistant

The output of this plugin was redacted.

## [289] tool

The output of this plugin was redacted.

## [290] assistant

The output of this plugin was redacted.

## [291] tool

The output of this plugin was redacted.

## [292] assistant

The output of this plugin was redacted.

## [293] tool

The output of this plugin was redacted.

## [294] assistant

The output of this plugin was redacted.

## [295] tool

The output of this plugin was redacted.

## [296] assistant

The output of this plugin was redacted.

## [297] tool

The output of this plugin was redacted.

## [298] assistant

The output of this plugin was redacted.

## [299] tool

The output of this plugin was redacted.

## [300] assistant

The output of this plugin was redacted.

## [301] tool

The output of this plugin was redacted.

## [302] assistant

```
{"uri":"skills://plugins/github/yeet/skill.md","start_line":1,"num_lines":240}
```

## [303] tool

The output of this plugin was redacted.

## [304] tool

The output of this plugin was redacted.

## [305] tool

The output of this plugin was redacted.

## [306] tool

The output of this plugin was redacted.

## [307] tool

The output of this plugin was redacted.

## [308] tool

The output of this plugin was redacted.

## [309] tool

The output of this plugin was redacted.

## [310] assistant

I read the current `problems/E-klein-cubic` state through the pre-dispatch head

```text
715faf441289e2589b9325311b6613ea0331bf88
```

including the theorem-boundary repair, the degree-24 cutoff, the global fixed-stratum machine, the current target-branch/fold work, degree 25, and the compressed Pfaffian algebra. The headline remains open. fileciteturn30file0

## 1. Which degrees have been excluded?

### Exact answer

Within the repository’s accepted reduction to homogeneous landing self-covariants, every positive degree

\[
\boxed{1\le d\le 24}
\]

has been excluded.

Here \(d\) means the homogeneous polynomial degree of a primitive equivariant map

\[
p:W\longrightarrow W,
\qquad
F(p)=0,
\]

defining

\[
[x]\longmapsto[p(x)].
\]

It is not the topological degree of a generically finite map. A common scalar polynomial factor should first be removed, since it does not change the resulting projective rational map.

The exclusions break down as follows:

| Degrees | Exact exclusion |
|---|---|
| \(1\)–\(15\) | Earlier complete quotient calculations |
| \(16\) | Restriction to an involution plus-plane is injective |
| \(17\)–\(19\) | Full cubic coefficient rank on the complete restriction kernels |
| \(20\)–\(21\) | Every exact projective chart is a unit ideal |
| \(22\) | Linear compression \(25\to12\to4\to0\) |
| \(23\) | Compression to 20 variables; 392 necessary cubics give the unit ideal on all 20 charts |
| \(24\) | One exceptional first-jet line is reduced to a 20-variable system; 484 cubics give the unit ideal on all 20 charts |

The projective-DVR argument transfers the special-fibre emptiness used in the last part of the calculation to characteristic zero. Degree \(25\) is explicitly recorded as the **first unresolved degree** in this route. fileciteturn19file0

An important audit point is that this cutoff does **not** depend on treating the historical degree-13 and degree-19 tower residuals as obstruction theorems. Those labels were correctly downgraded to sample residuals. The independent forced-plus-plane landing calculations still exclude the actual degree-13 and degree-19 schemes as part of the complete \(1\)–\(24\) result. fileciteturn7file0

### Does excluding \(1\)–\(24\) point toward non-unirationality?

It is meaningful evidence, but substantially weaker than “24 consecutive degrees” initially suggests.

The negative evidence is real:

- the cutoff is exact, not a random search;
- several mathematically different mechanisms all produce emptiness;
- any equivariant parametrization must now have primitive degree at least \(25\).

But there is a structural change at degree \(25\):

- the arrangement-compatible degree-25 space has rank \(43\);
- the complete landing row space has exact rank \(746\) in the certified special fibre;
- only one of the three main kernel strata has been proved empty;
- the full degree-25 projective support remains undecided;
- the normal-cone tower has formal solutions because later kernel parameters cancel earlier nonzero residuals. fileciteturn41file0

More importantly, the all-degree fixed-stratum calculation shows that for each fixed odd plane order \(m\), compatible plane jets grow as \(O(d^2)\), while the presently imposed line and point constraints grow only as \(O(d)\). Consequently, the linear necessary-state module is nonzero for every odd \(m\) and all sufficiently large \(d\). Three explicit global formal families survive. fileciteturn25file0

So my reading is:

\[
\boxed{\text{The cutoff is weak-to-moderate negative evidence, not strong asymptotic evidence.}}
\]

It proves a large lower bound on the minimal degree. It does not exhibit a trend toward eventual emptiness. In fact, the current asymptotic and degree-25 evidence says that the low-degree obstruction mechanisms become progressively less restrictive.

A single primitive solution in degree \(25\), \(31\), \(43\), or much higher would settle the problem positively. There is no theorem that the first solution, if one exists, should occur at a small degree.

## 2. Have the OD\(_{16}\)/Fermat-style fixed-locus applications been exhausted?

There are two different meanings of “fixed-locus obstruction.”

### The direct mechanism has been exhausted

If the intended mechanism is:

> Choose \(H\le G\), inspect a component of \(\mathbf P(W)^H\), observe that its image must lie in \(X^H\), and obtain an immediate contradiction from the geometry or normalizer action,

then the answer is essentially **yes**. The exact census closes the linear eigenspace and intersection strata for all relevant subgroup types, and the transition machine tests their compatible images. fileciteturn12file0

The outcomes are:

- For an involution \(t\), the plus-plane
  \[
  \mathbf P(E_+(t))\simeq\mathbf P^2
  \]
  is forced into the base locus: a nonconstant map to the elliptic component \(E_t\) is impossible, and residual \(S_3\) rules out a constant.

- This does **not** give a contradiction. After blowing up the plane, its normal \(\mathbf P^1\)-directions can map to the rational fixed component
  \[
  L_t=\mathbf P(E_-(t))\subset X^t.
  \]

- The \(V_4\)-fixed lines are also forced base strata, but their normal directions have compatible exits toward type-I points and elliptic components.

- The \(C_3\)-eigenlines are not forced base strata: order-zero maps constant at the appropriate \(C_6\)-point are locally allowed.

- The type-I/type-II incidences are globally consistent rather than contradictory.

- The finite marked-state screen has three surviving global families.

- The full linear inverse limit is nonzero in characteristic zero.

Thus:

\[
\boxed{
\text{No choice of a single original \(H\)-fixed linear subvariety currently yields non-unirationality.}
}
\]

That is the substantive difference from the completed \(OD_{16}\) and Fermat examples. In those examples, the fixed-locus image had nowhere compatible to go. For the Klein cubic, the rational line components and normal exits provide escape channels.

### Higher fixed-centre invariants have not been logically exhausted

One could still use information attached to the **resolved fixed-component tree**, such as:

- Albanese or Picard varieties of positive-genus blowup centres;
- Prym factors arising from involution-compatible covers;
- equivariant \(1\)-motives;
- Abel–Jacobi classes of normal-cone transition correspondences;
- integral Hodge or isogeny restrictions stronger than the existing character screen.

But this is no longer the elementary “inspect the image of \(\mathbf P(W)^H\)” argument.

The current Hodge theorem proves that a resolution must create nonlinear positive-genus curves or irregular surfaces, because the certified linear centres contribute no \(H^1\). However, the subgroup-character screen leaves 40 possible channels and finds no numerical contradiction. fileciteturn9file0 fileciteturn10file0 fileciteturn11file0

Therefore the precise verdict is:

\[
\boxed{
\begin{aligned}
&\text{Direct, order-zero OD\(_{16}\)/Fermat-style applications: exhausted and unsuccessful;}\\
&\text{resolved-centre/Jacobian/Prym refinements: not exhausted, but no current obstruction.}
\end{aligned}}
\]

I would not launch another worker whose task is merely “try more subgroups.” Any further fixed-locus project needs a new invariant that survives blowups and imposes an exact constraint on the existing nonlinear transition families.

## 3. Most promising remaining complete-resolution methods

### 1. Target-branch index-three obstruction — negative headline

The full fixed-frame cubic already has index three over the rational subfield

\[
F=\mathbf C(A,B,Y,Z),
\]

and the extension \(K_{\rm proj}/F\) has exact degree six and full \(S_6\) monodromy. A multiplicity-one target branch of residue degree one has been identified. The remaining negative gate is to prove that the generic cubic over that branch still has index three.

The ordinary Picard calculation is complete. The missing object is the horizontal three-primary part of

\[
\operatorname{Cl}/\operatorname{Pic}
\]

after normalization. This route can directly prove non-unirationality.

The latest fold result sharpens the task: the chart `(P_B,P_Y,P_Z)` cannot describe the full singular locus because it has exact extraneous Delta-open points. A successful continuation must use the full gate-saturated singular ideal, a different valid chart, or direct normalization of the target branch. fileciteturn26file0

This is the strongest current negative route.

### 2. Pfaffian–Morita common-line construction — positive headline

The descended degree-six central simple algebra and its symplectic involution are conceptually understood. The maximal-étale compression reduces the characteristic-zero reconstruction from thousands of nominal entries to 258 rational functions.

The exact target is a common isotropic right line for five specific Hermitian forms, equivalently a genuine \(K_{\rm proj}\)-point of the twisted Fano section \(F_{14,T}\).

This route has a direct positive bridge, but it must avoid the repeatedly identified scope error:

\[
\text{point of the auxiliary Pfaffian cubic}
\;\not\Rightarrow\;
\text{point of }F_{14,T}.
\]

The genuine common-line problem remains open. fileciteturn40file0

I rank this second by **headline leverage**. By near-term computational tractability, degree 25 may be slightly ahead of it.

### 3. Exact degree-25 landing support — positive headline or scoped negative

Degree \(25\) is the first open homogeneous degree. Unlike a general high-degree search, it is already a finite, structured decision problem:

- exact rank-43 coefficient model;
- exact rank-746 landing row space at \(p=89\);
- finite lower module;
- one major kernel stratum already empty;
- two projective strata still unresolved.

A characteristic-zero point gives an actual landing covariant and a positive headline. Empty special fibre gives an exact degree-25 exclusion but only advances the cutoff to \(25\). fileciteturn41file0

This is probably the best near-term exact computation.

### 4. Universal all-degree nonlinear lifting theorem — negative or positive headline

This is the direct structural route to a complete answer by covariants.

The current fixed-stratum machine already supplies:

- complete local transition modules;
- global compatible formal families;
- a nonzero linear inverse limit;
- a finite terminal system in every fixed degree;
- a symbolic free-fibre recurrence.

The missing theorem is finite generation—or an effective replacement—for the **full** multigraded equalizer/Fitting system, including triple lines, point links, elliptic markings, symbolic powers, and irrelevant torsion.

Once that theorem exists, the infinitely many degrees could be reduced to finite data. Without it, another degree ladder has no headline force. fileciteturn42file0

This is the most conceptually complete negative route, but also the furthest from an immediate computation.

### Lower-ranked routes

I did not create separate top-level packets for:

- the marked degree-19 Schur curve;
- KLS minimality/conductor;
- a standalone Hodge-centre screen;
- another original fixed-locus search.

They remain mathematically live, but each currently has a weaker bridge or substantially more surviving geometry than the four routes above.

## 4. Goal files pushed

The files were pushed directly to `main` under:

```text
problems/E-klein-cubic/goals_2026-08-01/
```

The final repository head after the additions is:

```text
089bdc6f10e033d124e79568d2fb8e14f8b03d05
```

The dispatch index contains shared theorem-boundary, verification, resource, and concurrency rules. fileciteturn38file0

The four worker files are:

1. **Target branch / index three** — exact normalization, conductor, local and global `Cl/Pic mod 3`, and headline bridge. fileciteturn39file0

2. **Pfaffian–Morita Fano point** — compressed characteristic-zero algebra, involution, quaternion corner, five Hermitian forms, and common line. fileciteturn40file0

3. **Degree-25 landing support** — full saturated projective support, exact candidate verification or special-fibre emptiness, and correct scoped/headline exits. fileciteturn41file0

4. **All-degree nonlinear lifting** — construction of the correct universal multigraded object, finite-generation replacement, finite reduction, and all-degree decision. fileciteturn42file0

The five commits are:

```text
aaab49f9f78c6f5955690131500032671f748e0d  Goal T
e495a5877a47a0df165ba4d2099cc98189f78083  Goal C
28faa47551fd341e78927b081d6e44585b8c00c4  Goal P25
8560c9b1a2321e57179070f0262c8505bb87ce38  Goal G
089bdc6f10e033d124e79568d2fb8e14f8b03d05  Dispatch index
```

For four simultaneous instances, the clean assignment is one file per worker, with each writing only to the route-specific `goal_runs/` directory specified in its packet.

## [311] user

We are going all out. Think hard and include other routes. Include all that are plausible. 

## [312] user

Push those too

## [313] assistant

> [thought] I’m checking the current repository state and recent changes before adding materially different mathematical routes. I’ll compare existing files, identify plausible alternatives, update the ranking if needed, and commit the work cleanly.

## [314] assistant

```
{"paths":["GitHub"],"query":"search"}
```

## [315] tool

The output of this plugin was redacted.

## [316] assistant

The output of this plugin was redacted.

## [317] tool

The output of this plugin was redacted.

## [318] tool

The output of this plugin was redacted.

## [319] tool

The output of this plugin was redacted.

## [320] tool

The output of this plugin was redacted.

## [321] tool

The output of this plugin was redacted.

## [322] tool

The output of this plugin was redacted.

## [323] assistant

```
{"paths":["GitHub"],"query":"fetch_commit"}
```

## [324] tool

The output of this plugin was redacted.

## [325] assistant

> [thought] I’m expanding the search beyond the existing four directions, including fixed-centre geometry, equivariant birational links, direct Schur-twist point searches, subgroup obstructions, and exact conic-intersection algebra.

## [326] assistant

The output of this plugin was redacted.

## [327] tool

The output of this plugin was redacted.

## [328] assistant

```
{"uri":"/response/turn16","query":"## 7. Route H"}
```

## [329] assistant

```
{"uri":"/response/turn16","query":"proper-subgroup twists"}
```

## [330] tool

The output of this plugin was redacted.

## [331] tool

The output of this plugin was redacted.

## [332] tool

The output of this plugin was redacted.

## [333] assistant

```
{"uri":"/response/turn16","query":"Route S19"}
```

## [334] tool

The output of this plugin was redacted.

## [335] tool

The output of this plugin was redacted.

## [336] tool

The output of this plugin was redacted.

## [337] assistant

```
{"uri":"/response/turn16","query":"S19.1 — universal"}
```

## [338] tool

The output of this plugin was redacted.

## [339] tool

The output of this plugin was redacted.

## [340] tool

The output of this plugin was redacted.

## [341] assistant

```
{"uri":"/response/turn16","query":"Route KLS"}
```

## [342] tool

The output of this plugin was redacted.

## [343] tool

The output of this plugin was redacted.

## [344] tool

The output of this plugin was redacted.

## [345] assistant

```
{"uri":"/response/turn16","query":"Route H"}
```

## [346] tool

The output of this plugin was redacted.

## [347] tool

The output of this plugin was redacted.

## [348] tool

The output of this plugin was redacted.

## [349] assistant

```
{"uri":"/response/turn16","query":"H1 — two maximal"}
```

## [350] tool

The output of this plugin was redacted.

## [351] tool

The output of this plugin was redacted.

## [352] tool

The output of this plugin was redacted.

## [353] tool

The output of this plugin was redacted.

## [354] assistant

```
{"uri":"/response/turn19","query":"KLS"}
```

## [355] tool

The output of this plugin was redacted.

## [356] tool

The output of this plugin was redacted.

## [357] tool

The output of this plugin was redacted.

## [358] tool

The output of this plugin was redacted.

## [359] tool

The output of this plugin was redacted.

## [360] tool

The output of this plugin was redacted.

## [361] tool

The output of this plugin was redacted.

## [362] tool

The output of this plugin was redacted.

## [363] tool

The output of this plugin was redacted.

## [364] tool

The output of this plugin was redacted.

## [365] tool

The output of this plugin was redacted.

## [366] tool

The output of this plugin was redacted.

## [367] tool

The output of this plugin was redacted.

## [368] tool

The output of this plugin was redacted.

## [369] assistant

Pushed an **all-out portfolio of 15 independent goal-mode routes** to:

```text
problems/E-klein-cubic/goals_2026-08-01/
```

Final head:

```text
3569d63da8edae0f1e7b5a714232002a23d4e767
```

The expanded index ranks the routes, distinguishes overlapping approaches, assigns isolated output directories, and includes shared theorem-boundary and resource rules. fileciteturn30file0

### Added beyond the original four

1. `GOAL_S19_SCHUR_CURVE.md`  
   Construct the marked degree-19 rational curve and execute the audited positive bridge.

2. `GOAL_KLS_MINIMALITY_CONDUCTOR.md`  
   Prove the missing minimality-to-discrepancy theorem, classify all conductor configurations, and eliminate them.

3. `GOAL_H_SUBGROUP_TWISTS.md`  
   Make a proper-subgroup generic twist pointless, beginning independently with both maximal \(A_5\) classes.

4. `GOAL_F_CONIC_INTERSECTION_ALGEBRA.md`  
   Find an \(F\)-conic whose six-point intersection algebra with the fixed-frame cubic is \(K_{\rm proj}\).

5. `GOAL_Q_SCHUR_INDEX_ONE_DESCENT.md`  
   Turn the genuine index-one Schur zero-cycle into a rational point, or prove pointlessness despite index one.

6. `GOAL_M_SARKISOV_BIRATIONAL_MODELS.md`  
   Blow up legitimate \(G\)- or Galois-stable centres and run the full two-ray game to useful Mori fibre spaces.

7. `GOAL_J_FIXED_CENTRE_PRYM.md`  
   Develop the resolved fixed-centre Albanese/Prym/\(1\)-motive and polarized-Hodge obstruction discussed earlier.

8. `GOAL_COV_STRUCTURED_POSITIVE_SEARCH.md`  
   Search structurally selected degrees beyond 24 for an explicit primitive landing covariant, rather than running a consecutive degree ladder.

9. `GOAL_D_EQUIVARIANT_DEGREE_MOTIVE.md`  
   Seek an integral equivariant degree formula, motive, Chow/cobordism, or quotient-stack canonical-dimension obstruction.

10. `GOAL_V_VALUATION_TROPICAL_POINTLESSNESS.md`  
    Search systematically for a simpler decisive valuation or tropical degeneration than the current target branch.

11. `GOAL_R_RATIONAL_CURVES_ON_TWIST.md`  
    Attack Hilbert schemes of twisted cubics, rational quartics, and other rational curves on the genuine generic twist.

Together with the original target-branch, Pfaffian–Morita, degree-25, and all-degree lifting packets, these cover the serious arithmetic, invariant-theoretic, birational, fixed-centre, motivic, valuation, subgroup, and constructive directions presently visible. The index also explains why similarly named routes are genuinely distinct—for example Pfaffian common lines versus conic intersection algebras, and marked degree-19 curves versus unrestricted Schur descent versus direct rational-curve Hilbert schemes. fileciteturn30file0

## [370] user

Read the state up to 35fa8f59b6a1423cc89300aeaceefe91552be5ba and devise the next set of goals. Make sure to check for faithful implementation of the existing goals

## [371] assistant

> [thought] I’m examining the repository state through the specified commit, comparing existing goals with their implementations, and checking for gaps before proposing the next goals. I’ll keep the recommendations grounded in what is already faithfully completed.

## [372] assistant

> [thought] I’m comparing each existing goal’s requirements with its recorded implementation and status, then identifying unfinished or weakly verified areas. After that, I’ll formulate a focused next set of goals based on the audit.

## [373] assistant

> [thought] I’m narrowing the review to the latest goal additions, checking their files and statuses against the stated requirements. I’ll separate faithfully completed work from gaps, then turn those findings into practical follow-up goals.

## [374] assistant

> [thought] I’m checking the latest reports against each goal’s stated obligations, distinguishing sealed results, provisional evidence, unresolved branches, and any claims that remain unsupported. Then I’ll propose follow-up goals that close the most consequential gaps.

> [thought] I’m treating the latest reports as evidence, not automatic completion: P25 remains provisional, structured searches are partial, and several routes may use noncanonical paths. I’m checking each claim against its original acceptance criteria before defining follow-ups.

## [375] assistant

```
{"paths":["GitHub"],"query":"fetch_commit"}
```

## [376] tool

The output of this plugin was redacted.

## [377] tool

The output of this plugin was redacted.

## [378] tool

The output of this plugin was redacted.

## [379] tool

The output of this plugin was redacted.

## [380] assistant

```
{"uri":"/response/turn31","query":"STATUS.md"}
```

## [381] tool

The output of this plugin was redacted.

## [382] tool

The output of this plugin was redacted.

## [383] tool

The output of this plugin was redacted.

## [384] tool

The output of this plugin was redacted.

## [385] tool

The output of this plugin was redacted.

## [386] tool

The output of this plugin was redacted.

## [387] tool

The output of this plugin was redacted.

## [388] tool

The output of this plugin was redacted.

## [389] tool

The output of this plugin was redacted.

## [390] tool

The output of this plugin was redacted.

## [391] tool

The output of this plugin was redacted.

## [392] tool

The output of this plugin was redacted.

## [393] assistant

```
{"uri":"/response/turn31","query":"T_TARGET_BRANCH"}
```

## [394] assistant

```
{"uri":"/response/turn31","query":"TARGET_BRANCH"}
```

## [395] assistant

```
{"uri":"/response/turn31","query":"S19"}
```

## [396] assistant

```
{"uri":"/response/turn31","query":"KLS"}
```

## [397] assistant

```
{"uri":"/response/turn31","query":"H_SUBGROUP"}
```

## [398] assistant

```
{"uri":"/response/turn32","query":"S19"}
```

## [399] tool

The output of this plugin was redacted.

## [400] tool

The output of this plugin was redacted.

## [401] assistant

```
{"uri":"/response/turn32","start_line":1,"num_lines":10}
```

## [402] tool

The output of this plugin was redacted.

## [403] assistant

```
{"uri":"/response/turn33","start_line":1,"num_lines":5}
```

## [404] tool

The output of this plugin was redacted.

## [405] assistant

```
{"uri":"/response/turn32","query":"T_TARGET_BRANCH"}
```

## [406] assistant

```
{"uri":"/response/turn32","query":"S19_SCHUR"}
```

## [407] tool

The output of this plugin was redacted.

## [408] tool

The output of this plugin was redacted.

## [409] tool

The output of this plugin was redacted.

## [410] tool

The output of this plugin was redacted.

## [411] tool

The output of this plugin was redacted.

## [412] tool

The output of this plugin was redacted.

## [413] tool

The output of this plugin was redacted.

## [414] tool

The output of this plugin was redacted.

## [415] tool

The output of this plugin was redacted.

## [416] assistant

```
{"uri":"/response/turn31","query":"J_FIXED"}
```

## [417] assistant

```
{"uri":"/response/turn31","query":"Q_SCHUR"}
```

## [418] assistant

```
{"uri":"/response/turn31","query":"V_VALUATION"}
```

## [419] assistant

```
{"uri":"/response/turn31","query":"M_SARKISOV"}
```

## [420] assistant

```
{"uri":"/response/turn31","query":"R_RATIONAL"}
```

## [421] assistant

```
{"uri":"/response/turn31","query":"G_ALL_DEGREE"}
```

## [422] assistant

```
{"uri":"/response/turn31","query":"KLS_MINIMALITY"}
```

## [423] assistant

```
{"uri":"/response/turn31","query":"S19_SCHUR"}
```

## [424] tool

The output of this plugin was redacted.

## [425] tool

The output of this plugin was redacted.

## [426] tool

The output of this plugin was redacted.

## [427] tool

The output of this plugin was redacted.

## [428] assistant

```
{"uri":"/response/turn50","query":"STATUS.md"}
```

## [429] tool

The output of this plugin was redacted.

## [430] tool

The output of this plugin was redacted.

## [431] tool

The output of this plugin was redacted.

## [432] tool

The output of this plugin was redacted.

## [433] tool

The output of this plugin was redacted.

## [434] tool

The output of this plugin was redacted.

## [435] tool

The output of this plugin was redacted.

## [436] tool

The output of this plugin was redacted.

## [437] tool

The output of this plugin was redacted.

## [438] tool

The output of this plugin was redacted.

## [439] tool

The output of this plugin was redacted.

## [440] tool

The output of this plugin was redacted.

## [441] tool

The output of this plugin was redacted.

## [442] tool

The output of this plugin was redacted.

## [443] tool

The output of this plugin was redacted.

## [444] tool

The output of this plugin was redacted.

## [445] tool

The output of this plugin was redacted.

## [446] tool

The output of this plugin was redacted.

## [447] tool

The output of this plugin was redacted.

## [448] tool

The output of this plugin was redacted.

## [449] tool

The output of this plugin was redacted.

## [450] tool

The output of this plugin was redacted.

## [451] tool

The output of this plugin was redacted.

## [452] tool

The output of this plugin was redacted.

## [453] tool

The output of this plugin was redacted.

## [454] tool

The output of this plugin was redacted.

## [455] tool

The output of this plugin was redacted.

## [456] tool

The output of this plugin was redacted.

## [457] tool

The output of this plugin was redacted.

## [458] tool

The output of this plugin was redacted.

## [459] tool

The output of this plugin was redacted.

## [460] tool

The output of this plugin was redacted.

## [461] tool

The output of this plugin was redacted.

## [462] tool

The output of this plugin was redacted.

## [463] tool

The output of this plugin was redacted.

## [464] tool

The output of this plugin was redacted.

## [465] tool

The output of this plugin was redacted.

## [466] tool

The output of this plugin was redacted.

## [467] assistant

I read the repository through exactly:

```text
35fa8f59b6a1423cc89300aeaceefe91552be5ba
```

The headline remains open. The first all-out dispatch produced substantial work, but it did **not** faithfully complete all 15 assignments: six routes returned meaningful packets, while nine had no new implementation at the audit boundary. fileciteturn32file0L2-L6 fileciteturn89file0L2-L2

## Faithfulness audit

### P25: mathematically useful, but not yet canonically verified

The worker correctly discovered that the old 690-row lower presentation is not \(T\)-stable and that the presentation must be enlarged. It also correctly refused to infer emptiness from the interrupted compressed `msolve` calculations.

The implementation gap is real: the independent verifier recomputes only

- \(\operatorname{rank}(V_0)=690\);
- nonmembership of the 126 missing cubic rows in \(V_0\).

It then **reads** the decisive counts \(4140\) and \(315\) from the producer JSON rather than independently recomputing the quartic-level membership map. The production path had previously encountered a destructive-input FLINT rank bug, which was repaired and rerun, but this makes an independent replication especially important. fileciteturn63file0L2-L2

Verdict:

```text
P25V-PRESENTATION-ENLARGED: strongly supported, not yet canonical
P25V-SUPPORT-UNDECIDED: faithful
```

### Pfaffian–Morita route: substantial progress, but fragmented across three packets

The three C workspaces collectively installed:

- exact minimal polynomials for both generators;
- the scalar \(b^6\) block;
- an exact lazy Cramer-circuit implementation of the compressed algebra;
- fresh-prime multiplication and associativity checks;
- the exact symplectic involution, with eigenspace dimensions \(15/21\);
- the exact distinguished five-plane inside the algebra with involution.

No worker constructed:

- an explicit exact self-adjoint rank-two idempotent;
- the quaternion corner;
- the \(3\times3\) Hermitian realization;
- a simultaneous common isotropic line;
- a genuine point of \(F_{14,T}\).

The workers were careful not to call the degree-12 ambient projector scheme a Fano point. One cyclotomic-conjugate RUR was also correctly quarantined after discovering that its test harness mutated only a copied `runpy` namespace. fileciteturn47file0L2-L2 fileciteturn60file0L2-L2

Verdict:

```text
C-UNDECIDED: faithful
```

The implementation defect is organizational: there is no single authoritative seal combining the lazy algebra, involution, and distinguished five-plane.

### Conic/intersection-algebra route: a complete scoped theorem

This is the strongest new mathematical result.

The worker constructs an exact reciprocal-leading divisor \(D\), proves that it gives an \((e,f)=(1,1)\) place of \(K_{\rm proj}/F\), and proves that the residual fixed-frame plane cubic has index three. Proper specialization then yields

\[
\boxed{C(K_{\rm proj})=\varnothing}
\]

for the installed fixed-frame cubic. The bidirectional conic/intersection-algebra criterion is therefore empty. fileciteturn64file0L2-L2 fileciteturn65file0L2-L2

The worker correctly withheld the headline because the repaired repository does not currently identify this fixed-frame plane cubic with the genuine generic Klein twist or with a necessary slice of the genuine Fano problem. fileciteturn51file0L2-L2

Verdict:

```text
F-CONIC-CRITERION-EMPTY: faithful and complete at its scoped boundary
```

The original goal’s optimistic mission language overstated the available positive bridge; the worker followed the repaired theorem boundary rather than making the incorrect promotion.

### Structured covariant search: two compatible results, one bad exit label

The two COV workers together proved:

\[
(d,m,e)=(25,3,7),\ (31,5,1),\ (35,5,5)
\]

have zero global coefficient module already at the first normal Taylor stages. Therefore any covariant in degrees \(25,31,35\) must have

\[
\boxed{m=1}.
\]

They also exactly eliminated the named composition, cross-gradient, and mixed ansatz families. fileciteturn53file0L2-L2 fileciteturn66file0L2-L2

But neither worker constructed the full \(m=1\) equalizers in degrees 31 or 35, and degree 25 remains the separate 43-dimensional strict-support problem.

The main packet uses the accurate exit:

```text
COV-NEW-ANSATZ-STRUCTURAL
```

The duplicate root packet uses:

```text
COV-STRUCTURED-DEGREES-EMPTY-SCOPED
```

despite explicitly saying that the degrees are not excluded and \(m=1\) remains live. That exit string is too broad and must not be consumed as degree-wide emptiness. fileciteturn54file0L2-L2

### Equivariant motives and degree formulas: faithfully refuted as a route

The D worker correctly found that:

- standard index-valued degree formulas are vacuous because every relevant twist has index one;
- the relative-dimension-one splitting satisfies \(ri=n\,\mathrm{id}\), not \(ri=\mathrm{id}\);
- unrestricted equivariant blowups can reproduce the target rational Hodge structure and motive using a free orbit of Prym curves.

Thus the audited invariant does not obstruct a parametrization unless one proves strong restrictions on which nonlinear centres can actually arise in a covariant base locus. fileciteturn49file0L2-L2

Verdict:

```text
D-INVARIANT-REPRODUCIBLE: faithful completed route refutation
```

The same unrestricted Hodge/motive calculation should not be rerun.

### Proper-subgroup twists: faithfully implemented and sharply narrowed

The H worker:

- proved the subgroup-twist bridge;
- treated the two maximal \(A_5\) classes separately;
- installed genuine generic twist equations for both \(A_5\) classes, \(A_4\), and \(11{:}5\);
- proved all selected twists have index one;
- proved every \(D_{10}\)- and \(D_{12}\)-twist is soluble by a stable line;
- excluded all polynomial \(A_4\)-equivariant maps through degree four, including all three character multipliers.

It correctly did not identify index one with existence of a point and did not promote the bounded \(A_4\) calculation. fileciteturn57file0L2-L2

Verdict:

```text
H-SWEEP-UNDECIDED: faithful
```

The exact \(A_4\)-twist is now the smallest unresolved proper-subgroup object.

## Goals that were not implemented

There was no new post-dispatch packet for:

```text
T    target branch
G    universal all-degree lifting
S19  marked degree-19 curve
KLS  minimality/conductor
Q    unrestricted Schur index-one descent
V    valuation/tropical route
M    Sarkisov route
J    fixed-centre Prym/1-motive
R    rational curves on the genuine twist
```

These remain at their pre-dispatch state rather than having silently “failed.” fileciteturn89file0L2-L2

# New goal portfolio

I pushed a new post-\(35fa8f\) round under:

```text
problems/E-klein-cubic/goals_after_35fa8f/
```

Final head:

```text
37d61c19a108781cf74af837e24810a9f7f7c3be
```

fileciteturn90file0L2-L7

## Priority 0: canonical audit

`GOAL_A0_CANONICAL_IMPLEMENTATION_AUDIT.md`

This is now a prerequisite for consuming the disputed packets. It requires:

- clean replay of all implemented workers;
- independent replication of the P25 quartic map;
- canonical merger of the three C packets;
- reconciliation of the two COV packets;
- quarantine of stale/invalid RURs;
- one authoritative status for all 15 original goals.

## Highest-leverage mathematical goals

1. **`GOAL_B_FIXED_FRAME_TO_GENERIC_BRIDGE.md`**

   Determine whether the exact theorem

   \[
   C(K_{\rm proj})=\varnothing
   \]

   applies to a necessary slice of the genuine versal Klein problem. It also tests whether the new infinity divisor is the same target branch required by `BR-T-NEG`. This is the most immediate possible negative resolution.

2. **`GOAL_P25_ENLARGED_CLOSURE_AND_SUPPORT.md`**

   Independently reproduce the closure failure, enlarge from the \(690\)-space to the full \(746=690+56\) cubic row space, compute its minimal \(T\)-stable closure, and decide the complete degree-25 projective support.

3. **`GOAL_C_EXPLICIT_MORITA_AND_COMMON_LINE.md`**

   Stop reconstructing expanded \(L_a\) entries. Use the exact lazy algebra, involution, and five-plane to build:

   \[
   D=eAe,\qquad
   (A,\sigma)\simeq(\operatorname{Mat}_3(D),\operatorname{ad}_h),
   \]

   transport the five forms to \(\operatorname{Herm}_3(D)\), and solve the genuine common-line problem.

4. **`GOAL_COV_M1_EQUALIZERS_DEG31_35.md`**

   The high-order \(e=1\) and \(e=5\) branches are dead. Construct the full characteristic-zero \(m=1\) equalizers, primitive quotients, and landing schemes in degrees 31 and 35.

5. **`GOAL_H2_A4_GENERIC_TWIST.md`**

   Decide the exact installed \(A_4\)-twist itself, not merely degree-five polynomial covariants. Pointlessness gives an immediate negative headline through the subgroup bridge.

6. **`GOAL_T2_TARGET_BRANCH_NORMALIZATION.md`**

   Continue the genuine target-branch route independently of the fixed-frame bridge: normalization, conductor, local class groups, and the horizontal three-primary part of \(\operatorname{Cl}/\operatorname{Pic}\).

## Structural and independent routes

The new set also includes refreshed assignments for:

- universal all-degree noetherianity;
- the marked degree-19 Schur curve;
- unrestricted Schur index-one descent;
- KLS minimality-to-discrepancy;
- base-locus-constrained Prym/\(1\)-motives, explicitly accounting for Goal D’s countermodel;
- transfer of the new infinity valuation to a genuine twist;
- the two \(A_5\) generic twists separately;
- rational curves on the genuine twist;
- equivariant Sarkisov links;
- a genuinely new mixed-prime quotient-stack invariant;
- the solvable \(11{:}5\) generic twist.

The complete ranking, dependencies, retired approaches, and resource scheduling rules are in the new index. fileciteturn88file0L2-L2

The principal strategic change is:

\[
\boxed{
\text{The next negative question is no longer “find an obstruction.” It is
“can the exact fixed-frame obstruction be promoted to the genuine versal object?”}
}
\]

In parallel, the most mature positive routes are now the genuine Morita common-line problem and the repaired degree-25 support.
