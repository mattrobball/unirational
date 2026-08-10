kk = ZZ/397;
R = kk[x0];
I = saturate ideal(193*x0*x0, 89*x0*x0, 378*x0*x0, 278*x0*x0, 189*x0*x0, 240*x0*x0, 323*x0*x0, 241*x0*x0, 1*x0*x0, 109*x0*x0, 122*x0*x0, 338*x0*x0, 28*x0*x0, 209*x0*x0, 185*x0*x0);
if I == ideal(1_R) then print("C6[363]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C6[363]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
