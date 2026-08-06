-- order-11 fixed data in standard cyclic coordinates, p = 397 (11 | p-1)
p = 397; kk = ZZ/p
R = kk[x0,x1,x2,x3,x4]
F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0
H = det matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)))
I = saturate(ideal H + ideal jacobian matrix{{H}}, ideal vars R);
-- coordinate points e_i
pts = entries id_(kk^5)
scan(5, i -> (
  pt = matrix{pts#i};
  onC = all(flatten entries gens I, f -> sub(f, matrix{pts#i}) == 0);
  << "e_" << i << " on C: " << onC << endl;
))
-- tangent direction at e_0: jacobian of I at e_0, kernel
J0 = sub(jacobian gens I, matrix{pts#0});
K0 = ker transpose J0;
<< "tangent space dim at e_0: " << rank K0 << endl
<< "tangent vector at e_0: " << transpose gens K0 << endl
-- also at e_1 to confirm the pattern
J1 = sub(jacobian gens I, matrix{pts#1});
<< "tangent vector at e_1: " << transpose gens ker transpose J1 << endl
