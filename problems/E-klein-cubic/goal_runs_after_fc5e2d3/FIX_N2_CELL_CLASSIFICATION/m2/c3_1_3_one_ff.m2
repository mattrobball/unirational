kkbase = ZZ/100057;
omv = 1140_kkbase; kpv = 74361_kkbase; kmv = 63219_kkbase;
R = kkbase[v0,v1,w];
om = omv; kp = kpv; km = kmv;
I = ideal(v0^2*v1,v0*v1^2,v0*v1^2,v0^3 + v1^3,v0^2*v1,v0^2*v1,v0*v1^2);
I = I + ideal(w);
d = dim I;
print("SOLUTION CONE dim = " | toString d | (if d == 0 then "  => ZERO TUPLE ONLY" else "  => NONTRIVIAL"));
J0 = ideal(v0^2*v1,v0*v1^2,v0*v1^2,v0^3 + v1^3,v0^2*v1,v0^2*v1,v0*v1^2);
if d > 0 then (
  print("  plane order 1 (maxexp 2) coef 0 : " | (if (J0 + ideal(1-w*(v0))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 1 (maxexp 2) coef 1 : " | (if (J0 + ideal(1-w*(v1))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 1 (maxexp 2) coef 2 : " | (if (J0 + ideal(1-w*(v1))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 1 (maxexp 2) coef 3 : " | (if (J0 + ideal(1-w*(v0))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 1 (maxexp 2) coef 4 : " | (if (J0 + ideal(1-w*(v0))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
  print("  plane order 1 (maxexp 2) coef 5 : " | (if (J0 + ideal(1-w*(v1))) == ideal(1_R) then "forced zero" else "CAN BE NONZERO"));
);
