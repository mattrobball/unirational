kk = ZZ/397;
R = kk[x0];
I = saturate ideal(90*x0*x0, 232*x0*x0, 30*x0*x0, 166*x0*x0, 331*x0*x0, 335*x0*x0, 340*x0*x0, 372*x0*x0, 14*x0*x0, 277*x0*x0, 217*x0*x0, 31*x0*x0, 107*x0*x0, 381*x0*x0, 37*x0*x0);
if I == ideal(1_R) then print("D12:1.1.34.34.362.111 EMPTY") else (
  cs = minimalPrimes I;
  print("D12:1.1.34.34.362.111 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("D12:1.1.34.34.362.111   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
