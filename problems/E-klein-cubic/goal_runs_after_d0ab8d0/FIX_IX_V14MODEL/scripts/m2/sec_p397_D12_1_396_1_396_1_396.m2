kk = ZZ/397;
R = kk[x0];
I = saturate ideal(137*x0*x0, 94*x0*x0, 264*x0*x0, 323*x0*x0, 201*x0*x0, 295*x0*x0, 127*x0*x0, 242*x0*x0, 72*x0*x0, 22*x0*x0, 220*x0*x0, 178*x0*x0, 214*x0*x0, 349*x0*x0, 298*x0*x0);
if I == ideal(1_R) then print("D12[1,396,1,396,1,396]|EMPTY") else (
  cs = minimalPrimes I;
  s := "D12[1,396,1,396,1,396]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
