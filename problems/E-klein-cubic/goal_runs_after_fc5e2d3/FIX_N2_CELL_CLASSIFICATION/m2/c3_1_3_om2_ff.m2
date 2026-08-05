kkbase = ZZ/100057;
omv = 1140_kkbase; kpv = 74361_kkbase; kmv = 63219_kkbase;
R = kkbase[v0,v1,v2,w];
om = omv; kp = kpv; km = kmv;
I = ideal(-om*v0*v2^2 - v0*v2^2 + v1^2*v2,-om*v0*v1^2 - v0*v1^2 + v1*v2^2,-om*v0*v1^2 - v0*v1^2 + v1*v2^2,kp*v0^3 - 6*om*v0*v1*v2 - 6*v0*v1*v2 + v1^3 + v2^3,-om*v0*v2^2 - v0*v2^2 + v1^2*v2,-om*v0*v2^2 - v0*v2^2 + v1^2*v2,-om*v0*v1^2 - v0*v1^2 + v1*v2^2);
I = I + ideal(w);
d = dim I;
print("SOLUTION CONE dim = " | toString d | (if d == 0 then "  => ZERO TUPLE ONLY" else "  => NONTRIVIAL"));
J0 = ideal(-om*v0*v2^2 - v0*v2^2 + v1^2*v2,-om*v0*v1^2 - v0*v1^2 + v1*v2^2,-om*v0*v1^2 - v0*v1^2 + v1*v2^2,kp*v0^3 - 6*om*v0*v1*v2 - 6*v0*v1*v2 + v1^3 + v2^3,-om*v0*v2^2 - v0*v2^2 + v1^2*v2,-om*v0*v2^2 - v0*v2^2 + v1^2*v2,-om*v0*v1^2 - v0*v1^2 + v1*v2^2);
if d > 0 then (
  print("  plane order 1 (maxexp 2) coef 0 : " | (if (J0 + ideal(1-w*(om*v1))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 1 (maxexp 2) coef 1 : " | (if (J0 + ideal(1-w*(om*v2))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 1 (maxexp 2) coef 2 : " | (if (J0 + ideal(1-w*(-om*v2 - v2))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 1 (maxexp 2) coef 3 : " | (if (J0 + ideal(1-w*(-om*v1 - v1))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 1 (maxexp 2) coef 4 : " | (if (J0 + ideal(1-w*(v1))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 1 (maxexp 2) coef 5 : " | (if (J0 + ideal(1-w*(v2))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 2 (maxexp 1) coef 0 : " | (if (J0 + ideal(1-w*(v0))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
);
