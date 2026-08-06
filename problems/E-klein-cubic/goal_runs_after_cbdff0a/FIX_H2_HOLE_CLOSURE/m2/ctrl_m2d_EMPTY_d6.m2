R = QQ[a,b,om,kp];
I = ideal(
  (1/1)*a,
  (-1/1)+(1/1)*a,
  om^2+om+1,
  8*kp^2-13*kp-4
);
stdio << "-- ctrl_m2d_EMPTY dlim=6" << endl << flush;
G = flatten entries gens gb(I, DegreeLimit => 6);
c = select(G, g -> g != 0 and first degree g == 0);
stdio << "GBSIZE " << #G << " CONSTS " << #c << endl << flush;
if #c > 0 then ( stdio << "VERDICT UNIT-IDEAL (EMPTY)" << endl ) else ( stdio << "VERDICT NOT-DECIDED-AT-THIS-DEGREE" << endl );
stdio << "M2-DONE" << endl << flush;
exit 0
