A = QQ[om,kp];
K = toField(A/ideal(om^2+om+1, 8*kp^2-13*kp-4));
R = K[a,b];
I = ideal(
  ((-2))+((1))*a^2,
  ((1))*b+((-1))*a
);
stdio << "-- ctrl_NONEMPTY-control" << endl << flush;
u = (1_R % I);
stdio << "ONE-IN-I " << (u == 0) << endl << flush;
if u == 0 then ( stdio << "VERDICT UNIT-IDEAL (EMPTY)" << endl ) else ( stdio << "VERDICT NON-UNIT dim=" << dim I << " degree=" << degree I << endl );
stdio << "M2-DONE" << endl << flush;
exit 0
