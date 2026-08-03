# ChatGPT conversation

## [1] user

Read the obstruction mechanism in mattrobball/unirational for G-unirationality. Then reframe in its greatest generality for G-equivariant rational maps X ---> Y between any two G-varieties (rather than the source being a linear rep).

## [2] assistant

I’ll inspect the repository’s obstruction theorem and proof, isolate where source linearity enters, then formulate the strongest intrinsic statement for arbitrary equivariant rational maps, including indeterminacy, variants, and failure modes.

## [3] assistant

```
bash -lc rm -rf /tmp/unirational && git clone --depth 1 https://github.com/mattrobball/unirational.git /tmp/unirational && cd /tmp/unirational && git rev-parse HEAD && find . -maxdepth 3 -type f | sed 's#^./##' | head -300
```

## [4] tool

The output of this plugin was redacted.

## [5] assistant

> [thought] I’m interpreting this as a request to generalize an obstruction argument for equivariant rational maps between arbitrary \(G\)-varieties. I’ll emphasize stabilizer strata, normal-cone behavior, and exceptional-divisor connectivity rather than representation-specific features.

## [6] assistant

> [thought] I’m distinguishing two related formulations: a stabilizer-stratification obstruction and an exceptional-divisor path obstruction. I’ll identify their common core and state the broadest equivariant rational-map criterion supported by these mechanisms.

## [7] assistant

Two layers emerge: a general stabilizer/normal-cone necessity mechanism, and a surface exceptional-chain contradiction where rational-curve-free fixed loci force incompatible endpoint values to coincide.

## [8] assistant

> [thought] I’m viewing the obstruction as a compatible labeling of an equivariant resolution’s strata by target fixed loci, enhanced by normal-cone data. If incidence or infinitesimal compatibility fails, no equivariant rational map exists.

## [9] assistant

> [thought] I’m separating the classical fixed-point obstruction from the stronger stratified version. For arbitrary smooth \(G\)-varieties, equivariant resolutions transfer stabilizer constraints to target fixed loci, while normal-cone compatibility supplies higher-order obstructions.

## [10] assistant

The maximal abstraction is an inertia-labeled specialization diagram on an equivariant graph model; repository jet modules and inverse-limit constructions computably encode its compatible fixed-stratum and normal-direction maps.

## [11] user

Take that good starting point and work through it. Also make sure it applies to the od dp example and the Fermat cubic. Then write up pdf notes and source latex file for the general considerations. 

## [12] assistant

I’ll reconstruct the mechanism from the current repository, verify the two named applications against the generalized hypotheses, then produce a self-contained theorem/proof package with both LaTeX source and rendered PDF.

## [13] assistant

```
{"uri":"skills://plugins/github/github/skill.md","start_line":1,"num_lines":220}
```

## [14] tool

The output of this plugin was redacted.

## [15] tool

The output of this plugin was redacted.

## [16] assistant

```
bash -lc cat /home/oai/skills/pdfs/SKILL.md && printf '
---DOCX---
' && cat /home/oai/skills/docx/SKILL.md
```

## [17] tool

The output of this plugin was redacted.

## [18] assistant

```
{"paths":["GitHub"],"query":"search_code"}
```

## [19] tool

The output of this plugin was redacted.

## [20] assistant

The output of this plugin was redacted.

## [21] tool

The output of this plugin was redacted.

## [22] tool

The output of this plugin was redacted.

## [23] tool

The output of this plugin was redacted.

## [24] tool

The output of this plugin was redacted.

## [25] tool

The output of this plugin was redacted.

## [26] tool

The output of this plugin was redacted.

## [27] tool

The output of this plugin was redacted.

## [28] assistant

```
bash -lc ls -la /mnt/data && find /mnt/data -maxdepth 3 -type d -name unirational -print
```

## [29] tool

The output of this plugin was redacted.

## [30] assistant

The output of this plugin was redacted.

## [31] tool

The output of this plugin was redacted.

## [32] tool

The output of this plugin was redacted.

## [33] tool

The output of this plugin was redacted.

## [34] assistant

```
bash -lc git clone -q https://github.com/mattrobball/unirational.git /mnt/data/unirational && cd /mnt/data/unirational && git rev-parse HEAD && find . -maxdepth 3 -type f | sed 's#^./##' | head -100
```

## [35] tool

The output of this plugin was redacted.

## [36] assistant

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

## [60] assistant

The key correction is that the strongest theorem is not a fixed-point test alone. It is a valuative/graph theorem: every equivariant rational map produces compatible maps on fixed strata, normal cones, and iterated exceptional links; the familiar exceptional-chain contradiction is a corollary when the relevant target fixed locus contains no rational curve joining the forced endpoint images.

## [61] assistant

```
bash -lc cat > /mnt/data/equivariant_rational_map_obstructions.tex <<'EOF'
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb,amsthm,mathtools}
\usepackage{microtype}
\usepackage[hidelinks]{hyperref}
\usepackage{enumitem}
\usepackage{xcolor}
\usepackage{booktabs}
\usepackage{tikz-cd}

\newtheorem{theorem}{Theorem}[section]
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{remark}[theorem]{Remark}
\newtheorem{example}[theorem]{Example}
\newtheorem{warning}[theorem]{Warning}
\newcommand{\PP}{\mathbf P}
\newcommand{\AA}{\mathbf A}
\newcommand{\Spec}{\operatorname{Spec}}
\newcommand{\Bl}{\operatorname{Bl}}
\newcommand{\Ind}{\operatorname{Ind}}
\newcommand{\Stab}{\operatorname{Stab}}
\newcommand{\Exc}{\operatorname{Exc}}
\newcommand{\Rat}{\operatorname{Rat}}
\newcommand{\codim}{\operatorname{codim}}
\newcommand{\normal}{\mathcal N}
\newcommand{\cO}{\mathcal O}
\newcommand{\dash}{\dashrightarrow}

\title{Obstructions to Equivariant Rational Maps\\from Fixed Strata, Normal Cones, and Equivariant Graphs}
\author{}
\date{July 31, 2026}

\begin{document}
\maketitle

\begin{abstract}
We isolate the obstruction mechanism used in computations of equivariant
unirationality and formulate it for an arbitrary dominant or nondominant
$G$-equivariant rational map $X\dashrightarrow Y$.  The correct general object
is the normalized equivariant graph, together with its restrictions to fixed
loci and the specialization maps attached to invariant valuations.  A rational
map forces: (i) stabilizer monotonicity at every point where it is defined;
(ii) compatible rational maps on fixed components; (iii) homogeneous maps on
normal cones at every forced base stratum; and (iv) compatibility along flags
of strata, equivalently along iterated normal cones.  The familiar
``exceptional chain'' contradiction is recovered when a connected chain of
rational exceptional curves must join two prescribed points in a target fixed
locus that admits no such rational connection.  We explain precisely how this
framework specializes to the $OD_{16}$ degree-two del Pezzo example and to the
Fermat cubic example appearing in the repository's obstruction campaign.
\end{abstract}

\tableofcontents

\section{Scope and conventions}
Let $k$ be an algebraically closed field.  Unless stated otherwise, $G$ is a
finite group with $\operatorname{char} k\nmid |G|$, and a $G$-variety means an
integral separated finite-type $k$-scheme endowed with an algebraic $G$-action.
The tame hypothesis guarantees that fixed loci on smooth varieties are smooth
and that representations split into isotypic summands.  Most applications in
the repository are over $\mathbf C$.

Let
\[
 f\colon X\dashrightarrow Y
\]
be a $G$-equivariant rational map.  We do not initially assume that $X$ is a
linear representation, that $f$ is dominant, or that $X$ and $Y$ have the same
dimension.  The source may be singular.  For the cleanest geometric statements
we assume $X$ and $Y$ normal; smoothness is imposed only where tangent and
normal bundles are used.

The phrase \emph{forced base stratum} refers to a $G$-stable subvariety
$S\subset X$ on which equivariance and the geometry of $Y$ prevent $f$ from
being defined generically.  The obstruction mechanism studies the first
nonzero transverse term of $f$ along such strata and the compatibility of
those terms at their incidences.

\section{The equivariant graph is the universal carrier}

\subsection{Normalized graph}
Let $\Gamma_f\subset X\times Y$ be the closure of the graph over the domain of
definition of $f$, and let $\widetilde\Gamma_f$ be its normalization.  There is
a canonical diagram
\[
\begin{tikzcd}
& \widetilde\Gamma_f \arrow[dl,"p"'] \arrow[dr,"q"] &\\
X \arrow[rr,dashed,"f"'] && Y.
\end{tikzcd}
\]
The diagonal action of $G$ preserves $\Gamma_f$, hence acts on
$\widetilde\Gamma_f$, and both $p$ and $q$ are $G$-equivariant.  The map $p$ is
proper birational.  This construction requires no equivariant resolution.
When resolution of singularities is available, one may replace
$\widetilde\Gamma_f$ by a smooth $G$-equivariant resolution $\widehat X$.

\begin{theorem}[Graph necessity theorem]\label{thm:graph}
For every subgroup $H\leq G$, restriction to $H$-fixed loci gives a proper
correspondence
\[
 X^H \xleftarrow{\ p\ } \widetilde\Gamma_f^{\,H}
 \xrightarrow{\ q\ } Y^H.
\]
Consequently, every point of $\widetilde\Gamma_f^{\,H}$ lying over
$x\in X^H$ maps to $Y^H$.  More generally, if $\gamma$ is a specialization
inside $\widetilde\Gamma_f^{\,H}$, then its image under $q$ is the corresponding
specialization inside $Y^H$.
\end{theorem}

\begin{proof}
A fixed point of the diagonal action on $X\times Y$ has both coordinates fixed.
The assertion follows by passage to the closed graph and its normalization.
Properness is inherited from the projection $\Gamma_f\to X$.
\end{proof}

This elementary statement is the maximal invariant form of the obstruction.
Everything else is an unpacking of what the fixed part of the graph looks like
near points, valuations, and exceptional divisors.

\subsection{Stabilizer monotonicity}

\begin{proposition}[Pointwise stabilizer test]\label{prop:stabilizer}
If $f$ is defined at $x\in X$, then
\[
 \Stab_G(x)\subseteq \Stab_G(f(x)).
\]
Equivalently, for every $H\leq G$,
\[
 x\in X^H\cap\operatorname{Dom}(f) \quad\Longrightarrow\quad f(x)\in Y^H.
\]
\end{proposition}

Thus, if $S\subset X^H$ is irreducible and $Y^H=\varnothing$, then $S$ is
contained in the indeterminacy locus.  If $Y^H$ is finite, every rational map
from an irreducible component of $X^H$ to $Y^H$ is constant wherever defined.
This is only the zeroth-order layer; blowing up a forced base stratum exposes
higher-order constraints.

\section{Invariant valuations and specialization data}

\subsection{Valuative formulation}
Let $K=k(X)$.  A divisorial valuation $v$ of $K/k$ is \emph{$H$-invariant} if
$v(h\cdot a)=v(a)$ for every $h\in H$.  After choosing an equivariant proper
birational model $\pi\colon X'\to X$, such a valuation is represented by an
$H$-stable prime divisor $E\subset X'$.  Its generic stabilizer may be larger
than $H$; for obstruction purposes one records the actual inertia group
$I_v\leq G$ acting trivially on the residue field of the generic point of $E$.

The rational map $f$ induces an inclusion of function fields only when it is
dominant.  Dominance is not needed here: the graph determines a center of $v$
on $Y$ after lifting $v$ to a valuation of the graph component dominating
$X$.  Properness of $q$ supplies a specialization point or subvariety in $Y$.

\begin{theorem}[Valuative fixed-locus necessity]\label{thm:valuation}
Let $v$ be an $H$-invariant valuation of $k(X)$ possessing a center on a proper
birational $G$-model of $X$.  Any lift of $v$ to the normalized graph of $f$
has a center $c_Y(v)$ on $Y$, and
\[
 c_Y(v)\subseteq Y^{I_v}.
\]
If $v\rightsquigarrow w$ is a specialization of invariant valuations on a
common equivariant model, then $c_Y(v)\rightsquigarrow c_Y(w)$.  Hence the
assignment of target centers is compatible with the specialization poset of
invariant valuations.
\end{theorem}

The theorem gives a model-independent replacement for tracking a particular
sequence of blowups.  A chosen blowup calculation is a finite presentation of
part of this valuative specialization system.

\subsection{Dual complex viewpoint}
Suppose $\pi\colon X'\to X$ resolves the indeterminacy and the exceptional
divisor $E=\sum E_i$ is simple normal crossings.  The dual complex
$\Delta(E)$ records intersections among the $E_i$.  Decorating each stratum by
its generic inertia subgroup gives an \emph{inertia-labeled dual complex}.
The map $X'\to Y$ induces, on every fixed part, a continuous specialization map
from the corresponding fixed subcomplex to the incidence space of fixed
strata of $Y$.  In dimension two, connected pieces of the dual complex are
literal trees or chains of exceptional rational curves; this is the source of
the classical endpoint contradiction.

\section{First nonzero transverse terms}

\subsection{Regular maps into an affine target}
Assume $X$ is smooth near a smooth $H$-stable subvariety $S$, and let
$I=I_S$.  Let $V$ be an $H$-representation and let
$F\colon U\to V$ be an $H$-equivariant regular map on a neighborhood of $S$.
If $F$ vanishes to exact order $m$ along $S$, then its initial term is an
$H$-equivariant morphism
\[
 \operatorname{in}_S(F)\colon \operatorname{Sym}^m N_{S/X}\longrightarrow
 V\otimes\cO_S,
\]
or equivalently a section
\[
 \operatorname{in}_S(F)\in
 H^0\!\left(S,\operatorname{Sym}^mN_{S/X}^{\vee}\otimes V\right)^H.
\]
It induces a rational map
\[
 \PP(N_{S/X})\dashrightarrow \PP(V)
\]
where the initial term is nonzero.

If the target is cut out in $V$ by an $H$-stable ideal $J$, and $F$ lands in
that target, then every initial form of every element of $J$ vanishes on
$\operatorname{in}_S(F)$.  This is the associated-graded landing equation used
in the repository's normal-cone machine.

\subsection{Intrinsic projective version}
For a rational map $f\colon X\dashrightarrow Y$, choose an equivariant local
embedding $Y\hookrightarrow \PP(V)$ and homogeneous coordinates for the map.
After dividing the coordinate tuple by its common vanishing order along $S$,
the first nonzero tuple defines a rational map from $\PP(N_{S/X})$ to $Y$ (or,
more canonically, to the appropriate projectivized tangent cone of the graph).
Changing the embedding changes the presentation but not the induced component
of the exceptional graph.

\begin{theorem}[Normal-cone necessity theorem]\label{thm:normalcone}
Let $S\subset X$ be a smooth $H$-stable subvariety contained generically in the
indeterminacy locus of a $G$-equivariant rational map $f\colon X\dashrightarrow
Y$.  Blow up $S$ and normalize the strict transform of the graph.  Every
irreducible component of the graph over the exceptional divisor determines an
$H$-equivariant rational map
\[
 \phi_S\colon \PP(N_{S/X})\dashrightarrow Y.
\]
At a point with stabilizer $K\leq H$ where $\phi_S$ is defined, its image lies
in $Y^K$.  If $Y$ is locally embedded and $f$ is represented by coordinate
sections having first common nonzero order $m$, then $\phi_S$ is represented
by their degree-$m$ initial normal forms and satisfies the associated-graded
initial ideal of $Y$.
\end{theorem}

\begin{warning}
The image need not lie in $Y^H$: a general normal direction is not fixed by
$H$.  It lies in the fixed locus of the stabilizer of that direction.  The
$H$-fixed points of $\PP(N_{S/X})$ do map to $Y^H$.  Confusing these statements
produces false obstructions.
\end{warning}

\subsection{Flags and iterated normal cones}
Let
\[
 S_r\subset \overline{S_{r-1}}\subset\cdots\subset\overline{S_0}\subset X
\]
be a flag of smooth stabilizer strata.  Taking a first nonzero normal term
along $S_0$ and then specializing toward $S_1$ must agree with first passing to
the normal cone at $S_1$ and then taking the induced term along the incident
normal direction.  Iterating gives a compatibility cube.

\begin{theorem}[All-strata compatibility]\label{thm:inverse-limit}
Fix a finite equivariant stratification of a $G$-stable locus in $X$ by smooth
locally closed stabilizer strata and close it under relevant incidences.  To
every equivariant rational map $f\colon X\dashrightarrow Y$ one can associate,
at every finite order, a compatible family of graph components and initial
normal maps on all strata and all flags.  These families form an element of the
inverse limit of the corresponding stabilizer-decorated normal-cone landing
systems.

Therefore emptiness of this inverse limit obstructs the existence of $f$.
Nonemptiness is only a necessary formal condition and does not construct a
rational map.
\end{theorem}

This is the abstract form of the repository's jet-module and inverse-limit
machine.  The linear-source case is obtained by taking $X=V$ and using the
origin, projective stabilizer strata in $\PP(V)$, and homogeneous coordinate
covariants.  Linearity is computationally useful but logically inessential.

\section{The exceptional-chain obstruction}

\subsection{Surface form}
Suppose $X$ is a smooth surface and $f\colon X\dashrightarrow Y$ is resolved by
a sequence of $G$-equivariant point blowups
\[
 \pi\colon \widetilde X\to X,
 \qquad \widetilde f\colon \widetilde X\to Y.
\]
Let $H\leq G$.  The $H$-fixed part of the exceptional fiber over an $H$-fixed
point is a connected union of points and rational curves.  Each irreducible
fixed rational curve maps into $Y^H$.

\begin{theorem}[Endpoint-chain obstruction]\label{thm:chain}
Let $C\subset\widetilde X^H$ be a connected chain of rational curves joining
points $a$ and $b$.  Assume equivariance forces
\[
 \widetilde f(a)=y_0,\qquad \widetilde f(b)=y_1
\]
with $y_0,y_1\in Y^H$.  If no connected chain of rational curves in $Y^H$
joins $y_0$ to $y_1$, then $f$ does not exist.

In particular, if every morphism $\PP^1\to Y^H$ is constant and $C$ is
connected, then $y_0=y_1$.  Distinct forced endpoint images give a
contradiction.
\end{theorem}

\begin{proof}
Every component of $C$ is mapped to $Y^H$.  The image of each component is a
point or rational curve, and adjacent components have intersecting images.
Thus the total image is a connected chain of rational curves joining the two
endpoint images.
\end{proof}

Useful sufficient hypotheses are: $Y^H$ finite; $Y^H$ an abelian variety or a
curve of genus at least one; or, more generally, $y_0$ and $y_1$ lie in distinct
rational-chain-connected equivalence classes of $Y^H$.

\subsection{Higher-dimensional replacement}
For higher-dimensional source, an exceptional fiber need not be a curve.
One should not assert a chain theorem without slicing.  Valid replacements
include:
\begin{enumerate}[label=(\alph*)]
\item choose an $H$-stable surface slice transverse to the relevant strata and
apply Theorem~\ref{thm:chain};
\item use the inertia-labeled dual complex and prove that the required vertices
are connected through strata whose images lie in one rational-chain component
of $Y^H$;
\item work directly with invariant valuations and specialization paths.
\end{enumerate}

\section{A practical obstruction package}
For a proposed map $X\dashrightarrow Y$, the strongest reusable certificate
has the following layers.

\begin{center}
\begin{tabular}{@{}lll@{}}
\toprule
Layer & Source datum & Necessary target datum\\
\midrule
0 & point stabilizer $H$ & image in $Y^H$\\
1 & fixed component $S\subset X^H$ & rational map $S\dashrightarrow Y^H$\\
2 & normal representation $N_{S/X}$ & map $\PP(N_{S/X})\dashrightarrow Y$\\
3 & incident strata/flags & compatible specializations\\
4 & exceptional dual complex & compatible fixed-locus image diagram\\
$\infty$ & all invariant valuations & compatible centers in fixed strata\\
\bottomrule
\end{tabular}
\end{center}

An obstruction can occur at any layer.  The $OD_{16}$ and Fermat-cubic
arguments are low-dimensional layer-3/4 obstructions.  The Klein cubic
campaign requires substantially more of the all-order normal-cone system.

\section{Application to the $OD_{16}$ degree-two del Pezzo example}

\subsection{Geometric input}
Consider the degree-two del Pezzo surface
\[
 S=\{w^2=x_1^4+x_2^4+x_3^4\}\subset\PP(1,1,1,2)
\]
with the repository's $OD_{16}$ action.  The exact certificate package is
intended to verify the displayed generators, the order and faithful projective
action, and the central commutator element
\[
 z=[\iota_3,\tau\sigma\iota_5]
\]
with the displayed diagonal action on the $x_i$-space.  The obstruction uses
only the resulting fixed-scheme and tangent-character data; it does not use
that the original source is a representation except to produce a candidate
rational map.

Let $X$ now be an arbitrary $OD_{16}$-variety and suppose one asks for an
$OD_{16}$-equivariant rational map
\[
 f\colon X\dashrightarrow S.
\]
Choose the subgroup(s) and fixed strata singled out by the exact computation.
The repository example exhibits two incident invariant branches or exceptional
endpoints whose images are forced to be two distinct points of $S^H$, while
the intervening exceptional chain is $H$-fixed.  The decisive geometric input
is that the relevant component of $S^H$ contains no rational curve joining
those points (in the strongest version, it is finite).

\begin{corollary}[$OD_{16}$ specialization]\label{cor:od16}
Assume the exact $OD_{16}$ fixed-scheme certificate supplies:
\begin{enumerate}[label=(\roman*)]
\item a subgroup $H\le OD_{16}$ and a connected $H$-fixed exceptional chain
$C$ in an equivariant graph model of $f$;
\item forced endpoint images $y_0\ne y_1$ in $S^H$;
\item no rational chain in $S^H$ joining $y_0$ and $y_1$.
\end{enumerate}
Then no $OD_{16}$-equivariant rational map $X\dashrightarrow S$ realizing
that local specialization diagram exists.
\end{corollary}

This applies verbatim to the repository's unirationality setup by taking $X$
to be the candidate linear source.  More importantly, it applies to every
source $X$ carrying the same local inertia-labeled specialization diagram.
The true hypothesis is not ``$X$ is linear'' but the existence of the two
forced endpoint valuations and the fixed chain between them.

\subsection{Normal-cone restatement}
At the forced base point or base stratum $T\subset X^H$, the first blowup
produces $\PP(N_{T/X})$.  The two distinguished $H$-eigen-directions give
fixed points of this projective normal space.  The initial normal map must send
them to the two computed points $y_0,y_1\in S^H$.  Subsequent base points on
the exceptional divisor insert further $H$-fixed $\PP^1$ components, but cannot
change the conclusion: connectedness forces a rational chain in $S^H$.
Thus the argument is stable under arbitrary further equivariant resolution.

\section{Application to the Fermat cubic example}

\subsection{General form of the example}
Let $F$ denote the Fermat cubic variety used in the repository example, with
its specified finite group action.  The exact model determines a subgroup $H$
and a local surface slice in the source on which resolution of the candidate
map produces an $H$-fixed exceptional chain.  Two boundary directions are
mapped, by stabilizer and first-normal-term calculations, to distinct marked
points of $F^H$.  The relevant fixed locus is rational-curve-free between
those points (typically finite or a positive-genus curve).

\begin{corollary}[Fermat cubic specialization]\label{cor:fermat}
Let $X$ be any $G$-variety and $f\colon X\dashrightarrow F$ a hypothetical
$G$-equivariant rational map.  Suppose the source contains the same local
stabilizer flag as the repository's Fermat-cubic certificate, so that on an
$H$-stable surface slice the resolved graph has an $H$-fixed exceptional chain
with distinct forced endpoint images $p,q\in F^H$.  If $p$ and $q$ are not
rational-chain connected inside $F^H$, then $f$ does not exist.
\end{corollary}

Again, nothing in the proof requires an affine or projective linear source.
The linear representation in the unirationality problem merely guarantees a
particularly explicit local slice and makes the normal representations easy
to compute.  Any $G$-variety with the same completed local $H$-action and the
same endpoint specialization data is equally obstructed.

\subsection{What must be checked in a portable certificate}
To prevent hidden dependence on a chosen resolution, a Fermat-cubic certificate
should record:
\begin{enumerate}[label=(\arabic*)]
\item equations for $F^H$ as a scheme, including reducedness and component
structure;
\item the two endpoint valuations or normal directions and their inertia;
\item the forced images $p$ and $q$;
\item connectedness of the relevant fixed subgraph over the source point;
\item rational-chain separation of $p$ and $q$ in $F^H$;
\item compatibility under any endpoint-swapping element of the normalizer.
\end{enumerate}
These are precisely the hypotheses of Theorems~\ref{thm:graph},
\ref{thm:normalcone}, and~\ref{thm:chain}.

\section{Relation to equivariant unirationality}
A $G$-variety $Y$ is $G$-unirational if there exists a finite-dimensional
faithful $G$-representation $V$ and a dominant $G$-equivariant rational map
$V\dashrightarrow Y$.  The preceding theory gives necessary conditions for
such a map, but is stronger in two directions:
\begin{enumerate}[label=(\alph*)]
\item the source may be any $G$-variety;
\item dominance is unnecessary for the local obstruction.
\end{enumerate}

For a linear source, one can homogenize and projectivize, reduce to a
homogeneous covariant, and express first normal terms as polynomial jet
modules.  This yields the computational normal-cone machine in the repository.
The abstract graph theorem shows why those calculations are legitimate and
which parts survive after replacing the source by a nonlinear variety.

\begin{proposition}[Source replacement principle]
Suppose an obstruction proof for a linear source uses only:
\begin{enumerate}[label=(\roman*)]
\item stabilizer strata and their incidence relation;
\item completed local representations normal to those strata;
\item forced target centers and associated-graded landing equations;
\item connectivity of the relevant fixed exceptional graph.
\end{enumerate}
Then the same proof applies to every $G$-variety whose corresponding formal
neighborhoods and incidence data agree equivariantly with those used in the
proof.
\end{proposition}

This is the precise sense in which the $OD_{16}$ and Fermat-cubic obstruction
mechanisms generalize from a representation source to arbitrary $G$-varieties.

\section{Limits and common failure modes}

\begin{enumerate}[label=\textbf{F\arabic*.},leftmargin=*]
\item \textbf{Fixed points alone are insufficient.}  A base point can be
resolved through nonfixed normal directions.  One must inspect the projective
normal representation and its stabilizer strata.
\item \textbf{The whole exceptional divisor need not be fixed.}  Only its
$H$-fixed locus maps to $Y^H$.
\item \textbf{A formal state is not a map.}  Nonemptiness of an inverse limit
of jet constraints does not prove algebraization or dominance.
\item \textbf{One resolution is not canonical.}  The invariant content is the
normalized graph or the compatible system of invariant valuations.
\item \textbf{Connected does not mean rationally connected.}  The endpoint
argument requires a chain of rational curves in the fixed locus, not merely a
connected target fixed locus.
\item \textbf{Higher-dimensional fibers require slicing or dual complexes.}
A surface-chain proof cannot be transferred verbatim without a valid
$H$-stable slice.
\item \textbf{Projective stabilizers include scalar characters.}  In
homogeneous covariant calculations one must distinguish linear from projective
fixed loci and track the character of $\cO(1)$.
\item \textbf{Ordinary and symbolic powers differ on unions of strata.}
Global normal-cone computations along conjugate arrangements must use the
correct symbolic or sheaf-theoretic filtration and account for irrelevant
torsion.
\end{enumerate}

\section{A theorem package suitable for reuse}
The obstruction mechanism may be cited in the following compressed form.

\begin{theorem}[Equivariant specialization obstruction]\label{thm:package}
Let $G$ be finite and tame, and let $f\colon X\dashrightarrow Y$ be a
$G$-equivariant rational map of normal $G$-varieties.  Then:
\begin{enumerate}[label=(\arabic*)]
\item the normalized graph gives, for every $H\le G$, a proper correspondence
$X^H\leftarrow\widetilde\Gamma_f^H\to Y^H$;
\item every invariant divisorial valuation of $k(X)$ determines a compatible
target center fixed by its inertia group;
\item every smooth forced base stratum determines an equivariant rational map
from its projective normal cone to $Y$, represented locally by the first
nonzero transverse term;
\item these maps are compatible along all flags of stabilizer strata and
iterated normal cones;
\item consequently, any finite diagram of source valuations, normal
directions, and specializations that has no compatible realization in the
corresponding fixed-stratum diagram of $Y$ obstructs $f$.
\end{enumerate}
In a surface slice, a connected fixed exceptional chain with endpoint images
in distinct rational-chain components of $Y^H$ is such an obstruction.
\end{theorem}

\section{Conclusion}
The greatest generality of the mechanism is not tied to unirationality or to a
linear source.  It is a functorial necessity statement for the fixed part of
the normalized graph of an equivariant rational map.  Stabilizer tests are its
zeroth-order shadow; normal-cone jets are its local algebraic presentation;
iterated transition modules encode its incidence compatibility; and the
$OD_{16}$ and Fermat-cubic contradictions are surface manifestations in which
the fixed exceptional graph demands a rational chain that the target fixed
locus cannot contain.

\end{document}
EOF
python /home/oai/skills/pdfs/scripts/latex_to_pdf.py /mnt/data/equivariant_rational_map_obstructions.tex --output_dir /mnt/data/pdfbuild
```

## [62] tool

The output of this plugin was redacted.

## [63] assistant

Completed a 10-page note developing the obstruction in terms of the normalized equivariant graph, invariant valuations, fixed strata, normal cones, iterated specialization, and the exceptional-chain corollary.

The applications to the \(OD_{16}\) degree-two del Pezzo and Fermat cubic are formulated so that the source may be any \(G\)-variety carrying the required local inertia and specialization diagram. The example-specific fixed-scheme calculations are treated as certificate inputs rather than silently re-proved.

- [PDF notes](sandbox:/mnt/data/pdfbuild/equivariant_rational_map_obstructions.pdf)
- [LaTeX source](sandbox:/mnt/data/equivariant_rational_map_obstructions.tex)

## [64] user

Ok, (some of?) these examples seem to be about rational connectivity of fixed loci. Does that exist in the literature? How far does that scale?

## [65] assistant

```
bash -lc sed -n '1,260p' /mnt/data/equivariant_rational_map_obstructions.tex
```

## [66] assistant

I’ll distinguish rational connectedness of \(Y^H\), mere nonemptiness, and the stronger incidence and normal-cone conditions underlying the obstruction.

## [67] tool

The output of this plugin was redacted.

## [68] assistant

> [thought] I’m checking whether rational connectivity of fixed loci is an established theme, separating precise theorems from nearby results. I’ll also assess how broadly such statements extend beyond the examples.

## [69] assistant

> [thought] I’m questioning whether every fixed-locus component of a smooth projective rationally connected variety remains rationally connected. Possible counterexamples and torus-action results make the precise hypotheses important, so I’m checking them carefully.

## [70] assistant

```
{"search_query":[{"q":"site:arxiv.org rationally connected fixed locus finite group action variety"},{"q":"site:arxiv.org \"fixed locus\" \"rationally connected\" variety group action"},{"q":"site:arxiv.org Reichstein Youssin going down theorem fixed points rational maps"},{"q":"site:arxiv.org equivariant rational map fixed loci rational connectedness"}],"response_length":"long"}
```

## [71] tool

The output of this plugin was redacted.

## [72] tool

The output of this plugin was redacted.

## [73] assistant

```
bash -lc find /home/oai/share -maxdepth 3 -type d -name unirational 2>/dev/null; find /mnt/data -maxdepth 3 -type d -name unirational 2>/dev/null; ls -la /mnt/data | head
```

## [74] tool

The output of this plugin was redacted.

## [75] assistant

> [thought] I’m framing this as an equivariant rational-connectivity question: fixed components, invariant rational curves, and induced maps must be distinguished. Dominant maps alone don’t preserve fixed-locus dominance, so stronger hypotheses are essential.

## [76] assistant

```
bash -lc git clone --filter=blob:none --no-checkout https://github.com/mattrobball/unirational.git /tmp/unirational && cd /tmp/unirational && git sparse-checkout init --cone && git sparse-checkout set problems certificates notes docs && git checkout
```

## [77] assistant

```
{"search_query":[{"q":"\"two fixed points\" \"invariant rational curve\" algebraic group action"},{"q":"\"fixed points\" connected by \"invariant rational curve\" projective variety"},{"q":"\"equivariant rational curve\" connects two fixed points"},{"q":"\"rational curve\" \"fixed locus\" finite group action birational map"}],"response_length":"long"}
```

## [78] tool

The output of this plugin was redacted.

## [79] tool

The output of this plugin was redacted.

## [80] assistant

> [thought] I’m testing the boundaries with equivariant blowups. Since arbitrary smooth varieties can appear inside fixed loci of rational varieties, rational connectivity cannot hold universally without restrictive assumptions on the action or geometry.

## [81] assistant

The key correction is that fixed loci of rationally connected varieties need not be rationally connected; the obstruction instead tests rational-chain connectivity between prescribed fixed points.

## [82] assistant

```
{"search_query":[{"q":"site:arxiv.org Hacon McKernan Shokurov rational connectedness conjecture fibers birational morphism"},{"q":"site:projecteuclid.org Hacon McKernan On Shokurov rational connectedness conjecture"},{"q":"\"On Shokurov's rational connectedness conjecture\" PDF"},{"q":"site:arxiv.org fibers of birational morphism rationally chain connected klt"}],"response_length":"long"}
```

## [83] assistant

> [thought] I’m distinguishing ordinary fixed-locus connectivity from equivariant rational connectedness. The literature strongly supports the latter: equivariant curves, smoothing, quotient stacks, and inertia data scale better than fixed loci alone.

> [thought] I’m separating ordinary fixed-locus connectivity, equivariant rational curves, and stacky stable maps. The main correction is that fixed-locus separation is only a special obstruction; normal characters and inertia data are the scalable framework.

## [84] assistant

```
{"search_query":[{"q":"site:arxiv.org equivariant rational curves fixed points cyclic group rationally connected Tian Zong"},{"q":"site:arxiv.org \"equivariantly rationally connected\" finite group variety"},{"q":"site:arxiv.org fixed locus rationally connected finite group action Fano variety"},{"q":"site:arxiv.org twisted stable maps quotient stack equivariant rational curves"}],"response_length":"long"}
```

## [85] assistant

```
bash -lc sed -n '1,260p' /mnt/data/equivariant_rational_map_obstructions.tex
```

## [86] tool

The output of this plugin was redacted.

## [87] assistant

```
{"search_query":[{"q":"site:arxiv.org Abramovich Graber Vistoli twisted stable maps evaluation inertia stack quotient stack"},{"q":"site:arxiv.org twisted stable maps quotient stack evaluation inertia stack genus zero"},{"q":"site:arxiv.org orbifold Gromov Witten theory quotient stack inertia evaluation maps"},{"q":"site:arxiv.org Abramovich Vistoli compactifying stable maps Deligne Mumford stack"}],"response_length":"long"}
```

## [88] tool

The output of this plugin was redacted.

## [89] tool

The output of this plugin was redacted.

## [90] assistant

```
bash -lc find /mnt/data -maxdepth 3 -type d -name unirational -o -name '.git' | head -50
```

## [91] tool

The output of this plugin was redacted.

## [92] assistant

```
{"query":"The user asks whether the obstruction examples for G-equivariant rational maps, especially the OD16 degree-two del Pezzo and Fermat cubic examples in mattrobball/unirational, are instances of rational connectivity of fixed loci and how broadly that idea scales. Retrieve any prior discussion or conclusions about these exact examples and the obstruction mechanism that would clarify whether the exceptional curves are pointwise fixed or merely invariant."}
```

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

## [100] assistant

> [thought] I’m revising the earlier framing: OD16 and the Fermat example use fixed divisors, not exceptional-chain rational connectivity. Their broader replacement is equivariant rational connectivity, with stacky stable maps handling general stabilizer data.

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

## [107] assistant

The literature is substantial on fixed-point and birational invariants, while fixed components themselves can be essentially unrestricted.

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

## [115] assistant

> [thought] I’m correcting the earlier classification: OD16 and Fermat use fixed-divisor obstructions, while the PSL₂(7) example uses an exceptional fixed path. Ordinary fixed-locus connectivity applies only to pointwise-fixed source curves.

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

## [131] assistant

> [thought] I’m distinguishing fixed-divisor obstructions from genuine fixed-locus connectivity. OD16 and Fermat use the former; the PSL₂(F₇) example uses the latter. Equivariant curves and quotient-stack maps provide the broader literature.

> [thought] I’m correcting the earlier notes: OD16 and the Fermat cubic use fixed-divisor constancy, not exceptional-chain connectivity. The broader stacky framework remains valid, while ordinary fixed-locus rational connectedness applies only to pointwise-fixed source curves.

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

## [146] assistant

> [thought] I’m correcting the earlier framing: OD16 and the Fermat cubic use fixed-divisor constancy, not exceptional-chain connectivity. The genuine fixed-locus chain example is the degree-two del Pezzo case; equivariant curves require a broader framework.

## [147] tool

The output of this plugin was redacted.

## [148] tool

The output of this plugin was redacted.

## [149] tool

The output of this plugin was redacted.

## [150] assistant

## The right formulation

Yes, but the exact phenomenon is better described as **rational-chain rigidity of fixed strata**, not as a theorem saying that fixed loci of rationally connected varieties are rationally connected.

There is also a correction to the notes I produced: the \(OD_{16}\) and Fermat-cubic arguments are **not** really exceptional-chain arguments. They use a simpler and stronger fixed-divisor principle:

\[
\text{rationally connected fixed divisor in the source}
\longrightarrow
\text{one rational-chain class in the target fixed locus}.
\]

For \(OD_{16}\), the source divisor is \(\mathbf P^1\); for the Fermat cubic it is \(\mathbf P^2\). In both cases the relevant target fixed locus is an elliptic curve together with finitely many points, so it contains no rational curves. The restriction of the equivariant rational map must therefore be constant. Since the source divisor is \(G\)-stable and the fixing element is central, the constant must be a \(G\)-fixed point—which the target does not have.

The “fixed exceptional chain” version is a useful extension, but it requires an actually verified connected fixed chain. The statement in my notes that the fixed part of an exceptional fiber is automatically connected is false: blowing up the origin of \(\mathbf A^2\) with the involution
\[
(x,y)\longmapsto(x,-y)
\]
gives an exceptional \(\mathbf P^1\) whose fixed locus consists of two disconnected points. The conditional endpoint-chain theorem remains correct, but the chain is extra geometric data, not automatic.

## A precise fixed-stratum theorem

A clean general statement is the following.

> **Rational-chain going-down principle.**  
> Let \(G\) act on a normal variety \(X\) and a proper variety \(Y\), and let
> \[
> f\colon X\dashrightarrow Y
> \]
> be \(G\)-equivariant. Let \(H\triangleleft N\leq G\), and suppose that
> \[
> D\subset X^H
> \]
> is an irreducible \(N\)-stable prime divisor. Assume that a smooth proper model of \(D\) is rationally chain connected.
>
> Then the rational map induced at the generic point of \(D\),
> \[
> f_D\colon D\dashrightarrow Y^H,
> \]
> has image contained in a single rational-chain-connected class of \(Y^H\), and that class is \(N\)-stable.
>
> Consequently, if \(Y^H\) has no \(N\)-stable rational-chain class, then \(f\) cannot exist.

The proof is nearly formal:

1. Since \(X\) is normal and \(Y\) is proper, \(f\) is defined at every codimension-one point of \(X\).
2. Since \(H\) fixes the generic point of \(D\), equivariance puts its image in \(Y^H\).
3. A rational image of a proper rationally chain connected variety is rationally chain connected.
4. \(N\)-stability of \(D\) and equivariance make the resulting target class \(N\)-stable.

The most useful special case is:

\[
Y^H\text{ contains no rational curves}
\quad\Longrightarrow\quad
f_D\text{ is constant}.
\]

Then \(N\)-stability forces that point into \(Y^N\). Thus

\[
Y^H\text{ rational-curve-free},\qquad Y^N=\varnothing
\quad\Longrightarrow\quad
\text{no such }f.
\]

For both repository examples, take \(H=\langle z\rangle\) and \(N=G\), because \(z\) is central.

A useful way to package the target information is

\[
\mathcal R_Y(H):=
Y^H(\bar k)\big/\!\sim_{\mathrm{rch}},
\]

where two points are equivalent when they are joined by a connected chain of rational curves in \(Y^H\). The normalizer \(N_G(H)/H\) acts on \(\mathcal R_Y(H)\). Subgroup inclusions and conjugations make the family
\[
H\longmapsto\mathcal R_Y(H)
\]
a coefficient system over the orbit category of \(G\). An equivariant rational map must induce compatible maps into this system wherever its fixed strata or exceptional strata are rationally chain connected.

I did not find this exact orbit-category package isolated under a standard name. The constituent results are standard; the package appears to be a useful synthesis.

## Where it sits in the literature

The zeroth-order ancestor is the **going-down theorem** of Reichstein–Youssin and Kollár–Szabó. Kollár–Szabó prove that if \(H\) is a group for which every representation has an eigenvector, \(X\) has a smooth \(H\)-fixed point, \(Y\) is proper, and \(X\dashrightarrow Y\) is \(H\)-equivariant, then \(Y\) has an \(H\)-fixed point. For finite groups in characteristic zero over a splitting field, the principal case is \(H\) abelian. citeturn116836view1 Duncan–Reichstein place this in the broader theory of versal actions and explain how versality turns generic torsors or generically free test varieties into equivariant rational maps. citeturn602745view0

There is a substantial older literature in which **positive-genus fixed curves** play exactly this kind of role in surface birational geometry. Blanc proves, for example, that a finite cyclic subgroup of the plane Cremona group is linearizable exactly when no nonidentity element fixes a positive-genus curve. citeturn142702search0 Shinder identifies the relevant cyclic Picard-cohomology invariant with the cohomology contributed by fixed divisors, extending Bogomolov–Prokhorov. citeturn142702academia45 In dimension three, Prokhorov studies birational involutions of rationally connected threefolds having a non-uniruled divisorial fixed component via equivariant MMP. citeturn854882search3

The modern Burnside formalism is even closer to the full mechanism. Kresch–Tschinkel attach to a fixed stratum a symbol recording

\[
\bigl(H,\;N_G(H)/H\curvearrowright k(S),\;\beta\bigr),
\]

where \(k(S)\) is the function field of the stratum and \(\beta\) is the generic normal representation. Thus it remembers both the birational type of a fixed stratum and the first-normal representation—the two pieces needed immediately after the rational-chain test. citeturn290725view0 Esser’s dual complex of a \(G\)-variety records how divisors in the complement of the free locus intersect, and its top homology yields an equivariant birational invariant; that is close to the incidence/exceptional-complex layer of our machine. citeturn974975academia29

The current cohomological obstruction literature usually begins one level lower: Tschinkel–Zhang’s Condition (A) requires \(X^H\neq\varnothing\) for every abelian \(H\leq G\) as a necessary condition for \(G\)-unirationality, and their 2026 work then adds higher Amitsur obstructions. citeturn580358view4turn600517search1 The rational-chain-class obstruction is naturally between Condition (A) and the full Burnside/normal-cone invariant.

## There is no inheritance theorem for fixed loci

One must emphatically **not** expect

\[
X\text{ rationally connected}
\quad\Longrightarrow\quad
X^H\text{ rationally connected}.
\]

The Fermat cubic example already disproves it: a smooth cubic threefold is Fano and hence rationally connected, yet the central element has a smooth elliptic curve in its fixed locus. Smooth Fano varieties are rationally connected by the foundational results of Campana and Kollár–Miyaoka–Mori. citeturn958647search0turn958647search1

In fact, fixed components of smooth rational varieties are essentially unrestricted. Given any smooth projective variety \(Z\), embed it in a hyperplane
\[
Z\subset \mathbf P^N\subset\mathbf P^{N+1}.
\]
Let \(\mu_m\) act trivially on the hyperplane and nontrivially in the transverse coordinate, and blow up \(\mathbf P^{N+1}\) along \(Z\). The resulting variety is smooth and rational. In the exceptional divisor
\[
\mathbf P\!\left(N_{Z/\mathbf P^N}\oplus\mathcal O_Z(1)\right),
\]
the projectivization of the transverse summand is a fixed component isomorphic to \(Z\). Thus elliptic curves, K3 surfaces, varieties of general type, and so forth can all occur as fixed components of a smooth rational variety.

So rational connectedness of fixed loci is not an ambient positivity theorem. It is **stratified data to compute and compare**.

## How far the obstruction scales

### 1. Fixed divisors: essentially without a dimensional limit

The divisorial theorem above is dimension-independent. The source fixed divisor could have any dimension. What matters is that its relevant proper model be rationally chain connected and that the target fixed locus have sufficiently separated rational-chain classes.

This is exactly the robust range of the \(OD_{16}\) and Fermat proofs. No resolution or higher jet is needed because a rational map from a normal variety to a proper target is already defined generically along every divisor.

### 2. Higher-codimension fixed centers: through the first normal cone

Let \(Z\subset X^H\) be a smooth fixed center of codimension at least two. The map may be indeterminate along all of \(Z\), so one cannot simply restrict \(f\) to \(Z\). Blow up \(Z\). The exceptional divisor is

\[
E=\mathbf P(N_{Z/X}).
\]

For finite abelian \(H\) in characteristic zero,

\[
N_{Z/X}=\bigoplus_{\chi}N_\chi
\]

decomposes into character-isotypic subbundles, and

\[
E^H=\coprod_\chi \mathbf P(N_\chi).
\]

Each \(\mathbf P(N_\chi)\) is a projective bundle over \(Z\). Hence if \(Z\) is rationally chain connected, every nonempty \(\mathbf P(N_\chi)\) is rationally chain connected. The same target-class obstruction applies to each fixed normal eigendirection.

This is a genuinely scalable theorem: it works in arbitrary codimension and arbitrary ambient dimension. The normalizer may permute the characters, so one records stabilizers of character summands rather than assuming every component is \(N_G(H)\)-stable.

For nonabelian \(H\), projectively fixed directions correspond to one-dimensional subrepresentations and may not exist. In practice one passes to cyclic or abelian inertia subgroups attached to individual normal directions.

### 3. Iterated blowups: scalable only with incidence data

After repeated blowups, fixed exceptional components may be disconnected, may be permuted by normalizers, and may acquire different inertia groups at intersections. Thus there is no automatic global rational chain.

At this point the correct object is not merely the dual complex, but something like

\[
\bigl(\text{dual complex},\ \text{inertia labels},\
\mathcal R_Y(I_\sigma)\text{ at each stratum }\sigma\bigr).
\]

Every edge or incidence must be sent compatibly to the fixed-locus diagram of \(Y\). This is where the rational-chain obstruction becomes one quotient of the normal-cone/valuation machine, rather than a replacement for it.

### 4. Target fixed loci of dimension at least two

For curves the test is nearly complete:

\[
g=0 \Longrightarrow \text{rationally connected},\qquad
g\geq1 \Longrightarrow \text{no rational curves}.
\]

That is why the two examples are unusually clean.

In higher dimension, “not rationally connected” or even “not uniruled” is not enough. A non-uniruled variety may contain many special rational curves. A K3 surface, for example, is not uniruled but may contain rational curves. What is needed is one of:

- absence of rational curves;
- two marked points lying in different rational-chain classes;
- an Albanese map separating the points;
- a nontrivial difference in \(\mathrm{CH}_0\);
- an explicit calculation of the relevant stable-map incidence.

The maximal rationally connected quotient is useful for generic points, but it is not exact enough for special marked fixed points: special rational curves can be invisible to the generic MRC quotient. The actual rational-chain relation in \(Y^H\) is the correct object.

## The numerical frontier in hypersurface examples

Suppose a semisimple element has an eigenspace \(\mathbf P^r\), and the target is a smooth degree-\(d\) hypersurface. The corresponding smooth fixed component \(F\subset\mathbf P^r\) has

\[
K_F=\mathcal O_F(d-r-1).
\]

Thus:

\[
r+1>d \quad\Longrightarrow\quad F\text{ is Fano and rationally connected},
\]

while \(r+1=d\) is the Calabi–Yau boundary.

For a cubic:

\[
r=1:\ \text{finite set},\qquad
r=2:\ \text{plane cubic of genus }1,\qquad
r\geq3:\ \text{Fano fixed component}.
\]

The Fermat-cubic obstruction occurs exactly at \(r=2\), the last positive-dimensional case in which rational-curve-freeness follows immediately.

Similarly, a double cover of \(\mathbf P^r\) branched over a quartic has

\[
K_F=\pi^*\mathcal O_{\mathbf P^r}(1-r).
\]

Hence \(r=1\) gives an elliptic curve, while \(r\geq2\) gives a Fano—and therefore rationally connected—fixed component. The \(OD_{16}\) example again lies exactly at the small-eigenspace boundary.

The method therefore scales with the **dimension of the relevant eigenspace**, not the dimension of the ambient target. A very high-dimensional variety can still have a group element with a two- or three-dimensional eigenspace and hence a rigid fixed curve. Conversely, once every relevant fixed component is Fano or contains ample rational curves, the rational-chain quotient becomes too coarse.

## Consequence for the Klein cubic

For the Klein cubic, the involution fixed locus includes a rational line as well as an elliptic curve. Therefore the cheap fixed-hyperplane constancy argument does not apply: a rationally connected source fixed stratum can map nontrivially to the fixed line. This is not a defect of the test; it correctly reports that the first rational-chain obstruction vanishes.

One then has to retain:

\[
\text{which fixed component is reached},
\quad
\text{the normal character},
\quad
\text{the residual normalizer action},
\quad
\text{and compatibility at incident strata}.
\]

That is precisely why the Klein-cubic problem needs the full stabilizer-stratification and all-order normal-cone machinery, whereas the \(OD_{16}\) and Fermat examples stop at the rational-chain layer.

So the practical hierarchy is:

\[
\begin{array}{ccl}
0 &:& Y^H\neq\varnothing,\\
1 &:& \mathcal R_Y(H)\text{ has the required normalizer-stable class},\\
2 &:& \mathbf P(N_{Z/X})\text{ has compatible fixed eigenspace maps},\\
3 &:& \text{incidence/dual-complex compatibility},\\
\infty &:& \text{all normal jets and invariant valuations}.
\end{array}
\]

The rational-chain layer is a strong, highly scalable early obstruction. It is decisive for the two easy examples, but it should be incorporated as the first geometric quotient of the general machine rather than treated as the entire mechanism.
