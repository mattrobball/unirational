# Exact marked-component presentations

## Normalized map atlas

On `h4 != 0`, identify `M_h` with P3.  Write a degree-19 map as four binary
forms

`c_j(s,t)=sum_{k=0}^{19} a_jk s^(19-k)t^k`.

The 55 ordered preimages are normalized by

`alpha_0=[1:0], alpha_1=[0:1], alpha_2=[1:1]`.

Because the target points are distinct, this is the unique PGL2 slice.
Writing `c(alpha_i)=lambda_i p_i(h)` and setting `lambda_0=1` removes the
remaining common map scalar.  The fixed incidence ideal consists of the 220
equations

`c_j(alpha_i)-lambda_i P_i,j(h)=0`, `0<=i<=54`, `0<=j<=3`.

Its dimension ledger is

`80 map coefficients + 52 source-point dimensions + 54 scales + 4 base - 220 equations = -30`.

For fixed `h` the virtual value is -34.  These are virtual values, not
emptiness proofs.

The qualification open in the JSON payload explicitly includes distinct
source points, nonzero scales, basepoint freeness, nondegeneracy, the
closed-immersion Fitting conditions, proper cubic intersection, and
multiplicity one at all marks.

The universal embedded image ideal is the finite saturation/elimination

`I_univ=((<X_j c_k-X_k c_j>:(s,t)^infinity) intersect R[X0..X3])`.

Thus the payload supplies a universal ideal without assuming a Betti table
or an unproved monad.

## The two Rao loci

Let `Sub5` be the 96 x 56 matrix of the restriction map

`H0(P3,O(5)) -> H0(P1,O(95))`.

Every entry is fixed by coefficient extraction from the displayed binary
forms.

Because incidence implies `I_C(5) subset I_Z(5)=F3_h*S2+<F5_h>`, the same
kernel is computed by the smaller 96 x 11 matrix consisting of the ten
`F3_h`-quadric columns and the `F5_h` column.  Thus epsilon zero is compressed
rank 11, while epsilon one is compressed rank 10 with nonzero `F5_h` kernel
coordinate.

- Epsilon 0 is the open rank-56 locus.  Its Rao values in degrees 0 through
  5 are `(0,16,29,38,42,40)`.
- Epsilon 1 is `I_56(Sub5)=0` with a 55-minor inverted.  Its Rao values are
  `(0,16,29,38,42,41)`.  Equivalently one adds ten quadric variables and the
  96 coefficients of `F5_h(c)+F3_h(c)Q2(c)=0`, then requires rank 55.

Neither rank locus is proved nonempty.

## Certified tangent, obstruction, and dimension statement

For a nondegenerate smooth rational degree-19 curve in P3, write

`N_C/P3 = O(19+b1) + O(19+b2)`, with `b1,b2>=2` and `b1+b2=36`.

This is the standard P3 normal-bundle splitting range recorded, for example,
in [Coskun--Riedl](https://arxiv.org/abs/1607.06149).  Twisting by the 55
distinct marked points gives

`N_C/P3(-Z)=O(b1-36)+O(b2-36)`.

Both degrees are at most -2, so

`h0(N(-Z))=0` and `h1(N(-Z))=(35-b1)+(35-b2)=34`.

Consequently every geometric point of either qualified fixed-h locus is an
isolated reduced point.  The relative qualified projection to the
four-dimensional hyperplane base is unramified; each relative component has
the dimension of its image, hence at most four, and exactly four if it is
dominant.  The nonzero obstruction space does not itself prove that an
obstruction occurs.

Descent remains binding: a geometric isolated point need not yield an
F-point of the twisted incidence scheme.
