p = 397; kk = ZZ/p
w = null; s33 = null;
for t from 2 to p-1 do (tk = t_kk; if tk^3 == 1 and tk != 1 then (w = tk; break));
for t from 1 to p-1 do (tk = t_kk; if tk^2 == 33_kk then (s33 = tk; break));
kp = (13_kk + 3_kk*s33) / 16_kk; km = (13_kk - 3_kk*s33) / 16_kk;
R = kk[a,b,x,y,z]
F = kp*a^3 + km*b^3 + (a+b)*x^2 + (w*a + w^2*b)*y^2 + (w^2*a + w*b)*z^2 + x*y*z
H = det matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)))
I = saturate(ideal H + ideal jacobian matrix{{H}}, ideal vars R);
-- rho fixed lines: V_w = span{a-axis, (0,0,1,w,w2)}; V_w2 = span{b-axis, (0,0,1,w2,w)}; V_1 = q1
-- param V_w: (s : 0 : t : w t : w2 t)
S = kk[s,t]
lw  = map(S, R, {s, 0_S, t, w*t, w^2*t});
lw2 = map(S, R, {0_S, s, t, w^2*t, w*t});
Iw  = lw gens I; Iw2 = lw2 gens I;
gw  = gcd flatten entries Iw;  gw2 = gcd flatten entries Iw2;
<< "C cap V_w line: gcd = " << gw << "  (factors: " << factor gw << ")" << endl
<< "C cap V_w2 line: gcd = " << gw2 << "  (factors: " << factor gw2 << ")" << endl
-- q1 on C?
<< "q1 on C: " << all(flatten entries gens I, f -> sub(f, matrix{{0_kk,0,1,1,1}}) == 0) << endl
