kk = ZZ/199;
R = kk[x0,x1];
I = saturate ideal(94*x0*x0+6*x0*x1+149*x1*x1, 185*x0*x0+113*x0*x1+41*x1*x1, 14*x0*x0+44*x0*x1+62*x1*x1, 198*x0*x0+106*x0*x1+50*x1*x1, 11*x0*x0+27*x0*x1+153*x1*x1, 2*x0*x0+21*x0*x1+44*x1*x1, 158*x0*x0+129*x0*x1+107*x1*x1, 131*x0*x0+37*x0*x1+81*x1*x1, 12*x0*x0+34*x0*x1+167*x1*x1, 186*x0*x0+124*x0*x1+182*x1*x1, 112*x0*x0+95*x0*x1+120*x1*x1, 112*x0*x0+53*x0*x1+191*x1*x1, 110*x0*x0+44*x0*x1+106*x1*x1, 42*x0*x0+93*x0*x1+148*x1*x1, 93*x0*x0+57*x0*x1+149*x1*x1);
if I == ideal(1_R) then print("C6[106]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C6[106]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
