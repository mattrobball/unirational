# ChatGPT conversation

## [1] user

Read the work on problem E in mattrobball/unirational using the GitHub connector and then prove or disprove: the Klein cubic threefold is PSL unirational. 

## [2] assistant

I’ll inspect the repository’s Problem E materials and definitions, then test the Klein cubic using the relevant geometry, group action, and literature.

## [3] assistant

> [thought] I’m continuing from the truncated material by locating the current files, recent changes, and problem-specific resources. I’m also checking whether the repository has enough computational or written evidence to support a proof or disproof.

## [4] assistant

```
bash -lc rm -rf /tmp/unirational && git clone --depth 1 https://github.com/mattrobball/unirational.git /tmp/unirational && find /tmp/unirational/problems/E-klein-cubic -maxdepth 3 -type f | sed 's#/tmp/unirational/##' | sort | head -200
```

## [5] tool

The output of this plugin was redacted.

## [6] assistant

> [thought] I’m examining whether invariant-theoretic identities can produce a homogeneous equivariant map landing on the cubic. The existing search appears exhaustive only through degree 15, so higher-degree constructions or a theoretical obstruction remain possible.

## [7] assistant

```
{"search_query":[{"q":"site:arxiv.org PSL(2,11) Klein cubic covariant invariant theory"},{"q":"site:arxiv.org \"Klein cubic\" \"PSL_2(11)\" unirationality"},{"q":"site:arxiv.org essential dimension PSL2(11) 3 4"},{"q":"site:arxiv.org Klein cubic Fano surface lines PSL2(11) covariant"}],"response_length":"long"}
```

## [8] tool

The output of this plugin was redacted.

## [9] assistant

```
{"search_query":[{"q":"\"essential dimension\" \"PSL_2(11)\" 2026"},{"q":"\"PSL(2,11)\" \"essential dimension\""},{"q":"\"Klein cubic\" equivariant unirationality PSL 2 11 2026"},{"q":"\"Klein cubic\" \"very versal\""}],"response_length":"long"}
```

## [10] tool

The output of this plugin was redacted.

## [11] assistant

The repository reduces the claim to whether \(\operatorname{ed}_{\mathbb C}(\mathrm{PSL}_2(11))\) is \(3\) or \(4\). Since covariants are excluded through degree \(24\), I’m pursuing involution-fixed arrangements and Jacobian foliations.

## [12] assistant

> [thought] I’m considering whether the quartic covariant or representation-theoretic identities can generate a map onto the cubic. A finite-field computation might suggest candidates, but lifting one to characteristic zero would still require proof.

## [13] assistant

> [thought] I’m testing whether the quartic covariant preserves the cubic or generates useful self-maps. It does not appear to do so directly, so I’m shifting toward broader essential-dimension and incompressibility arguments.

## [14] assistant

```
{"search_query":[{"q":"\"PSL(2,11)\" covariants five variables Klein invariant"},{"q":"\"Klein cubic\" covariant map"},{"q":"\"Klein's cubic\" covariants invariant theory PSL(2,11)"},{"q":"\"PSL_2(11)\" invariant ring 5-dimensional representation"}],"response_length":"long"}
```

## [15] tool

The output of this plugin was redacted.

## [16] assistant

> [thought] I’m finding that the repository does not currently prove or disprove the claim. It establishes an exact equivalence with essential dimension three and excludes self-covariant constructions through degree 24, while higher-degree cases remain unresolved.

## [17] assistant

```
{"search_query":[{"q":"site:arxiv.org/abs/2502.19598 equivariant unirationality Fano threefolds Klein cubic PSL2(11)"},{"q":"site:math.nyu.edu tschinkel 25bguni Klein cubic PSL2(11) open"},{"q":"essential dimension PSL(2,11) 2026"},{"q":"PSL2(11) essential dimension 3 4 latest"}],"response_length":"long"}
```

## [18] tool

The output of this plugin was redacted.

## [19] assistant

```
bash -lc git ls-remote https://github.com/mattrobball/unirational.git HEAD
```

## [20] tool

The output of this plugin was redacted.

## [21] assistant

```
bash -lc which M2 || true; which msolve || true; which magma || true; python3 --version; ls -l /usr/bin | grep -E 'Singular|sage' | head
```

## [22] tool

The output of this plugin was redacted.

## [23] assistant

```
{"search_query":[{"q":"Klein cubic threefold PSL(2,11) 11 point permutation representation cubic invariant"},{"q":"Klein cubic threefold 11 points permutation module equation"},{"q":"PSL2(11) 5 dimensional representation invariant cubic permutation representation 11"},{"q":"Klein cubic covariants PSL2(11) classical invariant theory"}],"response_length":"long"}
```

## [24] tool

The output of this plugin was redacted.

## [25] assistant

```
bash -lc python3 - <<'PY'
mods=['numpy','scipy','torch','jax','sympy','sklearn']
for m in mods:
 try:
  x=__import__(m); print(m, getattr(x,'__version__','ok'))
 except Exception as e: print(m,'NO',e)
PY
```

## [26] assistant

Gross–Popescu’s hyperplane-dependent birational map is not PSL-compatible, so it does not resolve equivariance. I’m checking its Palatini-quartic correspondence and any later essential-dimension theorem.

## [27] assistant

No valid proof emerges from the repository yet; I’m additionally testing classical moduli models, the six-dimensional Schur representation, and subgroup-induced constructions before fixing the verdict.

## [28] assistant

```
{"uri":"skills://plugins/github/github/skill.md","start_line":1,"num_lines":240}
```

## [29] tool

The output of this plugin was redacted.

## [30] tool

The output of this plugin was redacted.

## [31] assistant

```
{"paths":["GitHub"],"query":"content"}
```

## [32] tool

The output of this plugin was redacted.

## [33] assistant

```
{"paths":["GitHub"],"query":"tree"}
```

## [34] tool

The output of this plugin was redacted.

## [35] assistant

```
{"paths":["GitHub"],"query":"search"}
```

## [36] tool

The output of this plugin was redacted.

## [37] tool

The output of this plugin was redacted.

## [38] tool

The output of this plugin was redacted.

## [39] tool

The output of this plugin was redacted.

## [40] tool

The output of this plugin was redacted.

## [41] tool

The output of this plugin was redacted.

## [42] tool

The output of this plugin was redacted.

## [43] tool

The output of this plugin was redacted.

## [44] tool

The output of this plugin was redacted.

## [45] tool

The output of this plugin was redacted.

## [46] tool

The output of this plugin was redacted.

## [47] tool

The output of this plugin was redacted.

## [48] tool

The output of this plugin was redacted.

## [49] tool

The output of this plugin was redacted.

## [50] tool

The output of this plugin was redacted.

## [51] tool

The output of this plugin was redacted.

## [52] tool

The output of this plugin was redacted.

## [53] tool

The output of this plugin was redacted.

## [54] tool

The output of this plugin was redacted.

## [55] tool

The output of this plugin was redacted.

## [56] tool

The output of this plugin was redacted.

## [57] tool

The output of this plugin was redacted.

## [58] tool

The output of this plugin was redacted.

## [59] tool

The output of this plugin was redacted.

## [60] tool

The output of this plugin was redacted.

## [61] tool

The output of this plugin was redacted.

## [62] tool

The output of this plugin was redacted.

## [63] tool

The output of this plugin was redacted.

## [64] tool

The output of this plugin was redacted.

## [65] tool

The output of this plugin was redacted.

## [66] tool

The output of this plugin was redacted.

## [67] tool

The output of this plugin was redacted.

## [68] tool

The output of this plugin was redacted.

## [69] tool

The output of this plugin was redacted.

## [70] tool

The output of this plugin was redacted.

## [71] tool

The output of this plugin was redacted.

## [72] tool

The output of this plugin was redacted.

## [73] tool

The output of this plugin was redacted.

## [74] tool

The output of this plugin was redacted.

## [75] tool

The output of this plugin was redacted.

## [76] tool

The output of this plugin was redacted.

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

## [83] tool

The output of this plugin was redacted.

## [84] tool

The output of this plugin was redacted.

## [85] tool

The output of this plugin was redacted.

## [86] tool

The output of this plugin was redacted.

## [87] tool

The output of this plugin was redacted.

## [88] tool

The output of this plugin was redacted.

## [89] tool

The output of this plugin was redacted.

## [90] assistant

```
{"paths":["GitHub"],"query":"commit"}
```

## [91] tool

The output of this plugin was redacted.

## [92] tool

The output of this plugin was redacted.

## [93] tool

The output of this plugin was redacted.

## [94] tool

The output of this plugin was redacted.

## [95] tool

The output of this plugin was redacted.

## [96] tool

The output of this plugin was redacted.

## [97] tool

The output of this plugin was redacted.

## [98] tool

The output of this plugin was redacted.

## [99] tool

The output of this plugin was redacted.

## [100] tool

The output of this plugin was redacted.

## [101] tool

The output of this plugin was redacted.

## [102] tool

The output of this plugin was redacted.

## [103] tool

The output of this plugin was redacted.

## [104] tool

The output of this plugin was redacted.

## [105] tool

The output of this plugin was redacted.

## [106] tool

The output of this plugin was redacted.

## [107] tool

The output of this plugin was redacted.

## [108] tool

The output of this plugin was redacted.

## [109] tool

The output of this plugin was redacted.

## [110] tool

The output of this plugin was redacted.

## [111] tool

The output of this plugin was redacted.

## [112] tool

The output of this plugin was redacted.

## [113] tool

The output of this plugin was redacted.

## [114] tool

The output of this plugin was redacted.

## [115] tool

The output of this plugin was redacted.

## [116] tool

The output of this plugin was redacted.

## [117] tool

The output of this plugin was redacted.

## [118] tool

The output of this plugin was redacted.

## [119] tool

The output of this plugin was redacted.

## [120] tool

The output of this plugin was redacted.

## [121] tool

The output of this plugin was redacted.

## [122] tool

The output of this plugin was redacted.

## [123] tool

The output of this plugin was redacted.

## [124] tool

The output of this plugin was redacted.

## [125] tool

The output of this plugin was redacted.

## [126] tool

The output of this plugin was redacted.

## [127] tool

The output of this plugin was redacted.

## [128] tool

The output of this plugin was redacted.

## [129] tool

The output of this plugin was redacted.

## [130] tool

The output of this plugin was redacted.

## [131] tool

The output of this plugin was redacted.

## [132] tool

The output of this plugin was redacted.

## [133] tool

The output of this plugin was redacted.

## [134] tool

The output of this plugin was redacted.

## [135] tool

The output of this plugin was redacted.

## [136] tool

The output of this plugin was redacted.

## [137] tool

The output of this plugin was redacted.

## [138] tool

The output of this plugin was redacted.

## [139] tool

The output of this plugin was redacted.

## [140] tool

The output of this plugin was redacted.

## [141] tool

The output of this plugin was redacted.

## [142] tool

The output of this plugin was redacted.

## [143] tool

The output of this plugin was redacted.

## [144] tool

The output of this plugin was redacted.

## [145] tool

The output of this plugin was redacted.

## [146] tool

The output of this plugin was redacted.

## [147] assistant

```
{"paths":["GitHub"],"query":"directory"}
```

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

## [154] assistant

```
{"paths":["GitHub"],"query":"file"}
```

## [155] tool

The output of this plugin was redacted.

## [156] assistant

## Verdict

Let  
\[
G=\operatorname{PSL}_2(\mathbf F_{11})
\]
act through its faithful five-dimensional representation on the Klein cubic
\[
X=\left\{x_0^2x_1+x_1^2x_2+x_2^2x_3+x_3^2x_4+x_4^2x_0=0\right\}
\subset \mathbf P^4.
\]

Here “PSL-unirational” means that there is a finite-dimensional linear \(G\)-representation \(U\) and a dominant \(G\)-equivariant rational map
\[
U\dashrightarrow X.
\]

**The assertion is presently neither proved nor disproved.** The exact unconditional theorem established in Problem E is

\[
\boxed{
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
}
\]

The only known possibilities are
\[
3\leq \operatorname{ed}_{\mathbf C}(G)\leq4,
\]
so non-unirationality is equivalently the assertion that the essential dimension is \(4\). The repository explicitly leaves this dichotomy open, and the July 18, 2026 Cheltsov–Tschinkel–Zhang manuscript still lists this precise Klein-cubic action among the open exceptions. fileciteturn3file0L3-L28 citeturn434482view1

What follows is a proof of that exact equivalence.

## The equivalence with essential dimension

### \(G\)-unirationality implies \(\operatorname{ed}_{\mathbf C}(G)=3\)

Suppose there is a dominant equivariant map
\[
U\dashrightarrow X
\]
from a linear \(G\)-representation.

Then \(X\) is a three-dimensional very versal \(G\)-variety. The action on \(X\) is faithful; for a faithful finite-group action, the generic stabilizer is trivial because the fixed locus of each nonidentity element is proper. Hence \(X\) is a faithful three-dimensional compression of a linear representation, so
\[
\operatorname{ed}_{\mathbf C}(G)\leq3.
\]

On the other hand, the known lower bound is
\[
\operatorname{ed}_{\mathbf C}(G)\geq3;
\]
in particular, \(G\) admits no faithful compression to a unirational surface. Therefore
\[
\operatorname{ed}_{\mathbf C}(G)=3.
\]
This is the easy implication in the repository’s theorem. fileciteturn36file0L63-L95

### \(\operatorname{ed}_{\mathbf C}(G)=3\) implies \(G\)-unirationality

Assume now that
\[
\operatorname{ed}_{\mathbf C}(G)=3.
\]

There is then a faithful, generically free, three-dimensional very versal \(G\)-variety \(Z\). After equivariant compactification and resolution, one obtains a smooth projective rationally connected threefold still dominated equivariantly by a representation.

The equivariant minimal-model program and Prokhorov’s classification reduce such a threefold to one of two \(G\)-birational models:

1. the Klein cubic \(X\); or
2. the associated degree-14, genus-eight Pfaffian Fano threefold \(F_{14}\).

If the resulting model is \(X\), then \(X\) is very versal and hence \(G\)-unirational.

It remains to treat the \(F_{14}\) branch. Assume \(F_{14}\) is very versal. Let \(K/\mathbf C\) be any field extension and \(T/K\) any \(G\)-torsor. Twisting the Pfaffian–Grassmannian bridge gives a \(K\)-birational map
\[
{}^T X\times\mathbf P^2\times S_T
\dashrightarrow
{}^T F_{14}\times\mathbf P^2\times S_T,
\]
where \(S_T\) is the Brauer–Severi twist of the projective five-space associated with the six-dimensional representation of the double cover
\[
1\longrightarrow\mu_2\longrightarrow
\operatorname{SL}_2(\mathbf F_{11})
\longrightarrow G\longrightarrow1.
\]

Let \(\alpha_T=[S_T]\in\operatorname{Br}(K)\). Since \(\alpha_T\) is obtained from this central extension,
\[
\exp(\alpha_T)\mid2.
\]
The corresponding central simple algebra has degree \(6\), so its index divides \(6\). Index and exponent have the same prime divisors, and therefore
\[
\operatorname{ind}(\alpha_T)\in\{1,2\}.
\]
Consequently \(S_T\) splits over a separable extension \(L/K\) of degree at most two.

Because \(F_{14}\) is very versal, its twist \({}^T F_{14}\) is \(K\)-unirational. After passing to \(L\), the right-hand side has a Zariski-dense set of \(L\)-points. Choosing one in the domain of the inverse birational map and projecting to the Klein-cubic factor gives
\[
{}^T X(L)\neq\varnothing.
\]

Now use the following elementary lemma.

> **Quadratic descent for cubic hypersurfaces.**  
> Let \(D\subset\mathbf P^n_K\) be a cubic hypersurface and let \(L/K\) be separable of degree at most two. If \(D(L)\neq\varnothing\), then \(D(K)\neq\varnothing\).

For a quadratic extension, take \(P\in D(L)\) and its conjugate \(\bar P\). The line
\[
\ell=\langle P,\bar P\rangle
\]
is defined over \(K\). If \(\ell\subset D\), it is a \(K\)-line and contains \(K\)-points. Otherwise
\[
\ell\cap D=P+\bar P+Q
\]
as a degree-three zero-cycle on \(\ell\). The residual point \(Q\) is Galois invariant and hence belongs to \(D(K)\).

The five-dimensional action of \(G\) is an honest linear action, so the twisted ambient projective space of \({}^T X\) is a split \(\mathbf P^4_K\). Thus the lemma applies and gives
\[
{}^T X(K)\neq\varnothing.
\]

This holds for every \(G\)-torsor \(T/K\). Therefore \(X\) is weakly versal; for this cubic action, the Duncan–Reichstein twist criterion upgrades this to very versal, equivalently \(G\)-unirational. fileciteturn45file0L4-L59

This completes the proof that
\[
X\text{ is }G\text{-unirational}
\iff
\operatorname{ed}_{\mathbf C}(G)=3.
\]

## The remaining concrete problem

Let
\[
K_{\mathrm{proj}}
=\mathbf C(\mathbf P(W))^G
\]
and let \(T_{\mathrm{proj}}\) be the generic \(G\)-torsor obtained from the free locus in \(\mathbf P(W)\). Write
\[
X_{\mathrm{gen}}={} ^{T_{\mathrm{proj}}}X.
\]

Then the equivalence can be sharpened to the single rational-point question
\[
\boxed{
\begin{aligned}
\operatorname{ed}_{\mathbf C}(G)=3
&\iff X_{\mathrm{gen}}(K_{\mathrm{proj}})\neq\varnothing,\\
\operatorname{ed}_{\mathbf C}(G)=4
&\iff X_{\mathrm{gen}}(K_{\mathrm{proj}})=\varnothing.
\end{aligned}}
\]

The repository constructs primitive covariants
\[
x,C,D,E,K:W\longrightarrow W
\]
of degrees \(1,4,5,6,7\), with
\[
\det[x,C,D,E,K]\neq0.
\]
They therefore give an explicit Hilbert–90 frame for the twisted ambient vector space. In that frame the entire problem is an explicit five-variable cubic equation
\[
\Phi(a_0,\ldots ,a_4)
=
F\bigl([x\ C\ D\ E\ K]a\bigr)=0
\]
over \(K_{\mathrm{proj}}\). No nonzero \(K_{\mathrm{proj}}\)-solution is currently known, and no obstruction to one has been proved. fileciteturn45file0L124-L190

Every Klein twist has index one: subgroup-fixed constructions give effective zero-cycles of degrees
\[
60,\quad132,\quad165,\quad220,
\]
whose greatest common divisor is one. But this does not produce a rational point. The missing implication is precisely
\[
\text{index one cubic threefold}
\quad\Longrightarrow\quad
\text{rational point}
\]
for this special family. The audited Brauer, Amitsur, and standard stable-cohomology obstructions all vanish. fileciteturn45file0L193-L199

## Why the computations do not yet decide it

The latest Problem E work contains substantial exact exclusions, but none is an all-degree theorem:

- Homogeneous self-covariants \(W\to W\) landing in \(X\) are excluded through degree \(24\); degree \(25\) is the first bounded unknown. In degree \(25\), the complete problem has been reduced to a structured relative border/Fitting problem, but its landing locus has not been proved empty. fileciteturn13file0L57-L104
- The Kraft–Loetscher–Schwarz criterion says that \(\operatorname{ed}(G)=3\) is equivalent to the existence of a nonzero homogeneous self-covariant with identically vanishing Jacobian. Such covariants are completely excluded only through degree \(11\); degree \(12\) remains open on a proper exceptional locus. fileciteturn34file0L39-L66
- The all-degree involution obstruction that solved the analogous \(\operatorname{PSL}_2(\mathbf F_7)\) del Pezzo problem does not transfer. For a Klein-cubic involution, the negative eigenspace gives an entire line contained in \(X\), and for a Sylow \(V_4\) the three such lines form a triangle. The exact transition analysis closes rather than producing contradictory endpoint values. fileciteturn30file0L28-L97
- A finite quartic \(G\)-endomorphism of \(\mathbf P(W)\) shows that, if one solution exists, precomposition generates solutions in degrees \(4^n d\). Thus no uniform bound on the degrees of all possible solutions can be used to justify a finite search. fileciteturn15file0L33-L44

## Conditional answers

Two major conjectural routes point in opposite directions:

\[
\begin{array}{ccl}
\text{Cassels--Swinnerton-Dyer for these cubics}
&\Longrightarrow&
\operatorname{ed}_{\mathbf C}(G)=3
\Longrightarrow X\text{ is }G\text{-unirational},\\[4pt]
\text{Duncan--Reichstein Conjecture 8.8}
&\Longrightarrow&
\operatorname{ed}_{\mathbf C}(G)=3
\Longrightarrow X\text{ is }G\text{-unirational},\\[4pt]
\operatorname{Crdim}(G)\leq\operatorname{ed}(G)
&\Longrightarrow&
4=\operatorname{Crdim}(G)\leq\operatorname{ed}(G)
\Longrightarrow X\text{ is not }G\text{-unirational}.
\end{array}
\]
None of these implications presently gives an unconditional verdict. fileciteturn4file0L182-L225

Therefore the defensible conclusion is

\[
\boxed{\text{The PSL}_2(\mathbf F_{11})\text{-unirationality of the Klein cubic remains open.}}
\]

The exact remaining binary target is to prove either
\[
X_{\mathrm{gen}}(K_{\mathrm{proj}})\neq\varnothing
\]
or
\[
X_{\mathrm{gen}}(K_{\mathrm{proj}})=\varnothing;
\]
equivalently, to determine whether
\[
\operatorname{ed}_{\mathbf C}\!\left(\operatorname{PSL}_2(\mathbf F_{11})\right)
=3\quad\text{or}\quad4.
\]

## [157] user

That is a good baseline. Now, I need you to CAREFULLY read the resolution to the PSL(2,7) del Pezzo question found in problem/F-dp2-psl27. A tool for refuting G-unirationality emerged there. Your tasks:
1. Generalize this tool to the correct abstraction. 
2. Determine what other open questions it might apply to. Then apply it. 
3. Return to the threefold case here and attempt to apply the new general machine to it. 
4. Make a compute questions shopping list if needed after 3. This is a M5 Max macbook pro fully specced out. Assume we have ALL CAS available. There is an agent operating locally to run it.

## [158] assistant

I’ll reconstruct the PSL(2,7) obstruction precisely, abstract its essential hypotheses, test and apply it to open cases, then revisit the Klein cubic and produce a concrete CAS work order.

## [159] assistant

> [thought] I’m generalizing the surface argument through equivariant dual complexes. Fixed exceptional components map constantly when their target fixed loci contain no rationally connected subvarieties; adjacency then propagates equal images, producing an obstruction when endpoint states remain separated.

## [160] assistant

> [thought] I’m tracing how equivariant blowups create a fixed chain and when each exceptional curve has a nontrivial kernel in its projective action. For finite abelian groups, this supports the broader criterion that noncyclicity prevents faithful one-dimensional characters.

## [161] assistant

> [thought] I’m refining the obstruction: fixed-locus rational rigidity forces endpoint maps to be constant, while rational curves in fixed loci permit transport. I’m defining an equivalence relation generated by these fixed-locus rational curves; distinct classes obstruct equivariant maps.

## [162] assistant

```
{"search_query":[{"q":"site:arxiv.org equivariant unirationality Fano threefolds Cheltsov Tschinkel Zhang 2502.19598"},{"q":"site:arxiv.org degree 1 degree 2 del Pezzo equivariant unirationality finite group open"},{"q":"site:arxiv.org equivariant unirationality cubic threefold finite group open exceptions Klein cubic"},{"q":"site:arxiv.org Tschinkel Zhang degree 2 del Pezzo non-unirational Q8 2504.10204"}],"response_length":"long"}
```

## [163] tool

The output of this plugin was redacted.

## [164] assistant

> [thought] I’m identifying candidate group actions where the obstruction could apply, especially surface actions and higher-dimensional examples. I’ll test whether invariant projective planes or surface slices preserve the needed fixed-curve configuration and endpoint constraints.

## [165] assistant

```
{"search_query":[{"q":"site:arxiv.org A5 degree 2 del Pezzo equivariant unirationality"},{"q":"site:arxiv.org icosahedral quartic del Pezzo surface degree 2 A5 action unirational"},{"q":"site:arxiv.org finite groups degree 2 del Pezzo A5 Condition A unirationality"},{"q":"site:arxiv.org automorphism groups degree 2 del Pezzo A5 invariant quartic"}],"response_length":"long"}
```

## [166] assistant

The emerging abstraction is a character-labeled equivariant resolution tree: tangent-character kernels constrain exceptional components to target fixed loci, whose rational-connectivity relations govern allowable endpoint transitions.

## [167] tool

The output of this plugin was redacted.

## [168] assistant

```
from collections import deque, Counter, defaultdict
p=3
# monomial transformation M: e_j -> zeta^exp[j] e_{perm[j]}
def compose(M,N): # M after N: M∘N
    permM, expM=M; permN, expN=N
    perm=tuple(permM[permN[j]] for j in range(5))
    exp=tuple((expN[j]+expM[permN[j]])%p for j in range(5))
    return perm,exp
I=(tuple(range(5)),(0,)*5)
def inv(M):
    perm,exp=M
    pinv=[0]*5
    for j,k in enumerate(perm): pinv[k]=j
    einv=[0]*5
    # inverse e_k -> z^-exp[j] e_j
    for k in range(5):
        j=pinv[k]
        einv[k]=(-exp[j])%p
    return tuple(pinv),tuple(einv)
a=(tuple(range(5)),(0,0,1,2,0))
b
```

## [169] assistant

```
{"open":[{"ref_id":"https://arxiv.org/pdf/2504.10204"}],"response_length":"short"}
```

## [170] tool

The output of this plugin was redacted.

## [171] assistant

A promising new application may exclude the \(C_9\rtimes C_3\) Fermat cubic action via a scalar-normal divisor; I’m verifying generic-torsor and further-resolution compatibility before claiming it.

## [172] assistant

> [thought] I’m organizing the requested work around four goals: abstracting the obstruction, identifying applications, reassessing the Klein cubic, and specifying computational tasks. I’ll distinguish established repository results from proposed, unverified extensions.

> [thought] I’m examining a possible negative result for the Fermat cubic action of \(C_9\rtimes C_3\). The proposed argument uses \(K\)-fixed source edges, rationally rigid target fixed loci, and a normalizer contradiction.

## [173] assistant

```
{"search_query":[{"q":"\"C_9\" \"C_3\" Fermat cubic threefold equivariant unirationality July 2026"},{"q":"\"Fermat cubic\" \"C9\" \"unirational\" equivariant"},{"q":"site:arxiv.org equivariant unirationality Fermat cubic C_9 C_3"}],"response_length":"long"}
```

## [174] tool

The output of this plugin was redacted.

## [175] assistant

```
{"query":"The user is asking for a research-level generalization of a new equivariant unirationality obstruction from their mattrobball/unirational repository, applications to other open problems, and a computational work order for a local agent on a fully specced M5 Max MacBook Pro. Retrieve any prior preferences or constraints about mathematical proof standards, computational certificates, CAS workflows, repository conventions, and how they want novel results presented."}
```

## [176] assistant

The output of this plugin was redacted.

## [177] tool

The output of this plugin was redacted.

## [178] assistant

The output of this plugin was redacted.

## [179] tool

The output of this plugin was redacted.

## [180] tool

The output of this plugin was redacted.

## [181] tool

The output of this plugin was redacted.

## [182] tool

The output of this plugin was redacted.

## [183] tool

The output of this plugin was redacted.

## [184] assistant

The output of this plugin was redacted.

## [185] tool

The output of this plugin was redacted.

## [186] assistant

The output of this plugin was redacted.

## [187] tool

The output of this plugin was redacted.

## [188] tool

The output of this plugin was redacted.

## [189] tool

The output of this plugin was redacted.

## [190] assistant

The output of this plugin was redacted.

## [191] tool

The output of this plugin was redacted.

## [192] assistant

The output of this plugin was redacted.

## [193] tool

The output of this plugin was redacted.

## [194] assistant

Separately, the machine now proves the Type-II \(OD_{16}\) Fermat degree-two del Pezzo action is not equivariantly unirational, using a fixed source line and elliptic target fixed locus.

## [195] assistant

```
{"paths":["GitHub"],"query":"fetch_file"}
```

## [196] tool

The output of this plugin was redacted.

## [197] tool

The output of this plugin was redacted.

## [198] tool

The output of this plugin was redacted.

## [199] tool

The output of this plugin was redacted.

## [200] tool

The output of this plugin was redacted.

## [201] tool

The output of this plugin was redacted.

## [202] tool

The output of this plugin was redacted.

## [203] tool

The output of this plugin was redacted.

## [204] tool

The output of this plugin was redacted.

## [205] tool

The output of this plugin was redacted.

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

## [212] assistant

# Main conclusions

The PSL\((2,7)\) proof is an instance of a broader **fixed-stratum descent machine**:

1. test weak versality on a deliberately chosen faithful representation;
2. restrict a hypothetical equivariant rational map to projective eigenspaces of subgroups;
3. use normalizers to constrain the image inside target fixed loci;
4. when a fixed stratum is forced into the base locus, blow it up and repeat on the projectivized normal representation;
5. encode the possible repetitions as an **isotropy-transition category**.

For surfaces, the exceptional dual complex is a tree, and this recovers the \(V_4\)-path obstruction proved in Problem F. fileciteturn49file0L138-L242

This abstraction gives two immediate negative results:

\[
\boxed{\text{The Type-II }OD_{16}\text{ action on the Fermat degree-2 del Pezzo is not }G\text{-unirational}.}
\]

\[
\boxed{\text{The }C_9\rtimes C_3\text{ action on the Fermat cubic threefold is not }G\text{-unirational}.}
\]

In fact, neither action is even weakly versal. The second result closes one of the four exceptional cubic-threefold actions in the July 18, 2026 Cheltsov–Tschinkel–Zhang theorem. That paper currently leaves \(C_9\rtimes C_3\) on the Fermat cubic, \(C_{11}\rtimes C_5\) and \(\operatorname{PSL}_2(\mathbf F_{11})\) on the Klein cubic, and the irreducible \(A_5\) pencil as the possible exceptions. citeturn223444view3turn209124view0

For the Klein cubic, the first two levels of the generalized machine do not obstruct: the rational lines in the involution fixed loci create genuine transitions. The correct next object is not another \(V_4\) table or another degree sweep, but a global, isotropy-labelled transition system on the full 55-plane arrangement.

---

# 1. The correct abstraction

## 1.1 Testing on any faithful representation

Let \(Y\) be a proper \(G\)-variety. If \(Y\) is weakly versal—and therefore if it is \(G\)-unirational—then for every faithful projective action \(\mathbf P(U)\) arising from a linear representation, there is a rational \(G\)-map

\[
\mathbf P(U)\dashrightarrow Y.
\]

Indeed, take the generic torsor of the generically free action on \(\mathbf P(U)\). Weak versality gives a point on the corresponding twist of \(Y\), and twisting adjunction converts it into the rational \(G\)-map. This is the same generic-torsor mechanism used in Problems E and F. fileciteturn51file0L102-L127

The important flexibility is that **\(U\) need not be the ambient representation of \(Y\)**. One should engineer \(U\) to expose useful fixed divisors.

## 1.2 Normalizer fixed-stratum obstruction

Let \(H\leq G\), let \(N=N_G(H)\), and suppose

\[
D\subset \mathbf P(U)^H
\]

is an irreducible \(N\)-stable prime divisor. Assume:

1. every rational map
   \[
   D\dashrightarrow Y^H
   \]
   is constant;
2. \(Y^N=\varnothing\).

Then \(Y\) is not weakly versal.

### Proof

Suppose that a rational \(G\)-map
\[
f:\mathbf P(U)\dashrightarrow Y
\]
exists.

Because \(\mathbf P(U)\) is normal and \(Y\) is proper, \(f\) is defined at the generic point of every prime divisor, in particular at the generic point of \(D\). Since \(H\) fixes \(D\) pointwise,

\[
f(D)\subset Y^H.
\]

By assumption, \(f|_D\) is constant, say with value \(y\). Since \(D\) is \(N\)-stable and \(f\) is equivariant,

\[
ny=y\qquad(n\in N).
\]

Thus \(y\in Y^N\), contrary to \(Y^N=\varnothing\).

A particularly useful sufficient condition for the first assumption is:

- \(D\) is rationally connected; and
- \(Y^H\) contains no rational curves.

A positive-dimensional rational image of a rationally connected variety is rationally connected and therefore contains rational curves.

## 1.3 Central eigenhyperplane criterion

A very common special case is the following.

Let \(z\in Z(G)\). Suppose \(R\) is a faithful representation on which \(z\) acts by a nontrivial scalar \(\lambda\), and let \(\chi\) be a one-dimensional representation on which \(z\) acts by a different scalar. Put

\[
U=R\oplus\chi.
\]

Then

\[
D=\mathbf P(R)\subset\mathbf P(U)
\]

is a \(G\)-stable hyperplane fixed pointwise by \(z\). Therefore:

> If \(Y^z\) contains no rational curves and \(Y^G=\varnothing\), then \(Y\) is not weakly versal.

Adding the one-dimensional summand is the key source-engineering operation. A central element that was scalar—and hence invisible—on an irreducible representation becomes a projectively nontrivial element with a fixed hyperplane.

## 1.4 Exceptional-path transition theorem

The preceding criterion handles a fixed divisor that is generically in the domain. If a fixed stratum is instead forced into the base locus, blow it up and repeat.

For a finite noncyclic abelian group \(K\), define the **isotropy-transition relation** on \(Y^K\) as follows. Put an \(H\)-labelled edge from \(y_0\) to \(y_1\) when there is a \(K\)-equivariant morphism

\[
\phi:\mathbf P^1\longrightarrow Y^H
\]

such that:

- \(H\neq 1\);
- the action of \(K\) on \(\mathbf P^1\) factors through a character of \(K/H\);
- the two \(K\)-fixed points of \(\mathbf P^1\) map to \(y_0,y_1\).

Now let \(S\) be a smooth \(K\)-surface and let two \(K\)-stable rational curves \(C_0,C_1\) meet at a \(K\)-fixed point. Suppose a rational \(K\)-map \(S\dashrightarrow Y\) has forced constant endpoint values \(y_0,y_1\) on these curves. Then:

\[
y_0\text{ and }y_1
\quad\text{must be connected in the isotropy-transition graph of }Y.
\]

The proof is exactly the tree argument from Problem F:

- equivariant point blowups produce a tree over the intersection point;
- \(K\) fixes the unique endpoint-to-endpoint path componentwise;
- each intermediate exceptional curve is \(\mathbf P(T_xS)\) at a \(K\)-fixed birth point;
- since \(K\) is abelian, \(T_xS=\chi_1\oplus\chi_2\);
- the projective action factors through \(\chi_1\chi_2^{-1}\);
- because \(K\) is noncyclic, this character has nontrivial kernel \(H\);
- the exceptional curve maps into \(Y^H\), producing an allowed transition.

In Problem F, every relevant involution fixed locus was an elliptic curve plus points, so there were no nonconstant edges. The transition graph was discrete, while the two forced endpoints were distinct. fileciteturn49file0L43-L60 fileciteturn49file0L194-L240

## 1.5 Higher-dimensional version

For a higher-dimensional source, the correct object is the equivariant dual complex of a log resolution, labelled by:

- generic stabilizers of exceptional strata;
- projectivized normal representations;
- components of the corresponding \(Y^H\);
- rational transition maps between those components.

One can often reduce locally to the surface theorem by taking an equivariant formal two-dimensional slice through two selected normal directions. Globally, however, the data is not merely a graph. It is a constructible category or cosheaf on the incidence complex of the base arrangement.

That distinction is precisely what matters for the Klein cubic.

---

# 2. First new application: the \(OD_{16}\) degree-two del Pezzo

The July 2026 Tschinkel–Zhang table identifies the Type-II \(OD_{16}\) action as the unique \(OD_{16}\) row with Condition (A); its \(\operatorname{Am}^3\) obstruction vanishes. Apart from it, the Condition-(A) rows in the relevant table are the three \(Q_8\) actions, which are already excluded by nonzero \(\operatorname{Am}^3\). citeturn223444view1

Consider

\[
S=\left\{
w^2=x_1^4+x_2^4+x_3^4
\right\}\subset\mathbf P(2,1,1,1).
\]

The displayed generators are

\[
\begin{aligned}
\tau(w,x_1,x_2,x_3)&=(-w,x_1,x_2,x_3),\\
\sigma(w,x_1,x_2,x_3)&=(w,x_2,x_1,x_3),\\
\iota_3(w,x_1,x_2,x_3)&=(w,ix_1,-ix_2,x_3),\\
\iota_4(w,x_1,x_2,x_3)&=(w,ix_1,ix_2,x_3),\\
\iota_5(w,x_1,x_2,x_3)&=(w,-x_1,ix_2,x_3),
\end{aligned}
\]

and

\[
G=\langle \iota_3,\iota_4,\tau\sigma\iota_5\rangle
\simeq OD_{16}.
\]

These are the generators in the current classification table. citeturn223444view0turn223444view1

Put

\[
a=\iota_3,\qquad c=\tau\sigma\iota_5.
\]

Direct multiplication gives

\[
z=[a,c]:
(w,x_1,x_2,x_3)\longmapsto
(w,-x_1,-x_2,x_3).
\]

This element is central: it is scalar on
\[
R=\langle x_1,x_2\rangle
\]
and fixes the complementary coordinate \(x_3\).

The two-dimensional representation \(R\) is faithful. Indeed:

- \(\langle\iota_3,\iota_4\rangle\) gives eight distinct diagonal matrices on \(R\);
- \(c\) is non-diagonal;
- \(c^2=\iota_4^3\);
- consequently the generated matrix group has exactly \(16\) elements.

Thus

\[
U=R\oplus\mathbf 1
=\langle x_1,x_2,x_3\rangle
\]

is a faithful representation, and

\[
D=\mathbf P(R)=\{x_3=0\}\subset\mathbf P(U)
\]

is a \(G\)-stable line fixed pointwise by \(z\).

The fixed locus of \(z\) on \(S\) is

\[
S^z
=
E\ \sqcup\ \{P_+,P_-\},
\]

where

\[
E=\{x_3=0,\ w^2=x_1^4+x_2^4\}
\]

is a smooth genus-one curve and

\[
P_\pm=[\pm1:0:0:1].
\]

Thus \(S^z\) contains no rational curve.

Finally,

\[
S^G=\varnothing.
\]

To see this, the only \(G\)-invariant line in the base representation is \(\langle x_3\rangle\): the representation on \(R\) is irreducible because \(\iota_3\) has the two coordinate eigenlines and \(c\) interchanges them. The two points over \([0:0:1]\) are \(P_+\) and \(P_-\), and \(c\), through its \(\tau\)-factor, interchanges them.

The central eigenhyperplane criterion now gives:

\[
\boxed{
S\text{ is not weakly versal for }OD_{16}.
}
\]

In particular,

\[
\boxed{
S\text{ is not }OD_{16}\text{-unirational}.
}
\]

This closes the one Condition-(A), \(\operatorname{Am}^3=0\) Type-II row left by the cohomological analysis.

---

# 3. Second new application: \(C_9\rtimes C_3\) on the Fermat cubic

Let

\[
X=\left\{
x_1^3+x_2^3+x_3^3+x_4^3+x_5^3=0
\right\}\subset\mathbf P^4.
\]

The exceptional action currently listed as open is generated by

\[
\begin{aligned}
a&=\operatorname{diag}(1,1,\omega,\omega^2,1),\\
b&=\operatorname{diag}(1,1,1,\omega,\omega^2),\\
c(x_1,x_2,x_3,x_4,x_5)
&=(x_1,\omega x_2,x_4,\omega x_5,x_3),
\end{aligned}
\]

where \(\omega^3=1\), \(\omega\neq1\). citeturn209124view0

Decompose the target representation as

\[
W=A\oplus R,
\qquad
A=\langle x_1,x_2\rangle,
\qquad
R=\langle x_3,x_4,x_5\rangle.
\]

The representation \(R\) is faithful. On \(R\),

\[
a=\operatorname{diag}(\omega,\omega^2,1),
\qquad
b=\operatorname{diag}(1,\omega,\omega^2),
\]

and \(c\) cyclically permutes the three joint weight lines, with scalar factors. The diagonal subgroup \(\langle a,b\rangle\) has order \(9\), while

\[
c^3=\omega I_R=ab^2
\]

and \(c\notin\langle a,b\rangle\). Hence the generated matrix group on \(R\) has order \(27\).

Set

\[
z=c^3.
\]

On \(W\),

\[
z=\operatorname{diag}(1,1,\omega,\omega,\omega),
\]

and \(z\) is central.

Now choose the test representation

\[
U=R\oplus\mathbf 1.
\]

Its projectivization is faithful: if an element acts projectively as a scalar on \(U\), the trivial summand forces that scalar to equal \(1\), and faithfulness of \(R\) then forces the element to be the identity.

The hyperplane

\[
D=\mathbf P(R)\subset\mathbf P(U)=\mathbf P^3
\]

is \(G\)-stable and fixed pointwise by \(z\).

The fixed locus of \(z\) on the Fermat cubic is

\[
X^z
=
E\ \sqcup\ Q,
\]

where

\[
E=
\left\{
x_3^3+x_4^3+x_5^3=0
\right\}
\subset\mathbf P(R)
\]

is a smooth plane cubic and

\[
Q=
\left\{
x_1^3+x_2^3=0
\right\}\subset\mathbf P(A)
\]

is a reduced set of three points. Thus \(X^z\) contains no rational curves.

Also,

\[
X^G=\varnothing.
\]

Indeed:

- \(R\) is irreducible, because its three \(\langle a,b\rangle\)-weight lines are cyclically permuted by \(c\);
- the only invariant projective lines in \(A\) are \([x_1]\) and \([x_2]\);
- neither coordinate point belongs to the Fermat cubic.

If \(X\) were weakly versal, the generic torsor associated with \(\mathbf P(U)\) would yield a rational \(G\)-map

\[
\mathbf P^3\dashrightarrow X.
\]

Restricting to the fixed hyperplane gives

\[
\mathbf P^2\dashrightarrow X^z.
\]

A rational map from \(\mathbf P^2\) to a genus-one curve is constant, and the finite components are also constant. Since \(D\) is \(G\)-stable, the constant would be a \(G\)-fixed point of \(X\), which does not exist.

Therefore

\[
\boxed{
X\text{ is not weakly versal for }C_9\rtimes C_3.
}
\]

Consequently,

\[
\boxed{
X\text{ is not }(C_9\rtimes C_3)\text{-unirational}.
}
\]

I do not see this argument recorded in the current cubic-threefold paper. Its only finite checks are the order-\(27\) monomial matrix closure and the two elementary fixed-locus computations.

---

# 4. Other cases to which the machine applies

## Immediate and successful

### \(Q_8\) degree-two del Pezzo actions

A faithful two-dimensional \(Q_8\)-representation has its central involution acting by \(-I\). Adding a trivial line produces a central fixed hyperplane exactly as above. For the relevant degree-two del Pezzo actions, this should give a geometric reproof of their negative answer whenever the central fixed locus is the positive-genus branch component plus isolated points. These cases are already excluded by the nonzero \(\operatorname{Am}^3\) obstruction, so this is a validation target rather than a new open result. The current theorem identifies the \(Q_8\) cases as the Condition-(A) cases with the cohomological obstruction. citeturn223444view1

### Other central-scalar actions

The criterion should be run systematically whenever:

- \(G\) or a subgroup \(H\) has nontrivial center;
- there is a faithful irreducible representation on which a central element acts scalarly;
- the target fixed locus of that element is non-uniruled;
- the target has no normalizer-fixed point.

This is a finite character-table and fixed-scheme scan.

## Open but requiring the recursive machine

### The irreducible \(A_5\) cubic pencil

For a \(V_4\subset A_5\), the irreducible five-dimensional representation restricts as

\[
W|_{V_4}
\simeq
\mathbf 1^{\oplus2}
\oplus\chi_1\oplus\chi_2\oplus\chi_3.
\]

Thus its involution fixed loci have the same basic shape as in the Klein case: a plane cubic and a line. The line gives rational transitions, so the fixed-hyperplane obstruction does not apply. The full normalizer \(A_4\) and the five \(V_4\)-configurations should nevertheless make this a much smaller proving ground for the global transition-cosheaf calculation. The irreducible \(A_5\) pencil remains one of the current open cubic cases. citeturn223444view2

### \(C_{11}\rtimes C_5\) on the Klein cubic

This group has no noncyclic abelian subgroup and no useful central scalar element. A cyclic group can act faithfully on an exceptional \(\mathbf P^1\), so the kernel argument underlying the surface path theorem disappears. This is a poor target for the present machine unless one first finds a larger normalizer-fixed configuration.

### Degree-one del Pezzo surfaces

The current cohomological analysis notes that a degree-one del Pezzo surface always has a \(G\)-fixed point. Consequently, the terminal “constant would be a forbidden \(G\)-fixed point” step is unavailable. citeturn167988view0

---

# 5. Applying the full machine to the Klein cubic

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
X=\left\{\sum x_i^2x_{i+1}=0\right\}\subset\mathbf P(W).
\]

The repository proves

\[
X\text{ is }G\text{-unirational}
\iff
\operatorname{ed}_{\mathbf C}(G)=3.
\]

Thus a successful obstruction below would also prove
\(\operatorname{ed}_{\mathbf C}(G)=4\). fileciteturn58file0L109-L129

## 5.1 First fixed-stratum descent

For an involution \(t\),

\[
W=E_+(t)\oplus E_-(t),
\qquad
(\dim E_+,\dim E_-)=(3,2).
\]

The target fixed locus is

\[
X^t=E_t\sqcup L_t,
\]

where

\[
E_t=X\cap\mathbf P(E_+(t))
\]

is a smooth plane cubic and

\[
L_t=\mathbf P(E_-(t))
\]

is an entire line contained in \(X\).

The order-12 centralizer of \(t\) has no fixed point on \(X\). Consequently, if a landing self-covariant were nonzero on the source plus-plane, its restriction would give a rational map

\[
\mathbf P^2\dashrightarrow E_t,
\]

hence a constant centralizer-fixed point. This is impossible. Therefore every one of the 55 plus-planes is a base component.

After blowing up a plus-plane, however, the projectivized normal direction is a \(\mathbf P^1\), and the leading normal map can dominate the rational fixed line \(L_t\). Exact calculations show that the transverse order is odd and that this nonconstant transition is genuinely possible. fileciteturn58file0L13-L21

This is precisely where the \(OD_{16}\) and Fermat arguments stop working and the recursive machine becomes necessary.

## 5.2 The local \(V_4\) transition category

For \(K=V_4\),

\[
W=A\oplus B\oplus C\oplus D,
\qquad
(\dim A,\dim B,\dim C,\dim D)=(2,1,1,1).
\]

The three involution fixed lines are

\[
\mathbf P(C\oplus D),\qquad
\mathbf P(B\oplus D),\qquad
\mathbf P(B\oplus C),
\]

and form a triangle in \(X\). The three plus elliptics meet the neighboring fixed lines at the opposite vertices. In addition,

\[
R=X\cap\mathbf P(A)
\]

is a reduced three-point set common to the three elliptics. Hence

\[
X^K=R\sqcup\{B,C,D\}.
\]

The triangle vertices are mutually reachable through rational fixed lines. The three points of \(R\) are isolated constant states.

The repository’s exact transition calculation shows:

- endpoint-preserving local transitions occur;
- endpoint-swapping local transitions occur;
- extra endpoint vanishing occurs;
- a whole line may remain based;
- the triangle transition system closes rather than obstructs.

Thus the direct Problem-F path argument genuinely fails, not merely because an inconvenient case was omitted. fileciteturn30file0L28-L97

## 5.3 Why a tempting global vertex argument is invalid

There is a tempting shortcut: try to assign a single target vertex to every one of the 165 \(V_4\)-fixed triangle vertices and derive an incompatible permutation around each triangle.

That is not the correct geometry.

At a triangle vertex, the source plus-plane has already been blown up. The two incident minus-lines determine two distinct points of the exceptional normal \(\mathbf P^1\). The leading map may take different values on those two normal directions. Thus the state is attached to a **flag**

\[
(\text{plus-plane},\ \text{vertex},\ \text{normal line direction}),
\]

not to the vertex alone.

This direction dependence is exactly what permits both the preserving and swapping transitions found in the repository. Any global argument must retain the exceptional-fiber coordinate.

## 5.4 The correct global object

The source configuration consists of:

- 55 forced plus-planes;
- 55 triple lines;
- 66 five-plane points with stabilizer \(D_{10}\);
- 55 seven-plane points with stabilizer \(D_{12}\);
- the exceptional normal directions and the on-\(X\) triangle flags.

The repository has already proved that the symbolic normal module is assembled in the order

\[
\text{plane normal blocks}
\longrightarrow
\text{triple-line equalizers}
\longrightarrow
\text{residual }D_{10}/D_{12}\text{ point quotients}.
\]

It also proves that there is no naïve globally exact four-term Čech complex: finite irrelevant torsion and line-supported symbolic defects intervene. fileciteturn58file0L22-L63

The next object should therefore be a constructible **transition cosheaf** \(\mathscr T_X\) on the incidence complex:

- at a plane: leading maps into \(L_t\);
- at a plane-line flag: the \(D_{12}\) binary transition module;
- at a triple line: the \(A_4\)-equalizer;
- at a multiple point: the \(D_{10}\) or \(D_{12}\) residual quotient;
- at an exceptional-fiber direction: the corresponding point or line state in \(X^H\);
- restriction maps: actual leading-term specialization, not merely scalar incidence.

A hypothetical landing covariant gives a global section of \(\mathscr T_X\) satisfying the cubic landing equations. Therefore:

\[
H^0(\mathscr T_X^{\mathrm{land}})=0
\quad\Longrightarrow\quad
X\text{ is not }G\text{-unirational}.
\]

Conversely, a nonzero section is a formal positive leading configuration and should be passed to an obstruction-to-lifting calculation.

This formulation is all-degree. It is not invalidated by the quartic precomposition phenomenon, which proves that no uniform degree bound on all KLS solutions can exist. fileciteturn57file0L23-L34

---

# 6. Computational shopping list

## Priority 0: seal the two new theorems

These should be separate, portable certificates. They require only exact finite-group and fixed-scheme calculations.

### A. \(OD_{16}\)

Create an exact \(\mathbf Q(i)\) checker that verifies:

1. the displayed generators preserve
   \[
   w^2=x_1^4+x_2^4+x_3^4;
   \]
2. the generated group has order \(16\) and projective kernel zero on
   \(\langle x_1,x_2,x_3\rangle\);
3. 
   \[
   z=[\iota_3,\tau\sigma\iota_5]
   =\operatorname{diag}(1,-1,-1,1)
   \]
   is central;
4. \(S^z\) is exactly the genus-one curve plus two points;
5. the curve is smooth;
6. \(S^G=\varnothing\);
7. the two points over \([0:0:1]\) are interchanged.

Suggested stack: Sage or Magma for matrices and weighted fixed schemes; Singular for a redundant primary-decomposition check.

### B. \(C_9\rtimes C_3\)

Create an exact \(\mathbf Q(\omega)\) checker that verifies:

1. the three displayed matrices preserve the Fermat cubic;
2. the group has order \(27\);
3. the restriction to \(R=\langle x_3,x_4,x_5\rangle\) is faithful;
4. \(z=c^3=\operatorname{diag}(1,1,\omega,\omega,\omega)\) is central;
5. \(U=R\oplus\mathbf1\) is projectively faithful;
6. \(X^z\) is exactly a smooth Fermat plane cubic plus three reduced points;
7. \(X^G=\varnothing\).

These checks are tiny. The proof note should contain the generic-torsor lemma and the fixed-hyperplane theorem, rather than treating the calculation itself as the proof.

## Priority 1: build the universal fixed-stratum scanner

Input:

- a finite matrix group \(G\);
- equations for a proper \(G\)-variety \(Y\);
- irreducible representations and characters of \(G\) and selected subgroups.

For each subgroup \(H\):

1. enumerate projective eigenspaces in candidate faithful source representations;
2. find \(N_G(H)\)-stable divisorial eigenspaces;
3. compute \(Y^H\), its components, dimensions, genera, and residual normalizer actions;
4. determine whether every rational image of the source divisor is constant;
5. test for normalizer-fixed points.

This should automatically rediscover:

- the \(OD_{16}\) obstruction;
- the Fermat \(C_9\rtimes C_3\) obstruction;
- the known \(Q_8\) negative cases;
- the failure of the test for the Klein \(D_{12}\), because \(X^t\) contains a rational line.

Use GAP or Magma for subgroup and character enumeration, and Sage/Singular/Macaulay2 for fixed schemes.

## Priority 2: the Klein incidence and flag packet

Using the exact matrices already in Problem E:

1. enumerate and serialize:
   - 55 involutions;
   - 55 \(V_4\)'s;
   - 55 plus-planes;
   - 55 triple lines;
   - the 66 \(D_{10}\) and 55 \(D_{12}\) points;
   - all plane–line–point and exceptional-direction flags;
2. record stabilizers and normal representations at every orbit type;
3. compute the exact target fixed-locus component attached to every stabilizer;
4. build the finite incidence category before introducing polynomial degrees.

The crucial output is not another point list. It is a canonical orbit-by-orbit data structure for the transition cosheaf.

GAP/Magma should own the group combinatorics. Sage or OSCAR should own the incidence algebra.

## Priority 3: universal \(D_{12}\) line transitions

Replace degree-by-degree binary calculations by a universal invariant-theoretic presentation.

For a representative fixed line \(L_t\simeq\mathbf P^1\):

1. present the complete module of \(D_{12}\)-equivariant and determinant-twisted binary covariants over the invariant ring;
2. retain the six marked points given by the reflection discriminant;
3. compute symbolically:
   - endpoint values;
   - zero patterns;
   - preserving versus swapping behavior;
   - orders of vanishing;
4. express restriction to all incident flags as a finite module map.

This should decide all degrees simultaneously because the binary covariant module is finitely generated over the dihedral invariant ring.

Do not launch another finite degree ladder here.

## Priority 4: local jet automata

At each orbit type \(S\), compute the bigraded leading-term module

\[
\bigoplus_{m,d}
\operatorname{Hom}_{G_S}
\left(
\operatorname{Sym}^m N_{S/\mathbf P(W)},
W
\right)
\otimes H^0(S,\mathcal O_S(d)).
\]

For each possible first nonzero jet:

1. determine the target fixed-locus component;
2. impose the initial cubic landing equation;
3. determine its restrictions to lower strata;
4. encode the result as a transition between finitely many character states.

The key yes/no question is:

\[
\text{Does the resulting all-order state automaton have a nonzero terminal cycle?}
\]

- No cycle gives an all-degree obstruction.
- A cycle gives a formal leading configuration that must be lifted.

Because the stabilizer characters are finite, degree and jet order should enter through finitely many congruence classes plus multiplication by invariant generators.

## Priority 5: transition cosheaf cohomology

Assemble the plane, line, point, and flag modules into a constructible complex. Compute:

\[
H^0(\mathscr T_X^{\mathrm{land}})
\]

and, for surviving formal sections, the first obstruction group

\[
H^1(\mathscr T_X^{\mathrm{land}}).
\]

The existing symbolic-normalization work supplies much of the linear skeleton, but the new complex must include:

- exceptional normal directions;
- rational-line target states;
- nonlinear landing equations;
- the finite irrelevant-torsion correction.

This is the conceptual successor to the existing

\[
I^{(m)}/I^{(m+2)}
\]

work, not a replacement by a false four-term Čech sequence.

## Priority 6: sparse relative border/Fitting computation

Only after the transition calculation has reduced the state space should the existing degree-25 rank-28 border presentation be resumed.

Use:

- commuting multiplication matrices;
- neighbor syzygies;
- sparse Fitting ideals;
- saturation by the exceptional-state denominators;
- one split prime for discovery and a second split prime for validation;
- an integral or \(\mathbf Q(\zeta_{11})\) lift for the final theorem.

The fully specced M5 Max allows structurally justified jobs to use 64–96 GB of unified memory. It does not justify returning to an undelimited 43-variable or 821-row dense Gröbner calculation. Keep the low memory gate for exploratory formulations; raise it only after the transition machine has selected a canonical sparse module.

## Priority 7: parallel foliation route

A dominant map

\[
\mathbf P^4\dashrightarrow X^3
\]

defines a saturated rank-one \(G\)-invariant foliation

\[
\mathcal F\subset T_{\mathbf P^4}
\]

on the regular locus. The fixed-stratum machine gives prescribed behavior of \(\mathcal F\) along the 55-plane wonderful model.

Compute:

1. possible \(G\)-equivariant line subsheaves of \(T_{\mathbf P^4}\);
2. their Chern classes and singular schemes;
3. tangency constraints along the 55 planes and triple lines;
4. whether any can possess three algebraically independent rational first integrals.

This is the geometric version of the degree-free KLS determinant equation. It is also one of the two structural successors already identified in the repository. fileciteturn57file0L23-L34

## Priority 8: run the smaller \(A_5\) pencil first

Before the full Klein incidence calculation, implement the same machinery for the irreducible \(A_5\) pencil:

- only five \(V_4\)'s;
- fifteen involutions;
- a much smaller incidence complex;
- the same \(2+1+1+1\) restriction pattern.

It is the natural regression test for the transition-cosheaf implementation and is itself an open case.

---

# Bottom line

The PSL\((2,7)\) proof should be understood as the surface case of **normalizer fixed-stratum descent**, with an isotropy-transition category controlling what happens after blowups.

That machine already yields two complete negative proofs:

\[
\boxed{OD_{16}\text{ on the Type-II degree-two del Pezzo is not weakly versal}.}
\]

\[
\boxed{C_9\rtimes C_3\text{ on the Fermat cubic threefold is not weakly versal}.}
\]

For the Klein cubic, the local machine has been fully tested and genuinely permits transitions. The next viable attack is the global flag-level transition cosheaf on the 55-plane arrangement, followed—only on its surviving state space—by the relative border/Fitting or foliation calculation.
