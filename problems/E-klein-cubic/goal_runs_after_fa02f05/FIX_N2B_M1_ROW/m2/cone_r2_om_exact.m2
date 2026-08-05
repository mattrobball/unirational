kk = toField(QQ[om,kp]/ideal(om^2+om+1, 8*kp^2-13*kp-4));
R = kk[B0,w, MonomialOrder=>GRevLex];
I = ideal(((1))*B0^3);
print("### r=2 lam=om free=1 eqs=1");
J = I + ideal(w);
d = dim J;
print("CONE-DIM " | toString d | (if d == 0 then "  ZERO-ONLY" else "  NONTRIVIAL"));
if d > 0 then (
  print("CONE-DEGREE " | toString degree J);
  print("PO1 B0 : " | (if (I + ideal(1-w*B0)) == ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));
);
