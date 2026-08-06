p = 397; kk = ZZ/p
w = null; s33 = null;
for t from 2 to p-1 do (tk = t_kk; if tk^3 == 1 and tk != 1 then (w = tk; break));
for t from 1 to p-1 do (tk = t_kk; if tk^2 == 33_kk then (s33 = tk; break));
kp = (13_kk + 3_kk*s33) / 16_kk; km = (13_kk - 3_kk*s33) / 16_kk;
R = kk[a,b,x,y,z]
F = kp*a^3 + km*b^3 + (a+b)*x^2 + (w*a + w^2*b)*y^2 + (w^2*a + w*b)*z^2 + x*y*z
H = det matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)))
I = saturate(ideal H + ideal jacobian matrix{{H}}, ideal vars R);
Iplus = saturate(I + ideal(y, z), ideal vars R);
<< "deg C cap Pi: " << degree Iplus << endl
F0 = kp*a^3 + km*b^3 + (a+b)*x^2
Kc = x^2 - 4*(a^2 - a*b + b^2)
<< "deg after removing V(F0): " << degree saturate(Iplus, F0) << endl
<< "deg after removing V(Kc): " << degree saturate(Iplus, Kc) << endl
-- also: order of vanishing of H along the line L = {a=b=x=0}
IL = ideal(a, b, x)
<< "H in IL: " << (H % IL == 0) << "   H in IL^2: " << (H % IL^2 == 0) << endl
-- and gradH along L: all five partials mod IL
gH = flatten entries jacobian matrix{{H}};
<< "gradH components in IL: " << apply(gH, g -> g % IL == 0) << endl
