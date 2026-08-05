kk = ZZ/100057;
om = 1140_kk; kp = 74361_kk;
R = kk[P0,R0,B0,B1,B2,B3,B4,w, MonomialOrder=>GRevLex];
I = ideal(1*B0*B2*B4+1*R0*B4^2+98916*P0*B4^2,1*B1*B2*B4+1*R0*B2^2+1140*P0*B2^2,1*B2^2*B4+1*B0*B3*B4+1*B0*B1*B2+1*R0*B4^2+2*R0*B1*B4+1*R0*B0^2+1*P0*B4^2+97775*P0*B1*B4+1*P0*B0^2,1*B2*B3*B4+1*B1*B3*B4+1*B1^2*B2+1*B0*B2*B3+1*B0^2*B4+1*R0*B4^2+2*R0*B3*B4+2*R0*B2*B3+1*R0*B2^2+2*R0*B0*B1+63219*R0^3+1140*P0*B4^2+97775*P0*B3*B4+2280*P0*B2*B3+98916*P0*B2^2+2*P0*B0*B1+74361*P0^3,1*B2*B4^2+1*B1*B2*B3+1*B0*B1*B4+1*R0*B2^2+1*R0*B1^2+2*R0*B0*B2+1*P0*B2^2+1*P0*B1^2+2280*P0*B0*B2,1*B2*B3*B4+1*B1*B2^2+1*B0*B4^2+1*B0*B1*B3+2*R0*B1*B4+1*R0*B1^2+2*R0*B0*B2+1*R0*B0^2+2*P0*B1*B4+98916*P0*B1^2+2*P0*B0*B2+1140*P0*B0^2,1*B3^2*B4+1*B2^2*B3+1*B1*B4^2+1*B1*B2*B3+1*B1^2*B3+1*B0*B3^2+1*B0*B2*B4+1*B0*B1*B4+1*B0^2*B2+1*B0^2*B1+2*R0*B3*B4+1*R0*B3^2+2*R0*B2*B4+2*R0*B2*B3+2*R0*B1*B4+2*R0*B1*B3+2*R0*B1*B2+2*R0*B0*B4+2*R0*B0*B3+2*R0*B0*B1+1*R0*B0^2+89600*R0^3+2*P0*B3*B4+1140*P0*B3^2+2280*P0*B2*B4+97775*P0*B2*B3+2280*P0*B1*B4+97775*P0*B1*B3+2*P0*B1*B2+97775*P0*B0*B4+2*P0*B0*B3+2280*P0*B0*B1+98916*P0*B0^2+69783*P0^3,1*B3*B4^2+1*B2*B3^2+1*B1*B3^2+1*B1*B2*B4+1*B1^2*B4+1*B0*B3*B4+1*B0*B2^2+1*B0*B1*B2+1*B0*B1^2+1*B0^2*B3+2*R0*B3*B4+1*R0*B3^2+2*R0*B2*B4+2*R0*B2*B3+2*R0*B1*B3+2*R0*B1*B2+1*R0*B1^2+2*R0*B0*B4+2*R0*B0*B3+2*R0*B0*B2+2*R0*B0*B1+89600*R0^3+2280*P0*B3*B4+98916*P0*B3^2+97775*P0*B2*B4+2*P0*B2*B3+2*P0*B1*B3+2280*P0*B1*B2+1140*P0*B1^2+2*P0*B0*B4+2280*P0*B0*B3+97775*P0*B0*B2+97775*P0*B0*B1+7305*P0^3,1*B4^3+1*B3^3+1*B2^3+3*B1*B3*B4+1*B1^3+3*B0*B2*B3+3*B0*B1*B3+1*B0^3+3*R0*B3^2+6*R0*B2*B4+6*R0*B1*B3+6*R0*B1*B2+6*R0*B0*B4+6*R0*B0*B3+79143*R0^3+3*P0*B3^2+6*P0*B2*B4+6840*P0*B1*B3+93211*P0*B1*B2+6840*P0*B0*B4+93211*P0*B0*B3+45938*P0^3);
print("### r=5 lam=om free=7 eqs=9");
J = I + ideal(w);
d = dim J;
print("CONE-DIM " | toString d | (if d == 0 then "  ZERO-ONLY" else "  NONTRIVIAL"));
if d > 0 then (
  print("CONE-DEGREE " | toString degree J);
  print("PO2 P0 : " | (if (I + ideal(1-w*P0)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO2 R0 : " | (if (I + ideal(1-w*R0)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO2 B0 : " | (if (I + ideal(1-w*B0)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO2 B1 : " | (if (I + ideal(1-w*B1)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO1 B2 : " | (if (I + ideal(1-w*B2)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO3 B3 : " | (if (I + ideal(1-w*B3)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
  print("PO1 B4 : " | (if (I + ideal(1-w*B4)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
);
