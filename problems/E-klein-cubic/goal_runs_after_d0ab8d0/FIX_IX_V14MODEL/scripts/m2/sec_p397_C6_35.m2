kk = ZZ/397;
R = kk[x0];
I = saturate ideal(159*x0*x0, 379*x0*x0, 271*x0*x0, 44*x0*x0, 270*x0*x0, 244*x0*x0, 226*x0*x0, 221*x0*x0, 214*x0*x0, 379*x0*x0, 336*x0*x0, 253*x0*x0, 335*x0*x0, 251*x0*x0, 362*x0*x0);
if I == ideal(1_R) then print("C6[35]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C6[35]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
