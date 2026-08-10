kk = ZZ/199;
R = kk[x0,x1];
I = saturate ideal(80*x0*x0+93*x0*x1+193*x1*x1, 156*x0*x0+82*x0*x1+150*x1*x1, 124*x0*x0+57*x0*x1+175*x1*x1, 11*x0*x0+142*x0*x1+96*x1*x1, 132*x0*x0+149*x0*x1+122*x1*x1, 99*x0*x0+10*x0*x1+148*x1*x1, 92*x0*x0+90*x0*x1+35*x1*x1, 98*x0*x0+129*x0*x1+181*x1*x1, 148*x0*x0+142*x0*x1+23*x1*x1, 100*x0*x0+96*x0*x1+113*x1*x1, 195*x0*x0+110*x0*x1+1*x1*x1, 198*x0*x0+15*x0*x1+41*x1*x1, 59*x0*x0+187*x0*x1+1*x1*x1, 62*x0*x0+62*x0*x1+187*x1*x1, 165*x0*x0+170*x0*x1+184*x1*x1);
if I == ideal(1_R) then print("C6[1]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C6[1]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
