-- FIX-T34 / T3 supporting check.
-- The linear automorphism scheme of the Fermat quartic curve:
--     Lin(F) = { A in Mat_3 : F(Ax) = F(x) },   F = x1^4+x2^4+x3^4.
-- Its invertible points form a group mapping onto Aut(P^2,B) with kernel
-- the scalars mu_4, so |Aut(P^2,B)| = deg(Lin(F) cap GL_3)/4.
-- Expected: degree 384 = 4 * 96, hence |Aut(S)| = 2 * 96 = 192.
kk = ZZ/65537;   -- 65537 = 1 mod 4, so i is present
S = kk[a_(1,1)..a_(3,3), x_1..x_3, MonomialOrder=>Lex];
A = matrix for i from 1 to 3 list for j from 1 to 3 list a_(i,j);
X = matrix{{x_1},{x_2},{x_3}};
Y = A*X;
F = (v) -> v_0^4 + v_1^4 + v_2^4;
G = F(flatten entries Y) - F({x_1,x_2,x_3});
-- coefficients with respect to the x variables
cs = flatten entries last coefficients(G, Variables => {x_1,x_2,x_3});
T = kk[a_(1,1)..a_(3,3)];
phi = map(T, S, join(gens T, {0,0,0}));
I = ideal apply(cs, c -> phi c);
d = det matrix for i from 1 to 3 list for j from 1 to 3 list T_(3*(i-1)+(j-1));
J = saturate(I, d);
<< "dim  = " << dim J << endl;
<< "degree = " << degree J << endl;
<< "|Aut(P^2,B)| = degree/4 = " << (degree J)/4 << endl;
<< "|Aut(S)| = 2*|Aut(P^2,B)| = " << (degree J)/2 << endl;
exit 0
