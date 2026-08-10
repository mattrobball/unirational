kk = ZZ/397;
R = kk[x0,x1];
I = saturate ideal(378*x0*x0+26*x0*x1+132*x1*x1, 92*x0*x0+218*x0*x1+114*x1*x1, 91*x0*x0+135*x0*x1+142*x1*x1, 196*x0*x0+218*x0*x1+169*x1*x1, 342*x0*x0+360*x0*x1+245*x1*x1, 223*x0*x0+114*x1*x1, 316*x0*x0+183*x0*x1+193*x1*x1, 386*x0*x0+8*x0*x1+215*x1*x1, 125*x0*x0+58*x0*x1+351*x1*x1, 139*x0*x0+238*x0*x1+296*x1*x1, 298*x0*x0+338*x0*x1, 164*x0*x0+361*x0*x1+216*x1*x1, 69*x0*x0+389*x0*x1+367*x1*x1, 141*x0*x0+279*x0*x1+60*x1*x1, 255*x0*x0+71*x0*x1+388*x1*x1);
if I == ideal(1_R) then print("V4[1,396]|EMPTY") else (
  cs = minimalPrimes I;
  s := "V4[1,396]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
