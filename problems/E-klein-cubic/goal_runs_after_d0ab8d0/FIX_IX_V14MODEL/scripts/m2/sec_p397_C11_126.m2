kk = ZZ/397;
R = kk[x0];
I = saturate ideal(198*x0*x0);
if I == ideal(1_R) then print("C11[126]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C11[126]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
