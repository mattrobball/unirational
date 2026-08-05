kk = toField(QQ[om,kp]/ideal(om^2+om+1, 8*kp^2-13*kp-4));
R = kk[P0,R0,B0,B1,B2,w, MonomialOrder=>GRevLex];
I = ideal(((1))*R0*B1^2+((1)*om)*P0*B1^2,((1))*B0*B1*B2+((1))*R0*B2^2+((1))*R0*B1^2+((-1)+(-1)*om)*P0*B2^2+((1))*P0*B1^2,((1))*R0*B2^2+((1)*om)*P0*B2^2,((2))*R0*B1*B2+((13/8)+(-1)*kp)*R0^3+((2)*om)*P0*B1*B2+((1)*kp)*P0^3,((1))*B1^2*B2+((1))*B0*B2^2+((1))*B0^2*B1+((2))*R0*B1*B2+((1))*R0*B1^2+((2))*R0*B0*B2+((2))*R0*B0*B1+((1))*R0*B0^2+((39/8)+(-3)*kp)*R0^3+((2))*P0*B1*B2+((-1)+(-1)*om)*P0*B1^2+((-2)+(-2)*om)*P0*B0*B2+((2)*om)*P0*B0*B1+((1))*P0*B0^2+((-3)*kp+(-3)*om*kp)*P0^3,((1))*B1*B2^2+((1))*B0*B1^2+((1))*B0^2*B2+((1))*R0*B2^2+((2))*R0*B1*B2+((2))*R0*B0*B2+((2))*R0*B0*B1+((1))*R0*B0^2+((39/8)+(-3)*kp)*R0^3+((1))*P0*B2^2+((-2)+(-2)*om)*P0*B1*B2+((2)*om)*P0*B0*B2+((2))*P0*B0*B1+((-1)+(-1)*om)*P0*B0^2+((3)*om*kp)*P0^3,((1))*B2^3+((1))*B1^3+((3))*B0*B1*B2+((1))*B0^3+((6))*R0*B0*B2+((6))*R0*B0*B1+((3))*R0*B0^2+((39/4)+(-6)*kp)*R0^3+((6))*P0*B0*B2+((-6)+(-6)*om)*P0*B0*B1+((3)*om)*P0*B0^2+((6)*kp)*P0^3);
print("### r=4 lam=om free=5 eqs=7");
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
