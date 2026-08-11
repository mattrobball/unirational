-- Eckardt points of the Klein cubic threefold.
-- p in X is Eckardt  <=>  the tangent hyperplane section T_pX cap X is a cone
--                    <=>  3*Phi(p,v,v) = (1/2) v^T Hess F(p) v  is divisible by
--                         the linear form  grad F(p) . v.
R = QQ[x_0..x_4, v_0..v_4, c_0..c_4];
X = {x_0,x_1,x_2,x_3,x_4};
V = {v_0,v_1,v_2,v_3,v_4};
C = {c_0,c_1,c_2,c_3,c_4};
F = sum for i from 0 to 4 list X#i^2 * X#((i+1)%5);
gradF = for i from 0 to 4 list diff(X#i, F);
ell = sum for i from 0 to 4 list gradF#i * V#i;
H = matrix for i from 0 to 4 list for j from 0 to 4 list diff(X#j, diff(X#i,F));
q = (1/2) * ( (matrix{V}) * H * (transpose matrix{V}) )_(0,0);
lam = sum for i from 0 to 4 list C#i * V#i;
D = q - ell*lam;
eqs = flatten entries (coefficients(D, Variables=>V))#1;
I = ideal(eqs) + ideal(F);
J = eliminate(I, C);
S = QQ[x_0..x_4];
phi = map(S, R, {x_0,x_1,x_2,x_3,x_4, 0,0,0,0,0, 0,0,0,0,0});
gensJ = select(flatten entries gens gb J, g -> all(support g, s -> member(s, X)));
E = if #gensJ == 0 then ideal(0_S) else saturate(ideal(phi \ gensJ), ideal(x_0,x_1,x_2,x_3,x_4));
print "Eckardt ideal on the Klein cubic:";
print E;
print("is unit ideal (i.e. NO Eckardt points): " | toString(E == ideal(1_S)));
