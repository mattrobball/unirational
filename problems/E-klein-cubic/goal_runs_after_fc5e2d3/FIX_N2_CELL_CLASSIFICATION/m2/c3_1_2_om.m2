kkbase = toField(QQ[om,kp]/ideal(om^2+om+1, 8*kp^2-13*kp-4));
kmv = 13/8 - kp; kpv = kp; omv = om;
R = kkbase[v0,w];
om = omv; kp = kpv; km = kmv;
I = ideal(v0^3);
print("PARAM v0 : " | (if (I + ideal(1-w*(v0))) == ideal(1_R) then "forced zero" else "can be nonzero"));
print("MAXEXP 1 COEF 0 : " | (if (I + ideal(1-w*(-om*v0 - v0))) == ideal(1_R) then "forced zero" else "can be nonzero"));
print("MAXEXP 1 COEF 1 : " | (if (I + ideal(1-w*(om*v0))) == ideal(1_R) then "forced zero" else "can be nonzero"));
print("MAXEXP 1 COEF 2 : " | (if (I + ideal(1-w*(v0))) == ideal(1_R) then "forced zero" else "can be nonzero"));
