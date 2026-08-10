kk = ZZ/199;
R = kk[x0];
I = saturate ideal(72*x0*x0, 63*x0*x0, 52*x0*x0, 35*x0*x0, 169*x0*x0, 153*x0*x0, 71*x0*x0, 69*x0*x0, 139*x0*x0, 88*x0*x0, 43*x0*x0, 42*x0*x0, 166*x0*x0, 171*x0*x0, 108*x0*x0);
if I == ideal(1_R) then print("C6[93]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C6[93]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
