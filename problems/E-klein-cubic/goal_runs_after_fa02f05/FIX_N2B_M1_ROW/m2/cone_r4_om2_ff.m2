kk = ZZ/100057;
om = 1140_kk; kp = 74361_kk;
R = kk[P0,R0,B0,B1,B2,w, MonomialOrder=>GRevLex];
I = ideal(98916*R0*B1^2+1*P0*B1^2,1*B0*B1*B2+1140*R0*B2^2+1*R0*B1^2+1*P0*B2^2+1*P0*B1^2,98916*R0*B2^2+1*P0*B2^2,97775*R0*B1*B2+63219*R0^3+2*P0*B1*B2+74361*P0^3,1*B1^2*B2+1*B0*B2^2+1*B0^2*B1+2*R0*B1*B2+1140*R0*B1^2+2280*R0*B0*B2+97775*R0*B0*B1+1*R0*B0^2+85860*R0^3+2*P0*B1*B2+1*P0*B1^2+2*P0*B0*B2+2*P0*B0*B1+1*P0*B0^2+22969*P0^3,1*B1*B2^2+1*B0*B1^2+1*B0^2*B2+1*R0*B2^2+2280*R0*B1*B2+97775*R0*B0*B2+2*R0*B0*B1+1140*R0*B0^2+24654*R0^3+1*P0*B2^2+2*P0*B1*B2+2*P0*B0*B2+2*P0*B0*B1+1*P0*B0^2+22969*P0^3,1*B2^3+1*B1^3+3*B0*B1*B2+1*B0^3+6*R0*B0*B2+6840*R0*B0*B1+96634*R0*B0^2+79143*R0^3+6*P0*B0*B2+6*P0*B0*B1+3*P0*B0^2+45938*P0^3);
print("### r=4 lam=om2 free=5 eqs=7");
J = I + ideal(w);
d = dim J;
print("CONE-DIM " | toString d | (if d == 0 then "  ZERO-ONLY" else "  NONTRIVIAL"));
if d > 0 then (
  print("CONE-DEGREE " | toString degree J);
  print("PO2 P0 : " | (if (I + ideal(1-w*P0)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO2 R0 : " | (if (I + ideal(1-w*R0)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO2 B0 : " | (if (I + ideal(1-w*B0)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO1 B1 : " | (if (I + ideal(1-w*B1)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO1 B2 : " | (if (I + ideal(1-w*B2)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
);
