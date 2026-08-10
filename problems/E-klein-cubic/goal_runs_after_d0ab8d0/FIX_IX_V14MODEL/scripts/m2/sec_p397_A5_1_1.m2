kk = ZZ/397;
R = kk[x0];
I = saturate ideal(207*x0*x0, 183*x0*x0, 149*x0*x0, 151*x0*x0, 115*x0*x0, 30*x0*x0, 199*x0*x0, 137*x0*x0, 136*x0*x0, 395*x0*x0, 149*x0*x0, 395*x0*x0, 115*x0*x0, 199*x0*x0, 183*x0*x0);
if I == ideal(1_R) then print("A5[1,1]|EMPTY") else (
  cs = minimalPrimes I;
  s := "A5[1,1]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
