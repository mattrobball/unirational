R = QQ[a,b,om,kp];
I = ideal(
  (-2/1)+(1/1)*a^2,
  (1/1)*b+(-1/1)*a,
  om^2+om+1,
  8*kp^2-13*kp-4
);
stdio << "-- ctrl_m2v_NONEMPTY" << endl << flush;
u = (1_R % I);
stdio << "ONE-IN-I " << (u == 0) << endl << flush;
if u == 0 then ( stdio << "VERDICT UNIT-IDEAL (EMPTY)" << endl ) else ( stdio << "VERDICT NON-UNIT dim=" << dim I << endl );
stdio << "M2-DONE" << endl << flush;
exit 0
