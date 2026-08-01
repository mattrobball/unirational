# Exact Pfaffian--Morita model

The exact degree-12 RUR defines a nonzero decomposable bivector

```text
p(x,t)=sum_i c_i(t) R_i(x) in wedge^2(V6)
```

over `Q(zeta11,t)`, where `t` satisfies the saved monic cubic.  The actual
base field contains `C`, so choosing one root of this constant polynomial does
not extend `K_proj=C(P(W))^G`.

Let `P` be the skew matrix with upper-triangular entries `p_ij`, let `Q(x)` be
the installed universal alternating form, and put

```text
s = sum_(i<j) Q_ij p_ij.
```

The reduction witness `s(1,2,3,4,5)=3 mod 23` proves that `s` is a nonzero
rational function.  On `s != 0`, define

```text
e = -P Q / s.
```

If `p=u wedge v`, then `P Q` acts by `-s` on `span(u,v)` and vanishes on its
symplectic complement.  Hence `e^2=e`, `trace(e)=2`, and
`Q^-1 e^t Q=e`.  Global decomposability is not inferred from samples: the
fifteen degree-24 invariant Pluecker residuals are exactly zero on a
40-point unisolvent set whose invariant evaluation matrix has rank 40.

Set `D=e A_proj e` and `P_M=A_proj e`.  The selected corner circuits are

```text
e, e M_1 e, e M_2 e, e M_3 e,
```

and the selected right-`D` module generators are

```text
e, M_1 e, M_2 e.
```

Their exact determinant circuits reduce to ranks 4 and 12 at the good fibre,
so they are bases over `K_proj`.  Since a reduced-rank-two idempotent in a
degree-six central simple algebra has `dim D=4` and `dim A_proj e=12`, this
also proves exhaustiveness.  The restricted involution is the quaternionic
canonical involution, and left multiplication gives

```text
(A_proj,sigma) = (End_D(P_M), ad_h),
h(xe,ye)=e sigma(x) y e.
```

The packet also fixes a literal symbol.  For two selected corner basis
elements `d_r,d_s`, it sets

```text
i=d_r-star(d_r),
j0=d_s-star(d_s),
j=j0-((i*j0+j0*i)/(2*i^2))*i,
a=i^2, b=j^2.
```

The saved nonzero determinant and nonzero residues of `a,b` prove that
`1,i,j,ij` is a basis and that `D=(a,b)` with `ij=-ji` on the generic open.

For the exact Hilbert--90 frame `V_j in [x,C,D,E,K]`, put

```text
S_j=Q(x)^-1 Q(V_j(x)),
H_j[r,s]=e sigma(g_r) S_j g_s e.
```

The resulting five matrices are Hermitian under the saved corner involution,
span a five-plane, and specialize to the original aligned Pfaffian section.
Their explicit lazy entries and good-fibre coordinate tables are in
`c2_morita.json`.

This completes C2 only.  A C3 point must still provide a nonzero
`q in D^3` satisfying `q^* H_j q=0` for all five matrices.
