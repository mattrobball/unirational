# PC.1 higher-degree and stabilization-bound audit

Date: 2026-08-01  
Field: \(\mathbf F_{89}\)

## Supersession note

This audit correctly rejects the naive degree-eight monomial-resolution
argument and its conditional degree-five ranks.  It was written before the
later exact border-circuit packet
`pc1_border_stability.{json,npz}`.  That packet supplies a different proof of
finite stabilization: a deliberately redundant 25,200-state hull through
degree six is transition-stable and equals the true relation kernel.  What
remains open is the **minimal graded** degree-five/degree-six ledger required
by PC.1, not the existence of any finite presentation.

## Verdict

The coupled degree-four calculation by itself does **not** prove PC.1.  It gives

\[
G_3=690,\qquad N_4=S_1G_3\oplus G_4,\qquad
\dim N_4=25{,}530+4{,}350=29{,}880,
\]

where the minimal degree-four complement consists of 4,140 transition rows
and 210 independent commutator rows.  The later border packet proves finite
stability nonminimally, but does not compute the minimal quotient ranks,
syzygies, normal forms, or transition matrices in degrees five and six.

In particular, the linear resolution of the monomial ideal
\((K)^3\subset \mathbf F_{89}[K_0,\ldots,K_5]\) does **not** furnish a
degree-eight stabilization bound for the deformed monic rules.  Its Betti
counts are a critical-pair schedule, not a resolution of the actual ideal.

## 1. Why the naive degree-eight bound fails

Let

\[
A=S[K_0,\ldots,K_5],\qquad S=\mathbf F_{89}[q_0,\ldots,q_{36}],
\]

and let the 56 sealed rewrite rules be

\[
f_\mu=K^\mu+\operatorname{tail}_\mu(q,K),\qquad |\mu|=3,
\]

with every tail of \(K\)-degree at most two.  For a block order prioritizing
\(K\)-degree, their displayed leading monomials generate \((K)^3\).  The
minimal resolution of this *monomial* ideal has ranks

\[
56\;\big|\;210,336,280,120,21
\]

in total degrees \(3\;\big|\;4,5,6,7,8\).

Schreyer lifting preserves that resolution only if the lifted leading
syzygies reduce to zero at every stage.  Here the first 210 independent
degree-four lifts reduce to the certified nonzero coupled commutator defects.
Consequently:

1. the 56 deformed rules are not a Groebner/border basis;
2. the actual initial ideal/module has new leading terms of \(K\)-degree at
   most two and is strictly larger than \((K)^3\);
3. the old counts \(336,280,120,21\) do not automatically give syzygies of the
   enlarged basis; and
4. new \(q\)-leading S-pairs may occur after degree eight.

Thus neither monicity nor the monomial Betti table is an explicit regularity
bound.  A degree-eight statement would become valid only after an exact
lifted-Schreyer replay adjoins every nonzero remainder, recomputes the leading
module and all new critical pairs, and proves that the resulting basis closes.
No such replay currently exists.

## 2. Exact degree-five ledger

Use the shifted free \(S\)-module

\[
F=S\oplus S(-1)^6\oplus S(-2)^{21}.
\]

Its degree-five part is

\[
F_5=S_5\oplus S_4^6\oplus S_3^{21}
\]

with component dimensions

| component | dimension |
|---|---:|
| \(S_5\) | 749,398 |
| \(S_4^6\) | 548,340 |
| \(S_3^{21}\) | 191,919 |
| **\(F_5\)** | **1,489,657** |

The degree-five piece already generated over \(S\) is

\[
M_5=S_2G_3+S_1G_4.
\]

Its canonical source has

\[
690\binom{38}{2}+4{,}350\cdot37
=485{,}070+160{,}950
=646{,}020
\]

rows.  This is a source count only: its rank and degree-five syzygy space have
not been computed.

The raw transition tests on \(G_4\) number

\[
6\cdot4{,}350=26{,}100.
\]

Modulo \(M_5\), the 24,840 ordered second transitions of the seeds can be
replaced by the 14,490 symmetric paths

\[
\operatorname{Sym}^2(K)\otimes G_3,\qquad 21\cdot690=14{,}490.
\]

Indeed, the antisymmetric difference is \([T_i,T_j](s_a)\), an
\(S_1\)-combination of the degree-four commutator generators and hence already
lies in \(M_5\).  The 210 commutator generators contribute at most

\[
K\otimes C_4,\qquad 6\cdot210=1{,}260
\]

additional paths.  Therefore the controlling quotient test can use at most

\[
14{,}490+1{,}260=15{,}750
\]

canonical rows rather than all 26,100 ordered transitions.  The exact rank of
these 15,750 classes modulo \(M_5\) is unknown.

A dense materialization is forbidden by scale: the \(646{,}020\times
1{,}489{,}657\) matrix for \(M_5\) alone has about 896 GiB even with one byte
per entry (and about 7.0 TiB as binary64).

## 3. Conditional targets -- not results

The degree-five raw Macaulay source has

\[
746\dim R_2=746\binom{44}{2}=705{,}716
\]

rows.  Also

\[
\dim R_5-\dim F_5
=1{,}533{,}939-1{,}489{,}657
=44{,}282,
\]

where

\[
44{,}282=56\dim S_2+126\dim S_1+252
\]

is the degree-five monomial normal-form kernel forced by \(K\)-degree at
least three.

The following numbers are **conditional predictions only**:

- If the 746 cubics have no quadratic syzygies, then
  \(\operatorname{rank}J_5=705{,}716\), and the normal-form image has dimension
  \(705{,}716-44{,}282=661{,}434\).
- If, in addition, \(M_5\) has full source rank 646,020 and the canonical
  transition candidates are replayed to the whole normal-form kernel, then
  the new degree-five rank would be
  \(661{,}434-646{,}020=15{,}414\), leaving 336 dependencies among the 15,750
  canonical paths.

None of the hypotheses in the preceding bullets has been certified.  In
particular, the coincidence of 336 with a monomial Betti number is not a
proof of those dependencies.

The pure-\(q\) projections of the degree-five candidates factor through

\[
\mu_2:S_2\otimes U\longrightarrow S_5,
\qquad U=V_0\oplus W,\quad\dim U=746,
\]

whose source dimension is \(703\cdot746=524{,}438\).  The 19 certified linear
syzygies from degree four have degree-five prolongations, but the full kernel
of \(\mu_2\), its second syzygies, and the coupled residual on the other 27
components are all uncomputed.  Pure-\(q\) rank alone would again be only a
projection, not a coupled module verdict.

## 4. Installed nonminimal finite-state certificate and remaining minimal gate

The later border packet takes the order ideal

\[
B=1+K+\operatorname{Sym}^2(K)
\]

and closes the 690 seeds and a 210-row commutator forest under all canonical
operators \(P_b\), \(b\in B\).  It gives 19,320 seed states in degrees
3--5 and 5,880 commutator states in degrees 4--6.  Exact circuits put all 336
linear border defects in the commutator span and all 1,176 quadratic border
defects in \(S_1C+\sum_iT_i(C)\).  This proves transition stability.  The
commuting-operator/monic-reduction inverse maps then prove that this finite
hull equals the true kernel over \(\mathbf F_{89}\).

Those 25,200 states are intentionally redundant.  For the full PC.1
acceptance ledger, each degree \(d\ge5\) must still be minimized as follows:

1. build the canonical multiplication space
   \(M_d=\sum_{e<d}S_{d-e}G_e\) without duplicating monomial paths;
2. certify \(\operatorname{rank}M_d\) and an exact basis of all graded
   syzygies;
3. apply every \(T_i\) to every minimal generator in \(G_{d-1}\);
4. reduce those images modulo \(M_d\), record the quotient rank and select
   the new minimal generators \(G_d\);
5. store replayable normal-form coefficients, pivot/unit-minor data, hashes,
   and the induced transition matrices; and
6. independently replay the reductions from the sealed 56 rules, 690 seeds,
   and all 315 raw commutators (or their proved 210-row spanning basis).

For a minimal staged computation, termination at a degree \(D\) is justified only after every
\(T_i(g)\), for every stored minimal generator \(g\) through degree \(D\),
reduces exactly to the \(S\)-module already generated.  Equivalently, after
constructing \(G_D\), the verifier must check the entire degree-\(D+1\)
transition frontier and obtain zero.  S-linearity then proves all higher
\(q\)-multiples close.  Several unchanged Hilbert ranks do not substitute for
this check.

The border-circuit proof supplies this stopping argument for the redundant
state family, so a second stabilization proof is unnecessary.  A streamed
sparse/signature computation or dynamic lifted-Schreyer calculation is still
needed only to extract the missing minimal ranks, syzygies, normal forms, and
transition matrices.  The old \((K)^3\) resolution may schedule its initial
critical pairs, but it cannot certify those minimal data.

## 5. Representation ledger boundary

No nontrivial action of \(\mathrm{PSL}(2,11)\) on the 37 \(q\)-coordinates,
the six \(K\)-coordinates, or the RREF generator labels is sealed.  These are
multiplicity/frame coordinates of already equivariant covariants.  PC.1 must
therefore record that no nontrivial character decomposition is installed
(the canonical multiplicity action is trivial), rather than inventing
representation blocks.  Any nontrivial block decomposition first requires a
separately verified action commuting with the sealed equations and transition
operators.
