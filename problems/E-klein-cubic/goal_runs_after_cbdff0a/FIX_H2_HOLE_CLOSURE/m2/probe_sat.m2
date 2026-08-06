A = QQ[om,kp];
K = toField(A/ideal(om^2+om+1, 8*kp^2-13*kp-4));
R = K[a,b,c];
I = ideal(a*b, a*c);
J1 = saturate(I, {a});
stdio << "list-form saturate ok, J1 = " << toString J1 << endl;
J2 = saturate(I, a);
stdio << "elt-form  saturate ok, J2 = " << toString J2 << endl;
I2 = ideal(a, a-b, b);
stdio << "unit test: " << ((1_R % saturate(I2, {a})) == 0) << endl;
exit 0
