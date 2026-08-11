RS2 = QQ[A0,A1];
IS2 = ideal(A0^3, A0^2*A1, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A1^3, A0^3, A0^2*A1, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A1^3, A0^3, A0^2*A1, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A1^3, A0^3, A0^2*A1, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A1^3, A0^3, A0^2*A1, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A1^3);
JS2 = saturate(IS2, A0*A1);
print("S2 saturation is unit: " | toString(JS2 == ideal(1_RS2)));
RS3 = QQ[A0,A1];
IS3 = ideal(A0^3, A0^2*A1, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A1^3, A0^3, A0^2*A1, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A1^3, A0^3, A0^2*A1, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A1^3, A0^3, A0^2*A1, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A1^3, A0^3, A0^2*A1, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A1^3);
JS3 = saturate(IS3, A0*A1);
print("S3 saturation is unit: " | toString(JS3 == ideal(1_RS3)));
RS4 = QQ[A0,A1];
IS4 = ideal(A0^3, A0^2*A1 + A1^3, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A0^2*A1 + A1^3, A0^3, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A0^2*A1 + A1^3, A0^3, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A0^2*A1 + A1^3, A0^3, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2, A0^2*A1 + A1^3, A0^3, 2*A0^2*A1, 2*A0*A1^2, A0*A1^2);
JS4 = saturate(IS4, A0*A1);
print("S4 saturation is unit: " | toString(JS4 == ideal(1_RS4)));
RS5 = QQ[A0,A1,A2];
IS5 = ideal(A0^3, A0^2*A1 + 2*A0^2*A2, 5*A0^2*A2, 2*A0^2*A1, 2*A0*A1^2 + 2*A0*A1*A2, 2*A0*A1*A2 + 2*A0*A2^2, 2*A0*A1*A2 + A0*A2^2, 2*A0*A1*A2 + 2*A0*A2^2, A0*A1^2, A1^3, A1^2*A2 + A2^3, 2*A1^2*A2, 2*A1*A2^2, A1*A2^2, A1^2*A2 + A2^3, A0^3, A0^2*A1 + 2*A0^2*A2, 2*A0^2*A1, 2*A0*A1^2 + 2*A0*A1*A2, 2*A0*A1*A2 + A0*A2^2, 2*A0*A1*A2 + 2*A0*A2^2, A0*A1^2, A1^3, 2*A1^2*A2, 2*A1*A2^2, A1*A2^2, A1^2*A2 + A2^3, A0^3, A0^2*A1 + 2*A0^2*A2, 2*A0^2*A1, 2*A0*A1^2 + 2*A0*A1*A2, 2*A0*A1*A2 + A0*A2^2, 2*A0*A1*A2 + 2*A0*A2^2, A0*A1^2, A1^3, 2*A1^2*A2, 2*A1*A2^2, A1*A2^2, A1^2*A2 + A2^3, A0^3, A0^2*A1 + 2*A0^2*A2, 2*A0^2*A1, 2*A0*A1^2 + 2*A0*A1*A2, 2*A0*A1*A2 + A0*A2^2, 2*A0*A1*A2 + 2*A0*A2^2, A0*A1^2, A1^3, 2*A1^2*A2, 2*A1*A2^2, A1*A2^2, A1^2*A2 + A2^3, A0^3, A0^2*A1 + 2*A0^2*A2, 2*A0^2*A1, 2*A0*A1^2 + 2*A0*A1*A2, 2*A0*A1*A2 + A0*A2^2, A0*A1^2, A1^3, 2*A1^2*A2, 2*A1*A2^2, A1*A2^2);
JS5 = saturate(IS5, A0*A1*A2);
print("S5 saturation is unit: " | toString(JS5 == ideal(1_RS5)));
exit 0
