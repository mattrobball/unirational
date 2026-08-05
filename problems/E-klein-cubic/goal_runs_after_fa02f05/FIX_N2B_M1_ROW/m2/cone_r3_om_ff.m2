kk = ZZ/100057;
om = 1140_kk; kp = 74361_kk;
R = kk[R0,B0,B1,w, MonomialOrder=>GRevLex];
I = ideal(1*B0^2*B1+1*R0*B1^2,1*B0*B1^2+1*R0*B0^2,1*B1^3+1*B0^3+6*R0*B0*B1+63219*R0^3);
print("### r=3 lam=om free=3 eqs=3");
J = I + ideal(w);
d = dim J;
print("CONE-DIM " | toString d | (if d == 0 then "  ZERO-ONLY" else "  NONTRIVIAL"));
if d > 0 then (
  print("CONE-DEGREE " | toString degree J);
  print("PO2 R0 : " | (if (I + ideal(1-w*R0)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO1 B0 : " | (if (I + ideal(1-w*B0)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO1 B1 : " | (if (I + ideal(1-w*B1)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
);
