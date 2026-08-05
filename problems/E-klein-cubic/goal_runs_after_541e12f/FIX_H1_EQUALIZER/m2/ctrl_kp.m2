A = QQ[om,kp];
K = toField(A/ideal(om^2+om+1, 8*kp^2-13*kp-4));
R = K[a];
I = ideal(
  ((-1)*kp)+((1))*a,
  ((-5))+((-13))*a+((8))*a^2
);
stdio << "-- ctrl_kp" << endl << flush;
G = gens gb I;
u = (1_R % I);
stdio << "ONE-IN-I " << (u == 0) << endl << flush;
if u == 0 then ( stdio << "VERDICT UNIT-IDEAL (EMPTY)" << endl ) else ( stdio << "VERDICT NON-UNIT dim=" << dim I << " degree=" << degree I << endl; stdio << "GB " << toString G << endl );
stdio << "M2-DONE" << endl << flush;
exit 0
