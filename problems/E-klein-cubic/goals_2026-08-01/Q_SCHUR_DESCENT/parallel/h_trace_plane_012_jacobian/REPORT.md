# The `C_012` Fisher invariants and Jacobian

## Verdict

This packet computes the exact Fisher-normalized invariants of the first
three-Kummer plane cubic `C_012` and hence its Jacobian.  It does **not**
decide whether `C_012` has a rational point and does **not** compute its
torsor class.

Write

\[
 s=U_1,\qquad t_j=T_j=\operatorname{Tr}_{E/K}(R_2R_3^2\alpha^j),
 \qquad \epsilon^4+\epsilon^3+\epsilon^2+\epsilon+1=0.
\]

The source plane packet gives

\[
 F_{012}(X,Y,Z)=
 \operatorname{Tr}_{E/K}\!\left(
 R_2R_3^2(X+Y\alpha+Z\alpha^2)^2
 \sigma(X+Y\alpha+Z\alpha^2)
 \right),
\]

with `T_(m+5)=s*T_m`.  The verifier reconstructs this cubic independently
from its 27 ordered summands.  It has 10 ternary monomials and 18 monomials
after expansion in `X,Y,Z,s,t0,...,t4,epsilon`.

The exact result is

\[
 J_{012}:\qquad y^2=x^3-27c_4x-54c_6,
\]

where the complete canonical expressions for `c4` and `c6` are serialized
in `payload.json`.  A payload term

```text
{"exp":[a0,...,a5],"coeff":[q0,q1,q2,q3]}
```

means

\[
 s^{a_0}t_0^{a_1}\cdots t_4^{a_5}
 (q_0+q_1\epsilon+q_2\epsilon^2+q_3\epsilon^3).
\]

The canonical tables have the following independently replayed sizes and
digests:

| invariant | grouped terms | expanded `Q(epsilon)` terms | SHA-256 |
| --- | ---: | ---: | --- |
| `c4` | 14 | 56 | `f06672c95ae3843d645424600b4a6ae118fd34a4d0942b74ff16acb7606fb9f3` |
| `c6` | 40 | 148 | `c3a56da44cf47a1d26dfbaa52216c664ca705ce94259ecce7078fdcf986e1374` |

After substituting `s=U1` and the five exact trace polynomials `t_j=T_j`,
these give the invariants and Jacobian over
`K=C(U1,U2,U3,U4)`.

## Exact invariant extraction

The only invariant-theory input is Tom Fisher's normalization in
[*Testing Equivalence of Ternary Cubics*](https://www.dpmms.cam.ac.uk/~taf1000/papers/testeqtc.pdf),
Theorem 1.1 and the Hessian-pencil identity immediately following it.  With

\[
 H(F)=-\frac12\det\left(\frac{\partial^2F}
 {\partial X_i\partial X_j}\right),
\]

the identity is

\[
\begin{aligned}
 H(\lambda F+\mu H(F))={}&
 3(c_4\lambda^2\mu+2c_6\lambda\mu^2+c_4^2\mu^3)F\\
 &+(\lambda^3-3c_4\lambda\mu^2-2c_6\mu^3)H(F).
\end{aligned}
\]

Since `[X^3]F_012=t0` is nonzero in the generic coefficient field, taking
the `X^3` coefficient gives

\[
 c_4=\frac{[\lambda^2\mu X^3]H(\lambda F+\mu H)}
 {3[X^3]F}
\]

and

\[
 c_6=\frac{[\lambda\mu^2X^3]H(\lambda F+\mu H)
 +3c_4[X^3]H}{6[X^3]F}.
\]

The verifier computes the two mixed determinants directly, reduces every
coefficient modulo `epsilon^4+epsilon^3+epsilon^2+epsilon+1`, and checks the
serialized tables and digests.  The expanded Hessian itself has 268 terms.

As a normalization guard, it also repeats the extraction for the Hesse
family

\[
 a(X^3+Y^3+Z^3)-3bXYZ
\]

and obtains exactly

\[
 c_4=3^4(8a^3+b^3)b,
 \qquad
 c_6=3^6(8a^6+20a^3b^3-b^6).
\]

The source packet is hash-bound and supplies the already certified generic
geometric smoothness of `C_012`.  Fisher's theorem therefore identifies the
displayed Weierstrass equation as its Jacobian after specialization to the
trace model.

## Exact scope and nonclaims

Proved by this packet:

- exact canonical `c4` and `c6` for `C_012`;
- the Fisher-normalized Jacobian equation for `C_012`;
- the stated Hesse-family normalization and all term counts and hashes.

Imported, not reproved here:

- the compact trace formula and generic geometric smoothness of `C_012`.

Not checked and not claimed:

- the full expanded Hessian-pencil identity after substituting this cubic;
- the class of `C_012` in `H^1(K,J_012)` or `H^1(K,J_012[3])`;
- triviality or nontriviality of that class;
- a `K`-rational point or a pointlessness theorem for `C_012`;
- a point or obstruction for the ambient twisted cubic threefold.

In particular, computing the Jacobian does not trivialize the genus-one
torsor.  The arithmetic point/obstruction gate remains open.
